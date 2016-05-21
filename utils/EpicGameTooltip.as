package utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EpicGameTooltip extends ToolTip
	{
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		
		public function EpicGameTooltip()
		{
			super();
		
		}
		
		public override function overHandler(target:MovieClip, mc:MovieClip):void
		{
			super.overHandler(target, mc);
			this.name_txt.text = target.discriptionName;
			this.price_txt.text = target.price + "$";
			this.hp_txt.text = target.hp_max;
			this.attack_txt.text = target.damageMinClean + " - " + target.damageMaxClean;
			this.attackSpeed_txt.text = target.attackSpeedClean;
			this.ultimate_txt.text = target.ultimateDiscription;
			this.discription_txt.text = target.discription;
			this.passive_txt.text = target.passiveDiscription;
		}
		
		/**
		 * Обработчик события отвода мыши от объекта
		 */
		public override function outHandler(target:MovieClip):void
		{
			super.outHandler(target);
			this.name_txt.text = "";
			this.price_txt.text = "";
			this.hp_txt.text = "";
			this.attack_txt.text = "";
			this.attackSpeed_txt.text = "";
			this.ultimate_txt.text = "";
			this.discription_txt.text = "";
			this.passive_txt.text = "";
		}
	
	}
}