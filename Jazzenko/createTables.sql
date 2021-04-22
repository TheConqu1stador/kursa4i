--CREATE
CREATE TABLE IF NOT EXISTS public.Airports (
ID INT
GENERATED ALWAYS AS IDENTITY
NOT NULL
UNIQUE
PRIMARY KEY,
Name TEXT
DEFAULT 'New Airport',
Country TEXT
DEFAULT 'New Country',
City TEXT
DEFAULT 'New City',
Terminals INT
DEFAULT 0
);

CREATE INDEX Index_AirportID ON Airports(ID);
ALTER TABLE Airports CLUSTER ON Index_AirportID;
CLUSTER Airports;

CREATE TABLE IF NOT EXISTS public.Planes (
ID INT
GENERATED ALWAYS AS IDENTITY
NOT NULL
UNIQUE
PRIMARY KEY,
HomeAirport INT
DEFAULT 1,
Model TEXT
DEFAULT 'Default Model',
Seats INT
DEFAULT 0,
CONSTRAINT FK_PlaneAirport_ID
FOREIGN KEY(HomeAirport)
REFERENCES public.Airports(ID)
ON DELETE SET NULL
);

CREATE INDEX Index_PlaneHomeAirport ON Planes(HomeAirport);
ALTER TABLE Planes CLUSTER ON Index_PlaneHomeAirport;
CLUSTER Planes;

CREATE TABLE IF NOT EXISTS public.Companies (
ID INT
GENERATED ALWAYS AS IDENTITY
NOT NULL
UNIQUE
PRIMARY KEY,
Name TEXT
DEFAULT 'New Company',
Rating INT
DEFAULT 0,
Director TEXT
DEFAULT 'John Galt',
Location TEXT
DEFAULT 'Outer Space'
);

CREATE INDEX Index_CompanyName ON Companies(Name);
ALTER TABLE Companies CLUSTER ON Index_CompanyName;
CLUSTER Companies;

CREATE INDEX Index_CompanyRating ON Companies(Rating);

CREATE TABLE IF NOT EXISTS public.Schedule (
ID INT
GENERATED ALWAYS AS IDENTITY
NOT NULL
UNIQUE
PRIMARY KEY,
FlightDate TIMESTAMP
DEFAULT now() + interval '1d',
Plane INT
DEFAULT 1,
Company INT
DEFAULT 1,
Source INT
DEFAULT 1,
Destination INT
DEFAULT 1,
TicketsTotal INT
DEFAULT 100,
TicketsSold INT
DEFAULT 0,
Active BOOLEAN
DEFAULT true,
CONSTRAINT FK_Schedule_PlaneID
FOREIGN KEY(Plane)
REFERENCES public.Planes(ID)
ON DELETE SET NULL,
CONSTRAINT FK_Schedule_CompanyID
FOREIGN KEY(Company)
REFERENCES public.Companies(ID)
ON DELETE SET NULL,
CONSTRAINT FK_Schedule_Airport_ID_Source
FOREIGN KEY(Source)
REFERENCES public.Airports(ID)
ON DELETE SET NULL,
CONSTRAINT FK_Schedule_Airport_ID_Destination
FOREIGN KEY(Destination)
REFERENCES public.Airports(ID)
ON DELETE SET NULL
);

CREATE INDEX Index_Schedule_Plane ON Schedule(Plane);

CREATE INDEX Index_Schedule_Company ON Schedule(Company);

CREATE INDEX Index_Schedule_Source ON Schedule(Source);

CREATE INDEX Index_Schedule_Destination ON Schedule(Destination);

CREATE INDEX Index_Schedule_ID ON Schedule(ID);
ALTER TABLE Schedule CLUSTER ON Index_Schedule_ID;
CLUSTER Schedule;