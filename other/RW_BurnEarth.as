package other
{
	
	import flash.display.MovieClip;
	import hero.*;
	
	public class RW_BurnEarth extends RangeWeapon
	{
		
		//private var damage:Number;
		private var lifeTime:int = 7;
		private var iLife:uint = 0;
		private var burnTimer:int = 0;
		
		public function RW_BurnEarth(_damage:Number, _master:Warrior):void
		{
			super();
			width = 200;
			height = 10;
			damage = _damage;
			master = _master;
		}
		
		public function update():void
		{
			
			if (arrowLive == true)
			{
				if (iLife < lifeTime)
				{
					
					if (++burnTimer % (60 * 1) == 0)
					{
						
						var enemy_length:uint = ENEMY.length;
						if (enemy_length > 0)
						{
							for (var i:uint = 0; i < enemy_length; i++)
							{
								var enemy:MovieClip = ENEMY[i];
								if (hitTestObject(enemy) && arrowLive && (enemy.tween_active == false))
								{
									enemy.imhit(damage, hitHeightAttack, master);
								}
							}
						}
						iLife++;
					}
					
				}
				else
				{
					arrowLive = false;
					trace("i am dead");
				}
			}
		}
	}

}
