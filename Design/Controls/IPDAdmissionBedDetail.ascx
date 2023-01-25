<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IPDAdmissionBedDetail.ascx.cs" Inherits="Design_Controls_IPDAdmissionBedDetail" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script type="text/javascript">

    jQuery(function () {
        var refDoctor = $('#td_userControlReferDoctor').html();
        jQuery('#td_userControlReferDoctor').html('');
        jQuery('#td_DirectRefDoc').html(refDoctor);
       
        var ParentPanel = $('#td_userControlParentPanel').html();
        jQuery('#td_userControlParentPanel').html('');
        jQuery('#td_ParentPanel').html(ParentPanel);
        jQuery('#ddlParentPanel').attr('tabIndex', 51);

        $('#ddlReferDoctor').searchable();
        var TID = '<%=Util.GetString(Request.QueryString["TID"])%>';
        if (TID == "") {
            bindRoomType();
            bindBillingCategory();
            bindAdmissionType();
            //  bindReferDoctor();
            bindAdmissionPanel();
            bindCardHolderRelation();
            checkCreditLimit();
            BindProName();
        }
       
        bindAdmissionDoctor();
        CheckPolicy();
        isIgnore();

    });
    function CheckPolicy() {
        if (jQuery('#chkPolicy').is(':checked')) {
            jQuery('#txtPolicyno').show();
            jQuery('#ddlPolicy').hide();
        }
        else {
            jQuery('#txtPolicyno').show();
        }
    }
    function checkCreditLimit() {
        // if (jQuery('#ddlAdmissionPanel').val().split('#')[0] == '<%=Resources.Resource.DefaultPanelID%>') {
        //     jQuery('#chkCardno').prop('checked', true).attr('disabled', true);
        //     isIgnore();
        //     jQuery('#rdoAdAmt,#rdoAdPer,#txtAdPanelCredit').attr('disabled', true);
        //     jQuery('#txtAdPanelCredit').val('');
        // }
        // else {
        //     jQuery('#chkCardno').prop('checked', false).attr('disabled', false);
        //     jQuery('#txtIgnoringPolicy').val('');
        //     isIgnore();
        //     jQuery('#rdoAdAmt,#rdoAdPer,#txtAdPanelCredit').attr('disabled', false);


        // }
        if ((jQuery('#ddlAdmissionPanel').val().split('#')[2] == 0) || (jQuery('#ddlAdmissionPanel').val().split('#')[0] == '<%=Resources.Resource.DefaultPanelID%>')) {
            jQuery('#rdoAdAmt,#rdoAdPer,#txtAdPanelCredit').attr('disabled', true);
            jQuery('#chkCardno').prop('checked', true).attr('disabled', true);
            jQuery('#txtAdPanelCredit').val('');
        }

        else {
            jQuery('#chkCardno').prop('checked', false).attr('disabled', false);
            jQuery('#chkCardno').prop('checked', false).attr('disabled', false);
            jQuery('#rdoAdAmt,#rdoAdPer,#txtAdPanelCredit').attr('disabled', false);
            jQuery('#txtIgnoringPolicy').val('');
        }
        
        chkCreditType();
        getPanelCreditlimt();
       
       
       // isIgnore();
       
    }
    function isIgnore() {
        if (jQuery('#chkCardno').is(':checked')) {
            jQuery('#txtCarHolderName,#txtCardNo,#ddlRelationCardHolder,#ddlPolicy,#chkPolicy,#txtPolicyno,#txtPolicyExpieryDate').attr('disabled', true);
            jQuery('#txtCarHolderName,#txtCardNo,#ddlRelationCardHolder,#txtIgnoringPolicy,#txtPolicyno,#txtPolicyExpieryDate').val('');
            jQuery("#ddlRelationCardHolder,#ddlPolicy").find('option[value=0]').attr('selected', true);
            jQuery('#chkPolicy').prop('checked', false);
            if (jQuery('#ddlAdmissionPanel').val().split('#')[0] == '<%=Resources.Resource.DefaultPanelID%>') {
                jQuery('#txtIgnoringPolicy').val('In Case of Cash Panel No Policy Detail Needed').attr('disabled', false);
            }
            else
                jQuery('#txtIgnoringPolicy').val(' ').attr('disabled', false);
        }
        else {
            jQuery('#txtCarHolderName,#txtCardNo,#ddlRelationCardHolder,#ddlPolicy,#chkPolicy,#txtPolicyno,#txtPolicyExpieryDate').attr('disabled', false);
            // jQuery('#txtCarHolderName,#txtCardNo,#ddlRelationCardHolder,#txtIgnoringPolicy,#txtPolicyno,#txtPolicyExpieryDate').val('');
            // jQuery("#ddlRelationCardHolder,#ddlPolicy").find('option[value=0]').attr('selected', true);
            jQuery('#txtIgnoringPolicy').val(' ').attr('disabled', true);
        }
    }

    function bindRoomType() {
        jQuery("#ddlRomType option").remove();
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/bindRoomType",
            data: '{}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                Data = jQuery.parseJSON(result.d);
                jQuery("#ddlRomType").append(jQuery("<option></option>").val("0").html("Select"));
                jQuery("#ddlRqstRoomType").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < Data.length; i++) {
                    jQuery("#ddlRomType").append(jQuery("<option></option>").val(Data[i].IPDCaseType_ID).html(Data[i].Name));
                    jQuery("#ddlRqstRoomType").append(jQuery("<option></option>").val(Data[i].IPDCaseType_ID).html(Data[i].Name));
                }
            },
            error: function (xhr, status) {
            }
        });
    }
    function bindBillingCategory() {
        jQuery("#ddlRoomBilling option").remove();
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/bindBillingCategory",
            data: '{}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                Data = jQuery.parseJSON(result.d);
                jQuery("#ddlRoomBilling").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < Data.length; i++) {
                    jQuery("#ddlRoomBilling").append(jQuery("<option></option>").val(Data[i].IPDCaseType_ID).html(Data[i].Name));
                }
            },
            error: function (xhr, status) {
            }
        });
    }
    function bindRoomBed() {
        jQuery("#ddlRoomNo option").remove();
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/bindRoomBed",
            data: '{caseType:"' + jQuery('#ddlRomType').val() + '",IsDisIntimated:"0"}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                Data = jQuery.parseJSON(result.d);
                if (Data != null) {
                    if (Data != '') {
                        jQuery("#ddlRoomNo").append(jQuery("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Data.length; i++) {
                            jQuery("#ddlRoomNo").append(jQuery("<option></option>").val(Data[i].Room_Id).html(Data[i].Name));
                        }
                        jQuery("#ddlRoomNo").removeAttr('disabled');
                    }
                }
                else {
                    jQuery("#ddlRoomNo").append(jQuery("<option></option>").val("0").html("--No Room Available--"));
                }
            },
            error: function (xhr, status) {
            }
        });
    }
    function bindAdmissionType() {

        jQuery("#ddlAdmissionType option").remove();
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/AdmissionType",
            data: '{}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                Data = jQuery.parseJSON(result.d);
                jQuery("#ddlAdmissionType").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < Data.length; i++) {
                    jQuery("#ddlAdmissionType").append(jQuery("<option></option>").val(Data[i].ADMISSIONTYPE).html(Data[i].ADMISSIONTYPE));
                }
            },
            error: function (xhr, status) {
            }
        });
    }
    function bindAdmissionDoctor() {
        jQuery("#ddlDoctorAdmision option").remove();
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/bindAdmissionDoctor",
            data: '{}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                Data = jQuery.parseJSON(result.d);
                jQuery("#ddlDoctorAdmision").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < Data.length; i++) {
                    jQuery("#ddlDoctorAdmision").append(jQuery("<option></option>").val(Data[i].DoctorID).html(Data[i].Name));
                }
            },
            error: function (xhr, status) {
            }
        });
    }

    function bindAdmissionPanel() {
        jQuery("#ddlAdmissionPanel option").remove();
        jQuery("#ddlParentPanel option").remove();
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/bindPanel",
            data: '{}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                panel = jQuery.parseJSON(result.d);
                if (panel != null) {
                    if (panel != '') {
                        for (i = 0; i < panel.length; i++) {
                            jQuery("#ddlAdmissionPanel").append(jQuery("<option></option>").val(panel[i].PanelID + "#" + panel[i].ReferenceCode + "#" + panel[i].applyCreditLimit).html(panel[i].Company_Name));
                            jQuery("#ddlParentPanel").append(jQuery("<option></option>").val(panel[i].PanelID).html(panel[i].Company_Name));
                        }
                        jQuery("#ddlAdmissionPanel").val('<%=Resources.Resource.DefaultPanelID %>' + '#' + '<%=Resources.Resource.DefaultPanelID %>' + "#" + '1');
                        jQuery("#ddlParentPanel").val('<%=Resources.Resource.DefaultPanelID %>');
                    }
                }
                else {
                    jQuery("#ddlAdmissionPanel,#ddlParentPanel").append(jQuery("<option></option>").val("0").html("--No Panel Found--"));
                }
            },
            error: function (xhr, status) {
            }
        });

    }
    function bindCardHolderRelation() {
        jQuery("#ddlRelationCardHolder option").remove();
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/bindCarHolderRelation",
            data: '{}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                Relation = jQuery.parseJSON(result.d);
                jQuery("#ddlRelationCardHolder").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < Relation.length; i++) {
                    jQuery("#ddlRelationCardHolder").append(jQuery("<option></option>").val(Relation[i]).html(Relation[i]));
                }
            },
            error: function (xhr, status) {
            }
        });
    }

    function checkForSecondDecimalCreditCR(sender, e) {
        var charCode = (e.which) ? e.which : e.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        formatBox = document.getElementById(sender.id);
        strLen = sender.value.length;
        strVal = sender.value;
        if ((strVal == "0") && (charCode == 48)) {
            strVal = Number(strVal);
            sender.value = sender.value.substring(0, (sender.value.length - 1));

        }
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
    function chkCreditPer() {
        if (jQuery("#rdoAdPer").is(':checked') && (Number(jQuery("#txtAdPanelCredit").val()) > 100)) {
            alert('Please Enter Valid Percentage');
            jQuery("#txtAdPanelCredit").val('');
            return;
        }
    }

    function chkCreditType() {
        if (jQuery("#ddlAdmissionPanel").length > 0) {
            if ((jQuery("#ddlAdmissionPanel").val().split('#')[2] === "0"))
                jQuery("#txtAdPanelCredit").val('').attr('disabled', 'disabled');
            else {
                jQuery("#txtAdPanelCredit").val('0').removeAttr('disabled');
               // if (jQuery('input[name=IPDPanelCreditType]:checked').val() == jQuery("#spnCreditlimitType").text()) {
               //     jQuery("#txtAdPanelCredit").val(jQuery("#spnCreditLimitAmt").text());
               // }
            }
        }
        else {

            if ((jQuery("#ddlAdmissionPanel").val().split('#')[2] === "0"))
                jQuery("#txtAdPanelCredit").val('').attr('disabled', 'disabled');
            else {
                jQuery("#txtAdPanelCredit").val('0').removeAttr('disabled');
               // if (jQuery('input[name=IPDPanelCreditType]:checked').val() == jQuery("#spnCreditlimitType").text()) {
               //     jQuery("#txtAdPanelCredit").val(jQuery("#spnCreditLimitAmt").text());
               // }
            }
        }
    }
    function getPanelCreditlimt() {
        if ((jQuery("#ddlAdmissionPanel").val().split('#')[2] == "0")) {
            jQuery("#txtAdPanelCredit").val('').attr('disabled', 'disabled');
            jQuery("#rdoAdAmt,#rdoAdPer").attr('disabled', 'disabled');
            // jQuery('#chkCardno').prop('checked', true);
            isIgnore();
        }
        else {
            jQuery("#txtAdPanelCredit").val('0').removeAttr('disabled');
            jQuery("#rdoAdAmt,#rdoAdPer").removeAttr('disabled');
            //  jQuery('#chkCardno').prop('checked', false);
            isIgnore();
            var TID = '<%=Util.GetString(Request.QueryString["TID"])%>';
                jQuery.ajax({
                    url: "Services/IPDAdmission.asmx/getPanelCreditLimit",
                    data: '{ PanelID: "' + jQuery("#ddlAdmissionPanel").val().split('#')[0] + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d != "") {
                            var PanelCreditLimit = result.d;
                            if (PanelCreditLimit.split('#')[1] != "") {
                                jQuery("#txtAdPanelCredit").val(PanelCreditLimit.split('#')[1]).removeAttr('disabled');
                                if (TID == "")
                                    jQuery("#spnCreditLimitAmt").text(PanelCreditLimit.split('#')[1]);
                            }
                            else {
                                jQuery("#txtAdPanelCredit").val('0').attr('disabled', false);
                                if (TID == "") {
                                    jQuery("#spnCreditLimitAmt").text('0');
                                   
                                }
                            }
                            if (PanelCreditLimit.split('#')[0] == "A") {
                                jQuery("#spnCreditlimitType").text('A');
                                jQuery("#rdoAdAmt").prop('checked', 'checked');
                                jQuery("#rdoAdPer").prop('checked', false).attr('disabled', 'disabled');
                            }
                            else {
                                jQuery("#spnCreditlimitType").text('P');
                                jQuery("#rdoAdPer").prop('checked', 'checked');
                                jQuery("#rdoAdAmt").prop('checked', false).attr('disabled', 'disabled');
                            }
                        }
                        else {
                            jQuery("#txtAdPanelCredit").val('').removeAttr('disabled', 'disabled');
                            jQuery("#rdoAdPer,#rdoAdAmt").removeAttr('disabled', 'disabled');


                        }
                    },
                    error: function (xhr, status) {

                    }

                });
               
                if (TID != "") {
                    
                    if ((jQuery("#spnCreditLimitAmt").text() != "") && (jQuery("#spnCreditLimitAmt").text() > 0) && (jQuery("#spnIPDPanelID").text().split('#')[0] == jQuery("#ddlAdmissionPanel").val().split('#')[0])) {
                    
                        jQuery("#txtAdPanelCredit").val(jQuery("#spnCreditLimitAmt").text());
                        if (jQuery("#spnCreditlimitType").text() == "A")
                            jQuery("#rdoAdAmt").prop('checked', 'checked');
                        else
                            jQuery("#rdoAdPer").prop('checked', 'checked');
                    }
                }
                
            }

        
            
        }

    function getPatientAllPolicyNo() {

        jQuery("#ddlPolicy option").remove();
        if ((jQuery.trim(jQuery("#txtPID").val()) != "") && (jQuery("#ddlAdmissionPanel").val().split('#')[2] == "1")) {
            jQuery("#ddlPolicy").removeAttr('disabled');
            jQuery("#spnPolicyExpieryDate").text('');
            jQuery.ajax({
                url: "../Common/CommonService.asmx/getPatientAllPolicyNo",
                data: '{ PanelID: "' + jQuery("#ddlAdmissionPanel").val().split('#')[0] + '",PatientID:"' + jQuery.trim(jQuery("#txtPID").val()) + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    policyNo = jQuery.parseJSON(result.d);
                    jQuery("#ddlPolicy").append(jQuery("<option></option>").val("0" + "#" + "0").html("Select"));
                    if (policyNo != null) {
                        for (i = 0; i < policyNo.length; i++) {
                            jQuery("#ddlPolicy").append(jQuery("<option></option>").val(policyNo[i].PolicyExpiry + "#" + policyNo[i].PolicyExpired).html(policyNo[i].PolicyNo));
                            if (policyNo[i].PolicyExpired == "1") {

                                jQuery('#ddlPolicy option[value="' + policyNo[i].PolicyExpiry + "#" + policyNo[i].PolicyExpired + '"]').attr('disabled', true);
                            }
                        }
                    }
                },
                error: function (xhr, status) {

                }

            });
        }
    }

    function getPanelDocumentID() {
        jQuery.ajax({
            url: "../Common/CommonService.asmx/bindPanelDocumentID",
            data: '{ PanelID: "' + jQuery("#ddlAdmissionPanel").val().split('#')[0] + '"}',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            async: false,
            success: function (result) {
                PanelDocumentID = jQuery.parseJSON(result.d);
                if (PanelDocumentID != null) {
                    jQuery('spnPanelDocumentID').text(PanelDocumentID);
                }
            },
            error: function (xhr, status) {

            }

        });
    }

    function BindProName() {
        jQuery("#ddlProName option").remove();
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/bindProMaster",
            data: '{}',
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                PROData = jQuery.parseJSON(result.d);
                jQuery("#ddlProName").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < PROData.length; i++) {
                    jQuery("#ddlProName").append(jQuery("<option></option>").val(PROData[i].pro_id).html(PROData[i].ProName));
                }
            },
            error: function (xhr, status) {
            }
        });
    }

