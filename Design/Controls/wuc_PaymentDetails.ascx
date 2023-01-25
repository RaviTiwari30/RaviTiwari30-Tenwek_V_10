<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wuc_PaymentDetails.ascx.cs"
    Inherits="Design_Controls_wuc_PaymentDetails" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script  type="text/javascript">
    if ($.browser.msie)
        $(document).on("keydown", function (e) {
            var doPrevent;
            if (e.keyCode == 8) {
                var d = e.srcElement || e.target;
                if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                }
                else
                    doPrevent = true;
            }
            else
                doPrevent = false;

            if (doPrevent)
                e.preventDefault();
        });
   

     </script>
<script  type="text/javascript"  >
    function changeBaseAmt(paidAmt) {
        if (paidAmt > $('#txtTotalPaidAmount').val()) {          
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#txtTotalPaidAmount').val() - $('#<%=lblTotalPaidAmount.ClientID %>').text());
        }
        else if ($('#<%=lblTotalPaidAmount.ClientID %>').text() == "0") {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#txtTotalPaidAmount').val() - paidAmt);
            $('#<%=lblBalanceAmount.ClientID %>').text($('#txtTotalPaidAmount').val() - paidAmt);
        }
        else if ($('#<%=lblBalanceAmount.ClientID %>').text() == "0") {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text());
        }
        
        else {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text() - paidAmt);
        }
    }
    function changeBaseAmtPharmacy(paidAmt) {
        if (paidAmt > $('#txtTotalPaidAmount').val()) {
            getCurrencyBasePharmacy($('#<%=ddlCountry.ClientID %>').val(), $('#txtTotalPaidAmount').val() - $('#<%=lblTotalPaidAmount.ClientID %>').text());
        }
        else if ($('#<%=lblTotalPaidAmount.ClientID %>').text() == "0") {
            getCurrencyBasePharmacy($('#<%=ddlCountry.ClientID %>').val(), $('#txtTotalPaidAmount').val() - paidAmt);
            $('#<%=lblBalanceAmount.ClientID %>').text($('#txtTotalPaidAmount').val() - paidAmt);
        }
        else if ($('#<%=lblBalanceAmount.ClientID %>').text() == "0") {
            getCurrencyBasePharmacy($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text());
        }

        else {
            getCurrencyBasePharmacy($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text() - paidAmt);
        }
}
</script>
<script  type="text/javascript">
    $(document).ready(function () {
        $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>,.a").hide();     
        if (($('#txtDisAmount').val() > 0) || ($('#txtDisPercent').val() > 0)) {
            $("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,#v3,#v4,.a").show();
        }

    });
    function paymentmode() {
        if ($("#<%=ddlPaymentMode.ClientID %>").val() == "1") {
            $("#<%=txtrefNo.ClientID %>").val('');
            $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>,#v1,#v2").hide();
            $('#<%=ddlBank.ClientID%> option:nth-child(1)').attr('selected', '0');
            if ($('#<%=txtNetAmount.ClientID %>').val() != "0") {
                $("#<%=txtPaidAmount.ClientID %>,#<%=btnAdd.ClientID %>").attr("disabled", false);
            }
            else {
                $("#<%=txtPaidAmount.ClientID %>,#<%=btnAdd.ClientID %>").attr("disabled", true);
            }
            $("#<%=Label10.ClientID %>").show();
        }
        else if ($("#<%=ddlPaymentMode.ClientID %>").val() == "4") {
            $("#<%=txtrefNo.ClientID %>,#<%=txtPaidAmount.ClientID %>").val('');
            $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>,#v1,#v2,#<%=Label10.ClientID %>").hide();
            $('#<%=ddlBank.ClientID%> option:nth-child(1)').attr('selected', '0');
            $("#<%=txtPaidAmount.ClientID %>,#<%=btnAdd.ClientID %>").attr("disabled", true);
        }
        else {
            $("#<%=txtrefNo.ClientID %>").val('');
            $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>").show();
            $('#<%=ddlBank.ClientID%> option:nth-child(1)').attr('selected', '0');
            if ($('#<%=txtNetAmount.ClientID %>').val() != "0") {
                $("#<%=txtPaidAmount.ClientID %>,#<%=btnAdd.ClientID %>").attr("disabled", false);
            }
            else {
                $("#<%=txtPaidAmount.ClientID %>,#<%=btnAdd.ClientID %>").attr("disabled", true);
            }
            $("#<%=Label10.ClientID %>,#v1,#v2").show();
        }
    }
    function visibleDisAmount() {
        sum();
        if ($('#txtDisAmount').val() != "") 
            $('#txtDisPercent').removeAttr('tabindex');
        else 
            $('#txtDisPercent').attr('tabindex', 29);
        ValidateDecimalAmt();
        var DisAmount = $('#<%=txtDisAmount.ClientID %>').val();
        var DisPercent = $('#<%=txtDisPercent.ClientID %>').val();

        if (($("#<%=txtDisAmount.ClientID %>").val() <= "0") && ($("#<%=txtDisPercent.ClientID %>").val() <= "0")) {
            $("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,#v3,#v4,.a").hide();
            $("#<%=ddlApproveBy.ClientID %> option:nth-child(1)").attr('selected', '0');
            $("#<%=txtDiscReason.ClientID%>").val('');
        }
        else {
            $("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,#v3,#v4,.a").show();
            $("#<%=ddlApproveBy.ClientID %>").attr('selectedIndex', 0);
        }
    }
    function visibleDisPercent() {
        amt();
        if ($('#txtDisPercent').val() != "") 
            $('#txtDisPercent').attr('tabindex', 29);
        ValidateDecimal();
        var DisAmount = $('#<%=txtDisAmount.ClientID %>').val();
        var DisPercent = $('#<%=txtDisPercent.ClientID %>').val();

        if (($("#<%=txtDisAmount.ClientID %>").val() <= "0") && ($("#<%=txtDisPercent.ClientID %>").val() <= "0")) {
            $("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,.a").hide();
            $("#<%=ddlApproveBy.ClientID %> option:nth-child(1)").attr('selected', '0');
            $("#<%=txtDiscReason.ClientID%>").val('');
        }
        else {
            $("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,.a").show();
            $("#<%=ddlApproveBy.ClientID %>").attr('selectedIndex', 0);
        }
    }
    $(document).ready(function () {
      
        $('#txtDisAmount').keyup(function () {
            $('#txtDisPercent').val('');          
        });      
    });
    function precise_round(num, decimals) {
        return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
    }
    function amt() {
        $('#txtDisPercent').bind("blur keyup keydown", function () {
            if ($(this).val().charAt(0) == ".") {
                $(this).val('0.');
                $(".a").hide();
                return false;
            }
            $('#txtDisAmount').val('');
            $('#<%=txtPaidAmount.ClientID%>').val('');
            var TotalBillAmt = Number($('#txtBillAmount').val());
            var DisPer = Number($('#txtDisPercent').val());
            if (DisPer > 100) {
                $('#txtDisPercent').val('');
                $('#txtNetAmount').val(precise_round(TotalBillAmt,0));
                $(".a").hide();
                return;
            }
            if ($("#txtBillAmount").val() == "0.00") {
                $('#txtDisPercent').val('');
                $('#txtNetAmount').val(TotalBillAmt);
                $(".a").hide();
                return;
            }
            $('#txtNetAmount').val((TotalBillAmt - ((TotalBillAmt * DisPer) / 100)));
            var NetAmount = precise_round($('#txtNetAmount').val(), 2);
            $('#txtNetAmount').val(NetAmount);
            var GovTaxPer = $("#<%=lblGovTaxPercentage.ClientID%>").text();   
           
            if (($("span[id*=lblCardRegistration]").length == "1") || ($("span[id*=lblAppGetPayment]").length == "1") || ($("span[id*=lblOPDPharmacyIssue]").length == "1") || ($("span[id*=lblOPDPharmacyReturn]").length == "1") || ($("span[id*=lblBookDirectAppointment]").length == "1")) {
                $("#<%=txtGovTaxAmt.ClientID%>").val(0);   
            }      
            else {
                    $("#<%=txtGovTaxAmt.ClientID%>").val(precise_round(((($('#txtNetAmount').val()) * parseFloat(GovTaxPer)) / 100),2));              
            }
         
            $('#txtTotalPaidAmount').val(precise_round(((parseFloat($('#txtNetAmount').val())) + (parseFloat($("#<%=txtGovTaxAmt.ClientID%>").val()))), 2));
            
            var TotalPaidAmt = parseFloat($('#txtTotalPaidAmount').val());
           
           
            if (($("span[id*=lblOPDPharmacyIssue]").length == "1") || ($("span[id*=lblOPDPharmacyReturn]").length == "1")) {
                $('#txtTotalPaidAmount').val(precise_round(($('#txtTotalPaidAmount').val()),0));
                $('#<%=lblRoundVal.ClientID %>').text(precise_round(((parseFloat($('#txtTotalPaidAmount').val())) - (parseFloat((TotalPaidAmt)))),2));
            }
            else
            {
                $('#txtTotalPaidAmount').val(precise_round(($('#txtTotalPaidAmount').val()),0));
                $('#<%=lblRoundVal.ClientID %>').text(precise_round((parseFloat($('#txtTotalPaidAmount').val())) - (parseFloat((TotalPaidAmt))), 2));
           
            }
            $('#<%=lblBalanceAmount.ClientID %>').text($('#txtTotalPaidAmount').val()); 
            if ($('#<%=txtNetAmount.ClientID %>').val() == "0") {
                $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlPaymentMode.ClientID%> option[value='1']").attr("disabled", false);
                $("#<%=btnAdd.ClientID%>,#<%=txtPaidAmount.ClientID %>,#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3'],#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
            }
            else {
                if (($("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisPercent').val() > 0)) {
                    $("input[id*=btnSelect]").attr("disabled", true);
                    $(".imbRemove").hide();
                    $("select[id*=ddlcategory],select[id*=ddlSubcategory]").prop('selectedIndex', 0).attr("disabled", true);
                    $("input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").val('').attr("disabled", true);
                }
                else {
                    $("input[id*=btnSelect],select[id*=ddlcategory],select[id*=ddlSubcategory],input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").attr("disabled", false);
                    $(".imbRemove").show();
                }
                $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
                $("#<%=btnAdd.ClientID %>,#<%=txtPaidAmount.ClientID %>,#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
                if ($("select[id*=ddlPanelCompany]").val() != null) {
                    if ($("select[id*=ddlPanelCompany]").val() == "1#1") {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    }
                    else {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);

                    }
                }
                else if ($("select[id*=ddlPanel]").val() != null) {
                    if ($("select[id*=ddlPanel]").val() == "1") {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    }
                    else {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);

                    }
                }
                else if ($("span[id*=lblPanelID]").text() != null) {
                    if ($("span[id*=lblPanelID]").text() == "1") {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    }
                    else {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                    }
                }             
                else {
                    $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
            }
            getCurrencyConditions();
        });
    }
    function sum() {
        $('#txtDisAmount').bind("blur keyup keydown", function () {
            if (($(this).val().charAt(0) == ".")) {
                $(this).val('0.');
                $(".a").hide();
                return false;
            }
            $('#txtDisPercent').val('');
            $('#<%=txtPaidAmount.ClientID%>').val('');
            var TotalBillAmt = $('#txtBillAmount').val();
            var DisAmt = Number($('#txtDisAmount').val());
            if (DisAmt > TotalBillAmt) {
                $('#txtDisAmount').val('');
                $('#txtNetAmount').val(precise_round(TotalBillAmt,2));
                $(".a").hide();
                return;
            }
            var GovTaxPer = $("#<%=lblGovTaxPercentage.ClientID%>").text();
            
            $('#txtNetAmount').val(precise_round((Number(TotalBillAmt) - DisAmt), 2));
            if (($("span[id*=lblCardRegistration]").length == "1") || ($("span[id*=lblAppGetPayment]").length == "1") || ($("span[id*=lblOPDPharmacyIssue]").length == "1") || ($("span[id*=lblOPDPharmacyReturn]").length == "1") || ($("span[id*=lblBookDirectAppointment]").length == "1")) {
                $("#<%=txtGovTaxAmt.ClientID%>").val(0);
            }
            else {
                $("#<%=txtGovTaxAmt.ClientID%>").val(precise_round((((parseFloat($('#txtNetAmount').val()) * (parseFloat(GovTaxPer))) / 100)), 2));
            }
       
            $('#txtTotalPaidAmount').val(precise_round((parseFloat($('#txtNetAmount').val()) + (parseFloat($("#<%=txtGovTaxAmt.ClientID%>").val()))), 2));

            var TotalPaidAmt = parseFloat($('#txtTotalPaidAmount').val());
            if (($("span[id*=lblOPDPharmacyIssue]").length == "1") || ($("span[id*=lblOPDPharmacyReturn]").length == "1")) {
                $('#txtTotalPaidAmount').val(precise_round(($('#txtTotalPaidAmount').val()),0));
            }
            else
                $('#txtTotalPaidAmount').val(precise_round(($('#txtTotalPaidAmount').val()),0));
            $('#<%=lblBalanceAmount.ClientID %>').text($('#txtTotalPaidAmount').val());
            $('#<%=lblRoundVal.ClientID %>').text(precise_round((parseFloat($('#txtTotalPaidAmount').val())) - (parseFloat((TotalPaidAmt))), 2));
           
            if ($('#<%=txtNetAmount.ClientID %>').val() == "0") {
                $("#<%=txtPaidAmount.ClientID %>").attr("disabled", true);
                $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlPaymentMode.ClientID%> option[value='1']").attr("disabled", false);
                $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", true);

                paymentmode();
            }
            else {
                if (($("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisAmount').val() > 0)) {
                    $("input[id*=btnSelect]").attr("disabled", true);                  
                    $(".imbRemove").hide();
                    $("select[id*=ddlcategory],select[id*=ddlSubcategory]").prop('selectedIndex', 0).attr("disabled", true);
                    $("input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").val('').attr("disabled", true);
                }
                else {
                    $("input[id*=btnSelect],select[id*=ddlcategory],select[id*=ddlSubcategory],input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").attr("disabled", false);
                    $(".imbRemove").show();
                }
                $("#<%=btnAdd.ClientID %>").attr("disabled", false);
                $("#<%=txtPaidAmount.ClientID %>").attr("disabled", false);
                $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
                if ($("select[id*=ddlPanelCompany]").val() != null) {
                    if ($("select[id*=ddlPanelCompany]").val() == "1#1") {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    }
                    else {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                    }
                }
                else if ($("select[id*=ddlPanel]").val() != null) {
                    if ($("select[id*=ddlPanel]").val() == "1") {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    }
                    else {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                    }
                }
                else if ($("span[id*=lblPanelID]").text() != null) {
                    if ($("span[id*=lblPanelID]").text() == "1") {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    }
                    else {
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                    }
                }              
                else {
                    $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
            }          
            getCurrencyConditions();
        });
    }
    $(document).ready(function () {
        if ((($("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisAmount').val() > 0)) || (($("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisPercent').val() > 0))) {
            $(".imbRemove").hide();
            $("select[id*=ddlcategory],select[id*=ddlSubcategory]").prop('selectedIndex', 0).attr("disabled", true);
            $("input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode],input[id*=btnSelect]").attr("disabled", true);
        }
        else {
            $("input[id*=btnSelect],input[id*=txtCPTCode],input[id*=txtsearchword],input[id*=txtSearch]").attr("disabled", false);
            $(".imbRemove").show();
        }
        if (($("span[id*=lblOPDLabPrescription]").length > 0) && ($("#<%=grdPaymentMode.ClientID%> tr").length > 1)) {
            $("input[id*=btnSelect]").attr("disabled", true);
        }      
        $('#<%=ddlCountry.ClientID %>').change(function () {
            loadCountryFactor();
        });
        if ($("#<%=grdPaymentMode.ClientID %> tr").length > "0") {
            $("#<%=grdPaymentMode.ClientID %> tr").each(function () {            
                if (!this.rowIndex)
                    return;
                var cell = $(this).find("td:eq(1)").text();
                if (cell == "Credit") {
                    $('#<%=txtPaidAmount.ClientID %>').attr("disabled", true);
                    $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 4);
                    $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", true);
                    $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                else {
                    
                    $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
                }
            });
        }
    });
    function loadCountryFactor() {
        $.ajax({
            url: "../Common/CommonService.asmx/loadCountryFactor",
            data: '{CountryID:"' + $('#<%=ddlCountry.ClientID %>').val() + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var dtdata = jQuery.parseJSON(mydata.d);
                if (dtdata.length > 0) {
                    $('#<%=lblCurrencyNotation.ClientID %>').val(dtdata[0].Notation);
                    getCurrencyConditions();
                    if (($("span[id*=lblOPDPharmacyIssue]").length == "1") || ($("span[id*=lblOPDPharmacyReturn]").length == "1"))
                        getMinCurrency($('#<%=ddlCountry.ClientID %>').val());

                }
            }
        });
    }
    function getMinCurrency(CountryID) {
        if ('<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>' != CountryID) {
            $.ajax({
                url: "../Common/CommonService.asmx/MinCurrency",
                data: '{CountryID:"' + $('#<%=ddlCountry.ClientID %>').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var Curr = mydata.d;
                    if (Curr.length > 0) {
                        if (Curr > "1") {

                            var RoundOff = 0; var NewAmount = 0;
                            var Amount = precise_round(parseFloat($("#<%=lblCurrencyBase.ClientID %>").text().split(' ')[0]),0);
                            if (Amount < 100) {
                                if (Amount > Curr) {
                                    RoundOff = precise_round((100 - Amount),2);
                                    NewAmount = precise_round((Amount + RoundOff),0);

                                    $("#txtCurrencyRoffAmt").val(RoundOff);
                                    $("#lblCurrencyRoffAmt").text(RoundOff);
                                    $('#lblCurrencyBase').text(NewAmount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                                    $("#<%=txtCurrencyBase.ClientID %>").val(NewAmount);
                                }
                                else {
                                    RoundOff = precise_round((Curr - Amount),2);
                                    NewAmount = precise_round((Amount + RoundOff),0);
                                    
                                    $("#txtCurrencyRoffAmt").val(RoundOff);
                                    $("#lblCurrencyRoffAmt").text(RoundOff);
                                    $('#lblCurrencyBase').text(NewAmount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                                    $("#<%=txtCurrencyBase.ClientID %>").val(NewAmount);
                                }
                            }
                            else if (Amount > 100) {

                                var Last2Digit = $("#<%=lblCurrencyBase.ClientID %>").text().split(' ')[0];
                                var length = Last2Digit.length;
                                Last2Digit = Last2Digit.substr(length - 2);
                                if ((Last2Digit) > Curr) {
                                    
                                    RoundOff = precise_round((100 - (Last2Digit)),2);
                                    NewAmount =precise_round(( Amount + RoundOff),0);

                                    $("#txtCurrencyRoffAmt").val(RoundOff);
                                    $("#lblCurrencyRoffAmt").text(RoundOff);
                                    $('#lblCurrencyBase').text(NewAmount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                                    $("#<%=txtCurrencyBase.ClientID %>").val(NewAmount);
                                    // getConvertCurrency($('#<%=ddlCountry.ClientID %>').val(), $('#<%=txtCurrencyBase.ClientID %>').val());

                                }
                                else if ((Last2Digit) > 0) {
                                    RoundOff = precise_round((Curr - (Last2Digit)),2);
                                    NewAmount = precise_round((Amount + RoundOff), 0);
                                   
                                    $("#txtCurrencyRoffAmt").val(RoundOff);
                                    $("#lblCurrencyRoffAmt").text(RoundOff);
                                    $("#<%=txtCurrencyBase.ClientID %>").val(NewAmount);
                                    $('#lblCurrencyBase').text(NewAmount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());

                                    //    getConvertCurrency($('#<%=ddlCountry.ClientID %>').val(), $('#<%=txtCurrencyBase.ClientID %>').val());
                                }
                                else {
                                    $("#<%=txtCurrencyBase.ClientID %>").val(Amount);
                                    $('#lblCurrencyBase').text(Amount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());

                                    $("#txtCurrencyRoffAmt").val(0);
                                    $("#lblCurrencyRoffAmt").text(0);
                                }
                            }
                        }
                        else {


                            $("#txtCurrencyRoffAmt").val(0);
                            $("#lblCurrencyRoffAmt").text(0);
                        //    $('#txtTotalPaidAmount').val(parseFloat($("#<%=txtNetAmount.ClientID%>").val()) + parseFloat($("#<%=txtGovTaxAmt.ClientID%>").val()));
                            //   getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), parseFloat($('#txtNetAmount').val()) + parseFloat($("#txtGovTaxAmt").val()));
                        }
                    }
                }
            });
        }
        else {
            $("#txtCurrencyRoffAmt").val(0);
            $("#lblCurrencyRoffAmt").text(0);
          //  $('#txtTotalPaidAmount').val(parseFloat($("#<%=txtNetAmount.ClientID%>").val()) + parseFloat($("#<%=txtGovTaxAmt.ClientID%>").val()));

        }
    }
    function getCurrencyConditions() {
        if ($('#<%=lblTotalPaidAmount.ClientID %>').text() == "0") {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#txtTotalPaidAmount').val());
        }
        else {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text());
        }
    }
    function getCurrencyBase(CountryID, Amount) {
        $.ajax({
            url: "../Common/CommonService.asmx/getConvertCurrecncy",
            data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
            type: "POST",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                
                $('#lblCurrencyBase').text(precise_round(data,0) + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                $("#<%=txtCurrencyBase.ClientID %>").val(data); 
                
                
                //shatrughan 08.04.2014      
                if (($("span[id*=lblOPDPharmacyReturn]").length != "1")) {
                    if ($.trim($("#<%=txtCurrencyBase.ClientID%>").val()) == "0") {
                        $("#<%=txtPaidAmount.ClientID%>,#<%=btnAdd.ClientID%>,#<%=ddlPaymentMode.ClientID%>,#<%=ddlCountry.ClientID%>").prop('disabled', true);
                    }
                    else {
                        $("#<%=txtPaidAmount.ClientID%>,#<%=btnAdd.ClientID%>,#<%=ddlPaymentMode.ClientID%>,#<%=ddlCountry.ClientID%>").prop('disabled', false);
                    }
                }
                if (($("span[id*=lblOPDPharmacyReturn]").length == "1")) {
                    $("#<%=ddlPaymentMode.ClientID%>").prop("disabled", "disabled");
                }
                else if (($("#<%=grdPaymentMode.ClientID %> tr").length) > "1") {
                    $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
                    $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                }
            }
        });
    }
    function getCurrencyBasePharmacy(CountryID, Amount) {
        $.ajax({
            url: "../Common/CommonService.asmx/getConvertCurrecncy",
            data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
            type: "POST",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                if (($("span[id*=lblOPDPharmacyReturn]").length == "1") || ($("span[id*=lblOPDPharmacyIssue]").length == "1")) {
                    data = parseFloat(data) + parseFloat($("#txtCurrencyRoffAmt").val());
                }
                $('#lblCurrencyBase').text(precise_round(data,0) + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                $("#<%=txtCurrencyBase.ClientID %>").val(data);


                //shatrughan 08.04.2014      
                if (($("span[id*=lblOPDPharmacyReturn]").length != "1")) {
                    if ($.trim($("#<%=txtCurrencyBase.ClientID%>").val()) == "0") {
                        $("#<%=txtPaidAmount.ClientID%>,#<%=btnAdd.ClientID%>,#<%=ddlPaymentMode.ClientID%>,#<%=ddlCountry.ClientID%>").prop('disabled', true);
                    }
                    else {
                        $("#<%=txtPaidAmount.ClientID%>,#<%=btnAdd.ClientID%>,#<%=ddlPaymentMode.ClientID%>,#<%=ddlCountry.ClientID%>").prop('disabled', false);
                    }
                }
                if (($("span[id*=lblOPDPharmacyReturn]").length == "1")) {
                    $("#<%=ddlPaymentMode.ClientID%>").prop("disabled", "disabled");
                }
                else if (($("#<%=grdPaymentMode.ClientID %> tr").length) > "1") {
                    $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
                    $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                }
            }
        });
}
    function getConvertCurrency(CountryID, Amount) {
        if ('<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>' != CountryID) {
            $.ajax({
                url: "../Common/CommonService.asmx/ConvertCurrency",
                data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    $('#<%=txtConvertCurrency.ClientID %>').val(precise_round((mydata.d), 2));
                   


                }
            });
        }
    }
    </script>
    <script type="text/javascript" >
    function validate() {       
        if ($('#<%=ddlPaymentMode.ClientID %>').val() == "2" || $('#<%=ddlPaymentMode.ClientID %>').val() == "3") {
            if (($.trim($('#<%=ddlBank.ClientID %>').val()) == "")) {
                alert('Please Select Bank');
                return false;
            }
            if (($.trim($('#<%=txtrefNo.ClientID %>').val()) == "")) {
                alert('Please Enter Ref No.');
                return false;
            }
        }
        if ($("#<%=grdPaymentMode.ClientID %> tr").length > "0") {
            $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
            $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
            $("#<%=grdPaymentMode.ClientID %> tr").each(function () {
                if (!this.rowIndex)
                    return;
                var cell = $(this).find("td:eq(1)").text();
                if (cell == "Credit") {
                    $('#<%=txtPaidAmount.ClientID %>').attr("disabled", true);
                    $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 4);
                }

            });
        }
        if ($("#<%=grdPaymentMode.ClientID %> tr").length > "0") {
            var con = 0;
            $("#<%=grdPaymentMode.ClientID %> tr").each(function () {
                if (!this.rowIndex)
                    return;
                var PaymentMode = $.trim($(this).find("td:eq(1)").text());
                var Currency = $.trim($(this).find("td:eq(3)").text());
                if ((Currency == ($.trim($("#<%=ddlCountry.ClientID %> option:selected").text()))) && (PaymentMode == ($.trim($("#<%=ddlPaymentMode.ClientID%> option:selected").text())))) {                  
                    con = 1;
                }
            });
            if (con == "1") {
                alert('Same Currency already added in same Payment Mode');
                return false;
            }
        }
        if ($.trim($('#<%=txtDisAmount.ClientID%>').val()) > "0" || $.trim($('#<%=txtDisPercent.ClientID%>').val()) > "0") {
            if (($('#<%=ddlApproveBy.ClientID %>').val() == "0")) {
                $('#<%=ddlApproveBy.ClientID %>').focus();
                alert('Please Select Approved By');
                return false;
            }
            if ($.trim($('#<%=txtDiscReason.ClientID %>').val()) == "") {
                $('#<%=txtDiscReason.ClientID %>').focus();
                alert('Please Enter Disc. Reason');
                return false;
            }
        }     
        if (($("#<%=ddlPaymentMode.ClientID%> ").val() != "4") && ($("#<%=txtPaidAmount.ClientID%> ").val() <= "0")) {
            $('#<%=txtPaidAmount.ClientID %>').focus();
            alert('Please Enter Amount');
            return false;
        }
        if (($("span[id*=lblOPDPackage]").length > 0)||($("span[id*=lblOPDLabPrescription]").length > 0)) {
            var amount = parseFloat($("#<%=lblCurrencyBase.ClientID %>").text().split(' '));
            var amount1 = parseFloat($.trim($('#<%=txtPaidAmount.ClientID %>').val()));
            if ((($("#<%=ddlPaymentMode.ClientID%> ").val() != "4")) && (amount < amount1)) {
                alert('Paid amount cannot greater than Balance amount');
                $('#<%=txtPaidAmount.ClientID %>').focus();
                return false;
            }
        }
        
        else if ($("span[id*=lblPanelIDOPDPayment]").length > 0) {
            var amount = parseFloat($("#<%=lblCurrencyBase.ClientID %>").text().split(' '));         
            var amount1 = parseFloat($.trim($('#<%=txtPaidAmount.ClientID %>').val()));
            if ((($("#<%=ddlPaymentMode.ClientID%> ").val() != "4")) && (amount < amount1)) {
                alert('Paid amount cannot greater than Balance amount');
                $('#<%=txtPaidAmount.ClientID %>').focus();
                return false;
            }
        }
        else if ($("span[id*=pnlDirectApp]").length > 0 || $("span[id*=pnlDirectApp]")!=null) {
            var amount = parseFloat($("#<%=lblCurrencyBase.ClientID %>").text().split(' '));          
            var amount1 = parseFloat($.trim($('#<%=txtPaidAmount.ClientID %>').val()));
            if ((($("#<%=ddlPaymentMode.ClientID%> ").val() != "4")) && (amount < amount1)) {
                alert('Paid amount cannot greater than Balance amount');
                $('#<%=txtPaidAmount.ClientID %>').focus();
                return false;
            }
        }
       
    }
    </script>
    <script type="text/javascript" >
    function ValidateDecimal() {
        var DigitsAfterDecimal = 2;
        var val = $("#<%=txtDisPercent.ClientID%>").val();
        var valIndex = val.indexOf(".");
        if (valIndex > "0") {
            if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                alert("Please Enter Valid Discount Percent, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                $("#<%=txtDisPercent.ClientID%>").val($("#<%=txtDisPercent.ClientID%>").val().substring(0, ($("#<%=txtDisPercent.ClientID%>").val().length - 1)))
                return false;
            }
        }
    }
    function ValidateDecimalAmt() {
        var DigitsAfterDecimal = 2;
        var val = $("#<%=txtDisAmount.ClientID%>").val();
        var valIndex = val.indexOf(".");
        if (valIndex > "0") {
            if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                $("#<%=txtDisAmount.ClientID%>").val($("#<%=txtDisAmount.ClientID%>").val().substring(0, ($("#<%=txtDisAmount.ClientID%>").val().length - 1)))
                return false;
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
    function validatedot() {
        if (($("#<%=txtPaidAmount.ClientID%>").val().charAt(0) == ".")) {
            $("#<%=txtPaidAmount.ClientID%>").val('');
            return false;
        }
    }
</script>

<div>
    <div>
        <table cellpadding="0" cellspacing="0" style="width: 100%" runat="server" id="tblPayment">
            <tr>
                <td style="text-align: right;" >
                    <strong>Bill&nbsp;Amount :&nbsp;</strong>
                </td>
                <td style="width: 35%; text-align: left; vertical-align:top" >
                    <asp:TextBox ID="txtBillAmount" ClientIDMode="Static" runat="server" Style="font-weight: 700"
                        CssClass="ItDoseTextinputNum" Text="0" Width="75px"></asp:TextBox>
                    <strong>&nbsp;</strong></td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                   <asp:Label ID="lblGovTaxPercentage" Style="display:none" runat="server"></asp:Label>
                </td>
            </tr>
            <tr id="trDiscRow" runat="server">
                <td style="text-align: right" >
                    Disc. Amount :&nbsp;
                   
                </td>
                <td style="width: 35%; text-align: left">
                    <asp:TextBox ID="txtDisAmount" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum"
                        Width="75px" TabIndex="28" onkeyup="visibleDisAmount();" AutoCompleteType="Disabled"
                        ToolTip="Enter Discount Amount" onkeypress="return checkForSecondDecimal(this,event)"
                        MaxLength="10" />
                    <cc1:FilteredTextBoxExtender ID="fc1" runat="server" TargetControlID="txtDisAmount"
                        ValidChars=".0987654321">
                    </cc1:FilteredTextBoxExtender>
                    <span style="font-size: 10pt; font-family: Arial" id="spnDisper" runat="server">&nbsp; &nbsp; Per. :&nbsp;
                        <asp:TextBox ID="txtDisPercent" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"
                            Width="75px" TabIndex="29" onkeyup="visibleDisPercent();" ToolTip="Enter Discount Percent"
                            AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"
                            MaxLength="10" />
                        <cc1:FilteredTextBoxExtender ID="fc2" runat="server" TargetControlID="txtDisPercent"
                            FilterMode="ValidChars" ValidChars="." FilterType="Numbers,Custom">
                        </cc1:FilteredTextBoxExtender>
                    </span>
                     <asp:Label ID="lblItemDisc" runat="server" Visible="false"></asp:Label>
                </td>
                <td style="width: 10%; text-align:right"  class="a">
                    &nbsp;
                </td>
                <td style="width: 16%; text-align:left"  class="a">
                    &nbsp;
                </td>
            </tr>
            <tr id="trDiscReason" runat="server" class="a">
                <td style="text-align: right;" >
                    Disc. Reason :&nbsp;
                    
                </td>
                <td style="width: 40%; text-align: left;">
                    <asp:TextBox ID="txtDiscReason" runat="server" CssClass="ItDoseTextinputText" TabIndex="31"
                        Width="354px" MaxLength="50"  AutoCompleteType="Disabled"/>
                    <asp:Label ID="v4" runat="server" Style="font-size: 10px; font-family: Verdana;
                        color: Red;" ClientIDMode="Static" Text="*"></asp:Label>
                </td>
                <td style="width: 14%; text-align: right;">
                    Approved By :&nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:DropDownList ID="ddlApproveBy" runat="server" Width="151px" TabIndex="30" />
                    <asp:Label ID="v3" runat="server" Style="font-size: 10px;  font-family: Verdana;
                        color: Red;" ClientIDMode="Static" Text="*"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" >
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Net&nbsp;Bill&nbsp;Amount&nbsp;:&nbsp;</strong>
                </td>
                <td style="width: 35%; text-align: left;" >
                    <asp:TextBox ID="txtNetAmount" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"
                        Width="75px"></asp:TextBox>
                    <strong>&nbsp;</strong></td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    &nbsp;
                </td>
            </tr>
            <tr >
                <td style="text-align: right;display:none" >
                    <strong><asp:Label ID="lblGovTaxPer" runat="server"></asp:Label></strong></td>
                <td style="width: 35%; text-align: left;" colspan="2" >
                    <asp:TextBox ID="txtGovTaxAmt" Style="display:none" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" Width="75px"></asp:TextBox>
                    <strong>&nbsp;Total Paid Amount :&nbsp;<asp:TextBox ID="txtTotalPaidAmount" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"
                        Width="75px"></asp:TextBox>
                    </strong>
                   </td>
                <td style="width: 10%; text-align: right;">
                   <asp:TextBox ID="txtConvertCurrency" Style="display:none" runat="server" Width="30px" Text="0" ClientIDMode="Static"></asp:TextBox></td>
                <td style="width: 36%; text-align: left;">
                    &nbsp;</td>
            </tr>
            <tr>
                <td style="text-align: right;" >
                    Currency :&nbsp;
                </td>
                <td style="width: 40%; text-align: left; vertical-align:top" >
                    <asp:DropDownList ID="ddlCountry" runat="server" Width="100px" TabIndex="32">
                    </asp:DropDownList>
                    <asp:TextBox ID="lblCurrencyNotation" runat="server" Style="display: none;"></asp:TextBox>
                    <asp:Label ID="lblCurrencyBase" runat="server" ClientIDMode="Static" Style="color: Red;
                        font-size: 10px; font-family: Verdana;"></asp:Label>
                    <asp:TextBox ID="txtCurrencyBase" runat="server"  Width="30px"    Style="display: none;" ></asp:TextBox>
                    <asp:Label ID="lblCurrencyRoff" Style="display: none;" runat="server" Text="Currency Round Off"></asp:Label>
                  <asp:Label ID="lblCurrencyRoffAmt"  Style="color: Red;
                        font-size: 10px; font-family: Verdana; display:none" runat="server" Width="20px" ClientIDMode="Static" Text="0"></asp:Label>

                    <asp:TextBox ID="txtCurrencyRoffAmt"  Style="display: none;" runat="server" Width="20px" ClientIDMode="Static" Text="0"></asp:TextBox>
                 </td>
                <td style="width: 10%; text-align: right;">
                    Amount :&nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:TextBox ID="txtPaidAmount" runat="server" AutoCompleteType="Disabled"  Width="80px"
                        TabIndex="33" MaxLength="10" CssClass="ItDoseTextinputNum" ToolTip="Enter Paid Amount"
                        onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="fc3" runat="server" TargetControlID="txtPaidAmount"
                        FilterMode="ValidChars"  FilterType="Numbers">
                    </cc1:FilteredTextBoxExtender>
                    <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    <asp:Label ID="lblBaseCurrency" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblBaseCurrencyID" runat="server" Visible="False"></asp:Label>
                    <asp:RequiredFieldValidator ID="req" runat="server" ControlToValidate="txtPaidAmount"
                        ErrorMessage="Enter Paid Amount" ValidationGroup="add" SetFocusOnError="True"
                        Display="None"></asp:RequiredFieldValidator>
                    
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" >
                    Payment Mode :&nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <asp:DropDownList ID="ddlPaymentMode" runat="server" TabIndex="34" Width="100px"
                        onchange="paymentmode();">
                    </asp:DropDownList>
                </td>
                <td style="width: 10%; text-align: right;">
                    <asp:Label ID="lblBank" runat="server">Bank&nbsp;Name&nbsp;:&nbsp;</asp:Label>
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:DropDownList ID="ddlBank" runat="server" Width="151px" TabIndex="35">
                    </asp:DropDownList>
                    <asp:Label ID="v1" runat="server" Style="font-size: 10px; display: none; font-family: Verdana;
                        color: Red;" ClientIDMode="Static" Text="*"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" >
                    &nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    &nbsp;
                </td>
                <td style="width: 10%; text-align: right;">
                    <asp:Label ID="lblCardNo" runat="server">Card&nbsp;/&nbsp;Ref.&nbsp;No.&nbsp;:&nbsp;</asp:Label>
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:TextBox ID="txtrefNo" runat="server" TabIndex="36" AutoCompleteType="Disabled" MaxLength="30" Width="145px"></asp:TextBox>&nbsp;<asp:Label
                        ID="v2" runat="server" ClientIDMode="Static" Style="font-size: 10px; display: none;
                        font-family: Verdana; color: Red;" Text="*"></asp:Label>
                    <cc1:FilteredTextBoxExtender ID="ftbtrefNo" runat="server" TargetControlID="txtrefNo"
                        FilterType="Numbers">
                    </cc1:FilteredTextBoxExtender>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" >
                    &nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <asp:Button ID="btnAdd" runat="server" Text="Add" ValidationGroup="add" OnClick="btnAdd_Click"
                        TabIndex="37" OnClientClick="return validate();" CssClass="ItDoseButton" />
                </td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td >
                </td>
                <td colspan="3">
                    <asp:GridView ID="grdPaymentMode" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                        TabIndex="21" OnRowCommand="grdPaymentMode_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Payment Mode">
                                <ItemTemplate>
                                    <asp:Label ID="lblPaymentMode" runat="server" Text='<%# Eval("PaymentMode")%>'></asp:Label>
                                    <asp:Label ID="lblPaymentModeID" Visible="false" runat="server" Text='<%# Eval("PaymentModeID")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Paid Amount">
                                <ItemTemplate>
                                    <asp:Label ID="lblAmount" runat="server" Text='<%# Eval("Amount")%>' Width="65px"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Right"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Currency">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblCountryID" runat="server" Text='<%#Eval("CountryID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCFactor" runat="server" Text='<%#Eval("CFactor") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCurrency" runat="server" Text='<%#Eval("Currency") %>' Visible="true"></asp:Label>
                                    <asp:Label ID="lblNotation" runat="server" Text='<%#Eval("Notation") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bank Name"  >
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblBankName" Text='<%#Eval("BankName") %>' runat="server" Width="180px"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                             
                            <asp:TemplateField HeaderText="Card/Ref. No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblRefNo" Text='<%#Eval("RefNo") %>' runat="server" Width="180px"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Base Currency" Visible="false">
                                <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Center"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblBaseCurrency" Text='<%#Eval("BaseCurrency") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="C. Factor" Visible="false">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblConversionFactor" Text='<%#Eval("CFactor") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Base Currency" Visible="false">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblBaseCurrencyAmount" CssClass="ItDoseTextinputNum" Text='<%#Eval("BaseCurrencyAmount") %>'
                                        runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CRoundOff" Visible="false"  >
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblCurrencyRoundOff" CssClass="ItDoseTextinputNum" Text='<%#Eval("CurrencyRoundOff") %>'
                                        runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                               <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                        CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" >
                    &nbsp;</td>
                <td style="width: 35%; text-align: left;">
                    &nbsp;</td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    <strong>Total Amount Paid</strong>&nbsp;:
                    <asp:Label ID="lblTotalPaidAmount" Text="0" runat="server"
                        Style="font-weight: 700"></asp:Label>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" >
                    <span style="font-size: 10pt; font-family: Arial">Remarks :&nbsp; </span>
                </td>
                <td style="width: 35%; text-align: left;">
                  
                    <asp:TextBox ID="txtRemarks" runat="server"  TabIndex="38"
                        Width="370px" MaxLength="50" ToolTip="Enter Remarks"></asp:TextBox>
                </td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    <strong>Balance :
                        <asp:Label ID="lblBalanceAmount" Text="0" CssClass="ItDoseTextinputNum" runat="server"
                            Style="font-weight: 700"></asp:Label>
                        
                    </strong>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" >
                    &nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    &nbsp;
                </td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%; text-align: left; ">
                    <strong>Round Off :
                        <asp:Label ID="lblRoundVal" Text="0" CssClass="ItDoseTextinputNum" runat="server"
                            Style="font-weight: 700;"></asp:Label>
                       
                    </strong>
                </td>
            </tr>
        </table>
    </div>
    &nbsp;
</div>
<div runat="server" id="div_save" visible="false">
    &nbsp;&nbsp;
    <cc1:FilteredTextBoxExtender ID="validateDisPercent" TargetControlID="txtDisPercent"
        runat="server" FilterType="Custom,Numbers" ValidChars="%">
    </cc1:FilteredTextBoxExtender>
</div>

