package hero.rogue
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class R_MasterYad extends Warrior
	{
		
		private var enLength:uint;
		private var numberHit:uint = 0;
		private var dif:Number;
		private var paraliseVer:uint = 30;
		private var posionOn:Boolean = false;
		private var posionLength:uint = 10;
		private var posionTimer:uint = 0;
		private var posionDamage:uint;
		private var posionDamageTime:uint = 5;
		
		public function R_MasterYad():void
		{
			super();
			immortal = false;
			name = "masteryad";
			discriptionName = "Мастер ядов";
			discription = "Герой ближнего боя. Имеет средний показатель атаки, низкий - жизни и среднюю скорость атаки";
			width = 55;
			height = 65;
			speed = 0.1;
			damageMinClean = damageMin = 5;
			exp = 0;
			level = 1;
			damageMaxClean = damageMax = 8;
			defenceX = 300;
			hitHeightAttack = 10;
			attackSpeedClean = attackSpeed = 1.5;
			atack_speed = 0.5;
			hp_max = 25 + 4 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "masteryad";
			price = 750;
			passiveDiscription = "10% вероятность парализовать противника";
			ultimateDiscription = "Смазывает клинки ядом – атаки вешают дот.";
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
			if ((ENEMY !== null) && (ENEMY.length > 0) && (phase !== "figth") && (phase !== "go") && (phase !== "hit"))
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
						var verRand:Number = Math.random() * 100;
						if (verRand < paraliseVer)
						{
							enemyTemp.paralise();
							trace("paralise");
						}
						if (posionOn == true)
						{
							posionDamage = Math.floor(damage / 2);
							enemyTemp.dotAttack("posion", posionDamage, posionDamageTime, this);
						}
						enemyTemp = null;
						attackTimer = 0;
					}
				}
			}
			if (ultimate == true)
			{
				posionOn = true;
				this.swordMovieClip_1.gotoAndStop("posion");
				this.swordMovieClip_2.gotoAndStop("posion");
				if (++posionTimer % (FRAME_RATE * posionLength) == 0)
				{
					ultimate = false;
					posionOn = false;
					posionTimer = 0;
					this.swordMovieClip_1.gotoAndStop("none");
					this.swordMovieClip_2.gotoAndStop("none");
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
