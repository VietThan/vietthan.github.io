---
layout: post
title: "the database discovery"
date: 2022-10-29 20:33:25 -0400
categories: [tech, work, career, interview]
---

This is probably my most interesting story so far at this job. No lie, I really did discover a database in production that no one else knew existed.

It starts when Kobi, AppCard's Operations Director, approached me one day and say, "Hey Viet, can you look into why one of our jbrains wasn't backed up?". 

<!--break-->

For context, jbrains are the on-prem devices AppCard deploys to our customers (the grocery stores). These brains sits in the grocery store's network and communicates with the various Point-of-Sales devices to administer coupons, loyalty system etc. The Jbrain is highly configurable, as each grocers have different needs and integrations.

I knew the jbrain's "backups" are really just daily copies of these configuration files, stored in a server on AWS (we will leave aside the question of why not S3). With these files, a jbrain replacement can be "built" with the same configurations if there are hardware failures or the likes.

After confirming that it looks like the jbrain in question has no backups, and actually there are other jbrains that are missing their backups too, the only suspects is a bug in the backup process or a bug with the backup server. Now I know this backup server, the tech support guys and I use it everyday to do our work, but it's a holy mess of scripts created by half a dozen sysadmins that I never got a knowledge transfer on, we can't start our search there. Howabout the process? Do we know how the backup process work? Of course we don't. And just as obviously, the guys that actually built it are long gone and didn't leave behind any documentation on both the process and the server. The only clue I had was someone mentioning: "I think it's scheduled to run daily at 1 or 2AM or something".

Now that could mean anything, but to me, that sounded like a crontab. At the very least, I hope the crontab exists on the backups server, and not some _other_ server, cause oh boy do we have a lot of servers (as an aside, this monstrosity of complexity is being worked on, with no end in sight). I was able to find a way to output every possible cronjob (users, cron directories), and nestled in all those jobs was one labeled "daily jbrain backups". Aha!

But wait, that backup script is in perl. I didn't know perl, but I had the spirit of all engineers in that we know we can figure anything out. It's actually quite an intuitive language. And all you really need to know how to debug is the ability to print to stdout.

I quickly found that this backup perl script rely on a textfile with a list of stores to know what to backup. Grepping on that list, we can see it is certainly missing many many stores. So what populates this file?

At this point I could do a combination of `find`/`grep`, but thankfully I noticed that this textfile is last modified on the dot at 11PM the previous day. Lol, crontab again it is. Scanning the crontab output from the previous section, and what do you know, another perl script.

This time, I noticed something peculiar. The perl script started calling `/usr/bin/mysql` with some variables. Chasing down these variables leads to some env files. And at this point, I realized that it is calling a database that I didn't know about. This database wasn't in my training, it wasn't ever mentioned by the support engineers, it wasn't on the google sheet containing list of database maintained by the ex-database administrator, and it was not part of my knowledge transfer with the ex-system admin either. 

I called Kobi and told him the situation, and then we simply shared a kind of chuckle reserved for situations of absurdity.

Back to work, I obviously started by logging into this MariaDB lost through time. There were only a few tables, nothing mind-blowing or anything. But combined with the perl script, I started tracing that perl script to see what it is doing with the database. And actually, once I figured out how to run the perl script, the error quickly became apparent as the result of an unhandled error by the script when it tries to insert rows into the database. For a moment, it was the developer happy debug loop of modify, run, read until eureka!

Anyway, what was the issue isn't important (it is fixed by now!)(there was missing ancillary data because new jbrains had a recent upgrade), but the discovery of the database is. This database, until we can move on from it, is a critical part of the company's infrastructure. The existence of this database, even mostly-unmanaged as it is now, changed how development for operations can move forward. We started documenting it. Though opportunities are few, future development did consider whether we can use that database. Once I figured out how to get myself superuser access, I even started adding new tables for my developmental needs. 

Looking back, I think of this story as a fond discovery. The CTO was definitely pleased to hear about this find. And I think it's a lesson in how effective but forgotten scripts and software can quietly run for years until the day something breaks.

PS: We are starting to centralize the various perl and bash scripts across servers and versioning control them. Not forgetting those too!