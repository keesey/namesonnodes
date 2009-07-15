package org.namesonnodes.commands.nomenclature
{
	import a3lbmonkeybrain.brainstem.collections.HashSet;
	import a3lbmonkeybrain.brainstem.collections.MutableSet;
	import a3lbmonkeybrain.brainstem.strings.capitalize;
	
	import mx.collections.IList;
	import mx.rpc.Fault;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.AbstractCommandFlow;
	import org.namesonnodes.commands.Command;
	import org.namesonnodes.commands.collections.CommandList;
	import org.namesonnodes.commands.collections.ExtractTaxonIdentifierElement;
	import org.namesonnodes.commands.filtration.RankFilter;
	import org.namesonnodes.commands.identity.ExtractTaxa;
	import org.namesonnodes.commands.identity.FindAllEquivalentTaxa;
	import org.namesonnodes.commands.load.LoadTaxon;
	import org.namesonnodes.commands.load.LoadTaxonIdentifier;
	import org.namesonnodes.commands.nomenclature.bacterial.BacteriologicalCode;
	import org.namesonnodes.commands.nomenclature.bacterial.CreateBacterialSpeciesName;
	import org.namesonnodes.commands.nomenclature.botanic.BotanicalCode;
	import org.namesonnodes.commands.nomenclature.botanic.CreateBotanicSpeciesName;
	import org.namesonnodes.commands.nomenclature.zoo.CreateZooSpeciesGroup;
	import org.namesonnodes.commands.nomenclature.zoo.ZoologicalCode;
	import org.namesonnodes.commands.search.EpithetSearch;
	import org.namesonnodes.commands.search.TaxonIdentifierLabelSearch;
	import org.namesonnodes.commands.search.TaxonSearch;
	import org.namesonnodes.commands.select.EntityConfirmPanel;
	import org.namesonnodes.commands.select.SelectionPanel;
	import org.namesonnodes.commands.select.TextInputPanel;
	import org.namesonnodes.commands.summaries.SummarizeAuthorityIdentifiers;
	import org.namesonnodes.commands.summaries.SummarizeTaxa;
	import org.namesonnodes.commands.summaries.SummarizeTaxonIdentifiers;
	import org.namesonnodes.data.services.CommandService;
	import org.namesonnodes.domain.entities.TaxonIdentifier;
	import org.namesonnodes.domain.summaries.SummaryItem;

	public final class SpeciesFlow extends AbstractCommandFlow
	{
		private static const CODE_COMMANDS:Array = [new BacteriologicalCode(),
			new BotanicalCode(), new ZoologicalCode()];
		private static const PATTERN:RegExp = /^([A-Za-z]{2,}-)?[A-Za-z]{2,} [A-Za-z]{2,}$/;
		private const confirmPanel:EntityConfirmPanel = new EntityConfirmPanel();
		private const confirmSynonymPanel:EntityConfirmPanel = new EntityConfirmPanel();
		private const labelSearch:TaxonIdentifierLabelSearch = new TaxonIdentifierLabelSearch();
		private const nameInputPanel:TextInputPanel = new TextInputPanel;
		private const selectCodePanel:SelectionPanel = new SelectionPanel();
		private const selectPanel:SelectionPanel = new SelectionPanel();
		private const selectSynonymPanel:SelectionPanel = new SelectionPanel();
		private const service:CommandService = new CommandService();
		private const taxonSearch:TaxonSearch = new TaxonSearch();
		private var codeCommand:Command;
		private var codeSummaries:IList;
		private var currentSearch:Command;
		private var name:String;
		private var taxonCommand:Command;
		private var typesCommand:Command;
		public function SpeciesFlow()
		{
			super();
			confirmPanel.title = "Did you mean this species name?";
			confirmPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			confirmPanel.addEventListener(ResultEvent.RESULT, onConfirmResult);
			confirmSynonymPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			confirmSynonymPanel.addEventListener(ResultEvent.RESULT, onSynonymSelectionResult);
			with (nameInputPanel)
			{
				maxChars = 128;
				restrict = "A-Za-z--- ";
				title = "Enter a binomial.";
				validatorExpression = PATTERN.source;
			}
			nameInputPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			nameInputPanel.addEventListener(ResultEvent.RESULT, onNameInputResult);
			selectCodePanel.title = "Select a nomenclatural code.";
			selectCodePanel.width = 450;
			selectCodePanel.height = 250;
			selectCodePanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			selectCodePanel.addEventListener(ResultEvent.RESULT, onCodeSelectionResult);
			selectPanel.title = "Did you mean one of these species names?";
			selectPanel.createLabel = "No, create a new species name.";
			selectPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			selectPanel.addEventListener(ResultEvent.RESULT, onSelectionResult);
			selectSynonymPanel.allowCreation = false;
			selectSynonymPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			selectSynonymPanel.addEventListener(ResultEvent.RESULT, onSynonymSelectionResult);
		}
		override public function get flowName() : String
		{
			return "Add a species.";
		}
		private function createNewSpeciesName():void
		{
			var createCommand:Command = null;
			if (codeCommand is BacteriologicalCode)
				createCommand = new CreateBacterialSpeciesName(name, typesCommand, taxonCommand);
			else if (codeCommand is BotanicalCode)
				createCommand = new CreateBotanicSpeciesName(name, typesCommand, taxonCommand);
			else if (codeCommand is ZoologicalCode)
				createCommand = new ExtractTaxonIdentifierElement(new
					CreateZooSpeciesGroup(name.replace("-", ""), typesCommand, taxonCommand), 1);
			if (createCommand == null)
			{
				const fault:Fault = new Fault("No Nomenclatural Code", "No nomenclatural code was selected.");
				dispatchEvent(FaultEvent.createEvent(fault));
				return;
			}
			service.executeCommand(createCommand)
				.addResponder(new Responder(onLoadResult, dispatchEvent));
		}
		private function executeTaxonSearch():void
		{
			taxonSearch.text = name;
			currentSearch = taxonSearch;
			service.executeCommand(new SummarizeTaxonIdentifiers(new RankFilter("species", new FindAllEquivalentTaxa(taxonSearch))))
				.addResponder(new Responder(onSearchResult, dispatchEvent));
		}
		private function getTypes():void
		{
			// :TODO: use a SpecimenSetFlow
			createNewSpeciesName();
		}
		override public function invoke(input:Object) : void
		{
			if (!matches(input))
				nameInputPanel.invoke(null);
			else
				useName(input as String);
		}
		private function loadCodes():void
		{
			service.executeCommand(new SummarizeAuthorityIdentifiers(new CommandList(CODE_COMMANDS)))
				.addResponder(new Responder(onCodesResult, dispatchEvent));
		}
		private function loadTaxonIdentifier(id:uint):void
		{
			service.executeCommand(new LoadTaxonIdentifier(id))
				.addResponder(new Responder(onLoadResult, dispatchEvent));
		}
		override public function matches(input:Object) : Boolean
		{
			return input is String && PATTERN.test(input as String); 
		}
		private function onCodeSelectionResult(event:ResultEvent):void
		{
			if (event.result is SummaryItem)
				useCode(SummaryItem(event.result));
			else
				dispatchEvent(ResultEvent.createEvent(null));
		}
		private function onCodesResult(event:ResultEvent):void
		{
			try
			{
				codeSummaries = event.result as IList;
				selectCodePanel.allowCreation = false;
				selectCodePanel.invoke(event.result);
			}
			catch (e:Error)
			{
				handleError(e);
			}
		}
		private function onConfirmResult(event:ResultEvent):void
		{
			if (event.result is SummaryItem)
				loadTaxonIdentifier(SummaryItem(event.result).id);
			else
				loadCodes();
		}
		private function onLoadResult(event:ResultEvent):void
		{
			dispatchEvent(ResultEvent.createEvent(event.result as TaxonIdentifier));
		}
		private function onNameInputResult(event:ResultEvent):void
		{
			if (event.result is String && PATTERN.test(event.result as String))
				useName(event.result as String);
			else
				dispatchEvent(ResultEvent.createEvent(null));
		}
		private function onSearchResult(event:ResultEvent):void
		{
			if (event.result is IList)
			{
				const collection:IList = event.result as IList;
				if (collection.length == 0)
				{
					if (currentSearch == labelSearch)
						executeTaxonSearch();
					else
						loadCodes();
				}
				else if (collection.length == 1)
					confirmPanel.invoke(collection.getItemAt(0));
				else
					selectPanel.invoke(collection);
			}
			else if (currentSearch == labelSearch)
				executeTaxonSearch();
			else
				loadCodes();
		}
		private function onSelectionResult(event:ResultEvent):void
		{
			if (event.result is TaxonIdentifier)
				dispatchEvent(event);
			else
				loadCodes();
		}
		private function onSynonymSelectionResult(event:ResultEvent):void
		{
			if (event.result is SummaryItem)
			{
				taxonCommand = new LoadTaxon(SummaryItem(event.result).id);
				createNewSpeciesName();
			}
			else
			{
				taxonCommand = null;
				getTypes();
			}
		}
		private static function removeDuplicates(list:IList):void
		{
			const ids:MutableSet = new HashSet();
			var n:int = list.length;
			for (var i:int = 0; i < n; ++i)
			{
				const item:SummaryItem = list.getItemAt(i) as SummaryItem;
				if (ids.has(item.id))
				{
					list.removeItemAt(i);
					--i;
					--n;
				}
				else ids.add(item.id);
			}
		}
		private function onSynonymsResult(event:ResultEvent):void
		{
			if (event.result is IList)
			{
				removeDuplicates(event.result as IList);
				const n:int = IList(event.result).length;
				if (n == 0)
					getTypes();
				else if (n == 1)
					confirmSynonymPanel.invoke(IList(event.result).getItemAt(0));
				else
					selectSynonymPanel.invoke(event.result);
			}
			else getTypes();
		}
		private function useCode(item:SummaryItem):void
		{
			const index:uint = codeSummaries.getItemIndex(item);
			codeCommand = CODE_COMMANDS[index] as Command;
			taxonCommand = null;
			typesCommand = null;
			if (codeCommand == null)
			{
				dispatchEvent(ResultEvent.createEvent(null));
				return;
			}
			if (codeCommand is BotanicalCode)
			{
				confirmSynonymPanel.title = "Is this a nomenclatural synonym?";
				selectSynonymPanel.cancelLabel = "None of these are nomenclatural synonyms.";
				selectSynonymPanel.title = "Select a name below if it is an nomenclatural synonym.";
			}
			else
			{
				confirmSynonymPanel.title = "Is this an objective synonym?";
				selectSynonymPanel.cancelLabel = "None of these are objective synonyms.";
				selectSynonymPanel.title = "Select a name below if it is an objective synonym.";
			}
			const epithet:String = name.split(" ")[1];
			const synonymsCommand:Command = new SummarizeTaxa(new ExtractTaxa(new RankFilter("species", new EpithetSearch(epithet, codeCommand))));
			service.executeCommand(synonymsCommand)
				.addResponder(new Responder(onSynonymsResult, dispatchEvent));
		}
		private function useName(name:String):void
		{
			const parts:Array = name.split(" ", 2);
			const prenomen:String = capitalize(String(parts[0]).toLowerCase().replace(/[^a-z-]/g, ""));
			const epinomen:String = String(parts[1]).toLowerCase().replace(/[^a-z]/g, "");
			this.name = prenomen + " " + epinomen;
			labelSearch.label = name;
			currentSearch = labelSearch;
			service.executeCommand(new SummarizeTaxonIdentifiers(new RankFilter("species", labelSearch)))
				.addResponder(new Responder(onSearchResult, dispatchEvent));
		}
	}
}