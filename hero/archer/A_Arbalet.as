package hero.archer
{
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class A_Arbalet extends Warrior
	{
		
		private var arrow:Arrow;
		private var bolt:Bolt;
		private var enLength:uint;
		private var dif:Number;
		
		public function A_Arbalet():void
		{
			super();
			name = "arbalet";
			discriptionName = "Арбалетчик";
			discription = "Герой дальнего боя. Имеет средние атаки и жизни, но медленную скорость стрельбы";
			width = 50;
			exp = 0;
			height = 60;
			speed = 0.3;
			defenceX = 50;
			hitHeightAttack = 15;
			damageMinClean = damageMin = 10 + level;
			damageMaxClean = damageMax = 15 + level;
			attackSpeedClean = attackSpeed = 5.0; // Время перезарядки
			atack_speed = 0.2; // Скорость движения во время атаки
			hp_max = 40 + 3 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "arbalet";
			price = 250;
			passiveDiscription = "Пассивной способности не имеет";
			ultimateDiscription = "Стреляет болтом по прямой – и пробивает врагов насквозь";
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
						arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this, false, false, false);
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
				
				bolt = new Bolt(damageMax, damageMin, hitHeightAttack, this);
				bolt.x = this.x + this.width;
				bolt.y = this.y + this.height / 4;
				parent.addChild(bolt);
				this.ARROW.push(bolt);
				combatPhaze = false;
				bolt.index = this.ARROW.length - 1;
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