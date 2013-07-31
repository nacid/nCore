package ru.nacid.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import ru.nacid.base.data.interfaces.IData;

	public class ProtectedStorage implements IData
	{
		protected var bytes:ByteArray;
		protected var dict:Dictionary;

		private var _inited:Boolean;
		private var _dep:uint;
		private var _symbol:String;

		public function ProtectedStorage($init:Object=null)
		{
			if ($init)
			{
				init($init is Number ? Math.min(Math.max(Number($init), 0), 0xFF) : Math.random() * 0xFF);
			}
		}

		public function init($dep:uint):void
		{
			if (_inited)
			{
				return;
			}

			_dep=$dep;
			_inited=true;

			clear();
		}

		public function get size():int
		{
			return bytes.length;
		}

		public function clear():void
		{
			if (_inited)
			{
				dict=new Dictionary(true);
				bytes=new ByteArray();

				for (var i:int=0; i < _dep; i++)
				{
					bytes.writeByte(Math.floor(Math.random() * 0xFF));
				}
			}
		}

		public function containt($key:Object):Boolean
		{
			return !isNaN(dict[$key]);
		}

		public function writeFloat($key:Object, $value:Number, $rw:Boolean=true):Boolean
		{
			if (prepareWrite($key, $rw))
			{
				bytes.writeFloat($value);
				return true
			}

			return false;
		}

		public function readFloat($key:Object):Number
		{
			var response:Number=NaN;

			if (_inited && containt($key))
			{
				bytes.position=dict[$key] + _dep;
				response=bytes.readFloat();
			}

			return response;
		}

		protected function prepareWrite($key:Object, $rw:Boolean):Boolean
		{
			if (!_inited)
			{
				return false
			}

			if (containt($key))
			{
				if (!$rw)
				{
					return false;
				}

				bytes.position=dict[$key] + _dep;
			}
			else
			{
				dict[$key]=bytes.length - _dep;
				bytes.position=bytes.length;
			}

			return true
		}

		public function set symbol(value:String):void
		{
			_symbol=value;
		}

		//----- Interface IData -----
		public function get symbol():String
		{
			return _symbol;
		}

		public function valueOf():Number
		{
			return HashUtils.CRC(symbol);
		}
	}
}
