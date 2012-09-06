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
  $("td.evaluation_result_pie").each(function(){
    $elem = $(this)
    draw_answers_pie.apply($elem,[$elem.data("yes-count"), $elem.data("no-count"),$elem.data("na-count"),$elem.data("blank-count"), 15 ])
  })

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
draw_answers_pie = function(yes_count,no_count, na_count, blank_count, r ){
  var elem = this[0]
      $elem = this,
      data = [yes_count,no_count, na_count, blank_count ]
      total = yes_count + no_count + na_count + blank_count,
      w = r*2,
      h = r*2,
      color = ["#CEC","#ECC","#EE8","#AAA"],
      donut = d3.layout.pie().sort(null),
      arc = d3.svg.arc().innerRadius(7).outerRadius(r-1);

  var svg = d3.select(elem).append("svg:svg")
    .attr("width", w)
    .attr("height", h)
    .append("svg:g")
    .attr("transform", "translate(" + w / 2 + "," + h / 2 + ")");

  var arcs = svg.selectAll("path")
    .data(donut(data))
    .enter().append("svg:path")
    .attr("fill", function(d, i) { return color[i] })
    .attr("d", arc)

  svg.append("svg:text")
      .attr("dy", ".4em")
      .attr("font-size", ".8em")
      .attr("text-anchor", "middle")
      .text(total);
}