<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="StoreItemsRate.aspx.cs" Inherits="Design_Purchase_StoreItemsRate" %>

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
                     modelAlert('Invalid Discount');
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
             modelAlert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
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
         modelAlert('Enter Rate First');
     }
     if (name == "txtDiscAmt") {
         if (parseFloat($('#<%=txtDiscAmt.ClientID %>').val()) > parseFloat($('#<%=txtRate.ClientID %>').val())) {
             $('#<%=txtDiscAmt.ClientID %>').val('');
             modelAlert('Discount Amount Can not be Greater than Rate');
         }
         else {
             $('#<%=lblMsg.ClientID %>').text('');
         }
     }
     if (name == "txtDiscPer") {
         if (parseFloat($('#<%=txtDiscPer.ClientID %>').val()) > "100") {
             $('#<%=txtDiscPer.ClientID %>').val('');
             modelAlert('Discount Percentage Can not be Greater than 100');
         }
         else {
             $('#<%=lblMsg.ClientID %>').text('');
         }
     }
 }


 $(document).ready(function () {
     BindCategory();
     BindVendor();
     BindAllManufacturer();
 });
 function SaveAllItems(ctr) {
     ctr.disabled = true;
     ctr.value = 'Submitting...';
     var Category = $('[id$=ddlCategoryn]').val();
     var data = {
         Category: Category
     }
     $.ajax({
         type: "POST",
         timeout: 120000,
         url: "StoreItemsRate.aspx/SaveAllItems",
         data: JSON.stringify(data),
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         success: function (data) {
             ItemDetails = JSON.parse(data.d);
             if (ItemDetails == true) {
                 modelAlert('Record Save successfully', function () {
                     ctr.disabled = true;
                     ctr.value = 'Save';
                     $('[id$=DivItemDetails]').html('');
                     BindVendor();
                     BindAllManufacturer();
                     BindCategory();
                     $('[id$=lblItemName]').text('')
                     $('[id$=lblItemName]').val('');
                     $('[id$=ddlSubCategory]').html('');
                     $('[id$=ddlSubCategory]').append(jQuery("<option></option>").val('0').html(" "));
                     $('[id$=ddlSubCategory]').trigger('chosen:updated');
                 });
             }
             else {
                 modelAlert('Record Not Saved!..');
             }
         },
         error: function (xhr, status) {
             modelAlert("Error ");
         }
     });
 }

 function RemoveRow(ctr) {
     modelConfirmation('Item Delete Confirmation ?', 'Are you sure want to delete this Item!', 'Yes', 'Cancel', function (response) {
         if (response == true) {
             var RowId = $(ctr).closest('tr').find('[id$=tdIndex]').text();
             RowId = RowId - 1;
             $.ajax({
                 type: "POST",
                 timeout: 120000,
                 url: "StoreItemsRate.aspx/DeleteRow",
                 data: '{ RowId: "' + RowId + '"}',
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     if (data.d == "") {
                         $('#DivItemDetails').html('');
                         $('[id$=btnSave]').prop('disabled', true);
                     }
                     else {
                         ItemDetails = JSON.parse(data.d);
                         if (ItemDetails.length > 0) {
                             var output = $('#tb_ItemDetails').parseTemplate(ItemDetails);
                             if (output != "" && output != null) {
                                 $('#DivItemDetails').html(output).customFixedHeader();
                                 $('[id$=btnSave]').prop('disabled', false);
                                 $('[id$=ddlCategoryn]').prop('disabled', true);
                             }
                             else {
                                 $('#DivItemDetails').html('');
                             }
                         }
                         else {
                             $('#DivItemDetails').html('');
                             $('[id$=btnSave]').prop('disabled', true);
                         }
                     }
                 },
                 error: function (xhr, status) {
                     modelAlert("Error ");
                 }
             });
         }
         else
             return false;
     });
     return false;
 }
 function UpdateItem() {
     var VendorNewId = $('[id$=ddlnVendor] option:selected').val();
     var VendorName = $('[id$=lblhdnid]').val().split('#')[1].toString();
     var ItemId = $('[id$=lblhdnid]').val().split('#')[2].toString();
     var ItemName = $('[id$=lblhdnid]').val().split('#')[3].toString();
     var StoreRateId = $('[id$=lblhdnid]').val().split('#')[4].toString();
     var UcFromDate = $('[id$=ucFromDate]').val();
     var UcToDate = $('[id$=ucToDate]').val();
     var rate = $('#<%=txtRate.ClientID %>').val();
     var Tax = $('#<%=ddlTAX1.ClientID %> option:selected').text();
     var IGST = $('#<%=txtIGSTPer.ClientID %>').val();
     var CGST = $('#<%=txtCGSTPer.ClientID %>').val();
     var SGCT = $('#<%=txtSGSTPer.ClientID %>').val();
     var DiscountPercent = $('#<%=txtDiscPer.ClientID %>').val();
     var DiscAmt = $('#<%=txtDiscAmt.ClientID %>').val();
     var Deal1 = $('#<%=txtDeal1.ClientID %>').val();
     var Deal2 = $('#<%=txtDeal2.ClientID %>').val();
     var rblTaxCal = $('input[type=radio]:checked').val();
     var chkIsActive = "";
     if ($('#<%=chkIsActive.ClientID %>').is(':checked') == true) {
         chkIsActive = "true";
     }
     else
         chkIsActive = "false";
     var MRP = $('#<%=txtMRP.ClientID %>').val();
     var txtHSNCode = $('#<%=txtHSNCode.ClientID %>').val();
     var txtRemarks = $('#<%=txtRemarks.ClientID %>').val();
     var Manufacturer_ID = $('[id$=ddlManufacturer] option:selected').val();
     var Manufacturer = $('[id$=ddlManufacturer] option:selected').text();
     if (Manufacturer == "Select") {
         Manufacturer = "";
     }
     var data = {
         ItemId: ItemId,
         UcFromDate: UcFromDate,
         UcTodate: UcToDate,
         // Subcategory: Subcategory,
         VendorId: VendorNewId,
         VendorName: VendorName,
         ItemName: ItemName,
         rate: rate,
         Tax: Tax,
         IGST: IGST,
         CGST: CGST,
         SGST: SGCT,
         DiscountPercent: DiscountPercent,
         DiscAmt: DiscAmt,
         Deal1: Deal1,
         Deal2: Deal2,
         rblTaxCal: rblTaxCal,
         chkIsActive: chkIsActive,
         MRP: MRP,
         txtHSNCode: txtHSNCode,
         txtRemarks: txtRemarks,
         Manufacturer_ID: Manufacturer_ID,
         Manufacturer: Manufacturer,
         StoreRateId: StoreRateId
     }
     $.ajax({
         type: "POST",
         timeout: 120000,
         url: "StoreItemsRate.aspx/UpdateItem",
         data: JSON.stringify(data),
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         success: function (data) {
             ItemDetails = JSON.parse(data.d);
             if (ItemDetails == true) {
                 modelAlert('Recored update successfully.', function () {
                     $('[id$=btnAddItems]').val('Add');
                     $('#<%=txtRate.ClientID %>').val('');
                     $('#<%=txtRemarks.ClientID %>').val('');
                     $('#<%=txtDiscAmt.ClientID %>').val('');
                     $('#<%=txtDiscPer.ClientID %>').val('');
                     $('#<%=txtMRP.ClientID %>').val('');
                     $('#<%=txtDeal1.ClientID %>').val('');
                     $('#<%=txtDeal2.ClientID %>').val('');
                     $('#<%=ddlTAX1.ClientID %> option:selected').text("IGST");
                     $('#<%=lblMsg.ClientID %>').text('');
                     $('#<%=txtIGSTPer.ClientID %>').val('');
                     $('#<%=txtCGSTPer.ClientID %>').val('');
                     $('#<%=txtSGSTPer.ClientID %>').val('');
                     $('#<%=txtHSNCode.ClientID %>').val('');
                     SearchSupplierQuotation();
                     BindAllManufacturer();
                 });
             }
             else {
                 $('[id$=btnAddItems]').val('Update');
                 $('#<%=lblMsg.ClientID %>').text('');
             }
         },
         error: function (xhr, status) {
             modelAlert("Error ");
         }
     });

 }

 function AddItems() {
     if ($('[id$=btnAddItems]').val() == 'Update') {
         UpdateItem();
     }
     else if ($('[id$=btnAddItems]').val() == 'Add') {
         if ($('[id$=ddlnVendor]').val() == "0") {
             $('#<%=lblMsg.ClientID %>').text('Please Select Supplier');
             $('[id$=ddlnVendor]').focus();
             return false;
         }
         if ($('[id$=lblItemName]').val() == "") {
             $('#<%=lblMsg.ClientID %>').text('Please Select Item');
             $("#txtSearchItem").focus();
             return false;
         }
         if ($("#lblItemName").text() == "0" || $("#lblItemName").text() == "Select") {
             $('#<%=lblMsg.ClientID %>').text('Please Select Item');
             $("#ddlItems").focus();
             return false;
         }
         else {
             var ItemId = $('[id$=lblItemName]').val();
             var ItemName = $('[id$=lblItemName]').text();
             var UcFromDate = $('[id$=ucFromDate]').val();
             var UcToDate = $('[id$=ucToDate]').val();
             var Category = $('[id$=ddlCategoryn]').val();
             var VendorId = $('[id$=ddlnVendor]').val();
             var VendorName = $('[id$=ddlnVendor] option:selected ').text();
             var Subcategory = $('[id$=ddlSubCategory] option:selected').val();
             var rate = $('#<%=txtRate.ClientID %>').val();
             var Tax = $('#<%=ddlTAX1.ClientID %> option:selected').text();
             var IGST = $('#<%=txtIGSTPer.ClientID %>').val();
             var CGST = $('#<%=txtCGSTPer.ClientID %>').val();
             var SGCT = $('#<%=txtSGSTPer.ClientID %>').val();
             var DiscountPercent = $('#<%=txtDiscPer.ClientID %>').val();
             var DiscAmt = $('#<%=txtDiscAmt.ClientID %>').val();
             var Deal1 = $('#<%=txtDeal1.ClientID %>').val();
             var Deal2 = $('#<%=txtDeal2.ClientID %>').val();
             var rblTaxCal = $('input[type=radio]:checked').val();
             var chkIsActive = "";
             if ($('#<%=chkIsActive.ClientID %>').is(':checked') == true) {
                 chkIsActive = "true";
             }
             else
                 chkIsActive = "false";
             var MRP = $('#<%=txtMRP.ClientID %>').val();
             var txtHSNCode = $('#<%=txtHSNCode.ClientID %>').val();
             var txtRemarks = $('#<%=txtRemarks.ClientID %>').val();
             var Manufacturer_ID = $('[id$=ddlManufacturer] option:selected').val();
             var Manufacturer = $('[id$=ddlManufacturer] option:selected').text();
             if (Manufacturer == "Select") {
                 Manufacturer = "";
             }
             var data = {
                 ItemId: ItemId,
                 UcFromDate: UcFromDate,
                 UcTodate: UcToDate,
                 Subcategory: Subcategory,
                 VendorId: VendorId,
                 VendorName: VendorName,
                 ItemName: ItemName,
                 rate: rate,
                 Tax: Tax,
                 IGST: IGST,
                 CGST: CGST,
                 SGST: SGCT,
                 DiscountPercent: DiscountPercent,
                 DiscAmt: DiscAmt,
                 Deal1: Deal1,
                 Deal2: Deal2,
                 rblTaxCal: rblTaxCal,
                 chkIsActive: chkIsActive,
                 MRP: MRP,
                 txtHSNCode: txtHSNCode,
                 txtRemarks: txtRemarks,
                 Manufacturer_ID: Manufacturer_ID,
                 Manufacturer: Manufacturer,
                 CategoryId: Category
             }
             $.ajax({
                 type: "POST",
                 timeout: 120000,
                 url: "StoreItemsRate.aspx/AddItems",
                 data: JSON.stringify(data),
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,
                 success: function (data) {
                     if (data.d == "1") {
                         modelAlert("Vendor is Already Active for this Item", function () {
                             $('#<%=lblMsg.ClientID %>').text('');
                         });
                         return false;
                     }
                     if (data.d == "2") {
                         modelAlert("Vendor is Already Added for this item", function () {
                             $('#<%=lblMsg.ClientID %>').text('');
                         });
                         return false;
                     }
                     else {
                         if (data.d != "") {
                             ItemDetails = JSON.parse(data.d);
                             if (ItemDetails.length > 0) {
                                 var output = $('#tb_ItemDetails').parseTemplate(ItemDetails);
                                 if (output != "" && output != null) {
                                     $('#DivItemDetails').html(output).customFixedHeader();
                                     $('[id$=btnSave]').prop('disabled', false);
                                     $('#<%=txtRate.ClientID %>').val('');
                                     $('#<%=txtRemarks.ClientID %>').val('');
                                     $('#<%=txtDiscAmt.ClientID %>').val('');
                                     $('#<%=txtDiscPer.ClientID %>').val('');
                                     $('#<%=txtMRP.ClientID %>').val('');
                                     $('#<%=txtDeal1.ClientID %>').val('');
                                     $('#<%=txtDeal2.ClientID %>').val('');
                                     $('#ddlTAX1').val('T4')
                                     $('#<%=txtIGSTPer.ClientID %>').val('0');
                                     $('#<%=txtCGSTPer.ClientID %>').val('0').attr('disabled','disabled');
                                     $('#<%=txtSGSTPer.ClientID %>').val('0').attr('disabled', 'disabled');
                                     $('#txtTAX1').val('0');
                                     $('#<%=txtHSNCode.ClientID %>').val('');
                                     $('#<%=lblMsg.ClientID %>').text('');
                                     BindVendor();
                                     BindAllManufacturer();
                                     $('#ddlnVendor').chosen('destroy').val(VendorId).chosen();
                                     $('#ddlManufacturer').chosen('destroy').val(Manufacturer_ID).chosen();
                                     $('#txtSearchItem').focus();
                                 }
                                 else {
                                     $('#DivItemDetails').html('');
                                 }
                             }
                             else {
                                 $('#DivItemDetails').html('');
                                 $('[id$=btnSave]').prop('disabled', true);
                                 $('#<%=lblMsg.ClientID %>').text('');
                             }
                         }
                     }
                 },
                 error: function (xhr, status) {
                     modelAlert("Error ");
                 }
             });
         }
     }
}

