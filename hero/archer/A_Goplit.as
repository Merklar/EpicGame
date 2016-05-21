package hero.archer
{
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	import hero.*;
	
	public class A_Goplit extends Warrior
	{
		
		private var arrow:Arrow;
		private var enLength:uint;
		private var dif:Number;
		private var arrowNumber:uint = 0;
		private var arrowTimer:uint = 0;
		private var attackSpeedRange:uint;
		private const ULT_STATE_1:uint = 1;
		private const ULT_STATE_2:uint = 2;
		private var ultimateState:uint = ULT_STATE_1;
		private const ARROW_NUMBER:uint = 3;
		private const STATE_MELEE:uint = 1;
		private const STATE_RANGE:uint = 2;
		private var state:uint = STATE_RANGE;
		private const DISTANTION_RANGE:uint = 250;
		private const DISTANTION_MELEE:uint = 50;
		
		public function A_Goplit():void
		{
			super();
			name = "goplit";
			discriptionName = "Гоплит";
			discription = "Унифицированный герой. Имеет средние показатели атаки и жизни";
			width = 50;
			exp = 0;
			height = 60;
			speed = 0.3;
			defenceX = 50;
			hitHeightAttack = 15;
			damageMinClean = damageMin = 8 + level;
			damageMaxClean = damageMax = 11 + level;
			attackSpeedClean = attackSpeed = 1.0; // Время перезарядки
			attackSpeedRange = attackSpeed + 2.6;
			atack_speed = 0.2; // Скорость движения во время атаки
			hp_max = 45 + 3 * level;
			hpClean = hp = hp_max;
			this.hpText.text = hp;
			ultimateName = "goplit";
			price = 750;
			passiveDiscription = "Может, как и стрелять на средние дистанции так и бить в ближнем бою";
			ultimateDiscription = "Делает взмах клинком перед собой и выпускает 3 стрелы";
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
			var range:int; // Дистанция атаки лучника
			var xdiff:Number;
			var ydiff:Number;
			var enemy:MovieClip;
			var enLength:uint;
			if (state == STATE_RANGE) // Если Враг на расстоянии - стреляем по нему стрелами
			{
				range = DISTANTION_RANGE;
				if ((ENEMY !== null) && (ENEMY.length > 0) && (phase !== "figth") && (phase !== "hit"))
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
							if (distantion <= range)
							{
								enemyTemp = enemy;
								state = STATE_MELEE;
								trace(state);
								break;
							}
						}
					}
				}
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
						if (++attackTimer % (FRAME_RATE * attackSpeedRange) == 0)
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
					if (++attackTimer % (FRAME_RATE * attackSpeedRange) == 0)
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
			}
			else if (state == STATE_MELEE) // Если подошел на растояние удара - бьем в рукопашку
			{
				range = DISTANTION_MELEE;
				if ((ENEMY !== null) && (ENEMY.length > 0) && (phase !== "figth") && (phase !== "go") && (phase !== "hit"))
				{
					enLength = ENEMY.length - 1;
					for (var j:uint = 0; j <= enLength; j++)
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
								trace(enemyTemp, phase);
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
						if (distantion > DISTANTION_RANGE)
						{
							state = STATE_RANGE;
							trace(state);
							combatPhaze = false;
							return;
						}
						if (++attackTimer % (FRAME_RATE * attackSpeed) == 0)
						{
							this.roundDamage();
							enemyTemp.imhit(damage, hitHeightAttack, this);
							phase = "attack";
							trace("hit");
							combatPhaze = false;
							attackTimer = 0;
						}
					}
				}
			}
			//---------------Ультимейт способность имеет 2 фазы: 1 - залп стрел, 2 - взмах перед собой оружием----
			if (ultimate == true)
			{
				if (ultimateState == ULT_STATE_1)
				{
					if (arrowNumber < ARROW_NUMBER)
					{
						if (++arrowTimer % (FRAME_RATE * 0.4) == 0)
						{
							arrow = new Arrow(damageMax, damageMin, hitHeightAttack, this, false, false, false);
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
						ultimateState = ULT_STATE_2;
						arrowTimer = 0;
						arrowNumber = 0;
					}
				}
				else if (ultimateState == ULT_STATE_2)
				{
					if (++arrowTimer % (FRAME_RATE * 1) == 0)
					{
						if (this.weapon.currentFrameLabel == "simple")
						{
							this.weapon.gotoAndPlay("attack");
						}
						if ((this.weapon.tag !== null) && (ENEMY.length > 0))
						{
							for (var l:uint = 0; l <= enLength; l++)
							{
								enemy = ENEMY[l];
								if (enemy !== null)
								{
									if (this.weapon.tag.hitTestObject(enemy))
									{
										enemyTemp = enemy;
										combatPhaze = true;
										this.roundDamage();
										enemyTemp.imhit(damage, hitHeightAttack, this);
									}
								}
							}
							
						}
						arrowTimer = 0;
						ultimateState = ULT_STATE_1;
						ultimate = false;
					}
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