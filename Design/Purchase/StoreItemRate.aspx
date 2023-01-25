<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="StoreItemRate.aspx.cs" Inherits="Design_Purchase_StoreItemRate" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('.searchable').chosen("destroy").chosen({ width: '100%' });
            $("input[id*=txtPer]").bind("blur keyup", function () {
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

            // Page Load
            $('#ddlTAX1').val("T4"); $('#lblGSTType').text("IGST");
            $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0);
            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>,#<%=txtTAX1.ClientID%>').prop("disabled", true);

            //---

            $('#ddlTAX1').change(function () {
                $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0);
                if ($('#ddlTAX1').val() == "T4") {  // IGST
                    $('#lblGSTType').text("IGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtCGSTPer.ClientID%>').prop("disabled", true);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                } else if ($('#ddlTAX1').val() == "T6") { // CGST&SGST
                    $('#lblGSTType').text("CGST&SGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                    $('#<%=txtCGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                }
                else if ($('#ddlTAX1').val() == "T7") {  // CGST&UTGST
                    $('#lblGSTType').text("CGST&UTGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                    $('#<%=txtCGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                }
                TaxCal();
            });

            return true;
        });




function TaxCal() {
    $('#<%=txtTAX1.ClientID %>').val(Number($('#<%=txtIGSTPer.ClientID%>').val()) + Number($('#<%=txtCGSTPer.ClientID%>').val()) + Number($('#<%=txtSGSTPer.ClientID%>').val()));
}


function RestrictDoubleEntry(btn) {
    btn.disabled = true;
    btn.value = 'Submitting...';
    __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
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
function validatedot() {
    if (($("#<%=txtRate.ClientID%>").val().charAt(0) == ".")) {
        $("#<%=txtRate.ClientID%>").val('');
        return false;
    }
}
function ValidateDecimal() {
    var DigitsAfterDecimal = 2;
    var val = $("#<%=txtRate.ClientID%>").val();
    var valIndex = val.indexOf(".");
    if (valIndex > "0") {
        if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
            alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
            //                    $("#<%=txtRate.ClientID%>").val($("#<%=txtRate.ClientID%>").val().substring(0, ($("#<%=txtRate.ClientID%>").val().length - 1)))
            return false;
        }
    }
}
function check(e) {
    var keynum
    var keychar
    var numcheck
    // For Internet Explorer  
    if (window.event) {
        keynum = e.keyCode
    }
        // For Netscape/Firefox/Opera  
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
function chkRadio() {
    $(".GridViewStyle").find("input[id*=chkselect]").change(function () {
        if ($(".GridViewStyle").find("input[id*=chkselect] input:checked")) {
            $(this).closest(".GridViewStyle").find("input[id*=chkselect]").not(this).prop('checked', false);
        }
    });
}
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
function validateAmt(name) {
    if (name == "txtDiscAmt") {
        if ($('#<%=txtDiscAmt.ClientID %>').val() != "") {
            $('#<%=txtDiscPer.ClientID %>').val('');
        }
    }
    if (name == "txtDiscPer") {
        if ($('#<%=txtDiscPer.ClientID %>').val() != "") {
            $('#<%=txtDiscAmt.ClientID %>').val('');
        }
    }
}
function validateDis(name) {
    if ($('#<%=txtRate.ClientID %>').val() == "" || parseFloat($('#<%=txtRate.ClientID %>').val()) == 0) {
        $('#<%=txtDiscAmt.ClientID %>').val('');
        $('#<%=txtDiscPer.ClientID %>').val('');
        alert('Enter Rate First');
    }
    if (name == "txtDiscAmt") {
        if (parseFloat($('#<%=txtDiscAmt.ClientID %>').val()) > parseFloat($('#<%=txtRate.ClientID %>').val())) {
            $('#<%=txtDiscAmt.ClientID %>').val('');
            alert('Discount Amount Can not be Greater than Rate');
        }
        else {
            $('#<%=lblMsg.ClientID %>').text('');
        }
    }
    if (name == "txtDiscPer") {
        if (parseFloat($('#<%=txtDiscPer.ClientID %>').val()) > "100") {
            $('#<%=txtDiscPer.ClientID %>').val('');
            alert('Discount Percentage Can not be Greater than 100');
        }
        else {
            $('#<%=lblMsg.ClientID %>').text('');
        }
    }
}
    </script>
    <script type="text/javascript">
<!--
    function popup(url) {
        var width = 800;
        var height = 500;
        var left = (screen.width - width) / 2;
        var top = (screen.height - height) / 2;
        var params = 'width=' + width + ', height=' + height;
        params += ', top=' + top + ', left=' + left;
        params += ', directories=no';
        params += ', location=no';
        params += ', menubar=no';
        params += ', resizable=no';
        params += ', scrollbars=no';
        params += ', status=no';
        params += ', toolbar=no';
        newwin = window.open(url, 'windowname5', params);
        if (window.focus) { newwin.focus() }
        return false;
    }
    // -->

    function validateRate() {
        if ($('#<%=ddlVendor.ClientID %>').val() == "Select") {
            $('#<%=lblMsg.ClientID %>').text('Please Select Supplier');
            $('#<%=ddlVendor.ClientID %>').focus();
            return false;
        }
        if ($("#ddlCategory option:selected").text() == "Select") {
            $('#<%=lblMsg.ClientID %>').text('Please Select Category');
            $("#ddlCategory").focus();
            return false;
        }
        if ($("#lstItem option:selected").text() == "") {
            $('#<%=lblMsg.ClientID %>').text('Please Select Item');
            $("#lstItem").focus();
            return false;
        }

        //   if ($('#<%=txtRate.ClientID %>').val() == "") {
        //       $('#<%=lblMsg.ClientID %>').text('Please Enter Rate');
        //         $('#<%=txtRate.ClientID %>').focus();
        //       return false;
        //    }
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
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Set Items Pricing </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" meta:resourcekey="lblMsgResource1" />
        </div>
        <Ajax:UpdatePanel ID="up" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Supplier &amp; Item&nbsp;Detail
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-2">
                                    <label class="pull-left">
                                        Supplier
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlVendor" runat="server" TabIndex="1" CssClass="searchable">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <input type="button" id="btnaddNewVen" class="ItDoseButton" value="Add New" onclick="wopen('../Store/VendorDetail.aspx?Mode=1', 'popup1', 1200, 490); return false;">
                                    <asp:Button ID="Button1" Text="Add New" runat="server" CssClass="ItDoseButton" Style="display: none;" />
                                </div>
                                <div class="col-md-3">
                                    <asp:Button ID="btnReload" runat="server" CssClass="ItDoseButton " OnClick="btnReload_Click" Text="Reload Supplier" />
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Manufacturer
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlManufacturer" runat="server" TabIndex="1" CssClass="searchable">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <input type="button" id="BtnAddnewMan" class="ItDoseButton" value="Add New" onclick="wopen('../Store/ManufactureMaster.aspx?Mode=1', 'popup1', 1200, 490); return false;">
                                    <asp:Button ID="BtnAddnew" Text="Add New" runat="server" CssClass="ItDoseButton" Style="display: none;" />
                                </div>
                                <div class="col-md-2">
                                    <%--<span class="icon32 icon-color icon-refresh" runat="server"  CssClass="icon32 icon-color icon-refresh"   ID="BtnReloadMan" OnClick="BtnReloadMan_Click"  >--%>
                                        <asp:Button ID="BtnReloadMan" runat="server"  CssClass="ItDoseButton" Text="Reload Manufacturer" OnClick="BtnReloadMan_Click" />
                                    <%--</span>--%>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <label class="pull-left">
                                        Category
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="searchable" ClientIDMode="Static"
                                        TabIndex="3" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"
                                        AutoPostBack="true">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2"></div>
                                <div class="col-md-3">
                                    <asp:Button ID="btnAddNewCat" Text="Add New" runat="server" CssClass="ItDoseButton"
                                        OnClick="btnAddNewCat_Click" Visible="false" />
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
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <label class="pull-left">
                                        Items
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="lstItem" runat="server" AutoPostBack="True" ClientIDMode="Static" CssClass="searchable"
                                        OnSelectedIndexChanged="ddlItemGroup_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-2">
                                    <input id="btnAddNewItem" class="ItDoseButton" onclick="wopen('../Store/ItemMaster.aspx?Mode=1', 'popup1', 1200, 490); return false;" type="button" value="Add New"></input>
                                </div>
                                <div class="col-md-3">
                                    <asp:Button ID="btnRefershItem" runat="server" CssClass="ItDoseButton" OnClick="btnRefershItem_Click" Text="Reload Items" />
                                </div>
                            </div>

                        </div>
                        <div class="col-md-1"></div>
                    </div>
              
                    <div>
                        <asp:GridView ID="GrdRateDetail" AutoGenerateColumns="false" runat="server" CssClass="GridViewStyle"
                            OnRowCommand="GrdRateDetail_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                        <asp:Label ID="lblID" runat="server" Style="display: none;" Text='<%# Eval("ID")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Supplier" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("VendorName")%>
                                        <asp:Label ID="lblVendorID" runat="server" Style="display: none;" Text='<%# Eval("VendorID")%>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Manufacturer" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("Name")%>
                                        <asp:Label ID="lblManID" runat="server" Style="display: none;" Text='<%# Eval("Manufacturer_ID")%>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ItemName" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("ItemName")%>
                                        <asp:Label ID="lblItemID" runat="server" Style="display: none;" Text='<%# Eval("ItemID")%>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("Rate")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />

                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Disc.Amt." HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("DiscAmt")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tax Amt." HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("TaxAmt")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="NetAmt." HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("NetAmt")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="GST Type" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("GSTType")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="From Date" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("FromDate")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="To Date" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblToDate" runat="server" Style="display: none;" Text='<%# Eval("ToDate")%>'></asp:Label>
                                        <%# Eval("ToDate")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Entry Date" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("EntryDate")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="User Name" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("UserName")%>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Active" HeaderStyle-Width="100px" Visible="false" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblActive" runat="server" Style="display: none;" Text='<%# Eval("IsActive")%>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Change">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:Button runat="server" ID="btnActive" Text="Activate" CommandName="Active" CommandArgument='<%# Eval("ItemID")+"#"+Eval("ID")+"#"+Eval("VendorID") %>'
                                            Visible='<%#!Util.GetBoolean(Eval("IsActive")) %>' CssClass="ItDoseButton" />
                                        <asp:Button runat="server" ID="btnInActive" Text="De-Activate" CommandName="InActive"
                                            CommandArgument='<%# Eval("ItemID")+"#"+Eval("ID")+"#"+Eval("VendorID") %>' Visible='<%#Util.GetBoolean(Eval("IsActive")) %>' CssClass="ItDoseButton" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </ContentTemplate>
        </Ajax:UpdatePanel>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Items Pricing Detail&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucFromDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate2" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucToDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rate
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRate" onkeypress="return checkForSecondDecimal(this,event)" runat="server"></asp:TextBox>
                            <span style="color: red; font-size: 10px; display: none">*</span>
                            <asp:RequiredFieldValidator ID="rqrate" runat="server" ErrorMessage="Rate Required!"
                                ControlToValidate="txtRate" Display="none" SetFocusOnError="true" ValidationGroup="Items"></asp:RequiredFieldValidator>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtRate"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-md-3">
                            <label class="pull-left">
                                MRP
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRP" onkeypress="return checkForSecondDecimal(this,event)" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtMRP"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Purchase&nbsp;Unit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblPerchaseUnit" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                GST (%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTAX1" runat="server" Width="174px" ClientIDMode="Static">
                            </asp:DropDownList>&nbsp;
                        <asp:TextBox ID="txtTAX1" runat="server" Width="40px" MaxLength="9" ClientIDMode="Static"
                            onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDisc();" Text="0"> </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                GST Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtTAX1"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                            &nbsp
                        <asp:Label ID="lblGSTType" runat="server" Text="" Style="font-weight: bold;" ClientIDMode="Static"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Is Deal
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDeal1" ClientIDMode="Static" runat="server" Width="105px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                            <asp:Label ID="Label1" runat="server" Text="+ " Width="5px" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:TextBox ID="txtDeal2" ClientIDMode="Static" runat="server" Width="105px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
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
                            <asp:TextBox ID="txtIGSTPer" runat="server" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" decimalPlace="2" ClientIDMode="Static" Onkeyup="TaxCal();"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtIGSTPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                HSN Code 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtHSNCode" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtHSNCode"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                CGST(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCGSTPer" runat="server" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" decimalPlace="2" Onkeyup="TaxCal();" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtCGSTPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                SGST(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSGSTPer" runat="server" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" decimalPlace="2" Onkeyup="TaxCal();" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtSGSTPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Disc. Amt.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDiscAmt" onchange="validateDis('txtDiscAmt');" onkeypress="return checkForSecondDecimal(this,event)" Onkeyup="validateAmt('txtDiscAmt');" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtDiscAmt"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <span style="font-weight: bold; color: Red;">OR</span>&nbsp;Disc.(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDiscPer" ClientIDMode="Static" onchange="validateDis('txtDiscPer');" onkeypress="return checkForSecondDecimal(this,event)" Onkeyup="validateAmt('txtDiscPer');" runat="server"></asp:TextBox>

                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtDiscPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Tax Calculated On
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList ID="rblTaxCal" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Rate" Value="Rate"></asp:ListItem>
                                <asp:ListItem Text="Rate Inclusive" Value="RateInclusive"></asp:ListItem>
                                <asp:ListItem Text="RateAD" Value="RateAD" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Remarks
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRemarks" runat="server"
                                Height="" TextMode="MultiLine"></asp:TextBox>
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="text-align: center;">
                    <td style="width: 123px; text-align: right;">&nbsp;</td>
                    <td colspan="4" style="text-align: left">
                        <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" Visible="false" Text="Active This Quotation" />
                    </td>
                </tr>

                <tr style="width: 123px; text-align: center;">
                    <td colspan="6">
                        <asp:Button ID="btnAddItems" runat="server" CssClass="ItDoseButton" Text="Add"
                            OnClick="btnAddItems_Click" OnClientClick="return validateRate()" /></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Item List
            </div>
            <div>
                <asp:Panel ID="pnlRequestItem" runat="server" ScrollBars="Vertical" Height="270px" Width="100%">
                    <asp:GridView ID="gvRequestItems" runat="Server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="gvRequestItems_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Supplier Name" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("VendorName")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Manufacturer" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Manufacturer")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Name" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("ItemName")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Unit" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Unit")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="From Date" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("FromDate")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="To Date" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("ToDate")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="MRP" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("MRP")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Rate")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Disc.Amt." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("DiscAmt")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Disc.Per." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("DiscPer")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tax(%)" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("TotalTaxPer")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="GST Type" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("GSTType")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="IGST(%)" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("IGSTPercent")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="CGST(%)" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("CGSTPercent")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="SGST(%)" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("SGSTPercent")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="HSNCode" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("HSNCode")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Tax Amt." HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("TaxAmt")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Is Deal" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Deal")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="NetAmt." HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("NetAmt")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Active" HeaderStyle-Width="15px" ItemStyle-CssClass="GridViewItemStyle" Visible="false"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("IsActive")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Remove" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                        CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Enabled="false" CssClass="ItDoseButton" Text="Save"
                OnClick="btnSave_Click" OnClientClick="RestrictDoubleEntry(this);" />

        </div>
    </div>

    <asp:Panel ID="pnlcategory" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;"
        Width="436px">
        <div class="Purchaseheader">
            Category Master
        </div>
        <div class="content" style="text-align: center">
            <table style="height: 106px">
                <tr>
                    <td style="text-align: right; width: 200px;">Category Type
                    </td>
                    <td style="text-align: left;">
                        <Ajax:UpdatePanel runat="server" ID="up1">
                            <ContentTemplate>
                                <asp:DropDownList ID="ddlCategoryType" AutoPostBack="true" runat="server" Width="285px"
                                    OnSelectedIndexChanged="ddlCategoryType_SelectedIndexChanged">
                                    <asp:ListItem>ID</asp:ListItem>
                                </asp:DropDownList>
                                <asp:Label ID="lblRemarks" runat="server" ForeColor="#C04000"></asp:Label>
                            </ContentTemplate>
                        </Ajax:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 200px;">Name
                    </td>
                    <td style="text-align: left;">
                        <asp:TextBox ID="txtCatName" runat="server" Width="277px">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="height: 18px; text-align: right; width: 200px;">Abbreviation
                    </td>
                    <td style="height: 18px; text-align: left;">
                        <asp:TextBox ID="txtCatAbbreviation" runat="server" MaxLength="4">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 200px;">Active
                    </td>
                    <td style="text-align: left;">
                        <asp:RadioButtonList ID="rbtnCatActive" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Selected="True" Value="1">YES</asp:ListItem>
                            <asp:ListItem Value="0">NO</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 200px;">Print Order No.
                    </td>
                    <td style="text-align: left;">
                        <asp:TextBox ID="txtCatOrdeno" runat="server">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; width: 200px;" colspan="2">
                        <asp:Button ID="btnSaveCat" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSaveCat_Click" />
                        <asp:Button ID="btnCancelCat" runat="server" Text="Cancel" CausesValidation="false"
                            CssClass="ItDoseButton" Width="55px" />
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCat" runat="server" CancelControlID="btnCancelCat"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlcategory" PopupDragHandleControlID="Div1">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlSubCat" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; width: 455px;">
        <div class="POuter_Box_Inventory" id="DIV6" style="width: 450px;">
            <div class="Purchaseheader">
                Create New Sub Category
            </div>
            <div class="content" style="text-align: center;">
                <table>
                    <tr>
                        <td style="text-align: right">Category :
                        </td>
                        <td colspan="2" style="text-align: left">
                            <Ajax:UpdatePanel ID="up2" runat="server">
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlCategoryName" runat="server" Width="354px" OnSelectedIndexChanged="ddlCategoryName_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </ContentTemplate>
                            </Ajax:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; height: 26px;">Sub Category Name :
                        </td>
                        <td colspan="2" style="text-align: left; height: 26px;">
                            <asp:TextBox ID="txtSubCatName" runat="server">
                            </asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 18px; text-align: right">Display Name :
                        </td>
                        <td colspan="2" style="height: 18px; text-align: left">
                            <asp:DropDownList ID="ddlDisplayName" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Print Order No :
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtSubPrintOrder" runat="server" MaxLength="3">
                            </asp:TextBox>
                        </td>
                        <td colspan="1" style="text-align: left; width: 258px;">
                            <asp:CheckBox ID="chkScheduler" runat="server" Text="Does Affect Scheduler ?" Visible="false" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Abbreviation :
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtSubAbb" runat="server" MaxLength="4">
                            </asp:TextBox>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Active :
                        </td>
                        <td>
                            <asp:RadioButtonList ID="rdblstSubActive" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True">YES</asp:ListItem>
                                <asp:ListItem>NO</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="text-align: right"></td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 450px;">
            <div class="content" style="text-align: center;">
                <asp:Button ID="btnSaveSub" Text="Save" CssClass="ItDoseButton" runat="server"
                    OnClientClick="RestrictDoubleEntry(this);" TabIndex="13" OnClick="btnSaveSub_Click" />
                <asp:Button ID="btnCancelSub" runat="server" Text="Cancel" CausesValidation="false"
                    CssClass="ItDoseButton" />
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeSubCat" runat="server" CancelControlID="btnCancelSub"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlSubCat" PopupDragHandleControlID="Div1">
    </cc1:ModalPopupExtender>
    <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton"></asp:Button>
</asp:Content>
