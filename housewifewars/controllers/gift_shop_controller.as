/*****************************************************************************
filename    gift_shop_controller.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

//import framework.screen_controller
import framework.event
import screens.passport_screen
import controllers.passport_controller

class GiftShopController extends ScreenController
{	
	static var travelDestination;
	var promptFunction;
	var achievementIcon;
	var itemNameText;
	var itemDescriptionText;
	var diamondCost;
	
	public function GiftShopController(controlledScreen)
	{
		super(controlledScreen);
	}
	
	override public function screenLoaded()
	{
		trace("GiftShopController screenLoaded!");
		trace(Game.font.getFont());
		
		promptFunction = null;
		achievementIcon = this.screen.getElement("achievementIcon").getSprite();
		itemNameText = this.screen.getElement("itemNameText");
		itemDescriptionText = this.screen.getElement("itemDescriptionText");
		diamondCost = this.screen.getElement("diamondCost");
		
		if(Game.sharedGame().passport.citiesVisited == 1)
			Game.sharedGame().unlockAchievement("Tourist");
		
		if(Game.sharedGame().passport.citiesVisited == 5) {
			Game.sharedGame().unlockAchievement("Jet Setter");
		}
		
		if(Game.sharedGame().passport.citiesVisited == 6) {
			Game.sharedGame().unlockAchievement("Sheila");
		}

		if(GiftShopController.travelDestination == "London") {
			this.screen.getElement("LondonFrame").getSprite().visible(1);
			this.screen.getElement("LondonFrame").getSprite().addaction(repeat(moveby(83, 2, -2), moveby(83, 2, 0), moveby(83, 2, 2), moveby(83, -2, 2), moveby(83, -4, -2)));
		}
		else {
			this.screen.getElement("LondonFrame").getSprite().visible(0);
		}
		
		if(GiftShopController.travelDestination == "SanFrancisco") {
			this.screen.getElement("SanFranciscoFrame").getSprite().visible(1);
			this.screen.getElement("SanFranciscoFrame").getSprite().addaction(repeat(moveby(83, 2, -2), moveby(83, 2, 0), moveby(83, 2, 2), moveby(83, -2, 2), moveby(83, -4, -2)));
		}
		else {
			this.screen.getElement("SanFranciscoFrame").getSprite().visible(0);
		}
		
		if(GiftShopController.travelDestination == "Paris") {
			this.screen.getElement("ParisFrame").getSprite().visible(1);
			this.screen.getElement("ParisFrame").getSprite().addaction(repeat(moveby(83, 2, -2), moveby(83, 2, 0), moveby(83, 2, 2), moveby(83, -2, 2), moveby(83, -4, -2)));
		}
		else {
			this.screen.getElement("ParisFrame").getSprite().visible(0);
		}
		
		if(GiftShopController.travelDestination == "BuenosAires") {
			this.screen.getElement("BuenosAiresFrame").getSprite().visible(1);
			this.screen.getElement("BuenosAiresFrame").getSprite().addaction(repeat(moveby(83, 2, -2), moveby(83, 2, 0), moveby(83, 2, 2), moveby(83, -2, 2), moveby(83, -4, -2)));
		}
		else {
			this.screen.getElement("BuenosAiresFrame").getSprite().visible(0);
		}
		
		if(GiftShopController.travelDestination == "Tokyo") {
			this.screen.getElement("TokyoFrame").getSprite().visible(1);
			this.screen.getElement("TokyoFrame").getSprite().addaction(repeat(moveby(83, 2, -2), moveby(83, 2, 0), moveby(83, 2, 2), moveby(83, -2, 2), moveby(83, -4, -2)));
		}
		else {
			this.screen.getElement("TokyoFrame").getSprite().visible(0);
		}
		
		if(GiftShopController.travelDestination == "Sydney") {
			this.screen.getElement("SydneyFrame").getSprite().visible(1);
			this.screen.getElement("SydneyFrame").getSprite().addaction(repeat(moveby(83, 2, -2), moveby(83, 2, 0), moveby(83, 2, 2), moveby(83, -2, 2), moveby(83, -4, -2)));
		}
		else {
			this.screen.getElement("SydneyFrame").getSprite().visible(0);
		}
		
		checkForPoppedBalloons();
	}
	
	override public function eventFired(event)
	{
		super.eventFired(event);
		
		if(event.name == "buysouvenir1") {
			Game.sounds.playSFX("generalCollection");
			
			this.screen.getElement("buySouvenirPrompt").getSprite().visible(1);
			promptFunction = hBuySouvenir1;
			diamondCost.setText(str(Game.sharedGame().shop.getSouvenirCost(GiftShopController.travelDestination, 1)));
			
			if(GiftShopController.travelDestination == "London") {
				achievementIcon.texture("images/gift-shop-icons/bulldog.png");
				itemNameText.setText("Bulldog");
				itemDescriptionText.setText("A breed for distinguished people such as yourself.");
			}
			else if(GiftShopController.travelDestination == "SanFrancisco") {
				achievementIcon.texture("images/gift-shop-icons/sourdough-bread.png");
				itemNameText.setText("Sourdough Bread");
				itemDescriptionText.setText("This distinctive bread is a true San Francisco favorite.");
			}
			else if(GiftShopController.travelDestination == "Paris") {
				achievementIcon.texture("images/gift-shop-icons/baguette.png");
				itemNameText.setText("Baguette");
				itemDescriptionText.setText("Oui! Oui! Something so simple yet so wonderful to eat. ");
			}
			else if(GiftShopController.travelDestination == "BuenosAires") {
				achievementIcon.texture("images/gift-shop-icons/el-obelisco.png");
				itemNameText.setText("El Obelisco");
				itemDescriptionText.setText("Show off your historical side by visiting this monument in the financial district.");
			}
			else if(GiftShopController.travelDestination == "Tokyo") {
				achievementIcon.texture("images/gift-shop-icons/sushi.png");
				itemNameText.setText("Sushi");
				itemDescriptionText.setText("Can heaven be found in a single bite? It can in Tokyo.");
			}
			else if(GiftShopController.travelDestination == "Sydney") {
				achievementIcon.texture("images/gift-shop-icons/koala.png");
				itemNameText.setText("Koala");
				itemDescriptionText.setText("Soft and cuddly, aren't these illegal to bring home? Not for a jetsetter");
			}
		}
		else if(event.name == "buysouvenir2") {
			Game.sounds.playSFX("generalCollection");
			
			this.screen.getElement("buySouvenirPrompt").getSprite().visible(1);
			promptFunction = hBuySouvenir2;
			diamondCost.setText(str(Game.sharedGame().shop.getSouvenirCost(GiftShopController.travelDestination, 2)));
			
			if(GiftShopController.travelDestination == "London") {
				achievementIcon.texture("images/gift-shop-icons/gin.png");
				itemNameText.setText("Gin");
				itemDescriptionText.setText("A bottle of their finest for that upcoming cocktail party you're hosting.");
			}
			else if(GiftShopController.travelDestination == "SanFrancisco") {
				achievementIcon.texture("images/gift-shop-icons/gg-bridge.png");
				itemNameText.setText("GG Bridge Picture");
				itemDescriptionText.setText("Your visit to the Golden Gate begs the question, which is more popular?");
			}
			else if(GiftShopController.travelDestination == "Paris") {
				achievementIcon.texture("images/gift-shop-icons/eiffel-tower.png");
				itemNameText.setText("Eiffel Tower Picture");
				itemDescriptionText.setText("Visit this romantic landmark and rekindle the fires with your husband or that cute guy at the patisserie.");
			}
			else if(GiftShopController.travelDestination == "BuenosAires") {
				achievementIcon.texture("images/gift-shop-icons/do-the-tango.png");
				itemNameText.setText("Tango");
				itemDescriptionText.setText("Discover the passion of the most forbidden of dances.");
			}
			else if(GiftShopController.travelDestination == "Tokyo") {
				achievementIcon.texture("images/gift-shop-icons/sake.png");
				itemNameText.setText("Sake");
				itemDescriptionText.setText("A sip here, a sip there and you'll think you're turning Japanese.");
			}
			else if(GiftShopController.travelDestination == "Sydney") {
				achievementIcon.texture("images/gift-shop-icons/opera-house.png");
				itemNameText.setText("Opera House");
				itemDescriptionText.setText("Opera never looked this good! The Aussies know how to take high culture even higher.");
			}
		}
		else if(event.name == "buysouvenir3") {
			Game.sounds.playSFX("generalCollection");
			
			this.screen.getElement("buySouvenirPrompt").getSprite().visible(1);
			promptFunction = hBuySouvenir3;
			diamondCost.setText(str(Game.sharedGame().shop.getSouvenirCost(GiftShopController.travelDestination, 3)));
			
			if(GiftShopController.travelDestination == "London") {
				achievementIcon.texture("images/gift-shop-icons/big-ben.png");
				itemNameText.setText("Big Ben");
				itemDescriptionText.setText("No trip to London would be complete without seeing Big Ben.");
			}
			else if(GiftShopController.travelDestination == "SanFrancisco") {
				achievementIcon.texture("images/gift-shop-icons/dim-sum.png");
				itemNameText.setText("Dim Sum");
				itemDescriptionText.setText("Taste the delicacies of Chinatown.");
			}
			else if(GiftShopController.travelDestination == "Paris") {
				achievementIcon.texture("images/gift-shop-icons/poodle.png");
				itemNameText.setText("Poodle");
				itemDescriptionText.setText("Cute, sassy and a little snotty, like you.");
			}
			else if(GiftShopController.travelDestination == "BuenosAires") {
				achievementIcon.texture("images/gift-shop-icons/puente-de-la-mujer.png");
				itemNameText.setText("Puente De La Mujer");
				itemDescriptionText.setText("A quiet evening stroll along this modern wonder will have others wondering how you manage to do it all.");
			}
			else if(GiftShopController.travelDestination == "Tokyo") {
				achievementIcon.texture("images/gift-shop-icons/bullet-train.png");
				itemNameText.setText("Shinkansen");
				itemDescriptionText.setText("The speed, the luxury, the way ground travel was meant to be.");
			}
			else if(GiftShopController.travelDestination == "Sydney") {
				achievementIcon.texture("images/gift-shop-icons/harbour-bridge.png");
				itemNameText.setText("Harbor Bridge");
				itemDescriptionText.setText("They call it The Coathanger, obviously Sydney understands high fashion.");
			}
		}
		else if(event.name == "buysouvenir4") {
			Game.sounds.playSFX("generalCollection");
			
			this.screen.getElement("buySouvenirPrompt").getSprite().visible(1);
			promptFunction = hBuySouvenir4;
			diamondCost.setText(str(Game.sharedGame().shop.getSouvenirCost(GiftShopController.travelDestination, 4)));
			
			if(GiftShopController.travelDestination == "London") {
				achievementIcon.texture("images/gift-shop-icons/buckingham-palace.png");
				itemNameText.setText("Buckingham Palace");
				itemDescriptionText.setText("Stop by and share tips with the Queen on interacting with the common folk.");
			}
			else if(GiftShopController.travelDestination == "SanFrancisco") {
				achievementIcon.texture("images/gift-shop-icons/cable-car.png");
				itemNameText.setText("Cable Car");
				itemDescriptionText.setText("Ride an historic cable car and see the sights.");
			}
			else if(GiftShopController.travelDestination == "Paris") {
				achievementIcon.texture("images/gift-shop-icons/dress.png");
				itemNameText.setText("Dress");
				itemDescriptionText.setText("Buy a couture dress and show the others your fantastic sense of style.");
			}
			else if(GiftShopController.travelDestination == "BuenosAires") {
				achievementIcon.texture("images/gift-shop-icons/mate.png");
				itemNameText.setText("Yerba Mate Tea");
				itemDescriptionText.setText("Enjoy this tea in a gourd just like the locals do!");
			}
			else if(GiftShopController.travelDestination == "Tokyo") {
				achievementIcon.texture("images/gift-shop-icons/kinkakuji.png");
				itemNameText.setText("Kinkakuji Picture");
				itemDescriptionText.setText("They have solid gold buildings here?! Show the others how cultured you are.");
			}
			else if(GiftShopController.travelDestination == "Sydney") {
				achievementIcon.texture("images/gift-shop-icons/kangaroo.png");
				itemNameText.setText("Kangaroo");
				itemDescriptionText.setText("Great to take pictures of, not great for a pet.");
			}
		}
		else if(event.name == "buysouvenir5") {
			Game.sounds.playSFX("generalCollection");
			
			this.screen.getElement("buySouvenirPrompt").getSprite().visible(1);
			promptFunction = hBuySouvenir5;
			diamondCost.setText(str(Game.sharedGame().shop.getSouvenirCost(GiftShopController.travelDestination, 5)));
			
			if(GiftShopController.travelDestination == "London") {
				achievementIcon.texture("images/gift-shop-icons/fish-n-chips.png");
				itemNameText.setText("Fish N Chips");
				itemDescriptionText.setText("Temptation finally gets the best of you and your diet comes to a delicious end.");
			}
			else if(GiftShopController.travelDestination == "SanFrancisco") {
				achievementIcon.texture("images/gift-shop-icons/alcatraz.png");
				itemNameText.setText("Alcatraz");
				itemDescriptionText.setText("Take a sightseeing excursion to tour Alcatraz Island.");
			}
			else if(GiftShopController.travelDestination == "Paris") {
				achievementIcon.texture("images/gift-shop-icons/wine.png");
				itemNameText.setText("Wine");
				itemDescriptionText.setText("Enjoy a bottle of wine with other fancy people.");
			}
			else if(GiftShopController.travelDestination == "BuenosAires") {
				achievementIcon.texture("images/gift-shop-icons/el-caminito.png");
				itemNameText.setText("Caminito");
				itemDescriptionText.setText("Experience the birthplace of the music behind the tango.");
			}
			else if(GiftShopController.travelDestination == "Tokyo") {
				achievementIcon.texture("images/gift-shop-icons/kimono.png");
				itemNameText.setText("Kimono");
				itemDescriptionText.setText("Wrap yourself in a beautiful kimono.");
			}
			else if(GiftShopController.travelDestination == "Sydney") {
				achievementIcon.texture("images/gift-shop-icons/manly-ferry.png");
				itemNameText.setText("Manly Ferry");
				itemDescriptionText.setText("Where are all the manly men? Oh well, get on board and head to Manly for fantastic beaches.");
			}
		}
		else if(event.name == "buySouvenirPrompt") {
			this.screen.getElement("buySouvenirPrompt").getSprite().visible(0);
			this.promptFunction();
		}
		else if(event.name == "cancelBuySouvenir") {
			this.screen.getElement("buySouvenirPrompt").getSprite().visible(0);
		}
		else if(event.name == "gotopassport") {
		    // this.screen.getElement("animation").getSprite().addaction(Game.animations.getGiftShopAnimation());
		    // this.screen.getElement("beachbum").getSprite().visible(0);
			var passportScreen = new PassportScreen(0);
			passportScreen.configFile = "screen-cfgs/passport-screen-cfg.xml";
			var controller = new PassportController(passportScreen);
			
			Game.pushScreen(passportScreen);
		}
	}
	
	public function checkForPoppedBalloons()
	{
		var itemsBought = 0;
		
		if(GiftShopController.travelDestination == "London") {
			if(Game.currentGame.passport.LondonSouvenirs[0] == 1) {
				this.screen.getElement("londonsouvenir1").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[1] == 1) {
				this.screen.getElement("londonsouvenir2").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[2] == 1) {
				this.screen.getElement("londonsouvenir3").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[3] == 1) {
				this.screen.getElement("londonsouvenir4").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.LondonSouvenirs[4] == 1) {
				this.screen.getElement("londonsouvenir5").getSprite().texture("");
				itemsBought++;
			}
		}
		else if(GiftShopController.travelDestination == "SanFrancisco") {
			if(Game.currentGame.passport.SanFranciscoSouvenirs[0] == 1) {
				this.screen.getElement("sanfranciscosouvenir1").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[1] == 1) {
				this.screen.getElement("sanfranciscosouvenir2").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[2] == 1) {
				this.screen.getElement("sanfranciscosouvenir3").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[3] == 1) {
				this.screen.getElement("sanfranciscosouvenir4").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.SanFranciscoSouvenirs[4] == 1) {
				this.screen.getElement("sanfranciscosouvenir5").getSprite().texture("");
				itemsBought++;
			}
		}
		else if(GiftShopController.travelDestination == "Paris") {
			if(Game.currentGame.passport.ParisSouvenirs[0] == 1) {
				this.screen.getElement("parissouvenir1").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[1] == 1) {
				this.screen.getElement("parissouvenir2").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[2] == 1) {
				this.screen.getElement("parissouvenir3").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[3] == 1) {
				this.screen.getElement("parissouvenir4").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.ParisSouvenirs[4] == 1) {
				this.screen.getElement("parissouvenir5").getSprite().texture("");
				itemsBought++;
			}
		}
		else if(GiftShopController.travelDestination == "BuenosAires") {
			if(Game.currentGame.passport.BuenosAiresSouvenirs[0] == 1) {
				this.screen.getElement("buenosairessouvenir1").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[1] == 1) {
				this.screen.getElement("buenosairessouvenir2").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[2] == 1) {
				this.screen.getElement("buenosairessouvenir3").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[3] == 1) {
				this.screen.getElement("buenosairessouvenir4").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.BuenosAiresSouvenirs[4] == 1) {
				this.screen.getElement("buenosairessouvenir5").getSprite().texture("");
				itemsBought++;
			}
		}
		else if(GiftShopController.travelDestination == "Tokyo") {
			if(Game.currentGame.passport.TokyoSouvenirs[0] == 1) {
				this.screen.getElement("tokyosouvenir1").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[1] == 1) {
				this.screen.getElement("tokyosouvenir2").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[2] == 1) {
				this.screen.getElement("tokyosouvenir3").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[3] == 1) {
				this.screen.getElement("tokyosouvenir4").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.TokyoSouvenirs[4] == 1) {
				this.screen.getElement("tokyosouvenir5").getSprite().texture("");
				itemsBought++;
			}
		}
		else if(GiftShopController.travelDestination == "Sydney") {
			if(Game.currentGame.passport.SydneySouvenirs[0] == 1) {
				this.screen.getElement("sydneysouvenir1").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[1] == 1) {
				this.screen.getElement("sydneysouvenir2").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[2] == 1) {
				this.screen.getElement("sydneysouvenir3").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[3] == 1) {
				this.screen.getElement("sydneysouvenir4").getSprite().texture("");
				itemsBought++;
			}
			
			if(Game.currentGame.passport.SydneySouvenirs[4] == 1) {
				this.screen.getElement("sydneysouvenir5").getSprite().texture("");
				itemsBought++;
			}
		}
		
		return itemsBought;
	}
	

	
	public function buySouvenir(city, souvenirLevel)
	{
		if(city == "London") {
			Game.currentGame.passport.LondonSouvenirs[souvenirLevel - 1] = 1;
		}
		else if(city == "SanFrancisco") {
			Game.currentGame.passport.SanFranciscoSouvenirs[souvenirLevel - 1] = 1;
		}
		else if(city == "Paris") {
			Game.currentGame.passport.ParisSouvenirs[souvenirLevel - 1] = 1;
		}
		else if(city == "BuenosAires") {
			Game.currentGame.passport.BuenosAiresSouvenirs[souvenirLevel - 1] = 1;
		}
		else if(city == "Tokyo") {
			Game.currentGame.passport.TokyoSouvenirs[souvenirLevel - 1] = 1;
		}
		else if(city == "Sydney") {
			Game.currentGame.passport.SydneySouvenirs[souvenirLevel - 1] = 1;
		}
		
		Game.sharedGame().savePassport();
		
		// pop balloons
		var ret = checkForPoppedBalloons();
		trace("### HWW ### - Number of souvenirs bought: " + str(ret));
		
		// if we bought the last souvenir do the animation
		if(ret == 5) {
			this.screen.stopGiftShopIdleAnimation();
			//this.screen.startGiftShopEndAnimation();
			//c_invoke(balloonsFlyAway, 10333, null);
			//c_invoke(balloonsFlyAway, 8916, null);
			
			// don't let them skip the animation
			this.collectCompletePurchasePoints();
			this.screen.getElement("passportbutton").getSprite().visible(0);
			this.screen.getElement("peopleAnimation").getSprite().texture("images/Animation/gift_shop_end_anim/frames_justpeople/justpeople0056.png");
			c_invoke(balloonsFlyAway, 4000, null);
			//balloonsFlyAway();
			c_invoke(transitionToPassportScreen, 10750, null);
		}
		else {
			transitionToPassportScreen();
		}
	}
	
	public function collectCompletePurchasePoints()
	{
		if(GiftShopController.travelDestination == "London") {
			Game.sharedGame().wife.incSocialStatusPoints(1500);
		}
		else if(GiftShopController.travelDestination == "SanFrancisco") {
			Game.sharedGame().wife.incSocialStatusPoints(3000);
		}
		else if(GiftShopController.travelDestination == "Paris") {
			Game.sharedGame().wife.incSocialStatusPoints(6000);
		}
		else if(GiftShopController.travelDestination == "BuenosAires") {
			Game.sharedGame().wife.incSocialStatusPoints(11000);
		}
		else if(GiftShopController.travelDestination == "Tokyo") {
			Game.sharedGame().wife.incSocialStatusPoints(24000);
		}
		else if(GiftShopController.travelDestination == "Sydney") {
			Game.sharedGame().wife.incSocialStatusPoints(30000);
		}
	}
	
	public function stopGiftShopAnimationTransition()
	{
		this.screen.getElement("peopleAnimation").getSprite().visible(0);
	}
	
	public function balloonsFlyAway()
	{		
		this.screen.getElement("balloonStrings").getSprite().visible(0);
		
		if(GiftShopController.travelDestination == "London") {
			this.screen.getElement("LondonFrame").getSprite().stop();
			this.screen.getElement("balloonsAnimationLondon").getSprite().texture("images/Animation/gift_shop_end_anim/just_balloons_with_strings_stringdown.png");
			this.screen.getElement("LondonFrame").getSprite().addaction(moveby(1417,0,-800));
		}
		else if(GiftShopController.travelDestination == "SanFrancisco") {
			this.screen.getElement("SanFranciscoFrame").getSprite().stop();
			this.screen.getElement("balloonsAnimationSanFrancisco").getSprite().texture("images/Animation/gift_shop_end_anim/just_balloons_with_strings_stringdown.png");
			this.screen.getElement("SanFranciscoFrame").getSprite().addaction(moveby(1417,0,-800));
		}
		else if(GiftShopController.travelDestination == "Paris") {
			this.screen.getElement("ParisFrame").getSprite().stop();
			this.screen.getElement("balloonsAnimationParis").getSprite().texture("images/Animation/gift_shop_end_anim/just_balloons_with_strings_stringdown.png");
			this.screen.getElement("ParisFrame").getSprite().addaction(moveby(1417,0,-800));
		}
		else if(GiftShopController.travelDestination == "BuenosAires") {
			this.screen.getElement("BuenosAiresFrame").getSprite().stop();
			this.screen.getElement("balloonsAnimationBuenosAires").getSprite().texture("images/Animation/gift_shop_end_anim/just_balloons_with_strings_stringdown.png");
			this.screen.getElement("BuenosAiresFrame").getSprite().addaction(moveby(1417,0,-800));
		}
		else if(GiftShopController.travelDestination == "Tokyo") {
			this.screen.getElement("TokyoFrame").getSprite().stop();
			this.screen.getElement("balloonsAnimationTokyo").getSprite().texture("images/Animation/gift_shop_end_anim/just_balloons_with_strings_stringdown.png");
			this.screen.getElement("TokyoFrame").getSprite().addaction(moveby(1417,0,-800));
		}
		else if(GiftShopController.travelDestination == "Sydney") {
			this.screen.getElement("SydneyFrame").getSprite().stop();
			this.screen.getElement("balloonsAnimationSydney").getSprite().texture("images/Animation/gift_shop_end_anim/just_balloons_with_strings_stringdown.png");
			this.screen.getElement("SydneyFrame").getSprite().addaction(moveby(1417,0,-800));
		}
		
		this.screen.startGiftShopEndAnimation();
		c_invoke(stopGiftShopAnimationTransition, 5750, null);
	}
	
	public function transitionToPassportScreen()
	{
		this.screen.getElement("passportbutton").getSprite().visible(1);
		
		var passportScreen = new PassportScreen(1);
		passportScreen.configFile = "screen-cfgs/passport-screen-cfg.xml";
		var controller = new PassportController(passportScreen);
		
		Game.pushScreen(passportScreen);
	}
	
	/*****************************************************************************
    Message Box Functions
	*****************************************************************************/
	
	function hBuySouvenirAtLevel(level)
	{
		var ret = Game.currentGame.shop.buySouvenir(GiftShopController.travelDestination, level);		
		if(ret == 1) {
			buySouvenir(GiftShopController.travelDestination, level);
		}
		else {
            this.pushPremiumCurrencyScreen();
		}
	}
	
	function hBuySouvenir1(x)
	{
		hBuySouvenirAtLevel(1);
	}
	
	function hBuySouvenir2(x)
	{
		hBuySouvenirAtLevel(2);
	}
	
	function hBuySouvenir3(x)
	{
		hBuySouvenirAtLevel(3);
	}
	
	function hBuySouvenir4(x)
	{
		hBuySouvenirAtLevel(4);
	}
	
	function hBuySouvenir5(x)
	{
		hBuySouvenirAtLevel(5);
	}

	public function pushPremiumCurrencyScreen() {
	    var screen = new PremiumCurrencyScreen("viewDiamond");
        screen.configFile = "screen-cfgs/premium-currency-screen-cfg.xml";
        var controller = new PremiumCurrencyController(screen);
        Game.pushScreen(screen);
	}
}
