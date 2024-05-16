/// svg charts was drawn by https://play.d2lang.com/.
/// The svg will always begin with the following code:
///
/// ```
/// ***: {
///   style.font-size: 25
/// }
/// ```
/// So that the text size can be better.

#import "@preview/touying:0.4.1": *
#import "@preview/codly:0.2.0": *
#import "@preview/pinit:0.1.3": *

#let s = themes.university.register(aspect-ratio: "16-9")
#let s = (s.methods.append-preamble)(self: s)[
  #codly(breakable: true, enable-numbers: true, default-color: green)
]
#let s = (s.methods.info)(
  self: s,
  title: [包管理器杂谈],
  subtitle: [],
  author: [],
  date: datetime.today(),
  institution: [],
)
#let (init, slides, touying-outline, alert) = utils.methods(s)
#show: init
#show: codly-init.with()

#let (slide, empty-slide, title-slide, focus-slide, matrix-slide) = utils.slides(s)

// me

#show link: underline
#let github(s) = {
  let url = "https://github.com/" + s
  text(size: 17pt)[#link(url, "github: " + s)]
}
#show figure.caption: it => text(size: 15pt, it.body)
#show raw: it => {
  text(size: 10.5pt, it)
}
#show heading: set align(center)

#show: slides.with()

= 前言

Package managers are at the core of Linux distributions. —— #link("https://lwn.net/Articles/712318/", "Jonathan Corbet, LWN.net")

#figure(image("static/status.svg", width: 70%))

// Package Manager <- linux
// Package Manager <- linux-lts
// Package Manager <- linux-zen
// Package Manager <- linux-lily

== 发行版和包管理器

#slide[
  - Arch Linux: _pacman_
  - Debian: _apt_, _apt-get_
    - Ubuntu: += _Snap_
  - CentOS: _yum_
  - Fedora: _dnf_
  - Gentoo: _Portage_
  - NixOS: _Nix_
  - #strike[Windows: _Chocolatey_, _Scoop_]
  - ...
][
  - Flatpak
  - #strike[AppImage]
]

== 数量统计

https://repology.org/repositories/statistics/newest

= 包管理器是如何工作的？

== Scoop

#github("ScoopInstaller/Scoop")

- Scoop is a command-line installer for *Windows*. (PowerShell)
- 声明式

```json
{
    "version": "1.6.4",
    "description": "GIF encoder based on libimagequant (pngquant).",
    "homepage": "https://gif.ski",
    "license": "AGPL-3.0-or-later",
    "url": "https://gif.ski/gifski-1.6.4.zip",
    "hash": "dc97c92c9685742c4cf3de59ae12bcfcfa6ee08d97dfea26ea88728a388440cb",
    "pre_install": "if (!(Test-Path '$dir\\config')) { New-Item '$dir\\config' }",
    "bin": "gifski.exe",
    "checkver": "For Windows.*?gifski-([\\d.]+)\\.zip",
    "autoupdate": {
        "url": "https://gif.ski/gifski-$version.zip"
    }
}
```

#figure(image("static/scoop_structure.svg", width: 80%))

// scoop -> bucket.main
// scoop -> bucket.extras
// scoop -> bucket."..."
// bucket.main -> manifest."1.json"
// bucket.main -> manifest."2.json"
// bucket.main -> manifest."...."
// bucket.extras -> manifest."3.json"
// bucket.extras -> manifest."..."
// bucket."..." -> manifest.".."

#slide[
  #figure(image("static/scoop_buckets.png", width: 60%))
][
  ```sh
  scoop install git  # uninstall, search
  scoop bucket add extras
  scoop bucket add absx https://github.com/absxsfriends/scoop-bucket
  scoop config proxy 127.0.0.1:<port>
  ```
  #figure(image("static/scoop_github.png", width: 55%))
]

=== 缺点

- Apps are self-contained units

  They should keep their own copies of any libraries they need to run, and not rely on or interfere with any libraries outside their own install path.—— #link("https://github.com/ScoopInstaller/Scoop/wiki/Dependencies", "Scoop Wiki")
- PowerShell

== apt

- apt（Advanced Packaging Tool）（2014） 是 apt-get（1998） 的较新版本。apt 命令被设计为对用户更加友好的 apt-get 替代方案。
- debian 系维护一个 .deb 包，能够直接使用 dpkg -i 安装。
- apt 处理依赖并下载，交由 dpkg 安装。

#pagebreak()

=== .deb 包结构

```
staging
  ├─ DEBIAN
  └─ usr
      ├─ bin
      └─ share
          ├─ project1       #resources of your package
          ├─ applications   #shortcut
          ├─ pixmaps        #default icon
          ├─ icons
          │   └─ hicolor    #icons of various sizes
          ├─ doc
          │   └─ project1   #information about your package
          └─ man            #user manual
              └─ man1       #index
```

ref: #link("https://wiki.freepascal.org/Debian_package_structure", "Debian package structure")

#pagebreak()

=== 打包上传

- Once you become an *official developer*, you can upload the package to the Debian archive.——#link("https://www.debian.org/doc/manuals/maint-guide/upload.en.html#ftn.idm3699", "Debian Manuals")
- Caddy 安装指南？

  ```sh
  sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
  sudo apt update
  sudo apt install caddy
  ```

== pacman

```
$ pacman --version
 .--.
/ _.-' .-.  .-.  .-.
\  '-. '-'  '-'  '-'
 '--'
...
```

- pacman（package manager）是 Arch Linux 的包管理器。

- 激进，滚动更新，不允许部分更新。#figure(image("static/pacman_partial.png", width: 55%))

=== AUR

== init-script

#github("lxl66566/init-script")

- 服务器一键脚本
- 安装列表：sudo, wget, curl, rsync, btop, lsof, ncdu, tldr, podman, fzf, make, paru, #text(fill: red, "trojan"), base, python-requests, python-pip, pipx, bpm, #text(fill: red, "trojan-go"), caddy, #text(fill: red, "hysteria2"), fd, mcfly, zoxide, fish, starship, cargo, sd, ripgrep, eza, yazi, neovim, fastfetch, zellij, bat, xh, #text(fill: red, "openppp2"), atuin

=== 初代

```python
@log
@mycache_once(name="install")
def install_zoxide():
    match distro():
        case "a":
            pacman("zoxide")
        case _:
            if distro() == "d" and version() < 11:
                rc_sudo(
                    "curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
                )
            else:
                basic_install("zoxide")
```

// direction: down
// downloader: {
//   direction: right
//   remote -> manifest: fetch
// }
// installer: {
//   direction: right
//   manifest -> package: pack
//   package -> system: install
// }
// downloader -> installer
