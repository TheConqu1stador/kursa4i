-- view - show all pending market offers

create view V_ShowOffers as
	select 'may buy seeds' "What can I do?", stb.amount, s.species, s.subspecies, sbo.cost "Their price", stb.maxCost "Our price", s.marketSeedsCost * stb.amount "Market Price"
	from SeedsBuyOffer sbo 
		inner join SeedsToBuy stb on sbo.OrderID = stb.ID
		inner join Species s on stb.SpeciesID = s.ID
	where
		sbo.offerStatus is null
	union
	select 'may sell seeds', sts.amount, s.species, s.subspecies, sso.cost "Their price", sts.minCost "Out price", s.marketSeedsCost * sts.amount "Market Price"
	from SeedsSellOffer sso
		inner join SeedsToSell sts on sso.OrderID = sts.ID
		inner join SeedsStorage ss on sts.StorageID = ss.ID
		inner join Species s on ss.SpeciesID = s.ID
	where
		sso.offerStatus is null
	union
	select 'may sell vegetables', vso.weight, s.species, s.subspecies, vso.cost "Their price", null "Our price", s.marketResultCost * vso.weight "Market Price"
	from VegetableSellOffer vso
		inner join GrownVegetablesStorage gvs on vso.StorageID = gvs.ID
		inner join Species s on gvs.SpeciesID = s.ID
	where
		vso.offerStatus is null;
		
-- procedure - agree on some offer, reject others, close issue

create or replace procedure BuySeedsAccept(offerID integer)
	language plpgsql as 
$$	
declare
	_orderID int;
	seedsGot int;
	seedsSpecies int;
	seedsTo int;
begin
	_orderID = (select OrderID from SeedsBuyOffer where ID = offerID);
	update SeedsBuyOffer set offerStatus = 'declined' where OrderID = _orderID;
	update SeedsBuyOffer set offerStatus = 'accepted' where ID = offerID;
	
	seedsGot = (select amount from SeedsToBuy where ID = _orderID);
	seedsSpecies = (select SpeciesID from SeedsToBuy where ID = _orderID);
	seedsTo = (select FacilityID from SeedsToBuy where ID = _orderID);
	
	delete from SeedsToBuy where ID = _orderID;
	
	if (select ID from SeedsStorage where FacilityID = seedsTo and SpeciesID = seedsSpecies) is not null then
		update SeedsStorage set amount = amount + seedsGot where FacilityID = seedsTo and SpeciesID = seedsSpecies;
	else
		insert into SeedsStorage (FacilityID, SpeciesID, amount, expirationDate) values
			(seedsTo, seedsSpecies, seedsGot, now() + '1 year');
	end if;
	
end
$$;

-- procedure 2 - agree on some offer, reject others + rollback transaction

create or replace procedure SellSeedsAccept(offerID integer)
	language plpgsql as 
$$	
declare
	_orderID int;
	seedsSold int;
	_StorageID int;
begin
	_orderID = (select OrderID from SeedsSellOffer where ID = offerID);
	update SeedsSellOffer set offerStatus = 'declined' where OrderID = _orderID;
	update SeedsSellOffer set offerStatus = 'accepted' where ID = offerID;
	
	_StorageID = (select StorageID from SeedsToSell where ID = _orderID);
	seedsSold = (select amount from SeedsToSell where ID = _orderID);
	
	delete from SeedsToSell where ID = _orderID;
	
	if (select ID from SeedsStorage where ID = _storageID) is null then
		rollback;
	else
		if (select amount from SeedsStorage where ID = _storageID) >= seedsSold then
		update SeedsStorage set amount = amount - seedsSold where ID = _storageID;
		else
			rollback;
		end if;
	end if;
	
end
$$;

