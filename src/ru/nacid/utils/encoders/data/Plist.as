package ru.nacid.utils.encoders.data
{
	import by.blooddy.crypto.Base64;

	import flash.utils.ByteArray;

	import ru.nacid.utils.encoders.interfaces.IEncoder;

	public class Plist implements IEncoder
	{
		private const PLIST_SIG:String='plist';
		private const DICT_SIG:String='dict';
		private const ARRAY_SIG:String='array';
		private const STRING_SIG:String='string';
		private const DATA_SIG:String='data';
		private const DATE_SIG:String='date';
		private const TRUE_SIG:String='true';
		private const FALSE_SIG:String='false';
		private const INT_SIG:String='integer';
		private const FLOAT_SIG:String='real';

		private var _version:String;

		public function Plist($version:String='1.0')
		{
			_version=$version;
		}

		private function encodeData($data:Object, $name:String=null):XML
		{
			var response:XML

			if ($data is Array)
			{
				response=<{ARRAY_SIG}/>;

				for (var i:int=0; i < $data.length; i++)
				{
					response.appendChild(encodeData($data[i]));
				}
			}
			else if ($data is ByteArray)
			{
				response=<{DATA_SIG}/>;
				response.appendChild(Base64.encode(ByteArray($data)));
			}
			else if ($data is Date)
			{
				response=<{DATE_SIG}/>;
				response.appendChild(($data as Date).time);
			}
			else if ($data is Boolean)
			{
				response=$data ? <true/> : <false/>;
			}
			else if ($data is Number)
			{
				response=encodeFloat(Number($data)) as XML;
			}
			else if ($data is String)
			{
				response=encodeString(String($data)) as XML;
			}
			else
			{
				response=<{DICT_SIG}/>;

				for (var field:String in $data)
				{
					var key:XML=<key/>;
					key.appendChild(field);

					var val:XML=encodeData($data[field]);

					response.appendChild(key);
					response.appendChild(val);
				}
			}

			return response;
		}

		public function encodeObject($data:Object):Object
		{
			var response:XML=new XML(<{PLIST_SIG}/>);
			response.@['version']=_version;
			response.appendChild(encodeData($data));

			return response;
		}

		public function encodeString($data:String):Object
		{
			var response:XML=<{STRING_SIG}/>;
			response.appendChild($data);
			return response;
		}

		public function encodeFloat($data:Number):Object
		{
			var response:XML=<{FLOAT_SIG}/>;
			response.appendChild($data);
			return response;
		}

		public function decodeString($data:Object):String
		{
			var source:XML=$data is XML ? $data as XML : XML($data);
			return source.text();
		}

		public function decodeFloat($data:Object):Number
		{
			return Number(decodeString($data));
		}

		public function decodeObject($data:Object):Object
		{
			var source:XML=$data is XML ? $data as XML : XML($data);

			switch (source.name().localName)
			{
				case PLIST_SIG:
					return decodeObject(source.children()[0]);
				case DICT_SIG:
					var obj:Object={};
					var children:XMLList=source.children();
					for (var i:int=0, cnt:int=source.children().length(); i < cnt; i+=2)
					{
						var key:String=children[i].text();
						obj[key]=decodeObject(children[i + 1]);
					}
					return obj;
				case ARRAY_SIG:
					var arr:Array=[];
					for each (var el:XML in source.children())
					{
						arr.push(decodeObject(el));
					}
					return arr;
				case STRING_SIG:
					return decodeString(source);
				case DATA_SIG:
					return Base64.decode(source.toString());
				case DATE_SIG:
					var ts:Number=Date.parse(decodeString(source));
					var d:Date=new Date();
					d.setTime(ts);
					return d;
				case TRUE_SIG:
				case FALSE_SIG:
					return source.name() == 'true';
				case INT_SIG:
				case FLOAT_SIG:
					return decodeFloat(source);
			}

			return null;
		}
	}
}
