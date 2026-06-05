-----------Tasks by Carpov Courses--------------------


-----------Сами таблицы--------------------


-- Таблица orders
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_created_time TIMESTAMP WITHOUT TIME ZONE,
    order_delivered_customer_time TIMESTAMP WITH TIME ZONE,
    order_estimated_delivery_time TIMESTAMP WITH TIME ZONE,
    order_status CHARACTER VARYING
);

-- Таблица products
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_brand CHARACTER VARYING,
    product_category_name CHARACTER VARYING,
    product_height_cm INTEGER,
    product_length_cm INTEGER,
    product_weight_g NUMERIC,
    product_width_cm INTEGER
);

-- Таблица events (с составным ключом)
CREATE TABLE events (
    client CHARACTER VARYING,
    actions_name CHARACTER VARYING,
    date DATE,
    PRIMARY KEY (client, actions_name, date)
);

-- Таблица oper (с составным ключом)
CREATE TABLE oper (
    client CHARACTER VARYING,
    type CHARACTER VARYING,
    amount INTEGER,
    date DATE,
    PRIMARY KEY (client, type, date)
);

-- Таблица order_items (с составным ключом)
CREATE TABLE order_items (
    order_id INTEGER,
    order_item_id INTEGER,
    product_id INTEGER,
    price NUMERIC,
    PRIMARY KEY (order_id, order_item_id)
);

-- Таблица customers
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_city CHARACTER VARYING,
    customer_zip_code INTEGER,
    gender CHARACTER VARYING,
    birth_date DATE,
    created_at DATE,
    preferred_categories CHARACTER VARYING[]  -- ARRAY тип в PostgreSQL
);

-- Таблица customer_actions
CREATE TABLE customer_actions (
    customer_id INTEGER REFERENCES customers(customer_id),
    order_id INTEGER,
    product_id INTEGER,
    event_type CHARACTER VARYING,
    event_timestamp TIMESTAMP WITHOUT TIME ZONE
);


-- Таблица accounts (счета)
CREATE TABLE accounts (
    account_num INTEGER PRIMARY KEY,
    date DATE,
    summa_usd NUMERIC
);

-- Таблица clients (клиенты)
CREATE TABLE clients (
    client_id CHARACTER VARYING PRIMARY KEY,
    account_num INTEGER REFERENCES accounts(account_num),
    fio CHARACTER VARYING,
    region CHARACTER VARYING
);












-----------Тренировки--------------------
Порядок ВЫПОЛНЕНИЯ SQL - запроса: 
1. FROM(и JOIN) 
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. ORDER BY
7.LIMIT/ OFFSET 

-- SQL сначала берёт таблицу и присоединение (FROM/JOIN),
-- потом оставляет только строки со статусом «доставлен» (WHERE),
-- потом группирует результаты (GROUP BY),
-- после чего фильтрует группы по условию (HAVING),
-- выбирает нужные поля (SELECT),
-- сортирует (ORDER BY)
-- и только в конце применяет ограничение на количество (LIMIT).
SELECT
  o.customer_id,
  COUNT(*)
FROM orders AS o
WHERE o.order_status = 'Delivered'
GROUP BY o.customer_id
HAVING COUNT(*) > 3
ORDER BY COUNT(*) DESC
LIMIT 5;





------------------------ORDER BY + LIMIT 100------------------------
SELECT
  DISTINCT customer_id,
  product_id
FROM
  customer_actions
ORDER BY
  customer_id
LIMIT
  100 
  
  
  
  
  
------------------------ COUNT ------------------------
  COUNT(*) считает  все строки, в т.ч., где есть NULL 
  COUNT(column) — только строки, где в column не NULL.
  
--Пример:
SELECT
  COUNT(*) as total_customers, -- будет 10,000
  COUNT(birth_date) as customers_with_birthdate -- будет 9,892
FROM customers;

-- Этот запрос покажет общее количество клиентов в таблице - total_customers 
-- и сколько из них указали дату рождения - customers_with_birthdate
SELECT 
    COUNT(*) AS total_customers,
    COUNT(birth_date) AS customers_with_birthdate
FROM customers;








------------------------ Примеры использования ROUND, CEIL, FLOOR ------------------------
SELECT
    product_id,
    price,
    ROUND(price, 1) AS round_price,  -- округление числа до указанного количества знаков после запятой
    CEIL(price) AS ceil_price,       -- округление числа вверх
    FLOOR(price) AS floor_price      -- округление числа вниз
FROM order_items;

-- Функция SUBSTRING(str, start, length) - извлекает часть строки
SELECT SUBSTRING('2023-10-01', 1, 4);  -- результат: 2023


-- Функция REPLACE(str, old_substr, new_substr) - заменяет подстроку
SELECT REPLACE('user@domain', '@', '(at)');  -- результат: user(at)domain


-- Функция TRIM(str) - удаляет пробелы по краям
SELECT TRIM('  Hello  ');  -- результат: Hello


-- Функция SPLIT_PART(str, разделитель, позиция) - разбивает строку на части
SELECT SPLIT_PART('user@domain.com', '@', 2);  -- результат: domain.com


-- Примеры применения строковых функций
SELECT
    product_brand,
    product_category_name,
    SUBSTRING(product_brand, 1, 5) AS brand_part,         -- извлекает часть строки
    REPLACE(product_brand, ' ', '_') AS brand_modified,   -- заменяет подстроку
    TRIM('  Hello  ') AS clean_text,                     -- удаляет пробелы по краям
    SPLIT_PART(product_brand, ',', 1) AS first_part       -- разбивает строку по частям
FROM products;







------------------------ DISTINCT ------------------------
-- для вывода уникальных значений
SELECT DISTINCT product_brand
FROM products;


-- DISTINCT внутри агрегирующих функций
SELECT
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;


-- Уникальные сочетания сразу нескольких столбцов
SELECT DISTINCT customer_city, customer_zip_code
FROM customers;








------------------------ WHERE ------------------------
-- Фильтрация данных с WHERE
SELECT *
FROM products
WHERE product_id = 1
ORDER BY product_brand DESC
LIMIT 10;



-- Операторы сравнения в WHERE
SELECT *
FROM products
WHERE product_length_cm > 10;

SELECT *
FROM products
WHERE product_weight_g >= 1000;

SELECT *
FROM products
WHERE product_category_name != 'Одежда';

SELECT *
FROM products
WHERE product_weight_g BETWEEN 1000 AND 2000;



-- Комбинирование условий с AND, OR, NOT
SELECT *
FROM products
WHERE product_weight_g > 1000 AND product_category_name = 'Бытовая техника';

SELECT *
FROM products
WHERE product_weight_g > 1000 OR product_category_name = 'Бытовая техника';

SELECT *
FROM products
WHERE NOT product_category_name = 'Бытовая техника';



-- Оператор IN для проверки наличия в списке
SELECT *
FROM products
WHERE product_category_name IN ('Электроника', 'Одежда');

SELECT *
FROM products
WHERE product_category_name NOT IN ('Электроника', 'Одежда');



-- Оператор LIKE для поиска по шаблону
SELECT *
FROM products
WHERE product_name LIKE '%куртка%';



------------------------ CASE ------------------------


-- Оператор CASE для условной логики
SELECT
    product_id,
    price,
    CASE
        WHEN price < 10000 THEN 'small_price'
        WHEN price >= 10000 AND price < 40000 THEN 'medium_price'
        ELSE 'big_price'
    END AS price_type
FROM order_items
LIMIT 100;

SELECT
    customer_id,
    customer_city,
    CASE
        WHEN customer_city = 'Санкт-Петербург' OR customer_city = 'Екатеринбург' 
            THEN customer_city
        ELSE 'другой город'
    END AS city_type
FROM customers;




-- CASE внутри агрегирующих функций
SELECT
    product_category_name,
    COUNT(CASE WHEN product_weight_g > 1000 THEN 1 END) AS large_count,
    COUNT(CASE WHEN product_weight_g <= 1000 THEN 1 END) AS tiny_count
FROM products
GROUP BY product_category_name;









------------------------ Работа с датами ------------------------
SELECT DATE_PART('year', '2024-10-05');  -- результат: 2024

SELECT DATE_TRUNC('month', '2024-10-05 14:30:45');  -- результат: 2024-10-01 00:00:00

SELECT '2024-05-01' - INTERVAL '1 month';  -- результат: 2024-04-01
SELECT '2024-05-01' + INTERVAL '1 day';    -- результат: 2024-05-02



SELECT 
customer_id, 
created_at, 
created_at + INTERVAL ' 5 days ', -- дата 5 дней после регистрации
created_at - INTERVAL ' 5 days '  -- дата 5 дней до регистрации
FROM 
customers

--Примеры различных промежутков:
INTERVAL ' 1 day '      -- 1 день
INTERVAL ' 7 days '     -- 7 дней (1 неделя)
INTERVAL ' 2 weeks '    -- 2 недели

INTERVAL ' 3 hours '    -- 3 часа
INTERVAL ' 30 minutes ' -- 30 минут  
INTERVAL ' 45 seconds ' -- 45 секунд
INTERVAL ' 2 hours 15 minutes ' -- 2 часа 15 минут

INTERVAL ' 1 month '    -- 1 месяц
INTERVAL ' 3 months '   -- 3 месяца
INTERVAL ' 1 year '     -- 1 год
INTERVAL ' 2 years '    -- 2 года
INTERVAL ' 6 months '   -- полгода


