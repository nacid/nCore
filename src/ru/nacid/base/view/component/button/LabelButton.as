package ru.nacid.base.view.component.button
{
	import flash.display.DisplayObject;

	import ru.nacid.base.view.component.text.Label;
	import ru.nacid.base.view.component.text.enum.LabelFormat;
	import ru.nacid.base.view.component.text.interfaces.ILabel;

	public class LabelButton extends AnimatedButton implements ILabel
	{
		private var _label:ILabel;

		public function LabelButton($skin:String, $text:String=null, $format:LabelFormat=null)
		{
			super($skin);
			defaultContent($format);

			if ($text)
			{
				text=$text;
			}
		}

		override public function set content(value:DisplayObject):void
		{
			if (value is ILabel)
			{
				_label=ILabel(value);
				super.content=value;
			}
			else
			{
				throw new TypeError('content must implement ILabel interface');
			}
		}

		protected function defaultContent($format:LabelFormat):void
		{
			content=new Label($format);
		}

		// interface -------------

		public function getFormat():LabelFormat
		{
			return _label.getFormat();
		}

		public function setFormat($format:LabelFormat):void
		{
			_label.setFormat($format);
		}

		public function set text(value:String):void
		{
			_label.text=value;
		}

		public function get text():String
		{
			return _label.text;
		}
	}
}
