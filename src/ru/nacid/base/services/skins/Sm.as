package ru.nacid.base.services.skins
{
	import com.junkbyte.console.Cc;

	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	import ru.nacid.base.services.skins.commands.LoadBitmapSkin;
	import ru.nacid.base.services.skins.commands.LoadSwfSkin;
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;
	import ru.nacid.base.services.skins.utils.SkinIterator;
	import ru.nacid.base.services.skins.utils.SkinList;

	/**
	 * Sm.as
	 * Created On: 21.8 12:36
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
	public class Sm implements IChannelParent
	{
		private const MAN_CHANNEL:String='MAN';

		private static var m_instance:Sm;

		private var types:Object;
		private var list:SkinList;

		/* Sm
		 * Use Sm.instance
		 * @param singleton DO NOT USE THIS - Use Sm.instance */
		public function Sm(singleton:*)
		{
			if (singleton is Sm || singleton is Singleton)
			{
				init();
			}
			else
			{
				throw new Error("Sm is a singleton class.  Access via ''Sm.instance''.");
			}
		}

		protected function init():void
		{
			types={};
			list=new SkinList();


			//DEFAULT TYPES
			addType(LoadBitmapSkin.SIG, new LoadBitmapSkin);
			addType(LoadSwfSkin.SIG, new LoadSwfSkin);
		}

		/* instance
		 * Gets the Sm instance */
		public static function get instance():Sm
		{
			if (Sm.m_instance == null)
				Sm.m_instance=new Sm(new Singleton());
			return Sm.m_instance;
		}

		public function addType($id:String, $type:ISkinLoader):void
		{
			if (getType($id) == null)
			{
				types[$id]=$type;
			}
		}

		private function getType($type:String):ISkinLoader
		{
			return types[$type];
		}

		public function addDirectly($skinLoader:ISkinLoader):Boolean
		{
			return list.add($skinLoader);
		}

		public function addSkin($type:String, $id:String, $url:String, $embed:Boolean):Boolean
		{
			var loader:ISkinLoader=getType($type);
			var result:Boolean;
			if (loader)
			{
				if (list.add(loader.fromData($id, $url, $embed)))
				{
					info('skin '.concat($id, ' added'));
					result = true;
				}
				else
				{
					error('error with add skin '.concat($id, ' duplicated'));
				}
			}
			else
			{
				error('unknown skin type:'.concat($type));
			}
			
			return result;
		}

		public function getEmbeds():VOIterator
		{
			var response:VOList=new VOList();
			var iterator:SkinIterator=getIterator();

			while (iterator.hasNext())
			{
				var n:ISkinLoader=iterator.next();
				if (n.embed)
				{
					response.add(n);
				}
			}

			return response.createIterator();
		}

		public function getIterator():SkinIterator
		{
			return list.createIterator();
		}

		public function getSkin ($id:String):Skin
		{
			return new Skin(list.atId($id));
		}

		public function isLoaded($id:String):Boolean
		{
			return list.containsId($id) && list.atId($id).loaded;
		}

		public function loadSkin($id:String):void
		{
			if (list.containsId($id))
			{
				(list.atId($id) as ISkinLoader).execute();
			}
		}

		public function contains($key:String):Boolean
		{
			return list.containsId($key);
		}

		/* INTERFACE ru.nacid.base.services.logs.interfaces.IChannelParent */

		public function log($string:String):void
		{
			Cc.logch(MAN_CHANNEL, $string);
		}

		public function warning($string:String):void
		{
			Cc.warnch(MAN_CHANNEL, $string);
		}

		public function info($string:String):void
		{
			Cc.infoch(MAN_CHANNEL, $string);
		}

		public function error($string:String):void
		{
			Cc.errorch(MAN_CHANNEL, $string);
		}

		public function critical($string:String):void
		{
			Cc.fatalch(MAN_CHANNEL, $string);
		}
	}
}

class Singleton
{
}
