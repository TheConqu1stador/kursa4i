--CREATE
CREATE TABLE IF NOT EXISTS public.Airports (
	ID INT
	GENERATED ALWAYS AS IDENTITY
	NOT NULL
	UNIQUE
	PRIMARY KEY,
	Name TEXT
	DEFAULT 'New Airport',
	Country TEXT
	DEFAULT 'New Country',
	City TEXT
	DEFAULT 'New City',
	Terminals INT
	DEFAULT 0
);

CREATE INDEX Index_AirportID ON Airports(ID);
ALTER TABLE Airports CLUSTER ON Index_AirportID;
CLUSTER Airports;

CREATE TABLE IF NOT EXISTS public.Planes (
	ID INT
	GENERATED ALWAYS AS IDENTITY
	NOT NULL
	UNIQUE
	PRIMARY KEY,
	HomeAirport INT
	DEFAULT 1,
	Model TEXT
	DEFAULT 'Default Model',
	Seats INT
	DEFAULT 0,
	LastMaintenance TIMESTAMP
	DEFAULT NULL,
	Active BOOLEAN
	DEFAULT true,
	CONSTRAINT FK_PlaneAirport_ID
	FOREIGN KEY(HomeAirport)
	REFERENCES public.Airports(ID)
	ON DELETE SET NULL
);

CREATE INDEX Index_PlaneHomeAirport ON Planes(HomeAirport);
ALTER TABLE Planes CLUSTER ON Index_PlaneHomeAirport;
CLUSTER Planes;

CREATE TABLE IF NOT EXISTS public.Companies (
	ID INT
	GENERATED ALWAYS AS IDENTITY
	NOT NULL
	UNIQUE
	PRIMARY KEY,
	Name TEXT
	DEFAULT 'New Company',
	Rating INT
	DEFAULT 0,
	Director TEXT
	DEFAULT 'John Galt',
	Location TEXT
	DEFAULT 'Outer Space'
);

CREATE INDEX Index_CompanyName ON Companies(Name);
ALTER TABLE Companies CLUSTER ON Index_CompanyName;
CLUSTER Companies;

CREATE INDEX Index_CompanyRating ON Companies(Rating);

CREATE TABLE IF NOT EXISTS public.Schedule (
	ID INT
	GENERATED ALWAYS AS IDENTITY
	NOT NULL
	UNIQUE
	PRIMARY KEY,
	FlightDate TIMESTAMP
	DEFAULT now() + interval '1d',
	Plane INT
	DEFAULT 1,
	Company INT
	DEFAULT 1,
	Source INT
	DEFAULT 1,
	Destination INT
	DEFAULT 1,
	TicketsTotal INT
	DEFAULT 100,
	TicketsSold INT
	DEFAULT 0,
	Active BOOLEAN
	DEFAULT true,
	CONSTRAINT FK_Schedule_PlaneID
	FOREIGN KEY(Plane)
	REFERENCES public.Planes(ID)
	ON DELETE SET NULL,
	CONSTRAINT FK_Schedule_CompanyID
	FOREIGN KEY(Company)
	REFERENCES public.Companies(ID)
	ON DELETE SET NULL,
	CONSTRAINT FK_Schedule_Airport_ID_Source
	FOREIGN KEY(Source)
	REFERENCES public.Airports(ID)
	ON DELETE SET NULL,
	CONSTRAINT FK_Schedule_Airport_ID_Destination
	FOREIGN KEY(Destination)
	REFERENCES public.Airports(ID)
	ON DELETE SET NULL
);

CREATE INDEX Index_Schedule_Plane ON Schedule(Plane);

CREATE INDEX Index_Schedule_Company ON Schedule(Company);

CREATE INDEX Index_Schedule_Source ON Schedule(Source);

CREATE INDEX Index_Schedule_Destination ON Schedule(Destination);

CREATE INDEX Index_Schedule_ID ON Schedule(ID);
ALTER TABLE Schedule CLUSTER ON Index_Schedule_ID;
CLUSTER Schedule;


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

