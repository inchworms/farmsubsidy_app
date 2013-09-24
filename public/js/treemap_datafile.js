
  var color = d3.scale.category10();

  // tooltip
  var tip = d3.tip()
  .attr('class', 'd3-tip')
  .offset([-10, 0])
  .html(function(d) {
    return d.name + " recieved: " + d.amount_euro;
  })

  var canvas = d3.select("#treemap").append("svg")
    .attr("width", 500)
    .attr("height", 500);

  // initialize tooltip
  canvas.call(tip);

  var treemap = d3.layout.treemap()
    .size([500,500])
    .round(true)
    .value(function(d) { return d.amount_euro; });

  var root_node = canvas.append("g")
    .attr("class", "cell")
    .attr("transform", "translate(0.5,0.5)");

d3.json("/treemap.json", function(error, root) {
  var cells = root_node.datum(root).selectAll(".cell")
    .data(treemap)
    .enter();


  cells.append("rect")
    .attr("x", function(d) { return d.x; })
    .attr("y", function(d) { return d.y; })
    .attr("width", function(d) { return d.dx; })
    .attr("height", function(d) { return d.dy; })
    .attr("fill", function(d) { return color(d.name); })
    .on('mouseover', tip.show)
    .on('mouseout', tip.hide)
    .attr("stroke", "#ffffff");

  // cells.append("text")
  //   .attr("x", function(d) { return d.x + d.dx/2 })
  //   .attr("y", function(d) { return d.y + d.dy/2 })
  //   .attr("text-anchor", "middle")
  //   .text(function(d) { return d.name })

});
