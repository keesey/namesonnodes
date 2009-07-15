package org.namesonnodes.domain.entities;

import static javax.persistence.FetchType.EAGER;
import static org.hibernate.annotations.CascadeType.MERGE;
import static org.hibernate.annotations.CascadeType.PERSIST;
import static org.hibernate.annotations.CascadeType.REFRESH;
import static org.hibernate.annotations.CascadeType.SAVE_UPDATE;
import static org.namesonnodes.utils.CollectionUtil.join;
import java.util.HashSet;
import java.util.Set;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.ManyToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import org.hibernate.annotations.Cascade;
import org.hibernate.validator.Length;
import org.hibernate.validator.NotNull;
import org.hibernate.validator.Pattern;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
public final class RankDefinition extends Definition
{
	private double level;
	private String rank;
	private Set<TaxonIdentifier> types = new HashSet<TaxonIdentifier>();
	public RankDefinition()
	{
		super();
	}
	public RankDefinition(final String rank)
	{
		super();
		setRank(rank);
	}
	public RankDefinition(final String rank, final double level)
	{
		this(rank);
		setLevel(level);
	}
	@Basic
	@NotNull(message = "Ranks must be associated with a decimal level (0.95 = subspecies, 1.0 = species, 1.05 = superspecies, 1.95 = subgenus, 2.0 = genus, ... 7.0 = regnum)")
	public double getLevel()
	{
		return level;
	}
	@Column(length = 64)
	@Length(min = 1, max = 64, message = "Empty rank for rank-based definition, or rank name too long.")
	@Pattern(regex = "^[a-z]+$", message = "Invalid rank for rank-based definition.")
	@NotNull(message = "No rank for rank-based definition.")
	public String getRank()
	{
		return rank;
	}
	@Cascade( { MERGE, PERSIST, REFRESH, SAVE_UPDATE })
	@ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH }, fetch = EAGER)
	public final Set<TaxonIdentifier> getTypes()
	{
		return types;
	}
	public void setLevel(final double level)
	{
		this.level = level;
	}
	public void setRank(final String rank)
	{
		this.rank = rank.toLowerCase().trim();
	}
	public final void setTypes(final Set<TaxonIdentifier> types)
	{
		this.types = types;
	}
	@Override
	public String toFormulaString()
	{
		return (rank == null || rank.length() == 0 ? "<no rank>" : rank) + "(" + join(getTypes(), ", ") + ")";
	}
}