</script>

<script type="text/javascript">
    function chkValidation() {
        var Val = 0;

        if (jQuery("#spnAdvanceRoomBooking").length == 0) {
            if (jQuery.trim(jQuery('#txtPFirstName').val()).length == 0) {
                jQuery('#spnErrorMsg').text('Please Enter First Name');
                jQuery('#txtPFirstName').focus();
                Val = 1;
                return false;
            }
            if ((jQuery('#rdoDOB').prop("checked")) && (jQuery.trim(jQuery('#txtDOB').val()).length == 0)) {
                jQuery('#spnErrorMsg').text('Please Enter Date Of Birth');
                jQuery('#txtDOB').focus();
                Val = 1;
                return false;
            }
            if ((jQuery('#rdoAge').prop("checked")) && (jQuery('#txtAge').val().length == 0)) {
                jQuery('#spnErrorMsg').text('Please Enter Age');
                jQuery('#txtAge').focus();
                Val = 1;
                return false;
            }
            if (jQuery.trim(jQuery('#txtMobile').val()).length == 0) {
                jQuery('#spnErrorMsg').text('Please Enter Contact No');
                jQuery('#txtMobile').focus();
                Val = 1;
                return false;

            }
            if (jQuery.trim(jQuery('#txtMobile').val()).length > 0) {
                if (jQuery.trim(jQuery('#txtMobile').val()).length < "10") {
                    jQuery('#spnErrorMsg').text('Please Enter Valid Contact No.');
                    jQuery('#txtMobile').focus();
                    Val = 1;
                    return false;
                }
            }
            var emailaddress = jQuery.trim(jQuery('#txtEmailAddress').val());
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                jQuery('#spnErrorMsg').text('Please Enter Valid Email Address');
                jQuery('#txtEmailAddress').focus();
                Val = 1;
                return false;
            }
            if ((jQuery('#ddlRelation option:selected').text() != "Self") && (jQuery.trim(jQuery('#txtRelationName').val()).length == 0)) {
                jQuery('#spnErrorMsg').text('Please Enter Relation Name');
                jQuery('#txtRelationName').focus();
                Val = 1;
                return false;
            }
            if ((jQuery('#ddlRelation option:selected').text() != "Self") && ((jQuery.trim(jQuery('#txtKinContactNo').val()).length == 0) || (jQuery.trim(jQuery('#txtKinContactNo').val()).length < "10"))) {
                jQuery('#spnErrorMsg').text('Please Enter Relation Contact No.');
                jQuery('#txtKinContactNo').focus();
                Val = 1;
                return false;
            }
            if (jQuery('#ddlCountry').val() == "0") {
                jQuery('#spnErrorMsg').text('Please Select Country');
                jQuery('#ddlCountry').focus();
                Val = 1;
                return false;
            }
            if (jQuery('#ddlDistrict').val() == "0") {
                jQuery('#spnErrorMsg').text('Please Select District');
                jQuery('#ddlDistrict').focus();
                Val = 1;
                return false;
            }

            if (jQuery('#ddlCity').val() == "0") {
                jQuery('#spnErrorMsg').text('Please Select  City');
                jQuery('#ddlCity').focus();
                Val = 1;
                return false;
            }
           // if (jQuery('#ddlTaluka').val() == "0") {
           //     jQuery('#spnErrorMsg').text('Please Select Taluka');
           //     jQuery('#ddlTaluka').focus();
           //     Val = 1;
           //     return false;
          //  }
            if (!jQuery('input:radio[name=sex]').is(':checked')) {
                jQuery('#spnErrorMsg').text('Please Select The Gender of the Patient');
                jQuery('#rdoMale').focus();
                Val = 1;
                return false;
            }

            if (jQuery('#txtAdmissionTime').val() == "00:00 AM") {
                jQuery('#spnErrorMsg').text('Please Enter Correct Time');
                jQuery('#txtAdmissionTime').focus();
                Val = 1;
                return false;
            }

            if (jQuery('#ddlAdmissionType').val() == "0") {
                jQuery('#spnErrorMsg').text('Please Select Admission Type');
                jQuery('#ddlAdmissionType').focus();
                Val = 1;
                return false;
            }
            if (jQuery('#ddlAdmissionType').val() == "MLC CASE") {
                if (jQuery('#txtMLCNo').val() == "" || jQuery('#ddlMLCType').val() == 0) {
                    jQuery('#spnErrorMsg').text('Please Enter MLC No. And Select MLC Type');
                    jQuery('#txtMLCNo').focus();
                    Val = 1;
                    return false;
                }
            }

            if (jQuery("#tb_grdDoctorSearch tr").length == "1") {
                jQuery('#spnErrorMsg').text('Please Add At least one Doctor');
                jQuery('#ddlDoctorAdmision').focus();
                Val = 1;
                return false;
            }

            //For other room  request
            if (jQuery('#chkIsRqstRoom').is(':checked') && jQuery('#ddlRqstRoomType option:selected').text() == "Select") {
                jQuery('#spnErrorMsg').text("Please Select Requested Room Type");
                jQuery('#ddlRqstRoomType').focus();
                Val = 1;
                return false;
            }
        }
        else {
            if (jQuery('#ddlDoctorAdmision option:selected').text() == "Select") {
                jQuery('#spnErrorMsg').text('Please Select Doctor');
                jQuery('#ddlDoctorAdmision').focus();
                Val = 1;
                return false;
            }
        }

        if (jQuery('#ddlRomType option:selected').text() == "Select") {
            jQuery('#spnErrorMsg').text('Please Select  Room Type');
            jQuery('#ddlRomType').focus();
            Val = 1;
            return false;
        }

        if (jQuery('#ddlRoomNo').val() == "0") {
            jQuery('#spnErrorMsg').text('Please Select  Room No.');
            jQuery('#ddlRoomNo').focus();
            Val = 1;
            return false;
        }

        if (jQuery('#ddlRoomBilling option:selected').text() == "Select") {
            jQuery('#spnErrorMsg').text('Please Select  Room Billing Type');
            jQuery('#ddlRoomBilling').focus();
            Val = 1;
            return false;
        }
        if (jQuery('#ddlAdmissionPanel option:selected').text() == "Select") {
            jQuery('#spnErrorMsg').text('Please Select Panel');
            jQuery('#ddlAdmissionPanel').focus();
            Val = 1;
            return false;
        }

        if (jQuery("#ddlAdmissionPanel").val().split('#')[0] != "1") {
            if (jQuery('#chkCardno').is(':checked')) {
                if (jQuery.trim(jQuery('#txtIgnoringPolicy').val()).length == 0) {
                    jQuery('#spnErrorMsg').text('Please Enter The Reason');
                    jQuery('#txtIgnoringPolicy').focus();
                    Val = 1;
                    return false;
                }
            }
            else {
                if (jQuery.trim(jQuery('#txtCardNo').val()).length == 0) {
                    jQuery('#spnErrorMsg').text('Please Enter The Card No.');
                    jQuery('#txtCardNo').focus();
                    Val = 1;
                    return false;
                }
                if (jQuery.trim(jQuery('#txtCarHolderName').val()).length == 0) {
                    jQuery('#spnErrorMsg').text('Please Enter The Card Holder Name');
                    jQuery('#txtCarHolderName').focus();
                    Val = 1;
                    return false;
                }
                if (jQuery('#ddlRelationCardHolder option:selected').text() == "Select") {
                    jQuery('#spnErrorMsg').text('Please Select Card Holder');
                    jQuery('#ddlRelationCardHolder');
                    Val = 1;
                    return false;
                }
            }
        }
        return true;
    }
    //   }

