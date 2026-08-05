pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    readonly property int currentWorkspaceId: Hyprland.focusedWorkspace?.id ?? 0

    function workspaceById(id: int): QtObject {
        return Hyprland.workspaces.values.find(ws => ws.id === id) ?? null;
    }

    function isOccupied(id: int): bool {
        const ws = workspaceById(id);
        return (ws?.toplevels?.values?.length ?? 0) > 0;
    }

    function isActive(id: int): bool {
        return id === currentWorkspaceId;
    }

    function activateWorkspace(id: int) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${id} })`);
    }

    Component.onCompleted: {
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
    }
}
