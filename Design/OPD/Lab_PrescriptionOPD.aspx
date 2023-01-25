<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Lab_PrescriptionOPD.aspx.cs" Inherits="Design_OPD_Lab_PrescriptionOPD" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="wuc_OldPatientSearch" TagPrefix="uc1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .ui-state-focus
        {
            /*background: none !important;*/
            background-color: #c6dff9 !important;
            border: none !important;
        }

        .ui-menu-item
        {
            width: 600px;
            max-width: 600px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .ui-widget-content
        {
            border-radius: 5px;
        }

        #toast-container > div
        {
            width: auto;
            min-width: 351px;
            opacity: 1;
        }

        .slotDetails
        {
            height: 440px !important;
            overflow: auto !important;
        }

        .circle
        {
            background: blue;
            -moz-border-radius: 65px;
            -webkit-border-radius: 65px;
            border-radius: 65px;
            width: 65px;
            height: 65px;
            padding-top: 16px;
            padding-left: 6px;
            font-size: 10px;
            font-weight: bold;
            cursor: pointer;
            color: white;
        }

        .POuter_Box_Inventory
        {
        }
    </style>

    <script type="text/javascript">

        //*****Global Variables*******
           var IsInvestigationAppointment = '<%=Resources.Resource.IsInvestigationAppointment %>';
        // var IsInvestigationAppointment = '0';

        var RoleWisePageChache = [];
        var appointmentTypeList = [];
        var revenueDoctorList = [];

        $(document).ready(function () {
            configurePageChache(function () {
                //$.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
                $getHashCode(function () { });
                $bindMandatory(function () { });
                bindDispatchMode(function () { });
                $bindTypeOfAppointments(function () { });
                $bindOPDFilterTypes(function () {
                    $bindCategory(function (response) { });
                });
                $patientControlInit(function () {
                    $bindRevenueDoctor(function () {
                        $panelControlInit(function () {
                            $paymentControlInit(function () {
                                if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1')
                                    $bindRegistrationCharges(function () { });
                                
                                $onInit();
                                // $.unblockUI();
                                var appointmentID = '<%=Util.GetString(Request.QueryString["AppointmentID"])%>';
                                var PatientID = '<%=Util.GetString(Request.QueryString["PatientID"])%>';
                                if (!String.isNullOrEmpty(appointmentID)) {
                                    $getBookedAppointmentDetails(appointmentID, function (response) {
                                        $bindPatientDetails(response, function () {
                                            $bindAppointmentDetails(appointmentID, response, function () {
                                                //        $('#pageTitle').val('Reschedule Appointment');
                                                //        $('#btnSave').val('Update');
                                            });
                                        });
                                    });
                                }

                                if (!String.isNullOrEmpty(PatientID)) {

                                    $patientSearchByPatientId({ PatientID: PatientID, PatientRegStatus: 1 }, function (response) {
                                        $bindPatientDetails(response, function () {
                                        });

                                    });

                                }

                                var isHelpDeskBooking = Number('<%=Util.GetString(Request.QueryString["helpDeskBooking"])%>');
                                if (isHelpDeskBooking == 1) {
                                    onHelpDeskBooking(function () {});
                                }
                            });
                        });
                    });
                });
            });

            $('#txtAppointmentSlotDate,#ddlSolotMin').change(function () {
                var doctorID = $('#spnSelectedDoctorID').text();
                var isSlotWiseToken = $('#spnSelectedDoctorIsSlotWiseToken').text();
                $getDoctorAppointmentTimeSlot(doctorID, 1, false, isSlotWiseToken, function (response) { });
            });
        });


        var onHelpDeskBooking = function () {
            var doctorItemID = Number('<%=Util.GetString(Request.QueryString["itemId"])%>');
            $bindItems({ searchType: 1, prefix: "", Type: "4", CategoryID: "0", SubCategoryID: "0", itemID: doctorItemID }, function (response) {
                var investigation = {};
                investigation.item = response[0];
                $validateInvestigation(investigation, 0, 0, 1, function () { });
                $('#txtSearch').attr('disabled', true);
            });
        }


        var configurePageChache = function (callback) {
            serverCall('../common/CommonService.asmx/RoleWiseOPDServiceBookingControls', {}, function (response) {
                var responseData = JSON.parse(response);
                RoleWisePageChache = responseData; //assign to global variables
                callback();
            });
        }

        var $getBookedAppointmentDetails = function (appointmentID, callback) {
            serverCall('Lab_PrescriptionOPD.aspx/bindAppointmentDetail', { App_ID: appointmentID }, function (response) {
                var responseData = JSON.parse(response)
                if (responseData.status)
                    callback(responseData.data[0])
                else
                    modelAlert(responseData.message);
            });
        }

        var $bindAppointmentDetails = function (appointmentID,appointmentDetails, callback) {
            serverCall('Services/LabPrescription.asmx/getPatientDoctorAppointmentDetails', { appointmentID: appointmentID }, function (response) {
                var responseData = JSON.parse(response);
                var investigations = [];
                $(responseData).each(function (i, $data) {
                    investigations.push({
                        IsOutSource: $data.IsOutSource,
                        ItemCode: $data.ItemCode,
                        LabType: $data.LabType,
                        CategoryID: $data.CategoryID,
                        SubCategoryID: $data.SubCategoryID,
                        TnxTypeID: $data.TnxType,
                        TypeName: $data.TypeName,
                        Type_ID: $data.Type_ID,
                        isadvance: $data.isadvance,
                        sampleType: $data.Sample,
                        val: $data.ItemID,
                        presceibedID: $data.PatientTest_ID,
                        IsUrgent: 0,
                        defaultQty: $data.Quantity,
                        isMobileBooking: 0,
                        salesID: $data.SalesID,
                        Rate: $data.Rate,
                        SubCategory: $data.SubCategory,
                        ItemDisplayName: $data.ItemDisplayName,
                        isSlotWiseToken: 0,
                        appointmentID: $data.App_ID,
                    });
                });
                $addInvestigation(investigations);
                callback();
            });
        }
        var $bindRevenueDoctor = function (callback) {
            //serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: 'ALL' }, function (response) {
             revenueDoctorList = CentreWiseCache.filter(function (i) { return i.TypeID == '3' });
                callback();
            //});
      }
        var $bindTypeOfAppointments = function (callback) {
          //  serverCall('../common/CommonService.asmx/bindTypeOfApp', {}, function (response) {
            // appointmentTypeList = JSON.parse(response);
                appointmentTypeList = RoleWisePageChache.filter(function (i) { return i.TypeID == '6' });
                callback();
            //});
        }
        var $bindOPDFilterTypes = function (callback) {
            var $ddlFilterType = $('#ddlFilterType');
            //  serverCall('../Common/CommonService.asmx/BindOPDFilterTypeUserWise', {}, function (response) {
            //   $ddlFilterType.bindDropDown({ data: JSON.parse(response), valueField: 'TypeID', textField: 'TypeName', isSearchAble: false, selectedValue:'0' });
            var responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '2' });
            $ddlFilterType.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: false, selectedValue: '0' });
            callback($ddlFilterType.val());
            //   });
        }

        var $bindMandatory = function (callback) {
            var manadatory = [
				{ control: '#ddlTitle', isRequired: true, erroMessage: 'Please Select Title', tabIndex: 1, isSearchAble: false },
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 2, isSearchAble: false },
                { control: '#txtPMiddleName', isRequired: false, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
                { control: '#txtPLastName', isRequired: true, erroMessage: 'Enter Second Name', tabIndex: 3, isSearchAble: false },
				//{ control: '#txtDOB', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 4, isSearchAble: false },
                { control: '#txtAge', isRequired: true, erroMessage: 'Select Age', tabIndex: 3, isSearchAble: false },                
                { control: '#txtMobile', isRequired: true, erroMessage: 'Enter Mobile Number', tabIndex: 5, isSearchAble: false },  
		       	{ control: '#ddlMarried', isRequired: false, erroMessage: 'Select Marital Status', tabIndex: 5, isSearchAble: false },
              //  { control: '#txtIDProofNo', isRequired: true, erroMessage: 'Enter NIC No.', tabIndex: 4, isSearchAble: false },
                 //{ control: '#txtAddress', isRequired: true, erroMessage: 'Enter Address', tabIndex: 7, isSearchAble: false },
                 { control: '#txtParmanentAddress', isRequired: true, erroMessage: 'Enter PhysicalAddress', tabIndex: 6, isSearchAble: false },
                //{ control: '#txtRelationName', isRequired: true, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },
                { control: '#ddlCountry', isRequired: true, erroMessage: 'Please Select Country', tabIndex: 8, isSearchAble: true },
                 { control: '#ddlState', isRequired: true, erroMessage: 'Please Select State', tabIndex: 9, isSearchAble: true },
                { control: '#ddlDistrict', isRequired: true, erroMessage: 'Please Select DIstrict', tabIndex: 10, isSearchAble: true },
            //    { control: '#ddlCity', isRequired: true, erroMessage: 'Please Select City', tabIndex: 11, isSearchAble: true },
                { control: '#ddlDoctor', isRequired: true, erroMessage: 'Please Select Doctor', tabIndex: 12, isSearchAble: true }

            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                $(manadatory[0].control).focus();
            });
            callback(true);
        }

        var bindDispatchMode = function (callback) {
            $ddlDispatchMode = $('#ddlDispatchMode');
           // serverCall('../common/CommonService.asmx/BindDispatchMode', {}, function (response) {
               // var responseData = JSON.parse(response);
            //   $ddlDispatchMode.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'DispatchMode', isSearchAble: false });

            var responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '5' });
            $ddlDispatchMode.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: false, selectedValue: '1' });
                callback($ddlDispatchMode.val());
           // });
        }

        var onDispatchModeChange = function (value) {
            var courierChargesItemID = '<%= Resources.Resource.CourierCharges_ItemId %>';
            if (value == '-10') {
                $bindItems({ searchType: 1, prefix: "", Type: "4", CategoryID: "0", SubCategoryID: "0", itemID: courierChargesItemID }, function (response) {
                    var investigation = {};
                    investigation.item = response[0];
                    $validateInvestigation(investigation, 0, 0, 1, function () { });
                });
            }
            else
                $removeLabItems($('#tbSelected').find('#' + courierChargesItemID).find('img'));
        }

        $updatePaymentAmount = function (callback) {
            var totalBillAmount = 0;
            var totalDiscountAmount = 0;
            var panelNonPayableAmount = 0;
            var isRegistrationChargesApply = 0;
            var isPaymentcontrolInit = 0;
            var registrationCharge = 0;
            var registrationChargeDiscount = 0;
            var IsConsultationPresent = 0;

            $tbSelected = $('#tbSelected');
            var labItemsAmountDetails = $($tbSelected).find('.billingRow .nonPackageItems').each(function () {

                //  if (!$(this).find("#chkDocCollect").is(':checked') && ($(this).find("#spnAppointmentType").text().trim() == '' || $(this).find("#spnAppointmentType").text().trim() == '0' || $(this).find("#spnAppointmentType").text().trim() == '2' )) 

                if (($(this).find("#spnAppointmentType").text().trim() == '0' || $(this).find("#spnAppointmentType").text().trim() == '2')) {
                    $qty = Number($(this).find('#txtQuantity').val());
                    $rate = Number($(this).find('#txtRate').val());
                    $isPayable = Number($(this).find('#spnIsPayable').text());

                    if ($isPayable == 0) {
                        $coPaymentPercent = Number($(this).find('#spnCoPaymentPercent').text());

                        if ($coPaymentPercent > 0)
                            panelNonPayableAmount = panelNonPayableAmount + ((($qty * $rate) * $coPaymentPercent) / 100);
                    }
                    else if ($isPayable == 1)
                        panelNonPayableAmount = panelNonPayableAmount + ($qty * $rate);

                    $isOutSource = $(this).find('#spnIsOutSource').text().trim();
                    if ($rate < 1)
                        $(this).css('background-color', 'lightpink');
                    else {
                        if ($isOutSource == '1')
                            $(this).css('background-color', 'aqua');
                        else
                            $(this).css('background-color', '');
                    }

                    totalBillAmount = totalBillAmount + ($rate * $qty);
                    $discountAmount = Number($(this).find('#txtDiscountAmount').val());
                    totalDiscountAmount = totalDiscountAmount + $discountAmount;

                    if ($(this).find('#spnItemID').text() == '<%=Resources.Resource.RegistrationItemID%>' && '<%=Resources.Resource.RegistrationChargesApplicable%>' == '1') {
                        registrationCharge = ($rate * $qty);
                        registrationChargeDiscount = Number($(this).find('#txtDiscountAmount').val());
                    }

                    if ($(this).find('#spnItemID').text() != '<%=Resources.Resource.RegistrationItemID%>' && '<%=Resources.Resource.RegistrationChargesApplicable%>' == '1')
                        isRegistrationChargesApply = 1;
                }
                if ($(this).find('#spnItemID').text() != '<%=Resources.Resource.RegistrationItemID%>' && '<%=Resources.Resource.RegistrationChargesApplicable%>' == '1')
                    isPaymentcontrolInit = 1;


                if ($(this).find('#spnCategoryID').text() == 1) {

                    IsConsultationPresent = 1;
                }

            });
            if (labItemsAmountDetails.length > 0 || isPaymentcontrolInit == 1) {
                $preventPatientPanelChange(function () { });
                $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                $autoPaymentMode = '<%=Resources.Resource.IsReceipt%>' == '1' ? false : true;

                // $getRegistrationCharges(function (registrationDetails) {

				   // var registrationCharge = totalBillAmount>0?registrationDetails.registrationCharge:0;

                //  var billAmount = (totalBillAmount + registrationCharge);


                var billAmount = totalBillAmount;

				    addRegistrationCharges(isRegistrationChargesApply, function () { });

				    if (isRegistrationChargesApply == 0)
				    {
				        billAmount = billAmount - registrationCharge;
				        totalDiscountAmount = totalDiscountAmount - registrationChargeDiscount;
				    }
                    var IsDiscountAuthorization = '<%=Util.GetInt(ViewState["IsDiscount"])%>';
					
					if ($isReceipt)
                    {
                        $isReceipt = billAmount > 0 ? true : false;
                        $autoPaymentMode = billAmount > 0 ? false : true;
                    }
					
                    getPatientBasicDetails(function (patientDetails) {
                        $addBillAmount({
                            panelId: patientDetails.panelID,
                            billAmount: billAmount,
                            disCountAmount: totalDiscountAmount,
                            isReceipt: $isReceipt,
                            patientAdvanceAmount: patientDetails.patientAdvanceAmount,
                            autoPaymentMode: $autoPaymentMode,
                            minimumPayableAmount: panelNonPayableAmount,
                            panelAdvanceAmount: patientDetails.panelAdvanceAmount,
                            disableDiscount: IsDiscountAuthorization == '0' ? true : false,
                            refund: { status: false }
                        }, function () { });
                        $($tbSelected).show();
                        $('.tbSelectedItems').show();
                    var Panel = '<%= Resources.Resource.CoPayAmountPanel %>';

                    if (Panel == patientDetails.panelID && IsConsultationPresent == 1) {
                        $("#txtCopaymentAmount").val('<%= Resources.Resource.CoPayPanelAmount %>')
				            onCoPaymentAmountChange('<%= Resources.Resource.CoPayPanelAmount %>', totalBillAmount);

				        }
                    });
                //  });

                    $('#lblTotalLabItemsCount').text('Count : ' + labItemsAmountDetails.length);
            }
            else {
                $($tbSelected).hide();
                $('.tbSelectedItems').hide();
                $allowPatientPanelChange(function () { });
                $clearPaymentControl(function () { });

                $('#lblTotalLabItemsCount').text('Count : 0');
            }
        }
        $onInit = function () {
            $('#txtSearch').autocomplete({
                source: function (request, response) {
                    $labItem = $('#ddlFilterType').val();// $('input[type=radio][name=labItems]:checked').val();
                    $categoryID = $('#ddlCategory').val();
                    $subCategoryID = $('#ddlSubCategory').val();
                    $searchType = $('#ddlSearchType').val();
                    $bindItems({ searchType: parseInt($searchType), prefix: request.term, Type: $labItem, CategoryID: $categoryID, SubCategoryID: $subCategoryID, itemID: '' }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    $validateInvestigation(i, 0, 0, 1, function () { });
                },
                focus: function (e, i) {
                    // console.log(i);
                },
                close: function (el) {
                    el.target.value = '';
                },
                minLength: 2
            });
            onPatientIDChange(function () { });
        }

        $bindItems = function (data, callback) {
            serverCall('../common/CommonService.asmx/LoadOPD_All_ItemsLabAutoComplete', data, function (response) {
                var responseData = $.map(JSON.parse(response), function (item) {
                    return {
                        label: item.AutoCompleteItemName,
                        val: item.Item_ID,
                        isadvance: item.isadvance,
                        IsOutSource: item.IsOutSource,
                        ItemCode: item.ItemCode,
                        Type_ID: item.Type_ID,
                        LabType: item.LabType,
                        TnxTypeID: item.TnxType,
                        SubCategoryID: item.SubCategoryID,
                        sampleType: item.Sample,
                        TypeName: item.TypeName,
                        rateEditAble: item.RateEditable,
                        isMobileBooking: 0,
                        CategoryID: item.categoryid,
                        SubCategory: item.SubCategory,
                        isSlotWiseToken: item.IsSlotWisetoken,
                        appointmentID:0
                    }
                });
                
                if (isPatientValidForFollowUpVisit == '1') {// if patient is enable for free visit (i.e. under doctor validity period) then hide first visit for that doctor only.
                    responseData = responseData.filter(function (i) { return (i.SubCategoryID + '#' + i.Type_ID) != '<%=Resources.Resource.FirstVisitSubCategoryID%>' + '#' + previousFirstVisitOPDDoctorID });
                    
                }
                else
                    responseData = responseData.filter(function (i) { return (i.SubCategoryID) != '<%=Resources.Resource.FollowUpVisitSubCategoryID%>' });
                callback(responseData);
            });

        }

        $validateInvestigation = function (investigation, IsUrgent, presceibedID, defaultQty, callback) {
            if ($('#tbSelected tbody tr td #spnItemID').filter(function () { return ($(this).text().trim() == investigation.item.val) }).length > 0) {
                modelAlert('Selected Item Already Added!', function () { $('#txtSearch').val('').focus(); });
                return;
            }

            if (investigation.item.TnxTypeID == '5') {
                if ($('#tbSelected tbody tr td #spnInvestigationID').filter(function () { return ($(this).text().trim() == investigation.item.Type_ID) }).length > 0) {
                    modelAlert('Selected Item Already Added!', function () { $('#txtSearch').val('').focus(); });
                    return;
                }
            }
            //if (investigation.item.TnxTypeID == '23') {
            //    $checkPackageExpiry(investigation.item.Type_ID, function (expiryStatus) {
            //        if (expiryStatus) {
            //            modelAlert('Package has been Expired!');
            //            return;
            //        }
            //    });
            //}
            slotinvestigation = [];
            $checkPackageExpiry(investigation.item.Type_ID, investigation.item.TnxTypeID, function (expiryStatus) {
                if (!expiryStatus) {
                    ValidateDoctorMap(investigation.item, function () {
                        validateDoctorLeave(investigation.item, function () {
                            getPatientBasicDetails(function (patientDetails) {
                                $getDiscountWithCoPay({ itemID: investigation.item.val, panelID: patientDetails.panelID, patientTypeID: patientDetails.patientTypeID, memberShipCardNo: $('#txtMembershipCardNo').val() }, function (discountCoPayment) {
                                    $checkAlreadyPrescribe({ PatientID: patientDetails.patientID, ItemID: investigation.item.val }, function (response) {
                                        if (response) {
                                            investigation.item.IsUrgent = IsUrgent;
                                            investigation.item.presceibedID = presceibedID;
                                            investigation.item.defaultQty = defaultQty;
                                            investigation.item.discountPercent = discountCoPayment.OPDPanelDiscPercent;
                                            investigation.item.IsPanelWiseDiscount = discountCoPayment.OPDPanelDiscPercent > 0 ? 1 : 0;
                                            investigation.item.coPaymentPercent = discountCoPayment.OPDCoPayPercent;
                                            investigation.item.IsPayable = discountCoPayment.IsPayble;
                                            investigation.item.salesID = '';
                                            investigation.item.IsDiscountEnable = '<%=Util.GetInt(ViewState["IsDiscount"])%>' == '0' ? false : true,
                                            $getItemRate(patientDetails.panelID, investigation, patientDetails.panelCurrencyFactor, function (investigationRateDetails) {
                                                slotinvestigation.push({
                                                    PanelId: patientDetails.panelID,
                                                    investigation: investigation,
                                                    investigationRateDetails: investigationRateDetails,
                                                });
                                                $('#spnIsSearchSelect').text('1');
                                                if (investigation.item.CategoryID == '7' && IsInvestigationAppointment == '1') {
                                                    $getinvestigationSlotwhenSearch(patientDetails.panelID, investigation, investigationRateDetails, function () {
                                                    });
                                                } else {
                                                    $addInvestigationRow(patientDetails.panelID, investigation, investigationRateDetails,0, function () {
                                                        $clearPaymentControl(function () {
                                                            $updatePaymentAmount(function () { });
                                                        });
                                                    });
                                                }
                                            });
                                        }
                                    });
                                });
                            });
                        });
                    });
                }
                else {
                    modelAlert('Package has been Expired!');
                }
            });


            //if (investigation.item.isadvance) {
            //    modelConfirmation('Confirmation', 'No More Item Can be Added With Advance Booking !', function (response) {
            //        return;
            //    })
            //}
            //if ($('#tbSelected tbody tr td #isAdvance').filter(function () { return ($(this).text().trim() == '1') }).length > 0) {
            //    modelAlert('No More Item Can be Added With Advance Booking !');
            //}

        };



        var onPanelControlPanelChange = function () {

            $('#spnIsHelpDeskSelected').text('0');

            var selectedDetails = $('#tbSelected').hide().find('tbody');
            var selectedData = [];
            selectedDetails.find('tr').each(function () {
                var itemData = JSON.parse($(this).find('#spnData').text());
                selectedData.push(itemData);
            });
            selectedDetails.find('tr').remove();
            $addInvestigation(selectedData);
			
            $bindRegistrationCharges(function () { });
        }


        var addRegistrationCharges = function (isRegistrationChargesApply) {
           

            var registrationChargesItemID = '<%=Resources.Resource.RegistrationItemID%>';

           // $removeLabItems($('#tbSelected').find('#' + registrationChargesItemID).find('img'));

            var isRegistrationChargesAlreadyAdded = $('#spanIsRegistrationChargesAlreadyAdded').text().trim();

            if (isRegistrationChargesAlreadyAdded == '1' && isRegistrationChargesApply == 0) {
                $('#spanIsRegistrationChargesAlreadyAdded').text("0");
                $removeLabItems($('#tbSelected').find('#' + registrationChargesItemID).find('img'));
               
            }

            // if (!String.isNullOrEmpty(registrationChargesItemID) && '<%=Resources.Resource.RegistrationChargesApplicable %>' == '1' && isRegistrationChargesApply == 1 && isRegistrationChargesAlreadyAdded == '0' && $('#spnRegistrationchargeFeePaid').text()=='0') {
            if (!String.isNullOrEmpty(registrationChargesItemID) && '<%=Resources.Resource.RegistrationChargesApplicable %>' == '1' && isRegistrationChargesApply == 1 && isRegistrationChargesAlreadyAdded == '0' && $('#spnRegistrationchargeFeePaid').text() == '0' && $('#spnIsRegistrationApply').text() == "0") {
                $('#spanIsRegistrationChargesAlreadyAdded').text("1");
                $bindItems({ searchType: 1, prefix: "", Type: "3", CategoryID: "0", SubCategoryID: "0", itemID: registrationChargesItemID }, function (response) {
                        var investigation = {};
                        investigation.item = response[0];
                        $validateInvestigation(investigation, 0, 0, 1, function () { });
                });
           }
        }

        var validateDoctorLeave = function (item, callback) {
            if ((item.LabType) == "OPD") {
                serverCall('Lab_PrescriptionOPD.aspx/ValidateDoctorLeave', { itemID: item.val }, function (resposne) {
                    var responseData = JSON.parse(resposne);
                    if (responseData.status)
                        callback();
                    else
                        modelAlert(responseData.message, function () {
                            $('#txtSearch').val('').focus();
                        });
                });
            }
            else
                callback();
        }
        var ValidateDoctorMap = function (item, callback) {
            if (item.LabType == "OPD") {
                serverCall('Lab_PrescriptionOPD.aspx/ValidateDoctorMap', { itemID: item.val }, function (resposne) {
                    var responseData = JSON.parse(resposne);
                    if (responseData.status)
                        callback();
                    else
                        modelAlert(responseData.message, function () {
                            $('#txtSearch').val('').focus();
                        });
                });
            }
            else
                callback();
        }


        $getDiscountWithCoPay = function (data, callback) {
            serverCall('../common/CommonService.asmx/GetDiscountWithCoPay', data, function (response) {
                callback(JSON.parse(response)[0]);
            });
        }

        $addInvestigationRow = function (panelID, investigation, investigationRateDetails,isCpoeOrOnline, callback) {
          
            $('#lblScheduleChargeID').text(investigationRateDetails.ScheduleChargeID);
            var trStyle = '';
            if (investigation.item.IsOutSource == 1)
                trStyle = 'style = "background-color:aqua"';
            else
                if (investigationRateDetails.Rate < 1)
                    trStyle = 'style = "background-color:lightpink"';



            var defaultValue = 1;
            if (investigation.item.LabType.toLowerCase() != 'lab')
                defaultValue = 99;


            var isDiscountEnable = investigation.item.IsDiscountEnable;

            if (investigation.item.discountPercent > 0)
                isDiscountEnable = false;



            var amount = precise_round((investigation.item.defaultQty * investigationRateDetails.Rate), 4);
            var discountAmount = investigation.item.discountPercent > 0 ? (((amount) * investigation.item.discountPercent) / 100) : 0;
            $investigationTr = "<tr id=" + investigation.item.val + " " + trStyle + " class='nonPackageItems' >";
            //   $investigationTr += "<td class='GridViewLabItemStyle'><input type='checkbox' id='chkDocCollect' data-title='Doctor Collection' ";

            // if (investigation.item.ConfigID == "11" || investigation.item.ConfigID == "28")
            //  $investigationTr += " style='display:none;' ";

            // $investigationTr += " onchange='$docCollection(this);' ><br /></td>";

            var datatitle = "Click here to Book Investigation Slots";
            if (isCpoeOrOnline == 0) {
                datatitle = investigation.item.BookingDate + " " + investigation.item.InvestigationSlotTime + " " + investigation.item.ModalityName;
            }

            if (investigation.item.CategoryID == '7' && IsInvestigationAppointment == '1' && investigation.item.isMobileBooking == '1')
                $investigationTr += "<td class='GridViewLabItemStyle' style='text-align:center'><img data-title='" + datatitle + "' id='imgView' src='../../Images/SlotCalender.jpg'  title='Click here to Book Investigation Slots' /></td>";
            else if (investigation.item.CategoryID == '7' && IsInvestigationAppointment == '1' && investigation.item.isMobileBooking == '0') 
                $investigationTr += "<td class='GridViewLabItemStyle' style='text-align:center'><img data-title='" + datatitle + "' id='imgView' src='../../Images/SlotCalender.jpg' onclick='SelectInvestigationSlot(0,this);' title='Click here to Book Investigation Slots' /></td>";
            else {
                $investigationTr += "<td class='GridViewLabItemStyle' style='text-align:center'><img  id='imgViewDocCalender' src='../../Images/SlotCalender.jpg'  ";
                if (investigation.item.TnxTypeID != "5")
                    $investigationTr += " style='display:none;' ";

                $investigationTr += " data-title='Click here to Book Appointment Slots' /> ";


                $investigationTr += " </td>";
            }
                $investigationTr += "<td style='width:100px;' id='tdAppointmentType' class='GridViewLabItemStyle'><select ";
                if (investigation.item.TnxTypeID != "5")
                    $investigationTr += " style='display:none;'  class='docAppointmentType' ";
                else
                    $investigationTr += " class='docAppointmentType requiredField' ";

            $investigationTr += " onchange='$validateDoctorCalender(this);' errorMessage='Please Select Appointment Type' ></select></td>";

            $investigationTr += "<td class='GridViewLabItemStyle'><span id='spnItemCode'>" + investigation.item.ItemCode + "</span></td>";

            $investigationTr += " <td class='GridViewLabItemStyle' style='text-align:center;' > ";
            if (investigation.item.TnxTypeID == "23")
                $investigationTr += "<img  id='imgViewPackageDetail' src='../../Images/plus_in.gif' onclick='showPackageItems(this);' class='imgPlus'  data-title='Click here to View Package Items' />";

            $investigationTr += " </td> ";
            $investigationTr += "<td  style='text-align:left; width:300px; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;' ";
            if (investigation.item.TnxTypeID == "5")
                $investigationTr += " onclick='showDoctorTokenNo(this);' ";

            if (investigation.item.TnxTypeID == "23")
                $investigationTr += " class='GridViewLabItemStyle patientInfo' style='font-weight:bold;'>";
            else
               $investigationTr += " class='GridViewLabItemStyle' style='width:300px;'> ";

           
            $investigationTr += "<span data-title='" + investigation.item.TypeName + "(" + investigation.item.SubCategory + ")'  id='spnItemName'>" + investigation.item.TypeName + "</span>";
            if (investigation.item.coPaymentPercent > 0)
                $investigationTr += "<br/> <div style='text-align: right;'  class='patientInfo'>Panel Co-Payment:" + investigation.item.coPaymentPercent + "%</div>"
            if (investigation.item.IsPayable == 1)
                $investigationTr += "<br/> <div style='text-align: right;' class='patientInfo'>Panel Non-Payable Item</div>"
            //  if (investigation.item.TnxTypeID == "5")
            //      $investigationTr += "<br/> <div style='text-align: right;font-weight:bold;' class='patientInfo' ><a href='JavaScript:void(0)' class='docAvailability' onclick='$getDoctorAppointmentTimeSlotNew(this,function (response) {})'>Availability</a> </div>"

            ///  $investigationTr += "<br/> <div style='text-align: right;' class='patientInfo'><span id='spnDocCollect' class='ItDoseLblError'></span></div>"
            //if (investigation.item.CategoryID == '7' && IsInvestigationAppointment == '1' && investigation.item.isMobileBooking == '1') {
            //    $investigationTr += "<span id='spnInvestigationSlotDate' style='display:none'>" + investigation.item.BookingDate + "</span>";
            //    $investigationTr += "<span id='spnInvestigationSlotModality' style='display:none'>" + investigation.item.ModalityID + "</span>";
            //    $investigationTr += "<span id='spnInvestigationSlotTime' style='display:none'>" + investigation.item.InvestigationSlotTime + "</span>";
            //}
            //else {
            //    $investigationTr += "<span id='spnInvestigationSlotDate' style='display:none'>" + investigation.item.BookingDate + "</span>";
            //    $investigationTr += "<span id='spnInvestigationSlotModality' style='display:none'>" + investigation.item.ModalityID + "</span>";
            //    $investigationTr += "<span id='spnInvestigationSlotTime' style='display:none'>" + investigation.item.InvestigationSlotTime + "</span>";
            //}

            if (isCpoeOrOnline == 0) {
                $investigationTr += "<span id='spnInvestigationSlotDate' style='display:none'>" + investigation.item.BookingDate + "</span>";
                $investigationTr += "<span id='spnInvestigationSlotModality' style='display:none'>" + investigation.item.ModalityID + "</span>";
                $investigationTr += "<span id='spnInvestigationSlotTime' style='display:none'>" + investigation.item.InvestigationSlotTime + "</span>";
            }
            else {
                $investigationTr += "<span id='spnInvestigationSlotDate' style='display:none'></span>";
                $investigationTr += "<span id='spnInvestigationSlotModality' style='display:none'></span>";
                $investigationTr += "<span id='spnInvestigationSlotTime' style='display:none'></span>";
            }

            $investigationTr += "<span id='spnDocAppointmentDateTime' style='display:none'></span>"
            $investigationTr += "<span id='spnAppointmentType' style='display:none'>0</span>"
            $investigationTr += "<span id='spnItemDoctorID' style='display:none'>0</span>"
            $investigationTr += "<span id='spnIsPackageView' style='display:none'>0</span>"
            $investigationTr += "<span id='spnData' style='display:none'>" + JSON.stringify(investigation.item) + "</span>";
            $investigationTr += "<span id='spnisMobileBooking' style='display:none'>" + investigation.item.isMobileBooking + "</span>";
            $investigationTr += "<span id='spnItemID' style='display:none'>" + investigation.item.val + "</span>";
            $investigationTr += "<span id='spnLabType' style='display:none'>" + investigation.item.LabType + "</span>";
            $investigationTr += "<span id='spnTnxTypeID' style='display:none'>" + investigation.item.TnxTypeID + "</span>";
            $investigationTr += "<span id='spnSubCategoryID' style='display:none'>" + investigation.item.SubCategoryID + "</span>";
            $investigationTr += "<span id='spnCategoryID' style='display:none'>" + investigation.item.CategoryID + "</span>";
            $investigationTr += "<span id='spnSalesID' style='display:none'>" + investigation.item.salesID + "</span>";
            $investigationTr += "<span id='spnSampleType' style='display:none'>" + investigation.item.sampleType + "</span>";
            $investigationTr += "<span id='spnInvestigationID' style='display:none'>" + investigation.item.Type_ID + "</span>";
            $investigationTr += "<span id='spnPresceibed_ID' style='display:none'>" + investigation.item.presceibedID + "</span>";
            $investigationTr += "<span id='spnIsAdvance' style='display:none'>" + investigation.item.isadvance + "</span>";
            $investigationTr += "<span id='spnIsUrgent' style='display:none'>" + investigation.item.IsUrgent + "</span>";
            $investigationTr += "<span id='spnRateListID' style='display:none'>" + investigationRateDetails.ID + "</span>";
            $investigationTr += "<span id='spnIsOutSource' style='display:none'>" + investigation.item.IsOutSource + "</span>";
            $investigationTr += "<span id='spnIsPayable' style='display:none'>" + investigation.item.IsPayable + "</span>";
            $investigationTr += "<span id='spnCoPaymentPercent' style='display:none'>" + investigation.item.coPaymentPercent + "</span>";
            $investigationTr += "<span id='spnIsPanelWiseDiscount' style='display:none'>" + investigation.item.IsPanelWiseDiscount + "</span>";
            $investigationTr += "<span id='spnRescheduleAppointmentID' style='display:none'>" + investigation.item.appointmentID + "</span>";
            $investigationTr += "<span id='spnDiscountAmount' style='display:none'>" + (investigation.item.discountPercent > 0 ? (((amount) * investigation.item.discountPercent) / 100) : 0) + "</span>";
            $investigationTr += "<span id='spnRateItemCode' style='display:none'>" + investigationRateDetails.ItemCode + "</span><span id='spnItemDisplayName' style='display:none'>" + investigationRateDetails.ItemDisplayName + "</span>";
            $investigationTr += "<span id='spnIsSlotWiseToken' style='display:none'>" + investigation.item.isSlotWiseToken + "</span></td>";
            $investigationTr += "<td id='tdRevenueDoctor' class='GridViewLabItemStyle' style='width:347px; text-align:center;'><select errorMessage='Please Select Item-Wise Doctor' ";
            if (investigation.item.TnxTypeID == "5" || investigation.item.TnxTypeID == "23" )
                $investigationTr += " style='display:none; width: 300px;' class='ddlRevenueDoctor' ";
            else
                $investigationTr += " style='width: 300px;' class='ddlRevenueDoctor requiredField' ";

            $investigationTr += " onchange='onItemDoctorChange(this)' ></select></td>";

            $investigationTr += "<td style='' class='GridViewLabItemStyle'><input id='txtRemarks'   autocomplete='off'     type='text'/></td>";
            $investigationTr += "<td class='GridViewLabItemStyle'><input id='txtRate'      onlynumber='14'  decimalplace='4'  max-value='10000000'  autocomplete='off'       onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' onkeyup='$labItemRateQuantityDiscountChange(event)'    " + ((investigation.item.rateEditAble == 0 && investigationRateDetails.Rate > 0) ? 'disabled' : '') + "    type='text' style='padding:2px' value=" + investigationRateDetails.Rate + " class='ItDoseTextinputNum'/></td>";
            $investigationTr += "<td class='GridViewLabItemStyle'><input id='txtQuantity'  onlynumber='10'   max-value='" + defaultValue + "' autocomplete='off'     onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' onkeyup='$labItemRateQuantityDiscountChange(event)'     type='text'  maxlength='4'   style='padding:2px'value=" + investigation.item.defaultQty + "   " + ((investigation.item.TnxTypeID == '5' || investigation.item.TnxTypeID == '23' || investigation.item.val == '<%= Resources.Resource.RegistrationItemID %>') ? 'disabled' : '') + " class='ItDoseTextinputNum'/></td>";
            $investigationTr += "<td class='GridViewLabItemStyle'><input id='txtDiscount'  onlynumber='14'  decimalplace='4'   max-value='100'   autocomplete='off'      onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' onkeyup='$labItemRateQuantityDiscountChange(event)' " + (isDiscountEnable ? '' : 'disabled') + "    type='text'  class='ItDoseTextinputNum'  style='padding:2px' value=" + investigation.item.discountPercent + "  /></td>";
            $investigationTr += "<td class='GridViewLabItemStyle'><input id='txtDiscountAmount'  autocomplete='off' type='text'  max-value='" + amount + "' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)'  onkeyup='$labItemRateQuantityDiscountChange(event)' " + (isDiscountEnable ? '' : 'disabled') + "  class='ItDoseTextinputNum'  style='padding:2px' value='" + (investigation.item.discountPercent > 0 ? (((amount) * investigation.item.discountPercent) / 100) : 0) + "'  /></td>";
            $investigationTr += "<td class='GridViewLabItemStyle'><input id='txtAmount'  autocomplete='off'      disabled     type='text'  class='ItDoseTextinputNum'  style='padding:2px' value=" + (amount - discountAmount) + "  /></td>";
            $investigationTr += "<td style='text-align: center;padding: 0px;' class='GridViewLabItemStyle'><input id='chkIsUrgent' data-title='Is Urgent'  autocomplete='off' type='checkbox'  class='ItDoseTextinputNum' ";
            
            if (investigation.item.TnxTypeID == "5" || investigation.item.TnxTypeID == "23" || investigation.item.TnxTypeID == "20")
                $investigationTr += " style='padding:2px;display:none;' ";
            else
                $investigationTr += " style='padding:2px' ";

            $investigationTr += "  /></td>";

            $investigationTr += '<td class="GridViewLabItemStyle" style="padding-left:0px;"><img ' + (investigation.item.val == '<%= Resources.Resource.CourierCharges_ItemId %>' || investigation.item.val == '<%= Resources.Resource.RegistrationItemID %>' ? 'style="display:none;cursor:pointer"' : 'style="cursor:pointer"') + ' class="" alt=""' + 'src="../../Images/Delete.gif" onclick="$removeLabItems(this)"  /></td></tr>';


            $('#tbSelected .billingRow').append($investigationTr);

            $('#tbSelected .billingRow tr:last').find('.docAppointmentType').bindDropDown({ data: appointmentTypeList, valueField: 'ValueField', textField: 'TextField', isSearchAble: false, selectedValue: '2' });

            if (investigation.item.TnxTypeID != "5" && investigation.item.TnxTypeID != "23") {
                $('#tbSelected .billingRow tr:last').find('.ddlRevenueDoctor').bindDropDown({ defaultValue: 'Select', data: revenueDoctorList, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: $('#ddlDoctor').val() });
                $('#tbSelected .billingRow tr:last').find('.ddlRevenueDoctor').chosen("destroy").chosen({ width: '300px' });
            }
            if (investigation.item.TnxTypeID == "5") {
                $('#ddlDoctor').val(investigation.item.Type_ID).chosen("destroy").chosen();
                $('#tbSelected .billingRow tr:last').find('.docAppointmentType').change();
            }
        
            
            if (investigation.item.TnxTypeID == "23") {
                $investigationTr = "<tr id=tr_packageItem" + investigation.item.val + " class='packageItems' style='display:none;'><td colspan='17'><div class='row' style='border:0px;'><div class='col-md-3'></div><div class='col-md-18' id='divPackageDetails' ></div><div class='col-md-3'></div></div></td></tr>";
                $('#tbSelected .billingRow').append($investigationTr);
                $('#tbSelected .billingRow .nonPackageItems:last').find('#imgViewPackageDetail').click();
            }

            $('#tbSelected .nonPackageItems td #txtDiscount').change();
            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            callback(true);
        }

        var $getDoctorAppointmentTimeSlotNew = function (isPackageDoctor, el, callback) {
      
            var row = $(el).closest('tr');
            $(row).closest('tbody').find('tr').removeClass('selectedDoctorAvailaility');
            $(row).addClass('selectedDoctorAvailaility');
            var appType = 0;
            var doctorID = 0;
            var IsSlotWiseToken = 0;
            var appointmentID = 0;


            var isHelpDeskBooking = Number('<%=Util.GetString(Request.QueryString["helpDeskBooking"])%>');
           var IsHelpDeskSelected = Number($('#spnIsHelpDeskSelected').text());
           if (IsHelpDeskSelected == 1)
               isHelpDeskBooking = 0;

                if (isPackageDoctor == 0) {
                    var selectedData = JSON.parse(row.find('#spnData').text());
                    doctorID = selectedData.Type_ID;
                    IsSlotWiseToken = selectedData.isSlotWiseToken;
                    appointmentID = selectedData.appointmentID;
                    if (doctorID === "0") {
                        modelAlert("Please Select Doctor !!!");
                        return false;
                    }
                    $('#spnSelectedDoctor').text(selectedData.TypeName + '   ( ' + selectedData.SubCategory + ' )');
                    $('#spnSelectedDoctorID').text(doctorID);
                    $('#spnSelectedDoctorIsSlotWiseToken').text(IsSlotWiseToken);
                    
                    if (isHelpDeskBooking == 1) {
                        appType = 3;
                        debugger;
                        var SlotTiming = '<%=Util.GetString(Request.QueryString["SlotTiming"])%>';
                        var SlotTimingDisplay = '<%=Util.GetString(Request.QueryString["SlotTimingDisplay"])%>';
                        SlotTiming = SlotTiming.replace("_", "#");
                        SlotTimingDisplay = SlotTimingDisplay.replace("%20", " ");

                        //dsk
                        row.find('.docAppointmentType').val(appType).attr('disabled', true);
                        $('#tbSelected').find('.selectedDoctorAvailaility').find('#spnAppointmentType').text(appType);
                        $('#tbSelected').find('.selectedDoctorAvailaility').find('#spnDocAppointmentDateTime').text(SlotTiming);
                        $('#tbSelected').find('.selectedDoctorAvailaility').find('#imgViewDocCalender').attr('data-title', SlotTimingDisplay);

                        MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                        $('#spnIsHelpDeskSelected').text('1');
                    }
                    else {
                        $('#tbSelected').find('.selectedDoctorAvailaility').find('#spnDocAppointmentDateTime').text('');
                        $('#tbSelected').find('.selectedDoctorAvailaility').find('#imgViewDocCalender').attr('data-title', 'Select Doctor Calendar');

                        MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                    }

                    $('#spnModalIsPackageSlot').text(0);

                    appType = row.find('.docAppointmentType').val();
                } else {
                    doctorID = $(row).find('#tdInvestigation_Id').text().trim();
                    appType = 2;
                    IsSlotWiseToken = 1;
                    $('#spnSelectedDoctor').text($(row).find('#tdInvestigationName').text().trim() + '   ( ' + $(row).find('#tdVisitType').text().trim() + ' )');
                    $('#spnSelectedDoctorID').text(doctorID);
                    $('#spnSelectedDoctorIsSlotWiseToken').text(1);
                    $('#spnPackageIDforSlot').text($(row).find('#tdPackageID').text().trim());
                    $('#spnModalIsPackageSlot').text(1);
                }

                if (isHelpDeskBooking == 0) {
                    if (Number(appointmentID) == 0) {
                        if (Number(appType) != 0) {
                            if (Number(appType) == 2 && IsSlotWiseToken == 0) {
                                $getDoctorAppointmentTimeSlot(doctorID, 0, false, IsSlotWiseToken, isPackageDoctor, function (response) { });
                            }
                            else if (Number(appType) == 2 && IsSlotWiseToken == 1) {
                                $getDoctorAppointmentTimeSlot(doctorID, 0, true, IsSlotWiseToken, isPackageDoctor, function (response) { });
                            }
                            else {
                                $getDoctorAppointmentTimeSlot(doctorID, 1, true, IsSlotWiseToken, isPackageDoctor, function (response) { });
                            }
                        }
                    } else {
                        row.find('.docAppointmentType').attr('disabled', 'disabled');
                        appType = 2;
                        row.find('#imgViewDocCalender').removeAttr('onclick').attr('data-title', 'Appointment Reschedule');;
                    }
                }
          
            showDoctorTokenNo(el, function () { });
        }


        var showDoctorTokenNo = function (el) {
         
            var selectedData = JSON.parse($(el).closest('tr').find('#spnData').text());
            var appointmentDate = $('#lblAppointmentCurrentDate').text();
            var selectedBookingDateTime = $(el).closest('tr').find('#spnDocAppointmentDateTime').text();
            if (selectedBookingDateTime != "")
                appointmentDate = selectedBookingDateTime.split('#')[0];

            data = {
                doctorID: selectedData.Type_ID,
                appointmentDate: appointmentDate
            }

            getAppointmentCountDoctorWise(data, function () { });
        }

        var getAppointmentCountDoctorWise = function (data) {
           
            serverCall('Lab_PrescriptionOPD.aspx/GetAppointmentCount', data, function (response) {
                if (!String.isNullOrEmpty(response))
                    $('#btnAppointmentCount b').text(response);
                else
                    $('#btnAppointmentCount b').text('00');
            });
        }

        var $getDoctorAppointmentTimeSlot = function (doctorID, isManualSlot, isModelShow, IsSlotWiseToken, isPackageDoctor, callback) {
           
            var appointmentDate = $("#txtAppointmentSlotDate").val();
            var centreID = '<%= HttpContext.Current.Session["CentreID"]%>'
            var appSlotMin = $('#ddlSolotMin').val();

            serverCall('Lab_PrescriptionOPD.aspx/GetDoctorAppointmentTimeSlotConsecutive', { DoctorId: doctorID, _appointmentDate: appointmentDate, appointmentType: 2, centreId: centreID, AppSlot: appSlotMin, IsManualSlot: isManualSlot }, function (response) {
               
                var responseData = JSON.parse(response);

                var divSlotAvailabilityBody = $('#divSlotAvailabilityBody').find('.slotDetails');
                var divSlotAvailabilityHead = $('#divSlotAvailabilityBody').find('.patientInfo');
                for (var i = 0; i < responseData.response.length; i++) {
                    $(divSlotAvailabilityHead[i]).text(responseData.response[i].appointmentDate);
                    $(divSlotAvailabilityBody[i]).html(responseData.response[i].response);
                }

                //  $('#txtAppointmentSlotDate').val(responseData.response[0].appointmentDate);

                var $responseData = responseData.response[0];
                if (true) {



                    $('#divSlotAvailabilityBody div #spnAppointmentTime').each(function (index, elem) {
                        if ($.trim($(elem).text()) == $responseData.defaultAvilableSlot) {
                            var currentAppointmentDate = $(elem).closest('.col-md-5').find('.patientInfo').text();
                            var defaultAppointmentDate = $('#txtAppointmentSlotDate').val();
                            if (defaultAppointmentDate == currentAppointmentDate)
                                $(elem).parent().addClass('badge-pink');
                        }
                    });
                    if (isModelShow)
                        $('#divSlotAvailability').showModel();
                    else {
                        var slotTiming = $responseData.appointmentDate + '#' + $responseData.defaultAvilableSlot;
                        var slotTimingDisplay = $responseData.appointmentDate + ' ' + $responseData.defaultAvilableSlot;
                        //  modelAlert(slotTiming);
                        if ($responseData.defaultAvilableSlot != undefined && $responseData.defaultAvilableSlot != '') {
                            $('#tbSelected').find('.selectedDoctorAvailaility').find('#spnDocAppointmentDateTime').text(slotTiming);
                            $('#tbSelected').find('.selectedDoctorAvailaility').find('#imgViewDocCalender').attr('data-title', slotTimingDisplay);
                            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                        }
                        else {
                            modelAlert('Slot Not Avilable.');
                        }
                    }

                    MarcTooltips.add('div .badge-avilable', 'Select Slot for Block', {
                        position: 'up',
                        align: 'left'
                    });


                    //callback(appointmentDate);
                }
                else {
                    modelAlert($responseData.response, function () {
                        clearAppointMentDetails(true);
                    });

                }
            });
        }

        var clearAppointMentDetails = function (isModelShow) {
            if (!isModelShow) {
                $('#divSlotAvailabilityBody').find('.slotDetails').html('');
                $('#divSlotAvailabilityBody').find('.patientInfo').html('');
            }
        }

        //dev
        var OnSelectPackageDoctorSlot = function (rowID) {
            var row = $(rowID).closest('tr');
            var doctorID = $(row).find('#tdInvestigation_Id').text();
            var packageID = $(row).find('#tdPackageID').text();
            $('#spnSelectedDoctorID').text(doctorID);
            $('#spnPackageIDforSlot').text(packageID);
            $('#spnModalIsPackageSlot').text(1);
            $getDoctorAppointmentTimeSlotNew(1, rowID, function () { });
            //  $getDoctorAppointmentTimeSlot(doctorID, 1, true, 5, function (response) {});
        }

        showPackageItems = function (el) {
         
            if ($(el).hasClass('imgPlus')) {
                $(el).attr('src', '../../Images/minus.png').removeClass('imgPlus').addClass('imgMinus');

                    if (Number($(el).closest('tr').find('#spnIsPackageView').text()) == 0) {
                        $bindPackageDetails(el, function () {
                            $bindPackageConsultationDoctor(el, function () {
                                $(el).closest('tr').find('#spnIsPackageView').text('1');
                                $(el).closest('tr').next().show();
                            });
                        });
                    }
                    else
                        $(el).closest('tr').next().show();
                }
                else {
                    $(el).attr('src', '../../Images/plus_in.gif').removeClass('imgMinus').addClass('imgPlus');
                    $(el).closest('tr').next().hide();
                }
            }
            $bindPackageDetails = function (el, callback) {
                var selectedData = JSON.parse($(el).closest('tr').find('#spnData').text());
                var packageID = selectedData.Type_ID;

            serverCall('../Common/CommonService.asmx/bindPackageItemDetailsNew', { PackageID: packageID }, function (response) {
                packageDetailsData = JSON.parse(response);
                if (packageDetailsData != null) {
                    var output = $('#templatePackageDetails').parseTemplate(packageDetailsData);
                    $(el).closest('tr').next().find('#divPackageDetails').html(output);
                    MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                    callback(true);
                }
                else {
                    $(el).closest('tr').next().find('#divPackageDetails').html('');
                    callback(false);
                }
            });
        }
       
        $bindPackageConsultationDoctor = function (el, callback) {
            $(el).closest('tr').next().find('#divPackageDetails').find('#tableInvestigation tr').each(function (index, row) {
                var doctorID = $(this).find('#tdInvestigation_Id').text();
                var packageType = $(this).find('#tdPackageType').text();
                if ((String.isNullOrEmpty(doctorID) || doctorID == '0') && packageType=='2') {
                  
                    var doctorDepartmentID = $(this).find('#tdDepartment').text();// $(this).find('#tdDocDepartmentID').text();
                    var dropDown = $(this).find('#ddlPackageDoctor');
                    $bindPackageConsultationDoctorDepartmentWise(dropDown, doctorDepartmentID);
                }
            });
            callback(true);
        }

        var $bindPackageConsultationDoctorDepartmentWise = function (dropdown, department) {
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                dropdown.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                dropdown.chosen("destroy").chosen({ width: '200px' });
            });
        }

        $onConsultationDoctorChange = function (elem) {
            $row = $(elem).closest('tr');
            $row.find('#tdInvestigation_Id').text(elem.value);
        }
        $checkPackageExpiry = function (packageID, tnxType, callback) {
            if (tnxType != '23') {
                callback(false);
            }
            else {
                serverCall('../Common/CommonService.asmx/PackageExpirayDate', { PackageID: packageID }, function (response) {
                    if (response == '1')
                        callback(false);
                    else
                        callback(true);
                });
            }
        }
        var $selectSlot = function (elem) {
            $('#divSlotAvailabilityBody .circle').removeClass('badge-pink');
            $(elem).addClass('badge-pink');
        }

        var $dobuleClick = function (elem) {
            var slotTiming = $(elem).closest('.slotDetails').prev().text() + '#' + $.trim($(elem).find('#spnAppointmentTime').text());
            var slotTimingDisplay = $(elem).closest('.slotDetails').prev().text() + ' ' + $.trim($(elem).find('#spnAppointmentTime').text());

            if ($('#spnModalIsPackageSlot').text() == '1') {
                $('.packageItems table tbody tr').each(function () {
                    if ($(this).find('#tdPackageID').text() == $('#spnPackageIDforSlot').text().trim() && $(this).find('#tdInvestigation_Id').text() == $('#spnSelectedDoctorID').text()) {
                        $(this).find('#tdPkgeAppointmentDate').text(slotTiming);
                        $(this).find('#imgPkgViewDocCalender').attr('data-title', slotTiming);
                    }
                });
            }
            else {
                //  modelAlert(slotTiming);
                $('#tbSelected').find('.selectedDoctorAvailaility').find('#spnDocAppointmentDateTime').text(slotTiming);
                $('#tbSelected').find('.selectedDoctorAvailaility').find('#imgViewDocCalender').attr('data-title', slotTimingDisplay);
                MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            }
            data = {
                doctorID: $('#spnSelectedDoctorID').text(),
                appointmentDate: $(elem).closest('.slotDetails').prev().text(),
            }
            getAppointmentCountDoctorWise(data, function () { });

            $('#divSlotAvailability').closeModel();


        }

        var onNextPrevDateChange = function (addDays, callback) {
            var data = {
                selectedDate: $('#txtAppointmentSlotDate').val(),
                addDays: addDays
            };
            onNextPreDataBind(data, function () { });

        }

        var onNextPreDataBind = function (data) {
            serverCall('Lab_PrescriptionOPD.aspx/NextPrevDate', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    $('#txtAppointmentSlotDate').val(responseData.calculatedAppointmentDate).change();
                else
                    modelAlert(responseData.message, function () { });
            });
        }
        var $validateDoctorCalender = function (el) {
         
            var row = JSON.parse($(el).closest('tr').find('#spnData').text());
            var isSlotWiseToken = row.isSlotWiseToken;
            var appointmentID= row.appointmentID;
            if (($(el).val() == '2' || $(el).val() == '0') && isSlotWiseToken == 0 && appointmentID==0)
                $(el).closest('tr').find('#imgViewDocCalender').removeAttr('onclick');
            else if (($(el).val() == '2' || $(el).val() == '0') && appointmentID == 1) {
                $(el).closest('tr').find('#imgViewDocCalender').removeAttr('onclick');
                $(el).attr('disabled', 'disabled');
            }
            else
                $(el).closest('tr').find('#imgViewDocCalender').attr('onclick', '$getDoctorAppointmentTimeSlotNew(0,this,function (response) {});');

            $(el).closest('tr').find('#spnAppointmentType').text($(el).val());

            $getDoctorAppointmentTimeSlotNew(0, el, function (response) { });

            $clearPaymentControl(function () {
                $updatePaymentAmount(function () { });
            });
        }
        var onItemDoctorChange = function (el) {
            $(el).closest('tr').find('#spnItemDoctorID').text($(el).val());
        }


        $labItemRateQuantityDiscountChange = function (e) {
            var inputValueCode = (e.which) ? e.which : e.keyCode;
            if ([37, 38, 39, 40].indexOf(inputValueCode) < 0) {
                $row = $(e.target).parent().parent();
                $qty = Number($row.find('#txtQuantity').val());
                $rate = Number($row.find('#txtRate').val());
                $amount = $qty * $rate;
                $discountPrecent = Number($row.find('#txtDiscount').val());
                var maxEligibleDiscountPercent = Number('<%=Util.GetDecimal(ViewState["maxEligibleDiscountPercent"])%>');
                if (e.target.id == 'txtDiscountAmount') {
                    var discountAmount = Number(e.target.value);
                    $discountPrecent = ((discountAmount * 100) / $amount);
                    $row.find('#txtDiscount').val(precise_round($discountPrecent, 2));
                }
                $discountAmount = 0;
                if ($discountPrecent > 0)
                    $discountAmount = (($amount * $discountPrecent) / 100);

                if (e.target.id != 'txtDiscountAmount')
                    $($row).find('#txtDiscountAmount').val($discountAmount);


                if (maxEligibleDiscountPercent < $discountPrecent) {
                    modelAlert('You are eligible upto ' + maxEligibleDiscountPercent + '% discount.');
                    $discountAmount = 0;
                    $discountPrecent = 0;
                    $row.find('#txtDiscount').val(precise_round($discountPrecent, 2));
                    $row.find('#txtDiscountAmount').val(precise_round($discountAmount, 2));
                }

                $($row).find('#txtAmount').val(precise_round(($amount - $discountAmount), 2));
                $updatePaymentAmount(function () { });
            }
        }


        $removeLabItems = function (elem) {
            $(elem).closest('tr').remove();
            var packageRow = $.trim('#tr_packageItem' + $(elem).closest('tr').attr('id'));
            $('#tbSelected').find(packageRow).remove();
            $updatePaymentAmount(function () { });
        };


        var onPanelCurrencyFactorChange = function (callback) {
            $('#tbSelected tbody').find('tr').remove();
            $updatePaymentAmount(function () { callback(); });
        }



        $checkAlreadyPrescribe = function (data, callBack) {
            if (data.PatientID.trim() != '') {
                serverCall('Services/LabPrescription.asmx/getAlreadyPrescribeItem', data, function (response) {
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

        $getItemRate = function (panelID, investigation, panelCurrencyFactor, callback) {
            $PanelID = panelID;
            $ItemID = investigation.item.val;
            $TID = ''; ///add later
            $IPDCaseTypeID = '';///add later
            serverCall('../common/CommonService.asmx/bindLabInvestigationRate', { PanelID: $PanelID, ItemID: $ItemID, TID: $TID, IPDCaseTypeID: $IPDCaseTypeID, panelCurrencyFactor: panelCurrencyFactor }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    callback(responseData[0]);
                }
                else
                    callback({ Rate: 0, ID: 0, ScheduleChargeID: 0, ItemCode: '', ItemDisplayName: '' });
            });
        }

        $bindCategory = function (callback) {
           var Type = Number($('#ddlFilterType').val());// Number($('input[type=radio][name=labItems]:checked').val());
            $ddlCategory = $('#ddlCategory');
            //  serverCall('../common/CommonService.asmx/BindCategory', { Type: $labItem }, function (response) {
            var responseData = [];

            if (Type == "2")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && i.ConfigID == '25' });
            else if (Type == "3")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && ['6', '20'].indexOf(i.ConfigID) > -1 });
            else if (Type == "4")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && i.ConfigID == '5' });
            else if (Type == "9")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && i.ConfigID == '3' && i.CategoryID == '3' });
            else if (Type == "10")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && i.ConfigID == '3' && i.CategoryID == '7' });
            else if (Type == "11")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && i.ConfigID == '23' });
			else if (Type == "12")//BB
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && i.ConfigID == '7' });	
            else if (Type == "10000")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && i.ConfigID == '-1' });
            else if (Type == "100")
            {
           
                var UserFilterRights = RoleWisePageChache.filter(function (i) { return i.TypeID == '1' });

                var ConfigIDArray = new Array(UserFilterRights[0].ConfigID);
                var ConfigIDs = ConfigIDArray.join(',');

                var CategoryArray = new Array(UserFilterRights[0].CategoryID);
                var CategoryIDs = CategoryArray.join(',');

                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '3' && ConfigIDs.indexOf(i.ConfigID) > -1 && CategoryIDs.indexOf(i.CategoryID) <= -1 });

            }

           // var d = { data: JSON.parse(response), valueField: 'CategoryID', textField: 'Name', isSearchAble: true }

            var d = { defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true }

                $ddlCategory.bindDropDown(d);
                $bindSubCategory(Type, $ddlCategory.val(), function () {
                    callback($ddlCategory.val());
                });
           // });
        }

        $bindSubCategory = function (Type, categoryID, callback) {
            $subCategory = $('#ddlSubCategory');
            //  serverCall('../common/CommonService.asmx/BindSubCategory', { Type: labItem, CategoryID: categoryID }, function (response) {

            var responseData = [];

            if (categoryID != "0")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && i.CategoryID == categoryID });
            else if (Type == "2")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && i.ConfigID == '25' });
            else if (Type == "3")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && ['6', '20'].indexOf(i.ConfigID) > -1 });
            else if (Type == "4")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && i.ConfigID == '5' });
            else if (Type == "9")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && i.ConfigID == '3' && i.CategoryID == '3' });
            else if (Type == "10")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && i.ConfigID == '3' && i.CategoryID == '7' });
            else if (Type == "11")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && i.ConfigID == '23' });
            else if (Type == "10000")
                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && i.ConfigID == '-1' });
            else if (Type == "100") {
                var UserFilterRights = RoleWisePageChache.filter(function (i) { return i.TypeID == '1' });
                var ConfigIDArray = new Array(UserFilterRights[0].ConfigID);
                var ConfigIDs = ConfigIDArray.join(',');

                var CategoryArray = new Array(UserFilterRights[0].CategoryID);
                var CategoryIDs = CategoryArray.join(',');

                responseData = RoleWisePageChache.filter(function (i) { return i.TypeID == '4' && ConfigIDs.indexOf(i.ConfigID) > -1 && CategoryIDs.indexOf(i.CategoryID) <= -1 });

            }
            //var d = { data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true };
            var d = { defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true };
            if (Type == 4)
                    d.selectedValue = '<%=Resources.Resource.FirstVisitSubCategoryID%>';


                $subCategory.bindDropDown(d);
                callback($subCategory.val());
           // });
        }


