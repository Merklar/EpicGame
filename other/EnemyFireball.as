package other
{
	
	import flash.display.MovieClip;
	
	public class EnemyFireball extends RangeWeapon
	{
		
		public function EnemyFireball(dMax:Number, dMin:Number, hH:int)
		{
			super();
			width = 25;
			height = 25;
			hitHeightAttack = hH;
			damageMax = dMax;
			damageMin = dMin;
			arrowSpeed = 3; // скорость полета снаряда
		}
		
		public function update():void
		{
			//----------------Движение снаряда по баллистике-----------
			if (arrowLive == true)
			{
				this.x -= arrowSpeed;
				//---------------------------------------------------------
				var enemy_length:uint = ARMY.length;
				for (var i:uint = 0; i < enemy_length; i++)
				{
					var enemy:MovieClip = ARMY[i];
					if (enemy !== null)
					{
						if (enemy.inActive == true)
						{
							if (hitTestObject(enemy) && arrowLive && (enemy.tween_active == false) && (enemy.immortal == false))
							{
								roundDamage();
								enemy.imhit(damage, hitHeightAttack, "range");
								arrowLive = false;
								break;
							}
						}
					}
				}
				if (this.x < -40)
				{
					arrowLive = false;
				}
			}
		}
	}

}
