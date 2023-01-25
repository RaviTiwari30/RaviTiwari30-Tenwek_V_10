
function addFeaturesButton(parentTag) {
    var style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = '.pdfMainbtnclass {text-decoration: none;float: left;cursor: pointer;display: inline-block;padding: 4px 8px;}';
    style.innerHTML += '.pdfMainbtnclass:hover {background-color: #ddd;color: black;}';
    style.innerHTML += '.pdfMainbtnclassPrevious {background-color: #4CAF50;color: black;}';
    style.innerHTML += '.pdfMainbtnclassNext {background-color: #4CAF50;color: black;}';
    style.innerHTML += '.pdfMainbtnclassRound {border-radius: 50%;}';
    //style.innerHTML += '.pdfMainbtnclass:not(:active) {transition: background-color 1000ms step-end;}';
    style.innerHTML += '.pdfMainbtnclass:active {transform: translateY(4px);}';

    document.getElementsByTagName('head')[0].appendChild(style);
    var pageElement = document.getElementById('pdf-features');

    var previousTag = document.createElement('a');
    previousTag.innerHTML = '&#8249;';
    previousTag.id = 'pdfViewerPreviousBtn';
    previousTag.className = 'pdfMainbtnclass pdfMainbtnclassPrevious pdfMainbtnclassRound';
    pageElement.appendChild(previousTag);

    var nextTag = document.createElement('a');
    nextTag.innerHTML = '&#8250;';
    nextTag.id = 'pdfViewerNextBtn';
    nextTag.className = 'pdfMainbtnclass pdfMainbtnclassNext pdfMainbtnclassRound';
    pageElement.appendChild(nextTag);

    //var zoomTag = document.createElement('a');
    //zoomTag.innerHTML = 'zoom';
    //zoomTag.className = 'pdfMainbtnclass pdfMainbtnclassNext pdfMainbtnclassRound';
    //pageElement.appendChild(zoomTag);

}





function viewPdfDocument(targetDiv, pdfURl,defaultPageNumber,callback) {
    var pageElement = document.getElementById(targetDiv);
    if (pageElement === undefined || pageElement == null) {
        console.error('targetDiv not Found');
        return;
    }
    pageElement.style.overflow = 'auto';
    pageElement.innerHTML = '';
    pageElement.innerHTML += '<div id="pdf-features" style="text-align: center;width: 100%;"></div>'
    pageElement.innerHTML += '<canvas id="pdf-canvas"></canvas>';
    var canvas = document.getElementById('pdf-canvas');
    canvas.style.cursor = 'pointer';
    canvas.title = 'Click To (Zoom IN/Zoom OUT)';
    var context = canvas.getContext('2d');
    var reachedEdge = false;
    var touchStart = null;
    var touchDown = false;
    var lastTouchTime = 0;


    pageElement.addEventListener('touchstart', function (e) {
        touchDown = true;

        if (e.timeStamp - lastTouchTime < 500) {
            lastTouchTime = 0;
            toggleZoom();
        } else {
            lastTouchTime = e.timeStamp;
        }
    });

    pageElement.addEventListener('touchmove', function (e) {
        if (pageElement.scrollLeft === 0 ||
          pageElement.scrollLeft === pageElement.scrollWidth - page.clientWidth) {
            reachedEdge = true;
        } else {
            reachedEdge = false;
            touchStart = null;
        }

        if (reachedEdge && touchDown) {
            if (touchStart === null) {
                touchStart = e.changedTouches[0].clientX;
            } else {
                var distance = e.changedTouches[0].clientX - touchStart;
                if (distance < -100) {
                    touchStart = null;
                    reachedEdge = false;
                    touchDown = false;
                    openNextPage();
                } else if (distance > 100) {
                    touchStart = null;
                    reachedEdge = false;
                    touchDown = false;
                    openPrevPage();
                }
            }
        }
    });

    pageElement.addEventListener('touchend', function (e) {
        touchStart = null;
        touchDown = false;
    });

    var pdfFile;
    var currPageNumber = defaultPageNumber;

    var openNextPage = function () {
        var pageNumber = Math.min(pdfFile.numPages, currPageNumber + 1);
        if (pageNumber !== currPageNumber) {
            currPageNumber = pageNumber;
            openPage(pdfFile, currPageNumber);
        }
    };

    var openPrevPage = function () {
        var pageNumber = Math.max(1, currPageNumber - 1);
        if (pageNumber !== currPageNumber) {
            currPageNumber = pageNumber;
            openPage(pdfFile, currPageNumber);
        }
    };
  
    pageElement.addEventListener("contextmenu", function (e) {
        e.preventDefault();
    }, false);


    var zoomed = true;
    var toggleZoom = function () {
        debugger;
        zoomed = !zoomed;
        openPage(pdfFile, currPageNumber);
    };

    var fitScale = 1;
    var openPage = function (pdfFile, pageNumber) {
        debugger;
       var scale = zoomed ? fitScale : 1;
        pdfFile.getPage(pageNumber).then(function (page) {
            viewport = page.getViewport(1);

            if (zoomed) {
                var scale = pageElement.clientWidth / viewport.width;
                viewport = page.getViewport(scale);
            }

            canvas.height = viewport.height;
            canvas.width = viewport.width;

            var renderContext = {
                canvasContext: context,
                viewport: viewport
            };

            page.render(renderContext);
        });
    };

    canvas.addEventListener('click', toggleZoom);
    PDFJS.disableStream = true;
    PDFJS.getDocument(pdfURl).then(function (pdf) {
        pdfFile = pdf;
        openPage(pdf, currPageNumber, 1);
        addFeaturesButton(pageElement)
        document.getElementById('pdfViewerPreviousBtn').addEventListener('click', openPrevPage);
        document.getElementById('pdfViewerNextBtn').addEventListener('click', openNextPage);
        callback(true);
    });
   

}


