package ru.nacid.base.view.component.text
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import ru.nacid.base.view.component.text.enum.LabelFormat;
	import ru.nacid.base.view.component.text.interfaces.ILabel;

	public class Label extends TextField implements ILabel
	{
		protected const DEFAULT_FORMAT:LabelFormat=new LabelFormat('defaultLabelFormat', false, 'Arial', 16, 0xFFFFFF);

		private var _format:LabelFormat;
		private var _originText:String;

		public function Label($format:LabelFormat=null, $autoSize:String=TextFieldAutoSize.LEFT)
		{
			autoSize=$autoSize;
			setFormat($format || DEFAULT_FORMAT);
			selectable=false;
			mouseEnabled=false;
		}

		public function getFormat():LabelFormat
		{
			return _format;
		}

		public function setFormat($format:LabelFormat):void
		{
			if (_format != $format)
			{
				_format=$format;

				embedFonts=$format.embed;
				filters=_format.filters;
				setTextFormat(defaultTextFormat=_format);
			}
		}

		public function cutToWidth($w:int):void
		{
			var tmp:String = text = _originText;

			while(width > $w && text.length > 3)
				text = text.substring(0,text.length - 4).concat('...');

			_originText = tmp;
		}

		override public function set text(value:String):void {
			super.text = _originText = value || '';
		}
	}
}
