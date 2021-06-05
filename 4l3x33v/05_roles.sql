CREATE ROLE hr_worker;
GRANT USAGE ON SCHEMA public TO hr_worker;
GRANT SELECT,INSERT ON TABLE public.Profession TO hr_worker;
GRANT SELECT ON TABLE public.Department TO hr_worker;
GRANT SELECT,INSERT,UPDATE ON TABLE public.Contract TO hr_worker;
GRANT SELECT,INSERT,UPDATE ON TABLE public.Employee TO hr_worker;
GRANT SELECT ON TABLE public.Office TO hr_worker;

CREATE USER olga WITH
	IN ROLE hr_worker
	ENCRYPTED PASSWORD 'jHFE*jA(EF3ehsi39JF83';
CREATE USER michael WITH
	IN ROLE manager
	ENCRYPTED PASSWORD 'password';

CREATE ROLE director;
GRANT USAGE ON SCHEMA public TO director;
GRANT SELECT,INSERT,UPDATE ON TABLE public.Profession TO director;
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE public.Department TO director;
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE public.Contract TO director;
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE public.Employee TO director;
GRANT SELECT,INSERT,UPDATE ON TABLE public.Office TO director;

CREATE USER dir WITH
	IN ROLE director
	ENCRYPTED PASSWORD 'amAdmin!';
