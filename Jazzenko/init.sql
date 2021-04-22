delete from Airports;
delete from Planes;
delete from Companies;
delete from Schedule;

alter sequence Airports_ID_seq restart;
alter sequence Planes_ID_seq restart;
alter sequence Companies_ID_seq restart;
alter sequence Schedule_ID_seq restart;

--Airports
select * from airports_insert('Changi', 'Сингапур', 'Сингапур', '3');
select * from airports_insert('Suvernabhumi', 'Тайланд', 'Бангкок', '2');
select * from airports_insert('Barajas', 'Испания', 'Мадрид', '4');
select * from airports_insert('Hartsfield Int`l', 'США', 'Атланта', '2');
select * from airports_insert('Sabiha Gokcen International', 'Турция', 'Стамбул', '3');
select * from airports_insert('Brisbane', 'Австралия', 'Брисбен', '5');
select * from airports_insert('Dulles International', 'США', 'Вашингтон', '4');

--Planes

select * from planes_insert('1', 'Sukhoi SuperJet-100', '95');
select * from planes_insert('2', 'Sukhoi SuperJet-100', '90');
select * from planes_insert('2', 'Boeing-747', '300');
select * from planes_insert('3', 'Boeing-737', '190');
select * from planes_insert('4', 'Boeing-737', '185');
select * from planes_insert('5', 'Boeing-767', '250');
select * from planes_insert('5', 'Boeing-777', '225');
select * from planes_insert('6', 'Boeing-777', '230');

--Companies
select * from companies_insert('Qatar Airways', '92', ' Акбар аль Бейкер', 'Катар');
select * from companies_insert('Emirates', '95', 'Тим Кларк', 'ОАЭ');
select * from companies_insert('Аэрофлот', '92', 'Савельев В.Г.', 'Россия');
select * from companies_insert('Hainan Airlines', '88', 'Ма Чжиминь', 'Китай');
select * from companies_insert('SilkAir', '90', 'Фу Чай Ву', 'Сингапур');

--Schedule
select * from schedule_insert('2021-05-12 06:44:00', '1', '4', '2', '3', true, 95, 65);
select * from schedule_insert('2021-05-15 17:36:00', '2', '2', '4', '6', true, 90, 85);
select * from schedule_insert('2021-05-08 12:52:00', '5', '2', '6', '1', true, 185, 121);
select * from schedule_insert('2021-06-01 16:15:00', '3', '1', '5', '2', true, 300, 168);
select * from schedule_insert('2021-06-30 08:29:00', '8', '5', '2', '3', true, 230, 56);
select * from schedule_insert('2021-07-22 11:01:00', '4', '5', '7', '1', true, 190, 88);
select * from schedule_insert('2021-07-26 23:44:00', '6', '3', '1', '4', true, 250, 24);
select * from schedule_insert('2021-07-28 23:44:00', '7', '3', '6', '2', true, 225, 30);
