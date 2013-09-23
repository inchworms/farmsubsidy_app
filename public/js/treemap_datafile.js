
  var color = d3.scale.category10();

  var canvas = d3.select("#treemap").append("svg")
    .attr("width", 500)
    .attr("height", 500);

  var treemap = d3.layout.treemap()
    .size([500,500])
    .value(function(d) { return d.size; });

d3.json("/d3_data/flare.json", function(error, root) {
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
    .attr("fill", function(d) { return d.children ? null : color(d.parent.name); })
    .attr("stroke", "#ffffff");

  cells.append("text")
    .attr("x", function(d) { return d.x + d.dx/2 })
    .attr("y", function(d) { return d.y + d.dy/2 })
    .attr("text-anchor", "middle")
    .text(function(d) { return d.children ? null : d.name })


  console.log(treemap)
