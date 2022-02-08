---
layout: post
title: "scaling with openvpn"
date: 2022-02-07 21:18:07 -0500
categories: [tech]
---

You know your company is growing if your openvpn `--max-client` limit [suddenly needs to be made bigger than the default 1024](https://forums.openvpn.net/viewtopic.php?t=7188) or else the OpenVPN server suddenly dies and everyone thought it's a firewall issue.