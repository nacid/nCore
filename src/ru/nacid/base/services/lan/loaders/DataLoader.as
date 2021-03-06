package ru.nacid.base.services.lan.loaders
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	
	import ru.nacid.base.services.lan.LanCommand;
	import ru.nacid.utils.encoders.interfaces.IEncoder;

	/**
	 * DataLoader.as
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
	public class DataLoader extends LanCommand
	{
		protected var loader:URLLoader;
		protected var encoder:IEncoder;

		public function DataLoader($url:String=null, $data:Object=null, $dataFormat:String=null)
		{
			data=$data || {};
			url=$url;
			encoder=createEncoder();

			loader=new URLLoader();
			loader.dataFormat=$dataFormat || URLLoaderDataFormat.TEXT;

			loader.addEventListener(Event.COMPLETE, responseHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}

		protected function createEncoder():IEncoder
		{
			return null;
		}

		override protected function execInternal():void
		{
			prepareData();
			req = urls.getUrl(url, data).urlRequest;
			
			loader.load(req);
		}

		protected function prepareData():void
		{
			if (exeData)
			{
				for (var field:String in exeData)
				{
					data[field]=exeData[field];
				}
			}
		}

		override protected function responseHandler(e:Event):void
		{
			responseData=loader.data;
			responseLen=loader.bytesTotal;

			super.responseHandler(e);
		}
		
		override public function terminate():void {
			loader.removeEventListener(Event.COMPLETE, responseHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);

			super.terminate();
		}
	}
}
