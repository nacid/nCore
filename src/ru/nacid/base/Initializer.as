package ru.nacid.base 
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.system.Capabilities;
	import ru.nacid.base.data.Global;
	import ru.nacid.base.services.CommandEvent;
	import ru.nacid.base.services.CommandQueue;
	import ru.nacid.base.services.localization.commands.LoadLocaleMap;
	import ru.nacid.base.services.localization.LocaleManager;
	import ru.nacid.base.services.logs.CCInit;
	import ru.nacid.base.services.skins.commands.SwfSkinLoader;
	import ru.nacid.base.services.windows.Navigator;
	import ru.nacid.base.view.data.Position;
	import ru.nacid.base.view.SimpleViewObject;
	import ru.nacid.utils.encoders.data.Amf;
	
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class Initializer extends CommandQueue 
	{
		private var main:Sprite;
		private var appLayer:SimpleViewObject;
		private var sysLayer:SimpleViewObject;
		
		private var preloaderSkinLoader:SwfSkinLoader;
		private var preloaderSkin:Object;
		
		protected var progressIndicator:DisplayObject;
		protected var stagePosition:Position;
		protected var data:Object;
		
		public function Initializer($mainObject:Sprite, $settings:*) 
		{
			id = "Initializer";
			
			data = readSettings($settings);
			main = $mainObject;
		}
		
		override protected function execInternal():void 
		{
			if (main.stage == null) {
				error('main object must have stage!');
				return onError();
			}
			appLayer = new SimpleViewObject;
			sysLayer = new SimpleViewObject;
			stagePosition = new Position(main.x, main.y, main.stage.stageWidth, main.stage.stageHeight);
			
			Global.appName = CONFIG::APP_NAME;
			Global.release = !(CONFIG::debug);
			Global.debugger = Capabilities.isDebugger;
			Global.language = Capabilities.language;
			Global.stageW = stagePosition.width;
			Global.stageH = stagePosition.height;
			
			createView();
			
			if (progressIndicator)
				appLayer.addChild(progressIndicator);
			
			main.addChild(appLayer);
			main.addChild(sysLayer);
			
			preInit();
			collectInitQueue();
			
			preloaderSkinLoader = new SwfSkinLoader(data.preloader);
			preloaderSkinLoader.id = 'loadPreloader';
			preloaderSkinLoader.priority = HIGH_PRIORITY;
			preloaderSkinLoader.addEventListener(CommandEvent.COMPLETE, addProloaderSkin);
			addCommand(preloaderSkinLoader);
			
			super.execInternal();
		}
		
		private function addProloaderSkin(e:CommandEvent):void {
			preloaderSkinLoader.removeEventListener(CommandEvent.COMPLETE, addProloaderSkin);
			preloaderSkin = preloaderSkinLoader.response;
			
			if (preloaderSkin is DisplayObject) {
				cls();
				appLayer.addChild(preloaderSkin as DisplayObject);
			}
			commitProgress(progress);
		}
		
		protected function cls():void {
			while (appLayer.numChildren)
				appLayer.removeChildAt(0);
		}
		
		//---------------------------------------------
		protected function readSettings($settings:*):Object {
			$settings.position = 0;
			return new Amf().decodeObject($settings);
		}
		
		protected function createView():void {
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(stagePosition.width, stagePosition.height);
			main.graphics.lineStyle(0);
			main.graphics.beginGradientFill(GradientType.RADIAL, [0x505050, 0x333333], [1, 1], [0, 255], gradientMatrix);
			main.graphics.drawRect(0, 0, stagePosition.width, stagePosition.height);
			
			progressIndicator = new DefaultProgress();
			progressIndicator.x = stagePosition.width >> 1;
			progressIndicator.y = stagePosition.height >> 1;
		}
		
		protected function preInit():void {
			new CCInit(sysLayer).execute(data[CCInit.DEFAULT_FIELD]);
			new Navigator(appLayer);
			new Model(data);
			new LocaleManager();
		}
		
		protected function collectInitQueue():void {
			//addCommand(new LoadLocaleMap(data['static'], true, 'ru'));
			addCommand(new LoadLocaleMap( { host:"../assets/debug/static.csv", params: { gid:'' }, langs: { ru:0 }}, true, 'ru'));
		}
		
		override protected function onComplete():void 
		{
			cls();
			notifyComplete();
		}
		
		override protected function commitProgress($progress:Number):void 
		{
			if (preloaderSkin) {
				if(LocaleManager.instance.activeMap){
					preloaderSkin.statusTF.text = LocaleManager.instance.getString('preprogress', { prsnt:Math.floor($progress * 100), cur:getCurrentID() } );
				}
				preloaderSkin.barMask.scaleX = $progress;
			}
		}
		
	}

}


