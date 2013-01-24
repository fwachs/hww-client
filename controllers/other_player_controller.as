/*****************************************************************************
filename    wife_customization_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller

class OtherPlayerController extends ScreenController
{
	var player;

	public function OtherPlayerController(controlledScreen, player)
	{
		super(controlledScreen);
		this.player = player;
	}
	
	override public function screenLoaded()
	{
		trace("OtherPlayerController screenLoaded!");
		this.screen.getElement("playerName").setText(this.player.name);
		Game.sharedGame().getServer().getOtherPlayerProfile(player.papayaUserId, buildOtherPlayerScreen);
	}

	public function buildOtherPlayerScreen(request_id, ret_code, response_content)
	{
		trace("### HWW ### - Other Player Profile: ", str(response_content));
		var response = json_loads(response_content);
		var wife = response.get("wife");

		var husband = response.get("husband");
		var husbandName = husband.get("name");
		var husbandType = husband.get("occupation");
		var citiesVisited = str(husband.get("totalVisits"));
		var jobLevel = str(husband.get("careerLevel"));
		var loveTank = str(husband.get("loveTankValue"));
		var stressLevel = str(husband.get("stressLevel"));

		var houseLevel = str(response.get("houseLevel"));
		trace("### HWW ### - Husband houseLevel", houseLevel);

		var husbandNameElement = this.screen.getElement("husbandName");
		husbandNameElement.setText(husbandName);
		
		this.screen.getElement("husband").getSprite().texture(getHusbandTexture(husbandType));

		var houseWife = new Wife();
		houseWife.loadFromJSON(wife);
		houseWife.dress(this.screen, 0);

		var socialStatusPointsElement = this.screen.getElement("SSPText");
		socialStatusPointsElement.setText(str(houseWife.socialStatusPoints));

		var houseLevelElement = this.screen.getElement("houseLevelValue");
		houseLevelElement.setText(houseLevel);

		var citiesVisitedElement = this.screen.getElement("citiesVisitedValue");
		citiesVisitedElement.setText(citiesVisited);

		var jobLevelElement = this.screen.getElement("jobLevelValue");
		jobLevelElement.setText(jobLevel);

		if(loveTank == null)
			loveTank = "n/a";
		
		var loveTankElement = this.screen.getElement("loveTankValue");
		loveTankElement.setText(loveTank);

		if(stressLevel == null)
			stressLevel = "n/a";
		
		var stressLevelElement = this.screen.getElement("stressLevelValue");
		stressLevelElement.setText(stressLevel);
	}

	override public function eventFired(event)
	{
		super.eventFired(event);
		
		if(event.name == "goBack") {
			Game.sounds.playSFX("buttonPress");
			Game.popScreen();
		}
		else if (event.name == "visitHome") {
			Game.sounds.playSFX("buttonPress");
			Game.sharedGame().getServer().getOtherPlayerHouse(this.player.papayaUserId, buildHouseScreen);
		}
		else if (event.name == "showGiftOthersScreen") {
			Game.sounds.playSFX("buttonPress");
			var screen = new GiftOthersPromptScreen();
			screen.configFile = "screen-cfgs/gift-others-prompt-screen-cfg.xml";
			var controller = new GiftOthersPromptController(screen, this.player);
			Game.pushScreen(screen);
		} else if (event.name == "doNothing") {
		    
		}
	}

	public function buildHouseScreen(request_id, ret_code, response_content)
	{
		var response = json_loads(response_content);

		var customTiles = response.get("customTiles");
		var houseCustomTiles = new dict();
		for (var i=0; i<len(customTiles); i++) {
			trace("### HWW ### - CustomTile: ", str(customTiles[i]));
			var tg = TilesGroup.deserialize(customTiles[i]);
			houseCustomTiles.update(tg.getId(), tg);
		}

		var furnitures = response.get("furnitures");
		var houseFurniture = new dict();
		for (var j=0; j<len(furnitures); j++) {
			trace("### HWW ### - FurnitureItem: ", str(furnitures[j]));
			var furnitureItem = FurnitureItem.deserialize(furnitures[j]);
			houseFurniture.update(furnitureItem.getId(), furnitureItem);
		}

		var storage = response.get("storage");
		var houseStorage = new dict();
		for (var k=0; k<len(storage); k++) {
			trace("### HWW ### - StorageItem: ", str(storage[k]));
			var storageItem = FurnitureItem.deserialize(storage[k]);
			houseStorage.update(storageItem.getId(), storageItem);
		}
		var selectedStyleId = response.get("type");
		var level = response.get("level");

		var house = new OtherPlayerHouse();

		house.storage = houseStorage;
		house.furniture = houseFurniture;
		house.customTiles = houseCustomTiles;
		house.setSelectedStyle(selectedStyleId);
		if (house.selectedStyle == null) {
		    house.setSelectedStyle("brick-yellow");
		}
		if (level == null) {
		    level = 1;
		}
		house.level = level;

		var screen = new HouseScreen(house);
		screen.configFile = "screen-cfgs/house-screen-cfg.xml";
		var controller = new HouseController(screen, house);
	
		Game.pushScreen(screen);
	}

	public function getHusbandTexture(occupation)
	{
		if(occupation == 0) {
			return "images/husband-selection-screen/m-Husbands-executivev5-536.png";
		}
		else if(occupation == 1) {
			return "images/husband-selection-screen/m-Husbands-Doctor-536.png";
		}
		else if(occupation == 2) {
			return "images/husband-selection-screen/m-Husbands-Bankerv5-536.png";
		}
		else if(occupation == 3) {
			return "images/husband-selection-screen/m-Husbands-Sport-536.png";
		}
		else if(occupation == 4) {
			return "images/husband-selection-screen/m-Husbands-Lawyer-536.png";
		}
	}
	
}//end class
