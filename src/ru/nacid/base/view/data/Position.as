package ru.nacid.base.view.data 
{
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class Position 
	{
		public static function FROM_OBJECT($obj:Object):Position {
			return new Position($obj.x, $obj.y, $obj.width, $obj.height);
		}
		//----------------------------
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public function Position(x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.width = w;
			this.height = h;
		}
		
		public function clone():Position {
			return new Position(x, y, width, height);
		}
		
	}

}