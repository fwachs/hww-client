/*****************************************************************************
filename    screen.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     Papaya-Engine 2clams framework

Brief Description:
   Represents a game screen
      
*****************************************************************************/

import framework.event
import framework.controls

class Screen
{
	static var xmlTemplates = new dict();
	var elements;
	var controller;
	var canvas;
	var configFile = "";
	var rootNode;
	var isRoot = 0;
	var firstTime;
	var properties;
	var currentTutorial = 0;
	
	public function Screen()
	{
		this.elements = dict();
	}
	
	public function getScreenName()
	{
		return  this.configFile.replace("-cfg.xml", "").split("/")[1];
	}
	
	public function addElement(name, element)
	{
		if(name != "") {
			this.elements.update(name, element);
		}
	}
	
	public function getElement(name)
	{
		return this.elements.get(name);
	}
	
	public function addEvent(node, eventName, argument, eventType)
	{
		var ev = new Event();		
		ev.node = node;
		ev.name = eventName;
		ev.eventType = eventType;
		ev.controller = this.controller;
		ev.argument = argument;
		Event.addEvent(ev);
	}
	
	public function parseEvents(control, attrs)
	{
		var newSprite = control.getSprite();
		var onTap = attrs.get("ontap");
		if(onTap) {
			trace("Adding on tap to ", control.controlName);

			var ev = new Event();		
			ev.node = newSprite;
			ev.name = onTap;
			ev.eventType = EVENT_UNTOUCH;
			ev.controller = this.controller;

			control.tapEvent = ev;
		}
		
		var onTouchUp = attrs.get("ontouchup");
		if(onTouchUp) {
			this.addEvent(newSprite, onTouchUp, null, EVENT_UNTOUCH);
		}
		
		var onTouchDown = attrs.get("ontouchdown");
		if(onTouchDown) {
			this.addEvent(newSprite, onTouchDown, null, EVENT_TOUCH);
		}

		var onMove = attrs.get("onmove");
		if(onMove) {
			this.addEvent(newSprite, onMove, null, EVENT_MOVE);
		}
	}
	
	public function controlFromXmlNode(ele)
	{
		var attrs = ele.get("#attributes");
		trace("Attrs: ", attrs);
		var text = ele.get("#text");
					
		var control = Control.newControlFromAttributes(attrs);
		var newSprite = control.getSprite();			
		
		if(attrs.get("visible") != null && attrs.get("visible").lower() == "no") {
			newSprite.visible(0);
		}			
		
		if(text) {
			control.parseText(text);
		}
		
		control.controlName = attrs.get("name");
		
		this.parseEvents(control, attrs);
				
		this.parseNode(ele, control);
		
		return control;
	}
	
	public function parseNode(node, parent)
	{
		var elems = node.get("#children");
		//trace("### HWW ### - Debugging. Parent: ", str(parent), " children: ", str(elems));
		if (elems != null) {
			for(var i = 0; i < len(elems); i++) {
				var ele = elems[i].get("screen:element");
				
				var control = this.controlFromXmlNode(ele);
						
				this.addElement(control.controlName, control);
				parent.addChild(control);			
			}
		}

	}
	
	public function create()
	{
		if(this.configFile != "") {
			this.load();
			
			var dict = parsexml(this.configFile, 1);
			
			var screenCfg = dict.get("screen:config").get("#children");
			
			this.rootNode = this.controlFromXMLString("<screen:element name=\"root_node\" left=\"0\" top=\"0\" width=\"1280\" height=\"800\"/>");
						
			var screenNode = screenCfg[0].get("screen:elements");
			this.parseNode(screenNode, this.rootNode);

			trace("CANVAS! ", this.canvas, this.rootNode);
			this.canvas.add(this.rootNode.getSprite());
			
			trace("create screen: ", this.configFile, this.firstTime);

			this.showNextTutorial();
		}

		this.build();		
	}
	
	public function showNextTutorial()
	{
		trace("ShowNextTutorial: ", this.currentTutorial);
		this.showTutorialStep(this.currentTutorial + 1);
	}
	
	public function showPrevTutorial()
	{
		trace("ShowPrevTutorial: ", this.currentTutorial);
		this.showTutorialStep(this.currentTutorial - 1);
	}
	
