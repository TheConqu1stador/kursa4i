--2a
CREATE OR REPLACE FUNCTION public.request_2a(_requested_id integer) RETURNS TABLE(_id integer, _fullName varchar(40), _discount integer, _final_Cost float)
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

CREATE OR REPLACE FUNCTION public.calculate_discount(_base_cost integer, _discount integer) RETURNS FLOAT
    LANGUAGE plpgsql
    AS $$
begin
	return _base_cost * ((100.0 - _discount) / 100.0);
end
$$;