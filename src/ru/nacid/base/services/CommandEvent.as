package ru.nacid.base.services 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class CommandEvent extends Event 
	{
		public static const START		:String = 'start';
		public static const PROGRESS	:String = 'progress';
		public static const COMPLETE	:String = 'complete';
		public static const ERROR		:String = 'error';
		
		public var progress:Number;
		
		public function CommandEvent(type:String, progress:Number, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
			this.progress = progress;
		}
		
		override public function clone():flash.events.Event 
		{
			return new CommandEvent(type, progress, bubbles, cancelable);
		}
		
	}

}