var onSearchTypeChange = function (el) {
    var type = Number($(el).val());
    $bindCategory(function () { });
}



var $getHashCode = function (callback) {
    serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
        $('#spnHashCode').text(response);
        callback(true);
    });
}

$getLabItemsDetails = function (callback) {

    var response = {};
    response.reportDispatchModeID = $('#ddlDispatchMode').val();
    response.hashCode = $('#spnHashCode').text(),
    response.ScheduleChargeID = $('#lblScheduleChargeID').text();
    response.Type = 'OPD';
    response.labItemsDetails = [];
    response.packageInvestigationDetails = [];
    response.packageConsultationDetails = [];


    $tbSelectedTrs = $('#tbSelected .billingRow .nonPackageItems').clone();
    var labitems = $($tbSelectedTrs);
    $(labitems).each(function (index, row) {
        $rate = Number($(row).find('#txtRate').val().trim());
        $quantity = Number($(row).find('#txtQuantity').val().trim());
        $amount = Number($(row).find('#txtAmount').val().trim());
        $discountPerCent = Number($(row).find('#txtDiscount').val().trim());
        $discountAmount = Number($(row).find('#txtDiscountAmount').val().trim());
        $itemName = $(row).find('#spnItemName').text().trim();
        $tnxTypeID = $(row).find('#spnTnxTypeID').text().trim();
        $typeOfApp = '';
        $appointmentDateTime = '';
        $doctorID ='0';
        if ($tnxTypeID == '5') {
            $typeOfApp = $(row).find('#spnAppointmentType').text();
            $appointmentDateTime = $(row).find('#spnDocAppointmentDateTime').text().trim();
        }
        else
            $typeOfApp = '0';

        if ($tnxTypeID != '5' && $tnxTypeID != '23') {
            $doctorID = $(row).find('#spnItemDoctorID').text().trim();
        }
        if ($(row).find('#spnItemDisplayName').text().trim() != "")
            $itemName = $(row).find('#spnItemDisplayName').text().trim();
        response.labItemsDetails.push({
            itemCode: $(row).find('#spnItemCode').text().trim(),
            itemName: $itemName,
            ItemID: $(row).find('#spnItemID').text().trim(),
            Type_ID: $(row).find('#spnInvestigationID').text().trim(),
            presceibedID: $(row).find('#spnPresceibed_ID').text().trim(),
            IsAdvance: $(row).find('#spnIsAdvance').text().trim(),
            IsUrgent: ($(row).find('#chkIsUrgent').is(':checked')) ? 1 : 0,//$(row).find('#spnIsUrgent').text().trim(),
            RateListID: $(row).find('#spnRateListID').text().trim(),
            IsOutSource: $(row).find('#spnIsOutSource').text().trim(),
            rateItemCode: $(row).find('#spnRateItemCode').text().trim(),
            remark: $(row).find('#txtRemarks').val().trim(),
            rate: $rate,
            quantity: $quantity,
            amount: $amount,
            TnxTypeID: $tnxTypeID,
            SubCategoryID: $(row).find('#spnSubCategoryID').text().trim(),
            sampleType: $(row).find('#spnSampleType').text().trim(),
            LabType: $(row).find('#spnLabType').text().trim(),
            DiscAmt: $discountAmount,
            DisPerCent: $discountPerCent,
            IsPayable: $(row).find('#spnIsPayable').text().trim(),
            CoPayPercent: $(row).find('#spnCoPaymentPercent').text().trim(),
            IsPanelWiseDiscount: $(row).find('#spnIsPanelWiseDiscount').text().trim(),
            isMobileBooking: Number($(row).find('#spnisMobileBooking').text()),
            CategoryID: $(row).find('#spnCategoryID').text().trim(),
            salesID: $(row).find('#spnSalesID').text().trim(),
            isDocCollect:0,// ($(row).find('#chkDocCollect').is(':checked')) ? 1 : 0,
            docCollectAmt:0, //($(row).find('#chkDocCollect').is(':checked')) ? Number($(row).closest('tr').find('#spnDocCollect').text().trim().split(':')[1]) : 0,
            appointmentDateTime: $appointmentDateTime,
            typeOfApp: $typeOfApp,
            doctorID: $doctorID,
            BookingDate: $(row).find('#spnInvestigationSlotDate').text().trim(),
            BookingTime: $(row).find('#spnInvestigationSlotTime').text().trim(),
            BookinginModality: ($(row).find('#spnInvestigationSlotModality').text() == "null" || $(row).find('#spnInvestigationSlotModality').text() == "undefined" || $(row).find('#spnInvestigationSlotModality').text() == "" ) ? '0' : $(row).find('#spnInvestigationSlotModality').text(),
            IsSlotWiseToken: $(row).find('#spnIsSlotWiseToken').text().trim(),
            appointmentID: $(row).find('#spnRescheduleAppointmentID').text().trim(),
        });
    });

  
    //$tbPackSelectedTrs = $('#tbSelected .billingRow .packageItems').clone();
    //var packItemsRows = $($tbPackSelectedTrs);
    $('#tbSelected .billingRow .packageItems').each(function (index, row) {
       // alert(index);
      //  console.log($(row)[index]);

        $(row).find('#divPackageDetails').find('#tableInvestigation tbody tr').each(function (i, r) {
            //alert(r);
            var selectedRow = $(r);
            var packageType = $.trim(selectedRow.find('#tdPackageType').text());
            if (packageType == '1') {
                response.packageInvestigationDetails.push({
                    investigationName: $.trim(selectedRow.find('#tdInvestigationName').text()),
                    quantity: $.trim(selectedRow.find('#tdPackItemQuantity').text()),
                    subcategory: $.trim(selectedRow.find('#tdSubCategoryIDInv').text()),
                    rate: 0,
                    investigationID: $.trim(selectedRow.find('#tdInvestigation_Id').text()),
                    sampleType: $.trim(selectedRow.find('#tdSampleType').text()),
                    itemID: $.trim(selectedRow.find('#tdPackItemItemID').text()),
                    outSource: $.trim(selectedRow.find('#tdOutSource').text()),
                    StockID: $.trim(selectedRow.find('#tdStockID').text()),
                    packageID: $.trim(selectedRow.find('#tdPackageID').text()),
                    bookingDate: $.trim(selectedRow.find('#tdPkgBookingDate').text()),
                    bookingTime: $.trim(selectedRow.find('#tdPkgBookingTime').text()),
                    bookinginModality: $.trim(selectedRow.find('#tdPkgModality').text()) == "" ? "0" : $.trim(selectedRow.find('#tdPkgModality').text()),
                    categoryID: $.trim(selectedRow.find('#tdCategoryID').text()),
                });
            }
            if (packageType == '2') {
                response.packageConsultationDetails.push({
                    visitType: $.trim(selectedRow.find('#tdVisitType').text()),
                    department: $.trim(selectedRow.find('#tdDepartment').text()),
                    doctorName: $.trim(selectedRow.find('#tdInvestigationName').find('select option:selected').text()) == '' ? $.trim(selectedRow.find('#tdInvestigationName').text()) : $.trim(selectedRow.find('#tdInvestigationName').find('select option:selected').text()),
                    doctorID: $.trim(selectedRow.find('#tdInvestigation_Id').text()),
                    subCategoryID: $.trim(selectedRow.find('#tdSubCategoryIDInv').text()),
                    docDepartmentID: $.trim(selectedRow.find('#tdSubCategoryIDInv').text()),
                    packageID: $.trim(selectedRow.find('#tdPackageID').text()),
                    isSlotWiseToken: $.trim(selectedRow.find('#tdPkgIsSlotWiseToken').text()),
                    appointmentDate: $.trim(selectedRow.find('#tdPkgeAppointmentDate').text()),
                    investigationID: $.trim(selectedRow.find('#tdInvestigation_Id').text()),
                });
            }
        });
    });

    var unselectedInvSlotWithoutPackage = response.labItemsDetails.filter(function (aa) { if (Number(aa.CategoryID) == 7) return (String.isNullOrEmpty(aa.BookingDate) && String.isNullOrEmpty(aa.BookingTime)) && aa.isSlotWiseToken==1});
    var unselectedDoctor = response.packageConsultationDetails.filter(function (doctor) { return (String.isNullOrEmpty(doctor.doctorID) == true || doctor.doctorID == '0') });
    var unselectedInvSlot = response.packageInvestigationDetails.filter(function (modality) { if (modality.categoryID == 7 && IsInvestigationAppointment==1) return (String.isNullOrEmpty(modality.bookingDate) && String.isNullOrEmpty(modality.bookingTime)) });
    var unselectedAppSlot = response.packageConsultationDetails.filter(function (app) { if (app.isSlotWiseToken == '1') return (String.isNullOrEmpty(app.appointmentDate)) });

    if (unselectedInvSlotWithoutPackage.length > 0) {
        modelAlert('Please Select Slot For Investigations', function () { });
        return false;
    }

    if (unselectedDoctor.length > 0) {
        modelAlert('Please Select Package Doctor', function () { });
        return false;
    }
    if (unselectedInvSlot.length > 0) {
        modelAlert('Please Select Slot For Package Investigations');
        return false;
    }
    if (unselectedAppSlot.length > 0) {
        modelAlert('Please Select Slot For Package Doctors');
        return false;
    }

    //console.log(response);
    callback(response);
}

