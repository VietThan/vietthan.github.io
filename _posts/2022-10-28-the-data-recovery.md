---
layout: post
title: "the data recovery"
date: 2022-10-28 23:20:06 -0400
categories: [tech, work, career, interview]
---

Many developers will have done this, some probably do this as a daily routine, but a recent work of mine on a data recovery job felt like a latest expression of my career's progress so far.

<!--break-->

## The Problem

After being notified by some customers, AppCard discovered that a real-time SQS data queue provided by a third-party hasn’t provided real-time data in a while. Though we were able to quickly notify our third-party to bring that system back online, we still had an issue where approximately 4 days of data was missing and unprocessed. 

{% include centerImage.html url="/assets/DataRecovery/not_my_problem.gif" desc="What I wanted us to say to them but they said this to us first" title="The 3rd-party didn't say this, but more like 'we don't want to deal with this'" alt="Jimmy Fallon on The Tonight Show saying 'This sounds more like a you problem'" %}

Based on business considerations, we decided that it would be best if we could recover the data without needing help from the third-party (or that they should be doing this because after all it's their fault). When the integration lead hesitated to take on this responsibility due to allocation constraints, I volunteered to take on the challenge. There were two components I had to address before even committing (because free credits for customers are expensive but simple):
1. Is it possible to retrieve the data from the third-party's available API?
2. How long would it take to implement this?

{% include centerImage.html url="/assets/DataRecovery/give_the_money.gif" desc="How I imagine any average customer hearing about missing data" title="The greed of man is insatiable" alt="Scene from the show Friends where Phoebe grabs Ross then threateningly says 'Give me your money, Punk'" %}

## The Fix 

Firing up a jupyter notebook, I got to work. Quickly, I was able to confirm that with the right secrets pulled from the right place, and just reading the documentation, the third-party's API seems to be able to provide the data we need. ( We are leaving aside the question why we rely on an SQS instead of this API ;) ). Additionally, after quickly skimming through our integration subsystem, I was able to identify a location in the flow where the right data could be injected with the right dummy setup.

{% include centerImage.html url="/assets/DataRecovery/in_theory_possible.gif" desc="I was 70% sure I could do it" title="The line between confidence and arrogance is thin" alt="Some dude on a red couch saying 'In theory it's possible'" %}

Gauging my own speed of development, considering that realistically I only grasp maybe 60-70% of how to use the API or the integration subsystem, and adding some buffer, I estimated 2 days for implementation and 1 day to run the recovery process. I then presented my findings to the business and tech leads that afternoon, giving me the greenlight to go ahead.

{% include centerImage.html url="/assets/DataRecovery/you_got_this.gif" desc="I didn't include a few worrying discussions of possible side-effects" title="Bill Murray would make a great tech lead" alt="Bill Murray in a suit with left eyebrow raised while holding a wine glass on his left hand and pointing at the screen with his right hand at the viewer with caption 'You Got This'" %}


Our async infrastructure and integration is already built on the Python framework Celery, convenient grounds for this one-off development. The simple overview of the job is that it would pull data for 100 transactions at time, process it, and repeat until it hits a transaction outside the 4 day gap. I made sure to provide sufficient optional parameterization in case I needed to restart the jobs if it fail or stop unexpectedly. Since we can only deploy once a day, it would be better for a struggling but kept-running process than having to wait for the following day to fix the code and start over. This also meant an almost excessive amount of loggings, so as to have an intimate visibility on how the recovery task is going, and provide the necessary parameters if the job needed restarting.

{% include centerImage.html url="/assets/DataRecovery/laying_train_tracks.gif" desc="Conceptual visual of my architecture" title="I'm Gromit" alt="The beagle Gromit from the series Wallace and Gromit riding a toy train and laying down the train tracks for that toy train as fast as he can so he won't crash" %}

Once I felt comfortable, we had a pre-production environment that I made sure to test out my task. But admittedly our pre-production data is very different from real production. There were immediate hiccups once this was merged in production, one of our assumptions turned out to be incorrect and sometimes the async job didn’t automatically repeat even though there was more data in the gap to query. Thankfully, I could manually re-trigger the jobs with the right parameters because of the logging. This meant more human intervention but still allowed the job to finish. 

{% include centerImage.html url="/assets/DataRecovery/phew.gif" desc="I didn't do this cause I was sitting next to the business, but I was this internally" title="A lot of internal self-praise" alt="Some guy wiping his brow" %}

## The Conclusion

In the end, almost all our customers didn’t even notice the data gap. Shoppers got their points and we didn't need to give anyone any extra credit. My teammates could focus on other task. As for me, this mini-project was well-delivered, well-scheduled, and had real immediate business impact on the bottom line. Coming home that day, I felt like I earned my paycheck.

{% include centerImage.html url="/assets/DataRecovery/honest_work.jpg" desc="Professional pride feels good" title="Couldn't find the gif for this" alt="The meme with the farmer and caption 'It ain't much, but it's honest work'" %}