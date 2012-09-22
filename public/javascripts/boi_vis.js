//  reimplementation of piece_charts based on:
//    http://bost.ocks.org/mike/chart/
  
function boi_responses_pie(){

  var width = 300,
      height = 300,
      r = Math.min(width,height)/2,
      answer_styles = ["answer_yes","answer_no","answer_na","answer_blank"],
      comment_styles = ["comment_yes","comment_no","comment_na"],
      donut = d3.layout.pie().sort(null),
      arc = d3.svg.arc().innerRadius(.7*r).outerRadius(r-2);  

  function chart(selection){
    console.log("drawing boi_responses_pie")
    selection.each(function(responses){

      var paths = d3.select(this).selectAll("path")
                    .data(function(d,i){ 
                      var ret = donut([d.yes_count, d.no_count, d.na_count, d.blank_count]);
                      ret[0].comments = (d.yes_comments > 0)
                      ret[1].comments = (d.no_comments > 0)
                      ret[2].comments = (d.na_comments > 0)
                      ret[3].comments = false;
                      return ret
                    });

      paths.enter().append("svg:path")
        //.attr("class", function(d,i) { return [answer_styles[i], _comment_style_decision(d,i)].join(" ") })
        .attr("class", function(d,i) { return [answer_styles[i]].join(" ") })
        .attr("d", arc)
        .each(function(d){this._current = d})

      paths.transition().duration(750).attrTween("d", _arcTween);

      paths.exit().remove()

    })

  }

  //  setters/getters
  chart.width = function (value){
    if(!arguments.length) return width;
    width = value;
    _update_r();
    return chart
  }
  chart.height = function(value){
    if(!arguments.length) return height;
    height = value;
    _update_r();
    return chart
  }
  chart.responses = function(value){
    if(!arguments.length) return responses;
    responses = value;
    _update_comment_styles();
    return chart 
  }
  chart.answer_styles = function(value){
    if(!arguments.length) return answer_styles;
    answer_styles = value;
    return chart 
  }  
  chart.comment_styles = function (value){
    if(!arguments.length) return comment_styles;
    comment_styles = value;
    return chart    
  }

  //  private helpers

  function _update_r(){
    r = Math.min(width,height)/2,
    arc = d3.svg.arc().innerRadius(.7*r).outerRadius(r-2); 
  }
  function _comment_style_decision(d,i){
    if(d.comments){
      return comment_styles[i]
    }
  }


  function _arcTween(a) {
    var i = d3.interpolate(this._current, a);
    this._current = i(0);
    return function(t) {
      return arc(i(t));
    };
  }

  return chart;
}






