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
    static var MB_GossipTutorial = 25;
    static var MB_MainTutorial = 26;
    static var MB_HouseSelectionTutorial = 27;
    static var MB_WifeCustomizeTutorial = 28;
    static var MB_HubbySelectionTutorial = 29;

    var type;
    var argument;
    var argument2;

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
            itemRetrieved.texture("images/" + this.argument.image);
            itemRetrieved.prepare();
            var sizeX = itemRetrieved.size()[0];
            var sizeY = itemRetrieved.size()[1];
            trace("### HWW ### - Image size: " + str(sizeX) + ", " + str(sizeY));
            var scaleX = 140 * 100 / sizeX;
            var scaleY = 140 * 100 / sizeY;
            trace("### HWW ### - Image scaled by: " + str(scaleX) + ", " + str(scaleY));
            itemRetrieved.scale(Game.translateX(scaleX), Game.translateY(scaleY));

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
            displayOkayPrompt("Sorry, your husband needs to be higher level to remodel your house.");
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
        else if(this.type == MessageBoxScreen.MB_GossipTutorial) {
            displayOkayPrompt("Here you can gossip and see who the number #1 wife in the game is.");
        }
        else if(this.type == MessageBoxScreen.MB_MainTutorial) {
            displayOkayPrompt("Add friends and send them Gifts or even a trap!");
        }
        else if(this.type == MessageBoxScreen.MB_HouseSelectionTutorial) {
            displayOkayPrompt("Select a house, don't worry you can change it later.");
        }
        else if(this.type == MessageBoxScreen.MB_WifeCustomizeTutorial) {
            displayOkayPrompt("Make her fabulous!");
        }
        else if(this.type == MessageBoxScreen.MB_HubbySelectionTutorial) {
            displayOkayPrompt("Pick a good career!");
        }
    }

    public function displayOkayPrompt(displayText, okayButton = "okay-button-default")
    {
        this.getElement("okayPromptText").setText(displayText);
        this.getElement("okayPrompt").getSprite().visible(1);
        this.getElement(okayButton).getSprite().visible(1);
    }

    public function setOkayPromptTextSize(newSize, style = "bold", align = "center", wrapMode = "wrap")
    {
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
}
