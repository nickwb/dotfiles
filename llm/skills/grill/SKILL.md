---
name: grill
description: Use when the user wants to stress-test a plan, a decision, or an idea before they commit to it - for example when the user types /grill, or asks to be grilled, challenged, interrogated, or pushed on their thinking, or wants the holes in a design found before the work starts.
---

# Grill

## Overview

You interview the user about one subject. You continue until you and the user share one understanding
of it. Then you stop.

This skill does two things at the same time. It finds the decisions that nobody has made yet. It also
attacks the answers that the user gives you. A grill is not a survey.

**Do not start the work that the subject describes.** The user decides what comes next.

## When not to use this skill

Do not grill a subject that holds no decisions. A defect with one cause, or a task with one path,
needs work and not questions.

## The subject

The _subject_ is the plan, the decision, or the idea that the user brings to you. It is one subject,
and not several. Agree the subject with the user before you ask anything else.

## A decision

A _decision_ is one choice about the subject. A decision has two or more possible answers, and the
answers lead to different work.

A question with one correct answer is not a decision. It is a fact. The section "Facts are your work"
tells you what to do with a fact.

## The design tree

Decisions are not independent. One decision opens the decisions below it. A choice of database opens
a choice of schema. The opposite is not true.

The _design tree_ holds this structure. The subject is the root. Each decision hangs from the
decision that opens it. You hold the tree in your head, and you grow it after each round.

## Settled

A decision is _settled_ when two things are true. The user gave an answer. The answer survived your
challenge.

An answer on its own does not settle a decision. Step 6 tells you when to challenge an answer.

## The frontier

The _frontier_ is the set of decisions that you can ask now. A decision is on the frontier when every
decision above it is settled.

A decision that waits on an answer from this round is not on the frontier. It belongs to a later
round. Do not ask a question when you must first guess the answer to an earlier question.

## A round

A _round_ is one message that asks the whole frontier. You ask all of it, and then you wait. Do not
ask one question at a time, and do not split one frontier across two messages.

The frontier is sometimes wide. A wide round is correct. It shows that many decisions are independent
of each other.

## Process

Make one to-do item for each of the nine steps. Steps 3 to 7 repeat.

### Step 1 - Agree the subject

Tell the user what you understand the subject to be. Use two or three sentences. Ask the user to
confirm it, or to correct it.

A subject that holds several subjects gives a tree that never closes. Ask the user to choose one.

### Step 2 - Plant the tree

Write down the decisions that the subject opens directly. These are the children of the root.

Do not write the whole tree now. You cannot know the deep decisions before you hear the shallow
answers. Three to eight children is usual.

### Step 3 - Compute the frontier

Read the tree. Collect every decision whose parents are all settled. This set is the frontier.

An empty frontier sends you to step 8. A frontier with decisions in it sends you to step 4.

### Step 4 - Send a sub-agent for each fact

A frontier question sometimes needs a fact from the environment. For example, the name of a file, the
version of a package, or the behaviour of a library.

Do not ask the user for that fact. Send a sub-agent to find it. Give the sub-agent the smallest task
that answers the question, and use the smallest model that can do the work.

A sub-agent that still runs is an unsettled parent. Only the questions below it wait. Ask the rest of
the frontier now, in this round.

### Step 5 - Ask the round

Give every question a number and a short title. Give every question your recommended answer.

The recommendation is not optional. It shows the user what you think, and it gives the user something
to push against. A question with no recommendation wastes a round.

Use this format:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Then wait. Do not answer your own questions. Do not continue to step 6 before the user replies.

### Step 6 - Challenge the weak answers

Read each answer. An answer is weak when one of the rows below describes it.

| Weakness                                              | What you say                                                       |
| ----------------------------------------------------- | ------------------------------------------------------------------ |
| The answer does not choose. It repeats the options.   | Name the choice that the answer avoids. Ask for it.                |
| The answer rests on a fact that nobody checked.       | Name the fact. Send a sub-agent. Then ask the question again.      |
| The answer contradicts a settled decision.            | Show both answers. Ask the user which one changes.                 |
| The answer replies to a different question.           | Ask the question again, in fewer words.                            |
| The answer is correct, but somebody pays for it.      | Name the person or the system that pays. Ask if that is acceptable. |

