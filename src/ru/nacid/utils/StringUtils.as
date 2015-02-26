package ru.nacid.utils
{

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
		public static function replace($input:String, ... rest):String
		{
			var len:uint=rest.length;
			var args:Array;
			if (len == 1 && rest[0] is Array)
			{
				args=rest[0] as Array;
				len=args.length;
			}
			else
			{
				args=rest;
			}

			for (var i:int=0; i < len; i++)
			{
				$input=$input.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}

			return $input;
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

		public static function casedNumeric($value:Number,$kTrim:String = ' ',$dTrim:String = '.'):String
		{
			var dec:Number = $value % 1;
			var kec:Number = $value - dec;
			var response:String = '';

			var str:String = kec.toString();
			var i:int = 0;
			while(i <= str.length)
			{
				var char:String = str.charAt(str.length - i);


				response = char.concat(response);
				if(i && i%3 == 0)
					response = $kTrim.concat(response);

				i++;
			}

			return dec ? response.concat($dTrim,dec.toString()) : response;
		}

		public static function unescapeString(input:String):String
		{
			var result:String="";
			var backslashIndex:int=0;
			var nextSubstringStartPosition:int=0;
			var len:int=input.length;

			do
			{
				backslashIndex=input.indexOf('\\', nextSubstringStartPosition);

				if (backslashIndex >= 0)
				{
					result+=input.substr(nextSubstringStartPosition, backslashIndex - nextSubstringStartPosition);
					nextSubstringStartPosition=backslashIndex + 2;

					var escapedChar:String=input.charAt(backslashIndex + 1);
					switch (escapedChar)
					{
						case '"':
							result+=escapedChar;
							break;
						case '\\':
							result+=escapedChar;
							break;
						case 'n':
							result+='\n';
							break;
						case 'r':
							result+='\r';
							break;
						case 't':
							result+='\t';
							break;
						case 'u':
							var hexValue:String="";
							var unicodeEndPosition:int=nextSubstringStartPosition + 4;

							if (unicodeEndPosition > len)
							{
								parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
							}

							for (var i:int=nextSubstringStartPosition; i < unicodeEndPosition; i++)
							{
								var possibleHexChar:String=input.charAt(i);
								if (!isHexDigit(possibleHexChar))
								{
									parseError("Excepted a hex digit, but found: " + possibleHexChar);
								}
								hexValue+=possibleHexChar;
							}

							result+=String.fromCharCode(parseInt(hexValue, 16));
							nextSubstringStartPosition=unicodeEndPosition;
							break;

						case 'f':
							result+='\f';
							break;
						case '/':
							result+='/';
							break;
						case 'b':
							result+='\b';
							break;
						default:
							result+='\\' + escapedChar;
					}
				}
				else
				{
					result+=input.substr(nextSubstringStartPosition);
					break;
				}

			} while (nextSubstringStartPosition < len);

			return result;
		}

		private static function isDigit(ch:String):Boolean
		{
			return (ch >= '0' && ch <= '9');
		}

		private static function isHexDigit(ch:String):Boolean
		{
			return (isDigit(ch) || (ch >= 'A' && ch <= 'F') || (ch >= 'a' && ch <= 'f'));
		}


		private static function parseError(message:String):void
		{
			throw new Error(message);
		}
	}
}