CREATE FUNCTION public.planes_select() RETURNS TABLE(_id integer, _homeAirport integer, _model text, _seats integer, _LastMaintenance timestamp, _Active boolean)
LANGUAGE plpgsql
AS $$
begin
	return query
	select * from Planes order by ID;
end
$$;

CREATE FUNCTION public.planes_insert(_homeAirport integer, _model text, _seats integer, _LastMaintenance timestamp, _Active boolean) RETURNS integer
LANGUAGE plpgsql
AS $$
begin
	insert into Planes(HomeAirport, Model, Seats, LastMaintenance, Active)
	values(_homeAirport, _model, _seats, _LastMaintenance, _Active);
	if found then
		return 1;
	else
		return 0;
	end if;
end
$$;

CREATE FUNCTION public.planes_update(_id integer, _homeAirport integer, _model text, _seats integer, _LastMaintenance timestamp, _Active boolean) RETURNS integer
LANGUAGE plpgsql
AS $$
begin
	update Planes
	set
	HomeAirport = _homeAirport,
	Model = _model,
	Seats = _seats,
	LastMaintenance = _LastMaintenance,
	Active = _Active
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
 
delete from Airports;
delete from Planes;
delete from Companies;
delete from Schedule;

alter sequence Airports_ID_seq restart;
alter sequence Planes_ID_seq restart;
alter sequence Companies_ID_seq restart;
alter sequence Schedule_ID_seq restart;

--Airports
select * from airports_insert('Changi', 'Сингапур', 'Сингапур', '3');
select * from airports_insert('Suvernabhumi', 'Тайланд', 'Бангкок', '2');
select * from airports_insert('Barajas', 'Испания', 'Мадрид', '4');
select * from airports_insert('Hartsfield Int`l', 'США', 'Атланта', '2');
select * from airports_insert('Sabiha Gokcen International', 'Турция', 'Стамбул', '3');
select * from airports_insert('Brisbane', 'Австралия', 'Брисбен', '5');
select * from airports_insert('Dulles International', 'США', 'Вашингтон', '4');

--Planes

select * from planes_insert('1', 'Sukhoi SuperJet-100', '95', '2018-04-09', true);
select * from planes_insert('2', 'Sukhoi SuperJet-100', '90', '2018-04-10', true);
select * from planes_insert('2', 'Boeing-747', '300', '2019-06-22', true);
select * from planes_insert('3', 'Boeing-737', '190', '2021-04-09', true);
select * from planes_insert('4', 'Boeing-737', '185', '2021-03-11', true);
select * from planes_insert('5', 'Boeing-767', '250', '2020-07-08', false);
select * from planes_insert('5', 'Boeing-777', '225', '2019-12-27', true);
select * from planes_insert('6', 'Boeing-777', '230', '2011-04-09', false);

--Companies
select * from companies_insert('Qatar Airways', '92', 'Акбар аль Бейкер', 'Катар');
select * from companies_insert('Emirates', '95', 'Тим Кларк', 'ОАЭ');
select * from companies_insert('Аэрофлот', '92', 'Савельев В.Г.', 'Россия');
select * from companies_insert('Hainan Airlines', '88', 'Ма Чжиминь', 'Китай');
select * from companies_insert('SilkAir', '90', 'Фу Чай Ву', 'Сингапур');

