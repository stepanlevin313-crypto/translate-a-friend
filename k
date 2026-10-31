<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fortnite Tracker | Сток и Ивенты</title>
    <style>
        :root {
            --bg-color: #0b0e14;
            --card-bg: #151a24;
            --text-main: #ffffff;
            --text-sub: #7a8b9e;
            --accent: #00bcff;
            --rarity-legendary: #d3690e;
            --rarity-epic: #ab3bc5;
            --rarity-rare: #257bc4;
            --rarity-uncommon: #4ca414;
        }

        body {
            font-family: 'Segoe UI', Roboto, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .container {
            max-width: 1000px;
            width: 100%;
            box-sizing: border-box;
        }

        h1 {
            text-align: center;
            font-size: 2.5rem;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 1px;
            background: linear-gradient(45deg, #00bcff, #9b51e0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Панель таймеров и инфо */
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
            margin-top: 20px;
        }

        .info-panel {
            background: var(--card-bg);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            border: 1px solid #222b3c;
        }

        .info-panel h3 {
            margin: 0 0 10px 0;
            color: var(--text-sub);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .timer-digits {
            font-size: 32px;
            font-weight: bold;
            color: var(--accent);
            font-variant-numeric: tabular-nums;
        }

        /* Секция витрины предметов (Сток) */
        .shop-title {
            font-size: 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 15px;
            border-left: 4px solid var(--accent);
            padding-left: 10px;
        }

        .shop-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }

        .item-card {
            background: var(--card-bg);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            transition: transform 0.2s;
            border: 1px solid #222b3c;
            display: flex;
            flex-direction: column;
        }

        .item-card:hover {
            transform: translateY(-5px);
        }

        .item-image {
            width: 100%;
            height: 200px;
            background-color: #1c2331;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        /* Заглушка вместо картинок реального API */
        .item-image::before {
            content: '👕';
            font-size: 64px;
        }

        /* Градиенты редкости для фона предметов */
        .rarity-legendary .item-image { background: radial-gradient(circle, #f0932b, #b33939); }
        .rarity-epic .item-image { background: radial-gradient(circle, #a55eea, #8854d0); }
        .rarity-rare .item-image { background: radial-gradient(circle, #45aaf2, #2d98da); }
        .rarity-uncommon .item-image { background: radial-gradient(circle, #26de81, #20bf6b); }

        .item-info {
            padding: 15px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .item-name {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .item-type {
            font-size: 12px;
            color: var(--text-sub);
            margin-bottom: 15px;
            text-transform: uppercase;
        }

        .item-footer {
            margin-top: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .item-price {
            color: #ffd700;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .rarity-badge {
            font-size: 10px;
            padding: 3px 8px;
            border-radius: 4px;
            text-transform: uppercase;
            font-weight: bold;
        }
        .rarity-legendary .rarity-badge { background: var(--rarity-legendary); }
        .rarity-epic .rarity-badge { background: var(--rarity-epic); }
        .rarity-rare .rarity-badge { background: var(--rarity-rare); }
        .rarity-uncommon .rarity-badge { background: var(--rarity-uncommon); }
    </style>
</head>
<body>

<div class="container">
    <h1>Fortnite Shop & Events</h1>
    
    <!-- Дашборд с таймерами -->
    <div class="dashboard">
        <!-- Таймер до смены стока -->
        <div class="info-panel">
            <h3>Обновление стока через:</h3>
            <div class="timer-digits" id="shopTimer">00:00:00</div>
        </div>

        <!-- Таймер до конца ивента/сезона -->
        <div class="info-panel">
            <h3>До конца сезона БП осталось:</h3>
            <div class="timer-digits" id="eventTimer">00д 00ч 00м</div>
        </div>
    </div>

    <!-- Витрина стока -->
    <div class="shop-title">Текущий Сток Магазина</div>
    <div class="shop-grid" id="shopGrid">
        <!-- Карточки сгенерируются через JavaScript -->
    </div>
</div>

<script>
// 1. Логика Таймера Магазина (до 03:00 по МСК / 00:00 UTC каждые сутки)
function updateShopTimer() {
    const now = new Date();
    
    // Создаем дату для следующего ресета в UTC
    const nextReset = new Date(Date.UTC(
        now.getUTCFullYear(),
        now.getUTCMonth(),
        now.getUTCDate() + (now.getUTCHours() >= 0 ? 1 : 0), // если 00:00 UTC уже прошло, берем следующий день
        0, 0, 0
    ));

    const diff = nextReset - now;

    const hours = String(Math.floor((diff / (1000 * 60 * 60)) % 24)).padStart(2, '0');
    const minutes = String(Math.floor((diff / (1000 * 60)) % 60)).padStart(2, '0');
    const seconds = String(Math.floor((diff / 1000) % 60)).padStart(2, '0');

    document.getElementById('shopTimer').textContent = `${hours}:${minutes}:${seconds}`;
}

// 2. Логика Таймера Сезона (пример: до конца текущего сезона)
function updateEventTimer() {
    const now = new Date();
    // Укажите точную дату окончания сезона (год, месяц-1, день, часы, минуты)
    const eventDate = new Date(2026, 11, 5, 10, 0); // Пример: 5 декабря 2026

    const diff = eventDate - now;

    if (diff <= 0) {
        document.getElementById('eventTimer').textContent = "Ивент начался!";
        return;
    }

    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = String(Math.floor((diff / (1000 * 60 * 60)) % 24)).padStart(2, '0');
    const minutes = String(Math.floor((diff / (1000 * 60)) % 60)).padStart(2, '0');

    document.getElementById('eventTimer').textContent = `${days}д ${hours}ч ${minutes}м`;
}

// 3. Фейковый генератор текущего СТОКА (в будущем сюда можно подключить бесплатное Fortnite API)
const mockItems = [
    { name: "Neon Midas", type: "Экипировка", price: 2000, rarity: "legendary" },
    { name: "Shadow Ruby", type: "Экипировка", price: 1500, rarity: "epic" },
    { name: "Axe of Champions", type: "Инструмент", price: 800, rarity: "rare" },
    { name: "Electro Shuffle", type: "Эмоция", price: 500, rarity: "epic" },
    { name: "Driver", type: "Инструмент", price: 500, rarity: "uncommon" },
    { name: "Slurp Wrap", type: "Обёртка", price: 300, rarity: "rare" }
];

function renderShop() {
    const grid = document.getElementById('shopGrid');
    grid.innerHTML = '';

    mockItems.forEach(item => {
        const card = document.createElement('div');
        card.className = `item-card rarity-${item.rarity}`;
        card.innerHTML = `
            <div class="item-image"></div>
            <div class="item-info">
                <div class="item-name">${item.name}</div>
                <div class="item-type">${item.type}</div>
                <div class="item-footer">
                    <div class="item-price">${item.price} V</div>
                    <span class="rarity-badge">${item.rarity}</span>
                </div>
            </div>
        `;
        grid.appendChild(card);
    });
}

// Запуск трекеров
setInterval(updateShopTimer, 1000);
setInterval(updateEventTimer, 60000);
updateShopTimer();
updateEventTimer();
renderShop();
</script>

</body>
</html>
