---
layout: post
title: "KConfigXT Alternative Generator"
---

I'm using for my own personal projects a generator for c++ preferences for quite a while, I'll not say that it's heavily tested as KConfigXT is, but it is also *much* more simple than it.

While talking about it to a fellow developer he asked me how hard it would be to port the thing to KConfig (as the main backend I used was QSettings) - and the result is quite nice, the port toook
less than a day, and now my generator generates configurations for both KConfig and QSettings.

- Example configuration:

```
preferences.conf

#include <QString>
#include <QStandardPaths>

Preferences {
    General {
        int beatsPerMinute = 60
    }
    Some {
        Inner {
            Group {
                int value = 10
            }
        }
    }
    Harmonica {
        QString partitureFolder = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)
    }
}

```

For those that worked with KConfigXT, it's easy to see how much this is different from the xml that the tool uses. And differently from KConfigXT, the code is smaller, easier to read, and does not rely on magic enums, nor it has a lot of different possibilities to fine tune the settings - if you want to choose between runtime or compile time file, shared vs non shared config, etc.: KConfigXT is for you, mine is supposed to be simple and up to the point.

That Preferences will generate all the corresponding C++ classes with the needed boilerplate for a Qt application to handle settings, in a safe way - no more strings for keys on code.

```
Preferences::self()->some()->inner()->group()->setValue(15);
Preferences::self()->general()->setBeatsPerMinute(10);
```

All of the preferences are exported as Q_PROPERTIES using `snake_case`
so you use it directly on Qml.

```
SomeQmlElement {
    width: preferences.window.width
}
```

If you want to set specific rules to the Preferences values, this is done in c++, using the `setRule` variants of the settings:

```
int main(int argc, char *argv[]) {
   QApplication app(argc, argv);
   Preferences::self()->some()->inner()->group()->setValueRule([](int value) { return value < 90; });
}
```

The defaut values can be queried with `Default` variants:

```
  Preferences::self()->some()->inner()->group->valueDefault();
```

There's no code to automatically handle ui files, like KConfigXT, nor there will be. create your connects by hand using this.

The source is at https://github.com/tcanabrava/configuration-parser
Currently the build produces two binaries: one for qsettings, one for kconfig.

(if anyone is better at cmake than myself, I'd appreicate some help on ConfigurationCompiler.cmake, as it's not correctly generating the targets on a 3rd party project)
