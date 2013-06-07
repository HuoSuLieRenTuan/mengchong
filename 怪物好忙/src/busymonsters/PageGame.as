/***
PageGame
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 10:57:25
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import assets.PageGame;
	import assets.Tile;
	
	import com.greensock.TweenMax;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class PageGame extends BasePage{
		
		private var map:Array;
		
		public function PageGame(){
			
			super(new assets.PageGame());
			
			var w:int=10;
			var h:int=10;
			var d:int=50;
			map=new Array(h);
			for(var y:int=0;y<h;y++){
				map[y]=new Array();
				for(var x:int=0;x<w;x++){
					var tile:busymonsters.Tile=new busymonsters.Tile();
					clip["tileArea"].addChild(tile.clip);
					map[y][x]=tile;
					tile.color=int(Math.random()*6)+1;
					tile.clip.x=x*d;
					tile.clip.y=y*d;
				}
			}
			
			clip["tileArea"].mouseChildren=true;
			clip["tileArea"].addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			clip["tileArea"].addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			clip["tileArea"].addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			
		}
		
		private function mouseOver(event:MouseEvent):void{
			var clip:assets.Tile=event.target as assets.Tile;
			if(clip){
				TweenMax.to(clip,8,{scaleX:1.05,scaleY:1.05,colorMatrixFilter:{saturation:1},useFrames:true});
			}
		}
		private function mouseOut(event:MouseEvent):void{
			var clip:assets.Tile=event.target as assets.Tile;
			if(clip){
				TweenMax.to(clip,8,{scaleX:1,scaleY:1,colorMatrixFilter:{saturation:0},useFrames:true});
			}
			
		}
		private function mouseDown(event:MouseEvent):void{
			
		}
		
	}
}