$(document).ready(function(){ 
  setup_uploadify()
})


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
        script: 'multi_upload',
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