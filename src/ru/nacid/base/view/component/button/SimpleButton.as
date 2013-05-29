package ru.nacid.base.view.component.button
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;

	import ru.nacid.base.view.component.button.enum.ButtonState;

	public class SimpleButton extends BaseButton
	{
		protected const DEFAULT_DISABLE_FILTERS:Array=[new ColorMatrixFilter([0.5, 0.5, 0.5, 0, 0, 0.5, 0.5, 0.5, 0, 0, 0.5, 0.5, 0.5, 0, 0, 0, 0, 0, 1, 0])];

		private var _skinMC:MovieClip;
		private var _enabled:Boolean=true;
		private var _stateHash:Object={};

		private var _content:DisplayObject;

		public function SimpleButton($skin:String)
		{
			super($skin);
		}


		override public function arrange():void
		{
			super.arrange();

			if (_content)
			{
				_content.x=(currentWidth - _content.width) >> 1;
				_content.y=(currentHeight - _content.height) >> 1;
			}
		}

		protected function get contentContainer():DisplayObjectContainer
		{
			return skin;
		}

		public function set content(value:DisplayObject):void
		{
			if (_content && contentContainer.contains(_content))
			{
				contentContainer.removeChild(_content);
				contentContainer.addChild(_content);
			}

			contentContainer.addChild(_content=value);
		}

		public function get content():DisplayObject
		{
			return _content;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if (value != _enabled)
			{
				_enabled=value;
				mouseEnabled=mouseChildren=_enabled;

				setState(ButtonState.UP);

				if (_enabled)
				{
					addListeners();
				}
				else
				{
					setState(ButtonState.DISABLED);
					removeListeners();
				}
			}
		}

		override protected function onStateChanged():void
		{
			if (skinMC && skinHasLabel(currentState))
			{
				skinMC.gotoAndStop(currentState);
			}
		}

		override protected function addListeners():void
		{
			if (!_enabled)
			{
				return;
			}

			super.addListeners();
		}

		override protected function init():void
		{
			super.init();
			setStateFilters(ButtonState.DISABLED, DEFAULT_DISABLE_FILTERS);
		}

		protected function skinHasLabel($label:String):Boolean
		{
			return _stateHash.hasOwnProperty($label);
		}

		protected function get skinMC():MovieClip
		{
			if (_skinMC == null)
			{
				if (skin.loaded)
				{
					if (skin.data is MovieClip)
					{
						_skinMC=skin.data;
						var i:int=_skinMC.currentLabels.length;

						while (i)
						{
							--i;

							if (_skinMC.currentLabels[i].name)
							{
								_stateHash[_skinMC.currentLabels[i].name]=_skinMC.currentLabels[i].frame;
							}
						}
					}
					else
					{
						error(skinName.concat(' is not a MovieClip'));

						_skinMC=new MovieClip();
						_skinMC.graphics.beginFill(0xCCCCCC);
						_skinMC.graphics.drawRect(0, 0, 100, 50);
					}
				}
				else
				{
					return null;
				}
			}
			
			return _skinMC;
		}
	}
}
