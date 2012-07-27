package ru.nacid.base.services.lan 
{
	import ru.nacid.base.data.factory.FactoryBase;
	import ru.nacid.base.data.interfaces.IFactoryData;
	import ru.nacid.base.services.lan.data.RequestVO;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class URLFactory extends FactoryBase 
	{
		
		public function URLFactory() 
		{
			cl = RequestVO;
		}
		
		override protected function create($key:String, $data:Object):IFactoryData
		{
			return new RequestVO($key, $data);
		}
		
		public function getUrl($url:String, $data:Object = null):RequestVO {
			return read($url, $data) as RequestVO;
		}
		
	}

}