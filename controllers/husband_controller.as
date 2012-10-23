/*****************************************************************************
filename    husband_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
    Husband
*****************************************************************************/

//import framework.screen_controller
import framework.event
import screens.message_box_screen

class HusbandController extends ScreenController implements TimerListener
{
    public function HusbandController(controlledScreen)
    {
        super(controlledScreen);
    }

    override public function screenLoaded()
    {
        trace("Husband screenLoaded! ", Game.sharedGame().hubby.isHome);

        Game.sharedGame().hubby.control = this;

        Timer.registerListener("outToWorkTimer", this);
        Timer.registerListener("outShoppingTimer", this);
    }

    override public function screenUnloaded()
    {
        Timer.unregisterListener("outToWorkTimer", this);
        Timer.unregisterListener("outShoppingTimer", this);
    }

    override public function eventFired(event)
    {
        var promptScreen;

        super.eventFired(event);

        if(event.name == "fillLoveTank") {
            Game.sounds.playSFX("buttonPress");
            this.screen.fillLoveTank();
        }
        else if(event.name == "closeLoveOptions") {
            this.screen.closeLoveOptions();
        }
        else if(event.name == "releaseStress") {
            Game.sounds.playSFX("buttonPress");
            this.screen.releaseStress();
        }
        else if(event.name == "closeStressOptions") {
            this.screen.closeStressOptions();
        }
        else if(event.name == "sendToWork") {
            Game.sounds.playSFX("buttonPress");
            sendHusbandToWork();
        }
        else if(event.name == "sendShopping") {
            Game.sounds.playSFX("buttonPress");
            sendHusbandShopping();
        }
        else if(event.name == "earlyreturn") {

            if(Game.sharedGame().hubby.outShopping == 1) {
                displayOutShoppingPrompt();
            }
            else if(Game.sharedGame().hubby.outWorking == 1) {
                displayOutWorkingPrompt();
            }
        }
        else if(event.name == "workReturn") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
            hreturnwork();
        }
        else if(event.name == "shoppingReturn") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
            hreturnshopping();
        }
        else if(event.name == "dismiss") {
            Game.sounds.playSFX("buttonPress");
            this.dismissModalScreen();
        }
        else if(event.name == "levelUpCheck") {
            this.dismissModalScreen();
            checkForLevelUp();
        }
        else if(event.name == "helpRelieveStress") {
            this.dismissModalScreen();
            this.screen.releaseStress();
        }
        else if(event.name == "helpIncreaseLove") {
            this.dismissModalScreen();
            this.screen.fillLoveTank();
        }
        else if(event.name == "doNothing") {
        }

        var cost;
        var ret;

        if(event.name == "hangOut") {

            if(Game.sharedGame().hubby.stressCooldown != 1) {
                Game.sharedGame().hubby.stressCooldown = 1;
                Game.sounds.playSFX("buttonPress");
                Game.sharedGame().hubby.stressReductionTimer.restart();
                Game.sharedGame().hubby.stressReductionTimer.ticks = 1;
                reduceStressBy(2);
            }
        }
        else if(event.name == "playVideoGames") {
        	
        	if(Game.sharedGame().hubby.stressOption2Cooldown != 1) {
        		Game.sounds.playSFX("buttonPress");

                ret = Game.sharedGame().shop.buyStressRelease("playVideoGames");
                if(ret == 1) {
                	Game.sharedGame().hubby.stressOption2Cooldown = 1;
                	Game.sharedGame().hubby.stressOption2ReductionTimer.restart();
                    Game.sharedGame().hubby.stressOption2ReductionTimer.ticks = 1;
                    reduceStressBy(3);
                }
                else {
                    gotoPremiumCurrencyGameBucks();
                }

                Game.sharedGame().saveHusband();
        	}
        }
        else if(event.name == "watchGame") {
            Game.sounds.playSFX("buttonPress");

            ret = Game.sharedGame().shop.buyStressRelease("watchGame");
            if(ret == 1) {
                reduceStressBy(10);
            }
            else {
                gotoPremiumCurrencyDiamonds();
            }

            Game.sharedGame().saveHusband();
        }
        else if (event.name == "makeFavoriteMeal") {
            if(Game.sharedGame().hubby.loveCooldown != 1) {
                Game.sharedGame().hubby.loveCooldown = 1;
                Game.sounds.playSFX("buttonPress");
                Game.sharedGame().hubby.loveFillingTimer.restart();
                Game.sharedGame().hubby.loveFillingTimer.ticks = 1;
                fillLoveTankBy(2);
            }
        }
        else if (event.name == "giveKiss") {
        	
        	if(Game.sharedGame().hubby.loveOption2Cooldown != 1) {
        		Game.sounds.playSFX("buttonPress");

                ret = Game.sharedGame().shop.buyLoveRefill("giveKiss");
                if(ret == 1) {
                	Game.sharedGame().hubby.loveOption2Cooldown = 1;
                	Game.sharedGame().hubby.loveOption2FillingTimer.restart();
                    Game.sharedGame().hubby.loveOption2FillingTimer.ticks = 1;
                    fillLoveTankBy(3);
                }
                else {
                    gotoPremiumCurrencyGameBucks();
                }

                Game.sharedGame().saveHusband();
        	}
        }
        else if (event.name == "goOnDate") {
            Game.sounds.playSFX("buttonPress");

            ret = Game.sharedGame().shop.buyLoveRefill("goOnDate");
            if(ret == 1) {
                fillLoveTankBy(10);
            }
            else {
                gotoPremiumCurrencyDiamonds();
            }

            Game.sharedGame().saveHusband();
        }
        else if(event.name == "secretButton") {
            Game.sounds.playSFX("buttonPress");
            this.secretPopUp();
        }
    }

    public function reduceStressBy(value)
    {
        // decrease stress
        Game.sharedGame().hubby.stressMeterValue -= value;

        // cap at 0
        if(Game.sharedGame().hubby.stressMeterValue < 0)
            Game.sharedGame().hubby.stressMeterValue = 0;

        Game.sharedGame().saveHusband();
        this.screen.closeStressOptions();

        Game.sounds.playSFX("reward");

        var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Stress_Results, value);
        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
        this.presentModalScreen(promptScreen);
    }

    public function fillLoveTankBy(value)
    {
        // increase love
        Game.sharedGame().hubby.loveTankValue += value;

        // cap at 10
        if(Game.sharedGame().hubby.loveTankValue > 10)
            Game.sharedGame().hubby.loveTankValue = 10;

        Game.sharedGame().saveHusband();
        this.screen.closeLoveOptions();

        Game.sounds.playSFX("reward");

        var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Love_Results, value);
        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
        this.presentModalScreen(promptScreen);
    }

    public function timerFired(timer)
    {
        if(timer.name == "outToWorkTimer") {
            trace("Time to come back from work");
        }
        else if(timer.name == "outShoppingTimer") {
            trace("Time to come back from shopping");
        }
        else if(timer.name == "husbandScreenUpdateTimer") {
            trace("Time to update the husband screen");
        }
    }

    public function sendHusbandToWork()
    {
        trace(Game.sharedGame().hubby.workTimer.getTimeString());
        trace("### HWW ### hubby work trips: " + str(Game.sharedGame().hubby.localVisits));
        trace("### HWW ### req hubby work trips: " + str(Game.sharedGame().hubby.requiredVisits));

        if(Game.sharedGame().hubby.isHome()) {
            var hubbyStress = Game.sharedGame().hubby.stressMeterValue + Game.sharedGame().hubby.getWorkStressPenalty();
            trace("### HWW ### Sending hubby to work will cause stress to be at: " + str(hubbyStress));

            if(hubbyStress <= 10) {
                Game.sharedGame().hubby.updateWorkHours();
                Game.sharedGame().hubby.workTimer.restart();
                Game.sharedGame().hubby.workTimer.ticks = 1;
                Game.sharedGame().hubby.outWorking = 1;
                Game.sharedGame().hubby.stressMeterValue += Game.sharedGame().hubby.getWorkStressPenalty();
                Game.sharedGame().hubby.checkAchievements();
                Game.sharedGame().hubby.save();
            }
            else {
                displayTooStressedPrompt();
            }
        }
        else if(Game.sharedGame().hubby.outWorking){
            displayOutWorkingPrompt();
        }
    }

    public function displayTooStressedPrompt()
    {
        var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Stressed_Out);
        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
        this.presentModalScreen(promptScreen);
    }

    public function sendHusbandShopping()
    {
        if(Game.sharedGame().hubby.isHome()) {
        	var hubbyLove = Game.sharedGame().hubby.loveTankValue - Game.sharedGame().hubby.getShoppingLovePenalty();
        	trace("### HWW ### Sending hubby shopping will cause love to be at: " + str(hubbyLove));
        	
            if(hubbyLove >= 0) {
                Game.sharedGame().hubby.sendShopping();
            }
            else {
                displayOutOfLovePrompt();
            }
        }
        else if(Game.sharedGame().hubby.outShopping){
            displayOutShoppingPrompt();
        }
    }

    public function displayOutOfLovePrompt()
    {
        var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Out_Of_Love);
        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
        this.presentModalScreen(promptScreen);
    }

    public function displayOutShoppingPrompt()
    {
        var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Return_Shopping_Early);
        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
        this.presentModalScreen(promptScreen);
    }

    public function displayOutWorkingPrompt()
    {
        var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Return_Work_Early);
        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
        this.presentModalScreen(promptScreen);
    }

    public function returnFromWorkPrompt()
    {
        this.screen.showNextTutorial();

        var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Return_Work);
        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
        this.presentModalScreen(promptScreen);
    }

    public function checkForLevelUp()
    {
        // check if we leveled up
        if(Game.sharedGame().hubby.careerLevel < 100) {
            if(Game.sharedGame().hubby.localVisits >= Game.sharedGame().hubby.requiredVisits) {
                Game.sharedGame().hubby.levelUp();

                var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Level_Up, Game.sharedGame().hubby);
                promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
                this.presentModalScreen(promptScreen);
            }
        }
    }

    public function thresholdWeighedWithBuff(thrx)
    {
        trace("### HWW ### rareItemThreshold: " + str(Game.sharedGame().husband.rareItemThreshold));
        thrx += Game.sharedGame().husband.rareItemThreshold;
        if(thrx > 100) {
            thrx = 100;
        }
        if(thrx < 1) {
            thrx = 1;
        }

        Game.sharedGame().husband.rareItemThreshold = 0;

        return thrx;
    }

    public function returnFromShoppingPrompt()
    {
        // get a number 1-100
        var itemType = rand(100, 1) + 1;
        var rareness;
        var shoppingItem;
        var commonItems = new Array();
        var rareItems = new Array();
        var veryRareItems = new Array();
        var extremelyRareItems = new Array();
        var selectionRange;
        var selectionIndex;

        this.screen.showNextTutorial();

        //
        var threshold = this.thresholdWeighedWithBuff(itemType);

        // 30% chance to get furniture
       /* if(itemType <= 30) {
            var furnLen = len(Game.sharedGame().furnitureListing);

            trace("### HWW ### - Furniture items: " + str(furnLen));

            // seperate by rarity only allow items the husband is high enough level for and don't cost diamonds
            for(var i = 0; i < furnLen; i++) {
                if(Game.sharedGame().furnitureListing[i].stars == 0 && Game.sharedGame().furnitureListing[i].level <= Game.sharedGame().hubby.careerLevel && Game.sharedGame().furnitureListing[i].diamonds == 0)
                    commonItems.append(Game.sharedGame().furnitureListing[i]);
                if(Game.sharedGame().furnitureListing[i].stars == 1 && Game.sharedGame().furnitureListing[i].level <= Game.sharedGame().hubby.careerLevel && Game.sharedGame().furnitureListing[i].diamonds == 0)
                    rareItems.append(Game.sharedGame().furnitureListing[i]);
                if(Game.sharedGame().furnitureListing[i].stars == 2 && Game.sharedGame().furnitureListing[i].level <= Game.sharedGame().hubby.careerLevel && Game.sharedGame().furnitureListing[i].diamonds == 0)
                    veryRareItems.append(Game.sharedGame().furnitureListing[i]);
                if(Game.sharedGame().furnitureListing[i].stars == 3 && Game.sharedGame().furnitureListing[i].level <= Game.sharedGame().hubby.careerLevel && Game.sharedGame().furnitureListing[i].diamonds == 0)
                    extremelyRareItems.append(Game.sharedGame().furnitureListing[i]);
            }

            trace("### HWW ### - common items: " + str(len(commonItems)));
            trace("### HWW ### - rareItems: " + str(len(rareItems)));
            trace("### HWW ### - veryRareItems: " + str(len(veryRareItems)));
            trace("### HWW ### - extremelyRareItems: " + str(len(extremelyRareItems)));


            // check if husband is of level required
            var itemLevel = 999;
            rareness = rand(100, 2) + 1;
            rareness += threshold;

            if(rareness > 97 && len(extremelyRareItems) > 0) {
                selectionRange = len(extremelyRareItems);
                selectionIndex = rand(selectionRange, 3);
                shoppingItem = extremelyRareItems[selectionIndex];

                //ppy_postnewsfeed(Game.sharedGame().wife.name + "'s hubby " + Game.sharedGame().hubby.name + " has come home with an extremely rare item.", "http://www.2clams.com", null);
            }
            else if(rareness > 90 && len(veryRareItems) > 0) {
                selectionRange = len(veryRareItems);
                selectionIndex = rand(selectionRange, 3);
                shoppingItem = veryRareItems[selectionIndex];

                //ppy_postnewsfeed(Game.sharedGame().wife.name + "'s hubby " + Game.sharedGame().hubby.name + " has come home with a very rare item.", "http://www.2clams.com", null);
            }
            else if(rareness > 70 && len(veryRareItems) > 0) {
                selectionRange = len(rareItems);
                selectionIndex = rand(selectionRange, 3);
                shoppingItem = rareItems[selectionIndex];

                //ppy_postnewsfeed(Game.sharedGame().wife.name + "'s hubby " + Game.sharedGame().hubby.name + " has come home with a rare item.", "http://www.2clams.com", null);
            }
            else {
                selectionRange = len(commonItems);
                selectionIndex = rand(selectionRange, 3);
                shoppingItem = commonItems[selectionIndex];
            }

            trace("### HWW ### - Item rarity: " + str(rareness));
            itemLevel = shoppingItem.level;

            trace("### HWW ### - Item retrieved: " + str(shoppingItem.name) + " - " + str(shoppingItem.id))
            trace("### HWW ### - Retrieved furniture item requiring level: " + str(itemLevel));
            trace("### HWW ### - Husband is level: " + str(Game.sharedGame().hubby.careerLevel));

            Game.sharedGame().house.saveNewStorageItem(shoppingItem);
            Game.sounds.playSFX("gainSSP");
            Game.sharedGame().wife.incSocialStatusPoints(shoppingItem.points);
        }
        */
        // 70% chance to get a mystery item
        //else {
            var miLen = len(Game.sharedGame().mysteryItems);
            rareness = rand(100, 4) + 1;
            rareness += threshold;
            var mysteryItemsMap = Game.sharedGame().mysteryItems; 
            trace("mystery items map ", mysteryItemsMap);
            var mysteryItemsKeys = mysteryItemsMap.keys();
            trace("mystery keys ", mysteryItemsKeys);

            // seperate by rarity
            for(var j = 0; j < miLen; j++) {
                var mysteryItemKey = mysteryItemsKeys[j];
                trace("mystery key ", mysteryItemKey);
                var mysteryItem = mysteryItemsMap.get(mysteryItemKey);
                trace("found mystery item: ", mysteryItem);
                if(mysteryItem.stars == 0)
                    commonItems.append(mysteryItem);
                if(mysteryItem.stars == 1)
                    rareItems.append(mysteryItem);
                if(mysteryItem.stars == 2)
                    veryRareItems.append(mysteryItem);
                if(mysteryItem.stars == 3)
                    extremelyRareItems.append(mysteryItem);
            }

            trace("### HWW ### - common items: " + str(len(commonItems)));
            trace("### HWW ### - rareItems: " + str(len(rareItems)));
            trace("### HWW ### - veryRareItems: " + str(len(veryRareItems)));
            trace("### HWW ### - extremelyRareItems: " + str(len(extremelyRareItems)));

            if(rareness > 97 && len(extremelyRareItems) > 0) {
                selectionRange = len(extremelyRareItems);
                selectionIndex = rand(selectionRange, 5);
                shoppingItem = extremelyRareItems[selectionIndex];

                //ppy_postnewsfeed(Game.sharedGame().wife.name + "'s hubby " + Game.sharedGame().hubby.name + " has come home with an extremely rare item.", "http://www.2clams.com", null);
            }
            else if(rareness > 90 && len(veryRareItems) > 0) {
                selectionRange = len(veryRareItems);
                selectionIndex = rand(selectionRange, 5);
                shoppingItem = veryRareItems[selectionIndex];

                //ppy_postnewsfeed(Game.sharedGame().wife.name + "'s hubby " + Game.sharedGame().hubby.name + " has come home with a very rare item.", "http://www.2clams.com", null);
            }
            else if(rareness > 70 && len(veryRareItems) > 0) {
                selectionRange = len(rareItems);
                selectionIndex = rand(selectionRange, 5);
                shoppingItem = rareItems[selectionIndex];

                //ppy_postnewsfeed(Game.sharedGame().wife.name + "'s hubby " + Game.sharedGame().hubby.name + " has come home with a rare item.", "http://www.2clams.com", null);
            }
            else {
                selectionRange = len(commonItems);
                selectionIndex = rand(selectionRange, 5);
                shoppingItem = commonItems[selectionIndex];
            }

            Game.sharedGame().wife.awardMysteryItem(shoppingItem);
            Game.sharedGame().wife.save();
            
            if(Game.sharedGame().darkSide.checkRequirements() == 1) {
            	this.showDarkSidePrompt();
            }

            Game.sounds.playSFX("gainSSP");
        //}

        var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Hubby_Return_Shopping, shoppingItem);
        promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
        this.presentModalScreen(promptScreen);
    }
    
    public function showDarkSidePrompt()
    {
    	if(Game.sharedGame().darkSide.challengeAccepted() == 0) {
    		this.showMessageBox(MessageBoxScreen.MB_DarkSideChallenge, this.showDarkSideLetter);
    	}
    	else {
    		this.showDarkSideScreen();
    	}
    }
    
    public function showDarkSideLetter()
    {
    	Game.sharedGame().darkSide.acceptChallenge();
    	
    	this.showMessageBox(MessageBoxScreen.MB_DarkSideLetter, this.showDarkSideScreen);
    }
    
    public function showDarkSideScreen()
    {    	
    	var screen = new DarkSideScreen();
        screen.configFile = "screen-cfgs/darkside-screen-cfg.xml";
        var controller = new DarkSideController(screen);
        Game.pushScreen(screen);        
    }

    public function secretPopUp()
    {
    	if(Game.sharedGame().darkSide.checkRequirements() == 0) {
            var promptScreen = new MessageBoxScreen(MessageBoxScreen.MB_Secret);
            promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
            this.presentModalScreen(promptScreen);
    	}
    	else {
    		if(Game.sharedGame().darkSide.challengeAccepted() == 0) {
	    		this.showDarkSidePrompt();
    		}
	    	if(Game.sharedGame().darkSide.isActive == 1) {
	    		this.showDarkSideScreen();
	    	}
    	}
    }
}

