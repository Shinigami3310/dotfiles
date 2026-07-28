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
        id: appStore
    }

    NotificationService {
        id: appService
        store: appStore
    }

    NotificationRouter {
        id: appRouter
        service: appService
    }

    NotificationServer {
        id: notificationServer
        onNotification: notification => appRouter.fromDbus(notification)
    }

    IpcHandler {
        target: "notification-center"

        function toggle(): void {
            centerWindow.visible = !centerWindow.visible;
        }

        function toggleDnd(): void {
            appService.toggleDnd();
        }

        function getDndState(): bool {
            return appService.dndEnabled ? true : false;
        }
    }

    ToastHost {
        id: toastHost
        store: appStore
        service: appService
    }

    CenterWindow {
        id: centerWindow
        store: appStore
        service: appService
    }

    Component.onCompleted: appService.start()
}
