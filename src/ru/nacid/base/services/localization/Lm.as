package ru.nacid.base.services.localization {
	import com.junkbyte.console.Cc;
	import ru.nacid.base.data.managment.events.VOManagerEvent;
	import ru.nacid.base.data.managment.VOManager;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.services.localization.commands.DumpLocaleMap;
	import ru.nacid.utils.encoders.EncoderReflection;
	/**
	 * Lm.as
	 * Created On: 5.8 16:41
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
	public class Lm  extends VOManager{
 
		private static var m_instance:Lm;
 
		/* Lm
		 * Use Lm.instance
		 * @param singleton DO NOT USE THIS - Use Lm.instance */
		public function Lm(singleton:Singleton) {
			if (singleton == null)
				throw new Error("Lm is a singleton class.  Access via ''Lm.instance''.");
				
			activeList = new Vector.<String>(1, true);
			list = new VOList();
			dispatcherMode = true;
			
			Cc.addSlashCommand('localeDump', dumpHandler, 'create formated localization map dump');
			log('locale manager created');
		}
 
		/* instance
		 * Gets the Lm instance */
		public static function get instance():Lm {
 			if (Lm.m_instance == null)
				Lm.m_instance = new Lm(new Singleton());
 			return Lm.m_instance;
 		}
		
		public function addMap($map:LocaleMap, $setCurrent:Boolean = false):void
		{
			if (list.add($map))
			{
				Cc.logch(MANAGER_CHANNEL, 'language map', $map.id, 'added');
				if ($setCurrent)
					activate($map.id);
			}
			else
			{
				Cc.logch(MANAGER_CHANNEL, 'language map', $map.id, 'not added');
			}
		}
		
		public function get activeMap():String
		{
			return activeList[0];
		}
		
		public function getString($key:String, $data:Object = null):String
		{
			return getStringFrom(activeMap, $key, $data);
		}
		
		public function getMap($key:String):LocaleMap
		{
			if (list.containsId($key))
			{
				return list.atId($key) as LocaleMap;
			}
			
			Cc.errorch(MANAGER_CHANNEL, 'locale map', $key, 'not found');
			return null;
		}
		
		public function getStringFrom($targetMap:String, $key:String, $data:Object = null):String
		{
			return LocaleMap(list.atId($targetMap)).getString($key, $data);
		}
		
		private function dumpHandler(... rest):void
		{
			var targetMap:String;
			if (list.containsId(rest[1]))
			{
				targetMap = rest[1];
			}
			else
			{
				Cc.warnch(MANAGER_CHANNEL, 'unknown language:', rest[1], 'using active map', activeMap);
				targetMap = activeMap;
			}
			new DumpLocaleMap(targetMap, EncoderReflection.data(rest[0])).execute();
		}
		
		override public function isActive($id:String):Boolean
		{
			return activeList[0] == $id;
		}
		
		override protected function activeIndex($id:String):int
		{
			return 0;
		}
		
		override protected function activate($id:String):void
		{
			if (list.containsId($id) && !isActive($id))
			{
				activeList[0] = $id;
				
				info('locale changed');
				if (dispatcherMode)
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ITEM_ACTIVATED, $id));
			}
		}
		
		override protected function deactivate($id:String):void
		{
			var index:int = activeIndex($id);
			if (index >= 0)
			{
				activeList[0] = null;
				
				if (dispatcherMode)
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ITEM_DEACTIVATED, $id));
			}
		}
	}
}
 
class Singleton { }