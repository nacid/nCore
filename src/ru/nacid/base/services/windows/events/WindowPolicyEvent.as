package ru.nacid.base.services.windows.events
{
	import flash.events.Event;

	/**
	 * WindowPolicyEvent.as
	 * Created On: 5.8 20:22
	 *
	 * @author Nikolay nacid Bondarev
	 * @url https://github.com/nacid/nCore
	 *
	 *
	 *		Copyright 2012 Nikolay nacid Bondarev
	 *
	 *	Licensed under the Apache License, Version 2.0 (the "License");
	 *	you may not use this file except in compliance with the License.
	 *	You may obtain a copy of the License at
	 *
	 *		http://www.apache.org/licenses/LICENSE-2.0
	 *
	 *	Unless required by applicable law or agreed to in writing, software
	 *	distributed under the License is distributed on an "AS IS" BASIS,
	 *	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	 *	See the License for the specific language governing permissions and
	 *	limitations under the License.
	 *
	 */
	public class WindowPolicyEvent extends Event
	{
		public static const CLOSE_WINDOW:String='closeWindow';
		public static const OPEN_WINDOW:String='openWindow';

		private var _targetWindow:String;
		private var _displayIndex:int;
		private var _openData:Object;

		public function WindowPolicyEvent(type:String, targetWindow:String, openData:Object=null, displayIndex:int=-1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			_targetWindow=targetWindow;
			_displayIndex=displayIndex;
			_openData=openData;
		}

		override public function clone():flash.events.Event
		{
			return new WindowPolicyEvent(type, _targetWindow, _openData, _displayIndex, bubbles, cancelable);
		}

		public function get targetWindow():String
		{
			return _targetWindow;
		}

		public function get displayIndex():int
		{
			return _displayIndex;
		}

		public function get openData():Object
		{
			return _openData;
		}

	}

}
