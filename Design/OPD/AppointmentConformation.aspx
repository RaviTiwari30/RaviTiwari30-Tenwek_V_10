<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AppointmentConformation.aspx.cs" Inherits="Design_OPD_AppointmentConformation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="OldPatientSearchControl" TagPrefix="UC1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>

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

    <cc1:ToolkitScriptManager ID="sc1" ScriptMode="Release" runat="server"></cc1:ToolkitScriptManager>
    <script type="text/javascript">
        $(document).ready(function () {
            $bindDepartment(function (selectedDepartment) {
                $bindDoctor(selectedDepartment, function () {
                    $bindSubCategory('1', '7', function () {
                        ChangeSearchCriteria('OPD', function () {
                        });
                    });
                });
            });
        });


        var doctorDepartmentChange = function (el) {
            if (el.selectedOptions.length > 0) {
                $bindDoctor(el.selectedOptions[0].text, function () { });
            }
        }

        $bindSubCategory = function (labItem, categoryID, callback) {
            $subCategory = $('#ddlSubCategory');
            serverCall('../common/CommonService.asmx/BindSubCategory', { Type: labItem, CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true });
                callback($subCategory.val());
            });
        }

        var $bindDepartment = function (callback) {
            var $ddlDepartment = $('#ddlSpecialization');
            serverCall('../common/CommonService.asmx/bindDepartment', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($ddlDepartment.find('option:selected').text());
            });
        }



        var $bindDoctor = function (department, callback) {
            var $ddlSearchDoctor = $('#ddlSearchDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                $ddlSearchDoctor.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlSearchDoctor.val());
            });
        }

        var paymentControlInitBasedOnBillingType = function (callback) {
            var useSeparateVisitAndBilling = Number('<%=Resources.Resource.UseSeparateVisitAndBilling%>');
            if (useSeparateVisitAndBilling == 0) {
                $paymentControlInit(function () {
                    callback();
                });
            }
            else
                callback();

        }


        var $bindMandatory = function (callback) {
            var manadatory = [
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPLastName', isRequired: false, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
				{ control: '#txtDOB', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },

                //{ control: '#txtAge', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                //{ control: '#ddlMarried', erroMessage: 'Select Marital Status', tabIndex: 3, isSearchAble: false },
                { control: '#txtMobile', isRequired: true, erroMessage: 'Enter Mobile Number', tabIndex: 4, isSearchAble: false },

                { control: '#txtRelationName', isRequired: true, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },
                //{ control: '#ddlCountry', isRequired: true, erroMessage: 'Please Select Country', tabIndex: 6, isSearchAble: true },
                { control: '#ddlDoctor', isRequired: true, erroMessage: 'Please Select Doctor', tabIndex: 6, isSearchAble: true },
                { control: '#ddlAppointmentType', isRequired: true, erroMessage: 'Please Select Visit Type', tabIndex: 7, isSearchAble: false },
                { control: '#ddlTypeOfApp', isRequired: true, erroMessage: 'Please Select Type of AppointMent', tabIndex: 8, isSearchAble: false },
                //{ control: '#ddlPurposeofVisit',isRequired:true, erroMessage: 'Please Select Purpose OF Visit', tabIndex: 9, isSearchAble: false },
                { control: '#txtAppointmentOn', isRequired: true, erroMessage: 'Please Enter AppointMent Date', tabIndex: 10, isSearchAble: false },
                { control: '#txtAppointmentTime', isRequired: true, erroMessage: 'Please Enter AppointMent Time', tabIndex: 11, isSearchAble: false },
                //{ control: '#txtAppointmentCharges', isRequired: true, erroMessage: 'Please Enter AppointMent Charges', tabIndex: 12, isSearchAble: false }


            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                $(manadatory[0].control).focus();
            });
            callback(true);
        }



        var $loadPaymentControl = function (elem) {
            $.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
            var userControlToLoad = ['OldPatientSearch.ascx']
            var useSeparateVisitAndBilling = Number('<%=Resources.Resource.UseSeparateVisitAndBilling%>');

            if (useSeparateVisitAndBilling == 0)
                userControlToLoad.push('UCPayment.ascx');

            serverCall('../Controls/LoadUserControl.asmx/LoadControl', { userControlNames: userControlToLoad, isControlHaveScriptManager: true }, function (response) {
                $('.appointmentDetails').hide();
                var temp = '<span id="lblReferenceCodeOPD" style="display:none">'
				+ '</span><span id="lblScheduleChargeID" style="display:none">'
				+ '</span><span id="lblHashCode" style="display:none">'
				+ '</span><span id="lblItemID" style="display:none"></span>'
				+ '</span><span id="lblSubCategoryID" style="display:none"></span>'
				+ '</span><span id="lblRate" style="display:none"></span>'
				+ '</span><span id="lblRateListID" style="display:none"></span>'
				+ '</span><span id="lblSelectedAppointmentID" style="display:none"></span>'
				+ '</span><span id="lbllblSelectedAppointmentDate" style="display:none"></span>';
                $('#divUserDetails').html(response + temp).removeAttr('style');
                $patientControlInit(function () {
                    $panelControlInit(function () {
                        $commonJsInit(function () {
                            $bindMandatory(function () {
                                paymentControlInitBasedOnBillingType(function () {
                                    var appointmentID = $(elem).closest('tr').find('#tdApp_ID').text();
                                    var appointmentDate = $(elem).closest('tr').find('#tdAppDate').text();
                                    $getBookedAppointmentDetails(appointmentID, function (patientAppointmentDetails) {
                                        $getHashCode(function (hashCode) {
                                            $bindPatientDetails(patientAppointmentDetails, function () {
                                                getPatientBasicDetails(function (patientDetails) {
                                                    console.log(patientAppointmentDetails);
                                                    $('#lblReferenceCodeOPD').text(patientAppointmentDetails.ReferenceCodeOPD);
                                                    $('#lblScheduleChargeID').text(patientAppointmentDetails.ScheduleChargeID);
                                                    $('#lblItemID').text(patientAppointmentDetails.ItemID);
                                                    $('#lblSubCategoryID').text(patientAppointmentDetails.SubcategoryID);
                                                    $('#lblRate').text(patientAppointmentDetails.Amount);
                                                    $('#lblRateListID').text(patientAppointmentDetails.RateListID);
                                                    $('#lblSelectedAppointmentID').text(appointmentID);
                                                    $('#lbllblSelectedAppointmentDate').text(appointmentDate);
                                                    $('#lblHashCode').text(hashCode);
                                                    if (useSeparateVisitAndBilling == 0) {
                                                        $getDiscountWithCoPay({ itemID: patientAppointmentDetails.ItemID, panelID: patientDetails.panelID, patientTypeID: patientDetails.patientTypeID, memberShipCardNo: '' }, function (discountCoPayment) {
                                                            if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1' && String.isNullOrEmpty(patientAppointmentDetails.PatientID)) {
	                                                            $bindRegistrationCharges(function () {
	                                                                $getRegistrationCharges(function (registrationDetails) {
	                                                                    var registrationCharge = registrationDetails.registrationCharge;
	                                                                    $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
	                                                                    var billAmount = (patientAppointmentDetails.Amount + registrationCharge);
	                                                                    var IsDiscountAuthorization = '<%=Util.GetInt(ViewState["IsDiscount"])%>';
	                                                                    $addBillAmount({
	                                                                        panelId: patientAppointmentDetails.PanelID,
	                                                                        billAmount: billAmount,
	                                                                        disCountAmount: 0,
	                                                                        isReceipt: $isReceipt,
	                                                                        patientAdvanceAmount: 0,
	                                                                        disableDiscount: IsDiscountAuthorization == '0' ? true : false,
	                                                                        refund: { status: false }
	                                                                    }, function () { });
	                                                                    $('.payment').show();
	                                                                });
	                                                            });
                                                            }
                                                            else {
                                                                $getRegistrationCharges(function (registrationDetails) {
                                                                    var registrationCharge = registrationDetails.registrationCharge;
                                                                    $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                                                                    var billAmount = patientAppointmentDetails.Amount + registrationCharge;
                                                                    var IsDiscountAuthorization = '<%=Util.GetInt(ViewState["IsDiscount"])%>';
                                                                    $addBillAmount({
                                                                        panelId: patientAppointmentDetails.PanelID,
                                                                        billAmount: billAmount,
                                                                        disCountAmount: 0,
                                                                        isReceipt: $isReceipt,
                                                                        patientAdvanceAmount: 0,
                                                                        disableDiscount: IsDiscountAuthorization == '0' ? true : false,
                                                                        refund: { status: false }
                                                                    }, function () { });
                                                                    $('.payment').show();
                                                                });
                                                            }
	                                                    });
                                                    }
                                                    else {
                                                        $('.payment').show();
                                                    }
	                                                $.unblockUI();
	                                            });
	                                        });
	                                    });
	                                });
	                            });
	                        });
	                    });
	                });
	            });
	        });
        }

        var $getBookedAppointmentDetails = function (appointmentID, callback) {
            serverCall('BookDirectAppointment.aspx/bindAppointmentDetail', { App_ID: appointmentID }, function (response) {
                var responseData = JSON.parse(response)
                if (responseData.status)
                    callback(responseData.data[0])
                else
                    modelAlert(responseData.message);
            });
        }
        var $realeasePaymentControl = function (callback) {
            $('.appointmentDetails').show();
            $('#divUserDetails').html('');
            $('.payment').hide();
            callback(true);
        }
        var $bindAppointmentDetails = function (callback) {
            if ($('input[name=RdoAppointment]:checked').val() == 'OPD') {
                getSearchCriteria(function (data) {
                    searchAppointments(data, function () { });
                });
            }
            else {
                getSearchCriteriaRadio(function (data) {
                    searchAppointmentsRadio(data, function () { });
                });
            }
        }

        $getDiscountWithCoPay = function (data, callback) {
            serverCall('../common/CommonService.asmx/GetDiscountWithCoPay', data, function (response) {
                callback(JSON.parse(response)[0]);
            });
        }


        var searchAppointments = function (data, callback) {
            serverCall('AppointmentConformation.aspx/GetApppointmentDetails', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    appointmentDetails = JSON.parse(response);

                    var output = $('#tb_AppointmentDetails').parseTemplate(appointmentDetails);
                    $('#divAppointmentDetails').html(output).customFixedHeader();
                    callback();
                }
                else {
                    $('#divAppointmentDetails').html('');
                    callback();
                }
            });
        }

        var searchAppointmentsRadio = function (data, callback) {
            serverCall('AppointmentConformation.aspx/GetRadiologyApppointmentDetails', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    appointmentDetails = JSON.parse(response);
                    var output = $('#tb_RadiologyAppoitmentDetails').parseTemplate(appointmentDetails);
                    $('#divRadiologyAppoitmentDetails').html(output).customFixedHeader();
                    //    $('#divRadioSave').show();
                    callback();
                }
                else {
                    $('#divRadiologyAppoitmentDetails').html('');
                    $('#divRadioSave').hide();
                    callback();
                }
            });
        }

        var labelSearch = function (appointmentStatus, callback) {
            if ($('input[name=RdoAppointment]:checked').val() == 'OPD') {
                getSearchCriteria(function (data) {
                    data.status = appointmentStatus;
                    searchAppointments(data, function () { });
                });
            } else {
                getSearchCriteriaRadio(function (data) {
                    data.status = appointmentStatus;
                    searchAppointmentsRadio(data, function () { });
                });
            }

        }



        $confirmAppointment = function (btnConfirm, callback) {
            var row = $(btnConfirm).parent().parent();
            var appointmentID = row.find('#tdApp_ID').text();

            var rowData = JSON.parse(row.attr('data'));

            var data = {
                appointmentID: appointmentID,
                status: 'confirm',
                remark: '',
                PatientID: rowData.PatientID,
                PName: rowData.NAME,
                DoctorName: rowData.DoctorName,
                ContactNo: rowData.ContactNo,
                AppDate: rowData.AppDate,
            };


            serverCall('AppointmentConformation.aspx/UpdateAppointmentStatus', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        $(row).css({ 'background-color': '#3CB371' });
                        $(row).find('input[type=button]').attr('Disabled', true);
                        $(row).find('input[type=button][name=payment]').attr('Disabled', false);
                    }
                });
            });
        }
        $rescheduleAppointment = function (btnReschedule) {
            //var appointmentID = $(btnReschedule).parent().parent().find('#tdApp_ID').text();
            //window.location.href = '../OPD/BookDirectAppointment.aspx?Appointment_Id=' + appointmentID;
            var IsSlotWiseToken = $(btnReschedule).parent().parent().find('#tdIsSlotWiseToken').text().trim();
            var doctorID = $(btnReschedule).parent().parent().find('#tdDoctorID').text().trim();
            var doctorName = $(btnReschedule).parent().parent().find('#tdDoctorName').text().trim();
            var appointmentID = $(btnReschedule).parent().parent().find('#tdApp_ID').text();
            $('#spnModalAppID').text(appointmentID);
            $('#spnModalDoctorID').text(doctorID);
            $('#spnisSlotWiseToken').text(IsSlotWiseToken);
            
            $getDoctorAppointmentTimeSlot(doctorName,doctorID, 1, true, IsSlotWiseToken, function (response) { });
        }
        var selectedRow = {};
        $cancelAppointmentModelOpen = function (btnCancel, callback) {
            selectedRow = $(btnCancel).parent().parent();
            var json = $.parseJSON(selectedRow.attr('data'));
            $('#PatientID').val(json.PatientID);
            $('#PName').val(json.NAME);
            $('#DoctorName').val(json.DoctorName);
            $('#ContactNo').val(json.ContactNo);
            $('#AppDate').val(json.AppDateTime);
            $('#spnSelectedAppointment').text(selectedRow.find('#tdApp_ID').text());
            $('#txtAppointmentCancelReason').val('');
            $('#divCancelConfirmation').showModel();
        }
        $cancelAppointment = function (reason, callback) {
            var appointmentID = $.trim(selectedRow.find('#tdApp_ID').text());



            serverCall('AppointmentConformation.aspx/UpdateAppointmentStatus', { appointmentID: appointmentID, status: 'cancel', remark: reason, PatientID: $('#PatientID').val(), PName: $('#PName').val(), DoctorName: $('#DoctorName').val(), ContactNo: $('#ContactNo').val(), AppDate: $('#AppDate').val() }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        $(selectedRow).remove();
                        $('#divCancelConfirmation').closeModel();
                    }
                });
            });
        }
        var $getHashCode = function (callback) {
            serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
                callback(response);
            });
        }
        $getAppointmentDetails = function (callback) {
            callback({
                ReferenceCodeOPD: $('#lblReferenceCodeOPD').text(),
                ScheduleChargeID: $('#lblScheduleChargeID').text(),
                ItemID: $('#lblItemID').text(),
                SubCategoryID: $('#lblSubCategoryID').text(),
                Rate: $('#lblRate').text(),
                RateListID: $('#lblRateListID').text(),
                hashCode: $('#lblHashCode').text(),
                appointmentID: $('#lblSelectedAppointmentID').text(),
                appointmentDate: $('#lbllblSelectedAppointmentDate').text(),
            });
        }

        var getPaymentDetailsBasedOnBillingType = function (callback) {
            var useSeparateVisitAndBilling = Number('<%=Resources.Resource.UseSeparateVisitAndBilling%>');
        if (useSeparateVisitAndBilling == 0) {
            $getPaymentDetails(function (paymentDetails) {
                callback(paymentDetails);
            });
        }
        else {
            callback([]);
        }
    }



    $getAppointmentPaymentDetails = function (callback) {
        $getAppointmentDetails(function (appointmentDetails) {
            $getPatientDetails(function (patientDetails) {
                getPaymentDetailsBasedOnBillingType(function (paymentDetails) {

                    var useSeparateVisitAndBilling = Number('<%=Resources.Resource.UseSeparateVisitAndBilling%>');

                    $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                    $PM = patientDetails.defaultPatientMaster;
                    //$PM = {
                    //    PatientID: patientDetails.PatientID,
                    //    IsNewPatient: patientDetails.IsNewPatient,
                    //    OldPatientID: patientDetails.OldPatientID,
                    //    Title: patientDetails.Title.value,
                    //    PFirstName: patientDetails.PFirstName,
                    //    PLastName: patientDetails.PLastName,
                    //    PName: patientDetails.PName,
                    //    Age: patientDetails.Age,
                    //    Gender: patientDetails.Gender,
                    //    PanelID: patientDetails.PanelID,
                    //    MaritalStatus: patientDetails.MaritalStatus.text,
                    //    Mobile: patientDetails.Mobile,
                    //    Email: patientDetails.Email,
                    //    Relation: patientDetails.Relation.text,
                    //    RelationName: patientDetails.RelationName,
                    //    House_No: patientDetails.House_No,
                    //    Country: patientDetails.Country.text,
                    //    StateID: patientDetails.State.value,
                    //    District: patientDetails.District.text,
                    //    City: patientDetails.City.text,
                    //    Taluka: patientDetails.Taluka.text,
                    //    CountryID: patientDetails.Country.value,
                    //    DistrictID: patientDetails.District.value,
                    //    CityID: patientDetails.City.value,
                    //    TalukaID: patientDetails.Taluka.value,
                    //    Place: patientDetails.Place,
                    //    LandMark: patientDetails.LandMark,
                    //    Occupation: patientDetails.Occupation,
                    //    AdharCardNo: patientDetails.AdharCardNo,
                    //    HospPatientType: patientDetails.HospPatientType.text,
                    //    PatientType: patientDetails.PatientType.text,
                    //    isCapTure: patientDetails.isCapTure,
                    //    base64PatientProfilePic: patientDetails.base64PatientProfilePic
                    //}

                    $PMH = {
                        patient_type: patientDetails.PatientType.text,
                        PanelID: patientDetails.PanelID,
                        DoctorID: patientDetails.Doctor.value,
                        ReferedBy: patientDetails.ReferedBy,
                        Type: 'OPD',
                        ParentID: patientDetails.ParentID,
                        HashCode: appointmentDetails.hashCode,
                        Purpose: '',
                        ScheduleChargeID: appointmentDetails.ScheduleChargeID,
                        PolicyNo: patientDetails.panelDetails.policyNo,
                        PanelIgnoreReason: patientDetails.panelDetails.ignorePolicyReason,
                        ExpiryDate: patientDetails.panelDetails.expireDate,
                        EmployeeDependentName: patientDetails.panelDetails.nameOnCard,
                        CardNo: patientDetails.panelDetails.cardNo,
                        CardHolderName: patientDetails.panelDetails.nameOnCard,
                        RelationWith_holder: patientDetails.panelDetails.cardHolderRelation,
                        KinRelation: patientDetails.Relation.text,
                        KinName: patientDetails.RelationName,
                        KinPhone: patientDetails.RelationPhoneNo,
                        patientTypeID: patientDetails.PatientType.value,
                    }

                    if (useSeparateVisitAndBilling == 0) {
                        $PMH.PatientPaybleAmt = paymentDetails.patientPayableAmount,
                        $PMH.PanelPaybleAmt = paymentDetails.panelPayableAmount,
                        $PMH.PatientPaidAmt = paymentDetails.patientPaidAmount,
                        $PMH.PanelPaidAmt = paymentDetails.panelPaidAmount
                    }
                    else {
                        $PMH.PatientPaybleAmt = 0,
                        $PMH.PanelPaybleAmt = 0,
                        $PMH.PatientPaidAmt = 0,
                        $PMH.PanelPaidAmt = 0
                    }

                    $LT = {};
                    $LTD = {};
                    $paymentDetails = [];
                    if (useSeparateVisitAndBilling == 0) {
                        $LT = {
                            PanelID: patientDetails.PanelID,
                            NetAmount: paymentDetails.netAmount,
                            GrossAmount: paymentDetails.billAmount,
                            DiscountReason: paymentDetails.discountReason,
                            DiscountApproveBy: paymentDetails.approvedBY,
                            DiscountOnTotal: paymentDetails.discountAmount,
                            RoundOff: paymentDetails.roundOff,
                            GovTaxPer: 0,
                            GovTaxAmount: 0,
                            Adjustment: $isReceipt ? paymentDetails.adjustment : '0',
                            CurrentAge: patientDetails.Age,
                            PatientType_ID: patientDetails.PatientType.value,
                        }
                        $LTD = {
                            ItemID: appointmentDetails.ItemID,
                            Rate: appointmentDetails.Rate,
                            Quantity: '1',
                            DiscAmt: paymentDetails.discountAmount,
                            DiscountPercentage: paymentDetails.discountPercent,
                            Amount: paymentDetails.billAmount - paymentDetails.discountAmount,
                            SubCategoryID: appointmentDetails.SubCategoryID,
                            ItemName: patientDetails.Doctor.text,
                            DiscountReason: paymentDetails.discountReason,
                            DoctorID: patientDetails.Doctor.value,
                            panelCurrencyCountryID: patientDetails.panelDetails.panelCurrencyCountryID,
                            panelCurrencyFactor: patientDetails.panelDetails.panelCurrencyFactor,
                        }
                        $paymentDetails = [];
                        $(paymentDetails.paymentDetails).each(function () {
                            $paymentDetails.push({
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
                                PaymentRemarks: paymentDetails.paymentRemarks,
                                swipeMachine: this.swipeMachine,
                                currencyRoundOff: paymentDetails.currencyRoundOff / paymentDetails.paymentDetails.length
                            })
                        });
                    }
                    callback({ patientMaster: [$PM], PMH: [$PMH], LT: [$LT], LTD: [$LTD], paymentDetail: $paymentDetails, parentPanelID: patientDetails.ParentID, scheduleChargeID: appointmentDetails.ScheduleChargeID, rateListID: appointmentDetails.RateListID, hashCode: appointmentDetails.hashCode, appointmentID: appointmentDetails.appointmentID, appointmentDate: appointmentDetails.appointmentDate, doctorID: patientDetails.Doctor.value, patientDocuments: patientDetails.patientDocuments, panelDocuments: patientDetails.panelDocuments });
                });
            });
        });
    }
    $saveAppointmentPaymentDetails = function (btnSave, callback) {
        $getAppointmentPaymentDetails(function (data) {
            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('Services/GetAppointmentPayment.asmx/SaveAppointmentPaymentDetails', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        $('#' + data.appointmentID).attr('disabled', true);
                        $(btnSave).removeAttr('disabled').val('Save');

                        var useSeparateVisitAndBilling = Number('<%=Resources.Resource.UseSeparateVisitAndBilling%>');
                        if (useSeparateVisitAndBilling == 0) {
                            $realeasePaymentControl(function () {
                                window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + responseData.ledgerTransactionNo + '&IsBill=' + responseData.IsBill + '&Duplicate=0');
                                if ('<%= Resources.Resource.OPDCard%>' == '1') {
                                    window.open('../common/OPDCard.aspx?LedgerTransactionNo=' + responseData.ledgerTransactionNo + '');
                                }
                            });
                        }
                        else {
                            $realeasePaymentControl(function () { });
                            //window.open('../common/OPDCard.aspx?LedgerTransactionNo=' + responseData.ledgerTransactionNo + '');
                        }
                    }
                    else
                        $(btnSave).removeAttr('disabled').val('Save');
                });
            });
        });
    }

        var getSearchCriteria = function (callback) {
            var mobileOrUHID = "";
            if ($('#ddlMobileUHID').val() == 'Mobile') {
                mobileOrUHID = 'Mobile';
            }
            else { mobileOrUHID = 'UHID'; }

        var data = {
            doctorID: $('#ddlSearchDoctor').val() == '0' ? '' : $('#ddlSearchDoctor').val(),
            fromDate: $('#txtFromDate').val(),
            toDate: $('#TextBox1').val(),
            appointmentNo: $('#txtAppointmentNo').val(),
            isConform: '',
            visitType: $('#ddlSearchPatientType').val(),
            status: $('#ddlStatus').val(),
            doctorDepartmentID: $('#ddlSpecialization').val(),
            Pname: $('#txtAppPName').val(),
            mobileOrUHID: mobileOrUHID,
            mobileOrUHIDNo: $('#txtMobileUHID').val()
        }
        callback(data);
    }



    var getAppointmentReport = function (callback) {
        if ($('input[name=RdoAppointment]:checked').val() == 'OPD') {
            getSearchCriteria(function (data) {
                data.reportType = '2';
                serverCall('AppointmentConformation.aspx/GetAppointmentReport', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status)
                        window.open(responseData.responseURL);
                    else
                        modelAlert(responseData.response);
                });
            });
        }
        else {
            getSearchCriteriaRadio(function (data) {
                data.reportType = '2';
                serverCall('AppointmentConformation.aspx/GetRadiologyAppointmentReport', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status)
                        window.open(responseData.responseURL);
                    else
                        moddelAlert(responseData.response);
                });
            });
        }
    }
    var getSearchCriteriaRadio = function (callback) {
        var data = {
            fromDate: $('#txtFromDate').val(),
            toDate: $('#TextBox1').val(),
            UHID: $('#txtUHID').val().trim(),
            PName: $('#txtPName').val().trim(),
            Mobile: $('#txtMobileRadio').val().trim(),
            SubCategoryID: $('#ddlSubCategory').val() == '0' ? '' : $('#ddlSubCategory').val(),
            LabNo: $('#txtLabNo').val().trim(),
            TokenNo: $('#txtTokenNo').val().trim(),
            isConform: '',
            status: $('#ddlStatus').val(),
        }
        callback(data);
    }


    </script>
    <script type="text/javascript">
        var ChangeSearchCriteria = function (elem) {
            if (elem == 'OPD') {
                $('.SearchRadio').hide();
                $('.SearchOpd').show();
            }
            else {
                $('.SearchRadio').show();
                $('.SearchOpd').hide();
            }
        }

        var $rescheduleRadioAppointment = function (btnReschedule) {

            rowID = $(btnReschedule).parent().parent();
            BookingID = $(rowID).find('#tdRBookingID').text();
            //if (IsRadioApointmentReschedulePayment == '1') {
            $InvestigationDate = $('#txtInvestigationCurrDate').val();
            ItemID = $(rowID).find('#tdRItemID').text();
            doctorID = '';
            SubCategoryID = $(rowID).find('#tdRSubCategoryID').text();
            $('#spnItemIDforSlot').text(ItemID);
            $('#txtInvestigationSlotDate').val($InvestigationDate);

            isOnlineBooking = $(rowID).find('#tdRisOnlineBooking').text();
            bindModality(SubCategoryID, function () {
                Modality = $('#ddlModality option').eq(0).val();
                $getInvestigationTimeSlot($InvestigationDate, doctorID, ItemID, SubCategoryID, true, '', Modality, BookingID, isOnlineBooking, function (response) {
                });
            });
            //}
            //else {
            //    window.location.href = '../OPD/RescheduleRadiologyAppointment.aspx?LtdID=' + BookingID;
            //}
        }

        var $getInvestigationTimeSlot = function (InvestigationDate, doctorID, ItemID, SubCategoryID, isModelShow, rowID, Modality, BookingID, isOnlinebooking, callback) {
            var centreID = '<%= HttpContext.Current.Session["CentreID"]%>'
            serverCall('AppointmentConformation.aspx/GetInvestigationTimeSlot', { DoctorId: doctorID, InvestigationDate: InvestigationDate, BookingType: 2, ItemID: ItemID, SubCategoryID: SubCategoryID, centreId: centreID, Modality: Modality }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $('#divInvSlotAvailabilityBody').html($responseData.response);
                    if ($('#spnIsSearchSelect').text() == '0') {
                        var txtInvestigationTime = $(rowID).closest('tr').find('#spnInvestigationSlotTime');
                        $(txtInvestigationTime).text($responseData.defaultAvilableSlot);
                        $(rowID).closest('tr').find('#spnInvestigationSlotDate').text(InvestigationDate);
                    }
                    else {

                    }
                    if ($responseData.defaultAvilableSlot == '')
                        modelAlert('Slot Not Avilable');
                    $('#spnModalSubCategoryID').text(SubCategoryID);
                    $('#spnModalItemID').text(ItemID);
                    $('#spnModalBookingID').text(BookingID);
                    $('#spnModalinonlineBooking').text(isOnlinebooking);
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
        };

        var bindModality = function (subcategoryid, callback) {
            $ddlModality = $('#ddlModality');
            serverCall('../common/CommonService.asmx/BindModality', { SubcategoryID: subcategoryid, CentreID: '<%=Session["CentreID"]%>' }, function (response) {
                var responseData = JSON.parse(response);
                $ddlModality.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: false });
                callback($ddlModality.val());
            });
        }

        var onInvestigationDateChange = function (el) {
            var $InvestigationDate = '';
            var SubCategoryID = '';
            var doctorID = '';
            Modality = $('#ddlModality').val();
            if ($('#spnItemIDforSlot').text() != '') {
                $('#tableRadio tbody tr').each(function () {
                    if ($(this).find('#tdRItemID').text().trim() == $('#spnItemIDforSlot').text() && $(this).find('#tdRBookingID').text().trim() == $('#spnModalBookingID').text()) {
                        $InvestigationDate = el.value;
                        SubCategoryID = $(this).find('#tdRSubCategoryID').text();
                        $getInvestigationTimeSlot($InvestigationDate, doctorID, $(this).find('#tdRItemID').text().trim(), SubCategoryID, true, '', Modality, $(this).find('#tdRBookingID').text().trim(), $(this).find('#tdRisOnlineBooking').text().trim(), function (response) {

                        });
                    }
                });
            }
        }

        var onInvestigationModalityChange = function (el) {
            var $InvestigationDate = $('#txtInvestigationSlotDate').val();
            var SubCategoryID = '';
            var doctorID = '';
            var Modality = el.value;
            if ($('#spnItemIDforSlot').text() != '') {
                $('#tableRadio tbody tr').each(function () {
                    if ($(this).find('#tdRItemID').text().trim() == $('#spnItemIDforSlot').text() && $(this).find('#tdRBookingID').text().trim() == $('#spnModalBookingID').text()) {
                        $(this).find('#tdRBookingDate').text($InvestigationDate);
                        SubCategoryID = $(this).find('#tdRSubCategoryID').text();
                        $getInvestigationTimeSlot($InvestigationDate, doctorID, $(this).find('#tdRItemID').text().trim(), SubCategoryID, true, '', Modality, $(this).find('#tdRBookingID').text().trim(), $(this).find('#tdRisOnlineBooking').text().trim(), function (response) {
                        });
                    }

                });
            }
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
                modalityID: $('#ddlModality option:selected').val(),
                SubCategoryID: $('#divInvSlotAvailability div #spnModalSubCategoryID').text(),
                ItemID: $('#divInvSlotAvailability div #spnModalItemID').text(),
                BookingDate: $.trim($('#txtInvestigationSlotDate').val()),
                TimeSlot: $.trim($(elem).find('#spnInvestigationTime').text()),
                BookingID: $('#divInvSlotAvailability div #spnModalBookingID').text(),
                isOnlineBooking: $('#divInvSlotAvailability div #spnModalinonlineBooking').text(),
            }
            modelConfirmation('Reschedule Radiology Appointment', 'Are you sure to Update Schedule ', 'Update', 'Cancel', function (response) {
                if (response) {
                    UpdateRadiologySchedule(data, function (response) {
                        $('#divInvSlotAvailability').closeModel();
                        $bindAppointmentDetails(function () { });

                    });
                }
            });
        }

        var UpdateRadiologySchedule = function (data, callback) {
            serverCall('AppointmentConformation.aspx/UpdateRadiologySchedule', data, function (response) {
                result = JSON.parse(response);
                if (!(result.status)) {
                    modelAlert(result.response, function () {

                    });
                }
                else {
                    modelAlert(result.response, function () {
                        callback(true);
                    })

                }
            });
        }

        var $getDoctorAppointmentTimeSlot = function (doctorName,doctorID, isManualSlot, isModelShow, IsSlotWiseToken, callback) {
            debugger;
            var appointmentDate = $("#txtAppointmentSlotDate").val();
            var centreID = '<%= HttpContext.Current.Session["CentreID"]%>'
            var appSlotMin = $('#ddlSolotMin').val();
            $("#spnSelectedDoctor").text(doctorName);

            serverCall('Lab_PrescriptionOPD.aspx/GetDoctorAppointmentTimeSlotConsecutive', { DoctorId: doctorID, _appointmentDate: appointmentDate, appointmentType: 2, centreId: centreID, AppSlot: appSlotMin, IsManualSlot: isManualSlot }, function (response) {
                var responseData = JSON.parse(response);

                var divSlotAvailabilityBody = $('#divSlotAvailabilityBody').find('.slotDetails');
                var divSlotAvailabilityHead = $('#divSlotAvailabilityBody').find('.patientInfo');
                for (var i = 0; i < responseData.response.length; i++) {
                    $(divSlotAvailabilityHead[i]).text(responseData.response[i].appointmentDate);
                    $(divSlotAvailabilityBody[i]).html(responseData.response[i].response);
                }

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
                        
                    }

                    MarcTooltips.add('div .badge-avilable', 'Select Slot for Block', {
                        position: 'up',
                        align: 'left'
                    });


                    callback(appointmentDate);
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

        var $selectSlot = function (elem) {
            $('#divSlotAvailabilityBody .circle').removeClass('badge-pink');
            $(elem).addClass('badge-pink');
        }

        var $dobuleClick = function (elem) {
            var slotTimingDisplay = $(elem).closest('.slotDetails').prev().text() + ' ' + $.trim($(elem).find('#spnAppointmentTime').text());
            
            var slotTiming = $(elem).closest('.slotDetails').prev().text() + '#' + $.trim($(elem).find('#spnAppointmentTime').text());
            var AppID = $('#divSlotAvailability div #spnModalAppID').text();
            var isSlotWiseToken = $('#divSlotAvailability div #spnisSlotWiseToken').text();
            var doctorID = $('#divSlotAvailability div #spnModalDoctorID').text();
            modelConfirmation('Reschedule Doctor Appointment', 'Are you sure to Update Schedule ', 'Update', 'Cancel', function (response) {
                if (response) {
                    UpdateDoctorAppointmentSchedule(slotTiming, AppID,isSlotWiseToken,doctorID, function (response) {
                        $('#divSlotAvailability').closeModel();
                        $bindAppointmentDetails(function () { });

                    });
                }
            });
            
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

        var UpdateDoctorAppointmentSchedule = function (slotTiming, AppID, IsSlotWiseToken, doctorID,callback) {
            serverCall('AppointmentConformation.aspx/UpdateDoctorAppointmentSchedule', { slotTiming: slotTiming, appID: AppID, IsSlotWiseToken: IsSlotWiseToken, doctorID: doctorID }, function (response) {
                result = JSON.parse(response);
                if (!(result.status)) {
                    modelAlert(result.response, function () {});
                }
                else {
                    modelAlert(result.response, function () {
                        callback(true);
                    });
                }
            });
        }

        var SaveAppointmentPayment = function (btnPayemnt) {
            var appointmentID = $(btnPayemnt).parent().parent().find('#tdApp_ID').text();
            window.location.href = '../OPD/Lab_PrescriptionOPD.aspx?AppointmentID=' + appointmentID;
        }
    </script>
    <input type="hidden" id="PatientID" value="" />
    <input type="hidden" id="PName" value="" />
    <input type="hidden" id="DoctorName" value="" />
    <input type="hidden" id="ContactNo" value="" />
    <input type="hidden" id="AppDate" value="" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Appointment Confirmation </b><br />
             <div style="display:none">
                 <input type="radio" name ="RdoAppointment" value="OPD" checked="checked" onchange="ChangeSearchCriteria($('input[name=RdoAppointment]:checked').val());" /><b>OPD</b> 
                 <input type="radio" name ="RdoAppointment" value="Radio" onchange="ChangeSearchCriteria($('input[name=RdoAppointment]:checked').val());" /><b>Radiology </b>
                  <asp:TextBox runat="server" ClientIDMode="Static" Style="display:none" ID="txtInvestigationCurrDate"></asp:TextBox>
                  <cc1:CalendarExtender ID="ccInvCur" TargetControlID="txtInvestigationCurrDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                  <span style="display: none" id="spnItemIDforSlot"></span>
             </div>
        </div>
        <div class="POuter_Box_Inventory  appointmentDetails">
            <div class="Purchaseheader">Search Criteria</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtAppointmentSearchFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="TextBox1" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="TextBox1" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Status  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus" title="Select Appointment Status">
                                <option value="All">All</option>
                                <option value="Confirmed">Confirmed</option>
                                <option value="ReScheduled">ReScheduled</option>
                                <option value="Pending">Pending</option>
                                <option value="Canceled">Canceled</option>
                                <option value="App. Time Expired">App. Time Expired</option>
                            </select>
                        </div>
                    </div>
                    <div class="row SearchOpd">
                        <div class="col-md-3 ">
                            <label class="pull-left">Appointment No.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="txtAppointmentNo" type="text" maxlength="10" title="Enter Appointment No." autocomplete="off" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Patient Type  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSearchPatientType" title="Select Appointment Status">
                                <option value="All">All</option>
                                <option value="Old Patient">Old Patient</option>
                                <option value="Old Patient">New Patient</option>
                            </select>
                        </div>
                        <div class="col-md-3 SearchOpd" style="display:none">
							<label class="pull-left"> Patient Name  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 SearchOpd" style="display:none">
						   <input type="text" id="txtAppPName" />    
						</div>
                    </div>

                    <div class="row SearchOpd">

                        <div class="col-md-3">
                            <label class="pull-left">Specialization</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSpecialization" title="Select Specialization" onchange="doctorDepartmentChange(this)"></select>
                        </div>



                        <div class="col-md-3">
                            <label class="pull-left">Doctor Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSearchDoctor" title="Select Doctor Name"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"><select id="ddlMobileUHID">
                                <option value="Mobile">Mobile</option>
                                <option value="UHID">UHID</option>
                                                     </select> </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input  type="text" id="txtMobileUHID"/>
                        </div>

                    </div>

                       <div class="row  SearchRadio">
                         <div class="col-md-3">
							<label class="pull-left"> UHID  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <input type="text" id="txtUHID" />    
						</div>
                         <div class="col-md-3">
							<label class="pull-left"> Patient Name  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <input type="text" id="txtPName" />    
						</div>
                         <div class="col-md-3">
							<label class="pull-left"> Mobile  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <input type="text" id="txtMobileRadio" />    
						</div>
                    </div>
                    <div class="row SearchRadio">
                         <div class="col-md-3">
							<label class="pull-left"> SubCategory  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <select id="ddlSubCategory"></select>  
						</div>
                         <div class="col-md-3">
							<label class="pull-left"> Lab No  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <input type="text" id="txtLabNo" />    
						</div>
                         <div class="col-md-3">
							<label class="pull-left"> Token No  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <input type="text" id="txtTokenNo" />    
						</div>
					</div>


                    <%--<div class="row">
						<div class="col-md-8">
						</div>
						<div style="text-align:center" class="col-md-8">
							 <input type="button" onclick="$bindAppointmentDetails(function () { });" value="Search" />   
							 <input type="button" onclick="getAppointmentReport(function () { })"  value="Report" />                          
						</div>
						<div class="col-md-8"></div>
					</div>--%>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter appointmentDetails">
            <input type="button" class="save margin-top-on-btn" onclick="$bindAppointmentDetails(function () { });" value="Search" />
            <input type="button" class="save margin-top-on-btn" onclick="getAppointmentReport(function () { })" value="Report" />
        </div>


        <div class="POuter_Box_Inventory appointmentDetails">
            <div class="row">
                <div style="text-align: center" class="col-md-3">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left" onclick="labelSearch('Confirmed',function(){})" class="circle badge-avilable"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Confirmed</b>
                </div>
                <div style="text-align: center" class="col-md-3">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left" onclick="labelSearch('ReScheduled',function(){})" class="circle badge-warning"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Rescheduled</b>
                </div>
                <div style="text-align: center" class="col-md-3">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left" onclick="labelSearch('Pending',function(){})" class="circle badge-primary"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                </div>
                <div style="text-align: center" class="col-md-5">
               <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" onclick="labelSearch('App. Time Expired',function(){})" class="circle badge-grey"></button>
							 <b style="margin-top:5px;margin-left:5px;float:left">Appointment Time Expired</b>
                </div>
                <div style="text-align: center" class="col-md-3">
               <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:lightpink"  class="circle"></button>
							 <b style="margin-top:5px;margin-left:5px;float:left">Canceled </b>
                </div>
                <div style="text-align: center" class="col-md-3">
               <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:skyblue"  class="circle"></button>
							 <b style="margin-top:5px;margin-left:5px;float:left">Unregistered </b>
                </div>
            </div>
            <div class="row SearchOpd">
				<div  style="overflow:scroll;max-height:410px" id="divAppointmentDetails" class="col-md-24  CustomfixedHeader">

				</div>
			</div>
            <div class="row SearchRadio">
				<div  style="overflow:auto;max-height:410px" id="divRadiologyAppoitmentDetails" class="col-md-24  CustomfixedHeader">

				</div>
			</div>
        </div>
            <div class="POuter_Box_Inventory" id="divRadioSave" style="display:none">
              <div class="row" style="text-align:center">
                  <input type="button" id="btnPaymentReschedule" value="Reschedule" class="save margin-top-on-btn" onclick="RescheduleandPayment();"/>
              </div>
        </div>
        <div id="divUserDetails" class="payment">
        </div>
        <div style="display: none" class="POuter_Box_Inventory payment">
            <div style="text-align: center" class="col-md-24">
                <input type="button" id="btnSavePayment" class="ItDoseButton" style="width: 100px; margin-top: 7px" value="Save" onclick="$saveAppointmentPaymentDetails(this, function () { });" tabindex="35" />
                <input type="button" id="btnCancelPayment" class="ItDoseButton" style="width: 100px; margin-top: 7px" onclick="$realeasePaymentControl(function () { })" value="Cancel" tabindex="35" />
            </div>
        </div>
    </div>

    <div id="divCancelConfirmation"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divCancelConfirmation" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Appointment Cancel Reason</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div style="display:none" class="col-md-5">
							   <label class="pull-left">   Reason   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-24">
							 <textarea cols="" rows=""  style="height: 75px;width: 276px;max-height:75px;max-width:276px;min-height:75px;min-width:276px"  id="txtAppointmentCancelReason"></textarea>
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$cancelAppointment($('#txtAppointmentCancelReason').val(),function(){})">Save</button>
						 <button type="button"  data-dismiss="divCancelConfirmation" >Close</button>
				</div>
			</div>
		</div>
	</div>
   <script id="tb_AppointmentDetails" type="text/html">
	<table  id="tableApp" cellspacing="0" class="yui" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr class="tblTitle" id="Header">
			<th class="GridViewHeaderStyle" scope="col" >#</th>
			<th class="GridViewHeaderStyle" scope="col" >App. No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>             
			<th class="GridViewHeaderStyle" scope="col" >Age</th>   
			<th class="GridViewHeaderStyle" scope="col" >ContactNo</th>
			<th class="GridViewHeaderStyle" scope="col" >Relative</th>           
			<th class="GridViewHeaderStyle" scope="col" >Doctor Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Type</th>     
            <th class="GridViewHeaderStyle" scope="col" >Purpose of Visit</th>     
			<th class="GridViewHeaderStyle" scope="col" >App. Time</th>         
			<th class="GridViewHeaderStyle" scope="col" >App. Date</th>
			<th class="GridViewHeaderStyle" style="width:320px" scope="col" >Action</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center;display:none">IsReschedule</th>
			 <th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center;display:none">IsConform</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center;display:none">App_ID</th>
		</tr>
			</thead>
		<tbody>
		<#     
			  var dataLength=appointmentDetails.length;
				var objRow;
	   for(var j=0;j<dataLength;j++)
		{
		objRow = appointmentDetails[j];
		#>
						<tr data='<#= JSON.stringify(appointmentDetails[j])#>' id="<#=j+1#>" style=
							 <# 
                             if(objRow.IsCancel =="1")
								 {#> "background-color:LightPink" <#} 

                            

                            else if(objRow.IsConform =="0" && objRow.IsCancel =="0" && objRow.isExpired =="0")
								 {#> "background-color:''"  <#} 

                            else if(objRow.IsConform =="1" && objRow.PatientID == "")
								 {#>  "background-color:skyblue" <#}

                            else if(objRow.IsConform =="1")
								 {#> "background-color:#3CB371"  <#} 

							else if(objRow.IsReschedule =="1")
								 {#> "background-color:#F89406" <#} 
                            else if(objRow.isExpired =="1")
								 {#> "background-color:gray" <#}
						
						 #>>                           
						<td class="GridViewLabItemStyle"  style="width:30px;">
						 <#=j+1#></td>      
																	 
						<td class="GridViewLabItemStyle" id="tdAppNo" ><#=objRow.AppNo#></td>
						<td class="GridViewLabItemStyle" id="tdPName" ><#=objRow.NAME#></td>
                        <td class="GridViewLabItemStyle" id="tdpatientid" ><#=objRow.PatientID#></td> 
						<td class="GridViewLabItemStyle" id="td1" ><#=objRow.Age#></td>
						<td class="GridViewLabItemStyle" id="td2" ><#=objRow.ContactNo#></td>
						<td class="GridViewLabItemStyle" id="td3" ><#=objRow.Relative#></td>                      
						<td class="GridViewLabItemStyle" id="tdDoctorName" ><#=objRow.DoctorName#></td>                      
						<td class="GridViewLabItemStyle" id="tdVisitType" ><#=objRow.VisitType#></td>   
                        <td class="GridViewLabItemStyle" id="tdPurposeofVisit" ><#=objRow.PurposeOfVisit#></td>                  
						<td class="GridViewLabItemStyle" id="tdAppTime" ><#=objRow.AppTime#></td>                    
						<td class="GridViewLabItemStyle" id="tdAppDate" ><#=objRow.AppDate#></td>
						<td class="GridViewLabItemStyle" style="text-align:center" id="tdStatus" >
							  <input type="button" value="Confirm" class="ItDoseButton" onclick="$confirmAppointment(this, function () { });"  id="btnConfirm"  
								  <#
								 if(objRow.IsConform=='1' || objRow.isExpired=='1' || objRow.IsCancel=='1'){#>
									 disabled="disabled" <#} 
								  #>
								   />
							  <input type="button" value="Reschedule" class="ItDoseButton" onclick="$rescheduleAppointment(this)" id="btnReschedule"
								  <#if(objRow.IsConform=='1' || objRow.IsCancel=='1'){#>
								   disabled="disabled" <#} 
								  #>
								   />
								   <%--<input type="button" name="payment" value="Registration" id="<#=objRow.App_ID#>" class="ItDoseButton" onclick="$loadPaymentControl(this);" id="btnPayment"--%>
                            <input type="button" name="payment" value="Reg/Payment" id="<#=objRow.App_ID#>" class="ItDoseButton" onclick="SaveAppointmentPayment(this);" id="btnPayment"
								  <#if(objRow.Reg_Pay=='0'){#>
								   disabled="disabled" <#} 
								  #>
								   />
									 <input type="button" value="Cancel" onclick="$cancelAppointmentModelOpen(this, function () { });" class="ItDoseButton" id="btnCancel"
								  <#if(objRow.IsConform=='1' || objRow.IsCancel=='1' || objRow.isExpired=='1'){#>
								  
								   disabled="disabled" <#} 
								  #>
								   />
						</td>                    
						<td class="GridViewLabItemStyle" id="tdIsReschedule" style="width:30px;text-align:center;display:none"><#=objRow.PatientID#>' '<#=objRow.IsCancel#>' '<#=objRow.isExpired#>' '<#=objRow.IsConform#>' '<#=objRow.IsReschedule#></td>
						<td class="GridViewLabItemStyle" id="tdIsConform" style="width:30px;text-align:center;display:none"><#=objRow.IsConform#></td>
						<td class="GridViewLabItemStyle" id="tdApp_ID" style="width:30px;text-align:center;display:none"><#=objRow.App_ID#></td>
                        <td class="GridViewLabItemStyle" id="tdIsSlotWiseToken" style="width:30px;text-align:center;display:none"><#=objRow.IsSlotWiseToken#></td>    
                        <td class="GridViewLabItemStyle" id="tdDoctorID" style="width:30px;text-align:center;display:none"><#=objRow.DoctorID#></td>
							  </tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
   </script>

    <%--Start Radiology Slot Modal--%>

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
                                <cc1:CalendarExtender ID="calenderInvestigationSlotDate" TargetControlID="txtInvestigationSlotDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <b class="modal-title">Modality :</b>
                            </div>
                            <div class="col-md-5">
                                <span id="spnModalSubCategoryID" style="display:none"></span>
                                <span id="spnModalItemID" style="display:none"></span>
                                 <span id="spnModalBookingID" style="display:none"></span>
                                 <span id="spnModalinonlineBooking" style="display:none"></span>
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
     <script id="tb_RadiologyAppoitmentDetails" type="text/html">
	<table  id="tableRadio" cellspacing="0" class="yui" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr class="tblTitle" id="RHeader">
			<th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>
            <th class="GridViewHeaderStyle" scope="col" >Lab No</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>             
			<th class="GridViewHeaderStyle" scope="col" >Age</th>   
			<th class="GridViewHeaderStyle" scope="col" >ContactNo</th>    
            <th class="GridViewHeaderStyle" scope="col" >Department</th> 
            <th class="GridViewHeaderStyle" scope="col" >Test Name</th> 
            <th class="GridViewHeaderStyle" scope="col" >TokenNo</th> 
            <th class="GridViewHeaderStyle" scope="col" >Room</th>                   
			<th class="GridViewHeaderStyle" scope="col" >App. Date</th>
            <th class="GridViewHeaderStyle" scope="col" >App. Time</th>  
            <th class="GridViewHeaderStyle" scope="col" >BookingFrom</th>
			<th class="GridViewHeaderStyle" style="width:30px" scope="col" >Select</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center;display:none">IsReschedule</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;text-align:center;display:none">IsConform</th>
		</tr>
			</thead>
		<tbody>
		<#     
			  var dataLength=appointmentDetails.length;
				var objRow;
	   for(var j=0;j<dataLength;j++)
		{
		objRow = appointmentDetails[j];
		#>
						<tr data='<#= JSON.stringify(appointmentDetails[j])#>' id="Tr1" 
							 <#
	if((appointmentDetails[j].IsReschedule =="0") && (appointmentDetails[j].IsDeptReceive =="0") &&(appointmentDetails[j].IsCancel =="0"))
						  {#>   style="background-color:''" <#} 
							else 
						 {
							   if(appointmentDetails[j].IsReSchedule =="1")
								 {#>  style="background-color:#f89406!important" <#} 
							if(appointmentDetails[j].IsDeptReceive =="1")
								 {#> style="background-color:#3CB371"  <#} 
							if(appointmentDetails[j].IsCancel =="1")
								 {#> style="background-color:LightPink" <#} 
						 	if(appointmentDetails[j].isExpired =="1")
								 {#> style="background-color:#a0a0a0!important" <#} 
						 } 
							 #>
							>                            
						<td class="GridViewLabItemStyle"  style="width:30px;">
						 <#=j+1#></td>      
																	 
						<td class="GridViewLabItemStyle" id="td4" ><#=objRow.UHID#></td>
                            <td class="GridViewLabItemStyle" id="tdLabNo" ><#=objRow.LabNo#></td>
						<td class="GridViewLabItemStyle" id="td5" ><#=objRow.PName#></td> 
						<td class="GridViewLabItemStyle" id="td6" ><#=objRow.Age#></td>
						<td class="GridViewLabItemStyle" id="td7" ><#=objRow.Mobile#></td>
						<td class="GridViewLabItemStyle" id="td8" ><#=objRow.subcategoryName#></td>                      
						<td class="GridViewLabItemStyle" id="td9" ><#=objRow.TestName#></td>                      
						<td class="GridViewLabItemStyle" id="td10" ><#=objRow.TokenNo#></td>
                        <td class="GridViewLabItemStyle" id="td17" ><#=objRow.TokenRoomName#></td>                      
						<td class="GridViewLabItemStyle" id="td11" ><#=objRow.BookingDate#></td>                    
						<td class="GridViewLabItemStyle" id="td12" ><#=objRow.BookingTime#></td>
                        <td class="GridViewLabItemStyle" id="td19" ><#=objRow.BookingFrom#></td>
                       <td class="GridViewLabItemStyle" style="text-align:center; " id="td13" >

							  <input type="button" value="Reschedule" class="ItDoseButton" onclick="$rescheduleRadioAppointment(this)" id="btnRadioReschedule"
								  <#if(objRow.IsDeptReceive=='1'){#> disabled="disabled" <#}#>  />

						     </td>          
                             <td class="GridViewLabItemStyle" style="text-align:center;display:none" id="td20" >
                                 <input type="checkbox" id="chkReschedule" class="Reschedule" onchange ="ValidateSinglePatient(this);"  
                                     <#if(objRow.IsDeptReceive=='1'){#> 
                                      disabled="disabled" <#} #>      />
                             </td>   
						<td class="GridViewLabItemStyle" id="td14" style="width:30px;text-align:center;display:none"><#=objRow.IsReschedule#></td>
						<td class="GridViewLabItemStyle" id="td15" style="width:30px;text-align:center;display:none"><#=objRow.IsDeptReceive#></td>
						<td class="GridViewLabItemStyle" id="td16" style="width:30px;text-align:center;display:none"><#=objRow.IsCancel#></td>
                        <td class="GridViewLabItemStyle" id="tdRSubCategoryID" style="width:30px;text-align:center;display:none"><#=objRow.SubCategoryID#></td>
                        <td class="GridViewLabItemStyle" id="tdRItemID" style="width:30px;text-align:center;display:none"><#=objRow.ItemID#></td>
                        <td class="GridViewLabItemStyle" id="tdRBookingID" style="width:30px;text-align:center;display:none"><#=objRow.BookingID#></td>
                        <td class="GridViewLabItemStyle" id="tdRisOnlineBooking" style="width:30px;text-align:center;display:none"><#=objRow.isOnlineBooking#></td>
                               

							  </tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
   </script>
    <%--End--%>

    <%--start Doctor Appointment Modal--%>
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
                            <cc1:CalendarExtender ID="calendarExteAppointmentSlotDate" TargetControlID="txtAppointmentSlotDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                            <span id="spnModalAppID" style="display:none">0</span>
                            <span id="spnisSlotWiseToken" style="display:none">0</span>
                            <span id="spnModalDoctorID" style="display:none">0</span>
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
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Avilable</b>
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
    <%--END--%>
</asp:Content>


