param(
    [string]$Branch = "main"
)

$gitRoot = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git"
$env:GIT_EXEC_PATH = "$gitRoot\mingw32\bin"
$env:PATH = "$gitRoot\usr\bin;$gitRoot\mingw32\bin;" + $env:PATH
$env:SHELL = "$gitRoot\usr\bin\sh.exe"

git -C "$PSScriptRoot\.." push origin $Branch
