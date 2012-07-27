package ru.nacid.base.data 
{
	import ru.nacid.base.data.interfaces.IData;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class SimpleValueObject implements IData 
	{
		protected var _id:String;
		protected var _numericId:uint;
		
		public function SimpleValueObject($key:String) 
		{
			_id = $key;
			_numericId = 0;
		}
		
		/* INTERFACE ru.nacid.base.data.interfaces.IData */
		
		public function get id():String 
		{
			return _id;
		}
		
		public function valueOf():Number 
		{
			return _numericId;
		}
		
	}
	
}