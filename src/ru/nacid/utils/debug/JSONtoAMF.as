package ru.nacid.utils.debug
{
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	/**
	 * JSONtoAMF.as
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
	public class JSONtoAMF
	{
		private static const saver:FileReference = new FileReference();
		
		public static function bytes($json:ByteArray, $save:Boolean = false):ByteArray
		{
			return string($json.readUTFBytes($json.bytesAvailable), $save);
		}
		
		public static function string($string:String, $save:Boolean = false):ByteArray {
			return object(JSON.parse($string), $save);
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