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
	 * LanCommand.as
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
	public class LanCommand extends Command
	{
		public static const urls:URLFactory=new URLFactory;

		protected var data:Object;
		protected var responseData:Object;

		protected var bytesForUnknown:uint=512000;

		protected var url:String;
		protected var req:URLRequest;

		protected function progressHandler(e:ProgressEvent):void
		{
			if (e.bytesTotal == 0)
			{
				e.bytesTotal=Math.max(e.bytesLoaded, bytesForUnknown);
			}
			commitProgress(e.bytesLoaded / e.bytesTotal);
		}

		protected function responseHandler(e:Event):void
		{
			commitProgress(1);
			Cc.infoch(CMD_CHANNEL, symbol, 'received: \n', responseData);

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
			notifyComplete();
		}

		override protected function msgExecute():void
		{
			Cc.infoch(CMD_CHANNEL, '>>', symbol, url);
		}

		override protected function msgComplete():void
		{
			Cc.logch(CMD_CHANNEL, '<<', symbol, url);
		}

		public function get response():Object
		{
			return responseData;
		}
	}

}
