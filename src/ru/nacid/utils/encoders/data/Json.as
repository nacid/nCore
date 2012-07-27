package ru.nacid.utils.encoders.data 
{
	import by.blooddy.crypto.serialization.JSON;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class Json implements IEncoder 
	{
		/* INTERFACE ru.nacid.utils.encoders.interfaces.IEncoder */
		
		public function encodeObject($data:Object):Object 
		{
			return JSON.encode($data);
		}
		
		public function encodeString($data:String):Object 
		{
			return JSON.encode($data);
		}
		
		public function encodeFloat($data:Number):Object 
		{
			return JSON.encode($data);
		}
		
		public function decodeObject($data:Object):Object 
		{
			return JSON.decode(String($data));
		}
		
		public function decodeString($data:Object):String 
		{
			return JSON.decode(String($data));
		}
		
		public function decodeFloat($data:Object):Number 
		{
			return parseFloat(JSON.decode(String($data)));
		}
		
	}

}