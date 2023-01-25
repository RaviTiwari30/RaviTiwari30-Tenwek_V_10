
var ajaxInProgress = 0;
var unBlocksURL = [
   'CommonService.asmx/LoadOPD_All_ItemsLabAutoComplete',
   'CommonService.asmx/GetNotificationDetail',
   'Welcome.aspx/showdischarge',
   'IPFolder.aspx/BindBillDetails',
   'IPFolder.aspx/BindVitals',
   'CPOEFolder.aspx/BindBillDetails',
   'CPOEFolder.aspx/BindVitals',
   'LabFolder.aspx/BindBillDetails',
   'LabFolder.aspx/BindVitals',
   'CommonService.asmx/ConvertCurrency',
   'CommonService.asmx/GetConversionFactor',
   'CommonService.asmx/getConvertCurrecncy',
   'CommonService.asmx/BindPaymentModePanelWise',
   'CommonService.asmx/bindLabInvestigationRate',
   'Pharmacy.asmx/medicineItemSearch',
   'OPD_Refund.aspx/IsSampleCollected',
   'Cpoe_CommonServices.asmx/cpoeSearch',
   'PrescribeServices.asmx/GetFavoriteTemplates',
   'PrescribeServices.asmx/medicineItemSearch',
   'Pharmacy.asmx/GetPatientIndent',
   'PatientIssue.aspx/GetItems',
   'WebService.asmx/GetItemList',
   'CommonService.asmx/GetVatTaxPercent',
   'CommonService.asmx/CalculateTaxAmount'
];


function serverCall(url, data, callback, params) {
    var dParams = {};
    dParams.isReturn = false;
    $.extend(dParams, params);
    var ajaxCall = $.ajax({
        url: url,
        data: JSON.stringify(data),
        type: 'POST',
        async: true,
        isReturn: dParams.isReturn,
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        success: function (response)
        { callback(response.d === undefined ? response : response.d); },
        error: function (request, status, error) {
            if (request.status != 401) {
                if (!String.isNullOrEmpty(request.responseText))
                    try {
                        modelAlert('😥', function () {
                            console.log(JSON.parse(request.responseText));
                        });
                        console.log(JSON.parse(request.responseText));
                    } catch (e) {

                    }
            }
            $modelUnBlockUI();
        }
    });
    if (dParams.isReturn)
        return ajaxCall;
}


$.fn.showModel = function (params) {
    this.each(function (index, elem) {
        elem.style.display = 'block';
    });
};

$.fn.closeModel = function (params) {
    this.each(function (index, elem) {
        elem.style.display = 'none';
    });
};

$.fn.openModel = function (params) {
    this.each(function (index, elem) {
        elem.style.display = 'block';
    });
};

$.fn.hideModel = function (params) {
    this.each(function (index, elem) {
        elem.style.display = 'none';
    });
};


$.fn.customFixedHeader = function (params) {
    $(this).bind('scroll', function () {
        var translate = 'translate(0,' + this.scrollTop + 'px)';
        this.querySelector('thead').style.transform = translate;
    });
};

$.fn.entireTrim = function () {
    this.forEach(function (o) {
        Object.keys(o).forEach(function (key) {
            o[key] = typeof o[key] === 'string' ? o[key].trim() : o[key];
        });
    });
};







$.fn.bindDropDown = function (params) {
    /// <summary>
    /// this method bind the array of  select control using data 
    /// </summary>
    /// <param name="data"> Set the data As a Json</param>
    /// <param name="defaultValue"> Set the Default value</param>
    /// <param name="selectedValue"> Set the Selected value</param>
    /// <returns></returns>
    try {
        var elem = this.empty();
        if (params.defaultValue != null || params.defaultValue != '')
            elem.append($('<option />').val('0').text(params.defaultValue));
        $.each(params.data, function (index, data) {
            var dataAttr = {};
            var option = $(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]).attr('data', JSON.stringify(dataAttr));
            $(params.customAttr).each(function (i, d) { $(option).attr(d, data[d]); });
            elem.append(option);

        });
        if (params.selectedValue != null || params.selectedValue != '' || params.selectedValue != undefined)
            $(elem).val(params.selectedValue);


        if (params.isSearchAble || params.isSearchable) {
            $(elem).chosen("destroy").chosen({ width: '100%' });
        }
    } catch (e) {
        console.error(e.stack);
    }
};

