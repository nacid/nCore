package ru.nacid.base.view.component.text.enum
{
	import flash.filters.BitmapFilter;
	import flash.text.TextFormat;

	import ru.nacid.base.data.interfaces.IData;

	public class LabelFormat extends TextFormat implements IData
	{
		private var _filters:Vector.<BitmapFilter>
		private var _symbol:String;
		private var _embed:Boolean;

		public function LabelFormat($name:String, $embed:Boolean=true, $font:String=null, $size:Object=null, $color:Object=null, $bold:Object=null, $italic:Object=null, $align:String=null, $filters:Array=null, $underline:Object=null, $url:String=null, $target:String=null, $leftMargin:Object=null, $rightMargin:Object=null, $indent:Object=null, $leading:Object=null)
		{
			super($font, $size, $color, $bold, $italic, $underline, $url, $target, $align, $leftMargin, $rightMargin, $indent, $leading);

			_embed=$embed;
			_filters=Vector.<BitmapFilter>([]);
			_symbol=$name;

			if ($filters)
			{
				for (var i:int=0; i < $filters.length; i++)
				{
					if ($filters[i] is BitmapFilter)
					{
						_filters.push($filters[i]);
					}
				}
			}

			_filters.fixed=true;
		}

		public function get embed():Boolean
		{
			return _embed;
		}

		public function set embed(value:Boolean):void
		{
			_embed=value;
		}

		public function get filters():Array
		{
			var response:Array=[];

			for (var i:int=0; i < _filters.length; i++)
			{
				response.push(_filters[i].clone());
			}

			return response;
		}

		public function get symbol():String
		{
			return _symbol;
		}

		public function valueOf():Number
		{
			return 0;
		}
	}
}
