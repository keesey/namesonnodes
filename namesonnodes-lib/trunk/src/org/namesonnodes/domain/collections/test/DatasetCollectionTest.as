package org.namesonnodes.domain.collections.test
{
	import a3lbmonkeybrain.brainstem.collections.FiniteSet;
	
	import flexunit.framework.TestCase;
	
	import org.namesonnodes.domain.collections.DatasetCollection;
	import org.namesonnodes.domain.collections.Node;
	import org.namesonnodes.domain.entities.Authority;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.entities.Dataset;
	import org.namesonnodes.domain.entities.Heredity;
	import org.namesonnodes.domain.entities.Label;
	import org.namesonnodes.domain.entities.RankDefinition;
	import org.namesonnodes.domain.entities.SpecimenDefinition;
	import org.namesonnodes.domain.entities.Taxon;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	
	public class DatasetCollectionTest extends TestCase
	{
		private static const datasets:Vector.<Dataset> = createDatasets();
		private static const classAuthority:AuthorityIdentifier = AuthorityIdentifier.create(Authority.create("DatasetCollection Test"),
			"org.namesonnodes.domain.collections.test.DatasetCollectionTest");
		public function DatasetCollectionTest(methodName:String=null)
		{
			super(methodName);
		}
		private static function createClassAuthority():AuthorityIdentifier
		{
			const id:AuthorityIdentifier = new AuthorityIdentifier();
			id.entity = new Authority();
			id.entity.id = 1;
			id.entity.label.name = "DatasetCollection Test";
			id.uri = "org.namesonnodes.domain.collections.test.DatasetCollectionTest";
			return id;
		}
		private static function createDatasets():Vector.<Dataset>
		{
			const Linnaeus:TaxonIdentifier = TaxonIdentifier.create(classAuthority,
				Label.create("Carolus Linnaeus", "Linnaeus"),
				"specimen:Carolus%20Linnaeus", Taxon.create(new SpecimenDefinition())); 
			const Homo_sapiens:TaxonIdentifier = TaxonIdentifier.create(classAuthority, 
				Label.create("Homo sapiens", "H. sapiens", true), "Homo%20sapiens",
				Taxon.create(RankDefinition.create("species", 1.0, [Linnaeus]))); 
			const Homo:TaxonIdentifier = TaxonIdentifier.create(classAuthority, Label.create("Homo", null, true), "Homo",
				Taxon.create(RankDefinition.create("genus", 2.0, [Homo_sapiens])));
			const Simia_troglodytes:TaxonIdentifier = TaxonIdentifier.create(classAuthority, 
				Label.create("Simia troglodytes", "S. troglodytes", true), "Simia%20troglodytes",
				Taxon.create(RankDefinition.create("species", 1.0))); 
			const Pan_troglodytes:TaxonIdentifier = TaxonIdentifier.create(classAuthority, 
				Label.create("Pan troglodytes", "P. troglodytes", true), "Pan%20troglodytes", Simia_troglodytes.entity);
			const Pan:TaxonIdentifier = TaxonIdentifier.create(classAuthority, Label.create("Pan", null, true), "Pan",
				Taxon.create(RankDefinition.create("genus", 2.0, [Pan_troglodytes])));
			const anc1:TaxonIdentifier = TaxonIdentifier.create(classAuthority, Label.create(null), "anc:1", new Taxon());
			const anc2:TaxonIdentifier = TaxonIdentifier.create(classAuthority, Label.create(null), "anc:2", new Taxon());
			const speciesPhylogeny:Dataset = Dataset.create(classAuthority, Label.create("Species Phylogeny"), "datasets:0", 1.0);
			speciesPhylogeny.heredities.addItem(Heredity.create(anc1, Homo_sapiens, 275000));
			speciesPhylogeny.heredities.addItem(Heredity.create(anc1, Simia_troglodytes, 550000));
			const genusPhylogeny:Dataset = Dataset.create(classAuthority, Label.create("Genus Phylogeny"), "datasets:1", 1.0);
			genusPhylogeny.heredities.addItem(Heredity.create(anc2, Homo, 250000));
			genusPhylogeny.heredities.addItem(Heredity.create(anc2, Pan, 520000));
			const datasets:Vector.<Dataset> = new Vector.<Dataset>(2);
			datasets[0] = speciesPhylogeny;
			datasets[1] = genusPhylogeny;
			return datasets;
		}
		public function testDatasetCollection():void
		{
			new DatasetCollection(datasets);
		}
		public function testDatasetDistance():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		
		public function testGenerationDistance():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		
		public function testImmediatePredecessors():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		
		public function testImmediateSuccessors():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		
		public function testInterpretQName():void
		{
			const collection:DatasetCollection = new DatasetCollection(datasets);
			const Homo:FiniteSet = collection.interpretQName("org.namesonnodes.domain.collections.test.DatasetCollectionTest::Homo"); 
			assertNotNull(Homo);
			assertEquals(Homo.size, 1);
			assertEquals(Node(Homo.singleMember).identifiers.size, 1);
			assertEquals(TaxonIdentifier(Node(Homo.singleMember).identifiers.singleMember).label.name, "Homo sapiens");
		}
	}
}