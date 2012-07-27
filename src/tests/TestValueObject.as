package tests 
{
	import ru.nacid.base.data.ValueObject;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class TestValueObject extends ValueObject
	{
		public var a:int;
		public var b:int;
		
		
		public function TestValueObject($id:String = null, $data:Object = null)
		{
			super($id, $data);
		}
		
		public function clone($id:String = null):TestValueObject {
			return new TestValueObject($id, internalClone());
		}
		
	}

}