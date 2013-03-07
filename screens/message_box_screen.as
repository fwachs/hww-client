/*****************************************************************************
filename    message_box_screen.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:

*****************************************************************************/

//import framework.screen

class MessageBoxScreen extends Screen
{
    static var MB_Hubby_Return_Work = 1;
    static var MB_Hubby_Return_Shopping = 2;
    static var MB_Hubby_Return_Work_Early = 3;
    static var MB_Hubby_Return_Shopping_Early = 4;
    static var MB_Hubby_Stress_Results = 5;
    static var MB_Hubby_Love_Results = 6;
    static var MB_Hubby_Level_Up = 7;
    static var MB_Travel_Return = 8;
    static var MB_Secret = 9;
    static var MB_RemodelHousePrompt = 10;
    static var MB_CantUnlockRemodel = 11;
    static var MB_Hubby_Stressed_Out = 12;
    static var MB_Hubby_Out_Of_Love = 13;
    static var MB_HouseTutorial = 14;
    static var MB_Insufficient_Miles = 15;
    static var MB_Insufficient_Papayas = 16;
    static var MB_OutWorkTutorial = 17;
    static var MB_OutWorkShopping = 18;
    static var MB_CantOpenGift = 19;
    static var MB_Travel_Sydney = 20;
    static var MB_House_Select_Insufficient_Level = 21;
    static var MB_TravelTutorial = 22;
    static var MB_HusbandTutorial = 23;
    static var MB_MysteryTutorial = 24;
    static var MB_MainTutorial = 25;
    static var MB_Exit = 26;
    static var MB_GotBusted = 27;
    static var MB_DarkSideChallenge = 28;
    static var MB_DarkSideLetter = 29;
    static var MB_BasicAccept = 30;
    static var MB_SellFurniture = 31;
    static var MB_UnlockCatalog = 32;
    static var MB_LockedCatalog = 33;
    static var MB_ClothingValidation = 34;
    static var MB_OutShoppingTutorial = 35;
    static var MB_UpdateGame = 36;

    var type;
    var argument;
    var argument2;
    var okCallBack;
    var cancelCallBack;

    public function MessageBoxScreen(newType, arg = null)
    {
        super();
        this.type = newType;
        this.argument = arg;
    }

