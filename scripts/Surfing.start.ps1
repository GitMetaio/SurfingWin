Add-Type -AssemblyName System.Windows.Forms

$ScriptDir = $PSScriptRoot
if (-not $ScriptDir) { $ScriptDir = Get-Location }

$BaseDir = Split-Path $ScriptDir -Parent
$ClashPath = Join-Path $BaseDir "bin\clash-amd64.exe"
$ConfigDir = Join-Path $BaseDir "config"

$LogFolder = Join-Path $ConfigDir "log"

if (-not (Test-Path -Path $LogFolder)) { New-Item -ItemType Directory -Path $LogFolder -ErrorAction Stop | Out-Null }
 
$SurfingErrorLog = Join-Path $BaseDir "Surfing_Error.log"
$ErrorLogPath = Join-Path $BaseDir "Clash_Error.log"

$TimeStamp = Get-Date -Format "yyyyMMddHHmm"
$LogFileName = "clash_$TimeStamp.log"
$LogPath = Join-Path $LogFolder $LogFileName

function Write-SurfingError {
    param([string]$msg)
    try {
        $logContent = "$(Get-Date) - $msg"
        Add-Content -Path $SurfingErrorLog -Value $logContent -ErrorAction Stop
    } catch {}
}

if (-not (Test-Path -Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -ErrorAction Stop | Out-Null }

if (-not (Test-Path -Path $ClashPath)) {
    Write-SurfingError "缺失可执行文件: $ClashPath"
    [System.Windows.Forms.MessageBox]::Show("Error: clash-amd64.exe not found in folder:`n$ClashPath", "Surfing Start Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

$proc = Get-Process -Name "clash-amd64" -ErrorAction SilentlyContinue
if ($proc) {
    [System.Windows.Forms.MessageBox]::Show("已经运行了一个实例，无需重复启动！", "提示", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    exit
}

$CmdCommand = [string]::Format('/c ""{0}" -d "{1}" > "{2}" 2>&1"', $ClashPath, $ConfigDir, $LogPath)

try {
    
    $shell = New-Object -ComObject "Shell.Application"
    
    $shell.ShellExecute("cmd.exe", $CmdCommand, $BaseDir, "runas", 0) | Out-Null
    
} catch {
    Write-SurfingError "ShellExecute 启动失败: $_"
    [System.Windows.Forms.MessageBox]::Show("ShellExecute 启动失败: $($_.Exception.Message)", "Error", "OK", "Error")
    exit
}

Start-Sleep -Seconds 3

try {
    $procCheck = Get-Process -Name "clash-amd64" -ErrorAction SilentlyContinue  
    if (-not $procCheck) {   
        if (Test-Path $LogPath) {
            Copy-Item -Path $LogPath -Destination $ErrorLogPath -Force
        } else {
            Write-SurfingError "启动失败且未生成日志文件，请检查系统安全软件和权限。"
        }   
        [System.Windows.Forms.MessageBox]::Show("启动失败!`nPlease Check Error log: $ErrorLogPath", "Surfing Start Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        exit
    } else {
        if (Test-Path $SurfingErrorLog) { Remove-Item $SurfingErrorLog -Force -ErrorAction SilentlyContinue }
        if (Test-Path $ErrorLogPath) { Remove-Item $ErrorLogPath -Force -ErrorAction SilentlyContinue }
        
        Start-Process "http://localhost:9090/ui"
    }
} catch {
    Write-SurfingError "验证过程出错: $_"
}
