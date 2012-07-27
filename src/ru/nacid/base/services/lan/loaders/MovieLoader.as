package ru.nacid.base.services.lan.loaders 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import ru.nacid.base.services.lan.LanCommand;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class MovieLoader extends LanCommand 
	{
		protected var loader	:Loader;
		protected var url		:String;
		
		public function MovieLoader($url:String = null, $data:Object = null)
		{
			timeOut = DEFAULT_TIMEOUT;
			data = $data;
			url = $url;
			
			loader = new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, responseHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		override protected function execInternal():void 
		{
			if (exeData) {
				for (var field:String in exeData) {
					data[field] = exeData[field];
				}
			}
			
			loader.load(urls.getUrl(url, data).urlRequest);
		}
		override protected function responseHandler(e:Event):void 
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, responseHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			responseData = loader.content;
			
			super.responseHandler(e);
		}
	}

}