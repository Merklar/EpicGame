package hero.archer
{
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class A_Archer extends Warrior
	{
		
		private var arrow:Arrow;
		private var enLength:uint;
		private var dif:Number;
		private var arrowNumber:uint = 0;
		private var arrowTimer:uint = 0;
		
		public function A_Archer():void
		{
			super();
			name = "archer";
			discriptionName = "Лучник";
			discription = "Герой дальнего боя. Имеет низкие показатели атаки и жизни, повышенную скорость стрельбы.";
			width = 50;
			exp = 750;
			height = 60;
			speed = 0.3;
			defenceX = 50;
			hitHeightAttack = 15;
			damageMinClean = damageMin = 3 + level;
			damageMaxClean = damageMax = 6 + level;
			attackSpeedClean = attackSpeed = 3.0; // Время перезарядки
			atack_speed = 0.2; // Скорость движения во время атаки
			hp_max = 25 + 3 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "archer";
			price = 250;
			passiveDiscription = "Пассивной способности не имеет";
			ultimateDiscription = "Залп – выпускает сразу 3-5 стрел в воздух";
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
			var range:int = 300; // Дистанция атаки лучника
			var xdiff:Number;
			var ydiff:Number;
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
						arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this,false,false, false);
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
					arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this,false,false, false);
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
			if (ultimate == true)
			{
				if (arrowNumber < 5)
				{
					if (++arrowTimer % (FRAME_RATE * 0.4) == 0)
					{
						arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this,false,false, false);
						arrow.x = this.x + this.width;
						arrow.y = this.y + this.height / 4;
						parent.addChild(arrow);
						this.ARROW.push(arrow);
						combatPhaze = false;
						arrow.index = this.ARROW.length - 1;
						arrowNumber++;
					}
				}
				else
				{
					ultimate = false;
					arrowTimer = 0;
					arrowNumber = 0;
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