--При помощи INTERVAL можно решать множество практических задач. Например:
-- Заказы за последние 24 часа
SELECT order_id, order_created_time
FROM orders
WHERE order_created_time >= NOW() - INTERVAL ' 24 hours '
ORDER BY order_created_time DESC;

-- Заказы, которые должны быть доставлены в ближайшие 2 дня
SELECT order_id, order_estimated_delivery_time
FROM orders
WHERE order_estimated_delivery_time BETWEEN NOW() AND NOW() + INTERVAL ' 2 days '
ORDER BY order_estimated_delivery_time;





------ NOW()
возвращает текущие дату и время (с часовым поясом сервера).
Пример: NOW() = ' 2024 -07 -20 15 :30 :45.123456 + 03 '

Если нужно посчитать разницу между датами, то достаточно использовать оператор -, чтобы получить интервал разницы между датами.
Пример: NOW() - created_at AS time_diff_interval = interval в формате DD days HH:MM:SS.ssssss.


SELECT
  customer_id,
  created_at,
  NOW() AS current_time, — текущее время
  NOW() - created_at AS date_diff, — разница между текущей датой и регистрацией
  DATE_PART(' year ', created_at) AS created_year, — год создания
  DATE_PART(' month ', created_at) AS created_month, – месяц создания
  created_at + INTERVAL ' 3 days ' AS created_at_3 – дата создания + 3 дня
FROM
  customers;








------------------------ CAST() ------------------------
------перевести один тип данных в другой------

--1. Функция CAST()
Синтаксис: CAST(значение AS ТИП)

Пример: SELECT CAST(' 123 ' AS INTEGER) = 123
Пример: SELECT CAST(123 AS TEXT) = ' 123 '


--2. Оператор ::
Просто добавьте к значению или к столбцу символ :: и укажите, в какой тип данных вы их переводите.

Пример: SELECT ' 123 '::INTEGER = 123 (из строки в число)
Пример: SELECT 123::VARCHAR = ' 123 ' (из числа в строку)
Пример: SELECT ' 2023 -10 -01 '::DATE = 2023-10-01 (из строки в дату)

Если преобразование невозможно (например, ' abc '::INT), PostgreSQL вернёт ошибку.


Существует такое понятие, как неявное преобразование, когда PostgreSQL автоматически конвертирует типы в некоторых случаях:

SELECT 5 + ' 10 ' =  15 (строка ' 10 ' конвертировалась автоматически в число 10)
SELECT NOW() + ' 1 day ' = текущая дата + 1 день (строка 1 day конвертировалась автоматически в интервал)


Но! Это работает не всегда:
SELECT ' 100 ' + ' 200 ';  — ошибка: неявное преобразование в число не сработает.







------------------------ NULL ------------------------
В базах данных NULL — это специальный маркер, который указывает на отсутствие значения. 
Важно понимать, что NULL — это не то же самое, что пустая строка или число 0. 
NULL означает, что данные либо неизвестны, либо неприменимы. 
Например, если у пользователя не указан дополнительный email, это поле может быть NULL.

Чтобы проверить, содержит ли столбец значение NULL, мы используем операторы 
IS NULL 
или 
IS NOT NULL

Например, так можно выбрать все продукты, у которых не указан product_id. 
SELECT 
*
FROM products
WHERE product_id IS NULL









------------------------ COALESCE ------------------------
--заменить одно значение, на какое-то конкретное при выводе данных или в вычислениях.
подставить другой столбец в COALESCE. 
Например, если product_category_name NULL, то заполнить его значением из product_brand.

SELECT 
product_id,
COALESCE(product_category_name, product_brand) AS product_name
FROM products
--WHERE product_category_name IS NULL (чтобы посмотреть только преобразования)


--заменить NULL
функция COALESCE просматривает свои аргументы по порядку и возвращает первый из них, который не является NULL. 
Если все аргументы NULL, то и результат будет NULL.


--Например, если у клиента не заполнен пол, то мы можем вывести стандартный текст:
-- сли gender для какого-то клиента будет NULL, то в колонке gender для этого клиента отобразится ' П о л н е у к а з а н '. 
--Если же gender не NULL, то отобразится само значение поля.
SELECT 
customer_id,
COALESCE(gender, ' Пол неуказан ') AS gender
FROM customers 
WHERE gender IS NULL




------ Подзапрос в операторе CASE ------
при формировании продвинутых условных конструкций.

--Сравнение со скалярным подзапросом:
CASE WHEN price > (SELECT AVG(price) FROM products) THEN 'Дорогой' ELSE 'Дешевый' END


--Проверка вхождения в список с помощью IN:
CASE WHEN customer_id IN (SELECT customer_id FROM vip_clients) THEN 'VIP' ELSE 'Обычный' END


--Проверка существования с помощью EXISTS:
CASE WHEN EXISTS (SELECT 1 FROM cancelled_orders co WHERE co.customer_id = c.customer_id) THEN 'Ненадежный' ELSE 'Надежный' END








------------------------ Группировка ------------------------
------------------------ GROUP BY ------------------------
Представьте, что вам нужно не просто отфильтровать товары, а посчитать, 
сколько товаров каждого бренда представлено в нашем маркетплейсе. 
Или, например, найти среднюю цену товаров в каждой категории. 


оператор позволяет сгруппировать строки с одинаковыми значениями в указанных столбцах в одну сводную строку. 
Чаще всего его используют вместе с агрегатными функциями

!!!! Важно, что колонки, указанные в SELECT, должны находиться и в GROUP BY, 
если они не используются в агрегирующих функциях. Это обязательное условие, 
и если оно не будет выполнено, то база данных вернёт ошибку. 


Возможность использовать алиас внутри GROUP BY есть не в каждой СУБД, 
поэтому при работе с другими инструментами будьте аккуратны — 
в общем случае рекомендуется дублировать расчётное поле в блоке GROUP BY и не использовать в нём алиасы колонок из SELECT.



--Выбрать (SELECT) название категории и посчитать количество (COUNT) всех строк 
--для каждой из них из (FROM) таблицы products, сгруппировав (GROUP BY) результат 
--по названию категории
SELECT
  product_category_name,
  COUNT(*) as products_count
FROM products
GROUP BY -- собирает все строки с одинаковым product_category_name в одну группу, и затем COUNT(*) считает, сколько их в каждой такой группе.
  product_category_name
ORDER BY products_count;

-- ессли группировка по нескольким полям
-- обязательно указать столько же и в GROUP BY, кроме агрегирующей
SELECT
  product_category_name,
  product_brand, 
  COUNT(*) as products_count
FROM
  products
GROUP BY
  product_category_name,
  product_brand





------Группировка с преобазованной датой------
Представь, что мы хотим посчитать количество заказов по месяцам. 
В таблице orders есть колонка order_created_time с точной датой и временем. 
Нам нужно "округлить" эту дату до месяца. 
Для этого идеально подходит функция DATE_TRUNC(' month ', timestamp_column). 
Она "отсекает" от даты всё, что точнее месяца, приводя любую дату к первому числу этого месяца.

Например:
DATE_TRUNC(' month ', ' 2024 -07 -15 10 :30 :00 ') вернет 2024-07-01 00:00:00.
DATE_TRUNC(' month ', ' 2024 -07 -28 22 :15 :00 ') тоже вернет 2024-07-01 00:00:00.
Таким образом, все заказы за июль попадут в одну группу! 


SELECT
  DATE_TRUNC(' month ', order_created_time) AS order_month,
  COUNT(order_id) AS orders_count
FROM
  orders
GROUP BY
  order_month;





------------------------ фильтрация после группировки ------------------------
------------------------ HAVING ------------------------
Для фильтрации после группировки в SQL есть специальный инструмент — оператор HAVING.

HAVING работает почти так же, как WHERE, но применяется к результатам агрегатных функций (COUNT, SUM, AVG и т. д.)
-- WHERE  используется для фильтрации отдельных строк, 
-- HAVING — для фильтрации результатов, сгруппированных с помощью GROUP BY.


--Найдём все заказы на сумму больше 1000 руб.
SELECT
--Выбираем ID заказов и считаем для каждого количество позиций и общую сумму заказа.
  order_id,
  COUNT(order_item_id) as total_items,
  SUM(price) as total_spent
FROM
  order_items 
GROUP BY
-- Группируем результаты по заказам. 
--На этом шаге у нас есть таблица с общей суммой и количеством позиций внутри каждого заказа.
  order_id
HAVING
  SUM(price) > 1000;
-- Покажи мне из этих сгруппированных результатов только те строки (те заказы), 
--у которых общая сумма (SUM) больше 1000».









------------------------JOIN------------------------

Если имя столбца, по которому мы соединяем таблицы, полностью совпадает 
в обеих таблицах (как, например, customer_id в таблицах orders и customers), 
то конструкцию ON можно заменить на USING.

Как было: JOIN customers AS c ON o.customer_id = c.customer_id
Как стало: JOIN customers AS c USING(customer_id)


------ INNER JOIN ------

INNER JOIN (внутренний JOIN)
--находит пересечения двух таблиц по ключу(выберет только те customer_id, 
--которые есть в обеих таблицах).

--По умолчанию JOIN — это то же самое, что и INNER JOIN. 

--Выбери (SELECT) ID заказа, статус заказа, город клиента и дату его рождения из 
--(FROM) таблицы orders (назовём её o), присоединив (JOIN) к ней таблицу customers 
--(назовем её c) по условию (ON), что customer_id в обеих таблицах равны. 
--Верни (LIMIT) первые 10 строк».

