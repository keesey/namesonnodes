package org.namesonnodes.commands.specimens
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.AbstractCommandFlow;
	import org.namesonnodes.commands.Command;
	import org.namesonnodes.commands.identity.FindAllEquivalentAuthorities;
	import org.namesonnodes.commands.load.LoadAuthorityIdentifier;
	import org.namesonnodes.commands.search.AuthorityLabelSearch;
	import org.namesonnodes.commands.search.AuthoritySearch;
	import org.namesonnodes.commands.select.EntityConfirmPanel;
	import org.namesonnodes.commands.select.NonSelection;
	import org.namesonnodes.commands.select.SelectionPanel;
	import org.namesonnodes.commands.select.TextInputPanel;
	import org.namesonnodes.commands.summaries.SummarizeAuthorityIdentifiers;
	import org.namesonnodes.data.services.CommandService;
	import org.namesonnodes.domain.summaries.SummaryItem;

	public final class CatalogueFlow extends AbstractCommandFlow
	{
		private const abbrOrNamePanel:TextInputPanel = new TextInputPanel();
		private const authoritySearch:AuthoritySearch = new AuthoritySearch();
		private const confirmPanel:EntityConfirmPanel = new EntityConfirmPanel();
		private const creationPanel:CatalogueCreationPanel = new CatalogueCreationPanel();
		private const labelSearch:AuthorityLabelSearch = new AuthorityLabelSearch();
		private const selectionPanel:SelectionPanel = new SelectionPanel();
		private const service:CommandService = new CommandService();
		private var abbrOrName:String;
		private var currentSearch:Command;
		public function CatalogueFlow()
		{
			super();
			with (abbrOrNamePanel)
			{
				inputToolTip = "You may enter the name of a specimen catalogue, e.g., \"Yale Peabody Museum: Vertebrate Paleontology\", or an abbreviated name, e.g. \"YPM-VP\".";
				noMatchError = "A specimen catalogue's name must start with a capital letter and be at least two characters.";
				requiredFieldError = "Please enter the name or abbreviated name of a specimen catalogue.";
				submitButtonLabel = "Use this catalogue name/abbreviation.";
				title = "Enter the name or abbreviated name of specimen catalogue.";
				validatorExpression = "^[A-Z].+$";
			}
			abbrOrNamePanel.addEventListener(ResultEvent.RESULT, onAbbrOrNamePanelResult);
			abbrOrNamePanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			confirmPanel.title = "Use this authority?";
			confirmPanel.addEventListener(ResultEvent.RESULT, onConfirmPanelResult);
			confirmPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			creationPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			creationPanel.addEventListener(ResultEvent.RESULT, dispatchEvent);
			selectionPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			selectionPanel.addEventListener(ResultEvent.RESULT, onSelectionPanelResult);
		}
		override public function get flowName() : String
		{
			return "Add a specimen catalogue.";
		}
		private function createCatalogue():void
		{
			try
			{
				creationPanel.invoke(abbrOrName);
			}
			catch (e:Error)
			{
				handleError(e);
			}
		}
		private function executeAuthoritySearch():void
		{
			authoritySearch.text = abbrOrName;
			currentSearch = authoritySearch;
			executeCurrentSearch();
		}
		private function executeCurrentSearch():void
		{
			try
			{
				service.executeCommand(new SummarizeAuthorityIdentifiers(new FindAllEquivalentAuthorities(currentSearch)))
					.addResponder(new Responder(onSearchResult, dispatchEvent));
			}
			catch (e:Error)
			{
				handleError(e);
			}
		}
		override public function invoke(input:Object) : void
		{
			try
			{
				if (input == null || (input is String && clean(input as String) == ""))
					abbrOrNamePanel.invoke(null);
				else if (!matches(input))
					throw new ArgumentError("Invalid catalogue name: " + input);
				else
					useAbbrOrName(input as String);
			}
			catch (e:Error)
			{
				handleError(e);
			}
			dispatchEvent(new InvokeEvent(InvokeEvent.INVOKE));
		}
		private function loadCatalogue(id:uint):void
		{
			service.executeCommand(new LoadAuthorityIdentifier(id))
				.addResponder(new Responder(dispatchEvent, dispatchEvent));
		}
		override public function matches(input:Object) : Boolean
		{
			return input is String && clean(String(input)).match(/^[A-Za-z].+$/);
		}
		private function onAbbrOrNamePanelResult(event:ResultEvent):void
		{
			useAbbrOrName(event.result as String);
		}
		private function onConfirmPanelResult(event:ResultEvent):void
		{
			if (event.result is SummaryItem)
				loadCatalogue(SummaryItem(event.result).id);
			else if (currentSearch == labelSearch)
				executeAuthoritySearch();
			else
				createCatalogue();
		}
		private function onSearchResult(event:ResultEvent):void
		{
			const list:ArrayCollection = event.result as ArrayCollection;
			try
			{
				if (list == null || list.length == 0)
				{
					if (currentSearch == labelSearch)
						executeAuthoritySearch();
					else
						createCatalogue();
				}
				else if (list.length == 1 && list[0] is SummaryItem)
					confirmPanel.invoke(list[0]);
				else
					selectionPanel.invoke(list);
			}
			catch (e:Error)
			{
				handleError(e);
			}
		}
		private function onSelectionPanelResult(event:ResultEvent):void
		{
			if (event.result is SummaryItem)
				loadCatalogue(SummaryItem(event.result).id);
			else if (event.result == NonSelection.CREATE)
				createCatalogue();
			else
				dispatchEvent(ResultEvent.createEvent());
		}
		private function useAbbrOrName(abbrOrName:String):void
		{
			this.abbrOrName = abbrOrName == null ? null : clean(abbrOrName);
			if (this.abbrOrName == null || this.abbrOrName == "")
				abbrOrNamePanel.invoke(null);
			else
			{
				labelSearch.label = this.abbrOrName;
				currentSearch = labelSearch;
				executeCurrentSearch();
			}
		}
	}
}