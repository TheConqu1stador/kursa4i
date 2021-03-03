delete from Airports;
delete from Planes;
delete from Companies;
delete from Schedule;
delete from Buyers;
delete from Tickets;

alter sequence Airports_A_ID_seq restart;
alter sequence Planes_P_ID_seq restart;
alter sequence Companies_C_ID_seq restart;
alter sequence Schedule_S_ID_seq restart;
alter sequence Buyers_B_ID_seq restart;
alter sequence Tickets_T_ID_seq restart;

--Airports
select * from airports_insert('Аэропорт Хитроу', 'Великобритания', 'Лондон', '5');
select * from airports_insert('Аэропорт Париж — Шарль-де-Голль', 'Франция', 'Париж', '3');
select * from airports_insert('Международный аэропорт имени Ататюрка', 'Турция', 'Стамбул', '2');
select * from airports_insert('Аэропорт Франкфурт-на-Майне', 'Германия', 'Франкфурт', '3');
select * from airports_insert('Амстердамский аэропорт Схипхол', 'Нидерланды', 'Амстердам', '1');
select * from airports_insert('Аэропорт Мадрид-Барахас', 'Испания', 'Мадрид', '4');
select * from airports_insert('Аэропорт Фьюмичино', 'Италия', 'Рим', '5');
select * from airports_insert('Международный аэропорт Шереметьево', 'Россия', 'Москва', '8');

--Planes

select * from planes_insert('1', 'Airbus A380-800', '700');
select * from planes_insert('1', 'Boeing 747-8', '605');
select * from planes_insert('6', 'Boeing 747-400', '660');
select * from planes_insert('7', 'Boeing 777-300', '550');
select * from planes_insert('7', 'Airbus A340-600', '475');
select * from planes_insert('8', 'Boeing 777-200', '440');
select * from planes_insert('8', 'Airbus A350-900', '380');
select * from planes_insert('8', 'Airbus A333-300', '335');

--Companies
select * from companies_insert('American Airlines', '96', 'Дуг Паркер', 'США');
select * from companies_insert('Emirates', '98', 'Тим Кларк', 'ОАЭ');
select * from companies_insert('Ryanair', '90', 'Майкл Коули', 'Ирландия');
select * from companies_insert('Lufthansa', '94', 'Карстен Шпор', 'Германия');
select * from companies_insert('Аэрофлот', '92', 'Савельев В.Г.', 'Россия');

--Schedule
select * from schedule_insert('2021-02-12 04:05:00', '1', '1', '1', '6', true);
select * from schedule_insert('2021-02-12 14:16:00', '2', '3', '2', '4', true);
select * from schedule_insert('2021-02-11 02:56:00', '3', '2', '2', '3', true);
select * from schedule_insert('2021-02-11 06:15:00', '4', '1', '7', '1', true);
select * from schedule_insert('2021-02-11 18:29:00', '5', '4', '5', '2', true);
select * from schedule_insert('2021-02-10 01:01:00', '6', '4', '1', '8', true);
select * from schedule_insert('2021-02-10 21:44:00', '7', '3', '8', '6', true);
select * from schedule_insert('2021-02-09 17:37:00', '8', '5', '3', '7', true);

--Buyers
select * from buyers_insert('Буков Игорь Матвеевич', '0');
select * from buyers_insert('Качурина Наталия Тимуровна', '10');
select * from buyers_insert('Лысов Денис Гаврилевич', '0');
select * from buyers_insert('Калмыкова Анфиса Елизаровна', '0');
select * from buyers_insert('Кахманова Григорий Артемович', '0');
select * from buyers_insert('Ямковой Демьян Валерьянович', '5');
select * from buyers_insert('Мамонова Екатерина Филипповна', '0');
select * from buyers_insert('Ижутин Игорь Куприянович', '7');

--Tickets

select * from tickets_insert('101', '1', '1', '1000');
select * from tickets_insert('21', '2', '2', '2000');
select * from tickets_insert('112', '3', '3', '3000');
select * from tickets_insert('251', '4', '4', '4000');
select * from tickets_insert('111', '5', '5', '5000');
select * from tickets_insert('47', '6', '6', '6000');
select * from tickets_insert('310', '7', '7', '7000');
select * from tickets_insert('57', '8', '8', '8000');