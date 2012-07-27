package ru.nacid.base.services.lan.loaders 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import ru.nacid.base.services.lan.LanCommand;
	import ru.nacid.utils.encoders.interfaces.IEncoder;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class DataLoader extends LanCommand 
	{
		protected var loader	:URLLoader;
		protected var url		:String;
		protected var encoder	:IEncoder;
		
		public function DataLoader($url:String = null, $data:Object = null, $dataFormat:String = null)
		{
			timeOut = DEFAULT_TIMEOUT;
			data = $data;
			url = $url;
			encoder = createEncoder();
			
			loader = new URLLoader();
			loader.dataFormat = $dataFormat || URLLoaderDataFormat.TEXT;
			
			loader.addEventListener(Event.COMPLETE, responseHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		protected function createEncoder():IEncoder {
			return null;
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
			loader.removeEventListener(Event.COMPLETE, responseHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			responseData = loader.data;
			
			super.responseHandler(e);
		}
	}

}