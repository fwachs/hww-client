/*****************************************************************************
filename    gossip_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
	Gossip
*****************************************************************************/

//import framework.screen_controller
import framework.event
import models.gossip_message

class GossipController extends ScreenController
{	
	public function GossipController(controlledScreen)
	{
		super(controlledScreen);
	}
	
	override public function screenLoaded()
	{
		trace("Gossip screenLoaded!");
		this.screen.screenUpdateTimer.start();
		Game.sharedGame().getServer().getMessagesAndBestWife(this.buildMessageListAndBestWife);
	}

	public function buildMessageListAndBestWife(request_id, ret_code, response_content)
	{
		if(ret_code == 0) return;
		
		trace("### HWW ### - Received Gossip Messages: ", str(response_content));
		var response = json_loads(response_content);
		var messages = response.get("messages");
		var bestWife = response.get("bestHouseWife");
		
		var topHouseWife = new Wife();
		topHouseWife.loadFromJSON(bestWife);
		
		this.screen.updateMessages(messages);
		this.screen.drawBestHouseWife(topHouseWife);
		
	}
	
	public function updateMessageList(request_id, ret_code, response_content)
	{
		if(ret_code == 0) return;
		
		trace("### HWW ### - Received Gossip Messages: ", str(response_content));
		var response = json_loads(response_content);
		var messages = response.get("messages");
		
		this.screen.updateMessages(messages);
		
	}

	override public function eventFired(event)
	{
		super.eventFired(event);
		
		if (event.name == "post") {
			Game.sounds.playSFX("buttonPress");
			this.screen.post();
			//Game.sharedGame().getServer().getMessagesAndBestWife(updateMessageList);
		}
		else if (event.name == "goBack") {
			Game.sounds.playSFX("buttonPress");
			Game.popScreen();
		}

	}
}
