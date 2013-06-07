package ru.nacid.base.view.component.button.enum
{

	public class ButtonState
	{
		//Base states
		public static const UP:String='Up';
		public static const OVER:String='Over';
		public static const DOWN:String='Down';
		//Simple states
		public static const DISABLED:String='Disabled';
		//Simple animate states
		//not necessary there. Just prevState.concat(currentState)
		public static const UP_OVER:String='UpOver';
		public static const OVER_UP:String='OverUp';
		public static const OVER_DOWN:String='OverDown';
		public static const DOWN_UP:String='DownUp';
		public static const DOWN_OVER:String='DownOver';
	}
}
