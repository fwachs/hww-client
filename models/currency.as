/*****************************************************************************
filename    currency.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   currency classes
*****************************************************************************/

class Currency
{
	var name;
	var image;
	static var currencies;
	
	public function Currency(name, image)
	{
		this.name = name;
		this.image = image;
	}		
}

class Money
{
	var currency;
	var amount;
	
	public function Money(currency, amount)
	{
		this.currency = currency;
		this.amount = amount;
	}
}

class Account
{
	var currency;
	var amount;
	
	public function Account(currency, amount)
	{
		this.currency = currency;
		this.amount = amount;
	}
	
	public function add(amount)
	{
		this.amount += amount;
	}
	
	public function test(amount)
	{
		if(this.amount - amount < 0) return 0;
		
		return 1;
	}
	
	/* returns 1 if succeeds, 0 if there's not enough money on the account */
	public function substract(amount)
	{
		if(this.test(amount) == 0) return 0;
		
		this.amount -= amount;
		
		return 1;
	}
	
	public function balance()
	{
		return this.amount;
	}
}

class Wallet
{
	var accounts;
	
	public function Wallet()
	{
		var gameBucks = 0;
		var diamonds = 0;
		var miles = 0;
		var wallet = Game.getDatabase().get("wallet" + Game.getPapayaUserId());
		if (wallet != null) {
			gameBucks = wallet.get("gameBucks");
			diamonds = wallet.get("diamonds");
			miles = wallet.get("miles");
		}
		this.accounts = new dict();
		this.accounts.update("GameBucks", new Account(new Currency("GameBucks", null), gameBucks));
		this.accounts.update("Diamonds", new Account(new Currency("Diamonds", null), diamonds));
		this.accounts.update("Miles", new Account(new Currency("Miles", null), miles));
	}

	public function saveFromJSON(walletMap) {
	    var diamonds = walletMap.get("diamonds");
        var gameBucks = walletMap.get("gameBucks");
        var miles = walletMap.get("miles");

	    this.accounts = new dict();
        this.accounts.update("GameBucks", new Account(new Currency("GameBucks", null), gameBucks));
        this.accounts.update("Diamonds", new Account(new Currency("Diamonds", null), diamonds));
        this.accounts.update("Miles", new Account(new Currency("Miles", null), miles));
        this.save();
	}

	public function collect(money)
	{
		var account = this.accounts.get(money.currency.name);
		account.add(money.amount);
		trace("### HWW ### - Collecting Money");
		this.save();
	}
	
	public function pay(money)
	{
		var account = this.accounts.get(money.currency.name);
		trace("### HWW ### - Spending Money");
		var response = account.substract(money.amount);
		return response;
	}
	
	public function payMultiple(moneyArray)
	{
		if(this.testMultipleAccounts(moneyArray) == 0) return 0;
		
		for(var i = 0; i < len(moneyArray); i++) {
			var money = moneyArray[i];
			
			var account = this.accounts.get(money.currency.name);
			account.substract(money.amount);
		}
		
		return 1;
	}
	
	public function testMultipleAccounts(moneyArray)
	{
		for(var i = 0; i < len(moneyArray); i++) {
			var money = moneyArray[i];
			
			var account = this.accounts.get(money.currency.name);
			var ret = account.test(money.amount);
			
			trace("testMultipleAccounts: ", money.currency.name, money.amount, ret);
			if(ret == 0) return 0;
		}
		
		return 1;
	}
	
	public function moneyForCurrency(amount, currencyName)
	{
		var account = this.accounts.get(currencyName);
		var currency = account.currency;
		
		return new Money(currency, amount);
	}

	public function getBalance(currencyName)
	{
		var account = this.accounts.get(currencyName);
		
		return account.amount;
	}
	
	public function purchaseCurrency(money, controller)
	{
		this.collect(money);
		
		var ev = new PurchaseCurrencyEvent();
		ev.controller = controller;
		ev.succeeded = 1;
		
		ev.run();
	}
	
	public function balanceForCurrency(currencyName)
	{
		var account = this.accounts.get(currencyName);
		return account.balance();
	}

	public function load()
	{
	}

	public function save()
	{
        var serializedWallet = this.serialize();
        trace("### HWW ### - Saving Wallet: ", str(serializedWallet));
        Game.getDatabase().put("wallet" + Game.getPapayaUserId(), serializedWallet);
	}

	public function serialize()
	{
		var papayaUserId = Game.getPapayaUserId();
        var walletArray = [];
        walletArray.append(["papayaUserId", papayaUserId]);
		walletArray.append(["gameBucks", this.getBalance("GameBucks")]);
		walletArray.append(["diamonds", this.getBalance("Diamonds")]);
		walletArray.append(["miles", this.getBalance("Miles")]);
        return dict(walletArray);
	}
}

class PurchaseCurrencyEvent extends Event
{
	var succeeded;
	
	public function PurchaseCurrencyEvent()
	{
		this.name = "PURCHASE_EVENT";
	}
}

