package ru.nacid.utils.geom
{
	public class GeomUtils
	{
		//PI/180
		private static const QUOT_PI_180:Number=0.01745329251;
		//180/PI
		private static const QUOT_180_PI:Number=57.2957795130;

		//α[°] = α[рад] × (180 / π)
		public static function radToGrad($rad:Number, $accurate:Boolean=false):Number
		{
			return $accurate ? $rad * (180 / Math.PI) : $rad * QUOT_180_PI;
		}

		//α[рад] = α[°] × (π / 180)
		public static function gradToRad($grad:Number, $accurate:Boolean=false):Number
		{
			return $accurate ? $grad * (Math.PI / 180) : $grad * QUOT_PI_180;
		}

		public static function radBetweenPoints($x1:Number, $x2:Number, $y1:Number, $y2:Number):Number
		{
			return Math.atan2($y1 - $y2, $x1 - $x2);
		}

		public static function gradBetweenPoints($x1:Number, $x2:Number, $y1:Number, $y2:Number, $accurate:Boolean=false):Number
		{
			return radToGrad(radBetweenPoints($x1, $x2, $y1, $y2), $accurate);
		}
		
		public static function floorTo(value:Number, base:Number): Number
		{
			return Math.floor((value + base / 2) / base) * base;
		}

		public static function ceilTo(value:Number, base:Number): Number
		{
			return Math.ceil((value + base / 2) / base) * base;
		}
	}
}
