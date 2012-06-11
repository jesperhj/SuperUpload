/*function fileSelected() {
  var file = document.getElementById('upload_file').files[0];
  if (file) {
    var fileSize = 0;
    if (file.size > 1024 * 1024)
      fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
    else
      fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
          
    document.getElementById('fileName').innerHTML = 'Name: ' + file.name;
    document.getElementById('fileSize').innerHTML = 'Size: ' + fileSize;
    document.getElementById('fileType').innerHTML = 'Type: ' + file.type;
  }
}*/

function saveDescription() {
  var description = document.getElementById('description');
  
  var fd = new FormData();
  fd.append("description", description.value);
  
  var xhr = new XMLHttpRequest();
  xhr.addEventListener("load", saveComplete, false);
  xhr.addEventListener("error", saveFailed, false);
  xhr.open("POST", "/description");
  xhr.send(fd);
}

function saveComplete(evt) {
  alert(evt.target.responseText);
}

function saveFailed(evt) {
  showError("Error. Could not save description!");
}

function uploadFile() {
  var fd = new FormData();
  fd.append("upload_file", document.getElementById('upload_file').files[0]);
  var xhr = new XMLHttpRequest();
  xhr.upload.addEventListener("progress", uploadProgress, false);
  xhr.addEventListener("load", uploadComplete, false);
  xhr.addEventListener("error", uploadFailed, false);
  xhr.addEventListener("abort", uploadCanceled, false);
  xhr.open("POST", "/upload");
  xhr.send(fd);
  
  document.getElementById('errormsg').style.display = 'none';

  showDescriptionBox();
}

function uploadProgress(evt) {
  var status = document.getElementById('status');
  
  if (evt.lengthComputable) {
    var percentComplete = Math.round(evt.loaded * 100 / evt.total);
    status.innerHTML  = 'Status: ' + percentComplete.toString() + '%';
    status.className  = '';
  } 
  else {
    status.innerHTML  = 'Cant calculate status.';
    status.className  = 'error';
  }
}

function uploadComplete(evt) {
  var res = eval("(" + evt.target.responseText + ")");
  
  if(res.error != null) {
    showError(res.error.message);
  } else {
    document.getElementById('stored_file').innerHTML = 'Uploaded to' +  res.result.stored_folder+'/'+res.result.stored_filename;
  }
}

function uploadFailed(evt) {
  showError("Error. Something went wrong!");
}

function uploadCanceled(evt) {
  showError("Error. Conenction lost or upload canceled!");
}

function showDescriptionBox() {
  var description = document.getElementById('description');
  var save        = document.getElementById('save');
  
  description.style.display = 'block';
  save.style.display        = 'block';
}

function showError(msg) {
  var error = document.getElementById('error');

  error.style.display = 'block';
  error.innerHTML = msg;
}