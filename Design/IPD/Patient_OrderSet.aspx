<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Patient_OrderSet.aspx.cs" Inherits="Design_IPD_Patient_OrderSet" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <script type="text/javascript">
            $(document).ready(function () {
                $('#<%=txtSearch.ClientID %>').focus();
                LoadCategory();
                LoadSubCategory();
                LoadItems();
                bindAdmissionDoctor();
            });
            var keys = [];
            var values = [];
            function SearchAndFilterBind() {
                var options = $('#<% = lstInv.ClientID %> option');
                $.each(options, function (index, item) {
                    keys.push(item.value);
                    values.push(item.innerHTML);
                });
            }
            $(function () {
                $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                    var key = (e.keyCode ? e.keyCode : e.charCode);
                    if (key == 13) {
                        if ((e.which == 13) && (e.target.id == "")) {
                            e.preventDefault();
                        }
                        $('#<% = txtSearch.ClientID %>').val('');
                        AddItem();
                        $('#<% = txtSearch.ClientID %>').focus();
                        return;
                    }
                    if (key == 38 || key == 40) {
                        var index = $('#<% = lstInv.ClientID %> option:selected').index();

                        var searchType = $("#<%=rblsearchtype.ClientID%> input[type:radio]:checked").val();
                        if (key == 38)
                            $('#<% = lstInv.ClientID %> ').attr('selectedIndex', index - 1);
                        else if (key == 40)
                            $('#<% = lstInv.ClientID %> ').attr('selectedIndex', index + 1);
                    $('#<% = lstInv.ClientID %> ').focus();
                        if (searchType == "0")
                            $('#<% = txtSearch.ClientID %>').val($.trim($('#<% = lstInv.ClientID %> option:selected').text().split('#')[0]));
                        else if (searchType == "1" || searchType == "2")
                            $('#<% = txtSearch.ClientID %>').val($.trim($('#<% = lstInv.ClientID %> option:selected').text().split('#')[1]));


                    return;
                }
                else {
                    var filter = $(this).val();
                    if (filter == '') {
                        $('#<% = lstInv.ClientID %> ').attr('selected', 'selected')
                        return;
                    }
                    DoListBoxFilter('#<% = lstInv.ClientID %>', '#<% = txtSearch.ClientID %>', $("#<%=rblsearchtype.ClientID%> input[type:radio]:checked").val(), filter, values, keys);
                        if ($("#<%=rblsearchtype.ClientID%> input[type:radio]:checked").val() == "2")
                            $('#<% = lstInv.ClientID %>').prop('selectedIndex', 0);
                    }
                });
                $('#<% = lstInv.ClientID %>').bind("keyup keydown", function (e) {
                    var key = (e.keyCode ? e.keyCode : e.charCode);

                    if (key == 13) {

                        if ((e.which == 13) && (e.target.id == "")) {
                            e.preventDefault();
                        }
                        $('#<% = txtSearch.ClientID %>').val('');

                        AddItem();
                        $('#<% = txtSearch.ClientID %>').focus();

                    }
                    else if (key == 38 || key == 40) {

                        var index = $('#<% = lstInv.ClientID %> option:selected').index();

                        var searchType = $("#<%=rblsearchtype.ClientID%> input[type:radio]:checked").val();
                        if (key == 38)
                            $('#<% = lstInv.ClientID %>').prop('selectedIndex', index);
                        else if (key == 40)
                            $('#<% = lstInv.ClientID %>').prop('selectedIndex', index);
                    $('#<% = lstInv.ClientID %> ').focus();
                        if (searchType == "0")
                            $('#<% = txtSearch.ClientID %>').val($.trim($('#<% = lstInv.ClientID %> option:selected').text().split('#')[0]));
                        else if (searchType == "1" || searchType == "2")
                            $('#<% = txtSearch.ClientID %>').val($.trim($('#<% = lstInv.ClientID %> option:selected').text().split('#')[1]));


                }
                });


            });
    function DoListBoxFilter(listBoxSelector, textbox, searchtype, filter, values, key) {

        var list = $(listBoxSelector);
        var selectBase = '<option value="{0}">{1}</option>';
        if (searchtype == "2")
            list.empty();
        if (searchtype == "0") {
            for (i = 0; i < values.length; ++i) {
                var value = '';
                if (values[i].indexOf('#') == -1)
                    continue;
                else
                    value = values[i].split('#')[0].trim();
                var len = $(textbox).val().length;
                if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                    $('#<% = lstInv.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
                    return;
                }
            }
        }
        else if (searchtype == "1") {
            for (i = 0; i < values.length; ++i) {
                var value = '';
                if (values[i].indexOf('#') == -1)
                    continue;
                else
                    value = values[i].split('#')[1].trim();
                var len = $(textbox).val().length;
                if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                    $('#<% = lstInv.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
                            return;
                        }
                    }
                }
                else if (searchtype == "2") {
                    for (i = 0; i < values.length; ++i) {
                        var value = values[i];
                        if (value == "" || value.toLowerCase().indexOf(filter.toLowerCase()) >= 0) {
                            var temp = '<option value="' + key[i] + '">' + value + '</option>';
                            list.append(temp);
                        }
                    }
                }
            $(textbox).focus();
        }
        function clearSearch() {
            $('#<% = txtSearch.ClientID %>').val('');
            var searchType = $("#<%=rblsearchtype.ClientID%> input[type:radio]:checked").val();
            if (searchType == "0")
                $('#<% = txtSearch.ClientID %>').attr('title', 'Enter Code to Search');
    else if (searchType == "1")
        $('#<% = txtSearch.ClientID %>').attr('title', 'Enter First Name to Search');
        else
            $('#<% = txtSearch.ClientID %>').attr('title', 'Enter Name to Search InBetween');

    if (values.length != $('#<% = lstInv.ClientID %> option').length) {
                $('#<% = lstInv.ClientID %>').empty();
        var list = $('#<% = lstInv.ClientID %>');
        for (i = 0; i < values.length; i++) {
            var temp = '<option value="' + keys[i] + '">' + values[i] + '</option>';
            list.append(temp);
        }
    }
}
function bindAdmissionDoctor() {
    $('#ddlDoctor option').remove();
    $.ajax({
        url: "Services/IPDAdmission.asmx/bindAdmissionDoctor",
        data: '{}',
        type: "POST",
        async: false,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = jQuery.parseJSON(mydata.d);
            $("#ddlDoctor").empty().append('<option selected="selected" value="0">Select</option>');
            for (var i = 0; i < data.length; i++) {
                $('#ddlDoctor').append($("<option></option>").val(data[i].DoctorID).html(data[i].Name));
            }
            var DocID = $('#spnDocID').text();
            $('#ddlDoctor').val(DocID);
        }
    });
}
function LoadCategory() {
    $('#ddlCategory option').remove();
    var Type = $('#rdbItem :radio[Checked]').val();
    $.ajax({
        url: "../common/CommonService.asmx/BindCategory",
        data: '{Type:"' + Type + '"}',
        type: "POST",
        async: false,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = jQuery.parseJSON(mydata.d);
            $("#ddlCategory").empty().append('<option selected="selected" value="0">Select</option>');
            for (var i = 0; i < data.length; i++) {
                $('#ddlCategory').append($("<option></option>").val(data[i].CategoryID).html(data[i].Name));
            }
        }
    });
}
function LoadSubCategory() {
    $('#ddlSubCategory option').remove();
    var Type = $('#rdbItem :radio[Checked]').val();
    var CategoryID = $('#ddlCategory').val();
    $.ajax({
        url: "../common/CommonService.asmx/BindSubCategory",
        data: '{Type:"' + Type + '",CategoryID:"' + CategoryID + '"}',
        type: "POST",
        async: false,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = jQuery.parseJSON(mydata.d);
            $("#ddlSubCategory").empty().append('<option selected="selected" value="0">Select</option>');
            for (var i = 0; i < data.length; i++) {
                $('#ddlSubCategory').append($("<option></option>").val(data[i].SubCategoryID).html(data[i].Name));
            }

        }
    });
}
function LoadItems() {
    var Type = $('#rdbItem :radio[Checked]').val();
    var CategoryID = $('#ddlCategory').val();
    var SubCategoryID = $('#ddlSubCategory').val();
    $('#lstInv option').remove();
    $.ajax({
        url: "../common/CommonService.asmx/LoadOPD_All_Items",
        data: '{Type:"' + Type + '",CategoryID:"' + CategoryID + '",SubCategoryID:"' + SubCategoryID + '"}',
        type: "POST",
        async: false,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = jQuery.parseJSON(mydata.d);
            for (var i = 0; i < data.length; i++) {
                $('#lstInv').append($("<option></option>").val(data[i].ItemID).html(data[i].item));
            }
        }
    });
    SearchAndFilterBind();
}

