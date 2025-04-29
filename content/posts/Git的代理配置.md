---
title: 'Git的代理配置'
date: 2025-04-29T14:43:10+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["git","代理","socket5","mac"]
---

# Git的代理配置
## http/https(使用 http/https 方式 clone 代码)
```bash
git config --global http.proxy http://127.0.0.1:1080
```

## ssh(使用 ssh 方式 clone 代码)
```bash
Host github.com
        Hostname ssh.github.com
        Port 443
        User git
        ProxyCommand nc -v -x 127.0.0.1:1080 %h %p
```
