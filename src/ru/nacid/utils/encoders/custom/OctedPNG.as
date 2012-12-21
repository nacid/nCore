package ru.nacid.utils.encoders.custom
{
	import flash.display.BitmapData;
	
	import ru.nacid.utils.encoders.data.Csv;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	/**
	 * OctedPNG.as
	 * Created On: 12.10 20:22
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
	
	public class OctedPNG
	{
		private const ASII_DELTA:uint=913;
		private const DATA_ALPHA:uint=0xFF << 24;
		private const BACK_ALPHA:uint=0x00;
		
		protected var encoder:IEncoder;
		
		public function OctedPNG($dataEncoder:IEncoder=null)
		{
			encoder=$dataEncoder || new Csv;
		}
		
		public function readData($bmpData:BitmapData):Object
		{
			var pixels:Vector.<Pixel>=getReadPixels($bmpData);
			var strings:Vector.<String>=Vector.<String>([]);
			
			for (var i:int=0; i < pixels.length; i++)
			{
				var color:uint=pixels[i].color32;
				
				if (color >> 16 & 0xFF)
					strings.push(String.fromCharCode(color >> 16 & 0xFF));
				if (color >> 8 & 0xFF)
					strings.push(String.fromCharCode(color >> 8 & 0xFF));
				if (color & 0xFF)
					strings.push(String.fromCharCode(color & 0xFF));
				
				$bmpData.setPixel32(pixels[i].x, pixels[i].y, BACK_ALPHA);
			}
			
			return strings.length ? encoder.decodeObject(strings.join('')) : null;
		}
		
		public function writeData($target:BitmapData, $data:Object, $stringEncoder:IEncoder=null):BitmapData
		{
			$stringEncoder=$stringEncoder ? $stringEncoder : encoder;
			
			var strings:Vector.<int>=getCodes($stringEncoder.encodeObject($data) as String);
			var pixels:Vector.<Pixel>=getWritePixels(strings.length / 3, $target);
			var target:BitmapData=$target.clone();
			
			var si:int=-1;
			for (var i:int=0; i < pixels.length; i++)
			{
				target.setPixel32(pixels[i].x, pixels[i].y, DATA_ALPHA | (strings[++si] << 16) | (strings[++si] << 8) | (strings[++si]));
			}
			
			return target;
		}
		
		
		private function getCodes($string:String):Vector.<int>
		{
			var mod3:Number=$string.length % 3;
			var result:Vector.<int>=new Vector.<int>(mod3 == 0 ? $string.length : $string.length + 3 - mod3, true);
			
			for (var i:int=0; i < result.length; i++)
			{
				var charCode:int=i < $string.length ? $string.charCodeAt(i) : 0;
				result[i]=charCode > 127 ? charCode - ASII_DELTA : charCode;
			}
			return result;
		}
		
		//@TODO: переделать c вектора на ByteArray (Pixel = 4x5 = 20 bytes)
		private function getWritePixels($len:uint, $btmp:BitmapData):Vector.<Pixel>
		{
			var result:Vector.<Pixel>=new Vector.<Pixel>($len, true);
			var pos:uint=0;
			
			for (var y:uint=0; y < $btmp.height; y++)
			{
				for (var x:uint=0; x < $btmp.width; x++)
				{
					var pix:Pixel=new Pixel(x, y, $btmp.getPixel32(x, y));
					
					if (pix.color32 == BACK_ALPHA && $btmp.getPixel32(x + 1, y) == BACK_ALPHA)
					{
						result[pos]=pix;
						
						if (++pos >= $len)
							return result;
					}
					else
					{
						break;
					}
				}
			}
			
			throw new RangeError('pixel pull ended');
			
			return result;
		}
		
		private function getReadPixels($btmp:BitmapData):Vector.<Pixel>
		{
			var result:Vector.<Pixel>=Vector.<Pixel>([]);
			var pos:uint=0;
			var skips:uint=0;
			
			for (var y:uint=0; y < $btmp.height; y++)
			{
				for (var x:uint=0; x < $btmp.width; x++)
				{
					var pix:Pixel=new Pixel(x, y, $btmp.getPixel32(x, y));
					
					if (pix.color32 != BACK_ALPHA)
					{
						skips=0;
						result[pos]=pix;
						pos++;
					}
					else
					{
						if (++skips > 1)
						{
							return result;
						}
						break;
					}
				}
			}
			
			throw new RangeError('pixel pull ended');
			
			return result;
		}
	}
}

class Pixel
{
	private var _x:int;
	private var _y:int;
	
	private var _rgb:int;
	private var _argb:int;
	
	private var _alpha:int;
	
	public function Pixel($x:uint, $y:uint, $color:uint)
	{
		_x=$x;
		_y=$y;
		
		setColor32($color);
	}
	
	private function setColor32($color:int):void
	{
		_argb=$color;
		_rgb=0xFFFFFF & _argb;
		_alpha=(_argb >> 24) & 0xFF;
	}
	
	public function get x():int
	{
		return _x;
	}
	
	public function get y():int
	{
		return _y;
	}
	
	public function get color32():int
	{
		return _argb;
	}
	
	public function get color():int
	{
		return _rgb;
	}
	
	public function setColor($color:int):void
	{
		setColor32(0 | $color);
	}
}
