function draw_answer_pie(yes_count,no_count, na_count, blank_count, yes_comments, no_comments, na_comments){
  var elem = this[0],
      $elem = this,
      data = [yes_count,no_count, na_count, blank_count ]
      total = yes_count + no_count + na_count + blank_count,
      w = $elem.width()-4,
      h = $elem.height()-4,
      r = Math.min(w,h)/2,
      answer_styles = [
        "fill: #ACA;",    // answer_yes
        "fill: #CAA;",    // answer_no
        "fill: #E5E579;", // answer_na
        "fill: #EEE;"     // answer_blank
      ],
  
      comment_styles = [
        yes_comments > 0 ? "stroke: #666;stroke-width:1.2px;" : "",
        no_comments >  0 ? "stroke: #666;stroke-width:1.2px;" : "",
        na_comments >  0 ? "stroke: #666;stroke-width:1.2px;" : "",
      ]
      donut = d3.layout.pie().sort(null),
      arc = d3.svg.arc().innerRadius(.4*r).outerRadius(r-1);


  var svg = d3.select(elem).append("svg:svg")
    .attr("width", w)
    .attr("height", h)
    .append("svg:g")
    .attr("transform", "translate(" + w / 2 + "," + h / 2 + ")");

  var arcs = svg.selectAll("path")
    .data(donut(data))
    .enter().append("svg:path")

    .attr("style", function(d, i) { return [answer_styles[i], comment_styles[i]].join(";") })
    .attr("d", arc)



  svg.append("svg:text")
      .attr("dy", ".4em")
      .attr("font-size", ".8em")
      .attr("text-anchor", "middle")
      .text(total);
}