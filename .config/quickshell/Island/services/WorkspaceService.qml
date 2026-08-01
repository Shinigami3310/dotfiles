import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    readonly property int currentWorkspaceId: Hyprland.focusedWorkspace?.id ?? 0

    function workspaceById(id) {
        return Hyprland.workspaces.values.find(ws => ws.id === id) ?? null;
    }

    function isOccupied(id) {
        const ws = workspaceById(id);
        return (ws?.toplevels?.values?.length ?? 0) > 0;
    }

    function isActive(id) {
        return id === currentWorkspaceId;
    }

    function activateWorkspace(id) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = " + id + " })");
    }

    Component.onCompleted: {
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
    }
}
