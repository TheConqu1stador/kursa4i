-- t*
CREATE TABLE Access_Levels (
	ID INTEGER
		GENERATED ALWAYS AS IDENTITY
		UNIQUE
		PRIMARY KEY,
	Name VARCHAR(64)
);

-- t4
CREATE TABLE Employee (
	ID INTEGER
		GENERATED ALWAYS AS IDENTITY
		UNIQUE
		PRIMARY KEY,
	Name VARCHAR(64)
		NOT NULL,
	Access_Level INTEGER
		NOT NULL,
	CONSTRAINT FK_EmployeeAccessLevel FOREIGN KEY(Access_Level) REFERENCES Access_Levels(ID),
	Salary MONEY,
	Post VARCHAR(64)
);

CREATE INDEX INDEX_Employee1 ON Employee(ID);
CREATE INDEX INDEX_Employee2 ON Employee(Name);
CREATE INDEX INDEX_Employee3 ON Employee(Post);

-- t1
CREATE TABLE Project (
	ID INTEGER
		GENERATED ALWAYS AS IDENTITY
		UNIQUE
		PRIMARY KEY,
	Name VARCHAR(64)
		UNIQUE
		NOT NULL,
	Manager_ID INTEGER,
	CONSTRAINT FK_ProjectManager FOREIGN KEY(Manager_ID) REFERENCES Employee(ID)
		ON DELETE SET NULL,
	Orderer VARCHAR(64),
	Start_Time TIMESTAMP
);

CREATE INDEX INDEX_Project1 ON Project(ID);
CREATE INDEX INDEX_Project2 ON Project(Name);
CREATE INDEX INDEX_Project3 ON Project(Orderer);

-- t*
CREATE TABLE Working_Day (
	ID INTEGER
		GENERATED ALWAYS AS IDENTITY
		UNIQUE
		PRIMARY KEY,
	Employee_ID INTEGER
		NOT NULL,
	CONSTRAINT FK_WorkingDayEmployee FOREIGN KEY(Employee_ID) REFERENCES Employee(ID) ON DELETE CASCADE,
	Start_Time TIMESTAMP,
	End_Time TIMESTAMP,
	Breaks_Time INTERVAL
);

CREATE INDEX INDEX_Working_Day1 ON Working_Day(ID);
CREATE INDEX INDEX_Working_Day2 ON Working_Day(Employee_ID);

-- t2
CREATE TABLE Status (
	ID INTEGER
		GENERATED ALWAYS AS IDENTITY
		UNIQUE
		PRIMARY KEY,
	Description VARCHAR(64),
	Is_Archive BOOLEAN,
	Access_Level INTEGER,
	CONSTRAINT FK_StatusAccessLevel FOREIGN KEY(Access_Level) REFERENCES Access_Levels(ID),
	Start_Time TIMESTAMP,
	Update_Time TIMESTAMP
);


-- t3
CREATE TABLE Task (
	ID INTEGER
		GENERATED ALWAYS AS IDENTITY
		UNIQUE
		PRIMARY KEY,
	Status_ID INTEGER,
	CONSTRAINT FK_TaskStatus FOREIGN KEY(Status_ID) REFERENCES Status(ID),
	Executor_ID INTEGER,
	CONSTRAINT FK_TaskExecutor FOREIGN KEY(Executor_ID) REFERENCES Employee(ID) ON DELETE SET NULL,
	Name VARCHAR(64),
	Project_ID INTEGER,
	CONSTRAINT FK_TaskProject FOREIGN KEY(Project_ID) REFERENCES Project(ID) ON DELETE SET NULL,
	Description VARCHAR(128),
	Time_Spent INTERVAL
);

CREATE INDEX INDEX_Task1 ON Task(ID);
CREATE INDEX INDEX_Task2 ON Task(Status_ID);
CREATE INDEX INDEX_Task3 ON Task(Executor_ID);
CREATE INDEX INDEX_Task4 ON Task(Name);
CREATE INDEX INDEX_Task5 ON Task(Project_ID);

