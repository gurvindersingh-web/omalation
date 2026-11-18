// omarchy-translate result window.
//
// A temporary floating card, in the same visual language as the Omarchy menu
// used for typing and language selection. Shown by omarchy-translate through
// `qs -p Result.qml` with its content and theme colours in the environment.
// Esc, Return, or a click outside closes it.
import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
  id: root

  function env(name, fallback) {
    var v = Quickshell.env(name)
    return v !== undefined && v !== null && String(v).length > 0 ? String(v) : fallback
  }

  function envNumber(name, fallback) {
    var n = Number(env(name, ""))
    return isFinite(n) && n > 0 ? n : fallback
  }

  readonly property color cardBase: env("TR_BG", "#0D0808")
  readonly property color cardColor: Qt.rgba(cardBase.r, cardBase.g, cardBase.b,
                                            envNumber("TR_ALPHA", 0.97))
  readonly property color fgColor: env("TR_FG", "#F5F5F5")
  readonly property color accentColor: env("TR_ACCENT", "#F60101")
  readonly property color mutedColor: env("TR_MUTED", "#786E6E")
  readonly property color scrimColor: Qt.rgba(0, 0, 0, envNumber("TR_SCRIM_ALPHA", 0.5))
  readonly property int cardRadius: envNumber("TR_RADIUS", 8)
  readonly property int bodySize: envNumber("TR_FONT_SIZE", 16)
  readonly property string titleText: env("TR_TITLE", "Translation")
  readonly property string sourceText: env("TR_SOURCE", "")
  readonly property string translationText: env("TR_TEXT", "")
  readonly property string footerText: env("TR_FOOTER", "Esc or click outside to close")

  readonly property var targetScreen: {
    var want = env("TR_SCREEN", "")
    var screens = Quickshell.screens
    for (var i = 0; i < screens.length; i++) {
      if (want.length > 0 && screens[i].name === want) return screens[i]
    }
    return screens.length > 0 ? screens[0] : null
  }

  PanelWindow {
    id: win
    screen: root.targetScreen
    anchors { top: true; left: true; right: true; bottom: true }
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "omarchy-translate"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Shortcut { sequence: "Escape"; onActivated: Qt.quit() }
    Shortcut { sequence: "Return"; onActivated: Qt.quit() }
    Shortcut { sequence: "Enter"; onActivated: Qt.quit() }

    Rectangle {
      anchors.fill: parent
      color: root.scrimColor
    }

    // Clicking the dimmed background dismisses the result.
    MouseArea {
      anchors.fill: parent
      onClicked: Qt.quit()
    }

    Rectangle {
      id: card
      anchors.centerIn: parent
      width: Math.min(parent.width * 0.62, 760)
      height: Math.min(implicitHeight, parent.height * 0.8)
      radius: root.cardRadius
      color: root.cardColor
      border.width: 1
      border.color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.45)
      opacity: 0
      scale: 0.97
      transformOrigin: Item.Center

      readonly property real pad: 24
      readonly property real headerH: Math.max(18, root.bodySize - 4)
      readonly property real sourceH: root.sourceText.length > 0 ? Math.max(20, root.bodySize - 2) : 0
      readonly property real footerH: Math.max(16, root.bodySize - 6)
      readonly property real maxBodyH: win.height * 0.55
      readonly property real bodyH: Math.min(bodyText.contentHeight, maxBodyH)
      readonly property real implicitHeight: pad * 2 + headerH + sourceH + 14 + bodyH + 16 + footerH

      // Keep clicks on the card itself from closing the window.
      MouseArea { anchors.fill: parent; onClicked: {} }

      Column {
        anchors.fill: parent
        anchors.margins: card.pad

        Text {
          width: parent.width
          height: card.headerH
          text: root.titleText
          color: root.accentColor
          font.pixelSize: Math.max(11, root.bodySize - 4)
          font.weight: Font.DemiBold
          elide: Text.ElideRight
          verticalAlignment: Text.AlignVCenter
        }

        Text {
          width: parent.width
          height: card.sourceH
          visible: card.sourceH > 0
          text: root.sourceText
          color: root.mutedColor
          font.pixelSize: Math.max(10, root.bodySize - 5)
          font.italic: true
          elide: Text.ElideRight
          verticalAlignment: Text.AlignVCenter
        }

        Item { width: parent.width; height: 14 }

        Flickable {
          id: bodyFlick
          width: parent.width
          height: card.bodyH
          contentWidth: width
          contentHeight: bodyText.contentHeight
          clip: true
          boundsBehavior: Flickable.StopAtBounds
          flickableDirection: Flickable.VerticalFlick

          TextEdit {
            id: bodyText
            width: bodyFlick.width
            text: root.translationText
            color: root.fgColor
            font.pixelSize: root.bodySize
            readOnly: true
            selectByMouse: true
            textFormat: TextEdit.PlainText
            wrapMode: TextEdit.Wrap
            selectionColor: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.35)
          }
        }

        Item { width: parent.width; height: 16 }

        Text {
          width: parent.width
          height: card.footerH
          text: root.footerText
          color: root.mutedColor
          font.pixelSize: Math.max(10, root.bodySize - 5)
          elide: Text.ElideRight
          verticalAlignment: Text.AlignVCenter
        }
      }

      ParallelAnimation {
        id: intro
        NumberAnimation { target: card; property: "opacity"; to: 1; duration: 120; easing.type: Easing.OutCubic }
        NumberAnimation { target: card; property: "scale"; to: 1; duration: 160; easing.type: Easing.OutCubic }
      }
      Component.onCompleted: intro.start()
    }
  }
}
