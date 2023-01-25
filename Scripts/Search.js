

function searchByFirstChar(txtFirstNameSearch, txtCPTCodeSearch, txtInBetweenSearch, listbox, btnSelect, values, key, e) {
    var searchType = 0;
    if (txtFirstNameSearch.value.length > 0) {
        txtCPTCodeSearch.value = "";
        txtInBetweenSearch.value = "";
        searchType = 0;
    }
    getKeyCode(txtFirstNameSearch, txtCPTCodeSearch, txtInBetweenSearch, listbox, btnSelect, values, key, searchType, e);

}

function searchByCPTCode(txtFirstNameSearch, txtCPTCodeSearch, txtInBetweenSearch, listbox, btnSelect, values, key, e) {
    var searchType = 0;
    if (txtCPTCodeSearch.value.length > 0) {
        txtFirstNameSearch.value = "";
        txtInBetweenSearch.value = "";
        searchType = 1;
    }
    getKeyCode(txtFirstNameSearch, txtCPTCodeSearch, txtInBetweenSearch, listbox, btnSelect, values, key, searchType, e);

}

function searchByInBetween(txtFirstNameSearch, txtCPTCodeSearch, txtInBetweenSearch, listbox, btnSelect, values, key, e) {
    var searchType = 0;
    if (txtInBetweenSearch.value.length > 0) {
        txtFirstNameSearch.value = "";
        txtCPTCodeSearch.value = "";
        searchType = 2;
    }
    getKeyCode(txtFirstNameSearch, txtCPTCodeSearch, txtInBetweenSearch, listbox, btnSelect, values, key, searchType, e);
}

function getKeyCode(txtFirstNameSearch, txtCPTCodeSearch, txtInBetweenSearch, listbox, btnSelect, values, keys, searchType, e) {
    var key = (e.keyCode ? e.keyCode : e.charCode);
    if (searchType != 2)
        rebindProcedure(listbox, values, keys);
    if (key == 38 || key == 40) {
        var index = listbox.selectedIndex;
        if (key == 38) {
            listbox.selectedIndex = index - 1;
        }
        else if (key == 40) {
            listbox.selectedIndex = index + 1;
        }
        if (searchType == 0) {
            if (listbox[index].innerHTML.split('#')[1].trim() != "") {
                if (key == 38) {
                    txtFirstNameSearch.value = listbox[index - 1].innerHTML.split('#')[1].trim();
                }
                if (key == 40) {
                    txtFirstNameSearch.value = listbox[index + 1].innerHTML.split('#')[1].trim();
                }
                else
                    txtFirstNameSearch.value = listbox[index].innerHTML.split('#')[1].trim();
            }
        }
        else if (searchType == 1) {
            if (listbox[index].innerHTML.split('#')[0].trim() != "") {
                if (key == 38) {
                    txtCPTCodeSearch.value = listbox[index - 1].innerHTML.split('#')[0].trim();
                }
                if (key == 40) {
                    txtCPTCodeSearch.value = listbox[index + 1].innerHTML.split('#')[0].trim();
                }
                else
                    txtCPTCodeSearch.value = listbox[index].innerHTML.split('#')[0].trim();
            }
        }
        else if (searchType == 2) {
            if (listbox[index].innerHTML.split('#')[1].trim() != "") {
                if (key == 38) {
                    txtInBetweenSearch.value = listbox[index - 1].innerHTML.split('#')[1].trim();
                }
                if (key == 40) {
                    txtInBetweenSearch.value = listbox[index + 1].innerHTML.split('#')[1].trim();
                }
                else
                    txtInBetweenSearch.value = listbox[index].innerHTML.split('#')[1].trim();
            }
        }

        return;
    }
    if (key == 13) {
        btnSelect.click();
    }
    else {
        var filter = "";
        if (searchType == 0)
            filter = txtFirstNameSearch.value;
        else if (searchType == 1)
            filter = txtCPTCodeSearch.value;
        else if (searchType == 2)
            filter = txtInBetweenSearch.value;

        if (filter == '') {
            listbox.selectedIndex = 0;
            return;
        }

        var search = "";
        if (searchType == 0)
            search = txtFirstNameSearch.value;
        else if (searchType == 1)
            search = txtCPTCodeSearch.value;
        else if (searchType == 2)
            search = txtInBetweenSearch.value;
        if (search == undefined)
            return;
        DoListBoxFilter(listbox, search, searchType, filter, values, keys);
        if (searchType == 2) {
            listbox.selectedIndex = 0;
        }
    }
}

function rebindProcedure(listbox, values, keys) {
    if (values.length != listbox.length) {
        listbox.options.length = 0;
        for (i = 0; i < values.length; i++) {
            var opt = document.createElement("option");
            opt.text = values[i];
            opt.value = keys[i];
            listbox.options.add(opt);
        }
    }
}

function DoListBoxFilter(listBoxSelector, textbox, searchtype, filter, values, key) {
    var list = $(listBoxSelector);
    var selectBase = '<option value="{0}">{1}</option>';
    if (searchtype == 2)
        listBoxSelector.options.length = 0;


    if (searchtype == 0) {

        for (i = 0; i < values.length; ++i) {
            var value = '';
            if (values[i].indexOf('#') == -1)
                continue;
            else
                value = values[i].split('#')[1].trim();
            var len = textbox.length;

            if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                listBoxSelector.options[i].selected = true;
                return;
            }
        }
    }
    else if (searchtype == 1) {
        for (i = 0; i < values.length; ++i) {
            var value = '';
            if (values[i].indexOf('#') == -1)
                value = values[i];
            else
                value = values[i].split('#')[0].trim();
            var len = textbox.length;
            if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                listBoxSelector.options[i].selected = true;
                return;
            }
        }
    }
    else if (searchtype == 2) {
        for (i = 0; i < values.length; ++i) {
            var value = values[i];

            if (value == "" || value.toLowerCase().indexOf(filter.toLowerCase()) >= 0) {
                var opt = document.createElement("option");
                opt.text = value;
                opt.value = key[i];
                listBoxSelector.options.add(opt);
            }
        }
    }

}