$(document).ajaxStart(function (event, jqxhr, settings) {

}).ajaxSend(function (e, xhr, opts) {
    var temp = opts.url.split('/');
    var requestedURl = temp.length > 1 ? (temp[temp.length - 2] + '/' + temp[temp.length - 1].split('?')[0]) : temp[0];
    if (unBlocksURL.indexOf(requestedURl) < 0) {
        if (!opts.isReturn) {
            ajaxInProgress += 1;
            //console.log('Start Count:' + ajaxInProgress);
            $modelBlockUI();
        }
    }

}).ajaxError(function (e, xhr, opts) {
    if (xhr.status == 401) {
        modelAlert('Session Time Out !!!', function () {
            var requestpath = window.location.href;
            window.location.href = '/' + requestpath.split('/')[3] + '/Default.aspx?sessionTimeOut=true';
        });
    }

    //processUnBlock(e, xhr, opts);
    
}).ajaxSuccess(function (e, xhr, opts) {
   
   // processUnBlock(e, xhr, opts);

}).ajaxComplete(function (e, xhr, opts) {

    processUnBlock(e, xhr, opts);
   
}).ajaxStop(function (e, xhr, opts) {
});




var processUnBlock = function (e, xhr, opts) {
    var temp = opts.url.split('/');
    var requestedURl = temp.length > 1 ? (temp[temp.length - 2] + '/' + temp[temp.length - 1].split('?')[0]) : temp[0];
    if (unBlocksURL.indexOf(requestedURl) < 0) {
        if (!opts.isReturn) {
            ajaxInProgress = ajaxInProgress - 1;
            //console.log('End   Count:' + ajaxInProgress);
            if (ajaxInProgress == 0)
                $modelUnBlockUI();
        }
    }
}


var previewCountDigit = function (e, callback) {
    $('#tooltip' + e.target.id).addClass('visible');
    $('#tooltip' + e.target.id + ' span').text('Count: ' + e.target.value.length);
    callback(e);
};


var $commonJsInit = function (callback) {

    $('input[onlyNumber]').keypress(function (e) {
        $commonJsNumberValidation(e);
    });
    $('input[onlyNumber]').keydown(function (e) {
        $commonJsPreventDotRemove(e);
    });

    $('input[onlyText]').keypress(function (e) {
        $commonJsTextValidation(e);
    });

    $('input[onlyTextNumber]').keypress(function (e) {
        $commonJsAlphaNumberValidation(e);
    });
    // $commonJSToolTipInit(function () { });
    addModelEvent();
    callback(true);
};



var $commonJSToolTipInit = function () { MarcTooltips.add("[data-title]", "Count: 0", { position: "up", align: "left", onFocus: !0, onClick: !0 }); };

var $commonJsTextValidation = function (e) {

    if (e.target.value.length == e.target.getAttribute('onlyText'))
        e.preventDefault();
    var inputValue = (e.which) ? e.which : e.keyCode;
    var $allowCharsCode = String.isNullOrEmpty(e.target.getAttribute('allowCharsCode')) == true ? [] : e.target.getAttribute('allowCharsCode').split(',').map(Number);
    if ($allowCharsCode.indexOf(inputValue) > -1)
        return true;
    if (inputValue == 8)
        return true;


    if (inputValue == 94 || inputValue == 96)
        e.preventDefault();
    if (inputValue == 32 && e.target.selectionStart == 0)
        e.preventDefault();
    if (!(inputValue >= 65 && inputValue <= 122) && (inputValue != 32 && inputValue != 0)) {
        e.preventDefault();
    }
};

var $commonJsAlphaNumberValidation = function (e) {
    var regex = new RegExp("^[a-zA-Z0-9\b]+$");
    if (e.target.value.length == e.target.getAttribute('onlyTextNumber'))
        e.preventDefault();

    var key = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    if (!regex.test(key))
        e.preventDefault();

};

