---
layout: post
title: "scaling with openvpn"
date: 2022-02-07 21:18:07 -0500
categories: [tech]
---

You know your company is growing if your openvpn `--max-client` limit [suddenly needs to be made bigger than the default 1024](https://forums.openvpn.net/viewtopic.php?t=7188) or else the OpenVPN server suddenly dies and everyone thought it's a firewall issue.

<!--break-->

It started around 2PM, our resident SysAdmin-Extraodinaire Dave, was sitting in the seat next to me when he suddenly says out loud "I can't connect to any jbrains". Ray who sits opposite me reached for his keyboard, typed a few things, and confirm "huh, I can't connect to any either". At this point, the other support engineers started doing the same thing, verifying that they too can't connect to any jbrains. 

At this point I should explain what are the jbrains. They're AppCard's brains in the field, deploying one to each merchant that we work with, handles any business logic, watch and alter POS transactions, send back data to our remote servers. From our servers, we can ssh into any of the jbrains to do maintenance, debugging, retrieving logs, etc. In short, they're the most important component in the AppCard hardware system, and now none of us can connect to them.

Almost instantly, the entire Ops team was roused into a flurry of activity. The Ops Manager didn't notice at first (he's very plugged in), not until the first of the Account Manager started pinging him on Slack, and then physically walked over to ask what's going on. Dave has left only one message on the prods alert channel saying: "jbrains are down. looking into". Within 10 minutes, a Google Meet where every engineer that has not yet left work was invited to join (in Israel it was dinner time). The CTO couldn't join but he was able to guide debugging through Slack, with some very insightful questions on "are the iptables up?". Dave himself went into the jbrain provisioning room all by himself, for focus I guess, and did his furious typing there.

Are the jbrains down? No, Account Managers are reporting discounts are still being applied. Are the servers configured correctly? Yes, and no one was changing anything recently. Is OpenVPN up? yes, we have multiple and none died, and failover processes would have been triggered. Can we connect to jbrains we have in the office? No, well, yes, but not through our VPN servers. Is it AWS? No, we can get into the servers and we can connect to the jbrain through network IP. What do you see when you connect to the jbrain directly and look at its log? it says they cannot reach the VPN server. Can't reach or can't connect? Can't reach, "no route to host". Can you connect to the VPN server? Yes, lemme attempt restart of servers. This reminds me of something, is iptable on? No, it's not on, wait, it's only disabled, not stopped, and the server restart restarted iptable. Disabling now.

It was like the sunrise. Green numbers started popping up on all the dashboards, jbrains flood the connections, logs started sprinting, the database suddenly see a spike in CPU and memory utilization due to backlog of transactions needed processing. For a moment, things were alright. People could breathe and ask "what happened? why did it happen?". Only Dave here suddenly ping on slack, "wait, nightmare not over, jbrains connections started dropping".

At this point I phased out, I knew Dave could fix it, and he did, because with the second time having to restart servers, Dave noticed when the number of connections reached 1024, the VPN servers started dropping connections. It was because of the default `--max-client` on OpenVPN.

Fun.