$getLabPrescriptionDetails = function (callback) {

    var validateStatus = true;
    $('#Pbody_box_inventory .requiredField').each(function (index, elem) {
        if ($.trim($(elem).val()) == '' || $.trim($(elem).val()) == '0') {
            validateStatus = false;
            modelAlert(this.attributes['errorMessage'].value, function () {

            });
            return false;
        }
    });
    if (!validateStatus)
        return false;
    $getPatientDetails(function (patientDetails) {
        $getLabItemsDetails(function (labPrescriptionDetails) {
            $getPaymentDetails(function (payment) {
                $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                var RoleID = '<%=Session["RoleID"].ToString()%>';
                var CentreID = '<%=Session["CentreID"].ToString()%>';
                var autoPaymentModepage = false;
                //if (RoleID == 104 && CentreID == 1) {
                //     $isReceipt = false;
                //     autoPaymentModepage = true;
                // }
                // else {
                //    $isReceipt = '' == '1' ? true : false;
                // }
                $PM = patientDetails.defaultPatientMaster;
                $PMH = patientDetails.defaultPatientMedicalHistory;

                $PMH.HashCode = labPrescriptionDetails.hashCode;
                $PMH.ScheduleChargeID = labPrescriptionDetails.ScheduleChargeID;
                $PMH.Type = labPrescriptionDetails.Type;
                $PMH.PatientPaybleAmt = payment.patientPayableAmount;
                $PMH.PanelPaybleAmt = payment.panelPayableAmount;
                $PMH.PatientPaidAmt = payment.patientPaidAmount;
                $PMH.PanelPaidAmt = payment.panelPaidAmount;
                $PMH.IsVisitClose = 1;
                $PMH.CorporatePanelID = patientDetails.CorporatePanelID;
                $PMH.ReferralTypeID = patientDetails.ReferralTypeID;
                $LT = {
                    PanelID: patientDetails.PanelID,
                    NetAmount: payment.netAmount,
                    GrossAmount: payment.billAmount,
                    DiscountReason: payment.discountReason,
                    DiscountApproveBy: payment.approvedBY,
                    DiscountOnTotal: payment.discountAmount,
                    RoundOff: payment.roundOff,
                    GovTaxPer: 0,
                    GovTaxAmount: 0,
                    IPNo: '',//for do latar
                    Adjustment: $isReceipt ? payment.adjustment : 0,
                    UniqueHash: labPrescriptionDetails.hashCode,
                }
                $LTD = [];
                $urgentTest = [];

                            var itemWiseDiscountTotal = 0;
                            labPrescriptionDetails.labItemsDetails.filter(function (i) { itemWiseDiscountTotal = itemWiseDiscountTotal + i.DiscAmt });
                            directDiscountOnBill = itemWiseDiscountTotal > 0 ? false : true;
                            $(labPrescriptionDetails.labItemsDetails).each(function () {
                                var itemDetails = {
                                    IsPackage: '0',
                                    IsAdvance: this.IsAdvance,
                                    ItemID: this.ItemID,
                                    Rate: this.rate,
                                    Quantity: this.quantity,
                                    DiscAmt: itemWiseDiscountTotal > 0 ? this.DiscAmt : (this.amount * payment.discountPercent / 100),
                                    Amount: itemWiseDiscountTotal > 0 ? this.amount : (this.amount - (this.amount * payment.discountPercent / 100)),
                                    DiscountPercentage: itemWiseDiscountTotal > 0 ? this.DisPerCent : payment.discountPercent,
                                    SubCategoryID: this.SubCategoryID,
                                    ItemName: this.itemName,
                                    DiscountReason: payment.discountReason,
                                    DoctorID: this.doctorID == '0' ? patientDetails.Doctor.value : this.doctorID,
                                    Type: this.LabType,
                                    Type_ID: this.Type_ID,
                                    TnxTypeID: this.TnxTypeID,
                                    sampleType: this.sampleType,
                                    RateListID: this.RateListID,
                                    IsOutSource: this.IsOutSource,
                                    rateItemCode: this.rateItemCode,
                                    CoPayPercent: this.CoPayPercent,
                                    IsPayable: this.IsPayable,
                                    isPanelWiseDisc: this.IsPanelWiseDiscount,
                                    panelCurrencyCountryID: patientDetails.panelDetails.panelCurrencyCountryID,
                                    panelCurrencyFactor: patientDetails.panelDetails.panelCurrencyFactor,
                                    isMobileBooking: this.isMobileBooking,
                                    CategoryID: this.CategoryID,
                                    salesID: this.salesID,
                                    remark: this.remark,
                                    isDocCollect: this.isDocCollect,
                                    docCollectAmt: this.docCollectAmt,
                                    typeOfApp: this.typeOfApp,
                                    appointmentDateTime: this.appointmentDateTime,
                                    BookingDate: this.BookingDate,
                                    BookingTime: this.BookingTime,
			                        BookinginModality: this.BookinginModality,
			                        IsSlotWiseToken: this.IsSlotWiseToken,
			                        appointmentID : this.appointmentID,
                                };

                    if (payment.isCoPaymentOnBill == 1)
                        itemDetails.CoPayPercent = payment.coPaymentPercent;

                    $LTD.push(itemDetails);

                    $urgentTest.push({
                        PatientTest_ID: this.presceibedID,
                        isUrgent: this.IsUrgent,
                    });
                });

                // Package Items 
                $(labPrescriptionDetails.packageInvestigationDetails).each(function () {

                                $LTD.push({
                                    PackageType: '1',
                                    IsPackage: '1',
                                    PackageID: this.packageID,
                                    ItemName: this.investigationName,
                                    Quantity: this.quantity,
                                    Amount: this.rate * this.quantity,
                                    SubCategoryID: this.subcategory,
                                    ItemID: this.itemID,
                                    Rate: this.rate,
                                    DiscAmt: 0,
                                    DiscountPercentage: 0,
                                    Investigation_ID: this.investigationID,
                                    sampleType: this.sampleType,
                                    IsOutSource: this.outSource,
                                    panelCurrencyCountryID: patientDetails.panelDetails.panelCurrencyCountryID,
                                    panelCurrencyFactor: patientDetails.panelDetails.panelCurrencyFactor,
                                    StockID: this.StockID,
                                    IsAdvance: 0,
                                    DiscountReason: payment.discountReason,
                                    DoctorID: patientDetails.Doctor.value,
                                    CoPayPercent: 0,
                                    IsPayable: 0,
                                    isPanelWiseDisc: 0,
                                    isMobileBooking: 0,
                                    salesID: 0,
                                    remark: '',
                                    isDocCollect: 0,
                                    docCollectAmt: 0,
                                    typeOfApp: '0',
                                    TnxTypeID: 23,
                                    Type_ID: this.investigationID,
                                    BookingDate: this.bookingDate,
                                    BookingTime: this.bookingTime,
                                    BookinginModality: this.bookinginModality,
                                });
                            })

                $(labPrescriptionDetails.packageConsultationDetails).each(function () {
                    $LTD.push({
                        PackageType: '2',
                        IsPackage: '1',
                        PackageID: this.packageID,
                        SubCategoryID: this.subCategoryID,
                        Quantity: 1,
                        DiscAmt: 0,
                        DiscountPercentage: 0,
                        ItemName: this.doctorName,
                        DoctorID: this.doctorID,
                        // Rate: this.rate,
                        // ItemID: this.ItemID,
                        // RateListID: this.RateListID
                        panelCurrencyCountryID: patientDetails.panelDetails.panelCurrencyCountryID,
                        panelCurrencyFactor: patientDetails.panelDetails.panelCurrencyFactor,
                        StockID: '',
                        IsAdvance: 0,
                        DiscountReason: payment.discountReason,
                        DoctorID: this.doctorID,
                        CoPayPercent: 0,
                        IsPayable: 0,
                        isPanelWiseDisc: 0,
                        isMobileBooking: 0,
                        salesID: 0,
                        remark: '',
                        isDocCollect: 0,
                        docCollectAmt: 0,
                        typeOfApp: '2',
                        TnxTypeID: 5,
                        Type_ID: this.investigationID,
                        appointmentDateTime: this.appointmentDate,
                        IsSlotWiseToken: this.isSlotWiseToken,
                    });
                })


                $PaymentDetail = [];

                $(payment.paymentDetails).each(function () {
                    $PaymentDetail.push({
                        PaymentMode: this.PaymentMode,
                        PaymentModeID: this.PaymentModeID,
                        S_Amount: this.S_Amount,
                        S_Currency: this.S_Currency,
                        S_CountryID: this.S_CountryID,
                        BankName: this.BankName,
                        RefNo: this.RefNo,
                        BaceCurrency: this.BaceCurrency,
                        C_Factor: this.C_Factor,
                        Amount: this.Amount,
                        S_Notation: this.S_Notation,
                        PaymentRemarks: this.paymentRemarks,
                        swipeMachine: this.swipeMachine,
                        currencyRoundOff: payment.currencyRoundOff / payment.paymentDetails.length
                    });
                });

                if (labPrescriptionDetails.labItemsDetails.length < 1) {
                    modelAlert('Please Select Investigation ');
                    return false;
                }

                var totalQuantity = 0;
                var zeroRateItems = $LTD.filter(function (i) {
                    totalQuantity += i.Quantity;
                    if (i.SubCategoryID != '<%=Resources.Resource.FollowUpVisitSubCategoryID%>' && i.IsPackage=='0') {
                        if (i.Rate == 0)
                            return i;
                    }
                });

                if (zeroRateItems.length > 0) {
                   
                    // modelAlert('Zero Rate Items Are Not Allow');                    
                   // return false;
                }


                var appointmentSlotNotSelect = $LTD.filter(function (i) {
                    if (i.TnxTypeID == '5' && i.IsPackage == '0' && i.appointmentDateTime == '' && i.appointmentID =='0')
                        return i;
                });

                if (appointmentSlotNotSelect.length > 0) {
                    modelAlert('Please Select Doctor Appointment Slot');
                    return false;
                }

                var itemWiseDoctorNotSelect = $LTD.filter(function (i) {
                    if (i.TnxTypeID != '5' && i.TnxTypeID != '23' && i.IsPackage == '0' && (i.DoctorID == '' || i.DoctorID == '0'))
                        return i;
                });

                if (itemWiseDoctorNotSelect.length > 0) {
                    modelAlert('Please Select Item-Wise Doctor');
                    return false;
                }


                if (totalQuantity < 1) {
                    modelAlert('Please Enter Valid Quantity');
                    return false;
                }

                //if (String.isNullOrEmpty($PMH.PanelIgnoreReason) && $('#divPanelRequiredDocuments button').length > 0 && patientDetails.panelDocuments <= 0) {
                if (String.isNullOrEmpty($PMH.PanelIgnoreReason) && (Number($('#divPanelRequiredDocuments button').length) > Number(patientDetails.panelDocuments.length))) {
                    modelAlert('All Panel Document Required...!!!<br/> Please Upload');
                    return false;
                }

                var nonAppointmentItems = $LTD.filter(function (i) { return i.TnxTypeID != 5 });
                if ($PaymentDetail.length < 1 && '<%=Resources.Resource.IsReceipt %>' == '1') {
                    modelAlert('Please Select Payment Details');
                    return false;
                }
                var panelPaidAmountrow = 0;
                _divPaymentControlParent.find('#divPaymentDetails #tdPaymentModeID').each(function () {
                    if (Number($(this).text()) == 8)
                        panelPaidAmountrow += Number($(this).closest('tr').find('#tdBaseCurrencyAmount').text());
                });
                var $totalPaidAmountpatient = $LT.Adjustment - panelPaidAmountrow;
                if ($PaymentDetail[0].PaymentModeID != 4) {
                    if (nonAppointmentItems.length > 0) {
                        if ($PMH.PatientPaybleAmt > 0) {
                            //if ($PMH.PatientPaybleAmt > $PMH.PatientPaidAmt) {
                            //    modelAlert('Partial Payment Not Allow.', function () { });
                            //    //return false;
                            //}
                        }
                        else if (($totalPaidAmountpatient+panelPaidAmountrow) < $LT.NetAmount) {
                            modelAlert('Partial Payment Not Allow.', function () { });
                            return false;
                        }
                    }
                }
                if (nonAppointmentItems.length > 0 && $isReceipt == true) {
                    if ($PMH.PatientPaybleAmt > 0) {
                        //if ($totalPaidAmountpatient < $PMH.PatientPaybleAmt) {
                        //    modelAlert('Partial Payment Not Allow.', function () { });
                        //    return false;
                        //}
                        if ($totalPaidAmountpatient > $PMH.PatientPaybleAmt) {
                            modelAlert('Can Not Collect More Than The Patient Payable Amount.', function () { });
                            return false;
                        }
                    }
                }
                //return false;
                //console.log({ PM: [$PM], PMH: [$PMH], LT: [$LT], LTD: $LTD, PaymentDetail: $PaymentDetail, PT: $urgentTest });

                var isHelpDeskBooking = Number('<%=Util.GetString(Request.QueryString["helpDeskBooking"])%>');
                var helpDeskBookingCentreID = Number('<%=Util.GetString(Request.QueryString["centreId"])%>');

                        var PoolNr = $("#lblPoolNr").text();
                        var PoolDesc = $("#lblPoolName").text();
                        if (PoolNr == 0 || PoolNr == "0" || PoolNr == "" || PoolNr == undefined || PoolNr == null) {
                            PoolNr = 0;
                            PoolDesc = "";
                        }
                callback({ PM: [$PM], PMH: [$PMH], LT: [$LT], LTD: $LTD, PaymentDetail: $PaymentDetail, PT: $urgentTest, patientDocuments: patientDetails.patientDocuments, reportDispatchModeID: labPrescriptionDetails.reportDispatchModeID, directDiscountOnBill: directDiscountOnBill, IsObservationRoomShift: false, lastVisitID: patientDetails.visitID, panelDocuments: patientDetails.panelDocuments, approvalRemark: patientDetails.panelDetails.approvalRemark, approvalAmount: payment.panelPayableAmount, IsHelpDeskBilling: isHelpDeskBooking, HelpDeskBookingCentreID: helpDeskBookingCentreID,PoolNr:PoolNr,PoolDesc:PoolDesc  });
            });
        });
    });
}

