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
   fixed commit (v1.0.0) — see
   [releases](https://github.com/dhasdiel/aws-vpn/releases) for newer tags:

   ```sh
   git clone https://github.com/dhasdiel/aws-vpn ~/aws-vpn \
     && git -C ~/aws-vpn checkout --detach 8c9c794059c8bc0b42f868cb593ec90a251ff7ff \
     && cd ~/aws-vpn
   ./setup.sh <your-profile.ovpn> && ./build.sh && ./install.sh
   ./vpnctl status   # prints "down"
   ```

2. Install the plugin:

   ```sh
   git clone https://github.com/dhasdiel/omarchy-aws-vpn /tmp/omarchy-aws-vpn
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
