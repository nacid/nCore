package ru.nacid.base.services.lan.data 
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import ru.nacid.base.data.interfaces.IFactoryData;
	import ru.nacid.base.data.SimpleValueObject;
	import ru.nacid.utils.HashUtils;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class RequestVO extends SimpleValueObject implements IFactoryData
	{
		private var method:String;
		private var _urlRequest:URLRequest;
		
		public var userData:Object;
		
		public function RequestVO($url:String, $data:Object=null,$method:String = null) 
		{
			super($url);
			
			_urlRequest = new URLRequest(id);
			_urlRequest.method = $method || URLRequestMethod.GET;
			setData($data);
		}
		
		public function setData($data:Object):void {
			_urlRequest.data = new URLVariables();
			for (var field:String in $data) {
				_urlRequest.data[field] = $data[field];
			}
			
			_numericId = HashUtils.CRC($data);
		}
		
		public function get urlRequest():URLRequest 
		{
			return _urlRequest;
		}
	}

}