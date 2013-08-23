package ru.nacid.base.services
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import ru.nacid.base.data.store.VOList;

	public class BgCommand extends CommandQueue
	{
		public var autoRepeat:Boolean=true;

		private var interval:int;
		private var swap:VOList=new VOList;
		private var timer:Timer;

		override public function addCommand(cmd:Command, $skipProgress:Boolean=false, autoPriority:Boolean=true):void
		{
			if (executing)
			{
				if (swap.add(new SwapData(cmd, autoPriority)))
				{
					if (msgEnabled)
					{
						info('cmd::'.concat(cmd.symbol, ' added to BgCommand::', symbol));
					}
				}
				else if (msgEnabled)
				{
					warning('cmd::'.concat(cmd.symbol, ' not added to BgCommand::', symbol, ' (duplicate id?)'));
				}
			}
			else
			{
				super.addCommand(cmd, autoPriority, $skipProgress);
				startInterval();
			}
		}

		override protected function onComplete():void
		{
			reset();
			drop();
			if (autoRepeat)
			{
				startInterval();
			}
		}

		override protected function reset():void
		{
			super.reset();

			while (swap.size)
			{
				var add:SwapData=swap.removeLast() as SwapData;

				if (add)
				{
					addCommand(add.cmd, add.autopriority);
				}
			}
		}

		public function drop():void
		{
			if (executing)
			{
				warning('unable drop '.concat(symbol, ' - executing right now'));
				return;
			}

			list.clear();
			swap.clear();

			step=0;
			commitProgress(0);
		}

		public function stopInterval():void
		{
			if (timer)
			{
				timer.reset();
			}
		}

		public function startInterval():void
		{
			if (interval)
			{
				if (timer == null)
				{
					timer=new Timer(interval, 0);
					timer.addEventListener(TimerEvent.TIMER, intervalHandler);
				}
				timer.start();
			}
		}

		//ms
		public function setInterval(value:int):void
		{
			interval=value;

			if (timer)
			{
				timer.delay=value;
				stopInterval();
				startInterval();
			}
		}

		private function intervalHandler(e:TimerEvent):void
		{
			if (!executing && getCacheSize() <= 1 && list.size)
			{
				execute();
				stopInterval();
			}
		}
	}
}
import ru.nacid.base.data.interfaces.IData;
import ru.nacid.base.services.Command;

class SwapData implements IData
{
	private var _cmd:Command;
	private var _autopriority:Boolean;

	public function SwapData($cmd:Command, $autopriority:Boolean)
	{
		_cmd=$cmd;
		_autopriority=$autopriority;
	}

	public function get cmd():Command
	{
		return _cmd;
	}

	public function get autopriority():Boolean
	{
		return _autopriority;
	}

	//----interface IData----
	public function get symbol():String
	{
		return _cmd.symbol;
	}

	public function valueOf():Number
	{
		return _cmd.valueOf();
	}
}
