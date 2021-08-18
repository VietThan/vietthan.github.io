---
layout: post
title: "5 interview questions: C++, Area 2"
date: 2021-08-17 22:38:55 -0400
categories: [tech, interview]
---
<!--break-->
### Area Number Two: Object-Oriented Programming

> We shouldn't hire SDEs (arguably excepting college hires) who aren't at least somewhat proficient with OOP. I'm not claiming that OOP is good or bad; I'm just saying you have to know it, just like you have to know the things you can and can't do at an airport security checkpoint.
>
> Two reasons:
>
> 1) OO has been popular/mainstream for more than 20 years. Virtually every programming language supports OOP in some way. You can't work on a big code base without running into it.
>
> 2) OO concepts are an important building block for creating good service interfaces. They represent a shared understanding and a common vocabulary that are sometimes useful when talking about architecture.
> 
> So you have to ask candidates some OO stuff on the phone.

### a) Terminology

The candidate should be able to give satisfactory definitions for a random selection of the following terms:

> - class, object (and the difference between the two)

Class, as an analogy, is the blueprint/template for an object, while an object is an instance of the class (like a built house).

In C++, classes are simple: 

```c++
class cPoint
{
    public: 
        int X;
        int Y;
};
```

There is another holdover from time of C:

```c++
typedef struct
{
    int X;
    int Y;
} sPoint;
```
or just:

```c++
struct sPoint
{
    int X;
    int Y;
};
```

> instantiation

z`

> method (as opposed to, say, a C function)

> virtual method, pure virtual method

> class/static method

> static/class initializer

> constructor

> destructor/finalizer

> superclass or base class

> subclass or derived class

> inheritance

> encapsulation

> multiple inheritance (and give an example)

> delegation/forwarding

> composition/aggregation

> abstract class

> interface/protocol (and different from abstract class)

> method overriding

> method overloading (and difference from overriding)

> polymorphism (without resorting to examples)

> is-a versus has-a relationships (with examples)

> method signatures (what's included in one)

> method visibility (e.g. public/private/other)

These are just the bare basics of OO. Candidates should know this stuff cold. It's not even a complete list; it's just off the top of my head.

Again, I'm not advocating OOP, or saying anything about it, other than that it's ubiquitious so you have to know it. You can learn this stuff by reading a single book and writing a little code, so no SDE candidate (except maybe a brand-new college hire) can be excused for not knowing this stuff.

I draw a distinction between "knows it" and "is smart enough to learn it." Normally I allow people through for interviews if they've got a gap in their knowledge, as long as I think they're smart enough to make it up on the job.

But for these five areas, I expect candidates to know them. It's not just a matter of being smart enough to learn them. There's a certain amount of common sense involved; I can't imagine coming to interview at Amazon and not having brushed up on OOP, for example. But these areas are also so fundamental that they serve as real indicators of how the person will do on the job here.

b) OO Design

This is where most candidates fail with OO. They can recite the textbook definitions, and then go on to produce certifiably insane class designs for simple problems. For instance:

They may have Person multiple-inherit from Head, Body, Arm, and Leg.

They may have Car and Motorcycle inherit from Garage.

They may produce an elaborate class tree for Animals, and then declare an enum ("Lion = 1, Bear = 2", etc.) to represent the type of each animal.

They may have exactly one static instance of every class in their system.

(All these examples are from real candidates I've interviewed in the past 3 weeks.)

Candidates who've only studied the terminology without ever doing any OOP often don't really get it. When they go to produce classes or code, they don't understand the difference between a static member and an instance member, and they'll use them interchangeably.

Or they won't understand when to use a subclass versus an attribute or property, and they'll assert firmly that a car with a bumper sticker is a subclass of car. (Yep, 2 candidates have told me that in the last 2 weeks.)

Some don't understand that objects are supposed to know how to take care of themselves. They'll create a bunch of classes with nothing but data, getters, and setters (i.e., basically C structs), and some Manager classes that contain all the logic (i.e., basically C functions), and voila, they've implemented procedural programming perfectly using classes.

Or they won't understand the difference between a char*, an object, and an enum. Or they'll think polymorphism is the same as inheritance. Or they'll have any number of other fuzzy, weird conceptual errors, and their designs will be fuzzy and weird as well.

For the OO-design weeder question, have them describe:

What classes they would define.

What methods go in each class (including signatures).

What the class constructors are responsible for.

What data structures the class will have to maintain.

Whether any Design Patterns are applicable to this problem.

Here are some examples:

Design a deck of cards that can be used for different card game applications.

Likely classes: a Deck, a Card, a Hand, a Board, and possibly Rank and Suit. Drill down on who's responsible for creating new Decks, where they get shuffled, how you deal cards, etc. Do you need a different instance for every card in a casino in Vegas?

Model the Animal kingdom as a class system, for use in a Virtual Zoo program.

Possible sub-issues: do they know the animal kingdom at all? (I.e. common sense.) What properties and methods do they immediately think are the most important? Do they use abstract classes and/or interfaces to represent shared stuff? How do they handle the multiple-inheritance problem posed by, say, a tomato (fruit or veggie?), a sponge (animal or plant?), or a mule (donkey or horse?)

Create a class design to represent a filesystem.

Do they even know what a filesystem is, and what services it provides? Likely classes: Filesystem, Directory, File, Permission. What's their relationship? How do you differentiate between text and binary files, or do you need to? What about executable files? How do they model a Directory containing many files? Do they use a data structure for it? Which one, and what performance tradeoffs does it have?

Design an OO representation to model HTML.

How do they represent tags and content? What about containment relationships? Bonus points if they know that this has already been done a bunch of times, e.g. with DOM. But they still have to describe it.

The following commonly-asked OO design interview questions are probably too involved to be good phone-screen weeders:

Design a parking garage.

Design a bank of elevators in a skyscraper.

Model the monorail system at Disney World.

Design a restaurant-reservation system.

Design a hotel room-reservation system.

A good OO design question can test coding, design, domain knowledge, OO principles, and so on. A good weeder question should probably just target whether they know when to use subtypes, attributes, and containment.