Запрос будет выглядеть так:
SELECT 
    o.order_id, 
    o.order_status,
    c.customer_city,
    c.birth_date
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
LIMIT 10;




------ LEFT JOIN ------

LEFT JOIN 
--использует все строки первой (левой) таблицы, объединяя с теми строками, 
--которые нашлись во второй (правой) таблице.
-- если для левой таблицы значения из правой не найдены, то будет стоять NULL

SELECT c.customer_id,
c.city,
s.purchase
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id


Одна из его суперспособностей — находить тех, у кого чего-то нет.
-- Мы делаем LEFT JOIN, а затем в WHERE просим показать только те строки, 
--где поля из правой (присоединённой) таблицы остались пустыми (IS NULL).

--Например, чтобы найти всех клиентов, которые ни разу ничего не заказали: 
--customers LEFT JOIN orders ... WHERE orders.order_id IS NULL. 
-- Этот приём — один из самых важных в аналитике!

--Найдите всех клиентов, которые зарегистрировались в системе, 
--но ещё не совершили ни одного действия в таблице customer_actions
-- Выведите их customer_id и дату регистрации created_at. 
-- Отсортируйте по возрастанию customer_id

SELECT 
c.customer_id,
c.created_at
FROM customers AS c
LEFT JOIN customer_actions AS ca
ON c.customer_id = ca.customer_id 
WHERE ca.event_type is NULL
ORDER BY c.customer_id ASC





------ RIGHT JOIN ------

RIGHT JOIN
-- использует все строки второй (правой) таблицы, объединяя с теми строками, 
--которые нашлись в первой (левой) таблице.

-- Честно говоря, RIGHT JOIN используется редко. Почему? 
--Потому что любой RIGHT JOIN можно переписать как LEFT JOIN, 
--просто поменяв таблицы местами. 

SELECT c.customer_id,
c.city,
s.purchase
FROM customers c
RIGHT JOIN sales s ON c.customer_id = s.customer_id

--Аналогично с LEFT JOIN
SELECT c.customer_id,
c.city,
s.purchase
FROM sales s
LEFT JOIN customers c ON c.customer_id = s.customer_id




------ FULL OUTER JOIN ------

FULL OUTER JOIN
--объединяет все записи по ключу.Если находятся совпадения – заполняются нужные 
--поля, если нет - ставится NULL

SELECT c.customer_id,
c.city,
s.purchase
FROM customers c
FULL OUTER JOIN sales s ON c.customer_id = s.customer_id






------ цепочки из JOIN ------ 
--Представьте, что нам нужно узнать категорию товара (products) из конкретного 
--заказа (orders) и город клиента (customers), который его сделал. 
--Путь будет таким: customers -> orders -> order_items -> products

-- Мы просто последовательно добавляем JOIN для каждой новой таблицы.
-- Cначала «приклеили» к клиентам их заказы, затем к заказам — товарные 
-- позиции, а уже к ним — информацию о самих товарах. 
-- Главное — правильно указать условия ON для каждой пары таблиц.
SELECT
    c.customer_city,
    o.order_status,
    p.product_category_name
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
LIMIT 10;





------------------------UNION/EXCEPT/INTERSECT------------------------

--UNION
Склеивает результаты двух запросов друг под другом 
и автоматически удаляет повторяющиеся строки.

SELECT customer_id, city
FROM A
UNION
SELECT customer_id, city
FROM B

--Показать всех клиентов, которые когда-либо оформляли заказ, 
--либо совершали действие на сайте.
Эту задачу мы могли бы решить и с помощью OUTER JOIN.

SELECT customer_id FROM orders
UNION
SELECT customer_id FROM customer_actions



--UNION ALL
Тоже объединяет две выборки построчно, но НЕ убирает дубликаты 
— если одинаковая строка встречается и там, и там, она попадёт в результат 
столько раз, сколько встретилась.

SELECT customer_id, city
FROM A
UNION ALL
SELECT customer_id, city
FROM B


--EXCEPT
Показывает только те строки, которые есть в первой выборке, но отсутствуют 
во второй (аналог разности: A - B).
(найти тех пользователей, которые есть в таблице A, но нет в таблице B)
SELECT customer_id, city
FROM A
EXCEPT
SELECT customer_id, city
FROM B


--Показать клиентов, которые совершали действие, 
--но не оформили заказ (например, когда клиент добавил товар в корзину, но не оплатил).
Эту задачу мы могли решить и с помощью LEFT JOIN.

SELECT customer_id FROM customer_actions
EXCEPT
SELECT customer_id FROM orders


--Проверка на то, что все активные пользователи есть в таблице регистрации.
Мы получили 0 строк. Значит, все пользователи зарегистрированы.

SELECT customer_id FROM customer_actions
EXCEPT
SELECT customer_id FROM customers



--INTERSECT
Оставляет только те строки, которые появились и в первом, и во втором 
запросе (пересечение множеств).

SELECT customer_id, city
FROM A
INTERSECT
SELECT customer_id, city
FROM B


--Показать клиентов, которые и оформили заказ, и совершали действие.
Эту задачу мы могли решить и с помощью INNER JOIN.

SELECT customer_id FROM orders
INTERSECT
SELECT customer_id FROM customer_actions



Главные требования:
- Количество и порядок столбцов в обеих выборках должны совпадать.
- Типы данных столбцов должны быть совместимыми.



Пример для понимания:
Есть две группы клиентов: из Москвы и из Санкт-Петербурга.

--UNION 
покажет всех клиентов из двух городов, ни одной строки не «дублируя».

--UNION ALL 
покажет всех, в том числе тех, кто (теоретически) живёт в обоих городах.

--EXCEPT 
«московские минус питерские».

--INTERSECT 
покажет только тех, кто есть и там, и там (в жизни так не бывает для городов, но идея понятна).








 ------------------------ Подзапрос (subquery) ------------------------
Применение:
- если нам нужно отфильтровать данные по условию, которое само по себе требует вычисления

Например, найти все товары, цена которых выше средней по всему каталогу. 
Или найти все заказы клиентов из самого популярного города. 
Сначала нам нужно вычислить эту среднюю цену или найти этот самый популярный город, 
а уже потом использовать полученное значение в запросе.

--Представьте, что мы хотим найти все товары, которые стоят дороже, 
--чем средняя цена всех товаров.

-- 1) Внешний запрос: SELECT product_id, ... FROM order_items WHERE price > ...
--Это основной запрос, который вернёт нам итоговый результат.
-- 2) Внутренний запрос (подзапрос): (SELECT AVG(price) FROM order_items)
--Этот запрос, заключённый в скобки, выполняется первым.

SELECT 
    product_id,
    price
FROM order_items
WHERE price > (SELECT AVG(price) FROM order_items);


--Подзапросы очень часто используются с оператором IN. 
--Например, нам нужно найти все заказы, сделанные клиентами из города Москвы.

- subquery OR join?
Если необходимо найти данные из другой таблицы, НО выводить их НЕ надо, то использовать subquery
Если при обращении к другой таблице необходимо также вывести и её данные, то - join

SELECT
    order_id,
    order_status,
    order_created_time
FROM orders
WHERE customer_id IN (SELECT customer_id FROM customers WHERE customer_city = 'Москва');




------------- Где прописываются? -------------

-- Подзапросы могут применяться:

-- 1) в операторе SELECT

--В результате мы получим таблицу, где в каждой строке будет product_id, его price 
--и столбец overall_average_price, в котором всегда будет одно и то же число — общая средняя цена.

SELECT
    product_id,
    price,
    (SELECT AVG(price) FROM order_items) AS overall_average_price
FROM order_items;



-- 2.1) в операторе WHERE
SELECT 
    product_id,
    price
FROM order_items
WHERE price > (SELECT AVG(price) FROM order_items);


 -- 2.2) в операторе HAVING
-- Он работает так же, как и в WHERE, но применяется для фильтрации сгруппированных 
--данных. 
-- Например, можно найти только те категории товаров, средняя цена в которых выше 
--общей средней цены по всему каталогу.

SELECT
    p.product_category_name,
    AVG(oi.price) as category_avg_price
FROM
    order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY
    p.product_category_name
HAVING
    AVG(oi.price) > (SELECT AVG(price) FROM order_items);

-- Здесь HAVING сравнивает среднюю цену для каждой группы (category_avg_price) со 
--значением, вычисленным скалярным подзапросом (общей средней ценой).
 
 

-- 3) в операторе FROM

SELECT column_1 
FROM ( 
SELECT column_1, column_2 
FROM table 
) AS subquery_1

-- По сути, подзапрос — это такая же таблица, только временная. 
-- Она формируется в процессе выполнения основного запроса и нигде не сохраняется.

-- В примере выше сначала будет выполнен подзапрос, который отберёт колонки 
-- column_1 и column_2 из таблицы table, а затем уже из образовавшейся таблицы основной 
-- запрос выберет колонку column_1.




-- 4) в операторе CASE 
при формировании продвинутых условных конструкций.

--Сравнение со скалярным подзапросом:
CASE WHEN price > (SELECT AVG(price) FROM products) THEN 'Дорогой' ELSE 'Дешевый' END


--Проверка вхождения в список с помощью IN:
CASE WHEN customer_id IN (SELECT customer_id FROM vip_clients) THEN 'VIP' ELSE 'Обычный' END


