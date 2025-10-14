# GIT WATCH: nouveau commit sur origin/main => pull + build + redeploy

$ErrorActionPreference = "Stop"
$env:DOCKER_BUILDKIT = "0"

$remote    = "origin"
$branch    = "main"
$image     = "arithmetics-api"
$container = "arithmetics-api"
$port      = 8000
$interval  = 30   

function Log($m){ Write-Host ("[{0}] {1}" -f (Get-Date -Format HH:mm:ss), $m) }
function LocalSha  { (git rev-parse HEAD).Trim() }
function RemoteSha { (git ls-remote $remote $branch).Split("`t")[0].Trim() }

function Build {
  Log "docker build…"
  cmd /c ("docker build -t {0}:latest ." -f $image)
  if ($LASTEXITCODE -ne 0) { throw "Build failed" }
}
function Run {
  Log "docker run…"
  cmd /c ("docker rm -f {0}" -f $container) 2>$null | Out-Null
  cmd /c ("docker run -d --name {0} -p {1}:{1} {2}:latest" -f $container, $port, $image) | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Run failed" }
  Log ("Running at http://127.0.0.1:{0}" -f $port)
}

git fetch $remote $branch --quiet
$local = LocalSha
$remoteSha = RemoteSha
Log ("Start git watch on {0}/{1} → local={2} remote={3}" -f $remote,$branch,$local,$remoteSha)

if ($remoteSha -ne $local) {
  Log "Local behind remote at start → pull + build + redeploy"
  git pull $remote $branch --ff-only
  Build; Run
}

while ($true) {
  Start-Sleep -Seconds $interval
  try {
    git fetch $remote $branch --quiet
    $newRemote = RemoteSha
    $curLocal  = LocalSha
    if ($newRemote -ne $curLocal) {
      Log ("New commit detected: {0} -> {1}" -f $curLocal, $newRemote)
      git pull $remote $branch --ff-only
      Build; Run
    }
  } catch {
    Log ("Error: {0}" -f $_.Exception.Message)
  }
}
