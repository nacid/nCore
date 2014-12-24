package ru.nacid.base.services.skins.commands
{
	import ru.nacid.base.data.managment.VOIterator;
	import ru.nacid.base.services.Command;
	import ru.nacid.base.services.CommandQueue;
	import ru.nacid.base.services.skins.Sm;

	public class LoadEmbed extends CommandQueue
	{

		public function LoadEmbed()
		{
			symbol='LoadEmbedSkins';
			priority=HIGH_PRIORITY;
		}

		override protected function execInternal():void
		{
			var iterator:VOIterator=Sm.instance.getEmbeds();
			while (iterator.hasNext())
			{
				var loader:Command=iterator.next() as Command;

				if (!loader.completed)
				{
					addCommand(loader);
				}
			}

			super.execInternal();
		}


		override public function get description():String {
			return 'loading interface skins';
		}
	}

}
