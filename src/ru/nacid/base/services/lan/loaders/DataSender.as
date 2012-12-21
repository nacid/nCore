package ru.nacid.base.services.lan.loaders
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import ru.nacid.base.services.lan.LanCommand;
	
	public class DataSender extends LanCommand
	{
		protected var reference:FileReference;
		protected var request:URLRequest;
		
		protected var fname:String;
		
		public function DataSender()
		{
			reference = new FileReference();
			
			reference.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			reference.addEventListener(Event.COMPLETE, responseHandler);
			reference.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		override protected function execInternal():void{
			request = urls.getUrl(url).urlRequest;
		}
	}
}