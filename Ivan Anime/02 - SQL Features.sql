-- 4 - удаляет устаревшие и неиспользуемые при этом доверенности
CREATE OR REPLACE PROCEDURE public."Актуализация доверенностей"()
	LANGUAGE plpgsql
	AS $$
DECLARE
	"i" INT;
BEGIN
	FOR "i" IN (SELECT "№ Записи" FROM "Дов-сть авто") LOOP
		IF ((SELECT "Дата выдачи" + make_interval(days => "Срок действия") 
			FROM "Дов-сть авто" WHERE "№ Записи" = "i") < clock_timestamp()) THEN
			DELETE FROM "Дов-сть авто" WHERE "№ Записи" = "i";
		END IF;
	END LOOP;
	FOR "i" IN (SELECT "№ Доверенности" FROM "Доверенность") LOOP
		IF (SELECT "№ Договора" FROM "Договор" WHERE "№ Доверенности" = "i") IS NULL THEN
			IF ((SELECT "Дата выдачи" + make_interval(days => "Срок действия") 
				FROM "Дов-сть авто" WHERE "№ Доверенности" = "i") < clock_timestamp()) THEN
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
		INNER JOIN "Колесо" ON "Колесо"."№ Записи" = "Авто"."№ Колёс"
		INNER JOIN "Диски" ON "Диски"."№ Записи" = "Колесо"."№ Дисков"
		INNER JOIN "Шины" ON "Шины"."№ Записи" = "Колесо"."№ Шин"
		INNER JOIN "КПП" ON "Авто"."№ КПП" = "КПП"."№ Записи"

-- 6 - Сдаём машину на запчасти и металлолом
CREATE OR REPLACE FUNCTION public."Металлолом"("Номер" VARCHAR(9)) RETURNS INT
	LANGUAGE plpgsql
	AS $$
DECLARE
	"Результат" INT;
BEGIN
	"Результат" = GREATEST(3, 20 - date_part('year', now())::INT + (SELECT "Год выпуска" FROM "Авто" WHERE "Гос номер" = "Номер")::INT);
	"Результат" = "Результат" * (SELECT "Вес ТС" FROM "СТС" WHERE "Номер авто" = "Номер") * 100;
	RETURN "Результат";
END
$$;

-- 7


-- ...