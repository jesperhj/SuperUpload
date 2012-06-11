var upload_progress;

function saveDescriptionWithAjax() {
  xmlhttpDescription=new XMLHttpRequest(); // we dont support < IE7
  xmlhttpDescription.onreadystatechange=function() {
    if (xmlhttpDescription.readyState==4 && xmlhttpDescription.status==200) {
      res = eval("(" + xmlhttpDescription.responseText + ")");
      
      document.getElementById("title_from_respons").innerHTML       = res.result.filename;
      document.getElementById("path_from_respons").innerHTML        = res.result.path;
      showDescriptionRespons();
    }
  };
  description = document.getElementById('description').value;
  transfer_id = document.getElementById('transfer_id').value;
  xmlhttpDescription.open("POST","description?description="+description+"&transfer_id="+transfer_id+"&rand="+ Math.random(),true);
  xmlhttpDescription.send();
}

function saveDescription() {
  //document.getElementById('description_form').target = 'upload_iframe';
  //document.getElementById('description_form').submit();
  saveDescriptionWithAjax();
}

function showDescriptionForm() {
  var description_form = document.getElementById('description_form'); 
  description_form.style.display = 'block';
}

function showDescriptionRespons() {
  var description_respons = document.getElementById('description_respons'); 
  description_respons.style.display = 'block';
}

function uploadFile() {
  upload_progress = setInterval(function() {
    xmlhttp=new XMLHttpRequest(); // we dont support < IE7
    xmlhttp.onreadystatechange=function() {
      if (xmlhttp.readyState==4 && xmlhttp.status==200) {
        res = eval("(" + xmlhttp.responseText + ")");
        
        document.getElementById("status").innerHTML='Status: '+res.result.status+'%';
        
        if(res.result.status == '100' || res.result.status == 100) {
          document.getElementById("status").innerHTML='Status: 100%';
          clearInterval(upload_progress);
          getPostUploadInfo();
        }
      }
    };
    transfer_id = document.getElementById('transfer_id').value;
    xmlhttp.open("GET","transfer_status/"+transfer_id+"?rand="+ Math.random(),true);
    xmlhttp.send();
     
  }, 1000);
  document.getElementById('upload_form').target = 'upload_iframe';
  document.getElementById('upload_form').submit();
  showDescriptionForm();
}

function getPostUploadInfo() {
  xmlhttp=new XMLHttpRequest(); // we dont support < IE7
  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      res = eval("(" + xmlhttp.responseText + ")");
      var stored_file = document.getElementById("stored_file");
      stored_file.innerHTML = 'Uploaded to: '+res.result.path+'/'+res.result.filename;
    }
  };
  transfer_id = document.getElementById('transfer_id').value;
  xmlhttp.open("GET","post_upload_info/"+transfer_id+"?rand="+ Math.random(),true);
  xmlhttp.send();
}