--Проверка существования с помощью EXISTS:
CASE WHEN EXISTS (SELECT 1 FROM cancelled_orders co WHERE co.customer_id = c.customer_id) THEN 'Ненадежный' ELSE 'Надежный' END






-- 5) JOIN

--Найти все заказы с общей суммой товаров более 100 000.
SELECT DISTINCT o.*
FROM orders o
JOIN (
    SELECT order_id
    FROM order_items
    GROUP BY order_id
    HAVING sum(price) > 100000
) expensive ON o.order_id = expensive.order_id





------------- Многоуровенвая вложенность -------------

-- Внутри одного запроса может быть сразу несколько подзапросов. 
--Более того, уровней вложенности может быть тоже несколько:

SELECT column_1 
FROM ( 
SELECT column_1, column_2 
FROM ( 
SELECT column_1, column_2, column_3 
FROM table 
) AS subquery_1 
) AS subquery_2


-- В данном случае последовательность работы запроса такая: 
1) сначала будет выполнен подзапрос, возвращающий результат subquery_1, 
2) затем — подзапрос, возвращающий результат subquery_2, 
3) и только потом в результат основного подзапроса попадёт колонка column_1.







 -------------  операторы EXISTS и NOT EXISTS ------------- 

Эти операторы проверяют наличие или отсутствие строк из подзапроса 
и возвращают булево значение — TRUE или FALSE. 
Они очень полезны, когда надо проверить, существуют ли связанные данные.


Почему в подзапросе часто пишут SELECT 1? 
Для оператора EXISTS не важны сами данные, которые выбирает подзапрос, 
достаточно узнать, есть ли хоть одна строка. 
Поэтому обычно пишут SELECT 1 или SELECT * — это вполне равноценно.


--Пример: найдём всех клиентов, которые хотя бы раз делали заказ.

--Здесь подзапрос для каждого клиента ищет хоть один заказ с тем же customer_id. 
--Если такой заказ найден, клиент попадает в итог.

SELECT
    c.customer_id,
    c.customer_city
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);


-- Пример: найдём всех клиентов, которые никогда не делали заказов.

SELECT
    c.customer_id,
    c.customer_city
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);







 ------------- CTE -------------

CTE, или обобщенное табличное выражение, — это, по сути, именованный подзапрос. 
Вы объявляете его в самом начале с помощью ключевого слова WITH, даёте ему имя, 
а затем можете ссылаться на него (даже несколько раз) в основном запросе как на обычную таблицу.

--Синтаксис такой:
WITH my_cte_name AS 
--( ... твой подзапрос здесь ... ) 
SELECT * FROM my_cte_name;

-- Например,
WITH spb_customers AS (
  SELECT 
      customer_id
      , gender
      , birth_date
      , customer_city
  FROM customers
  WHERE customer_city = 'Санкт-Петербург'
)

SELECT *
FROM spb_customers

После оператора WITH указывается название табличного выражения (здесь my_cte_name), 
а затем после ключевого слова AS в скобках указывается сам запрос, 
с помощью которого будет формироваться табличное выражение. 
Затем в основной части запроса к табличному выражению можно обращаться по имени, как к таблице.


-- 1-ая временная таблица
WITH samara_customers AS (
    SELECT customer_id
    FROM customers
    WHERE customer_city = 'Самара'
),

-- 2-ая временная таблица, где в подзапросе вызывается 1-ая
samara_orders AS (
    SELECT order_id
    FROM orders
    WHERE customer_id IN (SELECT customer_id FROM samara_customers)
)

-- Запрос с вызовом CTE
SELECT DISTINCT
    oi.product_id,
    p.product_brand,
    oi.price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id IN (SELECT order_id FROM samara_orders);

















--------------------------- Задания--------------------------- 
--------------------------- Урок 1 --------------------------- 
-- Задание 1.1:
-- Напишите SQL-запрос, который выводит все столбцы таблицы products, сортируя результат по возрастанию product_id и по убыванию поля product_brand.

SELECT
*
FROM order_items
ORDER BY product_id ASC, product_brand DESC




-- Задание 1.2:
-- Напишите SQL-запрос, который выведет все столбцы из таблицы order_items и ограничит результат тремя строками.

SELECT
*
FROM order_items
LIMIT 3



-- Задание 1.3:
-- Найдите топ-10 самых тяжёлых продуктов, используя поле product_weight_g. Выведите идентификатор продукта, его вес и название его категории. 

SELECT
product_id,
product_weight_g,
product_category_name
FROM products
ORDER BY product_weight_g DESC
LIMIT 10




-- Задание 1.4: 
-- Снова нужно подготовить руководству отчёт со сводкой всех товаров на нашем маркетплейсе. Его нужно сделать в определённом формате. Попробуйте.
-- Для каждого товара нужно вывести следующие данные:
-- 1) Идентификатор продукта.
-- 2) Длину (переименовать в length_cm), ширину (переименовать в width_cm), высоту (переименовать в height_cm).
-- 3) Объём товара в кубических метрах. Объём — это произведение длины, ширины и высоты. Для перевода в кубические метры нужно разделить объём на 1 000 000. Назвать volume_m3.


SELECT
product_id,
product_length_cm AS length_cm,
product_width_cm AS width_cm,
product_height_cm AS height_cm,
(product_length_cm * product_width_cm * product_height_cm)/1000000.0 AS volume_m3
FROM products
LIMIT 10




-- Задание 1.5:

-- Продолжаем делать отчёт. Давайте добавим в него ещё деталей:
-- 1) Идентификатор продукта
-- 2) Длину (переименовать в length_cm), ширину (переименовать в width_cm), высоту (переименовать в height_cm)
-- 3) Объём товара в кубических метрах, теперь округлённый до одного знака после запятой. Назвать round_volume_m3
-- 4) Новая колонка: Вес в килограммах, округлённый вверх. Назвать product_weight_kg


SELECT 
product_id,
product_length_cm AS length_cm,
product_width_cm AS width_cm,
product_height_cm AS height_cm,
ROUND(((product_length_cm * product_width_cm * product_height_cm)/1000000.0),1) AS round_volume_m3, 
-- Если написать просто / 1000000, получится целое деление, и значение объёма будет неверным (всё после запятой пропадёт). Поэтому нужно делить на 1000000.0, чтобы результат был дробным.
ROUND(CEIL(product_weight_g/1000.0), 1) AS product_weight_kg
-- CEIL(product_weight_g/1000.0) AS product_weight_kg
FROM products




-- Задание 1.6:
-- Давайте продолжим делать отчёт, добавим в него ещё деталей:

-- Идентификатор продукта.
-- Длину (переименовать в length_cm), ширину (переименовать в width_cm), высоту (переименовать в height_cm).
-- Объём товара в кубических метрах, округлённый до одного знака после запятой. Назвать round_volume_m3.
-- Вес в килограммах, округлённый вверх. Назвать product_weight_kg.
-- Модуль разницы между длиной и шириной, чтобы оценить «вытянутость» продукта. Переведите модуль разницы в метры. Назвать abs_diff.
SELECT 
product_id,
product_length_cm AS length_cm,
product_width_cm AS width_cm,
product_height_cm AS height_cm,
-- Если написать просто / 1000000, получится целое деление, и значение объёма будет неверным (всё после запятой пропадёт). Поэтому нужно делить на 1000000.0, чтобы результат был дробным.
ROUND(((product_length_cm * product_width_cm * product_height_cm)/1000000.0),1) AS round_volume_m3, 
CEIL(product_weight_g/1000.0) AS product_weight_kg,
--делим на 100.0, чтобы избежать ненужного целочисленного деления.
(ABS(product_length_cm - product_width_cm))/100.0 AS abs_diff
FROM products


-- Задание 1.7:
-- Давайте продолжим составлять отчёт, воспользовавшись функциями для работы со строками. Выведите:

-- Идентификатор продукта
-- Полное название продукта в формате: product_brand - product_category_name. Например, SAMSUNG - ЭЛЕКТРОНИКА. Назвать product_full_name
-- Артикул для товара, который состоит из названия бренда в верхнем регистре + длины названия категории (например, для Nike и одежда → NIKE6, где 6 — длина слова «одежда»). Назвать product_number
SELECT 
product_id,
CONCAT(product_brand,' - ',product_category_name) AS product_full_name,
CONCAT(UPPER(product_brand),LENGTH(product_category_name)) AS product_number
FROM products



-- Задание 1.8:
-- Давайте продолжим делать отчёт, добавим в него больше деталей:
-- Полное название продукта в формате: product_brand - product_category_name. Например, МирГрупп - Бытовая техника. Назвать product_full_name_clean
-- Давай сделаем артикул для товара, пусть он будет состоять из первых 3 символов бренда product_brand + длины названия категории из поля product_category_name (например для product_id = 1, МирГрупп → Мир15, где 15 — длина product_category_name «Бытовая техника»). Назвать product_number
-- Основная категория товара. Давайте при помощи функции SPLIT_PART возьмём 1 фрагмент строки из product_category_name, разделённой по пробелу  ' '. Назвать main_category.
-- Поля в результирующей таблице: product_id, product_full_name_clean, product_number, main_category

SELECT
product_id,
CONCAT (product_brand,' - ',product_category_name) AS product_full_name_clean,
CONCAT (SUBSTRING(product_brand, 1,3),LENGTH(product_category_name)) AS product_number,
SPLIT_PART (product_category_name, ' ', 1) AS main_category
FROM products






