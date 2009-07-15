package org.namesonnodes.commands.biofiles.nexus
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	
	import flash.utils.Dictionary;
	
	import org.namesonnodes.commands.biofiles.BioFileError;

	public final class CharactersFormat
	{
		private static const CHARACTER_SYMBOL:RegExp = /^[^\s()\[\]{}<>\/\,;:=*^'"]$/;
		public static const DATATYPE_STANDARD:String = "STANDARD";
		private static const EQUATE_ELEMENT:RegExp = /^[^\s()\[\]{}\/\,;:*`'"<>^]+=$([^\s()\[\]{}\/\,;:*`'"<>^]+|\([^\s()\[\]{}\/\,;:*`'"<>^]+(\s+[^\s()\[\]{}\/\,;:*`'"<>^])*\))/;
		private static const EQUATE_SYMBOL:RegExp = /^[^\s()\[\]{}\/\,;:*`'"<>^]$/;
		private static const ITEMS:FiniteSet = HashSet.fromObject(["MIN", "MAX", "MEDIAN", "AVERAGE", "VARIANCE", "STDERROR", "SAMPLESIZE", "STATES"]);
		private static const MATCH_CHAR_SYMBOL:RegExp = /^[^\s()\[\]{}\/\,;:=*'"`<>^]$/;
		public static const NON_STATE_CHARACTERS:RegExp = /[\s()\[\]{}<>\/\,;:=*'"`~]+/g;
		private static const STATES_FORMATS:FiniteSet = HashSet.fromObject(["STATESPRESENT", "INDIVIDUALS", "COUNT", "FREQUENCY"]);
		private const _equate:Dictionary = new Dictionary();
		private const _items:MutableSet = new HashSet();
		private const _symbols:Vector.<String> = new Vector.<String>();
		private const symbolIndexMap:Dictionary = new Dictionary();
		private var _dataType:String = DATATYPE_STANDARD;
		private var _gap:String;
		private var _matchChar:String;
		private var _missing:String;
		private var _statesFormat:String;
		public var interleave:Boolean;
		public var labels:Boolean;
		public var respectCase:Boolean;
		public var tokens:Boolean;
		public var transpose:Boolean; 
		public function getStateIndices(c:String):Vector.<uint>
		{
			if (c == _gap || c == _missing)
				return new Vector.<uint>(0);
			if (c.length > 1)
			{
				var v:Vector.<uint> = new Vector.<uint>(c.length);
				const n:uint = c.length;
				for (var i:uint = 0; i < n; ++i)
					v[i] = getStateIndex(c.charAt(i));
				return v;
			}
			else if (c.length == 1)
			{
				v = new Vector.<uint>(1);
				v[0] = getStateIndex(c.charAt(0));
				return v;
			}
			else throw new BioFileError("Invalid character state token: <" + c + ">.");
		}
		private function getStateIndex(c:String):uint
		{
			const eq:* = _equate[c];
			if (eq is String)
				c = eq;
			var i:* = symbolIndexMap[c];
			if (i !== undefined)
				return uint(i);
			i = parseInt(c);
			if (i == parseFloat(c))
				return uint(i);
			else throw new BioFileError("Invalid character state symbol: <" + c + ">.");
		}
		public function CharactersFormat()
		{
			super();
			clear();
		}
		public function get items():FiniteSet
		{
			return _items;
		}
		public function get statesFormat():String
		{
			return _statesFormat;
		}
		public function set statesFormat(v:String):void
		{
			_statesFormat = v ? v.toUpperCase() : null;
			if (_statesFormat != null)
				if (!STATES_FORMATS.has(_statesFormat))
					trace("[WARNING]", "Unrecognized STATESFORMAT value: '" + v + "'.");
		}
		public function get symbols():Vector.<String>
		{
			return _symbols;
		}
		public function get missing():String
		{
			if (_missing)
				return respectCase ? _missing : _missing.toUpperCase();
			return null;
		}
		public function set missing(v:String):void
		{
			_missing = v;
		}
		public function get matchChar():String
		{
			if (_matchChar)
				return respectCase ? _matchChar : _matchChar.toUpperCase();
			return null;
		}
		public function set matchChar(v:String):void
		{
			if (v != null)
				if (!MATCH_CHAR_SYMBOL.test(v))
					throw new ArgumentError("Invalid match character symbol: '" + v + "'.");
			_matchChar = v;
		}
		public function get dataType():String
		{
			return _dataType;
		}
		public function set dataType(v:String):void
		{
			_dataType = v.toUpperCase();
		}
		public function get gap():String
		{
			if (_gap)
				return respectCase ? _gap : _gap.toUpperCase();
			return null;
		}
		public function set gap(v:String):void
		{
			if (v != null)
				if (!CHARACTER_SYMBOL.test(v))
					throw new ArgumentError("Invalid character symbol: '" + v + "'.");
			_gap = v;
		}
		public function addEquate(symbol:String, equivalents:Object):void
		{
			if (!EQUATE_SYMBOL.test(symbol))
				throw new ArgumentError("Invalid EQUATE symbol: '" + s + "'.");
			for each (var s:String in equivalents);
				if (!EQUATE_SYMBOL.test(s))
					throw new ArgumentError("Invalid EQUATE symbol: '" + s + "'.");
			_equate[symbol] = equivalents;
		}
		public function addItems(items:Object):void
		{
			for each (var item:String in items)
			{
				item = item.toUpperCase();
				if (ITEMS.has(item))
					_items.add(item);
				else
					trace("[WARNING]", "Unrecognized character format item: " + item);
			}
		}
		public function clear():void
		{
			dataType = DATATYPE_STANDARD;
			for (var key:* in _equate)
				_equate[key] = null;
			gap = null;
			interleave = false;
			_items.clear();
			labels = false;
			matchChar = null;
			missing = null;
			respectCase = false;
			statesFormat = null;
			while (_symbols.length)
				_symbols.pop();
			transpose = false;
			tokens = false;
		}
		public function parse(line:Vector.<String>):void
		{
			clear();
			const n:uint = line.length;
			if (n == 0)
				throw new BioFileError("Expected FORMAT command.");
			if (line[0].toUpperCase() != "FORMAT")
				throw new BioFileError("Expected FORMAT command; found: " + line.join(" ") + ";");
			for (var i:uint = 1; i < n; ++i)
			{
				var word:String = line[i];
				if (i < n - 2 && line[i + 1] == "=")
				{
					setAttribute(word, line[i + 2]);
					i += 2;
				}
				else if (i < n - 1 && word.charAt(word.length - 1) == "=")
				{
					setAttribute(word.substr(0, word.length - 1), line[i + 1]);
					i++;
				}
				else if (i < n - 1 && line[i + 1].charAt(0) == "=")
				{
					setAttribute(word, line[i + 1].substr(1));
					i++;
				}
				else if (word.indexOf("=") > 0)
				{
					var segments:Array = word.split("=", 2);
					var attribute:String = String(segments[0]).toUpperCase();
					var value:String = segments[1] as String;
					setAttribute(attribute, value);
				}
				else
				{
					word = word.toUpperCase();
					setFlag(word);
				}
			}
		}
		public function parseEquate(v:String):void
		{
			if (!/^".+"$/.test(v))
				throw new BioFileError("Invalid EQUATE value: " + v);
			const equations:Array = v.substr(1, v.length - 2).split(/\s+/g);
			for each (var equation:String in equations)
			{
				if (!EQUATE_ELEMENT.test(equation))
					throw new BioFileError("Invalid EQUATE element: " + equation);
				var parts:Array = equation.split("=", 2);
				if (parts.length != 2)
					throw new BioFileError("Invalid EQUATE element: " + equation);
				var equivalents:Array;
				if (/^\(.+\)$/.test(parts[1] as String))
					equivalents = String(parts[1]).substr(1, String(parts[1]).length - 2).split(/\s+/g);
				else
					equivalents = [parts[1]];
				addEquate(parts[0] as String, equivalents);
			}
		}
		public function parseSymbols(v:String):void
		{
			while (_symbols.length)
				_symbols.pop();
			for (var k:* in symbolIndexMap)
				symbolIndexMap[k] = undefined;
			if (v)
			{
				const values:Array = v.replace(NON_STATE_CHARACTERS, "").split("");
				var i:uint = 0;
				for (i = 0; i < values.length; ++i)
					symbolIndexMap[String(i)] == i;
				i = 0;
				for each (var value:String in values)
					if (value.length != 0)
					{
						if (symbolIndexMap[value] != undefined)
							throw new BioFileError("Duplicate SYMBOLS character: " + value);
						symbolIndexMap[value] = i++;
						_symbols.push(value);
					}
			} 
		}
		private function setAttribute(attr:String, value:String):void
		{
			attr = attr.toUpperCase();
			switch (attr)
			{
				case "DATATYPE" :
				{
					dataType = value.toUpperCase();
					break;
				}
				case "EQUATE" :
				{
					parseEquate(value);
					break;
				}
				case "GAP" :
				{
					gap = value;
					break;
				}
				case "ITEMS" :
				{
					if (value.match(/^\(.*\)$/))
						addItems(value.substr(0, value.length - 1).toUpperCase().split(/[^A-Z]+/));
					else
						addItems([value]);
					break;
				}
				case "MATCHCHAR" :
				{
					matchChar = value;
					break;
				}
				case "MISSING" :
				{
					missing = value;
					break;
				}
				case "STATESFORMAT" :
				{
					statesFormat = value;
					break;
				}
				case "SYMBOLS" :
				{
					parseSymbols(value);
					break;
				}
				default :
				{
					trace("[WARNING]", "Unrecognized FORMAT attribute: " + attr);
				}
			}
		}
		private function setFlag(name:String):void
		{
			name = name.toUpperCase();
			switch (name)
			{
				case "INTERLEAVE" :
				{
					interleave = true;
					break;
				}
				case "LABELS" :
				{
					labels = true;
					break;
				}
				case "NOLABELS" :
				{
					labels = false;
					break;
				}
				case "NOTOKENS" :
				{
					tokens = false;
					break;
				}
				case "RESPECTCASE" :
				{
					respectCase = true;
					break;
				}
				case "TOKENS" :
				{
					tokens = true;
					break;
				}
				case "TRANSPOSE" :
				{
					transpose = true;
					break;
				}
				default :
				{
					trace("[WARNING]", "Unrecognized FORMAT attribute: " + name);
				}
			}
		}
	}
}