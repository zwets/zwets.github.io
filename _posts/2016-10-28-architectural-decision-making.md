---
title: Architectural Decision Making
layout: post
excerpt: "Taking the conflict out of the architectural decision making process."
published: true
---

When working as an enterprise architect, I used to profess that optimal
decisions in IT do not exist.  There are as many independent valuations of
a solution as there are stakeholders in the decision.  Stakeholders take
viewpoints, and each viewpoint defines a different set of priorities in
terms of which alternatives are evaluated.

But this doesn't at all mean that architectural considerations become a
matter of taste, and the subject of endless debate[^1].  In my experience,
a very productive approach to architectural decision making is to split
the discussion into two decoupled levels: evidence and utility.  I have
successfully used this method in workshops to achieve broadly supported
architectural decisions, even in polarised environments.

#### Evidence 

On the evidence level, the goal is to establish agreed-upon objective
conclusions based on evidence.  E.g.: "alternative A takes X less time to
build, whereas B is Y times more reliable".  The quantities X and Y
needn't be exact, but must be supported by evidence and be uncontested by
any party.

Any argument which cannot (in principle) be substantiated by facts is
disallowed in this phase.  For instance, a statement "alternative C is
better because it follows service-oriented principles" is tabled until
"better" is quantified, and the service-oriented principles are qualified.

This phase turns out to be both valuable and enjoyable for participants.
It is all about engineering, and everyone is working together toward a
shared goal, namely to establish measurable, objective truths.  Almost
as a side effect, a lot of insight is gained that will be useful for the
eventual design of the solution.

#### Utility

On the "utility" level, the goal is to elicit viewpoints potentially held
by stakeholders, and the probable valuation of the alternatives given
their frames of reference (objectives, constraints, priorities).  In
decision theory this would be called determining the utility functions.
Sideline: in very complex decision processes,
[probabilistic graphical modeling](https://www.coursera.org/learn/probabilistic-graphical-models-2-inference)
may be a useful tool.

Again, the discussion is not about deciding the optimal alternative, or
what is the superior viewpoint.  The goal is to make all valid viewpoints
explicit, so as to understand how alternatives are rated differently by
different people.  Participants are expected to not argue only for their
own view, but also to come up with the reasoning of other stakeholders.

It is especially during this phase that differences between (potentially
warring) factions are resolved.  They might not sway their opinion just
yet, but gaining an understanding of where other people "are coming from",
and realising one's own biases are much more important benefits.
In fact, even when the goal of this phase is not to obtain consensus, it
tends to bring parties much closer together.

#### Decision

It would seem that the above activities, however pleasant they may have
been, haven't brought us further.  At the end of the analysis we have
collected objective facts and a shared understanding of the different
valuations, but what is the decision going to be?

Clearly, the decision must be made by the person with the responsibility
and authority to do this.  That person's viewpoint will be known at this
point (or else a major stakeholder was overlooked in the previous phase),
but this does not mean that his/her viewpoint necessarily determines the
outcome.  It 'behooves' the decision taker, now that all viewpoints are
known, to consider these in making 'the right decision'.

What is interesting is that during the process, the single decision maker
becomes less relevant.  From the shared understanding of the knowledge that
has been gained in the process, and from the (intuitive) knowledge that
people have about the distribution of influence within the organisation,
most people present in the second workshop will already know what the
outcome must be.  Not only that, they will also better _understand_ the
outcome, even if it was not their (a priori) preference.

In that sense, there ís an optimum outcome of architectural decisions:
it is the one which is maximally evidence-based, and creates the most
shared understanding of the outcome.

### Credits

The above is not just theory.  I was positively surprised by its results
(and the fun had and insights gained by all participants) when I first
trialed it at a client where I was consulting.  It is also a great way for
people to learn to "think as an architect".  I later repeated and refined
the method, but then 
[left architecture consulting for genomics](http://io.zwets.it/about/), 
and was recently reminded that I should document this _somewhere_.  Hence
this post.

The seeds for these ideas came from an obscure but well-researched and
thought-out Ph.D. thesis that I stumbled upon when searching for a _tool_
for documenting architectural decisions.  The thesis [citation needed] 
had been written by [citation needed] during an internship at IBM
(Vienna?).  The tool itself never made it to deployment, as it was a 700MB
download which included a full unreleased version of WebSphere Server 
which I couldn't get to work. :)

---

[^1] I don't remember who coined it, but I love the proposed collective noun (as in: "a pride of lions" and "a flock of seagulls") for architects: an _argument_ of architects.

