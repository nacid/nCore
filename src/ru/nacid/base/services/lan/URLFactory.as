package ru.nacid.base.services.lan 
{
	import ru.nacid.base.data.factory.FactoryBase;
	import ru.nacid.base.data.interfaces.IFactoryData;
	import ru.nacid.base.services.lan.data.RequestVO;
	import ru.nacid.base.services.lan.data.UrlStorage;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class URLFactory extends FactoryBase 
	{
		private var aliases:Object
		
		public function URLFactory() 
		{
			cl = RequestVO;
			aliases = { };
		}
		
		override protected function create($key:String, $data:Object):IFactoryData
		{
			return new RequestVO($key, $data);
		}
		
		public function getUrl($url:String, $data:Object = null):RequestVO {
			return read($url, $data) as RequestVO;
		}
		
		public function writeAlias($key:String, $data:Object):UrlStorage {
			return aliases[$key] = new UrlStorage($data.host, $data.params, $data.userData);
		}
		
		public function readAlias($key:String):UrlStorage {
			return aliases[$key] || writeAlias($key, { } );
		}
	}

}