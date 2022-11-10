---
title: Introducing kcst
layout: post
excerpt: "Finally got around to putting the final touches on kcst, a sub-second bacterial genome typer."
---

Finally got around to getting [kcst](https://io.zwets.it/kcst) in publishable shape.

`kcst` predicts species and MLST for bacterial genome assemblies, and does it fast: it
takes less than a second for the average assembly.
`kcst` comes with `khc` (_k-mer hit counter_), a fast and accurate tool to compute
sequence similarity between a query sequence and a set of subject sequences.

Homepage is here: <https://io.zwets.it/kcst>, and [here is the code](https://github.com/zwets/kcst).

