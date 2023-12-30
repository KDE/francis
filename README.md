<!--
    SPDX-FileCopyrightText: 2022 Felipe Kinoshita <kinofhek@gmail.com>
    SPDX-License-Identifier: CC0-1.0
-->

# Francis

![coverage](https://invent.kde.org/utilities/francis/badges/master/coverage.svg?job=suse_tumbleweed_qt515)

Track your time.

![francis window](.gitlab/francis.png)

Francis uses the well-known pomodoro technique to help you get more productive.

## Build Flatpak

To build a flatpak bundle of Francis use the following instructions:

```bash
$ git clone https://invent.kde.org/utilities/francis.git
$ cd francis
$ flatpak install --user --or-update https://cdn.kde.org/flatpak/kde-runtime-nightly/org.kde.Platform.flatpakref
$ flatpak install --user --or-update https://cdn.kde.org/flatpak/kde-runtime-nightly/org.kde.Sdk.flatpakref
$ flatpak-builder --repo=repo --force-clean build-dir org.kde.francis.json
$ flatpak build-bundle repo francis.flatpak org.kde.francis
$ flatpak uninstall --user -y org.kde.francis
```

Now you can install:

```bash
$ flatpak install --user francis.flatpak
```
