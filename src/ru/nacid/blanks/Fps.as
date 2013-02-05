package ru.nacid.blanks
{
	import flash.display.DisplayObjectContainer;

	import mx.core.UIComponent;

	import ru.nacid.base.data.Global;
	import ru.nacid.base.services.Command;
	import ru.nacid.utils.debug.Stats;

	import spark.components.SkinnableContainer;

	public class Fps extends Command
	{
		public static const COMMAND_LINE:String='fps';

		private static var _enabled:Boolean;
		private static var _stats:UIComponent;
		private static var _container:SkinnableContainer;

		public function Fps($container:SkinnableContainer)
		{
			if (_container == null)
			{
				_container=$container;
			}

			symbol='statsBlock';
		}

		override protected function execInternal():void
		{

			if (_stats == null)
			{
				_stats=new UIComponent;
				_stats.addChild(new Stats);
			}


			if (!_enabled)
			{
				_container.addElement(_stats);
				_enabled=true;
			}
			else
			{
				_container.removeElement(_stats);
				_enabled=false;
			}

			notifyComplete();
		}
	}
}
