# Dotfiles

This is my custom _dotfiles_ project tailored to handle both macOS
and Ubuntu post-OS-install configuration.

# Supported OSs

This project is tested on [macOS Monterey][catalina] and [Ubuntu 20.04][ubuntu]
(and its [derivatives][flavours]).

For Ubuntu derivatives, script tries to identify the desktop environment and install
things accordingly but it assumes that you're running the install script right after
the OS installation (which is the whole point of having _dotfiles_), but if you're
running it on a very custom Ubuntu installation then script is not guaranteed to
behave as expected (and may potentially break stuff!).

Technically, this script should run fine on latest [Debian][debian], [LinuxMint][linuxmint],
[elementaryOS][elementary] or any Debian/Ubuntu based OS releases but I haven't tested
it on any of those so use it at your own risk.

## How to run?

Download the project tarball from GitHub and extract it somewhere in your `/home` directory.

Open the extracted folder in your terminal and add exec permission to `install.sh` file;

```bash
chmod +x install.sh
```

Now run the script (without `sudo`!);

```bash
./install.sh
```

It'll take a while before finishing and it'll occassionally require user input while it
asks questions during the install process so you while don't need to baby-sit this script,
stay around to keep an eye.

## Documentation for manual setup

Some of the steps that I perform right after OS installation (like setting up partition automount, grub timeout, and etc.)
are to be done manually, so for those steps, you can refer to following docs.

- [Ubuntu Post-install Setup](https://github.com/kushalpandya/dotfiles/blob/master/docs/post-install.md)
- [Ubuntu Server Setup](https://github.com/kushalpandya/dotfiles/blob/master/docs/services.md)

## License

Who even cares!
If you absolutely need one, then [MIT][mit], there you go.

## Author

### [Kushal Pandya](https://doublslash.com/about/)

[catalina]: https://www.apple.com/in/macos/monterey/
[ubuntu]: https://releases.ubuntu.com/20.04/
[flavours]: https://ubuntu.com/download/flavours
[debian]: https://www.debian.org/News/2020/20200801
[linuxmint]: https://linuxmint.com/rel_ulyana.php
[elementary]: https://elementary.io/
[mit]: https://opensource.org/licenses/MIT
