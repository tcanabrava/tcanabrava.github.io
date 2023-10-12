+++
title = "Porting Codevis to KDE"
[taxonomies]
tags=["kde", "codevis"]
categories=["kde"]
+++

# The Problem with C++ Tooling

An ISO accepted C++ tooling is inexistent, so each project will choose their own toolings based on personal preference, and sometimes, based on Corporations preferences, and unfortunately there's no common ground on what should be used. There are some programs that got the `Standard by consensus`, like `CMake`. But even tough, projects will choose `handmade makefiles`, `KConfig`, `meson`, `autotools`, and many others exist.

The same thing happens for Package Managers, each Linux distributtion has a variant of packages, and on top of that there's `vcpkg`, `conan` - each one with pros and cons.

The lack of a `node` or a `cargo` or a `pip` that's the entry point for the language makes it complex for developers to know where to start, and the most common idea is to build what doesn't exist, or manually install (via `git submodules/git subtrees`) things that are not disponible in your distribution or operating system.

# How Codevis Started (Tools and Libraries)

Codevis started as an experiment to see if it would be possible to apply the ideas in the `Large Scale C++` book by `John Lakos`. A small proof of concept was created three years ago, and we adopted a lot of libraries to be able to work fast keeping the quality high:

 - Qt (5 and 6)
 - soci (database layer used at CERN)
 - QuaZip (easy access to compressed files)
 - LLVM and CLang (parsing of C++ files)
 - Sqlite3 (our actual database)
 - Doxygen (Documentation)
 - Python (Plugins)
 - Catch2 (Tests)
  
And this is already a fair number of libraries, specially considering that those libraries also depend on others, keeping the Dependency graph quite large. 

One problem that we had was to create a CI for all systems we targeted with all those libraries. both of the most common C++ package managers failed us: 

 - `conan` did not had LLVM (and we indeed created patches for it, adding missing libraries)
 - `vcpkg` did not had some libraries that we needed, too.

Because of this we had to manually create base CI scripts that would download, compile, install the libraries that were not found on the package managers but this is frail, as any handwritten script is.

We started to look for a new home, and KDE was nice enough to host us. This gave us their amazing CI and buildsystems, that already had all the libraries we used, plus a few more.

So we were able to drop the handwritten scripts for, mostly, llvm.

# Why did the change from Pure Qt to KDE Frameworks?

When you are inside of a system that works, and that offers powerful and battle tested libraries, it's worth to try to use them. There are many libraries in the KDE Frameworks that I wanted to use before but it was too hard to bring to windows if I'm not using `craft`,  resembles to `conan` and knows how to build libraries and applications within the KDE universe. 

Adding the necessary information to build `Codevis` in craft was much simpler than expected.:
* clone `craft-blueprints-kde`
* copy a program template and chagne it's name
* point to the kde repository with a list of libraries it should use

The full `codevis` recipe for windows, mac and linux using `craft` is the following:
Note that every line on runtimeDependencies and buildDependencies are a `craft` recipe inside of the same repository, so just by searching the folders it's easy to know what to add for your program.

```
import info
from Packager.CollectionPackagerBase import PackagerLists

class subinfo(info.infoclass):
    def setTargets(self):
        self.versionInfo.setDefaultValues()
        self.description = "Codevis is a software to visualize large software architectures."
        self.displayName = "Codevis"
        self.webpage = "http://invent.kde.org/sdk/codevis"
        self.svnTargets["master"] = "http://invent.kde.org/sdk/codevis.git"

    def setDependencies(self):
        self.buildDependencies["kde/frameworks/extra-cmake-modules"] = None
        self.runtimeDependencies["libs/llvm"] = None
        self.runtimeDependencies["libs/zlib"] = None
        self.runtimeDependencies["libs/catch2"] = None
        self.runtimeDependencies["qt-libs/quazip"] = None
        self.runtimeDependencies["libs/runtime"] = None
        self.runtimeDependencies["libs/qt5/qtbase"] = None

from Package.CMakePackageBase import *

class Package(CMakePackageBase):
    def __init__(self):
        CMakePackageBase.__init__(self)
        self.subinfo.options.configure.args += ["-DUSE_QT_WEBENGINE=OFF ", "-DCOMPILE_TESTS=OFF "]

    def createPackage(self):
        self.defines["executable"] = "bin\\codevis_desktop.exe"
        return TypePackager.createPackage(self)
```

# How easy is to bring a 50 - 100K lines of code to KDE?

* We adopted `KConfig`
  
With The build part fixed, it was time to adopt some libraries to remove some handwritten logic we had. I wrote a configuration to c++ parser to easily access configuration keys from .ini format, but this was the only project using it, so why not change to KConfig, that uses a `XML` based description for settings, and it's used by almost all programs within the KDE Infrastructure (and it certainly has way more unittests preventing breackages than what I have on my try)

* We adopted `KXmlGUI`

KXMLGui is one of the killer features of the `KDE Frameworks`. It allow you to split the logic of your interface with a description of `Menus` and `Toolbars` in `XML`, and in runtime it provides some nice features like allowing the user to change the toolbars with any action registered within the system, and a `searchable command pallete`, that's something I use in all `KDE` applications on my machine, and I sure was missing this on Codevis.

* We adopted `KDocTools`

Documentation is complex, but having an integrated documentation viewer and semantics ready, that could compile into hmtl with integrated search is impressive. Now we just need the time to actually write that documentation...

* We adopted `KNewStuff`

KNewStuff is a technology that integrates with `pling.com` and allows to distribute certain types of downloadable goodies, like wallpapers - or in our case, `plugins` to improve the system with things that the main developers didn't had the time to do yet.

* We adopted `KNotification`

Since the application takes a while to parse C++ code, or to run some plugins, `KNotification` is used to send a desktop notification to the user when an action ends. A small feature, but good for UX.

* We adopted `KTextEditor`

We need to have a place for users to develop plugins for Codevis, so KTextEditor was not a hard choice, it's the editor that powers up Kate, one of the flagship applications from KDE. Using it has been extremely easy and fast, supporting `syntax-highlihting` for multiple formats.

# An Honest, and unbiased, view

The work to port Codevis to use KDE libraries took around 2 weeks, and things were good. No major breakage and just some changes in behavior (mostly for the better). We also helped the KF6 libraries with ideas while discussing on their public channel in Matrix, and patches for some other programs while developing (such as `Konsole`, `Kate`, `Konversation`).

Nothing is perfect, but the outcome was a better, more stable, Codevis and the community was great while helping us understand how to use / handle specifics of a library - like `KNotification` using `raw news` without a corresponding call to a deleter. This was fixed by a comment on the Documentation stating that it auto-deletes itself.

# Should Corporations Adopt KDE Libraries?

For sure. The libraries are really high quality, and there are more than 90 of them. `Not using` something that's already working and with tests, is a waste of money on the corporation side.

# Are the devs Happy?

Yes, and I would use KDE Frameworks again.

The work for `Codevis` is sponsored by `Bloomberg`, and done by `Codethink` in the open, inside of the KDE Repositories.
