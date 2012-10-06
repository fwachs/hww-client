/*****************************************************************************
filename    gift_item.as
author      Federico Wachs
DP email    federico.wachs@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

import framework.timer

class GiftItem
{
	var id;
	var title;
	var type;
	var itemDescription;
	var description;
	var image;
	var smallImage;
	var amount;
	var currency;
	var buffType = null;
	var buffFactor = null;
	var buffTime = null;
	var buffWorkIcon = null;
	var buffShoppingIcon = null;
	var buffSSPsIcon = null;
	
	public static function newGiftFromAttributes(giftAttrs)
	{							 
		var gift = new GiftItem(giftAttrs.get("id"), giftAttrs.get("title"), giftAttrs.get("type"), giftAttrs.get("itemDescription"), giftAttrs.get("description"), giftAttrs.get("image"),
								 giftAttrs.get("smallImage"), giftAttrs.get("amount"), giftAttrs.get("currency"));
		
		gift.buffType = giftAttrs.get("buff-type");
		gift.buffFactor = int(giftAttrs.get("buff-factor"));
		
		if(giftAttrs.get("buff-time")) {
			gift.buffTime = int(giftAttrs.get("buff-time"));
		}
		
		if(giftAttrs.get("work-icon") != "") {
			gift.buffWorkIcon = "images/" + giftAttrs.get("work-icon");
		}
		
		if(giftAttrs.get("shopping-icon") != "") {
			gift.buffShoppingIcon = "images/" + giftAttrs.get("shopping-icon");
		}
		
		if(giftAttrs.get("ssp-icon") != "") {
			gift.buffSSPsIcon = "images/" + giftAttrs.get("ssp-icon");
		}
		
		trace("new gift: ", gift.id, gift.buffType, gift.buffFactor, gift.buffTime);
		
		return gift;
	}

	public function GiftItem(id, title, type, itemDescription, description, image, smallImage, amount, currency)
	{
		this.id = id;
		this.title = title;
		this.type = type;
		this.itemDescription = itemDescription;
		this.description = description;
		this.image = image;
		this.smallImage = smallImage;
		this.amount = amount;
		this.currency = currency;
	}

	public function toString() {
	    return str(this.id) + "-" + this.title;
	}

}

interface IBuff
{
	public function execute(factor, time) {}
}

class Buffs
{
	public static var started = 0;
	public static var workTimeDebuff;
	public static var shoppingTimeDebuff;
	public static var workShoppingTimeDebuff;
	public static var workTimeBuff;
	public static var salaryBuff;
	public static var rareItemChanceBuff;
	public static var sStatusPointsBuff;
	public static var shoppingIcon;
	public static var workIcon;
	
	public static function canOpenGift()
	{
		var ongoingBuff = Game.sharedGame().getProperty("OngoingBuff");
		trace("OngoingBuff: ", ongoingBuff);
		if(ongoingBuff) return 0;

		return 1;
	}
	
	public static function createBuffFromGift(gift)
	{
		if(Buffs.canOpenGift() == 0) return;
		
		Game.sharedGame().setProperty("OngoingBuff", gift.buffType);
		Game.sharedGame().setProperty("CurrentGiftId", gift.id);
		
		var buff = Buffs.getBuffForGift(gift);
		buff.execute(gift.buffFactor, gift.buffTime);		

		Buffs.showIconsForGift(gift);
	}		
		
	public static function getBuffForGift(gift)
	{
		var buff = null;
		
		if(gift.buffType) {
			if(gift.buffType == "DebuffWorkTime") {
				buff = new DebuffHusbandWorkTime();
			}
			else if(gift.buffType == "DebuffShoppingTime") {
				buff = new DebuffHusbandShoppingTime();
			}
			else if(gift.buffType == "DebuffWorkAndShoppingTime") {
				buff = new DebuffHusbandWorkShoppingTime();
			}
			else if(gift.buffType == "BuffWorkTime") {
				buff = new BuffHusbandWorkTime();
			}
			else if(gift.buffType == "BuffSalary") {
				buff = new BuffHusbandSalary();
			}
			else if(gift.buffType == "BuffRareItemChance") {
				buff = new BuffRareItemChance();
			}
			else if(gift.buffType == "BuffSocialStatusPoints") {
				buff = new BuffSStatusPoints();
			}
			else if(gift.buffType == "BuffShoppingTime") {
				buff = new BuffHusbandShoppingTime();
			}
		}
		
		return buff;
	}
		
	public static function startBuffs()
	{
		if(Buffs.started == 1) return;

		var currentGift = Game.sharedGame().getProperty("CurrentGiftId");
		if(currentGift >= 0) {
			var gift = Game.sharedGame().getGift(str(currentGift));
			trace("Current gift:", currentGift, gift);
			
			var buf = Buffs.getBuffForGift(gift);
			Buffs.showIconsForGift(gift);
		}
	}
	
	public static function showIconsForGift(gift)
	{
	    trace("hubby icons buff: ", Game.sharedGame().hubby);
	    if (Game.sharedGame().hubby == null) return;

		if(gift.buffWorkIcon) {
		    var workIcon = str(gift.buffWorkIcon);
			if(gift.buffType != "DebuffWorkAndShoppingTime" || Game.sharedGame().getProperty("OngoingBuffWork") == 0) {
			    trace("gift work icon: ", gift.buffWorkIcon);
				Buffs.workIcon = workIcon;
			}
		}
		if(gift.buffShoppingIcon) {
		    var shoppingIcon = str(gift.buffShoppingIcon);
			if(gift.buffType != "DebuffWorkAndShoppingTime" || Game.sharedGame().getProperty("OngoingBuffShopping") == 0) {
			    trace("gift shopping icon: ", gift.buffShoppingIcon);
				Buffs.shoppingIcon = shoppingIcon;
			}
		}
		if(gift.buffSSPsIcon) {
		    var sspIcon = str(gift.buffSSPsIcon);
			Game.sharedGame().bannerScreen.showSSPsBuffIcon(sspIcon);
		}
	}
	
	public static function workTripEnded()
	{
		var buffType = Game.sharedGame().getProperty("OngoingBuff");
		
		if(buffType == "DebuffWorkTime") {
			Game.sharedGame().hubby.clearWorkBuffTime();			
			Buffs.clearBuffs();
		}
		else if(buffType == "DebuffWorkAndShoppingTime") {
			Buffs.workIcon = null;
			
			Game.sharedGame().hubby.clearWorkBuffTime();

			Game.sharedGame().setProperty("OngoingBuffWork", 1);			
			if(Game.sharedGame().getProperty("OngoingBuffShopping") == 1) {
				Buffs.clearBuffs();
			}
			
		}
	}
	
	public static function shoppingTripEnded()
	{
		var buffType = Game.sharedGame().getProperty("OngoingBuff");
		
		if(buffType == "DebuffShoppingTime") {
			Game.sharedGame().hubby.clearShoppingBuffTime();
			Buffs.clearBuffs();
		}
		else if(buffType == "DebuffShoppingTime" || buffType == "DebuffWorkAndShoppingTime") {
			Buffs.shoppingIcon = null;
			
			Game.sharedGame().hubby.clearShoppingBuffTime();

			Game.sharedGame().setProperty("OngoingBuffShopping", 1);			
			if(Game.sharedGame().getProperty("OngoingBuffWork") == 1) {
				Buffs.clearBuffs();
			}
		} else if (buffType == "BuffRareItemChance") {
		    Buffs.clearBuffs();
		}
	}
	
	public static function clearBuffs()
	{
		trace("clearBuffs");
		
		Buffs.workIcon = null;
		Buffs.shoppingIcon = null;
		Game.bannerScreen.controller.hideSSPsBuffIcon();

		Game.sharedGame().setProperty("OngoingBuff", 0);
		Game.sharedGame().setProperty("CurrentGiftId", -1);
		Game.sharedGame().setProperty("OngoingBuffShopping", 0);			
		Game.sharedGame().setProperty("OngoingBuffWork", 0);			
	}
}

class DebuffHusbandWorkTime implements IBuff
{
	override public function execute(factor, time)
	{
		Game.sharedGame().hubby.setWorkBuffTime(factor * 60);
	}
}

class DebuffHusbandShoppingTime implements IBuff
{
	override public function execute(factor, time)
	{
		Game.sharedGame().hubby.setShoppingBuffTime(factor * 60);
	}
}

class DebuffHusbandWorkShoppingTime implements IBuff
{
	override public function execute(factor, time)
	{
		Game.sharedGame().hubby.setWorkBuffTime(factor * 60);
		Game.sharedGame().hubby.setShoppingBuffTime(factor * 60);
		Game.sharedGame().setProperty("OngoingBuffShopping", 0);          
        Game.sharedGame().setProperty("OngoingBuffWork", 0);
	}
}

class BuffHusbandWorkTime extends Timer implements IBuff
{
	public function BuffHusbandWorkTime()
	{
		super("BuffHusbandWorkTime", 1, 1);
	}

	override public function execute(factor, time)
	{
		trace("Execute BuffHusbandWorkTime", factor, time);
		
		Game.sharedGame().hubby.setWorkBuffTime(-factor);

		this.restart();
		this.changeRunningTime(time * 3600);
	}

	override public function tick()
	{
		trace("Done BuffHusbandWorkTime");
		
		Game.sharedGame().hubby.clearWorkBuffTime();

		Buffs.clearBuffs();
	}
}

class BuffHusbandShoppingTime extends Timer implements IBuff
{
	public function BuffHusbandShoppingTime()
	{
		super("BuffHusbandShoppingTime", 1, 1);
	}

	override public function execute(factor, time)
	{
		trace("Execute BuffHusbandShoppingTime", factor, time);
		
		Game.sharedGame().hubby.setShoppingBuffTime(-factor);

		this.restart();
		this.changeRunningTime(time * 3600);
	}

	override public function tick()
	{
		trace("Done BuffHusbandShoppingTime");
		
		Game.sharedGame().hubby.clearShoppingBuffTime();

		Buffs.clearBuffs();
	}
}

class BuffHusbandSalary extends Timer implements IBuff
{
	public function BuffHusbandSalary()
	{
		super("BuffHusbandSalary", 1, 1);
	}

	override public function execute(factor, time)
	{
		trace("Execute BuffHusbandSalary", factor, time);

		Game.sharedGame().hubby.setSalaryFactor(factor);
		
		this.restart();
		this.changeRunningTime(time * 3600);
	}

	override public function tick()
	{
		trace("Done BuffHusbandSalary");
		
		Game.sharedGame().hubby.setSalaryFactor(1);
		Buffs.clearBuffs();
	}
}

class BuffRareItemChance implements IBuff
{
	override public function execute(factor, time)
	{
		trace("Execute BuffRareItemChance");
		
		Game.sharedGame().hubby.setRareItemThreshold(factor);
	}
}

class BuffSStatusPoints extends Timer implements IBuff
{
	public function BuffSStatusPoints()
	{
		super("BuffSStatusPoints", 1, 1);
	}

	override public function execute(factor, time)
	{
		trace("Execute BuffSStatusPoints", factor, time);

		Game.sharedGame().wife.setStatusPointsFactor(factor);
		
		this.restart();
		this.changeRunningTime(time * 3600);
	}	
	
	override public function tick()
	{
		trace("Done BuffSStatusPoints");
		
		Game.sharedGame().wife.setStatusPointsFactor(0);
		Buffs.clearBuffs();
	}
}