function BindItemOnSubcategory() {
    //BindItem();
}

function BindSubcategory() {
    $.ajax({
        type: "POST",
        timeout: 120000,
        url: "StoreItemsRate.aspx/BindAllSubcategory",
        data: '{ Category: "' + $('[id$=ddlCategoryn]').val() + '"}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (data) {
            Subcat = jQuery.parseJSON(data.d);
            if (Subcat != null) {
                if (Subcat.length == 0) {
                    $('[id$=ddlSubCategory]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    $('[id$=ddlSubCategory]').html('');
                    $('[id$=ddlSubCategory]').append(jQuery("<option></option>").val("All").html("ALL"));
                    for (i = 0; i < Subcat.length; i++) {
                        $('[id$=ddlSubCategory]').append(jQuery("<option></option>").val(Subcat[i].SubCategoryID).html(Subcat[i].Name));
                    }
                    $('[id$=ddlSubCategory]').chosen();
                    $('[id$=ddlSubCategory]').trigger('chosen:updated');
                }
            }
        },
        error: function (xhr, status) {
            modelAlert("Error ");
            $('[id$=ddlSubCategory]').attr("disabled", false);
        }
    });
}

function BindItem() {
    var SubcategoryId = "";
    if ($('[id$=ddlSubCategory]').val() != null) {
        SubcategoryId = $('[id$=ddlSubCategory] option:selected').val();
        if (SubcategoryId == "All")
            SubcategoryId = "0";
    }
    else {
        SubcategoryId = "0";
    }
    $.ajax({
        type: "POST",
        timeout: 120000,
        url: "StoreItemsRate.aspx/BindItemList",
        data: '{ CategoryId: "' + $('[id$=ddlCategoryn]').val() + '",SubCategory:"' + SubcategoryId + '"}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.d == "") {
                $('[id$=ddlItems]').html('');
                $('[id$=ddlItems]').append(jQuery("<option></option>").val('0').html(" "));
                $('[id$=ddlItems]').trigger('chosen:updated');
            }
            else {
                Subcat = jQuery.parseJSON(data.d);
                if (Subcat.length == 0) {
                    $('[id$=ddlItems]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    $('[id$=ddlItems]').html('');
                    $('[id$=ddlItems]').append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < Subcat.length; i++) {
                        $('[id$=ddlItems]').append(jQuery("<option></option>").val(Subcat[i].ItemId).html(Subcat[i].TypeName));
                    }
                    $('[id$=ddlItems]').chosen();
                    $('[id$=ddlItems]').trigger('chosen:updated');
                }
            }
        },
        error: function (xhr, status) {
            modelAlert("Error ");
            $('[id$=ddlItems]').attr("disabled", false);
        }
    });
}

