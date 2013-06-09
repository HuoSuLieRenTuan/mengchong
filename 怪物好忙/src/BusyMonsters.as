/***
BusyMonsters
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 09:44:47
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package{
	import assets.Main;
	
	import busymonsters.BasePage;
	import busymonsters.GameEvent;
	import busymonsters.PageGame;
	import busymonsters.PageMenu;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;
	
	public class BusyMonsters extends Sprite{
		
		private var main:Main;
		
		private var currPage:BasePage;
		
		private var wid0:int;
		private var hei0:int;
		
		private var outputTxt:TextField;
		
		public function BusyMonsters(){
			
			trace("需要教学系统（参考宝石迷阵和Candy Crush Saga）。");
			//trace("Tile不要用跳帧的形式换图。");
			
			this.addEventListener(Event.ENTER_FRAME,enterFrame);
		}
		
		private function enterFrame(...args):void{
			
			this.removeEventListener(Event.ENTER_FRAME,enterFrame);
			
			outputMsg=_outputMsg;
			
			outputMsg("0.0.001");
			
			this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,uncaughtError);
			
			if(stage){
				added();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE,added);
			}
			
		}
		private function uncaughtError(event:UncaughtErrorEvent):void{
			outputMsg(event.error);
		}
		private function _outputMsg(msg:String,...args):void{
			//trace("msg="+msg);
			if(outputTxt){
			}else{
				outputTxt=new TextField();
				this.addChild(outputTxt);
				outputTxt.x=10;
				outputTxt.y=150;
				outputTxt.textColor=0xff0000;
				outputTxt.border=true;
				outputTxt.background=true;
				outputTxt.text="";
				outputTxt.autoSize=TextFieldAutoSize.LEFT;
			}
			outputTxt.appendText(msg+"\n");
		}
		private function added(...args):void{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			this.addChildAt(main=new Main(),0);
			
			/*//不是很准确地区分PC和移动设备
			if(Capabilities.screenDPI>72){
				//移动设备
				main.scaleX=main.scaleY=Capabilities.screenDPI/96;
			}//else{
			//	PC
			//}*/
			
			//不是很准确地区分PC和移动设备
			if(Capabilities.playerType=="Desktop"){
				//移动设备
				main.scaleX=main.scaleY=Capabilities.screenDPI/96;
			}
			
			this.tabChildren=false;
			var i:int=main.numChildren;
			while(--i>=0){
				var child:DisplayObject=main.getChildAt(i);
				if(child.hasOwnProperty("mouseEnabled")){
					child["mouseEnabled"]=false;
				}
				if(child.hasOwnProperty("mouseChildren")){
					child["mouseChildren"]=false;
				}
			}
			
			main.container.mouseChildren=true;
			
			wid0=main.bg.width;
			hei0=main.bg.height;
			
			stage.addEventListener(Event.RESIZE,resize);
			
			addPage(new PageMenu());
			currPage["clip"].addEventListener(GameEvent.START_GAME,startGame);
			
			startGame();
			
			outputMsg(stage.stageWidth+"x"+stage.stageHeight+"，Capabilities.screenDPI="+Capabilities.screenDPI+"，main.transform.matrix="+main.transform.matrix);
			outputMsg("Capabilities.playerType="+Capabilities.playerType);
			
		}
		
		private function startGame(...args):void{
			currPage["clip"].removeEventListener(GameEvent.START_GAME,startGame);
			removeCurrPage();
			addPage(new PageGame());
		}
		
		private function resize(...args):void{
			
			var wid:int=Math.ceil(stage.stageWidth/main.scaleX);
			var hei:int=Math.ceil(stage.stageHeight/main.scaleY);
			outputMsg("wid="+wid+"，hei="+hei);
			
			main.bg.width=wid;
			main.bg.height=hei;
			
			currPage.resize(wid0,hei0,wid,hei);
			
		}
		
		private function addPage(page:BasePage):void{
			
			if(currPage){
				throw new Error("请先 removeCurrPage()");
			}
			
			currPage=page;
			main.container.addChild(currPage["clip"]);
			
			resize();
			
		}
		private function removeCurrPage():void{
			if(currPage){
				var clip:Sprite=currPage["clip"];
				currPage.clear();
				currPage=null;
				main.container.removeChild(clip);
			}else{
				throw new Error("请先 removeCurrPage()");
			}
		}
	}
}