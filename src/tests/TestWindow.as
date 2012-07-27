package tests 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import ru.nacid.base.services.windows.interfaces.IWindowStorage;
	import ru.nacid.base.services.windows.Window;
	import ru.nacid.base.services.windows.WindowParam;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class TestWindow extends Window 
	{
		private var shape:Sprite;
		private var label:TextField;
		
		public function TestWindow($param:WindowParam) 
		{
			super($param);
			
			info(id.concat(' created'));
		}
		
		override protected function init():void 
		{
			super.init();
			
			shape = new Sprite();
			shape.graphics.beginFill(Math.random() * 255, 1);
			shape.graphics.lineStyle(2);
			shape.graphics.drawRect(0, 0, 400, 400);
			
			shape.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			shape.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			/*shape.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				model.navigator.closeWindow(id);
			})*/
			
			label = new TextField();
			label.textColor = 0xFFFFFF;
			label.selectable = false;
			label.mouseEnabled = false;
			
			addChild(shape);
			addChild(label);
		}
		
		private function mouseHandler(e:MouseEvent):void {
			if (e.type == MouseEvent.MOUSE_DOWN)
				startDrag();
			else
				stopDrag();
		}
		
		override protected function show():void 
		{
			x = showData.x;
			y = showData.y;
			label.text = id;
		}
		
	}

}