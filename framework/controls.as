/*****************************************************************************
filename    controls.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

function distance(point0, point1)
{
	var dx = point0[0] - point1[0];
	var dy = point0[1] - point1[1];

	return sqrt(dx * dx + dy * dy);
}	
	

class Control
{
	var attrs;
	var _sprite;
	var controlName;
	var parent;
	var mustBubbleSize;
	var children;
	var didMove;
	var tapEvent = null;
	var textLabel;
	var textString;
	var highlight = null; 
	var lowlight;
	
	static var controlsCount = 0;
	
	static public function newControlFromAttributes(attrs)
	{
		var control = null;
		
		Control.controlsCount++;
		trace("Control removed. Controls count: ", Control.controlsCount);
		
		var className = attrs.get("class");
//		trace("className: ", className);
		
		if(className) {
			if(className == "Scroll") {
				control = Scroll.newScrollFromAttributes(attrs);
			}
			else if(className == "IsometricCanvas") {
				control = IsometricCanvas.newCanvasFromAttributes(attrs);
			}
		}
		else {
			//trace("### HWW ### - newControlFromAttributes", str(attrs));
			var resource = attrs.get("resource");
			var highlightFile;
			if (resource != null && resource != "") {
				resource = "images/" + resource;
				
				var resParts = resource.split(".");
				if(len(resParts) == 2) {
					highlightFile = resParts[0] + "-highlight." + resParts[1];
				}
			}
						
			control = new Control(resource);
			control.attrs = attrs;

			control.lowlight = resource;
			/*
			var handler = c_res_file(highlightFile)
			if(c_file_exist(handler) == 1) {
				control.highlight = highlightFile;
			}
			*/

			control._sprite.pos(Game.translateX(int(attrs.get("left"))), Game.translateY(int(attrs.get("top"))));

			var w = attrs.get("width");
			var h = attrs.get("height");			
			if(w && h) {
				control._sprite.size(Game.translateX(int(w)), Game.translateY(int(h)));
			}

			var strColor = attrs.get("color");
			if(strColor) {
				var parts = strColor.split(",");
				control._sprite.color(int(parts[0]), int(parts[1]), int(parts[2]), int(parts[3]));
			}
			
		}
				
		return control;
	}
	
	public function Control(resourceImage)
	{
//		trace("Control constructor [", resourceImage, "]");
		if(resourceImage) {
			this._sprite = sprite(resourceImage, ARGB_8888);
		}
		else if(resourceImage == "transparent") {
			this._sprite = sprite("images/transparent.png", ARGB_8888, ALPHA_TOUCH);
		}
		else {
			this._sprite = sprite();
		}
		
		this.mustBubbleSize = 0;
		
		this.children = new Array();	
		this.textLabel = null;
		this.textString = "";
	}
	
	public function addChild(childControl)
	{
		this.children.append(childControl);
		
		childControl.addToParent(this.getSprite());
	}
	
	public function removeChild(child)
	{
		child.removeAllChildren();
		
		child.removeFromParent(this);
		this.children.remove(child);		
	}
	
	public function removeFromParent()
	{
		var sprt = this.getSprite();
		var parentSprite = sprt.parent();
		
		trace("+ removeFromParent: ", sprt);
//		Event.removeEventsForHandler(sprt);
//		sprt.removefromparent();
		parentSprite.remove(sprt);
		trace("- removeFromParent: ", sprt);

		Control.controlsCount--;
		trace("Control removed. Controls count: ", Control.controlsCount);
	}
	
	public function removeAllChildren()
	{
		while(len(this.children) > 0) {
			this.removeChild(this.children[0]);
		}
	}
	
	public function configureEvents()
	{
		if(this.tapEvent != null) {
			this.attachEvent(this._sprite, "ontouch", "", EVENT_TOUCH);
			this.attachEvent(this._sprite, "ontouch", "", EVENT_MULTI_TOUCH);
			this.attachEvent(this._sprite, "onuntouch", "", EVENT_UNTOUCH);
			this.attachEvent(this._sprite, "onmove", "", EVENT_MOVE);
		}
	}
	
	public function addToParent(parent)
	{
		var zIndex = 0;
		var strZIndex = this.attrs.get("z-index");
		if(strZIndex) {
			zIndex = int(strZIndex);
		}		
		
		parent.add(this.getSprite(), zIndex);
		
		this.parent = parent;

		//this.getSprite().put(this);

		this.configureEvents();	
	}
	
	public function getSprite()
	{
		return this._sprite;
	}

	public function parseText(text)
	{
		this.getSprite().prepare();
		var pos = this.getSprite().pos();
		var size = this.getSprite().size();
		
		var fontSize = Game.translateFontSize(32);
		if(attrs.get("font-size")) {
			fontSize = Game.translateFontSize(int(this.attrs.get("font-size")));
		}
		
		var fontStyle;
		var strFontStyle = this.attrs.get("font-style");
		if(strFontStyle == "bold") {
			fontStyle = FONT_BOLD;
		}
		else if(strFontStyle == "italic") {
			fontStyle = FONT_ITALIC;
		}
		else if(strFontStyle == "bold-italic") {
			fontStyle = FONT_BOLD_ITALIC;
		}
		else {
			fontStyle = FONT_NORMAL;
		}

		var textAlign;
		var strTextAlign = this.attrs.get("text-align");
		if(strTextAlign == "left") {
			textAlign = ALIGN_LEFT;
		}
		else if(strTextAlign == "right") {
			textAlign = ALIGN_RIGHT;
		}
		else {
			textAlign = ALIGN_CENTER;
		}

		var selectedFont = "Arial";
		var strFont = this.attrs.get("text-font");
		if(strFont) {
			selectedFont = strFont;
		}
		
//		trace("parseText: ", text, "Arial", fontSize, fontStyle, size[0], size[1], textAlign);
		
		var ret;		
		if(this.attrs.get("text-wrap") != null && this.attrs.get("text-wrap").lower() == "yes") {
			var width = this.attrs.get("width");
			if(width) {
				size[0] = Game.translateX(int(width));
			}
		
			this.textLabel = this.getSprite().addlabel(text, selectedFont, fontSize, fontStyle, size[0], 0, textAlign);
			this.textLabel.prepare();
			
			this.getSprite().size(size[0], this.textLabel.size()[1]);
			
//			this.bubbleUpSize(size[0], ret.size()[1]);			
//			trace("**** text wrapping: ", ret.size());
		}
		else {
			this.textLabel = this.getSprite().addlabel(text, selectedFont, fontSize, fontStyle, size[0], size[1], textAlign);
		}
		
		this.textString = text;
		
		return ret;
	}
	
	public function setFont(fontName, fontSize, style, align, wrapMode)
	{
		if(this.textLabel != null) {
			this.getSprite().remove(this.textLabel);
		}
		
		var size = this.getSprite().size();
		if(wrapMode == "wrap") {
			size[1] = 0;
		}
		
		var textAlign;
		if(align == "left") {
			textAlign = 0;
		}
		else if(align == "right") {
			textAlign = 2;
		}
		else {
			textAlign = 1;
		}
		
		var fontStyle;
		if(style == "bold") {
			fontStyle = FONT_BOLD;
		}
		else if(style == "italic") {
			fontStyle = FONT_ITALIC;
		}
		else if(style == "bold-italic") {
			fontStyle = FONT_BOLD_ITALIC;
		}
		else {
			fontStyle = FONT_NORMAL;
		}

		this.textLabel = this.getSprite().addlabel(this.textString, fontName, fontSize, style, size[0], size[1], textAlign);
	}
	
	public function setText(text)
	{
		this.textString = text;
		
		if(this.textLabel == null) {
			var defaultFont = Game.font.getFont();
			this.textLabel = this.getSprite().addlabel(this.textString, defaultFont, Game.translateFontSize(32));
		}
		else {
			this.textLabel.text(text);
		}
	}
	
	public function getText()
	{
		return this.textString;
	}
	
	public function bubbleUpSize(width, height)
	{
		var size = this.getSprite().size();
		this.getSprite().size(size[0], height);
		
		if(this.parent) {
			this.parent.bubbleUpSize(size[0], height);
		}
		else {
			this.mustBubbleSize = 1;
		}
	}

	public function addEvent(eventName, argument, eventType)
	{
		this.attachEvent(this._sprite, eventName, argument, eventType);
	}	

	public function attachEvent(node, eventName, argument, eventType)
	{
		var ev = new Event();		
		ev.node = node;
		ev.name = eventName;
		ev.eventType = eventType;
		ev.controller = this;
		ev.argument = argument;
		Event.addEvent(ev);
	}
	
	public function eventFired(event)
	{
//		trace("Control eventFired: ", event.name, " ", this.controlName);
		
		this.tapEventHandler(event);
	}
	
	function getCanvas(ele)
	{
		return ele.canvas;
	}
	
	public function tapEventHandler(event)
	{
		trace("tapEventHandler: ", event.name, " ", this.controlName);
		
		if(event.name == "ontouch") {
			trace("touch event: " + this.controlName, " ", event.x, event.y, event.name, event.argument);
			
			if(this.highlight != null) {
				this.getSprite().texture(this.highlight);
			}
			
			var worldPos = this.getSprite().node2world(event.x, event.y);
			this.didMove = event.makeCopy();
			this.didMove.x = worldPos[0];
			this.didMove.y = worldPos[1];
		}
		else if(event.name == "onuntouch") {			
			var p1 = new Array(this.didMove.x, this.didMove.y);
			var p2 = this.getSprite().node2world(event.x, event.y);
			var dist = distance(p1, p2)
			
			if(this.highlight != null) {
				this.getSprite().texture(this.lowlight);
			}
			
//			trace("Untouch with distance: ", dist);
//			if(dist < 75) {
				this.controlTapped();
				
				return;
//			}
		}
		
		if(this.parent) {
			var pos = this.getSprite().node2world(event.x, event.y);
			var newPos = this.parent.world2node(pos[0], pos[1]);
//			trace("tapEventHandler: ", event.x, event.y, pos, newPos);
			
			var newEvent = event.makeCopy();
			newEvent.x = pos[0];
			newEvent.y = pos[1];
			
			var target = this.parent.get();
			if(target) {
				target.eventFired(newEvent);
			}
		}
	}
	
	public function translateEvent(event)
	{
		var pos = event.node.node2world(event.x, event.y);
		var newPos = this.getSprite().world2node(pos[0], pos[1]);
		
		var newEvent = event.makeCopy();
		newEvent.x = pos[0];
		newEvent.y = pos[1];
		
		return newEvent;
	}
	
	public function controlTapped()
	{
		trace("controlTapped: ", this.controlName, this.tapEvent.name, this.tapEvent.argument);
		if(this.tapEvent) {
			if(this.tapEvent.controller.cancelEvents == 0) {
				this.tapEvent.controller.eventFired(this.tapEvent);
			}
		}
	}
}

