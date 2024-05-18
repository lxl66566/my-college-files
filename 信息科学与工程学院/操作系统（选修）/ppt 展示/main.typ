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

== 使用体验

- 直观感受：只需要知道名字，一行代码，安装并管理
- 环境变量
- 源，依赖
- 查找表
- ...

== 地位

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
]

=== 数量统计

- https://repology.org/repositories/statistics/newest

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

#pagebreak(weak: true)

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

#pagebreak(weak: true)

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

== snap

- Ubuntu 的预装包管理器，/snap
- 守护进程：snapd
- 每个软件包里带有所有依赖
- loop mount

#figure(image("static/snap.png", width: 50%))

== pacman

- pacman（package manager）是 Arch Linux 的官方仓库包管理器。
- 激进，滚动更新，不允许部分更新。

#figure(image("static/pacman_partial.png", width: 60%))

- 依赖的可用性由官方仓库保证。

=== 缺点

- 抽象的参数 (S, Sy, Syu, Syyu, Syyuu; Qtdq, Qtdm; Rns, Rsc)
- 过于严格的审查与缺陷
  - error: xxx: signature from "xxx" is unknown trust
  - 自 2023 年 12 月初 archlinux-keyring 中删除了一个退任的 master key (https://gitlab.archlinux.org/archlinux/archlinux-keyring/-/issues/246) 导致 farseerfc 的 key 的信任数不足，由 GnuPG 的 web of trust 推算为 marginal trust，从而不再能自动信任 archlinuxcn-keyring 包的签名。
- do not support search name only (pacman -Ss '^vim-')

== AUR

- AUR（Arch User Repository）是 Arch Linux 的用户仓库，由用户自由上传
- 所有包使用 PKGBUILD 描述；AUR Helper 处理依赖并下载 PKGBUILD，交由 makepkg 构建安装。

```
# Maintainer: ab5_x <lxl66566@gmail.com>

pkgname=tdl-bin
pkgver=0.17.0
pkgrel=1
pkgdesc="A Telegram downloader/tools written in Golang"
arch=("x86_64" "aarch64" "armv7h")
url="https://github.com/iyear/tdl"
license=("AGPL-3.0-or-later")
depends=()
provides=("tdl")

source_x86_64=("$pkgname-x86_64::https://github.com/iyear/tdl/releases/download/v$pkgver/tdl_Linux_64bit.tar.gz")
source_aarch64=("$pkgname-aarch64::https://github.com/iyear/tdl/releases/download/v$pkgver/tdl_Linux_arm64.tar.gz")
source_armv7h=("$pkgname-armv7h::https://github.com/iyear/tdl/releases/download/v$pkgver/tdl_Linux_armv7.tar.gz")

sha256sums_x86_64=('2d9ac6d36530ba08da44572447120691f5487443a1eb65be189850ddaa6d6c7d')
sha256sums_aarch64=('2c34a9255ae7a79a6cac0c74dd72e79d539813f4f39c4f904f940b44b2b30bb5')
sha256sums_armv7h=('ea7a126b120682e8130dbe87e07e790c2d9cc5bc41c8ba464cd27d3b5e5f7062')

package() {
        cd "$srcdir/"
        install -Dm755 tdl -t "${pkgdir}/usr/bin/"
        install -Dm644 LICENSE -t "${pkgdir}/usr/share/licenses/$pkgname/LICENSE"
}
```
#pagebreak(weak: true)

=== 缺点

- 安全问题
- 没有通用提交 patch/PR 的办法，只能用户自行维护
  - 可以标记过期

#figure(image("static/meme.jpg", width: 60%))

== Nix

- 通用包管理器
- 包描述：函数式 Nix 语言
- hash 存储，ex. /nix/store/l5rah62vpsr3ap63xmk197y0s1l6g2zx-simgrid-3.22.2
  - 隔离
  - 回滚
  - 可复现
- cache

#pagebreak(weak: true)

=== 使用

```sh
❯ sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable
❯ sudo nix-channel --update
❯ sudo nix-env -i fish
❯ which fish
/nix/var/nix/profiles/default/bin/fish
❯ nix-shell -p cowsay
[nix-shell:~]# cowsay 456
```

= 包管理器实践

== init-script

#github("lxl66566/init-script")

- 服务器一键脚本
- 安装列表：sudo, wget, curl, rsync, btop, lsof, ncdu, tldr, podman, fzf, make, paru, #text(fill: red, "trojan"), base, python-requests, python-pip, pipx, bpm, #text(fill: red, "trojan-go"), caddy, #text(fill: red, "hysteria2"), fd, mcfly, zoxide, fish, starship, cargo, sd, ripgrep, eza, yazi, neovim, fastfetch, zellij, bat, xh, #text(fill: red, "openppp2"), atuin

#pagebreak(weak: true)

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

#pagebreak(weak: true)

=== V2

```python
class Package:
    """
    `pm_name`: 一个函数，根据当前架构与包管理器返回系统包名。
    `level`: 优先级，数字越大优先级越高。0 默认不安装，1 在配置充足的系统上安装，2 必定安装。
    `pre_install_fun`：自定义安装前函数，返回 None | bool。如果未设置或返回 False，使用 `pm_install` 安装，返回 None 不安装，否则使用 `install_fun` 安装。
    `install_fun`: 自定义安装函数。如果返回 False，改为使用 pm_install 安装。
    `post_install_fun`: 自定义安装后函数，主要进行一些配置。无论使用 pm_install 还是 install_fun 安装，都会执行这个函数。
    """

    @install_once(name="install")
    def install(self):
        # install dependencies
        for i in self.depends:
            p = packages_list.get(i)
            assert p, f"找不到依赖包 {i}"
            if not SetCache("package_installed").in_set(p.name):
                p.install()
            else:
                log.debug(f"依赖 {p.name} 已经安装，跳过安装")

        cut()
        print(f"""开始安装 {colored(self.name, "green")}...""")

        name = getattr(self, "pm_name", lambda: self.name)()
        if not name:
            name = self.name

        """
        调用函数，如果函数有且只有一个参数，则将 self 作为参数传入，否则不传。
        """
        pre_ret = self._call_with_param_0_or_1(
            getattr(self, "pre_install_fun", lambda: False)
        )

        if pre_ret is None:
            log.warning(f"""{colored(self.name, 'yellow')} 不满足安装条件，安装取消.""")
            return

        if not pre_ret and check_package_exists(name):
            pm_install(name)
        else:
            assert hasattr(
                self, "install_fun"
            ), "跳过了系统包安装，并且找不到自定义安装函数。这可能是您的平台不受支持，或者包管理器版本过低，请开 issue 报告"
            fun = getattr(self, "install_fun")
            self._call_with_param_0_or_1(fun)

        self._call_with_param_0_or_1(getattr(self, "post_install_fun", lambda: None))

        SetCache("package_installed").append_set(self.name)
        print(f"""{colored(self.name, "green")} 安装完成.""")
```
#pagebreak(weak: true)

=== 使用

```python
packages_list.add(
    Package(
        "zoxide",
        2,
        pre_install_fun=lambda: distro() == "d" and version() < 11,
        install_fun=lambda: rc_sudo(
            "curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
        ),
        post_install_fun=lambda: fish_add_config("zoxide init fish | source"),
        depends=["fish", "sudo"],
    )
)
```
- 不用 nix 的原因？
  - 当时不知道
  - nix 安装后需要手动重启 shell

== bpm

#github("lxl66566/bpm")

- 从 Github Release 中安装 binary
  - 无需处理依赖
- 无需打包，依照既定规则安装

```
install (i)         Install packages.
remove (r)          Remove packages.
update (u)          Update packages.
info                Info package.
alias               Alias package. (Windows only; Linux use shell alias instead.)
```

#figure(image("static/bpm.svg", width: 70%))

// vars: {
//   d2-config: {
//     layout-engine: tala
//   }
// }
// ***: {
//   style.font-size: 25
// }
// net: {
//   direction: down
//   select repo -> assets: github api
//   assets -> download link: filter
// }
// installer: {
//   direction: down
//   archive -> files: unpack
//   files -> system: place rules
// }
// direction: right
// net -> installer: download

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
