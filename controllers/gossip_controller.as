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
        var secondHouseWife = response.get("secondHouseWife");
        var thirdHouseWife = response.get("thirdHouseWife");

        var topHouseWife = new Wife();
        topHouseWife.loadFromJSON(bestWife);
        this.screen.drawBestHouseWife(topHouseWife, 1);

        var secondWife = new Wife();
        secondWife.loadFromJSON(secondHouseWife);
        this.screen.drawBestHouseWife(secondWife, 2, 0);

        var thirdWife = new Wife();
        thirdWife.loadFromJSON(thirdHouseWife);
        this.screen.drawBestHouseWife(thirdWife, 3, 0);

//        this.getElement("tourneyDate").setText(response.get("tournamentEndDate"));
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
        else if (event.name == "showWeeklyTournament") {
            var tournamentScreen = new TournamentScreen();
            tournamentScreen.configFile = "screen-cfgs/tournament-screen-cfg.xml";
            this.presentModalScreen(tournamentScreen);
        }
        else if (event.name == "goBack") {
            Game.sounds.playSFX("buttonPress");
            Game.popScreen();
        }
        else if(event.name == "dismiss") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
        }
        else if(event.name == "doNothing") {
        }

    }
}
