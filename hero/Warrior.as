package hero
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import other.*;
	import com.greensock.*;
	
	public class Warrior extends MovieClip
	{
		
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		private const MIN_ATACK_SPEED:Number = 0.2;
		public const FRAME_RATE:uint = 60;
		public const STAGE_WIDTH:uint = 650;
		public const POSITION_HERO:Vector.<uint> = Vector.<uint>([50, 100, 150, 200]);
		
		//-------------------------------------------
		//  PUBLIC VARIABLES
		//-------------------------------------------
		public var slot:MovieClip; //Слот юнита (в меню выбора воинов)
		public var position:uint; //Позиция героя при движении в очереди
		public var hp:*; // Жизни
		public var hpClean:*;
		public var hp_max:int;
		public var hp_clean:int;
		public var range:uint;
		public var immortal:Boolean = false;
		public var ultimateButton:MovieClip;
		public var ultimateReady:Boolean = false;
		public var ultimate:Boolean = false;
		public var item_1:Item = null;
		public var item_2:Item = null;
		public var item_3:Item = null;
		public var heroTags:String = "none";
		public var missRange:uint = 0;
		public var missMelee:uint = 0;
		public var ultimateName:String = "lock";
		public var discriptionName:String; // Имя юнита в информации
		public var discription:String; // Описание юнита в информации
		public var defenceVer:Number = 0;
		public var defenceVerClean:Number = 0;
		public var combatPhaze:Boolean = false;
		public var damageMin:int; // Минимальный урон
		public var damageMax:int; // Максимальный урон
		public var damageMinClean:int;
		public var damageMaxClean:int;
		public var phase:String;
		public var ARROW:Vector.<MovieClip>;
		public var BATTLE_TEXT:Vector.<MovieClip>;
		public var end_level:Boolean;
		public var EXP:Vector.<uint>;
		public var inActive:Boolean = false;
		public var exp:int; // Опыт юнита
		public var level:uint; // уровень юнита
		public var expMax:int;
		public var onLife:Boolean = true;
		public var combatPhazeGlobal:Boolean = false;
		public var burnEarth:Boolean = false;
		public var dotBurn:Boolean = false;
		public var ENEMY:Vector.<MovieClip>; //Массив с врагами, присылаемой из Стейджа
		public var ARMY:Vector.<MovieClip>; //Массив с союзниками, присылаемой из Стейджа
		public var tween_active:Boolean = false; // Активно ли сейчас состояние, после удара
		public var attackSpeedClean:Number;
		public var enemyTemp:MovieClip; //Текущая цель
		public var price:uint;
		public var ultimateDiscription:String;
		public var passiveDiscription:String;
		public var attackSpeed:Number; // Скорость Атаки
		
		//---------------------------------------
		// PROTECTED VARIABLES
		//---------------------------------------
		protected var hitHeight:int; // Высота прыжка, после удара
		protected var hitHeightAttack:int; // Сила подкидывающего удара
		protected var tween_go:Tween; //Твин предвижения
		protected var tween_hit:Tween; //Твин прыжка при ударе
		protected var tempY:Number; // Текущая координата Y юнита
		protected var hit_speed:Number = 0.4; // Скорость передвижения при попадании по объекту
		protected var atack_speed:Number; // Скорость передвижения при Атаке
		protected var attackTimer:int = 0; // Таймер для счета атаки
		protected var moveSpeed:Number = 1.5;
		protected var defenceX:int;
		protected var speed:Number;
		protected var attackUp:int = 0;
		protected var ultimateTimer:int = 0;
		protected var ultimateReadyTimer:int = 0;
		protected var ultimateReadyKD:uint;
		protected var splashVer:int = 0;
		protected var damage:int; //Средний урон
		protected var inAtack:Boolean = false;
		
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		private var attackModify:Number = 0;
		private var attackModifyTimer:uint = 0;
		private var attackModifyLength:uint = 0;
		
		public function Warrior():void
		{
		
		}
		
		public function update():void
		{
			//---------------Изменение атаки----------------------
			if (attackModify !== 0)
			{
				if (++attackModifyTimer % (FRAME_RATE * attackModifyLength) == 0)
				{
					attackModify = 0;
					attackModifyTimer = 0;
					trace("изменение закончилось закончилось");
				}
			}
			
			if (phase == "hit")
			{
				combatPhaze = true;
				if (tween_active == false)
				{
					tempY = this.y;
					tween_active = true;
					combatPhaze = true;
					TweenLite.to(this, 0.3, {x: "-15", y: "-" + hitHeight, onComplete: tween_down});
				}
			}
			
			if (this.hp <= 0) {
				onLife = false;
			}
		}
		
//Функция удаления экземпляра класса со сцены
		public function dispose():void
		{
			burnEarth = false;
			dotBurn = false;
			this.inActive = false;
			parent.removeChild(this);
			hp = hpClean + item_1.hp + item_2.hp + item_3.hp;
			trace("Удален");
		}
		
		//Действия при нажатии на кнопку "Идти"
		public function go():void
		{
			phase = "go";
			if (end_level == false)
			{
				if (tween_go !== null)
				{
					tween_go.stop();
				}
				if (combatPhazeGlobal == false)
				{
					tween_go = new Tween(this, "x", None.easeOut, this.x, POSITION_HERO[position], 180, false);
				}
				else
				{
					phase = "attack";
				}
			}
			if (this.x + this.width > STAGE_WIDTH)
			{
				this.x = STAGE_WIDTH - this.width;
			}
		}
		
//Действия при нажатии на кнопку "Атаковать"
		public function attack():void
		{
			phase = "attack";
			if (tween_go !== null)
			{
				tween_go.stop();
				
			}
		}
		
//Действия при нажатии на кнопку "Назад"
		public function back():void
		{
			phase = "back";
			if (tween_go !== null)
			{
				tween_go.stop();
				
			}
		}
		
//Действия при нажатии на кнопку "Защита"
		public function defence():void
		{
			phase = "defence";
			if (tween_go !== null)
			{
				tween_go.stop();
			}
			if (end_level == false)
			{
				tween_go = new Tween(this, "x", None.easeOut, this.x, defenceX + Math.random() * 40, 240, false);
			}
		}
		
//Событие изменения параметров, при одевании или снятии вещей
		public function updateItem():void
		{
			hp = hpClean + item_1.hp + item_2.hp + item_3.hp;
			damageMin = damageMinClean + item_1.ap + item_2.ap + item_3.ap;
			damageMax = damageMaxClean + item_1.ap + item_2.ap + item_3.ap;
			attackSpeed = attackSpeedClean - item_1.asp - item_2.asp - item_3.asp;
			if (attackSpeed < MIN_ATACK_SPEED) {
				attackSpeed = MIN_ATACK_SPEED;
			}
		}
		
//-----------------Реакция на удар врага----------------------------
		public function imhit(damage:int, _hitHeight:int, _damageType:String):void
		{
			var verBlock:Number = Math.random() * 100;
			var text:BattleText;
			if (tween_active == false)
			{
				if (_damageType == "melee")
				{
					//создание текста с уроном
					if (verBlock > missMelee)
					{
						if (tween_go !== null)
						{
							tween_go.stop();
						}
						if (verBlock >= defenceVer)
						{
							text = new BattleText(-1 * damage, "enemy");
							text.x = this.x;
							text.y = this.y;
							parent.addChild(text);
							BATTLE_TEXT.push(text);
							text.index = BATTLE_TEXT.length - 1;
							hitHeight = _hitHeight;
							phase = "hit";
							this.hp -= damage;
						}
						else
						{
							text = new BattleText("BLOCK", "enemy");
							text.x = this.x;
							text.y = this.y;
							parent.addChild(text);
							BATTLE_TEXT.push(text);
							text.index = BATTLE_TEXT.length - 1;
						}
					}
					else
					{
						text = new BattleText("MISS", "miss");
						text.x = this.x;
						text.y = this.y;
						parent.addChild(text);
						BATTLE_TEXT.push(text);
						text.index = BATTLE_TEXT.length - 1;
					}
				}
				else if (_damageType == "range")
				{
					if (verBlock > missRange)
					{
						if (tween_go !== null)
						{
							tween_go.stop();
						}
						if (verBlock >= defenceVer)
						{
							text = new BattleText(-1 * damage, "enemy");
							text.x = this.x;
							text.y = this.y;
							parent.addChild(text);
							BATTLE_TEXT.push(text);
							text.index = BATTLE_TEXT.length - 1;
							hitHeight = _hitHeight;
							phase = "hit";
							this.hp -= damage;
						}
						else
						{
							text = new BattleText("BLOCK", "enemy");
							text.x = this.x;
							text.y = this.y;
							parent.addChild(text);
							BATTLE_TEXT.push(text);
							text.index = BATTLE_TEXT.length - 1;
						}
					}
					else
					{
						text = new BattleText("MISS", "miss");
						text.x = this.x;
						text.y = this.y;
						parent.addChild(text);
						BATTLE_TEXT.push(text);
						text.index = BATTLE_TEXT.length - 1;
					}
				}
			}
		}
		
		//Модификатор атаки		
		public function heroAttackModify(_attackModifyLength:uint, _attackModify:Number)
		{
			attackModifyTimer = 0;
			attackModifyLength = _attackModifyLength;
			attackModify = _attackModify;
			trace("ослабление началось");
		}
		
		// Получение среднего урона
		public function roundDamage():void
		{
			damage = damageMin + Math.random() * (damageMax - damageMin) + attackUp;
			damage -= damage * attackModify;
			damage = Math.round(damage);
		}
		
		private function tween_down():void
		{
			TweenLite.to(this, 0.2, {y: tempY, onComplete: tween_down_2});
		}
		
		private function tween_down_2():void
		{
			phase = "attack";
			enemyTemp = null;
			combatPhaze = false;
			tween_active = false;
		}
	}

}