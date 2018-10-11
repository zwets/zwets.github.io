---
title: Introducing kcst
layout: post
excerpt: "Finally got around to putting the final touches on kcst, a sub-second bacterial genome typer."
---

Finally got around to getting [kcst](http://io.zwets.it/kcst) in publishable shape.

Kcst predicts species and MLST for bacterial genome assemblies, and does this
within a second for the average assembly.  It comes with `khc` (k-mer hit counter),
a very fast and accurate tool to compute sequence similarity between a query sequence
and a set of subject sequences.

Its homepage is here: http://io.zwets.it/kcst, and [here is its source code](https://github.com/zwets/kcst).

