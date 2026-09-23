---
name: write-tech-docs
description: Use when writing or revising technical documentation - for example when the user types /write-tech-docs, or asks for a README, a design document, an analysis, a runbook, a guide, or other prose that explains a technical subject to engineers.
---

# Write technical documents

## Overview

This skill gives guidance, and not a procedure. Use your judgement to apply it to the document in
front of you. When the repository has its own style guide, that guide takes precedence.

The goal is a document that the reader understands on the first read. A place where the reader must
stop, read a sentence again, or search for an explanation is a defect.

## The reader

Unless the user names a different reader, write for a junior software engineer. This reader knows the
fundamentals, for example HTTP, a database, a queue, a unit test, or a pull request. Refer to these
ideas by name, and do not explain them.

Explain the concepts that are specific to the subject, for example the team's own systems and the
decisions that the team made.

## Plain words

Write mostly in ASD Simplified Technical English (ASD-STE100): short sentences and the active voice.
Do not let its dictionary or its tense rules make a sentence awkward.

Give each thing one name, and use that name every time. Do not change a word for variety.

Avoid jargon. Use a technical term only when it is more exact than plain words. Define it the first
time that you use it, unless the reader knows it already.

Explain a difficult concept in simple sentences, as you would say it aloud to a colleague. A concrete
example often explains a concept faster than a definition.

## One concept at a time

A document tells a story. Usually the story starts with the background and the motivation. Then it
moves through the intermediate steps, and it ends with the outcome.

Introduce one concept at a time, and introduce each concept before any other part of the document
relies on it.

## References

A reference to a concept points backwards, to the place that introduced it. Add one only when it
helps the reader unpack a complex design. Do not add an obvious reference, for example to a concept
from the previous paragraph.

A reference to detail can point forwards, for example "the appendix lists every field". The reader
can continue without the detail.

## Say it once

Plain words do not mean more words. When two sentences next to each other say almost the same thing,
keep the better one.

## Not too dense

Keep paragraphs short, but not dense. When a paragraph holds too many concepts, split it. When the
reader must stop to unpack a sentence, add back the words that they need.
