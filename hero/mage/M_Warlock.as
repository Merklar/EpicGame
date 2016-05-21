package hero.mage
{
	
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class M_Warlock extends Warrior
	{
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		private const DEBUFF_TIME:uint = 8;
		private const KILL_VER:uint = 5;
		private const ATTACK_DOWN_PERSENT:Number = 0.5;
		//-------------------------------------------
		//  PRIVATE VARIABLES
		//-------------------------------------------
		private var arrow:Fireball;
		private var arrowU:FireballWarl;
		private var ultimateAttackPower:uint;
		private var dif:Number;
		private var enLength:uint;
		private var onKills:Boolean = false;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		public function M_Warlock()
		{
			super();
			name = "warlock";
			discriptionName = "Чернокнижник";
			discription = "Герой дальнего боя. Имеет средние показатели жизни и скорости атаки, но очень большую силу атаки";
			width = 50;
			height = 65;
			speed = 0.3;
			range = 250;
			hitHeightAttack = 20;
			ultimateAttackPower = 30 + 2 * level;
			damageMinClean = damageMin = 15;
			damageMaxClean = damageMax = 25;
			defenceX = 150;
			attackSpeedClean = attackSpeed = 7; // Время перезарядки
			atack_speed = 0.2; // Скорость движения во время атаки
			hp_max = 25 + 2 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "warlock";
			price = 750;
			passiveDiscription = "5% вероятность убить цель (не босса)";
			ultimateDiscription = "Пускает шар тьмы, наносящий едино разово массовый урон и снижающий силу атаки врага на некоторое время";
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
				{   var verBlock:Number = Math.random() * 100;
				    if (verBlock <= KILL_VER) {
						onKills = true;
					}
					arrow = new Fireball(damageMax, damageMin, hitHeightAttack, this, onKills);
					arrow.x = this.x + this.width;
					arrow.y = this.y + this.height / 4;
					parent.addChild(arrow);
					this.ARROW.push(arrow);
					arrow.index = this.ARROW.length - 1;
					phase = "attack";
					attackTimer = 0;
					combatPhaze = false;
					onKills = false;
				}
			}
			if (ultimate == true)
			{
				arrowU = new FireballWarl(ultimateAttackPower, DEBUFF_TIME, hitHeightAttack, this, ATTACK_DOWN_PERSENT);
				arrowU.x = this.x + this.width;
				arrowU.y = this.y + this.height / 4;
				parent.addChild(arrowU);
				this.ARROW.push(arrowU);
				arrowU.index = this.ARROW.length - 1;
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
