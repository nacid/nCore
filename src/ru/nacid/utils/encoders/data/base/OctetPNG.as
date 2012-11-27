package ru.nacid.utils.encoders.data.base
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	public class OctetPNG
	{
		protected const CODE_PAGE_DELTA	:int = 913;
		
		protected var background:int;
		protected var encoder:IEncoder;
		
		public function OctetPNG($dataEncoder:IEncoder,$background:int = 0xFF)
		{
			background = $background;
			encoder = $dataEncoder;
		}
		
		protected function decodeData($data:Vector.<uint>):String {
			var response:String = '';
			
			for (var w:int = 0; w < $data.length; w++) {
				response = decode(decodePixel($data[w])).concat(response);
			}
			return response;
		}
		
		protected function encodeData($string:String, $rect:Rectangle):BitmapData {
			
			var maxLen:int  = $rect.width;
			
			if ($string.length > maxLen * 3) throw(new Error('input len > maxLen'));
			
			var response:BitmapData = new BitmapData($rect.width, $rect.height, false, background);
			var data:Vector.<int> = encode($string);
			var i:int = data.length;
			var w:int = 0;
			
			while (i) {
				w++;
				response.setPixel(++w, 0, 0|(data[--i] << 16 | data[--i]  << 8 | data[--i]));
			}
			
			return response;
		}
		
		private function decodePixel($color:uint):Vector.<int> {
			$color &= 0xFFFFFF;
			return Vector.<int>( $color == background ? [] : [$color >> 16, $color >> 8 & 0xFF, $color & 0xFF] ).reverse();
		}
		
		private function decode($vect:Vector.<int>):String {
			var response:String = '';
			
			var charCode:int;
			
			for (var i:int = 0; i < $vect.length; i++) {
				charCode = $vect[i] > 127 ? CODE_PAGE_DELTA + $vect[i] : $vect[i]; 
				response = response.concat(String.fromCharCode(charCode));
			}
			
			return response;
		}
		
		private function encode($str:String):Vector.<int> {
			var response:Vector.<int> = new Vector.<int>($str.length + ($str.length % 3), true);
			var charCode:int;
			
			for (var i:int = 0; i < response.length; i++) {
				charCode = $str.charCodeAt(i);
				response[i] = charCode > 127 ? charCode - CODE_PAGE_DELTA : charCode;
			}
			
			return response;
		}
		
		
	}
}