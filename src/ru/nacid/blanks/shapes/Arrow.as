package ru.nacid.blanks.shapes
{
	import flash.display.Shape;
	import flash.geom.Point;

	import ru.nacid.utils.geom.GeomUtils;

	public class Arrow extends Shape
	{
		protected const DEFAULT_COLOR:Number=0xCFCFCF;
		protected const DEFAULT_PAN:Number=20;
		protected const DEFAULT_PAN_ALI:Number=5;
		protected const DEFAULT_STROKE:Number=1;

		protected const CMDS:Vector.<int>=Vector.<int>([1, 2, 2, 1, 2]);
		
		public function Arrow(){
		}

		private var _color:Number;
		private var _pan:Number;
		private var _panAli:Number;
		private var _stroke:Number;

		private var _str:Point;
		private var _end:Point;

		//rad
		private var _angle:Number;

		public function drawByPoint($start:Point, $end:Point, $color:Number=NaN, $pan:Number=NaN, $panAli:Number=NaN, $stroke:Number=NaN):void
		{
			_color=isNaN($color) ? _color || DEFAULT_COLOR : $color;
			_pan=isNaN($pan) ? _pan || DEFAULT_PAN : $pan;
			_panAli=isNaN($panAli) ? _panAli || DEFAULT_PAN_ALI : $panAli;
			_stroke=isNaN($stroke) ? _stroke || DEFAULT_STROKE : $stroke;

			_str=$start;
			_end=$end;
			updateAngle();
			var pairs:Vector.<Number>=getPairs(GeomUtils.gradToRad(_panAli));

			graphics.clear();
			graphics.lineStyle(_stroke, _color);
			graphics.drawPath(CMDS, pairs);
		}

		public function drawByVector($len:Number, $rad:Number, $color:int=NaN, $pan:Number=NaN, $panAli:Number=NaN, $stroke:uint=NaN):void
		{
			drawByPoint(new Point, Point.polar($len, $rad), $color, $pan, $panAli, $stroke);
		}

		private function redraw():void
		{
			drawByPoint(_str, _end);
		}

		private function updateAngle():void
		{
			_angle=GeomUtils.radBetweenPoints(_str.x, _end.x, _str.y, _end.y);
		}

		private function getPairs($panRad:Number):Vector.<Number>
		{
			var response:Vector.<Number>=new Vector.<Number>(CMDS.length << 1, true);
			var pan1:Point=Point.polar(_pan, _angle + $panRad);
			var pan2:Point=Point.polar(_pan, _angle - $panRad);

			response[0]=_str.x;
			response[1]=_str.y;
			response[2]=_end.x;
			response[3]=_end.y;
			response[4]=_end.x + pan1.x;
			response[5]=_end.y + pan1.y;
			response[6]=response[2];
			response[7]=response[3];
			response[8]=_end.x + pan2.x;
			response[9]=_end.y + pan2.y;

			return response;
		}

		public function get color():int
		{
			return _color;
		}

		public function set color(value:int):void
		{
			_color=value;
			redraw();
		}

		public function get pan():Number
		{
			return _pan;
		}

		public function set pan(value:Number):void
		{
			_pan=value;
			redraw();
		}

		public function get panAli():Number
		{
			return _panAli;
		}

		public function set panAli(value:Number):void
		{
			_panAli=value;
			redraw();
		}

		public function get stroke():uint
		{
			return _stroke;
		}

		public function set stroke(value:uint):void
		{
			_stroke=value;
			redraw();
		}
	}
}
