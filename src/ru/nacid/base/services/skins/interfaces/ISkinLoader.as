package ru.nacid.base.services.skins.interfaces
{
	import flash.display.DisplayObject;
	import ru.nacid.base.services.interfaces.ICommand;

	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public interface ISkinLoader extends ICommand
	{
		function getInstance():*;
		function fromData($id:String, $url:String, $embed:Boolean):ISkinLoader
		function get embed():Boolean;
	}

}
