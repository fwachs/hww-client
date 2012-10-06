/*****************************************************************************
filename    sounds.as
author      Corey Blackburn
DP email    corey.blackburn@2clams.com
project     House Wife Wars

Brief Description:
   Represents a playable sound
*****************************************************************************/

class Sounds
{
	var loop;        // 0 - single play, 1 - loop
	var leftVolume;  // 0 - 100
	var rightVolume; // 0 - 100
	
	var list;
	var currentTrack = null;
	
	public function Sounds()
	{
		this.leftVolume = 100;
		this.rightVolume = 100;
		this.list = dict();
	}
	
	public function addSound(name, location)
	{
		var sound = createsound(location);
		this.list.update(name, sound);
		
		trace("### HWW ### - Added sound: " + name + " at location: " + location);
	}
	
	public function addMusic(name, location)
	{
		this.list.update(name, location);
		
		trace("### HWW ### - Added music: " + name + " at location: " + location);
	}
	
	public function playSFX(name)
	{		
		var sound = this.list.get(name);
		
		if(Game.audioOn() == 1) {
			sound.play(0, this.leftVolume, this.rightVolume, 10)
			trace("### HWW ### - Playing sound effect: " + name);
		}
	}
	
	public function playMusic(name)
	{
		var location = this.list.get(name);
		var sound = createaudio(location);
		sound.preparetoplay();
		this.currentTrack = sound;
		
		
		trace("### HWW ### - Is audio on? " + str(Game.audioOn()));
		if(Game.audioOn() == 1) {
			sound.play(-1);
			
			trace("### HWW ### - Playing music: " + name);
		}
	}
	
	public function pause()
	{
		if(this.currentTrack)
			this.currentTrack.pause();
	}
	
	public function resume()
	{
		if(this.currentTrack && Game.audioOn() == 1)
			this.currentTrack.play(-1);
	}
	
	public function stop()
	{
		if(this.currentTrack)
			this.currentTrack.stop();
		
		trace("### HWW ### - Stopping sound");
		
		this.currentTrack = null;
	}
	
	public function restart()
	{
		if(this.currentTrack) {
			this.currentTrack.stop();
			this.currentTrack.preparetoplay();
			this.currentTrack.play();
		}
	}
	
	public function setVolume(left, right)
	{
		this.leftVolume = left;
		this.rightVolume = right;
	}
	
	public function turnOff()
	{
		Game.getDatabase().put("soundOn", 0);
		this.setVolume(0, 0);
		this.pause();
	}
	
	public function turnOn()
	{
		Game.getDatabase().put("soundOn", 1);
		this.setVolume(100, 100);
		this.resume();
	}
}
