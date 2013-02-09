package ru.nacid.base.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class DispatcherValueObject extends ValueObject implements IEventDispatcher
	{
		private var _dispatcher:EventDispatcher;

		public function DispatcherValueObject($id:String=null, $data:Object=null)
		{
			super($id, $data);

			_dispatcher=new EventDispatcher;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}

		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
	}
}
