delete from Working_Day;
delete from Task;
delete from Project;
delete from Status;
delete from Employee;
delete from Access_Levels;

alter sequence Access_Levels_ID_seq restart;
alter sequence Employee_ID_seq restart;
alter sequence Status_ID_seq restart;
alter sequence Project_ID_seq restart;
alter sequence Task_ID_seq restart;
alter sequence Working_Day_ID_seq restart;

--Access_Levels
call Access_Levels_insert('Рабочий');
call Access_Levels_insert('Менеджер');
call Access_Levels_insert('Директор');

--Employee
call Employee_insert('Иванов Иван Иванович', 1, '30000', 'Младший разработчик');
call Employee_insert('Гоев Алексей Петрович', 1, '100', 'Системный архитектор');
call Employee_insert('Петров Петр Петрович', 1, '60000', 'Разработчик');
call Employee_insert('Александров Борис Юрьевич', 2, '80000', 'Менеджер важных проектов');
call Employee_insert('Филатов Вячеслав Валерьевич', 2, '700000', 'Менеджер слишком важных проектов');
call Employee_insert('Юдеман Иосиф Иудович', 3, '92233720368547', 'Технический директор');

--Status
call Status_insert('Принять в работу', false, 1, '2021-04-18 09:00:00', '2021-04-18 09:00:00');
call Status_insert('На проверке', false, 2, '2021-04-10 09:00:00', '2021-04-20 15:15:44');
call Status_insert('В работе', false, 1, '2021-04-12 09:00:00', '2021-04-13 14:35:03');
call Status_insert('Завершена', true, 2, '2021-04-05 09:00:00', '2021-04-22 11:26:51');

call Status_insert('Принять в работу', false, 1, '2021-04-13 15:00:00', '2021-04-13 15:00:00');
call Status_insert('На проверке', false, 2, '2021-04-08 11:53:22', '2021-04-12 13:44:19');
call Status_insert('В работе', false, 1, '2021-04-16 16:17:07', '2021-04-18 12:39:22');
call Status_insert('Завершена', true, 2, '2021-04-15 17:48:03', '2021-04-21 10:23:55');

--Project
call Project_insert('(((Важный))) проект', 4, 'ООО ПИВПРОМ', '2021-03-01 01:00:00');
call Project_insert('Слишком (((важный))) проект', 5, 'ЕАО ЗИОН', '2021-04-01 01:00:00');

--Task
call Task_insert(1, 1, 'Интересная задача', 1, '', INTERVAL '2H');
call Task_insert(2, 4, 'Очень интересная задача', 1, '', INTERVAL '7H');
call Task_insert(3, 3, 'Задача со звёздочкой', 1, '', INTERVAL '3H');
call Task_insert(4, 4, 'Задача коммивояжера', 1, '', INTERVAL '10H');

call Task_insert(5, 2, 'Сделать 50% проекта', 2, '', INTERVAL '1H');
call Task_insert(6, 5, 'Сделать 5% проекта', 2, '', INTERVAL '8H');
call Task_insert(7, 3, 'Сделать 44% проекта', 2, '', INTERVAL '5H');
call Task_insert(8, 5, 'Сделать 1% проекта', 2, '', INTERVAL '12H');

--Working_Day
call Working_Day_insert(1, '2021-04-11 08:00:00', '2021-04-11 18:00:00', INTERVAL '0H');
call Working_Day_insert(1, '2021-04-12 08:00:00', '2021-04-12 17:00:00', INTERVAL '30M');
call Working_Day_insert(1, '2021-04-13 08:00:00', '2021-04-13 17:30:00', INTERVAL '1H');

call Working_Day_insert(2, '2021-04-11 09:00:00', '2021-04-11 20:00:00', INTERVAL '0H');
call Working_Day_insert(2, '2021-04-12 09:00:00', '2021-04-12 18:00:00', INTERVAL '0H');
call Working_Day_insert(2, '2021-04-13 09:30:00', '2021-04-13 19:30:00', INTERVAL '45M');

call Working_Day_insert(3, '2021-04-11 09:00:00', '2021-04-11 18:00:00', INTERVAL '15M');
call Working_Day_insert(3, '2021-04-12 08:40:00', '2021-04-12 19:00:00', INTERVAL '25M');
call Working_Day_insert(3, '2021-04-13 08:20:00', '2021-04-13 18:30:00', INTERVAL '1H');

call Working_Day_insert(4, '2021-04-11 08:50:00', '2021-04-11 18:20:00', INTERVAL '2H');
call Working_Day_insert(4, '2021-04-12 10:00:00', '2021-04-12 17:50:00', INTERVAL '55M');
call Working_Day_insert(4, '2021-04-13 09:20:00', '2021-04-13 17:40:00', INTERVAL '40M');

call Working_Day_insert(5, '2021-04-11 08:30:00', '2021-04-11 19:10:00', INTERVAL '1H');
call Working_Day_insert(5, '2021-04-12 10:10:00', '2021-04-12 17:35:00', INTERVAL '15M');
call Working_Day_insert(5, '2021-04-13 08:50:00', '2021-04-13 18:30:00', INTERVAL '20M');

call Working_Day_insert(6, '2021-04-11 15:00:00', '2021-04-11 16:00:00', INTERVAL '1H');
call Working_Day_insert(6, '2021-04-12 12:00:00', '2021-04-12 14:00:00', INTERVAL '2H');
call Working_Day_insert(6, '2021-04-13 16:00:00', '2021-04-13 17:30:00', INTERVAL '1H30M');
