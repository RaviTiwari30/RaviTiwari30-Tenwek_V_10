<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DirectPO_ItemWise.aspx.cs" Inherits="Design_Purchase_DirectPO_ItemWise" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            $('#txtPODate').change(function () {
                ChkDate();
            });
            $('#txtValidDate').change(function () {
                ChkDate();
            });
            $('#txtDeliveryDate').change(function () {
                ChkDate1();
            });

            // Page Load
            $('#ddlGST').val("T4");
            $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0);
            $('#<%=txtHSNCode.ClientID %>').val(''); $('#<%=lblGSTType.ClientID %>').text('IGST');
            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);

            //---

            $('#ddlGST').change(function () {
                $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0);
                if ($('#ddlGST').val() == "T4") {  // IGST
                    $('#lblGSTType').text("IGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtCGSTPer.ClientID%>').prop("disabled", true);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                } else if ($('#ddlGST').val() == "T6") { // CGST&SGST
                    $('#lblGSTType').text("CGST&SGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                    $('#<%=txtCGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                }
                else if ($('#ddlGST').val() == "T7") {  // CGST&UTGST
                    $('#lblGSTType').text("CGST&UTGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                    $('#<%=txtCGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                }
            });

        });
function ChkDate() {
    $.ajax({
        url: "../Common/CommonService.asmx/CompareDate",
        data: '{DateFrom:"' + $('#txtPODate').val() + '",DateTo:"' + $('#txtValidDate').val() + '"}',
        type: "POST",
        async: true,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = mydata.d;
            if (data == false) {
                $("#<%=lblMsg.ClientID%>").text('PO date can not be Greater than Valid date!');
                $("#<%=lblMsg.ClientID%>").focus();
                $("#<%=btnSavePO.ClientID%>").attr('disabled', 'disabled');
            }
            else {
                $("#<%=lblMsg.ClientID%>").text('');
                $("#<%=btnSavePO.ClientID%>").removeAttr('disabled');
                ChkDate1();
            }
        }
    });

}
function ChkDate1() {
    $.ajax({
        url: "../Common/CommonService.asmx/CompareDate",
        data: '{DateFrom:"' + $('#txtPODate').val() + '",DateTo:"' + $('#txtDeliveryDate').val() + '"}',
        type: "POST",
        async: true,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = mydata.d;
            if (data == false) {
                $("#<%=lblMsg.ClientID%>").text('PO date can not be Greater than Delivery date!');
                $("#<%=lblMsg.ClientID%>").focus();
                $("#<%=btnSavePO.ClientID%>").attr('disabled', 'disabled');
            }
            else {
                $("#<%=lblMsg.ClientID%>").text('');
                $("#<%=btnSavePO.ClientID%>").removeAttr('disabled');
            }
        }
    });

}
function MoveUpAndDownValue(textbox2, listbox2) {

    var f = document.theSource;
    var listbox = listbox2;
    var textbox = textbox2;
    if (event.keyCode == '38' || event.keyCode == '40') {
        if (event.keyCode == '40') {
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
        if (event.keyCode == '38') {
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
function suggestName(textbox2, listbox2, level) {
    if (isNaN(level)) { level = 1 }
    if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {

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
        if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
    }

}
function suggestValue(textbox2, listbox2, level) {
    if (isNaN(level)) { level = 1 }
    if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
        var f = document.theSource;
        var listbox = listbox2;
        var textbox = textbox2;

        var soFar = textbox.value.toString();
        var soFarLeft = soFar.substring(0, level).toLowerCase();
        var matched = false;
        var suggestion = '';
        for (var m = 0; m < listbox.length; m++) {
            suggestion = listbox.options[m].value.toString();
            suggestion = suggestion.substring(0, level).toLowerCase();
            if (soFarLeft == suggestion) {
                listbox.options[m].selected = true;

                matched = true;
                break;
            }
        }
        if (matched && level < soFar.length) { level++; suggestName(level) }
    }
}
//Password validation

    </script>

    <script type="text/javascript">
<!--
    function wopen(url, name, w, h) {
        // Fudge factors for window decoration space.
        // In my tests these work well on all platforms & browsers.
        w += 32;
        h += 96;
        var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
        win.resizeTo(w, h);
        win.moveTo(10, 100);
        win.focus();
    }
    // -->
    </script>
    <script type="text/javascript">

        function ButtonDisable(btn) {

            var narration = document.getElementById("ctl00$ContentPlaceHolder1$txtNarration").value;

            if (narration != '') {
                btn.disabled = true;
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave');
            }
        }
        function LTrim(value) {

            var re = /\s*((\S+\s*)*)/;
            return value.replace(re, "$1");

        }
        function RTrim(value) {

            var re = /((\s*\S+)*)\s*/;
            return value.replace(re, "$1");

        }
        // Removes leading and ending whitespaces
        function trim(value) {

            return LTrim(RTrim(value));
        }
        function sum() {
            var Nettotal = document.getElementById('<%=lbl.ClientID %>').value;
            if (Nettotal == '') Nettotal = 0;

            var fright = (document.getElementById('<%=txtFreight.ClientID %>').value);
            if (fright == '') fright = 0;

            var RoundOff = (document.getElementById('<%=txtRoundOff.ClientID %>').value);
            if (RoundOff == '') RoundOff = 0;

            var Scheme = (document.getElementById('<%=txtScheme.ClientID %>').value);
            if (Scheme == '') Scheme = 0;

            Nettotal = eval(Nettotal) + eval(fright) + eval(RoundOff) - eval(Scheme);
            Nettotal = eval(Nettotal) + eval(document.getElementById('<%=txtExciseOnBill.ClientID %>').value);

            document.getElementById('<%=txtInvoiceAmount.ClientID %>').value = Nettotal;
        }
        function MoveUpAndDownText(textbox2, listbox2) {
            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;
                            LoadDetail();
                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            LoadDetail();
                            return;
                        }
                    }
                }

            }
        }


        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
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
                        LoadDetail();
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }

        }
        function suggestValue(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
                var f = document.theSource;
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                for (var m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        LoadDetail();
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(level) }
            }
        }
    </script>
    <%-----------------Get Amount Info after selection the ListBoxItem---------------------%>
    <script type="text/javascript">
        function LoadDetail() {
            var strItem = $('[id$=lblItemName]').val();
            // var strItem = $('#<%=ListBox1.ClientID %>').val();
            var ItemID = strItem.split('#')[0];
            var DeptLedgerNo = '<%=ViewState["DeptLedgerNo"].ToString()%>'
            $.ajax({
                url: "../Store/WebServices/StockStatusRpt.asmx/BindListAmtInfoItemWise",
                data: '{ ItemID:"' + ItemID + '",DeptLedgerNo:"' + DeptLedgerNo + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var InvData = (typeof result.d) == 'string' ? eval('(' + result.d + ')') : result.d;
                    if (InvData.length != 0) {
                        $('#<%=txtRate1.ClientID %>').val(InvData[0].Rate).attr('readonly', 'readonly');
                        $('#<%=txtDiscount1.ClientID %>').val(InvData[0].DiscPer).attr('readonly', 'readonly');
                        $('#<%=txtVATPer.ClientID %>').val(InvData[0].VATPer).attr('readonly', 'readonly');
                        $('#<%=lblTaxID.ClientID %>').val(InvData[0].TaxID);
                        $('#<%=txtVendorID.ClientID %>').val(InvData[0].Vendor_ID).attr('readonly', 'readonly');
                        $('#<%=txtVendorName.ClientID %>').val(InvData[0].VendorName).attr('readonly', 'readonly');
                        $('#<%=lblConFactor.ClientID %>').val(InvData[0].ConFactor).attr('readonly', 'readonly');
                        $('#<%=lblMajorUnit.ClientID %>').val(InvData[0].MajorUnit).attr('readonly', 'readonly');
                        $('#<%=lblMinorUnit.ClientID %>').val(InvData[0].MinorUnit).attr('readonly', 'readonly');
                        $('#<%=txtExcisePer.ClientID %>').val(InvData[0].ExcisePer).attr('readonly', 'readonly');
                        $('#<%=lblTaxCalculatedOn.ClientID %>').val(InvData[0].TaxCalulatedOn).attr('readonly', 'readonly');

                        $('#<%=txtIGSTPer.ClientID %>').val(InvData[0].IGSTPercent).attr('readonly', 'readonly');
                        $('#<%=txtCGSTPer.ClientID %>').val(InvData[0].CGSTPercent).attr('readonly', 'readonly');
                        $('#<%=txtSGSTPer.ClientID %>').val(InvData[0].SGSTPercent).attr('readonly', 'readonly');
                        $("#ddlGST option:contains(" + InvData[0].GSTType + ")").attr('selected', 'selected');
                        $('#<%=txtHSNCode.ClientID %>').val(InvData[0].HSNCode).attr('readonly', 'readonly');
                        $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType).attr('readonly', 'readonly');

                        if (InvData[0].GSTType == "IGST") {
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                        } else if (InvData[0].GSTType == "CGST&SGST") {
                            $('#<%=txtIGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                        } else if (InvData[0].GSTType == "CGST&UTGST") {
                            $('#<%=txtIGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                        } else {
                            $("#ddlGST option:contains('IGST')").attr('selected', 'selected');
                            $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text('IGST');
                            $('#<%=txtHSNCode.ClientID %>').val('');
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                            
                        }
                        $('#<%=txtDeal1.ClientID%>,#<%=txtDeal2.ClientID%>').prop("readonly", true);
                        if (InvData[0].Deal != '') {
                            $('#txtDeal1').val(InvData[0].Deal.split('+')[0]);
                            $('#txtDeal2').val(InvData[0].Deal.split('+')[1]);

                        }
            }
            else {
                $('#<%=txtRate1.ClientID %>,#<%=txtDiscount1.ClientID %>,#<%=txtVATPer.ClientID %>,#<%=txtExcisePer.ClientID %>,#<%=lblTaxID.ClientID %>').val('');
                        $('#<%=txtVendorID.ClientID %>,#<%=txtVendorName.ClientID %>').val('');
                        $('#<%=lblMinorUnit.ClientID %>,#<%=lblConFactor.ClientID %>,#<%=lblMajorUnit.ClientID %>,#<%=lblTaxCalculatedOn.ClientID %>').val('');

                        $("#ddlGST option:contains('IGST')").attr('selected', 'selected');
                        $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text('IGST');
                        $('#<%=txtHSNCode.ClientID %>').val('');
                        $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                        $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                        $('#<%=txtDeal1.ClientID%>,#<%=txtDeal2.ClientID%>').prop("readonly", false);
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");

                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>

    <script type="text/javascript">
        //$(function () {
        //    $('input[id$=btnSaveItems]').click(function (e) {
        //        e.preventDefault();
        //    });
        //    });
    </script>

    <script type="text/javascript">
        function preventBackspace(e) {
            var evt = e || window.event;
            if (evt) {
                var keyCode = evt.charCode || evt.keyCode;
                if (keyCode === 8) {
                    if (evt.preventDefault) {
                        evt.preventDefault();

                    } else {
                        evt.returnValue = false;
                    }
                }
            }
        }
        function validateQty() {
            if (($("#<%=txtQuantity1.ClientID%>").val() == "") || ($("#<%=txtQuantity1.ClientID%>").val() == "0")) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Quantity');
                $("#<%=txtQuantity1.ClientID%>").focus();
                return false;
            }
        }
        $(function () {
            var MaxLength = 200;
            $("#<%=txtRemarks.ClientID%>").keypress(function (e) {
                if ($(this).val().length >= MaxLength) {
                    if (e.keyCode != 8) {
                        e.preventDefault();
                    }
                }
            });
        });
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        $(document).ready(function () {
            $onInit();
            $('#txtSearchItem').focus();
        });
        $onInit = function () {
            $('#txtSearchItem').autocomplete({
                source: function (request, response) {
                    if ($('[id$=ddlCategory] option:selected').val() == "0") {
                        modelAlert('Please Select Category', function () {
                            $('[id$=ddlCategory]').focus();
                            $('#txtSearchItem').val('');
                            return false;
                        });
                        return false;
                    }
                    else {
                        $Category = $('[id$=ddlCategory] option:selected').val()
                    }
                    if ($('[id$=ddlSubCategory] option:selected').val() == "0") {
                        modelAlert('Please Select SubCategory', function () {
                            $('[id$=ddlSubCategory]').focus();
                            $('#txtSearchItem').val('');
                            return false;
                        });
                        return false;
                    }
                    else {
                        $Subcategory = $('[id$=ddlSubCategory] option:selected').val();
                    }
                    $bindItems({ ddlSubCategory: $Subcategory, ddlCategory: $Category, PreFix: request.term }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    $validateInvestigation(i, function () { });
                },
                close: function (el) {
                    el.target.value = '';
                    $('[id$=txtQuantity1]').focus();
                },
                minLength: 3
            });

        };
        $bindItems = function (data, callback) {
            serverCall('DirectPO_ItemWise.aspx/BindItem', data, function (response) {
                if (response == "1") {
                    modelAlert('No Item Found', function () {
                        $('#txtSearchItem').val('');
                        return false;
                    });
                    return false;
                }
                else {
                    var responseData = $.map(JSON.parse(response), function (item) {
                        return {
                            label: item.TypeName,
                            val: item.ItemId
                        }
                    });
                }
                callback(responseData);
            });
        };
        $validateInvestigation = function (ctr, callback) {
            if (ctr.item.val != "") {
                $('[id$=lblItemName]').text(ctr.item.label);
                $('[id$=lblItemName]').val(ctr.item.val);
                $('[id$=lblItemID]').val(ctr.item.val);
                $('[id$=hdnItemText]').val(ctr.item.label);
                LoadDetail();
            }
        };
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Purchase Order (Item)</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" meta:resourcekey="lblMsgResource1" />
        </div>
        <div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Order Detail
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Category
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlCategory" runat="server"
                                    TabIndex="3" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"
                                    AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Sub&nbsp;Category
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSubCategory" runat="server"
                                    TabIndex="4" OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged"
                                    AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    HSN Code
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtHSNCode" runat="server" CssClass="ItDoseTextinputNum" Text="" ClientIDMode="Static"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Select&nbsp;Item
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtSearchItem" title="Enter Search text" />
                                <asp:TextBox ID="txtSearch" runat="server" Visible="false" AutoCompleteType="Disabled"
                                    onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                    onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                    meta:resourcekey="txtSearchResource1"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Item Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left">
                                <%-- <label id="lblItemName"></label>--%>
                                <asp:Label ID="lblItemName" runat="server"></asp:Label>
                                <asp:HiddenField ID="lblItemID" runat="server" />
                                <asp:HiddenField ID="hdnItemText" runat="server" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Purchase Unit
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="lblMajorUnit" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Quantity
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtQuantity1" onkeypress="return checkForSecondDecimal(this,event)" CssClass="requiredField" AutoCompleteType="Disabled" runat="server" meta:resourcekey="txtQuantity1Resource1"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtQuantity1"
                                    FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Rate
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtRate1" onkeypress="return checkForSecondDecimal(this,event)" runat="server" onKeyDown="preventBackspace();"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rqrate" runat="server" ErrorMessage="Rate Required!" ControlToValidate="txtRate1" Display="none" SetFocusOnError="true" ValidationGroup="Items"></asp:RequiredFieldValidator>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtRate1"
                                    FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                                <asp:TextBox ID="lblTaxID" runat="server" Style="display: none;"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Discount&nbsp;(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDiscount1" onkeypress="return checkForSecondDecimal(this,event)" runat="server" onKeyDown="preventBackspace();"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    GST Type 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left">
                                <asp:DropDownList ID="ddlGST" CssClass="ItDoseDropdownbox" Style="margin-top: 0px;" Width="116px" runat="server" ClientIDMode="Static"></asp:DropDownList>
                                <asp:Label ID="lblGSTType" runat="server" Style="color: red; font-weight: bold;" Text="" ClientIDMode="Static"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    CGST(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtCGSTPer" runat="server" CssClass="" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    SGST(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSGSTPer" runat="server" CssClass="" ClientIDMode="Static"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    IGST(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtIGSTPer" runat="server" CssClass="" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Tax Calculated On 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="lblTaxCalculatedOn" runat="server" onKeyDown="preventBackspace();"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Conversion&nbsp;Factor
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="lblConFactor" runat="server"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Supplier
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtVendorName" runat="server" MaxLength="50" onKeyDown="preventBackspace();"></asp:TextBox>
                                <asp:TextBox ID="txtVendorID" runat="server" Style="display: none;"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Deal 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDeal1" ClientIDMode="Static" runat="server" Width="105px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                                <asp:Label ID="Label1" runat="server" Text="+ " Width="5px" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:TextBox ID="txtDeal2" ClientIDMode="Static" runat="server" Width="105px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Free 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtDiscount1"
                                    FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                                <asp:RadioButtonList ID="rbtnFree" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Selected="True" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row"></div>
                        <div class="row" style="text-align: center">
                            <asp:Button ID="btnSaveItems" runat="server" CssClass="ItDoseButton" OnClientClick="return validateQty()"
                                Text="Add" ValidationGroup="Items" meta:resourcekey="btnSaveItemsResource1" OnClick="btnSaveItems_Click" />
                        </div>
                    </div>
                </div>
                <div>
                    <table style="width: 100%; border-collapse: collapse; display: none">
                        <tr style="display: none;">
                            <td style="text-align: right;">Select Vendor :&nbsp;</td>
                            <td colspan="2" style="text-align: left">
                                <asp:DropDownList ID="ddlVendor" runat="server" Width="250px" meta:resourcekey="ddlVendorResource1" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan="2" rowspan="2">
                                <table style="width: 100%; border-collapse: collapse">
                                    <tr style="display: none;">
                                        <td style="text-align: right">Sale&nbsp;Tax(%)&nbsp;:&nbsp;</td>
                                        <td style="text-align: left">
                                            <asp:DropDownList ID="ddlTax1" runat="server" Height="22px" Width="80px" meta:resourcekey="ddlTAX1Resource1">
                                                <asp:ListItem>0</asp:ListItem>
                                                <asp:ListItem>5.25</asp:ListItem>
                                                <asp:ListItem>13.125</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="text-align: right">Sale Unit :&nbsp;</td>
                                        <td style="text-align: left">
                                            <asp:TextBox ID="lblMinorUnit" runat="server" Width="80px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr style="display: none">
                                        <td style="text-align: right">VAT(%) :&nbsp;</td>
                                        <td style="text-align: left">
                                            <asp:TextBox ID="txtVATPer" onkeypress="return checkForSecondDecimal(this,event)" runat="server" Width="80px" onKeyDown="preventBackspace();"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtVATPer"
                                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                            </cc1:FilteredTextBoxExtender>
                                        </td>
                                        <td style="text-align: right">Excise(%) :&nbsp;</td>
                                        <td style="text-align: left">
                                            <asp:TextBox ID="txtExcisePer" onkeypress="return checkForSecondDecimal(this,event)" runat="server" Width="80px" onKeyDown="preventBackspace();"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtExcisePer"
                                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                            </cc1:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 121px; text-align: right"></td>
                            <td style="width: 162px; text-align: left; vertical-align: top;">
                                <asp:ListBox ID="ListBox1" runat="server" CssClass="ItDoseDropdownbox" Height="164px"
                                    Width="304px" meta:resourcekey="ListBox1Resource1" onChange="LoadDetail();"></asp:ListBox></td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: left"></td>
                            <td colspan="2" rowspan="1"></td>
                        </tr>
                    </table>
                </div>
            </div>


            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Order Items Detail
                </div>
                <div class="" style="text-align: center;">
                    <asp:Panel ID="pnlOrderDetail" runat="server" Visible="false" ScrollBars="Vertical" Height="200">

                        <asp:GridView ID="gvPODetails" DataKeyNames="ItemID" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowDeleting="gvPODetails_RowDeleting1" meta:resourcekey="gvPODetailsResource1" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." meta:resourcekey="TemplateFieldResource1">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <HeaderStyle Width="20px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Suplier Name" meta:resourcekey="TemplateFieldResource1">
                                    <ItemTemplate>
                                        <%# Eval("VendorName") %>
                                    </ItemTemplate>
                                    <HeaderStyle Width="175px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item Name" meta:resourcekey="TemplateFieldResource1">
                                    <ItemTemplate>
                                        <%# Eval("ItemName") %>
                                    </ItemTemplate>
                                    <HeaderStyle Width="200px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Available Qty." meta:resourcekey="TemplateFieldResource8">
                                    <ItemTemplate>
                                        <asp:Label ID="lblInhandQty" runat="server" Text='<%# Eval("InHand Qty") %>' CssClass="ItDoseTextinputNum"
                                            meta:resourcekey="lblInhandQtyResource1" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Order Qty." meta:resourcekey="TemplateFieldResource8">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRecQty" runat="server" Text='<%# Eval("Order Qty") %>' CssClass="ItDoseTextinputNum"
                                            meta:resourcekey="lblRecQtyResource1" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Unit" meta:resourcekey="TemplateFieldResource2">
                                    <ItemTemplate>
                                        <asp:Label ID="lblunit" runat="server" Text='<%# Eval("Unit") %>' meta:resourcekey="lblunitResource1" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Free">
                                    <ItemTemplate>
                                        <asp:Label ID="lblFree" Visible="false" runat="server" Text='<%# Eval("Free") %>' />
                                        <asp:Label ID="lblFreeDisplay" runat="server" Text='<%# Util.GetInt(Eval("Free"))==1 ? "Yes":"No" %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Unit Price" meta:resourcekey="TemplateFieldResource3">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate") %>' meta:resourcekey="lblRateResource1" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="60px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Disc." meta:resourcekey="TemplateFieldResource5">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("DiscPer") %>' meta:resourcekey="lblDiscountResource1" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Deal" meta:resourcekey="TemplateFieldResource5">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDeal" runat="server" Text='<%# Eval("IsDeal") %>' meta:resourcekey="lblDiscountResource1" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="GST Type" meta:resourcekey="TemplateFieldResource5">
                                    <ItemTemplate>
                                        <asp:Label ID="lblGST_Type" runat="server" Text='<%# Eval("GSTType") %>' />
                                        <asp:Label ID="lblHSN_Code" runat="server" Text='<%# Eval("HSNCode") %>' Visible="false" />
                                        <asp:Label ID="lblIGSTPer" runat="server" Text='<%# Eval("GSTType") %>' Visible="false" />
                                        <asp:Label ID="lblCGSTPer" runat="server" Text='<%# Eval("CGSTPercent") %>' Visible="false" />
                                        <asp:Label ID="lblSGSTPer" runat="server" Text='<%# Eval("SGSTPercent") %>' Visible="false" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="GST(%)" meta:resourcekey="TemplateFieldResource5">
                                    <ItemTemplate>
                                        <asp:Label ID="lblGSTPer" runat="server" Text='<%# Eval("GSTPer") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="NetAmt." meta:resourcekey="TemplateFieldResource8">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBuyPrice" runat="server" Text='<%# Eval("BuyPrice") %>' CssClass="ItDoseTextinputNum"
                                            meta:resourcekey="lblNetAmtResource1" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="70px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Total Amt." meta:resourcekey="TemplateFieldResource8">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNetAmt" runat="server" Text='<%# Eval("NetAmt") %>' CssClass="ItDoseTextinputNum"
                                            meta:resourcekey="lblNetAmtResource1" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="70px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:CommandField HeaderText="Remove" DeleteImageUrl="~/Images/Delete.gif" ShowDeleteButton="true" ButtonType="Image">
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:CommandField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Purchase Order Information
                </div>
                <div>
                    <div style="float: left; clear: both; display: none;">
                        <label class="labelForTag">Freight:</label>
                        <asp:TextBox ID="txtFreight" runat="server" Width="75px" CssClass="ItDoseTextinputNum" />
                        R/o Amt(+ -)&nbsp :
            <asp:TextBox ID="txtRoundOff" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                Width="75px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                            TargetControlID="txtRoundOff" FilterType="Custom, Numbers" ValidChars=".-">
                        </cc1:FilteredTextBoxExtender>
                        Scheme&nbsp :
              <asp:TextBox ID="txtScheme" runat="server" CssClass="ItDoseTextinputNum" Text="0" Width="75px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                            TargetControlID="txtScheme" FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                        &nbsp;
              Bill Amount&nbsp :
    <asp:TextBox ID="txtInvoiceAmount" runat="server" Width="75px" CssClass="ItDoseTextinputNum"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtInvoiceAmount" FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                        &nbsp;
                   <asp:Label ID="lblCurreny_Amount" runat="server" ClientIDMode="Static"
                       Style="display: none"></asp:Label>
                        <asp:TextBox ID="lblCurrencyNotation" runat="server" Style="display: none;"></asp:TextBox>
                        <asp:TextBox ID="txtCurreny_Amount" Style="display: none" ClientIDMode="Static" runat="server"></asp:TextBox>
                        <div style="display: none">
                            <asp:TextBox ID="lbl" runat="server" meta:resourcekey="lblResource1"></asp:TextBox>
                        </div>
                        Excise On Bill :&nbsp;
         <asp:TextBox ID="txtExciseOnBill" Width="75px" Text="0" CssClass="ItDoseTextinputNum" runat="server"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server"
                            TargetControlID="txtExciseOnBill" FilterType="Custom, Numbers" ValidChars=".-">
                        </cc1:FilteredTextBoxExtender>

                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        PO Date
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtPODate" runat="server" Width="" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="cePODate" TargetControlID="txtPODate" Format="dd-MMM-yyyy"
                                        Animated="true" runat="server">
                                    </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Valid&nbsp;Date
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtValidDate" runat="server" Width="" Style="text-align: left" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="ceValidDate" TargetControlID="txtValidDate" Format="dd-MMM-yyyy"
                                        Animated="true" runat="server">
                                    </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Type
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlPOType" runat="server" OnSelectedIndexChanged="ddlPOType_SelectedIndexChanged" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Delivery Date
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDeliveryDate" runat="server" Width="" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="ceDeliveryDate" TargetControlID="txtDeliveryDate" Format="dd-MMM-yyyy"
                                        Animated="true" runat="server">
                                    </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Remarks
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtRemarks" Width="" runat="server" TextMode="MultiLine" MaxLength="200" />
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" FilterType="Custom, Numbers" TargetControlID="txtFreight" ValidChars="."></cc1:FilteredTextBoxExtender>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                    </label>
                                </div>
                                <div class="col-md-5">
                                </div>
                            </div>
                        </div>
                    </div>
                    <table style="width: 100%; display: none;">
                        <tr>
                            <td style="text-align: right; display: none">Narration :&nbsp
                            </td>
                            <td colspan="4" style="text-align: left; display: none">
                                <asp:TextBox ID="txtNarration" Width="317px" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText" ValidationGroup="Save" MaxLength="200" />
                            </td>
                            <td style="text-align: right; vertical-align: top">:&nbsp;
                            </td>
                            <td colspan="4" style="text-align: left"></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:Label ID="lblchktxt" runat="server" Text="Print:"></asp:Label>
                    <asp:CheckBox ID="chkPrintImg" Checked="true" runat="server" />
                    <asp:Button ID="btnSavePO" runat="server" Text="Save" CssClass="ItDoseButton" ValidationGroup="Save" meta:resourcekey="btnSavePOResource1" OnClick="btnSavePO_Click" OnClientClick="return ValidatePass();" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="ItDoseButton" CausesValidation="False" OnClick="btnReset_Click" />
                    <asp:RequiredFieldValidator ID="rq2" runat="server" ErrorMessage="Specify Narration" Display="None" ControlToValidate="txtNarration" SetFocusOnError="True" meta:resourcekey="rq1Resource1">*</asp:RequiredFieldValidator>
                </div>
            </div>
        </div>
        <div>
            <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="True"
                ShowSummary="False" ValidationGroup="Items" />
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                ShowSummary="False" meta:resourcekey="ValidationSummary1Resource1" />

        </div>
    </div>
</asp:Content>

