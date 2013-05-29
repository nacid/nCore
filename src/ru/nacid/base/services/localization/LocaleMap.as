package ru.nacid.base.services.localization
{
	import com.junkbyte.console.Cc;
	
	import ru.nacid.base.data.ValueObject;
	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.data.store.VOList;

	/**
	 * LocaleMap.as
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
	public class LocaleMap extends ValueObject
	{
		protected var settings:LocaleMapSetting;
		protected var data:VOList;

		public function LocaleMap($id:String, $data:Object=null, $settings:LocaleMapSetting=null)
		{
			settings=$settings || new LocaleMapSetting;

			super($id, $data);
		}

		override protected function init():void
		{
			data=new VOList();
			super.init();
		}

		override public function apply($data:Object):void
		{
			super.apply($data);

			for each (var obj:Object in $data)
			{
				data.add(new LocaleString(settings, null, obj));
			}
		}

		public function getString($key:String, $data:Object=null):String
		{
			if (data.containsId($key))
				return LocaleString(data.atId($key)).getString($data);

			Cc.warnch(VO_CHANNEL, 'locale', $key, 'not exist in', symbol);
			return settings.undefinedValue;
		}
		
		public function addString($string:LocaleString):Boolean{
			return data.add($string);
		}

		public function dump():Object
		{
			var response:Array=[];
			var iterator:VOIterator=data.createIterator();

			while (iterator.hasNext())
			{
				response.push(LocaleString(iterator.next()).dump());
			}

			return response;
		}

	}

}
