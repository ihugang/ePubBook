$(document).ready(function() {
//    alert("aa");
//                  $(this).addEaddEventListener("mousedown", function () {alert("test"));
                 // $('span').click(function(){alert('dd');});
//                  $(document).mouseup(function(){
//                                      longtouchedFire($(this));
////                                      
//                                      });   
                  
//                  setInterval("longtouchedFire('a')", 2000);
                  
//                  $('span').click(function(event){
//                                    alert('asd');
//                                  alert(event.target.nodeName);
//                                  alert(event.target.textContent);
//                                  alert(event.target.attributes.item(0).textContent);
//                                  alert(event.target.attributes.item(1).textContent);
//                                  
//                                    document.location = "iBooks:" + "tags:" + randomCssClass + ":" + selectText;
//                                    });
                  
                  
                  $('span').bind("click", function(event) {
                                 //alert('The mouse cursor is at(' + event.pageX + ',' + event.pageY + ')');
//                                 alert("bind");
                                 if(event.target.nodeName.toLowerCase() == "span"&&event.target.attributes.length != 0){
//                                     alert(event.target.nodeName);
//                                     alert(event.target.textContent);
//                                     alert(event.target.attributes.item(0).textContent);
//                                     alert(event.target.attributes.item(1).textContent);
                                     //                                 alert(event.target.hasAttributes());
                                     //                                 alert(document.activeElement.nodeName);
                                     var thisNodeName = event.target.nodeName;//当前标签名字
                                     var txt = event.target.textContent;//标签包含的内容
                                     var className = event.target.attributes.item(0).textContent;//标签 class 内容
                                     var styleText = event.target.attributes.item(1).textContent;//标签style样式
                                     //                                 document.location = "iBooks:"+"tags:"+className+":"text;
                                    var x=event.clientX;
                                    var y=event.clientY;
                                     make(className,txt,x,y);
                                 }
                    });
 });

function make(name,txt,x,y) {
//    alert("make");
//    alert(name);
    document.location = "iBooks:" + "tags:" + name + ":" + txt + ":" + x + ":"+ y;
//    removetheClass(name);
}

//删除样式
function removetheClass(name)
{
//    alert(name);
    $("."+name).removeAttr("style");
    $("."+name).removeAttr("class");
//    $("."+name).detach();
//    $("."+name).parentNode.removeChild(node);
}

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
//    $("." + tagid).addClass("underline"); 
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