package ru.nacid.base.services
{
	import flash.events.Event;

	/**
	 * CommandEvent.as
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
	public class CommandEvent extends Event
	{
		public static const START:String='start';
		public static const PROGRESS:String='progress';
		public static const COMPLETE:String='complete';
		public static const ERROR:String='error';

		public var progress:Number;

		public function CommandEvent(type:String, progress:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			this.progress=progress;
		}

		override public function clone():flash.events.Event
		{
			return new CommandEvent(type, progress, bubbles, cancelable);
		}

	}

}