    override public function build()
    {
        if(this.type == MessageBoxScreen.MB_Hubby_Return_Work) {
            this.getElement("ReturnFromWorkingPrompt").getSprite().visible(1);
            this.getElement("gameBucksLable").getSprite().addlabel(str(Game.sharedGame().hubby.salary * Game.sharedGame().hubby.salaryFactor) + " Game Bucks", Game.getFont(), Game.translateFontSize(42));
            this.getElement("sspLable").getSprite().addlabel(str(Game.sharedGame().hubby.workSSPReturn) + " Social Status Points", Game.getFont(), Game.translateFontSize(42));
        }
        else if(this.type == MessageBoxScreen.MB_Hubby_Return_Shopping) {
            this.getElement("ReturnFromShoppingPrompt").getSprite().visible(1);
            var itemRetrieved = this.getElement("itemRetrieved").getSprite();
            itemRetrieved.size(140, 140);
            itemRetrieved.texture("images/" + this.argument.image);
            
            /*
            itemRetrieved.prepare();
            var sizeX = itemRetrieved.size()[0];
            var sizeY = itemRetrieved.size()[1];
            trace("### HWW ### - Image size: " + str(sizeX) + ", " + str(sizeY));
            var scaleX = 140 * 100 / sizeX;
            var scaleY = 140 * 100 / sizeY;
            trace("### HWW ### - Image scaled by: " + str(scaleX) + ", " + str(scaleY));
            itemRetrieved.scale(Game.translateX(scaleX), Game.translateY(scaleY));
            */

            var shoppingText = this.getElement("shoppingText");
            shoppingText.setText("Look what I got for you!");
            shoppingText.setFont(Game.font.getFont(), Game.translateFontSize(48));

            var shoppingItemText = this.getElement("shoppingItemText");
            shoppingItemText.setText(str(this.argument.name));
            shoppingItemText.setFont(Game.font.getFont(), Game.translateFontSize(36));

            if(this.argument.stars == 1) {
                this.getElement("star1").getSprite().texture("images/hubby-screen/item-star.png");
            }
            if(this.argument.stars == 2) {
                this.getElement("star1").getSprite().texture("images/hubby-screen/item-star.png");
                this.getElement("star2").getSprite().texture("images/hubby-screen/item-star.png");
            }
            if(this.argument.stars == 3) {
                this.getElement("star1").getSprite().texture("images/hubby-screen/item-star.png");
                this.getElement("star2").getSprite().texture("images/hubby-screen/item-star.png");
                this.getElement("star3").getSprite().texture("images/hubby-screen/item-star.png");
            }
        }
        else if(this.type == MessageBoxScreen.MB_Hubby_Return_Work_Early) {
            displayConfirmCancelPrompt("images/hubby-screen/gone-to-work-text.png", "confirm-button-work-return");
        }
        else if(this.type == MessageBoxScreen.MB_Hubby_Return_Shopping_Early) {
            displayConfirmCancelPrompt("images/hubby-screen/gone-shopping-text.png", "confirm-button-shopping-return");
        }
        else if(this.type == MessageBoxScreen.MB_Hubby_Stress_Results) {
            displayOkayPrompt("You lowered his stress by " + str(argument) + " and he's more relaxed now!");
            this.getElement("okayPromptFrame").getSprite().texture("images/hubby-screen/results-box/stress-result-frame-alt.png");
        }
        else if(this.type == MessageBoxScreen.MB_Hubby_Love_Results) {
            displayOkayPrompt("You filled his love tank by " + str(argument) + " and he's more relaxed now!");
            this.getElement("okayPromptFrame").getSprite().texture("images/hubby-screen/results-box/love-result-frame-alt.png");
        }
        else if(this.type == MessageBoxScreen.MB_Hubby_Level_Up) {
            displayOkayPrompt("Congrats! you are now level " + str(this.argument.careerLevel) + " and make " + str(this.argument.salary) + "GB");
        }
        else if(this.type == MessageBoxScreen.MB_Travel_Return) {
            this.getElement("TravelReturnPrompt").getSprite().visible(1);
        }
        else if(this.type == MessageBoxScreen.MB_Secret) {
            displayOkayPrompt("");
            this.getElement("okayPromptFrame").getSprite().texture("images/hubby-screen/secret-popup.png");
        }
        else if(this.type == MessageBoxScreen.MB_RemodelHousePrompt) {
            this.getElement("remodelCost").setText(str(this.argument.diamonds));
            this.getElement("RemodelHousePrompt").getSprite().visible(1);
        }
        else if(this.type == MessageBoxScreen.MB_CantUnlockRemodel) {
            var unlockLevel = Game.sharedGame().house.getNextRemodelLevel(); 
            displayOkayPrompt("Your husband needs to be level " + str(unlockLevel) + " to remodel.");
        }
        else if(this.type == MessageBoxScreen.MB_Hubby_Stressed_Out) {
            displayOkayPrompt("He's too stressed out to work! Help him relax?", "okay-button-relieve-stress");
        }
        else if(this.type == MessageBoxScreen.MB_Hubby_Out_Of_Love) {
            displayOkayPrompt("He's all out of love and so lost without you! Show him you care?", "okay-button-increase-love");
        }
        else if(this.type == MessageBoxScreen.MB_HouseTutorial) {
            displayTutorialPrompt("images/tutorial-icons/decorate-tutorial.png");
        }
        else if(this.type == MessageBoxScreen.MB_Insufficient_Miles) {
            displayOkayPrompt("You don't have enough miles. Earn more miles by staying online.");
            setOkayPromptPosition(361, 163);
            setOkayPromptTextSize(48);
        }
        else if(this.type == MessageBoxScreen.MB_Insufficient_Papayas) {
            displayOkayPrompt("You do not have enough papayas.");
        }
        else if(this.type == MessageBoxScreen.MB_OutWorkTutorial) {
            displayOkayPrompt("Text for the going to work tutorial.", "okay-button-work-tutorial");
        }
        else if(this.type == MessageBoxScreen.MB_OutShoppingTutorial) {
            displayOkayPrompt("Text for the going shopping tutorial.", "okay-button-shopping-tutorial");
        }
        else if(this.type == MessageBoxScreen.MB_CantOpenGift) {
            displayOkayPrompt("Sorry, you can only have one gift or trap open at a time.");
        }
        else if(this.type == MessageBoxScreen.MB_Travel_Sydney) {
            displayOkayPrompt("Become a Jet Setter first.");
            setOkayPromptPosition(361, 163);
            setOkayPromptTextSize(48);
        }
        else if(this.type == MessageBoxScreen.MB_House_Select_Insufficient_Level) {
            displayOkayPrompt("Sorry, your husband level is not high enough to purchase this home.");
            setOkayPromptTextSize(48);
        }
        else if(this.type == MessageBoxScreen.MB_TravelTutorial) {
            displayTutorialPrompt("images/tutorial-icons/travel-tutorial.png");
        }
        else if(this.type == MessageBoxScreen.MB_HusbandTutorial) {
            displayTutorialPrompt("images/tutorial-icons/husband-tutorial.png");
        }
        else if(this.type == MessageBoxScreen.MB_MysteryTutorial) {
            displayTutorialPrompt("images/tutorial-icons/mystery-tutorial.png");
        }
        else if(this.type == MessageBoxScreen.MB_MainTutorial) {
        	displayTutorialPrompt("images/tutorial-icons/mainmenu-tutorial-01.png");
        }
        else if(this.type == MessageBoxScreen.MB_Exit) {
        	displayOkayPrompt("Are you sure you want to quit Housewife Wars?", "okay-button-exit");
        	this.getElement("cancel-button-dismiss").getSprite().visible(1);
        }
        else if(this.type == MessageBoxScreen.MB_GotBusted) {
            displayOkayPrompt("");
            this.getElement("okayPromptFrame").getSprite().texture("images/dark-side/bail-out-full.png");
            this.getElement("okay-button-default").getSprite().pos(Game.translateX(641), Game.translateY(524));
        }
        else if(this.type == MessageBoxScreen.MB_DarkSideChallenge) {
            displayDarkSideChallengePrompt();
        }
        else if(this.type == MessageBoxScreen.MB_DarkSideLetter) {
            displayOkayPrompt("", "okay-button-dark-side-letter");
            var promptBG = this.getElement("okayPromptFrame").getSprite();
            promptBG.texture("images/dark-side/darkside-intro-02.png");
            promptBG.pos(0, 0);
        }
        else if(this.type == MessageBoxScreen.MB_BasicAccept) {
            displayOkayPrompt(this.argument, "okay-button-alert");
        }
        else if(this.type == MessageBoxScreen.MB_SellFurniture) {
        	displaySellItemPrompt();
        } else if (this.type == MessageBoxScreen.MB_UnlockCatalog) {
            displayOkayPrompt("Congratulations! You unlocked the " + str(this.argument) + " Fashion Catalog");
        } else if (this.type == MessageBoxScreen.MB_LockedCatalog) {
            displayOkayPrompt("Visit "+ this.argument + " and see all the sights first.");
        } else if (this.type == MessageBoxScreen.MB_ClothingValidation) {
            displayOkayPrompt("Too much skin showing! Put on a top, a bottom and some shoes before you leave.");
        } else if (this.type == MessageBoxScreen.MB_UpdateGame) {
            displayOkayPrompt("Please update your game through Google store, othewise you can't come in!");
        }
    }

