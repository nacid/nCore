package ru.nacid.utils.geom
{
	import flash.geom.Point;

	public class Sector
	{
		private var _b:Point;
		private var _p1:Point;
		private var _p2:Point;

		public function Sector($base:Point=null, $p1:Point=null, $p2:Point=null)
		{
			_b=$base || new Point;
			_p1=$p1 || new Point;
			_p2=$p2 || new Point;
		}

		public function getFixedAngle($x1:Number, $x2:Number, $y1:Number, $y2:Number):Number
		{
			var rad:Number=GeomUtils.radBetweenPoints($x1, $x2, $y1, $y2);

			return rad < 0 ? Math.PI * 2 + rad : rad;
		}

		public function get base():Point
		{
			return _b;
		}

		public function get p1():Point
		{
			return _p1;
		}

		public function get p2():Point
		{
			return _p2;
		}

		//rad;

		public function get radius():Number
		{
			return Math.min(Point.distance(_b, _p1), Point.distance(_b, p2));
		}

		public function get angle1():Number
		{
			return getFixedAngle(_b.x, _p1.x, _b.y, _p1.y);
		}

		public function get angle2():Number
		{
			return getFixedAngle(_b.x, _p2.x, _b.y, _p2.y);
		}

		public function get insideAngle():Number
		{
			var a1:Number=angle1;
			var a2:Number=angle2;
			var r:Number=a2 > a1 ? a2 - a1 : a1 - a2;

			return r > Math.PI ? Math.PI *2 - r : r;
		}

		public function get maxAngle():Number
		{
			var response:Number
			return Math.max(angle1, angle2);
		}

		public function get minAngle():Number
		{
			return Math.min(maxAngle - insideAngle,angle1,angle2);
		}

		//какую часть составляет угол пересечения с $sector от insideAngle
		//(0...1)
		public function compareAngle($sector:Sector):Number
		{
			var intersect:Number=0;

			if ($sector.maxAngle > maxAngle)
			{
				intersect=maxAngle - $sector.minAngle;
			}
			else if ($sector.maxAngle > minAngle)
			{
				intersect=$sector.maxAngle - minAngle;

				if ($sector.minAngle > minAngle)
				{
					intersect-=($sector.minAngle - minAngle);
				}
			}

			return Math.abs(intersect/insideAngle);
		}
	}
}
