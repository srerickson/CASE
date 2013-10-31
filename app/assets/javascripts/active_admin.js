//= require active_admin/base

//= require swfobject
//= require jquery.uploadify.v2.1.4.min
//= require d3.v2
//# require jquery.tools.min
//= require_self 
//= require_tree ./admin







$(document).ready(function(){ 

  // make table rows of birds list clickable
  $("table#index_table_birds tr, table.birds_list tr").bind({
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


  // $(".evaluation_result_pie").bind("show_evaluation_result_details",function(){
  //   var bird_id = $(this).data("bird-id"),
  //       eval_id =  $(this).data("eval-id"),
  //       question_id = $(this).data("question-id"),
  //       url = "/admin/evaluation_sets/"+eval_id+"/user_evaluation_answers/summary?bird_id="+bird_id+"&evaluation_question_id="+question_id
  //   $.get(url, function(data){
  //     $("#evaluation_result_details").html(data)
  //   })

  // })



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








