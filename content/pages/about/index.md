+++
title = "About"
path = "about"
date = 2021-10-05
template = "info-page.html"
+++

I'm Tomaz Canabrava, a KDE developer. I grew up in Salvador, Brazil, and I've
been running Arch Linux as my daily driver for more than fifteen years — the
only distro I've ever managed to stay on for longer than six months.

Most of what I write here is C++, Qt and KDE.

## Work

I work at [Codethink](https://www.codethink.co.uk), an open source system
software consultancy. The work sits at the systems level — firmware, drivers,
board support, operating systems, libraries, middleware, and the build tooling
needed to turn all of that into something you can actually ship and maintain —
for clients in automotive, medical devices, financial services and heavy
equipment.

It's Linux and free software most of the way down, and the company contributes
upstream to the projects it builds on rather than quietly forking them. That
part of the job and the part of my life described below are less separate than
you might expect.

## Konsole

I work on [Konsole](https://konsole.kde.org), KDE's terminal emulator. It had
gone nearly a decade without much happening to it, on the reasonable grounds
that it already worked, until the rest of the terminal world caught up and
started shipping things Konsole didn't have. So I started modernising the
codebase enough that it could be worked on again, and then adding the missing
pieces: splits, Wayland support, a plugin system, and a fair amount of work on
scrollback performance.

There is still no other terminal that does everything Konsole does.

## Codevis

[Codevis](https://invent.kde.org/sdk/codevis) is a C++ codebase visualisation
tool, now part of KDE. It started as an experiment in applying the ideas from
John Lakos' *Large Scale C++* to real projects — showing you the physical
structure of a codebase, its components and the dependencies between them, so
that architectural problems become something you can see rather than something
you discover at link time.

## Arch and KDE packaging

Packaging KDE for a distribution is a large job, because KDE is large. Together
with Antonio Rojas I've been reworking the build scripts Arch uses to package
KDE software, making them less manual and less error-prone. Every Plasma 6
release packaged for Arch has gone through those scripts in one form or another.

## Elsewhere

Not everything is C++. [Harmonicon](@/projects/harmonicon/index.md) is a rhythm
game for blues harmonica written in Rust — it listens to you play into a
microphone and scores you on it. That and the rest are on the
[projects](@/projects/_index.md) page.

I turn up at conferences and community booths now and then — most recently
FOSSASIA in Bangkok. The hallway track is usually the best part.

You can find my code on [GitHub](https://github.com/tcanabrava) and on
[KDE Invent](https://invent.kde.org/tcanabrava), and reach me at
<tcanabrava@kde.org>.
