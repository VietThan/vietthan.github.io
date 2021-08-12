---
layout: post
title: "Is COBOL holding you hostage with Math?"
date: 2021-08-12 08:52:31 -0400
categories: tech
---

_So a certain country blocks Medium so I'm recreating it here_


> Author: Marianne Bellotti
> Jul 28, 2018 · 12 min [read](https://medium.com/the-technical-archaeologist/is-cobol-holding-you-hostage-with-math-5498c0eb428b)


Face it: nobody likes fractions, not even computers.

When we talk about COBOL the first question on everyone’s mind is always *Why are we still using it in so many critical places?* Banks are still running COBOL, close to 7% of the GDP is dependent on COBOL in the form of payments from the [Centers for Medicare & Medicaid Services](1), The IRS famously still uses COBOL, airlines still use COBOL ([Adam Fletcher](2) dropped my favorite fun fact on this topic in his [Systems We Love talk](3): the reservation number on your ticket used to be just a pointer), lots of critical infrastructure both in the private and public sector still runs on COBOL.

_**Why?**_

<!--break-->

The traditional answer is deeply cynical. Organizations are lazy, incompetent, stupid. They are cheap: unwilling to invest the money needed upfront to rewrite the whole system in something modern. Overall we assume that the reason so much of civil society runs on COBOL is a combination of inertia and shortsightedness. And certainly there is a little truth there. Rewriting a mass of spaghetti code is no small task. It is expensive. It is difficult. And if the existing software seems to be working fine there might be little incentive to invest in the project.

But back when I was working with the IRS the old COBOL developers used to tell me: “We tried to rewrite the code in Java and Java couldn’t do the calculations right.”
This was a very strange concept to me. So much so that a panicked thought popped immediately into my head: “my God the IRS has been rounding up everyone’s tax bill for 50 years!!!” I simply could not believe that COBOL could beat Java at the type of math the IRS needed. After all, they weren’t launching men into space over at New Carrollton.
One of the fun side effects of my summer learning COBOL is that I’m beginning to understand that it’s not that Java can’t do math correctly, it’s how Java does math correctly. And when you understand how Java does math and how COBOL does the same math, you begin to understand why it’s so difficult for many industries to move away from their legacy.

### Where’s Your Point?

I took a little break from writing about COBOL to write about [the ways computers stored information before binary became the de facto standard](4) (and also [a primer on how to use the z/OS interface](5) but that’s neither here nor there). Turns out that was a useful digression when considering this problem. In that post I talked about various ways one might use on/off states to store base 2 numbers, base 3 numbers, base 10 numbers, negative numbers and so on. The one thing I left out was … How do we store decimals?

If you were designing your own binary computer you might start off by just sticking with a base 2 representation. Bits left of the point represent 1,2,4,8… and bits right of the point represent 1/2, 1/4, 1/8…


{% include centerImage.html url="/assets/CobolMath/1.png" desc="2.75 in binary" title="2.75 in binary" alt="fraction is hard" %}

The problem is figuring out how to store the decimal point — or actually I should say the _binary point_ because this is base two after all. This topic is not obscure, so you might realize that I’m referring to _**floating point**_ -vs- _**fixed point**_. In floating point the binary point can be placed anywhere (it can float) [with its exact location stored as an exponent](6). Floating the point gives you a wider range of numbers you can store. You can move the decimal point all the way to the back of the number and devote all the bits to integer values representing very large numbers, or you could move it all the way to the front and represent very small numbers. But you sacrifice precision in exchange. Take another look at the binary representation of 2.75 above. Going from four to eight is a much longer jump than going from one-fourth to one-eight. It might be easier to visualize if we wrote it out like this:

{% include centerImage.html url="/assets/CobolMath/2.png" desc="Don’t measure the gaps, I just eyeballed this to demonstrate the concept." title="visually spaced binary representation" alt="visually spaced binary representation down to 1/8" %}

It’s easy to calculate the difference yourself: the distance between 1/16 and 1/32 is 0.03125 but the distance between 1/2 and 1/4 is .25.

Why does this matter? With integers it really doesn’t, some combination of bits can fill in the gaps, but with fractions things can and do fall through the gaps making it impossible for the exact number to be represented in binary.

The classic example of this is .1 (one-tenth). How do we represent this in binary? 2-¹ is 1/2 or .5 which is too large. 1/16 is .0625 which is too small. 1/16 + 1/32 gets us closer (0.09375) but 1/16+1/32+1/64 knocks us over with 0.109375.

If you’re thinking to yourself this could go on forever: [yes, that’s exactly what it does](7).

Okay, you say to yourself, why don’t we just store it the same way we store the number 1? We can store the number 1 without problems, let’s just take out the decimal point and store everything as an integer.

Which is a great solution to this problem except that it requires you to fix the decimal/binary point at a specific place. Otherwise 10.00001 and 100000.1 become the same number. But with the places right of the point fixed at two we’d round off 10.00001 to 10.00 and 100000.1 would become 100000.10

Voilà! And that’s fixed point.

Another thing you can do more easily with fixed point? Bring back our good friend Binary Coded Decimal. FYI this is how the majority of scientific and graphing calculators work, things that you really want to be able to get math right.

{% include centerImage.html url="/assets/CobolMath/calculator.jpeg" desc="<i>Remember me? BCD baby~</i>" title="TI-84 Plus calculator" alt="Remember me? BCD baby~" %}

### Muller’s Recurrence

Fixed point is thought to be more precise because the gaps between are consistent and rounding only occurs when you’ve exhausted the available places, whereas with floating points we can represent larger and smaller numbers with the same amount of memory but we cannot represent all numbers within that range accurately and must round to fill in the gaps.

COBOL was designed for fixed point by default, but does that mean COBOL is better at math than more modern languages? If we stuck to problems like .1 + .2 the answer might seem like a yes, but that’s boring. Let’s push this even further.

We’re going to experiment with COBOL using something called Muller’s Recurrence. Jean-Michel Muller is a French computer scientist with perhaps the best computer science job in the world. He finds ways to break computers using math. I’m sure he would say he studies reliability and accuracy problems, but no no no: _**He designs math problems that break computers**_. One such problem is his recurrence formula. Which looks something like this:

{% include centerImage.html url="/assets/CobolMath/muller-recurrence.png" desc="From Muller’s Recurrence — roundoff gone wrong" title="Muller's recurrence formula" alt="Showing how float/fix point calculation differs" %}

[Muller’s Recurrence — roundoff gone wrong](8)

That doesn’t look so scary does it? The recurrence problem is useful for our purposes because:
- It is straight forward math, no complicated formulas or concepts
- We start off with two decimal places, so it’s easy to imagine this happening with a currency calculation.
- The error produced is not a slight rounding error but orders of magnitude off.

And here’s a quick python script that produces floating point and fixed point versions of Muller’s Recurrence side by side:

```python
from decimal import Decimal
def rec(y, z):
 return 108 - ((815-1500/z)/y)
 
def floatpt(N):
 x = [4, 4.25]
 for i in range(2, N+1):
  x.append(rec(x[i-1], x[i-2]))
 return x
 
def fixedpt(N):
 x = [Decimal(4), Decimal(17)/Decimal(4)]
 for i in range(2, N+1):
  x.append(rec(x[i-1], x[i-2]))
 return x
N = 20 
flt = floatpt(N)
fxd = fixedpt(N)
for i in range(N):
 print str(i) + ' | '+str(flt[i])+' | '+str(fxd[i])
```

Which gives us the following output:

```
i  | floating pt    | fixed pt
-- | -------------- | ---------------------------
0  | 4              | 4
1  | 4.25           | 4.25
2  | 4.47058823529  | 4.4705882352941176470588235
3  | 4.64473684211  | 4.6447368421052631578947362
4  | 4.77053824363  | 4.7705382436260623229461618
5  | 4.85570071257  | 4.8557007125890736342039857
6  | 4.91084749866  | 4.9108474990827932004342938
7  | 4.94553739553  | 4.9455374041239167246519529
8  | 4.96696240804  | 4.9669625817627005962571288
9  | 4.98004220429  | 4.9800457013556311118526582
10 | 4.9879092328   | 4.9879794484783912679439415
11 | 4.99136264131  | 4.9927702880620482067468253
12 | 4.96745509555  | 4.9956558915062356478184985
13 | 4.42969049831  | 4.9973912683733697540253088
14 | -7.81723657846 | 4.9984339437852482376781601
15 | 168.939167671  | 4.9990600687785413938424188
16 | 102.039963152  | 4.9994358732880376990501184
17 | 100.099947516  | 4.9996602467866575821700634
18 | 100.004992041  | 4.9997713526716167817979714
19 | 100.000249579  | 4.9993671517118171375788238
```

Up until about the 12th iteration the rounding error seems more or less negligible but things quickly go off the rails. Floating point math converges around a number twenty times the value of what the same calculation with fixed point math produces.

Least you think it is unlikely that anyone would do a recursive calculation so many times over. [This is exactly what happened in 1991 when the Patriot Missile control system miscalculated the time and killed 28 people](9). And it turns out floating point math has blown lots of stuff up completely by accident. Mark Stadtherr gave an incredible talk about this called [High Performance Computing: are we just getting wrong answers faster?](10) You should read it if you want more examples and a more detailed history of the issue than I can offer here.

The trouble is computers do not have infinite memory and therefore cannot store an infinite number of decimal (or binary) places. Fixed point can be more accurate that floating point when you’re confident that you’re unlikely to need more places than you’ve set aside. If you go over, the number will be rounded. Neither fixed point nor floating point are immune to Muller’s Recurrence. Both will eventually produce the wrong answer. The question is _when_? If you increase the number of iterations in the python script from 20 to 22, for example, the final number produced by fixed point will be `0.728107`. Iteration 23? `-501.7081261`. Iteration 24? `105.8598187`.

Different languages handle this issue differently. Some, like COBOL, will only let data types have a certain number of places. Python, on the other hand has defaults that can be adjusted as needed if the computer itself has enough memory. If we add a line to our program (`getcontext().prec = 60`) telling python’s decimal module to use 60 places after the point instead of its default of 28 the program will be able to reach 40 iterations of Muller’s Recurrence without error.

Let’s see how COBOL does with the same challenge. Here’s a COBOL version of Muller’s

```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID.  muller.
AUTHOR.  Marianne Bellotti.
DATA DIVISION.
WORKING-STORAGE SECTION.
01  X1           PIC 9(3)V9(15)    VALUE 4.25.
01  X2           PIC 9(3)V9(15)    VALUE 4.
01  N            PIC 9(2)          VALUE 20.
01  Y            PIC 9(3)V9(15)    VALUE ZEROS.
01  I            PIC 9(2)          VALUES ZEROS.
 
PROCEDURE DIVISION.
 PERFORM N TIMES
  ADD 1 TO I
  DIVIDE X2 INTO 1500 GIVING Y
  SUBTRACT Y FROM 815 GIVING Y
  DIVIDE X1 INTO Y
  MOVE X1 TO X2
  SUBTRACT Y FROM 108 GIVING X1
  DISPLAY I'|'X1
 END-PERFORM.
 STOP RUN.
 ```

 If this is the first time you’ve seen a COBOL program before, let’s go over a couple of things. First is this is ‘free form’ COBOL which was introduced in 2002 to bring COBOL slightly more in line with how modern day languages are structured. Traditionally COBOL is fixed width, with certain things going in certain columns. The idea of thinking of source code as rows and columns might seem bizarre, but it was meant to imitate the formatting of punch cards which were how programs were written at the time. Punch cards are 80 columns across, with certain columns for certain values … so too is traditional COBOL.

The main thing that probably stands out is how variables are declared:

```cobol
01  X2           PIC 9(3)V9(15)    VALUE 4.
```

The code 01 in the beginning of the row is called the level number, it tells COBOL we are declaring a new variable. COBOL will allow us to associate or group variables together (the classic example is an address, which might have a street, a city, and a country as individual variables), so in that case the level number becomes important.

X2 is out variable name, pretty straight forward. At the end we have what our variable is set to at the beginning of the program: `VALUE 4`. No, the period is not a typo, that’s how COBOL ends lines.

That leaves the part in the middle `PIC 9(3)V9(35)`

PIC can be thought of as a char data type. It accepts alphanumeric data. It will even accept decimals. COBOL is strongly and static typed with the caveat that most of its types are much more flexible than other languages. You also have to define how many characters variables will take up when declaring them, those are the numbers in parentheses. `PIC 9(3)` means this variable holds three characters that are digits (represented by the `9`).

`9(3)V9(15)` then should be read as 3 digits followed by a decimal point (`V`) followed by 15 more digits.

Which produces the following:

```
01|004.470588235294118
02|004.644736842105272
03|004.770538243626253
04|004.855700712593068
05|004.910847499165008
06|004.945537405797454
07|004.966962615594416
08|004.980046382396752
09|004.987993122733704
10|004.993044417666328
11|005.001145954388894
12|005.107165361144283
13|007.147823677868234
14|035.069409660592417
15|090.744337001124836
16|099.490073035205414
17|099.974374743980031
18|099.998718461941870
19|099.999935923870551
20|099.999996796239314
```

That’s with 15 places after the point. If we change the `X1`, `X2`, and `Y` to `PIC9(3)V9(25)` we’ll get further:

```
01|004.4705882352941176470588236
02|004.6447368421052631578947385
03|004.7705382436260623229462114
04|004.8557007125890736342050246
05|004.9108474990827932004556769
06|004.9455374041239167250872200
07|004.9669625817627006050563544
08|004.9800457013556312889833307
09|004.9879794484783948244551363
10|004.9927702880621195047924520
11|004.9956558915076636302013455
12|004.9973912684019537143684268
13|004.9984339443572195941803341
14|004.9990600802214771851068183
15|004.9994361021888778909361376
16|004.9996648253090127504521620
17|004.9998629291504492286728625
18|005.0011987392925953357360627
19|005.0263326115282889612747162
20|005.5253038494467588243232985
```

Different mainframes will offer different upper limits for COBOL’s PIC type. IBM taps out at 18 digits total (at least my version did). MicroFocus will go up as high as 38 digits.

### How much does accuracy cost?

All of this is to demonstrate that COBOL does not do math better than other more common programming languages. With restrictions on the number of places in fixed point, it can actually under perform languages that give the developer more control.

But there’s a catch… Python (and for that matter Java) do not have fixed point built in and COBOL does.

IIn order to get Python to do fixed point I needed to import the `Decimal` module. If you’ve ever worked on a project with a whole bunch of imports you already know that they are not free. In a language like Java (which is usually what people want to migrate to when they talk about getting rid of COBOL), [the costs of the relevant library can be noticeably higher](11). It’s really more a question of whether worrying about it makes sense for your use case. For most programmers, fussing over the performance hit of an import is the ultimate in premature optimization.

But COBOL programmers tend to work on systems that must process millions — possibly billions — of calculations per second accurately and reliably. And unfortunately it’s very difficult to make a compelling argument for or against COBOL around that use case because it really is a zone of infinite variation. Is COBOL’s built in fixed point support the difference maker or would the proper combination of processor, memory, operating system, or dance moves neutralize that issue? Even when we restrict the conversation to very specific terms (say COBOL -vs- Java on the same hardware) it is hard to grasp how the trade-offs of each will affect performance when you reach that scale. They are simply too different.

> COBOL is a compiled language with stack allocation, pointers, unions with no run-time cost of conversion between types, and no run-time dispatching or type inference. Java, on the other hand, runs on a virtual machine, has heap allocation, does not have unions, incurs overhead when converting between types, and uses dynamic dispatching and run-time type inferencing. While it is possible to minimize the amount that these features are used, that usually comes at the cost of having code that is not very “Java like”. A common complaint with translators is that the resulting Java code is unreadable and unmaintainable, which defeats much of the purpose of the migration.

[Performance of Java Code Translated from COBOL, UniqueSoft](12)

Least you dismiss this issue with “Oh yes, but that’s Java and Java sucks too” remember this: most modern day programming languages do not have support for fixed point or decimal built in either. (Actually I think the correct statement is NONE of them do, but I couldn’t confidently verify that) You can pick a different language with a different combination of trade-offs, sure, but if you need the accuracy of fixed point and you think that the tiny performance cost of importing a library to do it might pile up you really only have one option and that’s COBOL.

That’s why so-called modernization is hard: it depends. Some organizations will realize game changing improvements from their investment, others will find that they forfeit valuable optimizations by switching systems in exchange for “improvements” that really aren’t all that special. When you are a major financial institution processing millions of transactions per second requiring decimal precision, it could actually be cheaper to train engineers in COBOL than pay extra in resources and performance to migrate to a more popular language. After all, popularity shifts over time.

So when considering why so much of our society still runs on COBOL, one needs to realize that the task of rebuilding an application is not the same as the task of building it. The original programmers had the luxury of gradual adoption. Applications tend to pushed out towards the limits of what their technologies can support. The dilemma with migrating COBOL is not that you are migrating from one language to another, but that you are migrating from one paradigm to another. The edges of Java or python on Linux have a different shape than the edges of COBOL on a mainframe. In some cases COBOL may have allowed the application to extend past what modern languages can support. For those cases COBOL running on a modern mainframe will actually be the cheaper, more performant and more accurate solution.

 [1]: https://www.cms.gov/

 [2]: https://medium.com/u/1c85b35a0c79

 [3]: https://systemswe.love/videos/life-of-an-airline-flight

 [4]: https://medium.com/@bellmar/the-land-before-binary-cc705d5bdd70

 [5]: https://medium.com/@bellmar/hello-world-on-z-os-a0ef31c1e87f

 [6]: https://en.wikipedia.org/wiki/Single-precision_floating-point_format

 [7]: https://www.exploringbinary.com/why-0-point-1-does-not-exist-in-floating-point/

 [8]: http://www.latkin.org/blog/2014/11/22/mullers-recurrence-roundoff-gone-wrong/

 [9]: https://hackaday.com/2015/10/22/an-improvement-to-floating-point-numbers/

 [10]: https://www3.nd.edu/~markst/cast-award-speech.pdf

 [11]: https://gist.github.com/hillmanli-seekers/a8ab8e463e7b60989e6d0c0900cf4d93

 [12]: https://www.uniquesoft.com/pdfs/UniqueSoft-Performance-Considerations-COBOL-to-Java.pdf


