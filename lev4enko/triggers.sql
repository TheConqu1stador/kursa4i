
CREATE FUNCTION public.schedule_data_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF (NEW.S_DateTime < clock_timestamp()) THEN
			ROLLBACK;
		END IF;
		RETURN NEW;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF (NEW.S_DateTime < OLD.S_DateTime) THEN
			NEW.S_DateTime = OLD.S_DateTime;
		END IF;
		RETURN NEW;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		OLD.S_Active = false;
		RETURN OLD;
	END IF;
	
END;
$$;

CREATE TRIGGER schedule_trigger AFTER INSERT OR UPDATE ON public.Schedule EXECUTE FUNCTION public.schedule_data_check();
CREATE TRIGGER schedule_trigger_2 BEFORE DELETE ON public.Schedule EXECUTE FUNCTION public.schedule_data_check();