</script>
<script type="text/javascript">
    function AddDoctor() {
        var DocName = jQuery("#ddlDoctorAdmision option:selected").text();
        var DocID = jQuery("#ddlDoctorAdmision").val();

        if (DocID != 0) {
            RowCount = jQuery("#tb_grdDoctorSearch tr").length;
            RowCount = RowCount + 1;

            var AlreadySelect = 0;
            if (RowCount > 2) {

                jQuery("#tb_grdDoctorSearch tr").each(function () {
                    if (jQuery(this).attr("id") == 'tr_' + DocID) {
                        AlreadySelect = 1;
                        return;
                    }
                });
            }

            if (AlreadySelect == "0") {
                var newRow = jQuery('<tr />').attr('id', 'tr_' + DocID)
                newRow.html('<td class="GridViewLabItemStyle" style="display:none;">' + (RowCount - 1) +
                     '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_DocID >' + DocID +
                     '</td><td class="GridViewLabItemStyle" style="text-align:centre" id=td_DocName >' + DocName +
                     '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Remove" /></td>'
                    );
                jQuery("#tb_grdDoctorSearch").append(newRow);
                jQuery("#tb_grdDoctorSearch").show();
            }
            else {
                jQuery("#spnMsg").text('Item Already Selected');
                alert('Doctor Already Selected');
            }

        }
        else {
            alert('Please Select Proper Doctor');
        }
    }

    function DeleteRow(rowid) {
        var row = rowid;
        jQuery(row).closest('tr').remove();
    }

    function chngcur() {
        document.body.style.cursor = 'pointer';

    }
    function validation(keyCode) {
        var Hours = jQuery("#<%=txtHr.ClientID %>").val();
        if (Hours < 0 || Hours > 12) {
            alert("Must enter a time between 0-12 hours");
            getHours();
            jQuery("#<%=txtHr.ClientID %>").focus();
            return false;
        }
    }
    function validationMin(keyCode) {
        var Hours = jQuery("#<%=txtMin.ClientID %>").val();
        if (Hours < 0 || Hours > 60) {
            alert("Must enter a time between 0-60 minutes");
            getMintus();
            jQuery("#<%=txtMin.ClientID %>").focus();
            return false;
        }
    }
    function getHours() {
        jQuery.ajax({
            url: "../Common/CommonService.asmx/getHours",
            data: '{}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                jQuery("#<%=txtHr.ClientID %>").val(data);
                return;
            }
        });
    }
    function getMintus() {
        jQuery.ajax({
            url: "../Common/CommonService.asmx/getMintus",
            data: '{}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                jQuery("#<%=txtMin.ClientID %>").val(data);
                return;
            }
        });
    }
