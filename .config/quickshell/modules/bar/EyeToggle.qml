import QtQuick
import "../../Singletons"
import "../../services/"

Icon {
    id: root

    source: "../../assets/icons/eye.png"
    active: service.active

    EyeService {
        id: service
    }

    signal surfaceRequested(string newName, var payload)

    onClicked: {
        service.setActive(!active);
    }

    Connections {
        target: service
        function onSurfaceRequested(newName, payload) {
            root.surfaceRequested(newName, payload);
        }
    }
}
