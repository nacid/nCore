package ru.nacid.base.services.windows.interfaces
{
	import flash.events.IEventDispatcher;

	import ru.nacid.base.data.interfaces.IData;
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	import ru.nacid.base.services.windows.WindowParam;
	import ru.nacid.base.view.interfaces.IDisplayObject;

	public interface IWindow extends IDisplayObject, IData, IChannelParent, IWindowStorage, IEventDispatcher
	{
		function applyParam($param:WindowParam):void;
		function arrange():void;
		function setData($data:Object):void;
	}
}
