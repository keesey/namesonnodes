package org.namesonnodes.utils
{
	public function parseQName(s:String):QName
	{
		if (s == null) return null;
		const parts:Array = s.split("::", 2);
		while (parts.length < 2)
			parts.unshift("");
		return new QName(parts[0], parts[1]);
	}
}