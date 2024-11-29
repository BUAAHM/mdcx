@echo off
REM 使用PowerShell命令获取格式化的日期和时间
for /f "tokens=*" %%i in ('powershell -Command "Get-Date -Format 'yyyyMMdd'"') do set "time=%%i"
set "FileName=MDCx-%time%.exe"
echo Output File: %FileName%

REM 使用pyi-makespec创建spec文件
%~dp0/venv/Scripts/pyi-makespec.exe -n "%FileName%" -F ^
-i resources\Img\MDCx.ico ^
-w main.py ^
-p ".\src" ^
--add-data "resources;resources" ^
--add-data "libs;." ^
--hidden-import socks ^
--hidden-import urllib3 ^
--hidden-import _cffi_backend ^
--collect-all curl_cffi

REM 删除dist目录
if exist dist rmdir /s /q dist

REM 使用PyInstaller构建项目
%~dp0/venv/Scripts/pyinstaller.exe "%FileName%.spec"

REM 清理build目录和spec文件
if exist build rmdir /s /q build
if exist "%FileName%.spec" del "%FileName%.spec"

echo %FileName% Built Successful!
pause
