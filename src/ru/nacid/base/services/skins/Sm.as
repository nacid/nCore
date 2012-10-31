package ru.nacid.base.services.skins
{
	import com.junkbyte.console.Cc;
	import mx.core.UIComponent;
	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	import ru.nacid.base.services.skins.commands.LoadSkin;
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;

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
		public static const BITMAP:String='BITMAP';
		
		private const MAN_CHANNEL:String='MAN';

		private static var m_instance:Sm;

		private var types:Object;
		private var list:VOList

		public var fxSkin:UIComponent;

		/* Sm
		 * Use Sm.instance
		 * @param singleton DO NOT USE THIS - Use Sm.instance */
		public function Sm(singleton:Singleton)
		{
			if (singleton == null)
				throw new Error("Sm is a singleton class.  Access via ''Sm.instance''.");

			types={};
			list=new VOList();

			addType(BITMAP, new LoadSkin);
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

		public function addSkin($type:String, $id:String, $url:String, $embed:Boolean):void
		{
			var loader:ISkinLoader=getType($type);
			if (loader)
			{
				if (list.add(loader.fromData($id, $url, $embed)))
				{
					info('skin '.concat($id, ' added'));
				}
				else
				{
					error('error with add skin '.concat($id));
				}
			}
			else
			{
				error('unknown skin type:'.concat($type));
			}
		}

		public function getEmbeds():VOIterator
		{
			var response:VOList=new VOList();
			var iterator:VOIterator=list.createIterator();

			while (iterator.hasNext())
			{
				var n:ISkinLoader=iterator.next() as ISkinLoader;
				if (n.embed)
				{
					response.add(n);
				}
			}

			return response.createIterator();
		}

		public function getSkin($id:String):Skin
		{
			return new Skin(list.atId($id) as ISkinLoader);
		}

		public function loadSkin($id:String):void
		{
			if (list.containsId($id))
			{
				(list.atId($id) as ISkinLoader).execute();
			}
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
