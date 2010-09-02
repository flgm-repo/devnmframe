// Rails notes

// This is the handlers.js file from swfupload's application demo

// All image paths are changed from relative to absolute

// Example:
//   AddImage("images/" + image_name);  ->  AddImage("/images/" + image_name);

// Images from the swfupload demo are saved in #{RAILS_ROOT}/public/images

// uploadSuccess was changed
// The line: AddImage("thumbnail.php?id=" + serverData);
// was changed to: AddImage(serverData);
// The rails photo controller should return a text string
// containing the full URL to the thumbnail

// Make sure uploadSuccess can read your return string to test if it's an
// error or not

function fileQueueError(file, errorCode, message) {
    try {
        var imageName = "error.gif";
        var errorName = "";
        if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
            errorName = "You have attempted to queue too many files.";
        }

        if (errorName !== "") {
            alert(errorName);
            return;
        }

        switch (errorCode) {
            case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
                imageName = "zerobyte.gif";
                break;
            case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
                imageName = "toobig.gif";
                break;
            case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
            case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
            default:
                alert(message);
                break;
        }

        addImage("/images/" + imageName);

    } catch (ex) {
        this.debug(ex);
    }
Uploadin
}

function fileDialogComplete(numFilesSelected, numFilesQueued) {
    try {
        enabled_uploading = enabled_to_upload();
        if (enabled_uploading == true || enabled_uploading == "true" ){
          if (numFilesQueued > 0) {
              $("#loading").show();
              this.startUpload();
          }
        }
        else{
          alert("You can't upload more photos");
          this.cancelQueue();
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadProgress(file, bytesLoaded) {

    try {
        var percent = Math.ceil((bytesLoaded / file.size) * 100);

        var progress = new FileProgress(file,  this.customSettings.upload_target);
        progress.setProgress(percent);
        if (percent == 100) {
            progress.setStatus("Creating thumbnail...");
            progress.toggleCancel(false, this);
        } else {
            progress.setStatus("Uploading...");
            progress.toggleCancel(true, this);
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadSuccess(file, serverData) {
    try {
        var progress = new FileProgress(file,  this.customSettings.upload_target);
        var serverData = jQuery.parseJSON(serverData)
        if (serverData.success == true) {
            addImage(serverData);
            progress.setStatus("Thumbnail Created.");
            progress.toggleCancel(false);
        } else {
            //addImage("/images/error.gif");
            progress.setStatus("Error");
            progress.toggleCancel(false);
            alert(serverData.message);
            this.cancelQueue();
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadComplete(file) {
    try {
        /*  I want the next upload to continue automatically so I'll call startUpload here */
        if (this.getStats().files_queued > 0) {
            this.startUpload();
        } else {
            $("#loading").hide();
            var progress = new FileProgress(file,  this.customSettings.upload_target);
            progress.setComplete();
            progress.setStatus("All images received.");

            showButtonAddImagesToFrame();

            $("#no-image").attr("checked", false);
            update_cost();
            progress.toggleCancel(false);
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadError(file, errorCode, message) {
    var imageName =  "error.gif";
    var progress;
    try {
        switch (errorCode) {
            case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
                try {
                    progress = new FileProgress(file,  this.customSettings.upload_target);
                    progress.setCancelled();
                    progress.setStatus("Cancelled");
                    progress.toggleCancel(false);
                }
                catch (ex1) {
                    this.debug(ex1);
                }
                break;
            case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
                try {
                    progress = new FileProgress(file,  this.customSettings.upload_target);
                    progress.setCancelled();
                    progress.setStatus("Stopped");
                    progress.toggleCancel(true);
                }
                catch (ex2) {
                    this.debug(ex2);
                }
            case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
                imageName = "uploadlimit.gif";
                break;
            default:
                alert(message);
                break;
        }

        addImage("/images/" + imageName);

    } catch (ex3) {
        this.debug(ex3);
    }

}


function addImage(serverData) {
    var newImg = document.createElement("img");
    newImg.src = serverData.path;
    newImg.style.margin = "5px";
    newImg.width= "50";
    newImg.height= "50";
    newImg.alt = "";

    li = $('<div></div>');
    li.append(newImg);
    $('ul.uploaded-images').append('<li><a title="" href="#">' + li.html() + '</a><a image_id="' + serverData.id + '" class="delete-image" href="#preview"><img width="13" height="13" src="/images/close.gif" class="delete_cross" alt="Delete"></a></li>');

    try {
        newImg.filters.item("DXImageTransform.Microsoft.Alpha").opacity = 1;
    } catch (e) {
        // If it is not set initially, the browser will throw an error.  This will set it if it is not set yet.
        newImg.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + 1 + ')';
    }
    newImg.onload = function () {
        fadeIn(newImg, 0);
    };

}

function fadeIn(element, opacity) {
    var reduceOpacityBy = 5;
    var rate = 30;	// 15 fps


    if (opacity < 100) {
        opacity += reduceOpacityBy;
        if (opacity > 100) {
            opacity = 100;
        }

        if (element.filters) {
            try {
                element.filters.item("DXImageTransform.Microsoft.Alpha").opacity = opacity;
            } catch (e) {
                // If it is not set initially, the browser will throw an error.  This will set it if it is not set yet.
                element.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + opacity + ')';
            }
        } else {
            element.style.opacity = opacity / 100;
        }
    }

    if (opacity < 100) {
        setTimeout(function () {
            fadeIn(element, opacity);
        }, rate);
    }
}



/* ******************************************
 *	FileProgress Object
 *	Control object for displaying file info
 * ****************************************** */

function FileProgress(file, targetID) {
    this.fileProgressID = "divFileProgress";

    this.fileProgressWrapper = document.getElementById(this.fileProgressID);
    if (!this.fileProgressWrapper) {
        this.fileProgressWrapper = document.createElement("div");
        this.fileProgressWrapper.className = "progressWrapper";
        this.fileProgressWrapper.id = this.fileProgressID;

        this.fileProgressElement = document.createElement("div");
        this.fileProgressElement.className = "progressContainer";

        var progressCancel = document.createElement("a");
        progressCancel.className = "progressCancel";
        progressCancel.href = "#";
        progressCancel.style.visibility = "hidden";
        progressCancel.appendChild(document.createTextNode(" "));

        var progressText = document.createElement("div");
        progressText.className = "progressName";
        progressText.appendChild(document.createTextNode(file.name));

        var progressBar = document.createElement("div");
        progressBar.className = "progressBarInProgress";

        var progressStatus = document.createElement("div");
        progressStatus.className = "progressBarStatus";
        progressStatus.innerHTML = "&nbsp;";

        this.fileProgressElement.appendChild(progressCancel);
        this.fileProgressElement.appendChild(progressText);
        this.fileProgressElement.appendChild(progressStatus);
        this.fileProgressElement.appendChild(progressBar);

        this.fileProgressWrapper.appendChild(this.fileProgressElement);

        document.getElementById(targetID).appendChild(this.fileProgressWrapper);
        fadeIn(this.fileProgressWrapper, 0);

    } else {
        this.fileProgressElement = this.fileProgressWrapper.firstChild;
        this.fileProgressElement.childNodes[1].firstChild.nodeValue = file.name;
    }

    this.height = this.fileProgressWrapper.offsetHeight;

}
FileProgress.prototype.setProgress = function (percentage) {
    this.fileProgressElement.className = "progressContainer green";
    this.fileProgressElement.childNodes[3].className = "progressBarInProgress";
    this.fileProgressElement.childNodes[3].style.width = percentage + "%";
};
FileProgress.prototype.setComplete = function () {
    this.fileProgressElement.className = "progressContainer blue";
    this.fileProgressElement.childNodes[3].className = "progressBarComplete";
    this.fileProgressElement.childNodes[3].style.width = "";

};
FileProgress.prototype.setError = function () {
    this.fileProgressElement.className = "progressContainer red";
    this.fileProgressElement.childNodes[3].className = "progressBarError";
    this.fileProgressElement.childNodes[3].style.width = "";

};
FileProgress.prototype.setCancelled = function () {
    this.fileProgressElement.className = "progressContainer";
    this.fileProgressElement.childNodes[3].className = "progressBarError";
    this.fileProgressElement.childNodes[3].style.width = "";

};
FileProgress.prototype.setStatus = function (status) {
    this.fileProgressElement.childNodes[2].innerHTML = status;
};

FileProgress.prototype.toggleCancel = function (show, swfuploadInstance) {
    this.fileProgressElement.childNodes[0].style.visibility = show ? "visible" : "hidden";
    if (swfuploadInstance) {
        var fileID = this.fileProgressID;
        this.fileProgressElement.childNodes[0].onclick = function () {
            swfuploadInstance.cancelUpload(fileID);
            return false;
        };
    }
};

function swfuploadPreLoad(){
}
function swfuploadLoadFailed(){
  $("#spanButtonPlaceholder").html('<a href="http://www.adobe.com/go/getflashplayer" target="_blank"><img border="0" alt="Get Adobe Flash Player" src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif"></a>');
}