$openOldInvestigationModel = function () {
    getPatientBasicDetails(function (patientDetails) {
        if (String.isNullOrEmpty(patientDetails.patientID)) {
            modelAlert('Please Select Patient First');
            return;
        }
        $serachOldInvestigationModel();
        $('#oldInvestigationModel').showModel();
    });
}

$openMobileAppBookingModel = function () {
    getPatientBasicDetails(function (patientDetails) {
        $('#dvonlineInvestBooking').showModel();
        $serachOnlineInvestigationModel();
    });
}

$serachOnlineInvestigationModel = function () {
    var data = {
        FromDate: $('#txtOnlineFromDate').val(),
        ToDate: $('#txtOnlineToDate').val(),
        Mobile: $('#txtOnlineMobile').val()
    }
    serverCall('../Common/CommonService.asmx/BindOnlineBookingInvestigation', data, function (response) {
        if (response != '') {
            OnlineData = JSON.parse(response);
            var $template = $('#template_searchOnlineInvestigation').parseTemplate(OnlineData);
            $('#divOnline').html($template);
            MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
        }
    });
}

var mobileApplicationBookingModelClose = function () {
    $('#dvonlineInvestBooking').closeModel();
}
var addOnlineInvestigation = function (elem) {

    $('#tbSelected tbody').find('tr').remove();
    var PatientData = JSON.parse($(elem).closest('tr').attr('data-app'));
    if (PatientData.IsRegistred == 1) {
        $searchPatient({ PatientID: PatientData.patientID, PatientRegStatus: 1 }, '', PatientData.Gender, function (response) {
            mobileApplicationBookingModelClose();
            $bindPatientDetails($.extend(response, PatientData), function () {
                if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1') {
                    $bindRegistrationCharges(function () {
                        $bindOnlineBookingDetails(PatientData.IbID, function () { });
                    });
                }
                else {
                    $bindOnlineBookingDetails(PatientData.IbID, function () {
                    });
                }
            });
        });
    }
    else {
        getBindPatientDefaultValue(PatientData, function (response) {
            mobileApplicationBookingModelClose();
            $bindPatientDetails(response, function () {
                if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1') {
                    $bindRegistrationCharges(function () {
                        $bindOnlineBookingDetails(PatientData.IbID, function () { });
                    });
                }
                else {
                    $bindOnlineBookingDetails(PatientData.IbID, function () {
                    });
                }
            });
        });
    }
}
var $bindOnlineBookingDetails = function (Ids) {
    serverCall('../Common/CommonService.asmx/BindOnlineBookingInvestigationDetails', { BookingIds: Ids }, function (response) {
        if (response != '') {
            OnlineBookingData = JSON.parse(response);
            if (OnlineBookingData.length > 0) {
                var Onlineinvestigations = [];
                $(OnlineBookingData).each(function () {
                    Onlineinvestigations.push({
                        IsOutSource: this.IsOutSource,
                        ItemCode: this.ItemCode,
                        LabType: this.LabType,
                        SubCategoryID: this.SubCategoryID,
                        TnxTypeID: this.TnxType,
                        TypeName: this.Typename,
                        Type_ID: this.Type_id,
                        isadvance: this.isadvance,
                        sampleType: this.Sample,
                        val: this.itemID,
                        presceibedID: this.PatientTest_ID,
                        IsUrgent: 0,
                        defaultQty: 1,
                        isMobileBooking: 1,
                        salesID: '',
                        appointmentID:0,
                    });
                });
                $addInvestigation(Onlineinvestigations);
            }
            else
                modelAlert('Please Select Investigation');
        }
    });
}
$serachOldInvestigationModel = function () {
    getPatientBasicDetails(function (patientDetails) {
        var data = {
            PatientId: patientDetails.patientID,
            FromDate: $('#txtOldInvestigationModelFromDate').val(),
            ToDate: $('#txtOldInvestigationModelToDate').val(),
            Condition: 'CPOE Prescription',
        }
        serverCall('../Common/CommonService.asmx/BindInvestigation', data, function (response) {
            if (response != '') {
                CPOEPrescripData = JSON.parse(response);
                var $template = $('#template_searchOldInvestigation').parseTemplate(CPOEPrescripData);
                $('#divInvetigationPrescription').html($template);
            }
        });
    });
}

