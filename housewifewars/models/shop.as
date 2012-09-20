/*****************************************************************************
filename    shop.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   pricing and purchase management classes
*****************************************************************************/

class Shop
{
	public function buyFurniture(furniture)
	{
		var costGB = this.getGameBucks(furniture.gameBucks);
		var costD = this.getDiamonds(furniture.diamonds);
		var payments = new Array(costGB, costD);
		var ret = Game.sharedGame().wallet.payMultiple(payments);
		
		trace("Furniture bought: ", furniture, costGB, costD, ret);
		
		return ret;
	}
	
	public function buyHouseRemodel(remodel)
	{
		var cost = this.getDiamonds(remodel.diamonds);
		var ret = Game.currentGame.wallet.pay(cost);
		
		return ret;
	}
	
	public function buyStressRelease(type)
	{
		var ret = 0;
		var cost;
		
		if(type == "playVideoGames") {
			Game.sounds.playSFX("buttonPress");
			cost = this.getGameBucks(Game.sharedGame().hubby.playVideoGameCost);
			ret = Game.sharedGame().wallet.pay(cost);
		}
		else if(type == "watchGame") {
			Game.sounds.playSFX("buttonPress");
			cost = this.getDiamonds(Game.sharedGame().hubby.watchTheGameCost);
			ret = Game.sharedGame().wallet.pay(cost);
		}
		
		return ret;
	}
	
	public function buyLoveRefill(type)
	{
		var ret = 0;
		var cost;
		
		if(type == "giveKiss") {
			cost = this.getGameBucks(Game.sharedGame().hubby.kissCost);
			ret = Game.sharedGame().wallet.pay(cost);
		}
		else if(type == "goOnDate") {
			cost = this.getDiamonds(Game.sharedGame().hubby.goOnADateCost);
			ret = Game.currentGame.wallet.pay(cost);
		}
		
		return ret;
	}
	
	public function buyImmediateReturn(from)
	{
		var cost;
		var ret = 0;
		
		if(from == "Work") {
			cost = Game.currentGame.wallet.moneyForCurrency(2, "Diamonds");
			ret = Game.currentGame.wallet.pay(cost);
			
		}
		else if(from == "Shopping") {
			cost = Game.currentGame.wallet.moneyForCurrency(1, "Diamonds");
			ret = Game.currentGame.wallet.pay(cost);
		}
		
		return ret;
	}
	
	public function buyHouse(house)
	{
		var price = int(house.price);
		var cost = Game.sharedGame().wallet.moneyForCurrency(price, house.currency);
		
		var ret = Game.sharedGame().wallet.pay(cost);
		
		return ret;
	}
	
	public function buyGift(gift)
	{
		var cost = Game.currentGame.wallet.moneyForCurrency(int(gift.amount), gift.currency);
		var ret = Game.currentGame.wallet.pay(cost);
		
		return ret;
	}	
	
	public function buySouvenir(city, souvenirLevel)
	{
		var diamonds = this.getSouvenirCost(city, souvenirLevel);
		
		var cost = this.getDiamonds(diamonds);
		var ret = Game.currentGame.wallet.pay(cost);
	
		return ret;
	}
	
	public function getSouvenirCost(city, souvenirLevel) {
		var costList = dict([
				["London", 		[1, 2, 1, 1, 1]],
				["SanFrancisco",[1, 1, 2, 1, 3]],
				["Paris",		[1, 2, 2, 2, 3]],
				["BuenosAires",	[3, 3, 3, 2, 2]],
				["Tokyo",		[4, 3, 3, 3, 3]],
				["Sydney",		[3, 5, 4, 3, 5]]
			]);
		var cityCost = costList.get(city);
		var diamonds = cityCost[souvenirLevel - 1];
		
		return diamonds;
	}
	
	public function buyTripTo(location)
	{
		var travelCost = this.getTravelCost(location);
		var travelCurrency = this.getTravelCurrency(location);
		
		var cost = Game.currentGame.wallet.moneyForCurrency(travelCost, travelCurrency);
		var ret = Game.currentGame.wallet.pay(cost);
		
		return ret;
	}
	
	public function getLocationCosts()
	{
		var locationCosts = dict([
				["London", 		[20000, "Miles"]],
				["SanFrancisco",[25000, "Miles"]],
				["Paris", 		[35000, "Miles"]],
				["BuenosAires", [50000, "Miles"]],
				["Tokyo", 		[100000,"Miles"]],				
				["Sydney", 		[10, 	"Diamonds"]]
		]);

		return locationCosts;
	}

	public function getTravelCost(location)
	{
		var travelCost = this.getLocationCosts().get(location)[0];
		
		trace("Travel cost for location:", location, travelCost);
		
		return travelCost;
	}

	public function getTravelCurrency(location)
	{
		var travelCurrency = this.getLocationCosts().get(location)[1];
		
		return travelCurrency;
	}
	
	public function getGameBucks(amount)
	{
		return Game.sharedGame().wallet.moneyForCurrency(amount, "GameBucks");
	}

	public function getDiamonds(amount)
	{
		return Game.sharedGame().wallet.moneyForCurrency(amount, "Diamonds");
	}
}