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
	

	
	