var $addCPOEInvestigation = function (tblOldInvestigation) {
    $checkedInvestigation = tblOldInvestigation.find('tbody input[type=checkbox]:checked');
    if ($checkedInvestigation.length > 0) {
        slotinvestigation = [];
        var investigations = [];
        //deve
        $checkedInvestigation.parent().parent().each(function () {
            $data = JSON.parse($(this).find('#tdData').text());
            investigations.push({
                IsOutSource: $data.IsOutSource,
                ItemCode: $data.ItemCode,
                LabType: $data.LabType,
                SubCategoryID: $data.SubCategoryID,
                CategoryID: $data.CategoryID,
                TnxTypeID: $data.TnxType,
                TypeName: $data.Typename,
                Type_ID: $data.Type_id,
                isadvance: $data.isadvance,
                sampleType: $data.Sample,
                val: $data.ItemID,
                presceibedID: $data.PatientTest_ID,
                IsUrgent: 0,
                defaultQty: $data.Quantity,
                isMobileBooking: 0,
                salesID: '',
                appointmentID: 0,
                isSlotWiseToken: 0,
                SubCategory: $data.SubCategory

            });
        });
       $addInvestigation(investigations);


    }
    else
        modelAlert('Please Select Investigation');

}


var $addInvestigation = function (investigations) {
    var _temp = [];
    var prescribeInvestigationData = [];
    getPatientBasicDetails(function (patientDetails) {
        investigations.forEach(function (item) {
            _temp.push(serverCall('../common/CommonService.asmx/GetDiscountWithCoPay', { itemID: item.val, panelID: patientDetails.panelID, patientTypeID: patientDetails.patientTypeID, memberShipCardNo: patientDetails.memberShipCardNo }, function (response) {
                var discountCoPayment = JSON.parse(response)[0];
                item.discountPercent = discountCoPayment.OPDPanelDiscPercent;
                item.IsPanelWiseDiscount = discountCoPayment.OPDPanelDiscPercent > 0 ? 1 : 0;
                item.coPaymentPercent = discountCoPayment.OPDCoPayPercent;
                item.IsPayable = discountCoPayment.IsPayble;
                prescribeInvestigationData.push({ investigation: { item: item }, discountCoPayment: discountCoPayment });
            }, { isReturn: true }));
        });
        $.when.apply(null, _temp).progress(function () {
            $modelBlockUI();
        }).done(function () {
            _temp = [];
            prescribeInvestigationData.forEach(function (item) {
                _temp.push(serverCall('Services/LabPrescription.asmx/getAlreadyPrescribeItem', { PatientID: patientDetails.patientID, ItemID: item.investigation.item.val }, function (response) {
                    var responseData = JSON.parse(response);
                    item.todayPrescribeDetails = responseData;
                }, { isReturn: true }));
            });
            $.when.apply(null, _temp).done(function () {
                _temp = [];
                prescribeInvestigationData.forEach(function (item) {
                    _temp.push(serverCall('../common/CommonService.asmx/bindLabInvestigationRate', { PanelID: patientDetails.panelID, ItemID: item.investigation.item.val, TID: '', IPDCaseTypeID: '', panelCurrencyFactor: patientDetails.panelCurrencyFactor }, function (response) {
                        if (!String.isNullOrEmpty(response))
                            item.rateDetails = JSON.parse(response)[0];
                        else if (item.investigation.item.TnxTypeID == '16')
                            item.rateDetails = { Rate: item.investigation.item.Rate, ID: 0, ScheduleChargeID: 0, ItemCode: '', ItemDisplayName: '' };
                        else
                            item.rateDetails = { Rate: 0, ID: 0, ScheduleChargeID: 0, ItemCode: '', ItemDisplayName: '' };
                    }, { isReturn: true }));
                });
                $.when.apply(null, _temp).done(function () {
                    prescribeInvestigationData.forEach(function (i) {
                        var isAlreadyAdded = ($('#tbSelected tbody tr td #spnItemID').filter(function () { return ($(this).text().trim() == i.investigation.item.val) }).length == 0) ? true : false;
                        if (isAlreadyAdded) {
                            i.investigation.item.IsDiscountEnable = '<%=Util.GetInt(ViewState["IsDiscount"])%>' == '0' ? false : true,
                              //slotinvestigation.push({
                              //    PanelId: patientDetails.panelID,
                              //    investigation: i.investigation,
                              //    investigationRateDetails: i.rateDetails,
                              //});

                            $addInvestigationRow(patientDetails.panelID, i.investigation, i.rateDetails,1, function () { });
                        }
                    });
                    $modelUnBlockUI();
                    $('#oldInvestigationModel').hideModel();
                    $updatePaymentAmount(function () { });
                });
            });
        });
    });
}

