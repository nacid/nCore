package ru.nacid.base.services.localization
{
	import com.junkbyte.console.Cc;
	import ru.nacid.base.data.managment.events.VOManagerEvent;
	import ru.nacid.base.data.managment.VOManager;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.services.localization.commands.DumpLocaleMap;
	import ru.nacid.utils.encoders.EncoderReflection;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class LocaleManager extends VOManager
	{
		protected function init():void
		{
			activeList = new Vector.<String>(1, true);
			list = new VOList();
			dispatcherMode = true;
			
			_instance = this;
			
			Cc.addSlashCommand('localeDump', dumpStarter, 'create formated localization map dump');
			log('locale manager created');
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
		
		//------------------------------
		override public function isActive($id:String):Boolean
		{
			return activeList[0] == $id;
		}
		
		override protected function activeIndex($id:String):int
		{
			return 0;
		}
		
		override public function activate($id:String):void
		{
			if (list.containsId($id) && !isActive($id))
			{
				activeList[0] = $id;
				
				info('locale changed');
				if (dispatcherMode)
					dispatchEvent(new VOManagerEvent(VOManagerEvent.ITEM_ACTIVATED, $id));
			}
		}
		
		override public function deactivate($id:String):void
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