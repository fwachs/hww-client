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
	public function MainScreen()
	{
		super();

		this.isRoot = 1;	
	}
	
	override public function build()
	{
		var husbandElement = this.getElement("husband").getSprite();
		var husband = Game.sharedGame().hubby;
		husbandElement.texture(husband.getHusbandTexture());
		Game.sharedGame().wife.dress(this);
		this.showChatText();
		this.startHusbandAnimation();
		
		var fbLogin = FacebookApi.loginView(330, 272, 104, 35, facebookLoginCallback);
		this.getElement("settingsFrame").getSprite().add(fbLogin);
	}

	public function facebookLoginCallback(facebookId) {
	    Game.sharedGame().updateSocialId(facebookId);
	}

	public function showChatText() {
	    var chatText = this.getElement("chatText");
        var husbandMessage = Game.sharedGame().getRandomMessage("main-menu");
        trace("HWW ### - husband message: ", husbandMessage);
        chatText.setText(husbandMessage);
        chatText.textColor(0, 0, 0);
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
	}

	override public function lostFocus()
	{
		Game.hideBanner();
		this.getElement("settingsFrame").getSprite().visible(0);
		this.getElement("friendsBeltContainer").getSprite().visible(0);
		this.stopHusbandAnimation();
		this.stopWifeAnimation();
		Game.stopButtonShineAnimation();
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
		this.getElement("friendsScroll").removeAllChildren();
		
		var left = this.buildFriendsBelt(friends, 20, 1, "friendSelected");
		var fakeFriends = new Array();
		for(var j = 0; j < 3; j++) {
		    var fakeFriend = new PapayaFriend(0, "Invite", "friend-belt/friendbelt-question.png", 0, 0, 0);
		    fakeFriends.append(fakeFriend);
        }
		left = this.buildFriendsBelt(fakeFriends, left, 0, "inviteFriend");
		this.getElement("friendsScroll").setContentSize(left, 185);
	}
	
	public function buildFriendsBelt(friends, leftStart, isGamePlayer, event)
	{
		Game.showBanner(1, 0);
		this.getElement("friendsBeltContainer").getSprite().visible(1);
		
		var friendsBelt = this.getElement("friendsScroll");
		var left = leftStart;
		var totalFriendsToDisplay = 10;
		var friendsCount = len(friends);
		
		var avatarLeft = 82;
		var avatarTop = 61;
		var inviteVisible = "no";
		if(isGamePlayer == 0) {
			inviteVisible = "yes";
		}
		
		for(var i = 0; i < friendsCount; i++) {
			var friend = friends[i];
			log(friend.name, friend.isGamePlayer, " game player: ", isGamePlayer);
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
		var count = 1;
		trace("### HWW ### - LastReward: ", str(lastReward));
		trace("### HWW ### - LastReward count : ", str(count));
		if(lastReward != null) {
			count = lastReward.get("reward.count");
		}
		for (var i=1; i <= count; i++) {
			this.getElement("day"+str(i)+"Icon").getSprite().texture("images/daily-bonus-prompt/check-select.png");
		}
		
		this.getElement("todayBonusPrize").getSprite().texture("images/daily-bonus-prompt/bonus-0" + str(count) +".png");
		this.getElement("dailyBonusFrame").getSprite().visible(1);
		this.getElement("closeDailyBonusButton").getSprite().visible(1);
	}

}
