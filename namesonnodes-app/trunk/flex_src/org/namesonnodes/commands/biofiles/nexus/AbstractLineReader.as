package org.namesonnodes.commands.biofiles.nexus
{
	import flash.utils.ByteArray;
	
	import org.namesonnodes.commands.biofiles.BioFileError;

	internal class AbstractLineReader
	{
		protected static const CHAR_SET:String = "us-ascii";
		public function AbstractLineReader()
		{
			super();
		}
		protected static function getChar(bytes:ByteArray, length:uint = 1):String
		{
			return bytes.readMultiByte(length, CHAR_SET);
		}
		protected final function getLine(bytes:ByteArray):Vector.<String>
		{
			var word:String = "";
			var comment:String = "";
			const words:Vector.<String> = new Vector.<String>();
			var quoteEnd:String = null;
			var outComments:Boolean = true;
			while (bytes.bytesAvailable != 0)
			{
				var c:String = getChar(bytes);
				if (outComments)
				{
					if (quoteEnd == null)
					{
						if (c == ";")
							break;
						if (c == "[")
						{
							outComments = false;
							continue;
						}
						if (c == "'")
							quoteEnd = "'";
						else if (c == "\"")
							quoteEnd = "\"";
						else if (c == "(")
							quoteEnd = ")";
						else if (/\s/.test(c))
						{
							if (word.length != 0)
							{
								words.push(word);
								word = "";
							}
							continue;
						}
						word += c;
					}
					else
					{
						if (c == quoteEnd)
							quoteEnd = null;
						word += c;
					} 
				}
				else if (c == "]")
				{
					outComments = true;
					handleComment(comment);
					comment = "";
				}
				else comment += c;
			}
			if (comment.length != 0)
				handleComment(comment);
			if (word.length != 0)
				words.push(word);
			if (words.length == 0)
			{
				if (bytes.bytesAvailable != 0)
					return getLine(bytes);
				else
					throw new BioFileError("Unexpected end of file.");
			}
			return words;
		}
		protected function handleComment(comment:String):void
		{
		}
	}
}