// make sure that the variable dataset is in recipient.erb


  var w = 550;
  var h = 250;

  var xScale = d3.scale.ordinal()
              .domain(d3.range(dataset.length))
              .rangeRoundBands([0,w], 0.05);

  var yScale = d3.scale.linear()
              .domain([0, d3.max(dataset, function(d){ return d.amount })])
              .range([30, h]);

  var color = d3.scale.quantize()
      .domain([ d3.min(dataset, function(d){ return d.amount }),
                d3.max(dataset, function(d){ return d.amount })])
      .range(["rgb(176,176,176)","rgb(127,127,127)","rgb(90,90,90)","rgb(77,77,77)","rgb(51,51,51)"]);

  // format currency
  var formatNumber = d3.format(",");

  //Create SVG element
  var svg = d3.select("#bar-chart")
        .append("svg")
        .attr("width", w)
        .attr("height", h);

  //Create bars
  svg.selectAll("rect")
    .data(dataset)
    .enter()
    .append("rect")
    .attr("x", function(d, i) {
       return xScale(i);
     })
    .attr("y", function(d) {
        return h - yScale(d.amount);
     })
    .attr("width", xScale.rangeBand())
    .attr("height", function(d) {
        return yScale(d.amount);
     })
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

  //Create amount labels
  svg.selectAll("text")
    .data(dataset)
    .enter()
    .append("text")
    .text(function(d) {
       return formatNumber(d.amount);
    })
    .attr("text-anchor", "middle")
    .attr("x", function(d, i) {
        return xScale(i) + xScale.rangeBand() / 2;
    })
    .attr("y", function(d) {
        return h - yScale(d.amount) + 14;
    })
    .attr("font-family", "sans-serif")
    .attr("font-size", "11px")
    .attr("fill", "white");

  //Create year labels
  svg.selectAll("text")
    .data(dataset)
    .enter()
    .append("text")
    .text(function(d) {
       return d.year;
    })
    .attr("text-anchor", "middle")
    .attr("x", function(d, i) {
        return xScale(i) + xScale.rangeBand() / 2;
    })
    .attr("y", function(d) {
        return h - yScale(d.amount) -30;
    })
    .attr("font-family", "sans-serif")
    .attr("font-size", "11px")
    .attr("fill", "white");



