package ru.nacid.base.services.skins.commands
{
	import flash.display.Bitmap;

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

		private var skinData:Bitmap;
		private var _embed:Boolean;

		public function LoadBitmapSkin($id:String=null, $url:String=null, $embed:Boolean=false)
		{
			super($url);
			symbol=$id;
			_embed=$embed;
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
			return new Bitmap();
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