--Schedule
select * from schedule_insert('2021-03-12 17:42:00', '1', '4', '1', '7', false, 280, 214);
select * from schedule_insert('2021-03-14 04:51:00', '7', '3', '7', '1', false, 180, 179);
select * from schedule_insert('2021-05-12 06:44:00', '1', '4', '2', '3', true, 95, 65);
select * from schedule_insert('2021-05-15 17:36:00', '2', '2', '4', '6', true, 90, 85);
select * from schedule_insert('2021-05-08 12:52:00', '5', '2', '6', '1', true, 185, 121);
select * from schedule_insert('2021-06-01 16:15:00', '3', '1', '5', '2', true, 300, 168);
select * from schedule_insert('2021-06-30 08:29:00', '7', '5', '2', '3', true, 230, 56);
select * from schedule_insert('2021-07-22 11:01:00', '4', '5', '7', '1', true, 190, 88);
select * from schedule_insert('2021-07-26 23:44:00', '5', '3', '1', '4', true, 250, 24);
select * from schedule_insert('2021-07-28 23:44:00', '7', '3', '6', '2', true, 225, 30);
select * from schedule_insert('2021-05-13 05:33:00', '3', '1', '3', '2', true, 95, 81);
select * from schedule_insert('2021-05-16 11:38:00', '1', '5', '6', '4', true, 90, 73);
select * from schedule_insert('2021-05-21 15:01:00', '5', '4', '1', '6', true, 185, 183);
select * from schedule_insert('2021-06-27 17:45:00', '7', '2', '2', '5', true, 300, 95);
select * from schedule_insert('2021-07-04 09:34:00', '4', '3', '3', '2', true, 230, 144);
select * from schedule_insert('2021-07-18 13:49:00', '3', '3', '1', '7', true, 190, 20);
select * from schedule_insert('2021-07-29 11:32:00', '2', '4', '4', '1', true, 250, 54);
select * from schedule_insert('2021-08-03 19:34:00', '7', '5', '2', '6', true, 225, 11);



-- quieres
--a
create function public.q2a_GetFlightsWithSeats(_Seats integer) returns table("From" text, "To" text, "Flight time" timestamp, "Tickets" integer, "Sold" integer, "Active" boolean, "Result" text)
language plpgsql as
$$
begin
	return query
	select afrom.City, ato.City, s.FlightDate, s.TicketsTotal, s.TicketsSold, s.Active,
	case 
		when ((NOT s.Active) OR s.FlightDate < now())
			then 'Рейс не активен'
		when (s.Active AND q8scalar_GetSeats(s.ID) >= _Seats) 
			then 'Достаточно мест'
		when (s.Active AND s.TicketsTotal-s.TicketsSold < _Seats)
			then 'Мест не хватает'
	end "Result"
	from Schedule s
	inner join Airports afrom on afrom.ID = s.Source
	inner join Airports ato on ato.ID = s.Destination;
end
$$;

-- b
create view View_Schedule as
	select afrom.Country "From Country", afrom.City "From City", afrom.Name "From Name", ato.Country, ato.City, ato.Name, s.FlightDate, s.TicketsTotal, s.TicketsSold
	from Schedule s
	inner join Airports afrom on afrom.ID = s.Source
	inner join Airports ato on ato.ID = s.Destination
	where (s.Active AND s.FlightDate > now());

create function public.q2b_GetActiveFlights() returns table("From Country" text, "From City" text, "From Name" text, "To Country" text, "To City" text, "To Name" text, "Flight time" timestamp, "Tickets" integer, "Sold" integer)
language plpgsql as
$$
begin
	return query
	select * from View_Schedule;
end
$$;


-- c
create function public.q2c_GetMaxSeatsInCoolPlanes() returns table("Max got" integer)
language plpgsql as
$$
begin
	return query
	select distinct (select max(q8scalar_GetSeats(s.ID)) got)
	from (select * from Schedule where TicketsTotal <= 200) s
	where 90 < (select Rating from Companies where ID = s.Company);
end
$$;

create function public.q2c_GetDangerousPlanesInAction() returns table("Plane ID" integer, "Model" text, "Last Maintenance" timestamp, "Last among all" timestamp)
language plpgsql as
$$
begin
	return query
	select p.ID, p.Model, p.LastMaintenance, (select min(LastMaintenance) from Planes where Active=true) Oldest from Planes p,
	lateral (select * from Schedule where Schedule.Plane = p.ID) as s
	where (now() - p.LastMaintenance > (select avg(now()-LastMaintenance) from Planes));
end
$$;


-- d
create function public.q2d_GetDestinationsOut(_City text) returns table("From" text, "To" text, "Tickets available" bigint)
language plpgsql as
$$
begin
	return query
	select afrom.City, ato.City, SUM(q8scalar_GetSeats(s.ID)) "Tickets available"
	from (select * from Schedule where Active = true and FlightDate > now()) s
	inner join Airports afrom on afrom.ID = s.Source
	inner join Airports ato on ato.ID = s.Destination
	group by afrom.City, ato.City
	having afrom.City=_City;