-- crud
CREATE PROCEDURE Access_Levels_insert(_Name VARCHAR)
LANGUAGE plpgsql AS
$$
BEGIN
	INSERT INTO Access_Levels(Name)
	VALUES (_Name);
END
$$;
CREATE PROCEDURE Access_Levels_update(_ID INTEGER, _Name VARCHAR)
LANGUAGE plpgsql AS
$$
BEGIN
	UPDATE Access_Levels SET
	Name = _Name
	WHERE ID = _ID;
END
$$;
CREATE PROCEDURE Access_Levels_delete(_ID INTEGER)
LANGUAGE plpgsql AS
$$
BEGIN
	DELETE 
	FROM Access_Levels 
	WHERE ID = _ID;
END
$$;


CREATE PROCEDURE Employee_insert(_Name VARCHAR, _Access_Level INTEGER, _Salary MONEY, _Post VARCHAR)
LANGUAGE plpgsql AS
$$
BEGIN
	INSERT INTO Employee(Name, Access_Level, Salary, Post)
	VALUES (_Name, _Access_Level, _Salary, _Post);
END
$$;
CREATE PROCEDURE Employee_update(_ID INTEGER, _Name VARCHAR, _Access_Level INTEGER, _Salary MONEY, _Post VARCHAR)
LANGUAGE plpgsql AS
$$
BEGIN
	UPDATE Employee SET
	Name = _Name, Access_Level = _Access_Level, Salary = _Salary, Post = _Post
	WHERE ID = _ID;
END
$$;
CREATE PROCEDURE Employee_delete(_ID INTEGER)
LANGUAGE plpgsql AS
$$
BEGIN
	DELETE 
	FROM Employee
	WHERE ID = _ID;
END
$$;


CREATE PROCEDURE Project_insert(_Name VARCHAR, _Manager_ID INTEGER, _Orderer VARCHAR, _Start_Time TIMESTAMP)
LANGUAGE plpgsql AS
$$
BEGIN
	INSERT INTO Project(Name, Manager_ID, Orderer, Start_Time)
	VALUES (_Name, _Manager_ID, _Orderer, _Start_Time);
END
$$;
CREATE PROCEDURE Project_update(_ID INTEGER, _Name VARCHAR, _Manager_ID INTEGER, _Orderer VARCHAR, _Start_Time TIMESTAMP)
LANGUAGE plpgsql AS
$$
BEGIN
	UPDATE Project SET
	Name = _Name, Manager_ID = _Manager_ID, Orderer = _Orderer, Start_Time = _Start_Time
	WHERE ID = _ID;
END
$$;
CREATE PROCEDURE Project_delete(_ID INTEGER)
LANGUAGE plpgsql AS
$$
BEGIN
	DELETE 
	FROM Project
	WHERE ID = _ID;
END
$$;


CREATE PROCEDURE Working_Day_insert(_Employee_ID INTEGER, _Start_Time TIMESTAMP, _End_Time TIMESTAMP, _Breaks_Time INTERVAL)
LANGUAGE plpgsql AS
$$
BEGIN
	INSERT INTO Working_Day(Employee_ID, Start_Time, End_Time, Breaks_Time)
	VALUES (_Employee_ID, _Start_Time, _End_Time, _Breaks_Time);
END
$$;
CREATE PROCEDURE Working_Day_update(_ID INTEGER, _Employee_ID INTEGER, _Start_Time TIMESTAMP, _End_Time TIMESTAMP, _Breaks_Time INTERVAL)
LANGUAGE plpgsql AS
$$
BEGIN
	UPDATE Working_Day SET
	Employee_ID = _Employee_ID, Start_Time = _Start_Time, End_Time = _End_Time, Breaks_Time = _Breaks_Time
	WHERE ID = _ID;
END
$$;
CREATE PROCEDURE Working_Day_delete(_ID INTEGER)
LANGUAGE plpgsql AS
$$
BEGIN
	DELETE
	FROM Working_Day
	WHERE ID = _ID;
END
$$;


