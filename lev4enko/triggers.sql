CREATE OR REPLACE FUNCTION public.schedule_data_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF (NEW.S_DateTime < clock_timestamp()) THEN
			RETURN NULL;
		ELSE
			RETURN NEW;
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF (NEW.S_DateTime < OLD.S_DateTime) THEN
			NEW.S_DateTime = OLD.S_DateTime;
		END IF;
		RETURN NEW;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		UPDATE public.Schedule SET S_Active = false WHERE S_ID = OLD.S_ID;
		RETURN NULL;
	END IF;
END;
$$;

CREATE TRIGGER schedule_trigger BEFORE INSERT OR UPDATE OR DELETE ON public.Schedule FOR EACH ROW EXECUTE FUNCTION public.schedule_data_check();