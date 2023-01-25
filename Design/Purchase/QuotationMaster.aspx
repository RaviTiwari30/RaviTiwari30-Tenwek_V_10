<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="QuotationMaster.aspx.cs" Inherits="Design_Purchase_QuotationMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        function CloseScript() {          
            var remarks = document.getElementById("<%=txtRemarks.ClientID %>")
            remarks.value = label.value;
        }
        function openremarks() {         
            var remarks = document.getElementById("<%=txtRemarks.ClientID %>")
            label.value = ''
            label.value = remarks.value;
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

        function ValidateDecimalUnitPrice() {
            var DigitsAfterDecimal = 3;
            var val = $("#<%=txtRate.ClientID%>").val();
    var valIndex = val.indexOf(".");
    if (valIndex > "0") {
        if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
            alert("Please Enter Valid Cost Price, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");

            $("#<%=txtRate.ClientID%>").val($("#<%=txtRate.ClientID%>").val().substring(0, ($("#<%=txtRate.ClientID%>").val().length - 1)))
            return false;
        }
    }
}
        function validatedot() {
            ValidateDecimalUnitPrice();
            if (($("#<%=txtRate.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtRate.ClientID%>").val('');
                return false;
            }
        }
        function validatedots() {
            if (($("#<%=txtDisc.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtDisc.ClientID%>").val('');
                return false;
            }
            var DiscPer = $('#<%=txtDisc.ClientID %>').val();
            if (Number(DiscPer) > 100) {
                $('#<%=txtDisc.ClientID %>').val('');
                alert('Invalid Discount');
            }
        }
        
        function ValidateDecimalAmt() {
            var DigitsAfterDecimal = 2;
            var val = $("#<%=txtDisc.ClientID%>").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $("#<%=txtDisc.ClientID%>").val($("#<%=txtDisc.ClientID%>").val().substring(0, ($("#<%=txtDisc.ClientID%>").val().length - 1)))
                    return false;
                }
            }
        }
        function ValidateDecimal() {
            var DigitsAfterDecimal = 2;
            var val = $("#<%=txtRate.ClientID%>").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    return false;
                }
            }
        }

        function check(e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }

        function validatetax() {
            $("input[id*=txtPer]").bind("blur keyup keydown", function () {
                if (($(this).closest("tr").find("input[id*=txtPer]").val().charAt(0) == ".")) {
                    $(this).closest("tr").find("input[id*=txtPer]").val('');
                }
                var tax = $(this).closest("tr").find("input[id*=txtPer]").val();
                if (Number(tax) > 100) {
                    $(this).closest("tr").find("input[id*=txtPer]").val('');
                    alert('Invalid Discount');
                }
            });
            $("input[id*=txtTaxAmt]").bind("blur keyup keydown", function () {
                if (($(this).closest("tr").find("input[id*=txtTaxAmt]").val().charAt(0) == ".")) {
                    $(this).closest("tr").find("input[id*=txtTaxAmt]").val('');
                }
            });
            return true;
        }
        function chkRadio() {
            $(".GridViewStyle").find("input[id*=chkselect]").change(function () {
                if ($(".GridViewStyle").find("input[id*=chkselect] input:checked")) {
                    $(this).closest(".GridViewStyle").find("input[id*=chkselect]").not(this).prop('checked', false);
                }
            });
        }


        function wopen(url, name, w, h) {
            w += 32;
            h += 96;
            var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
            win.resizeTo(w, h);
            win.moveTo(10, 100);
            win.focus();
        }

        function validate() {
            var con = 0;
            if ($("#<%=ddlVendor.ClientID%>").val() == "0") {
                $('#<%=lblmsg.ClientID%>').text('Please Select Vendor');
                $('#<%=ddlVendor.ClientID%>').focus();
                con = 1;
                 return false;
             }
            if ($("#<%=txtQuotationNo.ClientID%>").val() == "") {
                $('#<%=lblmsg.ClientID%>').text('Please Enter Quotation No.');
                $('#<%=txtQuotationNo.ClientID%>').focus();
                con = 1;
                return false;
            }
           
            if ($('#<%=txtDeliveryTime.ClientID%>').val() != "") {
                var MaxValueMonth = 13;
                var MaxValueYrs = 161;
                var MaxValueDay = 32

                if ($('#<%=txtDeliveryTime.ClientID%>').val() >= MaxValueMonth && $('#<%=ddlDeliveryTime.ClientID%>').val() == "MONTH(S)") {
                    $('#<%=lblmsg.ClientID%>').text('Please Enter Valid Delivery Time In Month');
                    $('#<%=txtDeliveryTime.ClientID%>').val('');
                    $('#<%=txtDeliveryTime.ClientID%>').focus();
                    con = 1;
                    return false;
                }
                else if ($('#<%=txtDeliveryTime.ClientID%>').val() >= MaxValueYrs && $('#<%=ddlDeliveryTime.ClientID%>').val() == "YRS") {
                    $('#<%=lblmsg.ClientID%>').text('Please Enter Valid Delivery Time In YRS');
                    $('#<%=txtDeliveryTime.ClientID%>').val('');
                    $('#<%=txtDeliveryTime.ClientID%>').focus();
                    con = 1;
                    return false;
                }
                else if ($('#<%=txtDeliveryTime.ClientID%>').val() >= MaxValueDay && $('#<%=ddlDeliveryTime.ClientID%>').val() == "DAY(S)") {
                    $('#<%=lblmsg.ClientID%>').text('Please Enter Valid Delivery Time In Days');
                    $('#<%=txtDeliveryTime.ClientID%>').val('');
                    $('#<%=txtDeliveryTime.ClientID%>').focus();
                    con = 1;
                    return false;
                }

            }
            
            if (con==0) {
                document.getElementById('<%=btnSaveQuto.ClientID%>').disabled = true;
                document.getElementById('<%=btnSaveQuto.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSaveQuto', '');
            }
            else {
                document.getElementById('<%=btnSaveQuto.ClientID%>').disabled = false;
                document.getElementById('<%=btnSaveQuto.ClientID%>').value = 'Save';
            }
        }
    </script>

    <script type="text/javascript">
        function validateDeliveryTime() {
            var MaxValueMonth = 13;
            var MaxValueYrs = 161;
            var MaxValueDay = 32

            if ($('#<%=txtDeliveryTime.ClientID%>').val() >= MaxValueMonth && $('#<%=ddlDeliveryTime.ClientID%>').val() == "MONTH(S)") {
                $('#<%=lblmsg.ClientID%>').text('Please Enter Valid Delivery Time In Month');
                $('#<%=txtDeliveryTime.ClientID%>').val('');
                $('#<%=txtDeliveryTime.ClientID%>').focus();
                return false;
            }
            else if ($('#<%=txtDeliveryTime.ClientID%>').val() >= MaxValueYrs && $('#<%=ddlDeliveryTime.ClientID%>').val() == "YRS") {
                $('#<%=lblmsg.ClientID%>').text('Please Enter Valid Delivery Time In YRS');
                $('#<%=txtDeliveryTime.ClientID%>').val('');
                $('#<%=txtDeliveryTime.ClientID%>').focus();
                return false;
            }
            else if ($('#<%=txtDeliveryTime.ClientID%>').val() >= MaxValueDay && $('#<%=ddlDeliveryTime.ClientID%>').val() == "DAY(S)") {
                $('#<%=lblmsg.ClientID%>').text('Please Enter Valid Delivery Time In Days');
                $('#<%=txtDeliveryTime.ClientID%>').val('');
                $('#<%=txtDeliveryTime.ClientID%>').focus();
                return false;
            }
            else {

                $('#<%=lblmsg.ClientID%>').text('');
            }
}
$(document).ready(function () {
    $('#<%=txtDeliveryTime.ClientID%>').bind("blur keyup keydown", function (e) {
        validateDeliveryTime();
    });


    var MaxLength = 200;
    $('#<%=txtSilentFeatures.ClientID%>,#<%=txtAdditionalFeatures.ClientID%>').bind("cut copy paste", function (event) {
        event.preventDefault();
    });
    $('#<%=txtSilentFeatures.ClientID%>,#<%=txtAdditionalFeatures.ClientID%>').bind("keypress", function (e) {
        // For Internet Explorer  
        if (window.event) {
            keynum = e.keyCode
        }
        else if (e.which) {
            keynum = e.which
        }
        keychar = String.fromCharCode(keynum)
        if (e.keyCode == 39 || keychar == "'") {
            return false;
        }
        if ($(this).val().length >= MaxLength) {

            if (window.event)//IE
            {
                e.returnValue = false;
                return false;
            }
            else//Firefox
            {
                e.preventDefault();
                return false;
            }
        }
    });
});

        function ValidateAdd() {
            var con = 0;
    if ($("#<%=ddlVendor.ClientID%>").val() == "0") {
        $('#<%=lblmsg.ClientID%>').text('Please Select Vendor');
        $('#<%=ddlVendor.ClientID%>').focus();
        return false;
    }
    if ($("#<%=txtQuotationNo.ClientID%>").val() == "") {
        $('#<%=lblmsg.ClientID%>').text('Please Enter Quotation No.');
        $('#<%=txtQuotationNo.ClientID%>').focus();
        return false;
    }
    if ($("#<%=lstItem.ClientID%> option:selected").text() == "") {
        $('#<%=lblmsg.ClientID%>').text('Please Select Item');
        $('#<%=lstItem.ClientID%>').focus();
        return false;
    }
    if ($('#<%=txtDeliveryTime.ClientID%>').val() != "") {
        validateDeliveryTime();

    }
    if ($("#<%=txtRate.ClientID%>").val() == "") {
        $('#<%=lblmsg.ClientID%>').text('Please Enter Unit Price');
        $('#<%=txtRate.ClientID%>').focus();
        return false;
    }
}

