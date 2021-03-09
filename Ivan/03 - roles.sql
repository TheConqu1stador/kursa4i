CREATE USER admin WITH 
	ENCRYPTED PASSWORD 'admin';
ALTER USER admin WITH SUPERUSER;

CREATE ROLE operator;
GRANT USAGE ON SCHEMA public TO operator;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Заявка" TO operator;
GRANT SELECT ON TABLE public."Переч. Штрафов" TO operator;
GRANT SELECT ON TABLE public."ПТС" TO operator;
GRANT SELECT ON TABLE public."СТС" TO operator;
GRANT SELECT ON TABLE public."КПП" TO operator;
GRANT SELECT ON TABLE public."Двигатель" TO operator;
GRANT SELECT ON TABLE public."Колесо" TO operator;
GRANT SELECT ON TABLE public."Диски" TO operator;
GRANT SELECT ON TABLE public."Шины" TO operator;
GRANT SELECT ON TABLE public."Авто" TO operator;
GRANT SELECT ON public."Каталог" TO operator;

CREATE USER john WITH
	IN ROLE operator
	ENCRYPTED PASSWORD '2hard';
CREATE USER michael WITH
	IN ROLE manager
	ENCRYPTED PASSWORD 'e4sy';

CREATE ROLE seller;
GRANT USAGE ON SCHEMA public TO seller;
GRANT SELECT,INSERT,UPDATE ON TABLE public."РПДС" TO seller;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Договор" TO seller;
GRANT SELECT ON TABLE public."Переч. Штрафов" TO seller;
GRANT SELECT ON TABLE public."ПТС" TO seller;
GRANT SELECT ON TABLE public."СТС" TO seller;
GRANT SELECT ON TABLE public."КПП" TO seller;
GRANT SELECT ON TABLE public."Двигатель" TO seller;
GRANT SELECT ON TABLE public."Колесо" TO seller;
GRANT SELECT ON TABLE public."Диски" TO seller;
GRANT SELECT ON TABLE public."Шины" TO seller;
GRANT SELECT ON TABLE public."Авто" TO seller;
GRANT SELECT ON public."Каталог" TO seller;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Паспорт" TO seller;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Координаты" TO seller;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Дов-сть авто" TO seller;

CREATE USER bestseller WITH
	IN ROLE seller
	ENCRYPTED PASSWORD 'allo';
CREATE USER anotherbestseller WITH
	IN ROLE seller
	ENCRYPTED PASSWORD 'dada';
CREATE USER andanotherbestseller WITH
	IN ROLE seller
	ENCRYPTED PASSWORD 'nukak';
	
CREATE ROLE accountant;
GRANT USAGE ON SCHEMA public TO accountant;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Счет-фактура" TO accountant;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Договор" TO accountant;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Налог.Дек." TO accountant;
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE public."Доверенность" TO accountant;
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE public."Дов-сть авто" TO accountant;
CREATE USER zina WITH
	IN ROLE accountant
	ENCRYPTED PASSWORD 'sdengami';
CREATE USER lyuba WITH
	IN ROLE accountant
	ENCRYPTED PASSWORD 'a';