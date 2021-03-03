--CREATE
CREATE TABLE IF NOT EXISTS public.Airports (
	A_ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	A_Name VARCHAR(40),
	A_Country VARCHAR(40),
	A_City VARCHAR(40),
	A_Terminals INT
		DEFAULT 0
);

CREATE INDEX IX_Airports_A_ID ON Airports(A_ID);
ALTER TABLE Airports CLUSTER ON IX_Airports_A_ID;
CLUSTER Airports;

CREATE TABLE IF NOT EXISTS public.Planes (
	P_ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	P_HomeAirport INT
		DEFAULT 0,
	P_Model VARCHAR(40),
	P_Seats INT
		DEFAULT 0,
	CONSTRAINT FK_Planes_Airport_A_ID
		FOREIGN KEY(P_HomeAirport)
			REFERENCES public.Airports(A_ID)
			ON DELETE SET NULL
);

CREATE INDEX IX_Planes_P_HomeAirport ON Planes(P_HomeAirport);
ALTER TABLE Planes CLUSTER ON IX_Planes_P_HomeAirport;
CLUSTER Planes;

CREATE TABLE IF NOT EXISTS public.Companies (
	C_ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	C_Name VARCHAR(40),
	C_Rating INT
		DEFAULT 0,
	C_Director VARCHAR(40),
	C_Location VARCHAR(40)
);

CREATE INDEX IX_Companies_C_Name ON Companies(C_Name);
ALTER TABLE Companies CLUSTER ON IX_Companies_C_Name;
CLUSTER Companies;

CREATE INDEX IX_Companies_C_Rating ON Companies(C_Rating);

CREATE TABLE IF NOT EXISTS public.Schedule (
	S_ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	S_DateTime TIMESTAMP,
	S_Plane INT
		DEFAULT 0,
	S_Company INT
		DEFAULT 0		DEFAULT true;
	CONSTRAINT FK_Schedule_Planes_P_ID
		FOREIGN KEY(S_		DEFAULT true,
	CONSTRAINT FK_Schedule_Planes_P_ID
		FOREIGN KEY(S_Plane)
			REFERENCES public.Planes(P_ID)
			ON DELETE SET NULL,
	CONSTRAINT FK_Schedule_Companies_C_ID
		FOREIGN KEY(S_Company)
			REFERENCES public.Companies(C_ID)
			ON DELETE SET NULL,
	CONSTRAINT FK_Schedule_Airport_A_ID_From
		FOREIGN KEY(S_From)
			REFERENCES public.Airports(A_ID)
			ON DELETE SET NULL,
	CONSTRAINT FK_Schedule_Airport_A_ID_To
		FOREIGN KEY(S_To)
			REFERENCES public.Airports(A_ID)
			ON DELETE SET NULL
);

CREATE INDEX IX_Schedule_S_Plane ON Schedule(S_Plane);

CREATE INDEX IX_Schedule_S_Company ON Schedule(S_Company);

CREATE INDEX IX_Schedule_S_From ON Schedule(S_From);

CREATE INDEX IX_Schedule_S_To ON Schedule(S_To);

CREATE INDEX IX_Schedule_S_ID ON Schedule(S_ID);
ALTER TABLE Schedule CLUSTER ON IX_Schedule_S_ID;
CLUSTER Schedule;

CREATE TABLE IF NOT EXISTS public.Buyers (
	B_ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	B_FullName VARCHAR(40),
	B_Discount INT
		DEFAULT 0
);

CREATE INDEX IX_Buyers_B_FullName ON Buyers(B_FullName);
ALTER TABLE Buyers CLUSTER ON IX_Buyers_B_FullName;
CLUSTER Buyers;

CREATE TABLE IF NOT EXISTS public.Tickets (
	T_ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	T_Seat INT
		DEFAULT 0,
	T_Flight INT
		DEFAULT 0,
	T_Buyer INT
		DEFAULT 0,
	T_Cost FLOAT	

		DEFAULT 0,
	T_Buyer INT
		DEFAULT 0,
	T_Cost FLOAT	
		DEFAULT 0,
	CONSTRAINT FK_Tickets_Schedule_S_ID
		FOREIGN KEY(T_Flight)
			REFERENCES public.Schedule(S_ID)
			ON DELETE SET NULL,
	CONSTRAINT FK_Tickets_Buyers_B_ID
		FOREIGN KEY(T_Buyer)
			REFERENCES public.Buyers(B_ID)
			ON DELETE SET NULL
);

CREATE INDEX IX_Tickets_T_Flight ON Tickets(T_Flight);
ALTER TABLE Tickets CLUSTER ON IX_Tickets_T_Flight;
CLUSTER Tickets;

CREATE INDEX IX_Tickets_T_Buyer ON Tickets(T_Buyer);



