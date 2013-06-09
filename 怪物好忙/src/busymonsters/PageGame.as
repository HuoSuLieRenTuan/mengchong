/***
PageGame
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 10:57:25
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import assets.PageGame;
	import assets.SelectedClip;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class PageGame extends BasePage{
		
		private var selectedClip:SelectedClip;
		private var isDownSelect:Boolean;
		private var selectedTile:Tile;
		
		private static const d:int=50;
		private var map:Array;
		private var w:int;
		private var h:int;
		
		private var oldMouseX:int;
		private var oldMouseY:int;
		
		public function PageGame(){
			
			super(new assets.PageGame());
			
			w=10;
			h=10;
			
			map=new Array(h);
			for(var y:int=0;y<h;y++){
				map[y]=new Array();
				for(var x:int=0;x<w;x++){
					var tile:busymonsters.Tile=new busymonsters.Tile(int(Math.random()*6));
					clip["tileArea"].addChild(tile);
					map[y][x]=tile;
					tile.x=x*d;
					tile.y=y*d;
				}
			}
			
			selectedClip=(clip as assets.PageGame).selectedClip;
			selectedClip.visible=false;
			clip["tileArea"].addChild(selectedClip);
			selectedClip.mouseEnabled=selectedClip.mouseChildren=false;
			
			clip["tileArea"].mouseChildren=true;
			clip["tileArea"].addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			clip["tileArea"].addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			clip["tileArea"].addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			
		}
		
		private function mouseOver(event:MouseEvent):void{
			var tile:Tile=event.target as Tile;
			if(tile){
				tile.selected=true;
			}
		}
		private function mouseOut(event:MouseEvent):void{
			var tile:Tile=event.target as Tile;
			if(tile){
				if(selectedTile){
					if(selectedTile==tile){
					}else{
						tile.selected=false;
					}
				}else{
					tile.selected=false;
				}
			}
		}
		
		private function mouseDown(event:MouseEvent):void{
			var tile:Tile=event.target as Tile;
			if(tile){
				clip.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
				clip.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				oldMouseX=clip["tileArea"].mouseX;
				oldMouseY=clip["tileArea"].mouseY;
				changeSelection(tile,MouseEvent.MOUSE_DOWN);
			}
		}
		private function mouseMove(event:MouseEvent):void{
			changeSelection(event.target as Tile,MouseEvent.MOUSE_MOVE);
		}
		private function mouseUp(event:MouseEvent):void{
			clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			clip.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			changeSelection(event.target as Tile,MouseEvent.MOUSE_UP);
		}
		
		private function changeSelection(tile:Tile,type:String):void{
			
			//outputMsg(type);
			
			switch(type){
				case MouseEvent.MOUSE_DOWN:
					if(tile){
						if(selectedTile){
							//已经选中一个方块了
							if(selectedTile==tile){
								isDownSelect=false;
							}else{
								var x1:int=Math.round(selectedTile.x/d);
								var y1:int=Math.round(selectedTile.y/d);
								var x2:int=Math.round(tile.x/d);
								var y2:int=Math.round(tile.y/d);
								if(
									x1==x2&&(y1-y2==-1||y1-y2==1)
									||
									y1==y2&&(x1-x2==-1||x1-x2==1)
								){
									//点击相邻的方块，交换
									isDownSelect=false;
									clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
									clip.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
									jiaohuan(selectedTile,tile);
									selectedTile=null;
								}else{
									//点击不相邻的方块，选中此方块
									isDownSelect=true;
									selectedTile=tile;
								}
							}
						}else{
							//还未选中任何方块，选中一个方块
							isDownSelect=true;
							selectedTile=tile;
						}
					}
				break;
				case MouseEvent.MOUSE_MOVE:
					var currMouseX:int=clip["tileArea"].mouseX;
					var currMouseY:int=clip["tileArea"].mouseY;
					var dMouseX:int=currMouseX-oldMouseX;
					var dMouseY:int=currMouseY-oldMouseY;
					if(dMouseX*dMouseX+dMouseY*dMouseY>100){
						x1=Math.round(selectedTile.x/d);
						y1=Math.round(selectedTile.y/d);
						if(dMouseX*dMouseX>dMouseY*dMouseY){
							if(dMouseX<0){
								x2=x1-1;
							}else{
								x2=x1+1;
							}
							y2=y1;
						}else{
							x2=x1;
							if(dMouseY<0){
								y2=y1-1;
							}else{
								y2=y1+1;
							}
						}
						if(x2>=0&&x2<w&&y2>=0&&y2<h){
							tile=map[y2][x2];
							if(tile){
								clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
								clip.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
								jiaohuan(selectedTile,tile);
								selectedTile=null;
							}
						}
					}
				break;
				case MouseEvent.MOUSE_UP:
					if(tile){
						if(selectedTile){
							if(isDownSelect){
							}else{
								if(selectedTile==tile){
									selectedTile=null;
								}else{
									selectedTile=tile;
								}
							}
						}
					}
				break;
			}
			
			if(selectedTile){
				selectedTile.selected=true;
				selectedClip.x=selectedTile.x;
				selectedClip.y=selectedTile.y;
				selectedClip.visible=true;
			}else{
				selectedClip.visible=false;
			}
			
		}
		
		private function jiaohuan(tile1:Tile,tile2:Tile):void{
			tile1.mouseEnabled=false;
			tile2.mouseEnabled=false;
			var x1:int=Math.round(tile1.x/d);
			var y1:int=Math.round(tile1.y/d);
			var x2:int=Math.round(tile2.x/d);
			var y2:int=Math.round(tile2.y/d);
			map[y1][x1]=null;
			map[y2][x2]=null;
			Jiaohuan.add(tile1,tile2,x1*d,y1*d,x2*d,y2*d,jiaohuanComplete);
		}
		private function jiaohuanComplete(tile1:Tile,tile2:Tile):void{
			var x2:int=Math.round(tile1.x/d);
			var y2:int=Math.round(tile1.y/d);
			var x1:int=Math.round(tile2.x/d);
			var y1:int=Math.round(tile2.y/d);
			map[y2][x2]=tile1;
			map[y1][x1]=tile2;
			tile1.mouseEnabled=true;
			tile2.mouseEnabled=true;
		}
		
	}
}