/**
 * Created by Bondarev on 14.10.2014.
 */
package ru.nacid.base.services.lan.loaders.types {
	import by.blooddy.crypto.image.JPEGEncoder;

	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	import ru.nacid.utils.image.ImageResizer;
	import ru.nacid.utils.image.ResizeMath;

	public class JpegType extends UploadType {

		//4K
		protected static const MAX_W:int = 4096;
		protected static const MAX_H:int = 2160;

		protected var source:BitmapData;
		protected var maxW:int;
		protected var maxH:int;

		public function JpegType($key:String, $bitmap:BitmapData, $maxW:int = 0, $maxH:int = 0) {
			source = $bitmap;
			ext = '.jpeg';

			maxW = $maxW > 0 ? Math.min($maxW, MAX_W) : MAX_W;
			maxH = $maxH > 0 ? Math.min($maxH, MAX_W) : MAX_H;

			super($key,'image/jpeg');
		}

		protected function resize($bitmap:BitmapData):BitmapData {
			var scale:Number = Math.max(Math.min(maxW / $bitmap.width, 1), Math.min(maxH / $bitmap.height, 1));

			return ImageResizer.bilinear($bitmap, $bitmap.width * scale, $bitmap.height * scale, ResizeMath.METHOD_PAN_AND_SCAN)
		}

		override public function makeRaw():ByteArray {
			return JPEGEncoder.encode(resize(source))
		}
	}
}
