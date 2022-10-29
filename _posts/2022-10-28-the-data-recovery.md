---
layout: post
title: "the data recovery"
date: 2022-10-28 23:20:06 -0400
categories: [tech, work, career, interview]
---

Many developers will have done this, some probably do this as a daily routine, but a recent work of mine on a data recovery job felt like a latest expression of my progress so far.

After being notified by some customers, AppCard discovered that a real-time SQS data queue provided by a third-party hasn’t provided real-time data in a while. Though we were able to quickly notify our third-party to bring that system back online, we still had an issue where approximately 4 days of data was missing and unprocessed. 

{% include centerImage.html url="/assets/DataRecovery/records_dont_exist.webp" desc="Jocasta Nu is her name btw" title="The 3rd-party didn't say this, but more like 'we don't want to deal with this'" alt="Jedi Master Jocasta Nu tells Obi-Wan Kenobi that 'if an item doesn't appear in our records, it does not exist'" %}

Based on business considerations, we decided that it would be best if we could recover the data without needing help from the third-party (or that they should be doing this because after all it's their fault). When the integration lead hesitated to take on this responsibility due to allocation constraints, I volunteered to take on the challenge. There were two components I had to address before even committing (because free credits for customers are expensive but simple):
1. Is it possible to retrieve the data from the third-party's available API?
2. How long would it take to implement this?

{% include centerImage.html url="/assets/DataRecovery/give_the_money.gif" desc="How I imagine any average customer" title="The greed of man is insatiable" alt="Scene from the show Friends where Phoebe grabs Ross then threateningly says 'Give me your money, Punk'" %}

Firing up a jupyter notebook, I got to work. Quickly, I was able to confirm that with the right secrets pulled from the right place, and just reading the documentation, the third-party's API seems to be able to provide the data we need. ( We are leaving aside the question why we rely on an SQS instead of this API ;) ). Additionally, after quickly skimming through our integration subsystem, I was able to identify a location in the flow where I could inject the data if I have the right dummy wrapper setup.

{% include centerImage.html url="/assets/DataRecovery/in_theory_possible.gif" desc="I was 70% sure" title="The line between confidence and arrogance is thin" alt="Some dude on a red couch saying 'In theory it's possible'" %}

Gauging my own speed of development, considering that realistically I only grasp maybe 60-70% of how to use the API or the integration subsystem, and adding some buffer, I was able to give an estimate of 2 days for implementation and 1 day to run the recovery process to the business and tech leads by the same day, which then my lead gave the greenlight to carry on. 


Our codebase is in Python so I was able to draft out and do test code with a local jupyter notebook. With the implementation, I made the decisions to rely on our existing async infrastructure with Celery, and also provide sufficient optional parameterization in case I needed to restart tasks with slightly different assumptions as our business only allowed releases once a day. It would be better for a struggling but running process than having to wait another day. Once I felt comfortable, we had a pre-production environment that I made sure to test out the results before we merged into production but admittedly our pre-production data is very different from real production.The key was excessive logging (stored in Kibana) to monitor the progress. There were hiccups once this was merged in production, one of our assumptions turned out to be incorrect and sometimes the async task didn’t automatically restart if there was more data to query, but combining architecture with loggings of the right parameters meant I could manually trigger them without side-effects. This meant more human intervention but still allowed the job to finish. In the end, almost all our customers didn’t even notice. In retrospect, this mini-project was well-delivered and went as scheduled, and had real immediate business impact on the bottom line.