function UpdateItemList() {
    var SubcategoryId = "";
    if ($('[id$=ddlCategoryn]').val() == "0") {
        return false;
    }
    else {
        if ($('[id$=ddlSubCategory]').val() == null) {
            return false;
        }
        else {
            SubcategoryId = $('[id$=ddlSubCategory] option:selected').val();
            if (SubcategoryId == "All")
                SubcategoryId = "0";
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "StoreItemsRate.aspx/BindItemList",
                data: '{ CategoryId: "' + $('[id$=ddlCategoryn]').val() + '",SubCategory:"' + SubcategoryId + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d == "") {
                        $('[id$=ddlItems]').html('');
                        $('[id$=ddlItems]').append(jQuery("<option></option>").val('0').html(" "));
                        $('[id$=ddlItems]').trigger('chosen:updated');
                    }
                    else {
                        Subcat = jQuery.parseJSON(data.d);
                        if (Subcat.length == 0) {
                            $('[id$=ddlItems]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            $('[id$=ddlItems]').html('');
                            $('[id$=ddlItems]').append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < Subcat.length; i++) {
                                $('[id$=ddlItems]').append(jQuery("<option></option>").val(Subcat[i].ItemId).html(Subcat[i].TypeName));
                            }
                            $('[id$=ddlItems]').chosen();
                            $('[id$=ddlItems]').trigger('chosen:updated');
                        }
                    }
                },
                error: function (xhr, status) {
                    modelAlert("Error ");
                    $('[id$=ddlItems]').attr("disabled", false);
                }
            });
            return false;
        }
    }
}

function BindItemList() {
    //BindItem()
    BindSubcategory();
}

