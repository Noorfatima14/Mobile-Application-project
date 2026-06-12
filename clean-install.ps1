Write-Host "----------------------------------------"
Write-Host " Cleaning old node_modules and lock file "
Write-Host "----------------------------------------"

# Remove node_modules if it exists
if (Test-Path "node_modules") {
    Remove-Item -Recurse -Force "node_modules"
    Write-Host "Deleted node_modules folder."
} else {
    Write-Host "No node_modules folder found."
}

# Remove package-lock.json if it exists
if (Test-Path "package-lock.json") {
    Remove-Item -Force "package-lock.json"
    Write-Host "Deleted package-lock.json file."
} else {
    Write-Host "No package-lock.json file found."
}

Write-Host "----------------------------------------"
Write-Host " Installing dependencies with npm install"
Write-Host "----------------------------------------"

npm install

Write-Host "----------------------------------------"
Write-Host " Starting Expo project "
Write-Host "----------------------------------------"

npx expo start -c
