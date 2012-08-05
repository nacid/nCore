package ru.nacid.base.services.localization.commands 
{
	import flash.system.Capabilities;
	import ru.nacid.base.data.Global;
	import ru.nacid.base.services.lan.data.RequestVO;
	import ru.nacid.base.services.lan.data.UrlStorage;
	import ru.nacid.base.services.lan.loaders.DataLoader;
	import ru.nacid.base.services.localization.Lm;
	import ru.nacid.base.services.localization.LocaleMap;
	import ru.nacid.utils.encoders.data.Csv;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class LoadLocaleMap extends DataLoader 
	{
		protected var lang		:String;
		protected var activate	:Boolean;
		
		protected var manager:Lm;
		
		public function LoadLocaleMap($host:String, $activate:Boolean = true, $lang:String = null)
		{
			super();
			
			lang = $lang || Global.language;
			activate = $activate;
			manager = Lm.instance;
			
			makeRequest(urls.readAlias($host))
			id = 'loadLocale';
		}
		
		protected function makeRequest($alias:UrlStorage):void {
			url = $alias.host;
			data = $alias.data;
			if($alias.userData.hasOwnProperty(lang)){
				data.gid = $alias.userData[lang];
			}
		}
		
		override protected function createEncoder():IEncoder 
		{
			return new Csv;
		}
		
		override protected function onResponse():void 
		{
			manager.addMap(new LocaleMap(lang, encoder.decodeObject(responseData)), activate);
			notifyComplete();
		}
		
	}

}