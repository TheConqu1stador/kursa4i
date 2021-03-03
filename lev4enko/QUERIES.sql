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

CREATE FUNCTION public.calculate_discount(_base_cost integer, _discount integer) RETURNS FLOAT
    LANGUAGE plpgsql
    AS $$
begin
	return _base_cost * ((100.0 - _discount) / 100.0);
end
$$;

--2b
CREATE VIEW public.request_2b_by_name AS
	SELECT Companies.C_Name, COUNT(Schedule.S_Company) FROM Schedule
		INNER JOIN Companies ON Schedule.S_Company = Companies.C_ID
	GROUP BY Companies.C_Name
	ORDER BY Companies.C_Name;

CREATE VIEW public.request_2b_by_count AS
	SELECT Companies.C_Name, COUNT(Schedule.S_Company) as _count FROM Schedule
		INNER JOIN Companies ON Schedule.S_Company = Companies.C_ID
	GROUP BY Companies.C_Name
	ORDER BY _count DESC;

---- 2с ----
-- 2с1

-- 2с2

-- 2с3
CREATE OR REPLACE FUNCTION public.request_2c3() RETURNS TABLE(Model varchar(30), Seats INT, "Min Seats" INT, "Avg Seats" INT, "Max Seats" INT)
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
CREATE OR REPLACE FUNCTION public.request_2d(_Amount INT) RETURNS TABLE(Country varchar(40), Airport varchar(60), Amount bigint)
    LANGUAGE plpgsql
    AS $$
begin
	return query
		SELECT A_Country, A_Name, COUNT(P_ID)
		FROM Planes
			INNER JOIN public.Airports ON A_ID = P_HomeAirport
		GROUP BY A_Country, A_Name
		HAVING COUNT(P_ID) >= _Amount;
end
$$;

--2e
SELECT C_Name, C_Rating, C_Location
	FROM Companies 
	WHERE C_Rating >= ANY(SELECT AVG(C_Rating) FROM Companies GROUP BY C_Location)