package hero.warrior
{
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class SM_Veteran extends Warrior
	{
		
		private var enLength:uint;
		private var dif:Number;
		private var attackPowerUp:int = 10;
		
		public function SM_Veteran():void
		{
			super();
			name = "veteran";
			discriptionName = "Ветеран";
			discription = "Юнит ближнего боя, имеет высокий показатели урона и средние жизней и скорости атаки";
			width = 50;
			height = 60;
			speed = 0.1;
			level = 1;
			exp = 250;
			ultimateReady = true;
			ultimateReadyKD = 10;
			ultimateName = "attackPowerUp";
			ultimate = false;
			damageMinClean = damageMin = 9 + level;
			damageMaxClean = damageMax = 13 + level;
			price = 500;
			passiveDiscription = "Пассивной способности не имеет";
			ultimateDiscription = "Следующий удар, будет усиленный в 2-3 раза.";
			defenceX = 300;
			hitHeightAttack = 20;
			attackSpeedClean = attackSpeed = 1.5;
			atack_speed = 0.5;
			hp_max = 50 + 5 * level;
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
						attackUp = 0;
						this.swordMovieClip.gotoAndStop("simple");
						ultimate = false;
						phase = "attack";
						combatPhaze = false;
						attackTimer = 0;
					}
				}
			}
			if (ultimate == true)
			{
				attackUp = attackPowerUp;
				this.swordMovieClip.gotoAndStop("rage");
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
