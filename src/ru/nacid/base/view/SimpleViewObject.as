package ru.nacid.base.view 
{
	import flash.display.Sprite;
	import ru.nacid.base.view.data.Position;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class SimpleViewObject extends Sprite 
	{
		public function writePosition($position:Position):void {
			x = $position.x;
			y = $position.y;
			width = $position.width;
			height = $position.height;
		}
		
		public function readPosition($from:Position = null):Position {
			return Position.FROM_OBJECT(this);
		}
	}

}