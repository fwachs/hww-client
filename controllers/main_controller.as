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
import screens.missions_screen
import screens.tournament_screen
import screens.reward_screen

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

        this.screenUpdateTimer = new mainScreenUpdateTimer(this);
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
                url = "https://play.google.com/store/apps/details?id=com.twoclams.hww.android.dx.live";
            }
            Game.sharedGame().rateReward();
            openUrl(url);
        }
        else if (event.name == "restorePurchases") {
            InAppHelper.restorePurchases();
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
    		this.screen.getElement("closeDailyBonusButton").getSprite().visible(0);
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
        else if (event.name == "collectReward") {
            Game.sounds.playSFX("buttonPress");
            var storedRewards = Game.getDatabase().get("storedRewards");
            trace("storedRewards before pop: ", storedRewards);
            var reward = storedRewards.pop(0); 
            var amount = reward.get("amount");
            var currency = reward.get("currency");
            if (amount != null && currency != null) {
                var freeMoney = Game.currentGame.wallet.moneyForCurrency(amount, currency);
                Game.currentGame.wallet.collect(freeMoney);
            }
            trace("storedRewards after pop: ", storedRewards);
            Game.getDatabase().put("storedRewards", storedRewards);
            this.dismissModalScreen();
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

        var storedRewards = Game.getDatabase().get("storedRewards");
        if (storedRewards != null && len(storedRewards)>0)
        {
            trace("showing storedRewards: ", storedRewards);
            var rewardScreen = new RewardScreen(storedRewards[0]);
            rewardScreen.configFile = "screen-cfgs/reward-prompt-cfg.xml";
            this.presentModalScreen(rewardScreen);
        }
    }

    public function loadFriends()
    {
        if (Game.socialId == 0) {
            var fbLogin = FacebookApi.loginView(10, 35, 104, 35, 
                    this.facebookLoginCallback, this.facebookLogoutCallback);
            this.buildFriendCallback(0, 0, 0);
            var fbContainer = this.screen.getElement("fbContainer");
            fbContainer.getSprite().add(fbLogin);
            fbContainer.getSprite().visible(1);
            this.screen.getElement("friendsScroll").getSprite().add(fbContainer.getSprite());
        } else {
            FacebookApi.request("me/friends?fields=installed", dict(), buildFriendCallback);
        }
    }

    public function facebookLoginCallback(facebookId) {
        Game.sharedGame().updateSocialId(facebookId);
        var fbContainer = this.screen.getElement("fbContainer");
        fbContainer.getSprite().visible(0);
        FacebookApi.request("me/friends?fields=installed", dict(), buildFriendCallback);
    }

    public function facebookLogoutCallback() {
        Game.sharedGame().updateSocialId(0);
    }

    public function buildFriendCallback(ret_code, response, param)
    {
        if(ret_code == 0) {
            this.screen.prepareFriendsBelt(new Array());
            return;
        }

        var data = response.get("data");
        var coolFriends = new Array();
        for (var i=0; i< len(data); i++) {
            var coolFriend = dict();
            coolFriend.update("id", data[i].get("id"));
            coolFriend.update("name", data[i].get("name"));
            var pictureDict = data[i].get("picture");
            var url = pictureDict.get("data").get("url");
            coolFriend.update("avatar_version", url);
            var installed = data[i].get("installed");
            if (installed == "1") {
                log(data[i].get("name"), " installed: ", installed);
                coolFriend.update("foundOnHWW", 1);
                coolFriends.append(coolFriend);
            }
        }
        
        this.buildFriends(coolFriends);
    }
    
    public function buildFriends(flist)
    {
    	
        this.screen.getElement("friendsBeltContainer").getSprite().visible(1);

        var friends = new Array();
        for (var i=0; i< len(flist); i++) {
            var friendUserId = flist[i].get("id");
            var name = flist[i].get("name");
            var avatarUrl= flist[i].get("avatar_version");
            log(name, " installed: ", 1);
            var friend = new PapayaFriend(friendUserId, name, avatarUrl, 1, 1, 0);
            friends.append(friend);
        }
        
        this.friends = friends;
        
        this.prepareFriends();
    }
    
    public function prepareFriends()
    {
        this.screen.prepareFriendsBelt(this.friends);
    }

    public function inviteFriend(friend)
    {
    	FacebookApi.dialog("Come play the Fabulous Life now!", dict(), friendInvited, friend);
    }

    public function friendInvited(requestId, ret_code, response, friend)
    {
    	var message = "";
        if(ret_code == 0) {
            message = "An error ocurred while trying to send the invites...";
            this.alert(message, this.prepareFriends);
        }
    }    
}

/*****************************************************************************
Timers
*****************************************************************************/

class mainScreenUpdateTimer extends Timer
{
    var controller;

    public function mainScreenUpdateTimer(controller)
    {
        super("mainScreenUpdateTimer", 30, -1);
        this.controller = controller;
    }

    override public function tick()
    {
        trace("### HWW ### - checking for new gifts!");
        controller.checkForGifts();
    }
}
