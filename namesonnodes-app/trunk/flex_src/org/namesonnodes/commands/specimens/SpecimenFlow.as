package org.namesonnodes.commands.specimens
{
	import a3lbmonkeybrain.brainstem.strings.clean;
	
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.namesonnodes.commands.AbstractCommandFlow;
	import org.namesonnodes.commands.load.LoadAuthorityIdentifier;
	import org.namesonnodes.commands.resolve.ResolveTaxonIdentifier;
	import org.namesonnodes.data.services.CommandService;
	import org.namesonnodes.domain.entities.AuthorityIdentifier;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class SpecimenFlow extends AbstractCommandFlow
	{
		private const assignmentPanel:IdentifierPartsAssignmentPanel = new IdentifierPartsAssignmentPanel();
		private const catalogueFlow:CatalogueFlow = new CatalogueFlow();
		private const service:CommandService = new CommandService();
		private var catalogueID:uint;
		private var catalogueLabel:String;
		private var identifier:String;
		public function SpecimenFlow()
		{
			super();
			assignmentPanel.addEventListener(FaultEvent.FAULT, dispatchEvent);
			assignmentPanel.addEventListener(ResultEvent.RESULT, onAssignmentPanelResult);
			catalogueFlow.addEventListener(FaultEvent.FAULT, dispatchEvent);
			catalogueFlow.addEventListener(ResultEvent.RESULT, onCatalogueFlowResult);
		}
		override public function get flowName() : String
		{
			return "Add a specimen.";
		}
		private function createNewSpecimen():void
		{
			const createSpecimen:CreateSpecimen = new CreateSpecimen();
			createSpecimen.catalogueCommand = new LoadAuthorityIdentifier(catalogueID);
			createSpecimen.identifier = identifier;
			service.executeCommand(createSpecimen)
				.addResponder(new Responder(dispatchEvent, dispatchEvent));
		}
		override public function invoke(input:Object) : void
		{
			try
			{
				if (!matches(input))
					throw new ArgumentError("Invalid specimen identifier: " + input);
				const name:String = clean(String(input));
				const parts:Array = name.split(/[\s-]+/g);
				if (parts.length == 0)
					throw new ArgumentError("Invalid specimen identifier: " + input);
				else if (parts.length == 1)
					useIdentifier(parts[0] as String);
				else assignmentPanel.invoke(parts);
			}
			catch (e:Error)
			{
				handleError(e);
			}
			dispatchEvent(InvokeEvent.createEvent());
		}
		private function onAssignmentPanelResult(event:ResultEvent):void
		{
			if (event.result is Array && event.result.length == 2)
				useCatalogueLabelAndIdentifier(event.result[0] as String, event.result[1] as String);
			else
				dispatchEvent(ResultEvent.createEvent(null));
		}
		private function onCatalogueFlowResult(event:ResultEvent):void
		{
			if (event.result is AuthorityIdentifier)
				useCatalogue(event.result as AuthorityIdentifier);
			else
				dispatchEvent(ResultEvent.createEvent(null));
		}
		private function onResolveResult(event:ResultEvent):void
		{
			if (event.result is TaxonIdentifier)
				dispatchEvent(event);
			else
				createNewSpecimen();
		}
		private function onSelectionPanelResult(event:ResultEvent):void
		{
			useCatalogue(event.result as AuthorityIdentifier);
		}
		override public function matches(input:Object) : Boolean
		{
			if (input == null)
				return false;
			const name:String = clean(String(input));
			return name.length > 0;
		}
		private function useCatalogue(catalogue:AuthorityIdentifier):void
		{
			catalogueID = catalogue.id;
			const qName:String = catalogue.uri + "::" + escape(identifier);
			service.executeCommand(new ResolveTaxonIdentifier(qName))
				.addResponder(new Responder(onResolveResult, dispatchEvent));
		}
		private function useCatalogueLabelAndIdentifier(label:String, identifier:String):void
		{
			if (label == null)
				useIdentifier(identifier);
			else
			{
				try
				{
					catalogueLabel = clean(label);
					this.identifier = clean(identifier);
					catalogueFlow.invoke(catalogueLabel);
				}
				catch (e:Error)
				{
					handleError(e);
				}
			}
		}
		private function useIdentifier(identifier:String):void
		{
			try
			{
				catalogueLabel = null;
				this.identifier = clean(identifier);
				catalogueFlow.invoke(null);
			}
			catch (e:Error)
			{
				handleError(e);
			}
		}
	}
}