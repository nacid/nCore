package ru.nacid.utils 
{
	import by.blooddy.crypto.CRC32;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class HashUtils 
	{
		private static const tempBA:ByteArray = new ByteArray();
		
		public static function CRC($obj:Object):uint {
			if ($obj == null)
				return 0;
			
			tempBA.writeObject($obj);
			var r:uint = CRC32.hash(tempBA);
			tempBA.clear();
			return r;
		}
		
		public static function MD5($obj:Object):String {
			if ($obj == null)
				return null;
			
			tempBA.writeObject($obj);
			var r:String = by.blooddy.crypto.MD5.hashBytes(tempBA);
			tempBA.clear();
			return r;
		}
		
	}

}