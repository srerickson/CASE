$(document).ready(function(){ 

  // make table rows of birds list clickable
  $("table#birds tr, table.birds_list tr").bind({
    mouseover: function(){
      $(this).addClass("mouseover")
      $(this).children("td").addClass("mouseover")
    }, 
    mouseout: function(){
      $(this).removeClass("mouseover")
      $(this).children("td").removeClass("mouseover")
    },
    click: function(){
      window.location = "/admin/birds/"+$(this).attr("id").split("_")[1]
    }
  })
  
  // draw evaluation result pie charts
  $(".evaluation_result_pie").each(function(){
    var $elem = $(this)
    draw_answers_pie.apply($elem,[
        $elem.data("yes-count"), 
        $elem.data("no-count"),
        $elem.data("na-count"),
        $elem.data("blank-count"),
        $elem.data("yes-comments"),
        $elem.data("no-comments"),
        $elem.data("na-comments"),
    ])
  })

  // $(".evaluation_result_pie").bind("show_evaluation_result_details",function(){
  //   var bird_id = $(this).data("bird-id"),
  //       eval_id =  $(this).data("eval-id"),
  //       question_id = $(this).data("question-id"),
  //       url = "/admin/evaluation_sets/"+eval_id+"/user_evaluation_answers/summary?bird_id="+bird_id+"&evaluation_question_id="+question_id
  //   $.get(url, function(data){
  //     $("#evaluation_result_details").html(data)
  //   })

  // })

  $(".tooltip_trigger[title]").tooltip()


})



function set_bird_form_bindings(){
  $('form.bird').bind('ajax:success', function(evt,dat,stat,xhr){
    $("div#main_content").html(xhr.responseText);
    $(".edit_saved_status").removeClass("saving").addClass("saved")
  });

  $('form.bird').bind('ajax:before', function(){
    $(".edit_saved_status").removeClass("saved").addClass("saving")
  });
  $('form.bird :input').keypress(function(){
    //$('div.edit_saved_status .changes').show()
  })
  setup_uploadify()
}


function save_and_redirect($form, url){
  $('form.bird').bind('ajax:success', function(evt,dat,stat,xhr){
    window.location = url;
  });
  $form.submit();
}



function  set_bird_form_last_saved(date){
  $("#last_saved_sidebar_section h3").html("Last Saved: "+date)
}

function setup_uploadify(){
  // Create an empty object to store our custom script data
  var uploadify_script_data = {};
  
  // Fetch the CSRF meta tag data
  var csrf_token = $('meta[name=csrf-token]').attr('content');
  var csrf_param = $('meta[name=csrf-param]').attr('content');
  
  // Now associate the data in the config, encoding the data safely
  uploadify_script_data[csrf_param] = encodeURI(encodeURIComponent(csrf_token));

  // Associate the session information
  // .... see views/layouts/application.html.erb
  uploadify_script_data[BOI_SESSION_KEY] = BOI_SESSION_VAL;;

  $("#media_file_uploader").uploadify({
        uploader: '/uploadify/uploadify.swf',
        script: 'assets',
        auto: true,
        scriptData: uploadify_script_data,
        multi: true,
        cancelImg: '/images/cancel.png',
        onComplete: function(event, queueID, fileObj, response, data) {
          $("#media_files").html(response);
          $("#media_files").animate({scrollTop: $("#media_files").attr("scrollHeight") - $('#media_files').height()}, 150);
        },
        onError: function(ev,ID,fileObj,errorObj){
          console.log(errorObj)
        }
  });
}


//Evluation Set
draw_answers_pie = function(yes_count,no_count, na_count, blank_count, yes_comments, no_comments, na_comments){
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
    console.log("drwing boi_responses_pie")
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
      margin = 30,
      node_size = margin-10;

  var x = d3.scale.linear()
            .domain([-2,2])
            .range([margin,w-margin])

  var y = d3.scale.linear()
            .domain([0,1])
            .range([margin,h-margin])

  var root = d3.select(".d3_vis"),
      svg = root.append("svg")
                .attr("width", w)
                .attr("height",h)


  svg.append("defs")
    .append("clipPath")
      .attr("id","logo_circle")
        .append("circle")
          .attr("r",10)
          .attr("cx",0)
          .attr("cy",0)
          .style("stroke","gray")



  var vis = svg.append("g")

  function d3_question_analysis_update(){

    var pie_chart = boi_responses_pie().width(node_size).height(node_size)

    var val =  $("select.question_analysis").val(),
        responses = root.datum()[val].answers,
        pies = vis.selectAll("g.pie").data(responses)


    var new_g = pies.enter().append("svg:g")
                  .attr("width",node_size)
                  .attr("height",node_size)
                  .attr("class","pie")
                  .style("opacity","0") 
                  .attr("transform", function(d,i){
                    return "translate("+x(question_score(d))+","+y(i)+")"
                  })
        

    new_g.call(pie_chart)
   

    new_g.append("image")
      .attr("xlink:href",function(d){ return (d.bird.bird.thumbnail_100_url || "") })
      .attr("width",node_size)
      .attr("x",-node_size/2)
      .attr("y",-node_size/2)
      .attr("height",node_size)
      .style("fill","black")
      .attr("clip-path","url(#logo_circle)")



    x.domain([
      d3.min(responses, function (d) { return question_score(d) }),
      d3.max(responses, function (d) { return question_score(d) })
    ]);

    y.domain([0,responses.length]);

    pies.transition().transition().duration(750)
        .attr("transform", function(d,i){
          return "translate("+x(question_score(d))+","+y(i)+")"
        })
        .style("opacity",1)

    pies.call(pie_chart)

    pies.exit()
      .transition().duration(750)
      .style("opacity", 0)
        .remove()

  }


})






// Utility Stuff

function preload_images(image_paths, callback){
  var i, loaded = 0;
  function image_loaded_check_complete(e){
    loaded += 1;
    if(loaded == image_paths.length) {
      console.log("image preload complete")
      callback();
    };
  }
  for(i in image_paths ){
    var img = $("<img style='display:none' />")
      .error(image_loaded_check_complete)
      .load(image_loaded_check_complete)
      .attr("src",image_paths[i])
    $("body").append(img);
  }
}








