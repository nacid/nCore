/**
 * Created by Bondarev on 31.03.2015.
 */
package ru.nacid.base.view.component.lists {

	import com.gskinner.motion.GTween;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import ru.nacid.base.view.ViewObject;
	import ru.nacid.base.view.component.text.Label;
	import ru.nacid.base.view.interfaces.IContentRenderer;
	import ru.nacid.utils.HashUtils;
	import ru.nacid.utils.geom.GeomUtils;

	public class HorizontalList extends ViewObject {

		protected var elements:Vector.<IContentRenderer>;
		protected var renderer:Class;
		protected var container:Sprite;
		protected var containerMask:Sprite;

		protected var prevButton:DisplayObject;
		protected var nextButton:DisplayObject;

		protected var gap   :int = 0;
		protected var minGap:int = 10;
		protected var inline:uint = 0;

		private var _currentIndex:int = 0;
		private var _tween:GTween;
		private var _xBuffer:Number;

		private var _dp:Vector.<String>;
		private var _buttons:Vector.<DisplayObject>;

		private var _currentW:int;
		private var _activeW:int;
		private var _leftX:int;
		private var _currentH:int;
		private var _elementW:int;
		private var _elementH:int;
		private var _buttonsW:int;
		private var _sizeInvalidated:Boolean;

		public function HorizontalList($renderer:Class,$key:String = null,...buttons) {

			renderer = $renderer;
			elements = Vector.<IContentRenderer>([]);

			_buttons = Vector.<DisplayObject>(buttons);
			_dp = Vector.<String>([]);

			applyId($key || HashUtils.getRandomSigCRC());
		}

		override protected function init():void {
			super.init();

			addChild(container = new Sprite());
			addChild(containerMask = new Sprite());
			addChild(prevButton = createButton(false));
			addChild(nextButton = createButton(true));

			container.mask = containerMask;

			addElement();

			_elementW = elements[0].defaultWidth;
			_elementH = elements[0].defaultHeight;

			_tween = new GTween(this,.3);
			_tween.autoPlay = false;
			_tween.onChange = checkPosition;

			for each(var button:DisplayObject in _buttons)
				container.addChild(button);
		}

		override public function arrange():void {
			super.arrange();

			if(_sizeInvalidated)
				validateSize();
		}

		protected function arrangeElement($item:IContentRenderer,$index:int,$list:Vector.<IContentRenderer>):void
		{
			$item.arrange();
			$item.x = (_elementW + gap)*$index + (gap >> 1);
			$item.y = (currentHeight - $item.defaultHeight) >> 1;
		}

		protected function arrangeButton($item:DisplayObject,$index:int,$list:Vector.<DisplayObject>):void
		{
			$item.height = Math.min($item.height,currentHeight);
			$item.scaleX = $item.scaleY;

			var itemSlots:int = Math.ceil($item.width/(_elementW+gap));
			var itemW:int = itemSlots*(_elementW+gap);

			$item.x = (itemW - $item.width) / 2 -_buttonsW - itemW;
			$item.y = (currentHeight - $item.height) >> 1;

			_buttonsW += itemW;
		}

		protected function validateSize():void
		{
			_sizeInvalidated = false;
			_activeW = currentWidth - prevButton.width - nextButton.width - (minGap << 1);
			_leftX = currentWidth - _activeW >> 1;

			inline = Math.max(Math.floor(_activeW/(_elementW + minGap)),1);
			gap = (_activeW - _elementW*inline)/inline;

			while(elements.length - inline < 1)
				addElement();

			while(elements.length - inline > 1)
				removeElement();

			prevButton.y = nextButton.y = (currentHeight - prevButton.height) >> 1;
			prevButton.x = 0;
			nextButton.x = currentWidth - nextButton.width;

			drawScreen(containerMask.graphics,0x000000);
			elements.forEach(arrangeElement);

			_buttonsW = 0;
			buttons.forEach(arrangeButton);

			if((dp.length - inline) <= _currentIndex)
				_currentIndex = dp.length - inline - 1;

			if(_currentIndex < 0)
				_currentIndex = 0;

			if(setIndex(_currentIndex) && dp.length)
				moveByPos(0);
			else if(!_currentIndex) {
				_tween.paused = true;
				container.x = _buttonsW + _leftX;
			}
		}

		protected function moveByIndex($delta:int):void
		{
			moveByPos((_elementW + gap)*$delta);
		}

		protected function moveByPos($value:int):void
		{
			if(inline < dp.length)
			{
				var target:int = _leftX + GeomUtils.floorTo(container.x + $value,_elementW + gap);

				_tween.paused = true;
				_xBuffer = container.x;

				if(_xBuffer != target)
				{
					_tween.setValue('xBuffer',target);
					_tween.paused = false;
				}else if($value)
					checkPosition();
			}
		}

		public function set xBuffer($value:Number):void
		{
			container.x +=($value - _xBuffer);
			_xBuffer = $value;
		}

		public function get xBuffer():Number
		{
			return _xBuffer;
		}

		protected function checkPosition(tw:GTween = null):void
		{
			if(container.x < _leftX - (_elementW + gap))
			{
				if(setIndex(_currentIndex + 1))
					container.x += _elementW + gap;
				else
					moveByPos(_leftX - (_elementW + gap) - container.x);
			}else if(container.x > _leftX)
			{
				if(_buttonsW && _currentIndex == 0)
				{
					if(container.x > _leftX + _buttonsW)
						moveByPos(_buttonsW - container.x);
				}else
				{
					if(setIndex(_currentIndex - 1))
						container.x -= _elementW + gap;
					else
						moveByPos(_leftX - container.x);
				}
			}else if(!setIndex(_currentIndex))
				moveByPos(0);
		}

		public function setIndex($value:int):Boolean
		{
			if(dp.length <= inline)
				_currentIndex = 0;
			else if($value < 0 || $value >= (dp.length - inline))
				return false;

			_currentIndex = $value;

			for(var i:int = 0;i<elements.length;i++)
			{
				var j:int = _currentIndex + i;

				elements[i].visible = j < dp.length;

				if(j < 0 || j >= dp.length)
					continue;

				elements[i].contentKey = dp[j];
			}

			return true;
		}

		public function set dp($list:Vector.<String>):void
		{
			_dp = $list;
			_currentIndex = 0;

			invalidateSize(isInited());
		}

		public function get dp():Vector.<String>
		{
			return _dp
		}

		public function get buttons():Vector.<DisplayObject>
		{
			return _buttons;
		}

		//override
		public function createButton($next:Boolean):DisplayObject
		{
			var response:Label = new Label();
			response.text = $next ? '>' : '<';
			response.mouseEnabled = true;

			return response;
		}

		protected function addElement():IContentRenderer
		{
			var r:IContentRenderer = new renderer();
			r.invalidateContent();

			elements.push(r);
			container.addChild(r as DisplayObject);

			return r;
		}

		protected function removeElement():void
		{
			container.removeChild(elements.pop() as DisplayObject);
		}

		protected function buttonsHandler(e:MouseEvent):void
		{
			moveByIndex(stepSize*(e.currentTarget == prevButton ? 1 : -1));
		}

		override protected function show():void {
			super.show();

			nextButton.addEventListener(MouseEvent.CLICK,buttonsHandler);
			prevButton.addEventListener(MouseEvent.CLICK,buttonsHandler);
		}

		override protected function hide():void {
			super.hide();

			nextButton.removeEventListener(MouseEvent.CLICK,buttonsHandler);
			prevButton.removeEventListener(MouseEvent.CLICK,buttonsHandler);
		}

		private function drawScreen($target:Graphics,$color:int,$alpha:Number = .7):void
		{
			$target.clear();
			$target.beginFill($color,$alpha);
			$target.drawRect(_leftX,0,_activeW,currentHeight);
			$target.endFill();
		}

		public function invalidateSize($force:Boolean = false):void
		{
			_sizeInvalidated = true;

			if($force)
				arrange();
		}

		public function setSize($w:int,$h:int):void
		{
			if(currentWidth != $w || currentHeight != $h)
			{
				_currentW = $w;
				_currentH = $h;

				invalidateSize(isInited());
			}
		}

		public function get currentWidth():int
		{
			return _currentW;
		}

		public function get currentHeight():int
		{
			return _currentH;
		}

		protected function get stepSize():int
		{
			return inline;
		}
	}
}
