#代理
$env:HTTP_PROXY = "http://127.0.0.1:7897"
$env:HTTPS_PROXY = "http://127.0.0.1:7897"

#服务器信息
$MinecraftVersion = "1.21.1"
$LoaderType = "NeoForge"
$LoaderVersion = "21.1.216"
$JavaVersion = "21"
$Motd = "测试"

#Java路径
$JavaPath = "C:\Program Files\BellSoft\LibericaJDK-$JavaVersion-Full\bin\java.exe"

#加载器哈希表
$Loaders = @{
    Forge    = @{
        Url         = "https://maven.minecraftforge.net/net/minecraftforge/forge/$MinecraftVersion-$LoaderVersion/forge-$MinecraftVersion-$LoaderVersion-installer.jar"
        Installer   = "forge-$MinecraftVersion-$LoaderVersion-installer.jar"
        WinArgsPath = "libraries/net/minecraftforge/forge/$MinecraftVersion-$LoaderVersion/win_args.txt"
    }
    NeoForge = @{
        Url         = "https://maven.neoforged.net/releases/net/neoforged/neoforge/$LoaderVersion/neoforge-$LoaderVersion-installer.jar"
        Installer   = "neoforge-$LoaderVersion-installer.jar"
        WinArgsPath = "libraries/net/neoforged/neoforge/$LoaderVersion/win_args.txt"
    }
}
$UserJvmArgsPath = Join-Path $PSScriptRoot "user_jvm_args.txt"
$UserJvmArgs = "@$UserJvmArgsPath"

#检查java.exe是否存在
if (-not (Test-Path $JavaPath)) {
    Write-Error "未找到Java$JavaVersion，请检查该路径是否存在java.exe：$JavaPath，即将自动退出"
    exit 0
}

<# $ServerProperties = Join-Path $PSScriptRoot "server.properties"
$MotdLine = "motd=$Motd"

#MOTD
if (Test-Path $ServerProperties) {} #>

#服务器本体
while ($true) {

    #检查加载器名称是否合法
    if (-not $Loaders.ContainsKey($LoaderType)) {
        Write-Error "无法识别的加载器名称：$LoaderType"
        break
    }

    #加载器信息转换
    $Loader = $Loaders[$LoaderType]
    $InstallerPath = Join-Path $PSScriptRoot $Loader.Installer
    $WinArgsPath = Join-Path $PSScriptRoot $Loader.WinArgsPath
    $WinArgs = "@$WinArgsPath"

    #如果不存在win_args.txt就执行加载器安装，如加载器安装程序不存在就下载
    if (-not (Test-Path $WinArgsPath)) {
        if (-not (Test-Path $InstallerPath)) {
            Write-Host "正在下载 $LoaderType 安装程序"
            Invoke-WebRequest -Uri $Loader.Url -OutFile $InstallerPath
        }

        Write-Host "正在安装 $LoaderType 服务端"
        & $JavaPath -jar $InstallerPath -installServer
    }

    #启动服务端前确认是否存在user_jvm_args.txt
    if (Test-Path $UserJvmArgsPath) {
        Write-Host "正在启动服务端"
        Write-Host "$JavaPath $UserJvmArgs $WinArgs "nogui""
        & $JavaPath $UserJvmArgs $WinArgs "nogui"
    }
    else {
        Write-Error "未找到user_jvm_args.txt"
        break
    }

    
    #EULA处理
    $Eula = Join-Path $PSScriptRoot "eula.txt"
    $EulaStatus = $false

    if (-not (Test-Path $Eula -PathType Leaf)) {
        Write-Error "未找到 eula.txt"
        break
    }

    $EulaContent = Get-Content $Eula -Raw

    if ($EulaContent -match "eula=false") {

        Write-Host "您必须同意 Minecraft EULA 才能继续运行服务端"
        Write-Host "请输入 true 并回车以同意，输入其他内容并回车将退出："

        if ([System.Environment]::UserInteractive) {
            $EulaInput = Read-Host
        }
        else {
            Write-Error "当前终端不可交互，即将自动退出"
            break
        }

        if ($EulaInput -eq "true") {
            $EulaContent = $EulaContent -replace "eula=false", "eula=true"
            Set-Content $Eula $EulaContent -Encoding ASCII
            Write-Host "您已同意 Minecraft EULA，即将重启服务端"
            $EulaStatus = $true
        }
        else {
            Write-Error "您未同意 Minecraft EULA，即将退出服务端"
            break
        }
    }

    #同意EULA后服务端自动重启
    if ($EulaStatus) {
        continue
    }

    #服务端退出
    Write-Host "服务端已正常退出"
    break
}

#按键退出
<# if ([System.Environment]::UserInteractive) {
    Write-Host "请按任意键继续"
    [System.Console]::ReadKey($true) | Out-Null
}
else {
    Write-Host "当前终端不可交互，即将自动退出"
    exit 0
} #>

#[面板用]自动退出
exit 0