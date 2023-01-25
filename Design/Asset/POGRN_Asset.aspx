
<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="POGRN_Asset.aspx.cs" Inherits="Design_Asset_POGRN_Asset" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<script type="text/javascript">       

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

 $(document).ready(function () {
     BindVendor();
     BindPurchaseOrder();
 });
 function formatDate(date) {
     var d = new Date(date),
         month = '' + (d.getMonth() + 1),
         day = '' + d.getDate(),
         year = d.getFullYear();

     if (month.length < 2) month = '0' + month;
     if (day.length < 2) day = '0' + day;

     return [day, month, year].join('/');
 }
 function BindVendor() {
        var DeptLedgerNo = '<%=Util.GetString(ViewState["DeptLedgerNo"])%>';
        $('#tablePOdetails tbody').empty();
        $('#POOutput,#DivPODetails').hide();
        $.ajax({
        type: "POST",
        timeout: 120000,
        url: "POGRN_Asset.aspx/BindVendor",
        data: '{StoreType:"' + $("#rblType").find("input:radio:checked").val() + '",DeptLedgerNo:"' + DeptLedgerNo + '"}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.d == "") {
                $('[id$=ddlVendor]').html('');
                $('[id$=ddlVendor]').append(jQuery("<option></option>").val('0').html(" "));
                $('[id$=ddlVendor]').trigger('chosen:updated');
            }
            else {
                $('[id$=ddlVendor]').html('');
                $('[id$=ddlVendor]').trigger('chosen:updated');
                $('[id$=ddlVendor]').append(jQuery("<option></option>").val("0").html("Select"));
                Subcat = jQuery.parseJSON(data.d);
                if (Subcat.length == 0) {
                    $('[id$=ddlVendor]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < Subcat.length; i++) {
                        $('[id$=ddlVendor]').append(jQuery("<option></option>").val(Subcat[i].ID).html(Subcat[i].LedgerName));
                    }
                    $('[id$=ddlVendor]').chosen();
                    $('[id$=ddlVendor]').trigger('chosen:updated');
                }
            }
        },
        error: function (xhr, status) {
            modelAlert("Error ");
            $('[id$=ddlVendor]').attr("disabled", false);
        }
    });

    return false;

}
    function BindPurchaseOrder() {
        $('#tablePOdetails tbody').empty();
        $('#POOutput,#DivPODetails').hide();
        var DeptLedgerNo = '<%=Util.GetString(ViewState["DeptLedgerNo"])%>';
        $.ajax({
        type: "POST",
        timeout: 120000,
        url: "POGRN_Asset.aspx/BindPO",
        data: '{VendorID:"' + $('#ddlVendor option:selected').val().split('#')[1] + '",StoreType:"' + $("#rblType").find("input:radio:checked").val() + '"}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.d == "") {
                $('[id$=ddlpurchaseorder]').html('');
                $('[id$=ddlpurchaseorder]').append(jQuery("<option></option>").val('0').html(" "));
                $('[id$=ddlpurchaseorder]').trigger('chosen:updated');
            }
            else {
                $('[id$=ddlpurchaseorder]').html('');
                $('[id$=ddlpurchaseorder]').trigger('chosen:updated');
                $('[id$=ddlpurchaseorder]').append(jQuery("<option></option>").val("0").html("Select"));
                Subcat = jQuery.parseJSON(data.d);
                if (Subcat.length == 0) {
                    $('[id$=ddlpurchaseorder]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < Subcat.length; i++) {
                        $('[id$=ddlpurchaseorder]').append(jQuery("<option></option>").val(Subcat[i].PurchaseOrderNo).html(Subcat[i].PO));
                    }
                    $('[id$=ddlpurchaseorder]').chosen();
                    $('[id$=ddlpurchaseorder]').trigger('chosen:updated');
                }
            }
        },
        error: function (xhr, status) {
            modelAlert("Error ");
            $('[id$=ddlpurchaseorder]').attr("disabled", false);
        }
    });
    return false;
}

