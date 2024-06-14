@echo off
REM 定义颜色代码
set "RED="
set "GREEN="
set "YELLOW="
set "BLUE="
set "NC="

REM 构建静态文件
echo %YELLOW% Start Building blog....%NC%
hugo --gc

REM 切换到博客根目录
echo %YELLOW% Change Directory to blog root....%NC%
cd ..

REM 上传文件到服务器
echo %YELLOW% Uploading files to Server....%NC%
call rsync.bat
echo %GREEN% Uploading Successfully!%NC%

REM 返回到 hugo-blog 目录
echo %YELLOW% Back to hugo-blog directory%NC%
cd -

REM 上传到 GitHub
echo %YELLOW% Start push to github....%NC%
git add .
git commit -m "posts added"
git push -u origin main
echo %GREEN% push over! %NC%
