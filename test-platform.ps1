# Baro Academy - Automated Platform Integration Test Suite
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Baro Academy - Automated Platform Integration Tests     " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$serverProcess = Start-Process -FilePath "dotnet" -ArgumentList "run --urls http://localhost:5000" -PassThru
Write-Host "Starting ASP.NET Core (.NET 10) Server on http://localhost:5000..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

try {
    # 1. Health & Database check
    $h = Invoke-RestMethod -Uri "http://localhost:5000/api/health" -Method Get
    Write-Host "[✓ PASS] Health Check: $($h.status) (DB: $($h.database))" -ForegroundColor Green

    # 2. Student Authentication
    $loginBody = @{ email = "student@somskills.com"; password = "Student123!" } | ConvertTo-Json
    $studentAuth = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json"
    Write-Host "[✓ PASS] Student Login: $($studentAuth.fullName) ($($studentAuth.role)) Token Received" -ForegroundColor Green

    # 3. Student Authorization & Me profile
    $headers = @{ Authorization = "Bearer $($studentAuth.token)" }
    $me = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/me" -Method Get -Headers $headers
    Write-Host "[✓ PASS] Token Profile Verified: $($me.fullName) <$($me.email)>" -ForegroundColor Green

    # 4. Enrolled Courses
    $myCourses = Invoke-RestMethod -Uri "http://localhost:5000/api/learning/my-courses" -Method Get -Headers $headers
    Write-Host "[✓ PASS] Student Enrolled Courses: $($myCourses.Count) course(s) found" -ForegroundColor Green

    # 5. Instructor Authentication & Dashboard
    $instBody = @{ email = "cabdiraaxmaan.cumar@somskills.com"; password = "Instructor123!" } | ConvertTo-Json
    $instAuth = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method Post -Body $instBody -ContentType "application/json"
    $instHeaders = @{ Authorization = "Bearer $($instAuth.token)" }
    $instDash = Invoke-RestMethod -Uri "http://localhost:5000/api/dashboards/instructor" -Method Get -Headers $instHeaders
    Write-Host "[✓ PASS] Instructor Dashboard: $($instDash.instructorName) ($($instDash.totalCourses) courses, $($instDash.totalStudents) students)" -ForegroundColor Green

    # 6. Admin Authentication & Dashboard
    $adminBody = @{ email = "admin@somskills.com"; password = "Admin123!" } | ConvertTo-Json
    $adminAuth = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method Post -Body $adminBody -ContentType "application/json"
    $adminHeaders = @{ Authorization = "Bearer $($adminAuth.token)" }
    $adminDash = Invoke-RestMethod -Uri "http://localhost:5000/api/dashboards/admin" -Method Get -Headers $adminHeaders
    Write-Host "[✓ PASS] Admin Dashboard: Total Users: $($adminDash.totalUsers), Total Courses: $($adminDash.totalCourses), Revenue: `$$($adminDash.totalRevenue)" -ForegroundColor Green

    # 7. Frontend UI Delivery
    $page = Invoke-WebRequest -Uri "http://localhost:5000/" -Method Get -UseBasicParsing
    Write-Host "[✓ PASS] Frontend Client HTML: HTTP $($page.StatusCode), $($page.Content.Length) bytes loaded" -ForegroundColor Green

    Write-Host "`nAll 7 platform test suites passed successfully!" -ForegroundColor Cyan
}
catch {
    Write-Host "[FAIL] An error occurred during test execution: $_" -ForegroundColor Red
}
finally {
    Stop-Process -Id $serverProcess.Id -Force -ErrorAction SilentlyContinue
    Write-Host "Server stopped." -ForegroundColor DarkGray
}