function BindPurchaseUnit() {
    if ($('[id$=lblItemName]').val() == "") {
        return false;
    }
    else {
        var ItemId = $('[id$=lblItemName]').val();
        if (ItemId != "0" && ItemId != "") {
            $.ajax({
                type: "POST",
                timeout: 120000,
                async: false,
                url: "StoreItemsRate.aspx/BindPurchaseUnit",
                data: '{ ItemId: "' + ItemId + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var Result = JSON.parse(data.d);
                    if (Result.length > 0) {
                        $('#<%=lblPerchaseUnit.ClientID %>').text(Result[0].majorUnit);
                    }
                    else {
                        $('#<%=lblPerchaseUnit.ClientID %>').text('');
                    }
                },
                error: function (xhr, status) {
                    modelAlert("Error");
                }
            });
        }
        return false;
    }
}
function BindCategory() {
    $.ajax({
        type: "POST",
        timeout: 120000,
        url: "StoreItemsRate.aspx/BindCategoryDropDown",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.d == "1" || data.d == "2") {
                var Msg = "You do not have rights to Create Items";
                window.location.href = '../Purchase/MsgPage.aspx?msg=' + Msg;
                return false;
            }
            else {
                $('[id$=ddlCategoryn]').append(jQuery("<option></option>").val("0").html("Select"));
                Subcat = jQuery.parseJSON(data.d);
                if (Subcat.length == 0) {
                    $('[id$=ddlCategoryn]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    $('[id$=ddlCategoryn]').html('');
                    $('[id$=ddlCategoryn]').append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < Subcat.length; i++) {
                        $('[id$=ddlCategoryn]').append(jQuery("<option></option>").val(Subcat[i].CategoryID).html(Subcat[i].Name));
                    }
                    $('[id$=ddlCategoryn]').attr("disabled", false);
                    $('[id$=ddlCategoryn]').chosen();
                    $('[id$=ddlCategoryn]').trigger('chosen:updated');

                }
            }
        },
        error: function (xhr, status) {
            modelAlert("Error ");
            $('[id$=ddlCategoryn]').attr("disabled", false);
        }
    });
}

function BindVendor() {
    $.ajax({
        type: "POST",
        timeout: 120000,
        url: "StoreItemsRate.aspx/BindAllVendor",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.d == "") {
                $('[id$=ddlnVendor]').html('');
                $('[id$=ddlnVendor]').append(jQuery("<option></option>").val('0').html(" "));
                $('[id$=ddlnVendor]').trigger('chosen:updated');
            }
            else {
                $('[id$=ddlnVendor]').html('');
                $('[id$=ddlnVendor]').trigger('chosen:updated');
                $('[id$=ddlnVendor]').append(jQuery("<option></option>").val("0").html("Select"));
                Subcat = jQuery.parseJSON(data.d);
                if (Subcat.length == 0) {
                    $('[id$=ddlnVendor]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {

                    for (i = 0; i < Subcat.length; i++) {
                        $('[id$=ddlnVendor]').append(jQuery("<option></option>").val(Subcat[i].ID).html(Subcat[i].LedgerName));
                    }
                    $('[id$=ddlnVendor]').chosen();
                    $('[id$=ddlnVendor]').trigger('chosen:updated');
                }
            }
        },
        error: function (xhr, status) {
            modelAlert("Error ");
            $('[id$=ddlnVendor]').attr("disabled", false);
        }
    });

    return false;

}
function BindAllManufacturer() {
    $.ajax({
        type: "POST",
        timeout: 120000,
        url: "StoreItemsRate.aspx/BindManufacturer",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.d == "") {
                $('[id$=ddlManufacturer]').html('');
                $('[id$=ddlManufacturer]').append(jQuery("<option></option>").val('0').html(" "));
                $('[id$=ddlManufacturer]').trigger('chosen:updated');
            }
            else {
                $('[id$=ddlManufacturer]').html('');
                $('[id$=ddlManufacturer]').trigger('chosen:updated');
                $('[id$=ddlManufacturer]').append(jQuery("<option></option>").val("0").html("Select"));
                Subcat = jQuery.parseJSON(data.d);
                if (Subcat.length == 0) {
                    $('[id$=ddlManufacturer]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < Subcat.length; i++) {
                        $('[id$=ddlManufacturer]').append(jQuery("<option></option>").val(Subcat[i].ManufactureID).html(Subcat[i].Name));
                    }
                    $('[id$=ddlManufacturer]').chosen();
                    $('[id$=ddlManufacturer]').trigger('chosen:updated');
                }
            }
        },
        error: function (xhr, status) {
            modelAlert("Error ");
            $('[id$=ddlManufacturer]').attr("disabled", false);
        }
    });

    return false;

}

var SearchSupplierQuotation = function () {
    BindPurchaseUnit();
    var ItemGroup = "";
    var Vendor = "";
    Vendor = $('[id$=ddlnVendor] option:selected ').val();
    if ($('[id$=lblItemName]').val() != "") {
        ItemGroup = $('[id$=lblItemName]').val();
    }
    else {
        ItemGroup = "0";
    }
    if (Vendor == "0" && ItemGroup == "0") {
        $('#divSupplierQuotation').html('');
        $('[id$=DivQuotationDetails]').css('display', 'none');
        return false;
    }
    if ($('[id$=BtnNewBtn]').val() == 'Search') {
        $('[id$=DivQuotationDetails]').css('display', 'none');
        return false;
    }
    else {
        if (Vendor == "Select" && ItemGroup == "0") {
            Vendor = 'Select';
        }
        $.ajax({
            type: "POST",
            timeout: 120000,
            url: "StoreItemsRate.aspx/addItem",
            data: '{ Vendor: "' + Vendor + '",ItemGroup:"' + ItemGroup + '"}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (data) {
                prescribedMedicineStockDetails = JSON.parse(data.d);
                if (prescribedMedicineStockDetails.length > 0) {
                    var output = $('#templateQuotationsDetails').parseTemplate(prescribedMedicineStockDetails);
                    if (output != "" && output != null) {
                        $('#divSupplierQuotation').html(output).customFixedHeader();
                        $('[id$=DivQuotationDetails]').css('display', 'block');
                        $('[id$=DivItemPricingDetails]').css('display', 'none');
                    }
                    else {
                        $('[id$=DivQuotationDetails]').css('display', 'none');
                    }
                }
                else {
                    $('#divSupplierQuotation').html('');
                    $('[id$=DivQuotationDetails]').css('display', 'none');
                    $('[id$=BtnNewBtn]').text('New');
                }
            },
            error: function (xhr, status) {
                modelAlert("Error ");
            }
        });
    }
}

