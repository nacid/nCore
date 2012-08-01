package ru.nacid.base.services.localization.commands 
{
	import flash.system.Capabilities;
	import ru.nacid.base.data.Global;
	import ru.nacid.base.services.lan.data.RequestVO;
	import ru.nacid.base.services.lan.loaders.DataLoader;
	import ru.nacid.base.services.localization.LocaleManager;
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
		
		protected var manager:LocaleManager;
		
		public function LoadLocaleMap($data:Object, $activate:Boolean = false, $lang:String = null)
		{
			super();
			
			lang = $lang || Global.language;
			activate = $activate;
			manager = LocaleManager.instance;
			
			parse($data);
			id = 'loadLocale';
		}
		
		override protected function createEncoder():IEncoder 
		{
			return new Csv;
		}
		
		protected function parse($data:Object):void {
			url = $data.host;
			data = $data.params;
			data.gid = $data.langs[lang] || $data.langs.default;
		}
		
		override protected function onResponse():void 
		{
			manager.addMap(new LocaleMap(lang, encoder.decodeObject(responseData)), activate);
			notifyComplete();
		}
		
	}

}