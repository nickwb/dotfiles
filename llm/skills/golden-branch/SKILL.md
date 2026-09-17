---
name: golden-branch
description: Use when the commits on a branch must be made clean and reviewable before a pull request - for example when the user types /golden-branch, or asks to tidy, split, combine, re-order or re-word the commit history of a branch, or wants every commit on a branch to build and pass its tests.
---

# Golden Branch

## Overview

A golden branch is a branch that a reviewer reads one commit at a time. Each commit tells one small
part of the story. The branch adds to the upstream branch in a straight line.

This skill makes a branch golden. It rewrites the history of the branch. The work has two parts.
First you write a plan. Then you rebuild the commits from that plan.

**Do not change the history before the user approves the plan.**

## Scope

The _scope_ is the set of commits that you rewrite. It is the whole branch, or a continuous range of
commits in the branch. Step 1 agrees the scope with the user, and the six properties below apply only
to the commits in the scope.

The commit before the oldest commit in the scope is the _base commit_. You rebuild the scope on top
of the base commit.

## This skill does not review the code

The user has already read the changes and accepts them. Your work is to compose and to sequence the
commits, not to judge whether a change is correct. Do not remove a change, and do not correct a
change, unless the user asks you. The final content of the branch must not move.

## The six properties

A golden branch has these six properties. Use them to make every decision.

1. **The branch merges in a straight line.** Rebase the branch on the upstream branch. The pull
   request then merges with a fast-forward.
2. **Every commit builds, and every commit passes the tests.** Test each commit in scope. Do not
   run the tests only on the final commit.
3. **Every commit is small.** One commit advances one idea, repairs one fault, or completes one
   chore. Put a new or a changed test in the same commit as the code that the test examines.
4. **Independent commits come first.** A commit is independent when no other commit needs it. Put
   these commits at the start of the scope. A person can then remove them, and the commits that
   follow stay correct. Do not write this fact in the commit message. Write it in the plan.
5. **No commit contains work that a later commit in the scope replaces.** For example, a repair that
   did not correct the fault, or a design that a later commit changes. A small stub is permitted when
   a later commit completes it. Keep this rare.

   This property tells you how to compose and how to sequence the commits inside the scope. It does
   not tell you that a change is wrong. Do not compare changes to commits outside the scope. This
   is not a code review.

6. **Every commit message is short, and uses the conventional commits format.** For example:
   `fix(AccountCache): refresh the config on each call`. Look at `git log --oneline` for the
   repository, and copy the style of the scope names that it already uses. The subject line is the
   most important part. A body is permitted, but it is not necessary when the subject says enough.
   Do not put notes about the implementation in the body.

## Process

Make one to-do item for each of the twelve steps.

### Step 1 - Agree on the scope

How many commits are on this branch? Run `git log --oneline {UPSTREAM}..HEAD` first.

- **One commit.** There is no choice to make. Tell the user that the scope is that commit, and
  continue.
- **More than one commit.** Ask the user one question. Do you rewrite all of these commits, or only
  some of them? Wait for the answer. Do not guess.

A subset must be a continuous range of commits. The parent of the oldest commit in the range is the
base commit. For the whole branch, the base commit is the tip of the upstream branch.

### Step 2 - Look for uncommitted changes

Run `git status --short`. If the branch has uncommitted changes, stop. Tell the user. Ask the user to
commit the changes, or to remove them. Do not put the changes in a stash yourself. Continue only when
the working tree is clean.

### Step 3 - Find the build command and the test command

You must build and test each new commit, so you need these two commands first.

Read the repository to find them. Look in `CLAUDE.md`, `AGENTS.md`, `README.md`, `package.json`,
`justfile`, `Makefile`, and the project files. Show the two commands to the user. Ask the user to
confirm them.

Then run both commands one time. They must pass before you change anything. If they fail, tell the
user and stop.

### Step 4 - Make the rebase backup branch

Make a backup branch before you rebase. The old history is then safe if the rebase goes wrong:

```
git branch backup/{BRANCH_NAME}-{YYYYMMDD-HHMMSS}-before-rebase
```

This branch is the _rebase backup_. Do not push it.

### Step 5 - Rebase on the upstream branch

Write down the sha of HEAD before the rebase: `git rev-parse HEAD`.

Run `git fro`. This command fetches the upstream branch, and then rebases the current branch against
it. `git fro` uses `git frebase` internally, which may make its own backup branch. If it does, ensure
it is also reported in step 12.

If a conflict stops the rebase, ask the user for help. Do not continue with a rebase that is not
complete.

Read the sha of HEAD again. Compare it with the sha that you wrote down:

- **The two shas are the same.** The rebase did nothing, because the upstream branch has no new work.
  The rebase backup holds the same commit as HEAD, so delete it now:

  ```
  git branch -d backup/{BRANCH_NAME}-{YYYYMMDD-HHMMSS}-before-rebase
  ```

  Step 12 then tells the user that the branch includes no upstream changes.

  If the two shas are the same, skip step 6, continue directly to step 7.

