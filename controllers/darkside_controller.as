/*****************************************************************************
filename    darkside_controller.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

class DarkSideController extends ScreenController
{
	var selectedDoor = null;
	
	public function DarkSideController(controlledScreen)
	{
		super(controlledScreen);
	}

	override public function screenLoaded()
	{
		Game.sounds.stop();
        Game.sounds.playMusic("darkSideMusic");
    	Game.sharedGame().darkSide.activate();
	}	

	override public function eventFired(event)
	{
		super.eventFired(event);

		if (event.name == "doorTapped") {
		    this.doorTapped(event);
		} else if (event.name == "openSafe") {
		    this.openSafe(event);
		} else if (event.name == "getAway") {
		    this.getAway(event);
		} else if (event.name == "dismiss") {
		    this.dismiss(event);
		}
	}
	
	public function doorTapped(event)
	{
		var doorNum = int(event.argument);
		
		log("doorTapped: ", event.argument, doorNum);

		if(Game.sharedGame().darkSide.isDoorOpen(doorNum) == 1) return;
		
		this.screen.highlightDoor(doorNum);
		
		this.selectedDoor = doorNum;
	}
	
	public function openSafe(event)
	{
		if(this.selectedDoor == null) return;
		
		var doorNum = this.selectedDoor;
		
		this.selectedDoor = null;
		this.screen.hideHighlight();
		
		if(Game.sharedGame().darkSide.isDoorOpen(doorNum) == 1) return;
		
		var ret = Game.sharedGame().darkSide.openDoor(doorNum);
		if(ret > 0) {
            Game.sounds.playSFX("openSafe");
			this.screen.showDiamondsAtDoor(doorNum, ret);
		}
		else if(ret < 0) {
			Game.sounds.stop();
            Game.sounds.playSFX("sabotageGift");			
			this.screen.showCopAtDoor(doorNum)
			c_invoke(this.gotBusted, 1000, null);
		}
		else {
            Game.sounds.playSFX("openSafe");
			this.screen.showEmptyAtDoor(doorNum);
		}
	}
	
	public function gotBusted()
	{
		this.showMessageBox(MessageBoxScreen.MB_GotBusted);
	}
	
	public function getAway(event)
	{
		Game.sharedGame().darkSide.getAway();
		this.leave();
	}
	
	public function dismiss(event)
	{
		this.dismissModalScreen();
		this.leave();
	}
	
	public function leave()
	{
        Game.sharedGame().darkSide.deactivate();
        Game.popScreen();
		Game.sounds.stop();
        Game.sounds.playMusic("themeMusic");
	}
}
