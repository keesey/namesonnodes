package org.namesonnodes.math.editor.elements
{
	import a3lbmonkeybrain.brainstem.filter.isNonEmptyString;

	public function incrementIdentifier(identifier:String, position:int = -1):String
	{
		function setCharAt(s:String, position:uint, char:String):String
		{
			if (position == 0)
			{
				if (s.length == 1)
					return char;
				return char + s;
			}
			if (position == s.length - 1)
				return s.substr(0, position) + char;
			return s.substr(0, position) + char + s.substr(position + 1);
		}
		if (isNonEmptyString(identifier))
		{
			identifier = identifier.toUpperCase();
			if (identifier.match(/^[A-Z]+$/))
			{
				const n:uint = identifier.length;
				if (position < 0)
					position = n + position;
				const c:String = identifier.charAt(position);
				if (c == "Z")
				{
					identifier = setCharAt(identifier, position, "A");
					if (position == 0)
						return "A" + identifier;
					else
						return incrementIdentifier(identifier, position - 1);
				}
				else
					return setCharAt(identifier, position, String.fromCharCode(c.charCodeAt(0) + 1));
			}
		}
		return "A";
	}
}