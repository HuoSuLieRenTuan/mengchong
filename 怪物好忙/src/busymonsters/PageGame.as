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
	import zero.records.Recorder;
	
	public class PageGame extends BasePage{
		
		public var clip:assets.PageGame;
		
		private var selectedClip:SelectedClip;
		private var isDownSelect:Boolean;
		private var mouseOverTile:Tile;
		private var selectedTile:Tile;
		
		private var currColorArr:Array;
		
		private static const d:int=50;
		private static const maxSpeed:int=d*0.5-1;
		private static const g:int=2;
		private var map:Array;
		private var fallingTileV:Vector.<Tile>;//按物理定律掉落即可
		private var w:int;
		private var h:int;
		
		private var oldMouseX:int;
		private var oldMouseY:int;
		
		private var recorder:Recorder;
		private var record_dataArr:Array;
		private var checkingMouse:Boolean;
		
		public function PageGame(_currColorArr:Array,_record_dataArr:Array){
			
			super(new assets.PageGame());
			
			currColorArr=_currColorArr;
			record_dataArr=_record_dataArr;
			
			clip.addEventListener(Event.ADDED_TO_STAGE,added);
		}
		
		private function added(...args):void{
			
			clip.removeEventListener(Event.ADDED_TO_STAGE,added);
			
			Random.init(
				//Math.random()*0x100000000
				3
			);
			
			if(currColorArr){
			}else{
				//currColorArr=[0,1,2];
				currColorArr=[1,2,3,4];
				//currColorArr=[0,1,2,3,4,5];
			}
			
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
			fallingTileV=new Vector.<Tile>();
			for(var y0:int=0;y0<h;y0++){
				map[y0]=new Array();
				for(var x0:int=0;x0<w;x0++){
					
					if(x0==0||x0==w-1||y0==0||y0==h-1){
						var tile:Tile=new Tile(-1,Tile.TYPE_0);
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
						
						/*
						switch(x0+","+y0){
							case "4,4":
							case "4,5":
							case "4,6":
							case "5,5":
							case "6,4":
							case "6,5":
							case "6,6":
							case "6,7":
							case "6,8":
							case "7,5":
								color=0;
							break;
						}
						//*/
						
						/*
						switch(x0+","+y0){
							case "4,5":
							case "5,5":
							case "6,4":
							case "6,6":
							case "6,7":
							case "7,5":
								color=0;
							break;
						}
						//*/
						
						switch(x0+","+y0){
							case "4,4":
							case "5,4":
							case "6,4":
							case "4,5":
							//case "5,5":
							case "6,5":
							case "4,6":
							case "5,6":
							case "6,6":
								color=0;
							break;
						}
						
						tile=new Tile(color,Tile.TYPE_0);
						
					}
					
					clip.tileArea.addChild(tile);
					map[y0][x0]=tile;
					tile.x0=x0;
					tile.y0=y0;
					tile.x=x0*d;
					tile.y=y0*d;
					
				}
			}
			outputMsg("生成地图耗时："+(getTimer()-t)+"毫秒。");
			
			/*
			//测试个别下落
			for(y0=0;y0<h;y0++){
				for(x0=0;x0<w;x0++){
					if(x0==0||x0==w-1||y0==0||y0==h-1){
					}else{
						if(
							x0==6&&y0==3
							||
							x0==6&&y0==4
							||
							x0==6&&y0==7
						){
							tile=map[y0][x0];
							map[y0][x0]=null;
							tile.bounce=4;
							tile.speed=-4;
							tile.locked=true;
							fallingTileV.push(tile);
						}else{
							tile=map[y0][x0];
							clip.tileArea.removeChild(tile);
							map[y0][x0]=null;
						}
					}
				}
			}
			clip.addEventListener(Event.ENTER_FRAME,falling);
			//*/
				
			selectedClip=clip.selectedClip;
			selectedClip.visible=false;
			clip.tileArea.addChild(selectedClip);
			selectedClip.mouseEnabled=selectedClip.mouseChildren=false;
			
			clip.addEventListener(MouseEvent.CLICK,click);
			
			recorder=new Recorder();
			if(record_dataArr){
				clip.tileArea.mouseChildren=false;
				trace("replay start-----------------------------");
				recorder.replay(clip.stage,replayComplete,recorder_step,recorder_mouseOver,recorder_mouseOut,recorder_mouseDown,recorder_mouseUp,recorder_mouseMove,null,null,record_dataArr);
			}else{
				clip.tileArea.mouseChildren=true;
				trace("record start-----------------------------");
				recorder.record(clip.stage,recordComplete,recorder_step,recorder_mouseOver,recorder_mouseOut,recorder_mouseDown,recorder_mouseUp,recorder_mouseMove,null,null);
			}
			
			checkMatch(null);
			
		}
		
		private function recorder_step():void{
			
		}
		private function recorder_mouseOver():Boolean{
			//if(正在游戏){
				var x0:int=recorder.getInt(Math.round(clip.tileArea.mouseX/d));
				var y0:int=recorder.getInt(Math.round(clip.tileArea.mouseY/d));
				if(x0>=1&&x0<w-1&&y0>=1&&y0<h-1){
					var tile:Tile=map[y0][x0];
					if(tile&&tile.mouseEnabled){
						//outputMsg("recorder_mouseOver");
						if(mouseOverTile){
							mouseOverTile.selected=false;
							mouseOverTile=null;
						}
						mouseOverTile=tile;
						mouseOverTile.selected=true;
						return true;
					}
				}
			//}
			return false;
		}
		private function recorder_mouseOut():Boolean{
			//if(正在游戏){
				if(mouseOverTile){
					//outputMsg("recorder_mouseOut，mouseOverTile=("+mouseOverTile.x0+","+mouseOverTile.y0+")");
					if(selectedTile){
						if(selectedTile==mouseOverTile){
						}else{
							mouseOverTile.selected=false;
						}
					}else{
						mouseOverTile.selected=false;
					}
					mouseOverTile=null;
					return true;
				}
			//}
			return false;
		}
		private function recorder_mouseDown():Boolean{
			//if(正在游戏){
				var mouseX:int=recorder.getInt(Math.round(clip.tileArea.mouseX));
				var mouseY:int=recorder.getInt(Math.round(clip.tileArea.mouseY));
				var x0:int=Math.round(mouseX/d);
				var y0:int=Math.round(mouseY/d);
				if(x0>=1&&x0<w-1&&y0>=1&&y0<h-1){
					var tile:Tile=map[y0][x0];
					if(tile&&tile.mouseEnabled){
						checkingMouse=true;
						oldMouseX=mouseX;
						oldMouseY=mouseY;
						changeSelection(tile,MouseEvent.MOUSE_DOWN,mouseX,mouseY);
						return true;
					}
				}
			//}
			return false;
		}
		private function recorder_mouseUp():Boolean{
			//if(正在游戏){
				if(checkingMouse){
					var mouseX:int=recorder.getInt(Math.round(clip.tileArea.mouseX));
					var mouseY:int=recorder.getInt(Math.round(clip.tileArea.mouseY));
					var x0:int=Math.round(mouseX/d);
					var y0:int=Math.round(mouseY/d);
					if(x0>=1&&x0<w-1&&y0>=1&&y0<h-1){
						var tile:Tile=map[y0][x0];
						if(tile&&tile.mouseEnabled){
						}else{
							tile=null;
						}
					}else{
						tile=null;
					}
					checkingMouse=false;
					changeSelection(tile,MouseEvent.MOUSE_UP,mouseX,mouseY);
					return true;
				}
			//}
			return false;
		}
		private function recorder_mouseMove():Boolean{
			//if(正在游戏){
				if(checkingMouse){
					var mouseX:int=recorder.getInt(Math.round(clip.tileArea.mouseX));
					var mouseY:int=recorder.getInt(Math.round(clip.tileArea.mouseY));
					var x0:int=Math.round(mouseX/d);
					var y0:int=Math.round(mouseY/d);
					if(x0>=1&&x0<w-1&&y0>=1&&y0<h-1){
						var tile:Tile=map[y0][x0];
						if(tile&&tile.mouseEnabled){
						}else{
							tile=null;
						}
					}else{
						tile=null;
					}
					changeSelection(tile,MouseEvent.MOUSE_MOVE,mouseX,mouseY);
					return true;
				}
			//}
			return false;
		}
		
		private function recordComplete():void{
			trace("recordComplete");
			trace("recorder.dataArr="+recorder.dataArr);
			sol.setValue("record_"+new Date().time+"_"+(1000000+int(Math.random()*1000000)).toString().substr(1),recorder.dataArr.toString());
			clip.dispatchEvent(new GameEvent(GameEvent.BACK_TO_MENU,false,false,null));
		}
		private function replayComplete():void{
			trace("replayComplete");
			clip.dispatchEvent(new GameEvent(GameEvent.BACK_TO_MENU,false,false,null));
		}
		
		override public function clear():void{
			currColorArr=null;
			recorder=null;
			record_dataArr=null;
			clip.removeEventListener(MouseEvent.CLICK,click);
			clip.removeEventListener(Event.ENTER_FRAME,falling);
			map=null;
			fallingTileV=null;
			selectedClip=null;
			mouseOverTile=null;
			selectedTile=null;
			Jiaohuan.clear();
			Xiaochu.clear();
			super.clear();
		}
		private function click(event:MouseEvent):void{
			switch(event.target){
				case clip.btnPlayRecords:
					clip.dispatchEvent(new GameEvent(GameEvent.SHOW_RECORD_PANE,true,false,null));
				break;
				case clip.btnMenu:
					recorder.halt();
				break;
			}
		}
		
		private function changeSelection(tile:Tile,type:String,mouseX:int,mouseY:int):void{
			
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
											selectedTile.y0==tile.y0&&(selectedTile.x0-tile.x0==-1||selectedTile.x0-tile.x0==1)
										){
											//点击相邻的方块，交换
											isDownSelect=false;
											checkingMouse=false;
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
							var dMouseX:int=mouseX-oldMouseX;
							var dMouseY:int=mouseY-oldMouseY;
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
										checkingMouse=false;
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
			clip.tileArea.addChild(tile1);
			clip.tileArea.addChild(tile2);
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
			
			var justJiaohuanMark:Object=new Object();
			justJiaohuanMark[tile1.x0+","+tile1.y0]=tile1;
			justJiaohuanMark[tile2.x0+","+tile2.y0]=tile2;
			var xyArr:Array=checkMatch(justJiaohuanMark);
			if(xyArr){
				for each(var xy:Array in xyArr){
					if(justJiaohuanMark[xy.toString()]){
						return;//如果交换的有一个匹配成功
					}
				}
			}
			
			if(needBack){
				//还原
				jiaohuan(tile2,tile1,false);
			}else{
				checkFalling();
			}
			
		}
		
		private function checkMatch(justJiaohuanMark:Object):Array{
			var t:int=getTimer();
			var xyMark:Object=new Object();
			var xyArr:Array=new Array();
			var wArrMark:Object=new Object();
			var tile:Tile;
			for(var y0:int=0;y0<h;y0++){
				var x0:int=0;
				while(x0<w){
					var tile0:Tile=map[y0][x0];
					if(tile0){
						if(tile0.enabled&&(tile0.color>-1)){
							var x:int=x0;
							if(xyMark[x+","+y0]){
							}else{
								xyMark[x+","+y0]=[x,y0];
							}
							var arr:Array=[xyMark[x+","+y0]];
							while(tile=map[y0][++x]){
								if(tile.enabled&&(tile.color==tile0.color)){
									if(xyMark[x+","+y0]){
									}else{
										xyMark[x+","+y0]=[x,y0];
									}
									arr.push(xyMark[x+","+y0]);
								}else{
									break;
								}
							}
							if(arr.length>=3){
								for each(var xy:Array in arr){
									xyArr.push(xy);
									wArrMark[xy.toString()]=arr;
								}
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
			var hArrMark:Object=new Object();
			for(x0=0;x0<w;x0++){
				y0=0;
				while(y0<h){
					tile0=map[y0][x0];
					if(tile0){
						if(tile0.enabled&&(tile0.color>-1)){
							var y:int=y0;
							if(xyMark[x0+","+y]){
							}else{
								xyMark[x0+","+y]=[x0,y];
							}
							arr=[xyMark[x0+","+y]];
							while(tile=map[++y][x0]){
								if(tile.enabled&&(tile.color==tile0.color)){
									if(xyMark[x0+","+y]){
									}else{
										xyMark[x0+","+y]=[x0,y];
									}
									arr.push(xyMark[x0+","+y]);
								}else{
									break;
								}
							}
							if(arr.length>=3){
								for each(xy in arr){
									xyArr.push(xy);
									hArrMark[xy.toString()]=arr;
								}
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
			
			if(xyArr.length){
				
				//trace("xyArr="+xyArr);
				
				var tileEffectArr:Array=new Array();
				for each(xy in xyArr){
					x0=xy[0];
					y0=xy[1];
					
					tile0=map[y0][x0];
					var color:int=tile0.color;
					var type:int=tile0.type;
					if(selectedTile){
						if(selectedTile==tile0){
							selectedClip.visible=false;
							selectedTile=null;
						}
					}
					//tile0.locked=true;
					//tile0.visible=false;
					clip.tileArea.removeChild(tile0);
					tile0=null;
					map[y0][x0]=null;
					
					var wArr:Array=wArrMark[xy.toString()];
					var hArr:Array=hArrMark[xy.toString()];
					
					//trace("("+xy+")","["+wArr+"]","["+hArr+"]");
					
					var newTileV:Vector.<Tile>=new Vector.<Tile>();
					if(wArr){
						if(wArr.length>=5){
							if(wArr.indexOf(xy)==int(wArr.length/2)){
								newTileV.push(new Tile(color,Tile.TYPE_3));
							}
						}else if(wArr.length==4){
							var newTileXY:Array=null;
							if(justJiaohuanMark){
								for each(var _xy:Array in wArr){
									if(justJiaohuanMark[_xy.toString()]){
										newTileXY=_xy;
										break;
									}
								}
							}
							if(newTileXY){
							}else{
								if(wArr.indexOf(xy)==1){
									newTileXY=xy;
								}
							}
							if(newTileXY==xy){
								newTileV.push(new Tile(color,Tile.TYPE_1));
							}
						}
					}
					if(hArr){
						if(hArr.length>=5){
							if(hArr.indexOf(xy)==int(hArr.length/2)){
								newTileV.push(new Tile(color,Tile.TYPE_3));
							}
						}else if(hArr.length==4){
							newTileXY=null;
							if(justJiaohuanMark){
								for each(_xy in hArr){
									if(justJiaohuanMark[_xy.toString()]){
										newTileXY=_xy;
										break;
									}
								}
							}
							if(newTileXY){
							}else{
								if(hArr.indexOf(xy)==1){
									newTileXY=xy;
								}
							}
							if(newTileXY==xy){
								newTileV.push(new Tile(color,Tile.TYPE_1));
							}
						}
					}
					if(wArr&&hArr){
						newTileV.push(new Tile(color,Tile.TYPE_2));
					}
					
					if(newTileV.length){
						for each(var newTile:Tile in newTileV){
							clip.tileArea.addChild(newTile);
							map[y0][x0]=newTile;
							newTile.x0=x0;
							newTile.y0=y0;
							newTile.x=x0*d;
							newTile.y=y0*d;
						}
					}
					
					var tileEffect:TileEffect=new TileEffect(color,type);
					
					clip.effectArea.addChild(tileEffect.clip);
					tileEffectArr.push(tileEffect);
					tileEffect.clip.x=x0*d;
					tileEffect.clip.y=y0*d;
					
				}
				
				Xiaochu.add(tileEffectArr,xyArr,xiaochuComplete);
				
				checkFalling();
				
				return xyArr;
				
			}//end of if(matchArr.length)...
			
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
		
		private function checkFalling():void{
			for(var x0:int=0;x0<w;x0++){
				var y0:int=h;
				while(--y0>=0){
					var tile:Tile=map[y0][x0];
					if(tile){
					}else{//孔
						var y:int=y0;
						while(--y>=0){
							tile=map[y][x0];
							if(tile){
								if(tile.color>-1){
									if(tile.locked){
									}else{
										y0=y;
										map[y0][x0]=null;
										tile.bounce=4;
										tile.speed=-4;
										tile.locked=true;
										fallingTileV.push(tile);
										continue;
									}
								}
							}
							break;
						}
					}
				}
			}
			
			//上面的开始往下掉
			clip.removeEventListener(Event.ENTER_FRAME,falling);
			clip.addEventListener(Event.ENTER_FRAME,falling);
		}
		private function falling(...args):void{
			
			if(recorder.isPause()){
				return;
			}
			
			var numByX0Arr:Array=new Array();
			for(var x0:int=0;x0<w;x0++){
				numByX0Arr[x0]=0;
				for(var y0:int=0;y0<h;y0++){
					if(map[y0][x0]){
						numByX0Arr[x0]++;
					}
				}
			}
			
			var mark:Object=new Object();
			for each(var tile0:Tile in fallingTileV){
				numByX0Arr[tile0.x0]++;
				if(mark[tile0.x0+","+tile0.y0]){
					throw "xxx";
				}
				mark[tile0.x0+","+tile0.y0]=tile0;
			}
			
			for(x0=0;x0<w;x0++){
				if(mark[x0+",1"]){
				}else if(numByX0Arr[x0]<h){
					var tile:Tile=new Tile(currColorArr[Random.ranInt(currColorArr.length)],Tile.TYPE_0);
					clip.tileArea.addChild(tile);
					tile.x0=x0;
					tile.y0=1;
					tile.x=tile.x0*d;
					tile0=mark[x0+",2"];
					if(tile0){
						tile.y=tile0.y-d;
						tile.bounce=tile0.bounce;
						tile.speed=tile0.speed;
					}else{
						tile.y=0;
						tile.bounce=4;
						tile.speed=-4;
					}
					tile.locked=true;
					fallingTileV.push(tile);
				}
			}
			
			if(fallingTileV.length){
				
				fallingTileV.sort(sortTileByXY);
				
				var i:int=fallingTileV.length;
				while(--i>=0){
					tile0=fallingTileV[i];
					if((tile0.speed+=g)>maxSpeed){
						tile0.speed=maxSpeed;
					}
					tile0.y+=tile0.speed;
				}
				
				i=fallingTileV.length;
				while(--i>=0){
					tile0=fallingTileV[i];
					if(map[tile0.y0][tile0.x0]){
						throw "xxx";
					}
					if(tile0.y>tile0.y0*d){
						if(map[tile0.y0+1][tile0.x0]){
							tile0.x=tile0.x0*d;
							tile0.y=tile0.y0*d;
							if(tile0.bounce>0){
								tile0.speed=-tile0.bounce;
								tile0.bounce=0;
							}else{
								map[tile0.y0][tile0.x0]=tile0;
								tile0.locked=false;
								fallingTileV.splice(i,1);
								tile0=null;
							}
						}else{
							tile0.y0++;
							if(map[tile0.y0][tile0.x0]){
								throw "xxx";
							}
						}
					}
					if(tile0){
						var j:int=i;
						while(--j>=0){
							//调整上面的所有 tile
							tile=fallingTileV[j];
							if(tile.x0==tile0.x0){
								if(tile.y+d>tile0.y){
									tile.y0=tile0.y0-1;
									//tile.alpha=0.5;
									//trace("tile.y0="+(tile.y0+1)+"==>"+tile.y0);
									tile.y=tile0.y-d;
									tile.speed=tile0.speed;
									tile.bounce=tile0.bounce;
									//clip.removeEventListener(Event.ENTER_FRAME,falling);
									//return;
								}
							}
						}
					}
				}
				
			}
			
			if(selectedTile){
				selectedClip.x=selectedTile.x;
				selectedClip.y=selectedTile.y;
			}
			
			if(fallingTileV.length){
			}else{
				clip.removeEventListener(Event.ENTER_FRAME,falling);
				checkMatch(null);
			}
			
		}
		private function sortTileByXY(tile1:Tile,tile2:Tile):int{
			//从上到下，从右到左排序
			if(tile1.y>tile2.y){
				return 1;
			}
			if(tile1.y<tile2.y){
				return -1;
			}
			if(tile1.x<tile2.x){
				return 1;
			}else if(tile1.x>tile2.x){
				return -1;
			}
			return 0;//貌似不可能到这里
		}
		
		public function pause():void{
			recorder.pause();
		}
		public function resume():void{
			recorder.resume();
		}
		
	}
}