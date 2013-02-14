/*****************************************************************************
filename    tournament_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class TournamentScreen extends Screen
{
	public function TournamentScreen()
	{
		super();
	}
	
	override public function build()
	{
	    Game.sharedGame().getServer().getWeeklyTournament(this.displayWeeklyTournament);
	}

    public function displayWeeklyTournament(request_id, ret_code, response_content)
    {
        if(ret_code == 0) return;

        trace("### HWW ### - Received Tournament Rank: ", str(response_content));
        var response = json_loads(response_content);
        var players = response.get("players");
        this.getElement("tourneyDate").setText(response.get("tournamentEndDate"));
        this.fillScroll(players);
    }

	public function fillScroll(players) {
	    var scroll = this.getElement("scroll");
        scroll.removeAllChildren();
        var ypos = 10;
        
        for (var i = 0; i < len(players); i++) {
            var wife = new Wife();
            trace("fucking player: ", players[i]);
            wife.loadFromJSON(players[i]);
            
            var reward = null;
            var params = dict();
            params.update("rank", str(i+1));
            params.update("name", wife.name);
            params.update("score", wife.socialStatusPoints);
            if (i+1 == 1) {
                reward = "10";
            } else if (i+1 == 2) {
                reward = "5";
            } else if (i+1 == 3) {
                reward = "3";
            } else {
                reward = "1";
            }
            params.update("amount", reward);
            params.update("top", ypos);
            var control = this.controlFromXMLTemplate("WeeklyPlayerPosition", params, "weekly-player.xml");

            scroll.addChild(control);
            ypos += 70;
        }
        scroll.setContentSize(200, ypos);
	}

	override public function gotFocus()
	{
	}
	
	override public function lostFocus()
	{
	}
}
