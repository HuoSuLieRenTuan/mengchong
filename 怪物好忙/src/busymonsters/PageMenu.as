/***
PageMenu
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 10:58:22
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import assets.PageMenu;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class PageMenu extends BasePage{
		
		public var clip:assets.PageMenu;
		
		public function PageMenu(){
			super(new assets.PageMenu());
			clip.addEventListener(MouseEvent.CLICK,click);
		}
		override public function clear():void{
			clip.removeEventListener(MouseEvent.CLICK,click);
			super.clear();
		}
		private function click(event:MouseEvent):void{
			switch(event.target){
				case clip.btnPlayRecords:
					clip.dispatchEvent(new GameEvent(GameEvent.SHOW_RECORD_PANE,true,false,null));
				break;
				case clip.btnStart:
					clip.dispatchEvent(new GameEvent(GameEvent.START_GAME,false,false,null));
				break;
			}
		}
	}
}