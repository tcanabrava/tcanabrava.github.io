---
layout: post
title: "The state of Terminal Emulators in Linux"
---

We are seeing a strange trend nowadays: The terminal is being more widely used in windows, after they fixed the broken cmd.exe and MS is actually actively promoting their terminal applications like Visual Studio Code and the new Windows Terminal, but on the other hand the Unix world was always terminal based, even if you tend to use the Desktop Environment for your daily needs you probably also had a Terminal open somewhere.

And because we had always been terminal users, there are a lot of terminals for Linux, But it's not easy to keep a terminal up to date, it's usually fragile code and hard to maintain, that means that a lot of projects, good projects, are abandoned.

## Good terminals that unfortunately didn't make it
* Tilix: Is one of the best terminal emulators out there, it's a shell written in D, on top of VTE, the author lacks the time to continue working on it.
* Terminator: I don't know if this one is abandoned as there's no news on the web about it, the news that I know is that version 2 is scheduled for release in 2017, never happened though.

**If you are sad that your favorite terminal is without a maintainer, try to maintain it, free software depends on developers.**


## The state of Konsole:

* Konsole is receiving more reviews, more code and more contributors in the last year than it got in the past 10 years. 
* In the past, the project is kept alive by Kurt, and he did an awesome job. But a project as big as konsole needs more people.
* Three new developers joined konsole and are activelly fixing things over the past year, no plans to stop.
* Terminator / Tilix split mode is working
* A few features to be completely equal to minix / terminator is missing, but not hard to implement

Now it has more developers and more code flowing, fixing bugs, improving the interface, increasing the number of lines of code flowing thru the codebase. We don't plan to stop supporting konsole, and it will not depend on a single developer anymore.

We want konsole to be the swiss army knife of terminal emulators, you can already do with konsole a lot of things that are impossible in other terminals, but we want more. And we need more developers for that.

Konsole is, together with VTE, the most used terminal out there in numbers of applications that integrate the technology: Dolphin, Kate, KDevelop, Yakuake, and many other applications also use konsole, so fixing a bug in one place we are helping a lot of other applications too.

Consider joining a project, Consider sending code. 
