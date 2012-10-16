/*****************************************************************************
filename    main_screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen

class MainScreen extends Screen
{
	var advertisement;
	var firstTimeAdDisplay;
	
	public function MainScreen()
	{
		super();

		this.isRoot = 1;	
		this.firstTimeAdDisplay = 1;
	}
	
	override public function build()
	{
		var husbandElement = this.getElement("husband").getSprite();
		var husband = Game.sharedGame().hubby;
		husbandElement.texture(husband.getHusbandTexture());
		Game.sharedGame().wife.dress(this);
		this.showChatText();
		this.startHusbandAnimation();
	}

	public function showChatText() {
	    var chatText = this.getElement("chatText");
        var husbandMessage = Game.sharedGame().getRandomMessage("main-menu");
        trace("HWW ### - husband message: ", husbandMessage);
        chatText.setText(husbandMessage);
        chatText.getSprite().color(0, 0, 0);
        this.getElement("chatBubble").getSprite().visible(1);
        c_invoke(this.hideChatBubble, 4000, null);
	}

	public function hideChatBubble() {
        this.getElement("chatBubble").getSprite().visible(0);
    }

	override public function gotFocus()
	{
		Game.showBanner(1, 1);
		this.startHusbandAnimation();
		this.stopWifeAnimation();
		Game.sharedGame().wife.dress(this);
		this.showChatText();
		Game.startButtonShineAnimation();
		/*
		if(this.firstTimeAdDisplay == 1){
			this.firstTimeAdDisplay = 0;
			c_invoke(displayFullScreenAd, 5000, null);
		}
		
		c_invoke(displayFullScreenAd, 60000, null);
		*/
	}

	override public function lostFocus()
	{
		Game.hideBanner();
		this.getElement("settingsFrame").getSprite().visible(0);
		this.getElement("friendsBeltContainer").getSprite().visible(0);
		this.stopHusbandAnimation();
		this.stopWifeAnimation();
		Game.stopButtonShineAnimation();
		removeAd();
	}

	public function stopWifeAnimation()
	{
		this.getElement("rightArm").getSprite().stop();
		this.getElement("leftArm").getSprite().stop();
		this.getElement("rightArmSleeve").getSprite().stop();
		this.getElement("leftArmSleeve").getSprite().stop();
		this.getElement("face").getSprite().stop();
	}

	public function startHusbandAnimation()
	{
		var husband = Game.sharedGame().hubby;
		var faceSprite = this.getElement("faceAnimation").getSprite();
		var action = Game.animations.getAnimation(husband.getHusbandAnimation());
		faceSprite.stop();
		faceSprite.addaction(repeat(action));		
	}

	public function stopHusbandAnimation()
	{
		this.getElement("faceAnimation").getSprite().stop();
		this.getElement("face").getSprite().stop();
	}

	public function prepareFriendsBelt(friends)
	{
	    Game.showBanner(1, 0);
		this.getElement("friendsScroll").removeAllChildren();
		
		var left = this.buildFriendsBelt(friends, 20, 1, "friendSelected");
		this.buildFriendsBelt(friends, left, 0, "inviteFriend");
	}
	
	public function buildFriendsBelt(friends, leftStart, isGamePlayer, event)
	{
		this.getElement("friendsBeltContainer").getSprite().visible(1);
		
		var friendsBelt = this.getElement("friendsScroll");
		var left = leftStart;
		var totalFriendsToDisplay = 10;
		var friendsCount = len(friends);
		
		var avatarLeft = 67;
		var avatarTop = 61;
		var inviteVisible = "no";
		if(isGamePlayer == 0) {
			inviteVisible = "yes";
		}
		
		for(var i = 0; i < friendsCount; i++) {
			var friend = friends[i];
			
			if(friend.wasInvited == 1 && friend.isGamePlayer == 0) continue;
						
			if(friend.isGamePlayer == isGamePlayer) {
				var friendParams = dict();
				friendParams.update("left_pos", str(left));
				friendParams.update("friend_name", friend.name);
				friendParams.update("avatar_url", friend.avatarUrl);
				friendParams.update("avatar_left", str(Game.translateX(avatarLeft)));
				friendParams.update("avatar_top", str(Game.translateY(avatarTop)));
				friendParams.update("tap_event", event);
				friendParams.update("invite", inviteVisible);
				var property = this.controlFromXMLTemplate("PapayaFriend", friendParams, "papaya-friend.xml");
				property.tapEvent.argument = friend;
				friendsBelt.addChild(property);
				left += 165;
			}
		}
		
		return left;
	}

	public function showDailyBonusFrame()
	{
		var db = Game.getDatabase();
		var lastReward = db.get("lastReward");
		var count = lastReward.get("reward.count");
		trace("### HWW ### - LastReward: ", str(lastReward));
		trace("### HWW ### - LastReward count : ", str(count));
		if (count == null) {
            count = 1;
        }
		for (var i=1; i <= count; i++) {
			this.getElement("day"+str(i)+"Icon").getSprite().texture("images/daily-bonus-prompt/check-select.png");
		}
		
		this.getElement("todayBonusPrize").getSprite().texture("images/daily-bonus-prompt/bonus-0" + str(count) +".png");
		this.getElement("dailyBonusFrame").getSprite().visible(1);
	}
	
	public function displayBannerAd()
	{
	    if(Game.currentScreen().getScreenName() == "main-screen") {
	        advertisement = v_create(V_APPFLOOD_BANNER_SMALL, Game.translateX(240), Game.translateY(0), Game.translateX(790), Game.translateY(70));
	        v_root().addview(advertisement);
	    }
	    
	    c_invoke(removeAd, 5000, null);
	}

	public function displayFullScreenAd()
	{
	    if(Game.currentScreen().getScreenName() == "main-screen") {
	    	openUrl("appflood_fullscreen");
	    }	    
	}

	public function removeAd()
	{
	    if (advertisement != null) {
	        advertisement.removefromparent();
	    }
	}
}
