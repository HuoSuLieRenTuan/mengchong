/***
Tile
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 15:34:55
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	
	import assets.Tile;
	
	import com.greensock.TweenMax;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class Tile extends Sprite{
		
		private var clip:assets.Tile;
		
		public var color:int;
		public var speed:int;
		
		public var x0:int;
		public var y0:int;
		
		public function Tile(_color:int,_falling:Boolean){
			this.buttonMode=true;
			this.mouseChildren=false;
			color=_color;
			if(color>-1){
				this.addChild(clip=getTileClip(color));
			}
			locked=false;
			falling=_falling;
		}
		
		private var __selected:Boolean;
		public function get selected():Boolean{
			return __selected;
		}
		public function set selected(_selected:Boolean):void{
			__selected=_selected;
			if(__selected){
				TweenMax.to(clip,8,{scaleX:1.1,scaleY:1.1,colorMatrixFilter:{saturation:1.3},useFrames:true});
			}else{
				TweenMax.to(clip,8,{scaleX:1,scaleY:1,colorMatrixFilter:{saturation:1},useFrames:true});
			}
		}
		
		//正在交换或正在消除
		private var __locked:Boolean;
		public function get locked():Boolean{
			return __locked;
		}
		public function set locked(_locked:Boolean):void{
			__locked=_locked;
			this.mouseEnabled=__enabled=!(__locked||__falling);
		}
		
		//正在下落
		private var __falling:Boolean;
		public function get falling():Boolean{
			return __falling;
		}
		public function set falling(_falling:Boolean):void{
			__falling=_falling;
			this.mouseEnabled=__enabled=!(__locked||__falling);
		}
		
		private var __enabled:Boolean;
		public function get enabled():Boolean{
			return __enabled;
		}
		
	}
}