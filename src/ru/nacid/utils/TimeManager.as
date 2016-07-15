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
		
		public static function timeToString($sec:int):String
		{
			var sec:int = $sec;
			var min:int = int(sec / 60);
			
			return zeroCheck(min) + ':' + zeroCheck(sec - min * 60);
			
			function zeroCheck($time:int):String
			{
				return $time < 10 ? '0'.concat($time) : String($time);
			}
		}
	}
}
