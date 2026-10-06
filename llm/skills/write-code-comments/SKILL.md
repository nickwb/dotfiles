---
name: write-code-comments
description: Use when adding or changing a comment or a doc-comment in code - for example when the user types /write-code-comments, asks to add, review, or tidy the comments in code, or when you are about to write a comment as part of a code change.
---

# Write code comments

## Overview

This skill gives guidance, and not a procedure. Use your judgement to apply it to the code in front
of you. When the repository has its own conventions for comments, those conventions take precedence.

Write each comment for one reader: an engineer who knows the language, and who reads the names and
the types in the code. This reader did not see the conversation that produced the code. The reader
does not know the steps you took, the approaches you tried, or the code as it was before your change.

## Rules

**Do not restate the code.** The reader can already read the code, so a comment that repeats it
doubles the reading and adds nothing. This comment adds nothing:

```
// Increment the retry count.
retryCount++;
```

**Prefer fewer comments.** Let the names and the types describe the code. When the code seems to need
a comment to say what it does, first try a better name or a smaller function.

**The effort of a change is not a reason for a comment.** You can need detailed reasoning to make a
change, and the result can still be clear code. The reader sees only the result.

**Write what the code cannot show.** For example: why the code does something, a constraint from
outside the code, an obvious approach that does not work, or behaviour that crosses the boundary of
a module or a sub-system. The reader cannot find these facts in the code. Here is one:

```
// The payments API rejects a second request with the same key for 24 hours,
// so a retry must send the key of the original request.
request.idempotencyKey = original.idempotencyKey;
```

**State a ground rule once, on the data model or the interface that owns it.** A ground rule is an
invariant or a contract that the rest of a module or a sub-system relies on. When it is stated once,
the reader knows where to find it, and other comments do not need to repeat it. For example:

```
// Amounts are in cents. A negative amount is a debit.
interface LedgerEntry {
    amount: int
}
```

**A doc-comment adds something beyond the name.** When the repository requires a doc-comment on a
member, the doc-comment must still tell the reader something that the name and the type do not.
For example: the unit, the system that issues a value, or what an empty value means. The first
doc-comment below only restates the name. The second one adds facts that the name does not show:

```
// Gets the customer ID.
customerId: string

// Issued by the core banking platform. Empty until the customer completes onboarding.
customerId: string
```

**Describe the code as it is, not how it came to be.** The reader does not know the code before your
change, or the conversation that changed it. The history of a change belongs in the commit message.
Do not write comments like these:

```
// Now uses the shared client instead of creating a new one.
// Fixed the race condition from the earlier attempt.
// As discussed, this must run before the cache is warm.
```

**Write a TODO comment only for follow-up work that the user agreed to defer.** The TODO says what is
missing. A TODO for work that you chose not to do records your unfinished thought in the code.

**A ticket reference supplements an explanation, and never replaces it.** The reader may not have the
ticket open, and the ticket may not exist in a few years.

**Keep every comment true, and keep its emphasis in proportion.** A wrong comment is worse than no
comment, because the reader trusts it over the code. A comment that stresses a minor detail sends the
reader in the wrong direction. When your change makes a nearby comment false, fix the comment.

**Tidy the comments on the lines that your change touches.** When such a comment breaks these rules,
remove it or rewrite it. Leave the other comments alone, so that the change stays focused.

**Match the density of the comments that add value.** The surrounding code shows how much its authors
explain, for example on a difficult block or on a private helper. Do not add a comment that restates
the code to match a file that has many of them. Doc-comments that the repository requires follow the
repository.

**Be concise, but not terse.** When there is a lot to say, use full sentences.

## Read it again

Before you finish, read each comment that you added or changed as the reader would. Ask whether the
code already says it, and whether it makes sense without this conversation. Delete the comments that
the reader would not miss.
