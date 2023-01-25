function MoveUpAndDownText(textbox2, listbox2, e) {

    var f = document.theSource;
    var listbox = listbox2;
    var textbox = textbox2;

    e = (e) ? e : (window.event) ? event : null;
    var charCode = (e.charCode) ? e.charCode :
                       ((e.keyCode) ? e.keyCode :
                       ((e.which) ? e.which : 0));
    if (charCode == 13) {
        textbox.value = "";
    }
    if (charCode == '38' || charCode == '40') {
        if (charCode == '40') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m + 1 == listbox.length) {
                        return;
                    }
                    listbox.options[m + 1].selected = true;
                    textbox.value = listbox.options[m + 1].text;

                    return;
                }
            }

            listbox.options[0].selected = true;
        }
        if (charCode == '38') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m == 0) {
                        return;
                    }
                    listbox.options[m - 1].selected = true;
                    textbox.value = listbox.options[m - 1].text;
                    return;
                }
            }
        }

    }
    
}



function suggestName(textbox2, listbox2, level, e) {
    if (isNaN(level)) { level = 1 }

    e = (e) ? e : (window.event) ? event : null;
    var charCode = (e.charCode) ? e.charCode :
                       ((e.keyCode) ? e.keyCode :
                       ((e.which) ? e.which : 0));



    if (charCode != 38 && charCode != 40 && charCode != 13 && charCode != 8) {
        var listbox = listbox2;
        var textbox = textbox2;
        var soFar = textbox.value.toString();
        var soFarLeft = soFar.substring(0, level).toLowerCase();
        var matched = false;
        var suggestion = '';
        var m
        for (m = 0; m < listbox.length; m++) {
            suggestion = listbox.options[m].text.toString();
            suggestion = suggestion.substring(0, level).toLowerCase();
            if (soFarLeft == suggestion) {
                listbox.options[m].selected = true;
                matched = true;
                break;
            }

        }
        if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level, e) }
    }

   
}