-- Задание 1.9:
-- Напишите SQL-запрос, который выводит ID продукта, название бренда в нижнем регистре — product_brand_lower, количество символов в названии бренда — length_brand. 
-- Ограничьте результат запроса 10 строками, отсортировав результат по количеству символов в названии бренда по возрастанию.
-- Поля в результирующей таблице: product_id, product_brand_lower, length_brand.
SELECT
product_id,
LOWER (product_brand) AS product_brand_lower,
LENGTH (product_brand) AS length_brand
FROM products

ORDER BY length_brand ASC
LIMIT 10



-- Задание 1.10:
--Команда продукта хочет понять, пользователи каких городов пользуются их услугами.
--Напиши SQL-запрос, который выведет список уникальных городов, в которых зарегистрированы пользователи.
--Поля в результирующей таблице: customer_city

SELECT DISTINCT customer_city
FROM customers




-- Задание 1.11:
-- Напишите SQL-запрос, который выведет ID продукта, текущую цену продукта, цену продукта со снижением на 5%, а также цену продукта со снижением на 100 рублей. 
-- Округлите все числа вниз. 
-- Отсортируйте результат запроса по убыванию ID продукта и по убыванию цены продукта. 
--Поля в результирующей таблице: product_id, price, price_5_perc_discount, price_100_rub_discount.


SELECT
product_id,
price,
FLOOR(price*0.95) AS price_5_perc_discount,
FLOOR (price - 100.0) AS price_100_rub_discount
FROM order_items
ORDER BY product_id DESC, price DESC






--------------------------- Урок 2 --------------------------- 
-- Задание 2.1:
-- Напишите SQL-запрос, который выведет все столбцы в таблице products. 
-- Верните продукты только из категории «Одежда», отсортировав результаты запроса по весу по убыванию.
SELECT
*
FROM products
WHERE product_category_name = ' О д е ж д а '
ORDER BY product_weight_g DESC


-- Задание 2.2:
--Напишите SQL-запрос, который выведет всех клиентов, зарегистрировавшихся после 1 февраля 2024 года включительно.
-- Поля в результирующей таблице: customer_id, customer_zip_code, customer_city, created_at.

SELECT 
customer_id, customer_zip_code, customer_city, created_at
FROM customers
WHERE created_at >= ' 2024 -02 -01 '



-- Задание 2.3:
--Нам нужна выгрузка ID клиентов. 
--Подойдут клиенты из Питера или Москвы (Москва, Санкт-Петербург), которые были зарегистрированы в январе.

--проверить написание городов
SELECT 
customer_city
FROM customers
-- Москва может быть написана с большой или маленькой
--чтобы точно найти значение нужно исользовать LOWER  
WHERE LOWER(customer_city) LIKE ' м о с к в а ' OR LOWER(customer_city) LIKE ' % п % '

SELECT 
customer_id
FROM customers
WHERE (customer_city = ' М о с к в а ' OR customer_city = ' С а н к т - П е т е р б у р г ') AND created_at BETWEEN ' 2024 -01 -01 ' AND ' 2024 -01 -31 '

-- 2 вариант указать конкретный месяц -  функция DATE_PART()
...
WHERE (customer_city = ' М о с к в а ' OR customer_city = ' С а н к т - П е т е р б у р г ') AND DATE_PART (' MONTH ', created_at) = 1




-- Задание 2.4:
--Напишите SQL-запрос, который выведет все продукты, относящиеся к категориям «Электроника», «Одежда» и «Сад».

SELECT
product_id, product_brand, product_category_name
FROM products
WHERE product_category_name IN (' Э л е к т р о н и к а ', ' О д е ж д а ', ' С а д ');



-- Задание 2.5:
-- Напишите SQL запрос, который выведет все продукты, где в названии бренда есть строка ' ф о т о '. 
-- Приведите название бренда к нижнему регистру. Важно использовать и в SELECT
-- Поля в результирующей таблице: product_id, product_brand.

SELECT
product_id, LOWER(product_brand) AS product_brand
FROM products
WHERE LOWER(product_brand) LIKE ' % ф о т о % '


-- Задание 2.6:
-- Напишите SQL-запрос, который выведет все продукты, добавив колонку category с их типом. 
--Нужно создать категории на основе столбца product_brand:
--1) Фото — если в названии есть «фото».
--2) Техно — если есть «техно» или «квант».
--3) Энерго — если есть «энерго».
--4) Другое — если ничего не подошло.
--Обязательно приведите product_brand к нижнему регистру. 
--Условия в CASE должны идти в том же порядке (если товар подходит под несколько категорий, он попадёт в первую из них).
--Поля в результирующей таблице: product_id, product_brand, category.

SELECT product_id,
lower(product_brand) as product_brand,
case 
    when lower(product_brand) like ' % ф о т о % ' then ' Ф о т о '
    when lower(product_brand) like ' % т е х н о % ' OR lower(product_brand) like ' % к в а н т % ' then ' Т е х н о '
    when lower(product_brand) like ' % э н е р г о % ' then ' Э н е р г о '
    else ' Д р у г о е ' 
end as category
FROM   products




--Задание 2.7:

--Сделайте выгрузку клиентов нашего маркетплейса. В выгрузке должен быть:
--1) Идентификатор клиента
--2) Город
--3) День регистрации
--4) Месяц регистрации 
--5) Год регистрации
--6) Разница в днях между текущей датой и датой регистрации клиента в системе. Назовите этот столбец register_days_ago
--Поля в результирующей таблице: customer_id, customer_city, day_created_at, month_created_at, year_created_at, register_days_ago

SELECT customer_id,
       customer_city,
       date_part(' day ', created_at) as day_created_at,
       date_part(' month ', created_at) as month_created_at,
       date_part(' year ', created_at) as year_created_at,
       date_part(' day ', (now() - created_at)) as register_days_ago
FROM   customers



--Задание 2.8:
--Напишите SQL-запрос, который выведет 
--идентификатор клиента, 
--почтовый индекс клиента с типом данных INTEGER, 
--дату добавления клиента в систему с типом данных VARCHAR.

--Результат запроса должен быть отсортирован по возрастанию поля customer_zip_code.
--Поля в результирующей таблице: customer_id, customer_zip_code, created_at.

SELECT
customer_id,
customer_zip_code :: INTEGER,
CAST(created_at AS VARCHAR) AS created_at
FROM customers
ORDER BY customer_zip_code ASC




--Задание 2.9:
--Напишите SQL-запрос, который выведет все ID клиентов, где значение customer_city равно NULL.
--Поля в результирующей таблице: customer_id.
SELECT 
customer_id
FROM customers
WHERE customer_city IS NULL




--Задание 2.10:
--Напишите SQL-запрос, который выведет 
-- ID клиента, 
-- его ZIP-код, 
-- город, 
-- а также поле destination, которое принимает значение customer_city либо customer_zip_code, если customer_city не заполнен. 
--Обратите внимание, что внутри COALESCE ZIP-код необходимо будет привести к строковому типу.

-- Поля в результирующей таблице: customer_id, customer_zip_code, customer_city, destination.

--1 ВАРИАНТ
SELECT 
customer_id,
customer_zip_code,
customer_city,
CASE
    WHEN customer_city IS NOT NULL THEN customer_city
    ELSE COALESCE (customer_city, customer_zip_code::VARCHAR) 
end AS destination
FROM customers


--2 ВАРИАНТ
SELECT 
customer_id,
customer_zip_code,
customer_city,
COALESCE (customer_city, customer_zip_code::VARCHAR) AS destination
FROM customers




-- Задание 2.11:
--К нам поступила жалоба: заказ нашего клиента к нему не пришёл. 
--Нас попросили разобраться, почему так поучилось. Дали его ID = 229. 
--Товар должны были доставить в Москву. Давайте посмотрим, в каком городе зарегистрировался наш клиент.

--Напишите SQL-запрос, который выведет из таблицы customers город клиента 229.
--Поле в результирующей таблице: customer_city.

SELECT 
customer_city
FROM customers 
WHERE customer_id = 229;




-- Задание 2.12:
--Напишите SQL-запрос, который выведет из таблицы orders заказы, созданные после 4 января 2024 года (не включительно). 
--Статус заказа не должен быть Returned. 
--Ожидаемая дата доставки order_estimated_delivery_time между 5 и 10 днями от даты создания. 
--Фактическая дата доставки клиенту (order_delivered_customer_time) не NULL.
--Отсортируйте по убыванию даты создания заказа.
--Поля в результирующей таблице: order_id, order_status, order_created_time.

SELECT
order_id, order_status, order_created_time
FROM orders
WHERE order_created_time >= ' 2024 -01 -05 ' 
    AND order_status != ' Returned '
    AND order_estimated_delivery_time BETWEEN order_created_time + INTERVAL ' 5 days ' AND order_created_time + INTERVAL ' 10 days '
    AND order_delivered_customer_time IS NOT NULL
ORDER BY order_created_time DESC



-- Задание 2.13:
-- «Ребят, выгрузите, пожалуйста, все заказы наших пользователей, которые были созданы в период с 15 января 2024 года (включительно) по 3 марта 2024 года (не включительно). 
--Мы хотим посмотреть, были ли они доставлены вовремя. 
--Сделайте какой-то столбец, например status_order, который принимает значения:

--«вовремя» (если заказ был доставлен клиенту раньше рассчитанных даты и времени доставки или в те же день и время);
--«опоздал» (если заказ был доставлен строго позже рассчитанных даты и времени);
--«остальные случаи».
--Если дата доставки клиенту (order_delivered_customer_time) пустая, то заполните её датой «2050-01-01».

