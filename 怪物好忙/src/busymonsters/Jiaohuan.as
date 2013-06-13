/***
Jiaohuan
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月09日 14:48:22
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import com.greensock.TweenMax;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class Jiaohuan{
		
		private static const jiaohuanV:Vector.<Jiaohuan>=new Vector.<Jiaohuan>();
		
		public static function clear():void{
			for each(var jiaohuan:Jiaohuan in jiaohuanV){
				jiaohuan.clear();
			}
			jiaohuanV.length=0;
		}
		
		public static function add(tile1:Tile,tile2:Tile,x1:int,y1:int,x2:int,y2:int,needBack:Boolean,onComplete:Function):Jiaohuan{
			
			var jiaohuan:Jiaohuan=new Jiaohuan();
			jiaohuan.num=2;
			jiaohuan.onComplete=onComplete;
			jiaohuan.tile1=tile1;
			jiaohuan.tile2=tile2;
			jiaohuan.needBack=needBack;
			
			TweenMax.to(tile1,8,{x:x2,y:y2,useFrames:true,onComplete:jiaohuan.complete});
			TweenMax.to(tile2,8,{x:x1,y:y1,useFrames:true,onComplete:jiaohuan.complete});
			
			jiaohuanV.push(jiaohuan);
			return jiaohuan;
			
		}
		private static function complete(jiaohuan:Jiaohuan):void{
			
			var onComplete:Function=jiaohuan.onComplete;
			var tile1:Tile=jiaohuan.tile1;
			var tile2:Tile=jiaohuan.tile2;
			var needBack:Boolean=jiaohuan.needBack;
			
			jiaohuan.clear();
			
			jiaohuanV.splice(jiaohuanV.indexOf(jiaohuan),1);
			
			if(onComplete==null){
			}else{
				onComplete(tile1,tile2,needBack);
			}
			
		}
		
		private var num:int;
		private var onComplete:Function;
		private var tile1:Tile;
		private var tile2:Tile;
		private var needBack:Boolean;
		private function complete():void{
			if(--num<=0){
				Jiaohuan.complete(this);
			}
		}
		private function clear():void{
			onComplete=null;
			tile1=null;
			tile2=null;
			TweenMax.killTweensOf(tile1);
			TweenMax.killTweensOf(tile2);
		}
		
	}
}