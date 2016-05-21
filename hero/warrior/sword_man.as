package hero.warrior
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
    import hero.*;
	
	public class sword_man extends Warrior
	{
		
		private var enLength:uint;
		
		public function sword_man():void
		{
			super();
			name = "sword_man";
			discriptionName = "Recruit";
			discription = "The farmer has a little dog, the bingo was his name The farmer has a little dog, the bingo was his name The farmer has a little dog, the bingo was his name";
			width = 70;
			height = 85;
			range = width - 10;
			speed = 0.1;
			level = 1;
			price = 250;
			ultimateDiscription = "The farmer has a little dog, the bingo was his name The farmer has a little dog, the bingo was his name The farmer has a little dog, the bingo was his name";
			passiveDiscription = "The farmer has a little dog, the bingo was his name The farmer has a little dog, the bingo was his name The farmer has a little dog, the bingo was his name";
			exp = 250;
			damageMinClean = damageMin = 4 + level;
			damageMaxClean = damageMax = 9 + level;
			defenceX = 300;
			hitHeightAttack = 40;
			attackSpeedClean = attackSpeed = 1.5;
			atack_speed = 0.5;
			hp_max = 50 + 5 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var distantion:Number;
			//var range: int = width; // Дистанция атаки роги
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
				this.mc.gotoAndPlay("walk");
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
						this.mc.gotoAndPlay("attack");
						enemyTemp.imhit(damage, hitHeightAttack, this);
						phase = "attack";
						combatPhaze = false;
						attackTimer = 0;
						return;
					}
				} else {
					phase = "attack";
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
