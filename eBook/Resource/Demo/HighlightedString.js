/*!
 ------------------------------------------------------------------------ 
 // Search Highlighted String
 ------------------------------------------------------------------------ 
 */
var selectedText = "";

function getHighlightedString() {
    var text        = window.getSelection();
    selectedText    = text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset - text.anchorOffset);
    
    alert(text.focusNode.parentNode.offsetParent);
    
    //js获取当前p所在页面的index
    $("p").mouseup(function(){
                    $(this).each(function () {
                        alert($(this).index());
                    });
    });
}

// ...
function stylizeHighlightedString(className) {
    var range               = window.getSelection().getRangeAt(0);
    alert(range.startOffset);
    
    var selectionContents   = range.extractContents();
    var span                = document.createElement("span");
    
    span.appendChild(selectionContents);
    
//background:url(../Res/underline.gif) repeat-x 0 bottom;
//padding-bottom:5px;
//text-decoration:none; background:url(k003.png) repeat-x 0 bottom; color:#000000;padding-bottom:4px;text-decoration:none;
//color:#e6e6fa;
//    alert("test");
//    span.setAttribute("class","uiWebviewHighlight"+ (+new Date()));
    span.setAttribute("class",className);
    span.style.backgroundColor  = "black";
    span.style.color            = "#000000";
    span.style.background = "url(./k003.png) repeat-x 0 bottom";
//    span.style.padding-bottom = "4px";
//    span.style.text-decoration = "none";
    
    
    range.insertNode(span);
    
    $("p ."+className).each(function () {
                 alert($(this).index());
                 });
}


// helper function, recursively removes the highlights in elements and their childs
function uiWebview_RemoveAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            if (element.getAttribute("class") == "uiWebviewHighlight") {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (uiWebview_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}

// the main entry point to remove the highlights
function uiWebview_RemoveAllHighlights() {
    selectedText = "";
    uiWebview_RemoveAllHighlightsForElement(document.body);
}