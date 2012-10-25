/*****************************************************************************
filename    main_controller.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

//import framework.screen_controller
import framework.event
import screens.main_screen
import screens.house_screen
import screens.husband_screen
import screens.gossip_screen
import screens.travel_screen
import screens.gift_shop_screen
import screens.passport_screen
import screens.premium_currency_screen
import screens.other_player_screen
import screens.house_selection_screen
import screens.gift_others_prompt_screen
import screens.receive_gift_screen
import screens.mystery_items_screen
import screens.message_box_screen


import controllers.house_controller
import controllers.husband_controller
import controllers.gossip_controller
import controllers.travel_controller
import controllers.gift_shop_controller
import controllers.passport_controller
import controllers.premium_currency_controller
import controllers.other_player_controller
import controllers.house_selection_controller
import controllers.gift_others_prompt_controller
import controllers.receive_gift_controller
import controllers.mystery_items_controller



class MainController extends ScreenController
{
    var settingsText;
    var soundText;
    var notificationsText;
    var screenUpdateTimer;
    var friends = null;

    public function MainController(controlledScreen)
    {
        super(controlledScreen);
    }

    override public function screenLoaded()
    {
        trace("MainControlller screenLoaded!");
        
        Game.sharedGame().wife.registrationDone();

        this.screen.getElement("mysteryItemsButton").getSprite().size(Game.translateX(125), Game.translateY( 146));

        this.settingsText = this.screen.getElement("settingsText");
        this.settingsText.setText("SETTINGS");
        this.settingsText.setFont(Game.font.getBoldFont(), Game.translateFontSize(72));

        this.soundText = this.screen.getElement("soundText");
        this.soundText.setText("Sound");
        this.soundText.setFont(Game.font.getBoldFont(), Game.translateFontSize(60));

        this.notificationsText = this.screen.getElement("notificationsText");
        this.notificationsText.setText("Notifications");
        this.notificationsText.setFont(Game.font.getBoldFont(), Game.translateFontSize(60));

        this.screenUpdateTimer = new mainScreenUpdateTimer(this.checkForGifts);
        this.screenUpdateTimer.start();

        if(Game.audioOn() == 1) {
            this.screen.getElement("soundOnButton").getSprite().texture("images/settings-prompt/on-box-highlight.png");
            this.screen.getElement("soundOffButton").getSprite().texture("images/settings-prompt/off-box-deselect.png");
        }
        else {
            this.screen.getElement("soundOnButton").getSprite().texture("images/settings-prompt/on-box-deselect.png");
            this.screen.getElement("soundOffButton").getSprite().texture("images/settings-prompt/off-box-highlight.png");
        }
    }

    override public function screenUnloaded()
    {
    }

    override public function eventFired(event)
    {
        var screen;
        var controller;
        var web;

        super.eventFired(event);

        if(event.name == "gotoMap") {
        }
        else if(event.name == "gotoSettings") {
            Game.sounds.playSFX("buttonPress");

            this.screen.getElement("settingsFrame").getSprite().visible(1);
            this.screen.getElement("friendsBeltContainer").getSprite().visible(0);
        }
        else if(event.name == "closeSettings") {
            Game.sounds.playSFX("buttonPress");
            this.screen.getElement("settingsFrame").getSprite().visible(0);
        }
        else if(event.name == "displayFriendsBelt") {
            Game.sounds.playSFX("buttonPress");
            this.loadFriends();
        }
        else if(event.name == "hideFriendsBelt") {
            Game.sounds.playSFX("buttonPress");
            this.screen.getElement("friendsBeltContainer").getSprite().visible(0);
            Game.showBanner(1, 1);
        }
        else if(event.name == "soundOn") {
            Game.sounds.playSFX("buttonPress");
            Game.sounds.turnOn();

            this.screen.getElement("soundOnButton").getSprite().texture("images/settings-prompt/on-box-highlight.png");
            this.screen.getElement("soundOffButton").getSprite().texture("images/settings-prompt/off-box-deselect.png");
        }
        else if(event.name == "soundOff") {
            Game.sounds.playSFX("buttonPress");
            Game.sounds.turnOff();

            this.screen.getElement("soundOnButton").getSprite().texture("images/settings-prompt/on-box-deselect.png");
            this.screen.getElement("soundOffButton").getSprite().texture("images/settings-prompt/off-box-highlight.png");
        }
        else if(event.name == "notificationsOn") {
            Game.sounds.playSFX("buttonPress");

            // TODO impliment notifications functionality
            this.screen.getElement("notificationsOnButton").getSprite().texture("images/settings-prompt/on-box-highlight.png");
            this.screen.getElement("notificationsOffButton").getSprite().texture("images/settings-prompt/off-box-deselect.png");
        }
        else if(event.name == "notificationsOff") {
            Game.sounds.playSFX("buttonPress");

            // TODO impliment notifications functionality
            this.screen.getElement("notificationsOnButton").getSprite().texture("images/settings-prompt/on-box-deselect.png");
            this.screen.getElement("notificationsOffButton").getSprite().texture("images/settings-prompt/off-box-highlight.png");
        }
        else if(event.name == "rateUs") {
            Game.sounds.playSFX("buttonPress");

            var url = "http://itunes.apple.com/us/app/housewife-wars/id508200796?ls=1&mt=8";
            if (getmodel() == 6) {
                url = "https://play.google.com/store/apps/details?id=com.twoclams.hww.android.live";
            }
            Game.sharedGame().rateReward();
            openUrl(url);
        }
        else if(event.name == "friendSelected") {
            Game.sounds.playSFX("buttonPress");
            var socialPlayer = event.argument;
            screen = new OtherPlayerScreen();
            screen.configFile = "screen-cfgs/other-player-screen-cfg.xml";
            controller = new OtherPlayerController(screen, socialPlayer);
            Game.pushScreen(screen);
        }
        else if (event.name == "inviteFriends") {
            Game.sounds.playSFX("buttonPress");
            openUrl("static_findfriends", 1);
        }
        else if(event.name == "showDailyBonusFrame") {
            Game.sounds.playSFX("buttonPress");

            var lastRewardDay = Game.getDatabase().get("lastRewardDay");
            trace("### HWW ### - Today: ", Game.sharedGame().today, " lastRewardDay: ", lastRewardDay);
            if (lastRewardDay != null && Game.sharedGame().today == lastRewardDay) {
                this.screen.showDailyBonusFrame();
            } else {
                Game.getServer().getDailyBonus(dailyBonusCallback);
            }
        }
        else if (event.name == "hideDailyBonusFrame") {
            Game.sounds.playSFX("buttonPress");

            this.screen.getElement("dailyBonusFrame").getSprite().visible(0);
        }
        else if (event.name == "showGiftOthersStep") {
            Game.sounds.playSFX("buttonPress");
            this.openGift();
        }
        else if(event.name == "gotoMysteryItemsScreen") {
            Game.sounds.playSFX("buttonPress");

            screen = new MysteryItemsScreen();
            screen.configFile = "screen-cfgs/mystery-items-screen-cfg.xml";
            controller = new MysteryItemsController(screen);
            Game.pushScreen(screen);
        }
        else if(event.name == "showAchievements") {
            Game.sounds.playSFX("buttonPress");

            ppy_listachievements(achievement_callback, null);

            openUrl("static_achievement", 1);
        }
        else if(event.name == "gotoHusband") {
            Game.sounds.playSFX("buttonPress");

            Game.pushScreen(Game.sharedGame().hubby.husbandScreen);
        }
        else if(event.name == "dismiss") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
        }
        else if(event.name == "gotoPapayaHome") {
            Game.sounds.playSFX("buttonPress");
            openUrl("static_home", 1);
        }
        else if(event.name == "gotoPapayaCircle") {
            trace("papaya circle");
            Game.sounds.playSFX("buttonPress");
            openUrl("static_mycircles_circle?cid=7644329", 1);
        }
        else if(event.name == "doNothing") {
        }
        else if(event.name == "inviteFriend") {
        	this.inviteFriend(event.argument);
        }
        else if(event.name == "showTutorialHelp") {
        	Game.hideBanner();
        	this.screen.getElement("tutorialPrompt").getSprite().visible(1);
        }
        else if(event.name == "hideTutorialHelp") {
        	this.screen.getElement("tutorialPrompt").getSprite().visible(0);
        	Game.showBanner(1, 1);
        }
    }

    public function openGift()
    {
        if(Buffs.canOpenGift() == 1) {
            var storedGifts = Game.getDatabase().get("storedGifts");
            var receivedGift = storedGifts.pop(0);

            if (len(storedGifts)==0) {
                this.screen.getElement("giftsIcon").getSprite().visible(0);
            }
            Game.getDatabase().put("storedGifts", storedGifts);
            var countElement = this.screen.getElement("giftsCount");
            countElement.setText(str(len(storedGifts)));
            countElement.setFont(Game.font.getBoldFont(), 24);

            var screen = new ReceiveGiftScreen();
            screen.configFile = "screen-cfgs/receive-gift-screen-cfg.xml";
            trace("### HWW ### - ReceivedGift: ", str(receivedGift));
            var controller = new ReceiveGiftController(screen, receivedGift);
            controller.presentModalScreen(screen);
        }
        else {
            this.showMessageBox(MessageBoxScreen.MB_CantOpenGift);
        }
    }

    public function achievement_callback(id, ret, content, param)
    {
        trace("### HWW ### - Achievements");
        trace(str(content));
    }

    public function dailyBonusCallback(request_id, ret_code, response_content)
    {
        if(ret_code == 0) return;

        var response = json_loads(response_content);
        var lastRewardDay = response.get("currentDay");
        if (response.get("reward") == 1) {
            var currency = response.get("reward.currency");
            var amount = response.get("reward.amount");

            if (currency == "SocialStatusPoints") {
                Game.sharedGame().wife.incSocialStatusPoints(100);
            } else {
                var dailyBonus = Game.currentGame.wallet.moneyForCurrency(amount, currency);
                Game.currentGame.wallet.collect(dailyBonus);
            }

            var reward = dict();
            reward.update("reward.currency", currency);
            reward.update("reward.amount", amount);
            reward.update("reward.count", response.get("reward.count"));

            var db = Game.getDatabase();
            db.put("lastReward", reward);
            db.put("lastRewardDay", lastRewardDay);
        }
        this.screen.showDailyBonusFrame();
    }

    public function checkForGifts()
    {
        trace("### HWW ### - checking for new gifts function!");

        Game.sharedGame().checkForReceivedGifts();
        var storedGifts = Game.getDatabase().get("storedGifts");

        if (storedGifts != null && len(storedGifts)>0)
        {
            var giftsIcon = this.screen.getElement("giftsIcon");

            if(giftsIcon) {
                giftsIcon.getSprite().visible(1);
                var countElement = this.screen.getElement("giftsCount");
                trace("### HWW ### - Count of storedGifts", str(len(storedGifts)));
                countElement.setText(str(len(storedGifts)));
            }
        }
    }

    public function loadFriends()
    {
        var friends = new Array();
        var queryParams = dict([["offset",0],["limit",499]]);
        var param = "";
        // ppy_query("list_friends", queryParams, buildFriendCallback, param);
        ppy_query("list_friends", queryParams, buildFriendCallback, param);
    }

    public function buildFriendCallback(requestId, ret_code, response, param)
    {
        if(ret_code == 0) {
            this.screen.prepareFriendsBelt(new Array());
            return;
        }

        var flist = response.get("data");
        trace("Friends list: ", flist);

        // decorate user dicts with foundOnHWW attribute
        Game.getServer().checkPlayersStatus(flist, this);
        
//        this.buildFriends(flist);
    }
    
    public function buildFriends(flist)
    {
    	trace("buildFriends: ", flist);
    	
        this.screen.getElement("friendsBeltContainer").getSprite().visible(1);

        var friends = new Array();
        for (var i=0; i< len(flist); i++) {
            var friendUserId = flist[i].get("id");
            var name = flist[i].get("name");
            var avatarVersionId = 0;
            if (friendUserId != null) {
                avatarVersionId = flist[i].get("avatar_version");
            }

            var avatarUrl;
            if (avatarVersionId != 0) {
                avatarUrl = avatar_url(friendUserId, avatarVersionId);
                avatarUrl = avatarUrl.replace("&", "&amp;");
            } else {
                avatarUrl = "friend-belt/friendbelt-question.png";
            }
            
            var isGamePlayer = flist[i].get("isplayer");
            var wasInvited = PapayaFriend.isInvited(friendUserId);
        	if(isGamePlayer == 1 && wasInvited == 1) {
	        	trace("Invitation removed: ", friendUserId);
        		PapayaFriend.removeInvitation(friendUserId);
        	}
            
            var foundOnHWW = flist[i].get("foundOnHWW");

            var friend = new PapayaFriend(friendUserId, name, avatarUrl, isGamePlayer, foundOnHWW, wasInvited);
            trace("Friend: ", flist[i]);
            
            friends.append(friend);
        }
        
        this.friends = friends;
        
        this.prepareFriends();
    }
    
    public function prepareFriends()
    {

    	for(var i = 0; i < len(this.friends); i++) {
    		var friend = this.friends[i];
    		
	        if(friend.wasInvited == 1) {
	        	trace("Player is invited: ", friend.papayaUserId);
	        	if(friend.isGamePlayer == 0) {
	        		if(friend.foundOnHWW == 1) {
	        			friend.isGamePlayer = 1;
	        		}
	        	}
	        }
    	}

        this.screen.prepareFriendsBelt(this.friends);
    }

    public function inviteFriend(friend)
    {
    	trace("inviteFriend: ", friend, friend.friendUserId);
    	
    	// uncomment for final version
    	ppy_query("send_friend_request", dict("uid", friend.friendUserId), friendInvited, friend);
//    	this.friendInvited(0, 1, 0, friend);
    }

    public function friendInvited(requestId, ret_code, response, friend)
    {
    	var message = "";
    	
        if(ret_code == 0) {
            message = "Invitation failed";
        }
        else {
        	message = "Invitation succeded";
        	
        	if(friend.foundOnHWW == 1) {
        		friend.isGamePlayer = 1;
        	}
        	else {
        		this.friends.remove(friend);
        	}
    		PapayaFriend.addInvitation(friend.papayaUserId);
    		trace("Invitation added", friend.papayaUserId);
        }
        
        this.alert(message, this.prepareFriends);
    }    
}

/*****************************************************************************
Timers
*****************************************************************************/

class mainScreenUpdateTimer extends Timer
{
    var updateFunction;

    public function mainScreenUpdateTimer(functionArg)
    {
        super("mainScreenUpdateTimer", 30, -1);
        this.updateFunction = functionArg;
    }

    override public function tick()
    {
        trace("### HWW ### - checking for new gifts!");
        this.updateFunction();
    }
}
