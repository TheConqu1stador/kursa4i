--2a
create or replace function public.query_2a_GetAccessStatus(_projectID integer) returns table("Project name" varchar(64), "Task ID" integer, "Executor name" varchar(64), "Access status" text)
language plpgsql as
$$
begin
	return query
	select p.Name as proj_name, t.ID as task_id, e.Name as executor_name,
		case 
			when (s.Access_Level = 1)
				then 'Рабочий может продолжать выполнение'
			when (s.Access_Level  = 2) 
				then 'Нужно участие менеджера'
			when (s.Access_Level  = 3) 
				then 'Нужно участие директора'
		end "Access"
		from Task t
		inner join Project p on p.id = t.Project_ID 
		inner join Employee e on e.id = t.Executor_ID 
		inner join Status s on s.id = t.Status_ID 
	where t.Project_ID = _projectID;
end
$$;

--2b
create or replace view View_Projects as
	select t.ID, s.Description as "Status desc", e.Name as "Employee name", t.Name as "Task name", p.Name as "Project name", t.Description as "Task desc", t.Time_spent as "Time spent" from Task t
		inner join Project p on p.id = t.Project_ID 
		inner join Employee e on e.id = t.Executor_ID 
		inner join Status s on s.id = t.Status_ID;

create or replace function public.query_2b_GetProjectsInfoEx() returns table("Task ID" integer, "Status desc" varchar(64), "Employee name" varchar(64), "Task name" varchar(64), "Project name" varchar(64), "Task desc" varchar(64), "Time spent" interval)
language plpgsql as
$$
begin
	return query
	select * from View_Projects;
end
$$;

--2c

--2d
create or replace function public.query_2d_GetAmountOfBreaksMoreThanHour(_employee_id integer) returns table("Name" text, "Max break" interval, "Amount" bigint)
language plpgsql as
$$
begin
	return query
	select MAX(e.Name), MAX(wd.breaks_time), COUNT(*)
	from Working_Day wd
	inner join Employee e on wd.Employee_id = e.id
	where wd.breaks_time >= INTERVAL '1H'
	group by wd.employee_id
	having MAX(e.ID) = _employee_id;
end
$$;

--2e
create or replace function public.query_2e_GetEmployeesWithAvgBreaksMoreThan10perc() returns table("Name" varchar(64))
language plpgsql as
$$
begin
	return query
	SELECT Name
	FROM Employee
	WHERE ID = ANY 
	(select wd.employee_id from Working_Day wd 
		where EXTRACT(EPOCH from breaks_time) > 0
		group by employee_ID
		having query_8scalar_DivideIntervals(AVG(wd.breaks_time), AVG(end_time - start_time)) > 0.1);
end
$$;

--8 scalar
create or replace function public.query_8scalar_DivideIntervals(firstInterval interval, secondInterval interval) returns numeric
language plpgsql as
$$
begin
	return (EXTRACT(EPOCH from firstInterval) / EXTRACT(EPOCH from secondInterval));
end
$$;
	