function Rectangle(x, y, w, h)
{
	this.x = x;
	this.y = y;
	this.w = w;
	this.h = h;
};
Rectangle.prototype =
{
	bottom : function()
	{
		return this.y + this.h;
	},
	centerX : function()
	{
		return this.x + this.w / 2;
	},
	centerY : function()
	{
		return this.y + this.h / 2;
	},
	top : function()
	{
		return this.y;
	},
	left : function()
	{
		return this.x;
	},
	right : function()
	{
		return this.x + this.w;
	},
	intersects : function(that)
	{
		return this.x < that.right() && this.right() > that.x && this.y < that.bottom() && this.bottom() > that.y;
	},
	toString : function()
	{
		return "[Rectangle (" + this.x + ", " + this.y + ") " + this.w + " x " + this.h + "]";
	}
};

function PhyloPainter(graph, canvas)
{
	this.graph = graph;
	this.canvas = canvas;
	this._context = canvas.getContext('2d');
	this._untraversedSinks = new IDSet();
	this._initRectangles();
	this._xSort();
	this._ySort();
	this._removeOverlap();
	this._cleanUp();
};
PhyloPainter.FONT_SIZE = 12;
PhyloPainter.HGAP = 12;
PhyloPainter.PADDING = 6;
PhyloPainter.VGAP = 6;
PhyloPainter.compareRectangles = function(a, b)
{
	return a.bottom() - b.bottom();
};
PhyloPainter.prototype =
{
	canvas: null,
	graph: null,
	_context : null,
	_nodeRectangles : null,
	_nextSinkY : 0,
	_traversed : null,
	_untraversedSinks : null,
	render : function()
	{
		this.canvas.width = this.maxRight;
		this.canvas.height = this.maxBottom;
		this._context.clearRect(0, 0, this._context.canvas.width, this._context.canvas.height);
		this._context.lineWidth = 1;
		this._context.strokeStyle = "rgb(0, 0, 0)";
		this._renderArcs();
		this._renderNodes();
	},
	_drawCircle : function(r)
	{
		this._context.strokeStyle = "rgb(0, 0, 0)";
		this._context.fillStyle = "rgb(0, 0, 0)";
		this._context.beginPath();
		this._context.arc(r.x + PhyloPainter.PADDING, r.centerY(), PhyloPainter.PADDING, 0, Math.PI * 2, false);
		this._context.fill();
		this._context.stroke();
		this._context.closePath();
	},
	_drawRoundRect : function(r)
	{
		this._context.strokeStyle = "rgb(0, 0, 0)";
		this._context.fillStyle = "rgb(0, 0, 0)";
		this._context.beginPath();
		this._context.moveTo(r.x, r.y + PhyloPainter.PADDING);
		this._context.quadraticCurveTo(r.x, r.y, r.x + PhyloPainter.PADDING, r.y);
		this._context.lineTo(r.right() - PhyloPainter.PADDING, r.y);
		this._context.quadraticCurveTo(r.right(), r.y, r.right(), r.y + PhyloPainter.PADDING);
		this._context.lineTo(r.right(), r.bottom() - PhyloPainter.PADDING);
		this._context.quadraticCurveTo(r.right(), r.bottom(), r.right() - PhyloPainter.PADDING, r.bottom());
		this._context.lineTo(r.x + PhyloPainter.PADDING, r.bottom());
		this._context.quadraticCurveTo(r.x, r.bottom(), r.x, r.bottom() - PhyloPainter.PADDING);
		this._context.lineTo(r.x, r.y + PhyloPainter.PADDING);
		this._context.fill();
		this._context.stroke();
		this._context.closePath();
	},
	_cleanUp : function()
	{
		this._traversed = null;
		this._untraversedSinks = null;
	},
	_renderArcs : function()
	{
		this._context.strokeStyle = "rgb(0, 0, 0)";
		this._context.lineWidth = 1.5;
		this.graph[1].forEach(this._renderArc, this);
	},
	_renderNodes : function()
	{
		this._context.lineWidth = 1;
		this.graph[0].forEach(this._renderNode, this);
	},
	_renderArc : function(arc)
	{
		var parentRectangle = this._nodeRectangles[arc.head.id];
		if (!parentRectangle)
			throw new Error("No rectangle for node: " + arc.head + ".");
		var childRectangle = this._nodeRectangles[arc.tail.id];
		if (!childRectangle)
			throw new Error("No rectangle for node: " + arc.tail + ".");
		this._context.beginPath();
		var parentX = arc.head.label.length == 0 ? (parentRectangle.x + PhyloPainter.PADDING) : parentRectangle.centerX();
		this._context.moveTo(parentX, parentRectangle.centerY());
		this._context.quadraticCurveTo(parentX, childRectangle.centerY(), childRectangle.x - PhyloPainter.PADDING, childRectangle.centerY());
		this._context.stroke();
		this._context.beginPath();
		this._context.fillStyle = "rgb(0, 0, 0)";
		this._context.lineTo(childRectangle.x - PhyloPainter.PADDING, childRectangle.centerY() - (PhyloPainter.PADDING >> 1));
		this._context.lineTo(childRectangle.x - PhyloPainter.PADDING, childRectangle.centerY() + (PhyloPainter.PADDING >> 1));
		this._context.lineTo(childRectangle.x, childRectangle.centerY());
		this._context.fill();
	},
	_renderNode : function(node)
	{
		var r = this._nodeRectangles[node.id];
		if (!r)
			throw new Error("No rectangle for node: " + node + ".");
		if (node.label.length)
		{
			this._drawRoundRect(r);
			this._context.textAlign = "center";
			this._context.textBaseline = "middle";
			this._context.font = "italic 12px sans-serif";
			this._context.fillStyle = "rgb(255, 255, 255)";
			this._context.fillText(node.label, r.centerX(), r.centerY());
		}
		else
			this._drawCircle(r);
		if (node.cladeLabel.length)
		{
			var leftX = r.x + PhyloPainter.PADDING * 2.5;
			var metrics = this._context.measureText(node.cladeLabel);
			this._context.fillStyle = "rgba(255, 255, 255, 0.75)";
			this._context.fillRect(leftX, r.y + PhyloPainter.PADDING, metrics.width, PhyloPainter.FONT_SIZE);
			this._context.textAlign = "left";
			this._context.textBaseline = "middle";
			this._context.font = "italic 12px sans-serif";
			this._context.fillStyle = "rgb(0, 0, 0)";
			this._context.fillText(node.cladeLabel, leftX, r.centerY());
		}
	},
	_initRectangle : function(node)
	{
		var r = this._createNodeRectangle(node);
		this._nodeRectangles[node.id] = r;
	},
	_initRectangles : function()
	{
		this._nodeRectangles = {};
		this.graph[0].forEach(this._initRectangle, this);
	},
	_createNodeRectangle : function(node)
	{
		var p = PhyloPainter.PADDING << 1;
		var r = new Rectangle(0, 0, p, p);
		var metrics;
		var hasLabel = node.label.length != 0;
		var hasCladeLabel = node.cladeLabel.length != 0;
		if (hasLabel || hasCladeLabel)
			this._context.font = "italic 12px sans-serif";
		if (hasLabel)
		{
			metrics = this._context.measureText(node.label);
			r.w += metrics.width;
		}
		if (hasCladeLabel)
		{
			metrics = this._context.measureText(node.cladeLabel);
			r.w += metrics.width + PhyloPainter.PADDING;
		}
		if (hasLabel || hasCladeLabel)
			r.h += PhyloPainter.FONT_SIZE;
		return r;
	},
	// :TODO: move to IDDigraphSolver class
	_arcsFrom : function(node)
	{
		var arcs = [];
		var n = this.graph[1].size;
		for (var i = 0; i < n; ++i)
		{
			var arc = this.graph[1].list[i];
			if (arc.head == node)
				arcs.push(arc);
		}
		return arcs;
	},
	// :TODO: move to IDDigraphSolver class
	_arcsTo : function(node)
	{
		var arcs = [];
		var n = this.graph[1].size;
		for (var i = 0; i < n; ++i)
		{
			var arc = this.graph[1].list[i];
			if (arc.tail == node)
				arcs.push(arc);
		}
		return arcs;
	},
	_collapseNonSinkX : function(node)
	{
		if (this._traversed.contains(node))
			return;
		this._traversed[node.id] = node.id;
		var nodeRectangle = this._nodeRectangles[node.id];
		if (!nodeRectangle)
			return;
		var arcsFrom = this._arcsFrom(node);
		var n = arcsFrom.length;
		if (n == 0)
			return;
		var x = Number.MAX_VALUE;
		for (var i = 0; i < n; ++i)
		{
			var arc = arcsFrom[i];
			this._collapseNonSinkX(arc.tail);
			var childRectangle =
				this._nodeRectangles[arc.tail.id];
			if (childRectangle == undefined)
				continue;
			var childX =
				childRectangle.x - PhyloPainter.HGAP - nodeRectangle.w;
			x = Math.min(x, childX);
		}
		if (x != Number.MAX_VALUE)
			nodeRectangle.x = x;
	},
	_sinks : function()
	{
		if (this._sinks_result)
			return this._sinks_result;
		this._sinks_result = new IDSet();
		this._sinks_result.addAll(this.graph[0]);
		var n = this.graph[1].size;
		for (var i = 0; i < n; ++i)
		{
			var nonSink = this.graph[1].list[i].head;
			this._sinks_result.remove(nonSink);
		}
		return this._sinks_result;
	},
	_sources : function()
	{
		if (this._sources_result)
			return this._sources_result;
		this._sources_result = new IDSet();
		this._sources_result.addAll(this.graph[0]);
		var n = this.graph[1].size;
		for (var i = 0; i < n; ++i)
		{
			var nonSource = this.graph[1].list[i].tail;
			this._sources_result.remove(nonSource);
		}
		return this._sources_result;
	},
	_collapseNonSinksX : function()
	{
		this._sinks().forEach(this._collapseNonSinkX, this);
	},
	_compareNodes : function(a, b)
	{
		if (a == b || a.id == b.id)
			return 0;
		var aRectangle = this._nodeRectangles[a.id];
		var bRectangle = this._nodeRectangles[b.id];
		var rectangleCompare;
		if (aRectangle == null)
		{
			if (bRectangle == null)
				rectangleCompare = 0;
			else
				rectangleCompare = -1;
		}
		else if (bRectangle == null)
			rectangleCompare = 1;
		else
			rectangleCompare = PhyloPainter.compareRectangles(aRectangle, bRectangle);
		if (rectangleCompare != 0)
			return rectangleCompare;
		if (a.id < b.id)
			return -1;
		if (b.id < a.id)
			return 1;
		return 0;
	},
	_removeOverlap : function()
	{
		var n = this.graph[0].size;
		if (n == 0)
			return;
		var rectangles = [];
		var i;
		for (i = 0; i < n; ++i)
			rectangles.push(this._nodeRectangles[this.graph[0].list[i].id]);
		rectangles.sort(PhyloPainter.compareRectangles);
		for (i = 1; i < n; ++i)
			for (var h = 0; h < i; ++h)
				if (rectangles[h].intersects(rectangles[i]))
				{
					var offset = rectangles[h].bottom() + PhyloPainter.VGAP - rectangles[i].y;
					for (var j = i; j < n; ++j)
						rectangles[j].y += offset;
				}
		var lastRectangle = rectangles[rectangles.length - 1];
		this.maxBottom = lastRectangle.bottom() + PhyloPainter.VGAP;
	},
	_setNonSinkY : function(node)
	{
		if (this._traversed.contains(node))
			return;
		this._traversed.add(node);
		var arcsFrom = this._arcsFrom(node);
		var n = arcsFrom.length;
		if (n == 0)
			return;
		var ySum = 0;
		var numChildren = n;
		for (var i = 0; i < n ; ++i)
		{
			var arc = arcsFrom[i];
			var child = arc.tail;
			this._setNonSinkY(child);
			var childRectangle = this._nodeRectangles[child.id];
			if (!childRectangle)
				numChildren--;
			else
				ySum += childRectangle.centerY();
		}
		var rectangle = this._nodeRectangles[node.id];
		rectangle.y = (numChildren == 0) ? 0 : (ySum / numChildren - rectangle.h / 2);
	},
	_setNonSinksY : function()
	{
		var sinks = this._sinks();
		var n = this.graph[0].size;
		for (var i = 0; i < n; ++i)
		{
			var node = this.graph[0].list[i];
			if (!sinks.contains(node))
				this._setNonSinkY(node);
		}
	},
	_setNonSourceX : function(node)
	{
		if (this._traversed.contains(node))
			return;
		var arcsTo = this._arcsTo(node);
		var x = 0;
		var n = arcsTo.length;
		if (n != 0)
		{
			var numParents = n;
			for (var i = 0; i < n; ++i)
			{
				var arc = arcsTo[i];
				var parentRectangle = this._nodeRectangles[arc.head.id];
				if (!(parentRectangle instanceof Rectangle))
					numParents--;
				else
				{
					this._setNonSourceX(arc.head);
					x = Math.max(x, parentRectangle.x + parentRectangle.w + PhyloPainter.HGAP);
				}
			}
		}
		var rectangle = this._nodeRectangles[node.id];
		if (rectangle)
		{
			rectangle.x = x;
			rectangle.y = 0;
			this.maxRight = Math.max(this.maxRight, x + rectangle.w + PhyloPainter.HGAP);
		}
		this._traversed.add(node);
	},
	_setNonSourcesX : function()
	{
		this.graph[0].forEach(this._setNonSourceX, this);
	},
	_setSinkSuccessorsY : function(node)
	{
		if (this._traversed.contains(node))
			return;
		this._traversed.add(node);
		var arcsFrom = this._arcsFrom(node);
		var n = arcsFrom.length;
		if (n == 0)
		{
			this._untraversedSinks.remove(node);
			var rectangle = this._nodeRectangles[node.id];
			if (rectangle)
			{
				rectangle.y = this._nextSinkY;
				this._nextSinkY += rectangle.h + PhyloPainter.VGAP;
			}
		}
		else if (n == 1)
			this._setSinkSuccessorsY(arcsFrom[0].tail);
		else
		{
			var children = [];
			var i;
			for (i = 0; i < n; ++i)
			{
				var arc = arcsFrom[i];
				children.push(arc.tail);
			}
			var o = this;
			children = children.sort(function(a, b) {return o._compareNodes(a, b);});
			for (i = 0; i < n; ++i)
				this._setSinkSuccessorsY(children[i]);
		}
	},
	_setSinksY : function(node)
	{
		this._setSinkSuccessorsY(node);
		var arcsTo = this._arcsTo(node);
		var n = arcsTo.length;
		for (var i = 0; i < n; ++i)
		{
			var arc = arcsTo[i];
			this._setSinksY(arc.head);
		}
	},
	_setSourcesX : function()
	{
		var sources = this._sources();
		var n = sources.size;
		for (var i = 0; i < n; ++i)
		{
			var source = sources.list[i];
			var rectangle = this._nodeRectangles[source.id];
			if (rectangle)
			{
				rectangle.x = PhyloPainter.HGAP;
				rectangle.y = PhyloPainter.VGAP;
			}
			this._traversed.add(source);
		}
	},
	_xSort: function()
	{
		this.maxRight = 0;
		this.maxBottom = 0;
		this._traversed = new IDSet();
		this._setSourcesX();
		this._setNonSourcesX();
		this._traversed = new IDSet();
		this._collapseNonSinksX();
		this._traversed = null;
	},
	_nextUntraversedSink : function()
	{
		var sink = this._untraversedSinks.list[0];
		this._untraversedSinks.remove(sink);
		return sink;
	},
	_ySort : function()
	{
		this._traversed = new IDSet();
		this._untraversedSinks = new IDSet();
		var sinks = this._sinks();
		this._untraversedSinks.addAll(sinks);
		this._nextSinkY = PhyloPainter.VGAP;
		while (this._untraversedSinks.size != 0)
			this._setSinksY(this._nextUntraversedSink());
		this._untraversedSinks = null;
		this._traversed = new IDSet();
		this._setNonSinksY();
		this._traversed = null;
	}
};
