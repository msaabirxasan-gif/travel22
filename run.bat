@echo off
echo ===================================================
echo     SomSkills Academy - Starting Web Application
echo ===================================================
echo.
echo Starting .NET 10 Web Server on http://localhost:5000 and http://localhost:5260 ...
start "" "http://localhost:5000"
dotnet run --urls "http://localhost:5000;http://localhost:5260"
pause
