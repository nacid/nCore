package ru.nacid.base.view
{
	import com.junkbyte.console.Cc;
	import flash.events.Event;
	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	import ru.nacid.base.services.windows.WindowParam;
	import ru.nacid.utils.StringUtils;
	/**
	 * ViewObject.as
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
	public class ViewObject extends BaseViewObject implements IData, IChannelParent
	{
		protected const VIEW_CHANNEL:String = 'DIS';
		
		private var _id:String;
		private var _numericId:Number;
		
		private var _inited:Boolean;
		private var _onStage:Boolean;
		
		protected var showData:Object;
		
		final public function applyId($id:String):void {
			_id = $id;
			_numericId = StringUtils.toCRC(_id);
			
			if (stage)
			{
				init();
				show();
			}
			else
				addEventListener(Event.ADDED_TO_STAGE, stageOnHandler);
		}
		
		private function stageOnHandler(e:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, stageOffHandler);
			removeEventListener(Event.ADDED_TO_STAGE, stageOnHandler);
			
			if (!_inited)
				init();
			_onStage = true;
			
			arrange();
			show();
		}
		
		private function stageOffHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, stageOffHandler);
			addEventListener(Event.ADDED_TO_STAGE, stageOnHandler);
			
			_onStage = false;
			hide();
		}
		
		protected function init():void
		{
			//@override
		}
		
		protected function show():void
		{
			//@override
		}
		
		protected function hide():void
		{
			//@override
		}
		
		public function arrange():void {
			//@override
		}
		
		public function isInited():Boolean
		{
			return _inited;
		}
		
		public function get onStage():Boolean
		{
			return _onStage;
		}
		
		/* INTERFACE ru.nacid.base.data.interfaces.IData */
		
		
		
		public function get symbol():String
		{
			return _id;
		}
		
		public function valueOf():Number
		{
			return _numericId;
		}
		
		/* INTERFACE ru.nacid.base.services.logs.interfaces.IChannelParent */
		
		public function log($string:String):void
		{
			Cc.logch(VIEW_CHANNEL, $string);
		}
		
		public function warning($string:String):void
		{
			Cc.warnch(VIEW_CHANNEL, $string);
		}
		
		public function info($string:String):void
		{
			Cc.infoch(VIEW_CHANNEL, $string);
		}
		
		public function error($string:String):void
		{
			Cc.errorch(VIEW_CHANNEL, $string);
		}
		
		public function critical($string:String):void
		{
			Cc.fatalch(VIEW_CHANNEL, $string);
		}
	
	}

}