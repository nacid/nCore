/**
 * Created by Bondarev on 31.03.2015.
 */
package ru.nacid.base.view.interfaces {

	import flash.events.IEventDispatcher;

	public interface IContentRenderer extends IEventDispatcher,IDisplayObject{
		function set contentKey($value:String):void;
		function get contentKey():String;
		function invalidateContent($force:Boolean = false):void;

		function get defaultWidth():int;
		function get defaultHeight():int;
		function arrange():void;

		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get visible():Boolean;
		function set visible(value:Boolean):void;
	}
}
