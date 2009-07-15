package org.namesonnodes.domain.entities
{
	public interface Authorized
	{
		function get authority():AuthorityIdentifier;
		function set authority(value:AuthorityIdentifier):void;
	}
}