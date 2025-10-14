# WATCH DOCKER BUILD & REDEPLOY - CLEAN & SAFE

$ErrorActionPreference = "Stop"
$env:DOCKER_BUILDKIT = "0"   

$image     = "arithmetics-api"
$container = "arithmetics-api"
$port      = 8000
$interval  = 2  

function Log($m) { Write-Host ("[{0}] {1}" -f (Get-Date -Format HH:mm:ss), $m) }

function Build {
    Log "Building image..."
    $buildCmd = ("docker build -t {0}:latest ." -f $image)
    cmd /c $buildCmd
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }
}

function Run {
    Log "Deploying container..."
    cmd /c ("docker rm -f {0}" -f $container) 2>$null | Out-Null
    $runCmd = ("docker run -d --name {0} -p {1}:{1} {2}:latest" -f $container, $port, $image)
    cmd /c $runCmd
    if ($LASTEXITCODE -ne 0) { throw "Run failed" }
    Log ("Running at http://127.0.0.1:{0}" -f $port)
}

# Initial build & run
Build
Run

# Polling loop (fiable)
Log "Watching for changes... (Ctrl+C to stop)"
$last = Get-Date
while ($true) {
    Start-Sleep -Seconds $interval
    $changed = Get-ChildItem -Recurse -File | Where-Object { $_.LastWriteTime -gt $last }
    if ($changed) {
        $last = Get-Date
        Log "Change detected -> rebuild"
        try {
            Build
            Run
        } catch {
            Log $_.Exception.Message
        }
    }
}
