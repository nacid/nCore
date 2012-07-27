package ru.nacid.base.services.skins.commands 
{
	import ru.nacid.base.services.lan.loaders.MovieLoader;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class SwfSkinLoader extends MovieLoader 
	{
		
		public function SwfSkinLoader($url:String=null, $data:Object=null) 
		{
			super($url, $data);
			
		}
		
		override protected function onResponse():void 
		{
			notifyComplete();
		}
		
	}

}