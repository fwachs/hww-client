/*****************************************************************************
filename    carousel.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   
*****************************************************************************/

function rotateLoop(timer, tick, carousel)
{
/*
	trace("rotateLoop: ", timer, tick, carousel);
	
	carousel.counter--;
	
	for(var i = 0; i < len(carousel.elements); i++) {
		var e = carousel.elements[i];
		var element = e[0];
		var currentAngle = e[1];
		
		var x = sin(currentAngle) / 3 + 340;
		var y = cos(currentAngle) / 20 + 150;
	
		var scale = (cos(currentAngle) + 1000) / 6 + 666;
		var width = carousel.startWidth * scale / 1000;
		var height = carousel.startHeight * scale / 1000;
		
		y += (carousel.startHeight - height);
		
		element.size(Game.translateX(width), Game.translateY( height));
		element.pos(Game.translateX(x), Game.translateY( y));
		var parent = element.parent();
		element.removefromparent();
		parent.add(element, scale);
				
		carousel.elements[i][1] = currentAngle + carousel.step * carousel.direction;
	}
*/
}

class Carousel
{
	var currentAngle;
	var startHeight;
	var startWidth;
	var direction;
	var step;
	var elements;
	var selectedIndex;
	var counter;
	
	public function Carousel(type)
	{
		this.elements = new Array();
		this.currentAngle = 0;
		this.direction = 1;
		this.step = 4;
		this.selectedIndex = 0;
		this.counter = 0;
		
		if(type == "wife") {
			this.startHeight = 526;
			this.startWidth = 244;
		}
		else if(type == "hubby") {
			this.startHeight = 536;
			this.startWidth = 220;
		}
	}
	
	public function addElement(ele, angle)
	{
		var e = new Array(ele, angle);
		this.elements.append(e);		
		
		rotateLoop(null, 0, this);
		this.counter = 0;
	}
	
	public function rotateToIndex(idx)
	{
		if(this.selectedIndex == idx) return;
		
		trace("**** counter: ", this.counter);
		if(this.counter != 0) return;
		
		this.selectedIndex = idx;
		
		var e = this.elements[idx];
		var targetAngle = idx * 72;
		var loops = abs(targetAngle - this.currentAngle) / this.step;
		if(targetAngle > this.currentAngle) {
			this.direction = -1;
		}
		else {
			this.direction = 1;
		}

		trace("currentAngle: ", this.currentAngle, "targetAngle: ", targetAngle)
/*
		var deltaB = 360 - targetAngle + this.currentAngle;
		
		
		var loops;
		if(deltaA > deltaB) {
			loops = deltaB / this.step;
		}
		else {
			loops = deltaA / this.step;
		}
		
		if(loops > 0) {
			this.direction = -1;
		}
		else {
			this.direction = 1;
		}
		loops = abs(loops);
*/
		
		trace("Loops: ", loops, " direction:", this.direction);
		
		this.currentAngle = targetAngle;
		
		trace("new angle: ", this.currentAngle);
		
		this.counter = loops;
		
		c_addtimer(40, g_rotateLoop, this, 0, loops);
	}
}
