@echo off
chcp 65001 >nul

REM AI使用指南场景数据更新工具 for Windows
REM 功能：将模板文件中的$$json_data$$占位符替换为JSON文件内容

setlocal enabledelayedexpansion

REM 默认文件路径
set "TEMPLATE_FILE=ai_guide_app_template.html"
set "JSON_FILE=ai-guide.json"
set "OUTPUT_FILE=ai_guide_app.html"

REM 解析命令行参数
:parse_args
if "%~1"=="" goto after_args
if "%~1"=="-t" (
    set "TEMPLATE_FILE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="--template" (
    set "TEMPLATE_FILE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="-j" (
    set "JSON_FILE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="--json" (
    set "JSON_FILE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="-o" (
    set "OUTPUT_FILE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="--output" (
    set "OUTPUT_FILE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="-h" (
    goto show_help
)
if "%~1"=="--help" (
    goto show_help
)
echo 错误: 未知参数 %~1
goto show_help

after_args:

REM 检查文件是否存在
if not exist "%TEMPLATE_FILE%" (
    echo 错误: 模板文件 "%TEMPLATE_FILE%" 不存在
    exit /b 1
)
if not exist "%JSON_FILE%" (
    echo 错误: JSON数据文件 "%JSON_FILE%" 不存在
    exit /b 1
)

REM 验证JSON格式
echo 验证JSON格式...
python -m json.tool "%JSON_FILE%" >nul 2>nul
if errorlevel 1 (
    echo 错误: JSON文件 "%JSON_FILE%" 格式无效
    exit /b 1
)
echo JSON格式验证通过

REM 检查模板文件中是否包含占位符
findstr /C:"$$json_data$$" "%TEMPLATE_FILE%" >nul
if errorlevel 1 (
    echo 错误: 模板文件中未找到 "$$json_data$$" 占位符
    exit /b 1
)

REM 读取JSON内容到变量（去除换行，转义双引号）
set "JSON_CONTENT="
for /f "usebackq delims=" %%A in ("%JSON_FILE%") do (
    set "line=%%A"
    set "line=!line:\=\\!"
    set "line=!line:"=\"!"
    set "JSON_CONTENT=!JSON_CONTENT!!line! "
)
REM 去除多余空格
set "JSON_CONTENT=%JSON_CONTENT:  = %"

REM 替换模板中的占位符
REM 逐行读取模板，遇到占位符则替换
(
    for /f "usebackq delims=" %%L in ("%TEMPLATE_FILE%") do (
        set "line=%%L"
        setlocal enabledelayedexpansion
        set "line=!line:$$json_data$$=%JSON_CONTENT%!"
        echo(!line!
        endlocal
    )
) > "%OUTPUT_FILE%"

REM 检查输出文件
if not exist "%OUTPUT_FILE%" (
    echo 错误: 输出文件创建失败
    exit /b 1
)

REM 统计信息
set /a SCENARIOS_COUNT=0
set /a STEPS_COUNT=0
set /a OPTIONS_COUNT=0

for /f "delims=" %%S in ('findstr /C:"\"scene\":" "%OUTPUT_FILE%"') do set /a SCENARIOS_COUNT+=1
for /f "delims=" %%S in ('findstr /C:"\"step\":" "%OUTPUT_FILE%"') do set /a STEPS_COUNT+=1
for /f "delims=" %%S in ('findstr /C:"\"content\":" "%OUTPUT_FILE%"') do set /a OPTIONS_COUNT+=1

echo.
echo 场景数量: %SCENARIOS_COUNT%
echo 步骤数量: %STEPS_COUNT%
echo 选项数量: %OPTIONS_COUNT%
echo.
echo 输出文件: %OUTPUT_FILE%
echo 可以直接在浏览器中打开 %OUTPUT_FILE% 查看效果
exit /b 0

:show_help
echo.
echo AI使用指南场景数据更新工具 for Windows
echo.
echo 用法: %~nx0 [选项]
echo.
echo 选项:
echo   -t, --template FILE    模板文件路径 (默认: %TEMPLATE_FILE%)
echo   -j, --json FILE        JSON数据文件路径 (默认: %JSON_FILE%)
echo   -o, --output FILE      输出文件路径 (默认: %OUTPUT_FILE%)
echo   -h, --help             显示此帮助信息
echo.
echo 示例:
echo   %~nx0
echo   %~nx0 -t template.html -j data.json
echo   %~nx0 -o new_app.html
exit /b 0 