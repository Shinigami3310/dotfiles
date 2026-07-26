import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    id: root
    property int currentWorkspaceId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 0

    function workspaceById(id) {
        var values = Hyprland.workspaces.values;
        for (var i = 0; i < values.length; i++) {
            var ws = values[i];
            if (ws.id === id)
                return ws;
        }
        return null;
    }

    function isCurrent(id) {
        return id === currentWorkspaceId;
    }

    function isOccupied(id) {
        var ws = workspaceById(id);
        if (!ws)
            return false;

        if (!ws.toplevels || !ws.toplevels.values)
            return false;

        return ws.toplevels.values.length > 0;
    }

    function isActive(id) {
        return id === currentWorkspaceId;
    }

    function activateWorkspace(id) {
        var ws = workspaceById(id);
        if (ws) {
            ws.activate();
            return;
        }
        Quickshell.execDetached(["hyprctl", "eval", "hl.dispatch(hl.dsp.focus({ workspace = " + id + " }))"]);
        return;
    }

    Component.onCompleted: Hyprland.refreshWorkspaces()
}
