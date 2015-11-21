package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.sound.SfxFader;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PersonGrabbed extends Person
	{
		public var fading:Boolean = false;
		public var dead:Boolean = false;
		
		public var sndDrowning:Sfx = new Sfx(Assets.SND_DROWNING);
		public var drowningFader:SfxFader;
		
		public var escapeAlarm:Alarm;
		
		public function PersonGrabbed(x:Number = 0, y:Number = 0, angle:Number = 0, health:Number = 100, maxHealth:Number = 100) 
		{
			super(x, y, angle, health, maxHealth);
			visible = false;
			drowningFader = new SfxFader(sndDrowning);
		}
		
		override public function added():void
		{
			Global.globalPerson = this;
			addTween(drowningFader);
			super.added();

			escapeAlarm = new Alarm(Global.escapeTime, escape);
			addTween(escapeAlarm);
			escapeAlarm.start();			
		}
		
		override public function update():void
		{
			x = FP.world.mouseX;
			y = FP.world.mouseY;
			
			if (y > floatLevel + Global.FLOAT_LEVEL_VARIATION)
			{
				if (health > Global.MIN_HEALTH)
					health -= Global.HEALTH_LOSS_RATE;
					
				if (health > Global.MIN_HEALTH)
				{
					if (!sndHeartbeat.playing || sndHeartbeat.volume == 0) 
					{
						trace('loop heartbeat in');
						var vol:Number = 1 - FP.scaleClamp(health, Global.MIN_HEALTH, Global.BASE_HEALTH, 0, 1);
						sndHeartbeat.loop(vol);
						sndDrowning.loop(vol);
						heartbeatFader.fadeTo(1, 6);
						drowningFader.fadeTo(1, 6);
					}
				}
				else if (health > Global.MIN_HEALTH && !fading)
				{
					//heartbeatFader.fadeTo(0, 3);
					trace('stop heartbeat');
					fading = true;
					sndHeartbeat.stop();
					sndDrowning.stop();
					sndHeartbeatSingle.play();					
				}
				else if (health <= Global.MIN_HEALTH && !dead)
				{
					dead = true;
					health = Global.MIN_HEALTH - 1;

					//heartbeatFader.fadeTo(0, 0.5);
				}
			}
			else if (sndHeartbeat.playing)
			{
				//sndHeartbeat.stop();
				heartbeatFader.fadeTo(0, 1);
				sndDrowning.stop();
			}
			
			super.update();
		}
			
		override public function removed():void
		{
			heartbeatFader.cancel();
			drowningFader.cancel();
			if (sndHeartbeat.playing)
			{
				sndHeartbeat.stop();
			}
			if (sndDrowning.playing) sndDrowning.stop();
			super.removed();
		}		
		
		public function escape():void 
		{
			// Swim free.
			if (!Global.personGrabbed || this.health < Global.MIN_HEALTH) {
				return;
			}
			
			if (this.underWater()) {
				Global.mouseController.escapeJerk();
				Global.escapeTime += 3;
				
				var swimmer:PersonSwimming;
				FP.world.add(swimmer = new PersonSwimming(this.x, this.y, this.image.angle, this.health, this.maxHealth));
				swimmer.sndHeartbeat = this.sndHeartbeat;
				Global.personGrabbed = null;	
				trace('people killed ' + Global.peopleKilled);
				escapeAlarm.cancel();
				
				// Increase tension. See startDrowning() in PersonDrowning.as
				Global.peopleKilled += 1;
				Global.bloodOverlay.updateAlpha();	
				trace('Global.peopleKilled: ' + Global.peopleKilled);
				Global.scareDistance = Global.peopleKilled * 20;		
				Global.scareDistanceAfter = Global.scareDistance * 4;
				
				// Ambient sounds
				if (Global.peopleKilled == 1 && !Global.ambientController.sndHell01.playing)
				{
					Global.ambientController.playSpecificSound(Global.ambientController.sndHell01);
				}	
				else if (Global.peopleKilled == 2 && !Global.ambientController.sndHell02.playing)
				{
					Global.ambientController.playSpecificSound(Global.ambientController.sndHell02);
				}		
				else if (Global.peopleKilled == 3 && !Global.ambientController.sndHell03.playing)
				{
					Global.ambientController.playSpecificSound(Global.ambientController.sndHell03);
				}	
				else if (Global.peopleKilled >= 4 && !Global.ambientController.started)
				{
					Global.ambientController.start();
				}									
				
				this.destroy();
			}
		}
		
		public function underWater():Boolean 
		{
			if (y > floatLevel + Global.FLOAT_LEVEL_VARIATION)
			{
				return true;
			}				
			else 
			{
				return false;
			}
		}		
		
		//public function stopHeartbeat():void
		//{
			//sndHeartbeat.stop();
		//}
		//
		//override public function removed():void
		//{
			//sndHeartbeat.stop();
		//}
		
	}

}