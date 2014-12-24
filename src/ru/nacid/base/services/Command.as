package ru.nacid.base.services
{
	import com.junkbyte.console.Cc;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import ru.nacid.base.data.Global;

	import ru.nacid.base.services.interfaces.ICommand;
	import ru.nacid.utils.HashUtils;

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
		public static const LOW_PRIORITY:Number=Number.MIN_VALUE;
		public static const LOWER_PRIORITY:Number=Number.NEGATIVE_INFINITY;
		public static const DEFAULT_PRIORITY:Number=1;
		public static const HIGH_PRIORITY:Number=Number.MAX_VALUE;
		public static const HIGHER_PRIORITY:Number=Number.POSITIVE_INFINITY;

		public static const NO_TIMEOUT:uint=0;
		public static const DEFAULT_TIMEOUT:uint=5000;

		private static const cache:Vector.<Command>=Vector.<Command>([]);

		protected const CMD_CHANNEL:String='CMD';
		protected const START_EVENT:CommandEvent=new CommandEvent(CommandEvent.START, 0);
		protected const PROGRESS_EVENT:CommandEvent=new CommandEvent(CommandEvent.PROGRESS, 0);
		protected const COMPLETE_EVENT:CommandEvent=new CommandEvent(CommandEvent.COMPLETE, 1);


		protected var exeData:Object;
		protected var msgEnabled:Boolean=true;
		protected var progress:Number=0;

		private var _id:String='';
		private var _numericId:Number;

		private var _completed:Boolean;
		private var _executing:Boolean;
		private var _timeOut:uint;

		private var timer:Timer=new Timer(NO_TIMEOUT, 1);

		public var priority:Number=DEFAULT_PRIORITY;
		public var terminateOnError:Boolean=true;
		public var useProgress:Boolean=true;

		public function Command()
		{
			symbol = HashUtils.getRandomSigCRC();
		}

		protected function msgExecute():void
		{
			Cc.infoch(CMD_CHANNEL, 'start execute for ', symbol, '|T =', _timeOut);
		}

		protected function msgComplete():void
		{
			Cc.logch(CMD_CHANNEL, symbol, 'complete');
		}

		protected function msgError():void
		{
			Cc.errorch(CMD_CHANNEL, 'error while executing', this);
		}

		protected function msgTimeOut():void
		{
			Cc.warnch('timeOut for "', symbol, '"');
		}

		public function execute($data:Object=null):void
		{
			if (_executing || _completed)
				return;

			_executing=true;
			exeData=$data;

			if (cache.indexOf(this) == -1)
				cache.push(this);

			if (timeOut > 0)
				startTimout();

			dispatchEvent(START_EVENT);


			if(Global.isRelease())
			{
				try
				{
					if (msgEnabled)
						msgExecute();
					execInternal();
				}
				catch (error:*)
				{
					onError(error);
				}
			}else
			{
				if (msgEnabled)
					msgExecute();
				execInternal();
			}
		}

		protected function commitProgress($progress:Number):void
		{
			progress=PROGRESS_EVENT.progress=$progress;

			if (useProgress)
			{
				dispatchEvent(PROGRESS_EVENT);
			}
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

		protected function reset():void
		{
			resetTimout();
			_completed=false;
			_executing=false;
			exeData=null;
		}

		protected function notifyComplete():void
		{
			if (msgEnabled)
				msgComplete();
			_executing=false;
			_completed=true;

			terminate();
			commitProgress(1);
			dispatchEvent(COMPLETE_EVENT);
		}

		public function terminate():void
		{
			var index:int=cache.indexOf(this);
			if (index > -1)
				cache.splice(index, 1);

			if (timer.running)
				resetTimout();
			if (msgEnabled)
				Cc.infoch(CMD_CHANNEL, symbol, 'terminated. Current cache size:', getCacheSize());
		}

		protected function onTimeout(event:Event):void
		{
			if (msgEnabled)
				msgTimeOut();
			if (!completed)
			{
				onError();
			}
		}

		protected function onError(err:*=null):void
		{
			if (msgEnabled)
			{
				channelError(err);
				msgError();
			}
			dispatchEvent(new CommandEvent(CommandEvent.ERROR, 1));

			if (terminateOnError)
				terminate();
		}

		protected function execInternal():void
		{
			// virtual
		}

		final protected function getCacheSize():int
		{
			return cache.length;
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
			timer.delay=_timeOut=value;
		}

		public function get timeOut():uint
		{
			return _timeOut;
		}

		public function get description():String
		{
			return symbol;
		}

		/* INTERFACE ru.nacid.base.services.logs.interfaces.IChannelParent */

		public function channelLog($string:String):void
		{
			if(msgEnabled)
				Cc.logch(CMD_CHANNEL, $string);
		}

		public function channelWarning($string:String):void
		{
			if(msgEnabled)
				Cc.warnch(CMD_CHANNEL, $string);
		}

		public function channelInfo($string:String):void
		{
			if(msgEnabled)
				Cc.infoch(CMD_CHANNEL, $string);
		}

		public function channelError($string:String):void
		{
			Cc.errorch(CMD_CHANNEL, $string);
			Cc.stackch(CMD_CHANNEL, 'getStack(-1):', 15);
		}

		public function channelCrit($string:String):void
		{
			Cc.fatalch(CMD_CHANNEL, $string);
		}

		public function get symbol():String
		{
			return _id;
		}

		public function set symbol(value:String):void
		{
			_id=value;
			_numericId=HashUtils.CRC(_id);
		}

		public function valueOf():Number
		{
			return _numericId;
		}

	}

}
