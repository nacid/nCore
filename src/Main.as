package 
{
	import ru.nacid.base.Initializer;
	import ru.nacid.base.view.ViewObject;
	import ru.nacid.utils.debug.JSONtoAMF;

	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */

	public class Main extends ViewObject 
	{

		[Embed(source = "../assets/debug/config.json", mimeType = "application/octet-stream")]
		private var startup:Class;

		override protected function show():void 
		{
			new Initializer(this, JSONtoAMF.bytes(new startup)).execute();
		}

	}

}