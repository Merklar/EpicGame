package enemy
{
	
	import flash.events.Event;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	
	public class Enemy_archer extends Enemy
	{
		
		private var arrow:ArrowEnemy;
		
		public function Enemy_archer()
		{
			super();
			name = "enemy_archer";
			width = 50;
			height = 60;
			speed = -0.1;
			atack_speed = -0.2;
			damageMin = 3;
			damageMax = 6;
			gold = 25;
			expCoins = 40;
			hitHeightAttack = 10;
			attackSpeed = 3.5;
			hp = 30;
			this.hpText.text = hp;
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var distantion:Number;
			var range:int = 350;
			var xdiff:Number;
			var ydiff:Number;
			var enemy_h:MovieClip;
			if ((ARMY !== null) && (phase !== "figth") && (phase !== "hit") && (phase !== "paralise"))
			{
				var enLength:uint = ARMY.length - 1;
				for (var i:uint = 0; i <= enLength; i++)
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
								phase = "figth";
								break;
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
			if ((phase == "figth") && (enemyTemp !== null))
			{
				this.x += speedDelta;
				if (++attackTimer % (FRAME_RATE * attackSpeed) == 0)
				{
					arrow = new ArrowEnemy(damageMax, damageMin, hitHeightAttack);
					arrow.x = this.x;
					arrow.y = this.y + this.height / 4;
					parent.addChild(arrow);
					this.ARROW.push(arrow);
					arrow.index = this.ARROW.length - 1;
					enemyTemp = null;
					phase == "go";
					attackTimer = 0;
				}
			}
			if (phase == "paralise")
			{
				if (++paraliseTimer % (FRAME_RATE * paraliseLength) == 0)
				{
					phase = "go";
					paraliseTimer = 0;
					trace("попустило");
				}
			}
		}	
	}

}
