package org.namesonnodes.domain.entities;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import org.apache.solr.analysis.ISOLatin1AccentFilterFactory;
import org.apache.solr.analysis.LowerCaseFilterFactory;
import org.apache.solr.analysis.StandardTokenizerFactory;
import org.hibernate.search.annotations.Analyzer;
import org.hibernate.search.annotations.AnalyzerDef;
import org.hibernate.search.annotations.Field;
import org.hibernate.search.annotations.Index;
import org.hibernate.search.annotations.TokenFilterDef;
import org.hibernate.search.annotations.TokenizerDef;
import org.hibernate.validator.Length;
import org.hibernate.validator.NotNull;

@Embeddable
@AnalyzerDef(name = "nameAnalyzer", tokenizer = @TokenizerDef(factory = StandardTokenizerFactory.class), filters = {
        @TokenFilterDef(factory = LowerCaseFilterFactory.class),
        @TokenFilterDef(factory = ISOLatin1AccentFilterFactory.class) })
// @TokenFilterDef(factory = SnowballPorterFilterFactory.class, params = {
// @Parameter(name = "language", value = "English") }) })
public final class Label implements Cloneable
{
	private String abbr;
	private boolean italics;
	private String name;
	public Label()
	{
		super();
	}
	public Label(final String name)
	{
		super();
		this.name = name;
	}
	public Label(final String name, final String abbr)
	{
		super();
		this.name = name;
		this.abbr = abbr;
	}
	public Label(final String name, final String abbr, final boolean italics)
	{
		this(name, abbr);
		this.italics = italics;
	}
	@Override
	public Label clone()
	{
		final Label label = new Label();
		label.setAbbr(abbr);
		label.setItalics(italics);
		label.setName(name);
		return label;
	}
	@Analyzer(definition = "nameAnalyzer")
	@Column(length = 64, nullable = true)
	@Field(index = Index.TOKENIZED)
	public String getAbbr()
	{
		return abbr;
	}
	@Basic
	public final boolean getItalics()
	{
		return italics;
	}
	@Analyzer(definition = "nameAnalyzer")
	@Column(length = 256)
	@Field(index = Index.TOKENIZED)
	@Length(max = 256, message = "Name too long.")
	@NotNull(message = "No name.")
	public String getName()
	{
		return name;
	}
	public final void setAbbr(final String abbr)
	{
		if (abbr == "")
			setAbbr(null);
		else
			this.abbr = abbr;
	}
	public final void setItalics(final boolean italics)
	{
		this.italics = italics;
	}
	public final void setName(final String name)
	{
		this.name = name;
	}
	public final String shortestLabel()
	{
		if (abbr != null)
			return abbr;
		return name;
	}
	public String toHTMLText()
	{
		if (italics)
			return "<i>" + (name == null ? "" : name) + "</i>";
		return name == null ? "" : name;
	}
	public String toShortHTMLText()
	{
		final String abbrOrName = abbr == null ? (name == null ? "" : name) : abbr;
		if (italics)
			return "<i>" + abbrOrName + "</i>";
		return abbrOrName;
	}
	@Override
	public String toString()
	{
		return name == null ? "<no name>" : "\"" + name + "\"";
	}
}
