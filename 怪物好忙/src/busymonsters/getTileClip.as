/***
getTileClip
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；已婚（单身美女们没机会了~~）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2013年06月15日 19:26:28
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package busymonsters{
	import assets.Tile;

	public function getTileClip(color:int):assets.Tile{
		return new (TileClassV[color])();
	}
}

const TileClassV:Vector.<Class>=new <Class>[assets.Tile_0_0,assets.Tile_1_0,assets.Tile_2_0,assets.Tile_3_0,assets.Tile_4_0,assets.Tile_5_0];