CREATE ROLE manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.airports TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.buyers TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.companies TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.planes TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.schedule TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.tickets TO manager;
GRANT USAGE ON SCHEMA public TO manager;
CREATE USER george WITH
	IN ROLE manager
	ENCRYPTED PASSWORD 'floyd';
	
CREATE ROLE ticketseller;
GRANT SELECT ON TABLE public.airports TO ticketseller;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.buyers TO ticketseller;
GRANT SELECT ON TABLE public.companies TO ticketseller;
GRANT SELECT ON TABLE public.planes TO ticketseller;
GRANT SELECT, INSERT, UPDATE ON TABLE public.schedule TO ticketseller;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.tickets TO ticketseller;
GRANT USAGE ON SCHEMA public TO ticketseller;
CREATE USER cassa1 WITH
	IN ROLE ticketseller
	ENCRYPTED PASSWORD 'cassacassacassa';
CREATE USER cassa2 WITH
	IN ROLE receptionist
	ENCRYPTED PASSWORD 'cassacassa?';