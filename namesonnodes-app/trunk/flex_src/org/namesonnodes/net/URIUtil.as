package org.namesonnodes.net
{
	
	
	public final class URIUtil
	{
		public static const REG_EXP_SOURCE:String = "^(([^:\/?#]+):)?(\/\/([^\/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?$";
		public static const REG_EXP:RegExp = new RegExp(REG_EXP_SOURCE);
		public static function fixURI(uri:String):String
		{
			if (uri == null || uri == "")
				return uri;
			uri = uri.replace(/\s+/g, "");
			uri = uri.replace(/\/$/, "");
			if (uri.match(/^www\./i))
				return "http://www." + uri.substr(4);
			if (uri.match(/^doi:10./i))
				return "urn:doi:" + uri.substr(4);
			if (uri.match(/^10./))
				return "urn:doi:" + uri;
			if (uri.match(/^pubmed:/i))
				return "urn:lsid:ncbi.nlm.nih.gov:pubmed:" + uri.substr(7);
			if (uri.match(/^pmid:/i))
				return "urn:lsid:ncbi.nlm.nih.gov:pubmed:" + uri.substr(5);
			if (uri.match(/^lsid:/i))
				return "urn:lsid:" + uri.substr(5);
			if (uri.match(/^isbn:/i))
				return "urn:isbn:" + uri.substr(5);
			if (uri.match(/^issn:/i))
				return "urn:issn:" + uri.substr(5);
			if (uri.match(/^mailto:/i))
				return "mailto:" + uri.substr(7);
			if (uri.match(/^[^@]+@[^@]$/))
				return "mailto:" + uri;
			if (!isAbsolute(uri))
				return "http://" + uri;
			return uri;
		}
		public static function isAbsolute(uri:String):Boolean
		{
			return uri != null && uri.match(REG_EXP);
		}
	}
}