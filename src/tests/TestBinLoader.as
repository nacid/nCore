package tests 
{
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.lan.loaders.DataLoader;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class TestBinLoader extends DataLoader 
	{
		
		public function TestBinLoader($url:String=null, $data:Object=null, $dataFormat:String=null) 
		{
			super($url, $data, $dataFormat);
			id = 'test loading';
			priority = Command.LOW_PRIORITY;
		}
		
		override protected function onResponse():void 
		{
			notifyComplete();
		}
		
	}

}