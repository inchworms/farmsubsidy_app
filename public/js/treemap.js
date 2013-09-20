// console.log(treemap[0].children)
  // [Object, Object, Object]

  // console.log(treemap[1].parent)
  // max
var mydata = {
  "name": "Max", "value": 100,
  "children": [
  {
    "name": "Sylvia", "value": 75,
    "children": [
    {"name": "Graig", "value": 25},
    {"name": "Robin", "value": 25},
    {"name": "Anna", "value": 25}
    ]
  },
  {
    "name": "David", "value": 75,
    "children": [
    {"name": "Jeff", "value": 25},
    {"name": "Buffy", "value": 25}
    ]
  },
  {
    "name" : "Mr X", "value": 75
  }
  ]
};

  // var dataset = <%= @payment_total_treemap_array.to_json %>

// <% p @payment_total_treemap_array %>
// <% p @payment_total_treemap_array.to_json %>


  var color = d3.scale.category10();

  var canvas = d3.select("#treemap").append("svg")
    .attr("width", 500)
    .attr("height", 500);

  var treemap = d3.layout.treemap()
    .size([500,500])
    .nodes(mydata);

  var cells = canvas.selectAll(".cell")
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