var $commonJsNumberValidation = function (e, callback) {
    var $onlynumber = e.target.getAttribute('onlynumber');
    //if (e.target.value == '0')
    //    e.target.value = '';

    var inputValue = (e.which) ? e.which : e.keyCode;

    if (e.target.value.length == $onlynumber && inputValue != 8 && inputValue != 0 && inputValue != 9)
        e.preventDefault();


    var $allowCharsCode = String.isNullOrEmpty(e.target.getAttribute('allowCharsCode')) == true ? [] : e.target.getAttribute('allowCharsCode').split(',').map(Number);
    if ($allowCharsCode.indexOf(inputValue) > -1)
        return true;


    if (inputValue != 8 && inputValue != 0 && inputValue != 9 && inputValue != 46 && (inputValue < 48 || inputValue > 57))
        e.preventDefault();





    var $decimalPlace = e.target.getAttribute('decimalPlace');
    var indexOfDecimal = e.target.value.indexOf('.');

    if ($decimalPlace != null) {
        if (indexOfDecimal != -1 && inputValue == 46)
            e.preventDefault();
        else if (indexOfDecimal != -1 && inputValue != 8 && inputValue != 0 && inputValue != 9) {
            if (e.target.selectionStart > indexOfDecimal)
                if (e.target.value.substr(e.target.value.indexOf('.') + 1, e.target.value.length).length == $decimalPlace)
                    e.preventDefault();
        }
    }
    else if (inputValue == 46)
        e.preventDefault();

    var $maxvalue = e.target.getAttribute('max-value');
    var evalue = parseFloat(e.target.value.slice(0, e.target.selectionStart) + e.key + e.target.value.slice(e.target.selectionStart + Math.abs(0)));
    if ($maxvalue != null)
        if ((evalue > parseFloat($maxvalue)))
            e.preventDefault();
        else if ((evalue == parseFloat($maxvalue)) && inputValue == 46)
            e.preventDefault();


    if ($.isFunction(callback))
        callback(e);

    //PreventDotRemove
    //var inputValue = (e.which) ? e.which : e.keyCode;
    //if (inputValue == 46)
    //    e.preventDefault();
    //var indexOfDecimal = e.target.value.indexOf('.');
    //var typeIndex = e.target.selectionStart;
    //if (inputValue == 8 && typeIndex == (indexOfDecimal + 1) && (e.target.value.substr(indexOfDecimal + 1, e.target.value.length).length > 0))
    //    e.preventDefault();

    //  if (parseFloat(((e.target.selectionStart<indexOfDecimal)?e.key+e.target.value: +e.target.value+ e.key)) > $maxvalue)
    //  e.preventDefault();
}

var $commonJsPreventDotRemove = function (e, callback) {
    var inputValue = (e.which) ? e.which : e.keyCode;
    if (inputValue == 46)
        e.preventDefault();
    var indexOfDecimal = e.target.value.indexOf('.');
    if (indexOfDecimal < 0) {
        if ($.isFunction(callback))
            callback(e);
        else
            return true;
    }
    var typeIndex = e.target.selectionStart;
    if (inputValue == 8 && typeIndex == (indexOfDecimal + 1) && (e.target.value.substr(indexOfDecimal + 1, e.target.value.length).length > 0)) {
        e.preventDefault();
    }
    else {
        if ($.isFunction(callback))
            callback(e);
        else
            return true;
    }

    // e.target.value = Number(e.target.value);
}

function addModelEvent() {
    $('div[model-target]').each(function (index, elem) {
        document.getElementById(this.getAttribute('model-target')).onclick = function () {
            elem.style.display = 'block';
        }
        this.getElementsByClassName('close')[0].onclick = function () { elem.style.display = "none"; };
    })

    $('input[type=button][data-dismiss],button[data-dismiss]').each(function (index, elem) {
        elem.onclick = function () {
            document.getElementById(this.getAttribute('data-dismiss')).style.display = 'none';
        }
    });
}

$.fn.getPropValues = function (callback) {
    var inputTextControl = $(this).find('input[type=text][prop]');
    var $modelValues = {};
    $(inputTextControl).each(function (index, elem) {
        $modelValues[this.attributes['prop'].value] = this.value;
    });
    var selectControl = $(this).find('select[prop]');
    $(selectControl).each(function (index, elem) {
        if (this.selectedIndex >= 0)
            $modelValues[this.attributes['prop'].value] = { value: this.value, text: this.options[this.selectedIndex].text };
        else
            $modelValues[this.attributes['prop'].value] = { value: '', text: '' };
    });

    var inputRadioControl = $(this).find('input[type=radio][prop]');
    $(inputRadioControl).each(function (index, elem) {
        this.checked == true ? $modelValues[this.attributes['prop'].value] = this.value : '';
    });
    callback($modelValues);
}

