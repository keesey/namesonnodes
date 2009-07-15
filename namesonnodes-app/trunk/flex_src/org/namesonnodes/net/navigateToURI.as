package org.namesonnodes.net
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	public function navigateToURI(uri:Object, window:String = "_blank"):void
	{
		const data:URLVariables = new URLVariables();
		data.uri = uri;
		const request:URLRequest = new URLRequest("/namesonnodes/resolve/");
		request.data = data;
		request.method = URLRequestMethod.POST;
		navigateToURL(request, window);
	}
}