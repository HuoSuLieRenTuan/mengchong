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
		
		private static const TileClassV:Vector.<Class>=new <Class>[assets.Tile_0_0,assets.Tile_1_0,assets.Tile_2_0,assets.Tile_3_0,assets.Tile_4_0,assets.Tile_5_0];
		
		private var clip:assets.Tile;
		
		public var locked:Boolean;
		public var color:int;
		
		public function Tile(_color:int){
			this.buttonMode=true;
			this.mouseChildren=false;
			color=_color;
			if(color>-1){
				this.addChild(clip=new (TileClassV[color])());
			}
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
		
	}
}