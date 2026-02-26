# Convert GDD HTML files to PDF using Chrome Headless
# Run this script with: powershell -ExecutionPolicy Bypass -File convert_to_pdf.ps1

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$gddFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
$pdfFolder = Join-Path $gddFolder "PDF"

# Create PDF folder if not exists
if (-not (Test-Path $pdfFolder)) {
    New-Item -ItemType Directory -Path $pdfFolder | Out-Null
}

# Get all HTML files
$htmlFiles = Get-ChildItem -Path $gddFolder -Filter "*.html"

Write-Host "Converting GDD files to PDF..." -ForegroundColor Cyan
Write-Host "Output folder: $pdfFolder" -ForegroundColor Yellow
Write-Host ""

foreach ($file in $htmlFiles) {
    $pdfName = $file.BaseName + ".pdf"
    $pdfPath = Join-Path $pdfFolder $pdfName
    $htmlPath = $file.FullName

    Write-Host "Converting: $($file.Name) -> $pdfName" -ForegroundColor Green

    # Use Chrome headless to print to PDF
    $args = @(
        "--headless"
        "--disable-gpu"
        "--no-sandbox"
        "--print-to-pdf=$pdfPath"
        "--print-to-pdf-no-header"
        "file:///$htmlPath"
    )

    Start-Process -FilePath $chromePath -ArgumentList $args -Wait -NoNewWindow

    if (Test-Path $pdfPath) {
        Write-Host "  -> Success!" -ForegroundColor Green
    } else {
        Write-Host "  -> Failed!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Conversion complete!" -ForegroundColor Cyan
Write-Host "PDF files are in: $pdfFolder" -ForegroundColor Yellow
