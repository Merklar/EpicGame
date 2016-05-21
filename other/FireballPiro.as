package other
{
	
	import flash.display.MovieClip;
	import hero.*;
	
	public class FireballPiro extends RangeWeapon
	{
		private var dotDamageTime:uint;
		
		public function FireballPiro(dMax:Number, _dotDamageTime:uint, hH:int, _master:Warrior)
		{
			super();
			width = 25;
			height = 25;
			master = _master;
			hitHeightAttack = hH;
			dotDamageTime = _dotDamageTime;
			damageMax = damageMin = dMax;
			arrowSpeed = 3; // скорость полета снаряда
		}
		
		public function update():void
		{
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
							
							//this.gotoAndPlay("boom");
							roundDamage();
							ballBoom();
							arrowLive = false;
							break;
						}
					}
				}
				if (this.x > 850)
				{
					arrowLive = false;
				}
			}
		}
		
		private function ballBoom():void
		{
			var _distantion:Number;
			var _range:int = 150;
			var _xdiff:Number;
			var _ydiff:Number;
			var _enemy_length:uint = ENEMY.length;
			if (_enemy_length > 0)
			{
				for (var i:uint = 0; i < _enemy_length; i++)
				{
					var _enemy:MovieClip = ENEMY[i];
					_xdiff = _enemy.x - this.x;
					_ydiff = _enemy.y - this.y;
					_distantion = Math.sqrt(_xdiff * _xdiff + _ydiff * _ydiff);
					if ((_distantion <= _range) && (_enemy !== null))
					{
						roundDamage();
						_enemy.imhit(damage, hitHeightAttack, master);
						damage = Math.round(damage/4);
						_enemy.dotAttack("fire", damage, dotDamageTime, master);
					}
				}
			}
		}
	}

}
