CREATE ROLE manager;
GRANT USAGE ON SCHEMA public TO manager;
CREATE USER george WITH
	IN ROLE manager
	ENCRYPTED PASSWORD 'floyd';
	
CREATE ROLE ticketseller;
GRANT USAGE ON SCHEMA public TO ticketseller;
CREATE USER cassa1 WITH
	IN ROLE ticketseller
	ENCRYPTED PASSWORD 'cassacassacassa';
CREATE USER cassa2 WITH
	IN ROLE receptionist
	ENCRYPTED PASSWORD 'cassacassa?';