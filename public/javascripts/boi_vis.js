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
      var bird_lookup = [],
          i = 0;
      for(i in data){
        bird_lookup[ data[i].bird.id ] = data[i].bird
      }
      $(document).data("bird_data", bird_lookup)
    }
    preload_images(image_paths, function(){
      d3_question_analysis_images()
      $(".pie image").each(function(){
        var b_id = $(this).siblings("circle").data("bird-id")
        $(this).attr("class","tooltip_trigger")
        $(this).attr("title", $(document).data("bird_data")[b_id].name )
      })
      $(".tooltip_trigger[title]").tooltip()

    })
  },"json")



  $("select.question_analysis").on("change", function(){
    d3_question_analysis_update();
  })

  $(window).on("resize", function(){
    //d3_question_analysis_update();
  })


  $(".d3_vis").on("click",".pie image",function(e){
    var b_id = $(this).siblings("circle").data("bird-id")
    $.getScript(window.location+"_details?bird_id="+b_id+"&q_id_x="+q_id_x+"&q_id_y="+q_id_y)
  })



  //
  //   D3 
  // 
  var w = $(".d3_vis").width(), 
      h = $(".d3_vis").height(),
      margin = { top:100,
                 right:100,
                 bottom:100,
                 left:100},
      node_size = 10;
      inner_w = (w - margin.left - margin.right),
      inner_h = (h - margin.top - margin.bottom)

  var x_scale = d3.scale.linear()
            .range([margin.left, w-margin.right])
            .domain([-1,1])

  var y_scale = d3.scale.linear()
            .range([margin.top, h-margin.bottom])
            .domain([1,-1])

  var root = d3.select(".d3_vis"),
      svg = root.append("svg")
                .attr("width", w)
                .attr("height",h)

  var x_axis = d3.svg.axis().scale(x_scale).orient("bottom"),
      y_axis = d3.svg.axis().scale(y_scale).orient("right")

  var padding = 6,
      color = d3.scale.category10().domain([-1,1])

  var q_id_x = 0,
      q_id_y = 0;

  svg.append("defs")
    .append("clipPath")
      .attr("id","logo_circle")
        .append("circle")
          .attr("r",node_size-2)
          .attr("cx",0)
          .attr("cy",0)

  var vis = svg.append("g")

  
  vis.append("g")
        .attr("class","axis x")
        .call(x_axis)

  vis.append("g")
        .attr("class","axis y")
        .call(y_axis)


  var responses = root.datum()[q_id_x].results.map(function(r,i){
    return {
      'bird_id': r.evaluation_result.bird_id,
      'score_x': x_scale(r.evaluation_result.answer_score),
      'score_y': y_scale(r.evaluation_result.answer_score),
      'color': color((r.evaluation_result.answer_score)),
      'radius': node_size
    }
  })

  var pies = vis.selectAll("g.pie").data(responses)

  var force = d3.layout.force()
    .gravity(0)
    .charge(0)
    .nodes(responses)
    .size([w,h])
    .on("tick", tick)
    .start()


  var new_g = pies.enter().append("svg:g")
                .attr("width",node_size)
                .attr("height",node_size)
                .attr("class","pie")
                .style("opacity","1") 
                .call(force.drag);

    new_g.append("circle")
      .attr("r", node_size)
      .attr("fill",function(d,i){ return responses[i].color })
      .attr("data-bird-id", function(d,i){return responses[i].bird_id } )


  function d3_question_analysis_images(){
    new_g.append("image")
      .attr("xlink:href",function(d,i){ 
          return (  $(document).data("bird_data")[d.bird_id].thumbnail_100_url || "" )
       })
      .attr("width",40)
      .attr("x",-20)
      .attr("y",-20)
      .attr("height",40)
      .attr("clip-path","url(#logo_circle)")
  }





  function d3_question_analysis_update(){

    q_id_x =  $("select.question_analysis.x_axis").val()
    q_id_y =  $("select.question_analysis.y_axis").val()

    var x_responses = root.datum()[q_id_x].results,
        y_responses = root.datum()[q_id_y].results;      

    var responses = force.nodes(),
        i = 0;

    for(i in responses){
      if(y_responses[i].bird_id != x_responses[i].bird_id){
        throw new Error("order of responses has changed!")      
      } else {
        responses[i].score_x = x_scale(x_responses[i].evaluation_result.answer_score)
        responses[i].score_y = y_scale(y_responses[i].evaluation_result.answer_score)
        responses[i].color = color(responses[i].score_y * responses[i].score_x )
     }
    }

    vis.selectAll("g.pie").data(responses)
      .select("circle")
        .attr("fill",function(d,i){ return responses[i].color })

    force.nodes(responses).start()

  }



  var translate_function = function(d,i){
    return "translate("+ d.x +","+ d.y +")"
  }




  function tick(e){
    pies
      .each(gravity(.4 * e.alpha))
      .each(collide(.4))
      .attr("transform", translate_function)
  }



  // Move nodes toward cluster focus.
  function gravity(alpha) {
    return function(d) {
      d.y += (d.score_y - d.y) * alpha;
      d.x += (d.score_x - d.x) * alpha;
    };
  }



  // Resolve collisions between nodes.
  function collide(alpha) {
    var quadtree = d3.geom.quadtree(responses);
    return function(d) {
      var r = d.radius + (node_size) + padding,
          nx1 = d.x - r,
          nx2 = d.x + r,
          ny1 = d.y - r,
          ny2 = d.y + r;
      quadtree.visit(function(quad, x1, y1, x2, y2) {
        if (quad.point && (quad.point !== d)) {
          var x = d.x - quad.point.x,
              y = d.y - quad.point.y,
              l = Math.sqrt(x * x + y * y),
              r = d.radius + quad.point.radius + (d.color !== quad.point.color) * padding;
          if (l < r) {
            l = (l - r) / l * alpha;
            d.x -= x *= l;
            d.y -= y *= l;
            quad.point.x += x;
            quad.point.y += y;
          }
        }
        return x1 > nx2
            || x2 < nx1
            || y1 > ny2
            || y2 < ny1;
      });
    };
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