package ru.nacid.utils.debug
{
	import by.blooddy.crypto.serialization.JSON;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class JSONtoAMF
	{
		private static const saver:FileReference = new FileReference();
		
		public static function bytes($json:ByteArray, $save:Boolean = false):ByteArray
		{
			return string($json.readUTFBytes($json.bytesAvailable), $save);
		}
		
		public static function string($string:String, $save:Boolean = false):ByteArray {
			return object(JSON.decode($string), $save);
		}
		
		public static function object($object:Object, $save:Boolean = false):ByteArray {
			var response:ByteArray = new ByteArray();
			response.writeObject($object);
			
			if ($save)
				saver.save(response);
			
			return response;
		}
	}

}