function ShowDivItemPricing() {
    if ($('[id$=BtnNewBtn]').val() == 'New') {
        $('[id$=BtnNewBtn]').val('Search');
        $('[id$=DivItemPricingDetails]').css('display', 'block');
        $('[id$=divItemList]').css('display', 'block');
        $('[id$=divBtnsave]').css('display', 'block');
        $('[id$=DivQuotationDetails]').css('display', 'none');
        //$('[id$=btnAddItems]').val('Add');
        $('#<%=lblMsg.ClientID %>').text('');
        $('#<%=txtRate.ClientID %>').val('');
        $('#<%=txtRemarks.ClientID %>').val('');
        $('#<%=txtDiscAmt.ClientID %>').val('');
        $('#<%=txtDiscPer.ClientID %>').val('');
        $('#<%=txtMRP.ClientID %>').val('');
        $('#<%=txtDeal1.ClientID %>').val('');
        $('#<%=txtDeal2.ClientID %>').val('');
        // GST Changes
        $('#<%=ddlTAX1.ClientID %> option:selected').text("IGST");
        $('#<%=txtIGSTPer.ClientID %>').val('');
        $('#<%=txtCGSTPer.ClientID %>').val('');
        $('#<%=txtSGSTPer.ClientID %>').val('');
        $('#<%=txtHSNCode.ClientID %>').val('');
        $('[id$=btnAddItems]').val('Add');
        return false;
    }
    else if ($('[id$=BtnNewBtn]').val() == 'Search') {
        BindVendor();
        //UpdateItemList()
        BindCategory();
        $('[id$=ddlSubCategory]').html('');
        $('[id$=ddlSubCategory]').append(jQuery("<option></option>").val('0').html(" "));
        $('[id$=ddlSubCategory]').trigger('chosen:updated');
        $('[id$=BtnNewBtn]').val('New');
        $('[id$=DivItemPricingDetails]').css('display', 'none');
        $('[id$=divItemList]').css('display', 'none');
        $('[id$=divBtnsave]').css('display', 'none');
        if ($('[id$=divSupplierQuotation]').html() != '') {
            $('[id$=DivQuotationDetails]').css('display', 'block');
        }
        return false;
    }
    else {
        return false;
    }
}

function SetSupplier(ctr) {
    modelConfirmation('Set Supplier Confirmation ?', 'Are you sure want to set this supplier', 'Yes', 'Cancel', function (response) {
        if (response == true) {
            var ItemID = $(ctr).closest('tr').find('[id$=tdItemId]').text();
            var VendorLedNo = $(ctr).closest('tr').find('[id$=tdVendorLedgerNo]').text();
            var StoreRateID = $(ctr).closest('tr').find('[id$=tdStorerateId]').text();
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "StoreItemsRate.aspx/Setvendor",
                data: '{ StoreRateID: "' + StoreRateID + '",VendorLedNo:"' + VendorLedNo + '",ItemID:"' + ItemID + '"}',
                contentType: "application/json; charset=utf-8",
                ashync: false,
                dataType: "json",
                success: function (data) {
                    prescribedMedicineStockDetails = JSON.parse(data.d);
                    if (prescribedMedicineStockDetails == true) {
                        SearchSupplierQuotation();
                        return false;
                    }
                    else {
                        return false;
                    }
                },
                error: function (xhr, status) {
                    modelAlert("Error ");
                    return false;
                }
            });
        }
        else
            return false;
    });
    return false;
}