	public function showTutorialStep(step)
	{
		if(this.firstTime == 0) return;

		this.hideTutorial();
		
		this.currentTutorial = step;

		var newTut = this.getElement("tutorial-step-" + str(this.currentTutorial));
		if(newTut) {
			newTut.getSprite().removefromparent();
			Game.scene.add(newTut.getSprite());
			newTut.getSprite().visible(1);
		}
	}
	
	public function hideTutorial()
	{
		var oldTut = this.getElement("tutorial-step-" + str(this.currentTutorial));
		if(oldTut) {
			oldTut.getSprite().removefromparent();
			this.rootNode.getSprite().add(oldTut.getSprite());
			oldTut.getSprite().visible(0);
		}
	}
	
	public function controlFromXMLString(xmlString)
	{
		var dict = parsexml(xmlString, 0);
		var ele = dict.get("screen:element");
		
		var control = this.controlFromXmlNode(ele);
		
		return control;
	}
	
	public function arrayToString(arr)
	{
		var newstr = "";
		
		for(var i = 0; i < len(arr); i++) {
			newstr += str(arr[i]);
		}
		
		return newstr;
	}
	
	public function getTemplateText(fileName)
	{
		var templateText = Screen.xmlTemplates.get(fileName);
		
		if(!templateText) {
		var file_handler = c_res_file("screen-cfgs/templates/" + fileName);
		var result = c_file_op(C_FILE_READ, file_handler);
			
			templateText = this.arrayToString(result);
			
			Screen.xmlTemplates.update(fileName, templateText);

			trace("### HWW ### - XML From File: ", fileName, templateText);
		}
		
		return templateText;
	}
	
	public function controlFromXMLTemplate(templateName, argsDictionary, fileName)
	{		
		var strXML = this.getTemplateText(fileName);
		
		var keys = argsDictionary.keys();
		for(var i = 0; i < len(keys); i++) {
			//trace("### HWW ### - Key: ", keys[i], " argDirectory: ", argsDictionary.get(keys[i]));
			if (argsDictionary.get(keys[i]) != null) {
				strXML = strXML.replace("#" + keys[i], str(argsDictionary.get(keys[i])));
			}
		}
		//trace("### HWW ### - XML After Procession", strXML);
		
		var dict = parsexml(strXML, 0);

		var templates = dict.get("screen:templates").get("#children");
		for(i = 0; i < len(templates); i++) {
			var tplt = templates[i].get("screen:template");
			var attrs = tplt.get("#attributes");
			
			if(attrs.get("name") == templateName) {
				var screenNode = tplt.get("#children")[0].get("screen:element");
				return this.controlFromXmlNode(screenNode);
			}
		}

		return null;
	}
	
	// Must be overriden for custom creation
	public function build()
	{
	}
	
	public function destroy()
	{
		Event.removeEventsForHandlerAndChildren(this.rootNode.getSprite());
		
		this.rootNode.removeAllChildren();
		this.rootNode.removeFromParent();
		this.rootNode = null;
	}
	
	public function gotFocus()
	{
	}
	
	public function lostFocus()
	{
	}
	
	public function willLooseFocus()
	{
		this.hideTutorial();
	}
	
	public function willGetFocus()
	{
		this.showTutorialStep(this.currentTutorial);
	}
	
	public function bubbleUpSize(width, height)
	{
	}
	
	public function load() 
	{
        this.properties = Game.getDatabase().get("screen_" + this.configFile);
        trace("### HWW ### - Fetched screen:", "screen_" + this.configFile, this.properties);
        if(this.properties)  {
        	this.firstTime = 1;
        }
        else {        
        	this.firstTime = 1;
        	this.properties = dict();
        	this.setProperty("initialized", 1);
        }
	}

    public function save()
    {
        trace("### HWW ### - Saved screen:", "screen_" + this.configFile);
        Game.getDatabase().put("screen_" + this.configFile, this.properties);
    }
    
    public function setProperty(key, value)
    {
    	this.properties.update(key, value);
    	this.save();
    }
    
    public function getProperty(key)
    {
    	return this.properties.get(key);
    }
}

