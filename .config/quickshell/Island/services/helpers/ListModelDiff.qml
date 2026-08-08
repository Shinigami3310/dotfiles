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

        // Идём с конца, чтобы remove не сдвигал индексы ещё не проверенных
        // элементов — иначе пропустим часть записей.
        for (let i = model.count - 1; i >= 0; i--) {
            if (!targetMap.has(model.get(i)[keyField])) {
                model.remove(i);
            }
        }

        // Карта ключ→индекс даёт O(1) поиск вместо O(n) на каждый элемент.
        // Строим после удаления, иначе индексы будут указывать не туда.
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

                // move сдвигает индексы всех элементов между foundIdx и i —
                // перестраиваем карту, чтобы последующие поиски были верны.
                if (foundIdx !== i) {
                    model.move(foundIdx, i, 1);
                    modelMap.clear();
                    for (let j = 0; j < model.count; j++) {
                        modelMap.set(model.get(j)[keyField], j);
                    }
                }
            } else {
                model.insert(i, target);
                // insert сдвигает индексы всех элементов после i — перестраиваем.
                modelMap.clear();
                for (let j = 0; j < model.count; j++) {
                    modelMap.set(model.get(j)[keyField], j);
                }
            }
        }
    }
}