function EditSupplier(ctr) {
    //ctr.disabled = true;
    // $('[id$=' + ctr.id + ']').text('Editing....');
    $('[id$=lblhdnid]').val('');
    $('[id$=btnAddItems]').val('Update');
    var rate = $(ctr).closest('tr').find('[id$=tdrate]').text();
    var DiscAmt = $(ctr).closest('tr').find('[id$=tddiscsamt]').text();
    var MRP = $(ctr).closest('tr').find('[id$=tdmrp]').text();
    var gstType = $(ctr).closest('tr').find('[id$=tdgsttype]').text();
    var fromdate = $(ctr).closest('tr').find('[id$=tdfromdate]').text();
    var Todate = $(ctr).closest('tr').find('[id$=tdtodate]').text();
    var IsActive = $(ctr).closest('tr').find('[id$=tdIsActive]').text();
    if (IsActive == 'false') {
        $('#<%=chkIsActive.ClientID%>').prop('checked', false);
    }
    if (IsActive == 'true') {
        $('#<%=chkIsActive.ClientID%>').prop('checked', true);
    }
    var ManufacturerName = $(ctr).closest('tr').find('[id$=tdManufacturer]').text();
    var VendorName = $(ctr).closest('tr').find('[id$=tdVendorName]').text();
    var ItemId = $(ctr).closest('tr').find('[id$=tdItemId]').text();
    var ItemName = $(ctr).closest('tr').find('[id$=tdItemName]').text();
    var StoreRateId = $(ctr).closest('tr').find('[id$=tdStorerateId]').text();
    $('[id$=lblhdnid]').val("" + ManufacturerName + "#" + VendorName + "#" + ItemId + "#" + ItemName + "#" + StoreRateId + "");
    $('[id$=ddlnVendor] option:selected').text(VendorName);
    $('[id$=ddlnVendor]').trigger('chosen:updated');
    if (ManufacturerName != "") {
        $('[id$=ddlManufacturer] option:selected').text(ManufacturerName);
        $('[id$=ddlManufacturer]').trigger('chosen:updated');
    }
    if (ManufacturerName == "") {
        var manufacturer = "Select";
        $('[id$=ddlManufacturer] option:selected').text(manufacturer);
        $('[id$=ddlManufacturer]').trigger('chosen:updated');
    }
    $('[id$=ucFromDate]').val(fromdate);
    $('[id$=ucToDate]').val(Todate);
    $('#<%=txtRate.ClientID %>').val(rate);
    $('#<%=txtMRP.ClientID %>').val(MRP);
    $('#<%=txtDiscAmt.ClientID %>').val(DiscAmt);
    $('#<%=ddlTAX1.ClientID%> option:selected').text(gstType);
    $('#lblGSTType').text(gstType);
    if (gstType == "IGST") {
        $('#txtIGSTPer').removeAttr('disabled');
        $('#txtCGSTPer,#txtSGSTPer').attr('disabled', 'disabled');
    }
    else {
        $('#txtIGSTPer').attr('disabled', 'disabled');
        $('#txtCGSTPer,#txtSGSTPer').removeAttr('disabled');
    }
    $('#txtIGSTPer').val($(ctr).closest('tr').find('[id$=tdIGST]').text());
    $('#txtCGSTPer').val($(ctr).closest('tr').find('[id$=tdCGST]').text());
    $('#txtSGSTPer').val($(ctr).closest('tr').find('[id$=tdSGST]').text());
    $('#txtHSNCode').val($(ctr).closest('tr').find('[id$=tdHSNCode]').text());
    $IsDeal = $(ctr).closest('tr').find('[id$=tdIsDeal]').text();
    if ($IsDeal != '') {
        $('#txtDeal1').val($IsDeal.split('+')[0]);
        $('#txtDeal2').val($IsDeal.split('+')[1]);
    }

    $('[id$=DivItemPricingDetails]').css('display', '');
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
        if ($('[id$=ddlnVendor]').val() == "Select") {
            $('#<%=lblMsg.ClientID %>').text('Please Select Supplier');
            $('[id$=ddlnVendor]').focus();
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
        else {
            return true;
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
        $onInit();
        $('#txtSearchItem').val('');
    });
    $onInit = function () {
        $('#txtSearchItem').autocomplete({
            source: function (request, response) {
                if ($('[id$=ddlCategoryn]').val() == null || $('[id$=ddlCategoryn]').val() == "0") {
                    modelAlert('Please Select Category.');
                    $('#txtSearchItem').val('');
                    return false;
                }
                $CategoryId = $('[id$=ddlCategoryn]').val();
                if ($('[id$=ddlSubCategory]').val() != null) {
                    $SubCategory = $('[id$=ddlSubCategory] option:selected').val();
                    if ($SubCategory == "All")
                        $SubCategory = "0";
                }
                else {
                    $SubCategory = "0";
                }
                $bindItems({ CategoryId: $CategoryId, SubCategory: $SubCategory, PreFix: request.term }, function (responseItems) {
                    response(responseItems)
                });
            },
            select: function (e, i) {
                $validateInvestigation(i, function () { });
            },
            close: function (el) {
                el.target.value = '';
            },
            minLength: 2
        });
    };
    $bindItems = function (data, callback) {
        serverCall('StoreItemsRate.aspx/BindItemList', data, function (response) {
            if (response == "No Item Found") {
                modelAlert(response);
                $('#txtSearchItem').val('');
                return false;
            }
            if (response.d == "1") {
                modelAlert('Please Select Category');
                $('#txtSearchItem').val('');
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
        if (ctr.item.val.trim() != "") {
            var strItem = ctr.item.val;
            $('[id$=lblItemName]').text(ctr.item.label);
            $('[id$=lblItemName]').val(strItem);
            SearchSupplierQuotation();
        }
    };

    $(document).ready(function () {
        $('#btnUpload').click(function () {
            if ($('#FuFileUpload').val() == '') {
                modelAlert('Please Select File');
                return false;
            }
            var fileUpload = $("#FuFileUpload").get(0);
            var files = fileUpload.files;
            var data = new FormData();
            for (var i = 0; i < files.length; i++) {
                data.append(files[i].name, files[i]);
            }
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: 'Services/FileUploadHandler.ashx',
                data: data,
                contentType: false,
                processData: false,
                success: function (result) {
                    modelAlert(result);
                    $('[id$=FuFileUpload]').val('');
                },
                error: function (err) {
                    modelAlert(err.statusText)
                }
            });
        });
    });
    </script>
     <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
         <asp:Label ID="lblhdnid" runat="server" style="display:none;"  ClientIDMode="Static"></asp:Label>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Set Items Pricing</b>
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
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Supplier
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                   <select id="ddlnVendor" onchange="return SearchSupplierQuotation();">
                                   </select>
                                   <%-- <asp:DropDownList ID="ddlVendor" Visible="false" runat="server" onchange=" return SearchSupplierQuotation();" TabIndex="1" CssClass="searchable">
                                    </asp:DropDownList>--%>
                                </div>
                                <div class="col-md-1">
                                    <input type="image"  src="../../Images/AddNew.png" id="btnaddNewVen" onclick="wopen('../Store/VendorDetail.aspx?Mode=1', 'popup1', 1200, 490); return false;" />
                                    <asp:Button ID="Button1" Text="Add New" runat="server" CssClass="ItDoseButton" Style="display: none;" />
                                </div>
                                <div class="col-md-3">
                                    <input type="image" id="btnReload" src="../../Images/refresh.png" onclick="return BindVendor();" />
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Manufacturer
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlManufacturer" tabindex="1">
                                    </select>
                                </div>
                                <div class="col-md-1">
                                    <input type="image" src="../../Images/AddNew.png" id="BtnAddnewMan" value="Add New" onclick="wopen('../Store/ManufactureMaster.aspx?Mode=1', 'popup1', 1200, 490); return false;" />
                                     </div>
                                <div class="col-md-3">
                                    <input type="image" src="../../Images/refresh.png"  onclick="return BindAllManufacturer();"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Category
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                  <select id="ddlCategoryn" onchange="return BindItemList();">

                                  </select>
                                </div>
                                 <div class="col-md-4"></div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Sub&nbsp;Category
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlSubCategory" onchange="return BindItemOnSubcategory();">

                                    </select>
                                </div>
                               
                            </div>
                             <div class="row">
                                  <div class="col-md-3">
                                    <label class="pull-left">
                                      Search  Items
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select  id="ddlItems" style="display:none;" onchange="return SearchSupplierQuotation();">
                                    </select>
                                   <input type="text" id="txtSearchItem" tabindex="1" title="Enter Search text" />
                                </div>
                                <div class="col-md-1">
                                    <input id="btnAddNewItem" src="../../Images/AddNew.png" onclick="wopen('../Store/ItemMaster.aspx?Mode=1', 'popup1', 1200, 490); return false;" type="image" />
                                </div>
                                 <div style="display:none" class="col-md-1">
                                     <input type="image" id="BtnRefreshItm" src="../../Images/refresh.png" onclick="return UpdateItemList()" />
                                 </div>
                                    <div class="col-md-3"></div>
                                    <div class="col-md-3">
                                    <label class="pull-left">
                                    Item Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <label id="lblItemName" title="Enter Search Text"></label>
                                </div>
                                </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-12"></div>
                                <div class="col-md-2">
                                    <input type="button" id="BtnNewBtn" onclick="return ShowDivItemPricing();" value="New" />
                                </div>
                                <div class="col-md-10"></div>
                            </div>
                        </div>
                    </div>
                    <div>
                    </div>
                </div>
            </ContentTemplate>
        </Ajax:UpdatePanel>
            <div id="DivQuotationDetails" style="display:none;" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Quotation Details
            </div>
            <div style="text-align: center;">
                <div id="divSupplierQuotation" style="height:220px;overflow-y:scroll" class="col-md-24">
                </div>
            </div>
           </div>
        <div class="POuter_Box_Inventory" id="DivItemPricingDetails" style="display:none;">
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
                    </div>
                    <div class="row">
                     
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
                          <div class="col-md-3">
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
                    <div class="row">
                       <div class="col-md-3">
                       </div>
                        <div class="col-md-5">
                            <label class="pull-left">
                                 <asp:CheckBox ID="chkIsActive" runat="server" Checked="true"  Text="Active This Quotation" />
                                </label>
                            </div>
                         <div class="col-md-3" style="display:none;">
                            <label class="pull-left">
                               Document Upload
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5" style="display:none;">
                             <input type="file" id="FuFileUpload" />
                        </div>
                         <div class="col-md-3" style="display:none;">
                             <input type="button" id="btnUpload" value="Upload" style="display:none;" />
                       </div>
                        <div class="col-md-3" >
                            <label class="pull-left">
                                Tax Calculated On
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6" >
                            <asp:RadioButtonList ID="rblTaxCal" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Rate" Value="Rate"></asp:ListItem>
                                <asp:ListItem Text="Rate Inclusive" Value="RateInclusive"></asp:ListItem>
                                <asp:ListItem Text="RateAD" Value="RateAD" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row"></div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="width: 123px; text-align: center;">
                    <td colspan="6">
                           <input type="button" id="btnAddItems" onclick="return AddItems();" value="Add" />
                    </td>
                </tr>
                
            </table>
        </div>
      
        <div class="POuter_Box_Inventory" id="divItemList" style="display:none;">
            <div class="Purchaseheader">
                Item List
            </div>
            <div id="DivItemDetails" style="height:270px;width:100%;overflow-x:scroll;">
                
            </div>
        </div>
        <div id="divBtnsave" class="POuter_Box_Inventory" style="text-align: center;display:none;">

           <%-- <asp:Button ID="btnSave" runat="server" Enabled="false" CssClass="ItDoseButton" Text="Save"
                OnClick="btnSave_Click" OnClientClick="RestrictDoubleEntry(this);" />--%>
            <input type="button" id="btnSave" value="Save"  disabled="disabled" onclick="return SaveAllItems(this);" />
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


    <script id="templateQuotationsDetails" type="text/html">   
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="medicineDetail" style="width:100%;border-collapse:collapse;">                                  
        <tr id="MedHeader">
            <%--<th class="GridViewHeaderStyle" scope="col" style="width:4%;"></th>--%>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Supplier</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Manufacturer</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Rate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Discount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Tax</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">GST Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Deal</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">CostPrice</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">MRP</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Profit</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:70px;">IsActive</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">FromDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">ToDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">EntryDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">SetVendor</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Edit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center;display:none">ItemID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center;display:none">VendorLedgerNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center;display:none">StoreRateID</th>
       </tr>
       <#       
              var dataLength=prescribedMedicineStockDetails.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var k=0;k<dataLength;k++)
        {
        objRow = prescribedMedicineStockDetails[k];      
            #>        
                  <tr data='<#= JSON.stringify(prescribedMedicineStockDetails[k])#>' id="<#=k+1#>" 
                             <#
                         if(prescribedMedicineStockDetails[k].AppStatus =="False")
                          {#>   style="background-color:''" <#} 
                            else 
                             {
                               if(prescribedMedicineStockDetails[k].AppStatus =="True")
                                 {#> style="background-color:#3CB371"  <#} 
                              } 
                             #>
                            >                            
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=k+1#></td> 
                    <td class="GridViewLabItemStyle" id="tdVendorName" style="width:60px;"><#=objRow.VendorName#></td>
                    <td class="GridViewLabItemStyle" id="tdManufacturer" style="width:80px;text-align:center"><#=objRow.Name#></td>
                      <td class="GridViewLabItemStyle" id="tdItemName" style="width:70px;text-align:center"><#=objRow.ItemName#></td>   
                    <td class="GridViewLabItemStyle" id="tdrate" style="width:70px;text-align:center"><#=objRow.Rate#></td>                 
                    <td class="GridViewLabItemStyle" id="tddiscsamt" style="width:60px;text-align:right"><#=objRow.DiscAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdtaxamt" style="width:60px;text-align:right"><#=objRow.TaxAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdgsttype" style="width:60px;text-align:right"><#=objRow.GSTType#></td>
                    <td class="GridViewLabItemStyle" id="tdisdeal" style="width:60px; text-align:center"><#=objRow.IsDeal#></td>
                    <td class="GridViewLabItemStyle" id="tdnetamt" style="width:80px;"><#=objRow.NetAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdmrp" style="width:70px;text-align:center"><#=objRow.MRP#></td>
                    <td class="GridViewLabItemStyle" id="tdProfit" style="width:70px;text-align:center"><#=objRow.Profit#></td>
                    <td class="GridViewLabItemStyle" id="tdIsActive" style="width:70px;text-align:center"><#=objRow.AppStatus#></td>
                    <td class="GridViewLabItemStyle" id="tdfromdate" style="width:80px;text-align:center"><#=objRow.FromDate#></td>                 
                    <td class="GridViewLabItemStyle" id="tdtodate" style="width:80px;text-align:right"><#=objRow.ToDate#></td>
                    <td class="GridViewLabItemStyle" id="tdentrydate" style="width:60px;text-align:right"><#=objRow.EntryDate#></td>
                      <td class="GridViewLabItemStyle" id="tdsetvendor" style="width:60px;">
                        <button type="button" id="btnSetsupplier"   onclick="return SetSupplier(this);" style="width:50px;background-color:#018EFF;font-size: 11px;margin-bottom:3px;margin-top:3px;" class="ItDoseButton">Set</button>
                      </td>
                       <td class="GridViewLabItemStyle" id="tdEdit" style="width:60px;">
                        <button type="button" id="btnedtsupplier" onclick="return EditSupplier(this);"  style="width:50px;background-color:#018EFF;font-size: 11px;margin-bottom:3px;margin-top:3px;" class="ItDoseButton">Edit</button>
                      </td>
                        <td class="GridViewLabItemStyle" id="tdItemId" style="width:30px;text-align:center;display:none"><#=objRow.ItemID#></td>
                        <td class="GridViewLabItemStyle" id="tdVendorLedgerNo" style="width:30px;text-align:center;display:none"><#=objRow.VendorLedgerNo#></td>
                        <td class="GridViewLabItemStyle" id="tdStorerateId" style="width:30px;text-align:center;display:none"><#=objRow.StoreRateID#></td>
                      <td class="GridViewLabItemStyle" id="tdCGST" style="width:30px;text-align:center;display:none"><#=objRow.CGSTPercent#></td>
                      <td class="GridViewLabItemStyle" id="tdSGST" style="width:30px;text-align:center;display:none"><#=objRow.SGSTPercent#></td>
                      <td class="GridViewLabItemStyle" id="tdIGST" style="width:30px;text-align:center;display:none"><#=objRow.IGSTPercent#></td>
                      <td class="GridViewLabItemStyle" id="tdHSNCode" style="width:30px;text-align:center;display:none"><#=objRow.HSNCode#></td>
                      <td class="GridViewLabItemStyle" id="tdIsDeal" style="width:30px;text-align:center;display:none"><#=objRow.IsDeal#></td>
                 </tr>
            <#}#>                      
     </table>     
    </script>

     <script id="tb_ItemDetails" type="text/html">
    <table  id="tableitemdetails" cellspacing="0" class="yui" style="width:100%;border-collapse:collapse;">
        <thead>
        <tr class="tblTitle" id="Header">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Supplier Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Manufacturer</th>           
            <th class="GridViewHeaderStyle" scope="col" >Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Unit</th>          
            <th class="GridViewHeaderStyle" scope="col" >From Date</th>         
            <th class="GridViewHeaderStyle" scope="col" >To Date</th>
            <th class="GridViewHeaderStyle" scope="col" >MRP</th>
            <th class="GridViewHeaderStyle" scope="col" >Rate</th>          
            <th class="GridViewHeaderStyle" scope="col" >Disc.Amt.</th>         
            <th class="GridViewHeaderStyle" scope="col" >Disc.Per.</th>
            <th class="GridViewHeaderStyle" scope="col" >Tax(%)</th>
            <th class="GridViewHeaderStyle" scope="col" >GST Type</th>          
            <th class="GridViewHeaderStyle" scope="col" >IGST(%)</th>         
            <th class="GridViewHeaderStyle" scope="col" >CGST(%)</th>
            <th class="GridViewHeaderStyle" scope="col" >SGST(%)</th>
            <th class="GridViewHeaderStyle" scope="col" >HSNCode</th>          
            <th class="GridViewHeaderStyle" scope="col" >Tax Amt.</th>         
            <th class="GridViewHeaderStyle" scope="col" >Is Deal</th>
            <th class="GridViewHeaderStyle" scope="col" >Net Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" >IsActive</th>
            <th class="GridViewHeaderStyle" scope="col" >Remove</th>
        </tr>
            </thead>
        <tbody>
        <#     
              var dataLength=ItemDetails.length;
                var objRow;
       for(var j=0;j<dataLength;j++)
        {
        objRow = ItemDetails[j];
        #>
                        <tr data='<#= JSON.stringify(ItemDetails[j])#>' id="<#=j+1#>" >
                        <td class="GridViewLabItemStyle" id="tdIndex"  style="width:30px;"> <#=j+1#></td>  
                        <td class="GridViewLabItemStyle" id="tdSuppName" ><#=objRow.VendorName#></td>
                        <td class="GridViewLabItemStyle" id="tdmanufacturer" ><#=objRow.Manufacturer#></td>                       
                        <td class="GridViewLabItemStyle" id="TdItemname" ><#=objRow.ItemName#></td>                      
                        <td class="GridViewLabItemStyle" id="Tdunit" ><#=objRow.Unit#></td>                     
                        <td class="GridViewLabItemStyle" id="tdFromDate" ><#=objRow.FromDate#></td>                    
                        <td class="GridViewLabItemStyle" id="tdToDatenew" ><#=objRow.ToDate#></td>
                        <td class="GridViewLabItemStyle" id="TDMrp" ><#=objRow.MRP#></td>
                        <td class="GridViewLabItemStyle" id="tdnewrate" ><#=objRow.Rate#></td>                       
                        <td class="GridViewLabItemStyle" id="tddiscamt" ><#=objRow.DiscAmt#></td>                      
                        <td class="GridViewLabItemStyle" id="tdDiscPr" ><#=objRow.DiscPer#></td>                     
                        <td class="GridViewLabItemStyle" id="tdTotaltaxper" ><#=objRow.TotalTaxPer#></td>                    
                        <td class="GridViewLabItemStyle" id="tdGsttype" ><#=objRow.GSTType#></td>
                        <td class="GridViewLabItemStyle" id="tdIgstPer" ><#=objRow.IGSTPercent#></td>
                        <td class="GridViewLabItemStyle" id="tdCgstPer" ><#=objRow.CGSTPercent#></td>                       
                        <td class="GridViewLabItemStyle" id="Tdsgst" ><#=objRow.SGSTPercent#></td>                      
                        <td class="GridViewLabItemStyle" id="tdhsncode" ><#=objRow.HSNCode#></td>                     
                        <td class="GridViewLabItemStyle" id="tdtaxamount" ><#=objRow.TaxAmt#></td>                    
                        <td class="GridViewLabItemStyle" id="tddeal" ><#=objRow.Deal#></td>
                        <td class="GridViewLabItemStyle" id="tdnetamount" ><#=objRow.NetAmt#></td>
                        <td class="GridViewLabItemStyle" id="td1" >
                             <#
                          if(ItemDetails[j].IsActive =="0")
                          {#>   False <#} 
                            else 
                             {
                               if(ItemDetails[j].IsActive =="1")
                                 {#> True <#} 
                              } 
                             #>
                        </td>
                        <td class="GridViewLabItemStyle" id="tddelete" style="text-align:center" >
                            <input type="image" src="../../Images/Delete.gif" onclick="return RemoveRow(this);" />
                        </td>                       
                       </tr>            
        <#}        
        #>
            </tbody>      
     </table> 
   </script>

</asp:Content>