- **The two shas are different.** The rebase moved the branch onto new upstream work. Keep the rebase
  backup, because it is the only copy of the branch from before the rebase. Step 12 gives its name to
  the user.

### Step 6 - Build and test the rebased branch

A rebase can join two changes that do not conflict and still make code that does not work.

Run the build command and the test command again.

- **Both commands pass.** Continue to step 7.
- **Either command fails.** Find the smallest repair. Tell the user what broke, what the repair is,
  and that the repair becomes an entry in Section C of the plan, because the rebuilt branch will then
  differ from the rewrite backup. Do not make the repair yet. It belongs to the commit that needs it.

### Step 7 - Write the plan

Write the plan in a directory outside the repository. The plan is not part of the branch, so it must
not go into the working tree. Use this path:

```
/tmp/golden/{REPO_NAME}/{YYYYMMDD-HHMMSS}_{SHORT_HEAD_SHA}/GOLDEN.md
```

Collect the data with `git log --oneline {BASE}..HEAD`, `git diff {BASE} HEAD`, and `git show` for
each commit. Then write the plan in the structure that the next section gives.

### Step 8 - Ask the user to review the plan

Give the user the full path of the plan. Offer to run the `/crit` skill, which puts inline comments
on the plan and collects the user's feedback. The user decides.

Wait for the approval. Do not change the history in this step.

### Step 9 - Make the rewrite backup branch

```
git branch backup/{BRANCH_NAME}-{YYYYMMDD-HHMMSS}-before-rewrite
```

This branch is the _rewrite backup_. It is the only copy of the history from before the rewrite, and
steps 10 and 11 read from it. Do not push it.

### Step 10 - Rebuild the commits, one at a time

Build the new history on a temporary branch. The original branch then keeps its old commits until the
user decides to move it:

```
git checkout -b golden/{BRANCH_NAME} {BASE}
```

Then do these five things for each row of Section B, in the order of the table:

1. If the plan marks the commit as preserved, run `git cherry-pick {SHA}`. Then go to item 4.
2. Put the content of the commit into the working tree:
   - For a complete file: `git checkout {REWRITE_BACKUP} -- {PATH}`
   - For a part of a file: write the patch with
     `git diff {BASE} {REWRITE_BACKUP} -- {PATH} > {PLAN_DIR}/{NN}.patch`, remove the chunks that
     belong to other commits, then run `git apply --check` and `git apply`.
   - For a file that the branch deletes: `git rm {PATH}`
3. Stage only the files of this commit. Then commit with the message from the plan.
4. Run the build command. Run the test command.
5. If the build or the test fails, go to "When a commit fails".

If the user selected a subset in step 1, the newer commits are still in the rewrite backup. Put them
back with `git cherry-pick {OLD_RANGE_TIP}..{REWRITE_BACKUP}`. Build and test each of these commits
also.

#### Take the whole file when you can

A commit often brings a file to its final content. Copy the final file in that case, with
`git checkout {REWRITE_BACKUP} -- {PATH}`. A patch is only for a file that several commits share.

#### Line endings

One repository can hold files with `\r\n` and files with `\n`. Read the file first and count both,
so that you know what the file uses.

Read and write patch content as **bytes**. A tool that reads the patch as text can change `\r\n` to
`\n` and give no warning. The commit then differs from the rewrite backup on every line that you
touched, the difference is invisible on the screen, and step 11 is the first place that you see it.

### Step 11 - Compare the new branch with the rewrite backup

```
git diff {REWRITE_BACKUP} {TEMP_BRANCH}
```

The result must be empty. An empty result shows that you changed the history and not the code.

If the result is not empty, read Section C of the plan. The plan must describe each difference, and
the user must agree to it.

A difference that is not in Section C has one of two causes. Find out which one before you act:

- **The plan is wrong.** The plan puts a chunk in no commit, or in two commits. Go back to step 7 and
  correct the plan with the user.
- **The plan is correct, and you made a mistake when you built a commit.** For example, you used the
  wrong line endings, or you put a chunk in the wrong commit.

When only your work is wrong, you do not need to start again. Find each commit that holds an error
and correct it. Then build and test **every commit from the first correction to the last commit in
the branch**. A correction changes the commits that follow it, so the results that you recorded
before are no longer proof. Then run the comparison again.

### Step 12 - Report the result

Give the user these five things:

1. The full path of the plan file, and an offer to delete it.
2. The name of the temporary branch, and the command that moves the original branch onto it:

   ```
   git switch {BRANCH_NAME} && git reset --hard {TEMP_BRANCH}
   ```

   The user runs this command. Do not run it yourself, because it discards the old commits from the
   original branch.

