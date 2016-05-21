package other
{
	
	import flash.display.MovieClip;
	
	public class ArrowEnemy extends RangeWeapon
	{
		
		private var speedX:Number;
		private var speedY:Number;
		private var rotate:Number;
		private var angle:Number = (10 + Math.random() * 20) + 180;
		private const G:Number = 1.5;
		private var t:Number;
		
		public function ArrowEnemy(dMax:Number, dMin:Number, hH:int):void
		{
			super();
			width = 25;
			height = 5;
			hitHeightAttack = hH;
			damageMax = dMax;
			damageMin = dMin;
			arrowSpeed = 3; // скорость полета снаряда
			t = 0;
		}
		
		public function update():void
		{
			//----------------Движение снаряда по баллистике-----------
			if (arrowLive == true)
			{
				speedX = arrowSpeed * Math.cos(angle * GRAD);
				speedY = arrowSpeed * Math.sin(angle * GRAD) + G * t * t / 2;
				rotate = Math.atan2(speedY, speedX) * RAD;
				this.x += speedX;
				this.y += speedY;
				this.rotation = rotate;
				t += 0.015;
				if (t >= 4)
				{
					t = 4;
				}
				//---------------------------------------------------------
				var enemy_length:uint = ARMY.length;
				if (enemy_length > 0)
				{
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
				}
				if (this.y > 350)
				{
					arrowLive = false;
				}
			}
		}
	}

}
