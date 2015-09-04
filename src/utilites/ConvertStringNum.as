package utilites 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Linda
	 */
	
	/*
	 * Convert string to hex(encode) and hex to string(decode)
	 * usage:
	 * 
	 * var linda = ConvertStringNum.encode("Linda");
		trace(linda, "4c696e6461");//output:    4c696e6461 4c696e6461
		linda = ConvertStringNum.decode(linda);
		trace(linda, "Linda");//output:	Linda Linda
	 * 
	 */ 
	public class ConvertStringNum 
	{
		
		public static function encode(value:String):String {
            var ba:ByteArray = new ByteArray();
            ba.writeUTFBytes(value);
            var len:uint = ba.length;
            var s:String = "";
            for (var i:uint = 0; i < len; i++) {
                s += ba[i].toString(16);
            }
            return s;
        }
        
        public static function decode(value:String):String {
            var ba:ByteArray = new ByteArray();
            var len:uint = value.length;
            for (var i:uint = 0; i < len; i += 2) {
                var c:String = value.charAt(i) + value.charAt(i + 1);
                ba.writeByte(parseInt(c, 16));
            }
            return ba.toString();
        }
		
	}

}