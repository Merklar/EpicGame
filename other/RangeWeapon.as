package other

{
	import flash.display.MovieClip;
	import hero.*;
	
	public class RangeWeapon extends MovieClip
	{
		
		protected var damage:Number;
		protected var damageMax:Number;
		protected var damageMin:Number;
		protected var arrowSpeed:Number;
		protected var finishX:int;
		protected var finishY:int;
		protected var master:Warrior;
		protected var hitHeightAttack:int; // Сила подкидывающего удара
		protected const GRAD:Number = Math.PI / 180;
		protected const RAD:Number = 180 / Math.PI;
		public var ENEMY:Vector.<MovieClip>;
		public var ARMY:Vector.<MovieClip>;
		public var ARROW:Vector.<MovieClip>;
		public var index:uint;
		public var dotOn:Boolean;
		public var burnEarth:Boolean;
		public var arrowLive:Boolean = true;
		
		public function RangeWeapon():void
		{
		
		}
		
		protected function roundDamage():void
		{
			damage = Math.round(damageMin + Math.random() * (damageMax - damageMin));
		}
		
		public function dispose():void
		{
			ARROW.splice(this.index, 1);
			for (var i:uint = this.index; i <= ARROW.length - 1; i++)
			{
				ARROW[i].index--;
			}
			parent.removeChild(this);
		}
	}

}
