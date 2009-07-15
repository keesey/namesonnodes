package org.namesonnodes.domain.entities;

import static javax.persistence.FetchType.EAGER;
import static org.hibernate.annotations.CascadeType.MERGE;
import static org.hibernate.annotations.CascadeType.PERSIST;
import static org.hibernate.annotations.CascadeType.REFRESH;
import static org.hibernate.annotations.CascadeType.SAVE_UPDATE;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Lob;
import javax.persistence.ManyToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import org.hibernate.annotations.Cascade;
import org.hibernate.validator.Size;
import org.namesonnodes.validators.xml.XML;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
// :TODO: Validate specifiers.
public final class PhyloDefinition extends Definition
{
	private String formula;
	private String prose;
	private Set<TaxonIdentifier> specifiers = new HashSet<TaxonIdentifier>();
	public PhyloDefinition()
	{
		super();
	}
	@Lob
	@XML(targetNamespace = "http://www.w3.org/1998/Math/MathML", message = "Formula must be valid MathML 2.0.")
	public final String getFormula()
	{
		return formula;
	}
	@Lob
	@XML(targetNamespace = "http://www.w3.org/1999/xhtml", rootNodeName = "span", message = "Prose must be text with optional HTML markup (\"b\", \"i\", \"u\").")
	public final String getProse()
	{
		return prose;
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH }, fetch = EAGER)
	@Size(min = 1, message = "A phylogenetic definition must have at least one specifier.")
	public final Set<TaxonIdentifier> getSpecifiers()
	{
		return specifiers;
	}
	public final void setFormula(final String formula)
	{
		this.formula = formula;
	}
	public final void setProse(final String prose)
	{
		this.prose = prose;
	}
	public final void setSpecifiers(final Set<TaxonIdentifier> specifiers)
	{
		this.specifiers = specifiers;
	}
	@Override
	protected String toFormulaString()
	{
		return prose == null ? "<no prose>" : "\"" + prose.replaceAll("\"", "'") + "\"";
	}
}
