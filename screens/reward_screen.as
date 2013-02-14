/*****************************************************************************
filename    tournament_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class RewardScreen extends Screen
{
    var reward;

	public function RewardScreen(reward)
	{
		super();
		this.reward = reward;
	}
	
	override public function build()
	{
	    trace("reward: ", reward);
	    this.getElement("rewardGivenAmount").setText(str(reward.get("amount")));
	    this.getElement("rewardReasonText").setText(str(reward.get("reason")));
	    var texture = null;
	    if (reward.get("currency") == "Diamonds") {
	        texture = "images/premium-currency-screen/dimonds01v2.png";
	    } else if (reward.get("currency") == "GameBucks") {
	        texture = "images/daily-bonus-prompt/bonus-01b.png";
	    } else {
	        texture = "images/daily-bonus-prompt/bonus-04b.png";
	    }
	    this.getElement("rewardGivenIcon").getSprite().texture(texture);
	}

	override public function gotFocus()
	{
	}
	
	override public function lostFocus()
	{
	}
}
