package ru.nacid.base.services.skins.commands
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;

	import ru.nacid.base.services.lan.loaders.MovieLoader;
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;

	/**
	 * LoadBitmap.as
	 * Created On: 21.8 17:27
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
	public class LoadBitmapSkin extends MovieLoader implements ISkinLoader
	{
		public static const SIG:String='bitmap';

		private static const __loadedPolices:Object = {}
		private static var 	 __emptyBD:BitmapData;

		private var skinData:Bitmap;
		private var _embed:Boolean;

		public function LoadBitmapSkin($id:String=null, $url:String=null, $embed:Boolean=false)
		{
			super($url);
			symbol=$id;
			_embed=$embed;
		}

		override protected function execInternal():void {
			if(url)
			{
				var domain:String = url.split('/',3).join('/');

				if(!__loadedPolices[domain])
				{
					Security.loadPolicyFile(domain.concat("/crossdomain.xml"));

					__loadedPolices[domain] = true
				}
			}

			super.execInternal();
		}

		override protected function createContext():LoaderContext {
			return new LoaderContext(true,ApplicationDomain.currentDomain,SecurityDomain.currentDomain);
		}

		override protected function onResponse():void
		{
			skinData=Bitmap(responseData);
			notifyComplete();
		}

		public function getInstance():*
		{
			return new Bitmap(skinData.bitmapData, 'auto', true);
		}
		
		public function getEmpty():*
		{
			if(!__emptyBD)
			{
				__emptyBD = new BitmapData(64,64,false,0xFFFFF);
				__emptyBD.fillRect(new Rectangle(0,0,32,32),0x339900);
				__emptyBD.fillRect(new Rectangle(32,32,64,64),0x339900);
			}

			return new Bitmap(__emptyBD);
		}

		public function fromData($id:String, $url:String, $embed:Boolean):ISkinLoader
		{
			return new LoadBitmapSkin($id, $url, $embed);
		}

		public function get embed():Boolean
		{
			return _embed;
		}
	}

}
