# SomSkills Academy - Launch Script
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "    SomSkills Academy - Starting Web Application" -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Opening web browser at http://localhost:5000 ..." -ForegroundColor Yellow
Start-Process "http://localhost:5000"
Write-Host "Starting ASP.NET Core (.NET 10) Server on ports 5000 & 5260..." -ForegroundColor Magenta
dotnet run --urls "http://localhost:5000;http://localhost:5260"
