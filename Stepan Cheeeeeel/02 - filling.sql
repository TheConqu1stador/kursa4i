insert into Species (species, subspecies, marketSeedsCost, marketResultCost, weightFromSeed, timeToGrow) values
	('Tomato', 'Cherry', 0.02, 0.12, 40, '180 days'),
	('Tomato', 'Grape', 0.07, 0.76, 40, '220 days'),
	('Tomato', 'Green', 0.05, 0.43, 45, '210 days'),
	('Artichoke', 'Globe', 0.24, 1.35, 15, '120 days'),
	('Garlic', 'Hardneck', 0.03, 0.35, 1, '50 days'), 
	('Garlic', 'Softneck', 0.04, 0.45, 1, '55 days'),
	('Potato', 'Andean', 0.02, 0.34, 15, '90 days'),
	('Potato', 'Chilean', 0.02, 0.32, 16, '90 days'),
	('Pea', 'Snow', 0.34, 1.92, 3, '210 days'),
	('Pea', 'Sugar snap', 0.42, 2.16, 3, '210 days'),
	('Salad', 'Green', 0.44, 1.31, 4, '70 days');
	
insert into Facility (facilityName, established, staffSize) values
	('Main', '2018-04-11', 13),
	('Tomato node', '2019-09-12', 7),
	('Potato node', '2020-03-27', 14),
	('Pea node', '2021-02-03', 4);
	
insert into SeedsStorage (FacilityID, SpeciesID, amount, expirationDate) values
	(1, 3, 40, '2022-03-01'),
	(1, 4, 90, '2021-09-01'),
	(1, 5, 240, '2021-08-01'),
	(1, 6, 300, '2021-10-01'),
	(1, 11, 120, '2023-05-01'),
	(2, 1, 400, '2023-01-01'),
	(2, 2, 500, '2022-07-01'),
	(2, 3, 440, '2022-08-01'),
	(3, 7, 800, '2022-09-01'),
	(3, 8, 500, '2022-05-01'),
	(4, 9, 600, '2025-04-01'),
	(4, 10, 800, '2025-04-01');
	
insert into Bed (FacilityID, SpeciesID, soilQuality, bedSize, localBedNumber, plantedSince) values
	(1, 3, 'Decent', 16, 1, '2020-12-21'),
	(1, null, 'Bad', 30, 2, null),
	(1, null, 'Decent', 30, 3, null),
	(1, 4, 'Good', 40, 4, '2020-08-01'),
	(1, 5, 'Good', 120, 5, '2020-09-01'),
	(2, 1, 'Good', 100, 1, '2021-01-01'),
	(2, 2, 'Good', 100, 2, '2021-01-01'),
	(2, 2, 'Good', 100, 3, '2021-01-01'),
	(2, 3, 'Decent', 100, 4, '2021-01-01'),
	(3, 7, 'Dry', 200, 1, '2020-12-25'),
	(3, 8, 'Dry', 200, 2, '2020-12-25'),
	(4, 9, 'Good', 15, 1, '2021-01-03'),
	(4, 10, 'Good', 15, 2, '2021-01-03');
	
insert into GrownVegetablesStorage (FacilityID, SpeciesID, weight, expirationDate) values
	(1, 11, 40, '2021-09-01'),
	(1, 4, 70, '2022-04-20'),
	(2, 1, 300, '2021-05-28'),
	(2, 2, 300, '2021-05-28'),
	(2, 2, 100, '2021-12-01'),
	(2, 3, 200, '2021-05-28'),
	(3, 7, 600, '2021-11-15'),
	(3, 8, 550, '2021-11-15'),
	(4, 9, 60, '2022-01-01'),
	(4, 10, 60, '2022-01-01');
	
insert into SeedsToSell (StorageID, amount, minCost, deadline) values
	(4, 100, 11, '2021-03-21'),
	(4, 100, 11, '2021-03-21'),
	(4, 100, 11, '2021-03-21'),
	(1, 40, 1.20, '2021-04-01'),
	(8, 100, 5.80, '2022-01-01'),
	(8, 100, 5.80, '2022-01-01'),
	(8, 100, 5.80, '2022-01-01'),
	(9, 100, 4.40, '2022-01-01');
	
insert into SeedsToBuy (SpeciesID, amount, maxCost, FacilityID, deadline) values
	(11, 200, 100, 1, '2021-07-01'),
	(5, 100, 3.20, 1, '2021-06-01'),
	(9, 400, 150, 4, '2021-04-01'),
	(10, 400, 180, 4, '2021-04-01');
	
insert into SeedBuyer (orgName, country, rating, contactPhone) values
	('Friendly Farm', 'United Kingdom', 8.9, '+443043894893'),
	('Happy Cucumber', 'Spain', 9.4, '+348924739182'),
	('Lawn La Marselle', 'France', 8.7, '+338941224742');
	
insert into SeedSupplier (orgName, country, rating, contactPhone) values
	('GT GeneLabs', 'USA', 6.4, '+18439229302'),
	('Canadian Seed', 'Canada', 8.9, '+18438831943'),
	('Ogaio State University', 'USA', 7.9, '+17743290493');
	
insert into VegetableBuyer (orgName, country, rating, contactPhone) values
	('BILLA', 'Austria', 9.3, '+438920030500'),
	('Swiss Food Guard', 'Switzerland', 9.8, '+418392212121'),
	('Austrafood', 'Australia', 8.7, '+618430291828');
	
insert into SeedsSellOffer (OrderID, cost, BuyerID, offerStatus) values
	(1, 13, 1, null),
	(1, 12, 2, null),
	(3, 12, 3, null),
	(2, 12, 3, null),
	(null, 9, 2, 'accepted'),
	(1, 12, 3, null),
	(4, 1.20, 2, null),
	(6, 5.80, 1, 'declined'),
	(7, 5.80, 1, 'declined');
	
insert into SeedsBuyOffer (OrderID, cost, SupplierID, offerStatus) values
	(1, 100, 1, 'declined'),
	(1, 95, 2, null),
	(1, 97, 3, null),
	(2, 3, 1, null),
	(null, 190, 1, 'declined'),
	(null, 110, 1, 'accepted'),
	(2, 3.05, 2, null),
	(2, 3.05, 3, null),
	(3, 149.99, 1, 'declined'),
	(null, 90, 3, 'accepted'),
	(3, 120, 2, null),
	(3, 115, 3, null),
	(null, 140, 2, 'accepted'),
	(4, 120, 1, null),
	(4, 160, 2, null);
	
insert into VegetableSellOffer (StorageID, cost, weight, BuyerID, offerStatus) values
	(1, 50.82, 40, 3, null),
	(3, 40, 300, 3, null),
	(6, 80, 200, 3, null),
	(10, 121.43, 60, 1, null),
	(10, 110, 60, 3, 'declined'),
	(2, 200, 150, 1, 'accepted'),
	(2, 200, 155, 2, 'accepted');