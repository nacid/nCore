package ru.nacid.base.view.component.button
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;

	import ru.nacid.base.view.component.button.enum.ButtonState;
import ru.nacid.base.view.component.button.interfaces.IInteractiveContent;

public class SimpleButton extends BaseButton
	{
		protected const DEFAULT_DISABLE_FILTERS:Array=[new ColorMatrixFilter([0.5, 0.5, 0.5, 0, 0, 0.5, 0.5, 0.5, 0, 0, 0.5, 0.5, 0.5, 0, 0, 0, 0, 0, 1, 0])];

		private var _skinMC:MovieClip;
		private var _enabled:Boolean=true;
		private var _stateHash:Object={};

		private var _content:DisplayObject;

		public var contentDelta:Point;

		public function SimpleButton($skin:String)
		{
			super($skin);
		}


		override public function arrange():void
		{
			if (currentWidth && skinMC)
			{
				skinMC.width=currentWidth;
			}
			if (currentHeight && skinMC)
			{
				skinMC.height=currentHeight;
			}

			if (_content)
			{
				_content.x=(currentWidth - _content.width) >> 1;
				_content.y=(currentHeight - _content.height) >> 1;

				if(contentDelta)
				{
					_content.x += contentDelta.x;
					_content.y += contentDelta.y;
				}
			}
		}


		override protected function hide():void {
			super.hide();
			setState(ButtonState.UP);
		}

		protected function get contentContainer():DisplayObjectContainer
		{
			return this;
		}

		public function set content(value:DisplayObject):void
		{
			if (_content && contentContainer.contains(_content))
			{
				contentContainer.removeChild(_content);
			}
			if (value)
			{
				_content=value;
				if (_content is InteractiveObject)
				{
					InteractiveObject(_content).mouseEnabled=false;
				}
				contentContainer.addChild(_content);
			}

			arrange();
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
			arrange();

			if (content is IInteractiveContent)
			{
				IInteractiveContent(content).changeState(currentState);
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
			updateSkinMC();
		}

		protected function skinHasLabel($label:String):Boolean
		{
			return _stateHash.hasOwnProperty($label);
		}

		protected function updateSkinMC():void
		{
			if (skin && skin.loaded)
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

                    return;
				}
				else
				{
					channelError(skinName.concat(' is not a MovieClip'));

					drawDefault();
				}
			}

            drawDefault();

            function drawDefault():void{
                _skinMC=new MovieClip();
                _skinMC.graphics.beginFill(0xCCCCCC);
                _skinMC.graphics.drawRect(0, 0, currentWidth || 100, currentHeight || 50);
            }
		}

		protected function get skinMC():MovieClip
		{
			if (_skinMC == null)
			{
				updateSkinMC();
			}

			return _skinMC;
		}

		override public function set width(value:Number):void
		{
			super.width=content && content.width > value ? content.width : value;
		}

		override public function set height(value:Number):void
		{
			super.height=content && content.height > value ? content.height : value;
		}
	}
}