class Scroll extends Control
{
	var container;
	var dist0;
	var dist1;
	var currentScale;
	var start;
	var state;
	var ZOOM = 0;
	var DRAG = 1;
	var lock;
	var startPos;
	var contentWidth;
	var contentHeight;
	var startContentWidth;
	var startContentHeight;
	var width;
	var height;
	var speed;
	var lastMoved;
	var minZoom;
	var maxZoom;
	var controller;
	
	static public function newScrollFromAttributes(attrs)
	{
		var scroll = new Scroll(int(attrs.get("left")), int(attrs.get("top")), int(attrs.get("width")), int(attrs.get("height")));
		scroll.lock = attrs.get("lock");	
		scroll.attrs = attrs;
		scroll.container.texture("images/" + attrs.get("resource"));
				
		return scroll;
	}
		
	public function Scroll(left, top, w, h)
	{		
		super(null);

		this.width = Game.translateX(w);
		this.height = Game.translateY(h);
		
		this.container = sprite();
		this.container.pos(Game.translateX(left), Game.translateY(top));
		this.container.clipping(1);
		this.container.size(this.width, this.height);

		this.attachEvent(this.container, "ontouch", "", EVENT_TOUCH);
		this.attachEvent(this.container, "ontouch", "", EVENT_MULTI_TOUCH);
		this.attachEvent(this.container, "onuntouch", "", EVENT_UNTOUCH);
		this.attachEvent(this.container, "onmove", "", EVENT_MOVE);
				
		this.minZoom = 100;
		this.maxZoom = 100;
		this.currentScale = 100;
	}