/*****************************************************************************
    Message Box Functions
*****************************************************************************/

function hcantcomplete(x)
{
    trace("husband unable to complete action");
}

function hcancel(x)
{
    trace("action canceled");
}

function hreturnwork()
{
    if(Game.sharedGame().hubby.isHome() == 0) {
        var ret = Game.currentGame.shop.buyImmediateReturn("Work");
        if(ret == 1) {
            Game.sharedGame().hubby.returnFromWork();
            trace("returned from work");
        }
        else {
            gotoPremiumCurrencyDiamonds();
        }
    }
}

function hreturnshopping()
{
    if(Game.sharedGame().hubby.isHome() == 0) {
        var ret = Game.currentGame.shop.buyImmediateReturn("Shopping");
        if(ret == 1) {
            Game.sharedGame().hubby.returnFromShopping();
            trace("returned from shopping");
        }
        else {
            gotoPremiumCurrencyDiamonds();
        }
    }
}

function gotoPremiumCurrencyDiamonds()
{
    var screen = new PremiumCurrencyScreen("viewDiamond");
    screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
    var controller = new PremiumCurrencyController(screen);

    Game.pushScreen(screen);
}

function gotoPremiumCurrencyGameBucks()
{
    var screen = new PremiumCurrencyScreen("viewGameBucks");
    screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
    var controller = new PremiumCurrencyController(screen);

    Game.pushScreen(screen);
}

