package ru.nacid.base.services.lan
{
	import com.junkbyte.console.Cc;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.lan.data.RequestVO;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class LanCommand extends Command
	{
		public static const urls:URLFactory = new URLFactory;
		
		protected var data:Object;
		protected var responseData:Object;
		
		protected var bytesForUnknown:uint = 512000;
		
		protected function progressHandler(e:ProgressEvent):void
		{
			if (e.bytesTotal == 0)
			{
				e.bytesTotal = Math.max(e.bytesLoaded, bytesForUnknown);
			}
			commitProgress(e.bytesLoaded / e.bytesTotal);
		}
		
		protected function responseHandler(e:Event):void
		{
			commitProgress(1);
			Cc.infoch(CMD_CHANNEL, id, 'received: \n', responseData);
			
			try
			{
				onResponse();
			}
			catch (error:*)
			{
				onError(error);
			}
		}
		
		protected function onResponse():void
		{
			//virtual
		}
		
		override protected function msgExecute():void
		{
			Cc.infoch(CMD_CHANNEL, '>>', id);
		}
		
		override protected function msgComplete():void
		{
			Cc.logch(CMD_CHANNEL, '<<', id);
		}
		
		public function get response():Object
		{
			return responseData;
		}
	}

}