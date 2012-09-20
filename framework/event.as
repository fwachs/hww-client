/*****************************************************************************
filename    event.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   Event handling
*****************************************************************************/


var glEvents = new dict();

function eventHandler(node, event, param, x, y, points) 
{
/*
	if(event == EVENT_MULTI_TOUCH) {
		var point0 = points[0];
		var point1 = points[1];
		
		trace("MultiTouch: (", point0[0] , ",", point0[1], ") (", point1[0], ",", point1[1], ")");	
	}
	else if(event == EVENT_TOUCH) {
		trace("Touch: (", x , ",", y, ") ");
	}
	else if(event == EVENT_MOVE) {
		trace("Move: (", x , ",", y, ") ");	
	}
	else if(event == EVENT_UNTOUCH) {
		trace("Move: (", x , ",", y, ") ");	
	}	
*/

//	trace("EventHandler: ", node.get().controlName);
	
	var hookResult;
	var nodeEvents = glEvents.get(node);
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

class Event
{
	static var hookController = null;
	static var hookType = null;
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
	
	public static function addEvent(event)
	{
//		trace("Adding event to ", event.node, " of type ", event.eventType);
	
		event.node.setevent(event.eventType, eventHandler);
		
//		trace("Event has_key: ", glEvents.has_key(event.node));
		if(glEvents.has_key(event.node) == 0) {
			glEvents.update(event.node, new Array());
		}
		
		var arrayList = glEvents.get(event.node);
		arrayList.append(event);
//		trace("Event arrayList: ", arrayList, " - ", arrayList.count());
	}
	
	public static function removeEventsForHandler(objectHandler)
	{
		glEvents.pop(objectHandler);
	}
	
	public static function removeEventsForHandlerAndChildren(objectHandler)
	{
		var nodes = objectHandler.subnodes();
		
		glEvents.pop(objectHandler);

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
		this.controller.eventFired(this);
	}
	
	public function copy()
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
