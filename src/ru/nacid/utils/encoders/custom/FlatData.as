package ru.nacid.utils.encoders.custom
{
	import ru.nacid.utils.encoders.interfaces.IEncoder;

	public class FlatData implements IEncoder
	{
		private const DEFAULT_KEY_SEPARATE:String=':';
		private const DEFAULT_VAL_SEPARATE:String='=';
		private const DEFAULT_EMPTY_KEY:String='';
		private const DEFAULT_LINE_SEPARATE:String=String.fromCharCode(0x0A);

		public var keySeparate:String;
		public var valSeparate:String;
		public var emptyKey:String;
		public var lineSeparate:String;

		public function FlatData()
		{
			keySeparate=DEFAULT_KEY_SEPARATE;
			valSeparate=DEFAULT_VAL_SEPARATE;
			emptyKey=DEFAULT_EMPTY_KEY;
			lineSeparate=DEFAULT_LINE_SEPARATE;
		}

		public function encodeObject($data:Object):Object
		{
			return recObj($data);

			function recObj($data:Object, $parent:String=null):String
			{
				var response:String=emptyKey;

				for (var subData:String in $data)
				{
					var subDataValue:Object=$data[subData];

					if (subDataValue is Number || subDataValue is String)
					{
						response=response.concat($parent ? $parent.concat(keySeparate, subData) : subData, valSeparate, encodeString(subDataValue.toString()));
					}
					else
					{
						response=response.concat(recObj(subDataValue, $parent ? $parent.concat(keySeparate, subData) : subData));
					}
				}

				return response;
			}
		}

		public function encodeString($data:String):Object
		{
			return emptyKey.concat($data, lineSeparate);
		}

		public function encodeFloat($data:Number):Object
		{
			return encodeString($data.toString());
		}

		public function decodeObject($data:Object):Object
		{
			var response:Object={};
			var arr:Array=$data is String ? String($data).split(lineSeparate) : $data as Array;
			var len:uint=arr.length;

			while (len)
			{
				var line:String=arr[--len];

				if (line.length)
				{
					var keys:Array=line.split(valSeparate)[0].split(keySeparate);
					write(response, keys, decodeString(line));
				}
			}

			return response;

			function write($target:Object, $childs:Array, $val:*):void
			{
				var mainChild:String=$childs.shift();
				if ($childs.length)
				{
					if ($target.hasOwnProperty(mainChild))
					{
						write($target[mainChild], $childs, $val);
					}
					else
					{
						write($target[mainChild]={}, $childs, $val);
					}
				}
				else
				{
					$target[mainChild]=$val;
				}
			}
		}

		public function decodeString($data:Object):String
		{
			return String($data).split(valSeparate).pop();
		}

		public function decodeFloat($data:Object):Number
		{
			return parseFloat(decodeString($data));
		}
	}
}
