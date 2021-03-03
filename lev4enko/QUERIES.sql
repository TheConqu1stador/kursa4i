--2a
CREATE FUNCTION public.request_2a(_requested_id integer) RETURNS TABLE(_id integer, _fullName varchar(40), _discount integer, _final_Cost float)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select Tickets.T_ID, Buyers.B_FullName, Buyers.B_Discount,
	case
		WHEN Buyers.B_Discount = 0
			then Tickets.T_Cost
		else
			calculate_discount(Tickets.T_Cost, Buyers.B_Discount)
	end _cost
	from Tickets
		inner join Buyers
			on Tickets.T_Buyer = Buyers.B_ID
	where Tickets.T_ID = _requested_id;
end
$$;

CREATE FUNCTION public.calculate_discount(_base_cost float, _discount integer) RETURNS FLOAT
    LANGUAGE plpgsql
    AS $$
begin
	return _base_cost * ((100.0 - _discount) / 100.0);
end
$$;

--2b
CREATE FUNCTION public.request_2b_by_name() RETURNS TABLE(_name varchar(40), _count bigint)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from request_2b_by_name_view;
end
$$;

CREATE FUNCTION public.request_2b_by_count() RETURNS TABLE(_name varchar(40), _count bigint)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select * from request_2b_by_count_view;
end
$$;

CREATE VIEW public.request_2b_by_name_view AS
	SELECT Companies.C_Name, COUNT(Schedule.S_Company) FROM Schedule
		INNER JOIN Companies ON Schedule.S_Company = Companies.C_ID
	GROUP BY Companies.C_Name
	ORDER BY Companies.C_Name;

CREATE VIEW public.request_2b_by_count_view AS
	SELECT Companies.C_Name, COUNT(Schedule.S_Company) as _count FROM Schedule
		INNER JOIN Companies ON Schedule.S_Company = Companies.C_ID
	GROUP BY Companies.C_Name
	ORDER BY _count DESC;

---- 2с ----
-- 2с1
CREATE OR REPLACE FUNCTION public.request_2c1() RETURNS TABLE(_company varchar(40), _from VARCHAR(40), _to VARCHAR(40), "Avg Price" INT)
    LANGUAGE plpgsql
    AS $$
begin
	return query
		SELECT 
			C_Name,
			aFrom._Country,
			aTo._Country,
			(SELECT AVG(T_Cost) FROM Tickets WHERE T_Flight = S_ID)::INT
		FROM
			Schedule
				INNER JOIN (SELECT * FROM Companies WHERE C_Name = 'American Airlines') s ON C_ID = S_Company
				INNER JOIN (SELECT * FROM airports_select()) aFrom ON aFrom._ID = S_From
				INNER JOIN (SELECT * FROM airports_select()) aTo ON aTo._ID = S_To;
end;
$$;

-- 2с2
CREATE OR REPLACE FUNCTION public.request_2c2() RETURNS TABLE(_name varchar(40), _terminals integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
		select _airports.A_Name, _airports.A_Terminals FROM Planes,
			LATERAL (SELECT A_Name, A_Terminals FROM Airports WHERE A_ID = Planes.P_HomeAirport) as _airports
			WHERE _airports.A_Terminals > (SELECT AVG(A_Terminals) FROM Airports)
			GROUP BY _airports.A_Name, _airports.A_Terminals;
end
$$;

-- 2с3
CREATE OR REPLACE FUNCTION public.request_2c3() RETURNS TABLE(_model varchar(40), _seats INT, "Min Seats" INT, "Avg Seats" INT, "Max Seats" INT)
    LANGUAGE plpgsql
    AS $$
begin
	return query
		SELECT P_Model, P_Seats,
			(SELECT MIN(P_Seats) FROM Planes) minseats,
			(SELECT AVG(P_Seats) FROM Planes)::INT avgseats,
			(SELECT MAX(P_Seats) FROM Planes) maxseats
		FROM
			Planes
		WHERE
			EXISTS(SELECT 1 FROM Schedule WHERE S_Plane = P_ID);
end
$$;

--2d
CREATE OR REPLACE FUNCTION public.request_2d(_request_amount INT) RETURNS TABLE(_country varchar(40), _airport varchar(40), _amount bigint)
    LANGUAGE plpgsql
    AS $$
begin
	return query
		SELECT A_Country, A_Name, COUNT(P_ID)
		FROM Planes
			INNER JOIN public.Airports ON A_ID = P_HomeAirport
		GROUP BY A_Country, A_Name
		HAVING COUNT(P_ID) >= _amount;
end
$$;

--2e
CREATE OR REPLACE FUNCTION public.request_2e() RETURNS TABLE(_name varchar(40), _rating integer, _location varchar(40))
    LANGUAGE plpgsql
    AS $$
begin
	return query
		SELECT C_Name, C_Rating, C_Location
		FROM Companies 
		WHERE C_Rating >= ANY(SELECT AVG(C_Rating) FROM Companies GROUP BY C_Location);
end
$$;
