package hero.mage
{
	
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class Mage extends Warrior
	{
		
		private var arrow:Fireball;
		
		public function Mage()
		{
			super();
			name = "mage";
			discriptionName = "Маг";
			discription = "Юнит дальнего боя, умеет кастовать различные заклинания";
			width = 50;
			height = 65;
			speed = 0.3;
			hitHeightAttack = 20;
			price = 250;
			exp = 250;
			ultimateDiscription = "Специальной способности не имеет";
			passiveDiscription = "Пассивной способности не имеет";
			damageMinClean = damageMin = 10;
			damageMaxClean = damageMax = 20;
			defenceX = 150;
			attackSpeedClean = attackSpeed = 5; // Время перезарядки
			atack_speed = 0.2; // Скорость движения во время атаки
			hp_max = 20 + 2 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var distantion:Number;
			var range:int = 250; // Дистанция атаки лучника
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
						if ((distantion <= range) && (phase !== "figth"))
						{
							enemyTemp = enemy;
							combatPhaze = true;
							phase = "figth";
							break;
						}
					}
				}
			}
			if (phase == "go")
			{
				attackTimer = 0;
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
				attackTimer = 0;
			}
			if (phase == "figth")
			{
				if (tween_go !== null)
				{
					tween_go.stop();
				}
				if (++attackTimer % (FRAME_RATE * attackSpeed) == 0)
				{
					arrow = new Fireball(damageMax, damageMin, hitHeightAttack, this, false);
					arrow.x = this.x + this.width;
					arrow.y = this.y + this.height / 4;
					parent.addChild(arrow);
					this.ARROW.push(arrow);
					arrow.index = this.ARROW.length - 1;
					phase = "attack";
					attackTimer = 0;
					combatPhaze = false;
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