var onPatientIDChange = function () {
    $('#txtPID').change(function () {
        // getLastVisitDetails(this.value, function () { });
        // getPatientUnBilledSearvices(function () { });
    });
}


_onPatientChangeOrBind = function (callback) {
    getPatientBasicDetails(function (patientDetails) {
        getLastVisitDetails(patientDetails.patientID, function () { });
        // getPatientUnBilledSearvices(function () { });
        getAppointmentLastVisitDetails(patientDetails.patientID, function () { });
    });

}
var isPatientValidForFollowUpVisit = 0;
var previousFirstVisitOPDDoctorID = 0;
var getAppointmentLastVisitDetails = function (patientID, callback) {
    serverCall('../Common/CommonService.asmx/GetLastVisitDetail', { PatientID: patientID, DoctorID: '' }, function (response) {
        var responseData = JSON.parse(response);
        if (responseData.length > 0) {
            var message = '<div class="row"><div class="col-md-10"><label class="pull-left">Date</label><b class="pull-right">:</b></div><div class="col-md-13 pull-left"><label class="pull-left">' + responseData[0].VisitDate + '</label></div></div>';
            message += '<div class="row"><div class="col-md-10"><label class="pull-left">Valid To</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].ValidTo + '</label></div></div>';
            message += '<div class="row"><div class="col-md-10"><label class="pull-left">Amount Paid</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].AmountPaid + '</label></div></div>';
            message += '<div class="row"><div class="col-md-10"><label class="pull-left">Days</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].Days + '</label></div></div>';
            message += '<div class="row"><div class="col-md-10"><label class="pull-left">Type</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].VisitType + '</label></div></div>';
            message += '<div class="row"><div class="col-md-10"><label class="pull-left">Doctor</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].Doctor + '</label></div></div>';
            toastr.clear();
            var notify = toastr.info(message, 'Last Visit Details', toastroptions);
            var $notifyContainer = jQuery(notify).closest('.toast-top-center');
            if ($notifyContainer) {
                var containerWidth = jQuery(notify).width() + 20;
                $notifyContainer.css("margin-left", -containerWidth / 2);
            }

            debugger;
            isPatientValidForFollowUpVisit = responseData[0].IsValidForFollowUpVisit;
            previousFirstVisitOPDDoctorID = responseData[0].DoctorID;
        }
        else
            toastr.clear();
    });

}


var getPatientUnBilledSearvices = function (callback) {
    getPatientBasicDetails(function (patientDetails) {
        serverCall('Services/LabPrescription.asmx/GetUnBilledPatientSearvices', { visitID: patientDetails.visitID, patientID: patientDetails.patientID }, function (response) {
            var responseData = JSON.parse(response);
            slotinvestigation = [];
            var investigations = [];
            $(responseData).each(function (i, $data) {
                investigations.push({
                    IsOutSource: $data.IsOutSource,
                    ItemCode: $data.ItemCode,
                    LabType: $data.LabType,
                    CategoryID: $data.CategoryID,
                    SubCategoryID: $data.SubCategoryID,
                    TnxTypeID: $data.TnxType,
                    TypeName: $data.TypeName,
                    Type_ID: $data.Type_ID,
                    isadvance: $data.isadvance,
                    sampleType: $data.Sample,
                    val: $data.ItemID,
                    presceibedID: $data.PatientTest_ID,
                    IsUrgent: 0,
                    defaultQty: $data.Quantity,
                    isMobileBooking: 0,
                    salesID: $data.SalesID,
                    Rate: $data.Rate,
                    SubCategory: $data.SubCategory,
                    ItemDisplayName: $data.ItemDisplayName,
                    appointmentID:0,
                });
            });
            $addInvestigation(investigations);
            callback();
        });
    });
}


var toastroptions = {
    "closeButton": true, "debug": false, "newestOnTop": false, "progressBar": true, "positionClass": "toast-bottom-left", "preventDuplicates": true, "showDuration": "300", "hideDuration": "500000000",
    "timeOut": "5000000000",
    "extendedTimeOut": "100000000000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
}
var getLastVisitDetails = function (patientID) {
    serverCall('Services/LabPrescription.asmx/lastVisitDetails', { patientID: patientID }, function (response) {
        lastVisitDetails = JSON.parse(response)
        if (lastVisitDetails.length > 0) {
            var message = $('#template_lastVisitDetails').parseTemplate(lastVisitDetails);
            toastr.clear();
            toastr.info(message, 'Last Visit Details', toastroptions);
            toastr.options.tapToDismiss = false;
        }
    });
}


var closeOpenPatientVisit = function (patientID, callback) {
    serverCall('Services/PatientVisitRegistration.asmx/ClosePatientOpenVisit', { patientID: patientID }, function (res) {
        var responseData = JSON.parse(res);
        if (responseData.status) {
            callback();
        }
        else
            modelAlert(responseData.response, function () {
                callback();
            });
    });
}

var $saveLabPrescription = function (btnSave) {
    var IsManual = 1;

    if ($('#txtPID').val() == '') { modelAlert(" Patient is not Register,Kindly Register The Patient First"); return; }
    if ($('#ddlDepartment').val() == '0') { modelAlert(" Select Clinic ."); return; }

    if ($("#lblIsSmartCard").text() == "1") {

        if ($("#lblisDataFetch").text() == "1") {

            var ApprovalAmt = $("#lblApprovedAmount").text();
            var BillAmt = $("#txtControlPanelPayable").val();

            var PoolNr = $("#lblPoolNr").text();

            if (PoolNr == 0 || PoolNr == "0" || PoolNr == "" || PoolNr == undefined || PoolNr == null) {
                modelAlert("Please Select The Benefit Of Smart Card.");
                return false;
            }
            if (parseFloat(BillAmt) > parseFloat(ApprovalAmt)) {
                modelAlert("Panel Payable Amount Is More then Approval Amount.");
                return false;
            } else {
                SavePrescription(btnSave);
            }


        } else {
            IsManual = 0;
            serverCall('Services/LabPrescription.asmx/IsBillingThroughSmartCard', { PatientId: $('#txtPID').val(), PanelId: $("#ddlPanelCompany").val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert("Samrt card Is Active For Selected Panel,Please Fetch Data.");
                    return false;
                } else {
                   
                    modelConfirmation('Save  data Manually ??', 'Smart Card Data Is Not Fetched Do You Want to save data manually ?', 'YES', 'NO', function (response) {
                        if (!response) {
                            return false;
                        }
                        else {
                            SavePrescription(btnSave);
                        }

                    });
                }

            });

        }


    }else {
        SavePrescription(btnSave)
    }
}



function SavePrescription(btnSave) {

    $getLabPrescriptionDetails(function (labPrescriptionDetails) {
        // $(btnSave).attr('disabled', true).val('Submitting...');
        serverCall('Services/LabPrescription.asmx/SaveLabPrescriptionOPD', labPrescriptionDetails, function (response) {
            var $responseData = JSON.parse(response);
            modelAlert($responseData.response, function () {
                if ($responseData.status) {
                    if ($responseData.IsBill != 2) {
                        if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
                            window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0');
                        else {
                            //window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0&Type=OPD');

                            window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0&Type=OPD');
                        }


                        if ($responseData.consultationLedgerTnxID != "") {

                            var consultationLedgerTnxID = $responseData.consultationLedgerTnxID.split('#');
                            $.each(consultationLedgerTnxID, function (index) {
                                var ledgerTnxId = consultationLedgerTnxID[index];
                                //if(ledgerTnxId !='')
                                  //   window.open('../../Design/common/OPDCard.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&LedgerTnxID=' + ledgerTnxId + ' ');
                            });
                            
                        }
                    }

                    var isHelpDeskBooking = Number('<%=Util.GetString(Request.QueryString["helpDeskBooking"])%>');
                    if (isHelpDeskBooking == 0)
                        window.location.href = '../OPD/Lab_PrescriptionOPD.aspx';
                    else
                        window.location.href = '<%=Util.GetString(Request.QueryString["backUrl"])%>';
                }
                else
                    $(btnSave).removeAttr('disabled').val('Save');

            });
        });
    });
}




