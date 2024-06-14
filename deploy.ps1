# 定义颜色代码
$RED = "`e[31m"
$GREEN = "`e[32m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$NC = "`e[0m" # 无颜色

# 构建静态文件
Write-Host "${YELLOW} Start Building blog....${NC}`n"
hugo --gc

# 切换到博客根目录
Write-Host "${YELLOW} Change Directory to blog root....${NC}`n"
Set-Location ..

# 上传文件到服务器
Write-Host "${YELLOW} Uploading files to Server....${NC}`n"
& ./rsync.ps1
Write-Host "${GREEN} Uploading Successfully!${NC}`n"

# 返回到 hugo-blog 目录
Write-Host "${YELLOW} Back to hugo-blog directory${NC}`n"
Set-Location -

# 上传到 GitHub
Write-Host "${YELLOW} Start push to github....${NC}`n"
git add .
git commit -m "posts added"
git push -u origin main
Write-Host "${GREEN} push over! ${NC}`n"
