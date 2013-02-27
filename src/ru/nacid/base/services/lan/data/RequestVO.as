package ru.nacid.base.services.lan.data
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import ru.nacid.base.data.SimpleValueObject;
	import ru.nacid.base.data.interfaces.IFactoryData;
	import ru.nacid.utils.HashUtils;

	/**
	 * RequestVO.as
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
	public class RequestVO extends SimpleValueObject implements IFactoryData
	{
		public static const HTTP:String='http';
		public static const HTTPS:String='https';
		public static const RELATIVE:String='';

		private const PROTOCOL_SEPARATE:String='://';
		private const DIR_SEPARATE:String='/';

		private var method:String;
		private var protocol:String;
		private var body:String;

		private var _urlRequest:URLRequest;

		public var userData:Object;

		public function RequestVO($url:String, $data:Object=null, $method:String=null)
		{
			super($url);

			_urlRequest=new URLRequest(symbol);
			_urlRequest.method=$method || URLRequestMethod.GET;

			var prEnd:int=$url.indexOf(PROTOCOL_SEPARATE);
			var bEnd:int=$url.lastIndexOf(DIR_SEPARATE);

			protocol=prEnd > 0 ? $url.substr(0, prEnd) : RELATIVE;
			body=protocol == RELATIVE ? $url.substring(0, bEnd) : bEnd > 0 ? $url.substring(prEnd + PROTOCOL_SEPARATE.length, bEnd) : RELATIVE;

			if ($data)
				setData($data);
		}

		public function setData($data:Object):void
		{
			_urlRequest.data=new URLVariables();
			for (var field:String in $data)
			{
				_urlRequest.data[field]=$data[field];
			}

			_numericId=HashUtils.CRC($data);
		}

		public function get urlRequest():URLRequest
		{
			return _urlRequest;
		}

		public function get domain():String
		{
			return protocol.concat(protocol == RELATIVE ? '' : PROTOCOL_SEPARATE, body, DIR_SEPARATE);
		}

	}

}
