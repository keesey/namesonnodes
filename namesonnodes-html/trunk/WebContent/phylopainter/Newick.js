Array.prototype.indexOf = function(item)
{
	var n = this.length;
	for (var i = 0; i < n; i++)
		if (this[i] == item)
			return i;
	return -1;
};
Array.prototype.toString = function()
{
	return "[" + this.join(", ") + "]";
};

function IDElement(id)
{
	this.id = String(id).toUpperCase();
}
IDElement.prototype =
{
	id : "",
	toString : function()
	{
		return this.id;
	}
};

function IDSet()
{
	this._idMap = {};
	this.list = [];
}
IDSet.prototype =
{
	_idMap : null,
	list : null,
	size: 0,
	add : function(element)
	{
		if (element instanceof IDElement && !(this._idMap[element.id] instanceof IDElement))
		{
			this._idMap[element.id.toUpperCase()] = element;
			this.list.push(element);
			++this.size;
		}
	},
	addAll : function(set)
	{
		if (set instanceof IDSet)
			for (var id in set._idMap)
				this.add(set._idMap[id]);
	},
	contains : function(element)
	{
		return element instanceof IDElement && this._idMap[element.id.toUpperCase()] instanceof IDElement; 
	},
	containsID : function(id)
	{
		return this._idMap[id.toUpperCase()] != undefined; 
	},
	forEach : function(callback, thisObject)
	{
		if (callback instanceof Function)
		{
			var n = this.size;
			for (var i = 0; i < n; ++i)
				callback.call(thisObject, this.list[i]);
		}
	},
	getByID : function(id)
	{
		return this._idMap[id.toUpperCase()];
	},
	remove : function(element)
	{
		if (element instanceof IDElement && this._idMap[element.id] instanceof IDElement)
		{
			this._idMap[element.id.toUpperCase()] = undefined;
			this.list.splice(this.list.indexOf(element), 1);
			--this.size;
		}
	},
	removeAll : function(set)
	{
		if (set instanceof IDSet)
			for (var id in set._idMap)
				this.remove(set._idMap[id]);
	},
	sort : function(compareFunction)
	{
		this.list.sort(compareFunction);
		return this.list;
	},
	toString : function()
	{
		return "{" + this.list.join(", ") + "}";
	}
};

// :TODO: DAGSolver

function Node(id)
{
	this.id = (id != null && String(id).length > 0) ? String(id) : ("NODE:" + (Node._nextID++));
	this.id = this.id.toUpperCase();
	if (id != null)
		this.label = String(id);
};
Node._nextID = 1;
Node.prototype = new IDElement("");
Node.prototype.label= "";
Node.prototype.cladeLabel= "";

function Arc(head, tail, weight)
{
	this.id = head.id + ":" + tail.id + ":" + String(weight);
	this.head = head;
	this.tail = tail;
	this.weight = isNaN(weight) ? Number.NaN : weight;
	this._list = [head, tail, weight];
}
Arc.prototype = new IDElement("");
Arc.prototype.head = null;
Arc.prototype.tail = null;
Arc.prototype.weight = Number.NaN;
Arc.prototype._list = null;
Arc.prototype.toArray = function()
{
	return this._list;
};
Arc.prototype.toString = function()
{
	if (isNaN(this.weight))
		return "[" + this.head + ", " + this.tail + "]";
	return "[" + this.head + ", " + this.tail + ", " + this.weight + "]";
};

