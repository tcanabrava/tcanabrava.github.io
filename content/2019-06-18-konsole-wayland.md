+++
title = "Konsole and Wayland"
date = 2019-06-18

[taxonomies]
tags=["kde"]
categories=["kde", "konsole"]
+++

Wayland needs a different mindset when you are programming, you cannot just assume things works the same way as in as X11. One of my first patches to konsole was the rewrite of the Tab Bar, and a different way to deal with Drag & Drop of the tabs. In my mind - and how wrong I was - I could assume that I was dragging to a konsole main window by querying the widget below the mouse.
<!-- more -->

Nope, this will not work. As Wayland has security by default, it will not give you anything global. What if I was a spy app trying to record another one to send to NSA? Security in Wayland is much stricter, and because of that I had to redo my drag & drop patch.

Konsole *should* work now with drag & drop of tabs in Wayland, as soon as the patch hits master. I also have other patches waiting that will make the wayland transition smoother, I'll write about them in due time.
