/*****************************************************************************
filename    missions_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class MissionsScreen extends Screen
{
    var mission;
	public function MissionsScreen(mission)
	{
		super();
		this.mission = mission;
	}
	
	override public function build()
	{
	    var currencyImage = "images/premium-currency-screen/game-buck.png";
	    if (mission.getCurrency() == "diamonds") {
	        currencyImage = "images/premium-currency-screen/dimonds01v2.png";
	    }

	    this.getElement("missionCurrencyRewardIcon").getSprite().texture(currencyImage);
	    this.getElement("missionTitle").setText(mission.name);
	    this.getElement("missionSspReward").setText(str(mission.ssp));
	    this.getElement("missionCurrencyReward").setText(str(mission.getReward()));
	    var canCollect = this.fillScroll(mission.tasks);
	    if (canCollect == 1) {
	        this.getElement("missionCompleteTextFrame").getSprite().visible(1);
	        this.getElement("missionCompleteButton").getSprite().visible(1);
	        this.getElement("missionIncompleteButton").getSprite().visible(0);
	    }
	}

	public function fillScroll(tasks) {
	    var scroll = this.getElement("scroll");
        scroll.removeAllChildren();
        var ypos = 50;
        var canCollect = 1;
        
        for (var i = 0; i < len(tasks); i++) {
            var params = dict();
            var control = null;
            if (this.mission.type == "remodel") {
                params.update("top", ypos);
                params.update("level", str(tasks[i].level));
                params.update("visible", "NO");
                var level = Game.sharedGame().house.level;
                if (level >= tasks[i].level) {
                    params.update("visible", "YES");
                } else {
                    canCollect = 0;
                }
                control = this.controlFromXMLTemplate("RemodelMissionTask", params, "mission-task.xml");
            } else {
                var furniture = Game.sharedGame().getFurniture(tasks[i].itemId);
                params.update("top", ypos);
                params.update("amount", str(tasks[i].amount));
                params.update("furnitureName", furniture.name);
                params.update("visible", "NO");
                var completedFurnitureTask = Game.sharedGame().house.containsFurniture(furniture, tasks[i].amount);
                if (completedFurnitureTask == 1) {
                    params.update("visible", "YES");
                } else {
                    canCollect = 0;
                }
                control = this.controlFromXMLTemplate("MissionTask", params, "mission-task.xml");
            }

            scroll.addChild(control);
            ypos += 72;
        }
        scroll.setContentSize(200, ypos);
        return canCollect;
	}

	override public function gotFocus()
	{
	}
	
	override public function lostFocus()
	{
	}
}
