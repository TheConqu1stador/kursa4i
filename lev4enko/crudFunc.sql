--Airports

CREATE FUNCTION public.airports_select() RETURNS TABLE(_id integer, _name varchar(40), _country varchar(40), _city varchar(40), _terminals integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Airports order by A_ID;
end
$$;

CREATE FUNCTION public.airports_insert(_name varchar(40), _country varchar(40), _city varchar(40), _terminals integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Airports(A_Name, A_Country, A_City, A_Terminals)
	values(_name, _country, _city, _terminals);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.airports_update(_id integer, _name varchar(40), _country varchar(40), _city varchar(40), _terminals integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Airports
	set
		A_Name = _name, 
		A_Country = _country, 
		A_City = _city, 
		A_Terminals = _terminals
	where
		A_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

CREATE FUNCTION public.airports_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Airports
	where
		A_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Planes

CREATE FUNCTION public.planes_select() RETURNS TABLE(_id integer, _homeAirport integer, _model varchar(40), _seats integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Planes order by P_ID;
end
$$;

CREATE FUNCTION public.planes_insert(_homeAirport integer, _model varchar(40), _seats integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Planes(P_HomeAirport, P_Model, P_Seats)
	values(_homeAirport, _model, _seats);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.planes_update(_id integer, _homeAirport integer, _model varchar(40), _seats integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Planes
	set
		P_HomeAirport = _homeAirport, 
		P_Model = _model, 
		P_Seats = _seats
	where
		P_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

CREATE FUNCTION public.planes_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Planes
	where
		P_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Companies

CREATE FUNCTION public.companies_select() RETURNS TABLE(_id integer, _name varchar(40), _rating integer, _director varchar(40), _location varchar(40))
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Companies order by C_ID;
end
$$;

CREATE FUNCTION public.companies_insert(_name varchar(40), _rating integer, _director varchar(40), _location varchar(40)) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Companies(C_Name, C_Rating, C_Director, C_Location)
	values(_name, _rating, _director, _location);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.companies_update(_id integer, _name varchar(40), _rating integer, _director varchar(40), _location varchar(40)) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Companies
	set
		C_Name = _name,
		C_Rating = _rating, 
		C_Director = _director, 
		C_Location = _location
	where
		C_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

CREATE FUNCTION public.companies_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Companies
	where
		C_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Schedule

CREATE FUNCTION public.schedule_select() RETURNS TABLE(_id integer, _dateTime timestamp, _plane integer, _company integer, _from integer, _to integer, _active boolean)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Schedule order by S_ID;
end
$$;

CREATE FUNCTION public.schedule_insert(_dateTime timestamp, _plane integer, _company integer, _from integer, _to integer, _active boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Schedule(S_DateTime, S_Plane, S_Company, S_From, S_To, S_Active)
	values(_dateTime, _plane, _company, _from, _to, _active);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.schedule_update(_id integer, _dateTime timestamp, _plane integer, _company integer, _from integer, _to integer, _active boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Schedule
	set
		S_DateTime = _dateTime, 
		S_Plane = _plane, 
		S_Company = _company, 
		S_From = _from, 
		S_To = _to,
		S_Active = _active
	where
		S_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

CREATE FUNCTION public.schedule_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Schedule
	where
		S_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Buyers

CREATE FUNCTION public.buyers_select() RETURNS TABLE(_id integer, _fullName varchar(40), _discount integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Buyers order by B_ID;
end
$$;

CREATE FUNCTION public.buyers_insert(_fullName varchar(40), _discount integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Buyers(B_FullName, B_Discount)
	values(_fullName, _discount);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.buyers_update(_id integer, _fullName varchar(40), _discount integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Buyers
	set
		B_FullName = _fullName, 
		B_Discount = _discount
	where
		B_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

CREATE FUNCTION public.buyers_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Buyers
	where
		B_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Tickets

CREATE FUNCTION public.tickets_select() RETURNS TABLE(_id integer, _seat integer, _flight integer, _buyer integer, _cost float)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Tickets order by T_ID;
end
$$;

CREATE FUNCTION public.tickets_insert(_seat integer, _flight integer, _buyer integer, _cost float) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Tickets(T_Seat, T_Flight, T_Buyer, T_Cost)
	values(_seat, _flight, _buyer, _cost);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.tickets_update(_id integer, _seat integer, _flight integer, _buyer integer, _cost float) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Tickets
	set
		T_Seat = _seat, 
		T_Flight = _flight, 
		T_Buyer = _buyer, 
		T_Cost = _cost
	where
		T_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

CREATE FUNCTION public.tickets_delete(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from Tickets
	where
		T_ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;