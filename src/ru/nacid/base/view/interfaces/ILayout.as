package ru.nacid.base.view.interfaces
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.data.store.VOList;

	public interface ILayout
	{
		function arrangeFromContainer(container:DisplayObjectContainer):void;
		function arrangeFromList(list:VOList):void;
		function arrangeFromIterator(iterator:VOIterator, reset:Boolean=true):void
		function arrangeFromArray(arr:Array):void;
		function arrangeFromObject(obj:Object):void;
		function arrangeItem($item:*, $index:int=0):void
		//отступ
		function get marginLeft():int;
		function set marginLeft(value:int):void;
		function get marginTop():int;
		function set marginTop(value:int):void;
		//минимальные размеры
		function get lines():int;
		function set lines(value:int):void;
		function get columns():int;
		function set columns(value:int):void;
		//промежутки
		function get hGap():int;
		function set hGap(value:int):void;
		function get vGap():int;
		function set vGap(value:int):void;
		//выравнивания
		function get hAlign():String;
		function set hAlign(value:String):void;
		function get vAlign():String;
		function set vAlign(value:String):void;
	}
}
