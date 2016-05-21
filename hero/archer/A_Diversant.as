package hero.archer
{
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class A_Diversant extends Warrior
	{
		
		private var arrow:Arrow;
		private var burnVer:uint = 20;
		private var enLength:uint;
		private var dif:Number;
		private var verBlock:Number;
		
		public function A_Diversant():void
		{
			super();
			name = "diversant";
			discriptionName = "Диверсант";
			discription = "Герой дальнего боя. Имеет средние показатели атаки и жизни, среднюю скорость стрельбы.";
			width = 50;
			exp = 0;
			height = 60;
			speed = 0.3;
			defenceX = 50;
			hitHeightAttack = 15;
			price = 750;
			passiveDiscription = "20% вероятность поджечь врага";
			ultimateDiscription = "Следующая стрела поджигает небольшую площадь там, где она упадет";
			damageMinClean = damageMin = 7 + level;
			damageMaxClean = damageMax = 10 + level;
			attackSpeedClean = attackSpeed = 3.75; // Время перезарядки
			atack_speed = 0.2; // Скорость движения во время атаки
			hp_max = 35 + 3 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "diversant";
			ultimate = false;
			ultimateReady = true;
			ultimateReadyKD = 10;
			dif = 1 / (FRAME_RATE * ultimateReadyKD);
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
						var verBlock:Number = Math.random() * 100;
						if (burnVer >= verBlock)
						{
							dotBurn = true;
						}
						arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this, dotBurn, burnEarth, false);
						arrow.x = this.x + this.width;
						arrow.y = this.y + this.height / 4;
						parent.addChild(arrow);
						this.ARROW.push(arrow);
						combatPhaze = false;
						arrow.index = this.ARROW.length - 1;
						attackTimer = 0;
						dotBurn = false;
						burnEarth = false;
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
					verBlock = Math.random() * 100;
					if (burnVer >= verBlock)
					{
						dotBurn = true;
					}
					arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this, dotBurn, burnEarth, false);
					arrow.x = this.x + this.width;
					arrow.y = this.y + this.height / 4;
					parent.addChild(arrow);
					this.ARROW.push(arrow);
					arrow.index = this.ARROW.length - 1;
					phase = "attack";
					combatPhaze = false;
					attackTimer = 0;
					dotBurn = false;
					burnEarth = false;
				}
			}
			if (ultimate == true)
			{
				
				burnEarth = true;
				ultimate = false;
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