$.fn.setPropValues = function (params) {
    try {
        var $parentElem = this;
        var $modelValues = params.data;
        $(Object.keys($modelValues)).each(function (index, elem) {
            $($($parentElem).find('[prop=' + this + ']')).each(function () {
                if (this.type == 'text')
                    this.value = $modelValues[elem];
                if (this.type == 'select-one') {
                    this.value = $modelValues[elem];
                    if ($modelValues[elem] != undefined)
                        this.value == '' ? $(this.options).filter(function () { return this.text == $modelValues[elem] })[0].selected = true : '';
                }
                if (this.type == 'radio')
                    this.value == $modelValues[elem] ? this.checked = true : '';
            });
        });
        if (params.success != undefined || params.success != null)
            params.success(true)
    } catch (e) {
        console.error(e.stack)
        if (params.error != undefined || params.error != null)
            params.success(false, e.stack)
    }
}




Array.prototype.unique = function () {
    var tmp = {}, out = [];
    for (var i = 0, n = this.length; i < n; ++i) {
        if (!tmp[this[i]]) { tmp[this[i]] = true; out.push(this[i]); }
    }
    return out;
}








function getAge(birthDate, callback) {
    var daysInMonth = 30.436875;
    var dateSplit = birthDate.split("-");
    var dob = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);

    var aad = new Date();
    //else aad = new Date(ageAtDate);
    var yearAad = aad.getFullYear();
    var yearDob = dob.getFullYear();
    var years = yearAad - yearDob; // Get age in years.
    dob.setFullYear(yearAad);
    var aadMillis = aad.getTime();
    var dobMillis = dob.getTime();
    if (aadMillis < dobMillis) {
        --years;
        dob.setFullYear(yearAad - 1);
        dobMillis = dob.getTime();
    }
    var days = (aadMillis - dobMillis) / 86400000;
    var monthsDec = days / daysInMonth; // Months with remainder.
    var months = Math.floor(monthsDec); // Remove fraction from month.
    days = Math.floor(daysInMonth * (monthsDec - months));
    callback({ years: years, months: months, days: days });
}

String.isNullOrEmpty = function (value) {
    try {
        return (!value || typeof (value) == 'Object' || value == null || value == undefined || value.trim() == "" || value.length == 0);
    } catch (e) {
        return false;
    }
}




function precise_round(num, decimals) {
    return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
}

String.prototype.toCamelCase = function () {
    return this.replace(/^([A-Z])|\s(\w)/g, function (match, p1, p2, offset) {
        if (p2) return p2.toUpperCase();
        return p1.toLowerCase();
    });
};


String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
};
//var row = $('<tr/>');
//row.html('')
//var obj = {};
//row.find('td').each(function () {
//    var id = $(this).attr('id');
//    console.log(id.replace('td', '').toCamelCase() + ":$(this).find('" + id + "').text(),")
//});