$(document).ready(function(){

  //    Preload Images, start the show as a callback

  $.get("/admin/birds.json",function(data){
    var image_paths = [], i;
    for(i in data){
      var path = data[i].bird.thumbnail_100_url
      if(path != null){ image_paths.push(path) }
    }
    preload_images(image_paths, function(){
      d3_question_analysis_update() // start here. 
    })
  },"json")



  $("select.question_analysis").on("change", function(){
    d3_question_analysis_update();
  })

  $(window).on("resize", function(){
    //d3_question_analysis_update();
  })


  function  question_score(a){
    total_responses = a.yes_count + a.no_count + a.na_count + a.blank_count
    score = (1.1 * a.yes_count) + (-1.1 * a.no_count)
    return score
  }


  //
  //   D3 
  // 
  var w = $(".d3_vis").width(), 
      h = $(".d3_vis").height(),
      node_size = 40,
      margin = { top:node_size,
                 right:node_size,
                 bottom:node_size,
                 left:node_size}

  var x = d3.scale.linear()
            .range([margin.left, w-margin.right])

  var y = d3.scale.linear()
            .range([margin.top, h-margin.bottom])

  var root = d3.select(".d3_vis"),
      svg = root.append("svg")
                .attr("width", w)
                .attr("height",h)

  var x_axis = d3.svg.axis().scale(x).orient("bottom")
  var y_axis = d3.svg.axis().scale(y).orient("right")

  svg.append("defs")
    .append("clipPath")
      .attr("id","logo_circle")
        .append("circle")
          .attr("r",node_size/2)
          .attr("cx",0)
          .attr("cy",0)
          .style("stroke","gray")

  var vis = svg.append("g")

  //  add axes 
  
  vis.append("g")
        .attr("class","axis x")
        .call(x_axis)

  vis.append("g")
        .attr("class","axis y")
        .call(y_axis)



  function d3_question_analysis_update(){

    var pie_chart = boi_responses_pie().width(node_size).height(node_size)

    var two_axis = false,
        q_id_x =  $("select.question_analysis.x_axis").val(),
        q_id_y =  $("select.question_analysis.y_axis").val(),
        x_responses, y_responses;

    x_responses = root.datum()[q_id_x].answers;

    if(q_id_y >= 0){
      two_axis = true;
      y_responses = root.datum()[q_id_y].answers;      
    }
    
    var responses = x_responses.map(function(r,i){
      var x_bird = r.bird.bird, y_bird
      if (two_axis && x_bird.id != y_responses[i].bird.bird.id){
        throw new Error("Responses for each axis don't refer to the same entity/bird!")
      }
      return {
        'bird': x_bird,
        'x': r,
        'y': (two_axis ? y_responses[i] : null)
      }
    })


    var pies = vis.selectAll("g.pie").data(responses)

    var translate_function = function(d,i){
      if(d.y) {
        return "translate("+x(question_score(d.x))+","+y(question_score(d.y))+")"
      } else {
        return "translate("+x(question_score(d.x))+","+y(i)+")"                      
      }
    }

    var new_g = pies.enter().append("svg:g")
                  .attr("width",node_size)
                  .attr("height",node_size)
                  .attr("class","pie")
                  .style("opacity","1") 
                  .attr("transform", translate_function)     
    //new_g.call(pie_chart)
   
    new_g.append("image")
      .attr("xlink:href",function(d){ return (d.bird.thumbnail_100_url || "") })
      .attr("width",node_size)
      .attr("x",-node_size/2)
      .attr("y",-node_size/2)
      .attr("height",node_size)
      .style("fill","black")
      .attr("clip-path","url(#logo_circle)")

    x.domain([
      d3.min(responses, function (d) { return question_score(d.x) }),
      d3.max(responses, function (d) { return question_score(d.x) })
    ]);

    if(two_axis){
      y.domain([
        d3.max(responses, function (d) { return question_score(d.y) }),
        d3.min(responses, function (d) { return question_score(d.y) })
      ])
    } else {
      y.domain([0,responses.length]);      
    }

    d3.select("g.axis.x").transition().call(x_axis)
    d3.select("g.axis.y").transition().call(y_axis)

    pies.transition().duration(750)
        .attr("transform", translate_function)

    //pies.call(pie_chart)
    pies.exit().remove()

  }


})







//
// Old Stuff
//


//Evluation Set
function draw_answers_pie(yes_count,no_count, na_count, blank_count, yes_comments, no_comments, na_comments){
  var elem = this[0],
      $elem = this,
      data = [yes_count,no_count, na_count, blank_count ]
      total = yes_count + no_count + na_count + blank_count,
      w = $elem.width()-4,
      h = $elem.height()-4,
      r = Math.min(w,h)/2,
      answer_styles = ["answer_yes","answer_no","answer_na","answer_blank"],
      comment_styles = [
        yes_comments > 0 ? "comment_yes " : "",
        no_comments >  0 ? "comment_no" : "",
        na_comments >  0 ? "comment_na" : "",
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
    .attr("class", function(d, i) { return [answer_styles[i], comment_styles[i]].join(" ") })
    .attr("d", arc)



  svg.append("svg:text")
      .attr("dy", ".4em")
      .attr("font-size", ".8em")
      .attr("text-anchor", "middle")
      .text(total);
}