/*****************************************************************************
filename    house.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     House Wife Wars

Brief Description:
   async helper class
*****************************************************************************/

class Runnable
{
	var calls = null;
	var callsCounter = 0;
	
	public function Runnable()
	{
		this.calls = new Array();
	}
	
	public function addCall(method, args)
	{
		this.calls.append([method, args]);
	}
	
	public function runSerialized(interval)
	{
		for(var i = 0; i < len(this.calls); i++) {
			var method = this.calls[i][0];
			var args = this.calls[i][1];
			
			method(args);			
		}
		
		return;
		
		c_invoke(this.callSerialized, interval, interval);
	}
	
	public function callSerialized(timer, tick, param)
	{
		var method = this.calls[this.callsCounter][0];
		var args = this.calls[this.callsCounter][1];
		
		method(args);
				
		this.callsCounter++;

		if(this.callsCounter < len(this.calls)) {
			c_invoke(this.callSerialized, param, param);
		}
	}
}
