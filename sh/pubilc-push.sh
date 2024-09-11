#!/bin/bash
WORKDIR=$(pwd)
cd ../public/

# 添加所有修改的文件到暂存区
git add .

# 提交暂存区内容
git commit -m "Auto Commit"

# 推送代码到远端分支
git push origin main