</script>
<script type="text/javascript">
    //For other room  request
    function isRequestRoomType() {
        if (jQuery('#chkIsRqstRoom').is(':checked')) {
            jQuery("#spnRoomTypeHeader,#ddlRqstRoomType,#spnRoomTypeError").show();
        }
        else {
            jQuery("#spnRoomTypeHeader,#ddlRqstRoomType,#spnRoomTypeError").hide();
        }
    }
    function ShowMLC() {
        if (jQuery('#ddlAdmissionType').val() == "MLC CASE") {
            jQuery('#txtMLCNo,#spnMLCNo,#ddlMLCType,#spnMlcType,#mlcclass1,#mlcclass').show();
        }
        else {
            jQuery('#txtMLCNo,#spnMLCNo,#ddlMLCType,#spnMlcType,#mlcclass1,#mlcclass').hide();
        }
    }
</script>

<div id="PatientDetails">
    <div class="POuter_Box_Inventory" style="text-align: left">
        <div class="Purchaseheader">
            Admission Details
        </div>
        <table style="width: 100%; border-collapse: collapse;">
            <tr>
                <td style="text-align: right; width: 16%">Admission Date :&nbsp;</td>
                <td style="text-align: left; width: 34%">
                    <asp:TextBox ID="txtAdmissionDate" runat="server" ClientIDMode="Static" ToolTip="Select Admission Date" TabIndex="37"></asp:TextBox>
                    <span style="color: red; font-size: 10px;" id="spnDOB">*</span>
                    <cc1:CalendarExtender ID="CalendarExteAdmission" TargetControlID="txtAdmissionDate" Format="dd-MMM-yyyy"
                        runat="server">
                    </cc1:CalendarExtender>
                </td>

                <td style="text-align: right; width: 18%">
                    <span id="spnAdmissionTime">Admission Time :&nbsp;</span></td>
                <td style="text-align: left; width: 32%"><%--<asp:TextBox ID="txtAdmissionTime" runat="server" Width="80px" ClientIDMode="Static" TabIndex="18"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="meetxtAdmissionTime" Mask="99:99" TargetControlID="txtAdmissionTime"
                                    AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="metxtAdmissionTime" ControlExtender="meetxtAdmissionTime"
                                    ControlToValidate="txtAdmissionTime" InvalidValueMessage="Invalid Time" Font-Bold="true" ForeColor="Red"></cc1:MaskedEditValidator>--%>
                    <asp:TextBox ID="txtHr" runat="server" MaxLength="2" Width="19px" onkeypress="if(event.keyCode<48 || event.keyCode>57)event.returnValue=false;"
                        onkeyup="validation(event.keyCode)" onpaste="return false" TabIndex="38" ClientIDMode="Static"></asp:TextBox>
                    <asp:TextBox ID="txtMin" runat="server" MaxLength="2" Width="19px" onkeypress="if(event.keyCode<48 || event.keyCode>57)event.returnValue=false;"
                        onkeyup="validationMin(event.keyCode)" onpaste="return false" TabIndex="39" ClientIDMode="Static"></asp:TextBox>
                    <asp:DropDownList ID="cmbAMPM" runat="server" TabIndex="40" ClientIDMode="Static">
                        <asp:ListItem Value="AM">AM</asp:ListItem>
                        <asp:ListItem Value="PM">PM</asp:ListItem>
                    </asp:DropDownList>

                </td>
            </tr>
            <tr>
                <td style="text-align: right; width: 16%">Room Type :&nbsp;</td>
                <td style="text-align: left; width: 34%">
                    <select id="ddlRomType" style="width: 225px" onchange="bindRoomBed();SelectRoomBilling();" tabindex="41"></select>
                    <span class="shat" style="color: red; font-size: 10px;">*</span>
                </td>

                <td style="text-align: right; width: 18%">Room/BedNo :&nbsp;</td>
                <td style="text-align: left; width: 32%">
                    <select id="ddlRoomNo" style="width: 225px;" disabled="disabled" tabindex="42"></select>
                    <span class="shat" style="color: red; font-size: 10px;">*</span></td>
            </tr>
            <tr>
                <td style="text-align: right; width: 16%">Billing Category :&nbsp</td>

                <td style="text-align: left; width: 34%">
                    <select id="ddlRoomBilling" style="width: 225px" tabindex="43"></select>
                    <span class="shat" style="color: red; font-size: 10px;">*</span>
                </td>

                <td style="text-align: right; width: 18%"><span id="spnAdmissionType">Admission Type :&nbsp;</span></td>
                <td style="width: 32%">
                    <select id="ddlAdmissionType" style="width: 225px" tabindex="45" onchange="ShowMLC()"></select>&nbsp;<span id="spnAdmissionError" class="shat" style="color: red; font-size: 10px;">*</span></td>
            </tr>

            <tr id="tdReferedSource">
                <td style="text-align: right; width: 16%">Refered Source :&nbsp;</td>
                <td style="text-align: left; width: 34%">
                    <select id="ddlPatienttype" style="width: 225px; display: none"></select><select id="ddlReferSource" style="width: 225px" tabindex="45" name="D1"><option value="Select">Select</option>
                        <option value="OPD">OPD</option>
                        <option value="Emergency">Emergency</option>
                        <option value="OutSide">OutSide</option>
                    </select></td>

                <td style="text-align: right; width: 18%"><span id="spnMLCNo" >MLC NO. :&nbsp;</span></td>
                <td style="text-align: left; width: 32%">
                    <input type="text" id="txtMLCNo" style="width: 72px" /><span class="shat" id="mlcclass1" style="color: red; font-size: 10px; display: none">*</span>&nbsp;<span id="spnMlcType" style="display: none">Type :&nbsp;</span>
                    <select id="ddlMLCType" style="width: 72px">
                        <option value="0">Select</option>
                        <option value="RTA">RTA</option>
                        <option value="Poisoining">Poisoining</option>
                        <option value="Burns">Burns</option>
                        <option value="Hanging">Hanging</option>
                        <option value="Assaults">Assaults</option>
                    </select><span class="shat" id="mlcclass" style="color: red; font-size: 10px; display: none">*</span></td>
            </tr>
            <tr id="trRoomRequest">
                <td style="text-align: right; width: 16%">Room Request :&nbsp</td>
                <td style="text-align: left; width: 34%">
                    <input type="checkbox" id="chkIsRqstRoom" onchange="isRequestRoomType();" tabindex="46" />

                <td style="text-align: right; width: 18%"><span id="spnRoomTypeHeader" style="display: none;">Req. RoomType :&nbsp;</span></td>
                <td style="width: 32%">
                    <select id="ddlRqstRoomType" style="width: 225px; display: none;" tabindex="47"></select>&nbsp;<span id="spnRoomTypeError" class="shat" style="color: red; font-size: 10px; display: none;">*</span>
                </td>
            </tr>
            <tr>
                <td style="text-align: right; width: 16%">Pro Name :&nbsp</td>
                <td style="text-align: left; width: 34%">
                    <table style="width: 100%; border-collapse: collapse;">
                        <tr>
                            <td style="width: 40%;">
                                <select id="ddlProName" style="width: 225px" tabindex="48" class="searchable"></select>

                            </td>
                            <td style="text-align: left">
                                <input id="btnNewPRO" class="ItDoseButton" onclick="ShowPRO()" title="Click to Create New Pro" type="button" value="New" />
                            </td>
                        </tr>
                    </table>
                </td>

                <td style="text-align: right; width: 18%">Refer By :&nbsp</td>
                <td style="width: 32%; text-align: left" id="td_DirectRefDoc">
                    <%--<select id="ddlReferBy" style="width: 225px" tabindex="50" class="searchable"></select>--%></td>
            </tr>
            <tr>
                <td style="text-align: right; width: 16%">Doctor :&nbsp</td>
                <td style="width: 34%; text-align: left">
                    <table style="width: 100%; border-collapse: collapse;">
                        <tr>
                            <td style="width: 40%;">
                                <select id="ddlDoctorAdmision" style="width: 225px" tabindex="48" class="searchable"></select>
                                <span style="color: red; font-size: 10px;" class="shat" id="split"></span>
                            </td>
                            <td>
                                <input type="button" value="Add" tabindex="49" class="ItDoseButton" onclick="AddDoctor();" /></td>
                        </tr>
                    </table>
                </td>
                <td style="text-align: right; width: 18%">&nbsp;
                </td>
                <td style="width: 32%; text-align: left">&nbsp;</td>
            </tr>
        </table>
        <table style="width: 100%; border-collapse: collapse">
            <tr style="text-align: center">
                <td>
                    <table class="GridViewStyle" rules="all" border="1" id="tb_grdDoctorSearch"
                        style="width: 50%; border-collapse: collapse; display: none; height: 2px; overflow: scroll">
                        <tr id="Header">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none">S.No.
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none">Doctor ID
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Doctor Name
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 5px;">Remove
                            </th>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div class="POuter_Box_Inventory" style="text-align: left">
        <div class="Purchaseheader">
            Panel Details
        </div>
        <table style="width: 100%; border-collapse: collapse;">
            <tr>
                <td style="text-align: right; width: 16%">Parent Panel :&nbsp</td>
                <td style="width: 34%" id="td_ParentPanel">
                    

                </td>
                <td style="text-align: right; width: 15%">Panel :&nbsp</td>
                <td style="width: 35%">
                    <select id="ddlAdmissionPanel" style="width: 225px" tabindex="52" onchange="checkCreditLimit()"></select>
                    <span class="shat" style="color: red; font-size: 10px;">*</span><span id="spnSchedulechargeID"></span></td>
            </tr>
            <tr>
                <td style="text-align: right; width: 16%">
                    <input type="checkbox" id="chkPolicy" onclick="CheckPolicy()" style="display: none" />Policy No. :&nbsp</td>
                <td style="width: 34%">
                    <select id="ddlPolicy" disabled="disabled" style="width: 225px; display: none"></select><input type="text" id="txtPolicyno" title="Enter Policy No." tabindex="53" /><asp:TextBox ID="txtPolicyExpieryDate" runat="server" Style="width: 80px;" ClientIDMode="Static" TabIndex="54" ToolTip="Select Policy Expiery Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="calpolicyexpiery" TargetControlID="txtPolicyExpieryDate" Format="dd-MMM-yyyy"
                        runat="server">
                    </cc1:CalendarExtender>
                    <span id="spnPolicyExpieryDate"></span><span class="shat" style="color: red; font-size: 10px;">*</span></td>
                <td style="text-align: right; width: 18%">Credit limit :&nbsp</td>
                <td style="width: 32%; text-align: left;" id="td_CreditType">
                    <input type="radio" id="rdoAdAmt" tabindex="30" value="A" checked="checked" disabled="disabled" name="IPDPanelCreditType" onclick="chkCreditType()" />Amt.
                            <input type="radio" id="rdoAdPer" tabindex="31"  value="P" name="IPDPanelCreditType" disabled="disabled" onclick="chkCreditType()" />Per. 
                           &nbsp;
                    <input type="text" tabindex="32" id="txtAdPanelCredit" onkeyup="chkCreditPer()" disabled="disabled" onkeypress="return checkForSecondDecimalCreditCR(this,event)" title="Enter Credit limit Amount" style="width: 20%" />
                    <span id="spnCreditlimitType" style="display: none"></span><span id="spnCreditLimitAmt" style="display: none"></span><span id="spnPanelDocumentID"></span><span id="spnIPDPanelID" style="display: none"></span></td>
            </tr>
            <tr>
                <td style="text-align: right; width: 16%">Card No. :&nbsp</td>
                <td style="width: 34%">
                    <input type="text" id="txtCardNo" title="Enter Card No." tabindex="55" />
                    <span class="shat" style="color: red; font-size: 10px;">*</span></td>
                <td style="text-align: right; width: 18%">Card Holder Name :&nbsp</td>
                <td style="width: 32%; text-align: left;">
                    <input type="text" id="txtCarHolderName" style="width: 220px" title="Enter Card Holder Name" tabindex="56" />
                    <span class="shat" style="color: red; font-size: 10px;">*</span></td>
            </tr>
            <tr>
                <td style="text-align: right; width: 16%">Card Holder :&nbsp;</td>
                <td style="width: 34%; text-align: left;">
                    <select id="ddlRelationCardHolder" style="width: 225px" title="Select Card Holder Name" tabindex="57"></select>
                    <span class="shat" style="color: red; font-size: 10px;">*</span>&nbsp;</td>
                <td style="text-align: left; width: 50%" colspan="2">
                    <input type="checkbox" id="chkCardno" onclick="isIgnore()" tabindex="58" />Ign. Policy Reason:
                    <input type="text" id="txtIgnoringPolicy" style="width: 250px;" title="Enter Ploicy Ignore Reason" tabindex="59" /><span class="shat" style="color: red; font-size: 10px;">*</span>
                </td>

            </tr>
        </table>
    </div>
    <script type="text/javascript">
        function ShowPRO() {
            $find('mpPRO').show();
            jQuery("#txtPROName").focus();
        }
        function ClosePRO() {
            $find('mpPRO').hide();
            jQuery("#txtPROName").val('');
            jQuery("#spnErrorPRO").text('');
        }
        function savePRO() {
            if (jQuery.trim(jQuery('#txtPROName').val()) == "") {
                jQuery('#spnErrorPRO').text('Please Enter Pro Name');
                jQuery('#txtPROName').focus();
                return;
            }
            else {
                jQuery("#btnSavePRO").attr('disabled', 'disabled');
                jQuery.ajax({
                    url: "Services/EDP.asmx/SavePro",
                    url: "../EDP/Services/EDP.asmx/SavePro",
                    data: '{ProName:"' + jQuery.trim(jQuery('#txtPROName').val()) + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        PROData = (result.d);
                        if (PROData == "0") {
                            jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            ClosePRO();
                        }
                        else if (PROData == "E") {
                            jQuery("#spnErrorPRO").text('Pro Name Already Exist');
                            jQuery('#txtPROName').focus();
                        }
                        else {
                            jQuery("#spnErrorMsg").text('Record Saved Successfully');
                            jQuery("#ddlProName").append(jQuery("<option></option>").val(PROData).html(jQuery("#txtPROName").val()));
                            jQuery("#ddlProName").val(PROData);
                            ClosePRO();
                        }
                        jQuery("#btnSavePRO").removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        jQuery("#btnSavePRO").removeAttr('disabled');
                    }
                });
            }

        }


    </script>
    <asp:Button ID="btnHide" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="mpPRO" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnPROCancel" DropShadow="true" PopupControlID="pnlPRO"
        TargetControlID="btnHide" OnCancelScript="ClosePRO()" BehaviorID="mpPRO">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlPRO" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="370px">
        <div id="Div3" class="Purchaseheader" runat="server">
            Create New Pro&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="ClosePRO()" />

                  to close</span></em>
        </div>

        <table style="width: 100%">
            <tr>
                <td colspan="2" style="text-align: center">
                    <span id="spnErrorPRO" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">&nbsp;Pro Name :&nbsp;
                </td>
                <td>
                    <input type="text" id="txtPROName" maxlength="50" title="Enter Pro Name" />
                    <span style="color: red; font-size: 10px;">*</span>

                </td>
            </tr>
            <tr>

                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="savePRO();" value="Save" class="ItDoseButton" id="btnSavePRO" title="Click To Save" />
                    &nbsp;
                                    <asp:Button ID="btnPROCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                </td>
            </tr>

        </table>
    </asp:Panel>
</div>
