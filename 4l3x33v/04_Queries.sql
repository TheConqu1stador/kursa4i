-- 2a - case-выражение и присоединение таблиц
-- Сравнительный уровень оплаты всех штатных сотрудников
create or replace function public.Query2a(_low_rate integer) returns table("Имя" text, "Возраст" integer, "Часы в неделю" integer, "З/п" integer, "Уровень оплаты" text)
    language plpgsql
    as $$
begin
	return query
	select
		e.Name, e.Age, c.HoursPerWeek, c.Salary,
		case
			when c.salary <= _low_rate
				then 'Низкая оплата'
			when c.salary <= (select * from calculateMediumRate(_low_rate))
				then 'Средняя оплата'
			else
				'Высокая оплата'
		    end
	from Employee e
		inner join Contract c on c.ID = e.ContractID
	where c.inStaff = true;
end
$$;

-- 8 пункт, скалярная функция
-- Вычисляет среднюю планку между указанной нижней границей и максимальной зарплатой
create or replace function public.calculateMediumRate(_low_rate integer) returns numeric
    language plpgsql
    as $$
begin
	return ((select MAX(salary) from Contract) + _low_rate) / 2;
end
$$;

-- 2b - view
-- Много информации по сотрудникам
create or replace view View_Employees as
	select e.Name n1, e.Age, o.Name n2, o.Address, d.Name n3, c.Salary, p.Name n4
	from Employee e
		inner join Department d on d.ID = e.DepartmentID
		inner join Office o on o.ID = d.MainOfficeID
		inner join Contract c on c.ID = e.ContractID
		inner join Profession p on p.ID = c.ProfessionID;
	
	
create or replace function public.Query2b() returns table("Имя" text, "Возраст" integer, "Офис" text, "Адрес офиса" text, "Департамент" text, "З/п" integer, "Должность" text)
    language plpgsql
    as $$
begin
	return query
	select *
	from View_Employees;
end
$$;

-- 2c - кореллированные и некореллированные
-- 2c1 - среднее количество рабочих часов для каждого департамента и в целом
create or replace function public.Query2c1() returns table("Департамент" text, "Средне часов " int, "Средне часов в департаменте" int)
    language plpgsql
    as $$
begin
	return query
	select distinct d.Name, 
	(select AVG(HoursPerWeek) from Contract)::int avgall,	-- некореллированный в select
	(select AVG(HoursPerWeek) from Contract ci				-- /
		inner join Employee ei on ei.ContractID = ci.ID 	-- | кореллированный в select
		where ei.DepartmentID = e.DepartmentID)::int avgdpt -- \
	from Employee e
		inner join (select * from Department where MainOfficeID = 2) d on d.ID = e.DepartmentID; -- некореллированный в from
end
$$;

-- 2c2 - потенциальные наставники с той же профессией и зарплатой выше среднего для работников с возрастом ниже среднего
create or replace function public.Query2c2() returns table("Потенциальный ученик" text, "Потенциальный наставник" text)
    language plpgsql
    as $$
begin
	return query
	select e.Name, ltTable.Name
		from Employee e
		inner join Contract c on e.ContractID = c.ID
		inner join lateral (select ei.ID, ei.Name, ci.Salary, ei.DepartmentID from Employee ei -- /
						inner join Contract ci on ei.ContractID = ci.ID 					   -- | кореллированный в from
						where ci.ProfessionID = c.ProfessionID) ltTable on e.ID != ltTable.ID  -- \
		where (select avg(Salary) from Contract) <= ltTable.Salary							   -- некореллированный в where
		  and (select avg(Age) from Employee where DepartmentID = e.DepartmentID) >= e.Age;    -- кореллированный в where
end
$$;

-- 2d - Функция возвращает названия должностей, на которых средняя зп выше либо равна указанной

create or replace function public.Query2d(_salary integer) returns table("Название должности" text, "Средняя зарплата" numeric)
    language plpgsql
    as $$
begin
	return query
	select p.Name, AVG(c.salary) from Contract c
	inner join Profession p on c.ProfessionID = p.ID
	group by p.Name
	having AVG(c.salary) >= _salary;
end
$$;

-- 2e
-- Функция возвращает названия должностей, у которых все сотрудники являются штатными
create or replace function public.Query2e() returns table("Название должности" text)
    language plpgsql
    as $$
begin
	return query
	select distinct p.Name
	from Profession p
	inner join Contract c on c.ProfessionID = p.ID
	where 'true' = all(
		select InStaff from 
		Profession p
		inner join Contract ci on ci.ProfessionID = p.ID 
		where ci.ProfessionID = c.ProfessionID
	);
end
$$;

-- 8 пункт, векторная функция
-- Возвращает все контракты, не связаные с должнстью директора
create or replace function public.getNonDirectorContracts() returns table(ID int, Salary int, SpecialTerms text, HoursPerWeek int, ProfessionID int, inStaff bool)
	language plpgsql
	as $$
begin
	return query
	select * 
		from Contract
		where Contract.ProfessionID != 5;
end
$$;

-- 6-7 пункт. Реализован курсор по всем договорам.
--Если в специальных условиях договора прописана возможность удаленной работы, то переводим сотрудника на внештат
--Если внештатников слишком много (> 50% всех сотрудников), то прекращаем перевод во внештат (откатываем транзакцию).

create or replace procedure Query6_7()
language plpgsql as
$$
declare
	cur cursor for select * from getNonDirectorContracts();
	rec record;
begin
	for rec in cur loop
		if rec.SpecialTerms like '%удалённая работа%' then
			update Contract
			set InStaff = false
				where ID = rec.ID;
		end if;
		if ((select COUNT(1) from Contract where InStaff = false) > (select COUNT(1) / 2 from Contract)) then
			rollback;
		else
			commit;
		end if;
		
	end loop;
end
$$;

-- 4 пункт, триггер на изменение таблицы Profession
-- В случае вставки новой записи в таблицу Contracts, поле ContractsMade той профессии, для которой заключается конракт, инкрементируется
-- В случае удаления записи из таблицы Contracts, поле ContractsBroke той профессии, для которой расторгается конракт, инкрементируется
-- В случае апдейта записи в таблице Contracts, фиксируется поле ProfessionID
create or replace function public.Contract_trigger() returns trigger
    language plpgsql as 
$$
begin
	if (TG_OP = 'INSERT') then
		update Profession set ContractsMade = ContractsMade + 1
		where ID = new.ProfessionID;
		
		return NEW;
	end if;
	if (TG_OP = 'UPDATE') then
		new.ProfessionID = old.ProfessionID; 
		return NEW;
	end if;
	if (TG_OP = 'DELETE') then
		update Profession set ContractsBroke = ContractsBroke + 1
		where ID = old.ProfessionID;
		
		return old;
	end if;
end
$$;

create trigger contract_trg before insert or update or delete on Contract for each row execute function public.Contract_trigger();