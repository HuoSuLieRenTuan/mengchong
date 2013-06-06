/***
CutCandys
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月06日 14:53:35
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	import zero.codec.PNGEncoder;
	import zero.zip.Zip;
	
	public class CutCandys extends Sprite{
		
		private var xmlLoader:URLLoader;
		private var xml:XML;
		private var pngLoader:Loader;
		private var onLoadComplete:Function;
		
		public function CutCandys(){
			
			xmlLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE,loadXMLComplete);
			
			pngLoader=new Loader();
			pngLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadPNGComplete);
			
			xmlLoader.load(new URLRequest(
				"candy.xml"
				//"hires_striped.xml"
			));
			
		}
		private function loadXMLComplete(...args):void{
			xml=new XML(xmlLoader.data);
			pngLoader.load(new URLRequest(xml.@imagePath.toString()));
		}
		private function loadPNGComplete(...args):void{
			var zip:Zip=new Zip();
			var bmd0:BitmapData=(pngLoader.content as Bitmap).bitmapData;
			for each(var spriteXML:XML in xml.sprite){
				var bmd:BitmapData=new BitmapData(int(spriteXML.@w.toString()),int(spriteXML.@h.toString()),true,0x00000000);
				bmd.copyPixels(bmd0,new Rectangle(int(spriteXML.@x.toString()),int(spriteXML.@y.toString()),bmd.width,bmd.height),new Point());
				zip.add(PNGEncoder.encode(bmd),spriteXML.@n.toString());
				bmd.dispose();
			}
			new FileReference().save(zip.encode(),xml.@imagePath.toString().replace(/\.\w+$/,".zip"));
		}
		
		
	}
}