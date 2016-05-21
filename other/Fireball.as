package other
{
	
	import flash.display.MovieClip;
	import hero.*;
	
	public class Fireball extends RangeWeapon
	{
		
		private var _kill:Boolean = false;
		
		public function Fireball(dMax:Number, dMin:Number, hH:int, _master:Warrior, kill:Boolean)
		{
			super();
			width = 25;
			height = 25;
			master = _master;
			hitHeightAttack = hH;
			_kill = kill;
			damageMax = dMax;
			damageMin = dMin;
			arrowSpeed = 3; // скорость полета снаряда
		}
		
		public function update():void
		{
			//----------------Движение снаряда по баллистике-----------
			if (arrowLive == true)
			{
				this.x += arrowSpeed;
				//---------------------------------------------------------
				var enemy_length:uint = ENEMY.length;
				if (enemy_length > 0)
				{
					for (var i:uint = 0; i < enemy_length; i++)
					{
						var enemy:MovieClip = ENEMY[i];
						if (hitTestObject(enemy) && arrowLive && (enemy.tween_active == false))
						{
							if (_kill == false)
							{
								roundDamage();
								enemy.imhit(damage, hitHeightAttack, master);
								arrowLive = false;
								break;
							}
							else
							{
								enemy.hp = 0;
								enemy.murder = master;
								arrowLive = false;
								trace("Ваншот");
							}
						}
					}
				}
				if (this.x > 850)
				{
					arrowLive = false;
				}
			}
		}
	}

}
