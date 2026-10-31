<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Переводчик раскладки (QWERTY <-> ЙЦУКЕН)</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
        }

        h1 {
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
            text-align: center;
        }

        .input-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #666;
            font-weight: 600;
            font-size: 14px;
        }

        textarea {
            width: 100%;
            height: 120px;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            resize: vertical;
            transition: border-color 0.3s;
        }

        textarea:focus {
            border-color: #007bff;
            outline: none;
        }

        .button-group {
            display: flex;
            gap: 10px;
        }

        button {
            flex: 1;
            padding: 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        button:hover {
            background-color: #0056b3;
        }

        button.secondary {
            background-color: #6c757d;
        }

        button.secondary:hover {
            background-color: #545b62;
        }

        .toast {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: #333;
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            font-size: 14px;
            opacity: 0;
            transition: opacity 0.3s;
            pointer-events: none;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Исправление раскладки клавиатуры</h1>
    
    <div class="input-group">
        <label for="input-text">Введите текст (перевод происходит на лету):</label>
        <textarea id="input-text" placeholder="Пример: ghbdtn, rfr ltkf?"></textarea>
    </div>

    <div class="input-group">
        <label for="output-text">Результат:</label>
        <textarea id="output-text" readonly placeholder="Здесь появится исправленный текст..."></textarea>
    </div>

    <div class="button-group">
        <button id="copy-btn">Копировать результат</button>
        <button id="clear-btn" class="secondary">Очистить</button>
    </div>
</div>

<div id="toast" class="toast">Текст скопирован!</div>

<script>
    // Карты соответствия символов
    const enChars = "qwertyuiop[]asdfghjkl;'zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>`~@#$^&";
    const ruChars = "йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮёЁ\"№;:?";

    // Создаем словари для быстрого поиска (в обе стороны)
    const enToRu = {};
    const ruToEn = {};

    for (let i = 0; i < enChars.length; i++) {
        const en = enChars[i];
        const ru = ruChars[i];
        if (ru) {
            enToRu[en] = ru;
            ruToEn[ru] = en;
        }
    }

    const inputArea = document.getElementById('input-text');
    const outputArea = document.getElementById('output-text');
    const copyBtn = document.getElementById('copy-btn');
    const clearBtn = document.getElementById('clear-btn');
    const toast = document.getElementById('toast');

    // Функция автоматического перевода
    function convertLayout(text) {
        if (!text) return '';

        // Считаем, каких символов во вводе больше, чтобы понять исходную «ошибочную» раскладку
        let enCount = 0;
        let ruCount = 0;

        for (let char of text) {
            if (enToRu[char]) enCount++;
            if (ruToEn[char]) ruCount++;
        }

        // Если латиницы больше — переводим в кириллицу, и наоборот
        const map = enCount >= ruCount ? enToRu : ruToEn;

        return text.split('').map(char => map[char] || char).join('');
    }

    // Слушатель ввода текста
    inputArea.addEventListener('input', () => {
        outputArea.value = convertLayout(inputArea.value);
    });

    // Кнопка копирования
    copyBtn.addEventListener('click', () => {
        if (!outputArea.value) return;
        
        navigator.clipboard.writeText(outputArea.value).then(() => {
            toast.style.opacity = '1';
            setTimeout(() => {
                toast.style.opacity = '0';
            }, 2000);
        });
    });

    // Кнопка очистки
    clearBtn.addEventListener('click', () => {
        inputArea.value = '';
        outputArea.value = '';
    });
</script>

</body>
</html>
