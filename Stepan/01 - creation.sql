-- data bank table
create table Species (
	ID int generated by default as identity primary key,
	species varchar(25),
	subspecies varchar(25),
	marketSeedsCost float,
	marketResultCost float,
	timeToGrow interval,
	weightFromSeed float
);

-- structure main table
create table Facility (
	ID int generated by default as identity primary key,
	facilityName varchar(30),
	established timestamp,
	staffSize int
);

-- structure table, production flow start
create table SeedsStorage (
	ID int generated by default as identity primary key,
	FacilityID int,
	SpeciesID int,
	amount int,
	expirationDate timestamp,
	constraint FK_FacilitySubTable1 foreign key(FacilityID) references Facility(ID),
	constraint FK_SpeciesDataLink1 foreign key(SpeciesID) references Species(ID)
);

-- structure table, production flow stage
create table Bed (
	ID int generated by default as identity primary key,
	FacilityID int,
	SpeciesID int,
	soilQuality varchar(10),
	bedSize float,
	localBedNumber int,
	plantedSince timestamp,
	constraint FK_FacilitySubTable2 foreign key(FacilityID) references Facility(ID),
	constraint FK_SpeciesDataLink2 foreign key(SpeciesID) references Species(ID)
);

-- outer structure table, production flow end
create table GrownVegetablesStorage (
	ID int generated by default as identity primary key,
	FacilityID int,
	SpeciesID int,
	weight int,
	expirationDate timestamp,
	constraint FK_FacilitySubTable3 foreign key(FacilityID) references Facility(ID),
	constraint FK_SpeciesDataLink3 foreign key(SpeciesID) references Species(ID)
);

-- outer structure table, production branched flow end
create table SeedsToSell (
	ID int generated by default as identity primary key,
	StorageID int,
	amount int,
	minCost int,
	deadline timestamp,
	constraint FK_SeedsTradeLink foreign key(StorageID) references SeedsStorage(ID) on delete cascade
);

-- outer structure table, production support branch
create table SeedsToBuy (
	ID int generated by default as identity primary key,
	SpeciesID int,
	amount int,
	maxCost int,
	FacilityID int,
	deadline timestamp,
	constraint FK_SpeciesDataLink4 foreign key(SpeciesID) references Species(ID),
	constraint FK_FacilityTradeLink foreign key(FacilityID) references Facility(ID)
);

-- third-parties data table
create table SeedBuyer (
	ID int generated by default as identity primary key,
	orgName varchar(25),
	country varchar(25),
	rating int,
	contactPhone varchar(15)
);

-- third-parties data table
create table SeedSupplier (
	ID int generated by default as identity primary key,
	orgName varchar(25),
	country varchar(25),
	rating int,
	contactPhone varchar(15)
);

-- third-parties data table
create table VegetableBuyer (
	ID int generated by default as identity primary key,
	orgName varchar(25),
	country varchar(25),
	rating int,
	contactPhone varchar(15)
);

-- structure communication table
create table SeedsSellOffer (
	ID int generated by default as identity primary key,
	OrderID int,
	cost int,
	BuyerID int,
	offerStatus varchar(10),
	constraint FK_OuterStructureEntry_SeedsToSell foreign key(OrderID) references SeedsToSell(ID) on delete set null,
	constraint FK_ThirdPartyLink_SeedBuyer foreign key(BuyerID) references SeedBuyer(ID) on delete cascade
);

-- structure communication table
create table SeedsBuyOffer (
	ID int generated by default as identity primary key,
	OrderID int,
	cost int,
	SupplierID int,
	offerStatus varchar(10),
	constraint FK_OuterStructureEntry_SeedsToBuy foreign key(OrderID) references SeedsToBuy(ID) on delete set null,
	constraint FK_ThirdPartyLink_SeedSupplier foreign key(SupplierID) references SeedSupplier(ID) on delete cascade
);

-- structure communication table
create table VegetableSellOffer (
	ID int generated by default as identity primary key,
	StorageID int,
	cost int,
	weight int,
	BuyerID int,
	offerStatus varchar(10),
	constraint FK_OuterStructureEntry_GrownVegetablesStorage foreign key(StorageID) references GrownVegetablesStorage(ID) on delete set null,
	constraint FK_ThirdPartyLink_VegetableBuyer foreign key(BuyerID) references VegetableBuyer(ID) on delete cascade
);