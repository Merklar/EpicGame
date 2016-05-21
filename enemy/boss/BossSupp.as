package enemy.boss
{
	import enemy.*;
    import flash.display.MovieClip;
	
	/**
	 * ...
	 * @Merklar
	 */
	public class BossSupp extends Enemy 
	{
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		private var SUMMONG_PERIOD:uint = 6;
		private var SUMMONG_RANGE:uint = 150;
		private var SUMMONG_RANGE_MAX:uint = 500;
		
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		private var _summongTimer:uint = 0;
		
		public function BossSupp():void
		{
			super();
			name = "boss_support";
            width = 100;
			height = 120;
			speed = -0.2;
			atack_speed = - 0.1;
			damageMin = 15;
			damageMax = 30;
			gold = 200;
			expCoins = 500;
			hitHeightAttack = 40;
			attackSpeed = 3.5;
			hp = 600;
			onBoss = true;
			this.hpText.text = hp;
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var distantion:Number;
			var range:int = width - 10;
			var xdiff:Number;
			var ydiff:Number;
			var enemy_h:MovieClip;
			if ((ARMY !== null) && (phase !== "figth") && (phase !== "hit"))
			{
				var enLength:uint = ARMY.length;
				for (var i:uint = 0; i < enLength; i++)
				{
					enemy_h = ARMY[i];
					if (enemy_h !== null)
					{
						if (enemy_h.inActive == true)
						{
							xdiff = enemy_h.x - this.x;
							ydiff = enemy_h.y - this.y;
							distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
							if ((distantion <= range) && (phase !== "figth"))
							{
								enemyTemp = enemy_h;
								enemyTemp.combatPhaze = true;
								phase = "figth";
								break;
							}
							if ((distantion > SUMMONG_RANGE) && (distantion <= SUMMONG_RANGE_MAX)) {
								phase = "summong";
							}
						}
					}
				}
			}
//---------------------------------------------------
			if (phase == "go")
			{
				this.x += speed + speedDelta;
			}
			if (phase == "figth")
			{
				xdiff = enemyTemp.x - this.x;
				ydiff = enemyTemp.y - this.y;
				distantion = Math.sqrt(xdiff * xdiff + ydiff * ydiff);
				if (distantion > range)
				{
					phase = "go";
					trace("Потеря цели");
					combatPhaze = false;
				}
				if (++attackTimer % (FRAME_RATE * attackSpeed) == 0)
				{
					//Высчитываем среднее значение урона и наносим его по врагу
					this.roundDamage();
					//this.mc.gotoAndPlay("attack");
					if ((enemyTemp.inActive == true) && (enemyTemp.immortal == false))
					{
						enemyTemp.imhit(damage, hitHeightAttack, "melee");
					}
					enemyTemp = null;
					phase = "go";
					attackTimer = 0;
				}
			}
			if (phase == "paralise")
			{
					phase = "go";
			}
		
			if (phase == "summong") {
				this.x += speedDelta;
				if (++_summongTimer % (FRAME_RATE * SUMMONG_PERIOD) == 0)
				{
					var _minion:BossMinion = new BossMinion();
					_minion.x = this.x - 30;
					_minion.y = this.y + 40;
					parent.addChild(_minion);
					ENEMY.push(_minion);
                    _minion.index = ENEMY.length - 1;
					_summongTimer = 0;
				}
			}
		}
	}
	
}