3. The name of the rewrite backup branch.
4. What step 5 found:
   - If you kept the rebase backup, give its name also. Tell the user that the branch now includes
     new work from the upstream branch.
   - If you deleted the rebase backup, tell the user that the branch includes no upstream changes.
5. The name of every other branch that starts with `backup/`, because `git frebase` may have made one
   of its own.

Tell the user that they can delete the backup branches and the temporary branch when they are
satisfied. The next step belongs to the user. Do not open a pull request, and do not push the branch,
unless the user asks you.

## When a commit fails

A commit that does not build, or that does not pass the tests, shows that the plan is wrong. It does
not show that the commit needs a small repair.

1. Stop. Do not make another commit.
2. Tell the user which commit failed, and show the error. The temporary branch holds the failure, and
   the rewrite backup still holds the old history, so nothing is lost.
3. Correct the plan with the user.
4. Get the approval again. Then delete the temporary branch and start step 10 again.

## The plan

The plan divides the scope into the parts that can become commits. Section A finds the smallest
parts. Section B joins them into commits. Section C records the differences that the final comparison
will show.

A _chunk_ is a group of lines in one file that changes together.

```md
# Section A - Change Analysis

## Theme #1: {short summary of the theme}

### Change #1.1: {short summary of the change}

{Two to four sentences. Describe the effect on the operation of the system, the effect on the design,
and the effect on the people who use it. Do not describe small details of the implementation.}

| File              | Lines | Change                           |
| ----------------- | ----- | -------------------------------- |
| `path/to/file.ts` | 10-42 | {terse description of the chunk} |

#### Dependency Notes

{List each other change that must come first. Name the symbols and the other items that the earlier
commits must supply. Write "None" when nothing blocks this change.}

# Section B - Commit List

| #   | Commit message                             | Changes  | Independent | Preserve  |
| --- | ------------------------------------------ | -------- | ----------- | --------- |
| 1   | `chore(build): remove the unused task`     | 2.1      | yes         | `a1b2c3d` |
| 2   | `feat(StatusApi): add the status endpoint` | 1.1, 1.2 | no          | no        |

# Section C - Expected Deviations

{List each difference that step 11 will show, and the reason for it. Write "None" when you expect no
difference.}
```

### Rules for Section A

- A theme groups related changes. The plan has one or more themes. Each theme has one or more
  changes.
- A change is the smallest step that is possible. Do not ask if a change is a good commit on its own.
  Section B answers that question.
- The changes to one file do not always belong to one change. Divide a file when the division gives a
  better result.
- The table must list every chunk of the scope. Leave nothing out.

### Rules for Section B

- The rows are in the order in which you will apply the commits.
- The independent commits come first.
- Each change id from Section A is in exactly one row.
- The `Preserve` column holds the sha of an old commit that is good enough to keep without a change.
  Keep such a commit with `git cherry-pick`. Keep it only when no later commit changes its lines.
  Write `no` for the other rows.

## Stop signals

Each of these thoughts is a signal to stop:

| Thought                                                                 | Do this                                               |
| ----------------------------------------------------------------------- | ----------------------------------------------------- |
| "The user will approve the plan, so I can start now."                   | Wait for the approval.                                |
| "This commit does not build, but the next commit repairs it."           | The plan is wrong. Correct the plan.                  |
| "The tests are slow, so I will test the last commit only."              | Test every commit.                                    |
| "The difference from the rewrite backup is small, so I will accept it." | Put every difference in Section C first.              |
| "There are uncommitted changes, but I can keep them for later."         | Stop. Ask the user.                                   |
| "This split is difficult, so I will make one large commit."             | A difficult split shows that the plan is wrong.       |
| "This change looks wrong, so I will correct it."                        | The user accepted the code. Only the history changes. |
| "I corrected one commit, so the commits after it are still good."       | Build and test all of them again.                     |
| "The branch is ready, so I will move it and open the pull request."     | Stop. The user decides.                               |

## Common mistakes

| Mistake                                              | Correction                                                                      |
| ---------------------------------------------------- | ------------------------------------------------------------------------------- |
| You put the test in a later commit than the code.    | The test goes in the commit that adds or changes the code.                      |
| You improve the code during the rewrite.             | The final content must not change. Only the history changes.                    |
| You rewrite a commit that was already good.          | Keep it with `git cherry-pick`, and record the sha in Section B.                |
| You write the plan inside the repository.            | The plan goes in `/tmp/golden/...`, outside the working tree.                   |
| You build a patch by hand for a whole-file change.   | Copy the final file with `git checkout`.                                        |
| A patch tool reads `\r\n` as text and writes `\n`.   | Read and write patch content as bytes.                                          |
| You move the original branch yourself.               | Give the user the command. The reset discards their commits.                    |
| You delete a backup branch.                          | Only the user deletes a backup branch. Step 5 is the one exception.             |
| Git reports changes that are not there, on `/mnt/c`. | This is the stale attribute cache. Run the command again, or use `git frebase`. |
