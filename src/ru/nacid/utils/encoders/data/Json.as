package ru.nacid.utils.encoders.data
{
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	import by.blooddy.crypto.serialization.JSON;
	/**
	 * Json.as
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
			return String(JSON.decode(String($data)));
		}

		public function decodeFloat($data:Object):Number
		{
			return parseFloat(String(JSON.decode(String($data))));
		}
		
		// https://github.com/mayakwd/as3-json-formatter
		public function formatJSON(serializedJSON:String, useTabs:Boolean=true):String
		{
			var strings:Object={};

			serializedJSON=serializedJSON.replace(/(\\.)/g, saveString);
			serializedJSON=serializedJSON.replace(/(".*?"|'.*?')/g, saveString);
			serializedJSON=serializedJSON.replace(/\s+/, "");

			var indent:int=0;
			var result:String="";

			for (var i:uint=0; i < serializedJSON.length; i++)
			{
				var char:String=serializedJSON.charAt(i);
				switch (char)
				{
					case "{":
					case "[":
						result+=char + "\n" + makeTabs(++indent, useTabs);
						break;
					case "}":
					case "]":
						result+="\n" + makeTabs(--indent, useTabs) + char;
						break;
					case ",":
						result+=",\n" + makeTabs(indent, useTabs);
						break;
					case ":":
						result+=": ";
						break;
					default:
						result+=char;
						break;
				}
			}

			result=result.replace(/\{\s+\}/g, stripWhiteSpace);
			result=result.replace(/\[\s+\]/g, stripWhiteSpace);
			result=result.replace(/\[[\d,\s]+?\]/g, stripWhiteSpace);
			result=result.replace(/\\(\d+)\\/g, restoreString);
			result=result.replace(/\\(\d+)\\/g, restoreString);

			return result;

			function saveString(... args):String
			{
				var string:String=args[0];
				var index:uint=uint(args[2]);

				strings[index]=string;

				return "\\" + args[2] + "\\";
			}

			function restoreString(... args):String
			{
				var index:uint=uint(args[1]);
				return strings[index];
			}

			function stripWhiteSpace(... args):String
			{
				var value:String=args[0];
				return value.replace(/\s/g, '');
			}

			function makeTabs(count:int, useTabs:Boolean):String
			{
				return new Array(count + 1).join(useTabs ? "\t" : "       ");
			}
		}
	}

}
