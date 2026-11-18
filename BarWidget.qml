import QtQuick
import Quickshell
import qs.Ui

BarWidget {
  id: root
  moduleName: "gurvindersingh-web.omalation"

  function scriptPath(name) {
    return Qt.resolvedUrl(name).toString().replace(/^file:\/\//, "")
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰗊"
    tooltipText: "Translator · click: type, middle: selection, right: language"
    onPressed: function(mouseButton) {
      if (mouseButton === Qt.RightButton)
        Quickshell.execDetached(["bash", root.scriptPath("omarchy-translate-lang")])
      else if (mouseButton === Qt.MiddleButton)
        Quickshell.execDetached(["bash", root.scriptPath("omarchy-translate")])
      else
        Quickshell.execDetached(["bash", root.scriptPath("omarchy-translate-type")])
    }
  }
}
