# SurfingWin

适用于 Windows 的轻量级 Clash 运行环境，采用“免安装、即开即用”的便携式结构。  

内置 Mihomo/Clash核心、完整的配置目录，以及一组基于 VBS、Task Scheduler 和批处理的自动化脚本，支持一键启动、延迟启动、开机自启注册、计划任务管理与安全关闭。所有逻辑均以最小依赖实现，适合希望快速部署或持续使用 Clash 的 Windows 用户。

- 📁 项目结构
```text
SurfingWin
├── bin
│   ├── clash-amd64.exe       # 核心文件
├── config
│   ├── config.yaml           # 配置文件
├── scripts
│   ├── Surfing.start.ps1     # 备用启动 Clash 服务脚本
│   ├── Surfing.start.bat     # 调用启动 Clash 服务脚本
│   ├── Surfing.start.vbs     # 启动 Clash 并初始化
│   ├── Surfing.delay.vbs     # 开机启动 Clash 并初始化
│   ├── Surfing.startup.xml   # 注册计划任务配置文件
│   ├── Surfing.task.stop.vbs # 删除计划任务
│   ├── Surfing.task.start.vbs# 注册计划任务
│   ├── Surfing.stop.vbs      # 停止 Clash 进程
│   └── Surfing.stop.bat      # 批处理版本的停止 Clash 进程
├── 关闭自启.bat                # 关闭开机自启（删除计划任务）
├── 开机自启.bat                # 设置开机自启（注册计划任务）
├── 启动服务.bat                # 批处理方式启动 Clash 服务
└── 停止服务.bat                # 批处理方式停止 Clash 服务
│
│
└── 脚本依赖: PowerShell / Windows Script Host (WSH) / cmd.exe
```

<details>
<summary>GPL-3.0 License</summary>

```text
Copyright (C) 2025 GitMetaio

This project is licensed under the GNU General Public License version GPL-3.0.
You are free to use, modify, and distribute this project under the terms GPL-3.0.

Dependencies:
The binary file bin/clash-amd64.exe is part of the Mihomo project and is not created or maintained by SurfingWin.
SurfingWin scripts may require this binary file to function properly. must comply separately with the license and usage terms of Mihomo.
The authors of SurfingWin assume no responsibility for the binary file or any consequences arising from its use.

Disclaimer:
SurfingWin scripts are provided "as is", without any warranty of any kind.
The authors are not liable for any direct or indirect damages, including but not limited to system issues, data loss, or network problems resulting from the use of these scripts.
```

</details>

## 使用方法
1. 通过 [发布页](https://github.com/GitMetaio/SurfingWin/releases/tag/Windows) 下载**zip**，并解压至桌面
2. 如果通过从 Windows 客户端浏览器下载，建议在**解压前**右键文件 -> **属性** -> 点击 **解除锁定**（Unblock）解决每次执行所带来的烦人安全提示
3. 在 `bin/clash-amd64.exe` 上右键 -> **属性** -> **兼容性**，勾选“以管理员权限运行此程序”  
   - **tips**：Tun 模式需要管理员权限运行。  
4. 编辑 `config/config.yaml` 填入订阅，使用方法与 [Android](https://github.com/GitMetaio/Surfing) 相同
5. 双击 **启动服务** 或选中该文件右键选择打开运行即可。  
6. 控制台地址: 
   ```text
   http://localhost:9090/ui    
   ```
7. 默认密码: 无，可在 **config.yaml** 中的 `secret` 值设置
8. 最后建议禁用智能多宿主解析，防止DNS请求泄露

## 开机自启动
1. 打开 Windows **任务计划程序**
2. 新建一个任务来开机运行 `scripts/Surfing.delay.vbs`.
3. 按需修改任务名称、**文件路径**、触发器、条件等等。
4. **在“常规”选项卡中，勾选“使用最高权限运行”**。（如果不设置此选项，每次启动会跳出 UAC 窗口）