import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import "./config"
import "./services"
import "ui/center"
import "ui/toasts"

ShellRoot {
    id: root

    NotificationStore {
        id: store
    }
    NotificationService {
        id: service
        store: store
    }
    NotificationRouter {
        id: router
        service: service
    }

    NotificationServer {
        id: notificationServer
        actionsSupported: true
        imageSupported: true
        bodySupported: true
        persistenceSupported: true
        onNotification: notification => router.fromDbus(notification)
    }

    IpcHandler {
        target: "notification-center"
        function toggle(): void {
            centerWindow.visible = !centerWindow.visible;
        }
        function toggleDnd(): void {
            service.toggleDnd();
        }
        function getDndState(): bool {
            return service.dndEnabled;
        }
    }

    ToastHost {
        id: toastHost
        store: store
        service: service
    }

    CenterWindow {
        id: centerWindow
        store: store
        service: service
    }

    Component.onCompleted: service.start()
}
