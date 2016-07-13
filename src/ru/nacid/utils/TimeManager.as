/*
 *
 *  * Written by Nikolay nacid Bondarev <i@nacid.ru>, $today.mouth 2016
 *
 */

package ru.nacid.utils {

	import flash.utils.getTimer;
	
	public class TimeManager {

		private var _lastAbs:int;
		private var _lastRel:int;

		public function TimeManager() {
			correct(new Date().time/1000);
		}

		public function correct($currentUTC:Number):void
		{
			_lastAbs=$currentUTC;
			_lastRel=getTimer();
		}

		public function current():int
		{
			return _lastAbs + (getTimer() - _lastRel)/1000;
		}
	}
}
