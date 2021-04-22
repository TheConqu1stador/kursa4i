--Airports

CREATE FUNCTION public.airports_select() RETURNS TABLE(_id integer, _name text, _country text, _city text, _terminals integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Airports order by ID;
end
$$;

CREATE FUNCTION public.airports_insert(_name text, _country text, _city text, _terminals integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Airports(Name, Country, City, Terminals)
	values(_name, _country, _city, _terminals);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.airports_update(_id integer, _name text, _country text, _city text, _terminals integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Airports
	set
		Name = _name, 
		Country = _country, 
		City = _city, 
		Terminals = _terminals
	where
		ID = _id;
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
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Planes

CREATE FUNCTION public.planes_select() RETURNS TABLE(_id integer, _homeAirport integer, _model text, _seats integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Planes order by ID;
end
$$;

CREATE FUNCTION public.planes_insert(_homeAirport integer, _model text, _seats integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Planes(HomeAirport, Model, Seats)
	values(_homeAirport, _model, _seats);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.planes_update(_id integer, _homeAirport integer, _model text, _seats integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Planes
	set
		HomeAirport = _homeAirport, 
		Model = _model, 
		Seats = _seats
	where
		ID = _id;
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
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Companies

CREATE FUNCTION public.companies_select() RETURNS TABLE(_id integer, _name text, _rating integer, _director text, _location text)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Companies order by ID;
end
$$;

CREATE FUNCTION public.companies_insert(_name text, _rating integer, _director text, _location text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Companies(Name, Rating, Director, Location)
	values(_name, _rating, _director, _location);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.companies_update(_id integer, _name text, _rating integer, _director text, _location text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Companies
	set
		Name = _name,
		Rating = _rating, 
		Director = _director, 
		Location = _location
	where
		ID = _id;
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
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;

--Schedule

CREATE FUNCTION public.schedule_select() RETURNS TABLE(_id integer, _flightDate timestamp, _plane integer, _company integer, _source integer, _destination integer, _active boolean, _ticketsTotal integer, _ticketsSold integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from Schedule order by ID;
end
$$;

CREATE FUNCTION public.schedule_insert(_flightDate timestamp, _plane integer, _company integer, _source integer, _destination integer, _active boolean, _ticketsTotal integer, _ticketsSold integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into Schedule(FlightDate, Plane, Company, Source, Destination, Active, TicketsTotal, TicketsSold)
	values(_flightDate, _plane, _company, _source, _destination, _active, _ticketsTotal, _ticketsSold);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.schedule_update(_id integer, _flightDate timestamp, _plane integer, _company integer, _source integer, _destination integer, _active boolean, _ticketsTotal integer, _ticketsSold integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update Schedule
	set
		FlightDate = _flightDate, 
		Plane = _plane, 
		Company = _company, 
		Source = _source, 
		Destination = _destination,
		Active = _active,
		TicketsTotal = _ticketsTotal,
		TicketsSold = _ticketsSold
	where
		ID = _id;
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
		ID = _id;
	if found then
		return 1;
	else	
		return 0;
	end if;	
end
$$;
