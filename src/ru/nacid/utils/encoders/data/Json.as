package ru.nacid.utils.encoders.data 
{
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	/**
	 * Json.as
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
	public class Json implements IEncoder 
	{
		/* INTERFACE ru.nacid.utils.encoders.interfaces.IEncoder */
		
		public function encodeObject($data:Object):Object 
		{
			return JSON.stringify($data);
		}
		
		public function encodeString($data:String):Object 
		{
			return JSON.stringify($data);;
		}
		
		public function encodeFloat($data:Number):Object 
		{
			return JSON.stringify($data);
		}
		
		public function decodeObject($data:Object):Object 
		{
			return JSON.parse(String($data));
		}
		
		public function decodeString($data:Object):String 
		{
			return String(JSON.parse(String($data)));
		}
		
		public function decodeFloat($data:Object):Number 
		{
			return parseFloat(String(JSON.parse(String($data))));
		}
		
	}

}