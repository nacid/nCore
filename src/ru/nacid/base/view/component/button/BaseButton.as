package ru.nacid.base.view.component.button
{
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import ru.nacid.base.services.CommandEvent;
	import ru.nacid.base.services.skins.Skin;
	import ru.nacid.base.services.skins.Sm;
	import ru.nacid.base.view.ViewObject;
	import ru.nacid.base.view.component.button.enum.ButtonState;
	import ru.nacid.utils.DelayedAction;
	import ru.nacid.utils.HashUtils;

	public class BaseButton extends ViewObject
	{
		protected var sm:Sm;
		protected var delayed:DelayedAction;

		protected var skinName:String;
		protected var skin:Skin;

		protected var currentWidth:Number;
		protected var currentHeight:Number;

		private var _currentState:String;
		private var _prevState:String;

		private var _statesFilters:Dictionary;

		public var maxWidth:Number=Number.MAX_VALUE;
		public var minWidth:Number=Number.MIN_VALUE;

		public var maxHeight:Number=Number.MAX_VALUE;
		public var minHeight:Number=Number.MIN_VALUE;

		public function BaseButton($skin:String)
		{
			sm=Sm.instance;
			delayed=new DelayedAction;
			skinName=$skin||'none';

			applyId(skinName.concat(HashUtils.getRandomSigCRC(16)));
		}

		override protected function init():void
		{
			super.init();

			skin=sm.getSkin(skinName);

			_prevState=ButtonState.DOWN;
			emptyStateFilters();

			if (skin.isVoid)
			{
				warning('unknown skin '.concat(skinName, ' use empty one'));

				skin.graphics.beginFill(0xCCCCCC);
				skin.graphics.drawRect(0, 0, 100, 50);

				addSkin();
				return;
			}

			if (!skin.loaded)
			{
				skin.loader.addEventListener(CommandEvent.COMPLETE, skinLoadHandler);
				skin.load();
			}
			else
			{
				addSkin();
			}
		}

		override protected function show():void
		{
			addListeners();
			setState(ButtonState.UP);
		}

		override protected function hide():void
		{
			removeListeners();
		}

		protected function addListeners():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		protected function removeListeners():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		override public function arrange():void
		{
			if (skin.loaded)
			{
				if (currentWidth)
				{
					super.width=skin.width=currentWidth;

				}
				if (currentHeight)
				{
					super.height=skin.height=currentHeight;
				}
			}
		}

		public function setStateFilters($state:String, $filters:Array):void
		{
			_statesFilters[$state]=$filters;
			setState(_currentState);
		}

		public function removeStateFilters($state:String):void
		{
			delete _statesFilters[$state];
		}

		public function emptyStateFilters():void
		{
			_statesFilters=new Dictionary(true);
			setState(_currentState);
		}

		public function getStateFilters($state:String):Array
		{
			return _statesFilters[$state];
		}

		protected function addSkin():void
		{
			if (contains(skin))
			{
				warning('duplicate addSkin() call. Skin already added');
				return;
			}

			onSkinReady();
			skin.mouseChildren=false;
			addChildAt(skin, 0);

			if (!currentWidth && skin.data)
			{
				currentWidth=skin.data.width;
			}else{
				currentWidth = 1;
			}

			if (!currentHeight && skin.data)
			{
				currentHeight=skin.data.height;
			}else{
				currentHeight = 1;
			}
		}

		protected function removeSkin():void
		{
			if (contains(skin))
			{
				removeChild(skin);
			}
		}

		protected function setState($newState:String):void
		{
			if ($newState != _currentState)
			{
				_prevState=_currentState;
				_currentState=$newState;

				onStateChanged();
			}

			this.filters= _statesFilters.hasOwnProperty(_currentState) ? getStateFilters(_currentState) : []
		}

		private function mouseOverHandler(e:MouseEvent):void
		{
			setState(ButtonState.OVER);
			onMouseOver();
		}

		private function mouseOutHandler(e:MouseEvent):void
		{
			setState(ButtonState.UP);
			onMouseOut();
		}

		private function mouseDownHandler(e:MouseEvent):void
		{
			setState(ButtonState.DOWN);
		}

		private function mouseUpHandler(e:MouseEvent):void
		{
			if (_currentState == ButtonState.DOWN)
			{
				setState(ButtonState.OVER);
				onClick();
			}
		}

		private function skinLoadHandler(e:CommandEvent):void
		{
			e.target.removeEventListener(e.type, skinLoadHandler);

			addSkin();
			arrange();
		}

		override public function set width(value:Number):void
		{
			if (value > maxWidth || value < minWidth)
			{
				return;
			}

			currentWidth=value;
			if (onStage && skin.loaded)
			{
				arrange();
			}
		}

		override public function get width():Number
		{
			return currentWidth;
		}

		override public function set height(value:Number):void
		{
			if (value > maxHeight || value < minHeight)
			{
				return;
			}

			currentHeight=value;
			if (onStage && skin.loaded)
			{
				arrange();
			}
		}

		override public function get height():Number
		{
			return currentHeight;
		}

		public function get currentState():String
		{
			return _currentState;
		}

		public function get prevState():String
		{
			return _prevState;
		}

		//@virtuals
		protected function onStateChanged():void
		{

		}

		protected function onSkinReady():void
		{

		}

		protected function onMouseOver():void
		{

		}

		protected function onMouseOut():void
		{

		}

		protected function onClick():void
		{

		}
	}
}
