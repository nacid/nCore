package ru.nacid.blanks.startup.simpleInit
{
	
	/**
	 * RotatePreloader.as
	 * Created On: 9.8 17:58
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
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class RotatePreloader extends Sprite
	{
		private var _color:uint;
		private var _minRadius:int;
		private var _segmentsCount:int;
		private var _segmentLength:int;
		private var _rotationSpeed:int;
		private var _timer:Timer;
		private var _playing:Boolean = false;
		
		public function RotatePreloader($pColor:uint = 0xF2F2F2, $minRadius:int = 10, $segmentLength:int = 10, $segmentsCount:int = 12, $rotationSpeed:int = 50)
		{
			super();
			
			_color = $pColor;
			_minRadius = $minRadius;
			_segmentLength = $segmentLength;
			_segmentsCount = $segmentsCount;
			_timer = new Timer($rotationSpeed);
			_timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			
			buildDisplay();
			play();
		}
		
		private function removeHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			destroy();
		}
		
		private function get totalSize():uint
		{
			return 2 * (_minRadius + _segmentLength);
		}
		
		override public function get width():Number
		{
			return totalSize;
		}
		
		override public function get height():Number
		{
			return totalSize;
		}
		
		public function play():void
		{
			if (_playing || !_timer)
				return;
			_timer.start();
			_playing = true;
		}
		
		public function stop():void
		{
			if (!_playing || !_timer)
				return;
			_timer.stop();
			_playing = false;
		}
		
		public function destroy():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color($colorValue:uint):void
		{
			_color = $colorValue;
			while (numChildren)
			{
				removeChildAt(0);
			}
			buildDisplay();
		}
		
		public function get segmentLength():int
		{
			return _segmentLength;
		}
		
		public function set segmentLength($lengthValue:int):void
		{
			_segmentLength = $lengthValue;
			while (numChildren)
			{
				removeChildAt(0);
			}
			buildDisplay();
		}
		
		public function get segmentsCount():int
		{
			return _segmentsCount;
		}
		
		public function set segmentsCount($countValue:int):void
		{
			_segmentsCount = $countValue;
			if (_segmentsCount < 5)
				_segmentsCount = 5;
			while (numChildren)
			{
				removeChildAt(0);
			}
			buildDisplay();
		}
		
		public function get minRadius():int
		{
			return _minRadius;
		}
		
		public function set minRadius($radiusValue:int):void
		{
			_minRadius = $radiusValue;
			while (numChildren)
			{
				removeChildAt(0);
			}
			buildDisplay();
		}
		
		public function get speed():int
		{
			return _timer.delay;
		}
		
		public function set speed($speedValue:int):void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
			_timer = new Timer($speedValue);
			_timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			if (_playing)
				_timer.start();
		}
		
		private function buildDisplay():void
		{
			for (var i:int = 0; i < _segmentsCount; i++)
			{
				var line:Shape = drawRoundedRect(_segmentLength, _segmentLength * 0.4, _segmentLength * 0.2, _color);
				line.x = _minRadius;
				line.y = -line.height / 2;
				var tempMc:Sprite = new Sprite();
				tempMc.addChild(line);
				tempMc.alpha = 0.3 + 0.7 * i / _segmentsCount;
				tempMc.rotation = 360 * i / _segmentsCount;
				addChild(tempMc);
			}
		}
		
		private function onTimerHandler(e:TimerEvent):void
		{
			rotation += 360 / _segmentsCount;
		}
		
		private function drawRoundedRect($w:Number, $h:Number, $bevel:Number = 0, $color:uint = 0x000000, $alpha:Number = 1):Shape
		{
			var mc:Shape = new Shape();
			mc.graphics.beginFill($color, $alpha);
			mc.graphics.moveTo($w - $bevel, $h);
			mc.graphics.curveTo($w, $h, $w, $h - $bevel);
			mc.graphics.lineTo($w, $bevel);
			mc.graphics.curveTo($w, 0, $w - $bevel, 0);
			mc.graphics.lineTo($bevel, 0);
			mc.graphics.curveTo(0, 0, 0, $bevel);
			mc.graphics.lineTo(0, $h - $bevel);
			mc.graphics.curveTo(0, $h, $bevel, $h);
			mc.graphics.lineTo($w - $bevel, $h);
			mc.graphics.endFill();
			return mc;
		}
	
	}
	
}