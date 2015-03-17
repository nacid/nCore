package ru.nacid.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import ru.nacid.base.data.Global;

	public class DelayedAction
	{
		private const _actions:Vector.<InternalAction>=Vector.<InternalAction>([]);
		private const _actionsHash:Dictionary=new Dictionary(true);

		private const _timer:Timer=new Timer(1000);

		private var _fps:int;

		public function DelayedAction($fps:int=0)
		{
			_fps=1000 / ($fps || Global.stageFPS);
			_timer.addEventListener(TimerEvent.TIMER, makeStep);
		}

		public function addAction($callback:Function, $delayFrame:uint=1, $scope:*=null):void
		{
			if (_actionsHash[$callback])
				return;

			_actionsHash[$callback]=_actions.push(new InternalAction($callback, _fps * $delayFrame, $scope));

			if (!_timer.running)
			{
				makeStep();
			}

		}

		private function makeStep(e:TimerEvent=null):void
		{
			_timer.reset();
			
			if (e)
			{
				var target:InternalAction=_actions.pop();
				target.release();

				delete _actions[target.callback];
			}

			if (_actions.length)
			{
				_timer.delay=_actions[_actions.length - 1].delay;
				_timer.start();
			}
		}
	}
}

class InternalAction
{
	private var _callback:Function;
	private var _scope:*;
	private var _delay:int;

	public function InternalAction($callback:Function, $delay:uint=1, $scope:*=null)
	{
		_callback=$callback;
		_delay=Math.max($delay, 1);
		_scope=$scope;
	}

	public function release():void
	{
		_callback.call(_scope);
	}

	public function get delay():uint
	{
		return _delay;
	}
	
	public function get callback():Function
	{
		return _callback;
	}
}

