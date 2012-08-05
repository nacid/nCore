package ru.nacid.utils 
{
	import by.blooddy.crypto.CRC32;
	import flash.utils.ByteArray;
	/**
	 * HashUtils.as
	 * Created On: 5.8 20:22
	 *
	 * @author Nikolay nacid Bondarev
	 * @url https://github.com/nacid/nCore
	 *
	 *
	 *		Copyright 2012 Nikolay nacid Bondarev
	 *
	 *	Licensed under the Apache License, Version 2.0 (the "License");
	 *	you may not use this file except in compliance with the License.
	 *	You may obtain a copy of the License at
	 *
	 *		http://www.apache.org/licenses/LICENSE-2.0
	 *
	 *	Unless required by applicable law or agreed to in writing, software
	 *	distributed under the License is distributed on an "AS IS" BASIS,
	 *	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	 *	See the License for the specific language governing permissions and
	 *	limitations under the License.
	 *
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