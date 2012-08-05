package 
{
	import ru.nacid.base.Initializer;
	import ru.nacid.base.view.ViewObject;

	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */

	public class Main extends ViewObject 
	{

		[Embed(source = "../assets/config.json", mimeType = "application/octet-stream")]
		private var config:Class;

		override protected function show():void 
		{
			new Initializer(this, new config).execute();
		}

	}

}