--Поля в результирующей таблице: order_id, status_order, order_delivered_customer_time.

SELECT
order_id,
CASE
    WHEN order_delivered_customer_time <= order_estimated_delivery_time THEN ' в о в р е м я '
    WHEN order_delivered_customer_time > order_estimated_delivery_time THEN ' о п о з д а л '
    ELSE ' о с т а л ь н ы е с л у ч а и '
end AS status_order,
COALESCE (order_delivered_customer_time, ' 2050 -01 -01 ') AS order_delivered_customer_time
FROM orders
WHERE order_created_time BETWEEN ' 2024 -01 -15 ' AND ' 2024 -03 -03 '



-- Задание 2.14:
-- Напишите SQL-запрос, который выведет из таблицы products все продукты, бренд которых содержит слово «фото» в любом регистре и части названия. 
--Отфильтруйте вес товара (product_weight_g) больше 500 г.
--Поля в результирующей таблице: product_id, product_brand, product_category_name.

SELECT
product_id, product_brand, product_category_name
FROM products
WHERE LOWER(product_brand) LIKE ' % ф о т о % ' AND product_weight_g >500



-- Задание 2.15:
-- Напишите SQL-запрос, который выведет из таблицы customers всех клиентов. 
--Выделите дополнительный столбец — группу региона (region_group) на основе следующей группировки: 
--«Столица» для «Москва» и «Санкт-Петербург», 
--«Другие» для остальных, 
-- а также название города в верхнем регистре city_upper.

--Поля в результирующей таблице: customer_id, city_upper, region_group.


SELECT 
customer_id,
CASE
    WHEN customer_city = ' М о с к в а ' OR customer_city = ' С а н к т - П е т е р б у р г ' THEN ' С т о л и ц а '
    ELSE ' Д р у г и е '
END AS region_group,
UPPER(customer_city) AS city_upper
FROM customers





-- Задание 2.16:
--нужна выгрузка данных о том, сколько времени уходит на доставку продукта, 
--отсортированная по количеству дней задержки — то есть первыми будут заказы с большей задержкой.

--Напишите SQL-запрос, который для каждого заказа выведет следующие данные:
--Идентификатор заказа
--Дату создания заказа без времени. Назовите order_created_day 
--Дату фактической доставки клиента без времени. Назовите order_delivered_customer_day
--Дату ожидаемой доставки клиента без времени. Назовите order_estimated_delivery_day 
--Количество полных дней между ожидаемой датой доставки и фактической. Назовите delivery_delay_days
--Отсортируйте заказы по количеству дней задержки (по возрастанию, так как задержка у нас обозначается отрицательными числами), а также по возрастанию order_id.

--Поля в результирующей таблице: order_id,  order_created_day, order_delivered_customer_day, order_estimated_delivery_day, delivery_delay_days.

SELECT 
order_id,
order_created_time :: DATE AS order_created_day,
CAST (order_estimated_delivery_time AS DATE) AS order_delivered_customer_day,
order_estimated_delivery_time :: DATE AS order_estimated_delivery_day,
DATE_PART(' day ', DATE_TRUNC(' day ', order_estimated_delivery_time - order_delivered_customer_time)) AS delivery_delay_days
FROM orders
ORDER BY delivery_delay_days ASC, order_id ASC








--------------------------- Урок 3 --------------------------- 
-- Задание 3.1:
--Отдел маркетинга планирует провести региональные акции и хочет понять, в каких городах у нас больше всего клиентов. 
--Чтобы принять решение, им нужна простая статистика по городам.

--Напишите SQL-запрос, который посчитает количество клиентов в каждом городе (customer_city). 
--Отсортируйте результат по количеству клиентов в порядке убывания, чтобы самые крупные города были наверху.
--Поля в результирующей таблице: customer_city, customers_count


SELECT
customer_city, COUNT (customer_id) AS customers_count
FROM customers 
GROUP BY customer_city
ORDER BY customers_count DESC




-- Задание 3.2:
--Представь, что ты анализируешь состав заказов. 
--Тебе нужно для каждого заказа (order_id) получить подробную статистику по товарам внутри него.

--Напиши SQL-запрос, который для каждого заказа посчитает:
--суммарную стоимость всех товаров в заказе (назови столбец total_price)
--количество позиций в заказе (назови столбец items_count)
--среднюю стоимость товара в заказе (назови столбец avg_price)
--стоимость самого дорогого товара в заказе (назови столбец max_price)
--стоимость самого дешевого товара в заказе (назови столбец min_price)

--Результат отсортируйте по возрастанию order_id.
--Поля в результирующей таблице: order_id, total_price, items_count, avg_price, max_price, min_price.

SELECT
order_id,
SUM(price) AS total_price,
COUNT (order_item_id) AS items_count,
AVG (price) AS avg_price,
MAX (price) AS max_price,
MIN (price) AS min_price
FROM order_items
GROUP BY order_id
ORDER BY order_id ASC





-- Задание 3.3:
--Напиши SQL-запрос, который посчитает, сколько уникальных клиентов 
--регистрировалось в системе каждый месяц.

--Поля в результирующей таблице: registration_month, unique_customers_count. 
--Отсортируй результат по месяцу регистрации по убыванию.


SELECT
count (customer_id) AS unique_customers_count,
DATE_TRUNC (' month ', created_at) AS registration_month

FROM customers
GROUP BY registration_month
ORDER BY registration_month DESC




-- Задание 3.4:
-- Отдел логистики заметил, что некоторые посылки весят подозрительно мало или, наоборот, 
-- слишком много. Давайте найдём бренды, в которых есть либо очень легкие, 
-- либо очень тяжёлые товары, чтобы проверить корректность данных.

-- Напишите SQL-запрос, который выведет 
--названия категорий товаров (product_brand) 
--и средний вес товаров, в которых меньше 200 грамм или больше 400 грамм. 

-- Отсортируйте по убыванию среднего веса.

-- Поля в результирующей таблице: product_brand, avg_weight_g


SELECT
product_brand,
AVG(product_weight_g) AS avg_weight_g
FROM products
GROUP BY product_brand
HAVING AVG(product_weight_g)< 200 OR AVG(product_weight_g)> 400
ORDER BY AVG(product_weight_g) DESC




-- Задание 3.5
--Команда продукта хочет понять, какие действия пользователи совершают чаще всего. 
--Эта информация поможет улучшить интерфейс и сделать платформу удобнее. 
--Нам нужно посчитать, сколько раз совершалось каждое уникальное действие.

SELECT 
event_type,
COUNT (event_type) AS event_count,
COUNT (DISTINCT customer_id) AS unique_customers_count
FROM customer_actions
GROUP BY event_type



-- Задание 3.6
--Напишите SQL-запрос, который вернёт уникальные пары бренда и категории товаров, представленных в магазине. 
--Отсортируйте результат по product_brand по убыванию.

--Поля в результирующей таблице: product_brand, product_category_name.

SELECT DISTINCT
product_brand,
product_category_name
FROM  products
ORDER BY product_brand DESC






-- Задание 3.7
--Напишите SQL-запрос, который покажет 
-- общее количество клиентов (назовите столбец total_customers) 
-- и количество клиентов, у которых указан пол (назовите столбец customers_with_gender).
--Поля в результирующей таблице: total_customers, customers_with_gender.

SELECT
COUNT (*) AS total_customers, -- 10000
COUNT (gender) AS customers_with_gender -- 9623
FROM customers





-- Задание 3.8
--Служба поддержки хочет оценить свою работу и понять, есть ли проблемые клиенты, 
--которые часто отменяют заказы.

--Напишите SQL-запрос, который для каждого клиента (customer_id) посчитает 
--количество заказов, которые были возвращены (назовите столбец returned_orders) 
--и количество заказов, которые были доставлены (назовите столбец delivered_orders). 

--Результат отсортируйте по возрастанию customer_id.
--Поля в результирующей таблице: customer_id, returned_orders, delivered_orders

-- посмотреть написание статусов
SELECT 
DISTINCT order_status 
FROM orders


SELECT 
customer_id,
COUNT (CASE WHEN order_status = ' Returned ' THEN 1 END) AS returned_orders,
-- sum(case when order_status = ' Returned ' then 1 else 0 end) as returned_orders
COUNT (CASE WHEN order_status = ' Delivered ' THEN 1 END) AS delivered_orders
FROM orders
GROUP BY customer_id
ORDER BY customer_id ASC





-- Задание 3.9
--Отдел логистики хочет понять, сколько заказов доставляется вовремя, 
--а сколько — с опозданием.

--Напишите SQL-запрос, который для каждого статуса заказа (order_status) посчитает:
-- Общее количество заказов (total_orders).
-- Количество заказов, доставленных с опозданием (фактическая дата доставки order_delivered_customer_time позже ожидаемой order_estimated_delivery_time). Назовите этот столбец late_orders.
--Поля в результирующей таблице: order_status, total_orders, late_orders.


SELECT order_status,
       count (*) as total_orders,
       count (order_id) filter (WHERE order_delivered_customer_time > order_estimated_delivery_time) as late_orders
FROM   orders
GROUP BY order_status






-- Задание 3.10
--Просто посчитать заказы — это хорошо, но бизнес теряет деньги и лояльность, 
--когда мы опаздываем с доставкой. Отдел логистики просит нас не просто найти 
--опоздавшие заказы, а выявить клиентов, для которых задержки стали систематической проблемой.

