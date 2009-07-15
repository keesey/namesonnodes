package org.namesonnodes.html;

import java.util.List;
import java.util.Set;
import org.namesonnodes.domain.Persistent;

public interface EntityHTMLAssistant<E extends Persistent>
{
	public String getAbstract(E entity);
	public String getClassName();
	public String getDescription(E entity);
	public List<Link> getEntityLinks(E entity);
	public List<Link> getExternalLinks(E entity);
	public String getExtraContent(E entity);
	public String getHeader(E entity);
	public Set<String> getKeywords(E entity);
	public String getName(E entity);
	public String getTableName();
}
