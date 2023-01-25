<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UtilityMaster.aspx.cs" Inherits="Design_EDP_UtilityMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
     <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
<script type="text/javascript">
    $(function () {
       // LoadCategory();
        BindPanel();
        CalcNetAmount();
        chkOPDIPDList();
    });
    function ChkDate() {
        $.ajax({
            url: "../Common/CommonService.asmx/CompareDate",
            data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                if (data == false) {
                    $('#spnErrorMsg').text('To date can not be less than from date!');
                    $('#btnSearch').attr('disabled', 'disabled');
                }
                else {
                    $('#spnErrorMsg').text('');
                    $('#btnSearch').removeAttr('disabled');
                }
            }
        });

    }
    function bindData() {
        var Category = $('#ddlCategory').val();
        var Panel = $('#ddlPanelCompany').val();
        var Type = $("#rdoOPDIPDList input[type=radio]:checked").val();
        var selectedItems = []; var selectedValues = [];
        $("#<%= chkCategory.ClientID %> input:checkbox:checked").each(function () {

             selectedItems.push($(this).next().html());
             selectedValues.push($(this).val());

         });
        if (Type == 0) {
            if (Category != 0) {
                $.ajax({
                    url: "UtilityMaster.aspx/bindData",
                    data: '{Category:"' + selectedValues + '",Panel:"' + Panel + '",FromDate:"' + $('#ucFromDate').val() + '",ToDate:"' + $('#ucToDate').val() + '",Type:"' + Type + '",BillNo:"' + $('#txtBillNo').val() + '",ReceiptNo:"' + $('#txtReceiptNo').val() + '",IPDNo:"' + $('#txtIPDNo').val() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var data = jQuery.parseJSON(mydata.d);
                        if (data != "") {
                            $("#spnErrorMsg").text('');
                            $('#txtGrossAmt').val(data[0]["GrossAmount"]);
                            $('#txtNetAmount').val(data[0]["NetAmt"]);
                            $('#txtAdjustment').val(data[0]["PaidAmt"]);
                            $('#divResult').show();
                            $('#divDiscount,#btnSave').show();
                            $('#spnnewNetAmt,#spnLedgerTransactionNo,#spnLedgerTnxID').text('');
                            $('#spnDiscAmt').text('');
                            $('#txtDisPercent').val('');
                            $('#txtDiscount').val('');
                            $('#spnLedgerTransactionNo').text(data[0]["LedgerTransactionNo"]);
                            $('#spnLedgerTnxID').text(data[0]["LedgerTnxID"]);
                            $('#spnCountLedgerTnxID').text(data[0]["CountLedgerTnxID"]);
                            $('#spnCountLedgerTransactionNo').text(data[0]["CountLedgerTransactionNo"]);
                            CalcNetAmount();
                        }
                        else
                            $('#spnErrorMsg').text('No Record Found');
                    }
                });
            }
            else {
                $('#spnErrorMsg').text('Please Select The Category');
            }
        }
        else {
            $.ajax({
                url: "UtilityMaster.aspx/bindData",
                data: '{Category:"' + selectedValues + '",Panel:"' + Panel + '",FromDate:"' + $('#ucFromDate').val() + '",ToDate:"' + $('#ucToDate').val() + '",Type:"' + Type + '",BillNo:" ",ReceiptNo:" ",IPDNo:"' + $('#txtIPDNo').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != "") {
                        $("#spnErrorMsg").text('');
                        $('#txtGrossAmt').val(data[0]["GrossAmount"]);
                        $('#txtNetAmount').val(data[0]["NetAmt"]);
                        $('#txtAdjustment').val(data[0]["PaidAmt"]);
                        $('#divResult').show();
                        $('#divDiscount,#btnSave').show();
                        $('#spnnewNetAmt,#spnLedgerTransactionNo,#spnLedgerTnxID').text('');
                        $('#spnDiscAmt').text('');
                        $('#txtDisPercent').val('');
                        $('#txtDiscount').val('');
                        $('#spnLedgerTransactionNo').text(data[0]["LedgerTransactionNo"]);
                        $('#spnLedgerTnxID').text(data[0]["LedgerTnxID"]);
                        $('#spnCountLedgerTnxID').text(data[0]["CountLedgerTnxID"]);
                        $('#spnCountLedgerTransactionNo').text(data[0]["CountLedgerTransactionNo"]);
                        CalcNetAmount();
                    }
                    else
                        $('#spnErrorMsg').text('No Record Found');
                }
            });
        }
        
    }
    function LoadCategory() {
        $('#ddlCategory option').remove();
        var Type = $('#rdoOPDIPDList :radio[Checked]').val();
        $.ajax({
            url: "UtilityMaster.aspx/BindCategory",
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
    function BindPanel() {
        $("#ddlPanelCompany option").remove();
        $.ajax({
            url: "../Common/CommonService.asmx/bindPanel",
            data: '{}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                panel = jQuery.parseJSON(result.d);
                for (i = 0; i < panel.length; i++) {
                    $("#ddlPanelCompany").append($("<option></option>").val(panel[i].PanelID + "#" + panel[i].ReferenceCodeOPD).html(panel[i].Company_Name));
                }
                $("#ddlPanelCompany").val('<%=Resources.Resource.DefaultPanelID %>' + '#' + '<%=Resources.Resource.DefaultPanelID %>');
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            });
    }
    function validateDisc() {
        if ($.trim($('#txtDisPercent').val()) > 0) {
            $('#txtDisPercent').val('');
        }
        var DigitsAfterDecimal = 2;
        var perIndex = $.trim($('#txtDiscount').val()).indexOf(".");
        if (perIndex > "0") {
            if ($.trim($('#txtDiscount').val()).length - ($.trim($('#txtDiscount').val()).indexOf(".") + 1) > DigitsAfterDecimal) {
                alert("Please Enter Valid Percentage, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                $('#txtDiscount').val($('#txtDiscount').val().substring(0, ($('#txtDiscount').val().length - 1)))
            }
        }

        if (parseFloat($('#txtDiscount').val()) > parseFloat($("#lblNetAmount").text())) {
            $("#lblMsg").text('Discount Amount Can Not Greater Then Net Amount');
            $('#txtDiscount').focus();
            return;
        }
    }
    function clear()
    {
        $('#ddlCategory').val(0);
        $('#divResult').hide();
        $('#divDiscount,#btnSave').hide();
        $('#spnnewNetAmt,#spnLedgerTransactionNo,#spnLedgerTnxID').text('');
        $('#spnDiscAmt').text('');
        $('#txtDisPercent').val('');
        $('#txtDiscount').val('');
    }
    function validatePer() {
        if ($.trim($('#txtDiscount').val()) > 0) {
            $('#txtDiscount').val('');
        }
        if (($.trim($('#txtDisPercent').val()) > 100)) {
            alert('Please Enter Valid Percentage');
            $('#txtDisPercent').val('');
            $('#txtDisPercent').focus();
            $('#spnnewNetAmt').text(' ');
            $('#spnDiscAmt').text(' ');
        }
        else {
            CalcNetAmount();
        }
        var DigitsAfterDecimal = 2;
        var perIndex = $.trim($('#txtDisPercent').val()).indexOf(".");
        if (perIndex > "0") {
            if ($.trim($('#txtDisPercent').val()).length - ($.trim($('#txtDisPercent').val()).indexOf(".") + 1) > DigitsAfterDecimal) {
                alert("Please Enter Valid Percentage, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                $('#txtDisPercent').val($('#txtDisPercent').val().substring(0, ($('#txtDisPercent').val().length - 1)))
            }
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
    function CalcNetAmount()
    {
        if ($('#txtDisPercent').val() != '') {
            var NewNetAmt;
                NewNetAmt = ($('#txtGrossAmt').val() - (($('#txtGrossAmt').val() * $('#txtDisPercent').val()) / 100));
            $('#spnnewNetAmt').text(precise_round(parseFloat(NewNetAmt), 2));
            var DiscAmt = ($('#txtNetAmount').val() - NewNetAmt);
           
            $('#spnDiscAmt').text(precise_round(parseFloat(DiscAmt), 2));
            $('#btnSave').removeAttr('disabled');
        }
        else {
            $('#spnnewNetAmt').text('');
            $('#spnDiscAmt').text('');
            $('#btnSave').attr('disabled','disabled');
        }
        
    }
    function precise_round(num, decimals) {
        return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
    }
    function UpdateDisc() {
        var Confirm = confirm("Are You Sure, You want to give" + $('#txtDisPercent').val() + "Discount in this Category")
        if (Confirm == true) {
            var LedgerTnxID = $('#spnLedgerTnxID').text();
            var Type = $("#rdoOPDIPDList input[type=radio]:checked").val()
                $.ajax({
                    url: "UtilityMaster.aspx/UpdateDisc",
                    data: '{DiscPer:"' + $('#txtDisPercent').val() + '",LedgerTnxID:"' + LedgerTnxID + '",LedgerTransactionNo:"' + $('#spnLedgerTransactionNo').text() + '",CountLedgerTnxID:"' + $('#spnCountLedgerTnxID').text() + '",CountLedgerTransactionNo:"' + $('#spnCountLedgerTransactionNo').text() + '",Pre_GrossAmt:"' + $('#txtGrossAmt').val() + '",Pre_NetAmt:"' + $('#txtNetAmount').val() + '",Pre_Adjustment:"' + $('#txtAdjustment').val() + '",DiscAmt:"' + $('#spnDiscAmt').text() + '",NewNetAmt:"' + $('#spnnewNetAmt').text() + '",Type:"' + Type + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = jQuery.parseJSON(result.d);
                        if (Data == 1) {
                            $("#spnErrorMsg").text('Record Saved Successfully');
                            clear();
                        }
                        else
                            $("#spnErrorMsg").text('Record Not Saved');
                    }
                });
            }
    }
    function chkOPDIPDList() {
        if ($("#rdoOPDIPDList input[type=radio]:checked").val() == "1") {
            $("#spnErrorMsg").text('');
            $("#chkCategory input[type=checkbox]").removeAttr("checked").attr('disabled', 'disabled');
            $('#chkSelectAll').removeAttr("checked").attr('disabled', 'disabled');
            $('#spnnewNetAmt,#spnLedgerTransactionNo,#spnLedgerTnxID,#spnDiscAmt').text('');
            $('#txtDisPercent,#txtDiscount,#txtGrossAmt,#txtNetAmount,#txtAdjustment,#txtBillNo,#txtReceiptNo,#txtIPDNo').val('');
            $('#txtBillNo,#txtReceiptNo').attr('disabled', 'disabled');
            $('#txtIPDNo').removeAttr("disabled");

            CalcNetAmount();
        }
        else {
            $("#spnErrorMsg").text('');
            $("#chkCategory input[type=checkbox]").removeAttr("disabled");
            $('#chkSelectAll,#txtBillNo,#txtReceiptNo').removeAttr("disabled");
            $('#spnnewNetAmt,#spnLedgerTransactionNo,#spnLedgerTnxID,#spnDiscAmt').text('');
            $('#txtDisPercent,#txtDiscount,#txtGrossAmt,#txtNetAmount,#txtAdjustment,#txtBillNo,#txtReceiptNo,#txtIPDNo').val('');
            $('#txtIPDNo').attr('disabled', 'disabled');
            CalcNetAmount();
        }
    }
    function SelectAll() {
            if ($('#chkSelectAll').is(":checked")) {
                $("#<%= chkCategory.ClientID%> input[type=checkbox]").attr("checked", "checked");
            }
            else {
                $("#<%= chkCategory.ClientID%> input[type=checkbox]").removeAttr("checked");
            }
    }
</script>
<div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>Bulk Discount Master</b><br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory" >
            <table  style="width: 100%;border-collapse:collapse">
                 <tr>
                    <td style="width: 15%;text-align:right ">
                        Type :&nbsp;</td>
                   <td style="width: 35%; text-align: left;">
                        <asp:RadioButtonList ID="rdoOPDIPDList"  TabIndex="14" ClientIDMode="Static" runat="server" onchange="chkOPDIPDList()"  RepeatDirection="Horizontal"  OnSelectedIndexChanged="rdoOPDIPDList_SelectedIndexChanged">
                        <asp:ListItem Enabled="true" Text="OPD"  Value="0" Selected="True"></asp:ListItem>
                        <asp:ListItem  Text="IPD" Value="1" ></asp:ListItem>
                        </asp:RadioButtonList></td>
                    <td style="width: 15%;text-align:right">
                         IPD No. :&nbsp;</td>
                   <td style="width: 35%; text-align: left"><asp:TextBox ID="txtIPDNo" runat="server" CssClass="ItDoseTextinputText" ClientIDMode="Static" MaxLength="10"> </asp:TextBox></td>
                </tr>
                 <tr>
                    <td style="width: 15%;text-align:right ">
                        Bill No. :&nbsp;</td>
                   <td style="width: 35%; text-align: left;">
                        <asp:TextBox ID="txtBillNo" runat="server" CssClass="ItDoseTextinputText" ClientIDMode="Static"></asp:TextBox></td>
                    <td style="width: 15%;text-align:right">
                        Receipt No. :&nbsp;</td>
                   <td style="width: 35%; text-align: left"><asp:TextBox ID="txtReceiptNo" runat="server" CssClass="ItDoseTextinputText" ClientIDMode="Static"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 15%;text-align:right">
                        Bill Date From :&nbsp;</td>
                    <td style="width: 35%; text-align: left;">
                        <asp:TextBox ID="ucFromDate" TabIndex="1" runat="server" ClientIDMode="Static" onchange="ChkDate();"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 15%; text-align:right">
                        Bill Date To :&nbsp;</td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="ucToDate" TabIndex="2" runat="server" ClientIDMode="Static" onchange="ChkDate();"></asp:TextBox>
                       <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                </tr>
                <tr >
                    <td style="width: 15%;text-align:right">
                    <input type="checkbox" id="chkSelectAll" onclick="SelectAll();" />Category :&nbsp;</td>
                    <td style="width: 35%; text-align: left;" colspan="3">
                      <select id="ddlCategory" style="width:240px;display:none"  ></select>
                        <asp:CheckBoxList ID="chkCategory" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal"  RepeatColumns="3"></asp:CheckBoxList>
                    </td>
                    <td style="width: 15%; text-align: right;display:none" >
                     Panel :&nbsp;</td>
                    <td style="width: 435%; text-align: left;display:none">
                     <select id="ddlPanelCompany" style="width:240px" disabled="disabled"></select>
                    </td>
                </tr>
            <tr style="text-align:center">
               <td colspan="4">
                	<input type="button" value="Search" class="ItDoseButton"  id="btnSearch" onclick="bindData()" />
            </td></tr>    
            </table>
           
			
			
        </div>

    <div class="POuter_Box_Inventory" style="display:none"  id="divResult">
         <div class="Purchaseheader">
                Search Result
            </div>
        <table>
            <tr>
                <td style="width: 143px;text-align:right">Gross Amt. :&nbsp;</td>
                <td style="width: 249px"><input  type="text" id="txtGrossAmt" class="ItDoseTextinputNum" readonly="readonly" disabled="disabled"/></td>
                <td style="width: 78px">Net Amt. :&nbsp;</td>
                <td><input type="text" id="txtNetAmount" class="ItDoseTextinputNum" readonly="readonly" disabled="disabled"/></td>
                <td style="width: 164px;text-align:right">Received Amt. :&nbsp;</td>
                <td><input type="text" id="txtAdjustment" class="ItDoseTextinputNum" readonly="readonly" disabled="disabled"/></td>
            </tr>
            
            
        </table>
    </div>
    <div class="POuter_Box_Inventory" style="display:none"  id="divDiscount">
         <div class="Purchaseheader">
               New Discount
            </div><table>
         <tr>
                <td style="width: 141px;text-align:right">New Discount Per :&nbsp;</td>
                <td><input  type="text" id="txtDisPercent" class="ItDoseTextinputNum" onkeyup="validatePer()" onkeypress="return checkNumeric(event,this);""/></td>
                <td style="width: 177px; text-align:right">New Net. Amt. :&nbsp;</td>
                <td style="width: 151px"><span id="spnnewNetAmt" class="ItDoseLblSpBl"></span>&nbsp;</td>
                <td  style="text-align:right; width: 164px;">Discount Amt :&nbsp;</td>
                <td style="width: 141px"><span id="spnDiscAmt" class="ItDoseLblSpBl"></span>&nbsp;</td>
            </tr>
                <tr><td style="display:none">
                    <asp:Label ID="spnLedgerTnxID" runat="server" ClientIDMode="Static"></asp:Label>
                    </td>
                   <td style="display:none"> <span id="spnLedgerTransactionNo"></span><span id="spnCountLedgerTnxID"></span><span id="spnCountLedgerTransactionNo"></span></td>
                </tr>
         </table>
    </div>
    <div style="text-align:center">
        <input type="button" id="btnSave" value="Save" class="ItDoseButton" style="display:none" onclick="UpdateDisc()" />
    </div>
</div>
</asp:Content>

