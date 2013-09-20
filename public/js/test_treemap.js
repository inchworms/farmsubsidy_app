 var root = { "key": "World", "values": [{ "key": "AFRICA", "values": [{ "key": "Eastern Africa", "values": [{ "key": "Burundi", "values": [{ "pop": "90", "Major_Region": "AFRICA", "Region": "Eastern Africa", "Country": "Burundi", "Country code": "108"}] }, { "key": "Comoros", "values": [{ "pop": "68", "Major_Region": "AFRICA", "Region": "Eastern Africa", "Country": "Comoros", "Country code": "174"}] }, { "key": "Djibouti", "values": [{ "pop": "83", "Major_Region": "AFRICA", "Region": "Eastern Africa", "Country": "Djibouti", "Country code": "262"}]}] }, { "key": "Middle Africa", "values": [{ "key": "Cameroon", "values": [{ "pop": "20", "Major_Region": "AFRICA", "Region": "Middle Africa", "Country": "Cameroon", "Country code": "120"}]}]}] }, { "key": "ASIA", "values": [{ "key": "Eastern Asia", "values": [{ "key": "China", "values": [{ "pop": "13", "Major_Region": "ASIA", "Region": "Eastern Asia", "Country": "China", "Country code": "156"}]}] }, { "key": "Southern Asia", "values": [{ "key": "Pakistan", "values": [{ "pop": "173", "Major_Region": "ASIA", "Region": "Southern Asia", "Country": "Pakistan", "Country code": "586"}]}] }, { "key": "Western Asia", "values": [{ "key": "Yemen", "values": [{ "pop": "22", "Major_Region": "ASIA", "Region": "Western Asia", "Country": "Yemen", "Country code": "887"}]}]}] }, { "key": "NORTHERN AMERICA", "values": [{ "key": "NORTHERN AMERICA", "values": [{ "key": "Canada", "values": [{ "pop": "34", "Major_Region": "NORTHERN AMERICA", "Region": "NORTHERN AMERICA", "Country": "Canada", "Country code": "124"}] }, { "key": "United States of America", "values": [{ "pop": "31", "Major_Region": "NORTHERN AMERICA", "Region": "NORTHERN AMERICA", "Country": "United States of America", "Country code": "840"}]}]}]}] };

    var w = 1280 - 80,
    h = 800 - 180,
    x = d3.scale.linear().range([0, w]),
    y = d3.scale.linear().range([0, h]),
    color = d3.scale.category20c(),
    root,
    node;

    var treemap = d3.layout.treemap()
    .children(function(d){return d.values;})
    .round(false)
    .size([w, h])
    .sticky(true)
    .value(function (d) { return d.pop; });

    var svg = d3.select("#chart").append("div")
    .attr("class", "chart")
    .style("width", w + "px")
    .style("height", h + "px")
  .append("svg:svg")
    .attr("width", w)
    .attr("height", h)
  .append("svg:g")
    .attr("transform", "translate(.5,.5)");

    
        node = root;

        var nodes = treemap.nodes(root)
      .filter(function (d) { return !d.values; });

        var cell = svg.selectAll("g")
      .data(nodes)
    .enter().append("svg:g")
      .attr("class", "cell")
      .attr("transform", function (d) { return "translate(" + d.x + "," + d.y + ")"; })
      .on("click", function (d) { return zoom(node == d.parent ? root : d.parent); });

        cell.append("svg:rect")
      .attr("width", function (d) { return d.dx - 1; })
      .attr("height", function (d) { return d.dy - 1; })
      .style("fill", function (d) { return color(d.parent.key); });

        cell.append("svg:text")
      .attr("x", function (d) { return d.dx / 2; })
      .attr("y", function (d) { return d.dy / 2; })
      .attr("dy", ".35em")
      .attr("text-anchor", "middle")
        .text(function (d) { console.log(d);return d.parent.key; })
      .style("opacity", function (d) { d.w = this.getComputedTextLength(); return d.dx > d.w ? 1 : 0; });

        d3.select(window).on("click", function () { zoom(root); });

        d3.select("select").on("change", function () {
            treemap.value(this.value == "size" ? size : count).nodes(root);
            zoom(node);
        });
    

    function size(d) {
        return d.pop;
    }

    function count(d) {
        return 1;
    }

    function zoom(d) {
        var kx = w / d.dx, ky = h / d.dy;
        x.domain([d.x, d.x + d.dx]);
        y.domain([d.y, d.y + d.dy]);

        var t = svg.selectAll("g.cell").transition()
      .duration(d3.event.altKey ? 7500 : 750)
      .attr("transform", function (d) { return "translate(" + x(d.x) + "," + y(d.y) + ")"; });

        t.select("rect")
      .attr("width", function (d) { return kx * d.dx - 1; })
      .attr("height", function (d) { return ky * d.dy - 1; })

        t.select("text")
      .attr("x", function (d) { return kx * d.dx / 2; })
      .attr("y", function (d) { return ky * d.dy / 2; })
      .style("opacity", function (d) { return kx * d.dx > d.w ? 1 : 0; });

        node = d;
        d3.event.stopPropagation();
    }