--Напишите SQL-запрос для поиска клиентов (customer_id), у которых среднее время 
--опоздания по всем доставленным им заказам составляет более 2 дней. 
--Среднее опоздание нужно считать как разницу между фактической датой доставки 
--(order_delivered_customer_time) и ожидаемой (order_estimated_delivery_time). 
--Оно должно быть рассчитано в днях, округлите до одного знака после запятой. 
--Отсортируйте по возрастанию customer_id.

--Поля в результирующей таблице: customer_id, average_delay_days


SELECT 
customer_id,
ROUND(AVG(CAST(DATE_PART(' day ', (order_delivered_customer_time - order_estimated_delivery_time)) AS INTEGER)),2) AS average_delay_days
FROM orders
WHERE order_status = ' Delivered ' AND order_delivered_customer_time > order_estimated_delivery_time
GROUP BY customer_id
HAVING ROUND(AVG(CAST(DATE_PART(' day ', (order_delivered_customer_time - order_estimated_delivery_time)) AS INTEGER)),2) > 2
ORDER BY customer_id





--Задание 3.10
--Финансовый отдел обеспокоен, что цены на некоторые товары сильно скачут. 
--Это может быть связано с акциями, ошибками в данных или поставщиками.

--Напишите SQL-запрос для таблицы order_items, который найдёт для 
--каждого товара (product_id) его коэффициент ценовой вариации. Коэффициент 
--рассчитаем как отношение разницы между максимальной и минимальной ценой к средней цене: 
--(MAX(price) - MIN(price)) / AVG(price). 
--Округлите значение до 3 знаков после запятой.

--Выведите топ-10 самых нестабильных товаров (с наибольшим коэффициентом). 
--Игнорируйте товары, которые продавались всего один раз (т. к. для них вариация будет 0). 
--Воспользуйтесь лайфхаком с порядковыми номерами.

--Поля в результирующей таблице: product_id, price_variation_coefficient


select
product_id,
ROUND((MAX(price) - MIN(price)) / AVG(price),3) AS price_variation_coefficient
from order_items
GROUP BY 1
having count(*) > 1
ORDER BY 2 desc
LIMIT 10










--------------------------- Урок 4 --------------------------- 
-- Задание 4.1:
--Напишите SQL-запрос, чтобы для каждого товара в заказе (order_items) вывести 
--его цену (price) и категорию (product_category_name). 
--Отсортируйте результат по убыванию цены.

--Поля в результирующей таблице: price, product_category_name.

SELECT
oi.price,
p.product_category_name,
oi.product_id,
p.product_id
FROM order_items AS oi
LEFT JOIN products AS p
ON oi.product_id = p.product_id


-- для себя
-- если написать такой запрос, то для каждого oi.product_id будут отображаться 
-- все возможные варианты с непохожими p.product_id.

SELECT
oi.price,
p.product_category_name,
oi.product_id,
p.product_id
FROM order_items AS oi
JOIN products AS p
ON oi.product_id != p.product_id

-- Итого:
price         product_category_name       product_id     product_id1
...           ...                            ...          ...
37,249.68 	  Музыкальные инструменты        652	       15	
37,249.68	  Искусство и ремесла            652	       16	
37,249.68	  Сад                            652           17	
37,249.68	  Сад                            652	       18
...           ...                            ...          ...





-- Задание 4.2:
--Выведите всех пользователей из таблицы customers и укажите их order_id 
--из таблицы orders, если пользователь делал заказы, если у пользователей 
--не было заказов, то мы не исключаем этих пользователей из результата 
--а ожидаем NULL в колонке order_id. 

--Отсортируйте по возрастанию customer_id.
--Поля в результирующей таблице: customer_id,  order_id.


SELECT
c.customer_id,
o.order_id
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
-- аналогично, если написать
-- ON o.customer_id = c.customer_id
ORDER BY c.customer_id






-- Задание 4.3:
--Найдите всех клиентов, которые зарегистрировались в системе, 
--но ещё не совершили ни одного действия в таблице customer_actions
-- Выведите их customer_id и дату регистрации created_at. 
-- Отсортируйте по возрастанию customer_id

SELECT 
c.customer_id,
c.created_at
FROM customers AS c
LEFT JOIN customer_actions AS ca
ON c.customer_id = ca.customer_id 
WHERE ca.event_type is NULL
ORDER BY c.customer_id ASC





-- Задание 4.4:
--Выведите всех клиентов  из таблицы customers (customer_id, customer_city) и, 
--если для этого клиента есть заказы, покажите order_id и order_status из orders. 

--Отсортируйте результат по возрастанию order_id.
--Поля в результирующей таблице: customer_id, customer_city, order_id, order_status.

SELECT
c.customer_id,
c.customer_city,
o.order_id,
o.order_status
from orders AS o
right join customers AS c
ON c.customer_id = o.customer_id
order by o.order_id ASC




-- Задание 4.5:
-- Создайте единый список, в котором будут присутствовать все клиенты из 
--customers и все заказы из orders. Нужно вывести customer_id и order_id. 

--Отсортируйте по возрастанию order_id.
--Поля в результирующей таблице: customer_id, order_id.


SELECT
c.customer_id,
o.order_id
FROM customers AS c
FULL JOIN orders AS o
ON c.customer_id = o.customer_id 
ORDER BY o.order_id ASC



-- Задание 4.6:
-- Напишите SQL-запрос, который выведет всех клиентов (customer_id) и какие 
-- действия они совершали (event_type из таблицы customer_actions). 
-- Если клиент не совершал никаких действий, на месте event_type должно 
--быть NULL. 

--Оставьте только уникальные комбинации сustomer_id и event_type. 
--Отсортируйте по возрастанию customer_id и event_type.
--Поля в результирующей таблице: customer_id, event_type


-- c GROUP BY
SELECT c.customer_id,
       ca.event_type
FROM   customers as c
    LEFT JOIN customer_actions as ca
        ON c.customer_id = ca.customer_id
GROUP BY c.customer_id, ca.event_type
ORDER BY c.customer_id asc, ca.event_type asc

-- DISTINCT
SELECT DISTINCT c.customer_id,
                ca.event_type
FROM   customers as c
    LEFT JOIN customer_actions as ca
        ON c.customer_id = ca.customer_id
ORDER BY c.customer_id, ca.event_type;



-- Задание 4.7:
-- Отдел логистики хочет понять, товары каких брендов (product_brand) 
-- доставляются в определённые города. 
-- Напишите запрос, который выведет уникальные названия брендов, товары 
-- которых были в заказах 
--со статусом Delivered 
--для клиентов из Москвы. 

-- Отсортируйте результат в алфавитном порядке по убыванию.
-- Поля в результирующей таблице: product_brand.

SELECT
DISTINCT p.product_brand
FROM products AS p
JOIN order_items AS oi
ON p.product_id = oi.product_id
JOIN orders AS o
ON oi.order_id = o.order_id
JOIN customers AS c
ON o.customer_id = c.customer_id
WHERE o.order_status = ' Delivered 'AND c.customer_city = ' М о с к в а '
ORDER BY p.product_brand DESC






-- Задание 4.8:
--Напишите запрос, который для каждого товара в заказе (order_items) 
--выведет его цену (price) и идентификатор (product_id). 

--Используйте синтаксис USING для соединения таблиц. 
--Отсортируйте по возрастанию цены. 
--Поля в результирующей таблице: price, product_id.

SELECT
oi.price,
p.product_id
FROM order_items AS oi
LEFT JOIN products AS p
USING (product_id)
ORDER BY oi.price ASC






-- Задание 4.9:
--Получите список всех уникальных product_id, которые хотя бы раз 
--заказывали либо клиенты с ними взаимодействовали (customer_actions).

--Поля в результирующей таблице: product_id.


SELECT 
product_id
FROM orders
UNION
SELECT 
product_id
FROM customer_actions





-- Задание 4.10:
-- Отдел маркетинга хочет узнать, какие бренды чаще всего были заказаны 
-- клиентами из Москвы. 
-- Для каждого бренда выведите общее количество заказанных позиций 
--(order_item_id) клиентами из города Москвы. 

--Отсортируйте в алфавитном порядке.
--Поля в результирующей таблице: product_brand, items_count

SELECT 
p.product_brand,
COUNT (oi.order_item_id) AS items_count
FROM order_items AS oi
JOIN products AS p
ON oi.product_id = p.product_id
JOIN orders AS o
USING (order_id)
JOIN customers AS c
ON o.customer_id = c.customer_id
WHERE c.customer_city = ' М о с к в а '
GROUP BY p.product_brand
ORDER BY p.product_brand




-- Задание 4.11:
-- Нужно определить, на какие товарные категории поступает особенно большое 
-- число заказов (больше либо равно 400). 
-- Для каждой такой категории выведите 
--название, 
--число уникальных товаров 
--и число заказов. 

-- Отсортируйте по количеству заказов в порядке убывания.
-- Поля в результирующей таблице: product_category_name, products_in_category, orders_count.

SELECT
p.product_category_name,
COUNT(DISTINCT p.product_id) AS products_in_category,
COUNT(DISTINCT o.order_id) AS orders_count
FROM products AS p
JOIN order_items AS oi
USING (product_id)
JOIN orders AS o
USING (order_id)
group by p.product_category_name 
HAVING COUNT(DISTINCT o.order_id) >= 400
ORDER BY orders_count DESC




