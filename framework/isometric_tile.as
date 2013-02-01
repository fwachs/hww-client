/*****************************************************************************
filename    isometric_tile.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

class IsometricTile extends Control
{
	var highlightSprite = null;
	var width;
	var height;
	var x;
	var y;
	var top;
	var left;
	var z;
	var occupied;
	var item;
	var isHighlighted;
	var canvas;
	var area;
	var resource;
	var item_width;
	var item_depth;
	
	public function IsometricTile(x, y, width, height)
	{
		super(null);
		
		this.x = x;
		this.y = y;
		
		this.width = width;
		this.height = height;
		this.isHighlighted = 0;
		
		this.resource = "images/furniture/highlight02.png";
		this._sprite = sprite();
		
		this.item = null;
	}
	
	override public function configureEvents()
	{
		return;
		this.attachEvent(this._sprite, "ontouch", 0, EVENT_TOUCH);
		this.attachEvent(this._sprite, "ontouch", 0, EVENT_MULTI_TOUCH);
		this.attachEvent(this._sprite, "onuntouch", 0, EVENT_UNTOUCH);
		this.attachEvent(this._sprite, "onmove", 0, EVENT_MOVE);
	}
	
	override public function controlTapped()
	{
		canvas.tileTapped(this);
	}
	
	public function calcPosition(cols)
	{
		this.top = (this.y + this.x) * this.height / 2;
		this.left = (this.y - this.x) * this.width / 2 + (cols - 1) * this.width / 2;
	}
	
	public function isInView(x, y, w, h)
	{
		var right = this.left + this.width;
		var bottom = this.top + this.height; 
		if(right >= x && this.left < x + w && bottom >= y && this.top < y + h) {
			return 1;
		}
		
		return 0;
	}
	
	public function addToCanvas(canvas)
	{
		if(this.canvas) return 0;		

		this.canvas = canvas;
		
		this.parent = canvas.getSprite();
		this.configureEvents();

		var newSprite = sprite(this.resource);
		newSprite.prepare();
		var size = newSprite.size();
		
		var top = this.top - size[1] + this.height;
		var left = this.left - this.width / this.item_width;

		Event.removeEventsForHandler(this._sprite);
		
		this._sprite.removefromparent();		
		this._sprite = newSprite;
		this._sprite.pos(left, top);
		
		this.configureEvents();

		var x1000 = this.x * 1000;
		var y1000 = this.y * 1000;
		var itemWidth1000 = 1 * 1000;
		
		this.z = (x1000 + 1000 - itemWidth1000 / 2) + 1000;
		
		parent.add(this._sprite, this.z);
		
		this._sprite.pos(left, top);
		//this._sprite.size(this.width, this.height);
		
		//this._sprite.addlabel(str(this.x) + "," + str(this.y), "Arial", 14);
		
		canvas.getSprite().add(this._sprite, x + y);
		
		if(this.item) {
			this.item.setCanvas(canvas);
		}
		
		return 1;
	}
	
	public function clear()
	{
		this.parent.remove(this._sprite);
		this.resource = "";
	}
	
	public function destroy()
	{
		this.parent.remove(this._sprite);
		
		Event.removeEventsForHandler(this._sprite);
		
		this.canvas = null;
		this.parent = null;
	}
	
	public function lightUp(item)
	{
		if(this.isHighlighted == 1) return;
		
		if(this.occupied == 0 || this.item == item) {
			this.highlightSprite = sprite("images/furniture/highlight.png");
		}
		else {
			this.highlightSprite = sprite("images/furniture/highlight02.png");
		}
		
		this.highlightSprite.pos(this.left, this.top);
		
		this.canvas.getSprite().add(this.highlightSprite, 99999999);
		
		this.isHighlighted = 1;
	}
	
	public function lightDown()
	{
		if(this.highlightSprite) {
			this.highlightSprite.removefromparent();
		}
		this.highlightSprite = null;
		this.isHighlighted = 0;
	}
	
	public function setFlatResource(resource, item_width, item_depth)
	{
		this.resource = resource;
		this.item_width = item_width;
		this.item_depth = item_depth;
	}
	
	public function setResource(resource, item_width, item_depth)
	{
		var newSprite = sprite(resource);
		newSprite.prepare();
		var size = newSprite.size();
		
		var itemWidth = size[0];
		var itemHeight = size[1];
		var x1000 = this.x * 1000;
		var y1000 = this.y * 1000;
		var itemWidth1000 = item_width * 1000;
		
		this.z = (x1000 + 1000 - itemWidth1000 / 2) + 1000;
				
		var left = this.left + this.width - itemWidth + ((5 * item_depth - 5) * this.width) / 10;
		var top = this.top + this.height - itemHeight;

		Event.removeEventsForHandler(this._sprite);

		var parent = this._sprite.parent();
		this._sprite.removefromparent();
		
		this._sprite = newSprite;
		this._sprite.pos(left, top);
		
		this.configureEvents();
		
		this.occupied = 1;
		
		parent.add(this._sprite, this.z);
	}
	
	public function removeItem()
	{
		this.item = null;
		this.occupied = 0;
		this.lightDown();
	}	
}
