package ru.nacid.base.view.component.text.interfaces
{
	import ru.nacid.base.view.component.text.enum.LabelFormat;

	public interface ILabel
	{
		function getFormat():LabelFormat;
		function setFormat($format:LabelFormat):void;

		function set text(value:String):void;
		function get text():String;

		function get width():Number;
		function get height():Number;
	}
}
