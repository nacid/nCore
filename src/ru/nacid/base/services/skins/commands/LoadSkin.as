package ru.nacid.base.services.skins.commands 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.net.URLLoaderDataFormat;
	import ru.nacid.base.services.lan.loaders.DataLoader;
	import ru.nacid.base.services.lan.loaders.MovieLoader;
	import ru.nacid.base.services.skins.interfaces.ISkinLoader;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
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
	public class LoadSkin extends MovieLoader implements ISkinLoader
	{
		private var skinData:Object
		private var _embed:Boolean;
		
		public function LoadSkin($id:String = null, $url:String = null,$embed:Boolean = false) 
		{
			super($url);
			id = $id;
			_embed = $embed;
		}
		
		override protected function onResponse():void 
		{
			skinData = responseData;
			notifyComplete();
		}
		
		public function getInstance():* {
			return new Bitmap((skinData as Bitmap).bitmapData.clone());
		}
		
		public function fromData($id:String, $url:String, $embed:Boolean):ISkinLoader {
			return new LoadSkin($id, $url, $embed);
		}
		
		public function get embed():Boolean 
		{
			return _embed;
		}
	}

}