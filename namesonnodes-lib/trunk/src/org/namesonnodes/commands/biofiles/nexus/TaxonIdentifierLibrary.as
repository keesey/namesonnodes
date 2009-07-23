package org.namesonnodes.commands.biofiles.nexus
{
	import flash.utils.Dictionary;
	
	import mx.events.PropertyChangeEvent;
	
	import org.namesonnodes.commands.biofiles.BioFileError;
	import org.namesonnodes.domain.entities.TaxonIdentifier;

	public final class TaxonIdentifierLibrary
	{
		private const _identifiers:Vector.<TaxonIdentifier> = new Vector.<TaxonIdentifier>(); 
		private const localNameMap:Dictionary = new Dictionary();
		private var _number:uint;
		public function TaxonIdentifierLibrary()
		{
			super();
		}
		public function get number():uint
		{
			return _number;
		}
		public function set number(v:uint):void
		{
			_number = v;
		}
		public function get identifiers():Vector.<TaxonIdentifier>
		{
			return _identifiers;
		}
		public function add(v:TaxonIdentifier):TaxonIdentifier
		{
			const existing:* = localNameMap[v.localName];
			if (existing is TaxonIdentifier)
				return existing as TaxonIdentifier;
			v.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
			_identifiers.push(v);
			trace("[NOTICE]", "Added taxon: " + v.label.name, "<" + v.localName + ">");
			return v;
		}
		public function clear():void
		{
			_number = 0;
			for (var key:* in localNameMap)
				localNameMap[key] = undefined;
			while (_identifiers.length != 0)
				_identifiers.shift();
		}
		public function getByIndex(i:int):TaxonIdentifier
		{
			if (i >= _identifiers.length)
				return null;
			return _identifiers[i];
		}
		public function getByLocalName(localName:String):TaxonIdentifier
		{
			const v:* = localNameMap[localName];
			return v is TaxonIdentifier ? v as TaxonIdentifier : null;
		}
		public function indexOf(identifier:TaxonIdentifier):int
		{
			return _identifiers.indexOf(identifier);
		}
		private function onPropertyChange(event:PropertyChangeEvent):void
		{
			if (event.property == "localName")
			{
				if (localNameMap[event.newValue] is TaxonIdentifier)
					_identifiers.splice(_identifiers.indexOf(event.target), 1);
				else
				{
					localNameMap[event.oldValue] = undefined;
					localNameMap[event.newValue] = event.target;
				}
			}
		}
		public function setByIndex(index:uint, identifier:TaxonIdentifier):void
		{
			if (index >= number)
				throw new BioFileError("Taxon index too high: " + index);
			if (_identifiers.length > index && _identifiers[index] is TaxonIdentifier)
				throw new BioFileError("Attempt to replace an existing taxon identifier.");
			if (localNameMap[identifier.localName] is TaxonIdentifier)
				throw new BioFileError("Qualified name conflict: " + identifier.localName);
			while (_identifiers.length <= index)
				_identifiers.push(null);
			_identifiers[index] = identifier;
			localNameMap[identifier.localName] = identifier;
		}
	}
}