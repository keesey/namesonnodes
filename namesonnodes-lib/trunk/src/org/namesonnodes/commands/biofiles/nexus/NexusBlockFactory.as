package org.namesonnodes.commands.biofiles.nexus
{
	import flash.utils.ByteArray;
	
	import org.namesonnodes.commands.biofiles.BioFileError;

	public final class NexusBlockFactory extends AbstractLineReader
	{
		private static const BLOCK_CHARACTERS:String = "CHARACTERS";
		private static const BLOCK_DATA:String = "DATA";
		private static const BLOCK_DISTANCES:String = "DISTANCES";
		private static const BLOCK_TAXA:String = "TAXA";
		private static const BLOCK_TREES:String = "TREES";
		private static const END:String = "END";
		private const taxaBlocks:Vector.<TaxaBlock> = new Vector.<TaxaBlock>();
		private var charactersIndex:uint = 0;
		private var dataIndex:uint = 0;
		private var taxaIndex:uint = 0;
		private var treesIndex:uint = 0;
		public function NexusBlockFactory()
		{
			super();
		}
		public function createBlock(bytes:ByteArray):NexusBlock
		{
			var line:Vector.<String> = getLine(bytes);
			var block:NexusBlock;
			if (line.length != 2)
				trace("[WARNING]", "Unrecognized command:", line.join(" "));
			if (line[0].toUpperCase() != "BEGIN")
				trace("[WARNING]", "Unrecognized command (expected BEGIN):", line.join(" "));
			const blockType:String = line[1].toUpperCase();
			trace("[NOTICE]", "BEGIN " + blockType);
			switch (blockType)
			{
				case BLOCK_CHARACTERS :
				{
					block = new CharactersBlock(taxaBlocks, "CHARACTERS:" + (charactersIndex++));
					break;
				} 
				case BLOCK_DATA :
				{
					block = new DataBlock("DATA:" + (dataIndex++));
					taxaBlocks.push(DataBlock(block).taxaBlock);
					break;
				}
				// :TODO: Distance blocks
				case BLOCK_TAXA :
				{
					block = new TaxaBlock("TAXA:" + (taxaIndex++));
					taxaBlocks.push(block as TaxaBlock);
					break;
				} 
				case BLOCK_TREES :
				{
					block = new TreesBlock(taxaBlocks, "TREES:" + (treesIndex++));
					break;
				}
				case END :
				{
					throw new BioFileError("Invalid NEXUS grammar: END cannot immediately follow BEGIN.");
				}
				default :
				{
					do
					{
						line = getLine(bytes);
					}
					while (line[0].toUpperCase() != "END");  
				}
			}
			if (block)
				block.parse(bytes);
			trace("[NOTICE]", "END " + blockType);
			return block;
		}
	}
}