/**
 * Created by Bondarev on 05.08.2015.
 */
package ru.nacid.utils.interfaces {

	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	public interface IGame extends IEventDispatcher{
		function start($container:DisplayObjectContainer,$flashVars:Object):void
	}
}
