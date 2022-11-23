+++
title = "How to setup LOGBOOK automation in org-mode"
author = ["Narice"]
description = "This is a must for ox-hugo's timestamp generation! (creation & last modified)"
date = 2022-11-19T01:20:00+01:00
lastmod = 2022-11-23T19:51:00+01:00
tags = ["emacs", "org", "til", "ox-hugo"]
draft = false
creator = "Emacs 29.0.50 (Org mode 9.6 + ox-hugo)"
+++

## Introduction {#introduction}

Using the `LOGBOOK` drawer is super simple and very useful for time logging.
It is even automated by `org-mode` if setup correctly!
I (re)discovered this feature of `org` when setting up this blog.
Here is the blogging system that I'm using: `org-mode` + `ox-hugo` + `hugo`.

`ox-hugo` is a very powerful tool for exporting an `org` file (or a bunch of them) to markdown files usable by `hugo` while retaining all the functionalities of `org-mode`.
It also adds automation for certain tasks, such as taking care of generating the timestamps for the creation and last modification of articles.
This is super useful!

Even though I've set the `LOGBOOK` up for that purpose, with the following explanations, you will most likely be able to do whatever you want with `LOGBOOK` drawers :grin:.


## The `LOGBOOK` drawer and `TODO` states {#the-logbook-drawer-and-todo-states}

For understanding how this system works, we first have to look at `TODO` states and the variable that allows you to change them.

Here is some code that you can place in your `config.el` file:

```elisp
(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE")))
```

It sets your keywords to `TODO` and `DONE`, the `|` in the middle is to indicate the separation between open/todo and closed/done states.
This enables emacs to do fancy stuff such as greying-out the things that are done, or logging the time specifically when transitioning to a closed state.

Here is some more code:

```elisp
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "CANCELED(c)")))
```

So here, both the `DONE` and `CANCELED` state will be understood as closing the item.
When having a healthy amount of keywords like this, I would avoid cycling between todo states with `S-<left>` and `S-<right>`.
An alternative to cycling between states is to use the `org-todo` function bound to `C-c C-t`, or to `SPC m t` if you're on Doom Emacs.
You can choose what shortcut letter will be used in the menu opened by `org-todo` by adding in your config a letter in parentheses after your todo states as seen above.

Now we get onto the **real** fancy stuff :eyes:.

```elisp
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
```

Here, you can see weird symbols after each letter in the parentheses, but don't fret! It's actually pretty easy.

`@` symbols as in the `CANCELED` state means that when switching to this state, we will be prompted to create a note on why, in this case, the task was canceled.
This note and the timestamp at which this action was performed will be stored in a special drawer called (you guessed it :upside_down:) `LOGBOOK`!

The `!` symbol means that only the timestamp will be recorded, so you won't be prompted to make a note.

Finally, what about this `@/!` syntax?
Well, we'll actually call it the `enter/leave` syntax since it's actually a more global pattern.

The `enter` part is the default behavior, so it will do what was explained above.

The `leave` part, however, is triggered when **leaving** the state and **only if** the target state doesn't have `!` or `@`.

Here are a couple of examples:

-   `TODO` -&gt; `WAIT`: the `enter` part of `WAIT` is triggered, a timestamp and a note (that you will be prompted to enter) will be added to the `LOGBOOK`
-   `WAIT` -&gt; `TODO`: the `leave` part of `WAIT` is triggered, a timestamp will be added to the `LOGBOOK`
-   `WAIT` -&gt; `DONE`: the `enter` part of `DONE` is triggered, making the `leave` part of `WAIT` not triggering. A timestamp will be added to the `LOGBOOK`


## But what's the result of doing this? {#but-what-s-the-result-of-doing-this}

First of all, here is my config:

```elisp
(setq org-todo-keywords
      '((sequence "TODO(t!)" "DOING(d!)" "WAIT(w@/@)" "|" "DONE(v!)" "CANCELLED(x!)"))
```

And now, here is a sample `LOGBOOK`:

```org
:LOGBOOK:
- State "DONE"       from "DOING"      [2022-11-19 sat. 01:20]
- State "DOING"      from "WAIT"       [2022-11-19 sat. 01:20]
- State "WAIT"       from "DOING"      [2022-11-19 sat. 01:19] \\
  Here is the reason why I needed to wait!
- State "DOING"      from "TODO"       [2022-11-19 sat. 01:19]
- State "TODO"       from "DOING"      [2022-11-19 sat. 01:19]
- State "DOING"      from "TODO"       [2022-11-19 sat. 01:19]
- State "TODO"       from              [2022-11-17 thu. 15:18]
:END:
```

Now, automated tools such as `ox-hugo` can take this information, and determine the creation and last edit timestamp of my posts :partying_face:!
