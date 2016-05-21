package hero.archer
{
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class Archer_man extends Warrior
	{
		
		private var arrow:Arrow;
		
		public function Archer_man():void
		{
			super();
			name = "archer_man";
			discriptionName = "Охотник";
			discription = "Обычный юнит дальнего боя, имеет низкие показатели жизней, урона и скорости атаки";
			width = 65;
			exp = 250;
			height = 85;
			speed = 0.3;
			price = 250;
			defenceX = 50;
			ultimateDiscription = "Специальной способности не имеет";
			passiveDiscription = "Пассивной способности не имеет";
			hitHeightAttack = 15;
			damageMinClean = damageMin = 3 + level;
			damageMaxClean = damageMax = 6 + level;
			attackSpeedClean = attackSpeed = 4; // Время перезарядки
			atack_speed = 0.2; // Скорость движения во время атаки
			hp_max = 30 + 3 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var enemy:MovieClip;
			if ((ENEMY !== null) && (ENEMY.length > 0) && (phase !== "figth") && (phase !== "go") && (phase !== "hit") && (phase !== "defence"))
			{
				phase = "figth";
				combatPhaze = true;
				attackTimer = 0;
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
				if ((ENEMY !== null) && (ENEMY.length > 0))
				{
					if (++attackTimer % (FRAME_RATE * attackSpeed) == 0)
					{
						arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this, false, false, false);
						this.gotoAndPlay("attack");
						arrow.x = this.x + this.width;
						arrow.y = this.y + this.height / 4;
						parent.addChild(arrow);
						this.ARROW.push(arrow);
						combatPhaze = false;
						arrow.index = this.ARROW.length - 1;
						attackTimer = 0;
					}
				}
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
					arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this, false, false, false);
					this.gotoAndPlay("attack");
					arrow.x = this.x + this.width;
					arrow.y = this.y + this.height / 4;
					parent.addChild(arrow);
					this.ARROW.push(arrow);
					arrow.index = this.ARROW.length - 1;
					phase = "attack";
					combatPhaze = false;
					attackTimer = 0;
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