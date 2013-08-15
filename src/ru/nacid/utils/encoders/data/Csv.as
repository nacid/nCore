package ru.nacid.utils.encoders.data
{
	import ru.nacid.utils.StringUtils;
	import ru.nacid.utils.encoders.interfaces.IEncoder;

	/**
	 * Csv.as
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
	public class Csv implements IEncoder
	{
		protected function get fielSeperator():String
		{
			return ',';
		}

		protected function get screen():String
		{
			return '"';
		}

		protected function get lineDel():String
		{
			return String.fromCharCode(0x0A);
		}

		//-------------

		protected function readLine($input:String):Array
		{
			var r:Array=$input.split(fielSeperator);

			for (var i:int=0; i < r.length; i++)
			{
				var s:String=r[i];
				if (Boolean(StringUtils.numOfSubstr(s, screen) % 2))
				{
					r[i]=s.concat(fielSeperator, r[i + 1]);
					r.splice(i + 1, 1);
					--i;
				}
				else
				{
					r[i]=decodeString(s);
				}
			}

			return r;
		}

		/* INTERFACE ru.nacid.utils.encoders.interfaces.IEncoder */

		public function encodeObject($data:Object):Object
		{
			var lines:Vector.<String>=Vector.<String>([]);
			var fList:Vector.<String>=Vector.<String>([]);
			var fHash:Object={};

			for each (var o:Object in $data)
			{
				for (var f:String in o)
				{
					if (!fHash.hasOwnProperty(f))
					{
						fHash[f]=fList.push(f) - 1;
					}
				}
			}

			for each (var o2:Object in $data)
			{
				var line:Array=[];
				for (var i:int=0; i < fList.length; i++)
				{
					line.push(encodeString(o2[fList[i]]));
				}
				lines.push(line.join(fielSeperator));
			}

			return fList.join(fielSeperator).concat(lineDel, lines.join(lineDel));
		}

		public function encodeString($data:String):Object
		{
			if ($data.search(lineDel) >= 0 || $data.search(screen) >= 0 || $data.search(fielSeperator) >= 0)
			{
				$data=screen.concat(StringUtils.replaceAll($data, screen, screen.concat(screen)), screen);
			}

			return $data;
		}

		public function encodeFloat($data:Number):Object
		{
			return $data.toString();
		}

		public function decodeObject($data:Object):Object
		{
			var inPut:Vector.<String>=Vector.<String>(String($data).split(lineDel));
			var fields:Vector.<String>=Vector.<String>(readLine(inPut.shift()));
			var outPut:Array=[];
			var i:int;
			var j:int;
			var temp:Array;

			for (i=0; i < inPut.length; i++)
			{
				if (StringUtils.numOfSubstr(inPut[i], screen) % 2)
				{
					inPut[i]=inPut[i].concat(lineDel, inPut.splice(i + 1, 1));

					if ((inPut.length - i) > 1)
					{
						--i;
						continue;
					}
					break;
				}
				var obj:Object={};
				temp=readLine(inPut[i]);

				while (j < fields.length)
				{
					obj[fields[j]]=temp[j];
					++j;
				}
				j=0;

				outPut[i]=obj;
			}
			return outPut;
		}

		public function decodeString($data:Object):String
		{
			var r:String=$data as String;
			if (r == null)
				return null;

			var f:int=r.indexOf(screen);
			var l:int=r.lastIndexOf(screen);

			if (f == 0 && l == (r.length - 1))
			{
				r=r.substr(1, l - 1);
			}

			return StringUtils.replaceAll(r, screen.concat(screen), screen);
		}

		public function decodeFloat($data:Object):Number
		{
			return parseFloat(String($data));
		}

	}

}
