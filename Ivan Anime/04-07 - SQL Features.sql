-- 4 - удаляет устаревшие доверенности
CREATE OR REPLACE PROCEDURE public."Актуализация доверенностей"()
	LANGUAGE plpgsql
	AS $$
DECLARE
	"i" INT;
BEGIN
	FOR "i" IN (SELECT "№ п/п" FROM "Дов-сть авто") LOOP
		IF ((SELECT "Дата выдачи" + make_interval(days => "Срок действия") FROM "Дов-сть авто" WHERE "№ п/п" = "i") < clock_timestamp()) THEN
			DELETE FROM "Дов-сть авто" WHERE "№ п/п" = "i";
		END IF;
	END LOOP;
	FOR "i" IN (SELECT "№ Доверенности" FROM "Доверенность") LOOP
		IF (SELECT "№ Договора" FROM "Договор" WHERE "№ Доверенности" = "i") IS NULL THEN
			IF ((SELECT "Дата выдачи" + make_interval(days => "Срок действия") FROM "Дов-сть авто" WHERE "№ Доверенности" = "i") < clock_timestamp()) THEN
				DELETE FROM "Доверенность" WHERE "№ Доверенности" = "i";
			END IF;
		END IF;
	END LOOP;
END
$$;

-- 5 - каталог авто из договоров
CREATE VIEW "Каталог" AS
	SELECT CONCAT("Авто"."Марка", ' ', "Авто"."Модель", ', ', "Авто"."Год выпуска") "Авто", 
		   CONCAT("Шины"."Производитель", ' ', "Шины"."Модель") "Модель шин", 
		   CONCAT("Диски"."Производитель", ' ', "Диски"."Модель") "Модель дисков",
		   CONCAT("КПП"."Тип коробки", ', ', "КПП"."Кол-во передач", ' передач') "КПП"
		   
	FROM "Договор"
		INNER JOIN "Авто" ON "Авто"."Гос номер" = "Договор"."Номер авто"
		INNER JOIN "Колесо" ON "Колесо"."№ п/п" = "Авто"."№ Колёс"
		INNER JOIN "Диски" ON "Диски"."№ п/п" = "Колесо"."№ Дисков"
		INNER JOIN "Шины" ON "Шины"."№ п/п" = "Колесо"."№ Шин"
		INNER JOIN "КПП" ON "Авто"."№ КПП" = "КПП"."№ п/п"


-- 6 - 


-- 7


-- ...