CREATE PROCEDURE Status_insert(_Description VARCHAR, _Is_Archive BOOLEAN, _Access_Level INTEGER, _Start_Time TIMESTAMP, _Update_Time TIMESTAMP)
LANGUAGE plpgsql AS
$$
BEGIN
	INSERT INTO Status(Description, Is_Archive, Access_Level, Start_Time, Update_Time)
	VALUES (_Description, _Is_Archive, _Access_Level, _Start_Time, _Update_Time);
END
$$;
CREATE PROCEDURE Status_update(_ID INTEGER, _Description VARCHAR, _Is_Archive BOOLEAN, _Access_Level INTEGER, _Start_Time TIMESTAMP, _Update_Time TIMESTAMP)
LANGUAGE plpgsql AS
$$
BEGIN
	UPDATE Status SET
	Description = _Description, Is_Archive = _Is_Archive, Access_Level = _Access_Level, Start_Time = _Start_Time, Update_Time = _Update_Time
	WHERE ID = _ID;
END
$$;
CREATE PROCEDURE Status_delete(_ID INTEGER)
LANGUAGE plpgsql AS
$$
BEGIN
	DELETE
	FROM Status
	WHERE ID = _ID;
END
$$;


CREATE PROCEDURE Task_insert(_Status_ID INTEGER, _Executor_ID INTEGER, _Name VARCHAR, _Project_ID INTEGER, _Description VARCHAR, _Time_Spent INTERVAL)
LANGUAGE plpgsql AS
$$
BEGIN
	INSERT INTO Task(Status_ID, Executor_ID, Name, Project_ID, Description, Time_Spent)
	VALUES (_Status_ID, _Executor_ID, _Name, _Project_ID, _Description, _Time_Spent);
END
$$;
CREATE PROCEDURE Task_update(_ID INTEGER, _Status_ID INTEGER, _Executor_ID INTEGER, _Name VARCHAR, _Project_ID INTEGER, _Description VARCHAR, _Time_Spent INTERVAL)
LANGUAGE plpgsql AS
$$
BEGIN
	UPDATE Task SET
	Status_ID = _Status_ID, Executor_ID = _Executor_ID, Name = _Name, Project_ID = _Project_ID, Description = _Description, Time_Spent = _Time_Spent
	WHERE ID = _ID;
END
$$;
CREATE PROCEDURE Task_delete(_ID INTEGER)
LANGUAGE plpgsql AS
$$
BEGIN
	DELETE
	FROM Task
	WHERE ID = _ID;
END
$$;

-- roles
CREATE ROLE director;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Project TO director;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Status TO director;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Task TO director;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Employee TO director;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Working_day TO director;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Access_Levels TO director;
GRANT USAGE ON SCHEMA public TO director;
GRANT SELECT ON view_projects TO director;

CREATE ROLE manager;
GRANT SELECT ON TABLE Project TO manager;
GRANT SELECT, INSERT, UPDATE ON TABLE Status TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Task TO manager;
GRANT SELECT, INSERT, UPDATE ON TABLE Employee TO manager;
GRANT SELECT, INSERT, UPDATE ON TABLE Working_day TO manager;
GRANT SELECT ON TABLE Access_Levels TO manager;
GRANT USAGE ON SCHEMA public TO manager;
GRANT SELECT ON view_projects TO manager;

CREATE ROLE worker;
GRANT SELECT ON TABLE Project TO worker;
GRANT SELECT, INSERT, UPDATE ON TABLE Status TO worker;
GRANT SELECT ON TABLE Task TO worker;
GRANT SELECT ON TABLE Employee TO worker;
GRANT SELECT ON TABLE Working_day TO worker;
GRANT SELECT ON TABLE Access_Levels TO worker;
GRANT USAGE ON SCHEMA public TO worker;
GRANT SELECT ON view_projects TO worker;

CREATE USER diric WITH
	IN ROLE director
	PASSWORD 'strongpa$$';
	
CREATE USER manag WITH
	IN ROLE manager
	PASSWORD 'mediumpa$$';
	
CREATE USER workr WITH
	IN ROLE worker
	PASSWORD 'weakpa$$';