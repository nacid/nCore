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
	 * LoadLocaleMap.as
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
			symbol = 'loadLocale';
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