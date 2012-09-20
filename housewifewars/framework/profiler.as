/*****************************************************************************
filename    profiler.as
author      Rafa Imas
DP email    rafael.imas@2clams.com
project     Papaya-Engine 2clams framework

Brief Description:
   profiling helper class
*****************************************************************************/

class Profiler
{	
	var points;
	var startTime;
	
	public function begin()
	{
		this.points = new Array();
		
		this.addPoint("start");
	}
	
	public function addPoint(name)
	{
		this.points.append([name, time()]);
	}
	
	public function end()
	{
		var report = dict();

		var prevT = this.points[0][1];
		for(var i = 1; i < len(this.points); i++) {
			var deltaT = this.points[i][1] - prevT;
			
			var totalT = report.get(this.points[i][0], 0);
			totalT += deltaT;
			
			report.update(this.points[i][0], totalT);
			
			prevT = this.points[i][1];
		}

		
		trace("!!! PROFILING REPORT BEGIN");
		
		var keys = report.keys();
		for(i = 0; i < len(keys); i++) {
			trace("!!!   ", keys[i], report.get(keys[i]));
		}
		
		trace("!!! PROFILING REPORT END");
	}
}
