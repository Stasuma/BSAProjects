-- Active: 1733769899649@@127.0.0.1@5432@Korotkova@public
-- members - дочерняя таблица для cards
create table members(
	tab_participant int,
	first_name VARCHAR,
	last_name varchar
);
select*from members

ALTER TABLE members
ADD PRIMARY KEY (tab_participant); --колонка становится первичным ключём

select*from members


INSERT INTO members VALUES (1111, 'Иванов', 'Александр');
insert into members values (2222, 'Сергеев', 'Сергей');
insert into members values (3333, 'Полякова', 'Анна');
select*from members



# cards - дочерняя таблица для table
create table cards(
	id_card int primary key,
	creator_id int,
	create_date DATE,
	title VARCHAR (100),
	descriptions VARCHAR (1000),
	done BOOLEAN,
	participants_id INT,
	FOREIGN KEY (participants_id) REFERENCES members (tab_participant)
);
select*from cards

insert into cards values (1, 2222, '2023-10-01', 'Планы', 'Описание', true, 2222);
select*from cards

insert into cards values (2, 2222, '2023-10-11', 'Название', 'Описание', true, NULL);
select*from cards

insert into cards values (3, 1111, '2023-10-03', 'Задача на день', 'Работать', false, 3333);
select*from cards

insert into cards values (4, 3333, '2023-11-23', 'Написать аналитику', 'Добавить ссылку', false, 1111);
select*from cards


#главная таблица
create table board(
	id_table int primary key,
	tab_author int,
	title VARCHAR (100)
);
select*from board

insert into board values (0001, 1111, 'Задачи команды');
select*from board

insert into board values (0002, 3333, 'Доска Поляковой');
select*from board




# дочерняя таблица для table
create table list(
	id_list int primary key,
	creator_id int,
	title VARCHAR (100)
);
select*from list

ALTER TABLE list
ADD COLUMN id_board INT,
ADD CONSTRAINT fk_id_table
FOREIGN KEY (id_board) REFERENCES board (id_table);
select*from list


insert into list values (11, 1111, 'to do', 0001);
select*from list

insert into list values (22, 1111, 'in progress', 0001);
select*from list

insert into list values (33, 1111, 'done', 0001);
select*from list


DELETE FROM list
WHERE id_list = 11;
select*from list

DELETE FROM list
WHERE id_list = 22;
select*from list

DELETE FROM list
WHERE id_list = 33;
select*from list


insert into list values (11, 1111, 'to do', 0001);
select*from list

insert into list values (22, 1111, 'in progress', 0001);
select*from list

insert into list values (33, 1111, 'done', 0001);
select*from list



`1

------------------------------------------------------------------------------------------------------------------


-- 1) Отобразить все колонки, которые были созданы Ивановым Александром id 1111
#результат - 3 колонки с id 11, 22, 33
select*from list
where creator_id = 1111;


# 2) Отобразить id доски с названием Доска Поляковой
#результат - доска с id 2

select id_table
from board
where title = 'Доска Поляковой';


-- 3) Отобразить карточку, в которой creator_id = 2222, а participants_id = null
-- Результат: id card = 2
select*from cards
where (creator_id = 2222) AND (participants_id is NULL);


-- Работа с 2-мя таблицами cards + members
-- 4) Отобразить фамилию и имя создателя карточки с id 1
-- Результат: Сергеев Сергей
SELECT cards.id_card, members.first_name, members.last_name FROM cards JOIN members ON participants_id = tab_participant
where id_card = 1;


-- 5) Показать названия всех колонок доски, где id не равно 0002 (=2)
-- Результат: to do, in progress, done
select board.id_table, list.title from list LEFT JOIN board ON id_board = id_table
where id_board != 2;

