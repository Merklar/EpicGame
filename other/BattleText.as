package other
{
	import flash.display.MovieClip;
	
	public class BattleText extends MovieClip
	{
		
		public var textFieldLife:Boolean = true;
		public var BATTLE_TEXT:Vector.<MovieClip>;
		public var index:int;
		
		public function BattleText(_text:*, _type):void
		{
			if (_type == "enemy")
			{
				this.textField.textColor = 0x00CC00;
			}
			else if (_type == "allias")
			{
				this.textField.textColor = 0xFF0000;
			}
			else if (_type == "gold")
			{
				this.textField.textColor = 0xFFDB11;
			}
			else if (_type == "posion")
			{
				this.textField.textColor = 0x208625;
			}
			else if (_type == "miss")
			{
				this.textField.textColor = 0xB1DAC7;
			}
			else if (_type == "fire")
			{
				this.textField.textColor = 0xE84500;
			}
			this.textField.text = _text.toString();
		}
		
		public function update():void
		{
			this.y--;
			this.alpha -= 0.01;
			if (this.alpha <= 0)
			{
				textFieldLife = false;
			}
		}
		
		public function dispose():void
		{
			BATTLE_TEXT.splice(this.index, 1);
			for (var i:uint = this.index; i <= BATTLE_TEXT.length - 1; i++)
			{
				BATTLE_TEXT[i].index--;
			}
			parent.removeChild(this);
		}
	
	}

}