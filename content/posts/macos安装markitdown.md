---
title: 'Macos安装markitdown'
date: 2026-07-15T09:54:14+08:00
description: "A blog post"
image: "/images/20260715095414.png"
type: "post"
tags: ["blog"]
---

# macOS 使用 microsoft/markitdown 完整教程
MarkItDown 是微软开源的文档转 Markdown 工具，macOS 基于 Python 运行，下面分**环境准备、安装、命令行使用、Python API、右键快捷操作、常见报错**完整说明。

## 一、前置环境（macOS 必装）
### 1. 安装 Python 3.10+
macOS 自带 Python2，需要装新版 Python：
```bash
brew install python@3.12
# 验证
python3 --version
```

### 2. 安装系统底层依赖（OCR/PDF 必备）
处理 PDF、图片OCR需要 poppler、tesseract：
```bash
brew install poppler tesseract
# 如需中文OCR识别图片汉字
brew install tesseract-lang
```

### 3. 推荐创建虚拟环境（避免依赖冲突）
```bash
# 创建虚拟环境
python3 -m venv ~/venv-markitdown
# 激活环境
source ~/venv-markitdown/bin/activate
```
终端出现 `(venv-markitdown)` 代表激活成功，后续所有安装/执行都在这个环境。

## 二、安装 markitdown 两种方式
### 方式1：PyPI 一键安装（推荐）
#### ① 全功能版（PDF/Word/PPT/Excel/OCR/音频全部支持）
```bash
pip3 install 'markitdown[all]'
```
#### ② 轻量化按需安装（只装办公文档，体积小）
```bash
# 仅 PDF + Word + PPT + Excel
pip3 install 'markitdown[pdf,docx,pptx,xlsx]'
```
可选模块：
- `image`：图片OCR
- `audio-transcription`：mp3/wav 语音转文字
- `youtube-transcription`：油管字幕提取

#### 验证安装
```bash
markitdown --version
```
输出版本号即安装成功。

### 方式2：源码安装（适合二次开发/修改源码）
```bash
git clone https://github.com/microsoft/markitdown.git
cd markitdown
# 本地可编辑模式安装
pip3 install -e 'packages/markitdown[all]'
```

## 三、macOS 终端命令行常用用法
### 1. 基础单文件转换
```bash
# 直接输出md内容到终端
markitdown 文档.pdf

# 指定输出文件（推荐）
markitdown 报告.docx -o 报告.md

# 重定向写法等价
markitdown 幻灯片.pptx > 幻灯片.md
```

### 2. 图片OCR提取文字（截图、照片）
```bash
markitdown 截图.png --enable-ocr -o 图片文字.md
# 中文图片识别
markitdown 发票.jpg --enable-ocr --ocr-lang chi_sim -o 发票.md
```

### 3. 音频转文字
```bash
markitdown 会议录音.mp3 -o 会议纪要.md
```

### 4. 批量转换当前目录所有PDF（macOS shell）
```bash
for f in *.pdf; do markitdown "$f" -o "${f%.pdf}.md"; done
```

### 5. 网页/在线PDF链接直接转换
```bash
markitdown https://xxx.com/file.pdf -o 网页文档.md
```

### 6. 查看帮助文档
```bash
markitdown -h
```

## 四、Python API 代码调用（自动化脚本）
新建 `convert.py`：
```python
from markitdown import MarkItDown

# 初始化转换器
md_tool = MarkItDown()

# 转换本地文件
result = md_tool.convert("文档.docx")

# 打印转换后的markdown文本
print(result.text_content)

# 保存到md文件
with open("输出.md", "w", encoding="utf-8") as f:
    f.write(result.text_content)

# 读取元数据（标题、作者等）
print("文档标题：", result.title)
print("元数据：", result.metadata)
```
运行脚本：
```bash
python3 convert.py
```

## 五、进阶：Finder 右键一键转换（不用敲终端）
社区提供 macOS 快捷操作 workflow：
1. 下载 workflow：https://github.com/danmunz/markitdown-quick-action
2. 将 `Markitdown.workflow` 放入文件夹：
```
~/Library/Services/
```
3. 系统设置 → 键盘 → 快捷键 → 服务，启用「Convert to Markdown」
4. 右键任意文档 → 快速操作 → Convert to Markdown，自动生成同目录 `.md` 文件

## 六、macOS 常见报错解决
1. `zsh: command not found: markitdown`
   - 未激活虚拟环境；或 pip3 安装路径没进PATH
   - 临时解决：`python3 -m markitdown.cli 文件.pdf`

2. OCR识别空白、乱码
   - 重装依赖：`brew reinstall tesseract tesseract-lang`
   - 命令加参数 `--ocr-lang chi_sim`

3. docx/ppt转换失败
   - 重装完整依赖：`pip3 install 'markitdown[docx,pptx]' --upgrade`

4. 权限报错（无法读取文件）
   - 终端执行前加 `chmod 644 文件名`，或把文件移到桌面再转换

## 七、退出虚拟环境
用完工具关闭隔离环境：
```bash
deactivate
```
