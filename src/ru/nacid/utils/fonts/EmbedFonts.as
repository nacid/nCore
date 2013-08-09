package ru.nacid.utils.fonts
{
	import flash.text.Font;
	
	import ru.nacid.base.services.Command;

	public class EmbedFonts extends Command
	{
		protected var list:Vector.<Class>;

		public function EmbedFonts(... rest)
		{
			symbol='registerEmbedFonts';
			list=Vector.<Class>([]);
			addToList(rest);
		}

		protected function addToList($data:Object):void
		{
			if ($data is Object)
			{
				for each (var add:Class in $data)
				{
					if (list.indexOf(add) < 0)
					{
						list.push(add);
					}
				}
			}
		}

		override protected function execInternal():void
		{
			addToList(exeData);
/*
			var len:int=list.length;
			while (len)
			{
				registerFont(list[--len]);
			}*/
			
			info(list.length.toString().concat(' fonts has been added:',Font.enumerateFonts().toString()));
			var s:Array = Font.enumerateFonts()

			notifyComplete();
		}

		protected function registerFont($cl:Class):void
		{
			Font.registerFont($cl);
		}
	}
}
