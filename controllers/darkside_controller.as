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
	}	

	override public function configureHandlers()
	{
		this.setEventHandler(this.doorTapped, "doorTapped");
		this.setEventHandler(this.openSafe, "openSafe");
		this.setEventHandler(this.getAway, "getAway");
		this.setEventHandler(this.dismiss, "dismiss");
	}
	
	override public function eventFired(event)
	{
		super.eventFired(event);

		this.processHandlerForEvent(event);
	}
	
	public function doorTapped(event)
	{
		var doorNum = int(event.argument);
		
		trace("doorTapped: ", event.argument, doorNum);

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
			this.screen.showDiamondsAtDoor(doorNum);
		}
		else if(ret < 0) {
			this.gotBusted();
		}
		else {
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
		
        Game.popScreen();
	}
	
	public function dismiss(event)
	{
		this.dismissModalScreen();
        Game.popScreen();
	}
}
