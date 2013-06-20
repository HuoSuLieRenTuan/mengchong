/***
RecordPane
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月20日 13:31:20
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import assets.RecordPane;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	import zero.utils.getTime;
	
	public class RecordPane extends BasePage{
		public var clip:assets.RecordPane;
		public function RecordPane(_clip:assets.RecordPane){
			super(_clip);
			clip.bg.mouseEnabled=true;
			clip.addEventListener(MouseEvent.CLICK,click);
			clip.txt.mouseEnabled=true;
			clip.txt.styleSheet=new StyleSheet();
			clip.txt.styleSheet.parseCSS(
				'a:link {color: #00FFFF;text-decoration: none;}\n'+
				'a:visited {text-decoration: none;color: #FF99FF;}\n'+
				'a:hover {text-decoration: underline;color: #FF0000;}\n'+
				'a:active {text-decoration: none;color: #00CCFF;}\n'
			);
			clip.txt.addEventListener(TextEvent.LINK,link);
		}
		override public function clear():void{
			clip.txt.removeEventListener(TextEvent.LINK,link);
			clip.removeEventListener(MouseEvent.CLICK,click);
			super.clear();
		}
		private function click(event:MouseEvent):void{
			switch(event.target){
				case clip.btnX:
					clip.dispatchEvent(new GameEvent(GameEvent.HIDE_RECORD_PANE,false,false,null));
				break;
			}
		}
		public function show():void{
			clip.visible=true;
			var settingXML:XML=sol.getSettingXML("当前");
			if(settingXML){
				var output:String="";
				var i:int=-1;
				for each(var childXML:XML in settingXML.children()){
					var execResult:Array=/^record_(\d+)_(\d+)$/.exec(childXML.name().toString());
					if(execResult){
						i++;
						var date:Date=new Date(Number(execResult[1]));
						output+='<a href="event:'+childXML.name().toString()+'">'+(i+1)+". "+getTime(null,date)+"</a>\n";
					}
				}
				if(output){
					clip.txt.htmlText=output;
					return;
				}
			}
			clip.txt.text="没有录像数据。";
		}
		public function hide():void{
			clip.visible=false;
		}
		private function link(event:TextEvent):void{
			clip.dispatchEvent(new GameEvent(GameEvent.PLAY_RECORD,false,false,event.text));
		}
	}
}