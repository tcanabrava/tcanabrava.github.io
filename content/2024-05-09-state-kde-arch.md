+++
title = "The State of KDE Apps and Plasma in Archlinux"
[taxonomies]
tags=["kde", "archlinux"]
categories=["kde"]
+++

KDE has a symbiotic relationship with many linux distros, since while we develop our software we also use particular versions of linux, I personally use archlinux as my distro of choice for many years being the only distro that I manage to bare for more than six months ( and I believe I am using it for more than 15 years already so that counts).

The "recipe" for packaging KDE software for arch is big, because we are big, and packaging large amounts of software is no easy feat, so me and Antonio Rojas started to update the build scripts to be less manual and less error prone. All the versions of Plasma 6 that have been packaged for arch are using this scripts in one way or another (or manually when we broke everything :)

This work is being done in a separate branch to not break the current workflow, but things are looking good and we hope to merge this in master soon, so that deploying newer versions of KDE software for arch will be a single command, meaning more time for the developers and less time creating packages.
