package ru.nacid.base.view.component.button
{
	import flash.display.FrameLabel;
	import flash.events.Event;

	public class AnimatedButton extends SimpleButton
	{
		private var _currentAnimation:String;
		private var _reverseStateHash:Object={};

		public function AnimatedButton($skin:String)
		{
			super($skin);
		}

		override protected function onStateChanged():void
		{
			_currentAnimation=prevState ? prevState.concat(currentState) : null;

			if (skinMC && skinHasLabel(_currentAnimation))
			{
				animateFrom(_currentAnimation);
				return;
			}

			super.onStateChanged();
		}

		override protected function updateSkinMC():void
		{
			super.updateSkinMC();

			if (skinMC)
			{
				var i:int=skinMC.currentLabels.length;

				while (i)
				{
					--i;

					if (skinMC.currentLabels[i].name)
					{
						_reverseStateHash[skinMC.currentLabels[i].frame]=skinMC.currentLabels[i].name;
					}
				}
			}
		}

		protected function animateFrom($label:String):void
		{
			skinMC.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			skinMC.gotoAndPlay($label);
		}

		protected function isReverseFrame($frame:int):Boolean
		{
			return $frame > skinMC.totalFrames || _reverseStateHash.hasOwnProperty($frame);
		}

		private function enterFrameHandler(e:Event):void
		{
			if (skinMC.currentFrameLabel == currentState || isReverseFrame(skinMC.currentFrame + 1))
			{
				skinMC.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				super.onStateChanged();
				_currentAnimation=null;
			}
		}

		public function get currentAnimation():String
		{
			return _currentAnimation;
		}
	}
}