function Newick(source, resultHandler, errorHandler, progressHandler)
{
	this._index = Newick._nextIndex++;
	Newick._instances[String(this._index)] = this;
	this.nodeStack = [];
	this.position = 0;
	this.graph = [new IDSet(), new IDSet()];
	this.source = String(source);
	this.resultHandler = resultHandler;
	this.errorHandler = errorHandler;
	this.progressHandler = progressHandler;
	this._intervalID = setInterval("Newick._instances[\"" + this._index + "\"]._intervalHandler()", Newick.CYCLE_LENGTH);
};
Newick.MAX_TIME_PER_CYCLE = 200;
Newick.CYCLE_LENGTH = 500;
Newick._nextIndex = 1;
Newick._instances = {};
Newick.prototype =
{
	graph : null,
	_intervalID : 0,
	_index : 0,
	_nextHTUID : 0,
	_cleanUp : function()
	{
		clearInterval(this._intervalID);
		this.target = null;
		this.targetHandler = null;
		Newick._instances[String(this._index)] = null;
		this.nodeStack = null;
		this.source = null;
	},
	_replaceNode : function(oldNode, newNode)
	{
		this.graph[0].remove(oldNode);
		this.graph[1].add(newNode);
		var n = this.graph[1].size;
		for (var i = 0; i < n; ++i)
		{
			var arc = this.graph[1].list[i];
			if (arc.head == oldNode)
				arc.head = newNode;
			else if (arc.tail == oldNode)
				arc.tail = newNode;
		}
	},
	_readClade : function()
	{
		if (this.nodeStack.length == 0)
		{
			this.position = this.source.length;
			return null;
		}
		var nodeInfo = this._readNodeInfo();
		var node = this.nodeStack.pop();
		if (!(node instanceof Node))
			throw new Error("Hierarchy error.");
		if (nodeInfo.name.length != 0)
		{
			node.id = nodeInfo.name.toUpperCase();
			node.cladeLabel = nodeInfo.name;
			if (this.graph[0].containsID(nodeInfo.name))
				this._replaceNode(this.graph[0].getByID(nodeInfo.name), node);
			else
				this.graph[0].add(node);
		}
		else
			this.graph[0].add(node);
		if (this.nodeStack.length != 0)
			this.graph[1].add(new Arc(this.nodeStack[this.nodeStack.length - 1], node, nodeInfo.weight));
		return node;
	},
	_readName : function()
	{
		var name = "";
		var quoted = false;
		while (this.position < this.source.length)
		{
			var token = this.source.charAt(this.position++);
			if (token == "'")
			{
				if (!quoted && name.length != 0)
					name += token;
				quoted = !quoted;
				continue;
			}
			else if (!quoted)
			{
				if (token == ")" || token == "," || token == ":" ||
					token == "(")
				{
					this.position--;
					break;
				}
			}
			if (name.length != 0 || !token.match(/\s/))
				name += token;
		}
		return name.replace(/;$/, '');
	},
	_readNodeInfo : function()
	{
		var name = this._readName();
		var weight = Number.NaN;
		if (name.length > 0 && this.position < this.source.length)
		{
			var token = this.source.charAt(this.position++);
			if (token == ":")
				weight = this._readWeight();
			else
				this.position--;
		}
		return {name: name, weight: weight};
	},
	_readNext : function()
	{
		if (this.position >= this.source.length)
			return;
		var token;
		do
		{
			token = this.source.charAt(this.position++);
		} while (token.match(/\s/));
		if (this.position >= this.source.length)
			return;
		if (token == "(")
		{
			var node = new Node(null);
			this.nodeStack.push(node);
		}
		else if (token == ")")
			this._readClade();
		else if (token == ":")
		{
			this.position--;
			this._readClade();
		}
		else if (token != ",")
		{
			this.position--;
			this._readSink();
		}
	},
	_readSink : function()
	{
		var nodeInfo = this._readNodeInfo();
		if (nodeInfo.name.length == 0)
			throw new Error("Empty name for terminal node at position " + this.position + ".");
		var node;
		if (this.graph[0].containsID(nodeInfo.name))
			node = this.graph[0].getByID(nodeInfo.name);
		else
		{
			node = new Node(nodeInfo.name);
			this.graph[0].add(node);
		}
		if (this.nodeStack.length == 0)
			throw new Error("Hierarchy error.");
		var parent = this.nodeStack[this.nodeStack.length - 1];
		this.graph[1].add(new Arc(parent, node, nodeInfo.weight));
	},
	_readWeight : function()
	{
		var s = "";
		while (this.position < this.source.length)
		{
			var token = this.source.charAt(this.position++);
			if (token == ")" || token == ",")
			{
				this.position--;
				break;
			}
			s += token;
		}
		if (s.length == 0)
			return Number.NaN;
		return parseFloat(s);
	},
	_trackError: function(error)
	{
		if (this.errorHandler != null)
		{
			var event =
			{
				target: this,
				type: "error",
				error: error
			};
			if (this.errorHandler instanceof Function)
				this.errorHandler.call(null, event);
			else if (this.errorHandler.method instanceof Function)
				this.errorHandler.method.call(this.errorHandler.target, event);
		}
	},
	_trackResult: function()
	{
		if (this.resultHandler != null)
		{
			var event =
			{
				target: this,
				type: "result",
				result: this.graph
			};
			if (this.resultHandler instanceof Function)
				this.resultHandler.call(null, event);
			else if (this.resultHandler.method instanceof Function)
				this.resultHandler.method.call(this.resultHandler.target, event);
		}
	},
	_trackProgress: function()
	{
		if (this.progressHandler != null)
		{
			var event =
			{
				target: this,
				type: "progress",
				progress : this.position,
				total : this.source.length
			};
			if (this.progressHandler instanceof Function)
				this.progressHandler.call(null, event);
			else if (this.progressHandler.method instanceof Function)
				this.progressHandler.method.call(this.progressHandler.target, event);
		}
	},
	_intervalHandler : function()
	{
		try
		{
			var start = new Date().getTime();
			while (this.position < this.source.length)
			{
				this._readNext();
				if (this.position == this.source.length && this.nodeStack.length != 0)
					this._readClade();
				if (new Date().getTime() - start >= Newick.MAX_TIME_PER_CYCLE)
				{
					this._trackProgress();
					return;
				}
			}
			this._trackProgress();
			this._trackResult();
		}
		catch (e)
		{
			this._trackError(e);
		}
		finally
		{
			this._cleanUp();
		}
	}
};