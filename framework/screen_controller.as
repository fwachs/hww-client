/*****************************************************************************
filename    screen_controller.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     Papaya-Engine 2clams framework

Brief Description:
   Screen controller. Should handle screen events and life-cicle.
*****************************************************************************/

class ScreenController
{
	var modalScreenStack;
	var screen;
	var hudFrameTop;
	var hudFrameBottom;
	var cancelEvents = 0;
	
	public function ScreenController(controlledScreen)
	{
		this.modalScreenStack = new Array();
		this.screen = controlledScreen;
		controlledScreen.controller = this;
	}
	
	public function screenLoaded()
	{
	}
	
	public function screenUnloaded()
	{
	}
	
	public function showTutorial()
	{		
	}
	
	public function screenPostLoaded()
	{
		if(this.screen.firstTime == 1) {
			this.showTutorial();
		}		
	}

	public function eventFired(event)
	{
		var scrName = this.screen.getScreenName();
		trace("### HWW ### - Track Event GA: ", scrName, event.name);
		Game.trackEvent("User event", scrName, event.name, 10);

		if(this.screen.firstTime == 1) {
			var evParts = event.name.split(":");
			var evName = evParts[0];
			
			if(evName == "nextTutorial") {
				this.screen.showNextTutorial();
			}
			else if(evName == "prevTutorial") {
				this.screen.showPrevTutorial();
			}
			else if(evName == "jumpTutorialStep") {
				this.screen.showTutorialStep(int(evParts[1]));
			}
		}
		
		if(event.name == "exitGame") {
			Game.sharedGame().quit();
		}
	}	

	public function hookFired(event)
	{
		return 0;
	}

	public function showMessageBox(mbType)
	{
		var promptScreen = new MessageBoxScreen(mbType);
		promptScreen.configFile = "screen-cfgs/message-box-screen-cfg.xml";
		this.presentModalScreen(promptScreen);
	}
	
	public function presentModalScreen(modalScreen)
	{
 		this.cancelEvents = 1;
		
 		if(len(this.modalScreenStack) == 0) {
			// check if the current screen shows the HUD
			this.hudFrameTop = Game.bannerScreen.getElement("hudFrameTop").getSprite().visible();
			this.hudFrameBottom = Game.bannerScreen.getElement("hudFrameBottom").getSprite().visible();
			// hide HUD while pop-up screen is up
			Game.hideBanner();
 		}
		
		var newCanvas = Game.scene.addsprite().size(screensize()).pos(0, screensize()[1]);
		modalScreen.canvas = newCanvas;
		modalScreen.controller = this;
		modalScreen.create();

		this.screen.willLoseFocus();
		this.screen.lostFocus();
		
		newCanvas.addaction(sequence(moveto(250, 0, 0), callfunc(this.reactivateEvents)));
		modalScreen.willGetFocus();
		modalScreen.gotFocus();
		
		this.modalScreenStack.append(modalScreen);
	}
	
	public function reactivateEvents()
	{
		this.cancelEvents = 0;
	}
	
	public function dismissModalScreen()
	{
		var modalScreen = this.modalScreenStack.pop();
		
		modalScreen.canvas.addaction(moveto(250, 0, screensize()[1]));
		modalScreen.willLoosFocus();
		modalScreen.lostFocus();
		
		Game.scene.remove(modalScreen.canvas);
		modalScreen.destroy();
		
		if(len(this.modalScreenStack) > 0) {
			var nextModalScreen = this.modalScreenStack[len(this.modalScreenStack) - 1];
			nextModalScreen.gotFocus();
		}
		else {					
			this.screen.gotFocus();
			this.screen.willGetFocus();
			
			trace("*** Last modal screen closed: ", this.hudFrameBottom, this.hudFrameTop);
			
			if(this.hudFrameTop == 0 && this.hudFrameBottom == 0) {
				Game.hideBanner();
			}
			else {
				Game.showBanner(this.hudFrameTop, this.hudFrameBottom);
			}
		}		
	}
	
	public function keyDown(node, event, param, x, y, points)
	{
		if(event == EVENT_KEYDOWN && x == KEYCODE_BACK) {
			this.showMessageBox(MessageBoxScreen.MB_Exit);
		}
	}
}
