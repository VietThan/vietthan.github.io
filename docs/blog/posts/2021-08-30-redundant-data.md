---
layout: post
title: "redundant data"
date: 2021-08-30 21:54:55
categories: [tech]
---

> A clever extension of this idea was introduced in C-Store and adopted in the commercial data warehouse Vertica. Different queries benefit from different sort orders, so why not store the same data sorted in several different ways? Data needs to be replicated to multiple machines anyway, so that you don’t lose data if one machine fails. You might as well store that redundant data sorted in different ways so that when you’re processing a query, you can use the version that best fits the query pattern.
> - Martin Klepmann, _Design Data-Intensive Applications_

<!--break-->

PS: also [TiKV has a very good summary of B-Tree vs LSM-Tree](https://tikv.github.io/deep-dive-tikv/key-value-engine/B-Tree-vs-Log-Structured-Merge-Tree.html)
