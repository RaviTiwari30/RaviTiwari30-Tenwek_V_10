<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPDServicesBilling.aspx.cs" Inherits="Design_IPD_IPDServicesBilling" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
      <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />
     <script type="text/javascript">
         $(function () {
             shortcut.add('Alt+S', function () {
                 var btnSave = $('#btnSave');
                 if (btnSave.length > 0) {
                     if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                         Save();
                     }
                 }
             }, addShortCutOptions);
             bindAdmissionDoctor(function () {
                 bindHashCode();
                 BindPatientDetail();
                 LoadCategory();
                 LoadSubCategory();
             });
            // $('.textbox-text').attr('tabindex', '1');
             $('.textbox-text').bind("keyup", function (e) {
                 AddInvestigation(this, e);
             });
         });
         $('#cmbItem').next().find('input').focus();
         $('#txtQuantity').removeAttr('tabIndex').attr('tabIndex', '2');
         var bindAdmissionDoctor = function (callback) {
             var $ddlDoctor = $('#ddlDoctor');
             serverCall('Services/IPDAdmission.asmx/bindAdmissionDoctor', { defaultvalue: {} }, function (response) {
                 $ddlDoctor.bindDropDown({ data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                 callback($ddlDoctor.val());
             });
         }
         function LoadCategory() {
             $('#ddlCategory option').remove();
             var Type = 6;
             $.ajax({
                 url: "../common/CommonService.asmx/BindCategory",
                 data: '{Type:"' + Type + '"}',
                 type: "POST",
                 async: false,
                 dataType: "json",
                 contentType: "application/json; charset=utf-8",
                 success: function (mydata) {
                     var data = jQuery.parseJSON(mydata.d);
                     $("#ddlCategory").empty().append('<option selected="selected" value="0">ALL</option>');
                     for (var i = 0; i < data.length; i++) {
                         $('#ddlCategory').append($('<option/>').val(data[i].CategoryID).html(data[i].Name).attr('configID', data[i].ConfigID));
                     }
                 }
             });
         }
         function LoadSubCategory() {
             $('#ddlSubCategory option').remove();
             var Type = 6;
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
                     $("#ddlSubCategory").empty().append('<option selected="selected" value="0">ALL</option>');
                     for (var i = 0; i < data.length; i++) {
                         $('#ddlSubCategory').append($("<option></option>").val(data[i].SubCategoryID).html(data[i].Name));
                     }

                 }
             });
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


             var value = $('input[name=rblTypeofPrescription]:checked').val();
             if (value == 0) {


                 if ($("#cmbItem").combogrid('getValue') == "") {
                     modelAlert('Please Select Item')
                     return false;
                 }
                 $("#btnAddInv").attr('disabled', 'disabled');
                 $("#spnErrorMsg").text('');
                 if ($("#cmbItem").combogrid('getValue') === null || $("#cmbItem").combogrid('getValue') === undefined) {
                     modelAlert('Please Select Item', function () {
                         $("#btnAddInv").removeAttr('disabled');
                         return false;
                     });
                 }
                 if ($('#txtQuantity').val() == '0' || $('#txtQuantity').val() == '')
                 {
                     modelAlert('Please Enter the quantity');
                     $('#txtQuantity').focus();
                     return false;
                 }
                 var ItemID = $("#cmbItem").combogrid('getValue').split('#')[0];
                 var conDup = 0;
                 var UserName = "";
                 var Date = "";
                 var RowColour = "";
                 alreadyPrescribeItem({ PatientID: $.trim($('#spnPatientID').text()), ItemID: ItemID }, function (response) {
                     if (response) {
                         if (CheckDuplicateItem(ItemID)) {
                             modelAlert('Selected Item Already Added');
                             conDup = 1;
                             $("#btnAddInv").removeAttr('disabled');
                             $('#cmbItem').combogrid('reset');
                             $("#cmbItem").combogrid('clear');
                             $('#cmbItem').next().find('input').focus();
                             return;
                         }
                         if (conDup == "1") {
                             modelAlert('Selected Item Already Added');
                             return;
                         }
                         var TypeID = $("#cmbItem").combogrid('getValue').split('#')[11].trim();
                         var ItemName = $("#cmbItem").combogrid('getText');
                         if ($("#cmbItem").combogrid('getValue').split('#')[2].trim() != "") {
                             ItemName = $("#cmbItem").combogrid('getValue').split('#')[2].trim();
                         }
                         var ItemCode = $("#cmbItem").combogrid('getValue').split('#')[3].trim();
                         var ConfigRelation = $("#cmbItem").combogrid('getValue').split('#')[13].trim();
                         var SubCategoryID = $("#cmbItem").combogrid('getValue').split('#')[12].trim();
                         var Disc = 0;
                         var CoPayPercent = 0;
                         var RateEditable = $("#cmbItem").combogrid('getValue').split('#')[5].trim();
                         var Payable = '';
                         var GSTDetails = $("#cmbItem").combogrid('getValue').split('#')[6].trim();
                         var Rate, ScheduleChargeID, Quantity, Days = 0, RateListID;
                         if (ConfigRelation != 3)
                             Quantity = $('#txtQuantity').val();
                         else
                             Quantity = "1";

                     if (Quantity == "") {
                         modelAlert("Please Enter Quantity");
                         $('#txtQuantity').focus();
                         return false;
                     }
                     var TID = $("#spnTransactionID").text();
                     RateListID = $("#cmbItem").combogrid('getValue').split('#')[4].trim();
                     Rate = precise_round($("#cmbItem").combogrid('getValue').split('#')[1].trim(),2);
                     $.ajax({
                         url: "Services/IPDLabPrescription.asmx/GetDiscount",
                         data: '{PanelID:"' + $("#spnReferenceCodeIPD").text() + '",ItemID:"' + ItemID + '",patientTypeID:"' + $('#spnPatientTypeID').text() + '",MembershipNo:"' + $("#spnMembershipNo").text() + '"}',
                         type: "POST",
                         async: false,
                         dataType: "json",
                         contentType: "application/json; charset=utf-8",
                         success: function (mydata) {
                             var data = jQuery.parseJSON(mydata.d);
                             if ('<%=Resources.Resource.IsmembershipInIPD%>' == "1" && $("#spnReferenceCodeIPD").text() == '<%=Resources.Resource.DefaultPanelID%>' && $('#spnMembershipNo').text() != "") {
                                if (data != 0) {
                                    Disc = data;
                                }
                                Payable = "";
                                CoPayPercent = 0;
                            }
                            else {
                                Disc = data[0].IPDPanelDiscPercent;
                                if (data[0].IsPayble == "1")
                                    Payable = 'checked="checked"';
                                CoPayPercent = data[0].IPDCoPayPercent;
                            }
                        }
                    });

                    $.ajax({
                        url: "Services/IPDLabPrescription.asmx/CalculateDays",
                        data: '{StartDate:"' + $('#ucDate').val() + '",EndDate:"' + $('#toDate').val() + '"}',
                        type: "POST",
                        async: false,
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        success: function (mydata) {
                            Days = mydata.d;
                        }
                    });
                    if (ConfigRelation == "14") {
                        Days = 0;
                    }
                    var ratestatus = "";
                    if (RateEditable == 1 || Rate != 0)
                        ratestatus = 'disabled="disabled"';
                    var ratestatus = '<%=Util.GetInt(ViewState["IsRate"])%>' == '0' ? 'disabled="disabled"' : '';
                    var SelectedDate = $('#ucDate').val();
                    $('#tbSelected').css('display', 'block');
                    var IsDiscount = '<%=Util.GetInt(ViewState["IsDiscount"])%>' == '0' ? 'disabled="disabled"' : '';
                    var NetAmount = ((Rate * Quantity) - (((Rate * Quantity) * Disc) / 100));
                    for (var i = 0; i <= Days ; i++) {
                        $('#tbSelected').append('<tr><td class="GridViewLabItemStyle" style="width:70px" ><span id="ItemCode">' + ItemCode +
                                                '</span></td><td class="GridViewLabItemStyle" style="width:120px;"><span id="ItemName">' + ItemName +
                                                '</span><span  style="display:none" id="spnInvestigationID" >' + TypeID +
                                                '</span><span  style="display:none" id="spnSubCategoryID" > ' + SubCategoryID + ' </span><span id="tditemID" style="display:none">' + ItemID +
                                                '</span><span id="tdConfigRelation" style="display:none">' + ConfigRelation +
                                                '</span><span id="spnRateListID" style="display:none"> ' + RateListID + '</span><span id="spnGSTDetails" style="display:none">'+ GSTDetails +'</span></td>' +
                                                '<td style="text-align:center"><input type="checkbox" disabled="disabled" id="chkPayable" ' + Payable + '  /></td>' +
                                                '<td class="GridViewLabItemStyle" style="width:100px" ><span id=spnDate>' + SelectedDate +
                                                '</span><span id="spnRateEditable" style="display:none">' + RateEditable + '</span><span id="spncopayment" style="display:none">' + CoPayPercent + '</span></td>' +
                                                '<td class="GridViewLabItemStyle" style="width:100px" ><input id="txtRemarks"  type="text" style="width:100px;" autocomplete="off" value="' + $('#txtRemarks').val() + '" /></td>' +
                                                '<td class="GridViewLabItemStyle" style="width:40px"><input id="txtRate" autocomplete="off"  type="text" class="ItDoseTextinputNum" style="width:100px;" ' + ratestatus + ' value=' + Rate +
                                                ' onkeyup="Rate(this);"  onkeypress="return checkNumeric(event,this);"/></td><td class="GridViewLabItemStyle" style="width:30px"><input onkeyup="Rate(this);" type="text" class="ItDoseTextinputNum"  onkeypress="return checkNumericDecimal(event,this);" id="spnQuantity" autocomplete="off" value=' + Quantity +
                                                ' </input></td><td class="GridViewLabItemStyle" style="width:40px"><input id="txtDiscountPer" class="ItDoseTextinputNum" type="text" autocomplete="off" onkeyup="Rate(this);" style="width:100px" class="ItDoseTextinputNum" ' + IsDiscount + ' value=' + Disc +
                                                ' /></td><td class="GridViewLabItemStyle" style="width:40px"><input id="txtAmount" class="ItDoseTextinputNum" type="text" autocomplete="off" style="width:100px" class="ItDoseTextinputNum" readonly="readonly" value=' + NetAmount +
                                                ' /></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');
                        $.ajax({
                            url: "Services/IPDLabPrescription.asmx/CalculateNextDay",
                            data: '{StartDate:"' + SelectedDate + '"}',
                            type: "POST",
                            async: false,
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            success: function (mydata) {
                                SelectedDate = "";
                                SelectedDate = mydata.d;
                            }
                        });
                    }
                    bindRate();
                    $('#divSave').show();
                    $("#btnAddInv").removeAttr('disabled');
                    $('#ItemOutput,#tbSelected').show();
                    $('#txtQuantity').val('1').attr("placeholder", "Enter Quantity");                    
                    $('#txtRemarks').val('');
                    $('#divTotalAmt').show();
                    $('#cmbItem').combogrid('reset');
                    $("#cmbItem").combogrid('clear');
                    $('#cmbItem').next().find('input').focus();
                    $('.textbox-text').focus();
                }
            });
         } else {

             if ($("#cmbItem").combogrid('getValue') == "") {
                 modelAlert('Please Select Item')
                 return false;
             }
             $("#btnAddInv").attr('disabled', 'disabled');
             $("#spnErrorMsg").text('');
             if ($("#cmbItem").combogrid('getValue') === null || $("#cmbItem").combogrid('getValue') === undefined) {
                 modelAlert('Please Select Item', function () {
                     $("#btnAddInv").removeAttr('disabled');
                     return false;
                 });
             }
             if (jQuery('#spnGender').text() == "Male" && $("#cmbItem").combogrid('getValue').split('#')[6] == "F") {
                 modelAlert('This Test Is Not For Male Patient');
                 return false;
             }
             if (jQuery('#spnGender').text() == "Female" && $("#cmbItem").combogrid('getValue').split('#')[6] == "M") {
                 modelAlert('This Test Is Not For Female Patient');
                 return false;
             }

             var ItemID = $("#cmbItem").combogrid('getValue').split('#')[0];
             var conDup = 0;
             var UserName = "";
             var Date = "";
             var RowColour = "";

             alreadyPrescribeOrderItem({ PatientID: $.trim($('#spnPatientID').text()), ItemID: ItemID }, function (response) {
                 if (response) {
                     if (CheckOrderDuplicateItem(ItemID)) {
                         modelAlert('Selected Item Already Added');
                         conDup = 1;
                         $("#btnAddInv").removeAttr('disabled');
                         $('#cmbItem').combogrid('reset');
                         $("#cmbItem").combogrid('clear');
                         $('#cmbItem').next().find('input').focus();
                         return;
                     }
                     if (conDup == "1") {
                         modelAlert('Selected Item Already Added');
                         return;
                     }
                     var ConfigRelation = $("#cmbItem").combogrid('getValue').split('#')[13].trim();
                     var ItemName = $("#cmbItem").combogrid('getText');
                     if ($("#cmbItem").combogrid('getValue').split('#')[2].trim() != "") {
                         ItemName = $("#cmbItem").combogrid('getValue').split('#')[2].trim();
                     }



                         var Rate, ScheduleChargeID, Quantity = "1", Days = 0, RateListID;


                         var TID = $("#spnTransactionID").text();
                         RateListID = $("#cmbItem").combogrid('getValue').split('#')[4].trim();
                         Rate = $("#cmbItem").combogrid('getValue').split('#')[1].trim();


                         var SelectedDate = $('#txtSelectDate').val();
                         var StartTime = $('#txtStartTime').val();
                         var txtRemainderName = "";//$("#ddlRemainderType option:selected").text();
                         var ddlRemainderType = "";// $("#ddlRemainderType").val();
                         var ddlTypeOfSchedular = $("#ddlTypeOfSchedular").val();

                         var ddlTypeOfSchedularText = $("#ddlTypeOfSchedular option:selected").text();


                         var ddlTypeofDuration = $("#ddlTypeofDuration").val();
                         var txtSelectDate = $("#txtSelectDate").val();
                         var txtStartTime = $("#txtStartTime").val();


                         var txtStopDate = txtSelectDate;
                         var txtStopTime = txtStartTime;

                         var txtRemarks = $("#txtRemarks").val();
                         var txtRepeatDuration = $("#txtRepeatDuration").val();

                         var ddlDoctor = $("#ddlDoctor").val();
                         var ddlDoctorName = $("#ddlDoctor option:selected").text();

                     //if (ddlRemainderType == "") {
                     //    modelAlert("Please Select Remainder type");
                     //    return false;
                     //}

                     if (txtStartTime == "") {
                         modelAlert("Please Select Start Time");
                         return false;
                     }
                     if (ConfigRelation != 3)
                         Quantity = $('#txtQuantity').val();
                     else
                         Quantity = "1";


                     if (Quantity == "") {
                         modelAlert("Please Enter Quantity");
                         $('#txtQuantity').focus();
                         return false;
                     }
					  var NoOfRepetitiontodo = $("#txtNoOfRepetition").val();

                     if (ddlTypeOfSchedular == 0) {
                         if (ddlTypeofDuration == "") {
                             modelAlert("Please Select Type of Duration");
                             return false;
                         }
                         if (txtRepeatDuration == "") {
                             modelAlert("Please Enter repeat Duration");
                             return false;
                         }

                             if (txtNoOfRepetition = "") {
                                 modelAlert("Please Enter Valid No Of Repetition.");
                                 return false;
                             }

                         }

                     $('#tbOrderSelected').css('display', 'block');

                     for (var i = 0; i <= Days ; i++) {
                         $('#tbOrderSelected tbody').append('<tr><td class="GridViewLabItemStyle" style="width:120px;"><span id="tdItemName">' + ItemName + '</span> </td>' +
                                                 '<td class="GridViewLabItemStyle" style="text-align:center; display:none"><span id="tditemID" >' + ItemID + '</span></td>' +
                                                 '<td class="GridViewLabItemStyle" style="width:120px;display:none"> <span id="tdtxtRemainderName" style="">' + txtRemainderName + '</span> </td>' +
                                                 '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdddlRemainderType">' + ddlRemainderType + '</span> </td>' +
                                                 '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdddlTypeOfSchedular" >' + ddlTypeOfSchedular + '</span> </td>' +
                                                   '<td class="GridViewLabItemStyle" style="width:120px; "> <span id="tdddlTypeOfSchedularText" >' + ddlTypeOfSchedularText + '</span> </td>' +



                                                '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdddlTypeofDuration" style="">' + ddlTypeofDuration + '</span> </td>' +
                                                 '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtSelectDate" style="">' + txtSelectDate + '</span> </td>' +
                                                 '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtStartTime" style="">' + txtStartTime + '</span> </td>' +

                                                      '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdtxtStopDate" style="">' + txtStopDate + '</span> </td>' +
                                                     '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdtxtStopTime" style="">' + txtStopTime + '</span> </td>' +


                                                     '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtRepeatDuration" style="">' + txtRepeatDuration + '</span> </td>' +

                                                     '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtNoOfRepetition" style="">' + NoOfRepetitiontodo + '</span> </td>' +


                                                     '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdddlDoctor" >' + ddlDoctor + '</span> </td>' +
                                                     '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdddlDoctorName" style="">' + ddlDoctorName + '</span> </td>' +

                                                 '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdspnQuantity">' + Quantity + '</span> </td>' +
                         '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtRemarks" style="">' + txtRemarks + '</span> </td>' +




                         '<td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');

                     }

                     $('#divSave').show();
                     $("#btnAddInv").removeAttr('disabled');
                     $('#tbSelected').hide();
                     $('#LabOutput,#tbOrderSelected').show();
                     $('#txtRemarks').val('');
                     //$('#divTotalAmt').show();
                     $('#cmbItem').combogrid('reset');
                     $("#cmbItem").combogrid('clear');
                     $('#cmbItem').next().find('input').focus();
                     $('.textbox-text').focus();



                 }
             });
         }
        }
         function Rate(rowid) {
             var DiscPer = $(rowid).closest('tr').find("#txtDiscountPer").val() == "" ? 0 : Number($(rowid).closest('tr').find("#txtDiscountPer").val());
             if (DiscPer > 100) {
                 modelAlert("Please Enter Valid Discount Per, Only 100 Per Discount Allowed.", function () { $(rowid).closest('tr').find("#txtDiscountPer").val(0) });
                 return;
             }
            var qty = $(rowid).closest('tr').find("#spnQuantity").val();
            var rate = $(rowid).closest('tr').find("#txtRate").val();
            var DigitsAfterDecimal = 2;
            var rateIndex = rate.indexOf(".");
            if (rateIndex > "0") {
                if (rate.length - (rate.indexOf(".") + 1) > DigitsAfterDecimal) {
                    modelAlert("Please Enter Valid Rate, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $(rowid).closest('tr').find("#txtRate").val($(rowid).closest('tr').find("#txtRate").val().substring(0, ($(rowid).closest('tr').find("#txtRate").val().length - 1)))
                }
            }
            if (isNaN(qty) || qty == "") {
                qty = 1;
                Number($(rowid).closest('tr').find("#spnQuantity").val(qty));
            }
            if (isNaN(rate) || rate == "") {
                rate = 0;
                Number($(rowid).closest('tr').find("#txtRate").val(0));
            }
            Number($(rowid).closest('tr').find("#txtAmount").val(parseFloat(qty * rate) - (parseFloat(qty * rate) * parseFloat(DiscPer / 100))));
            bindRate();
        }
        function RemoveRows(rowid) {
            if ($("#grdPaymentMode tr").length > 1) {
                return;
            }
            $(rowid).closest('tr').remove();
            if ($('#tbSelected tr:not(#ItemHeader)').length == 0) {
                $('#tbSelected').hide();
                $('#spnGrossAmount,#spnTotalDiscountAmount,#spnTotalNetAmount,#spnTotalRoundOff').text('');
                $('#divTotalAmt').hide();
                $('#divSave').hide();
            }
            bindRate();
            $("#spnErrorMsg").text('');


        }
        function bindRate() {
            var totalGAmount = 0;
            var totalDAmount = 0;
            var totalNAmount = 0;
            var totalNRoundoff = 0;
            $('#tbSelected tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "ItemHeader") {
                    var Grossamount = parseFloat(parseFloat($(this).closest('tr').find("#txtRate").val()) * parseFloat($(this).closest('tr').find("#spnQuantity").val()));
                    var DiscountAmount = parseFloat(((parseFloat(Grossamount) * parseFloat($(this).closest('tr').find("#txtDiscountPer").val()) / 100)));
                    var NetAmount = Grossamount - DiscountAmount;
                    totalGAmount = totalGAmount + Grossamount;
                    totalDAmount = totalDAmount + DiscountAmount;
                    totalNAmount = totalNAmount + NetAmount;
                    $('#spnGrossAmount').text(totalGAmount);
                    $('#spnTotalDiscountAmount').text(totalDAmount);
                    $('#spnTotalNetAmount').text(precise_round(totalNAmount, 2));
                    $('#spnTotalRoundOff').text(precise_round(Math.round(totalNAmount) - totalNAmount, 2))
                    if (totalGAmount >= 0) {
                        $('#divTotalAmt').show();
                        $('#divSave').show();
                    }
                    else {
                        $('#divTotalAmt').hide();
                        $('#divSave').hide();
                    }
                }
            });
            $('#lblTotalLabItemsCount').text('Count : ' + $('#tbSelected tr:not(#ItemHeader)').length);

            if (totalDAmount > 0) {
                $('.divDiscountReason').find('select').val('0');
                $('.divDiscountReason').show()
            }
            else {
                  
                $('.divDiscountReason').find('select').val('0');
                $('.divDiscountReason').hide();
            }

            


        }
        function CheckDuplicateItem(ItemID) {
            var count = 0;
            $('#tbSelected tr:not(#ItemHeader)').each(function () {
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
           
            //if (charCode == 13) {
            //    e.preventDefault();
            //    AddItem();
            //}
        }
        function CheckConfig() {
            LoadCategory();
            LoadSubCategory();
        }
        function bindHashCode() {
            jQuery('#txtHash').val('');
            jQuery.ajax({
                url: "../Common/CommonService.asmx/bindHashCode",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    jQuery('#txtHash').val(result.d);
                },
                error: function (xhr, status) {
                }
            });
        }
        function BindPatientDetail() {
            $('#spnPanelID,#spnIPD_CaseTypeID,#spnReferenceCodeIPD,#spnReferenceCodeIPD,#spnReferenceCodeIPD,#spnScheduleChargeID,#spnPatientType,#spnGender,#spnPatientTypeID,#spnMembershipNo').text('');
            jQuery.ajax({
                url: "Services/IPDLabPrescription.asmx/BindPatientDetails",
                data: '{TID:"' + $('#spnTransactionID').text() + '",PID:"' + $('#spnPatientID').text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = jQuery.parseJSON(result.d);
                    if (data != "") {
                        $('#spnPanelID').text(data[0].PanelID);
                        $('#spnPatientID').text(data[0].PatientID);
                        $('#ddlDoctor').val(data[0].DoctorID).chosen('destroy').chosen();
                        $('#spnIPD_CaseTypeID').text(data[0].IPDCaseTypeID);
                        $('#spnReferenceCodeIPD').text(data[0].ReferenceCode);
                        $('#spnScheduleChargeID').text(data[0].ScheduleChargeID);
                        $('#spnPatientType').text(data[0].PatientType);
                        $('#spnGender').text(data[0].Gender);
                        $('#spnPatientTypeID').text(data[0].PatientTypeID);
                        $('#spnMembershipNo').text(data[0].MemberShipCardNo);
                        $('#spnRoom_ID').text(data[0].RoomID);
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
     
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucDate').val() + '",DateTo:"' + $('#toDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        modelAlert('To date can not be less than from date!', function () {
                            $('#btnAdd').attr('disabled', 'disabled');
                        });

                    }
                    else {
                        $('#btnAdd').removeAttr('disabled');
                    }
                }
            });

        }
        //function AddInvestigation(sender, e) {
        //    var key = (e.keyCode ? e.keyCode : e.charCode);
        //    if (e.which == "")
        //        e.preventDefault();

        //    if ((e.which == 13)) {
        //        e.preventDefault();
        //        AddItem();
        //    }
        //    validatedot();
         //}
        
        function validatedot() {
            if (($("#txtQuantity").val().charAt(0) == ".")) {
                $("#txtQuantity").val('1');
                return false;
            }

            return true;
        }

        function HideToDateinPKG(){
            if ($('#ddlCategory option:selected').attr('configID') == "14"){
                $('.ToDate').hide();
            }
            else
                $('.ToDate').show();
        }
        function AddInvestigation(sender, evt) {
            if (evt.keyCode > 0) {
                keyCode = evt.keyCode;
            }
            else if (typeof (evt.charCode) != "undefined") {
                keyCode = evt.charCode;
            }
            if (keyCode == 13) {
              //  $('#divAddReferDoctor').closeModel();
                evt.preventDefault();
                AddItem();
                return false;
            }
        }
        </script>
    <form id="form1" runat="server">
    
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>IPD Services</b>
                <br/>
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" style="display:none"></asp:TextBox>
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnPanelID" style="display:none"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnRoom_ID" style="display:none"></span>
                <span id="spnIPD_CaseTypeID" style="display:none"></span>
                <span id="spnReferenceCodeIPD" style="display:none"></span>
                <span id="spnPatientType" style="display:none"></span>
                <span id="spnScheduleChargeID" style="display:none"></span>
                <span id="spnGender" style="display:none"></span>
                <span id="spnPatientTypeID" style="display:none"></span>
                <span id="spnMembershipNo" style="display:none"></span>
            </div>
              <div class="POuter_Box_Inventory" style="text-align: center;">

                <div class="row requistiontype" >
                    <div class="col-md-9"></div>
                    <div class="col-md-3">
                        <input type="radio" name="rblTypeofPrescription" id="rblIndent" value="0" onclick="RadioChange()" checked="checked" />
                        <label for="rblIndent" style="font-weight: bolder">Indent</label>
                    </div>
                    <div class="col-md-3">
                        <input type="radio" name="rblTypeofPrescription" id="rblOrder" value="1" onclick="RadioChange()"  />
                        <label for="rblOrder" style="font-weight: bolder">Order</label>
                    </div>
                    <div class="col-md-9"></div>
                </div>

            </div>

            <div class="POuter_Box_Inventory">
                                  <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                             <div class="col-md-4">
                                <label class="pull-left">Category</label><b class="pull-right">:</b>
                            </div><div class="col-md-8">
                                <select id="ddlCategory" onchange="LoadSubCategory();HideToDateinPKG();" tabindex="111"></select>
                                  </div>
                            <div class="col-md-4">
                                <label class="pull-left">SubCategory</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8"><select id="ddlSubCategory" tabindex="112"></select></div>
                            
                        </div>
                        <div class="row">
 <div class="col-md-4">
                                <label class="pull-left">Search By Name</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                    <input id="cmbItem"  tabindex="1" class="easyui-combogrid" style="width: 250px;height:20px" onkeypress="AddInvestigation(this,event);"  data-options="
			panelWidth: 800,
			idField: 'ItemId',
			textField: 'TypeName',
            mode:'remote',                                       
			url: 'IPDServicesBilling.aspx?cmd=item',
            loadMsg: 'Serching... ',
			method: 'get',
            pagination:true,
            rownumbers:true,
            fit:true,
            border:false,   
            cache:false,  
            nowrap:true, 
            pageSize: 10,                                                  
            emptyrecords: 'No records to display.',
            mode:'remote',
            onHidePanel: function(){ },
            onBeforeLoad: function (param) {
                   var TransactionID= $('#spnTransactionID').text();
                   var category=$('#ddlCategory').val();
                   var subcategory = $('#ddlSubCategory').val();
                   var ReferenceCode = $('#spnReferenceCodeIPD').text();
                   var IPDCaseTypeID =$('#spnIPD_CaseTypeID').text();
                   var ScheduleChargeID = $('#spnScheduleChargeID').text();
                   param.TransactionID = TransactionID;
                   param.category = category;
                   param.subcategory = subcategory;
                   param.ReferenceCode = ReferenceCode;
                   param.IPDCaseTypeID = IPDCaseTypeID;
                   param.ScheduleChargeID = ScheduleChargeID;},
			columns: [[
				{field:'TypeName',title:'Item Name',width:200,align:'center'},
        		{field:'Rate',title:'Rate',width:100,align:'center'},
{field:'SubCategoryName',title:'Group Name',width:200,align:'center'},
                {field:'ItemCode',title:'Item Code',width:100,align:'center'}
			]],
			fitColumns: true
		"/>
                            </div>
                            <div class="col-md-4">
                                   <input type="text" id="txtQuantity" class="requiredField" placeholder="Enter Quantity"  autocomplete="off" 
                                                           tabindex="2" value="1"  /> 
                            </div><div class="col-md-4 hideprescription">
                                  <button style="width: 100%; padding: 0px;" class="label label-important" type="button" tabindex="100"><span id="lblTotalLabItemsCount" style="font-size: 14px; font-weight: bold;">Count : 0</span></button>
                                <asp:Button ID="btnSetItem" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Prescribe Set" style="display:none" />
                                  </div>
                            <div class="col-md-4 showprescription">
                                <label class="pull-left">Type Of Scheduler</label>
                                <b class="pull-right">:</b>

                            </div>

                            <div class="col-md-4 showprescription">
                                <select id="ddlTypeOfSchedular" onchange="$OnchangeTypeOfScheduler(function (response) { });" class="required">
                                    <option value="">Select</option>
                                    <option value="1">Run Once</option>
                                    <option value="0" selected="selected">Run At Intervals</option>
                                </select>
                            </div>

                        </div>
                        <div class="row showprescription">


                            

                            <div class="col-md-4">
                                <label class="pull-left">Duration Unit</label>
                                <b class="pull-right">:</b>

                            </div>

                            <div class="col-md-4">
                                <select id="ddlTypeofDuration">
                                    <option value="">Select Type</option>
                                    <option value="HOUR" selected="selected">Hourly</option>
                                    <option value="MONTH">Montly</option>
                                    <option value="WEEK">Weekly</option>
                                    <option value="DAY">Daily</option>
                                    <option value="MINUTE">Minutes</option>
                                </select>


                            </div>

                            <div class="col-md-4 showprescription">
                                <label class="pull-left">Repeat Frequency</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 showprescription">

                                <input type="text" id="txtRepeatDuration" class="form-control btn-sm" style="float: left;" onkeypress="return isNumber(event)" maxlength="2" autocomplete="off" />

                            </div>
                            <div class="col-md-4 showprescription">
                              <label class="pull-left"> No. Of Repetition</label> <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 showprescription">

                                <input type="text" id="txtNoOfRepetition" class="form-control btn-sm" style="float: left;" onkeypress="return isNumber(event)"  maxlength="2" autocomplete="off" />
                                
                            </div>

                        </div>


                        <div class="row">
                            <div class="col-md-4 hideprescription">
                                <label class="pull-left">From Date</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 hideprescription">
                                 <asp:TextBox ID="ucDate" runat="server" ToolTip="Click to Select Date" TabIndex="3" ClientIDMode="Static" CssClass="ItDoseTextinputText"
                             onchange="ChkDate();"  ></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="ucDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4 ToDate hideprescription" >
                                <label class="pull-left">To Date</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 ToDate hideprescription">
                                <asp:TextBox ID="toDate" runat="server" ToolTip="Click to Select Date" TabIndex="4" ClientIDMode="Static" CssClass="ItDoseTextinputText"
                                onchange="ChkDate()" ></asp:TextBox>
                            <cc1:CalendarExtender ID="caltoDate" runat="server" TargetControlID="toDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            </div>
                            
                            <div class="col-md-4 showprescription">
                                <label class="pull-left">Start Date</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 showprescription">
                                <asp:TextBox ID="txtSelectDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtSelectDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>


                            <div class="col-md-4 showprescription">
                                <label class="pull-left">Start Time</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 showprescription">
                                <input type="text" id="txtStartTime" class="ItDoseTextinputText txtTime required"  />
                            </div>


                            <div class="col-md-4">
                                <label class="pull-left"> Remarks</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4"><input type="text" id="txtRemarks" class="ItDoseTextinputText"  tabindex="5" onkeypress="AddInvestigation(this,event);" /></div>
                        </div>

                          
                        <div class="row" style="display:none">
                            <div class="col-md-4 ">
                                <label class="pull-left">Stop Date</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 ">
                                <asp:TextBox ID="txtStopDate" runat="server" ToolTip="Click to Select Stop Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtStopDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>


                            <div class="col-md-4 ">
                                <label class="pull-left">Stop Time</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 ">
                                <input type="text" id="txtStopTime" class="ItDoseTextinputText txtTime required" readonly="readonly" />
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-4">
                              <label class="pull-left"> Doctor</label> <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <select id="ddlDoctor" tabindex="6"></select>
                            </div>
                            <div class="col-md-4"></div>
                            <div class="col-md-4"></div>
                            <div class="col-md-4"><input type="button" id="btnAdd" title="Add Item" value="Add Item" tabindex="7" class="ItDoseButton" onclick="AddItem();"  /></div>
                        </div>
                    </div></div></div>
            <div class="POuter_Box_Inventory">
             <div id="ItemOutput" style="max-height: 315px; overflow-y:auto;overflow-x: hidden;">
                            <table id="tbSelected"  rules="all" border="1" style="border-collapse: collapse; width: 100%;display:none" class="GridViewStyle">
                                <tr id="ItemHeader">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:center">CPT Code</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">Item Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:center">Payable</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Date</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Remarks</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Rate</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Quantity</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Discount(%)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Amount</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Remove</th>
                                </tr>
                               
                            </table>


                 
                                                