$(function () {
    shortcut.add('Alt+S', function () {
        var btnSave = $('#btnSave');
        if (btnSave.length > 0) {
            if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                $saveLabPrescription(btnSave[0]);
            }
        }
    }, addShortCutOptions);
});

    </script>
    <script type="text/javascript">
        //------------Investigation Slot start--------------

        var ClearSlots = function (ItemID, callback) {
            serverCall('Services/LabPrescription.asmx/ClearSlots', { ItemID: ItemID }, function (response) {
                callback(response);
            })
        }

        var $getinvestigationSlotwhenSearch = function (panel, investigation, investigationRateDetails) {
            $InvestigationDate = $('#txtInvestigationCurrDate').val();
            ItemID = investigation.item.val;
            doctorID = $('#ddlDoctor').val();
            SubCategoryID = investigation.item.SubCategoryID;
            CategoryID = investigation.item.CategoryID;
            $('#spnItemIDforSlot').text(ItemID);
            $('#txtInvestigationSlotDate').val($InvestigationDate);
            $('#txtInvestigationOn').val($InvestigationDate);

            bindModality(SubCategoryID, function () {
                Modality = $('#ddlModality option').eq(0).val();
                $getInvestigationTimeSlot($InvestigationDate, doctorID, ItemID, SubCategoryID, true, '', Modality,0,0, function (response) {

                });
            });
        }
        var bindModality = function (subcategoryid, callback) {
            $ddlModality = $('#ddlModality');
            serverCall('../common/CommonService.asmx/BindModality', { SubcategoryID: subcategoryid, CentreID: '<%=Session["CentreID"]%>' }, function (response) {
                    var responseData = JSON.parse(response);
                    $ddlModality.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: false });
                    callback($ddlModality.val());
                });
            }

        var $getInvestigationTimeSlot = function (InvestigationDate, doctorID, ItemID, SubCategoryID, isModelShow, rowID, Modality, isPackageSlot,PackageID, callback) {
                var centreID = '<%= HttpContext.Current.Session["CentreID"]%>'
                serverCall('Services/LabPrescription.asmx/GetInvestigationTimeSlot', { DoctorId: doctorID, InvestigationDate: InvestigationDate, BookingType: 2, ItemID: ItemID, SubCategoryID: SubCategoryID, centreId: centreID, Modality: Modality }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $('#divInvSlotAvailabilityBody').html($responseData.response);
                        if ($('#spnIsSearchSelect').text() == '0') {
                            var txtInvestigationTime = $(rowID).closest('tr').find('#spnInvestigationSlotTime');
                            $(txtInvestigationTime).text($responseData.defaultAvilableSlot);
                            $(rowID).closest('tr').find('#spnInvestigationSlotDate').text(InvestigationDate);

                        }
                        if ($responseData.defaultAvilableSlot == '')
                            modelAlert('Slot Not Avilable');
                        $('#spnModalSubCategoryID').text(SubCategoryID);
                        $('#spnModalItemID').text(ItemID);
                        $('#spnModalIsPackageSlot').text(isPackageSlot);
                        $('#spnModalPackageID').text(PackageID);
                        $('#divInvSlotAvailabilityBody div #spnInvestigationTime').each(function (index, elem) {
                            if ($.trim($(elem).text()) == $responseData.defaultAvilableSlot)
                                $(elem).parent().addClass('badge-pink');
                        });
                        if (isModelShow)
                            $('#divInvSlotAvailability').showModel();

                        MarcTooltips.add('div .badge-avilable', 'Double Click To Select', {
                            position: 'up',
                            align: 'left'
                        });


                        callback(InvestigationDate);
                    }
                    else {

                        modelAlert($responseData.response, function () {
                            clearInvestigationDetails();
                        });
                    }
                });
            }

            var clearInvestigationDetails = function () {
                $('#divInvSlotAvailabilityBody').html('');
            }
            var $selectInvSlot = function (elem) {
                $('#divInvSlotAvailabilityBody .circle').removeClass('badge-pink');
                $(elem).addClass('badge-pink');
            }


        var $InvdobuleClick = function (elem) {
            data = {
                modalityID: $.trim($(elem).find('#spnModalInvestigationModality').text()),
                modalityName: $.trim($(elem).find('#spnModalInvestigationModalityName').text()),
                SubCategoryID: $('#divInvSlotAvailability div #spnModalSubCategoryID').text(),
                ItemID: $('#divInvSlotAvailability div #spnModalItemID').text(),
                BookingDate: $.trim($(elem).find('#spnModalInvestigationDate').text()),
                TimeSlot: $.trim($(elem).find('#spnInvestigationTime').text()),
                isPackage: $('#spnModalIsPackageSlot').text(),
            }
            HoldTimeslot(data, function (response) {
                if (data.isPackage == '0' || data.isPackage == '') {
                    slotinvestigation[0].investigation.item.InvestigationSlotTime = $.trim($(elem).find('#spnInvestigationTime').text());
                    slotinvestigation[0].investigation.item.BookingDate = data.BookingDate;
                    slotinvestigation[0].investigation.item.ModalityID = data.modalityID;
                    slotinvestigation[0].investigation.item.ModalityName = data.modalityName;

                        if ($('#spnIsSearchSelect').text() == '0') {
                            $('#tbSelected tbody tr').each(function () {
                                if ($(this).find('#spnItemID').text() == $('#spnItemIDforSlot').text()) {
                                    $(this).find('#spnInvestigationSlotTime').text($.trim($(elem).find('#spnInvestigationTime').text()));
                                    $(this).find('#spnInvestigationSlotDate').text($.trim($('#txtInvestigationSlotDate').val()));
                                    $(this).find('#spnInvestigationSlotModality').text(data.modalityID);
                                    $(this).find('#spnData').text(JSON.stringify(slotinvestigation[0].investigation.item));
                                    $(this).find('#imgView').attr('data-title', $(this).find('#spnInvestigationSlotDate').text() + " " + $.trim($(elem).find('#spnInvestigationTime').text()) + " " + data.modalityName);
                                    $('#divInvSlotAvailability').closeModel();
                                }
                            });
                        }
                        else {
                            $addInvestigationRow(slotinvestigation[0].PanelId, slotinvestigation[0].investigation, slotinvestigation[0].investigationRateDetails,0, function () {
                                $clearPaymentControl(function () {
                                    $updatePaymentAmount(function () { });
                                    $('#divInvSlotAvailability').closeModel();
                                });
                            });
                        }
                    } else {
                        $('.packageItems table tbody tr').each(function () {
                            if ($(this).find('#tdPackageID').text() == $('#spnModalPackageID').text().trim() && $(this).find('#tdPackItemItemID').text() == $('#spnItemIDforSlot').text()) {
                                $(this).find('#tdPkgBookingDate').text(data.BookingDate);
                                $(this).find('#tdPkgBookingTime').text(data.TimeSlot);
                                $(this).find('#tdPkgModality').text(data.modalityID);
                                $(this).find('#imgPkgView').attr('data-title', data.BookingDate + " " + data.TimeSlot + " " + data.modalityName);
                                $('#divInvSlotAvailability').closeModel();
                            }
                        });
                    }
                });
            }

            var HoldTimeslot = function (data, callback) {
                serverCall('Services/LabPrescription.asmx/HoldTimeSlot', data, function (response) {
                    result = JSON.parse(response);
                    if (!(result.status)) {
                        modelAlert(result.response, function () {

                        });
                    }
                    else
                        callback(true);
                });
            }

            var onInvestigationDateChange = function (el) {
                var $InvestigationDate = '';
                var SubCategoryID = '';
                var doctorID = $('#ddlDoctor').val();
                Modality = $('#ddlModality').val();
                if ($('#spnItemIDforSlot').text() != '') {
                    if ($('#spnIsSearchSelect').text() == '0') {
                        if ($('#spnModalIsPackageSlot').text() == '0') {
                            $('#tbSelected tbody tr').each(function () {
                                if ($(this).find('#spnItemID').text().trim() == $('#spnItemIDforSlot').text()) {
                                    $(this).find('#spnInvestigationSlotDate').text(el.value);
                                    $InvestigationDate = $(this).find('#spnInvestigationSlotDate').text();
                                    SubCategoryID = $(this).find('#spnSubCategoryID').text();
                                    $getInvestigationTimeSlot($InvestigationDate, doctorID, $(this).find('#spnItemID').text().trim(), SubCategoryID, true, '', Modality, 0, function (response) {
                                        $(this).find('#spnInvestigationSlotDate,#spnInvestigationSlotTime').text(response);
                                    });
                                }
                            });
                        }
                        else if ($('#spnModalIsPackageSlot').text() == '1') {
                            $('.packageItems table tbody tr').each(function () {
                                if ($(this).find('#tdPackageID').text() == $('#spnModalPackageID').text().trim() && $(this).find('#tdPackItemItemID').text() == $('#spnItemIDforSlot').text()) {
                                    $(this).find('#tdPkgBookingDate').text(el.value);
                                    $InvestigationDate = $(this).find('#tdPkgBookingDate').text();
                                    SubCategoryID = $(this).find('#tdSubCategoryIDInv').text();
                                    $getInvestigationTimeSlot($InvestigationDate, doctorID, $(this).find('#tdPackItemItemID').text().trim(), SubCategoryID, true, '', Modality, 1,$(this).find('#tdPackageID').text(), function (response) {
                                        
                                    });
                                }
                            });
                        }

                    }
                    else {
                        $InvestigationDate = el.value;
                        $('#txtInvestigationOn').val(el.value);
                        ItemID = slotinvestigation[0].investigation.item.val;
                        SubCategoryID = slotinvestigation[0].investigation.item.SubCategoryID;
                        $getInvestigationTimeSlot($InvestigationDate, doctorID, ItemID, SubCategoryID, true, '', Modality,0,0, function (response) {
                        });
                    }
                }
            }

            var onInvestigationModalityChange = function (el) {
                var $InvestigationDate = $('#txtInvestigationSlotDate').val();
                var SubCategoryID = '';
                var doctorID = $('#ddlDoctor').val();
                var Modality = el.value;
                if ($('#spnItemIDforSlot').text() != '') {
                    if ($('#spnIsSearchSelect').text() == '0') {
                        if ($('#spnModalIsPackageSlot').text() == '0') {
                            $('#tbSelected tbody tr').each(function () {
                                if ($(this).find('#spnItemID').text().trim() == $('#spnItemIDforSlot').text()) {
                                    $(this).find('#spnInvestigationSlotDate').text($InvestigationDate);
                                    $(this).find('#spnInvestigationSlotModality').text(Modality);
                                    $InvestigationDate = $(this).find('#spnInvestigationSlotDate').text();
                                    SubCategoryID = $(this).find('#spnSubCategoryID').text();
                                    $getInvestigationTimeSlot($InvestigationDate, doctorID, $(this).find('#spnItemID').text().trim(), SubCategoryID, true, '', Modality, 0, 0, function (response) {
                                        $(this).find('#spnInvestigationSlotDate,#spnInvestigationSlotTime').text(response);
                                    });
                                }

                            });
                        }
                        else if ($('#spnModalIsPackageSlot').text() == '1') {
                            $('.packageItems table tbody tr').each(function () {
                                if ($(this).find('#tdPackageID').text() == $('#spnModalPackageID').text().trim() && $(this).find('#tdPackItemItemID').text() == $('#spnItemIDforSlot').text()) {
                                    $(this).find('#tdPkgBookingDate').text($InvestigationDate);
                                    $InvestigationDate = $(this).find('#tdPkgBookingDate').text();
                                    SubCategoryID = $(this).find('#tdSubCategoryIDInv').text();
                                    $getInvestigationTimeSlot($InvestigationDate, doctorID, $(this).find('#tdPackItemItemID').text().trim(), SubCategoryID, true, '', Modality, 1, $(this).find('#tdPackageID').text(), function (response) {

                                    });
                                }
                            });
                        }
                    }
                    else {
                        $InvestigationDate = $('#txtInvestigationSlotDate').val();;
                        $('#txtInvestigationOn').val($InvestigationDate);
                        ItemID = slotinvestigation[0].investigation.item.val;
                        SubCategoryID = slotinvestigation[0].investigation.item.SubCategoryID;
                        $getInvestigationTimeSlot($InvestigationDate, doctorID, ItemID, SubCategoryID, true, '', Modality,0,0, function (response) {
                        });
                    }
                }
            }

            var SelectInvestigationSlot = function (isPackageSlot,elem) {
                $InvestigationDate = $('#txtInvestigationCurrDate').val();
                ItemID = '0';
                SubCategoryID = '0';
                PackageID = '0';
                if (isPackageSlot == 0) {
                    ItemID = $(elem).closest('tr').find('#spnItemID').text();
                    doctorID = $('#ddlDoctor').val();
                    SubCategoryID = $(elem).closest('tr').find('#spnSubCategoryID').text();
                } else {
                    ItemID = $(elem).closest('tr').find('#tdPackItemItemID').text();
                    doctorID = $('#ddlDoctor').val();
                    SubCategoryID = $(elem).closest('tr').find('#tdSubCategoryIDInv').text();
                    PackageID = $(elem).closest('tr').find('#tdPackageID').text();
                }
                $('#spnItemIDforSlot').text(ItemID);
                $('#spnIsSearchSelect').text('0');
                $('#txtInvestigationSlotDate').val($InvestigationDate);
                $('#spnPackageIDforSlot').text(PackageID);
                bindModality(SubCategoryID, function () {
                    Modality = $('#ddlModality option').eq(0).val();
                    $getInvestigationTimeSlot($InvestigationDate, doctorID, ItemID, SubCategoryID, true, '', Modality, isPackageSlot,PackageID,function (response) {
                    });
                });
            }

            //-----------ENd-----------------
    </script>


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Service Booking</b>
            <span style="display: none" id="lblScheduleChargeID"></span>
            <span style="display: none" id="spnHashCode"></span>
              <span style="display: none" id="spnItemIDforSlot"></span>
            <span style="display: none" id="spnIsSearchSelect"></span>
            <span style="display: none" id="spnPackageIDforSlot"></span> 
            <span id="spnModalIsPackageSlot" style="display:none">0</span>
            <span id="spnIsHelpDeskSelected" style="display:none">0</span>
             <span id="spnRescheduleAppointmentID" style="display:none">0</span>
             <span id="spanIsRegistrationChargesAlreadyAdded" style="display:none">0</span>
            <asp:TextBox runat="server" ClientIDMode="Static" Style="display:none" ID="txtInvestigationOn"></asp:TextBox>
            <cc2:CalendarExtender ID="ccInv" TargetControlID="txtInvestigationOn" Format="dd-MMM-yyyy" runat="server"></cc2:CalendarExtender>
            <asp:TextBox runat="server" ClientIDMode="Static" Style="display:none" ID="txtInvestigationCurrDate"></asp:TextBox>
            <cc2:CalendarExtender ID="ccInvCur" TargetControlID="txtInvestigationCurrDate" Format="dd-MMM-yyyy" runat="server"></cc2:CalendarExtender>
        </div>
        <uc1:wuc_OldPatientSearch ID="PatientInfo" runat="server" />
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <select id="ddlFilterType" title="Select Type" onchange="onSearchTypeChange(this)">
                                <%--<option value="0" selected="selected">ALL</option>
                                <option value="9">Laboratory</option>
                                <option value="10">Radiology</option>
                                <option value="2">Procedures</option>
                                <option value="4">Consultation</option>
                                <option value="11">OPD-Package</option>
                                 <option value="5">Blood Bank</option>
                                <option value="3">Other</option>--%>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Category  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <select id="ddlCategory" title="Select Category" onchange="$bindSubCategory($('#ddlFilterType').val(),$('#ddlCategory').val(),function(){});"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Depart/Subca  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <select id="ddlSubCategory" title="Select SubCategory" onchange="bindConsultationItem()"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Dispatch Mode  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ddlDispatchMode" onchange="onDispatchModeChange(this.value)" title="Select SubCategory"></select>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <button id="btnCpoeInvestigation" style="width: 100%;" onclick="$openOldInvestigationModel()" type="button">
                        <span id="spnCountTest" class="badge badge-important  blink" style="display: none; padding: 2px 5px 2px 5px;"></span>
                        <b style="margin-left: 4px; font-size: 14px;">CPOE</b>

                    </button>


                </div>
            </div>
            <div class="row">
                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Search  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <select id="ddlSearchType">
                                <option value="1">Name</option>
                                <option value="2">Code</option>
                            </select>
                        </div>
                        <div class="col-md-11">
                            <input type="text" id="txtSearch" title="Enter Search Text" />
                        </div>
                        <div class="col-md-3">
                            <button style="width: 100%; padding: 0px; border-radius: 4px;" class="label label-important" type="button"><span id="lblTotalLabItemsCount" style="font-size: 14px; font-weight: bold;">Count : 0</span></button>
                        </div>
                        <div class="col-md-4">
                            <button type="button" id="btnAppointmentCount" style="width: 100%; padding: 0px; text-align: center" class="label label-warning"><span style="font-weight: bold;">Last Token No.(Doc): <b class="blink" style="font-size: 14px; font-family: cursive;">00</b> </span></button>
                        </div>

                    </div>
                </div>
                <div class="col-md-3">
                    <button id="btnMobileApp" style="width: 100%; font-size: 14px; font-weight: bold;" onclick="$openMobileAppBookingModel()" type="button">Online Booking`s</button>

                </div>
            </div>
        </div>
    <div class="POuter_Box_Inventory tbSelectedItems" style="display:none;" >
       <div style="width: 100%;">
                    <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; display: none; " class="GridViewStyle">
                        <thead style="width: 100%">
                            <tr id="LabHeader">
                                <%-- <th class="GridViewHeaderStyle" scope="col" style=""></th>--%>
                                <th class="GridViewHeaderStyle" scope="col" style="">Slot</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Type</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Code</th>
                                <th class="GridViewHeaderStyle" scope="col" style=" width:28px;"></th>
                                <th class="GridViewHeaderStyle" scope="col" style="text-align: left; width: 307px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">Item Name</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width:347px;">Doctor</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Remarks</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Rate</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Qty.</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Dis (%)</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Dis. Amt.</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Amount</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">U</th>
                                <th class="GridViewHeaderStyle" scope="col" style=""></th>
                            </tr>
                        </thead>
                        <tbody style="width: 100%" class="billingRow">
                        </tbody>
                    </table>

                    <%--<table id="tbConsumables" rules="all" border="1" style="border-collapse: collapse; display: none" class="GridViewStyle">
                            <thead style="width: 100%">
                                <tr id="Tr1">
                                    <th class="GridViewHeaderStyle" scope="col" style="">Code</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align: left; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">Item Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="display: none">Remarks</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Rate</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Qty.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Dis (%)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Dis. Amt.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Amount</th>
                                    <th class="GridViewHeaderStyle" scope="col" style=""></th>
                                    <th class="GridViewHeaderStyle" scope="col" style=""></th>
                                </tr>
                            </thead>
                            <tbody style="width: 100%">
                            </tbody>
                        </table>--%>
                </div>
    </div>
    <div id="paymentControlDiv" style="text-align: center;">
        <uc2:PaymentControl ID="paymentControlNew" runat="server" />
    </div>

    <div class="POuter_Box_Inventory" style="text-align: center">
        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: aqua" class="circle"></button>
        <b style="float: left; margin-top: 5px; margin-left: 5px">Out-Source</b>
        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: lightpink" class="circle"></button>
        <b style="float: left; margin-top: 5px; margin-left: 5px">Zero-Rate</b>
        <button type="button" style="display:none; width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #8ef3a9" class="circle"></button>
        <b style="display:none;float: left; margin-top: 5px; margin-left: 5px">Doctor-Collected</b>
        <input type="button" style="margin-left: -190px; width: 100px; margin-top: 7px" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveLabPrescription(this);" />
    </div>


    <%--Doctor Time Slot Availability Model--%>
    <div id="divSlotAvailability" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 1250px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSlotAvailability" aria-hidden="true">&times;</button>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Appointment Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtAppointmentSlotDate" runat="server" Style="width: 172px" ClientIDMode="Static" ToolTip="Select Booking Date"></asp:TextBox>
                            <asp:Label ID="lblAppointmentCurrentDate" runat="server" Style="display: none;" ClientIDMode="Static"></asp:Label>
                            <cc2:CalendarExtender ID="calendarExteAppointmentSlotDate" TargetControlID="txtAppointmentSlotDate" Format="dd-MMM-yyyy" runat="server"></cc2:CalendarExtender>
                        </div>

                        <div class="col-md-1">
                            <button type="button" onclick="onNextPrevDateChange('-1',function(){})">Prev</button>
                        </div>
                        <div class="col-md-1">
                            <button type="button" onclick="onNextPrevDateChange('1',function(){})">Next</button>
                        </div>

                        <div class="col-md-2" style="display:none">
                            <label class="pull-left">Slot Time </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2" style="display:none">
                            <select id="ddlSolotMin">
                                <option value="5">5 Min</option>
                                <option value="10">10 Min</option>
                                <option value="15">15 Min</option>
                                <option value="20">20 Min</option>
                                <option value="25">25 Min</option>
                                <option value="30">30 Min</option>
                                <option value="35">35 Min</option>
                                <option value="40">40 Min</option>
                                <option value="45">45 Min</option>
                                <option value="50">50 Min</option>
                                <option value="55">55 Min</option>
                                <option value="60">60 Min</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Doctor </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnSelectedDoctor" class="patientInfo" style="font-weight: bold"></span>
                            <span id="spnSelectedDoctorID" style="display: none"></span>
                            <span id="spnSelectedDoctorIsSlotWiseToken" style="display: none"></span>
                        </div>
                    </div>

                </div>
                <div class="modal-body">
                    <div id="divSlotAvailabilityBody">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-avilable"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Available</b>
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-yellow"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Booked</b>
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-purple"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Confirmed</b>
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-pink"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Selected</b>
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-grey"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Expired</b>
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-info"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Mobile</b>
                    <button type="button" data-dismiss="divSlotAvailability">Close</button>

                </div>
            </div>
        </div>
    </div>

    </div>

    <div id="oldInvestigationModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 860px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="oldInvestigationModel" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Prescription Search</h4>
                </div>
                <div class="modal-body">

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">From Date    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtOldInvestigationModelFromDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select From Date"></asp:TextBox>
                            <cc2:CalendarExtender ID="calExdTxtOldInvestigationModelFromDate" TargetControlID="txtOldInvestigationModelFromDate" Format="dd-MMM-yyyy" runat="server"></cc2:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">To Date    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtOldInvestigationModelToDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select To Date"></asp:TextBox>
                            <cc2:CalendarExtender ID="calExdTxtOldInvestigationModelToDate" TargetControlID="txtOldInvestigationModelToDate" Format="dd-MMM-yyyy" runat="server"></cc2:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <button type="button" onclick="$serachOldInvestigationModel()">Search</button>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div style="height: 200px" class="row">
                        <div id="divInvetigationPrescription" style="max-height: 190px; overflow: auto" class="col-md-24">
                            <%-- <table id='tblOldInvestigation' width="100%" cellspacing='0' rules='all' border='1'>
						   
						   <tbody>
						   </tbody>
						</table>--%>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: lightgreen" class="circle"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Done Investigations</b>
                    <button type="button" onclick="$addCPOEInvestigation($('#tblOldInvestigation'))">Add Investigation</button>
                    <button type="button" data-dismiss="oldInvestigationModel">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="dvonlineInvestBooking" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 860px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="dvonlineInvestBooking" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Today Online Booking</h4>
                </div>
                <div class="modal-body">

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <asp:TextBox ID="txtOnlineFromDate" runat="server" ReadOnly="true" ClientIDMode="Static" onchange="$serachOnlineInvestigationModel()" ToolTip="Select From Date"></asp:TextBox>
                            <cc2:CalendarExtender ID="cdOnlineFromDate" TargetControlID="txtOnlineFromDate" Format="dd-MMM-yyyy" runat="server"></cc2:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtOnlineToDate" runat="server" ReadOnly="true" ClientIDMode="Static" onchange="$serachOnlineInvestigationModel()" ToolTip="Select To Date"></asp:TextBox>
                            <cc2:CalendarExtender ID="cdOnlineToDate" TargetControlID="txtOnlineToDate" Format="dd-MMM-yyyy" runat="server"></cc2:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Mobile No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtOnlineMobile" runat="server" onlynumber="10" ClientIDMode="Static" onkeyup="$serachOnlineInvestigationModel()" ToolTip="Please Enter Mobile No."></asp:TextBox>

                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div style="height: 200px" class="row">
                        <div id="divOnline" style="max-height: 190px; overflow: auto" class="col-md-24">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <%--<button type="button" style="width:30px;height:30px;float:left;margin-left:5px;background-color:lightgreen" class="circle"></button>
				 <b style="float:left;margin-top:5px;margin-left:5px">Done Investigations</b>--%>
                    <button type="button" data-dismiss="dvonlineInvestBooking">Close</button>
                </div>
            </div>
        </div>



    </div>

    
    <%--Investigation Slot Modal Start--%>

     <div id="divInvSlotAvailability" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="row">
                            <div class="col-md-5">
                                 <b class="modal-title">Investigation Date :</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:TextBox ID="txtInvestigationSlotDate" runat="server" Style="width: 172px" ClientIDMode="Static" onchange="onInvestigationDateChange(this)"></asp:TextBox>
                        <cc2:CalendarExtender ID="calenderInvestigationSlotDate" TargetControlID="txtInvestigationSlotDate" Format="dd-MMM-yyyy" runat="server"></cc2:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <b class="modal-title">Modality :</b>
                            </div>
                            <div class="col-md-5">
                                <span id="spnModalSubCategoryID" style="display:none"></span>
                                <span id="spnModalItemID" style="display:none"></span>
                                <span id="spnModalPackageID" style="display:none"></span>
                                <select id="ddlModality" title="Select to change modality" onchange="onInvestigationModalityChange(this)"></select>
                            </div>
                               <div class="col-md-2"></div>
                            <div class="col-md-2">
                                <button type="button" class="close" data-dismiss="divInvSlotAvailability" aria-hidden="true">&times;</button>
                            </div>
                        </div>
                        
                        
                        
                    </div>
                    <div class="modal-body">
                        <div id="divInvSlotAvailabilityBody" style="padding-left: 30px; width: 1020px; height: 450px; overflow: auto">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-avilable"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Avilable</b>
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-yellow"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Booked in Hosp</b>
                        <%--<button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-purple"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Confirmed</b>--%>
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-pink"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Selected</b>
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-grey"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Expired</b>
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-info"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Booked Online</b>
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-darkgoldenrod"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Hold</b>
                        <button type="button" data-dismiss="divInvSlotAvailability">Close</button>

                    </div>
                </div>
            </div>
        </div>

    <%--Investigation Slot Modal End--%>


 <%-- Old Investigation template--%>
 <script id="template_searchOldInvestigation" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblOldInvestigation" style="width:100%;border-collapse:collapse;">
		<#if(CPOEPrescripData.length>0){#>

		<thead>
						   <tr  id='Header'>
								<th class='GridViewHeaderStyle'>All<input type='checkbox' id="chkAllOldInvestigation" onchange="$('#tblOldInvestigation tr td input[type=checkbox]').prop('checked',this.checked)"/></th>
								<th class='GridViewHeaderStyle'>S.No.</th>
                               <th class='GridViewHeaderStyle'>Type</th>
								<th class='GridViewHeaderStyle'>Item Name</th>
								<th class='GridViewHeaderStyle'>Quantity</th>
								<th class='GridViewHeaderStyle'>Outsource</th>
								<th class='GridViewHeaderStyle'>Remarks</th>
						   </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=CPOEPrescripData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{

		objRow = CPOEPrescripData[j];
		
		  #>
						<tr   
							<#if(objRow.IsIssue==1){#>
							   style="background-color: lightgreen;"
							<#}#>
							>
						<td id="td1" class="GridViewLabItemStyle" style="text-align:center">
                           <#if(objRow.IsIssue!=1){#>
							     <input type="checkbox" onchange="$('#tblOldInvestigation tr td input[type=checkbox]:not(:checked)').length>0?$('#chkAllOldInvestigation').prop('checked',false):$('#chkAllOldInvestigation').prop('checked',true)" /> 

							<#}
                              #>
                          
						</td>
						
                            
                            <td id="tdIndex" class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
						<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=JSON.stringify(objRow)#></td>
                        <td id="tdLabType" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.LabType#></td>
						<td id="tdTypename" class="GridViewLabItemStyle" style="text-align:left"><#=objRow.Typename#></td>
						<td id="tdQuantity" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Quantity#></td>
						<td id="tdIsOutSource" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.IsOutSource==0?'No':'Yes'#></td>
						<td id="td2" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.Remarks#></td>
						<td id="tdItemID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRow.ItemID#></td>         
						</tr>   

			<#}#>
</tbody>
	 </table>    
	</script>
 <%-- Online Investgation Booking template--%>
 <script id="template_searchOnlineInvestigation" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblOnlineInvestigation" style="width:100%;border-collapse:collapse;">
		<#if(OnlineData.length>0){#>

		<thead>
						   <tr  id='trOnlineHeader'>
								<th class='GridViewHeaderStyle'>S.No.</th>
                                <th class='GridViewHeaderStyle' >Booking No.</th>
								<th class='GridViewHeaderStyle'>Title</th>
								<th class='GridViewHeaderStyle'>Patient Name</th>
								<th class='GridViewHeaderStyle'>Mobile</th>
								<th class='GridViewHeaderStyle'>Gender</th>
                                <th class='GridViewHeaderStyle'>Age</th>
                                <th class='GridViewHeaderStyle'>BookingDate</th>
                                <th class='GridViewHeaderStyle'>Registered</th>
                                <th class='GridViewHeaderStyle'>Total Invest.</th>
                                <th class='GridViewHeaderStyle'>Select</th>
                                <th class='GridViewHeaderStyle' style="display:none;">OnlinePID</th>
                                <th class='GridViewHeaderStyle' style="display:none;">PanelID</th>
						   </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=OnlineData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRowOnline;   
		for(var k=0;k<dataLength;k++)
		{

		objRowOnline = OnlineData[k];
		
		  #>
						<tr  onmouseover="this.style.color='#00F'"    data-app='<#= JSON.stringify(objRowOnline)  #>'  onMouseOut="this.style.color=''" id="<#=k+1#>" ondblclick="addOnlineInvestigation(this);" style='cursor:pointer;'>
						<td id="tdOnlineIndex" class="GridViewLabItemStyle" style="text-align:center"><#=k+1#></td>
                        <td id="tdOnlineEntryNo" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.EntryNo#></td>
						<td id="tdOnlineTitle" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowOnline.Title#></td>
						<td id="tdOnlinePatientName" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.PatientName#></td>
						<td id="tdOnlineMobile" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.Mobile#></td>
						<td id="tdOnlineGender" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.Gender#></td>
						<td id="tdOnlineAge" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowOnline.Age#></td>
						<td id="tdOnlineBookingDate" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowOnline.BookingDate#></td> 
                        <td id="tdIsRegist" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.IsRegistred==0?'No':'Yes'#></td>  
                        <td id="tdOnlineTotalTest" class="customTooltip GridViewLabItemStyle" style="text-align:center;" data-title='<#=objRowOnline.TestName#>' ><#=objRowOnline.TotalTest#></td>
                        <td id="tdSelectOnlineInvest" class="GridViewLabItemStyle" style="text-align:center;"><button type="button"  onclick="addOnlineInvestigation(this)" >Select</button></td>
                        <td id="tdOnlineOnlinePID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRowOnline.OnlinePID#></td>      
                        <td id="tdOnlinePanelID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRowOnline.PanelID#></td> 
                                <%-- BookingDate,OnlinePID,ItemID,PanelID,Title,PatientName,Age,Mobile,Gender,TotalTest--%>          
						</tr>   

			<#}#>
</tbody>
	 </table>    
	</script>

 <script id="template_lastVisitDetails" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="Table1" style="width:100%;border-collapse:collapse;">
		<#
	   
		var dataLength=lastVisitDetails.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{

		objRow = lastVisitDetails[j];
		
		  #>
						<tr style="font-weight:bold
							<# if(objRow=='Yes') {#> 
								 background-color:red
							<#}#>
						 ">
						<td id="td3" class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
						<td id="td4" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=JSON.stringify(objRow)#></td>
						<td id="td5" class="GridViewLabItemStyle" style="text-align:left"><#=objRow.Name#></td>          
				</tr>   

			<#}#>

	 </table>    
	</script>

    
 
 <script id="templatePackageDetails" type="text/html">
	<table  id="tableInvestigation" cellspacing="0" rules="all" border="1" 
	style="width:100%;border-collapse:collapse; ">
		<thead>
		<tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" style="width:5px;text-align:center" data-title="Slot" ></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:5px;text-align:center" data-title="Type" >T</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:191px;text-align:left">Department</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:215px;text-align:left">Sub Department</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:206px;text-align:left">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center; width:64px;">Qty.</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">SubCategoryID</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">InvestigationID</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none;">Sample Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">ItemID</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none;">Is OutSource</th>
		</tr>
			</thead>
		<tbody>
			<#        
		for(var j=0;j<packageDetailsData.length;j++)
		{       
	   var objRow = packageDetailsData[j];
		#>
			<tr id="<#=j+1#>">
            <td class="GridViewLabItemStyle" id="tdSlot" style="width:5px; text-align:center; background-color:white">
                <# if(objRow.CategoryID=="7" && IsInvestigationAppointment=="1") {#>                         
                    <img id='imgPkgView' src='../../Images/SlotCalender.jpg'  data-title='Click here to Book Investigation Slots' onclick='SelectInvestigationSlot(1,this);' />
                  <#} if(objRow.PackageTypeName=="C" && objRow.IsSlotWiseToken=="1") {#>
                    <img id='imgPkgViewDocCalender' src='../../Images/SlotCalender.jpg' data-title='Click here to Book Appointment Slots' onclick="OnSelectPackageDoctorSlot(this);" /> 
                <#} else if(objRow.PackageTypeName=="C" && objRow.IsSlotWiseToken=="0") {#>
                   <%-- <img id='img1' src='../../Images/SlotCalender.jpg' data-title='Click here to Book Appointment Slots'  /> --%>
                <#}#>
            </td>
            <td class="GridViewLabItemStyle" id="tdPackageTypeName" style="width:5px; text-align:center; background-color:white"  data-title='<#=objRow.PackageTypeNameCap#>' ><#=objRow.PackageTypeName#></td> 
            <td class="GridViewLabItemStyle" id="tdPackageType" style=" display:none; text-align:center; background-color:white"><#=objRow.PackageType#></td>   
            <td class="GridViewLabItemStyle" id="tdPackageID" style=" display:none; text-align:center; background-color:white"><#=objRow.PackageID#></td>  
            <td class="GridViewLabItemStyle" id="tdDepartment" style="width:182px; text-align:left; background-color:white"><#=objRow.Department#></td>
            <td class="GridViewLabItemStyle" id="tdVisitType" style="width:211px; text-align:left; background-color:white"><#=objRow.VisitType#></td>                                                                                                      
		    <td class="GridViewLabItemStyle" id="tdInvestigationName" style=" text-align:left; width:206px; background-color:white">
               <#if((objRow.Investigation_Id=="" || objRow.Investigation_Id=="0") && objRow.PackageType=="2"){#>                         
                <select id="ddlPackageDoctor" class="packageDoctor requiredField"  errorMessage="Please Select Doctor Under The Package"  onchange="$onConsultationDoctorChange(this)" "></select>
                    <#}{#><#=objRow.Item#><#}#>

		    </td>
		   <td class="GridViewLabItemStyle" id="tdPackItemQuantity" style="text-align:center; background-color:white; width:64px;"><#=objRow.Quantity#></td>
		   <td class="GridViewLabItemStyle" id="tdSubCategoryIDInv" style="display:none; background-color:white"><#=objRow.SubCategoryID#></td>
           <td class="GridViewLabItemStyle" id="tdCategoryID" style="display:none; background-color:white"><#=objRow.CategoryID#></td> 
		   <td class="GridViewLabItemStyle" id="tdRate" style="display:none; background-color:white"><#=objRow.Rate#></td>
		   <td class="GridViewLabItemStyle" id="tdInvestigation_Id" style="display:none; background-color:white"><#=objRow.Investigation_Id#></td>
           <td class="GridViewLabItemStyle" id="tdIsConsuables" style="display:none; background-color:white">0</td>
           <td class="GridViewLabItemStyle" id="tdStockID" style="display:none; background-color:white"></td>
                     

		   <td class="GridViewLabItemStyle" id="tdSampleType" style="text-align:center;display:none; background-color:white"><#=objRow.Sample#></td>
		   <td class="GridViewLabItemStyle" id="tdPackItemItemID" style="display:none; background-color:white"><#=objRow.ItemID#></td>
		   <td class="GridViewLabItemStyle" id="tdOutSource" style="text-align:center;display:none; background-color:white"><#=objRow.IsOutSource#></td>
           <td class="GridViewLabItemStyle" id="tdPkgBookingDate" style="text-align:center;display:none; background-color:white"></td>
		   <td class="GridViewLabItemStyle" id="tdPkgBookingTime" style="display:none; background-color:white"></td>
		   <td class="GridViewLabItemStyle" id="tdPkgModality" style="text-align:center;display:none; background-color:white"></td>
           <td class="GridViewLabItemStyle" id="tdPkgeAppointmentDate" style="text-align:center;display:none; background-color:white"></td> 
           <td class="GridViewLabItemStyle" id="tdPkgIsSlotWiseToken" style="text-align:center;display:none; background-color:white"><#=objRow.IsSlotWiseToken#></td> 
			</tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
	
	</script>

    <script type="text/javascript">
        var $docCollection = function (ctrlID) {
         
            $(ctrlID).closest('tr').find('#spnDocCollect').text("");
            var itemName = $(ctrlID).closest('tr').find("#spnItemName").text();
            var type = $.trim($(ctrlID).closest('tr').find("#spnLabType").text());
            var NetAmount = $.trim($(ctrlID).closest('tr').find("#txtAmount").val());
            var IsOutSource = Number($(ctrlID).closest('tr').find("#spnIsOutSource").text());
            var Rate = Number($(ctrlID).closest('tr').find("#txtRate").val());


            var trStyle = "";
            if (IsOutSource == 1)
                trStyle = "background-color:aqua";
            else
                if (Rate < 1)
                    trStyle = "background-color:lightpink";

            $(ctrlID).closest('tr').removeAttr("style");

            if (type != 'OPD') {
                if ($("#ddlDoctor").val() == "0") {
                    modelAlert("Please Select Doctor First.", function () {
                        $(ctrlID).attr("checked", false);
                    });
                    return false;
                }
                else
                    itemName = $("#ddlDoctor option:selected").text();
            }
            else
                var itemName = "DR. " + itemName;


            if ($(ctrlID).is(':checked')) {
                var message = '<div class="row" style="font-weight:bold;"><div class="col-md-24" style="text-align:center;"><b>Collection Amount : </b><input type="text" id="txtDocCollection" class="requiredField" style="width:100px;" onlynumber="14" value=' + NetAmount + ' disabled="disabled" decimalplace="4" max-value="10000000" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeyDown="$commonJsPreventDotRemove(event)"></div></div>';
                modelConfirmation('Cash Collected By the Doctor : <span class="patientInfo">' + itemName + '</span>', message, 'Yes', 'No', function (res) {
                    if (res) {
                        if (Number($('#txtDocCollection').val()) > 0) {
                            $(ctrlID).closest('tr').find('#spnDocCollect').text("Doc. Collected : " + $('#txtDocCollection').val());
                            $(ctrlID).closest('tr').attr("style", "background-color:#8ef3a9");
                            $updatePaymentAmount(function () { });
                        }
                        else {
                            $(ctrlID).attr("checked", false);
                            $(ctrlID).closest('tr').attr("style", trStyle);
                        }
                    }
                    else {
                        $(ctrlID).attr("checked", false);
                    }
                });
            }
            else {
                $(ctrlID).closest('tr').attr("style", trStyle);
                $updatePaymentAmount(function () { });
            }
        }
    </script>
    <script type="text/javascript">



        function bindConsultationItem() {
            var SubCategoryID = $('#ddlSubCategory').val();
            var TypeId = $('#ddlDoctor').val();

            if (TypeId == null && TypeId == "0" && TypeId == "" && TypeId == undefined) {
                return false;
            }

            if (SubCategoryID == null && SubCategoryID == "0" && SubCategoryID == "" && SubCategoryID == undefined) {
                return false;
            }


            serverCall('../common/CommonService.asmx/GetItemIds', { SubCategoryID: SubCategoryID, TypeId: TypeId }, function (response) {
                var responseData = JSON.parse(response)
                if (responseData.status) {

                    $bindItems({ searchType: 1, prefix: "", Type: "0", CategoryID: "1", SubCategoryID: responseData.SubcategoryID, itemID: responseData.ItemId }, function (response) {
                        var investigation = {};
                        investigation.item = response[0];
                        $validateInvestigation(investigation, 0, 0, 1, function () { });
                    });
                }
            });



        }


    </script>
    <script type="text/javascript">

        function onCoPaymentAmountChange(val, BillAmt) {

            var netGrossBillAmount = BillAmt;//Number(_divPaymentControlParent.find('#txtControlBillAmount').val());

            var copayPercent = precise_round((100 * Number(val)) / netGrossBillAmount, _paymentControlRoundPlace);
            if (copayPercent <= 0)
                copayPercent = 0;
            var userMinPayableAmount = precise_round((netGrossBillAmount * Number(copayPercent)) / 100, 0);
            var panelMinPayableAmount = precise_round((netGrossBillAmount - userMinPayableAmount), _paymentControlRoundPlace);
            $('#txtCopaymentPercent').val(copayPercent);
            $('#txtControlUserPayable').val(userMinPayableAmount).attr('TotalUserPayableAmount', userMinPayableAmount);
            $('#txtControlPanelPayable').val(panelMinPayableAmount).attr('TotalPanelPayableAmount', panelMinPayableAmount);
            $('#txtControlDiscountPerCent').keyup();
        }
    </script>

</asp:Content>

