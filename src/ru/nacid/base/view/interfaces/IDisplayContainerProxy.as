package ru.nacid.base.view.interfaces
{
	import flash.display.DisplayObjectContainer;

	public interface IDisplayContainerProxy extends IDisplayObject
	{
		function get main():*;
		function empty($safe:Boolean=false):IDisplayContainerProxy;
		function setFocus($value:IDisplayObject = null):void;

		function add($display:IDisplayObject):IDisplayObject;
		function addAt($display:IDisplayObject, $depth:int):IDisplayObject;
		function rem($display:IDisplayObject):IDisplayObject;

		function move($display:IDisplayObject, $depth:int):void;
		function getDepth($display:IDisplayObject):int;
		function get numChild():int;

		function compatibility($with:*):Boolean;
	}
}
