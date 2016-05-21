package other
{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import hero.*;
	
	/**
	 * Ядро класса ячеечного инвентаря
	 * @Merklar
	 */
	
	public class InventaryCore extends Sprite
	{
		//-------------------------------------------
		//  CLASS CONSTANTS
		//-------------------------------------------
		private const BODY_HEIGHT:uint = 154;
		private const BODY_WIDTH:uint = 310;
		private const CELL_SIZE:uint = 35;
		private const CELL_DELTA:uint = 5;
		private const I1_X:int = -118;
		private const I1_Y:uint = 6;
		private const I2_X:int = -118;
		private const I2_Y:uint = 74;
		private const I3_X:int = -118;
		private const I3_Y:uint = 142;
		private const HERO_CELL_SIZE:uint = 45;
		
		//-------------------------------------------
		//  PUBLIC VARIABLES
		//-------------------------------------------
		public var inventaryMass:Vector.<MovieClip>;
		public var cellMass:Vector.<ItemBlank>;
		public var item_1:MovieClip;
		public var item_2:MovieClip;
		public var item_3:MovieClip;
		public var tempHero:MovieClip;
		public var onStage:Boolean = false;
		
		//-------------------------------------------
		//  PRIVATE VARIABLES
		//-------------------------------------------
		private var startDeltaX:uint;
		private var startDeltaY:uint;
		private var tempItemCell:MovieClip;
		private var onTake:Boolean = false;
		
		//Конструктор
		public function InventaryCore():void
		{
			super();
			this.mouseEnabled = false;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownOnItemHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpOnItemHandler);
		}
		
		//Создание иконок в инвентаре
		public function cellCreate():void
		{
			//Количество колонок
			var _colonNumber:uint;
			
			//Количество строк
			var _rowNumber:uint;
			
			//Позиция текущей ячейки
			var _posX:uint = 0;
			var _posY:uint = 0;
			
			cellMass = new Vector.<ItemBlank>;
			_colonNumber = Math.floor(BODY_HEIGHT / (CELL_SIZE + CELL_DELTA));
			_rowNumber = Math.floor(BODY_WIDTH / (CELL_SIZE + CELL_DELTA));
			trace(_colonNumber, _rowNumber);
			
			startDeltaX = (BODY_WIDTH - (_rowNumber * (CELL_SIZE + CELL_DELTA))) / 2;
			startDeltaY = (BODY_HEIGHT - (_colonNumber * (CELL_SIZE + CELL_DELTA))) / 2;
			
			for (var ix:uint = 0; ix < _colonNumber; ++ix)
			{
				for (var iy:uint = 0; iy < _rowNumber; ++iy)
				{
					var cell:ItemBlank = new ItemBlank();
					cell.height = CELL_SIZE;
					cell.width = CELL_SIZE;
					cell.x = _posX + startDeltaX;
					cell.y = _posY + startDeltaY;
					cellMass.push(cell);
					body.addChild(cell);
					_posX += (CELL_SIZE + CELL_DELTA);
				}
				_posY += (CELL_SIZE + CELL_DELTA);
				_posX = 0;
			}
			
			var item1:ItemBlank = new ItemBlank();
			item1.height = HERO_CELL_SIZE;
			item1.width = HERO_CELL_SIZE;
			item1.x = I1_X;
			item1.y = I1_Y;
			item1.name = "itemHero_1";
			cellMass.push(item1);
			body.addChild(item1);
			
			var item2:ItemBlank = new ItemBlank();
			item2.height = HERO_CELL_SIZE;
			item2.width = HERO_CELL_SIZE;
			item2.x = I2_X;
			item2.y = I2_Y;
			item2.name = "itemHero_2";
			cellMass.push(item2);
			body.addChild(item2);
			
			var item3:ItemBlank = new ItemBlank();
			item3.height = HERO_CELL_SIZE;
			item3.width = HERO_CELL_SIZE;
			item3.x = I3_X;
			item3.y = I3_Y;
			item3.name = "itemHero_3";
			cellMass.push(item3);
			body.addChild(item3);
			
			checkItem();
		}
		
		public function reRender():void
		{
			for (var i:uint = 0; i < cellMass.length; ++i)
			{
				var _tempCell:ItemBlank = cellMass[i];
				if (_tempCell.item !== null) {
				_tempCell.gotoAndStop(_tempCell.item.nameItem);
				}
			}
		}
		
		private function setItem(i:uint, tempCell:ItemBlank):void
		{
			var _item:MovieClip = inventaryMass[i];
			if (_item.nameItem !== null)
			{
				switch (_item.nameItem)
				{
					case "armor": 
						trace("armor");
						tempCell.gotoAndStop("armor");
						break;
					case "amulet": 
						trace("amulet");
						tempCell.gotoAndStop("amulet");
						break;
					case "glows": 
						trace("glows");
						tempCell.gotoAndStop("glows");
						break;
					default: 
						trace("Out of range");
						break;
				}
			}
		}
		
		private function checkItem():void
		{
			var _tempItem:MovieClip;
			var _tempCell:ItemBlank;
			for (var i:uint; i < inventaryMass.length - 1; ++i)
			{
				_tempItem = inventaryMass[i]
				_tempCell = cellMass[i];
				if (_tempItem !== null)
				{
					_tempCell.item = _tempItem;
					setItem(i, _tempCell);
				}
				else
				{
					_tempCell.item = null;
					_tempCell.gotoAndStop("none");
				}
			}
		}
		
		private function mouseDownOnItemHandler(e:MouseEvent):void
		{
			var _cell:MovieClip = e.target as MovieClip;
			trace(_cell);
			if (_cell is ItemBlank)
			{
				if ((_cell.item !== null) && (_cell.item.nameItem !== "none"))
				{
					var _tempIcon:ItemBlank = new ItemBlank();
					tempItemCell = _cell;
					onTake = true;
					_tempIcon.name = "tempIcon";
					_tempIcon.x = mouseX;
					_tempIcon.y = mouseY;
					_tempIcon.width = CELL_SIZE;
					_tempIcon.height = CELL_SIZE;
					_tempIcon.mouseEnabled = false;
					addChild(_tempIcon);
					_cell.gotoAndStop("none");
					_cell.nameItem = _cell.item.nameItem;
					_tempIcon.gotoAndStop(_cell.item.nameItem);
					_tempIcon.startDrag();
				}
			}
		}
		
		private function mouseUpOnItemHandler(e:MouseEvent):void
		{
			//var _cell:MovieClip = e.target as MovieClip;
			var _cell:* = e.target;
			var _moveCell:MovieClip = getChildByName("tempIcon") as MovieClip;
			trace(_cell, _moveCell);
			if (onTake == true)
			{
				if ((_cell is ItemBlank) && (_cell.nameItem == "none"))
				{
					onTake = false;
					_moveCell.stopDrag();
					removeChild(_moveCell);
					_moveCell = null;
					_cell.item = tempItemCell.item;
					trace(_cell);
					_cell.gotoAndStop(_cell.item.nameItem);
					switch (_cell.name)
					{
						case "itemHero_1": 
							tempHero.item_1 = tempItemCell.item;
							break;
						case "itemHero_2":
							tempHero.item_2 = tempItemCell.item;
							break;
						case "itemHero_3":
							tempHero.item_3 = tempItemCell.item;
							break;
						default: 
							trace("Out of range");
							break;
					}
					tempItemCell.nameItem = "none";
					tempItemCell.item = null;
					tempItemCell = null;
				}
				else
				{
					_moveCell.stopDrag();
					removeChild(_moveCell);
					_moveCell = null;
					onTake = false;
					tempItemCell.gotoAndStop(tempItemCell.item.nameItem);
					tempItemCell = null;
				}
			}
		}
	}

}