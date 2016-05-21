package hero.rogue
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class R_killer extends Warrior
	{
		
		private var enemyTarget:MovieClip;
		private var enLength:uint;
		private var enemyTargetDistanse:int;
		private var heroTempPosition:int;
		private var dif:Number;
		private var searchTarget:Boolean = false;
		
		public function R_killer():void
		{
			super();
			immortal = false;
			name = "killer";
			discriptionName = "Убийца";
			discription = "Юнит ближнего боя, имеет низкие показатели жизней и скорости атаки, но очень высокий урон";
			width = 60;
			height = 65;
			speed = 0.1;
			damageMinClean = damageMin = 12;
			exp = 750;
			level = 1;
			damageMaxClean = damageMax = 18;
			defenceX = 300;
			hitHeightAttack = 10;
			attackSpeedClean = attackSpeed = 2.0;
			atack_speed = 0.5;
			hp_max = 25 + 4 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "killer";
			price = 250;
			passiveDiscription = "Пассивной способности не имеет";
			ultimateDiscription = "Появляется за спиной врага и наносит едино разово большой урон – после возвращается назад";
			ultimate = false;
			ultimateReady = true;
			ultimateReadyKD = 10;
			dif = 1 / (FRAME_RATE * ultimateReadyKD);
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var distantion:Number;
			var range:int = 50; // Дистанция атаки роги
			var xdiff:Number;
			var ydiff:Number;
			var enemy:MovieClip;
			if ((ENEMY !== null) && (ENEMY.length > 0) && (phase !== "figth") && (phase !== "go") && (phase !== "hit") && (phase !== "ultimate") && (phase !== "blink") && (phase !== "backstab"))
			{
				enLength = ENEMY.length - 1;
				for (var i:uint = 0; i <= enLength; i++)
				{
					enemy = ENEMY[i];
					if (enemy !== null)
					{
						xdiff = enemy.x - this.x;
						ydiff = enemy.y - this.y;
						distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
						if ((distantion <= range) && (phase !== "figth") && (enemyTemp == null))
						{
							combatPhaze = true;
							enemyTemp = enemy;
							phase = "figth";
							break;
						}
					}
				}
			}
			if (phase == "go")
			{
				if (end_level == true)
				{
					this.x += moveSpeed;
				}
			}
			if (phase == "attack")
			{
				this.x += atack_speed;
			}
			if (phase == "defence")
			{
				//this.x -= speed;
			}
			if (phase == "back")
			{
				this.x -= atack_speed;
			}
			if (phase == "figth")
			{
				if (enemyTemp !== null)
				{
					xdiff = enemyTemp.x - this.x;
					ydiff = enemyTemp.y - this.y;
					distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
					if (distantion > range)
					{
						phase = "attack";
						enemyTemp = null;
						combatPhaze = false;
					}
					if (++attackTimer % (FRAME_RATE * attackSpeed) == 0)
					{
						this.roundDamage();
						enemyTemp.imhit(damage, hitHeightAttack, this);
						phase = "attack";
						enemyTemp = null;
						attackTimer = 0;
					}
				}
			}
			if (ultimate == true)
			{
				phase = "ultimate";
				immortal = true;
				combatPhaze = true;
				enemyTarget = null;
				heroTempPosition = this.x;
				enemyTargetDistanse = 10000;
				searchTarget = true;
				if ((searchTarget == true) && (ENEMY.length > 0))
				{
					for (var j:uint = 0; j <= enLength; j++)
					{
						enemy = ENEMY[j];
						if (enemy !== null)
						{
							xdiff = enemy.x - this.x;
							ydiff = enemy.y - this.y;
							distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
							if ((distantion <= 400))
							{
								if (distantion <= enemyTargetDistanse)
								{
									enemyTarget = enemy;
									enemyTargetDistanse = distantion;
								}
							}
						}
					}
				}
				ultimate = false;
				searchTarget = false;
				phase = "backstab";
			}
			if (phase == "backstab")
			{
				if (++ultimateTimer % (FRAME_RATE * 1) == 0)
				{
					if (enemyTarget !== null)
					{
						this.x = enemyTarget.x + 60 ;
						this.roundDamage();
						enemyTarget.imhit(damage * 3, hitHeightAttack, this);
					}
					ultimateTimer = 0;
					phase = "blink";
				}
			}
			if (ultimateReady == false)
			{
				this.ultimateButton.ultimateProgress.scaleY -= dif;
				if (++ultimateReadyTimer % (FRAME_RATE * ultimateReadyKD) == 0)
				{
					ultimateReady = true;
					this.ultimateButton.ultimateProgress.scaleY = 0;
					ultimateReadyTimer = 0;
				}
			}
			if (phase == "blink")
			{
				if (++ultimateTimer % (FRAME_RATE * 0.5) == 0)
				{
					this.x = heroTempPosition;
					ultimateTimer = 0;
					combatPhaze = false;
					phase = "attack";
					immortal = false;
				}
			}
			if (this.x > 600)
			{
				this.x = 600;
			}
			if (this.x < 0)
			{
				this.x = 0;
			}
			if ((ENEMY !== null) && (ENEMY.length == 0))
			{
				combatPhaze = false;
			}
		}
		
	}

}
