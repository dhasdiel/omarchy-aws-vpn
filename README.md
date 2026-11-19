# AWS VPN — Omarchy bar widget

Bar toggle for an [AWS Client VPN](https://github.com/dhasdiel/aws-vpn)
connection with SAML login, for the Omarchy shell.

- **Left click:** connect / disconnect (SAML login opens in the browser)
- **Right click:** open the OpenVPN log
- Icon is dimmed when off and changes while connecting

## Requirements

- Omarchy shell (Quickshell)
- The [aws-vpn](https://github.com/dhasdiel/aws-vpn) client installed and
  working — the widget shells out to its `vpnctl` script
- `xdg-open` for the browser login and log view

## Install

1. Install the client first and verify it works. The clone checks out a
   fixed commit (v1.1.2) — see
   [releases](https://github.com/dhasdiel/aws-vpn/releases) for newer tags:

   ```sh
   git clone https://github.com/dhasdiel/aws-vpn ~/aws-vpn && git -C ~/aws-vpn checkout --detach 0f70529d7da3bd4a57abe7a8d0957b74656d65be && cd ~/aws-vpn
   ./setup.sh <your-profile.ovpn> && ./build.sh && ./install.sh
   ./vpnctl status   # prints "down"
   ```

2. Install the plugin. Once it is listed in the Omarchy marketplace:

   ```sh
   omarchy plugin add io.github.dhasdiel.aws-vpn --enable
   ```

   Until then, install manually from a fixed commit:

   ```sh
   git clone https://github.com/dhasdiel/omarchy-aws-vpn /tmp/omarchy-aws-vpn
   git -C /tmp/omarchy-aws-vpn checkout --detach a61eb115b5a45fdce3e7fe85bdf347935630acb3
   mkdir -p ~/.config/omarchy/plugins/io.github.dhasdiel.aws-vpn
   cp -r /tmp/omarchy-aws-vpn/{manifest.json,Widget.qml,i18n} \
     ~/.config/omarchy/plugins/io.github.dhasdiel.aws-vpn/
   ```

3. If your aws-vpn clone is not at `~/aws-vpn`, set
   `AWSVPN_VPNCTL=/path/to/vpnctl` in the shell environment.

4. Add "AWS VPN" to the bar from Omarchy's widget settings (or restart the
   shell if it does not appear).

## Remove

Remove the widget from the bar, then:

```sh
rm -rf ~/.config/omarchy/plugins/io.github.dhasdiel.aws-vpn
```

To remove the VPN client itself, run `uninstall.sh` in the aws-vpn repo.

## External dependencies

The plugin itself is a thin QML wrapper. Runtime behavior comes from
`vpnctl`, which uses `pkexec`/`polkit`, `python3` (stdlib HTTP server for the
SAML callback), `openssl`, `resolvectl` and `xdg-open`. See the
[aws-vpn README](https://github.com/dhasdiel/aws-vpn#readme) for details and
its security notes.

## License

MIT — see [LICENSE](LICENSE).
