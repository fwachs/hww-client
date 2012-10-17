/*****************************************************************************
filename    house_selection_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

import framework.screen

class RealEstate
{
	var name;
	var houseStyle;
	var fileNumber;
	var type;
	var hubbyLvlReq;
	var price;
	var currency;
	
	public function RealEstate()
	{
	}
}

class HouseSelectionScreen extends Screen
{
	var houseListing;
	var houseNameLabel;
	var costDiamondsLabel;
	var costGameBucksLabel;
	
	public function HouseSelectionScreen()
	{
		super();
	}
	
	override public function build()
	{
		this.loadHouseListing();
		this.displayHouses();
		houseNameLabel = this.getElement("houseNameText");
		costDiamondsLabel = this.getElement("diamondsCost");
		costGameBucksLabel = this.getElement("gameBucksCost");
		
		if(this.firstTime == 1 && Game.sharedGame().recoveredFromServer == 0) {
			this.getElement("backbutton").getSprite().texture("images/wife-selection-screen/confirm-circle.png");
		}
	}
	
	override public function gotFocus()
	{
		Game.hideBanner();
	}
	
	override public function lostFocus()
	{
		Game.hideBanner();
	}
	
	public function displayHouses()
	{
		var houseSelectionBar = this.getElement("houseSelectionBar");
		var left = 20;
		for(var i = 0; i < len(this.houseListing); i++) {
			var house = this.houseListing[i];
			var houseSmallFrame = "house-select/house-select-screen/house-frame-small.png";
			var houseType;
			var houseText = "";
			
			if(house.type == "Default") {
				houseType = "";
			}
			else if(house.type == "Premium") {
				houseType = "house-select/house-select-screen/p-frame-small.png";
			}
			// before lockable types for removing locks
			else if(Game.sharedGame().realestate.propertyListing[int(house.fileNumber) - 1] == 1) {
				houseType = "";
			}
			else if(house.type == "LvlReq") {
				trace("### HWW ### -  hubby career level - " + str(Game.sharedGame().hubby.careerLevel));
				trace("### HWW ### - house hubby lvl reg - " + house.hubbyLvlReq);
				
				if(Game.sharedGame().hubby.careerLevel < int(house.hubbyLvlReq)) {
					houseType = "house-select/house-select-screen/l-frame-small.png";
					houseText = "LEVEL " + house.hubbyLvlReq;
				}
				else {
					houseType = "";
					houseText = "";
				}
			}
			else if(house.type == "FriendReq") {
				// TODO: Impliment post-launch
			}
			
			var params = dict();
			params.update("left", str(left));
			params.update("fileNumber", str(house.fileNumber));
			params.update("houseFrame", houseSmallFrame);
			params.update("houseType", houseType);
			params.update("houseText", houseText);
			var property = this.controlFromXMLTemplate("HouseItem", params, "house-item.xml");
			property.tapEvent.argument = house;
			
			// this.addEvent(property, "houseSelected", house, EVENT_UNTOUCH);
			houseSelectionBar.addChild(property);
			
			left += 200;
		}
		
		this.getElement("houseSelectionBar").setContentSize(left, 185);
	}
	
	public function loadHouseListing()
	{
		var xmldict = parsexml("game-config/house_costs.xml", 1);
		var xmlhouses = xmldict.get("hww-config:player-houses").get("#children");		
				
		this.houseListing = new Array();
		
		for(var i = 0; i < len(xmlhouses); i++) {
			var xmlhouse = xmlhouses[i].get("hww-config:player-house");
			var houseattrs = xmlhouse.get("#attributes");
			
			if(this.firstTime == 0 || Game.sharedGame().recoveredFromServer == 1 || (this.firstTime == 1 && houseattrs.get("type") == "Default")) {
				var realEstate = new RealEstate();
				realEstate.name = houseattrs.get("name");
				realEstate.houseStyle = houseattrs.get("houseStyle");
				realEstate.fileNumber = houseattrs.get("fileNumber");
				realEstate.type = houseattrs.get("type");
				realEstate.hubbyLvlReq = houseattrs.get("hubbyLvlReq");
				realEstate.price = houseattrs.get("price");
				realEstate.currency = houseattrs.get("currency");
				
				this.houseListing.append(realEstate);
			}			
		}		
	}
}
