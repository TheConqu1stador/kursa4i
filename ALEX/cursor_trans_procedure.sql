create function public.query_tfunc8_GetProjectStats(_ID integer) returns table(Start_Time timestamp, Update_Time timestamp)
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
		
		if (rec.Update_Time < (now() - '31d')) then
			
			projectid = (select Project_ID from Task t where Status_ID = rec.ID);
			projectAbandoned = (now() - '14d') > (select max(Start_Time) from query_tfunc8_GetProjectStats(projectid));
			
			if ((projectAbandoned = true) and (rec.Is_Archive = false)) then
			
				update Status
				set Is_Archive = true
				where rec.ID = ID;
				rec.Is_Archive = true;
				
			end if;
		end if;
		
		if ((rec.Is_Archive = true) and (rec.AccessLevel = 1)) then
			update Status
			set AccessLevel = 2
			where ID = rec.ID;
		end if;
		
		
		if (rec.AccessLevel = 3) then
			rollback;
		else
			commit;
		end if;
		
	end loop;
end
$$;