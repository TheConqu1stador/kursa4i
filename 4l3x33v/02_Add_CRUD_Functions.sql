--Должности

--Функция для получения всех записей из таблицы Profession
CREATE FUNCTION public.Profession_select() RETURNS TABLE(_id integer, _name text, _contractsMade integer, _contractsBroke integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Profession order by ID;
end
$$;

--Функция для вставки новых записей в таблицу Profession
CREATE FUNCTION public.Profession_insert(_name text, _contractsMade integer, _contractsBroke integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Profession(Name, ContractsMade, ContractsBroke)
	values(_name, _contractsMade, _contractsBroke);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

--Функция для обновления записей таблицы Profession
CREATE FUNCTION public.Profession_update(_id integer, _name text, _contractsMade integer, _contractsBroke integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Profession
	set
		Name = _name, 
		ContractsMade = _contractsMade, 
		ContractsBroke = _contractsBroke
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Функция для удаления записей из таблицы Profession
CREATE FUNCTION public.Profession_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Profession
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Договора

--Функция для получения всех записей из таблицы Contract
CREATE FUNCTION public.Contract_select() RETURNS TABLE(_id integer, _salary integer, _specialTerms text, _hoursPerWeek integer, _professionID integer, _inStaff boolean)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Contract order by ID;
end
$$;

--Функция для вставки записей в таблицу Contract
CREATE FUNCTION public.Contract_insert(_salary integer, _specialTerms text, _hoursPerWeek integer, _professionID integer, _inStaff boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Contract(Salary, SpecialTerms, HoursPerWeek, ProfessionID, inStaff)
	values(_salary, _specialTerms, _hoursPerWeek, _professionID, _inStaff);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

--Функция для обновления записей таблицы Contract
CREATE FUNCTION public.Contract_update(_id integer, _salary integer, _specialTerms text, _hoursPerWeek integer, _professionID integer, _inStaff boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Contract
	set
		Salary = _salary,
		SpecialTerms = _specialTerms, 
		HoursPerWeek = _hoursPerWeek, 
		ProfessionID = _professionID,
		inStaff = _inStaff
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Функция для удаления записей из таблицы Contract
CREATE FUNCTION public.Contract_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Contract
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Офисы

--Функция для получения всех записей из таблицы Office
CREATE FUNCTION public.Office_select() RETURNS TABLE(_id integer, _name text, _address text, _floors integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Office order by ID;
end
$$;

--Функция для вставки записей в таблицу Office
CREATE FUNCTION public.Office_insert(_name text, _address text, _floors integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Office(Name, Address, Floors)
	values(_name, _address, _floors);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

--Функция для обновления записей таблицы Office
CREATE FUNCTION public.Office_update(_id integer, _name text, _address text, _floors integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Office
	set
		Name = _name, 
		Address = _address, 
		Floors = _floors
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Функция для удаления записей из таблицы Office
CREATE FUNCTION public.Office_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Office
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;


--Отделы

--Функция для получения всех записей из таблицы Department
CREATE FUNCTION public.Department_select() RETURNS TABLE(_id integer, _name text, _parentDepartmentID integer, _mainOfficeID integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Department order by ID;
end
$$;

--Функция для вставки записей в таблицу Department
CREATE FUNCTION public.Department_insert(_name text, _parentDepartmentID integer, _mainOfficeID integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Department(Name, ParentDepartmentID, MainOfficeID)
	values(_name, _parentDepartmentID, _mainOfficeID);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

--Функция для обновления записей таблицы Department
CREATE FUNCTION public.Department_update(_id integer, _name text, _parentDepartmentID integer, _mainOfficeID integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Department
	set
		Name = _name, 
		ParentDepartmentID = _parentDepartmentID, 
		MainOfficeID = _mainOfficeID
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Функция для удаления записей из таблицы Department
CREATE FUNCTION public.Department_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Department
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Работники

--Функция для получения всех записей из таблицы Employee
CREATE FUNCTION public.Employee_select() RETURNS TABLE(_id integer, _contractID integer, _name text, _departmentID integer, _age integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Department order by ID;
end
$$;

--Функция для вставки записей в таблицу Employee
CREATE FUNCTION public.Employee_insert(_contractID integer, _name text, _departmentID integer, _age integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Employee(ContractID, Name, DepartmentID, Age)
	values(_contractID , _name, _departmentID, _age);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

--Функция для обновления записей таблицы Employee
CREATE FUNCTION public.Employee_update(_id integer, _contractID integer, _name text, _departmentID integer, _age integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Employee
	set
		ContractID = _contractID,
		Name = _name, 
		DepartmentID = _departmentID, 
		Age = _age
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Функция для удаления записей из таблицы Employee
CREATE FUNCTION public.Employee_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Employee
	where
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;