package utils
{
	import fl.transitions.Tween;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
    import com.greensock.*;
	
	/**
	 * Базовый класс для отображения всплывающих подсказок, при наведении на объект
	 * @Merklar
	 */
	
	public class ToolTip extends MovieClip
	{
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		private const DELTA_Y:int = 20;
		private const DELTA_X_LEFT:int = 20;
		private const DELTA_X_RIGHT:int = -300;
		private const STAGE_WIDTH:uint = 650;
		private const STAGE_HEIGHT:uint = 500;
		//-------------------------------------------
		//  PUBLIC STATIC VARIABLES
		//-------------------------------------------
		public static var stageLink:Stage; //Ссылка на Stage
		
		//-------------------------------------------
		//  PUBLIC STATIC METHOD
		//-------------------------------------------
		public static function Init(stage:Stage):void
		{
			stageLink = stage;
		}
		
		//-------------------------------------------
		// CONSTRUCTOR
		//-------------------------------------------
		public function ToolTip()
		{
			// запиоминаем смещение
			this.alpha = 0;
			this.visible = false;
			this.y = DELTA_Y;
			this.name = "tooltip";
			if (mouseX > STAGE_WIDTH/2) {
				this.x = DELTA_X_RIGHT;
			} else {
				this.x = DELTA_X_LEFT;
			}
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		public function overHandler(target:MovieClip, mc:MovieClip):void
		{
			TweenLite.to(this, 0.4, {alpha:1});
			//this.alpha = 1;
			this.visible = true;
			this.cacheAsBitmap = true;
			stageLink.addChild(this);
			setPosition();
			mc.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		/**
		 * Обработчик события отвода мыши от объекта
		 */
		public function outHandler(target:MovieClip):void
		{
			// убираем компонент-подсказку со stage
			if (this.parent != null)
			{
				TweenLite.to(this, 0.4, {alpha:0, onComplete:deleteTooltip});
				
			}
			//
			// убиваем слушателя события MOUSE_MOVE
			target.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		/**
		 * Обработчик события движения мыши
		 */
		private function moveHandler(event:MouseEvent):void
		{
			// дергаем updateAfterEvent что бы
			// движение было более плавным
			event.updateAfterEvent();
			// задаем координаты компонента-подсказки
			setPosition();
		}
		
		/**
		 * Метод который задает текущие координаты
		 * для компонента-подсказки
		 * исходя из текущих коордирнат мыши
		 */
		private function setPosition():void
		{
			// задаем координаты
			// используя смещение delta
			this.y = stageLink.mouseY + DELTA_Y;
			if (stageLink.mouseX > STAGE_WIDTH/2) {
				this.x = stageLink.mouseX + DELTA_X_RIGHT;
			} else {
				this.x = stageLink.mouseX + DELTA_X_LEFT;
			}
		}
		
		private function deleteTooltip():void {
			this.parent.removeChild(this)
		}
	}

}