-- Задание 4.12:
--Менеджеры хотят вернуть клиентов, которые делали меньше трёх заказов. 
--Покажите таких клиентов с их 
-- customer_id, 
-- городом 
-- и датой последнего заказа. 

--Отсортируйте по возрастанию customer_id.
--Поля в результирующей таблице: customer_id, customer_city, last_order_date, total_orders.

SELECT
c.customer_id,
c.customer_city,
MAX(o.order_created_time) AS last_order_date,
COUNT(o.order_id) AS total_orders 
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_city
HAVING COUNT(o.order_id)< 3 
ORDER BY customer_id ASC, last_order_date DESC




-- Задание 4.13:
--В каждом городе рассчитайте долю отменённых заказов 
--(order_status = ' Returned '). 
--Выведите 
-- город, 
-- общее число заказов, 
-- число отмен
-- и процент отмен (округлите его до 2 знака). 

--Отсортируйте по убыванию процента отмен.
--Поля в результирующей таблице: customer_city, total_orders, canceled_orders, cancel_rate_percent.


-- using 'CASE...WHERE...THEN...ELSE...END '
SELECT 
c.customer_city,
COUNT(o.order_id) AS total_orders,
SUM(CASE WHEN o.order_status = ' Returned ' THEN 1 ELSE 0 END) AS canceled_orders,
ROUND(
    (100.00*
    SUM(CASE WHEN o.order_status = ' Returned ' THEN 1 ELSE 0 END)
    /
    COUNT(o.order_id)), 
    2
    ) AS cancel_rate_percent
FROM orders as o
JOIN customers AS c
USING (customer_id)
GROUP BY c.customer_city
ORDER BY cancel_rate_percent DESC



-- using ' filter...WHERE '
SELECT c.customer_city,
       count(o.order_id) as total_orders,
       count(o.order_id) filter (WHERE o.order_status = ' Returned ') as canceled_orders,
       round(100.0 * count(o.order_id) filter (WHERE o.order_status = ' Returned ') / count(o.order_id),
             2) as cancel_rate_percent
FROM   customers as c join orders as o
        ON c.customer_id = o.customer_id
GROUP BY c.customer_city
ORDER BY cancel_rate_percent desc;


--check
SELECT
COUNT(CASE WHEN order_status = ' Returned ' THEN 1 END) AS cancel_rate_percen,
COUNT(order_id) AS total_orders
FROM orders










--------------------------- Урок 5 --------------------------- 
-- Задание 5.1:
--Найдите все товарные позиции (order_items) с максимальной среди всех 
--товарных позиций в таблице ценой. 

--Выведите order_id, product_id и price для этих позиций.
--Поля в результирующей таблице: order_id, product_id, price.

SELECT 
order_id, product_id, price
FROM order_items
WHERE price = (SELECT MAX(price) FROM order_items)



-- Задание 5.2:
--Отдел логистики хочет выявить тяжёлые категории товаров.
--Напишите SQL-запрос, который найдёт все категории товаров, средний вес которых 
--(product_weight_g) превышает общий средний вес всех товаров в базе.

--Для найденных категорий выведите:
-- Название категории (product_category_name).
-- Средний вес товаров в этой категории (category_avg_weight).
-- Общий средний вес всех товаров для сравнения (overall_avg_weight).

--Отсортируйте по убыванию category_avg_weight.

SELECT
product_category_name,
AVG(product_weight_g) AS category_avg_weight,
(SELECT AVG(product_weight_g) FROM products) AS overall_avg_weight --статичное на момент проверки число
FROM products
group by product_category_name
HAVING AVG(product_weight_g) > (SELECT AVG(product_weight_g) FROM products) 
ORDER BY category_avg_weight DESC







-- Задание 5.3:
--Давайте разработаем динамическую систему скидок. 
--Скидка на товар будет зависеть от того, насколько его цена отличается от 
--средней цены в его категории.

--Напишите запрос, который для каждого товара из категории 'Одежда' выводит его 
-- product_id, 
-- product_category_name, 
-- price 
-- и размер скидки в новом столбце discount_status.

-- 1) Если цена товара выше средней цены на товары в категории 'Одежда', 
-- discount_status должен быть 'Скидка 15%'.

-- 2) Если цена равна средней, 
-- discount_status — 'Скидка 10%'.

-- 3) Если цена ниже средней, 
-- discount_status — 'Скидка 5%'.

--Отсортируйте по возрастанию product_id и price.
--Поля в результирующей таблице: product_id, product_category_name, price, discount_status.



SELECT 
oi.product_id,
oi.price,
p.product_category_name,
CASE
    WHEN oi.price > (
        SELECT AVG(oi.price) 
        FROM order_items AS oi
        JOIN products AS p
        USING(product_id)
        WHERE p.product_category_name = 'Одежда'
        )
    THEN 'Скидка 15%'

    WHEN oi.price = (
        SELECT AVG(oi.price) 
        FROM order_items AS oi
        JOIN products AS p
        USING(product_id)
        WHERE p.product_category_name = 'Одежда'
        )
    THEN 'Скидка 10%'    

    ELSE 'Скидка 5%'
    
END AS discount_status

FROM order_items AS oi
JOIN products AS p
ON oi.product_id = p.product_id
WHERE product_category_name = 'Одежда'
ORDER BY product_id ASC, price ASC





-- Задание 5.4:
-- Напишите SQL-запрос, чтобы найти все товары 
--(product_id, product_brand, price), 
-- которые были куплены клиентами из Самары. 

--Отсортируйте результат по убыванию id товара 
--а также по убыванию цены.

-- Поля в результирующей таблице: product_id, product_brand, price.


SELECT
p.product_id,
p.product_brand,
oi.price
FROM products AS p
JOIN order_items AS oi
USING(product_id)
JOIN orders
USING(order_id)
JOIN customers AS c
USING(customer_id)
WHERE c.customer_city = 'Самара'
ORDER BY p.product_id DESC, oi.price DESC



--ИЛИ
SELECT oi.product_id,
       p.product_brand,
       oi.price
FROM   order_items oi join products p
        ON oi.product_id = p.product_id
WHERE  oi.order_id in (SELECT order_id
                       FROM   orders
                       WHERE  customer_id in (SELECT customer_id
                                              FROM   customers
                                              WHERE  customer_city = 'Самара'))
ORDER BY oi.product_id desc, oi.price desc;







-- Задание 5.5:
-- Напишите SQL-запрос, который покажет все категории товаров 
--(product_category_name), для которых есть хотя бы один заказ 
--(т. е. один заказанный товар из этой категории). 

--Отсортируйте в алфавитном порядке.
--Поля в результирующей таблице: product_category_name

SELECT
DISTINCT p.product_category_name
FROM products AS p
WHERE EXISTS 
    (SELECT *
     FROM order_items AS oi
     WHERE p.product_id = oi.product_id
    )
ORDER BY p.product_category_name







-- Задание 5.6:
-- Используя CTE, напишите запрос, который определяет для каждого клиента 
-- его 'статус' на основе количества просмотренных товаров в таблице customer_actions.

-- 1) Если клиент просмотрел >= 40 товаров (event_type = 'Page View'), 
--его статус — 'Активный'.
-- 2) Если 10—39 товаров — 'Средний'.
-- 3) Менее 10 — 'Новичок'.

--Отсортируйте результат по убыванию числа просмотров и убыванию customer_id.

--Поля в результирующей таблице: customer_id, views_count,customer_status



WITH client_status AS (
SELECT
customer_id,
COUNT(event_type) AS views_count -- или count(*) as views_count
FROM customer_actions
WHERE event_type =  'Page View'
GROUP BY customer_id
)


SELECT
customer_id, 
views_count,
CASE
    WHEN views_count>=40 THEN 'Активный'
    WHEN views_count BETWEEN 10 AND 39 THEN 'Средний'
    ELSE 'Новичок'
END AS customer_status
FROM client_status
ORDER BY views_count DESC, customer_id DESC





-- Задание 5.7:
-- Отдел маркетинга хочет понять, какие клиенты много интересуются 
-- товарами, но ничего не покупают. 
-- Мы определим таких клиентов как тех, кто просматривал товары 
-- (событие Page View в customer_actions), но при этом не имеет ни одного 
-- завершённого заказа (Delivered в orders).

-- Напишите SQL-запрос, который найдёт всех клиентов 
-- (customer_id и customer_city), у которых есть хотя бы одно событие 
-- просмотра товара, но при этом нет ни одного доставленного заказа. 

-- Отсортируйте по возрастанию customer_id.
-- Поля в результирующей таблице: customer_id, customer_city.



WITH Page_View AS (
    SELECT
    customer_id,
    event_type,
    COUNT (event_type)
    FROM customer_actions
    WHERE event_type = 'Page View'
    GROUP BY customer_id, event_type 
),
Delivered AS (
    SELECT
    customer_id,
    order_status
    FROM orders
    WHERE order_status = 'Delivered'
)

SELECT
customer_id,
customer_city
FROM customers
WHERE EXISTS (    
    SELECT
    customer_id,
    event_type,
    COUNT (event_type)
    FROM customer_actions
    WHERE event_type = 'Page View'
    GROUP BY customer_id, event_type ) 

AND NOT NOT EXISTS (
    SELECT
    customer_id,
    order_status
    FROM orders
    WHERE order_status = 'Delivered'
)
ORDER BY customer_id ASC
