import QtQuick

// Общий хелпер для синхронизации ListModel с целевым массивом объектов.
// Используется в WifiService, BluetoothService и AppService для устранения
// дублирования логики remove/move/insert/update.
QtObject {
    function sync(model, targets, keyField, fieldsToUpdate = []) {
        if (!model || !targets)
            return;

        const targetMap = new Map();
        for (let i = 0; i < targets.length; i++) {
            targetMap.set(targets[i][keyField], targets[i]);
        }

        // Удаляем элементы, отсутствующие в целевой модели
        for (let i = model.count - 1; i >= 0; i--) {
            if (!targetMap.has(model.get(i)[keyField])) {
                model.remove(i);
            }
        }

        // Добавляем/обновляем/перемещаем элементы
        for (let i = 0; i < targets.length; i++) {
            const target = targets[i];
            let foundIdx = -1;

            for (let j = 0; j < model.count; j++) {
                if (model.get(j)[keyField] === target[keyField]) {
                    foundIdx = j;
                    break;
                }
            }

            if (foundIdx !== -1) {
                // Обновляем изменённые поля
                for (let f = 0; f < fieldsToUpdate.length; f++) {
                    const field = fieldsToUpdate[f];
                    const item = model.get(foundIdx);
                    if (item[field] !== target[field]) {
                        model.setProperty(foundIdx, field, target[field]);
                    }
                }

                // Перемещаем в правильную позицию
                if (foundIdx !== i) {
                    model.move(foundIdx, i, 1);
                }
            } else {
                model.insert(i, target);
            }
        }
    }
}