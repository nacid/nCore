package ru.nacid.base.services.interfaces
{
	import flash.events.IEventDispatcher;
	
	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;

	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public interface ICommand extends IEventDispatcher, IChannelParent, IData
	{
		function execute($data:Object=null):void;
		function terminate():void;
		function get completed():Boolean;
		function get executing():Boolean;
		function set timeOut(value:uint):void;
		function get timeOut():uint;
	}

}