function ValidateCharactercount(charlimit, cont) {
    var id = "#" + cont.id;
    if ($(id).text().length > charlimit) {
        $(id).text($(id).text().substring(0, charlimit));
        $("#divmessage").html("Maximum text length allowed is :" + charlimit);
    }
    else
        $("#divmessage").html("");
}
function AddItem() {
    $("#btnAddInv").attr('disabled', 'disabled');
    $("#spnErrorMsg").text('');
    if ($('#lstInv').find('option:selected').val() === null || $('#lstInv').find('option:selected').val() === undefined) {
        $("#btnAddInv").removeAttr('disabled');
        $("#spnErrorMsg").text('Please Select Item');
        $('#lstInv').focus();
        return;
    }
    $("#spnErrorMsg").text('');
    var ItemID = $('#lstInv').find('option:selected').val().split('#')[0].trim();
    var conDup = 0;
    if (CheckDuplicateItem(ItemID)) {
        $("#spnErrorMsg").text('Selected Item Already Added');
        conDup = 1;
        $("#btnAddInv").removeAttr('disabled');
        $('#spnErrorMsg').focus();
        return;
    }
    if (conDup == "1") {
        $("#spnErrorMsg").text('Selected Item Already Added');
        return;
    }
    var InvestigationID = $('#lstInv').find('option:selected').val().split('#')[3].trim();
    var ItemName = $('#lstInv').find('option:selected').text().split('#')[1].trim();
    var ItemCode = $('#lstInv').find('option:selected').text().split('#')[0].trim();
    var ConfigRelation = $('#lstInv').find('option:selected').val().split('#')[5].trim();
    var Urgent = 0;
    var UrStatus = "";
    if ($('#chkUrgent').is(":checked")) {
        Urgent = 1;
        UrStatus = "Yes";
    }
    else {
        Urgent = 0;
        UrStatus = "NO";
    }
    var Rate, ScheduleChargeID, Quantity;
    if (ConfigRelation != 3) {
        Quantity = $('#txtQuantity').val();
    }
    else {
        Quantity = "1";
    }
    var TID;
    if ($("#spnTransactionID").text().indexOf('I') == 0)
        TID = $("#spnTransactionID").text();
    else
        TID = '';
    $.ajax({
        url: "../common/CommonService.asmx/bindLabInvestigationRate",
        data: '{PanelID:"' + $("#lblReferenceCodeOPD").text() + '",ItemID:"' + ItemID + '",TID:"' + TID + '",IPDCaseTypeID:"' + $("#spnIPD_CaseTypeID").text() + '"}',
        type: "POST",
        async: false,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = jQuery.parseJSON(mydata.d);
            if (data != null) {
                Rate = data[0].Rate;
                ScheduleChargeID = data[0].ScheduleChargeID;
                $("#spnScheduleChargeID").text(data[0].ScheduleChargeID);
            }
            else {
                $("#spnScheduleChargeID").text(0);
                Rate = 0;
            }
        }
    });
    $('#tbSelected').css('display', 'block');
    $('#tbSelected').append('<tr><td class="GridViewLabItemStyle" style="width:70px" ><span id="ItemCode">' + ItemCode +
                            '</span></td><td class="GridViewLabItemStyle" style="width:120px" id="itemName"><span id="ItemName">' + ItemName +
                            '</span><span  style="display:none">' + InvestigationID +
                            '</span></td><td class="GridViewLabItemStyle" ><span id="tditemID" style="display:none">' + ItemID +
                            '</span><span id="tdConfigRelation" style="display:none">' + ConfigRelation +
                            '</span><span id="tdUrgent" style="display:none">' + Urgent +
                            '</span><span id="UrgentStatus" >' + UrStatus +
                            '</span></td><td class="GridViewLabItemStyle" style="width:100px" ><span id=Remarks>' + $('#txtRemarks').val() +
                            ' </span></td><td class="GridViewLabItemStyle" style="width:40px"><span></span><input id="txtRate"  type="text" style="width:30px;" readonly="readonly" value=' + Rate +
                            ' class="ItDoseTextinputNum" onkeyup="Rate(this);"  onkeypress="return checkNumeric(event,this);"/></td><td class="GridViewLabItemStyle" style="width:30px"><input type="text" id="txtQuantity" maxlength="4" onkeyup="Rate(this);" style="width:30px" readonly="readonly" value=' + Quantity +
                            ' class="ItDoseTextinputNum" onkeypress="return checkNumericDecimal(event,this);" /></td><td class="GridViewLabItemStyle" style="width:40px"><input id="txtAmount" class="ItDoseTextinputNum" type="text" style="width:30px" readonly="readonly" value=' + Rate +
                            ' /></td><td class="GridViewLabItemStyle" style="width:30px"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');
    bindRate();
    $("#btnAddInv").removeAttr('disabled');
    $('#LabOutput,#tbSelected').show();
    $('#txtSearch').val('');
    $('#txtRemarks').val('');
    $('#txtSearch').focus();

}
function Rate(rowid) {
    var qty = $(rowid).closest('tr').find("#txtQuantity").val();
    var rate = $(rowid).closest('tr').find("#txtRate").val();
    var DigitsAfterDecimal = 2;
    var rateIndex = rate.indexOf(".");
    if (rateIndex > "0") {
        if (rate.length - (rate.indexOf(".") + 1) > DigitsAfterDecimal) {
            alert("Please Enter Valid Rate, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
            $(rowid).closest('tr').find("#txtRate").val($(rowid).closest('tr').find("#txtRate").val().substring(0, ($(rowid).closest('tr').find("#txtRate").val().length - 1)))
        }
    }
    if (isNaN(qty) || qty == "") {
        qty = 1;
        Number($(rowid).closest('tr').find("#txtQuantity").val(1));
    }
    if (isNaN(rate) || rate == "") {
        rate = 0;
        Number($(rowid).closest('tr').find("#txtRate").val(0));
    }
    Number($(rowid).closest('tr').find("#txtAmount").val(parseFloat(qty * rate)));
    bindRate();
}
function RemoveRows(rowid) {
    if ($("#grdPaymentMode tr").length > 1) {
        return;
    }
    $(rowid).closest('tr').remove();
    if ($('#tbSelected tr:not(#LabHeader)').length == 0) {
        $('#tbSelected').hide();
        $("#rdbItem").removeAttr('disabled');
    }
    bindRate();
    $("#spnErrorMsg").text('');


}
function bindRate() {
    var totalAmount = 0;
    $('#tbSelected tr').each(function () {
        var id = $(this).closest("tr").attr("id");
        if (id != "LabHeader") {
            var amount = parseFloat($(this).closest('tr').find("#txtAmount").val());
            totalAmount = totalAmount + amount;
            $('#spnTotalRate').text(totalAmount);
            if (totalAmount >= 0) {
                $('#divTotalAmt').show();
                $('#divSave').show();
            }
            else {
                $('#divTotalAmt').hide();
                $('#divSave').hide();
            }
        }
    });
}
function CheckDuplicateItem(ItemID) {
    var count = 0;
    $('#tbSelected tr:not(#LabHeader)').each(function () {
        var item = $(this).find('#tditemID').text().trim();
        if ($(this).find('#tditemID').text().trim() == ItemID) {
            count = count + 1;
        }
    });
    if (count == 0)
        return false;
    else
        return true;
}
function checkNumeric(e, sender) {
    var charCode = (e.which) ? e.which : e.keyCode;
    if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    if (sender.value == "0") {
        sender.value = sender.value.substring(0, sender.value.length - 1);
    }
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
function checkNumericDecimal(e, sender) {
    var charCode = (e.which) ? e.which : e.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    if (sender.value == "1") {
        sender.value = sender.value.substring(0, sender.value.length - 1);
    }
}
function CheckConfig() {
    LoadCategory();
    LoadSubCategory();
    LoadItems();
}
function SaveOrder() {
    $("#btnSave").attr('disabled', true);
    var data = new Array();
    var Order = new Object();
    $("#tbSelected tr").each(function () {
        var id = $(this).attr("id");
        var $rowid = $(this).closest("tr");
        if (id != "LabHeader") {
            Order.Test_ID = $.trim($rowid.find("#tditemID").text());
            Order.TransactionID = $('#spnTransactionID').text();
            Order.PatientID = $('#spnPatientID').text();
            Order.DoctorID = $('#ddlDoctor').val();
            Order.Remarks = $.trim($rowid.find("#Remarks").text());
            Order.Quantity = $.trim($rowid.find("#txtQuantity").val());
            Order.ConfigID = $.trim($rowid.find("#tdConfigRelation").text());
            Order.IsUrgent = $.trim($rowid.find("#tdUrgent").text());
            data.push(Order);
            Order = new Object();
        }
    });
    if (data.length > 0) {
        $.ajax({
            url: "Patient_OrderSet.aspx/SaveOrder",
            data: JSON.stringify({ Data: data }),
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            async: false,
            success: function (result) {
                Data = result.d;

                if (Data != "0") {
                    $("#tbSelected tr:not(:first)").remove();
                    $("#tbSelected").hide();
                    $("spnErrorMsg").text('Record Saved Successfully');
                    alert("Order No. is :" + Data);
                    $("#btnSave").hide();
                }
                else {
                    $("spnErrorMsg").text('Record Not Saved');
                }
                $("#btnSave").attr('disabled', false);
            },
            error: function (xhr, status) {
                alert(status + "\r\n" + xhr.responseText);
                $("#btnSave").attr('disabled', false);
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    }
}
function AddInvestigation(sender, event) {
    if (event.keyCode == 13) {
        AddItem();
    }
}
        </script>
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Patient Order Set </b>
                <br />
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <asp:Label ID="lblMsg" runat="server" Style="display: none"></asp:Label>
                <asp:Label ID="lblPanelID" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" Style="display: none" />
                <span id="spnTransactionID" runat="server" style="display: none"></span>
                <span id="spnPatientID" runat="server" style="display: none"></span>
                <span id="spnDocID" runat="server" style="display: none"></span>
                <span id="spnIPD_CaseTypeID" runat="server" style="display: none"></span>
                <asp:Label ID="lblReferenceCodeOPD" runat="server" ClientIDMode="Static" Style="display: none" />

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Patient Order Set
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <asp:RadioButtonList ID="rdbItem" ClientIDMode="Static" runat="server" CssClass="ItDoseRadiobuttonlist" RepeatDirection="Horizontal" RepeatLayout="Flow" onchange="CheckConfig()">
                                    <asp:ListItem Text="Investigations" Value="1" Selected="True" />
                                    <asp:ListItem Text="Procedures" Value="2" />
                                    <asp:ListItem Text="Other Charges" Value="3" />
                                    <asp:ListItem Text="ALL" Value="4" />
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Search Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <asp:RadioButtonList ID="rblsearchtype" runat="server" RepeatDirection="Horizontal" TabIndex="34"
                                    RepeatLayout="Flow" onclick="clearSearch()">
                                    <asp:ListItem Value="0">By Code</asp:ListItem>
                                    <asp:ListItem Value="1">By First Name</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="2"> InBetween</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static"
                                    TabIndex="1"
                                    ToolTip="Enter To Search" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Category
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlCategory"  onchange="LoadSubCategory();LoadItems();"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    SubCategory
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlSubCategory"  onchange="LoadItems()"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Items
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12" style="margin-top:-10px;">
                                <asp:ListBox ID="lstInv" runat="server" Width="451px" Height="125px" CssClass="ItDoseDropdownbox" ClientIDMode="Static" />
                            </div>
                             <div class="col-md-3">
                                <label class="pull-left">
                                    Enter Quantity
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <input type="text" class="requiredField" id="txtQuantity" onkeydown="checkNumericDecimal(this)" style="width: 60px" value="1" />
                            </div>
                        </div>
                         <div class="row">
                           
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Remarks
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtRemarks" class="ItDoseTextinputText" style="" tabindex="2" onkeypress="AddInvestigation(this,event);" />
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">
                                    Doctor
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <select id="ddlDoctor" style="width: 225px" tabindex="3" onkeypress="AddInvestigation(this,event);"></select>
                            </div>
                            <div class="col-md-4">
                                <input id="chkUrgent" style="background-color: red" type="checkbox" tabindex="4" />
                                <b><span id="spnUrgent" style="color: red">&nbsp;Urgent</span></b>
                                
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-10">
                            </div>
                            <div class="col-md-9">
                               <input type="button" id="btnAdd" title="Add Item" value="Add Item" class="ItDoseButton" onclick="AddItem();" onkeypress="AddInvestigation(this,event);" />
                            </div>
                            <div class="col-md-11">
                            </div>
                        </div>
                    </div>
                </div>
                <div id="LabOutput" style="max-height: 200px; overflow-y: auto; overflow-x: hidden;">
                    <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                        <tr id="LabHeader">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 70px; text-align: left">CPT Code</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 120px; text-align: left">Item Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">Urgent</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align: left">Remarks</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">Rate</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: left">Qty.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">Amt.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: left">Remove</th>
                        </tr>

                    </table>
                </div>
                <div style="text-align: center; display: none" id="divTotalAmt">Total Amount :<span id="spnTotalRate"></span></div>
            </div>
            <div style="text-align: center; display: none" id="divSave">
                <input type="button" value="Save" class="ItDoseButton" id="btnSave" onclick="SaveOrder()" />
            </div>
        </div>
    </form>
</body>
</html>
