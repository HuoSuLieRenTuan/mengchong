/***
Tile
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 15:34:55
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import assets.Tile;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class Tile{
		
		public var clip:assets.Tile;
		
		public function Tile(){
			clip=new assets.Tile();
			clip.buttonMode=true;
			clip.stop();
		}
		
		private var __color:int;
		public function get color():int{
			return __color;
		}
		public function set color(_color:int):void{
			__color=_color;
			clip.gotoAndStop((__color-1)*3+2);
		}
		
	}
}