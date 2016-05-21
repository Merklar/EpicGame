package hero.warrior
{
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class SM_Paladin extends Warrior
	{
		
		private var enLength:uint;
		private var ultimateLength:int = 6;
		private var dif:Number;
		private var bubbleGive:Boolean = false;
		
		public function SM_Paladin():void
		{
			super();
			name = "paladin";
			discriptionName = "Паладин";
			discription = "Герой ближнего боя. Имеет очень высокий показатель жизни, но пониженную атаку. Вооружен молотом и щитом";
			width = 50;
			height = 60;
			speed = 0.1;
			level = 1;
			defenceVerClean = 30;
			defenceVer = 30;
			ultimateName = "god_shield";
			ultimate = false;
			exp = 0;
			ultimateReady = true;
			ultimateReadyKD = 10;
			damageMinClean = damageMin = 1 + level;
			damageMaxClean = damageMax = 5 + level;
			defenceX = 300;
			price = 750;
			passiveDiscription = "30% вероятность блокировать любую атаку врага";
			ultimateDiscription = "На короткое время создает вокруг себя небольшой купол. Все союзные герои, что попадают в него – получают 100% шанс блока";
			hitHeightAttack = 20;
			attackSpeedClean = attackSpeed = 1.5;
			atack_speed = 0.5;
			hp_max = 130 + 5 * level;
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
						phase = "attack";
						combatPhaze = false;
						attackTimer = 0;
					}
				}
			}
			if (ultimate == true)
			{
				//phase = "ultimate";
				if (bubbleGive == false)
				{
					for (var z:uint = 0; z < ARMY.length; z++)
					{
						var ourTemp:MovieClip = ARMY[z];
						if (ourTemp !== null)
						{
							xdiff = ourTemp.x - this.x;
							ydiff = ourTemp.y - this.y;
							range = 100;
							distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
							if (distantion <= range)
							{
								ourTemp.heroTags = "buble";
								ourTemp.defenceVer = 100;
								trace(ourTemp);
							}
						}
					}
					bubbleGive = true;
				}
				combatPhaze = true;
				if (++ultimateTimer % (FRAME_RATE * ultimateLength) == 0)
				{
					for (var w:uint = 0; w < ARMY.length; w++)
					{
						ourTemp = ARMY[w];
						if ((ourTemp !== null) && (ourTemp.heroTags == "buble"))
						{
							ourTemp.heroTags = "none";
							ourTemp.defenceVer = ourTemp.defenceVerClean;
							trace(ourTemp);
						}
					}
					bubbleGive = false;
					ultimate = false;
					ultimateTimer = 0;
					defenceVer = 30;
					combatPhaze = false;
					phase = "attack";
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
