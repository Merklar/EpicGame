package other
{
	import flash.display.MovieClip;
	import hero.*;
	
	public class Item extends MovieClip
	{
		
		public var nameItem:String;
		public var attribute:String;
		public var discription:*;
		public var value:Number;
		public var ITEMS:Vector.<MovieClip>;
		public var target:Warrior;
		public var index:int;
		public var hp:int = 0;
		public var ap:int = 0;
		public var asp:Number = 0;
		private var verChoiseAttribute:Number;
		
		public function Item():void
		{
			super();
			verChoiseAttribute = Math.random() * 100;
			if (verChoiseAttribute <= 33)
			{
				attribute = "powerAttack";
				value = Math.round(1 + Math.random() * 4);
				discription = "+ " + value + " Attack power";
				nameItem = "amulet";
				hp = 0;
				ap = value;
				asp = 0;
			}
			else if ((verChoiseAttribute > 33) && (verChoiseAttribute <= 66))
			{
				attribute = "hitPoint";
				value = Math.round(5 + Math.random() * 45);
				discription = "+ " + value + " Hit Point";
				nameItem = "armor";
				hp = value;
				ap = 0
				asp = 0
			}
			else if (verChoiseAttribute > 66)
			{
				attribute = "speedAttack";
				value = 0.05 + Math.random() * 0.5;
				value = Math.round(value * 10) / 10;
				discription = "+ " + value + " Attack speed";
				nameItem = "glows";
				hp = 0;
				ap = 0;
				asp = value;
			}
		}
	}

}