</script>
<script type="text/javascript">

    $(document).ready(function () {
        $("#rblType input[type='radio']").change(function () {
            BindVendor();
            BindPurchaseOrder();
        });
        $('[id$=ddlVendor]').change(function () {
            BindPurchaseOrder();        
        });
        $('[id$=ddlpurchaseorder]').change(function () {
            SearchPO();           
        });
        $("#rdoGRNType input[type='radio']").change(function () {
            if ($("#rdoGRNType").find("input:radio:checked").val() == "1") 
                $("#divInv,#divChallan").show();            
            else if($("#rdoGRNType").find("input:radio:checked").val() == "2") {
                $("#divChallan").show(); $("#divInv").hide();
            }
            else if ($("#rdoGRNType").find("input:radio:checked").val() == "3") {
                $("#divInv").show(); $("#divChallan").hide();
            }
            $("#txtInvoiceNo,#txtInvoiceDate,#txtChallanNo,#txtChallanDate").val('');
        });

        $('#txtChallanDate,#txtInvoiceDate,#txtAssetPurDate').attr('readonly', 'readonly').datepicker({
            dateFormat: 'dd-M-yy',
            maxDate: '+0D',
            changeMonth: true,
            changeYear: true
        });      
    });
    function Enable(rowId) {
        
        var Index = $.trim($(rowId).closest("tr").find("#tdIndex").text());
        $UpdateAmounts(function(){});
        if (rowId.checked == true) 
            $(rowId).closest("tr").find('#txtBatchNo_' + Index +',#txtMRP_' + Index + ',#txtRcvQty_' + Index + ',#txtModel_' + Index + ',#txtAssetNo_' + Index + ',#txtInstDate_' + Index + ',#txtFreeServiceFrom_' + Index + ',#txtFreeServiceTo_' + Index + ',#txtSerialNo_' + Index + ',#txtWarrantyNo_' + Index + ',#txtWarrantyFrom_' + Index + ',#txtWarrantyTo_' + Index).prop("disabled", false);
        else 
            $(rowId).closest("tr").find('#txtBatchNo_' + Index + ',#txtMRP_' + Index + ',#txtRcvQty_' + Index + ',#txtModel_' + Index + ',#txtAssetNo_' + Index + ',#txtInstDate_' + Index + ',#txtFreeServiceFrom_' + Index + ',#txtFreeServiceTo_' + Index + ',#txtSerialNo_' + Index + ',#txtWarrantyNo_' + Index + ',#txtWarrantyFrom_' + Index + ',#txtWarrantyTo_' + Index).prop("disabled", true);
    }
    $CalNetValue = function (id, callback) {
        $RcvQty = $.trim(parseFloat($('#txtRcvQty_' + id).val()));
        $UP = $.trim(parseFloat($('#tdUP' + id).text(),2));
        $('#tdAmount' + id).text(Number($RcvQty * $UP).toFixed(2));
        $UpdateAmounts(function () { });
        callback(true);
    }

    function AddDupItem(rowId) {
        var Index = $.trim($(rowId).closest("tr").find("#tdIndex").text());
        $ItemID     = $.trim($(rowId).closest("tr").find("#tdItemID"+Index).text());
        $ItemName   = $.trim($(rowId).closest("tr").find("#spnItemName_" + Index).text());
        $OrderedQty = $.trim($(rowId).closest("tr").find("#spnOrderedQty_" + Index).text());
        $UP         = $.trim($(rowId).closest("tr").find("#tdUP" + Index).text());
        $Amount     = $.trim($(rowId).closest("tr").find("#tdAmount" + Index).text());
        $MRP        = $.trim($(rowId).closest("tr").find("#tdMRP" + Index).text());
        $CalcOn     = $.trim($(rowId).closest("tr").find("#tdCalcOn" + Index).text());
        $GSTType    = $.trim($(rowId).closest("tr").find("#tdGSTType" + Index).text());
        $IGSTPer    = $.trim($(rowId).closest("tr").find("#tdIGSTPer" + Index).text());
        $CGSTPer    = $.trim($(rowId).closest("tr").find("#tdCGSTPer" + Index).text());
        $SGSTPer    = $.trim($(rowId).closest("tr").find("#tdSGSTPer" + Index).text());
        $GSTPer     = $.trim($(rowId).closest("tr").find("#tdGSTPer" + Index).text());
        $DiscPer    = $.trim($(rowId).closest("tr").find("#tdDiscPer" + Index).text());
        $Rate       = $.trim($(rowId).closest("tr").find("#tdRate" + Index).text());       
        var NewIndex = parseInt($('#tablePOdetails tbody tr:last').find("#tdIndex").text()) + 1;
        
        $DupItemTr = "<tr id='tr_" + NewIndex + "'>";
        $DupItemTr += "<td class='GridViewLabItemStyle'><input type='checkbox' id='chkselect" + NewIndex + "' onclick='Enable(this);' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' style='display:none;'><img id='imgAddDupItem" + NewIndex + " alt='' src='../../Images/plus_in.gif' style='cursor:pointer'  onclick='AddDupItem(this)' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdIndex'  style='width:30px;display:none;'>" + NewIndex + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdItemID" + NewIndex + "'  style='width:30px;display:none;font-size: 7.5pt;'>" + $ItemID + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdItemName" + NewIndex + "' style='text-align:left;font-size: 7.5pt;' >" + $ItemName + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdOrderQty" + NewIndex + "' >" + $OrderedQty + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdRcvQty" + NewIndex + "'><input type='text' id='txtRcvQty_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 1) + ' class='requiredField'   style='width:40px;' disabled='disabled' value=" + $OrderedQty + " onblur='$CalNetValue(" + NewIndex + "',function(){})' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdBatch" + NewIndex + "' ><input type='text' id='txtBatchNo_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 2) + ' class='requiredField' style='width:50px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdUP" + NewIndex + "' >" + $UP + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdAmount" + NewIndex + "' >" + $Amount + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdMRP" + NewIndex + "'><input type='text' id='txtMRP_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 3) + ' class='requiredField' style='width:40px;' disabled='disabled' value=" + $MRP + " /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdModelNo" + NewIndex + "'><input type='text' id='txtModel_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 4) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdAssetNo" + NewIndex + "'><input type='text' id='txtAssetNo_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 5) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdInstDate" + NewIndex + "'><input type='text' id='txtInstDate_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 6) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdFreeServiceFrom" + NewIndex + "'><input type='text' id='txtFreeServiceFrom_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 7) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdFreeServiceTo" + NewIndex + "'><input type='text' id='txtFreeServiceTo_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 8) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdSerialNo" + NewIndex + "'><input type='text' id='txtSerialNo_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 9) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdWarrantyNo" + NewIndex + "'><input type='text' id='txtWarrantyNo_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 10) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdWarrantyFrom" + NewIndex + "'><input type='text' id='txtWarrantyFrom_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 11) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdWarrantyTo" + NewIndex + "'><input type='text' id='txtWarrantyTo_" + NewIndex + "'  tabindex=' + (" + NewIndex + " * 100 + 12) + ' class='requiredField' style='width:80px;' disabled='disabled' /></td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdCalcOn" + NewIndex + "'>" + $CalcOn + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdGSTType" + NewIndex + "'>" + $GSTType + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdIGSTPer" + NewIndex + "'>" + $IGSTPer + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdCGSTPer" + NewIndex + "'>" + $CGSTPer + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdSGSTPer" + NewIndex + "'>" + $SGSTPer + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdGSTPer" + NewIndex + "'>" + $GSTPer + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdDiscPer" + NewIndex + "'>" + $DiscPer + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tdRate" + NewIndex + "'>" + $Rate + "</td>";
        $DupItemTr += "<td class='GridViewLabItemStyle' id='tddelete" + NewIndex + "' style='text-align:center; display:none;' ><input type='image' src='../../Images/Delete.gif' onclick='return RemoveRow(this);' /></td></tr>'";
        $('#tablePOdetails tbody').append($DupItemTr);
        $UpdateAmounts(function () { });
    }

    function SearchPO() {
        $("#lblMsg").text('');
        $('#tablePOdetails tbody').empty();
        $('#POOutput,#DivPODetails').hide();
        var DeptLedgerNo='<%=Util.GetString(ViewState["DeptLedgerNo"])%>'
        $.ajax({
            type: "POST",
            url: "POGRN_Asset.aspx/SearchPO",
            data: '{PurchaseOrderNo:"' + $('#ddlpurchaseorder option:selected').val() + '",DeptLedgerNo:"' + DeptLedgerNo + '"}',
				dataType: "json",
				contentType: "application/json;charset=UTF-8",
				async: true,
				success: function (response) {
				    PODetail = jQuery.parseJSON(response.d);
				    if (PODetail != null) {
				        var output = $('#tb_PODetails').parseTemplate(PODetail);
				        $('#POOutput').html(output).customFixedHeader();
				        $('#POOutput,#DivPODetails').show();
				        $('#SpnOrderNo').text(PODetail[0].PurchaseOrderNo);
				        $('#SpnVendor').text(PODetail[0].VendorName);
				        $('#SpnPOAppDate').text(formatDate(PODetail[0].ApprovedDate));
				        $("#lblMsg").text("Total Records Found :" + PODetail.length);
				        $bindCal(function () { }); $UpdateAmounts(function () { });
				    }
				    else {
				        $('#POOutput,#DivPODetails').hide();
				        $("#lblMsg").text('No Record Found');
				    }
				},
				error: function (xhr, status) {
				}
			});
    }

    $bindCal = function (callback) {
        $('#tablePOdetails tbody tr').each(function () {
            $Index = $(this).closest('tr').find('#tdIndex').text();
            $('#txtInstDate_' + $Index + ',#txtFreeServiceFrom_' + $Index + ',#txtFreeServiceTo_' + $Index + ',#txtWarrantyFrom_' + $Index + ',#txtWarrantyTo_' + $Index).attr('readonly', 'readonly').datepicker({
                dateFormat: 'dd-M-yy',
                minDate: '+1D',
                changeMonth: true,
                changeYear: true
            });
        });
        callback(true);
    }  
    $UpdateAmounts = function (callback) {        
        $BillAmount = 0; $FreightCharges = 0; $RoundOff = 0;
        $('#tablePOdetails tbody tr').each(function () {
            $Index = $(this).closest('tr').find('#tdIndex').text();
            if ($('#chkselect' + $Index).is(":checked") == true) {
                $BillAmount += parseFloat($('#tdAmount' + $Index).text(),2);
                $RoundOff = Number(parseFloat(Math.round($BillAmount)) - parseFloat($BillAmount)).toFixed(2);
            }            
        });
        $('#txtInvoiceAmount').val(Number(Math.round($BillAmount)).toFixed(2));
        $('#txtFreight').val(Number($FreightCharges).toFixed(2));
        $('#txtRoundOff').val(Number($RoundOff).toFixed(2));
        callback(true);
    }

    $getInvoiceData = function (callback) {
        $data = new Array();
        $data.push({
            VenLedgerNo:    $('#ddlVendor').val().split('#')[0],
            InvoiceNo:      $('#txtInvoiceNo').val(),
            InvoiceDate:    $('#txtInvoiceDate').val(),
            NetAmount:      $('#txtInvoiceAmount').val(),
            ChalanNo:       $('#txtChallanNo').val(),
            ChalanDate:     $('#txtChallanDate').val(),
            FreightCharges: $('#txtFreight').val(),
            RoundOff:       $('#txtRoundOff').val(),
            StoreLedgerNo:  $("#rblType").find("input:radio:checked").val(),
            GRNType:        $("#rdoGRNType").find("input:radio:checked").val(),
            PaymentModeID:  $('#rdoGRNPayType').find(':checked').val(),
            PONumber:       $('#SpnOrderNo').text()
        });
        callback($data);
    }

    $getItemDetails = function (callback) {
        $data = new Array();
        $('#tablePOdetails tbody tr').each(function () {
            $rowid = $(this).closest('tr').find('#tdIndex').text(); $IsFree = 0;
            if ($('#chkselect' + $rowid).is(":checked") == true) {
                $data.push({
                    DeptLedgerNo: ('<%= ViewState["DeptLedgerNo"].ToString()%>'),
                    ItemID: $('#spnItemId_' + $rowid).text(),
                    PODID: $('#spnPODID_' + $rowid).text(),
                    HSNCode: $('#spnHSNCode_' + $rowid).text(),
                    ConversionFactor: $('#spnConversionFactor_' + $rowid).text(),
                    ItemName: $('#spnItemName_' + $rowid).text(),
                    SubCategoryID: $('#spnSubCategoryID_' + $rowid).text(),
                    OdrQty: $('#spnOrderedQty_' + $rowid).text(),
                    Quantity: $('#txtRcvQty_' + $rowid).val(),
                    UnitPrice: $('#tdUP' + $rowid).text(),
                    ItemGrossAmount: $('#tdAmount' + $rowid).text(),
                    MRP: $('#txtMRP_' + $rowid).val(),
                    BatchNumber: $('#txtBatchNo_' + $rowid).val(),
                    DiscPer: $('#tdDiscPer' + $rowid).text(),
                    Rate: $('#spnRate' + $rowid).text(),
                    taxCalculateOn: $('#tdCalcOn' + $rowid).text(),
                    GSTType: $('#tdGSTType' + $rowid).text(),
                    GSTPer: $('#tdGSTPer' + $rowid).text(),
                    IGSTPercent: $('#tdIGSTPer' + $rowid).text(),
                    IGSTAmt: 0,
                    CGSTPercent: $('#tdCGSTPer' + $rowid).text(),
                    CGSTAmt: 0,
                    SGSTPercent: $('#tdSGSTPer' + $rowid).text(),
                    SGSTAmt: 0,
                    DiscAmt: 0,
                    ItemGrossAmount: parseFloat($('#txtRcvQty_' + $rowid).val()) * parseFloat($('#spnRate' + $rowid).text()),
                    SpecialDiscPer: 0,
                    SpecialDiscAmt: 0,
                    PurTaxAmt: 0,
                    PurTaxPer: parseFloat($('#tdIGSTPer' + $rowid).text()) + parseFloat($('#tdIGSTPer' + $rowid).text()) + parseFloat($('#tdIGSTPer' + $rowid).text()),

                    StoreLedgerNo: $("#rblType").find("input:radio:checked").val(),
                    Naration: $('#txtNarration').val(),
                    IsFree: $IsFree,
                    //Asset----
                    SerialNo: $('#txtSerialNo_' + $rowid).val(),
                    ModelNo: $('#txtModel_' + $rowid).val(),
                    AssetTagNo: $('#txtAssetNo_' + $rowid).val(),
                    InstDate: $('#txtInstDate_' + $rowid).val(),
                    ServiceFrom: $('#txtFreeServiceFrom_' + $rowid).val(),
                    ServiceTo: $('#txtFreeServiceTo_' + $rowid).val(),
                    WarrantyNo: $('#txtWarrantyNo_' + $rowid).val(),
                    WarrantyFrom: $('#txtWarrantyFrom_' + $rowid).val(),
                    WarrantyTo: $('#txtWarrantyTo_' + $rowid).val(),
                    AssetPurDate: $('#txtAssetPurDate').text()
                    //Asset-----
                });
            }
        });
        callback($data);
    }

    $SaveGRN = function (btn, callback) {
        if ($validateData() == "0") {
            $(btn).attr('disabled', 'disabled');
            $getInvoiceData(function ($InvoiceData) {
                $getItemDetails(function ($ItemData) {
                    serverCall('Services/WebService.asmx/SavePOGRN', { InvoiceData: $InvoiceData, ItemDetails: $ItemData }, function (Response) {
                        if (Response != "") {
                            alert("GRN No. " + Response);
                            if ($("#rblType").find("input:radio:checked").val() == "STO00001")
                                window.open('DirectGRNReport.aspx?Hos_GRN=' + Response);
                            else
                                window.open('DirectGRNReport.aspx?Proj_GRN=' + Response);
                            $clear();
                        }
                        else {
                            modelAlert("Error Occured...");
                        }

                    });
                });
            });
        }
        $(btn).removeAttr('disabled');
        callback(true);
    }
    $clear = function () {
        location.reload();
    }

    $validateData = function () {        
        $con = 0; $RowChecked = 0;
        $('#tablePOdetails tbody tr').each(function () {
            $Index = $(this).closest('tr').find('#tdIndex').text();
            if ($('#chkselect' + $Index).is(":checked") == true) {               
                if ($('#spnItemName_' + $Index).text() == "" || $('#spnItemId_' + $Index).text() == "") {
                    modelAlert("Please Select Any Item At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtRcvQty_' + $Index).val() == "" || parseFloat($('#txtRcvQty_' + $Index).val()) < 1) {
                    modelAlert("Please Enter a Valid Receive Quantity At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                else if (parseFloat($('#txtRcvQty_' + $Index).val()) > parseFloat($('#spnOrderedQty_' + $Index).text())) {
                    modelAlert("Receive Quantity can not be greater than Ordered Quantity At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtBatchNo_' + $Index).val() == "") {
                    modelAlert("Please Enter a Batch No At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }                
                if ($('#txtMRP_' + $Index).val() == "") {
                    modelAlert("Please Enter MRP At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                else if ($('#txtMRP_' + $Index).val() != "" && (parseFloat(($('#txtMRP_' + $Index).val())) < parseFloat($('#spnRate' + $Index).text()))) {
                    modelAlert("Rate cannot be Greater Than MRP At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtQty_' + $Index).val() == "" || parseFloat($('#txtQty_' + $Index).val()) < 1) {
                    modelAlert("Please Enter a Valid QTY At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtBatchNo_' + $Index).val() == "") {
                    modelAlert("Please Enter Batch No. At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtModel_' + $Index).val() == "") {
                    modelAlert("Please Enter Model No. At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtAssetNo_' + $Index).val() == "") {
                    modelAlert("Please Enter Asset No. At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtInstDate_' + $Index).val() == "") {
                    modelAlert("Please Select Installation Date At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtFreeServiceFrom_' + $Index).val() == "") {
                    modelAlert("Please Select Free Service From Date At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtFreeServiceTo_' + $Index).val() == "") {
                    modelAlert("Please Select Free Service To Date At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtSerialNo_' + $Index).val() == "") {
                    modelAlert("Please Enter Serial No. At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtWarrantyNo_' + $Index).val() == "") {
                    modelAlert("Please Enter Warranty No At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtWarrantyFrom_' + $Index).val() == "") {
                    modelAlert("Please Select Warranty From Date At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                if ($('#txtWarrantyTo_' + $Index).val() == "") {
                    modelAlert("Please Select Warranty To Date At Row No.:" + $Index);
                    $(this).css("background-color", "#f54949");
                    $con = 1;
                    return false;
                }
                $RowChecked = 1;
            }
        });
        if ($('#txtAssetPurDate').val() == "") {
            $(this).focus();
            modelAlert("Please Enter Purchase Date");
            $con = 1;
        }
        if ($('#txtChallanNo').val() == "" && ($("#rdoGRNType").find("input:radio:checked").val() == "1" || $("#rdoGRNType").find("input:radio:checked").val() == "2")) {
            $(this).focus();
                modelAlert("Please Enter Challan No");               
                $con = 1;
            }
        else if ($('#txtChallanDate').val() == "" && ($("#rdoGRNType").find("input:radio:checked").val() == "1" || $("#rdoGRNType").find("input:radio:checked").val() == "2")) {
            $(this).focus();
                modelAlert("Please Enter Challan Date");
               
                $con = 1;
            }
        else if ($('#txtInvoiceNo').val() == "" && ($("#rdoGRNType").find("input:radio:checked").val() == "1" || $("#rdoGRNType").find("input:radio:checked").val() == "3")) {
            $(this).focus();
                modelAlert("Please Enter Invoice No");               
                $con = 1;
            }
        else if ($('#txtInvoiceDate').val() == "" && ($("#rdoGRNType").find("input:radio:checked").val() == "1" || $("#rdoGRNType").find("input:radio:checked").val() == "3")) {
            $(this).focus();
                modelAlert("Please Enter Invoice Date");
                
                $con = 1;
            }            
     
        if ($RowChecked == 0 && $con == 0) {
            modelAlert("Please Select Atleast One Row");
            $con = 1;
        }
        if ($('#txtNarration').val() == "" && $con == 0) {
            modelAlert("Please Enter Narration");
            $con = 1;
        }
        return $con;
    }

    $addQtyRow = function (id, isFree, Qty, callback) {
        var qty = $(Qty).val() - 1;
        $("#" + Qty.id).val(1);
        $("#" + Qty.id).prop("disabled", true)
        for (var n = 0; n < qty; n++) {
            $AddQtyItems(id, 0, function () {               
               // id = id + 1;
            });
        }
        $bindCal(function () { });
        callback(true);
    }
    $AddQtyItems = function (id, IsFree, callback) {        
            $isRequiredClass = "requiredField";
            var NewIndex = parseInt($('#tablePOdetails tbody tr:last').find("#tdIndex").text()) + 1;
            $QtyItemTr = "<tr id='tr_" + NewIndex + "'>";
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdchk' + NewIndex + '"><input type="checkbox" id="chkselect' + NewIndex + '" onclick="Enable(this);" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdAddDupItem' + NewIndex + '" style="display:none;"><img id="imgAddDupItem' + NewIndex + '" src="../../Images/plus_in.gif" onclick="AddDupItem(this)" style="cursor:pointer;" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdIndex" style="display:none;">' + NewIndex + '</td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdItemID' + NewIndex + '" style="display:none;"><span id="spnItemId_' + NewIndex + '"></span><span id="spnSubCategoryID_' + NewIndex + '" ></span><span id="spnConversionFactor_' + NewIndex + '"></span><span id="spnHSNCode_' + NewIndex + '"></span><span id="spnPODID_' + NewIndex + '" ></span></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdItemName' + NewIndex + '" style="text-align:left;font-size: 7.75pt;"><span id="spnItemName_' + NewIndex + '" ></span></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdOrderQty' + NewIndex + '"><span id="spnOrderedQty_' + NewIndex + '"></span></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdRcvQty' + NewIndex + '"><input type="text" id="txtRcvQty_' + NewIndex + '"  tabindex="' + (NewIndex * 100 + 1) + '" class="requiredField"   style="width:40px;" disabled="disabled" value="1" onblur="$addQtyRow(' + (id + 1) + ',1,this,function(){}),$CalNetValue(' + NewIndex + ',function(){})"  /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdBatch' + NewIndex + '"><input type="text" id="txtBatchNo_' + NewIndex + '"  tabindex="' + (NewIndex * 100 + 2) + '" class="requiredField"   style="width:50px;" disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdUP' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle"  id="tdAmount' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle"  id="tdMRP' + NewIndex + '"><input type="text" id="txtMRP_' + NewIndex + '" tabindex="' + (NewIndex * 100 + 3) + '" class="requiredField" style="width:70px;" disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdModelNo' + NewIndex + '"><input type="text" id="txtModelNo_' + NewIndex + '" style="width:80px;" tabindex="' + (NewIndex * 100 + 4) + '" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdAssetNo' + NewIndex + '"><input type="text" id="txtAssetNo_' + NewIndex + '" style="width:80px;" tabindex="' + (NewIndex * 100 + 5) + '" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);" disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdInstDate' + NewIndex + '"><input type="text" id="txtInstDate_' + NewIndex + '" style="width:65px;padding-left:0px;font-size: 11px;" tabindex="' + (NewIndex * 100 + 6) + '" class="requiredField" disabled="disabled" disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdFreeServiceFrom' + NewIndex + '"><input type="text" id="txtFreeServiceFrom_' + NewIndex + '" style="width:65px;padding-left:0px;font-size: 11px;" tabindex="' + (NewIndex * 100 + 7) + '" class="requiredField" disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdFreeServiceTo' + NewIndex + '"><input type="text" id="txtFreeServiceTo_' + NewIndex + '" style="width:65px;padding-left:0px;font-size: 11px;"  tabindex="' + (NewIndex * 100 + 8) + '"  class="requiredField" disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdSerialNo' + NewIndex + '"><input type="text" id="txtSerialNo_' + NewIndex + '" style="width:80px;" tabindex="' + (NewIndex * 100 + 9) + '" class="requiredField" onkeypress="return checkForSecondDecimal(this,event);"  disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdWarrantyNo' + NewIndex + '"><input type="text" id="txtWarrantyNo_' + NewIndex + '" style="width:80px;"  tabindex="' + (NewIndex * 100 + 10) + '" class="requiredField" disabled="disabled"  /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdWarrantyFrom' + NewIndex + '"><input type="text" id="txtWarrantyFrom_' + NewIndex + '" style="width:65px;padding-left:0px;font-size: 11px;"  tabindex="' + (NewIndex * 100 + 11) + '" class="requiredField" disabled="disabled"  /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdWarrantyTo' + NewIndex + '"><input type="text" id="txtWarrantyTo_' + NewIndex + '" style="width:65px;padding-left:0px;font-size: 11px;" tabindex="' + (NewIndex * 100 + 12) + '" class="requiredField" disabled="disabled" /></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdCalcOn' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdGSTType' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdIGSTPer' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdCGSTPer' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdSGSTPer' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdGSTPer' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdDiscPer' + NewIndex + '"></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tdRate' + NewIndex + '"><span id="spnRate' + NewIndex + '" ></td>';
            $QtyItemTr += '<td class="GridViewItemStyle" id="tddelete' + NewIndex + '" style="display:none;"><input type="image" src="../../Images/Delete.gif" onclick="return RemoveRow(this);" /></td></tr>';
            $('#tablePOdetails tbody').append($QtyItemTr);
            $setDuplicateRow(id, function () { });
            
        callback(true);
    }

    $setDuplicateRow = function (id, callback) {
        var NewIndex = parseInt($('#tablePOdetails tbody tr:last').find("#tdIndex").text());
        $('#tdCalcOn' + NewIndex).text($('#tdCalcOn' + (id)).text());
        $('#spnRate' + NewIndex).text($('#spnRate' + (id)).text());
        $('#txtMRP_' + NewIndex).val($('#txtMRP_' + (id)).val());
        $('#tdUP' + NewIndex).text($('#tdUP' + (id)).text());
        $('#tdAmount' + NewIndex).text($('#tdAmount' + (id)).text());
        $('#txtBatchNo_' + NewIndex).val($('#txtBatchNo_' + (id)).val());
        $('#tdGSTType' + NewIndex).text($('#tdGSTType' + (id)).text());
        $('#tdIGSTPer' + NewIndex).text($('#tdIGSTPer' + (id)).text());
        $('#tdSGSTPer' + NewIndex).text($('#tdSGSTPer' + (id)).text());
        $('#tdCGSTPer' + NewIndex).text($('#tdCGSTPer' + (id)).text());
        $('#tdGSTPer' + NewIndex).text($('#tdGSTPer' + (id)).text());
        $('#tdDiscPer' + NewIndex).text($('#tdDiscPer' + (id)).text());     
        $('#txtModel_' + NewIndex).val($('#txtModel_' + (id)).val());
        $('#txtAssetNo_' + NewIndex).val($('#txtAssetNo_' + (id)).val());
        $('#txtInstDate_' + NewIndex).val($('#txtInstDate_' + (id)).val());
        $('#txtFreeServiceFrom_' + NewIndex).val($('#txtFreeServiceFrom_' + (id)).val());
        $('#txtFreeServiceTo_' + NewIndex).val($('#txtFreeServiceTo_' + (id)).val());
        $('#txtSerialNo_' + NewIndex).val($('#txtSerialNo_' + (id)).val());
        $('#txtWarrantyNo_' + NewIndex).val($('#txtWarrantyNo_' + (id)).val());
        $('#txtWarrantyFrom_' + NewIndex).val($('#txtWarrantyFrom_' + (id)).val());
        $('#txtWarrantyTo_' + NewIndex).val($('#txtWarrantyTo_' + (id)).val());
        $('#spnItemName_' + NewIndex).text($('#spnItemName_' + (id)).text());
        $('#spnHSNCode_' + NewIndex).text($('#spnHSNCode_' + (id)).text());
        $('#spnItemId_' + NewIndex).text($('#spnItemId_' + (id)).text());
        $('#spnPODID_' + NewIndex).text($('#spnPODID_' + (id)).text());     
        $('#spnSubCategoryID_' + NewIndex).text($('#spnSubCategoryID_' + (id)).text());
        $('#spnConversionFactor_' + NewIndex).text($('#spnConversionFactor_' + (id)).text());
        $('#spnOrderedQty_' + NewIndex).text($('#spnOrderedQty_' + (id)).text());       
        $("#tr_" + NewIndex).css("background-color", "#e0fff6");
        callback(true);
    }


    </script>
     <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
         <asp:Label ID="lblhdnid" runat="server" style="display:none;"  ClientIDMode="Static"></asp:Label>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>PO GRN Asset Store</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" meta:resourcekey="lblMsgResource1" />
        </div>
        <Ajax:UpdatePanel ID="up" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                       Item Detail
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                               <div class="col-md-3">
                                    <label class="pull-left">
                                        Store Type
                                    </label>
                                    <b class="pull-right">:</b>
                               </div>
                               <div class="col-md-5">
                                    
                                <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                    <asp:ListItem Text="Medical" Value="STO00001" Selected="True" />
                                    <asp:ListItem Text="General" Value="STO00002" />
                                </asp:RadioButtonList> 
                               </div>
                               <div class="col-md-3">
                                    <label class="pull-left">
                                        Supplier
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                               <div class="col-md-5">
                                   <select id="ddlVendor" class="requiredField"></select>                                  
                                </div>                                 
                               <div class="col-md-3">
                                    <label class="pull-left">PO No</label>
                                    <b class="pull-right">:</b>
                                </div>
                               <div class="col-md-5">
                                    <select id="ddlpurchaseorder" class="requiredField"></select>
                                </div>                                
                            </div>                                         
                        </div>                      
                        <div class="col-md-1"></div>
                    </div>
               
                    <div>
                    </div>
                </div>

            </ContentTemplate>
        </Ajax:UpdatePanel>
            <div id="DivPODetails" style="display:none;" class="POuter_Box_Inventory">
               <div class="Purchaseheader">
                   Order Detail
               </div>
                     <div class="row">
                        <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                   <div class="col-md-3">
                                        <label class="pull-left">Order No</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                       <span id="SpnOrderNo"></span>
                                   </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Supplier</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5"><span id="SpnVendor"></span></div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Purchase Date</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5"><span id="SpnPOAppDate" style="display:none;"></span>
                                                    <input type="text" id="txtAssetPurDate" style="width:100px" class="requiredField"  />

                                   </div>
                                 </div>                                         
                             </div>                      
                         </div>
                 <div class="row">
                        <div class="col-md-1"></div>
                          <div class="col-md-22">
                                <div class="row">
                                   <div class="col-md-3">
                                        <label class="pull-left">GRN Type</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-13">
                                        <asp:RadioButtonList ID="rdoGRNType" runat="server" ClientIDMode="Static" AutoPostBack="false" Font-Bold="true" Font-Names="Verdana" Font-Size="12px" RepeatColumns="3" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="Challan No With Invoice" Value="1"></asp:ListItem>
                                            <asp:ListItem Selected="True" Text="Challan No" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="Invoice" Value="3"></asp:ListItem>
                                        </asp:RadioButtonList>
                                   </div>

                                    <div class="col-md-3">
                                        <label class="pull-left">Payment Type</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                        <asp:RadioButtonList ID="rdoGRNPayType" runat="server"
                                            RepeatColumns="2" RepeatDirection="Horizontal" ClientIDMode="Static">
                                            <asp:ListItem Text="Credit" Selected="True" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="Cash" Value="1"></asp:ListItem>
                                        </asp:RadioButtonList>
                                   </div>
                                 </div>                                         
                             </div>                      
                    </div>

                <div class="row" id="divChallan">
                       <div class="col-md-1"></div>
                          <div class="col-md-22">
                                <div class="row">
                                   <div class="col-md-3">
                                        <label class="pull-left">Challan No</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                      <input type="text" id="txtChallanNo" style="width:100px" class="requiredField"  />
                                   </div>

                                   <div class="col-md-3">
                                        <label class="pull-left">Challan Date</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                        <input type="text" id="txtChallanDate" style="width:100px" class="requiredField"  />
                                   </div>
                                   <div class="col-md-8"></div>
                                 </div>                                         
                             </div>                      
                    </div>

                 <div class="row" id="divInv"  style="display:none;">
                        <div class="col-md-1"></div>
                          <div class="col-md-22">
                                <div class="row">
                                   <div class="col-md-3">
                                        <label class="pull-left">Invoice No</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                      <input type="text" id="txtInvoiceNo" style="width:100px" class="requiredField"  />
                                   </div>

                                   <div class="col-md-3">
                                        <label class="pull-left">Invoice Date</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                        <input type="text" id="txtInvoiceDate" style="width:100px" class="requiredField"  />
                                   </div>

                                   <div class="col-md-3">
                                        <label class="pull-left"></label>
                                        <b class="pull-right"></b>
                                   </div>
                                   <div class="col-md-5">
                                       
                                   </div>
                                 </div>                                         
                             </div>                      
                     
                    </div>

               <div class="row"></div>
            <div class="Purchaseheader">
                Order Items
            </div>
            <div style="text-align: center;">               
                    <div id="POOutput" style="height:230px;width:100%;overflow-y:auto"> </div>               
            </div>

            <div class="Purchaseheader">
               Bill Detail
            </div>
            <div style="text-align: center;">               
                     <div class="row">
                        <div class="col-md-1"></div>
                          <div class="col-md-22">
                                <div class="row">
                                   <div class="col-md-3">
                                        <label class="pull-left">Freight</label><b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5" style="text-align: left;">
                                      <input type="text" id="txtFreight" style="width:80px" tabindex="12" />
                                   </div>
                                   <div class="col-md-3">
                                        <label class="pull-left">Round Off</label><b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                        <input type="text" id="txtRoundOff" style="width:80px" />
                                   </div>
                                   <div class="col-md-3">
                                        <label class="pull-left">Bill Amount</label>
                                        <b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-5">
                                          <input type="text" id="txtInvoiceAmount" style="width:80px" />
                                   </div>
                                 </div>                                         
                             </div>                      
                    </div>       
                     <div class="row">
                        <div class="col-md-1"></div>
                          <div class="col-md-22">
                                <div class="row">
                                   <div class="col-md-3">
                                        <label class="pull-left">Narration</label><b class="pull-right">:</b>
                                   </div>
                                   <div class="col-md-21" style="text-align: left;">
                                      <input type="text" id="txtNarration" style="width:1000px" class="requiredField" />
                                   </div>                                  
                                 </div>                                         
                             </div>                      
                    </div>     
                 <div class="row">
                        <div class="col-md-1"></div>
                          <div class="col-md-22">
                                <div class="row">
                                   <div class="col-md-24">
                                       <input type="button" id="btnSaveGRN" value="Save" class="ItDoseButton" style="width: 100px; margin-top: 7px;"  onclick="$SaveGRN(this, function () { });" />
                                       <input type="button" id="btnCancelGRN" value="Cancel" class="ItDoseButton" style="width: 100px; margin-top: 7px;" onclick="$clear();" />

                                   </div>                                  
                                 </div>                                         
                             </div>                      
                        <div class="col-md-1"></div>
                    </div>      
            </div>                

           </div>
   
    </div>

  
     <script id="tb_PODetails" type="text/html">
    <table  id="tablePOdetails" cellspacing="0" class="yui" style="width: 1900px;border-collapse:collapse;">
        <thead>
        <tr class="tblTitle" id="Header">
            <th class="GridViewHeaderStyle" scope="col" ></th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" ></th>             
            <th class="GridViewHeaderStyle" scope="col" style=" display:none;font-size: 8.5pt;" >S.No.</th>    
            <th class="GridViewHeaderStyle" scope="col" style=" display:none;font-size: 8.5pt;" >ItemID</th>       
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >O.Qty</th>       
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Rcv.Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Batch</th>                     
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >U.Price</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >MRP</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Model No</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Asset No</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Inst.Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Service From</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Service To </th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Serial No</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Warranty No</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Warranty From</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Warranty To</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >CalcOn</th> 
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >GSTType</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >ISGT(%)</th>          
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >CGST(%)</th>         
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >SGST(%)</th>
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Tax(%)</th>         
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Disc(%)</th>         
            <th class="GridViewHeaderStyle" scope="col" style="font-size: 8.5pt;" >Rate</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >Remove</th>
        </tr>
            </thead>
        <tbody>
        <#     
              var dataLength=PODetail.length;
                var objRow;
       for(var j=0;j<dataLength;j++)
        {
        objRow = PODetail[j];
        #>
                        <tr data='<#= JSON.stringify(PODetail[j])#>' id="tr_<#=j+1#>">

                        <td class="GridViewLabItemStyle" id="tdchk<#=j+1#>" style="text-align:left;font-size: 7.75pt;" >
                            <input type="checkbox" id="chkselect<#=j+1#>" onclick="Enable(this);" /></td>     
                         <td class="GridViewLabItemStyle" id="tdAddDupItem<#=j+1#>" style="text-align:left;display:none;" >
                            <img id="imgAddDupItem" alt="" src="../../Images/plus_in.gif" style="cursor:pointer"  onclick="AddDupItem(this)" /></td>                                                                                     
                        <td class="GridViewLabItemStyle" id="tdIndex"  style="width:30px;display:none;"><#=j+1#></td> 
                        <td class="GridViewLabItemStyle" id="tdItemID<#=j+1#>"  style="width:30px;display:none;font-size: 7.75pt;">
                             <span id="spnItemId_<#=j+1#>" style="display:none;"><#=objRow.ItemID#></span>
                            <span id="spnPODID_<#=j+1#>" style="display:none;"><#=objRow.PurchaseOrderDetailID#></span>
                             <span id="spnSubCategoryID_<#=j+1#>" style="display:none;"><#=objRow.SubCategoryID#></span>
                            <span id="spnConversionFactor_<#=j+1#>" style="display:none;"><#=objRow.ConversionFactor#></span>
                               <span id="spnHSNCode_<#=j+1#>" style="display:none;"><#=objRow.HSNCode#></span>
                            <#=objRow.ItemID#></td>                          
                        <td class="GridViewLabItemStyle" id="tdItemName<#=j+1#>" style="text-align:left;font-size: 7.75pt;" ><#=objRow.ItemName#>
                            <span id="spnItemName_<#=j+1#>" style="display:none;"><#=objRow.ItemName#></span>
                        </td>                      
                        <td class="GridViewLabItemStyle" id="tdOrderQty<#=j+1#>" >
                               <span id="spnOrderedQty_<#=j+1#>" style="display:none;"><#=objRow.OrderedQty#></span>
                            <#=objRow.OrderedQty#></td>                                             
                        <td class="GridViewLabItemStyle" id="tdRcvQty<#=j+1#>" >
                            <input type="text" id="txtRcvQty_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 1) + " class="requiredField"   style="width:40px;" disabled="disabled" value="1" onblur="$addQtyRow(<#=j+1#>,1,this,function(){}),$CalNetValue(<#=j+1#>,function(){})"  /></td>                       
                        <td class="GridViewLabItemStyle" id="tdBatch<#=j+1#>" >
                             <input type="text" id="txtBatchNo_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 2) + " class="requiredField"   style="width:50px;" disabled="disabled" />    </td>                                       
                        <td class="GridViewLabItemStyle" id="tdUP<#=j+1#>" ><#=objRow.ActualRate#></td>                                         
                        <td class="GridViewLabItemStyle" id="tdAmount<#=j+1#>" ><#=objRow.ActualRate#></td>                    
                        <td class="GridViewLabItemStyle" id="tdMRP<#=j+1#>"><input type="text" id="txtMRP_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 3) + " class="requiredField" style="width:70px;" disabled="disabled" value="<#=objRow.MRP#>" /></td>                        
                        <td class="GridViewLabItemStyle" id="tdModelNo<#=j+1#>"><input type="text" id="txtModel_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 4) + " class="requiredField" style="width:80px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdAssetNo<#=j+1#>"><input type="text" id="txtAssetNo_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 5) + " class="requiredField" style="width:80px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdInstDate<#=j+1#>"><input type="text" id="txtInstDate_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 6) + " class="requiredField" style="width:65px;padding-left:0px;font-size: 11px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdFreeServiceFrom<#=j+1#>"><input type="text" id="txtFreeServiceFrom_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 7) + " class="requiredField" style="width:65px;padding-left:0px;font-size: 11px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdFreeServiceTo<#=j+1#>"><input type="text" id="txtFreeServiceTo_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 8) + " class="requiredField" style="width:65px;padding-left:0px;font-size: 11px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdSerialNo<#=j+1#>"><input type="text" id="txtSerialNo_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 9) + " class="requiredField" style="width:80px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdWarrantyNo<#=j+1#>"><input type="text" id="txtWarrantyNo_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 10) + " class="requiredField" style="width:80px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdWarrantyFrom<#=j+1#>"><input type="text" id="txtWarrantyFrom_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 11) + " class="requiredField" style="width:65px;padding-left:0px;font-size: 11px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdWarrantyTo<#=j+1#>"><input type="text" id="txtWarrantyTo_<#=j+1#>"  tabindex="+ (<#=j+1#> * 100 + 12) + " class="requiredField" style="width:65px;padding-left:0px;font-size: 11px;" disabled="disabled" /></td>
                        <td class="GridViewLabItemStyle" id="tdCalcOn<#=j+1#>" ><#=objRow.TaxCalulatedOn#></td>
                        <td class="GridViewLabItemStyle" id="tdGSTType<#=j+1#>" ><#=objRow.GSTType#></td>                     
                        <td class="GridViewLabItemStyle" id="tdIGSTPer<#=j+1#>" ><#=objRow.IGSTPercent#></td>                    
                        <td class="GridViewLabItemStyle" id="tdCGSTPer<#=j+1#>" ><#=objRow.CGSTPercent#></td>
                        <td class="GridViewLabItemStyle" id="tdSGSTPer<#=j+1#>" ><#=objRow.SGSTPercent#></td>
                        <td class="GridViewLabItemStyle" id="tdGSTPer<#=j+1#>" ><#=objRow.VATPer#></td>                       
                        <td class="GridViewLabItemStyle" id="tdDiscPer<#=j+1#>" ><#=objRow.Discount_p#></td>                                         
                        <td class="GridViewLabItemStyle" id="tdRate<#=j+1#>" >
                            <span id="spnRate<#=j+1#>" style="display:none;"><#=objRow.RateDisplay#></span>
                            <#=objRow.RateDisplay#></td>   

                        <td class="GridViewLabItemStyle" id="tddelete<#=j+1#>" style="text-align:center; display:none;" >
                            <input type="image" src="../../Images/Delete.gif" onclick="return RemoveRow(this);" />
                        </td>                       
                       </tr>            
        <#}        
        #>
            </tbody>      
     </table> 
   </script>


 

</asp:Content>