<table id="tbOrderSelected"  rules="all" border="1" style="border-collapse: collapse; width: 100%;display:none" class="GridViewStyle">
                               <thead>
    
<tr>
<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">Item Name</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none"">ItemId</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center ;display:none">RemainderId</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none">Type Of Scheduler</th>
    <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;">Type Of Scheduler</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">Duration Type</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center; ">Start Date</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Start Time</th>
     <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none ">Stop Date</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center;display:none ">Stop Time</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Repeat Duration </th>
    <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center"> No Of Repetition </th>
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Doctors</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 160px; text-align:center">Remarks</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Remove</th>
 </tr>   
</thead>
<tbody></tbody>                            
</table>
           



                            </div>
                <div style="text-align:center;display:none" id="divTotalAmt" class="row">
                    <div class="col-md-24">
                        <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                             <span id="spnTotalAmountText" style="font-size:small;color:red; font-weight:bold;">Gross Amount</span>
                        </label><b class="pull-right">:</b>
                    </div>
                            <div class="col-md-2">
                                 <label class="pull-left">
                                <span id="spnGrossAmount" style="font-size:small;color:red; font-weight:bold;"></span></label>
                            </div>
                            <div class="col-md-5">
                                   <label class="pull-left">
                                  <span id="spntotaldiscount" style="font-size:small;color:red; font-weight:bold;">Discount Amount</span></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">
                                  <span id="spnTotalDiscountAmount" style="font-size:small;color:red; font-weight:bold;"></span></label>
                                  </div>
                            <div class="col-md-4">
                                   <label class="pull-left">
                                  <span id="spnNetAmount" style="font-size:small;color:red; font-weight:bold;">Net Amount</span></label>
                                <b class="pull-right">:</b>
                            </div><div class="col-md-2">
                                <label class="pull-left">
                                  <span id="spnTotalNetAmount" style="font-size:small;color:red; font-weight:bold;"></span></label>
                                  </div>
                            <div class="col-md-3">
                                <label class="pull-left"  style="font-size:small;color:red; font-weight:bold;"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">
                                    <span id="spnTotalRoundOff" style="font-size:small;color:red; display:none;"></span>
                                </label>
                            </div>
                        </div></div>
                  </div></div>


            <div class="POuter_Box_Inventory divDiscountReason" style="display:none">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Discount Reason</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <select id="ddlDiscountReason" class="required" ></select>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Approve By</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <select id="ddlDiscountApproveBy"  class="required"></select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div style="text-align:center;display:none" id="divSave" class="POuter_Box_Inventory">
                <input type="button" value="Save" class="save margin-top-on-btn" id="btnSave" onclick="Save()"/>
                    
                            <input type="checkbox" id="chkprint" checked="checked" />
                            Print
                    
            </div>
        </div>
        <script type="text/javascript">
            function LedgerTransaction() {
                var dataLT = new Array();
                var objLT = new Object();
                objLT.TypeOfTnx = "IPD-Billing";
                objLT.GrossAmount = $('#spnGrossAmount').text();
                objLT.DiscountOnTotal = $('#spnTotalDiscountAmount').text();
                objLT.NetAmount = $('#spnTotalNetAmount').text();
                objLT.PatientID = $('#spnPatientID').text();
                objLT.RoundOff = $('#spnTotalRoundOff').text();
                objLT.TransactionID = $('#spnTransactionID').text();
                objLT.PanelID = $('#spnPanelID').text();
                objLT.UniqueHash = $('#txtHash').val();
                objLT.PatientType = $('#spnPatientType').text();
                objLT.DiscountApproveBy = $.trim($('#ddlDiscountApproveBy option:selected').text());
                objLT.DiscountReason = $.trim($('#ddlDiscountReason option:selected').text());
                dataLT.push(objLT);
                return dataLT;
            }
            function LedgerTransactionDetail() {
                var dataLTD = new Array();
                var objLTD = new Object();
                $("#tbSelected tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "ItemHeader") {
                        objLTD.ItemID = $.trim($rowid.find("#tditemID").text());
                        objLTD.Rate = $.trim($rowid.find("#txtRate").val());
                        objLTD.Quantity = $.trim($rowid.find("#spnQuantity").val());
                        objLTD.Amount = $.trim($rowid.find("#txtAmount").val());
                        objLTD.DiscountPercentage = $.trim($rowid.find("#txtDiscountPer").val());
                        objLTD.DiscAmt = parseFloat($.trim($rowid.find("#txtRate").val()) * parseFloat($.trim($rowid.find("#spnQuantity").val()))) * parseFloat($.trim($rowid.find("#txtDiscountPer").val()) / 100);
                        objLTD.IsVerified = 1;
                        objLTD.SubCategoryID = $.trim($rowid.find("#spnSubCategoryID").text());
                        if ($.trim($rowid.find("#ItemCode").text()) == "")
                            objLTD.ItemName = $.trim($rowid.find("#ItemName").text());
                        else
                            objLTD.ItemName = $.trim($rowid.find("#ItemName").text()) + " (" + $.trim($rowid.find("#ItemCode").text()) + ")";
                        objLTD.TransactionID = $('#spnTransactionID').text();
                        objLTD.EntryDate = $.trim($rowid.find("#spnDate").text());
                        objLTD.DoctorID = jQuery('#ddlDoctor').val();
                        objLTD.ConfigID = $.trim($rowid.find("#tdConfigRelation").text());
                        if ($rowid.find("#chkPayable").is(':checked'))
                            objLTD.IsPayable = 1;
                        else
                            objLTD.IsPayable = 0;
                        objLTD.TotalDiscAmt = 0;
                        objLTD.NetItemAmt = $('#spnGrossAmount').text();
                        objLTD.IPDCaseTypeID = $('#spnIPD_CaseTypeID').text();
                        var RateListID = 0;
                        if ($.trim($rowid.find("#spnRateListID").text()) != "")
                            RateListID = $.trim($rowid.find("#spnRateListID").text());
                        objLTD.RateListID = RateListID;
                        objLTD.RoomID = $.trim($('#spnRoom_ID').text());
                        objLTD.CoPayPercent = $.trim($rowid.find('#spncopayment').text());
                        objLTD.rateItemCode = $.trim($rowid.find('#ItemCode').text());
                        var typeOfTnx = "";
                        if ($.trim($rowid.find("#tdConfigRelation").text()) == "2")
                            typeOfTnx = "IPD-Room-Shift";
                        else if ($.trim($rowid.find("#tdConfigRelation").text()) == "1")
                            typeOfTnx = "IPD-Doc-Billing";
                        else
                            typeOfTnx = "IPD-Billing";
                        objLTD.typeOfTnx = typeOfTnx;
                        objLTD.HSNCode = $.trim($rowid.find('#spnGSTDetails').text().split('^')[0]);
                        objLTD.IGSTPercent = $.trim($rowid.find('#spnGSTDetails').text().split('^')[1]);
                        objLTD.CGSTPercent = $.trim($rowid.find('#spnGSTDetails').text().split('^')[3]);
                        objLTD.SGSTPercent = $.trim($rowid.find('#spnGSTDetails').text().split('^')[2]);
                        objLTD.GSTType = $.trim($rowid.find('#spnGSTDetails').text().split('^')[4]);
                        dataLTD.push(objLTD);
                        objLTD = new Object();
                    }

                });
                return dataLTD;
            }
            function Validation() {
                var zerorateiten = 0
                $("#tbSelected tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "ItemHeader") {
                        if (Number($rowid.find("#txtRate").val()) == 0 || $.trim($rowid.find("#txtRate").val()) == '') {
                            zerorateiten += 1;
                        }
                    }
                });
                if (zerorateiten <= 0) {
                    return false;
                }
                return true;
            }
            function Save() {

                var value = $('input[name=rblTypeofPrescription]:checked').val();

                if (value == 0) {
                //if (Validation()) {

                var resultLT = LedgerTransaction();
                var resultLTD = LedgerTransactionDetail();

                if (Number(resultLT[0].DiscountOnTotal) > 0) {

                    if (String.isNullOrEmpty(resultLT[0].DiscountReason)) {
                        modelAlert('Please Select Discount Reason.', function () {
                            $('#ddlDiscountReason').focus();
                        });
                        return false;
                    }


                    if (String.isNullOrEmpty(resultLT[0].DiscountApproveBy)) {
                        modelAlert('Please Select Approve By.', function () {
                            $('#ddlDiscountApproveBy').focus();
                        });
                        return false;
                    }
                }


                $('#btnSave').attr('disabled', true).val("Submitting...");

                var IsPrint = ($('#chkprint').prop('checked') ? 1 : 0);


                $.ajax({
                    url: "Services/IPDLabPrescription.asmx/SaveServicesBilling",
                    data: JSON.stringify({ LT: resultLT, LTD: resultLTD, PatientTypeID: $('#spnPatientTypeID').text(), MembershipNo: $('#spnMembershipNo').text(), NotificationId: "" }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: "120000",
                    dataType: "json",
                    success: function (result) {
                        var responseData = JSON.parse(result.d);

                        var btnSave = $('#btnSave');

                        modelAlert(responseData.response, function () {

                            if (responseData.status) {
                                if (IsPrint == 1 && responseData.LedgerTransactionNo != "0")
                                    window.open('CommonReceipt.aspx?LedgerTransactionNo=' + responseData.LedgerTransactionNo + '&Duplicate=0');

                                window.location.reload();
                            }
                            else
                                $(btnSave).removeAttr('disabled').val('Save');

                        });




                            //OutPut = result.d;
                            //if (result.d.split('#')[1] == 1) {
                            //    modelAlert("Record Saved Successfully", function () {
                            //        $('#btnSave').attr('disabled', false).val("Save");
                            //        ClearControls();
                            //    });
                            //}
                            //else {
                            //    modelAlert("Error occurred, Please contact administrator", function () {
                            //        $('#btnSave').attr('disabled', false).val("Save");
                            //    });

                        //}
                    }
                });
                ///  }
                //else
                //  modelAlert("Please Remove The Zero Rate Item Otherwise Enter The Rate of These Item");

                } else {
                    SaveOrderEntry(function () { });
                }



            }

            function ClearControls() {
                $("#tbSelected tr:not(#ItemHeader)").remove();
                $('#tbSelected').removeAttr('disabled').hide();
                $('#divTotalAmt').hide();
                $('#divSave').hide();
                $('#spnGrossAmount,#spnTotalDiscountAmount,#spnTotalNetAmount,#spnTotalRoundOff').text('');
                $('.divDiscountReason').find('select').val('0');
                $('.divDiscountReason').hide();


                bindHashCode();
                BindPatientDetail();
            }
            var alreadyPrescribeItem = function (data, callBack) {
                if (data.PatientID.trim() != '') {
                    serverCall('Services/IPDLabPrescription.asmx/getAlreadyPrescribeItem', data, function (response) {
                        responseData = JSON.parse(response);
                        if (responseData != null && responseData != "") {
                            modelConfirmation('Do You Want To Prescribe Again  ?', 'This Service is Already Prescribed By ' + responseData[0].UserName + '</br> Date On ' + responseData[0].EntryDate, 'Prescribe Again', 'Cancel', function (response) {
                                if (response)
                                    callBack(response);
                            });
                        }
                        else
                            callBack(true);
                    });
                }
                else
                    callBack(true);
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
                    //if (charCode == 13) {
                    //    e.preventDefault();
                    //    AddItem();
                    //}
                }

                return true;
            }



            var bindApprovedMaster = function (callback) {

                
                var divDiscountReason = $('.divDiscountReason');

                serverCall('../EDP/Services/EDP.asmx/bindDisAppoval', { ApprovalType: '', Type: '1' }, function (response) {
                    if (String.isNullOrEmpty(response))
                        response = '[]';

                    var discountApprovalMaster = JSON.parse(response);
                    var ddlDiscountApproveBy = divDiscountReason.find('#ddlDiscountApproveBy');
                    ddlDiscountApproveBy.bindDropDown({
                        data: discountApprovalMaster,
                        valueField: 'ApprovalType',
                        textField: 'ApprovalType',
                        defaultValue: '',
                        selectedValue: ''
                    });
                    callback(ddlDiscountApproveBy.val());

                });
            }


            var bindDiscReason = function (callback) {

                
                var divDiscountReason = $('.divDiscountReason');
                serverCall('../Common/CommonService.asmx/GetDiscReason', { Type: 'IPD' }, function (response) {
                    var $ddlControlDiscountReason = divDiscountReason.find('#ddlDiscountReason');
                    $ddlControlDiscountReason.bindDropDown({
                        defaultValue: '', selectedValue: '', data: JSON.parse(response), valueField: 'DiscountReason', textField: 'DiscountReason', isSearchAble: false
                    });
                    callback($ddlControlDiscountReason.find('option:selected').text());
                });
            }


            $(document).ready(function () {

                $('#ucDate').change(function () {
                    ChkDate();
                });

                $('#toDate').change(function () {
                    ChkDate();
                });

                var roleid = '<%=Session["RoleID"].ToString()%>';
                if (roleid == '52') {
                    hideandshowfield(1);
                  //  var value = $('#rblOrder').attr('checked', 'checked');
                   // hideandshowfield(value);
                }
                else {
                    //var value = $('#rblIndent').attr('checked', 'checked');
                    hideandshowfield(1);
                  
                }
                $('.requistiontype').hide()
                $OnchangeTypeOfScheduler(function (response) { });
                $('.txtTime').timepicker({
                    timeFormat: 'h:mm p',
                    interval: 1,
                    minTime: '00:01',
                    maxTime: '11:59pm',
                    // defaultTime: '00:01',
                    startTime: '00:01',
                    dynamic: false,
                    dropdown: true,
                    scrollbar: true
                });



                bindApprovedMaster(function () {
                    bindDiscReason(function () { });
                });
            });


            //################## Order  Section ################
            function RadioChange() {
                var value = $('input[name=rblTypeofPrescription]:checked').val();
                hideandshowfield(value);
            }

            function hideandshowfield(SelVal) {
                if (SelVal == 0) {
                    $(".hideprescription").show();
                    $(".showprescription").hide();

                } else {
                    $(".hideprescription").show();
                    $(".showprescription").hide();
                }
            }

            var $OnchangeTypeOfScheduler = function () {
                if ($('#ddlTypeOfSchedular').val() == "1") {
                    $("#txtSelectDate").attr("disabled", false);
                    $("#txtStartTime").attr("disabled", false);

                    $("#txtRepeatDuration").attr("disabled", true);
                    $("#ddlTypeofDuration").attr("disabled", true);
                    $("#txtNoOfRepetition").attr("disabled", true);



                    $("#txtNoOfRepetition").removeClass("required");
                    $("#txtRepeatDuration").removeClass("required");
                    $("#ddlTypeofDuration").removeClass("required");


                }
                else if ($('#ddlTypeOfSchedular').val() == "0") {
                    $("#txtSelectDate").attr("disabled", false);
                    $("#txtStartTime").attr("disabled", false);
                    $("#txtRepeatDuration").attr("disabled", false);
                    $("#ddlTypeofDuration").attr("disabled", false);
                    $("#txtNoOfRepetition").attr("disabled", false);

                    $("#txtNoOfRepetition").addClass("required");
                    $("#txtRepeatDuration").addClass("required");
                    $("#ddlTypeofDuration").addClass("required");



                }
                else {

                    $("#txtSelectDate").attr("disabled", true);
                    $("#txtStartTime").attr("disabled", true);
                    $("#txtRepeatDuration").attr("disabled", true);
                    $("#ddlTypeofDuration").attr("disabled", true);
                    $("#txtNoOfRepetition").attr("disabled", true);


                }

            }


            function isNumber(evt) {
                evt = (evt) ? evt : window.event;
                var charCode = (evt.which) ? evt.which : evt.keyCode;
                if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
                return true;
            }




            function GetOrderDetails() {
                var dataLTD = new Array();
                var objLTD = new Object();
                $("#tbOrderSelected tbody tr").each(function () {

                    var $rowid = $(this).closest("tr");

                    objLTD.ItemID = $.trim($rowid.find("#tditemID").text());
                    objLTD.Quantity = $.trim($rowid.find("#tdspnQuantity").text());
                    objLTD.ItemName = $.trim($rowid.find("#tdItemName").text());
                    objLTD.TransactionID = $('#spnTransactionID').text();
                    objLTD.PatientId = $('#spnPatientID').text();

                    objLTD.DoctorID = $.trim($rowid.find("#tdddlDoctor").text());

                    objLTD.RemainderName = $.trim($rowid.find("#tdtxtRemainderName").text());
                    objLTD.RemainderType = $.trim($rowid.find("#tdddlRemainderType").text());
                    objLTD.StartDate = $.trim($rowid.find("#tdtxtSelectDate").text());
                    objLTD.StartTime = $.trim($rowid.find("#tdtxtStartTime").text());
                    objLTD.RepeatDuration = $.trim($rowid.find("#tdtxtRepeatDuration").text());

                    objLTD.TypeofDuration = $.trim($rowid.find("#tdddlTypeofDuration").text());
                    objLTD.TypeOfSchedular = $.trim($rowid.find("#tdddlTypeOfSchedular").text());
                    objLTD.Remark = $.trim($rowid.find("#tdtxtRemarks").text());
                    objLTD.StopDate = $.trim($rowid.find("#tdtxtStopDate").text());
                    objLTD.StopTime = $.trim($rowid.find("#tdtxtStopTime").text());
                    objLTD.NoOFRepetition = $.trim($rowid.find("#tdtxtNoOfRepetition").text());

                    dataLTD.push(objLTD);
                    objLTD = new Object();


                });
                return dataLTD;
            }





            var SaveOrderEntry = function () {
                var resultLTD = GetOrderDetails();

                $('#btnSave').attr('disabled', true).val("Submitting...");



                $.ajax({
                    url: "Services/IPDLabPrescription.asmx/SaveLabAndRadiologyOrder",
                    data: JSON.stringify({ LTD: resultLTD }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: "120000",
                    async: false,
                    dataType: "json",
                    success: function (result) {

                        var responseData = JSON.parse(result.d);
                        var btnSave = $('#btnSave');

                        modelAlert(responseData.response, function () {

                            if (responseData.status)
                                window.location.reload();
                            else
                                $(btnSave).removeAttr('disabled').val('Save');

                        });



                    }
                });

            }




            var alreadyPrescribeOrderItem = function (data, callBack) {
                if (data.PatientID.trim() != '') {
                    serverCall('Services/IPDLabPrescription.asmx/getAlreadyPrescribeOrderItem', data, function (response) {
                        responseData = JSON.parse(response);
                        if (responseData != null && responseData != "") {
                            modelConfirmation('Do You Want To Prescribe Again  ?', 'This Investigation is Already Prescribed  </br> On Date  ' + responseData[0].EntryDate, 'Prescribe Again', 'Cancel', function (response) {
                                if (response)
                                    callBack(response);
                            });
                        }
                        else
                            callBack(true);
                    });
                }
                else
                    callBack(true);
            }

            function CheckOrderDuplicateItem(ItemID) {
                var count = 0;
                $('#tbOrderSelected tbody tr').each(function () {
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

            //################## Order  Section  End ################
        </script>
    </form>
</body>
</html>
