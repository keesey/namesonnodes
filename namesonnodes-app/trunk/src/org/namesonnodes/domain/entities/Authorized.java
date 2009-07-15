package org.namesonnodes.domain.entities;

import org.namesonnodes.domain.Persistent;

public interface Authorized extends Persistent
{
	public AuthorityIdentifier getAuthority();
	public void setAuthority(AuthorityIdentifier authority);
}
