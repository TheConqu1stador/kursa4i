--2a
CREATE OR REPLACE FUNCTION public.request_2a(_requested_id integer) RETURNS TABLE(_id integer, _fullName varchar(40), _discount integer, _finalCost integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select Tickets.T_ID, Buyers.B_FullName, Buyers.B_Discount,
	case
		WHEN Buyers.B_Discount = 0
			then Tickets.T_Cost
		else
			Tickets.T_Cost * ((100 - Buyers.B_Discount) / 100)
	end _cost
	from Tickets
		inner join Buyers
			on Tickets.T_Buyer = Buyers.B_ID
	where Tickets.T_ID = _requested_id;
end
$$;