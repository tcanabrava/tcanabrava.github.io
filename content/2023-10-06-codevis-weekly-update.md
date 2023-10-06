+++
title = "Codevis Weekly Update"
[taxonomies]
tags=["kde", "codevis"]
categories=["kde"]
+++

Welcome to the first "Codevis Weekly Update"

# What is Codevis?

[Codevis](https://invent.kde.org/sdk/codevis) is a tool to help developers manage large codebases, sponsored by Bloomberg, developed by Codethink and hosted on the KDE Infrastructure, with all that, completely opensource with a permissive license. Codevis uses a mix of technologies to do what it does, mainly `LLVM and Clang` to do the heavy lifting of understanding C++ Codebases, `Qt` for Callback management (in the form of Signal/Slots), `KDE Frameworks` libraries for the desktop application, and `pure Qt` for the CLI application. The database layer is written with `Soci` , the same database layer used in CERN, targeting sqlite3.

# But How does it work?

Codevis analyzes *all* the *visible* source code from your project and creates a graph database (using a relational database) in a way that the analyst can load and interpret information from the codebase without loading the codebase. The graph-database is `comprehensive`, and has all the information we think it's important, and also a lot of information that's `good to have`, with a bunch of information because `why not`. Since something that's not important for me could be *really* important for a company with billions of lines of code.

# It just generates visualization?

No. Codevis also allows you to *draw* your software architecture and generate ready-to-compile c++ code from it. Think of this as a possibility to have C++ templates for complex projects tha are also visually documented. You can create libraries, classes, structures, connect them quickly on a dirty mockup during a meeting, and the output could be `60 c++ files on disk` with all the classes, folder-hierarchy and `CMake` ready to compile.

This will *not* add any method or implement anything, but just the creation of the C++ files and CMake scripts from a small architecture meeting is pretty interesting in my point of view.

<!-- more -->

# Yeah, but isn't UML alreday that?

No. UML is quite more complex and harder to use for large scale visualization, and the UML code generation doesn't really takes `buildability` in mind. You can't generate an entire project from a UML definition.

# You say that it's a large scale, but my proejct is small. it will also help me?

Codevis will analyze *everything*, every single include that you use (even if it's not from your project), helping you decide the best usage for libraries and visualizing the graph with different graph algorithms - making sure that the `physical software layout` is organized (not just the `logical architecture`).

# Improve it with Plugins

We support `C++` and `Python` plugins so you can implement things that might be important for your corporation (and by corporation I mean `Gnome, KDE, RedHat, Collabora`, etc) and integrate the software in ways that the developers didn't think of.

# CI integration?

Imagine that you need to make sure the architecture of the software is stable. Architecture is not something that is easy to do `unittests` for. it can also be a complex architecture so it's hard to see if all my new `header and source` files are implementing (or correctly integrating) into new architecture.

with Codevis you can use the `cli` tools and extract the code information on a CI step, load the database and run a plugin that checks if the whole architecture of the system is correct, based on heuristics.

# Is everything you said here production ready?

No. This is also an appeal for help. we are developing and we have *almost* everything here running correcty, some parts are missing, specially, people using and testing is missing. We appreciate if people download, compile, try.

