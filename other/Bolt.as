package other
{
	
	import flash.display.MovieClip;
	import hero.*;
	
	public class Bolt extends RangeWeapon
	{
		
		private var speedX:Number;
		private var speedY:Number;
		private var rotate:Number;
		private var angle:Number = -10 - Math.random() * 20;
		private const G:Number = 1.5;
		private var t:Number;
		
		public function Bolt(dMax:Number, dMin:Number, hH:int, _master:Warrior):void
		{
			super();
			width = 25;
			height = 5;
			hitHeightAttack = hH;
			damageMax = dMax;
			damageMin = dMin;
			master = _master;
			arrowSpeed = 5; // скорость полета снаряда
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
						if (enemy.onBoss == false) {
						if (hitTestObject(enemy) && arrowLive && (enemy.tween_active == false))
						{
							roundDamage();
							enemy.imhit(damage, hitHeightAttack, master);
								//break;
						}
						} else {
							// реализовать урон по боссу
						}
					}
				}
				if (this.x > 900)
				{
					arrowLive = false;
				}
			}
		}
	}

}
