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
})



function set_bird_form_bindings(){
  $('form.bird').bind('ajax:success', function(evt,dat,stat,xhr){
    console.log("here")
    $("div#main_content").html(xhr.responseText);
    $("div.edit_saved_status").html('&nbsp;');
  });

  $('form.bird').bind('ajax:before', function(){
    $("div.edit_saved_status").html('<img src="/images/spinner.gif" />')
  });
  $('form.bird :input').keypress(function(){
    //$('div.edit_saved_status .changes').show()
  })
  setup_uploadify()
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