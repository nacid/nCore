package ru.nacid.base.services.skins.commands
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.Capabilities;
	
	import ru.nacid.base.services.lan.loaders.MovieLoader;
	import ru.nacid.base.services.skins.Sm;
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;

	public class LoadSwfSkin extends MovieLoader implements ISkinLoader
	{
		public static const SIG:String='swf';

		private var _embed:Boolean;
		private var _mc:MovieClip;

		public function LoadSwfSkin($id:String=null, $url:String=null, $embed:Boolean=false)
		{
			super($url);

			symbol=$id;
			_embed=$embed;
		}

		override protected function onResponse():void
		{
			_mc=responseData as MovieClip;
			
			if (_mc.loaderInfo.applicationDomain.hasOwnProperty("getQualifiedDefinitionNames"))
			{
				var classes:Vector.<String>=_mc.loaderInfo.applicationDomain["getQualifiedDefinitionNames"]();
				var len:int=classes.length;

				while (len)
				{
					var className:String=classes[--len];
					var instance:ISkinLoader=new LoadClassSkin(className, _mc.loaderInfo.applicationDomain.getDefinition(className) as Class);

					if (addSkin(instance))
					{
						channelInfo('skin '.concat(className, ' added from ', url));
					}
					else
					{
						channelWarning('error with adding class skin "'.concat(className, '" from ', url));
					}
				}
			}
			else
			{
				channelError("Could not read classes. For a class list, open this application in Flash Player 11.3 or higher. Your current Flash Player version is: " + Capabilities.version);
			}

			notifyComplete();
		}

		protected function addSkin($instance:ISkinLoader):Boolean
		{
			return Sm.instance.addDirectly($instance);
		}

		public function getInstance():*
		{
			channelWarning('called getInstance method from LoadSwfSkin. Use internal classes with LoadClassSkin');
			return _mc;
		}
		
		public function getEmpty():*
			{
				return new Sprite();
			}

		public function fromData($id:String, $url:String, $embed:Boolean):ISkinLoader
		{
			return new LoadSwfSkin($id, $url, $embed);
		}

		public function get embed():Boolean
		{
			return _embed;
		}
	}
}
