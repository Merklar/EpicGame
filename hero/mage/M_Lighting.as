package hero.mage
{
	
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class M_Lighting extends Warrior
	{
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		private const LIGTH_VER_START:uint = 20;
		private const LIGTH_VER_ULTIMATE:uint = 100;
		private const NUMBER_LIGTHING:uint = 3;
		private const LIGHTING_RANGE:uint = 100;
		private const ULTIMER_LENGTH:uint = 12;
		private const ULT_ATTACKSPEED_DELTA:Number = 4.0;
		
		//-------------------------------------------
		//  PRIVATE VARIABLES
		//-------------------------------------------
		private var number_ligth:uint = NUMBER_LIGTHING;
		private var ligth_ver:uint = LIGTH_VER_START;
		private var tempEnemys:Vector.<MovieClip> = new Vector.<MovieClip>;
		private var dif:Number;
		private var onUltimate:Boolean = false;
		private var enLength:uint;
		private var ultTimer:uint = 0;
		private var enemyTarget:MovieClip;
		private var attackSpeedTemp:Number;
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		public function M_Lighting()
		{
			super();
			name = "lighting";
			discriptionName = "Ловец молний";
			discription = "Герой дальнего боя. Имеет низкие показатели жизни и скорости атаки, но очень большую силу атаки";
			width = 50;
			height = 65;
			speed = 0.3;
			range = 250;
			hitHeightAttack = 20;
			//ultimateAttackPower = 30 + 5 * level;
			damageMinClean = damageMin = 15;
			damageMaxClean = damageMax = 25;
			defenceX = 150;
			attackSpeedClean = attackSpeed = 7; // Время перезарядки
			atack_speed = 0.2; // Скорость движения во время атаки
			hp_max = 15 + 1 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "lighting";
			price = 750;
			passiveDiscription = "25% вероятность цепной молнии (заденет еще ближайших врагов от цели)";
			ultimateDiscription = "на Х секунд увеличивает скорость атаки и дает 100% вероятность цепной молнии от удара";
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
				{
					var verBlock:Number = Math.random() * 100;
					if (verBlock >= ligth_ver)
					{
						this.roundDamage();
						//drawLighting(this, enemyTemp);
						enemyTemp.imhit(damage, hitHeightAttack, this);
						//Место для анимации молнии
						phase = "attack";
						attackTimer = 0;
						combatPhaze = false;
					}
					else
					{
						//Цепнуха
						while (number_ligth > 0)
						{
							number_ligth--;
							tempEnemys.push(enemyTemp);
							this.roundDamage();
							enemyTemp.imhit(damage, hitHeightAttack, this);
							enemyTemp.onEvent = true;
							enemyTarget = enemyTemp;
							enLength = ENEMY.length;
							for (var t:uint = 0; t < enLength; t++)
							{
								enemy = ENEMY[t];
								if ((enemy !== null) && (enemy.onEvent == false))
								{
									xdiff = enemy.x - enemyTarget.x;
									ydiff = enemy.y - enemyTarget.y;
									distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
									if (distantion <= LIGHTING_RANGE)
									{
										enemyTemp = enemy;
										break;
									}
								}
							}
						}
						number_ligth = NUMBER_LIGTHING;
						var tempMassLength = tempEnemys.length;
						for (var j:uint = 0; j < tempMassLength; j++)
							tempEnemys[i].onEvent = false;
					}
					phase = "attack";
					attackTimer = 0;
					combatPhaze = false;
					while (tempEnemys.length > 0)
					{
						tempEnemys.pop();
					}
				}
			}
			if (ultimate == true)
			{
				ligth_ver = LIGTH_VER_ULTIMATE;
				onUltimate = true;
				ultimate = false;
				attackSpeedTemp = attackSpeed;
				attackSpeed -= ULT_ATTACKSPEED_DELTA;
				if (attackSpeed < 1)
				{
					attackSpeed = 1;
				}
				trace("Ульта началась", attackSpeed);
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
			//----------------Длительность ульты-----------------------
			if (onUltimate == true)
			{
				if (++ultTimer % (FRAME_RATE * ULTIMER_LENGTH) == 0)
				{
					ligth_ver = LIGTH_VER_START;
					onUltimate = false;
					ultTimer = 0;
					attackSpeed = attackSpeedTemp;
					trace("Ульта кончилась");
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
		
		private function drawLighting(start:MovieClip, finish:MovieClip):void
		{
			graphics.lineStyle(2, 0x0000FF);
			graphics.moveTo(start.x, start.y);
			graphics.lineTo(finish.x, finish.y);
		}
	}

}
