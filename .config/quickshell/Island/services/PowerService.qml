import QtQuick

QtObject {
    id: root

    signal actionRequested(string action)

    function lock() {
        actionRequested("lock");
    }

    function suspend() {
        actionRequested("suspend");
    }

    function hibernate() {
        actionRequested("hibernate");
    }

    function reboot() {
        actionRequested("reboot");
    }

    function powerOff() {
        actionRequested("poweroff");
    }
}
