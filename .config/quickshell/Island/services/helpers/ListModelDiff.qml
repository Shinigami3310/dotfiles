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

        // Удаляем элементы, отсутствующие в целевой модели (с конца, чтобы
        // индексы не сдвигались).
        for (let i = model.count - 1; i >= 0; i--) {
            if (!targetMap.has(model.get(i)[keyField])) {
                model.remove(i);
            }
        }

        // Индексная карта текущей модели для O(1) поиска.
        // Строится ПОСЛЕ удаления, чтобы индексы были актуальны.
        const modelMap = new Map();
        for (let i = 0; i < model.count; i++) {
            modelMap.set(model.get(i)[keyField], i);
        }

        // Добавляем/обновляем/перемещаем элементы.
        for (let i = 0; i < targets.length; i++) {
            const target = targets[i];
            const foundIdx = modelMap.get(target[keyField]);

            if (foundIdx !== undefined) {
                // Обновляем изменённые поля.
                for (let f = 0; f < fieldsToUpdate.length; f++) {
                    const field = fieldsToUpdate[f];
                    const item = model.get(foundIdx);
                    if (item[field] !== target[field]) {
                        model.setProperty(foundIdx, field, target[field]);
                    }
                }

                // Перемещаем в правильную позицию.
                if (foundIdx !== i) {
                    model.move(foundIdx, i, 1);
                    // После move индексы сдвигаются — перестраиваем карту.
                    modelMap.clear();
                    for (let j = 0; j < model.count; j++) {
                        modelMap.set(model.get(j)[keyField], j);
                    }
                }
            } else {
                model.insert(i, target);
                // После insert индексы сдвигаются — перестраиваем карту.
                modelMap.clear();
                for (let j = 0; j < model.count; j++) {
                    modelMap.set(model.get(j)[keyField], j);
                }
            }
        }
    }
}
