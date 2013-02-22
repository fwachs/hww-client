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
    var playerWeeklyScore;

	public function TournamentScreen(playerWeeklyScore)
	{
		super();
		this.playerWeeklyScore = playerWeeklyScore;
	}
	
	override public function build()
	{
	    Game.sharedGame().getServer().getWeeklyTournament(this.displayWeeklyTournament);
	}

    public function displayWeeklyTournament(request_id, ret_code, response_content)
    {
        if(ret_code == 0) return;

        var response = json_loads(response_content);
        var players = response.get("players");
        this.getElement("tourneyDate").setText(response.get("tournamentEndDate"));
        this.fillScroll(players);
    }

	public function fillScroll(players) {
	    var scroll = this.getElement("scroll");
        scroll.removeAllChildren();
        var ypos = 10;
        var addWeeklyScore = 1;
        for (var i = 0; i < len(players); i++) {
            var wife = new Wife();
            wife.loadFromJSON(players[i]);
            
            var reward = null;
            var params = dict();
            
            params.update("lbcard", "gossip-wall/lb-player-card.png");
            trace("rank player id: ", players[i].get("id"), wife.name);
            if (players[i].get("id") == str(Game.papayaUserId)) {
                params.update("lbcard", "gossip-wall/lb-player-card2.png");
                addWeeklyScore = 0;
            }
            params.update("rank", str(i+1));
            params.update("name", wife.name);
            params.update("score", wife.socialStatusPoints);
            if (i+1 == 1) {
                reward = "10";
            } else if (i+1 == 2) {
                reward = "7";
            } else if (i+1 == 3) {
                reward = "5";
            } else {
                reward = "2";
            }
            params.update("amount", reward);
            params.update("top", ypos);
            var control = this.controlFromXMLTemplate("WeeklyPlayerPosition", params, "weekly-player.xml");

            scroll.addChild(control);
            ypos += 80;
        }
        if (addWeeklyScore == 1) {
            params = dict();
            params.update("top", ypos);
            params.update("lbcard", "gossip-wall/lb-player-card2.png");
            params.update("rank", str(26));
            params.update("name", Game.sharedGame().wife.name);
            params.update("score", str(playerWeeklyScore));
            params.update("amount", "??");
            var weeklyUserControl = this.controlFromXMLTemplate("WeeklyPlayerPosition", params, "weekly-player.xml");
            scroll.addChild(weeklyUserControl);
            ypos += 80;
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
