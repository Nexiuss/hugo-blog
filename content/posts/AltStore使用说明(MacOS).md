---
title: 'AltStore使用说明(MacOS)'
date: 2025-12-29T17:06:40+08:00
description: "A blog post"
image: "https://www.xiaoji001.com/altstore/resource/macos/1.png"
type: "post"
tags: ["blog","AltStore","IOS","ipa","MacOS","自签名","签名","证书"]
---

# AltStore 使用说明(MacOS)
## 一、引言
对于希望在 iOS 设备上使用源阅读 App（如通过 RSS、OPML 订阅各类资讯源）的用户，由于 App Store 审核政策限制，许多功能强大的第三方源阅读工具无法上架。AltStore 提供了一种安全、可靠的侧载方式，让用户能够安装这些未上架的应用。
本指南将详细介绍如何在 Mac（苹果芯片）上安装和配置 AltStore，然后使用它来侧载一个名为 “NetNewsWire” 的开源源阅读 App。

## 二、准备工作
在开始之前，请确保你已准备好以下内容：
1. 一台运行 macOS 的电脑：本指南以搭载苹果芯片（M 系列）的 Mac 为例。
2. 一部 iPhone 或 iPad：运行 iOS 12.2 或更高版本。
3. 一个苹果开发者账号：
   - 免费账号：可以使用，但是每 7 天需要重新签名一次应用。
   - 付费开发者账号 ($99 / 年)：推荐，签名后的应用有效期为一年，且无需频繁连接电脑。
4. 网络连接：确保你的 Mac 和 iOS 设备连接到同一个 Wi-Fi 网络。
5. 数据线：用于首次将 iOS 设备连接到 Mac 进行配对。

## 自签名的步骤
### 一、安装AltServer
1. 进入 [Altstore官网](https://altstore.io/) 首页，在下方找到下载按钮，下载并保存到电脑。若在Mac上操作，下载macOS版；Windows上使用则下载Windows(Beta)版（要求：macOS 10.14.4+ / Windows 10）。
    - 官网相关界面截图参考：![AltStore官网下载界面](https://www.xiaoji001.com/altstore/resource/macos/1.png)
2. 把下载好的软件压缩包解压，将AltServer.app拷贝到长期保存的路径，或/Applications目录下。
    - 文件路径示例截图：![文件路径示意图](https://www.xiaoji001.com/altstore/resource/macos/2.png)

### 二、运行AltServer
1. 在macOS Bigsur上运行AltServer.app，系统默认禁止非App Store下载的软件运行，需右键点击软件，选择“打开”（Open）。
    - 右键菜单截图：![右键菜单示意图](https://www.xiaoji001.com/altstore/resource/macos/3.png)
2. 弹出提示“AltServer.app是从互联网下载的应用，是否确定打开？”，点击“Open”即可（Apple已检测无恶意软件）。
    - 安全提示截图：![安全提示弹窗](https://www.xiaoji001.com/altstore/resource/macos/4.png)

### 三、安装AltStore到手机
1. 绕过系统限制后，点击系统右上菜单栏中的altserver图标，选择“Install AltStore”，并选择已连接电脑的手机。
    - 菜单栏操作截图：![菜单栏选择示意图](https://www.xiaoji001.com/altstore/resource/macos/5.png)
2. 此时AltServer会要求输入Apple Id与密码，建议使用专门用于玩游戏的Id（密码仅用于Apple认证，不会被保存）。
    - 账号密码输入截图：![Apple ID输入界面](https://www.xiaoji001.com/altstore/resource/macos/6.png)
3. 若为刚安装的AltServer，会提示安装邮件插件（用于接收验证码、证书验证等），点击“Install Plug-in”。
    - 邮件插件安装提示截图：![插件安装提示弹窗](https://www.xiaoji001.com/altstore/resource/macos/7.png)
4. 安装插件需管理员权限，输入操作系统登陆密码后完成安装，之后重新执行步骤1-2安装AltStore到手机。
    - 管理员密码输入截图：![密码输入弹窗](https://www.xiaoji001.com/altstore/resource/macos/8.png)

### 四、启用邮件通讯插件
1. 若输入Apple Id与密码后出现“Installation Failed：Could not connect to Mail plug-in”错误，需按以下步骤操作：
    - 启动“邮件”（Mail）软件，选择“偏好设置”（快捷键：Command+,）。
      - 邮件软件操作截图：![邮件偏好设置入口](https://www.xiaoji001.com/altstore/resource/macos/9.png)
    - 切换到“通用”标签，点击“管理插件”。
      - 通用标签截图：![通用标签界面](https://www.xiaoji001.com/altstore/resource/macos/10.png)
    - 在弹出窗口中勾选“AltPlugin.mailbundle”，点击“应用并重启邮件”。
      - 插件管理截图：![插件勾选界面](https://www.xiaoji001.com/altstore/resource/macos/11.png)
2. 保持“邮件”运行状态，返回第三步重新安装AltStore到手机。

### 五、安装软件
1. AltStore安装到手机后，点击图标可能弹出“不受信任的开发者”提示，需进行以下设置：
    - 打开手机“设置”→“通用”→拉到最下方“设备管理”。
      - 手机设置路径截图：![设备管理入口](https://www.xiaoji001.com/altstore/resource/macos/12.png)
    - 找到对应签名（如“iPhone Developer: CHVZ4H3PWH”），点击“信任”，再次确认“信任”即可。
      - 信任设置截图：![开发者信任界面](https://www.xiaoji001.com/altstore/resource/macos/13.png)
2. 保持电脑端“AltServer”与“Mail”处于运行状态，返回手机桌面运行AltStore。
3. 首次进入或首次安装应用时，需输入安装AltStore时使用的Apple ID登陆（凭据将安全存储在设备钥匙串中，仅用于Apple认证）。
    - AltStore登陆界面截图：![AltStore登陆界面](https://www.xiaoji001.com/altstore/resource/macos/14.png)
4. 登陆后可在AltStore中直接安装列出的应用。
    - 注意：免费开发帐户最多可创建10个证书，因此免费签名安装的应用最多为9个（除去AltStore本身）。

### 六、Sideload 应用（安装自定义IPA）
1. 前提条件：电脑端运行“AltServer”与“邮件”，且手机与电脑处于同一网络环境。
2. 从网站下载ipa
3. 安装IPA文件：
    - 在下载列表中找到IPA文件，进入文件预览，点击右下角“发送”→“其他应用”。
    - 在应用列表中选择“AltStore”，等待安装完成（可在AltStore的“My Apps”中查看）。
### 七、有效期刷新
1. 自签名应用有效期为7天，需在过期前刷新证书。
2. 操作步骤：
    - 电脑端运行“AltServer”与“邮件”，手机与电脑保持同一网络。
    - 打开手机AltStore，进入“My Apps”，找到需刷新的应用，点击右侧时间按钮，等待刷新完成。
      - 有效期刷新截图：![刷新操作界面](https://www.xiaoji001.com/altstore/resource/mob/11.png)

## 补充说明
- AltStore、Delta、Clip均为Itstor LLC所有，与Nintendo、Apple无关联。
- 若需查看已使用的App ID，可在AltStore→“My Apps”→“View App IDs”中查看，剩余可用数量会显示（如“7 App IDs Remaining”）。
- 刷新操作可批量执行，点击“My Apps”页面的“Refresh All”即可刷新所有应用的有效期。
