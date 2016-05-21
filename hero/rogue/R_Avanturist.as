package hero.rogue
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class R_Avanturist extends Warrior
	{
		
		private var enemyTarget:MovieClip;
		private var enLength:uint;
		private var enemyTargetDistanse:int;
		private var numberHit:uint = 0;
		private var dif:Number;
		private var searchTarget:Boolean = false;
		
		public function R_Avanturist():void
		{
			super();
			immortal = false;
			name = "avanturist";
			discriptionName = "Авантюрист";
			discription = "Герой ближнего боя. Имеет низкие показатели атаки и жизни, но очень быструю скорость атаки";
			width = 55;
			height = 65;
			speed = 0.1;
			damageMinClean = damageMin = 4;
			exp = 0;
			level = 1;
			damageMaxClean = damageMax = 7;
			defenceX = 300;
			hitHeightAttack = 10;
			attackSpeedClean = attackSpeed = 0.8;
			atack_speed = 0.5;
			hp_max = 30 + 4 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "avanturist";
			price = 250;
			passiveDiscription = "Пассивной способности не имеет";
			ultimateDiscription = "Наносит врагу пере собой быструю серию из 5-6 ударов.";
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
			if ((ENEMY !== null) && (ENEMY.length > 0) && (phase !== "figth") && (phase !== "go") && (phase !== "hit") && (phase !== "ultimate") && (phase !== "multikick"))
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
				searchTarget = true;
				enemyTargetDistanse = 1000;
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
							if ((distantion <= 70))
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
				phase = "multikick";
			}
			//---Нанесение серии ударов! ВНИМАНИЕ, ГОВНОКОД! По возможности разобраться!!!!!
			if (phase == "multikick")
			{
				if (numberHit < 5)
				{
					if (++ultimateTimer % (FRAME_RATE * 0.1) == 0)
					{
						if (enemyTarget !== null)
						{
							if (enemyTarget.hp == 0)
							{
								enemyTarget = null;
							}
						}
						if (enemyTarget !== null)
						{
							this.roundDamage();
							enemyTarget.imhit(damage, 0, this);
							numberHit++;
						}
						else
						{
							ultimateTimer = 0;
							numberHit = 0;
							phase = "attack";
							immortal = false;
							combatPhaze = false;
							return;
						}
					}
				}
				else
				{
					ultimateTimer = 0;
					numberHit = 0;
					phase = "attack";
					immortal = false;
					combatPhaze = false;
				}
			}
//----------------------------------------------------------------------------
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
