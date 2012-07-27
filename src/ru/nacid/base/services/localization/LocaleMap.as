package ru.nacid.base.services.localization 
{
	import com.junkbyte.console.Cc;
	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.data.ValueObject;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class LocaleMap extends ValueObject 
	{
		protected var settings:LocaleMapSetting;
		protected var data:VOList;
		
		public function LocaleMap($id:String, $data:Object = null, $settings:LocaleMapSetting = null)
		{
			settings = $settings || new LocaleMapSetting;
			
			super($id, $data);
		}
		
		override protected function init():void 
		{
			data = new VOList();
			super.init();
		}
		
		override public function apply($data:Object):void 
		{
			super.apply($data);
			
			for each(var obj:Object in $data) {
				data.add(new LocaleString(settings, null, obj));
			}
		}
		
		public function getString($key:String, $data:Object = null):String {
			if (data.containsId($key)) 
				return LocaleString(data.atId($key)).getString($data);
			
			Cc.warnch(VO_CHANNEL, 'locale', $key, 'not exist in', id);
			return settings.undefinedValue;
		}
		
		public function dump():Object {
			var response:Array = [];
			var iterator:VOIterator = data.createIterator();
			
			while (iterator.hasNext()) {
				response.push(LocaleString(iterator.next()).dump());
			}
			
			return response;
		}
		
	}

}