package enemy
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	
	public class Enemy_meele extends Enemy
	{
		
		public function Enemy_meele():void
		{
			super();
			name = "enemy_melee";
			width = 75;
			height = 85;
			speed = -0.1;
			atack_speed = -0.5;
			damageMin = 6;
			damageMax = 8;
			gold = 20;
			expCoins = 50;
			hitHeightAttack = 40;
			attackSpeed = 1.5;
			hp = 60;
			this.hpText.text = hp;
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var distantion:Number;
			var range:int = width - 10;
			var xdiff:Number;
			var ydiff:Number;
			var enemy_h:MovieClip;
			if ((ARMY !== null) && (phase !== "figth") && (phase !== "hit") && (phase !== "paralise"))
			{
				var enLength:uint = ARMY.length;
				for (var i:uint = 0; i < enLength; i++)
				{
					enemy_h = ARMY[i];
					if (enemy_h !== null)
					{
						if (enemy_h.inActive == true)
						{
							xdiff = enemy_h.x - this.x;
							ydiff = enemy_h.y - this.y;
							distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
							if ((distantion <= range) && (phase !== "figth"))
							{
								enemyTemp = enemy_h;
								enemyTemp.combatPhaze = true;
								phase = "figth";
								break;
							}
						}
					}
				}
			}
//---------------------------------------------------
			if (phase == "go")
			{
				this.x += speed + speedDelta;
			}
			if (phase == "figth")
			{
				xdiff = enemyTemp.x - this.x;
				ydiff = enemyTemp.y - this.y;
				distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
				if (distantion > range)
				{
					phase = "go";
					trace("Потеря цели");
					combatPhaze = false;
				}
				if (++attackTimer % (FRAME_RATE * attackSpeed) == 0)
				{
					//Высчитываем среднее значение урона и наносим его по врагу
					this.roundDamage();
					this.mc.gotoAndPlay("attack");
					if ((enemyTemp.inActive == true) && (enemyTemp.immortal == false))
					{
						enemyTemp.imhit(damage, hitHeightAttack, "melee");
					}
					enemyTemp = null;
					phase = "go";
					attackTimer = 0;
				}
			}
			if (phase == "paralise")
			{
				if (++paraliseTimer % (FRAME_RATE * paraliseLength) == 0)
				{
					phase = "go";
					paraliseTimer = 0;
					trace("попустило");
				}
			}
		
		}
		
	}

}