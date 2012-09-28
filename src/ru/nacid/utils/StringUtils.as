package ru.nacid.utils
{
	import by.blooddy.crypto.CRC32;
	import flash.utils.ByteArray;
	import mx.utils.StringUtil;
	import ru.nacid.base.data.interfaces.IData;

	/**
	 * StringUtils.as
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
	public class StringUtils
	{
		private static const bytes:ByteArray=new ByteArray();

		public static function toCRC($str:String):uint
		{
			if ($str == null || split())
				return 0;

			bytes.writeUTF($str);
			bytes.position=0;

			return CRC32.hash(bytes);
		}

		public static function replace($input:String, ... rest):String
		{
			return StringUtil.substitute($input, rest);
		}

		public static function numOfSubstr($input:String, $sub:*):int
		{
			var i:int=$input.search($sub);

			return i >= 0 ? (1 + numOfSubstr($input.substr(i + 1), $sub)) : 0;
		}

		public static function replaceAll($input:String, $p:*, $repl:*):String
		{
			var v:Array=$input.split($p);
			if (v.length > 0)
			{
				return v.join($repl);
			}

			return $input;
		}

		private static function split():Boolean
		{
			if (bytes != null)
			{
				bytes.clear();
				return false;
			}
			return true;
		}
	}

}
