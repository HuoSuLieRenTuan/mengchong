/***
Xiaochu
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月13日 14:04:37
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class Xiaochu{
		
		private static const xiaochuV:Vector.<Xiaochu>=new Vector.<Xiaochu>();
		
		public static function clear():void{
			for each(var xiaochu:Xiaochu in xiaochuV){
				xiaochu.clear();
			}
			xiaochuV.length=0;
		}
		
		public static function add(tileArr:Array,xyArr:Array,onComplete:Function):Xiaochu{
			
			var xiaochu:Xiaochu=new Xiaochu();
			xiaochu.num=tileArr.length;
			xiaochu.onComplete=onComplete;
			xiaochu.tileArr=tileArr;
			xiaochu.xyArr=xyArr;
			
			for each(var tile:Tile in tileArr){
				TweenMax.to(tile,8,{scaleX:0.2,scaleY:0.2,alpha:0,ease:Back.easeIn,useFrames:true,onComplete:xiaochu.complete});
			}
			
			xiaochuV.push(xiaochu);
			return xiaochu;
			
		}
		private static function complete(xiaochu:Xiaochu):void{
			
			var onComplete:Function=xiaochu.onComplete;
			var tileArr:Array=xiaochu.tileArr;
			var xyArr:Array=xiaochu.xyArr;
			
			xiaochu.clear();
			
			xiaochuV.splice(xiaochuV.indexOf(xiaochu),1);
			
			if(onComplete==null){
			}else{
				onComplete(tileArr,xyArr);
			}
			
		}
		
		private var num:int;
		private var onComplete:Function;
		private var tileArr:Array;
		private var xyArr:Array;
		private function complete():void{
			if(--num<=0){
				Xiaochu.complete(this);
			}
		}
		private function clear():void{
			onComplete=null;
			tileArr=null;
			xyArr=null;
		}
	}
}