package enemy
{
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import other.*;
	
	public class Enemy_mage extends Enemy
	{
		
		private var arrow:EnemyFireball;
		
		public function Enemy_mage():void
		{
			super();
			name = "enemy_mage";
			width = 50;
			height = 80;
			speed = -0.2;
			atack_speed = -0.2;
			damageMin = 8;
			damageMax = 16;
			gold = 25;
			expCoins = 60;
			hitHeightAttack = 10;
			attackSpeed = 6.5;
			hp = 20;
			this.hpText.text = hp;
		}
		
		public override function update():void
		{
			super.update();
			this.hpText.text = hp;
			var distantion:Number;
			var range:int = 300;
			var xdiff:Number;
			var enemy_h:MovieClip;
			if ((ARMY !== null) && (phase !== "figth") && (phase !== "hit") && (phase !== "paralise"))
			{
				var enLength:uint = ARMY.length - 1;
				for (var i:uint = 0; i <= enLength; i++)
				{
					enemy_h = ARMY[i];
					if (enemy_h !== null)
					{
						//trace(enemyTemp);	
						if (enemy_h.inActive == true)
						{
							xdiff = enemy_h.x - this.x;
							distantion = Math.sqrt(xdiff * xdiff);
							if ((distantion <= range) && (phase !== "figth"))
							{
								trace("Есть цель");
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
					phase = "go";
					arrow = new EnemyFireball(damageMax, damageMin, hitHeightAttack);
					arrow.x = this.x;
					arrow.y = this.y + this.height / 4;
					parent.addChild(arrow);
					this.ARROW.push(arrow);
					arrow.index = this.ARROW.length - 1;
					enemyTemp = null;
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
