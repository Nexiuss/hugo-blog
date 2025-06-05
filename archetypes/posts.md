---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: {{ .Date }}
description: "A blog post"
image: "/images/{{ now.Format "20060102150405" }}.png"
type: "post"
tags: ["blog"]
---

# Hello World!
This is my blog.
