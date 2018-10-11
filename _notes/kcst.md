---
title: kcst - K-mer counting sequence typer
excerpt: "Sub-second species prediction and MLST typing for bacterial genome assemblies"
published: true
ignore: { permalink }
---

Kcst uses k-mer counting (k-mer mapping, really) to perform multi-locus sequence typing (MLST) of bacterial genomes.  It does not employ a separate species prediction step, but instead maps the query genome on all MLST alleles of all species at once.  It then picks the loci that were best covered, and looks up the sequence type(s) corresponding to the top allele combination(s).

Despite mapping on all loci of all species , `kcst` is very fast.  It typically takes less than a second to type a genome.  Clearly, `kcst` will only type species for which an MLST scheme exists.  However nothing prevents you from adding other loci to its database.  In fact, `kcst` is not limited to MLST: the loci could equally well be resistance genes or other genotypic features.  Note however that k-mer mapping is optimal for 'crisp' matching, and won't perform as well when the subject sequences allow for many mismatches.  (See [below](#how-come-it-is-so-fast).)


### How it works

`kcst` uses the core functionality of `khc`.  `khc`, for _k-mer hit counter_ maps the k-mers from one or more query sequences on any number of subject sequences.  It tracks which locations on the subject sequences are hit by (i.e. exactly match) a k-mer from the query, and outputs for each subject sequence its coverage percentage.  In the case of MLST the subject sequences are the alleles of the MLST loci.  `kcst` collects the output of `khc` and uses it look up the best matching profile(s) in the MLST tables.


### How come it is so fast

The reasons are both in the nature of the problem, and in the design choices for the implementation.

First off, note that k-mer mapping is based on 'crisp' matching: two k-mers are either identical or not.  We don't care about degrees of similarity between k-mers.  So, for any k-mer from the query, we need only determine where on the subjects that _exact_ k-mer occurs.  We then 'mark' these locations as being hit, which eventually gives us the coverage per subject sequence.  This is a lookup problem, not a matching problem, and can therefore theoretically be done in constant time.  That is, once an index has been built, computation depends neither on subject size nor k-mer size, and goes up (at most) linearly with query size.

Now, MLST, contrary to most other matching problems in genomics, is all about exact matching.  A genome is defined to have a specific ST only if the alleles at its MLST loci are _exact_ matches with the alleles in the MLST profile.  This means that we only need to check that every k-mer on the profile is hit by a k-mer from the query (under the proviso that smaller k-mer sizes tend to give more spurious hits), which is precisely what `khc` does.  This is not to say that `kcst` does not detect 'close-to-ST' situations (it does, as it has the coverage percentages for every MLST allele), just that it doesn't expend compute time looking for them.

On the implementation side, `khc` approaches the theoretic optimum of having _O_(1) lookup time per kmer, and hence _O_(n) run time, _n_ being query size[^1].  It does this at the expense of memory consumption, which goes up _O_(4^k) with k-mer size, as `khc` uses a lookup table indexed by integer-encoded k-mers.[^2]  When k-size would cause excession of the configurable memory consumption limit (default: all physical memory minus 2GB), `khc` switches to an _O_(n⋅k) run time implementation (using a red-black tree).  K-mers are always encoded as integers (reversibly, no hashing), which means that the maximum k-mer size is 31 for current CPUs.


### Where to get it

The code for `kcst` is [hosted on GitHub](https://github.com/zwets/kcst).  When you use it in your research, kindly cite <http://io.zwets.it/kcst>.


##### Footnotes

[^1]: The analysis assumes that the subjects fill a relatively small fraction of k-mer space, and that most of their k-mers are specific (do not occur "all over the place"), so that most k-mers from the query do not hit a subject, and the subject size has negligible effect.  For k-mers that do hit subjects, lookup time of each subject location (to 'tally' the hit) is _O_(1), so computation is still roughly bound by _O_(m), where _m_ is subject size.

[^2]: A kmer is encoded as a (2k-1)-bit integer, which means that at k=15, the table has 2^29 entries.  An entry (being the list of subject locations where the k-mer occurs) is 24 bytes, meaning that memory consumption (at k=15) is 12G.  This could be reduced to 4G at the cost of a little performance (by using an indirection), or even to 2G (at the additional cost of limiting the number of distinct k-mers allowed in the subjects).  However, note that every next k-size up (k=17)[^3] consumes 16 times more memory, making this not worth it given current workstation sizes (16-32G).

[^3]: The k-mer size must be odd so that there is an encoding that uniquely represents both the forward and reverse strands of the k-mer.  We pick this to be the bit-representation (with a=00, c=01, g=10, t=11) of whichever of the two strands happens to have 'a' or 'c' as its middle base.  This also explains why the integer representation has 2k*-1* bits: the centre base requires only a single bit in the encoding.

