package ru.nacid.utils.encoders.data 
{
	import ru.nacid.utils.encoders.interfaces.IEncoder;

	
	public class Sinx implements IEncoder 
	{
		protected function get blockStart():String {
			return '<';
		}
		
		protected function get blockEnd():String {
			return '<';
		}
		
		protected function get objDelimer():String {
			return ': ';
		}
		
		protected function get fieldDelimer():String {
			return '.';
		}
		//--------------
		
		public function encodeObject($data:Object):Object 
		{
			return null;
		}
		
		public function encodeString($data:String):Object 
		{
			return $data;
		}
		
		public function encodeFloat($data:Number):Object 
		{
			return null;
		}
		
		public function decodeObject($data:Object):Object 
		{
			var $str:String = String($data);
			var workBorder:BlockBorder = new BlockBorder($str.indexOf(blockStart), $str.lastIndexOf(blockEnd));
			
			if (workBorder.toBoolean()) {
				$str = $str.substr(workBorder.start +1, workBorder.end -1);
				
				var r:Object = { };
				var name:String = $str.substring(0, $str.indexOf(blockStart));
				
				if (name.indexOf(fieldDelimer) == 0) {
					trace(2);
				}else if (name.lastIndexOf(objDelimer) == name.length - objDelimer.length) {
					name = name.substring(0, name.length - objDelimer.length);
					r[name] = decodeObject
				}
				
				trace(name);
			}
			
			return $str;
		}
		
		
		public function decodeString($data:Object):String 
		{
			return '1';
		}
		
		public function decodeFloat($data:Object):Number 
		{
			return 1;
		}
	}
}

class BlockBorder {
	public var start:int;
	public var end:int;
	
	public function BlockBorder($start:int = 0, $end:int = -1) {
		start = $start;
		end = $end;
	}
	
	public function toBoolean():Boolean {
		return (start + end) > 0;
	}
}