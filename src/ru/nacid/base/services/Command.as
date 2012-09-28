package ru.nacid.base.services
{
	import com.junkbyte.console.Cc;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.interfaces.ICommand;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	import ru.nacid.utils.StringUtils;
	/**
	 * Command.as
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
	public class Command extends EventDispatcher implements ICommand
	{
		public static const LOW_PRIORITY	:Number = Number.MIN_VALUE;
		public static const LOWER_PRIORITY	:Number = Number.NEGATIVE_INFINITY;
		public static const DEFAULT_PRIORITY:Number = 1;
		public static const HIGH_PRIORITY	:Number = Number.MAX_VALUE;
		public static const HIGHER_PRIORITY	:Number = Number.POSITIVE_INFINITY;
		
		public static const NO_TIMEOUT		:uint = 0;
		public static const DEFAULT_TIMEOUT	:uint = 5000;
		
		private static const cache:Vector.<Command> = Vector.<Command>([]);
		
		protected const CMD_CHANNEL:String = 'CMD';
		protected const START_EVENT		:CommandEvent = new CommandEvent(CommandEvent.START, 0);
		protected const PROGRESS_EVENT	:CommandEvent = new CommandEvent(CommandEvent.PROGRESS, 0);
		protected const COMPLETE_EVENT	:CommandEvent = new CommandEvent(CommandEvent.COMPLETE, 1);
		
		
		protected var exeData		:Object;
		protected var msgEnabled	:Boolean = true;
		protected var progress		:Number = 0;
		
		private var _id:String = '';
		private var _numericId:Number;
		
		private var _completed:Boolean;
		private var _executing:Boolean;
		private var _timeOut:uint;
		
		private var timer:Timer = new Timer(NO_TIMEOUT, 0);
		
		public var priority:Number = DEFAULT_PRIORITY;
		public var terminateOnError:Boolean = true;
		
		protected function msgExecute():void {
			Cc.infoch(CMD_CHANNEL, 'start execute for ', symbol, '|T =', _timeOut);
		}
		protected function msgComplete():void {
			Cc.logch(CMD_CHANNEL, symbol, 'complete');
		}
		protected function msgError():void {
			Cc.errorch(CMD_CHANNEL, 'error while executing', this);
		}
		protected function msgTimeOut():void {
			Cc.warnch('timeOut for "', symbol, '"');
		}
		
		final public function execute($data:Object = null):void
		{
			if (_executing || _completed)
				return;
			
			_executing = true;
			exeData = $data;
			
			if (cache.indexOf(this) == -1)
				cache.push(this);
				
			if (timeOut > 0)
				startTimout();
			
			dispatchEvent(START_EVENT);
			
			try
			{
				if (msgEnabled) msgExecute();
				execInternal();
			}
			catch (error:*)
			{
				onError(error);
			}
		}
		
		protected function commitProgress($progress:Number):void {
			progress = PROGRESS_EVENT.progress = $progress;
			dispatchEvent(PROGRESS_EVENT);
		}
		
		protected function startTimout():void
		{
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			timer.start();
		}
		
		protected function stopTimout():void
		{
			timer.stop();
		}
		
		protected function resetTimout():void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			timer.reset();
		}
		
		internal function reset():void
		{
			resetTimout();
			_completed = false;
			exeData = null;
		}
		
		final protected function notifyComplete():void
		{
			if (msgEnabled) msgComplete();
			_executing = false;
			_completed = true;
			
			terminate();
			dispatchEvent(COMPLETE_EVENT);
		}
		
		public function terminate():void
		{
			var index:int = cache.indexOf(this);
			if (index > -1)
				cache.splice(index, 1);
				
			if (timer.running)
				resetTimout();
			
			Cc.infoch(CMD_CHANNEL, symbol, 'terminated. Current cache size:', cache.length);
		}
		
		protected function onTimeout(event:Event):void
		{
			if (msgEnabled) msgTimeOut();
			if (!completed)
			{
				onError();
			}
		}
		
		protected function onError(err:* = null):void
		{
			if (msgEnabled) {
				error(err.toString());
				msgError();
			}
			dispatchEvent(new CommandEvent(CommandEvent.ERROR, 1));
			
			if (terminateOnError) terminate();
		}
		
		protected function execInternal():void
		{
			// virtual
		}
		
		public function get completed():Boolean 
		{
			return _completed;
		}
		
		public function get executing():Boolean 
		{
			return _executing;
		}
		
		public function set timeOut(value:uint):void 
		{
			timer.delay = _timeOut = value;
		}
		
		public function get timeOut():uint 
		{
			return _timeOut;
		}
		
		/* INTERFACE ru.nacid.base.services.logs.interfaces.IChannelParent */
		
		public function log($string:String):void 
		{
			Cc.logch(CMD_CHANNEL, $string);
		}
		
		public function warning($string:String):void 
		{
			Cc.warnch(CMD_CHANNEL, $string);
		}
		
		public function info($string:String):void 
		{
			Cc.infoch(CMD_CHANNEL, $string);
		}
		
		public function error($string:String):void 
		{
			Cc.errorch(CMD_CHANNEL, $string);
		}
		
		public function critical($string:String):void 
		{
			Cc.fatalch(CMD_CHANNEL, $string);
		}
		
		public function get symbol():String {
			return _id;
		}
		
		public function set symbol(value:String):void 
		{
			_id = value;
			_numericId = StringUtils.toCRC(_id);
		}
		
		public function valueOf():Number {
			return _numericId;
		}
		
	}

}