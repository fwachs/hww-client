/*****************************************************************************
filename    event.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   Event handling
*****************************************************************************/


class Event
{
	static var hookController = null;
	static var hookType = null;
	static var glEvents = new dict();
	var eventType;
	var controller;
	var node;
	var name;
	var argument;
	var param;
	var x;
	var y;
	var points;
	var multi;
	var firingTime;	

	static public function eventHandler(node, event, param, x, y, points) 
	{
		var hookResult;
		var nodeEvents = Event.glEvents.get(node);
		for(var i = 0; i < len(nodeEvents); i++) {
			if(nodeEvents[i].eventType == event) {
				nodeEvents[i].param = param;
				nodeEvents[i].x = x;
				nodeEvents[i].y = y;
				nodeEvents[i].points = points;
				if(event == EVENT_MULTI_TOUCH) {
					nodeEvents[i].multi = 1;
				}
				else {
					nodeEvents[i].multi = 0;
				}
				nodeEvents[i].firingTime = time();
				
				hookResult = 0;
				if(Event.hookController) {
					if(Event.hookType == event) {
						hookResult = Event.hookController.hookFired(nodeEvents[i]);
					}
				}
				
				if(hookResult == 0) {
					nodeEvents[i].run();
				}
			}
		}
	}
	
	public static function addEvent(event)
	{
//		trace("Adding event to ", event.node, " of type ", event.eventType);
	
		event.node.setevent(event);

		/*
		event.node.setevent(event.eventType, Event.eventHandler);
		
//		trace("Event has_key: ", Event.glEvents.has_key(event.node));
		if(Event.glEvents.has_key(event.node) == 0) {
			Event.glEvents.update(event.node, new Array());
		}
		
		var arrayList = Event.glEvents.get(event.node);
		arrayList.append(event);
//		trace("Event arrayList: ", arrayList, " - ", arrayList.count());
 */
	}
	
	public static function removeEventsForHandler(objectHandler)
	{
		Event.glEvents.pop(objectHandler);
	}
	
	public static function removeEventsForHandlerAndChildren(objectHandler)
	{
		var nodes = objectHandler.subnodes();
		
		Event.glEvents.pop(objectHandler);

		if(nodes) {
			for(var i = 0; i < len(nodes); i++) {
				Event.removeEventsForHandlerAndChildren(nodes[i]);
			}
		}
	}
	
	public static function setHook(controller, eventType)
	{
		Event.hookController = controller;
		Event.hookType = eventType;
	}
	
	public static function clearHook(controller, eventType)
	{
		Event.hookController = null;
		Event.hookType = null;
	}
	
	public function run()
	{
		var hookResult = 0;
		if(Event.hookController) {
			if(Event.hookType == this.eventType) {
				hookResult = Event.hookController.hookFired(this);
			}
		}
		
		if(hookResult == 0) {
			this.controller.eventFired(this);
		}
	}
	
	public function makeCopy()
	{
		var e = new Event();
		
		e.eventType = this.eventType;
		e.controller = this.controller;
		e.node = this.node;
		e.name = this.name;
		e.argument = this.argument;
		e.param = this.param;
		e.x = this.x;
		e.y = this.y;
		e.points = this.points;
		e.multi = this.multi;
		e.firingTime = this.firingTime;
		
		return e;
	}
}

class GoBackEvent extends Event
{
	override public function run()
	{
		Game.popScreen();
	}
}

class QuitEvent extends Event
{
	override public function run()
	{
		Game.quit();
	}
}
