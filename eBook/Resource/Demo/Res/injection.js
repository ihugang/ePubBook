$(document).ready(function() {
    
                  $(this).addEaddEventListener("mousedown", function () {alert("test"));
                 // $('span').click(function(){alert('dd');});
                  $(document).mouseup(function(){
                                      longtouchedFire($(this));
                                      });   
                  
//                  setInterval("longtouchedFire('a')", 2000);
 });

function longtouchedFire(obj){
    /*
    // Get the selection range
    var range = window.getSelection().getRangeAt(0);
    
    // create a new DOM node and set it's style property to red
    var newNode = document.createElement('span');
    newNode.style.color = "red";
    
    // surround the selection with the new span tag
    range.surroundContents(newNode); 
    
    return;
     */
    /*
    if(obj.hasClass('underline')){
        obj.removeClass("underline");
    }
    else{
        obj.addClass("underline");
    }
    */
    
    var aOffset = window.getSelection().anchorOffset;
    var aNode = window.getSelection().anchorNode;
    var eOffset = window.getSelection().extentOffset;
    var eNode = window.getSelection().extentNode;   
    
    //if(selectText.length>0)
 
    makeSelectionRed();
    //alert($(eNode).text());
}

function makeSelectionRed() {
    rangy.init();
    var randomCssClass = "tags_" + (+new Date());
    var classApplier = rangy.createCssClassApplier(randomCssClass, true);
    classApplier.applyToSelection();
    // Now use jQuery to add the CSS colour and remove the class
    //$("." + randomCssClass).css( {"color": "red"} ).removeClass(randomCssClass);

   $("." + randomCssClass).addClass("underline");
    
    //清楚包含内的tags
    
  //alert($("." + randomCssClass).html()); 
    
    //当前页面 保存信息到本地－－下次恢复－－文字信息
    var selectText = getSelectedText();
    document.location = "iBooks:" + "tags:" + randomCssClass + ":" + selectText;
}

// 说明：获取页面上选中的文字 
function getS() {
    if (window.getSelection) { 
        return window.getSelection();
    }
    else if (document.getSelection) { 
        return document.getSelection();
    }
    else if (document.selection) { 
        return document.selection;
    }
}
function getSelectedText() {
    if (window.getSelection) { 
        return window.getSelection().toString();
    }
    else if (document.getSelection) { 
        return document.getSelection();
    }
    else if (document.selection) { 
        return document.selection.createRange().text;
    }
}

function loadBeforeTag(tagid){
    $("." + tagid).addClass("underline"); 
}


function loadjscssfile(filename, filetype){
    if (filetype=="js"){ //if filename is a external JavaScript file
        var fileref=document.createElement('script')
        fileref.setAttribute("type","text/javascript")
        fileref.setAttribute("src", filename)
    }
    else if (filetype=="css"){ //if filename is an external CSS file
        var fileref=document.createElement("link")
        fileref.setAttribute("rel", "stylesheet")
        fileref.setAttribute("type", "text/css")
        fileref.setAttribute("href", filename)
    }
    if (typeof fileref!="undefined")
        document.getElementsByTagName("head")[0].appendChild(fileref)
}