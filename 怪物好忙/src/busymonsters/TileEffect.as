/***
TileEffect
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月15日 20:22:29
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	
	import assets.TileEffect;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	import zero.utils.stopAll;
	
	public class TileEffect{
		public var onComplete:Function;
		public var clip:assets.TileEffect;
		public function TileEffect(color:int){
			clip=new assets.TileEffect();
			clip.container.addChild(getTileClip(color));
			clip.addFrameScript(clip.totalFrames-1,clip_lastFrame);
		}
		public function clear():void{
			stopAll(clip);
			clip.addFrameScript(clip.totalFrames-1,null);
			onComplete=null;
			clip=null;
		}
		private function clip_lastFrame():void{
			if(onComplete==null){
			}else{
				onComplete();
			}
		}
	}
}