function modelConfirmation(headerText, message, actionButtonText, cancelButtonText, callback, data) {

    if (!data)
        data = {};
    //var isAlert = false;
    //if (data.isAlert)
    //    isAlert = data.isAlert;

    var dialogDiv = "<div id='alertConfirmModel' class='modal fade'><div class='modal-dialog'><div style='min-width:250px' class='modal-content'>";

    //if (headerText != null && headerText != '' && headerText != 'null')
    if (!String.isNullOrEmpty(headerText) && !data.isAlert)
        dialogDiv += "<div class='modal-header'><h4 style='color:red' class='modal-title'>" + headerText + "</h4></div>";
    if (!String.isNullOrEmpty(headerText) && data.isAlert)
        dialogDiv += "<div style='padding: 10px;' class='modal-header'><h4 style='color:red' class='modal-title'>" + headerText + "</h4></div>";

    if (data.isAlert)
        dialogDiv += "<div style='text-align: center;padding: 0px;margin-left: 20px;margin-right: 20px;' class='modal-body'><p style='font-weight: bold;' id='alertConfirmMessage'>" + message + "</p></div>";
    else
        dialogDiv += "<div style='text-align: center;margin-left: 20px;margin-right: 20px;' class='modal-body'><p style='font-weight: bold;' id='alertConfirmMessage'>" + message + "</p></div>";

    //if ((actionButtonText != null && actionButtonText != '' && actionButtonText != 'null') || (cancelButtonText != null && cancelButtonText != '' && cancelButtonText != 'null'))

    if (data.isAlert)
        dialogDiv += "<div style='text-align:center;padding: 12px;' class='modal-footer'>";
    else
        dialogDiv += "<div style='text-align:center' class='modal-footer'>";
    //if (actionButtonText != null && actionButtonText != '' && actionButtonText != 'null')
    if (!String.isNullOrEmpty(actionButtonText)) {
        if (data.isAlert)
            dialogDiv += "<input id='alertConfirmOkButtonText' style='width:65px' class='btn ItDoseButton'  type='button' value='" + actionButtonText + "' />";
        else
            dialogDiv += "<input id='alertConfirmOkButtonText' class='btn ItDoseButton'  type='button' value='" + actionButtonText + "' />";
    }
    //if (cancelButtonText != null && cancelButtonText != '' && cancelButtonText != 'null')
    if (!String.isNullOrEmpty(cancelButtonText))
        dialogDiv += "<input id='alertConfirmCloseButtonText' class='btn ItDoseButton'  type='button' value='" + cancelButtonText + "' />";

    dialogDiv += "</div></div></div></div>";

    $nirajDiv = $('.nirajDiv');
    $nirajDiv.remove();
    var nirajDiv = document.createElement('Div');
    nirajDiv.id = 'nirajDiv';
    nirajDiv.className = 'nirajDiv';
    document.body.appendChild(nirajDiv);

    document.getElementById('nirajDiv').innerHTML = dialogDiv;
    document.getElementById('alertConfirmModel').style.display = 'block';
    (document.getElementById('alertConfirmOkButtonText') != null) ? document.getElementById('alertConfirmOkButtonText').focus() : '';
    document.getElementById('alertConfirmModel').onclick = function (e) {
        if (e.target.id == 'alertConfirmCloseButtonText') {
            document.getElementById('alertConfirmModel').style.display = 'none';
            callback(false);
        }
        else if (e.target.id == 'alertConfirmOkButtonText') {
            document.getElementById('alertConfirmModel').style.display = 'none';
            callback(true);
        }
    }

    document.body.onkeydown = function (evt) {
        var inputValue = (evt.which) ? evt.which : evt.keyCode;
        if (inputValue == 27) {
            if (document.getElementById('alertConfirmModel') != null) {
                document.getElementById('alertConfirmModel').style.display = 'none';
                callback(false);
            }
        }
        if (inputValue == 13) {
            if (document.getElementById('alertConfirmModel') != null) {
                //document.getElementById('alertConfirmModel').style.display = 'none';
                //callback(true);
            }
        }
    }



}



function modelAlert(message, callback) {
    modelConfirmation('Alert !!', message, 'Ok', null, function (response) {
        if (callback != undefined)
            callback(response);
    }, { isAlert: true });
}

function modelBlock(message, callback) {
    modelConfirmation(null, message, null, null, function (response) {
        if (callback != undefined)
            callback(response);
    });
}

function requestQuerystring(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}





function makeDragAble() {
    var draggable = $('.modal-header'); //element 

    draggable.on('mousedown', function (e) {
        var dr = $('.modal-body').addClass("drag").css("cursor", "move");
        height = dr.outerHeight();
        width = dr.outerWidth();
        max_left = dr.parent().offset().left + dr.parent().parent().parent().width() - dr.width();
        max_top = dr.parent().offset().top + dr.parent().parent().parent().height() - dr.height();
        min_left = dr.parent().offset().left;
        min_top = dr.parent().offset().top;

        ypos = dr.offset().top + height - e.pageY,
        xpos = dr.offset().left + width - e.pageX;
        $(document.body).on('mousemove', function (e) {
            var itop = e.pageY + ypos - height;
            var ileft = e.pageX + xpos - width;

            if (dr.hasClass("drag")) {
                if (itop <= min_top) { itop = min_top; }
                if (ileft <= min_left) { ileft = min_left; }
                if (itop >= max_top) { itop = max_top; }
                if (ileft >= max_left) { ileft = max_left; }
                dr.offset({ top: itop, left: ileft });
            }
        }).on('mouseup', function (e) {
            dr.removeClass("drag");
        });
    });

}

