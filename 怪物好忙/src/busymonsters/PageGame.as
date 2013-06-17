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
	
	import zero.Random;
	
	public class PageGame extends BasePage{
		
		public var clip:assets.PageGame;
		
		private var selectedClip:SelectedClip;
		private var isDownSelect:Boolean;
		private var selectedTile:Tile;
		
		private var currColorArr:Array;
		
		private static const g:int=2;
		private static const d:int=50;
		private var map:Array;
		private var fallingMap:Array;
		private var w:int;
		private var h:int;
		
		private var oldMouseX:int;
		private var oldMouseY:int;
		
		public function PageGame(){
			
			super(new assets.PageGame());
			
			Random.init(
				//Math.random()*0x100000000
				1
			);
			
			currColorArr=[0,1,2];
			//currColorArr=[3,4,5];
			//currColorArr=[0,1,2,3,4,5];
			
			//外围是一圈 color=-1 的 Tile
			w=8+2;
			h=8+2;
			
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
			fallingMap=new Array(h);
			for(var y0:int=0;y0<h;y0++){
				map[y0]=new Array();
				fallingMap[y0]=new Array();
				for(var x0:int=0;x0<w;x0++){
					
					if(x0==0||x0==w-1||y0==0||y0==h-1){
						var tile:Tile=new Tile(-1,false);
						tile.mouseEnabled=false;
					}else{
						//需要保证左边和上边没有和其连成一直线超过三个的
						while(true){
							var color:int=currColorArr[Random.ranInt(currColorArr.length)];
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
						tile=new Tile(color,false);
					}
					
					clip.tileArea.addChild(tile);
					map[y0][x0]=tile;
					tile.x0=x0;
					tile.y0=y0;
					fallingMap[y0][x0]=null;
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
		
		override public function clear():void{
			clip.removeEventListener(Event.ENTER_FRAME,falling);
			clip.tileArea.removeEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			clip.tileArea.removeEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			clip.tileArea.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			clip.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			map=null;
			fallingMap=null;
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
						if(tile.enabled){
							if(selectedTile){
								//已经选中一个方块了
								if(selectedTile==tile){
									isDownSelect=false;
								}else{
									if(selectedTile.enabled){
										if(
											selectedTile.x0==tile.x0&&(selectedTile.y0-tile.y0==-1||selectedTile.y0-tile.y0==1)
											||
											selectedTile.y0==tile.y0&&(selectedTile.x0-tile.x0==-1||selectedTile.x0-tile.x==1)
										){
											//点击相邻的方块，交换
											isDownSelect=false;
											clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
											clip.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
											jiaohuan(selectedTile,tile,true);
											selectedTile=null;
										}else{
											//点击不相邻的方块，选中此方块
											isDownSelect=true;
											selectedTile=tile;
										}
									}else{
										//选中的方块不能操作（正在交换或正在下落等）
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
					if(selectedTile){
						if(selectedTile.enabled){
							var currMouseX:int=clip.tileArea.mouseX;
							var currMouseY:int=clip.tileArea.mouseY;
							var dMouseX:int=currMouseX-oldMouseX;
							var dMouseY:int=currMouseY-oldMouseY;
							if(dMouseX*dMouseX+dMouseY*dMouseY>100){
								if(dMouseX*dMouseX>dMouseY*dMouseY){
									if(dMouseX<0){
										tile=map[selectedTile.y0][selectedTile.x0-1];
									}else{
										tile=map[selectedTile.y0][selectedTile.x0+1];
									}
								}else{
									if(dMouseY<0){
										tile=map[selectedTile.y0-1][selectedTile.x0];
									}else{
										tile=map[selectedTile.y0+1][selectedTile.x0];
									}
								}
								if(tile){
									if(tile.enabled&&(tile.color>-1)){
										clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
										clip.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
										jiaohuan(selectedTile,tile,true);
										selectedTile=null;
									}
								}
							}
						}
					}
				break;
				case MouseEvent.MOUSE_UP:
					if(tile){
						if(tile.enabled){
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
		
		private function jiaohuan(tile1:Tile,tile2:Tile,needBack:Boolean):void{
			//开始交换
			tile1.locked=true;
			tile2.locked=true;
			Jiaohuan.add(tile1,tile2,tile1.x0*d,tile1.y0*d,tile2.x0*d,tile2.y0*d,needBack,jiaohuanComplete);
		}
		private function jiaohuanComplete(tile1:Tile,tile2:Tile,needBack:Boolean):void{
			//交换完毕
			tile1.locked=false;
			tile2.locked=false;
			var xx:int=tile1.x0;
			var yy:int=tile1.y0;
			tile1.x0=tile2.x0;
			tile1.y0=tile2.y0;
			tile2.x0=xx;
			tile2.y0=yy;
			map[tile1.y0][tile1.x0]=tile1;
			map[tile2.y0][tile2.x0]=tile2;
			
			var xyMark:Object=new Object();
			xyMark[tile1.x0+","+tile1.y0]=true;
			xyMark[tile2.x0+","+tile2.y0]=true;
			var xyArr:Array=checkMatch();
			if(xyArr){
				//trace("xyArr.length="+xyArr.length);
				for each(var xy:Array in xyArr){
					if(xyMark[xy.toString()]){//如果交换的有一个匹配成功
						return;
					}
				}
			}
			
			if(needBack){
				//还原
				jiaohuan(tile2,tile1,false);
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
						if(tile0.enabled&&(tile0.color>-1)){
							var x:int=x0;
							var arr:Array=[[x,y0]];
							while(tile=map[y0][++x]){
								if(tile.enabled&&(tile.color==tile0.color)){
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
						if(tile0.enabled&&(tile0.color>-1)){
							var y:int=y0;
							arr=[[x0,y]];
							while(tile=map[++y][x0]){
								if(tile.enabled&&(tile.color==tile0.color)){
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
			
			if(matchArr.length){
				var tileEffectArr:Array=new Array();
				var xyArr:Array=new Array();
				var xyMark:Object=new Object();
				for each(arr in matchArr){
					for each(var xy:Array in arr){
						if(xyMark[xy.toString()]){
						}else{
							xyMark[xy.toString()]=true;
							xyArr.push(xy);
							x=xy[0];
							y=xy[1];
							tile=map[y][x];
							if(selectedTile){
								if(selectedTile==tile){
									selectedClip.visible=false;
									selectedTile=null;
								}
							}
							
							//tile.locked=true;
							//tile.visible=false;
							
							var tileEffect:TileEffect=new TileEffect(tile.color);
							
							clip.tileArea.removeChild(tile);
							map[y][x]=null;
							
							clip.effectArea.addChild(tileEffect.clip);
							tileEffectArr.push(tileEffect);
							tileEffect.clip.x=x*d;
							tileEffect.clip.y=y*d;
						}
					}
				}
				
				Xiaochu.add(tileEffectArr,xyArr,xiaochuComplete);
				
				for(y0=0;y0<h-1;y0++){
					for(x0=0;x0<w;x0++){
						tile=map[y0][x0];
						if(tile){
							if(tile.color>-1){
								if(tile.locked){
								}else{
									if(xyMark[x0+","+(y0+1)]){//下面有刚消产生的孔
										map[y0][x0]=null;
										fallingMap[y0][x0]=tile;
										tile.falling=true;
										tile.speed=-4;
									}
								}
							}
						}
					}
				}
				
				//上面的开始往下掉
				clip.removeEventListener(Event.ENTER_FRAME,falling);
				clip.addEventListener(Event.ENTER_FRAME,falling);
				
				return xyArr;
				
			}
			return null;
		}
		
		private function xiaochuComplete(tileEffectArr:Array,xyArr:Array):void{
			//删除完毕
			for each(var tileEffect:TileEffect in tileEffectArr){
				clip.effectArea.removeChild(tileEffect.clip);
				tileEffect.clear();
			}
			//trace("xyArr="+xyArr);
		}
		private function falling(...args):void{
			for(var y0:int=0;y0<h;y0++){
				for(var x0:int=0;x0<w;x0++){
					var tile:Tile=fallingMap[y0][x0];
					if(tile){
						tile.y=Math.round(tile.y+tile.speed);
						tile.speed+=g;
					}
				}
			}
		}
		
		
		
	}
}