	override public function configureEvents()
	{
	}

	override public function addToParent(parent)
	{
		var zIndex = 0;
		
		if(this.attrs) {
			var strZIndex = this.attrs.get("z-index");
			
			trace(">*** zIndex: ", strZIndex)
			if(strZIndex) {
				zIndex = int(strZIndex);
			}		
		}
		
		parent.add(this.container, zIndex);
		this.container.add(this._sprite);
		
		this.parent = parent;

		this.getSprite().put(this);
	}

	override public function removeFromParent()
	{
		Event.removeEventsForHandler(this.container);
		this.container.removefromparent();
	}
	
	override public function bubbleUpSize(width, height)
	{
		this.mustBubbleSize = 0;
	}
	
	override public function getSprite()
	{
		return this._sprite;
	}
	
	override public function eventFired(event)
	{
//		trace("Scroll Event ", event.name);		
		
		if(event.name == "ontouch") {
			if(event.multi == 0) {
				this.dragStarted(event);
			}
			else {
				this.zoomStarted(event);
			}
		}
		else if(event.name == "onuntouch") {
			if(this.state == DRAG) {
				this.dragEnded(event);
			} 
			else if(this.state == ZOOM) {
				this.zoomEnded(event);
			}
		}
		else if(event.name == "onmove") {
			if(this.state == DRAG) {
				this.dragMoved(event);
			} 
			else if(this.state == ZOOM) {
				this.zoomMoved(event);
			}
		}
	}
	
