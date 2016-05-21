package enemy
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import other.*;
	import hero.*;
	import com.greensock.*;
	
	public class Enemy extends MovieClip
	{
		
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		public const FRAME_RATE:uint = 60;
		
		//Переменные
		public var hp:*;
		public var onBoss:Boolean = false;
		public var index:int;
		public var ind_scr:int;
		public var dotDamage:int;
		public var dotOn:Boolean = false;
		public var dotTimer:uint;
		public var dotTimeEnemy:uint = 0;
		public var dotType:String;
		public var dotNumber:uint = 0;
		public var dotMurder:Warrior;
		public var paraliseTimer:uint = 0;
		public var paraliseLength:uint = 4;
		private var attackModify:Number = 0;
		private var attackModifyTimer:uint = 0;
		private var attackModifyLength:uint = 6;
		public var onEvent:Boolean = false;
		protected var damage:int;
		protected var damageMin:int;
		protected var damageMax:int;
		public var phase:String;
		public var gold:int;
		public var expCoins:int;
		public var murder:Warrior;
		protected var speed:Number;
		protected var exp:int;
		protected var level:uint;
		protected var atack_speed:Number;
		public var free:Boolean;
		protected var combatPhaze:Boolean = false;
		protected var attackTimer:int = 0;
		public var armor:int;
		public var speedDelta:Number;
		protected var attackSpeed:Number;
		protected var enemyTemp:MovieClip;
		protected var hit_speed:Number = 0.3;
		public var tween_active:Boolean = false; // Активно ли сейчас состояние, после удара
		public var movephase:String = "none";
		protected var hitHeight:int;
		protected var hitHeightAttack:int; // Сила подкидывающего удара
		protected var tween_go:Tween;
		protected var tween_hit:Tween;
		protected var tempY:Number;
		public var bolted:Boolean = false;
		public var BATTLE_TEXT:Vector.<MovieClip>;
		public var ARMY:Vector.<MovieClip>;
		public var ARROW:Vector.<MovieClip>;
		public var ENEMY:Vector.<MovieClip>;
		public var ENEMY_IN_SCREEN:Vector.<MovieClip>;
		
		public function Enemy():void
		{
			phase = "go";
			free = true;
		}
		
		//----------------------------------------------------
		//Отслеживание собитий в каждом кадре
		//----------------------------------------------------
		public function update():void
		{
			//---------------Ослабление атаки----------------------
			if (attackModify !== 0)
			{
				if (++attackModifyTimer % (FRAME_RATE * attackModifyLength) == 0)
				{
					attackModify = 0;
					attackModifyTimer = 0;
					trace("ослабление закончилось");
				}
			}
			//----------------------Урон дотом----------------------
			if (dotOn == true)
			{
				if (dotNumber < dotTimer)
				{
					if (++dotTimeEnemy % (FRAME_RATE * 1) == 0)
					{
						var text:BattleText;
						text = new BattleText(-1 * dotDamage, dotType);
						text.x = this.x;
						text.y = this.y;
						murder = dotMurder;
						parent.addChild(text);
						BATTLE_TEXT.push(text);
						text.index = BATTLE_TEXT.length - 1;
						this.hp -= dotDamage;
						dotNumber++
					}
				}
				else
				{
					dotOn = false;
					dotNumber = 0;
					trace("Дот закончился");
				}
			}
			
			if (phase == "hit")
			{
				if (tween_active == false)
				{
					tempY = this.y;
					tween_active = true;
					combatPhaze = true;
					TweenLite.to(this, 0.3, {x: "+15", y: "-" + hitHeight, onComplete: tween_down});
				}
			}
		}
		
		//----------------------------------------------------
		//Удаление класса
		//----------------------------------------------------
		public function dispose():void
		{
			ENEMY.splice(this.index, 1);
			for (var i:uint = this.index; i <= ENEMY.length - 1; i++)
			{
				ENEMY[i].index--;
			}
			ENEMY_IN_SCREEN.splice(this.ind_scr, 1);
			for (var j:uint = this.ind_scr; j <= ENEMY_IN_SCREEN.length - 1; j++)
			{
				ENEMY_IN_SCREEN[j].ind_scr--;
			}
			var text:BattleText = new BattleText(gold, "gold");
			text.x = this.x;
			text.y = this.y;
			parent.addChild(text);
			BATTLE_TEXT.push(text);
			text.index = BATTLE_TEXT.length - 1;
			parent.removeChild(this);
		}
		
		public function moveScreen():void
		{
			phase = "moveScreen";
		}
		
		public function go():void
		{
			phase = "go";
		}
		
		public function attack():void
		{
			if (phase !== "paralise")
			{
				phase = "attack";
			}
		}
		
		public function back():void
		{
			movephase = "back";
		}
		
		public function defence():void
		{
			phase = "defence";
		}
		
		public function paralise():void
		{
			phase = "paralise";
			paraliseTimer = 0;
		}
		
		//----------------------------------------------------
		//Атака ДОТа
		//----------------------------------------------------
		public function dotAttack(_dotType:String, _dotDamage:uint, _dotTimer:uint, _murder:Warrior):void
		{
			if (dotOn == false)
			{
				dotType = _dotType;
				dotDamage = _dotDamage;
				dotTimer = _dotTimer;
				dotMurder = _murder;
				dotOn = true;
			}
		}
		
		//----------------------------------------------------
		//Ослабление
		//----------------------------------------------------
		public function enemyAttackDown(_attackModifyLength:uint, _attackModify:Number)
		{
			attackModifyTimer = 0;
			attackModifyLength = _attackModifyLength;
			attackModify = _attackModify;
			trace("ослабление началось");
		}
		
		//-----------------Реакция на удар врага----------------------------
		public function imhit(damage:int, _hitHeight:int, _murder:Warrior):void
		{
			var text:BattleText;
			if (_hitHeight > 0)
			{
				if (tween_active == false)
				{
					text = new BattleText(-1 * damage, "allias");
					text.x = this.x;
					text.y = this.y;
					murder = _murder;
					parent.addChild(text);
					BATTLE_TEXT.push(text);
					text.index = BATTLE_TEXT.length - 1;
					if (onBoss == false)
					{
						hitHeight = _hitHeight;
						phase = "hit";
					}
					else
					{
						hitHeight = 0;
					}
					this.hp -= damage;
				}
			}
			else
			{
				text = new BattleText(-1 * damage, "allias");
				text.x = this.x;
				text.y = this.y;
				murder = _murder;
				parent.addChild(text);
				BATTLE_TEXT.push(text);
				text.index = BATTLE_TEXT.length - 1;
				if (onBoss == false)
				{
					hitHeight = _hitHeight;
					phase = "hit";
				}
				else
				{
					hitHeight = 0;
				}
				this.hp -= damage;
			}
		}
		
		protected function roundDamage():void
		{
			damage = Math.round(damageMin + Math.random() * (damageMax - damageMin));
			damage -= damage * attackModify;
			damage = Math.round(damage);
		}
		
		private function tween_down():void
		{
			TweenLite.to(this, 0.2, {y: tempY, onComplete: tween_down_2});
		}
		
		private function tween_down_2():void
		{
			phase = "go";
			tween_active = false;
			combatPhaze = false;
		}
	}

}
