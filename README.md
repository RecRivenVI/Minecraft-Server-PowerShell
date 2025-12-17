# 专用于 Minecraft 模组服务端的启动脚本
## 使用 Powershell 编写
### 因为目前还是我个人使用，所以内置了代理和硬编码Java路径
### 使用前（大概率）需要修改以下部分：
```powershell
#代理
$env:HTTP_PROXY = "http://127.0.0.1:7897"
$env:HTTPS_PROXY = "http://127.0.0.1:7897"

#Java绝对路径
$JavaPath = "C:\Program Files\BellSoft\LibericaJDK-$($Minecraft.JavaVersion)-Full\bin\java.exe"
```

## 使用方法
使用方法见startserver.ps1

非常简易的命令行调用方法，更换参数即可实现加载器（包括版本）修改，MC版本修改以及Java版本修改

已实现根据参数自动检测/下载/安装加载器，支持终端内无缝同意EULA

Forge/NeoForge 端检测 MC 与加载器版本依靠 win_args.txt，启动前会检查是否存在 user_jvm_args.txt

Fabric 端检测 MC 版本依靠解析 server.jar 中的 version.json 内容，检测加载器版本依靠 fabric-loader-xxx.jar，启动前会检查是否存在 fabric-server-launcher.jar 与 server.jar

### 待办（大概会忘）
- [x] Fabric 检测机制有问题，需要完善
- [ ] server.properties 预修改/覆盖修改

## 致谢
### 部分功能灵感来自 ATM9 与 ATM10 的服务端启动脚本 startserver.bat
+ [![All the Mods 9](http://cf.way2muchnoise.eu/715572.svg "ATM9") All The Mods 9 - ATM9](https://www.curseforge.com/minecraft/modpacks/all-the-mods-9)
+ [![All the Mods 10](http://cf.way2muchnoise.eu/925200.svg "ATM10") All The Mods 10 - ATM10](https://www.curseforge.com/minecraft/modpacks/all-the-mods-10)

### Fabric 端解析 server.jar 部分由 Microsfot Copilot 生成