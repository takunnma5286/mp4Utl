Set-Location $PSScriptRoot

$compLevel = Read-Host "publish as self contained? [y/n] (default value:n)"
if (($delFile -eq "y") -or ($delFile -eq "Y")) {
    dotnet publish -c Debug -r win-x64 --self-contained
} else {
    dotnet publish -c Debug -r win-x64 --no-self-contained
}

$batch_path=$PSScriptRoot
Write-Output $batch_path

if (Test-Path "$batch_path/build/mp4Utl_Debug.7z" -PathType Leaf) {
    Write-Output Found Duplicated ./build/mp4Utl_Debug.7z
    $delFile = Read-Host "Delete Duplicated 7z? [y/n] (default:n)"
    Write-Output $delFile

    if (($delFile -eq "y") -or ($delFile -eq "Y")) {
        Remove-Item "$batch_path/build/mp4Utl_Debug.7z"
    } else {
        exit
    }
}

$compLevel = Read-Host "compression rate? [1~9] (default value:5)"
if ("$compLevel" -eq "") {
    $compLevel = 5
}
Write-Output $compLevel

7z a -mx"$compLevel" ./build/mp4Utl_Debug.7z "$(Resolve-Path -Path ./build/x64/Debug/*/win-x64/publish)/*" -w