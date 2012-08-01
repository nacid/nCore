package ru.nacid.utils.encoders.data
{
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	import ru.nacid.utils.StringUtils;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
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
			var r:Array = $input.split(fielSeperator);
			
			for (var i:int = 0; i < r.length; )
			{
				var s:String = r[i];
				if (Boolean(StringUtils.numOfSubstr(s, screen) % 2))
				{
					r[i] = s.concat(fielSeperator, r[i + 1]);
					r.splice(i + 1, 1);
				}
				else
				{
					r[i] = decodeString(s);
					i++;
				}
			}
			
			return r;
		}
		
		/* INTERFACE ru.nacid.utils.encoders.interfaces.IEncoder */
		
		public function encodeObject($data:Object):Object
		{
			var lines:Vector.<String> = Vector.<String>([]);
			var fList:Vector.<String> = Vector.<String>([]);
			var fHash:Object = {};
			
			for each (var o:Object in $data)
			{
				for (var f:String in o)
				{
					if (!fHash.hasOwnProperty(f))
					{
						fHash[f] = fList.push(f) - 1;
					}
				}
			}
			
			for each (var o2:Object in $data)
			{
				var line:Array = [];
				for (var i:int = 0; i < fList.length; i++)
				{
					line.push(encodeString(o2[fList[i]]));
				}
				lines.push(line.join(fielSeperator));
			}
			
			return fList.join(fielSeperator).concat(lineDel, lines.join(lineDel));
		}
		
		public function encodeString($data:String):Object
		{
			if ($data.search(lineDel) >= 0 || $data.search(screen) >= 0)
			{
				$data = screen.concat(StringUtils.replaceAll($data, screen, screen.concat(screen)), screen);
			}
			
			return $data;
		}
		
		public function encodeFloat($data:Number):Object
		{
			return $data.toString();
		}
		
		public function decodeObject($data:Object):Object
		{
			var inPut:Vector.<String> = Vector.<String>(String($data).split(lineDel));
			var fields:Vector.<String> = Vector.<String>(readLine(inPut.shift()));
			var outPut:Array = [];
			
			var i:int;
			var j:int;
			var temp:Array;
			
			for (i; i < inPut.length; i++)
			{
				var obj:Object = {};
				temp = readLine(inPut[i]);
				
				while (j < fields.length)
				{
					obj[fields[j]] = temp[j];
					++j;
				}
				j = 0;
				outPut[i] = obj;
			}
			return outPut;
		}
		
		public function decodeString($data:Object):String
		{
			var r:String = $data as String;
			if (r == null)
				return null;
			
			var f:int = r.indexOf(screen);
			var l:int = r.lastIndexOf(screen);
			
			if (f == 0 && l == (r.length - 1))
			{
				r = r.substr(1, l - 1);
			}
			
			return StringUtils.replaceAll(r, screen.concat(screen), screen);
		}
		
		public function decodeFloat($data:Object):Number
		{
			return parseFloat(String($data));
		}
	
	}

}