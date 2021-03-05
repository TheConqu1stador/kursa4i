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