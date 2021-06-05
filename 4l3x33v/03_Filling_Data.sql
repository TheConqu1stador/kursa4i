delete from Employee;
delete from Department;
delete from Office;
delete from Contract;
delete from Profession;

alter sequence Profession_ID_seq restart;
alter sequence Contract_ID_seq restart;
alter sequence Office_ID_seq restart;
alter sequence Department_ID_seq restart;
alter sequence Employee_ID_seq restart;


select 'Таблица Profession заполнена'
where Profession_insert('SQL Разработчик', 13, 9) = 1
  and Profession_insert('C# Разработчик', 10, 9) = 1
  and Profession_insert('Аналитик', 4, 1) = 1
  and Profession_insert('Менеджер', 4, 0) = 1
  and Profession_insert('Директор', 1, 0) = 1

union all

select 'Таблица Contract заполнена'
where Contract_insert('Базовая оплата - 200 рублей в час', 20, 1, false) = 1
  and Contract_insert('Базовая оплата - 250 рублей в час', 20, 1, false) = 1
  and Contract_insert('Базовая оплата - 60000 в месяц', 35, 1, true) = 1
  and Contract_insert('Базовая оплата - 150 рублей в час, + реферальные бонусы', 20, 1, false) = 1
  and Contract_insert('Оплата за каждый проект обсуждается отдельно', 20, 2, true) = 1
  and Contract_insert('Базовая оплата - 40000 в месяц', 30, 3, true) = 1
  and Contract_insert('Базовая оплата - 40000 в месяц', 30, 3, true) = 1
  and Contract_insert('Базовая оплата - 45000 в месяц', 30, 3, true) = 1
  and Contract_insert('Базовая оплата - 40000 в месяц', 30, 4, true) = 1
  and Contract_insert('Базовая оплата - 30000 в месяц', 35, 4, true) = 1
  and Contract_insert('Базовая оплата - 30000 в месяц', 35, 4, true) = 1
  and Contract_insert('Базовая оплата - 50000 в месяц', 40, 4, true) = 1
  and Contract_insert('-', 40, 5, true) = 1
  
union all

select 'Таблица Office заполнена'
where Office_insert('Основной', '123557, г. Москва, ул. Пресненский Вал, д. 27', 2) = 1
  and Office_insert('Второстепенный', '123557, г. Москва, Большой Тишинский пер., д. 38', 5) = 1
  and Office_insert('Третьестепенный', '123022, г. Москва, Большой Предтечинский пер., д. 15', 3) = 1

union all

select 'Таблица Department заполнена'
where Department_insert('Руководство', null, 1) = 1
  and Department_insert('Разработка', 1, 2) = 1
  and Department_insert('Разработка SQL', 2, 2) = 1
  and Department_insert('Разработка C#', 2, 2) = 1
  and Department_insert('Аналитика', 2, 3) = 1
  and Department_insert('Менеджмент', 1, 1) = 1
  and Department_insert('Продажи', 1, 3) = 1
  
union all

select 'Таблица Employee заполнена'
where Employee_insert(1, 'Садкова Кристина', 3, 21) = 1
  and Employee_insert(2, 'Гаврилов Гаврила', 3, 25) = 1
  and Employee_insert(3, 'Стрелков Сергей', 3, 24) = 1
  and Employee_insert(4, 'Зайцев Александр', 3, 29) = 1
  and Employee_insert(5, 'Ермолов Алексей', 4, 30) = 1
  and Employee_insert(6, 'Хорошева Ольга', 5, 36) = 1
  and Employee_insert(7, 'Тарасова Анастасия', 5, 27) = 1
  and Employee_insert(8, 'Монина Елизавета', 5, 21) = 1
  and Employee_insert(9, 'Левантов Роман', 6, 34) = 1
  and Employee_insert(10, 'Семёнов Павел', 2, 43) = 1
  and Employee_insert(11, 'Дробышева Алла', 7, 31) = 1
  and Employee_insert(12, 'Мехов Григорий', 7, 26) = 1
  and Employee_insert(13, 'Каспаров Сергей', 1, 41) = 1;
