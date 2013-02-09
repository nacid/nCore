package ru.nacid.base.services.lan.loaders
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import ru.nacid.base.services.lan.LanCommand;

	/**
	 * MovieLoader.as
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
	public class MovieLoader extends LanCommand
	{
		protected var loader:Loader;

		public function MovieLoader($url:String=null, $data:Object=null)
		{
			timeOut=DEFAULT_TIMEOUT;
			data=$data;
			url=$url;

			loader=new Loader();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, responseHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}

		override protected function execInternal():void
		{
			if (exeData)
			{
				for (var field:String in exeData)
				{
					data[field]=exeData[field];
				}
			}

			loader.load(urls.getUrl(url, data || { } ).urlRequest);
		}

		override protected function responseHandler(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, responseHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);

			responseData=loader.content;

			super.responseHandler(e);
		}
	}

}
