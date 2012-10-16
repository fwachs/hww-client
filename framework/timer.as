/*****************************************************************************filename    timer.asauthor      Rafa ImasDP email    rafael.imas@2clams.comproject     House Wife WarsBrief Description:   Event handling*****************************************************************************/function timerHandler(firingTimer, tick, arg){		Timer.processTimers();}class Timer{	static var currentSecondsTick;	static var timersList = new dict();	static var lastTickCheck;	static var saveTicks = 0;	var seconds;	var remainingSeconds;	var ticks;	var name;	var listeners;	var running;	var repetitions;	var args;		public static function registerTimer(timer)	{		Timer.timersList.update(timer.name, timer);		if(timer.load() == 0) {			timer.reset();			timer.save();		}	}		public static function getTimer(name)	{		return Timer.timersList.get(name);	}		public static function registerListener(timerName, listener)	{		var timer = Timer.getTimer(timerName);		timer.listeners.append(listener);		}		public static function unregisterListener(timerName, listener)	{		var timer = Timer.getTimer(timerName);		timer.listeners.remove(listener);		}	public static function startTimers()	{		var storedTick = Game.sharedGame().getProperty("lastTimerSecondsTick");		if(storedTick) {			Timer.currentSecondsTick = storedTick;		}		else {			Timer.currentSecondsTick = 0;		}				trace("startTimers: ", storedTick)		c_addtimer(1000, timerHandler, null, 0, -1);	}		public static function updateTimerTick()	{		var ret = 1000;				var newTime = time();		var deltaT = abs(newTime - Timer.currentSecondsTick);		if(deltaT > 2000) {					ret = deltaT;		}		Timer.currentSecondsTick = newTime;				return ret / 1000;	}		public static function processTimers()	{		var deltaT = Timer.updateTimerTick();				var keys = Timer.timersList.keys();		for(var i = 0; i < len(keys); i++) {			var timer = Timer.timersList.get(keys[i]);						if(timer.running == 1) {				timer.remainingSeconds -= deltaT;					if(timer.remainingSeconds <= 0) {					var ticks = timer.run();						if (ticks == 0) {					 	timer.stop();					}				}			}		}				Timer.saveTimers();	}		public static function saveTimers()	{		if(Timer.saveTicks < 10) {			Timer.saveTicks++;			return;		}				trace("++++++ Saving timers");				Timer.saveTicks = 0;				Game.sharedGame().setProperty("lastTimerSecondsTick", Timer.currentSecondsTick);		var keys = Timer.timersList.keys();		for(var i = 0; i < len(keys); i++) {			var timer = Timer.timersList.get(keys[i]);						if(timer.running == 1) {				timer.save();			}		}	}		public function Timer(name, seconds, reps)	{		this.repetitions = reps;		this.ticks = this.repetitions;		this.seconds = seconds;		this.listeners = new Array();		this.name = name;		this.running = 0;		Timer.registerTimer(this)	}		public function tick()	{	}		public function run()	{		this.tick();		if(this.ticks > 0) {			this.ticks--;		}		for(var i = 0; i < len(this.listeners); i++) {			this.listeners[i].timerFired(this);		}		this.reset();				return this.ticks;	}		public function stop()	{/*		Timer.timersList.pop(this.name);        trace("### HWW ### - Removed timer from DB:", this.name);        Game.getDatabase().remove(this.timerDBKey());*/		this.running = 0;		this.save();	}		public function changeRunningTime(secs)	{		this.remainingSeconds += secs;				this.save();	}		public function reset()	{		this.remainingSeconds = this.seconds;				/* trace("resetting timer: ", this.name, this.seconds, this.firingMinutesTick, this.firingSecondsTick); */	}		public function restart()	{		this.reset();		this.ticks = this.repetitions;		this.running = 1;		this.save();	}		public function start()	{		this.running = 1;		this.save();			}		public function getTimeLeft()	{		return this.remainingSeconds;	}		public function getTimeString()	{		var timeLeft = this.getTimeLeft();		var minutes = timeLeft / 60;		var seconds = timeLeft - (minutes * 60);				if(len(str(seconds)) == 1)			return str(minutes) + ":0" + str(seconds);		else			return str(minutes) + ":" + str(seconds);	}		public function timerDBKey()	{		return "timer_" + str(this.name);	}	public function load() 	{        var timerData = Game.getDatabase().get(this.timerDBKey());        trace("### HWW ### - Fetched timer from DB:", this.name, timerData);                if(timerData == null) {	        this.remainingSeconds = 0;	        this.running = 0;	        this.args = dict();	        	        return 0;        }        var remSecs = timerData.get("remainingSeconds");        if(remSecs) {        	this.remainingSeconds = remSecs;        }        else {        	this.remainingSeconds = 0;        	        }        this.running = timerData.get("running");        this.args = timerData.get("args");                return 1;	}	    public function save()    {        var serializedTimer = this.serialize();        trace("### HWW ### - Saving Timer: ",str(serializedTimer));        Game.getDatabase().put(this.timerDBKey(), serializedTimer);    }    public function serialize()    {        var timerData = new dict([["name", this.name], ["remainingSeconds", this.remainingSeconds], ["running", this.running], ["args", this.args]]);        return timerData;    }}interface TimerListener{	public function timerFired(timer) {};}