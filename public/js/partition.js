
var color = d3.scale.category10();

var radius = 250;

// format currency
var formatNumber = d3.format(",");

// tooltip
var tip = d3.tip()
.attr('class', 'd3-tip-treemap')
.offset([-10, 0])
.html(function(d) {
  return d.name + " recieved: " + formatNumber(d.amount_euro) + " Euro";
})

var canvas = d3.select("#partition").append("svg")
  .attr("width", 500)
  .attr("height", 500);

// initialize tooltip
canvas.call(tip);

var partition = d3.layout.partition()
  .sort(null)
  .size([2 * Math.PI, radius * radius])
  .value(function(d) { return d.amount_euro; });

var arc = d3.svg.arc()
  .startAngle(function(d) { return d.x; })
  .endAngle(function(d) { return d.x + d.dx; })
  .innerRadius(function(d) { return Math.sqrt(d.y); })
  .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });

var root_node = canvas.append("g")
  .attr("class", "cell")
  .attr("transform", "translate(250,250)");

d3.json("/treemap.json", function(error, root) {

  var path = root_node.datum(root).selectAll("path")
    .data(partition.nodes)
    .enter().append("path")
    .attr("display", function(d) { return d.depth ? null : "none"; }) // hide inner ring
    .attr("d", arc)
    .style("stroke", "#fff")
    .style("fill", function(d) { return color((d.children ? d : d.parent).name); })
    .on('mouseover', tip.show)
    .on('mouseout', tip.hide)
    .style("fill-rule", "evenodd");
});
