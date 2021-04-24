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

--ccn
create or replace function public.query_2c_GetLargeTasksInfo() returns table("Task ID" integer, "Task name" varchar(64), "Description" varchar(128), "Time spent" interval, "Start time" timestamp, "Update time" timestamp, "Access level" varchar(64), "Proj starts this month" boolean)
language plpgsql as
$$
begin
	return query
	select t.id, t.name, t.description, t.time_spent, s.Start_time, s.Update_time, s.al_Name, (select p.Start_time > (now() - INTERVAL '31d') from Project p where t.project_id = p.id) "Proj this month"
	from Access_Levels al, Task t
	inner join lateral (select id, Start_Time, Update_time, al.Name al_name from Status where Status.Access_Level = al.id) s on s.Id = t.id
	where t.time_spent > (select AVG(time_spent) from Task);
end
$$;

--nnc
create or replace function public.query_2c_GetActiveEmployeeStats() returns table("Employee ID" integer, "Employee name" varchar(64), "Post" varchar(64), "WD more than avg" boolean)
language plpgsql as
$$
begin
	return query
	select e.id, e.name, e.post, (select AVG(wd.end_time - wd.start_time)) > (select AVG(end_time - start_time) from working_day) moreThanAvgWd
	from employee e
	inner join (select employee_id, start_time, end_time from working_day) wd on wd.employee_id = e.id
	where exists(select 1 from Task inner join Status on Task.status_id = Status.id where task.executor_id = e.id and Status.Is_Archive = false)
	group by e.id
	order by e.id;
end
$$;

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

--8 scalar func
create or replace function public.query_8scalar_DivideIntervals(firstInterval interval, secondInterval interval) returns numeric
language plpgsql as
$$
begin
	return (EXTRACT(EPOCH from firstInterval) / EXTRACT(EPOCH from secondInterval));
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

--8 table
create function public.query_8table_GetProjectStats(_ID integer) returns table(Start_Time timestamp, Update_Time timestamp)
language plpgsql as
$$
begin
	return query
	select s.Start_Time, s.Update_Time
	from Project p
	inner join Task t on t.Project_ID = p.ID
	inner join Status s on t.Status_ID = s.ID
	where p.ID = _ID;
end
$$;

--678 procedure
create or replace procedure query_proc8_Archivate()
language plpgsql as
$$
declare
	cur cursor for select * from Status;
	rec record;
	projectid integer;
	projectAbandoned boolean;
begin
	for rec in cur loop
		
		if (rec.Update_Time < (now() - interval '31d')) then
			
			projectid = (select Project_ID from Task t where Status_ID = rec.ID);
			projectAbandoned = (now() - interval '14d') > (select max(Start_Time) from query_8table_GetProjectStats(projectid));
			
			if ((projectAbandoned = true) and (rec.Is_Archive = false)) then
			
				update Status
				set Is_Archive = true
				where rec.ID = ID;
				rec.Is_Archive = true;
				
			end if;
		end if;
		
		if ((rec.Is_Archive = true) and (rec.Access_Level = 1)) then
			update Status
			set Access_Level = 2
			where ID = rec.ID;
		end if;
		
		
		if (rec.Access_Level = 3) then
			rollback;
		else
			commit;
		end if;
		
	end loop;
end
$$;


--trigger
create or replace function public.Status_trigger() returns trigger
    language plpgsql as 
$$
begin
	if (TG_OP = 'INSERT') then
		if (NEW.Is_Archive = false) then
			NEW.Start_Time = now();
		end if;
		NEW.Update_Time = now();
		return NEW;
	end if;
	if (TG_OP = 'UPDATE') then
		NEW.Update_Time = now();
		return NEW;
	end if;
	if (TG_OP = 'DELETE') then
		call status_insert('archived', true, 2, old.start_time, null);
		update Task set Status_ID = (select MAX(ID) from Status) where Status_ID = old.ID;
		return old;
	end if;
end
$$;

create trigger status_trg before insert or update or delete on Status for each row execute function public.Status_trigger();