/*****************************************************************************
    Timers
*****************************************************************************/

class husbandStressReductionTimer extends Timer
{
    public function husbandStressReductionTimer()
    {
        super("husbandStressReductionTimer", 1800, 1);
    }

    override public function tick()
    {
        if(this.ticks > 0) {
            Game.sharedGame().hubby.stressCooldown = 0;
            Game.sharedGame().hubby.save();
        }
    }
}

class husbandStressOption2ReductionTimer extends Timer
{
    public function husbandStressOption2ReductionTimer()
    {
        super("husbandStressOption2ReductionTimer", 300, 1);
    }

    override public function tick()
    {
        if(this.ticks > 0) {
            Game.sharedGame().hubby.stressOption2Cooldown = 0;
            Game.sharedGame().hubby.save();
        }
    }
}

class husbandLoveFillingTimer extends Timer
{
    public function husbandLoveFillingTimer()
    {
        super("husbandLoveFillingTimer", 1800, 1);
    }

    override public function tick()
    {
        if(this.ticks > 0) {
            Game.sharedGame().hubby.loveCooldown = 0;
            Game.sharedGame().hubby.save();
        }
    }
}

class husbandLoveOption2FillingTimer extends Timer
{
    public function husbandLoveOption2FillingTimer()
    {
        super("husbandLoveOption2FillingTimer", 300, 1);
    }

    override public function tick()
    {
        if(this.ticks > 0) {
            Game.sharedGame().hubby.loveOption2Cooldown = 0;
            Game.sharedGame().hubby.save();
        }
    }
}
