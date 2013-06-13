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
		
		public var clip:assets.PageGame;
		
		private var selectedClip:SelectedClip;
		private var isDownSelect:Boolean;
		private var selectedTile:Tile;
		
		//private static const dxyArr:Array=[[-1,0],[0,-1],[1,0],[0,1]];
		private static const d:int=50;
		private var map:Array;
		private var w:int;
		private var h:int;
		
		private var oldMouseX:int;
		private var oldMouseY:int;
		
		public function PageGame(){
			
			super(new assets.PageGame());
			
			//外围是一圈 color=-1 的 Tile
			w=10+2;
			h=10+2;
			
			/*
			xxxxxxxxxxxx
			xoooooooooox
			xoooooooooox
			xoooooooooox
			xoooooooooox
			xoooooooooox
			xoooooooooox
			xoooooooooox
			xoooooooooox
			xoooooooooox
			xoooooooooox
			xxxxxxxxxxxx
			*/
			
			var t:int=getTimer();
			//从上到下，从左到右生成初始地图（初始地图不能有自动消除的）
			map=new Array(h);
			for(var y0:int=0;y0<h;y0++){
				var line:Array=new Array();
				for(var x0:int=0;x0<w;x0++){
					
					if(x0==0||x0==w-1||y0==0||y0==h-1){
						var tile:Tile=new Tile(-1);
						tile.mouseEnabled=false;
					}else{
						//需要保证左边和上边没有和其连成一直线超过三个的
						while(true){
							var color:int=int(Math.random()*3);
							if(x0>=3){
								if(line[x0-1].color==color){
									if(line[x0-2].color==color){
										continue;
									}
								}
							}
							if(y0>=3){
								if(map[y0-1][x0].color==color){
									if(map[y0-2][x0].color==color){
										continue;
									}
								}
							}
							break;
						}
						tile=new Tile(color);
						tile.mouseEnabled=true;
					}
					
					clip.tileArea.addChild(tile);
					line[x0]=tile;
					tile.x=x0*d;
					tile.y=y0*d;
					
				}
				map[y0]=line;
			}
			outputMsg("生成地图耗时："+(getTimer()-t)+"毫秒。");
			
			selectedClip=clip.selectedClip;
			selectedClip.visible=false;
			clip.tileArea.addChild(selectedClip);
			selectedClip.mouseEnabled=selectedClip.mouseChildren=false;
			
			clip.tileArea.mouseChildren=true;
			clip.tileArea.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			clip.tileArea.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			clip.tileArea.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			
		}
		
		override public function clear():void{
			clip.removeEventListener(Event.ENTER_FRAME,falling);
			clip.tileArea.removeEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			clip.tileArea.removeEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			clip.tileArea.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			clip.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			selectedClip=null;
			selectedTile=null;
			Jiaohuan.clear();
			Xiaochu.clear();
			super.clear();
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
				oldMouseX=clip.tileArea.mouseX;
				oldMouseY=clip.tileArea.mouseY;
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
						if(tile.locked){
						}else{
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
					}
				break;
				case MouseEvent.MOUSE_MOVE:
					var currMouseX:int=clip.tileArea.mouseX;
					var currMouseY:int=clip.tileArea.mouseY;
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
						tile=map[y2][x2];
						if(tile){
							if(!(tile.locked)&&(tile.color>-1)){
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
						if(tile.locked){
						}else{
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
			//开始交换
			tile1.mouseEnabled=false;
			tile2.mouseEnabled=false;
			var x1:int=Math.round(tile1.x/d);
			var y1:int=Math.round(tile1.y/d);
			var x2:int=Math.round(tile2.x/d);
			var y2:int=Math.round(tile2.y/d);
			tile1.locked=true;
			tile2.locked=true;
			Jiaohuan.add(tile1,tile2,x1*d,y1*d,x2*d,y2*d,jiaohuanComplete);
		}
		private function jiaohuanComplete(tile1:Tile,tile2:Tile):void{
			//交换完毕
			var x2:int=Math.round(tile1.x/d);
			var y2:int=Math.round(tile1.y/d);
			var x1:int=Math.round(tile2.x/d);
			var y1:int=Math.round(tile2.y/d);
			tile1.locked=false;
			tile2.locked=false;
			tile1.mouseEnabled=true;
			tile2.mouseEnabled=true;
			map[y2][x2]=tile1;
			map[y1][x1]=tile2;
			var matchArr:Array=checkMatch();
			if(matchArr.length){
				var tileArr:Array=new Array();
				var xyArr:Array=new Array();
				for each(var arr:Array in matchArr){
					for each(var xy:Array in arr){
						xyArr.push(xy);
						var x:int=xy[0];
						var y:int=xy[1];
						var tile:Tile=map[y][x];
						tile.locked=true;
						tile.visible=false;
						var effectTile:Tile=new Tile(tile.color);
						clip.effectArea.addChild(effectTile);
						tileArr.push(effectTile);
						effectTile.x=x*d;
						effectTile.y=y*d;
					}
				}
				Xiaochu.add(tileArr,xyArr,xiaochuComplete);	
			}else{
				jiaohuan(tile2,tile1);
			}
		}
		
		private function checkMatch():Array{
			var t:int=getTimer();
			var matchArr:Array=new Array();
			var tile:Tile;
			for(var y0:int=0;y0<h;y0++){
				var x0:int=0;
				while(x0<w){
					var tile0:Tile=map[y0][x0];
					if(tile0){
						if((!tile0.locked)&&(tile0.color>-1)){
							var x:int=x0;
							var arr:Array=[[x,y0]];
							while(tile=map[y0][++x]){
								if((!tile.locked)&&(tile.color==tile0.color)){
									arr.push([x,y0]);
								}else{
									break;
								}
							}
							if(arr.length>=3){
								matchArr.push(arr);
							}
							x0+=arr.length;
						}else{
							x0++;
						}
					}else{
						x0++;
					}
					
				}
			}
			for(x0=0;x0<w;x0++){
				y0=0;
				while(y0<h){
					tile0=map[y0][x0];
					if(tile0){
						if((!tile0.locked)&&(tile0.color>-1)){
							var y:int=y0;
							arr=[[x0,y]];
							while(tile=map[++y][x0]){
								if((!tile.locked)&&(tile.color==tile0.color)){
									arr.push([x0,y]);
								}else{
									break;
								}
							}
							if(arr.length>=3){
								matchArr.push(arr);
							}
							y0+=arr.length;
						}else{
							y0++;
						}
					}else{
						y0++;
					}
					
				}
			}
			outputMsg("检测匹配耗时 "+(getTimer()-t)+" 毫秒。");
			return matchArr;
		}
		
		private function xiaochuComplete(tileArr:Array,xyArr:Array):void{
			//删除完毕
			for each(var effectTile:Tile in tileArr){
				clip.effectArea.removeChild(effectTile);
			}
			//trace("xyArr="+xyArr);
			for each(var xy:Array in xyArr){//xy可能会有重复的
				var x:int=xy[0];
				var y:int=xy[1];
				map[y][x]=null;
			}
			//上面的开始往下掉
			clip.removeEventListener(Event.ENTER_FRAME,falling);
			clip.addEventListener(Event.ENTER_FRAME,falling);
		}
		private function falling(...args):void{
			for(var x0:int=0;x0<w;x0++){
				var y0:int=h;
				while(--y0>=0){
					var tile0:Tile=map[y0][x0];
					if(tile0){
					}else{
						var y:int=y0;
						while(--y>=0){
							var tile:Tile=map[y][x0];
							if(tile){
								if(tile.color>-1){
									tile.locked=true;
									tile.y+=5;
									var dy:int=(y+1)*d-tile.y;
									if(dy<=0){
										map[y][x0]=null;
										map[y+1][x0]=tile;
										tile.locked=false;
									}
								}
							}
						}
						break;
					}
				}
			}
		}
		
	}
}