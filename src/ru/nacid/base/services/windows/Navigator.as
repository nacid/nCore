package ru.nacid.base.services.windows 
{
	import com.junkbyte.console.Cc;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import ru.nacid.base.data.managment.VOManager;
	import ru.nacid.base.data.store.VOList;
	import ru.nacid.base.services.windows.events.WindowPolicyEvent;
	import ru.nacid.base.services.windows.interfaces.IWindowStorage;
	/**
	 * ...
	 * @author Nikolay nacid Bondarev
	 */
	public class Navigator extends VOManager
	{
		private static var _instance:Navigator;
		static public function get instance():Navigator 
		{
			return _instance;
		}
		
		private var container	:DisplayObjectContainer;
		private var windows		:VOList = new VOList();
		
		public var topOnFocus	:Boolean;
		public var focusOnTop	:Boolean = true;
		
		public function Navigator($container:DisplayObjectContainer, $topOnFocus:Boolean = false, $focusOnTop:Boolean = true) {
			
			if (!instance) {
				init($container, $topOnFocus, $focusOnTop);
			}else {
				warning('duplicate Navigator constructor call');
			}
		}
		
		protected function init($container:DisplayObjectContainer, $topOnFocus:Boolean = false, $focusOnTop:Boolean = true):void {
			_instance = this;
			container = $container;
			log('navigator created');
		}
		
		public function regWindow($param:IWindowStorage):void {
			if (list.add($param)) {
				$param.policy.addEventListener(WindowPolicyEvent.OPEN_WINDOW, policyOpenHandler);
				$param.policy.addEventListener(WindowPolicyEvent.CLOSE_WINDOW, policyCloseHandler);
				
				Cc.infoch(MANAGER_CHANNEL, 'window', $param.id, 'added');
			}else {
				Cc.warnch(MANAGER_CHANNEL, 'window with id', $param.id, 'cannot be added');
			}
		}
		
		private function policyOpenHandler(e:WindowPolicyEvent):void {
			if (e.displayIndex < 0)
				return Cc.warnch(MANAGER_CHANNEL, 'window', e.targetWindow, 'is not open');
			
			var window:Window = createWindow(list.atId(e.targetWindow) as IWindowStorage);
			window.setData(e.openData);
			windows.add(window);
			
			activeList.push(e.targetWindow);
			container.addChildAt(window, e.displayIndex);
			
			window.addEventListener(FocusEvent.FOCUS_IN, focusHandler);
			window.addEventListener(MouseEvent.MOUSE_DOWN, focusHandler);
			
			if (focusOnTop)
				container.stage.focus = window;
			
			Cc.logch(MANAGER_CHANNEL, 'window', e.targetWindow, 'opened');
		}
		
		private function policyCloseHandler(e:WindowPolicyEvent):void {
			var target:Window = windows.removeAtId(e.targetWindow) as Window;
			deactivate(e.targetWindow);
			container.removeChild(target);
			
			target.removeEventListener(FocusEvent.FOCUS_IN, focusHandler);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, focusHandler);
			
			Cc.logch(MANAGER_CHANNEL, 'window', e.targetWindow, 'closed');
		}
		
		public function showWindow($id:String, $data:Object = null):void {
			var param:IWindowStorage = list.atId($id) as IWindowStorage;
			if (param == null)
				return Cc.errorch(MANAGER_CHANNEL, 'windows with id', $id, 'is not registered');
			
			if (isActive($id))
				return Cc.errorch(MANAGER_CHANNEL, 'windows with id', $id, 'already active');
				
			param.policy.applyOpen(activeList, $id, $data);
		}
		
		public function closeWindow($id:String,$force:Boolean = false):void {
			if (isActive($id)) {
				var param:IWindowStorage = list.atId($id) as IWindowStorage;
				param.policy.applyClose(activeList, $id, $force);
			}else {
				Cc.warnch(MANAGER_CHANNEL, 'window', $id, 'is not opened');
			}
		}
		
		public function closeAll():void {
			while (activeList.length)
				closeWindow(activeList[0], true);
		}
		
		public function makeTop($id:String):void {
			if (isActive($id)) {
				deactivate($id);
				container.setChildIndex(windows.atId($id) as Window, activeList.length);
				activate($id);
				
				Cc.infoch(MANAGER_CHANNEL, 'move window', $id, 'on top');
			}else {
				Cc.infoch(MANAGER_CHANNEL, 'can not move', $id, 'up because it closed');
			}
		}
		
		private function focusHandler(e:Event):void {
			if (topOnFocus) {
				makeTop(e.currentTarget.id);
			}
			e.currentTarget.onFocus();
		}
		
		public function get inited():Boolean {
			return container is DisplayObjectContainer;
		}
		
		private function createWindow($params:IWindowStorage):Window {
			if ($params is Window) return $params as Window;
			
			var response:Window = new $params.render($params);
			if (response.cached) list.setAtId($params.id, response);
			
			return response;
		}
	}

}