
  var color = d3.scale.category10();

  var canvas = d3.select("#treemap").append("svg")
    .attr("width", 500)
    .attr("height", 500);

  var treemap = d3.layout.treemap()
    .size([500,500])
    .value(function(d) { return d.amount_euro; });

d3.json("/d3_data/temp.json", function(error, root) {
  var cells = canvas.datum(root).selectAll(".cell")
    .data(treemap)
    .enter()
    .append("g")
    .attr("class", "cell");


  cells.append("rect")
    .attr("x", function(d) { return d.x; })
    .attr("y", function(d) { return d.y; })
    .attr("width", function(d) { return d.dx; })
    .attr("height", function(d) { return d.dy; })
    .attr("fill", function(d) { return color(d.name); })
    .attr("stroke", "#ffffff");

  cells.append("text")
    .attr("x", function(d) { return d.x + d.dx/2 })
    .attr("y", function(d) { return d.y + d.dy/2 })
    .attr("text-anchor", "middle")
    .text(function(d) { return d.name })

});