$(document).ready(function () {
    $('#<%=txtQuotationNo.ClientID%>').bind("blur", function (e) {
        if (($("#<%=ddlVendor.ClientID%>").val() != 0) && ($("#<%=txtQuotationNo.ClientID%>").val() != "")) {
            QuotationNo();
        }

    });
});
function QuotationNo() {
    if (($("#<%=ddlVendor.ClientID%>").val() != 0) && ($("#<%=txtQuotationNo.ClientID%>").val() != "")) {
        $.ajax({
            url: "QuotationMaster.aspx/CheckQuotationNo",
            data: '{QuotationNo:"' + $.trim($("#<%=txtQuotationNo.ClientID%>").val()) + '",VendorID:"' + $("#<%=ddlVendor.ClientID%>").val().split('#')[0] + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var data = mydata.d;
                        if (data > 0) {
                            $('#<%=lblmsg.ClientID%>').text('Quotation No. Already Exists For Vendor ' + $("#<%=ddlVendor.ClientID%> option:selected").text());
                            $("#<%=txtQuotationNo.ClientID%>").focus();
                        }
                        else {
                            $('#<%=lblmsg.ClientID%>').text('');
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }

                });
            }
        }
        function chkQuotationNo() {
            if ($("#<%=txtQuotationNo.ClientID%>").val().trim() == "") {
                $('#<%=lblmsg.ClientID%>').text('Please Enter Quotation No.');
                $("#<%=txtQuotationNo.ClientID%>").focus();
                return false;
            }
            
        }
    </script>
  

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Quotation Management
                        <br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" EnableViewState="False" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="text-align:right">Vendor :&nbsp;</td>
                    <td colspan="2" class="left-align">
                        <asp:DropDownList ID="ddlVendor" runat="server" TabIndex="1" onchange="QuotationNo()"
                            Width="220px">
                        </asp:DropDownList>
                        <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <input type="button" id="btnaddNewVen" class="ItDoseButton" value="New" onclick="wopen('../Store/VendorDetail.aspx?Mode=1', 'popup1', 1040, 550); return false;" />

                    </td>

                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align:right">Quotation&nbsp;No.&nbsp;:&nbsp;</td>
                    <td  class="left-align">
                        <asp:TextBox ID="txtQuotationNo" AutoCompleteType="Disabled" runat="server" TabIndex="2" Width="124px" MaxLength="20"> </asp:TextBox>
                        <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <asp:Button ID="btnSearchQuot" runat="server" Text="Search" OnClick="btnSearchQuot_Click"
                            CssClass="ItDoseButton"   OnClientClick="return chkQuotationNo();"/>
                    </td>
                    <td style="text-align:right">Quotation&nbsp;Date&nbsp;:&nbsp;</td>
                    <td  class="left-align">
                        <div id="divRefDate" runat="server" style="text-align: left">

                            <asp:TextBox ID="refdate" runat="server" Width="90px" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="refdate">
                            </cc1:CalendarExtender>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">Category :&nbsp;</td>
                    <td  class="left-align">
                        <asp:DropDownList ID="ddlCategory" runat="server" Width="220px"
                            TabIndex="3"  OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"
                            AutoPostBack="true">
                        </asp:DropDownList>

                    </td>
                    <td style="text-align:right">Sub&nbsp;Category&nbsp;:&nbsp;</td>
                    <td  class="left-align">
                        <asp:DropDownList ID="ddlSubCategory" runat="server" Width="200px"
                            TabIndex="4"  OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged"
                            AutoPostBack="true">
                        </asp:DropDownList>


                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">Item&nbsp;Name :&nbsp;</td>
                    <td colspan="3" class="left-align">
                        <asp:TextBox ID="txtItem" runat="server" AutoCompleteType="Disabled"
                            onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtItem,ctl00$ContentPlaceHolder1$lstItem);"
                            onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtItem,ctl00$ContentPlaceHolder1$lstItem);"
                            TabIndex="3" Width="500px"></asp:TextBox>
                        <input type="button" id="btnAddNewItem" class="ItDoseButton" value="New" onclick="wopen('../Store/ItemMaster.aspx?Mode=1', 'popup1', 940, 550); return false;" />



                        <asp:Button ID="btnRefershItem" runat="server" Text="Refresh"
                            CssClass="ItDoseButton" OnClick="btnRefershItem_Click" />

                    </td>

                </tr>
                <tr>
                    <td></td>
                    <td colspan="3"  class="left-align">
                        <asp:ListBox ID="lstItem" runat="server" CssClass="ItDoseDropdownbox"
                            Width="506px"></asp:ListBox>
                        <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label></td>

                </tr>
                

                <tr>
                    <td style="text-align: right;">Model&nbsp;Number :&nbsp;</td>
                    <td style="text-align: left;">
                        <asp:TextBox ID="txtModelNumber" MaxLength="50" runat="server"></asp:TextBox></td>

                    <td style="text-align: right;"></td>
                    <td style="text-align: left;"></td>

                </tr>
                <tr>
                    <td style="text-align: right; width: 10%;">Delivery&nbsp;Time&nbsp;Required :&nbsp;</td>
                    <td style="text-align: left; width: 15%;">
                        <asp:TextBox ID="txtDeliveryTime" MaxLength="3" Width="54px" runat="server" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                        <asp:DropDownList ID="ddlDeliveryTime" runat="server" Width="90px" onchange="validateDeliveryTime();">
                            <asp:ListItem Text="DAY(S)"></asp:ListItem>
                            <asp:ListItem Text="MONTH(S)"></asp:ListItem>
                            <asp:ListItem Text="YRS"></asp:ListItem>


                        </asp:DropDownList>
                        <cc1:FilteredTextBoxExtender ID="ftbDeliveryTime" runat="server" ValidChars=".0123456789" TargetControlID="txtDeliveryTime"></cc1:FilteredTextBoxExtender>
                    </td>

                    <td style="text-align: right; width: 12%;">Payment Pattern :&nbsp;</td>
                    <td colspan="1" style="text-align: left; width: 22%;">
                        <asp:TextBox ID="txtPaymentPattern" MaxLength="50" runat="server"></asp:TextBox></td>

                </tr>
                <tr>
                    <td style="text-align: right; width: 10%;">AMC :&nbsp;</td>
                    <td style="text-align: left; width: 15%;">
                        <asp:TextBox ID="txtAMC" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)" runat="server"></asp:TextBox>

                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" ValidChars=".0123456789" TargetControlID="txtAMC"></cc1:FilteredTextBoxExtender>
                    </td>

                    <td style="text-align: right; width: 12%;">Operational Cost :&nbsp;</td>
                    <td colspan="1" style="text-align: left; width: 22%;">
                        <asp:TextBox ID="txtOperationalCost" MaxLength="100" runat="server"></asp:TextBox></td>
                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" ValidChars=".0123456789" TargetControlID="txtOperationalCost"></cc1:FilteredTextBoxExtender>

                </tr>
                <tr>
                    <td style="text-align: right; vertical-align:top" >Silent Features :&nbsp;</td>
                    <td style="text-align: left;">
                        <asp:TextBox ID="txtSilentFeatures" TextMode="MultiLine" Width="260px" Height="60px" runat="server"></asp:TextBox>

                    </td>

                    <td style="text-align: right; vertical-align:top">Additional&nbsp;Features&nbsp;:&nbsp;</td>
                    <td colspan="1" style="text-align: left;">
                        <asp:TextBox ID="txtAdditionalFeatures" TextMode="MultiLine" Width="260px" Height="60px" runat="server"></asp:TextBox>
                    </td>
                </tr>


                <tr>
                    <td style="text-align: right;vertical-align:top">Specification&nbsp;:&nbsp;
                    </td>
                    <td  class="left-align">
                        <asp:TextBox ID="lblSpecification" runat="server"
                            Width="260px" Height="60px" TextMode="MultiLine" TabIndex="8"> </asp:TextBox>
                    </td>
                    <td style="text-align: right;vertical-align:top">Quantity :&nbsp;
                       
                    </td>
                    <td style="vertical-align:top"  class="left-align">
                        <asp:TextBox ID="txtQty" runat="server" CssClass="ItDoseTextinputNum" Enabled="False"
                            TabIndex="9" ValidationGroup="Update" Width="50px">1</asp:TextBox>

                    </td>

                </tr>
                <tr>
                    <td style="text-align: right;">Unit Price :&nbsp;
                    </td>
                    <td  class="left-align">
                        <asp:TextBox ID="txtRate" runat="server" Width="80px" ValidationGroup="Update" AutoCompleteType="Disabled"
                            CssClass="ItDoseTextinputNum" TabIndex="9" MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)"
                            onkeyup="validatedot();"> </asp:TextBox>
                        <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>

                    </td>
                    <td style="text-align: right;">
                        <label style="width: 100px;">
                            Disc.&nbsp;(%):&nbsp;</label>
                    </td>
                    <td  class="left-align"s>
                        <asp:TextBox ID="txtDisc" runat="server" CssClass="ItDoseTextinputNum" TabIndex="10"
                            MaxLength="8" Width="110px" onkeypress="return checkForSecondDecimal(this,event)"
                            onkeyup="validatedots();"> </asp:TextBox>
                    </td>
                    
                </tr>
                <tr>
                    <td style="text-align: right; vertical-align:top">Tax :&nbsp;
                    </td>
                    <td  class="left-align">
                        <asp:GridView ID="grdTax" runat="Server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tax Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTaxName" runat="server" Text='<%#Eval("TaxName" )%>' />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tax (%)">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtPer" runat="server" Width="75px" CssClass="ItDoseTextinputNum" Visible='<%# Util.GetBoolean(Eval("isPer")) %>'
                                            Text='<%# Eval("Tax") %>' TabIndex="12" onkeypress="return checkForSecondDecimal(this,event)"
                                            onkeyup="validatetax();" MaxLength="8" />
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtPer"
                                            FilterType="Custom,Numbers" ValidChars="." />
                                        <asp:Label ID="lblTaxID" runat="server" Text='<%# Eval("TaxID") %>' Visible="false" />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>



                                <asp:TemplateField HeaderText="Tax Amt." HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtTaxAmt" runat="server" Visible='<%# Util.GetBoolean(Eval("IsAmt")) %>'
                                            Width="75px" CssClass="ItDoseTextinputNum" Text='<%# Eval("TaxAmt") %>' onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatetax();" MaxLength="8" />
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtTaxAmt"
                                            FilterType="Custom,Numbers" ValidChars="." />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td style="text-align: right; vertical-align:top">Remarks&nbsp;:&nbsp;
                    </td>
                    <td style="vertical-align:top"  class="left-align">
                        <asp:TextBox ID="txtRemarks" runat="server" Width="260px" Height="60px"
                            TextMode="MultiLine" TabIndex="11"> </asp:TextBox>
                        <asp:LinkButton ID="btnlargesize" OnClientClick="openremarks();" Style="display: none;"
                            runat="server" Text="LargeSize" />
                    </td>
                </tr>
                <tr>
                    <td ></td>

                    <td style="vertical-align:top"></td>
                    <td style="text-align: right; vertical-align:top">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;">Upload&nbsp;Document&nbsp;:&nbsp;
                    </td>

                    <td style="vertical-align:top">
                        <asp:FileUpload ID="ddlupload_doc" runat="server" />
                    </td>
                    <td style="text-align: right; vertical-align:top">&nbsp;
                    </td>
                </tr>

                <tr style="text-align:  center">


                    <td colspan="4" style="vertical-align:top">
                        <asp:Button ID="btnAdd" Text="Add" runat="server" CssClass="ItDoseButton" OnClick="btnAdd_Click"
                            TabIndex="13" OnClientClick="return ValidateAdd()" />
                    </td>

                </tr>
                <tr>

                    <td colspan="4">


                        <cc1:FilteredTextBoxExtender ID="ftbox1" runat="server" TargetControlID="txtRate"
                            FilterType="Custom,Numbers" ValidChars="." />
                        <cc1:FilteredTextBoxExtender ID="ftbox2" runat="server" TargetControlID="txtDisc"
                            FilterType="Custom,Numbers" ValidChars="." />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:GridView ID="grdItemQuto" runat="Server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                TabIndex="16" OnRowCommand="grdItemQuto_RowCommand">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ItemId" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="lblItemId" runat="server" Text='<%#Eval("ItemId" )%>' />
                            <asp:Label ID="lblType" runat="server" Text='<%#Eval("IsOld") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Item Name">
                        <ItemTemplate>
                            <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Generic" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblSalts" runat="server" Text='<%# Eval("SaltName") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Quantity">
                        <ItemTemplate>
                            <asp:Label ID="lblQty" runat="server" Text='<%# Eval("Qty") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Rate">
                        <ItemTemplate>
                            <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Discount">
                        <ItemTemplate>
                            <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("Discount") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tax">
                        <ItemTemplate>
                            <asp:Label ID="lblTax" runat="server" Text='<%# Eval("Tax") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Cost Price">
                        <ItemTemplate>
                            <asp:Label ID="lblCostPrice" runat="server" Text='<%# Eval("CostPrice") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Selling Price" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Vendor Name" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblVendorName" runat="server" Text='<%# Eval("VendorName") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Company">
                        <ItemTemplate>
                            <asp:Label ID="lblManufacturer" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="PerformaRefNo" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblQuotationRefNo" runat="server" Text='<%# Eval("QuotationRefNo") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ManufacturePerformaNo" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblManuQuotRefNo" runat="server" Text='<%# Eval("ManufactureQuotationNo") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Ref Date" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblRefDate" runat="server" Text='<%# Eval("RefDate") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Specification">
                        <ItemTemplate>
                            <asp:Label ID="lblSpecification" runat="server" Text='<%# Eval("Specification") %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete">
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButton1" ImageUrl="~/Images/Delete.gif" runat="server" CommandName="Remove"
                                CommandArgument='<%#Container.DataItemIndex %>' />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">

                <asp:Button ID="btnSaveQuto" runat="server" Text="Save" TabIndex="14" OnClick="btnSaveQuto_Click" OnClientClick="return validate();"
                    Visible="False" CssClass="ItDoseButton" />
            </div>
        </div>
    </div>  
    <asp:Panel ID="pnlVendorQuotation" runat="server" CssClass="pnlVendorItemsFilter"
        Style="display: none;" Width="600px" Height="120px">
        <table  cellpadding ="0px" cellspacing ="0px">
            <tr><td>
        <asp:GridView ID="grdVendorQuotationnew" runat="server" AutoGenerateColumns="False"
            CssClass="GridViewStyle" >
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:CheckBox ID="chkselect" GroupName="radio" runat="server" onclick="chkRadio()" Style="float: right; padding-right: 5px;" />
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:TemplateField>
                <asp:TemplateField Visible="false" HeaderText="ManufactureQuotNo">
                    <ItemTemplate>
                        <asp:Label ID="lblManuQuotNo" runat="server" Text='<%#Eval("ManufactureQuotNo") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Vendor Name">
                    <ItemTemplate>
                        <asp:Label ID="lblVendor" runat="server" Text='<%#Eval("VendorName") %>'></asp:Label>
                        <asp:Label ID="lblVendorID" runat="server" Text='<%#Eval("Vendor") %>' Visible="false"></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewLabItemStyle" Width="160px"/>
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Company Name">
                    <ItemTemplate>
                        <asp:Label ID="lblManufacturerName" runat="server" Text='<%#Eval("ManufacturerName") %>'></asp:Label>
                        <asp:Label ID="lblManufacturer" runat="server" Text='<%#Eval("Manufacturer") %>'
                            Visible="false"></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewLabItemStyle"  Width="160px"/>
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Quotation No.">
                    <ItemTemplate>
                        <asp:Label ID="lblQuotatioNo" runat="server" Text='<%#Eval("QuotationRefNo") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Reference No.">
                    <ItemTemplate>
                        <asp:Label ID="lblRefNo" runat="server" Text='<%#Eval("RefrenceNo") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle CssClass="GridViewLabItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        </td></tr>
       <tr>
           <td style="text-align:center" >
        <asp:Button ID="btnQuotSearchnew" runat="server" CssClass="ItDoseButton" Text="Search"
            OnClick="btnQuotSearchnew_Click" />
        <asp:Button ID="btncancelQuot" runat="server" Text="Cancel" CssClass="ItDoseButton" />
               </td>
       </tr>
             </table>
    </asp:Panel>
    <cc1:ModalPopupExtender  ID="mpequotnew" runat="server" DropShadow="true"
        TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlVendorQuotation"
        PopupDragHandleControlID="dragHandle" CancelControlID="btncancelQuot">
    </cc1:ModalPopupExtender>
    <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton"></asp:Button>
</asp:Content>


