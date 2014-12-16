/**
 * Created by Bondarev on 14.10.2014.
 */
package ru.nacid.base.services.lan.loaders.types {
	import flash.utils.ByteArray;

	import ru.nacid.base.data.SimpleValueObject;

	public class UploadType extends SimpleValueObject {

		protected var ext:String;

		private var _mimeType:String;
		private var _name:String;

		public function UploadType($key:String, $mimeType:String = null) {
			_mimeType = $mimeType || "application/octet-stream";
			_name = $key;

			super(makeFileName());
		}

		protected function makeFileName():String {
			return name.concat(ext);
		}

		public function makeRaw():ByteArray {
			//virtual
			return new ByteArray();
		}

		public function get name():String {
			return _name;
		}

		public function get mimeType():String{
			return _mimeType;
		}
	}
}
