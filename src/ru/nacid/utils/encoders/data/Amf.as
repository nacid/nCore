package ru.nacid.utils.encoders.data
{
	import flash.utils.ByteArray;
	import ru.nacid.utils.encoders.interfaces.IByteEncoder;

	/**
	 * Amf.as
	 * Created On: 5.8 20:22
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
	public class Amf implements IByteEncoder
	{
		protected var decodeBa:ByteArray;

		protected var endian:String;
		protected var objectEncoding:uint;

		public function Amf($endian:String="bigEndian", $objectEncoding:uint=3)
		{
			endian=$endian;
			objectEncoding=$objectEncoding;

			decodeBa=createBytes();
		}

		protected function createBytes():ByteArray
		{
			var response:ByteArray=new ByteArray();
			response.objectEncoding=objectEncoding;
			response.endian=endian;

			return response;
		}

		/* INTERFACE ru.nacid.tools.encoders.interfaces.IByteEncoder */

		public function encodeBytes($data:ByteArray):ByteArray
		{
			var response:ByteArray=createBytes();
			response.writeBytes($data, 0, $data.length);

			return response;
		}

		public function decodeBytes($data:ByteArray):ByteArray
		{
			var startPosition:uint=$data.position;
			var response:ByteArray=createBytes();

			$data.position=0;
			$data.readBytes(response, 0, $data.bytesAvailable);
			$data.position=startPosition;

			return response;
		}

		public function encodeObject($data:Object):Object
		{
			var response:ByteArray=createBytes();
			response.writeObject($data);

			return response;
		}

		public function encodeString($data:String):Object
		{
			var response:ByteArray=createBytes();
			response.writeUTF($data);

			return response;
		}

		public function encodeFloat($data:Number):Object
		{
			var response:ByteArray=createBytes();
			response.writeFloat($data);

			return response;
		}

		public function decodeObject($data:Object):Object
		{
			return ($data as ByteArray).readObject();
		}

		public function decodeString($data:Object):String
		{
			return ($data as ByteArray).readUTF();
		}

		public function decodeFloat($data:Object):Number
		{
			return ($data as ByteArray).readFloat();
		}

	}

}