$.fn.parseTemplate = function (data) {
    var str = (this).html();
    var _tmplCache = {}
    var err = "";
    try {
        var func = _tmplCache[str];
        if (!func) {
            var strFunc =
            "var p=[],print=function(){p.push.apply(p,arguments);};" +
                        "with(obj){p.push('" +
            str.replace(/[\r\t\n]/g, " ")
               .replace(/'(?=[^#]*#>)/g, "\t")
               .split("'").join("\\'")
               .split("\t").join("'")
               .replace(/<#=(.+?)#>/g, "',$1,'")
               .split("<#").join("');")
               .split("#>").join("p.push('")
               + "');}return p.join('');";

            //alert(strFunc);
            func = new Function("obj", strFunc);
            _tmplCache[str] = func;
        }
        return func(data);
    } catch (e) { err = e.message; }
    return "< # ERROR: " + err.toString() + " # >";
}




var $modelBlockUI = function () {
    var requestpath = window.location.href;
    requestpath = '/' + requestpath.split('/')[3] + '/Images/loader.gif';
    var loader = '<img id="imgCustomJSLoader" style="width:100px;height:100px" alt="loading...." src="' + requestpath + '">'
    var dialogDiv = "<div id='modelBlockUI' style='padding-top: 215px;' class='modal fade'><div class='modal-dialog'><div style='width: 250px;margin: 0 auto;' class=''>";
    dialogDiv += "<div style='text-align: center;color: red' class='modal-body'><p style='font-weight: bold;' >" + loader + "</p></div>";
    dialogDiv += "</div></div></div>";
    $nirajDiv = $('.nirajDiv');
    $nirajDiv.remove();
    var nirajDiv = document.createElement('Div');
    nirajDiv.id = 'nirajDiv';
    nirajDiv.className = 'nirajDiv';
    document.body.appendChild(nirajDiv);
    document.getElementById('nirajDiv').innerHTML = dialogDiv;
    document.getElementById('modelBlockUI').style.display = 'block';
}

var $modelUnBlockUI = function () {
    try {
        document.getElementById('modelBlockUI').style.display = 'none';
        $nirajDiv = $('.nirajDiv');
        $nirajDiv.remove();
    } catch (e) {

    }
}


$toggleWindow = function (elem) {
    if ((document.fullScreenElement && document.fullScreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) {
        if (document.documentElement.requestFullScreen) {
            document.documentElement.requestFullScreen();
        } else if (document.documentElement.mozRequestFullScreen) {
            document.documentElement.mozRequestFullScreen();
        } else if (document.documentElement.webkitRequestFullScreen) {
            document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    } else {
        if (document.cancelFullScreen) {
            document.cancelFullScreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        }
    }
}

var _toggleWindow = function (_document) {
    if ((_document.fullScreenElement && _document.fullScreenElement !== null) || (!_document.mozFullScreen && !_document.webkitIsFullScreen)) {
        if (_document.documentElement.requestFullScreen) {
            _document.documentElement.requestFullScreen();
        } else if (_document.documentElement.mozRequestFullScreen) {
            _document.documentElement.mozRequestFullScreen();
        } else if (_document.documentElement.webkitRequestFullScreen) {
            _document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    } else {
        if (_document.cancelFullScreen) {
            _document.cancelFullScreen();
        } else if (_document.mozCancelFullScreen) {
            _document.mozCancelFullScreen();
        } else if (_document.webkitCancelFullScreen) {
            _document.webkitCancelFullScreen();
        }
    }
}


var addShortCutOptions = { 'type': 'keydown', 'propagate': true, 'target': document };

$(function ($) {
    $commonJsInit(function () {
        try {
            shortcut.add("Enter", function () {
                if (document.activeElement.tagName == 'button' || document.activeElement.type == 'button' || document.activeElement.type == 'submit')
                    $(document.activeElement);//.click();
            }, addShortCutOptions);
        } catch (e) {
        }
    });
});



(function ($) {


    




    $.expr[':'].containsIgnoreCase = function (n, i, m) {
        return jQuery(n).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
    };



    $.fn.progressbar = function (options) {

        var opts = $.extend({}, options);

        return this.each(function () {
            var $this = $(this);

            var $ul = $('<ul>').attr('class', 'progressbar');

            var currentIdx = -1

            $.each(opts.steps, function (index, value) {
                var $li = $('<li>').html(value.replace('@', '').replace('~', ''));
                $li.css('width', (100 / opts.steps.length) - 1 + '%');

                if (value.indexOf('@') > -1) {
                    $li.addClass('current');
                    currentIdx = index;
                }

                if (value.indexOf('~') > -1) {
                    $li.addClass('fail');
                }

                $ul.append($li);
            });

            for (var i = 0; i < currentIdx; i++) {
                $($ul.find('li')[i]).addClass('done');
            }

            $this.append($ul);
        });
    };
})(jQuery);


var validateEmail = function (emailAddress) {
    var emailPattern = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return emailPattern.test(emailAddress);
}