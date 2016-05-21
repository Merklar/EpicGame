package other
{
	
	import flash.display.MovieClip;
	import hero.*;
	
	public class Arrow extends RangeWeapon
	{
		
		private var speedX:Number;
		private var speedY:Number;
		private var rotate:Number;
		private var angle:Number = -10 - Math.random() * 20;
		private const G:Number = 1.5;
		private var t:Number;
		private var dotDamage:int;
		private var dotDamageTime:uint = 6;
		private var arrow:RW_BurnEarth;
		private var kill:Boolean = false;
		public function Arrow(dMax:Number, dMin:Number, hH:int, _master:Warrior, _dot:Boolean, _burnEarth:Boolean, _kill:Boolean):void
		{
			super();
			width = 25;
			height = 5;
			kill = _kill;
			hitHeightAttack = hH;
			damageMax = dMax;
			damageMin = dMin;
			master = _master;
			dotOn = _dot;
			burnEarth = _burnEarth;
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
				var enemy_length:uint = ENEMY.length;
				if (enemy_length > 0)
				{
					for (var i:uint = 0; i < enemy_length; i++)
					{
						var enemy:MovieClip = ENEMY[i];
						if (hitTestObject(enemy) && arrowLive && (enemy.tween_active == false))
						{ 
							if (kill == false) {
							roundDamage();
							enemy.imhit(damage, hitHeightAttack, master);
							if (dotOn == true)
							{
								dotDamage = Math.floor(damage / 2);
								enemy.dotAttack("fire", dotDamage, dotDamageTime, master);
							}
							if (burnEarth == true)
							{
								arrow = new RW_BurnEarth(damage, master);
								arrow.x = this.x;
								arrow.y = 320;
								parent.addChild(arrow);
								this.ARROW.push(arrow);
								arrow.index = this.ARROW.length - 1;
							}
							arrowLive = false;
							break;
							} else {
								enemy.hp = 0;
								enemy.murder = master;
								arrowLive = false;
							break;
							}
						}
					}
				}
				if (this.y > 350)
				{
					if (burnEarth == true)
					{
						roundDamage();
						arrow = new RW_BurnEarth(damage, master);
						arrow.x = this.x;
						arrow.y = 325;
						parent.addChild(arrow);
						this.ARROW.push(arrow);
						arrow.index = this.ARROW.length - 1;
					}
					arrowLive = false;
				}
			}
		}
	}

}
