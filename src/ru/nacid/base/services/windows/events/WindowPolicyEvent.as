package ru.nacid.base.services.windows.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class WindowPolicyEvent extends Event 
	{
		public static const CLOSE_WINDOW	:String = 'closeWindow';
		public static const OPEN_WINDOW		:String = 'openWindow';
		
		private var _targetWindow:String;
		private var _displayIndex:int;
		private var _openData:Object;
		
		public function WindowPolicyEvent(type:String,targetWindow:String,openData:Object = null,displayIndex:int = -1, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
			_targetWindow = targetWindow;
			_displayIndex = displayIndex;
			_openData = openData;
		}
		
		override public function clone():flash.events.Event 
		{
			return new WindowPolicyEvent(type, _targetWindow, _openData,_displayIndex, bubbles, cancelable);
		}
		
		public function get targetWindow():String 
		{
			return _targetWindow;
		}
		
		public function get displayIndex():int 
		{
			return _displayIndex;
		}
		
		public function get openData():Object 
		{
			return _openData;
		}
		
	}

}