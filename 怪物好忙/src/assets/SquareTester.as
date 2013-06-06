/***
SquareTester
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 21:43:22
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class SquareTester extends Sprite{
		
		private var timeoutId:int;
		
		public var bg:Sprite;
		
		public function SquareTester(){
			this.visible=false;
			timeoutId=setTimeout(showThis,100);
		}
		private function showThis():void{
			
			clearTimeout(timeoutId);
			
			//仅供测试用，不是很准确
			if(Capabilities.screenDPI==72&&Capabilities.os.indexOf("Windows ")==0){
			}else{
				this.scaleX=this.scaleY=Capabilities.screenDPI/96/this.transform.concatenatedMatrix.a;
			}
			this.visible=true;
			var b:Rectangle=bg.getBounds(stage);
			trace("Capabilities.screenDPI="+Capabilities.screenDPI,"b.width="+b.width,Capabilities.screenDPI==b.width);
			//pc：Capabilities.screenDPI=72 b.width=96 false（PC貌似获取不到正确值，右键桌面空白处，属性/设置/高级/常规 看DPI设置可能是96，获取到的却是72）
			//iPad：Capabilities.screenDPI=132 b.width=132 true
			//iPhone 3GS：Capabilities.screenDPI=163 b.width=163 true
			//iPhone 4：Capabilities.screenDPI=326 b.width=326 true
		}
	}
}