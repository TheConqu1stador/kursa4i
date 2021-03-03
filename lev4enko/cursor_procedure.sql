CREATE OR REPLACE PROCEDURE public.RefreshSchedule()
	LANGUAGE plpgsql
	AS $$
DECLARE _id INT;
		_date TIMESTAMP;
		_active BOOLEAN;
		cur CURSOR FOR SELECT S_ID, S_DateTime, S_Active FROM public.Schedule WHERE S_Active = true;
		x Schedule%rowtype;
BEGIN
	FOR x IN cur loop
		IF (x.S_DateTime < clock_timestamp()) THEN
			UPDATE public.Schedule SET s_active = false WHERE s_id = x.S_ID;
		END IF;
	END loop;
END
$$;