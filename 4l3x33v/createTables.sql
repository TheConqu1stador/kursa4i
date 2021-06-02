--CREATE

--Создание таблицы должностей
CREATE TABLE IF NOT EXISTS public.Profession (
	ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	Name TEXT,
	ContractsMade INT
		DEFAULT 0,
	ContractsBroke INT
		DEFAULT 0
);

--Вешаем кластеризованный индекс на поле с названием профессии
CREATE INDEX IX_Profession_Name ON Profession(Name);
ALTER TABLE Profession CLUSTER ON IX_Profession_Name;
CLUSTER Profession;


--Создание таблицы договоров
CREATE TABLE IF NOT EXISTS public.Contract (
	ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	Salary INT
		DEFAULT 0,
	SpecialTerms TEXT,
	HoursPerWeek INT
		DEFAULT 0,
	ProfessionID INT,
	inStaff BOOLEAN
		DEFAULT FALSE,
	CONSTRAINT FK_Contract_Profession_ID
		FOREIGN KEY(ProfessionID)
			REFERENCES public.Profession(ID)
			ON DELETE SET NULL
);

--Вешаем кластеризованный индекс на поле со специальными условиями
CREATE INDEX IX_Contract_SpecialTerms ON Contract(SpecialTerms);
ALTER TABLE Contract CLUSTER ON IX_Contract_SpecialTerms;
CLUSTER Contract;

--Создание таблицы офисов
CREATE TABLE IF NOT EXISTS public.Office (
	ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	Name TEXT,
	Address TEXT,
	Floors INT
		DEFAULT 1
);

--Вешаем кластеризованный индекс на поле с ID
CREATE INDEX IX_Office_ID ON Office(ID);
ALTER TABLE Office CLUSTER ON IX_Office_ID;
CLUSTER Office;

--Вешаем некластеризованный индекс на поле с адресом
CREATE INDEX IX_Office_Address ON Office(Address);

--Создание таблицы отделов
CREATE TABLE IF NOT EXISTS public.Department (
	ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	Name TEXT,
	ParentDepartment INT
		DEFAULT 0,
	MainOfficeID INT
		DEFAULT 0,
	CONSTRAINT FK_Department_Office_ID
		FOREIGN KEY(MainOfficeID)
			REFERENCES public.Office(ID)
			ON DELETE SET NULL,
	CONSTRAINT FK_Department_Department_ParentDepartment
		FOREIGN KEY(ParentDepartment)
			REFERENCES public.Department(ID)
			ON DELETE SET NULL
);

--Вешаем кластеризованный индекс на поле с ID
CREATE INDEX IX_Department_ID ON Department(ID);
ALTER TABLE Department CLUSTER ON IX_Department_ID;
CLUSTER Department;

--Создание таблицы работников
CREATE TABLE IF NOT EXISTS public.Employee (
	ID INT 
		GENERATED ALWAYS AS IDENTITY
		NOT NULL
		UNIQUE
		PRIMARY KEY,
	ContractID INT,
	Name TEXT,
	DepartmentID INT,
	Age INT
		DEFAULT 1,
	CONSTRAINT FK_Employee_Office_ID
		FOREIGN KEY(ContractID)
			REFERENCES public.Contract(ID)
			ON DELETE SET NULL,
	CONSTRAINT FK_Employee_Department_ID
		FOREIGN KEY(DepartmentID)
			REFERENCES public.Department(ID)
			ON DELETE SET NULL
);

--Вешаем кластеризованный индекс на поле с ID
CREATE INDEX IX_Employee_ID ON Employee(ID);
ALTER TABLE Employee CLUSTER ON IX_Employee_ID;
CLUSTER Employee;