end
$$;

-- e
create function public.q2e_GetAirportsWithPlanes() returns table("Country" text, "City" text, "Name" text)
language plpgsql as
$$
begin
	return query
	select ap.Country, ap.City, ap.Name
	from Airports ap
	where ap.ID = any(select HomeAirport from Planes);
end
$$;

--8 scalar
create function public.q8scalar_GetSeats(_ID integer) returns integer
language plpgsql as
$$
begin
	return 
	(select s.TicketsTotal-s.TicketsSold
	from Schedule s where s.ID = _ID);
end
$$;

--8 table
create function public.q8_GetTicketStat(_ID integer) returns table(TicketsTotal bigint, TicketsSold bigint)
language plpgsql as
$$
begin
	return query
	select sum(Schedule.TicketsTotal), sum(Schedule.TicketsSold)
	from Schedule
	where Company = _ID and active = false and FlightDate < now();
end
$$;

--678 procedure
CREATE OR REPLACE PROCEDURE q6_UpdateRating()
LANGUAGE plpgsql AS
$$
DECLARE
	cur CURSOR FOR SELECT * FROM Companies;
	rec RECORD;
	tickets RECORD;
BEGIN
	FOR rec IN cur LOOP
	
		tickets = q8_GetTicketStat(rec.ID);
		
		if (tickets IS NOT NULL) then
			rec.Rating = rec.Rating + (select
			(case
			when ((tickets.TicketsSold::numeric / tickets.TicketsTotal * 100) >= 90)
				then
					1
			when ((tickets.TicketsSold::numeric / tickets.TicketsTotal * 100) >= 70)
				then
					0.5
			when ((tickets.TicketsSold::numeric / tickets.TicketsTotal * 100) >= 50)
				then
					- 0.5
			when ((tickets.TicketsSold::numeric / tickets.TicketsTotal * 100) >= 30)
				then
					- 1
			else
			 	- 2
			end));
			
			update Companies
			set Rating = rec.Rating
			where rec.ID = ID;
			
			if (rec.Rating > 100) then
				rollback;
			else
				commit;
			end if;
		end if;
		
	END LOOP;
END
$$;

-- trigger
create function public.PlaneTrigger() returns trigger
    language plpgsql as 
$$
begin
	if (TG_OP = 'INSERT') then
		NEW.LastMaintenance = now();
		NEW.Active = true;
		return NEW;
	end if;
	if (TG_OP = 'UPDATE') then
		if (NEW.Model != OLD.Model) then
			NEW.Model = OLD.Model;
		end if;
		if (NEW.LastMaintenance > now()) then
			NEW.LastMaintenance = OLD.LastMaintenance;
		end if;
		return NEW;
	end if;
	if (TG_OP = 'DELETE') then
		update Schedule 
		set Active = false 
		where Plane = OLD.ID;
		return OLD;
	end if;
end
$$;

create trigger TRIGGER_Planes before insert or update or delete on Planes for each row execute function public.PlaneTrigger();

-- roles
CREATE ROLE planemanager;
GRANT SELECT ON TABLE Schedule TO planemanager;
GRANT SELECT, INSERT ON TABLE Airports TO planemanager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Planes TO planemanager;
GRANT SELECT ON TABLE Companies TO planemanager;
GRANT USAGE ON SCHEMA public TO planemanager;

CREATE ROLE dispatcher;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Schedule TO dispatcher;
GRANT SELECT, INSERT, UPDATE ON TABLE Airports TO dispatcher;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Planes TO dispatcher;
GRANT SELECT, INSERT, UPDATE ON TABLE Companies TO dispatcher;
GRANT USAGE ON SCHEMA public TO dispatcher;

CREATE USER mapilot WITH
	IN ROLE planemanager
	PASSWORD 'boingisdabest1';
	
CREATE USER dispatcher1 WITH
	IN ROLE dispatcher
	ENCRYPTED PASSWORD 'anotherCoffee';
	
CREATE USER dispatcher2 WITH
	IN ROLE dispatcher
	ENCRYPTED PASSWORD 'anotherTea';
