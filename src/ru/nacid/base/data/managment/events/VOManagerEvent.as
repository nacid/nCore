package ru.nacid.base.data.managment.events
{
	import flash.events.Event;

	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class VOManagerEvent extends Event
	{
		public static const ACTIVE_CHANGED:String='activeListChanged';
		public static const ITEM_ACTIVATED:String='itemActivated';
		public static const ITEM_DEACTIVATED:String='itemDeactivated';


		private var _item:String;

		public function get item():String
		{
			return _item;
		}

		public function VOManagerEvent(type:String, item:String='', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_item=item
			super(type, bubbles, cancelable);
		}

		override public function clone():flash.events.Event
		{
			return new VOManagerEvent(type, _item, bubbles, cancelable);
		}

	}

}
