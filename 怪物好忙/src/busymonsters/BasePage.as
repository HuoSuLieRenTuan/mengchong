/***
BasePage
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 11:43:04
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
	
	public class BasePage{
		
		public function BasePage(_clip:Sprite){
			this["clip"]=_clip;
			
			var i:int=this["clip"].numChildren;
			while(--i>=0){
				var child:DisplayObject=this["clip"].getChildAt(i);
				if(child.hasOwnProperty("mouseEnabled")){
					child["mouseEnabled"]=false;
				}
				if(child.hasOwnProperty("mouseChildren")){
					child["mouseChildren"]=false;
				}
				if(child.name.indexOf("btn")==0){
					child["mouseEnabled"]=true;
					child["buttonMode"]=true;
					child["align"]="rb";
					child["x0"]=child.x;
					child["y0"]=child.y;
				}
			}
			
		}
		public function clear():void{
			this["clip"]=null;
		}
		
		public function resize(wid0:int,hei0:int,wid:int,hei:int):void{
			var i:int=this["clip"].numChildren;
			while(--i>=0){
				var child:DisplayObject=this["clip"].getChildAt(i);
				if(child.hasOwnProperty("align")){
					if(child["align"].indexOf("r")>-1){
						child.x=wid-(wid0-child["x0"]);
					}
					if(child["align"].indexOf("b")>-1){
						child.y=hei-(hei0-child["y0"]);
					}
				}
			}
		}
	}
}