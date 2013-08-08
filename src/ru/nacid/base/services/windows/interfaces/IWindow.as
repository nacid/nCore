package ru.nacid.base.services.windows.interfaces
{
	import ru.nacid.base.services.logs.interfaces.IChannelParent;
	import ru.nacid.base.services.windows.WindowParam;
	import ru.nacid.base.view.interfaces.IDisplayObject;

	public interface IWindow extends IDisplayObject, IChannelParent, IWindowStorage
	{
		function applyParam($param:WindowParam):void;
		function arrange():void;
		function setData($data:Object):void;
	}
}
