package ru.nacid.base.services.skins.commands 
{
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.CommandQueue;
	import ru.nacid.base.services.lan.data.UrlStorage;
	import ru.nacid.base.services.lan.loaders.DataLoader;
	import ru.nacid.base.services.skins.Sm;
	import ru.nacid.utils.encoders.data.Csv;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	/**
	 * LoadSkinsMap.as
	 * Created On: 21.8 14:45
	 * 
	 * @author Nikolay nacid Bondarev
	 * @url https://github.com/nacid/Sand
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
	public class LoadSkinsMap extends DataLoader 
	{
		protected function get trueString():String {
			return 'TRUE';
		}
		protected function get falseString():String {
			return 'FALSE';
		}
		
		private var autoLoad:Boolean;
		private var mapDir:String;
		private var manager:Sm;
		
		public function LoadSkinsMap($skinsDir:String,$mapFile:String,$autoLoad:Boolean = false) 
		{
			manager = Sm.instance;
			priority = Command.HIGHER_PRIORITY;
			autoLoad = $autoLoad;
			
			symbol = 'LoadSkinsMap';
			makeRequest(urls.readAlias($skinsDir), $mapFile);
		}
		
		protected function makeRequest($alias:UrlStorage,$mapFile:String):void {
			url = $alias.host.concat($mapFile);
			mapDir = $alias.host;
			data = $alias.data;
		}
		
		override protected function createEncoder():IEncoder 
		{
			return new Csv;
		}
		
		override protected function onResponse():void 
		{
			var skins:Object = encoder.decodeObject(responseData);
			
			for each(var skinDesc:Object in skins) {
				manager.addSkin(skinDesc.type, skinDesc.id, mapDir.concat(skinDesc.url), skinDesc.embed == trueString ? true : false);
			}
			
			notifyComplete();
		}
		
	}

}