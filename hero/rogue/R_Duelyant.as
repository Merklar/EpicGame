package hero.rogue
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class R_Duelyant extends Warrior
	{
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		private const DEBUFF_TIME:uint = 6;
		private const ATTACK_DOWN_PERSENT:Number = 0.3;
		
		//-------------------------------------------
		//  PRIVATE VARIABLES
		//-------------------------------------------
		private var enLength:uint;
		private var dif:Number;
		private var attackDownOn:Boolean = false;
		private var posionLength:uint = 8;
		private var posionTimer:uint = 0;
		
		public function R_Duelyant():void
		{
			super();
			immortal = false;
			missMelee = 50;
			name = "duelyant";
			discriptionName = "Дуэлянт";
			discription = "Специализированный герой ближнего боя. Имеет низкий показатель атаки, низкий - жизни и высокую скорость атаки";
			width = 60;
			height = 65;
			speed = 0.1;
			damageMinClean = damageMin = 5;
			exp = 0;
			level = 1;
			damageMaxClean = damageMax = 8;
			defenceX = 300;
			hitHeightAttack = 10;
			attackSpeedClean = attackSpeed = 1.0;
			atack_speed = 0.5;
			hp_max = 25 + 4 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "duelyant";
			price = 750;
			passiveDiscription = "При атаке – понижает вражескую силу удара.";
			ultimateDiscription = "50% вероятность уклониться от атаки ближнего боя (боссов в том числе)";
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
						if (attackDownOn == true)
						{
							enemyTemp.enemyAttackDown(DEBUFF_TIME, ATTACK_DOWN_PERSENT);
						}
						enemyTemp = null;
						attackTimer = 0;
					}
				}
			}
			//----------Применение ультимейт-способности---------------
			if (ultimate == true)
			{
				attackDownOn = true;
				this.swordMovieClip_1.gotoAndStop("posion");
				this.swordMovieClip_2.gotoAndStop("posion");
				if (++posionTimer % (FRAME_RATE * posionLength) == 0)
				{
					ultimate = false;
					attackDownOn = false;
					posionTimer = 0;
					this.swordMovieClip_1.gotoAndStop("none");
					this.swordMovieClip_2.gotoAndStop("none");
				}
			}
			// --------------Перезярядка ультимейт-способности----------
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
