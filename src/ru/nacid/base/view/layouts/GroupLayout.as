package ru.nacid.base.view.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.view.interfaces.ILayout;

	//@TODO
	public class GroupLayout// implements ILayout
	{
		private var _marginLeft:int;
		private var _marginTop:int;
		private var _lines:int;
		private var _columns:int;
		private var _hGap:int;
		private var _vGap:int;
		private var _hAlign:String;
		private var _vAlign:String;

		public function GroupLayout()
		{
			marginLeft=0;
			marginTop=0;
			lines=1;
			columns=1;
			hGap=5;
			vGap=5;
			hAlign=Align.CENTER;
			vAlign=Align.CENTER;
		}

		public function arrangeItem($item:*, $index:int=0):void
		{
			//virtual;
		}

		//----------------------
		public function arrangeFromContainer(container:DisplayObjectContainer):void
		{
			var i:int=0;
			var len:int=container.numChildren;

			for (i; i < len; i++)
			{
				arrangeItem(container.getChildAt(i), i);
			}
		}

		public function arrangeFromList(list:VOList):void
		{
			arrangeFromIterator(list.createIterator(), false);
		}

		public function arrangeFromIterator(iterator:VOIterator, reset:Boolean=true):void
		{
			if (reset)
			{
				iterator.reset();
			}

			while (iterator.hasNext())
			{
				arrangeItem(iterator.next(), iterator.step - 1);
			}
		}

		public function arrangeFromArray(arr:Array):void
		{
			var i:int=0;
			var len:int=arr.length;

			for (i; i < len; i++)
			{
				arrangeItem(arr[i], i);
			}
		}

		public function arrangeFromObject(obj:Object):void
		{
			var i:int=0;
			for each (var field:* in obj)
			{
				arrangeItem(obj[field], i);
				++i;
			}
		}

		//-------------------
		public function get vAlign():String
		{
			return _vAlign;
		}

		public function set vAlign(value:String):void
		{
			_vAlign=value;
		}

		public function get hAlign():String
		{
			return _hAlign;
		}

		public function set hAlign(value:String):void
		{
			_hAlign=value;
		}

		public function get vGap():int
		{
			return _vGap;
		}

		public function set vGap(value:int):void
		{
			_vGap=value;
		}

		public function get hGap():int
		{
			return _hGap;
		}

		public function set hGap(value:int):void
		{
			_hGap=value;
		}

		public function get columns():int
		{
			return _columns;
		}

		public function set columns(value:int):void
		{
			_columns=value;
		}

		public function get lines():int
		{
			return _lines;
		}

		public function set lines(value:int):void
		{
			_lines=value;
		}

		public function get marginTop():int
		{
			return _marginTop;
		}

		public function set marginTop(value:int):void
		{
			_marginTop=value;
		}

		public function get marginLeft():int
		{
			return _marginLeft;
		}

		public function set marginLeft(value:int):void
		{
			_marginLeft=value;
		}
	}
}
