package ru.nacid.base.services.skins.utils
{
	import ru.nacid.base.data.interfaces.IIterator;
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;

	public class SkinIterator implements IIterator
	{
		private var list:SkinList;
		private var index:int;
		
		private var nullIndex:int;
		
		public function SkinIterator(aList:SkinList, $nullIndex:int=0)
		{
			list=aList;
			nullIndex=$nullIndex;
			
			reset();
		}
		
		public function reset():void
		{
			index=nullIndex - 1;
		}
		
		public function next():ISkinLoader
		{
			return list.at(++index);
		}
		
		public function hasNext():Boolean
		{
			return index < (list.size - 1) && list.at(index + 1) != null;
		}
		
		public function get step():int
		{
			return index;
		}
	}
}