---
layout: post
title: "how do you database?"
date: 2022-02-03 22:16:41 -0500
categories: [thoughts]
---

At my previous job, govtech/tax-tech, the database was just as important as the code. Now what do I mean by that? Mooney [explained it best](https://mooneyblog.mmdbsolutions.com/2010/03/23/why-your-database-version-control-strategy-sucks-and-what-to-do-about-it-part-i/) on this exact topic:

> Given how much thought and effort goes into source code control and change management at many of these same companies, it is confusing and a little unsettling that so much less progress has been made on the database change management front.  Many developers can give you a 15 minute explanation of their source code strategy, why they are doing certain things and referencing books and blog posts to support their approach, but when it comes to database changes it is usually just an ad-hoc system that has evolved over time and everyone is a little bit ashamed of it. 

I believe the quote above is true. Admittedly, I'm only a 1+ YOE software engineer, but having jumped ship from a govtech consultancy to a startup, I find there is a lot to compare between how databases is treated and how this leads to a better developer experience.

What follows is a series of features I found missing at my current place of work.

# 1. Version Control
Schemas have version control. The system detects any changes made to the schema (In fact, the company never taught you to alter tables with SQL) because you would make table structure changes through the system. Deleting/removing columns, adding or editing comments, addibg/editing indexes (and probably many more), local changes are "synced" with the shared work server, where it assigns a version number for your structure. Migrations from local to testing environments and then,  ultimately, to Prod, is simply having the environment point to the right version.