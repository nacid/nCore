/**
 * Created by Bondarev on 20.04.2015.
 */
package ru.nacid.utils.math {
	
	public class Random {
		public function Random() {
		}

		static private var pSeed:uint;

		static public function set seed(val:uint):void {
			if (val != 0) pSeed = val;
			else pSeed = uint(Math.random() * uint.MAX_VALUE);
		}
		static public function get seed():uint {
			return pSeed;
		}

		//NORMAL
		static public function getNormalInt(min:int, max:int):int {
			pSeed = 214013 * pSeed + 2531011;
			return min + (pSeed ^ (pSeed >> 15)) % (max - min + 1);
		}

		static public function getNormalFloat(min:Number, max:Number):Number {
			pSeed = 214013 * pSeed + 2531011;
			return min + (pSeed >>> 16) * (1.0 / 65535.0) * (max - min);
		}
	}
}
