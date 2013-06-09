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
				map[y0]=new Array();
				for(var x0:int=0;x0<w;x0++){
					
					if(x0==0||x0==w-1||y0==0||y0==h-1){
						var tile:Tile=new Tile(-1);
						tile.mouseEnabled=false;
					}else{
						//需要保证左边和上边没有和其连成一直线超过三个的
						while(true){
							var color:int=int(Math.random()*3);
							if(x0>=3){
								if(map[y0][x0-1].color==color){
									if(map[y0][x0-2].color==color){
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
					map[y0][x0]=tile;
					tile.x=x0*d;
					tile.y=y0*d;
					
				}
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
							if(tile.color>-1){
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
			
			var xyArrArr:Array=new Array();
			var matchArr1:Array=getMatchArr(tile1);
			var matchArr2:Array=getMatchArr(tile2);
			if(matchArr1[0]){
				//tile1的横向匹配情况
				if(matchArr2[0]){
					if(matchArr1[0].toString()==matchArr2[0].toString()){//重复的
						matchArr2[0]=null;
					}
				}
				xyArrArr.push(matchArr1[0]);
			}
			if(matchArr1[1]){
				//tile1的纵向匹配情况
				if(matchArr2[1]){
					if(matchArr1[1].toString()==matchArr2[1].toString()){//重复的
						matchArr2[1]=null;
					}
				}
				xyArrArr.push(matchArr1[1]);
			}
			if(matchArr2[0]){
				//tile2的横向匹配情况
				xyArrArr.push(matchArr2[0]);
			}
			if(matchArr2[1]){
				//tile2的纵向匹配情况
				xyArrArr.push(matchArr2[1]);
			}
			
			for each(var xyArr:Array in xyArrArr){
				for each(var xy:Array in xyArr){
					var x:int=xy[0];
					var y:int=xy[1];
					var tile:Tile=map[y][x];
					map[y][x]=null;
					clip.effectArea.addChild(tile);
				}
			}
			
		}
		
		private function getMatchArr(tile0:Tile):Array{
			
			if(tile0.color>-1){
			}else{
				return [null,null];
			}
			
			var x0:int=Math.round(tile0.x/d);
			var y0:int=Math.round(tile0.y/d);
			
			var arr1:Array=new Array();
			var x:int=x0;
			while(--x>=0){
				var tile:Tile=map[y0][x];
				if(tile){
					if(tile.color==tile0.color){
						arr1.unshift([x,y0]);
					}else{
						break;
					}
				}else{
					break;
				}
			}
			arr1.push([x0,y0]);
			x=x0;
			while(++x<w){
				tile=map[y0][x];
				if(tile){
					if(tile.color==tile0.color){
						arr1.push([x,y0]);
					}else{
						break;
					}
				}else{
					break;
				}
			}
			if(arr1.length>=3){
			}else{
				arr1=null;
			}
			
			var arr2:Array=new Array();
			var y:int=y0;
			while(--y>=0){
				tile=map[y][x0];
				if(tile){
					if(tile.color==tile0.color){
						arr2.unshift([x0,y]);
					}else{
						break;
					}
				}else{
					break;
				}
			}
			arr2.push([x0,y0]);
			y=y0;
			while(++y<h){
				tile=map[y][x0];
				if(tile){
					if(tile.color==tile0.color){
						arr2.push([x0,y]);
					}else{
						break;
					}
				}else{
					break;
				}
			}
			if(arr2.length>=3){
			}else{
				arr2=null;
			}
			
			return [arr1,arr2];
		}
		
	}
}