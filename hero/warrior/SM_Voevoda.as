package hero.warrior
{
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class SM_Voevoda extends Warrior
	{
		
		private var enLength:uint;
		private var dif:Number;
		private var attackPowerUp:int = 10;
		
		public function SM_Voevoda():void
		{
			super();
			name = "voevoda";
			discriptionName = "Воевода";
			discription = "Герой ближнего боя. Имеет высокий показатель атаки. Вооружен, предположительно, двуручным мечем";
			width = 50;
			height = 60;
			speed = 0.1;
			level = 1;
			exp = 250;
			splashVer = 15;
			ultimateReady = true;
			ultimateReadyKD = 10;
			ultimateName = "attackSplash";
			ultimate = false;
			damageMinClean = damageMin = 9 + level;
			damageMaxClean = damageMax = 13 + level;
			defenceX = 300;
			hitHeightAttack = 20;
			price = 750;
			passiveDiscription = "15% шанс нанести урон нескольким врагам в небольшом радиусе";
			ultimateDiscription = "Взмах мечем – наносит средний урон всем противникам перед собой.";
			attackSpeedClean = attackSpeed = 2.0;
			atack_speed = 0.5;
			hp_max = FRAME_RATE + 5 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			dif = 1 / (FRAME_RATE * ultimateReadyKD);
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var distantion:Number;
			var range:int = 50; // Дистанция атаки стража
			var splashRange:int = 80;
			var xdiff:Number;
			var ydiff:Number;
			var enemy:MovieClip;
			if ((ENEMY !== null) && (ENEMY.length > 0) && (phase !== "figth") && (phase !== "go") && (phase !== "hit"))
			{
				var enLength:uint = ENEMY.length - 1;
				for (var i:uint = 0; i <= enLength; i++)
				{
					enemy = ENEMY[i];
					if (enemy !== null)
					{
						xdiff = enemy.x - this.x;
						ydiff = enemy.y - this.y;
						distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
						if ((distantion <= range) && (phase !== "figth") && (phase !== "defence"))
						{
							enemyTemp = enemy;
							phase = "figth";
							combatPhaze = true;
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
						combatPhaze = false;
					}
					if (++attackTimer % (FRAME_RATE * attackSpeed) == 0)
					{
						this.roundDamage();
						enemyTemp.imhit(damage, hitHeightAttack, this);
						phase = "attack";
						combatPhaze = false;
						attackTimer = 0;
						var verSplash:Number = Math.random() * 100;
						if (splashVer >= verSplash)
						{
							if ((ENEMY !== null) && (ENEMY.length > 0))
							{
								enLength = ENEMY.length - 1;
								for (var j:uint = 0; j <= enLength; j++)
								{
									enemy = ENEMY[j];
									if (enemy !== null)
									{
										xdiff = enemy.x - this.x;
										ydiff = enemy.y - this.y;
										distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
										if ((distantion <= splashRange))
										{
											enemyTemp = enemy;
											combatPhaze = true;
											this.roundDamage();
											enemyTemp.imhit(damage / 2, hitHeightAttack, this);
										}
									}
								}
							}
						}
					}
				}
			}
			if (ultimate == true)
			{
				if (this.weapon.currentFrameLabel == "simple")
				{
					this.weapon.gotoAndPlay("attack");
				}
				if ((this.weapon.tag !== null) && (ENEMY.length > 0))
				{
					for (var l:uint = 0; l <= enLength; l++)
					{
						enemy = ENEMY[l];
						if (enemy !== null)
						{
							if (this.weapon.tag.hitTestObject(enemy))
							{
								enemyTemp = enemy;
								combatPhaze = true;
								this.roundDamage();
								enemyTemp.imhit(damage, hitHeightAttack, this);
							}
						}
					}
					
				}
				ultimate = false;
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
