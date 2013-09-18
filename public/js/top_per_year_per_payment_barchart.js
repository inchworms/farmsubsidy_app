// TODO describe this script and that it requires a data-varibable to be set before it is run

// variables assigned
var valueLabelWidth = 120; // space reserved for value labels (right)
var barHeight = 35; // height of one bar
var barLabelWidth = 280; // space reserved for bar labels
var barLabelPadding = 5; // padding between bar and bar labels (left)
var gridLabelHeight = 18; // space reserved for gridline labels
var gridChartOffset = 5; // space between start of grid and first bar
var maxBarWidth = 400; // width of the bar with the max value
var paddingBetweenBars = 1.1;

// format currency
var formatNumber = d3.format(",");

// color of bars
var color = d3.scale.quantize()
    .domain([ d3.min(data, function(d){ return +d.amount }),
              d3.max(data, function(d){ return +d.amount })])
    .range(["rgb(173,221,142)","rgb(120,198,121)","rgb(65,171,93)","rgb(35,132,67)","rgb(0,104,55)","rgb(0,69,41)"]);

// accessor functions 
var barLabel = function(d) { return (d['name']); };
var barValue = function(d) { return parseFloat(d['amount']); };

// scales
var yScale = d3.scale.ordinal().domain(d3.range(0, data.length)).rangeBands([0, data.length * barHeight ]);
var y = function(d, i) { return yScale(i) * paddingBetweenBars; };
var yText = function(d, i) { return y(d, i) + yScale.rangeBand() / 2; };
var x = d3.scale.linear().domain([0, d3.max(data, barValue)]).range([0, maxBarWidth]);

// svg container element
var chart = d3.select('#bar-chart').append("svg")
  .attr('width', maxBarWidth + barLabelWidth + valueLabelWidth)
  .attr('height', gridLabelHeight + gridChartOffset + data.length * barHeight * paddingBetweenBars);

// initialize the gridContainer
var gridContainer = chart.append('g')
  .attr('transform', 'translate(' + barLabelWidth + ',' + gridLabelHeight + ')');

// grit label
gridContainer.selectAll("text").data(x.ticks(2)).enter().append("text")
  .attr("x", x)
  .attr("dy", -3)
  .attr("text-anchor", "middle")
  .attr('fill', '#666')
  .text(String);

// vertical grid lines
gridContainer.selectAll("line").data(x.ticks(5)).enter().append("line")
  .attr("x1", x)
  .attr("x2", x)
  .attr("y1", 0)
  .attr("y2", yScale.rangeExtent()[1] + gridChartOffset + 40)
  .style("stroke", "#ccc");

// initialize bar labels container
var labelsContainer = chart.append('g')
  .attr('transform', 'translate(' + (barLabelWidth - barLabelPadding) + ',' + (gridLabelHeight + gridChartOffset ) + ')');

// bar label text
labelsContainer.selectAll('text.bar-label').data(data).enter().append('text')
  .attr('y', yText)
  .attr('stroke', 'none')
  .attr("class", 'bar-label')
  .attr("dy", ".35em") // vertical-align: middle
  .attr('text-anchor', 'end')
  .text(barLabel);

// initialize bars container
var barsContainer = chart.append('g')
  .attr('transform', 'translate(' + barLabelWidth + ',' + (gridLabelHeight + gridChartOffset) + ')')

// bars
barsContainer.selectAll("rect").data(data).enter().append("rect")
  .attr('y', y)
  .attr('height', yScale.rangeBand())
  .attr('width', function(d) { return x(barValue(d)); })
  .attr("fill", function(d) {
  //Get data value
    var value = d.amount;
      if (value) {
        //If value exists…
        return color(value);
      } else {
        //If value is undefined…
        return "#fff";
      };
    });

// bar value labels
barsContainer.selectAll("text.bar-value").data(data).enter().append("text")
  .attr("x", function(d) { return x(barValue(d)); })
  .attr("y", yText )
  .attr("dx", 3) // padding-left
  .attr("dy", ".35em") // vertical-align: middle
  .attr("text-anchor", "start") // text-align: right
  .attr("class", 'bar-value')
  .text(function(d) { return formatNumber(d3.round(barValue(d), 2))+ " Euro"; });

// start line
barsContainer.append("line")
  .attr("y1", -gridChartOffset)
  .attr("y2", yScale.rangeExtent()[1] + gridChartOffset + 40)
  .style("stroke", "#ccc");