	function dragStarted(event)
	{		
        this.start = event;
        this.lastMoved = event;
		this.state = DRAG;
		this.startPos = this._sprite.pos();
		this.speed = 0;

//		trace("SCROLL: dragStarted ", event.x, event.y);
	}
	
	function dragMoved(event)
	{
		var newX = event.x - this.start.x + this.startPos[0];
		var newY = event.y - this.start.y + this.startPos[1];

//		trace("SCROLL: dragMoved ", event.x, event.y, " - ", this.start.x, this.start.y, " + ", this.startPos, " = ", newX, newY);
		
		if(this.lock == "vertical") {
			newX = this.startPos[0];
		}
		else if(this.lock == "horizontal") {
			newY = this.startPos[1];
		}
		
		this._sprite.pos(newX, newY);
		
//				this.lastMoved = event;
	}
	
	function dragEnded(event)
	{
		var newX = event.x - this.start.x + this.startPos[0];
		var newY = event.y - this.start.y + this.startPos[1];
		
		if(newX > 0) {
			newX = 0;
		}
		if(newY > 0) {
			newY = 0;
		}
		
		var cWidth = (this.contentWidth * this.currentScale / 100);
		var cHeight = (this.contentHeight * this.currentScale / 100);
		if(newX < this.width - cWidth) {
			trace("newX: ", this.width, this.contentWidth, cWidth, newX);
			newX = this.width - cWidth;
			if(newX > 0) {
				newX = 0;
			}
			trace("newX post: ", newX);
		}
		if(newY < this.height - cHeight) {
			newY = this.height - cHeight;
		}

		if(this.lock == "vertical") {
			newX = this.startPos[0];
		}
		else if(this.lock == "horizontal") {
			newY = this.startPos[1];
		}

		this.speed = 100;
//				this.speed = (event.y - this.lastMoved.y) * 1000 / (event.firingTime - this.lastMoved.firingTime);
//				newY += this.speed;
//		trace("*** SPEED: ", this.speed);

		this._sprite.addaction(moveto(abs(this.speed) * 2, newX, newY));
	}
	
	function zoomStarted(event)
	{
		this.dist0 = distance(event.points[0], event.points[1]);
		this.state = ZOOM;
	}
	
	function zoomMoved(event)
	{
		this.dist1 = distance(event.points[0], event.points[1]);

		if(abs(this.dist1 - this.dist0) < 5) return;
		
//		var scaleDelta = (((this.currentScale * 1000) / (this.minZoom * 1000)) + 500) / 1000;
//		trace("scaleDelta: ", scaleDelta);
		var scaleDelta = 1;
		
		if(this.dist1 < this.dist0) {
			scaleDelta = -scaleDelta;
		}
		
		this.currentScale += scaleDelta;
		
		this._sprite.scale(this.currentScale);

		var pos = this._sprite.pos();
		
		this._sprite.pos(pos[0] + (-scaleDelta * this.contentWidth / 100 / 2), pos[1] + (-scaleDelta * this.contentHeight / 100 / 2));

		this.dist0 = this.dist1;
	}
	
	function zoomEnded(event)
	{
		var scaleDelta = 0;
		
		if(this.currentScale < this.minZoom) {
			scaleDelta = this.minZoom - this.currentScale;
		}
		else if(this.currentScale > this.maxZoom) {
			scaleDelta = this.maxZoom - this.currentScale;
		}

		this.currentScale += scaleDelta;
		
		var pos = this._sprite.pos();

		this._sprite.addaction(
							spawn(
								scaleto(200, this.currentScale, this.currentScale), 
								moveto(200, pos[0] + (-scaleDelta * this.contentWidth / 100 / 2), pos[1] + (-scaleDelta * this.contentHeight / 100 / 2))
							)
						);
	}
	
	public function offsetLeft()
	{
		return this._sprite.pos()[0];
	}

	public function offsetTop()
	{
		return this._sprite.pos()[1];
	}
	
	public function setContentSize(width, height)
	{
		this.contentWidth = Game.translateX(width);
		this.contentHeight = Game.translateY(height);
	}
	
	public function setZoomLimits(minZoom, maxZoom)
	{
		this.minZoom = minZoom;
		this.maxZoom = maxZoom;
	}
}