Put the challenges at the top of your next message, above the new round. A challenged decision stays
on the frontier, so the decisions below it stay closed.

Challenge the answer, and not the user. Make one challenge for each weak answer. Do not repeat a
challenge that the user already answered.

### Step 7 - Grow the tree

Each settled decision does two things. It closes its own question, and it opens the decisions below
it. Some of those decisions did not exist before you heard the answer.

Add the new decisions to the tree. Then return to step 3.

### Step 8 - Run the devil's-advocate pass

An empty frontier does not mean that the design is good. It means that you asked every question that
you thought of.

Now attack the design as one whole. Put these four attacks to the user in one message.

1. **The load-bearing assumption.** Find the assumption that the most decisions rest on. Tell the
   user what breaks when it is false.
2. **The one-way door.** Find the decision that is the most expensive to reverse. Tell the user the
   cost of the reversal.
3. **The loser.** Name the person, the team, or the system that the design makes worse. Say how.
4. **The failure.** Describe one realistic situation in which the design fails completely.

An attack that lands re-opens a decision. Put that decision back on the tree, and return to step 3.
An attack that the user answers is finished. Do not repeat it.

### Step 9 - Offer the record, then stop

Tell the user that the frontier is empty and that the devil's-advocate pass is complete.

Then offer to write the _record_. The record is a markdown file in the working repository. It holds
the subject, each settled decision with its answer and the reason for it, and the attacks that the
design survived. The user decides whether you write it.

If you write the record, offer to run the `/crit` skill on it. The user decides.

Then stop. Do not plan the work, and do not write the code. The next step belongs to the user.

## Facts are your work, decisions are the user's

Sort every question into one of two kinds before you ask it.

A **fact** has one correct answer, and the environment holds it. The file system, the repository, the
documentation, and the tools hold facts. Find every fact yourself. A question to the user about a
fact is a fault.

A **decision** has several possible answers, and a person must choose between them. Put every
decision to the user, and wait for the answer. A decision that you make yourself is also a fault.

When you are not sure, look first. If the search gives one answer, it was a fact. If the search gives
a list of options, it was a decision.

## Stop signals

Each of these thoughts is a signal to stop:

| Thought                                                       | Do this                                                |
| ------------------------------------------------------------- | ------------------------------------------------------ |
| "The frontier is large, so I will ask the best three."        | Ask all of them. A wide round is correct.              |
| "I can guess the answer to Q1, so I will also ask Q4 now."    | Q4 belongs to the next round. Wait for the answer.     |
| "The user is busy, so I will let this weak answer pass."      | Challenge it. An unchallenged answer is not settled.   |
| "The user answered, so the decision is settled."              | It is settled after it survives your challenge.        |
| "I do not know this file name, so I will ask the user."       | It is a fact. Send a sub-agent.                        |
| "The sub-agent still runs, so I will wait before the round."  | Ask the rest of the frontier now.                      |
| "This question has no good recommendation."                   | Give your best one. The user needs something to hit.   |
| "The frontier is empty, so the design is good."               | Run the devil's-advocate pass first.                   |
| "We agree, so I will start the work."                         | Stop. The user decides the next step.                  |

## Common mistakes

| Mistake                                              | Correction                                        |
| ---------------------------------------------------- | ------------------------------------------------- |
| You ask one question for each message.               | Ask the whole frontier in one round.              |
| You ask a question that depends on an open question. | Move it to a later round.                         |
| You leave out the recommendation.                    | Every question carries a recommendation.          |
| You accept a vague answer to keep the pace.          | A vague answer is a weak answer. Challenge it.    |
| You challenge the same answer twice.                 | One challenge for each answer. Then accept it.    |
| You ask the user for a fact.                         | Send a sub-agent.                                 |
| You settle a decision yourself to save a round.      | The decision belongs to the user.                 |
| You stop at the empty frontier.                      | The devil's-advocate pass comes after it.         |
| You write the record without an offer.               | Ask the user first.                               |
| You start the work after the last answer.            | Stop and hand back.                               |
