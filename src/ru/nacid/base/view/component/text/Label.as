package ru.nacid.base.view.component.text
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import ru.nacid.base.view.component.text.enum.LabelFormat;
	
	public class Label extends TextField
	{
		private var _format:LabelFormat;
		
		public function Label($format:LabelFormat,$autoSize:String = TextFieldAutoSize.LEFT)
		{
			embedFonts = true;
			autoSize = $autoSize;
			setFormat($format);
			selectable = false;
			mouseEnabled = false;
		}
		
		public function getFormat():LabelFormat{
			return _format;
		}
		
		public function setFormat($format:LabelFormat):void{
			if(_format!=$format){
				_format = $format;
				
				setTextFormat(defaultTextFormat = _format);
				filters = _format.filters;
			}
		}
	}
}