    public function displayDarkSideChallengePrompt()
    {
        this.getElement("darkSideChallengePrompt").getSprite().visible(1);
    }
    
    public function displayOkayPrompt(displayText, okayButton = "okay-button-default")
    {
        this.getElement("okayPromptText").setText(displayText);
        this.getElement("okayPrompt").getSprite().visible(1);
        this.getElement(okayButton).getSprite().visible(1);
    }

    public function setOkayPromptTextSize(newSize)
    {
    	var style = "bold";
    	var align = "center";
    	var wrapMode = "wrap";
    	
        var okayPromptText = this.getElement("okayPromptText");
        okayPromptText.setFont(Game.font.getFont(), Game.translateFontSize(newSize), style, align, wrapMode);
    }

    public function setOkayPromptPosition(posX, posY)
    {
        var okayPromptText = this.getElement("okayPromptText").getSprite();
        okayPromptText.pos(Game.translateX(posX), Game.translateY(posY));
    }

    public function displayConfirmCancelPrompt(bakedText, confirmButton = "confirm-button-default")
    {
        this.getElement("confirmCancelPromptBakedText").getSprite().texture(bakedText);
        this.getElement("confirmCancelPrompt").getSprite().visible(1);
        this.getElement(confirmButton).getSprite().visible(1);
    }

    public function displayTutorialPrompt(tutorialImage)
    {
        this.getElement("tutorialPrompt").getSprite().texture(tutorialImage);
        this.getElement("tutorialPrompt").getSprite().visible(1);
    }

    public function displaySellItemPrompt()
    {
		var furniture = this.argument.furnitureType;
		var price = furniture.gameBucks / 10;
		
        this.getElement("sellFurniturePrompt").getSprite().visible(1);
        this.getElement("sellItemImage").getSprite().texture("images/" + furniture.image);
        this.getElement("sellItemCostText").setText(str(price));
    }
}
