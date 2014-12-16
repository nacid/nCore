/**
 * Created by Bondarev on 14.10.2014.
 */
package ru.nacid.base.services.lan.loaders.types {
	import flash.utils.ByteArray;

	public class TextType extends UploadType {

		public var text:String;

		public function TextType($key:String,$value:String = null) {
			ext = '.txt';
			text = $value || '';

			super($key, 'text/html');
		}

		override public function makeRaw():ByteArray {
			var response:ByteArray = new ByteArray();

			response.writeUTFBytes(text);
			response.position = 0;

			return response;
		}
	}
}
