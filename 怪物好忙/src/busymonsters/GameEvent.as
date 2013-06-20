/***
GameEvent
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 13:38:11
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class GameEvent extends Event{
		
		public static const SHOW_RECORD_PANE:String="显示录像面板";
		public static const HIDE_RECORD_PANE:String="隐藏录像面板";
		public static const START_GAME:String="开始游戏";
		public static const BACK_TO_MENU:String="返回菜单";
		public static const PLAY_RECORD:String="播放录像";
		
		public var data:*;
		
		public function GameEvent(type:String,bubbles:Boolean,cancelable:Boolean,_data:*){
			super(type,bubbles,cancelable);
			data=_data;
		}
		
	}
}