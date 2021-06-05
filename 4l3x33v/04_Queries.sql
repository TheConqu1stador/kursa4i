-- 2a - case-выражение и присоединение таблиц
-- Сравнительный уровень оплаты всех штатных сотрудников
create function public.Query2a() returns table("Имя" text, "Возраст" integer, "Часы в неделю" integer, "З/п" integer, "Уровень оплаты" text)
    language plpgsql
    as $$
begin
	return query
	select
		e.Name, e.Age, c.HoursPerWeek, c.Salary,
		case
			when c.salary <= 30000
				then 'Низкая оплата'
			when c.salary <= 55000
				then 'Средняя оплата'
			else
				'Высокая оплата'
		    end
	from Employee e
		inner join Contract c on c.ID = e.ContractID
	where c.inStaff = true;
end
$$;