import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

class DefaultProgress extends Sprite
{
	private var _color:uint;
	private var _minRadius:int;
	private var _segmentsCount:int;
	private var _segmentLength:int;
	private var _rotationSpeed:int;
	private var _timer:Timer;
	private var _playing:Boolean = false;
	
	public function DefaultProgress($pColor:uint = 0xF2F2F2, $minRadius:int = 10, $segmentLength:int = 10, $segmentsCount:int = 12, $rotationSpeed:int = 50)
	{
		super();
		
		_color = $pColor;
		_minRadius = $minRadius;
		_segmentLength = $segmentLength;
		_segmentsCount = $segmentsCount;
		_timer = new Timer($rotationSpeed);
		_timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
		
		addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		
		buildDisplay();
		play();
	}
	
	private function removeHandler(e:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		destroy();
	}
	
	private function get totalSize():uint
	{
		return 2 * (_minRadius + _segmentLength);
	}
	
	override public function get width():Number
	{
		return totalSize;
	}
	
	override public function get height():Number
	{
		return totalSize;
	}
	
	public function play():void
	{
		if (_playing || !_timer)
			return;
		_timer.start();
		_playing = true;
	}
	
	public function stop():void
	{
		if (!_playing || !_timer)
			return;
		_timer.stop();
		_playing = false;
	}
	
	public function destroy():void
	{
		_timer.stop();
		_timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
	}
	
	public function get color():uint
	{
		return _color;
	}
	
	public function set color($colorValue:uint):void
	{
		_color = $colorValue;
		while (numChildren)
		{
			removeChildAt(0);
		}
		buildDisplay();
	}
	
	public function get segmentLength():int
	{
		return _segmentLength;
	}
	
	public function set segmentLength($lengthValue:int):void
	{
		_segmentLength = $lengthValue;
		while (numChildren)
		{
			removeChildAt(0);
		}
		buildDisplay();
	}
	
	public function get segmentsCount():int
	{
		return _segmentsCount;
	}
	
	public function set segmentsCount($countValue:int):void
	{
		_segmentsCount = $countValue;
		if (_segmentsCount < 5)
			_segmentsCount = 5;
		while (numChildren)
		{
			removeChildAt(0);
		}
		buildDisplay();
	}
	
	public function get minRadius():int
	{
		return _minRadius;
	}
	
	public function set minRadius($radiusValue:int):void
	{
		_minRadius = $radiusValue;
		while (numChildren)
		{
			removeChildAt(0);
		}
		buildDisplay();
	}
	
	public function get speed():int
	{
		return _timer.delay;
	}
	
	public function set speed($speedValue:int):void
	{
		_timer.stop();
		_timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
		_timer = new Timer($speedValue);
		_timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
		if (_playing)
			_timer.start();
	}
	
	private function buildDisplay():void
	{
		for (var i:int = 0; i < _segmentsCount; i++)
		{
			var line:Shape = drawRoundedRect(_segmentLength, _segmentLength * 0.4, _segmentLength * 0.2, _color);
			line.x = _minRadius;
			line.y = -line.height / 2;
			var tempMc:Sprite = new Sprite();
			tempMc.addChild(line);
			tempMc.alpha = 0.3 + 0.7 * i / _segmentsCount;
			tempMc.rotation = 360 * i / _segmentsCount;
			addChild(tempMc);
		}
	}
	
	private function onTimerHandler(e:TimerEvent):void
	{
		rotation += 360 / _segmentsCount;
	}
	
	private function drawRoundedRect($w:Number, $h:Number, $bevel:Number = 0, $color:uint = 0x000000, $alpha:Number = 1):Shape
	{
		var mc:Shape = new Shape();
		mc.graphics.beginFill($color, $alpha);
		mc.graphics.moveTo($w - $bevel, $h);
		mc.graphics.curveTo($w, $h, $w, $h - $bevel);
		mc.graphics.lineTo($w, $bevel);
		mc.graphics.curveTo($w, 0, $w - $bevel, 0);
		mc.graphics.lineTo($bevel, 0);
		mc.graphics.curveTo(0, 0, 0, $bevel);
		mc.graphics.lineTo(0, $h - $bevel);
		mc.graphics.curveTo(0, $h, $bevel, $h);
		mc.graphics.lineTo($w - $bevel, $h);
		mc.graphics.endFill();
		return mc;
	}
}