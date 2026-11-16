import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Commons as Commons
import qs.Ui

// Bar toggle for an AWS Client VPN driven by vpnctl
// (https://github.com/dhasdiel/aws-vpn). Point AWSVPN_VPNCTL at your vpnctl
// if it is not at ~/aws-vpn/vpnctl.
BarWidget {
  id: root
  moduleName: "io.github.dhasdiel.aws-vpn"

  readonly property string vpnctl: Quickshell.env("AWSVPN_VPNCTL")
      || (Quickshell.env("HOME") + "/aws-vpn/vpnctl")
  property string state: "down" // up | connecting | down

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Commons.Translations { id: strings; directory: Qt.resolvedUrl("i18n") }

  function refresh() {
    if (!statusProc.running) statusProc.running = true
  }

  Process {
    id: statusProc
    command: [root.vpnctl, "status"]
    stdout: StdioCollector {
      onStreamFinished: {
        var s = String(text).trim()
        root.state = (s === "up" || s === "connecting") ? s : "down"
      }
    }
  }

  Process {
    id: toggleProc
    command: [root.vpnctl, "toggle"]
    onExited: root.refresh()
  }

  Timer {
    // Poll faster while a login/handshake is in progress.
    interval: root.state === "connecting" ? 1000 : 4000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.state === "connecting" ? String.fromCodePoint(0xF051F) : String.fromCodePoint(0xF033E)
    // Connected = normal color, off = dimmed. ("active" would paint it in the urgent/red color.)
    dimmed: root.state === "down"
    tooltipText: root.state === "up" ? strings.t("tooltip.up")
               : root.state === "connecting" ? strings.t("tooltip.connecting")
               : strings.t("tooltip.down")
    onPressed: function(b) {
      if (b === Qt.RightButton) {
        Quickshell.execDetached(["xdg-open", Quickshell.env("XDG_RUNTIME_DIR") + "/aws-vpn/openvpn.log"])
        return
      }
      if (toggleProc.running) return
      if (root.state === "down") root.state = "connecting"
      toggleProc.running = true
    }
  }
}
