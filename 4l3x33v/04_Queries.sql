-- 2a - case-выражение и присоединение таблиц
-- Сравнительный уровень оплаты всех штатных сотрудников
create function public.Query2a(_low_rate integer, _high_rate integer) returns table("Имя" text, "Возраст" integer, "Часы в неделю" integer, "З/п" integer, "Уровень оплаты" text)
    language plpgsql
    as $$
begin
	return query
	select
		e.Name, e.Age, c.HoursPerWeek, c.Salary,
		case
			when c.salary <= _low_rate
				then 'Низкая оплата'
			when c.salary <= _high_rate
				then 'Средняя оплата'
			else
				'Высокая оплата'
		    end
	from Employee e
		inner join Contract c on c.ID = e.ContractID
	where c.inStaff = true;
end
$$;

-- 2b - view
-- Много информации по сотрудникам
create view View_Employees as
	select e.Name n1, e.Age, o.Name n2, o.Address, d.Name n3, c.Salary, p.Name n4
	from Employee e
		inner join Department d on d.ID = e.DepartmentID
		inner join Office o on o.ID = d.MainOfficeID
		inner join Contract c on c.ID = e.ContractID
		inner join Profession p on p.ID = c.ProfessionID;
	
	
create function public.Query2b() returns table("Имя" text, "Возраст" integer, "Офис" text, "Адрес офиса" text, "Департамент" text, "З/п" integer, "Должность" text)
    language plpgsql
    as $$
begin
	return query
	select *
	from View_Employees;
end
$$;

-- 2c - 
-- 
create function public.Query2c() returns table()
    language plpgsql
    as $$
begin
	return query
	select *
	from View_Employees;
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

-- 6-7 пункт. Реализован курсор по всем договорам.
--Если в специальных условиях договора прописана возможность удаленной работы, то переводим сотрудника на внештат
--Если внештатников слишком много (> 50% всех сотрудников), то прекращаем перевод во внештат (откатываем транзакцию).
create or replace procedure Query6_7()
language plpgsql as
$$
declare
	cur cursor for select * from Contract;
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