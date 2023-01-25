<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BookDirectAppointment.aspx.cs" Inherits="Design_OPD_BookDirectAppointment" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="OldPatientSearchControl" TagPrefix="UC1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style type="text/css">
        .slotDetails {
            height: 440px !important;
            overflow: auto !important;
        }
		.circle {
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
		
    </style>


    <script type="text/javascript">
        $(document).ready(function () {
            //$.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
            $getHashCode(function () {
                $bindMandatory(function (response) {
                    $patientControlInit(function () {
                        $bindVisitType(function () {
                            $bindTypeOfAppointments(function () {
                                $bindPurPoseOfVisit(function () {
                                    $panelControlInit(function () {
                                        $paymentControlInit(function () {

                                            //for Reshedule Appointment

                                            var appointmentID = '<%=Util.GetString(Request.QueryString["Appointment_Id"])%>';
                                            if (!String.isNullOrEmpty(appointmentID)) {
                                                $getBookedAppointmentDetails(appointmentID, function (response) {
                                                    $bindPatientDetails(response, function () {
                                                        $bindAppointmentDetails(response, function () {
                                                            $('#pageTitle').val('Reschedule Appointment');
                                                            $('#btnSave').val('Update');
                                                        });
                                                    });
                                                });
                                            }


                                            //for Book Appointment From help Desk
                                            var isHelpDeskBooking = Number('<%=Util.GetString(Request.QueryString["helpDeskBooking"])%>');
                                            if (isHelpDeskBooking == 1)
                                                bindAppointmentFromPreSlotDefine();
                                            if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1')
                                                $bindRegistrationCharges(function () { });
                                            //$.unblockUI();

                                            //For Direct Searching By Mobile No.
                                            var MobileNo = Number('<%=Util.GetString(Request.QueryString["MobileNo"])%>');
                                            if (MobileNo != "") {
                                                $('#txtMobile').val(MobileNo);
                                                patientSearchOnpageload($('#txtMobile').val());
                                            }
                                        });
                                    });
                                });
                            });
                        });
                    });

                    $('#ddlSolotMin').change(function (e) {
                        var $appointmentDate = (e.target.type == 'text' ? e.target.value : $('#txtAppointmentOn').val());
                        $validateAppointmenSlotData($appointmentDate, false,1, function (data) {
                            $getDoctorAppointmentTimeSlot(data.appointmentDate, data.doctorId,data.isManualSlot, false, function (response) {
                                getPatientBasicDetails(function (patientDetails) {
                                    $('#txtAppointmentSlotDate,#txtAppointmentOn').val(response)
                                    $getDoctorAppointmentCharges({ DoctorID: data.doctorId, referenceCodeOPD: data.referenceCodeOPD, SubCategoryID: data.subCategoryID, panelCurrencyFactor: patientDetails.panelCurrencyFactor }, function (response) {
                                        var $responseData = JSON.parse(response);
                                        if ($responseData.length > 0) {
                                            $getDiscountWithCoPay({ itemID: $responseData[0].ItemID, panelID: patientDetails.panelID, patientTypeID: patientDetails.patientTypeID, memberShipCardNo: patientDetails.memberShipCardNo }, function (discountCoPayment) {
                                                $('#lblRateListID').text($responseData[0].ID);
                                                $('#lblItemId').text($responseData[0].ItemID);
                                                $('#lblScheduleChargeID').text($responseData[0].ScheduleChargeID);
                                                $('#lblItem').text($responseData[0].Item);
                                                $('#lblItemCode').text($responseData[0].ItemCode);
                                                $('#lblIsPanelWiseDiscount').text(discountCoPayment.OPDPanelDiscPercent > 0 ? 1 : 0);
                                                $('#lblCoPaymentPercent').text(discountCoPayment.OPDCoPayPercent);
                                                $('#lblDiscountPercent').text(discountCoPayment.OPDPanelDiscPercent);
                                                $('#lblIsPayable').text(discountCoPayment.IsPayble);
                                                $('#txtAppointmentCharges').val($responseData[0].Rate).change();
                                            });

                                        }
                                        else {
                                            modelAlert('Doctor Fees Not Set');
                                            $('#txtAppointmentCharges').val('').change();
                                        }
                                    });
                                });
                            });
                        });
                        getAppointmentLastVisitDetails({ appointmentDate: $appointmentDate }, function () { });
                    });
                    $('#ddlDoctor,#txtAppointmentOn,#txtAppointmentSlotDate,#ddlAppointmentType,#ddlPanelCompany,#ddlTypeOfApp').change(function (e) {
                        var $appointmentDate = (e.target.type == 'text' ? e.target.value : $('#txtAppointmentOn').val());
                        $validateAppointmenSlotData($appointmentDate, false,0, function (data) {
                            $getDoctorAppointmentTimeSlot(data.appointmentDate, data.doctorId, data.isManualSlot, false, function (response) {
                                getPatientBasicDetails(function (patientDetails) {
                                    $('#txtAppointmentSlotDate,#txtAppointmentOn').val(response)
                                    $getDoctorAppointmentCharges({ DoctorID: data.doctorId, referenceCodeOPD: data.referenceCodeOPD, SubCategoryID: data.subCategoryID, panelCurrencyFactor: patientDetails.panelCurrencyFactor }, function (response) {
                                        var $responseData = JSON.parse(response);
                                        if ($responseData.length > 0) {
                                            $getDiscountWithCoPay({ itemID: $responseData[0].ItemID, panelID: patientDetails.panelID, patientTypeID: patientDetails.patientTypeID, memberShipCardNo: patientDetails.memberShipCardNo }, function (discountCoPayment) {
                                                $('#lblRateListID').text($responseData[0].ID);
                                                $('#lblItemId').text($responseData[0].ItemID);
                                                $('#lblScheduleChargeID').text($responseData[0].ScheduleChargeID);
                                                $('#lblItem').text($responseData[0].Item);
                                                $('#lblItemCode').text($responseData[0].ItemCode);
                                                $('#lblIsPanelWiseDiscount').text(discountCoPayment.OPDPanelDiscPercent > 0 ? 1 : 0);
                                                $('#lblCoPaymentPercent').text(discountCoPayment.OPDCoPayPercent);
                                                $('#lblDiscountPercent').text(discountCoPayment.OPDPanelDiscPercent);
                                                $('#lblIsPayable').text(discountCoPayment.IsPayble);
                                                $('#txtAppointmentCharges').val($responseData[0].Rate).change();
                                            });

                                        }
                                        else {
                                            modelAlert('Doctor Fees Not Set', function () {
                                                //clearAppointMentDetails();
                                            });
                                            $('#txtAppointmentCharges').val('').change();
                                        }
                                    });
                                });
                            });
                        });
                        getAppointmentLastVisitDetails({ appointmentDate: $appointmentDate }, function () { });
                    });

                    $('#btnAvailability').click(function () {
                        var $appointmentDate = $('#txtAppointmentOn').val();
                        $validateAppointmenSlotData($appointmentDate, true,0, function (data) {
                            $getDoctorAppointmentTimeSlot(data.appointmentDate, data.doctorId, data.isManualSlot, true, function (response) {
                                getPatientBasicDetails(function (patientDetails) {
                                    $('#txtAppointmentSlotDate,#txtAppointmentOn').val(response);
                                    $getDoctorAppointmentCharges({ DoctorID: data.doctorId, referenceCodeOPD: data.referenceCodeOPD, SubCategoryID: data.subCategoryID, panelCurrencyFactor: patientDetails.panelCurrencyFactor }, function (response) {
                                        var $responseData = JSON.parse(response);
                                        if ($responseData.length > 0) {
                                            $('#lblRateListID').text($responseData[0].ID);
                                            $('#lblItemId').text($responseData[0].ItemID);
                                            $('#lblScheduleChargeID').text($responseData[0].ScheduleChargeID);
                                            $('#lblItem').text($responseData[0].Item);
                                            $('#lblItemCode').text($responseData[0].ItemCode);
                                            $('#txtAppointmentCharges').val($responseData[0].Rate).change();
                                        }
                                        else {
                                            modelAlert('Doctor Fees Not Set');
                                            $('#txtAppointmentCharges').val('').change();
                                        }
                                    });
                                });
                            });
                        });
                    });
                });
            });

        });



        var bindAppointmentFromPreSlotDefine = function () {
            var doctorID = '<%=Util.GetString(Request.QueryString["doctorId"])%>';
            var appointmentDate = '<%=Util.GetString(Request.QueryString["appDate"])%>';
            var shiftStartTime = '<%=Util.GetString(Request.QueryString["startTime"])%>';
            var shiftEndTime = '<%=Util.GetString(Request.QueryString["endTime"])%>';
            var centreID = '<%=Util.GetString(Request.QueryString["centreId"])%>';
            var preDefinedSlotValue = '<%=Util.GetString(Request.QueryString["preDefinedSlot"])%>';
            var data = {
                doctorID: doctorID,
                appointmentDate: appointmentDate,
                startTime: shiftStartTime,
                endTime: shiftEndTime,
                centreId: centreID,
                preDefinedSlot: preDefinedSlotValue,
            }
            getAvilableSlotFromShift(data, function (res) {
                var _temp = {
                    PurposeOfVisitID: '0',
                    SubcategoryID: '<%=Resources.Resource.FirstVisitSubCategoryID%>',
                    appointmentType: 'Phone',
                    Time: res.split('-')[0],
                    EndTime: res.split('-')[1],
                    Amount: 0,
                    Date: appointmentDate
                }

                $bindAppointmentDetails(_temp, function () {
                    $('#ddlAppointmentType').change();
                });
            });
        }

        var getAvilableSlotFromShift = function (data, callback) {
            serverCall('BookDirectAppointment.aspx/GetDefaultAvilableSlot', data, function (response) {
                callback(response)
            });
        }





        $bindAppointmentDetails = function (appointmentDetails, callback) {
            $('#ddlPurposeofVisit').val(appointmentDetails.PurposeOfVisitID);
            $('#ddlTypeOfApp option').filter(function () { return this.text == appointmentDetails.appointmentType })[0].selected = true;
            $('#ddlAppointmentType').val(appointmentDetails.SubcategoryID);
            $('#txtAppointmentTime').val(appointmentDetails.Time + '-' + appointmentDetails.EndTime);
            $('#txtAppointmentOn').val(appointmentDetails.Date);
            $('#txtAppointmentCharges').val(appointmentDetails.Amount);

            if (!String.isNullOrEmpty(appointmentDetails.RateListID))
                $('#lblRateListID').text(appointmentDetails.RateListID);

            $('#ddlTypeOfApp').attr('disabled', true).change();
            callback(true);

        }
        var $bindMandatory = function (callback) {
            var manadatory = [
                { control: '#ddlTitle', isRequired: true, erroMessage: 'Please Select Title', tabIndex: 1, isSearchAble: false },
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPLastName', isRequired: true, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
		{ control: '#txtDOB', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                //{ control: '#txtAge', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                //{ control: '#ddlMarried', erroMessage: 'Select Marital Status', tabIndex: 3, isSearchAble: false },
                { control: '#txtMobile', isRequired: true, erroMessage: 'Enter Mobile Number', tabIndex: 4, isSearchAble: false },
              //  { control: '#txtIDProofNo', isRequired: true, erroMessage: 'Enter NIC No.', tabIndex: 4, isSearchAble: false },
                 { control: '#txtAddress', isRequired: false, erroMessage: 'Enter Address', tabIndex: 5, isSearchAble: false },
                //{ control: '#txtRelationName', isRequired: true, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },
               // { control: '#ddlCountry', isRequired: true, erroMessage: 'Please Select Country', tabIndex: 6, isSearchAble: true },
               // { control: '#ddlDistrict', isRequired: true, erroMessage: 'Please Select DIstrict', tabIndex: 7, isSearchAble: true },
               // { control: '#ddlCity', isRequired: true, erroMessage: 'Please Select City', tabIndex: 8, isSearchAble: true },
                { control: '#ddlDoctor', isRequired: true, erroMessage: 'Please Select Doctor', tabIndex: 9, isSearchAble: true },
                { control: '#ddlAppointmentType', isRequired: true, erroMessage: 'Please Select Visit Type', tabIndex: 10, isSearchAble: false },
                { control: '#ddlTypeOfApp', isRequired: true, erroMessage: 'Please Select Type of AppointMent', tabIndex: 11, isSearchAble: false },
                //{ control: '#ddlPurposeofVisit',isRequired:true, erroMessage: 'Please Select Purpose OF Visit', tabIndex: 9, isSearchAble: false },
                { control: '#txtAppointmentOn', isRequired: true, erroMessage: 'Please Enter AppointMent Date', tabIndex: 12, isSearchAble: false },
                { control: '#txtAppointmentTime', isRequired: true, erroMessage: 'Please Enter AppointMent Time', tabIndex: 13, isSearchAble: false },
                //{ control: '#txtAppointmentCharges', isRequired: true, erroMessage: 'Please Enter AppointMent Charges', tabIndex: 12, isSearchAble: false }
            ];
            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                $(manadatory[0].control).focus();
            });
            callback(true);
        }



        var $getDoctorAppointmentTimeSlot = function (appointmentDate, doctorID, isManualSlot, isModelShow, callback) {
            var centreID = '<%= HttpContext.Current.Session["CentreID"]%>'
            var appSlotMin = $('#ddlSolotMin').val();
            serverCall('BookDirectAppointment.aspx/GetDoctorAppointmentTimeSlotConsecutive', { DoctorId: doctorID, _appointmentDate: appointmentDate, appointmentType: $('#ddlTypeOfApp').val(), centreId: centreID, AppSlot: appSlotMin, IsManualSlot: isManualSlot }, function (response) {

                var responseData = JSON.parse(response);

                var divSlotAvailabilityBody = $('#divSlotAvailabilityBody').find('.slotDetails');
                var divSlotAvailabilityHead = $('#divSlotAvailabilityBody').find('.patientInfo');
                for (var i = 0; i < responseData.response.length; i++) {
                    $(divSlotAvailabilityHead[i]).text(responseData.response[i].appointmentDate);
                    $(divSlotAvailabilityBody[i]).html(responseData.response[i].response);
                }

                $('#txtAppointmentSlotDate').val(responseData.response[0].appointmentDate);
                $('#ddlSlotDoctors').val($('#ddlDoctor').val()).trigger('chosen:updated');
                var $responseData = responseData.response[0];
                if (true) {

                    var txtAppointmentTime = $('#txtAppointmentTime');
                    String.isNullOrEmpty($(txtAppointmentTime).val()) ? ($(txtAppointmentTime).val($responseData.defaultAvilableSlot)) : '';


                    //var currentAppointmentTime = $('#txtAppointmentTime').val();
                    $('#divSlotAvailabilityBody div #spnAppointmentTime').each(function (index, elem) {
                        if ($.trim($(elem).text()) == $responseData.defaultAvilableSlot) {
                            var currentAppointmentDate = $(elem).closest('.col-md-5').find('.patientInfo').text();
                            var defaultAppointmentDate = $('#txtAppointmentOn').val();
                            if (defaultAppointmentDate == currentAppointmentDate)
                                $(elem).parent().addClass('badge-pink');
                        }
                    });
                    if (isModelShow)
                        $('#divSlotAvailability').showModel();

                    MarcTooltips.add('div .badge-avilable', 'Double Click To Select', {
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
        };


        var clearAppointMentDetails = function (isModelShow) {
		if(!isModelShow){
            $('#divSlotAvailabilityBody').find('.slotDetails').html('');
            $('#divSlotAvailabilityBody').find('.patientInfo').html('');
			}
            $('#txtAppointmentTime,#txtAppointmentCharges').val('').change();
            $('#lblRateListID,#lblItemId,#lblScheduleChargeID,#lblItem,#lblItemCode').text('');
        }
        var $selectSlot = function (elem) {
            $('#divSlotAvailabilityBody .circle').removeClass('badge-pink');
            $(elem).addClass('badge-pink');
        }

        var $dobuleClick = function (elem) {
            $('#txtAppointmentTime').val($.trim($(elem).find('#spnAppointmentTime').text()));
            $('#txtAppointmentOn').val($(elem).closest('.slotDetails').prev().text());
            $('#divSlotAvailability').closeModel();
        }

        var onPanelCurrencyFactorChange = function (callback) {
            $.when($('#txtAppointmentCharges').val('').change()).then(function () {
                callback();
            });
        }

        var $getAppointMentDetails = function (callback) {
            var inValidElem = null;
            if ($('#ddlTypeOfApp').val() == "4" && $('#txtAppointmentTime').val() == "") {
                $('#txtAppointmentTime').removeClass('requiredField');
                $('#txtAppointmentTime').val("00:00:00-00:00:00");
            }
            $('#divAppointmentDetails .requiredField').each(function (index, elem) {
                if (String.isNullOrEmpty(elem.value) || elem.value == '0') {
                    inValidElem = elem;
                    modelAlert(this.attributes['errorMessage'].value, function () {
                        inValidElem.focus();
                    });
                    return false;
                }
            });
            var SubCategoryID = $.trim($('#ddlAppointmentType').val());
            var appointmentCharges = Number($('#txtAppointmentCharges').val());
            //if (SubCategoryID != 'LSHHI49') {
            //	if (appointmentCharges <= 0) {
            //		inValidElem = SubCategoryID;
            //		modelAlert('Please Enter AppointMent Charges');
            //	}
            //}




            if (String.isNullOrEmpty(inValidElem)) {
                var response = {};
                response.PurposeOfVisit = $('#ddlPurposeofVisit option:selected').text(),
                response.PurposeOfVisitID = $('#ddlPurposeofVisit').val(),
                response.TypeOfApp = $('#ddlTypeOfApp').val(),
                response.VisitType = $('#dlVisitType option:selected').text(),
                response.Date = $('#txtAppointmentOn').val(),
                response.SelectTime = $('#txtAppointmentTime').val().replace('-', '#'),
                response.Notes = '',
                response.Amount = Number($('#txtAppointmentCharges').val()),
                response.SubCategoryID = SubCategoryID;
                response.chkApp = false,
                response.hashCode = $('#spnHashCode').text(),
                response.RateListID = $('#lblRateListID').text();
                response.ItemID = $('#lblItemId').text();
                response.ScheduleChargeID = $('#lblScheduleChargeID').text();
                response.Item = $('#lblItem').text();
                response.rateItemCode = $('#lblItemCode').text();
                response.discountPercent = parseInt($('#lblDiscountPercent').text().trim());
                response.discountPercent = isNaN(response.discountPercent) ? 0 : response.discountPercent;
                response.discountAmount = $('#lblDiscountAmount').text().trim();
                response.IsPayable = $('#lblIsPayable').text().trim();
                response.CoPayPercent = $('#lblCoPaymentPercent').text().trim();
                response.IsPanelWiseDiscount = response.discountPercent > 0 ? 1 : 0;
                response.mobileAppAppointmentID = $('#txtAppointmentTime').attr('mobileAppointmentID');



                $tbVitalSignTrs = $('#tb_VitalSign tbody tr').clone();
                var VitalSignitems = $($tbVitalSignTrs);
                var IsVitalSignOnApp = 0;
                response.BP = VitalSignitems.closest("tr").find('#SpnBP').text();
                response.Pulse = VitalSignitems.closest("tr").find('#SpnPulse').text();
                response.Resp = VitalSignitems.closest("tr").find('#SpnResp').text();
                response.Temp = VitalSignitems.closest("tr").find('#SpnTemp').text();
                response.Height = VitalSignitems.closest("tr").find('#SpnHT').text();
                response.Weight = VitalSignitems.closest("tr").find('#SpnWT').text();
                response.ArmSpan = VitalSignitems.closest("tr").find('#SpnArmSpan').text();
                response.SittingHeight = Number(VitalSignitems.closest("tr").find('#SpnSittingHeight').text()).toFixed(2);
                response.BMI = Number($("#txtBMI").val()).toFixed(2);
                response.IBW = Number(VitalSignitems.closest("tr").find('#SpnIBW').text()).toFixed(2);
                response.SPO2 = Number(VitalSignitems.closest("tr").find('#SpnSPO2').text()).toFixed(2);
                if ($('#tb_VitalSign tbody tr').length > 0)
                    response.IsVitalSignOnApp = 1;
                else
                    response.IsVitalSignOnApp = 0;
                callback(response);
            }
        }



        var $getIndirectAppointmentDetails = function (callback) {
            $getPatientDetails(function (patientDetails) {
                $getAppointMentDetails(function (appointmentDetails) {
                    $appointmentDetails = {
                        PatientID: patientDetails.PatientID,
                        IsNewPatient: patientDetails.IsNewPatient,
                        OldPatientID: patientDetails.OldPatientID,
                        Title: patientDetails.Title.value,
                        PFirstName: patientDetails.PFirstName,
                        PLastName: patientDetails.PLastName,
                        PName: patientDetails.PName,
                        Age: patientDetails.Age,
                        Sex: patientDetails.Gender,
                        PanelID: patientDetails.PanelID,
                        MaritalStatus: patientDetails.MaritalStatus.text,
                        ContactNo: patientDetails.Mobile,
                        Email: patientDetails.Email,
                        Relation: patientDetails.Relation.text,
                        RelationName: patientDetails.RelationName,
                        House_No: patientDetails.House_No,
                        Nationality: patientDetails.Country.text,
                        Country: patientDetails.Country.text,
                        StateID: patientDetails.State.value,
                        District: patientDetails.District.text,
                        City: patientDetails.City.text,
                        Taluka: patientDetails.Taluka.text,
                        CountryID: patientDetails.Country.value,
                        DistrictID: patientDetails.District.value,
                        CityID: patientDetails.City.value,
                        TalukaID: '0',// patientDetails.Taluka.value,
                        Place: patientDetails.Place,
                        LandMark: patientDetails.LandMark,
                        AdharCardNo: patientDetails.AdharCardNo,
                        HospPatientType: patientDetails.HospPatientType.text,
                        PatientType: patientDetails.PatientType.text,
                        isCapTure: patientDetails.isCapTure,
                        base64PatientProfilePic: patientDetails.base64PatientProfilePic,
                        DoctorID: patientDetails.Doctor.value,
                        Doctor_Name: patientDetails.Doctor.text,
                        Address: patientDetails.Address,
                        PurposeOfVisit: appointmentDetails.PurposeOfVisit,
                        PurposeOfVisitID: appointmentDetails.PurposeOfVisitID,
                        TypeOfApp: appointmentDetails.TypeOfApp,
                        VisitType: appointmentDetails.VisitType,
                        Date: appointmentDetails.Date,
                        SelectTime: appointmentDetails.SelectTime,
                        Notes: appointmentDetails.Notes,
                        Amount: appointmentDetails.Amount,
                        SubCategoryID: appointmentDetails.SubCategoryID,
                        chkApp: appointmentDetails.chkApp,
                        hashCode: appointmentDetails.hashCode,
                        RateListID: appointmentDetails.RateListID,
                        ItemID: appointmentDetails.ItemID,
                        PlaceOfBirth: patientDetails.placeOfBirth,
                        IsInternational: patientDetails.isInternational.value,
                        OverSeaNumber: patientDetails.overSeaNumber,
                        EthenicGroup: patientDetails.ethenicGroup.text,
                        LanguageSpoken: patientDetails.languageSpoken.text,
                        occupation: patientDetails.occupation,
                        identificationMark: patientDetails.identificationMark,
                        IsTranslatorRequired: patientDetails.isTranslatorRequired.value,
                        FacialStatus: patientDetails.facialStatus.text,
                        Race: patientDetails.race.text,
                        Employement: patientDetails.employement.text,
                        MonthlyIncome: patientDetails.monthlyIncome,
                        ParmanentAddress: patientDetails.parmanentAddress,
                        IdentificationMarkSecond: patientDetails.identificationMarkSecond,
                        EmergencyPhoneNo: patientDetails.emergencyPhoneNo,
                        EmergencyRelationOf: patientDetails.emergencyRelationOf.value,
                        EmergencyRelationName: patientDetails.emergencyRelationName,

                        PhoneSTDCODE: patientDetails.phoneSTDCODE,
                        ResidentialNumber: patientDetails.residentialNumber,
                        ResidentialNumberSTDCODE: patientDetails.residentialNumberSTDCODE,
                        EmergencyFirstName: patientDetails.emergencyFirstName,
                        EmergencySecondName: patientDetails.emergencySecondName,
                        InternationalCountryID: patientDetails.internationalCountry.value,
                        InternationalCountry: patientDetails.internationalCountry.text,
                        InternationalNumber: patientDetails.internationalNumber,
                        Phone: patientDetails.phone,
                        EmergencyAddress: patientDetails.emergencyAddress,
                        DOB:patientDetails.DOB,
                    }
                    callback($appointmentDetails, appointmentDetails.mobileAppAppointmentID);
                });
            });
        }


        var $getCreateVisitDetails = function (callback) {
            $getPatientDetails(function (patientDetails) {
                $getAppointMentDetails(function (appointmentDetails) {
                    $getPaymentDetails(function (paymentDetails) {
                        $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                        $appointment = {
                            Amount: appointmentDetails.Amount,
                            DoctorID: patientDetails.Doctor.value,
                            ItemID: appointmentDetails.ItemID,
                            PanelID: patientDetails.PanelID,
                            PatientType: patientDetails.PatientType.text,
                            PurposeOfVisit: appointmentDetails.PurposeOfVisit,
                            PurposeOfVisitID: appointmentDetails.PurposeOfVisitID,
                            RefDocID: appointmentDetails.ReferedBy,
                            SubCategoryID: appointmentDetails.SubCategoryID,
                            TypeOfApp: appointmentDetails.TypeOfApp,
                            IsVitalSignOnApp: appointmentDetails.IsVitalSignOnApp,
                            SelectTime: appointmentDetails.SelectTime,
                            Place: patientDetails.Place,
                            LandMark: patientDetails.LandMark,
                            Occupation: patientDetails.Occupation,
                            AdharCardNo: patientDetails.AdharCardNo,
                            HospPatientType: patientDetails.HospPatientType.text,
                            PatientType: patientDetails.PatientType.text,
                            isCapTure: patientDetails.isCapTure,
                            base64PatientProfilePic: patientDetails.base64PatientProfilePic,
                            DoctorID: patientDetails.Doctor.value,
                            Doctor_Name: patientDetails.Doctor.text,
                            Address: patientDetails.Address,
                            PurposeOfVisit: appointmentDetails.PurposeOfVisit,
                            PurposeOfVisitID: appointmentDetails.PurposeOfVisitID,
                            TypeOfApp: appointmentDetails.TypeOfApp,
                            VisitType: appointmentDetails.VisitType,
                            Date: appointmentDetails.Date,
                            SelectTime: appointmentDetails.SelectTime,
                            Notes: appointmentDetails.Notes,
                            DOB:patientDetails.DOB,


                            PlaceOfBirth: patientDetails.placeOfBirth,
                            IsInternational: patientDetails.isInternational.value,
                            OverSeaNumber: patientDetails.overSeaNumber,
                            EthenicGroup: patientDetails.ethenicGroup.text,
                            LanguageSpoken: patientDetails.languageSpoken.text,
                            occupation: patientDetails.occupation,
                            identificationMark: patientDetails.identificationMark,
                            IsTranslatorRequired: patientDetails.isTranslatorRequired.value,
                            FacialStatus: patientDetails.facialStatus.text,
                            Race: patientDetails.race.text,
                            Employement: patientDetails.employement.text,
                            MonthlyIncome: patientDetails.monthlyIncome,
                            ParmanentAddress: patientDetails.parmanentAddress,
                            IdentificationMarkSecond: patientDetails.identificationMarkSecond,
                            EmergencyPhoneNo: patientDetails.emergencyPhoneNo,
                            EmergencyRelationOf: patientDetails.emergencyRelationOf.value,
                            EmergencyRelationName: patientDetails.emergencyRelationName,


                            PhoneSTDCODE: patientDetails.phoneSTDCODE,
                            ResidentialNumber: patientDetails.residentialNumber,
                            ResidentialNumberSTDCODE: patientDetails.residentialNumberSTDCODE,
                            EmergencyFirstName: patientDetails.emergencyFirstName,
                            EmergencySecondName: patientDetails.emergencySecondName,
                            InternationalCountryID: patientDetails.internationalCountry.value,
                            InternationalCountry: patientDetails.internationalCountry.text,
                            InternationalNumber: patientDetails.internationalNumber,
                            Phone: patientDetails.phone,
                            EmergencyAddress: patientDetails.emergencyAddress

                        }

                        $vitalSigns = {
                            IsVitalSignOnApp: appointmentDetails.IsVitalSignOnApp,
                            BP: appointmentDetails.BP,
                            Pulse: appointmentDetails.Pulse,
                            Resp: appointmentDetails.Resp,
                            Temp: appointmentDetails.Temp,
                            Height: appointmentDetails.Height,
                            Weight: appointmentDetails.Weight,
                            ArmSpan: appointmentDetails.ArmSpan,
                            SittingHeight: appointmentDetails.SittingHeight,
                            BMI: appointmentDetails.BMI,
                            IBW: appointmentDetails.IBW,
                            SPO2: appointmentDetails.SPO2
                        }
                        $PM = patientDetails.defaultPatientMaster;



                        $PMH = {
                            patient_type: patientDetails.PatientType.text,
                            PanelID: patientDetails.PanelID,
                            DoctorID: patientDetails.Doctor.value,
                            ReferedBy: patientDetails.ReferedBy,
                            ProId: patientDetails.PROID,
                            Type: 'OPD',
                            ParentID: patientDetails.ParentID,
                            HashCode: appointmentDetails.hashCode,
                            Purpose: appointmentDetails.PurposeOfVisit,
                            ScheduleChargeID: appointmentDetails.ScheduleChargeID,
                            PolicyNo: patientDetails.panelDetails.policyNo,
                            PanelIgnoreReason: patientDetails.panelDetails.ignorePolicyReason,
                            ExpiryDate: patientDetails.panelDetails.expireDate,
                            EmployeeDependentName: patientDetails.panelDetails.nameOnCard,
                            CardNo: patientDetails.panelDetails.cardNo,
                            CardHolderName: patientDetails.panelDetails.nameOnCard,
                            //DependentRelation: patientDetails.panelDetails.cardHolderRelation,
                            RelationWith_holder: patientDetails.panelDetails.cardHolderRelation,
                            KinRelation: patientDetails.Relation.text,
                            KinName: patientDetails.RelationName,
                            KinPhone: patientDetails.RelationPhoneNo,
                            patientTypeID: patientDetails.PatientType.value,
                            PatientPaybleAmt: paymentDetails.patientPayableAmount,
                            PanelPaybleAmt: paymentDetails.panelPayableAmount,
                            PatientPaidAmt: paymentDetails.patientPaidAmount,
                            PanelPaidAmt: paymentDetails.panelPaidAmount,
                            TypeOfReference: patientDetails.typeOfReference.text
                          
                        }

                        if (String.isNullOrEmpty($PMH.PanelIgnoreReason) && $('#divPanelRequiredDocuments button').length > 0 && patientDetails.panelDocuments <= 0) {
                            modelAlert('Panel Document Required...!!!<br/> Please Upload');
                            return false;
                        }
                        callback({ Appointment: [$appointment], PM: [$PM], PMH: [$PMH], patientDocuments: patientDetails.patientDocuments, lastVisitID: patientDetails.visitID, panelDocuments: patientDetails.panelDocuments });
                    });
                });
            });
        };





            var $getDirectAppointmentDetails = function (callback) {
                $getPatientDetails(function (patientDetails) {
                    $getAppointMentDetails(function (appointmentDetails) {
                        $getPaymentDetails(function (paymentDetails) {
                            $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                            $appointment = {
                                Amount: appointmentDetails.Amount,
                                DoctorID: patientDetails.Doctor.value,
                                ItemID: appointmentDetails.ItemID,
                                PanelID: patientDetails.PanelID,
                                PatientType: patientDetails.PatientType.text,
                                PurposeOfVisit: appointmentDetails.PurposeOfVisit,
                                PurposeOfVisitID: appointmentDetails.PurposeOfVisitID,
                                RefDocID: appointmentDetails.ReferedBy,
                                SubCategoryID: appointmentDetails.SubCategoryID,
                                TypeOfApp: appointmentDetails.TypeOfApp,
                                IsVitalSignOnApp: appointmentDetails.IsVitalSignOnApp,
                                Place: patientDetails.Place,
                                LandMark: patientDetails.LandMark,
                                Occupation: patientDetails.Occupation,
                                AdharCardNo: patientDetails.AdharCardNo,
                                HospPatientType: patientDetails.HospPatientType.text,
                                PatientType: patientDetails.PatientType.text,
                                isCapTure: patientDetails.isCapTure,
                                base64PatientProfilePic: patientDetails.base64PatientProfilePic,
                                DoctorID: patientDetails.Doctor.value,
                                Doctor_Name: patientDetails.Doctor.text,
                                Address: patientDetails.Address,
                                PurposeOfVisit: appointmentDetails.PurposeOfVisit,
                                PurposeOfVisitID: appointmentDetails.PurposeOfVisitID,
                                TypeOfApp: appointmentDetails.TypeOfApp,
                                VisitType: appointmentDetails.VisitType,
                                Date: appointmentDetails.Date,
                                SelectTime: appointmentDetails.SelectTime,
                                Notes: appointmentDetails.Notes,
                                PlaceOfBirth: patientDetails.placeOfBirth,
                                IsInternational: patientDetails.isInternational.value,
                                OverSeaNumber: patientDetails.overSeaNumber,
                                EthenicGroup: patientDetails.ethenicGroup.text,
                                LanguageSpoken: patientDetails.languageSpoken.text,
                                occupation: patientDetails.occupation,
                                identificationMark: patientDetails.identificationMark,
                                IsTranslatorRequired: patientDetails.isTranslatorRequired.value,
                                FacialStatus: patientDetails.facialStatus.text,
                                Race: patientDetails.race.text,
                                Employement: patientDetails.employement.text,
                                MonthlyIncome: patientDetails.monthlyIncome,
                                ParmanentAddress: patientDetails.parmanentAddress,
                                IdentificationMarkSecond: patientDetails.identificationMarkSecond,
                                EmergencyPhoneNo: patientDetails.emergencyPhoneNo,
                                EmergencyRelationOf: patientDetails.emergencyRelationOf.value,
                                EmergencyRelationName: patientDetails.emergencyRelationName,
                                DOB: patientDetails.DOB,

                                PhoneSTDCODE: patientDetails.phoneSTDCODE,
                                ResidentialNumber: patientDetails.residentialNumber,
                                ResidentialNumberSTDCODE: patientDetails.residentialNumberSTDCODE,
                                EmergencyFirstName: patientDetails.emergencyFirstName,
                                EmergencySecondName: patientDetails.emergencySecondName,
                                InternationalCountryID: patientDetails.internationalCountry.value,
                                InternationalCountry: patientDetails.internationalCountry.text,
                                InternationalNumber: patientDetails.internationalNumber,
                                Phone: patientDetails.phone,
                                EmergencyAddress: patientDetails.emergencyAddress
                            }

                            $vitalSigns = {
                                IsVitalSignOnApp: appointmentDetails.IsVitalSignOnApp,
                                BP: appointmentDetails.BP,
                                Pulse: appointmentDetails.Pulse,
                                Resp: appointmentDetails.Resp,
                                Temp: appointmentDetails.Temp,
                                Height: appointmentDetails.Height,
                                Weight: appointmentDetails.Weight,
                                ArmSpan: appointmentDetails.ArmSpan,
                                SittingHeight: appointmentDetails.SittingHeight,
                                BMI: appointmentDetails.BMI,
                                IBW: appointmentDetails.IBW,
                                SPO2: appointmentDetails.SPO2
                            }
                            $PM = patientDetails.defaultPatientMaster;

                            $PMH = {
                                patient_type: patientDetails.PatientType.text,
                                PanelID: patientDetails.PanelID,
                                DoctorID: patientDetails.Doctor.value,
                                ReferedBy: patientDetails.ReferedBy,
                                ProId: patientDetails.PROID,
                                Type: 'OPD',
                                ParentID: patientDetails.ParentID,
                                HashCode: appointmentDetails.hashCode,
                                Purpose: appointmentDetails.PurposeOfVisit,
                                ScheduleChargeID: appointmentDetails.ScheduleChargeID,
                                PolicyNo: patientDetails.panelDetails.policyNo,
                                PanelIgnoreReason: patientDetails.panelDetails.ignorePolicyReason,
                                ExpiryDate: patientDetails.panelDetails.expireDate,
                                EmployeeDependentName: patientDetails.panelDetails.nameOnCard,
                                CardNo: patientDetails.panelDetails.cardNo,
                                CardHolderName: patientDetails.panelDetails.nameOnCard,
                                //DependentRelation: patientDetails.panelDetails.cardHolderRelation,
                                RelationWith_holder: patientDetails.panelDetails.cardHolderRelation,
                                KinRelation: patientDetails.Relation.text,
                                KinName: patientDetails.RelationName,
                                KinPhone: patientDetails.RelationPhoneNo,
                                patientTypeID: patientDetails.PatientType.value,
                                PatientPaybleAmt: paymentDetails.patientPayableAmount,
                                PanelPaybleAmt: paymentDetails.panelPayableAmount,
                                PatientPaidAmt: paymentDetails.patientPaidAmount,
                                PanelPaidAmt: paymentDetails.panelPaidAmount,
                                TypeOfReference: patientDetails.typeOfReference.text,
                                CorporatePanelID:patientDetails.CorporatePanelID
                            }
                            $LT = {
                                PanelID: patientDetails.PanelID,
                                NetAmount: paymentDetails.netAmount,
                                GrossAmount: paymentDetails.billAmount,
                                Rate: appointmentDetails.Amount,
                                Amount: appointmentDetails.Amount,
                                DiscountReason: paymentDetails.discountReason,
                                DiscountApproveBy: paymentDetails.approvedBY,
                                DiscountOnTotal: paymentDetails.discountAmount,
                                RoundOff: paymentDetails.roundOff,
                                GovTaxPer: 0,
                                GovTaxAmount: 0,
                                Adjustment: $isReceipt ? paymentDetails.adjustment : '0',
                            }

                            $LTD = {
                                ItemID: appointmentDetails.ItemID,
                                SubCategoryID: appointmentDetails.SubCategoryID,
                                ItemName: appointmentDetails.Item,
                                DiscountReason: paymentDetails.discountReason,
                                RateListID: appointmentDetails.RateListID,
                                rateItemCode: appointmentDetails.rateItemCode,
                                Rate: appointmentDetails.Amount,
                                Amount: appointmentDetails.Amount - paymentDetails.discountAmount,
                                DiscAmt: paymentDetails.discountAmount,
                                DiscountPercentage: paymentDetails.discountPercent,
                                CoPayPercent: appointmentDetails.CoPayPercent,
                                IsPayable: appointmentDetails.IsPayable,
                                isPanelWiseDisc: appointmentDetails.IsPanelWiseDiscount,
                                panelCurrencyCountryID: patientDetails.panelDetails.panelCurrencyCountryID,
                                panelCurrencyFactor: patientDetails.panelDetails.panelCurrencyFactor,
                            }

                            if (paymentDetails.isCoPaymentOnBill == 1)
                                $LTD.CoPayPercent = paymentDetails.coPaymentPercent;

                            $PaymentDetail = [];
                            $(paymentDetails.paymentDetails).each(function () {
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
                                    PaymentRemarks: paymentDetails.paymentRemarks,
                                    swipeMachine: this.swipeMachine,
                                    currencyRoundOff: paymentDetails.currencyRoundOff / paymentDetails.paymentDetails.length
                                });
                            });

                            var directDiscountOnBill = appointmentDetails.discountPercent > 0 ? false : true;

                            if ($PaymentDetail.length < 1) {
                                modelAlert('Please Select Payment Details');
                                return false;
                            }
							  if (String.isNullOrEmpty($PMH.PanelIgnoreReason) && $('#divPanelRequiredDocuments button').length > 0 && patientDetails.panelDocuments <= 0) {
                                modelAlert('Panel Document Required...!!!<br/> Please Upload');
                                return false;
                            }
							
                            callback({ Appointment: [$appointment], PM: [$PM], PMH: [$PMH], LT: [$LT], LTD: [$LTD], PaymentDetail: $PaymentDetail, patientDocuments: patientDetails.patientDocuments, vitalSigns: $vitalSigns, directDiscountOnBill: directDiscountOnBill, mobileAppAppointmentID: appointmentDetails.mobileAppAppointmentID, lastVisitID: patientDetails.visitID, panelDocuments: patientDetails.panelDocuments });
                        });
                    });
                });
            };



                var $appointmentTypeChange = function (appointmentType) {
                    if (appointmentType == '100') {
                        $getCurentDate(function (response) {
                            $('#txtAppointmentOn').val(response).attr('disabled', false);
                            $('#btnAvailability').attr('disabled', false);
                            $clearPaymentControl(function () {
                                $('#paymentControlDiv').slideDown();
                                $('#txtAppointmentCharges').change();
                            });
                        });
                    }
                    else {
                        $('#txtAppointmentOn,#btnAvailability').removeAttr('disabled');
                        $('#paymentControlDiv').slideUp();
                    }
                }

                var $getCurentDate = function (callback) {
                    serverCall('../common/CommonService.asmx/getDate', {}, function (response) {
                        callback(response);
                    });
                }


                var $getDoctorAppointmentCharges = function (data, callback) {
                    serverCall('../common/CommonService.asmx/Loadrate', data, function (response) {
                        callback(response);
                    });
                }

                var $bindVisitType = function (callback) {
                    serverCall('../common/CommonService.asmx/bindAppVisitType', {}, function (response) {
                        $ddlAppointmentType = $('#ddlAppointmentType');
                        $ddlAppointmentType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name' });
                        callback($ddlAppointmentType.val());
                    });
                }


                var $bindTypeOfAppointments = function (callback) {
                    serverCall('../common/CommonService.asmx/bindTypeOfApp', {}, function (response) {
                        $ddlTypeOfApp = $('#ddlTypeOfApp');
                        $ddlTypeOfApp.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'AppointmentTypeID', textField: 'AppointmentType', selectedValue: 4 });
                        callback($ddlTypeOfApp.val());
                    });
                }

                var $bindPurPoseOfVisit = function (callback) {
                    serverCall('../common/CommonService.asmx/bindComplaint', {}, function (response) {
                        $ddlPurposeofVisit = $('#ddlPurposeofVisit');
                        $ddlPurposeofVisit.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Complain_id', textField: 'Complain', isSearchable: true });
                        callback($ddlPurposeofVisit.val());
                    });
                }

                var $getHashCode = function (callback) {
                    serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
                        $('#spnHashCode').text(response);
                        callback(true);
                    });
                }

                var $validateAppointmenSlotData = function (appointmentDate, isAlertError,isManualSlot, callback) {
                    $data = {
                        appointmentDate: $.trim(appointmentDate),
                        doctorId: $.trim($('#ddlDoctor').val()),
                        referenceCodeOPD: $.trim($('#ddlPanelCompany').val().split('#')[1]),
                        subCategoryID: $.trim($('#ddlAppointmentType').val()),
                        isManualSlot: isManualSlot
                    }

                    if (String.isNullOrEmpty($data.appointmentDate)) {
                        clearAppointMentDetails();
                        if (isAlertError)
                            modelAlert('Select Appointment Date');
                        return;
                    }
                    if ($data.doctorId == '0') {
                        clearAppointMentDetails();
                        if (isAlertError)
                            modelAlert('Select Doctor Name');
                        return;
                    }
                    if (String.isNullOrEmpty($data.referenceCodeOPD)) {
                        clearAppointMentDetails();
                        if (isAlertError)
                            modelAlert('Select Panel');
                        return;
                    }
                    if ($data.subCategoryID == '0') {
                        clearAppointMentDetails();
                        if (isAlertError)
                            modelAlert('Select  Visit Type');
                        return;
                    }
                    callback($data);
                }

                var $onAppointmentChargesChange = function (billAmount, appointmentType) {
                    if (isNaN(parseInt(billAmount)))
                        $clearPaymentControl(function () { });
                    else {
                        if (appointmentType == '2') {
                            var totalDiscountAmount = 0;
                            var panelNonPayableAmount = 0;
                            getPatientBasicDetails(function (patientDetails) {
                                $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                                $getRegistrationCharges(function (registrationDetails) {
                                    var registrationCharge = registrationDetails.registrationCharge;
                                    var totalBillAmount = parseFloat(billAmount) + parseFloat(registrationCharge);

                                    $isPayable = Number($('#lblIsPayable').text());


                                    if ($isPayable == 0) {
                                        $coPaymentPercent = Number($('#lblCoPaymentPercent').text());


                                        if ($coPaymentPercent > 0)
                                            panelNonPayableAmount = panelNonPayableAmount + ((billAmount * $coPaymentPercent) / 100);
                                    }
                                    else if ($isPayable == 1)
                                        panelNonPayableAmount = panelNonPayableAmount + billAmount;

                                    $discountPrecent = Number($('#lblDiscountPercent').text());


                                    if ($discountPrecent > 0)
                                        totalDiscountAmount = ((billAmount * $discountPrecent) / 100);

                                    $('#lblDiscountAmount').text(Number(totalDiscountAmount));

                                    var IsDiscountAuthorization = '<%=Util.GetInt(ViewState["IsDiscount"])%>';

                                    $addBillAmount({
                                        panelId: patientDetails.panelID,
                                        billAmount: totalBillAmount,
                                        disCountAmount: totalDiscountAmount,
                                        isReceipt: $isReceipt,
                                        patientAdvanceAmount: patientDetails.patientAdvanceAmount,
                                        minimumPayableAmount: panelNonPayableAmount,
                                        disableDiscount: IsDiscountAuthorization == '0' ? true : false,
                                        panelAdvanceAmount: patientDetails.panelAdvanceAmount,
                                        refund: { status: false }
                                    }, function () { });
                                });
                            });
                        }
                    }
                };


                $addNewVisitTypeModel = function () {
                    $('#txtComplaintName').val('')
                    $('#divAddComplaint').showModel();
                }


                $savePurposeOfVisit = function (visitDetails) {
                    if (!String.isNullOrEmpty(visitDetails.CName.trim())) {
                        serverCall('../Common/CommonService.asmx/Complaint', { CName: visitDetails.CName }, function (response) {
                            $responseData = parseInt(response);
                            if ($responseData == '0')
                                modelAlert('Purpose of Visit Already Exist');
                            else {
                                $('#divAddComplaint').closeModel();
                                modelAlert('Purpose of Visit Saved Successfully', function (response) {
                                    $bindPurPoseOfVisit(function (response) { });
                                });
                            }
                        });
                    }
                    else
                        modelAlert('Please Enter Visit Type');
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

                var $saveAppointment = function (btnSave, appointmentType) {
                    var appointmentType = Number(appointmentType);
                    if (btnSave.value == 'Save') {
                        if (appointmentType == 2) {
                            if ('<%=Resources.Resource.IsVitalSignOnApp%>' == 1) {
                                var CanViewVitalPopUp = '<%=Util.GetInt(ViewState["CanViewVitalPopUp"])%>';
                                if (CanViewVitalPopUp == "1")
                                    $showVitalSignModel();
                                else
                                    $closeVitalSignModel();
                            }
                            else
                                $closeVitalSignModel();
                        }
                        else if (appointmentType == 4) {

                            $getCreateVisitDetails(function (data) {

                                $(btnSave).attr('disabled', true).val('Submitting...');
                                serverCall('Services/PatientVisitRegistration.asmx/CreateAppointment', data, function (response) {
                                    var $responseData = JSON.parse(response);
                                    modelAlert($responseData.response, function () {
                                        if ($responseData.status)
                                            window.location.reload();
                                        else
                                            $(btnSave).removeAttr('disabled').val('Save');
                                    });
                                });
                            });
                        }
                        else {
                            $getIndirectAppointmentDetails(function (appointmentData, mobileAppAppointmentID) {
                                $(btnSave).attr('disabled', true).val('Submitting...');
                                var centreID = '<%=Util.GetString(HttpContext.Current.Session["CentreID"].ToString())%>'
                                var isHelpDeskBooking = Number('<%=Util.GetString(Request.QueryString["helpDeskBooking"])%>');
                                if (isHelpDeskBooking == 1)
                                    centreID = '<%=Util.GetString(Request.QueryString["centreId"])%>'
                                serverCall('Services/AppointmentNew.asmx/SaveApp', { Data: [appointmentData], mobileAppAppointmentID: mobileAppAppointmentID, centreID: centreID }, function (response) {
                                    var $responseData = JSON.parse(response);
                                    modelAlert($responseData.response, function () {
                                        if ($responseData.status) {
                                            if (isHelpDeskBooking == 1) {
                                                var backUrl = '<%=Util.GetString(Request.QueryString["backUrl"])%>';
                                                window.location = backUrl;
                                            }
                                            else
                                                window.location.reload();
                                        }
                                        else
                                            $(btnSave).removeAttr('disabled').val('Save');
                                    });
                                });
                            });
                        }
                }
                else if (btnSave.value == 'Update') {

                    $getIndirectAppointmentDetails(function (appointmentData) {
                        $(btnSave).attr('disabled', true).val('Submitting...');
                        appointmentData.App_ID = '<%=Util.GetString(Request.QueryString["Appointment_Id"])%>';
                        console.log(appointmentData);
                        serverCall('Services/AppointmentNew.asmx/UpdateApp', { appointmentData: [appointmentData] }, function (response) {
                            var $responseData = JSON.parse(response);
                            modelAlert($responseData.response, function () {
                                if ($responseData.status)
                                    window.location.href = '../OPD/AppointmentConformation.aspx';
                                else
                                    $(btnSave).removeAttr('disabled').val('Update');
                            });
                        });
                    });

                }
                };

        var toastOptions = {
            "closeButton": true,
            "debug": false,
            "newestOnTop": false,
            "progressBar": true,
            "positionClass": "toast-bottom-left",
            "preventDuplicates": true,
            "showDuration": "300",
            "hideDuration": "500000000",
            "timeOut": "5000000000",
            "extendedTimeOut": "100000000000",
            "showEasing": "swing",
            "hideEasing": "linear",
            "showMethod": "fadeIn",
            "hideMethod": "fadeOut"
        }

        var getAppointmentLastVisitDetails = function (data, callback) {
            getPatientBasicDetails(function (response) {
                getAppointmentCountDoctorWise({ doctorID: response.doctorID, appointmentDate: data.appointmentDate }, function () { });
                if (String.isNullOrEmpty(response.patientID))
                    return false;

                serverCall('../Common/CommonService.asmx/GetLastVisitDetail', { PatientID: response.patientID, DoctorID: response.doctorID }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0) {
                        var message = '<div class="row"><div class="col-md-10"><label class="pull-left">Date</label><b class="pull-right">:</b></div><div class="col-md-13 pull-left"><label class="pull-left">' + responseData[0].VisitDate + '</label></div></div>';
                        message += '<div class="row"><div class="col-md-10"><label class="pull-left">Valid To</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].ValidTo + '</label></div></div>';
                        message += '<div class="row"><div class="col-md-10"><label class="pull-left">Amount Paid</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].AmountPaid + '</label></div></div>';
                        message += '<div class="row"><div class="col-md-10"><label class="pull-left">Days</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].Days + '</label></div></div>';
                        message += '<div class="row"><div class="col-md-10"><label class="pull-left">Type</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].VisitType + '</label></div></div>';
                        message += '<div class="row"><div class="col-md-10"><label class="pull-left">Doctor</label><b class="pull-right">:</b></div><div class="col-md-14 pull-left"><label class="pull-left">' + responseData[0].Doctor + '</label></div></div>';
                        toastr.clear();
                        var notify = toastr.info(message, 'Last Visit Details', toastOptions);
                        var $notifyContainer = jQuery(notify).closest('.toast-top-center');
                        if ($notifyContainer) {
                            var containerWidth = jQuery(notify).width() + 20;
                            $notifyContainer.css("margin-left", -containerWidth / 2);
                        }
                    }
                    else
                        toastr.clear();
                });
            });
        }

        var getAppointmentCountDoctorWise = function (data, callback) {
            serverCall('BookDirectAppointment.aspx/GetAppointmentCount', data, function (response) {
                if (!String.isNullOrEmpty(response))
                    $('#btnAppointmentCount b').text(response);
                else
                    $('#btnAppointmentCount b').text('00');
            });
        }

        $getDiscountWithCoPay = function (data, callback) {
            serverCall('../common/CommonService.asmx/GetDiscountWithCoPay', data, function (response) {
                callback(JSON.parse(response)[0]);
            });
        }


        var getMobileAppointments = function (callback) {
            serverCall('./services/MobileApplication.asmx/GetMobileApplicationAppointment', {}, function (response) {
                var responseData = JSON.parse(response);
                mobileApplicationAppointments = responseData;
                var responseHTML = $('#template_mobileApplicationAppointment').parseTemplate(mobileApplicationAppointments);
                callback($('#divMobileApplicationAppointmentDetails').html(responseHTML).customFixedHeader());
            });
        }

        var mobileApplicationAppointmentAutoRefesh = {};
        var openMobileApplicationAppointmentsModel = function () {
            getMobileAppointments(function () {
                mobileApplicationAppointmentAutoRefesh = setTimeout(getMobileAppointments(function () { }), 10000);
                $('#divMobileAppointmentSearch').showModel();
            });
        }

        var mobileApplicationAppointmentModelClose = function () {
            $('#divMobileAppointmentSearch').closeModel();
            clearTimeout(mobileApplicationAppointmentAutoRefesh);
        }


        var onMobileAppointmentSelect = function (elem) {
            var appointmentData = JSON.parse($(elem).closest('tr').attr('data-app'));
            var appointmentDetails = {
                PurposeOfVisitID: '',
                appointmentType: 'Walk-In',
                SubcategoryID: '0',
                Time: appointmentData.StartTime,
                EndTime: appointmentData.EndTime,
                Amount: 0,
                RateListID: '',
                Date: appointmentData.AppointmentDate
            };
            $('#txtAppointmentTime').attr('mobileAppointmentID', appointmentData.ID);
            if (appointmentData.IsRegistred == 1) {
                $searchPatient({ PatientID: appointmentData.patientID, PatientRegStatus: 1 }, '', appointmentData.Gender, function (response) {
                    mobileApplicationAppointmentModelClose();
                    $bindPatientDetails($.extend(response, appointmentData), function () {
                        $bindAppointmentDetails(appointmentDetails, function () {

                        });
                    });
                });
            }
            else {
                getBindPatientDefaultValue(appointmentData, function (response) {
                    mobileApplicationAppointmentModelClose();
                    $bindPatientDetails(response, function () {
                        $bindAppointmentDetails(appointmentDetails, function () {

                        });
                    });
                });
            }
        }






        $showVitalSignModel = function () {
            $getDirectAppointmentDetails(function (appointmentData) {
                $('#tb_VitalSign tr').has('td').remove();
                $('#VitalSignModel .modal-body').find('input[type=text]').val('');
                $('#VitalSignModel').showModel();
            });
        }

        $closeVitalSignModel = function () {
            $('#VitalSignModel').hideModel();
            $getDirectAppointmentDetails(function (appointmentData) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/BookDirectAppointment.asmx/SaveDirectApp', appointmentData, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0") {
                                window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0');
                                window.open('../common/OPDCard.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0');
                            }
                            else {
                                window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0&Type=OPD');
                                window.open('../common/OPDCard.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0');
                            }
                            window.location.reload();
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');

                    });
                });
            });
        }


        $AddVitalSignDetail = function () {
            if (($("#txtBp").val() === "") && ($("#txtP").val() === "") && ($("#txtR").val() === "") && ($("#txtT").val() === "") && ($("#txtHt").val() === "") && ($("#txtWt").val() === "") && ($("#txtArmSpan").val() === "") && ($("#txtSittingHeight").val() === "") && ($("#txtIBW").val() === "")) {
                modelAlert('Please Enter BP OR Pulse OR Arm Span');
                $("#txtBp").focus();
                return false;
            }
            if ($("#txtBp").val() != "") {
                var con = bp();
                if (bp() == 1)
                    return false;
            }
            if ($("#txtBMI").val() == null || $("#txtBMI").val() == "" || $("#txtBMI").val() == "0") {
                modelAlert('Please Enter Valid Height OR Weight');
                $("#txtHt").focus();
                return false;
            }

            modelAlert('Your Bmi Is : ' + $("#txtBMI").val());

            var data = {
                BP: $('#txtBp').val(),
                Pulse: $('#txtP').val(),
                Resp: $('#txtR').val(),
                Temp: $('#txtT').val(),
                HT: $('#txtHt').val(),
                WT: $('#txtWt').val(),
                ArmSpan: $('#txtArmSpan').val(),
                SittingHeight: $('#txtSittingHeight').val(),
                IBW: $('#txtIBW').val(),
                SPO2: $('#txtSPO2').val()
            }
            if (!String.isNullOrEmpty(data)) {

                var trStyle = 'style = "background-color:aqua"';
                $VitalSignTr = "<tr id=tr1 " + trStyle + ">";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnBP'>" + data.BP + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnPulse'>" + data.Pulse + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnResp'>" + data.Resp + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnTemp'>" + data.Temp + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnHT'>" + data.HT + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnWT'>" + data.WT + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnArmSpan'>" + data.ArmSpan + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnSittingHeight'>" + data.SittingHeight + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnIBW'>" + data.IBW + "</span></td>";
                $VitalSignTr += "<td class='GridViewLabItemStyle'><span id='SpnSPO2'>" + data.SPO2 + "</span></td></tr>";
                $('#tb_VitalSign').append($VitalSignTr);
                $('#tb_VitalSign').show();
                $closeVitalSignModel();
            }
            else {
                $('#divVitalSignDetail').html('');
                $('#tb_VitalSign').hide();
            }
        }


    </script> 

     <script type="text/javascript">
         $(document).ready(function () {
             if ($("#txtHt").val() > 0 && $("#txtWt").val() > 0) {
                 convfromcmeters();
             }
         });
         function convfromcmeters() {
             $("#lblBmi").text('');
             var frm = $("#txtHt").val();
             var weight = $("#txtWt").val();
             var feet2 = 0;
             var inches2 = 0;
             var pound = parseFloat(weight * 2.20462).toFixed(3);
             inches2 = ((frm) * .39370078740157477);

             if (inches2 == 0) {
             }
             else if (inches2 == "") {
                 modelAlert('Please enter valid values into the boxes');
             }
             feet2 = parseInt(inches2 / 12);
             inches2 = inches2 % 12;

             if (feet2 != "0" && inches2 != "0" && pound != "0.000") {
                 compute(feet2, inches2, pound);
             }
             else {
                 $("#txtBMI").val(0);
             }
         }
         function cal_bmi(lbs, ins) {
             h2 = ins * ins;
             bmi = lbs / h2 * 703
             f_bmi = Math.floor(bmi);
             diff = bmi - f_bmi;
             diff = diff * 10;
             diff = Math.round(diff);
             if (diff == 10)    // Need to bump up the whole thing instead
             {
                 f_bmi += 1;
                 diff = 0;
             }
             if (isNaN(f_bmi)) f_bmi = 0;
             if (isNaN(diff)) diff = 0;
             bmi = f_bmi + "." + diff;
             return bmi;
         }
         function compute(feet, inch, weight) {
             var f = self.document.forms[1];
             w = weight;
             v = feet;
             u = inch;
             //w = document.getElementById('height_feet').value;
             // Format values for the BMI calculation
             var fi = parseInt(feet * 12);
             var i = parseInt(feet * 12) + inch * 1.0;
             // Do validation of remaining fields to check for existence of values
             if (w != "" && i != "") {
                 // Perform the calculation
                 var Bmi = cal_bmi(w, i);
                 if (Bmi != "") {
                     $("#lblBmi").text('Your Bmi Is : ' + Bmi + '');
                     $("#txtBMI").val(Bmi);
                 }
             }
             if (Bmi == null)
                 $("#txtBMI").val(0);
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

         function checkForSecond(sender, e) {
             formatBox = document.getElementById(sender.id);
             strLen = sender.value.length;
             strVal = sender.value;
             hasDec = false;
             e = (e) ? e : (window.event) ? event : null;
             if (e) {
                 var charCode = (e.charCode) ? e.charCode :
                             ((e.keyCode) ? e.keyCode :
                             ((e.which) ? e.which : 0));
                 if ((charCode == 47)) {
                     for (var i = 0; i < strLen; i++) {
                         hasDec = (strVal.charAt(i) == '/');
                         if (hasDec)
                             return false;
                     }
                 }
             }
             return true;
         }

         function bp() {
             var bp = $('#<%=txtBp.ClientID %>').val();
             var con = 0;
             var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
             if ($('#<%=txtBp.ClientID %>').val() != "") {
                 if (!bpexp.test(bp)) {
                     modelAlert('Please Enter Valid BP');
                     $('#<%=txtBp.ClientID %>').focus();
                     con = 1;
                 }
             }
             return con;
         }


         $(function () {
             shortcut.add('Alt+S', function () {
                 var btnSave = $('#btnSave');
                 if (btnSave.length > 0) {
                     if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                         $saveAppointment(btnSave[0], $('#ddlTypeOfApp').val());
                     }
                 }
             }, addShortCutOptions);
         });

         var onddlSlotDoctorsChange = function (el) {
             $('#ddlDoctor').val(el.value).change().trigger('chosen:updated');
         }
         
         var onNextPrevDateChange = function (addDays,callback) {
             var data = {
                 selectedDate: $('#txtAppointmentSlotDate').val(),
                 addDays: addDays
             };
             serverCall('BookDirectAppointment.aspx/NextPrevDate', data, function (response) {
                 var responseData=JSON.parse(response);
                 if (responseData.status)
                     $('#txtAppointmentSlotDate').val(responseData.calculatedAppointmentDate).change();
                 else
                     modelAlert(responseData.message, function () {

                     });
             });
         }

    </script>

    <style type="text/css">
        #toast-container > div {
            width: 430px;
            opacity: 1;
        }
    </style>
    
    <div id="Pbody_box_inventory">
       <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b id="pageTitle">Appointment</b>
        </div>
        <UC1:OldPatientSearchControl ID="PatientInfo" runat="server" />
        <div id="divAppointmentDetails"  class="POuter_Box_Inventory">
           
        <div class="row">
            <div class="col-md-21">
                <div class="row">
          <div class="col-md-3">
               <label class="pull-left">  Visit Type  </label>
               <b class="pull-right">:</b>
           </div>
           <div class="col-md-5">
                        <select id="ddlAppointmentType"  title="Select VisitType"></select>
          
           </div>
           <div class="col-md-3">
               <label class="pull-left">  Type   </label>
               <b class="pull-right">:</b>
           </div>
           <div class="col-md-5">
            <select id="ddlTypeOfApp"  onchange="$appointmentTypeChange(this.value)"  title="Select AppointmentType" ></select>
            
           </div>
           <div class="col-md-3">
               <label class="pull-left">    Purpose of Visit    </label>
               <b class="pull-right">:</b>
           </div>
           <div class="col-md-4">
                 <select id="ddlPurposeofVisit"  title="Select Purpose Of Visit"></select>
           </div>
            <div style="padding-left: 0px;" class="col-md-1">
                  <input type="button" class="ItDoseButton" value="New" id="btnAddPurposeOfVisit" title="Click to Create New District"  onclick="$addNewVisitTypeModel()" />
           </div>
             

      </div>
        <div class="row">
          <div class="col-md-3">
               <label class="pull-left">  Appointment On </label>
               <b class="pull-right">:</b>
           </div>
           <div class="col-md-3">
                <asp:TextBox ID="txtAppointmentOn" runat="server"    ClientIDMode="Static"   ToolTip="Select DOB" Enabled="false"   ></asp:TextBox>
                <cc1:CalendarExtender ID="calendarExteAppointmentOn" TargetControlID="txtAppointmentOn" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
          
           </div>
            <div style="padding-left: 0px;" class="col-md-2">
                        <input type="button" class="ItDoseButton" style="font-weight:bold;width:100%" value="Availability"  id="btnAvailability"   />
            </div>
           <div class="col-md-3">
               <label class="pull-left">   Time   </label>
               <b class="pull-right">:</b>
           </div>
           <div class="col-md-5">
            <input id="txtAppointmentTime"  mobileAppointmentID=""   type="text"  disabled="disabled"  maxlength="10" title="Enter Appointment Time."  autocomplete="off"  /> 
            
           </div>

           <div class="col-md-3">
               <label class="pull-left">    Charges   </label>
               <b class="pull-right">:</b>
           </div>
           <div class="col-md-5">
                 <input id="txtAppointmentCharges" type="text" onchange="$onAppointmentChargesChange(this.value,$('#ddlTypeOfApp').val())"  disabled="disabled" maxlength="10" title="Enter Appointment Charges"    /> 
           </div>
      </div>

            </div>
            <div class="col-md-3">
                <div class="row">
                    <div class="col-md-24">
                        <button   type="button" id="btnAppointmentCount" style="width:100%;padding: 0px;" class="label label-warning"><span style="font-weight:800" >Last Token : <b  class="blink" style="font-size: 15px;font-family: cursive;"> 00</b> </span></button>
                    </div>
                </div>
                 <div class="row" >
                 <div class="col-md-24">
                      <button style="width:100%;font-weight:bold;" id="btnMobileApplicationAppointmentModel" onclick="openMobileApplicationAppointmentsModel()" type="button">Online Booking's</button>
                 </div>
             </div>
            </div>
        </div>

        </div>
        <div style="width:100%;display:none" id="paymentControlDiv"  >
            <UC2:PaymentControl ID="paymentControl" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
             <span style="display:none" id="lblRateListID"></span>
             <span style="display:none" id="lblItemId"></span>
             <span style="display:none" id="lblItem"></span>
             <span style="display:none" id="lblScheduleChargeID"></span>
             <span style="display:none" id="lblDiscountPercent">0</span>
             <span style="display:none" id="lblDiscountAmount">0</span>
             <span style="display:none" id="lblIsPayable">0</span>
             <span style="display:none" id="lblCoPaymentPercent">0</span>
             <span style="display:none" id="lblIsPanelWiseDiscount">0</span>
             <span style="display:none" id="lblItemCode"></span>
             <span style="display:none" id="lblIsMobileAppointment"></span>
             <span id="spnBookDirectAppointment"></span> 
             <span style="display:none" id="spnHashCode"></span> 
             <span id="spnMembershipDisc" style="display:none" ></span>        
             <input type="button" id="btnSave" class="save margin-top-on-btn"   value="Save" onclick="$saveAppointment(this, $('#ddlTypeOfApp').val());" tabindex="35" />
             <input type="button" id="btnUpdate" class="save margin-top-on-btn"  style="display:none"  value="Update" onclick="" tabindex="35" />
        </div>
        </div>






    <div id="divAddComplaint"   class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;width:320px;height:153px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAddComplaint" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Add Visit Type</h4>
                </div>
                <div class="modal-body">
                     <div class="row">
                         <div class="col-md-10">
                               <label class="pull-left">    Visit Name   </label>
                               <b class="pull-right">:</b>
                          </div>
                         <div class="col-md-14">
                             <input type="text" onlytext="30" id="txtComplaintName" class="form-control ItDoseTextinputText" />
                         </div>
                      </div>
                </div>
                  <div class="modal-footer">
                         <button type="button"   onclick="$savePurposeOfVisit({CName:$('#txtComplaintName').val()});">Save</button>
                         <button type="button"  data-dismiss="divAddComplaint" >Close</button>
                </div>
            </div>
        </div>
    </div>


    
<div id="VitalSignModel" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1100px; height:270px;">
            <div class="modal-header">
                <button type="button" class="close"  onclick="$closeVitalSignModel()"   aria-hidden="true">&times;</button>
                <h4 class="modal-title">Vital Sign</h4>
            </div>
            <div class="modal-body">
                 
                  <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    BP
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtBp" runat="server" CssClass="requiredField" Width="50px" ClientIDMode="Static" onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="7" ToolTip="Enter BP"></asp:TextBox>
                                <span class="style2">mm/Hg</span>             
                                  <asp:Label ID="lblBmi" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" Style="display: none"   ></asp:Label>
                            <asp:TextBox ID="txtBMI" runat="server" Style="display: none" ClientIDMode="Static" ></asp:TextBox>
                            <asp:Label ID="lblID" Text="" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>                    
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pulse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtP" runat="server" CssClass="requiredField" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="16" MaxLength="5"
                                    ToolTip="Enter p"></asp:TextBox>
                                <span class="style2">p-m</span>
                                <cc1:FilteredTextBoxExtender ID="fttxtP" runat="server" TargetControlID="txtP" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Resp
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtR" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="17" MaxLength="5"
                                    ToolTip="Enter R"></asp:TextBox><span class="style2">BPM</span><span style="color: Red; font-size: 8px;"></span>
                                <cc1:FilteredTextBoxExtender ID="fttxtR" runat="server" TargetControlID="txtR" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Temp.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtT" runat="server" Width="49px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="18" MaxLength="5"
                                    ToolTip="Enter T"></asp:TextBox>
                                <span class="style2">&deg;C</span><span style="color: Red; font-size: 8px;"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtT"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Height
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtHt" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="19" MaxLength="5"
                                    ToolTip="Enter HT" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbHT" runat="server" TargetControlID="txtHt" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2">CM</span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Weight
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtWt" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter WT" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbWt" runat="server" TargetControlID="txtWt" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2">Kg</span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Arm Span
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtArmSpan" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Arm Span" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2">CM</span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtArmSpan"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Sitting Height
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtSittingHeight" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbSitting" runat="server" TargetControlID="txtSittingHeight" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2">CM</span>
                            </div>
                           
                        </div>
                        <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                    IBW
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtIBW" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter IBW" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2">Kg</span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtIBW"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    SPO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtSPO2" runat="server"  Width="50px" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter IBW Percentage" AutoCompleteType="None" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtSPO2"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            </div>
                        </div>
                    </div>
                </div>
               


                <div style="text-align:center" class="row">
                       <button type="button"  onclick="$AddVitalSignDetail()">Save</button>
                </div>
                <div style="height:40px"  class="row">
                    <div id="divVitalSignDetail" class="col-md-24">
                         <table id="tb_VitalSign" rules="all" border="1" style="border-collapse: collapse; width:800px; height:40px; display: none" class="GridViewStyle">
                            <thead style="width: 100%">
                                <tr id="VitalSignHeader">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px">BP</th>                                 
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px">Pulse</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px">Resp</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px">Temp</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px">Height</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px">Weight</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px">ArmSpan</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 120px">SittingHeight</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px">IBW</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px">SPO2</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px"></th>
                                </tr>
                            </thead>
                            <tbody style="width: 100%">
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
            <div class="modal-footer">  
                <button type="button"  onclick="$closeVitalSignModel()">Close</button>
            </div>
        </div>
    </div>
</div>






     <%--Doctor Time Slot Availability Model--%>
    <div id="divSlotAvailability"   class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" >
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSlotAvailability" aria-hidden="true">&times;</button>
                     <div class="row">
                          <div class="col-md-3">
			                      <label class="pull-left">   Appointment Date </label>
			                       <b class="pull-right">:</b>
                              </div>
		              <div class="col-md-4">
                          <asp:TextBox ID="txtAppointmentSlotDate" runat="server" style="width:172px"    ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                     <cc1:CalendarExtender ID="calendarExteAppointmentSlotDate" TargetControlID="txtAppointmentSlotDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
                     </div>

                         <div class="col-md-1">
                              <button type="button" onclick="onNextPrevDateChange('-1',function(){})">Prev</button>
                         </div>
                         <div class="col-md-1">
                             <button type="button" onclick="onNextPrevDateChange('1',function(){})">Next</button>
                         </div>

                         <div class="col-md-3">
			                      <label class="pull-left"> Slot Time </label>
			                       <b class="pull-right">:</b>
                           </div>
                         <div class="col-md-3">
                              <select id="ddlSolotMin"  >
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
                         <div class="col-md-3">
			                      <label class="pull-left">   Doctor </label>
			                       <b class="pull-right">:</b>
                           </div>
                          <div class="col-md-5">
                               <select id="ddlSlotDoctors"   onchange="onddlSlotDoctorsChange(this)"></select>
                              </div>
                    </div>
                    
                </div>
                <div class="modal-body">
                   <div id="divSlotAvailabilityBody" style="padding-left: 30px;width:1250px;height:450px;">
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
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-avilable"></button><b style="float:left;margin-top:5px;margin-left:5px">Avilable</b> 
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-yellow"></button><b style="float:left;margin-top:5px;margin-left:5px">Booked</b>  
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-purple"></button><b style="float:left;margin-top:5px;margin-left:5px">Confirmed</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-pink"></button><b style="float:left;margin-top:5px;margin-left:5px">Selected</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-grey"></button><b style="float:left;margin-top:5px;margin-left:5px">Expired</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-info"></button><b style="float:left;margin-top:5px;margin-left:5px">Mobile</b>

                    <button type="button"  data-dismiss="divSlotAvailability">Close</button>
                    
                </div>
            </div>
        </div>
   </div>





    <div id="divMobileAppointmentSearch" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px">
            <div class="modal-header">
                <button type="button" class="close" onclick="mobileApplicationAppointmentModelClose()"    aria-hidden="true">&times;</button>
                <h4 class="modal-title">Today Online Appointments</h4>
            </div>
            <div class="modal-body">
                <div   class="row">
                    <div  class="col-md-24">
                        <div style="height:200px;overflow:auto"  id="divMobileApplicationAppointmentDetails">

                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" onclick="mobileApplicationAppointmentModelClose()"  >Close</button>
            </div>
        </div>
    </div>
</div>




    <%--Time Slot Availability Templates--%>
    <script id="templateTimeSlotAvailability" type="text/html">  
        <#
        var dataLength=paymentModes.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = paymentModes[j];
          #>
                    <div class="ellipsis" style="float:left">
                    
                    </div>
            <#}#>       
    </script>




    <script id="template_mobileApplicationAppointment" type="text/html">
        <table  id="tableMobileApplicationAppointment" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
            <th class="GridViewHeaderStyle" scope="col" >Title</th>
            <th class="GridViewHeaderStyle" scope="col" >First Name</th>
            <th class="GridViewHeaderStyle" scope="col" >L.Name</th>
            <th class="GridViewHeaderStyle" scope="col">Appointment On </th>                         
            <th class="GridViewHeaderStyle" scope="col">Appointment Time </th>                         
            <th class="GridViewHeaderStyle" scope="col">Doctor </th>                         
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=mobileApplicationAppointments.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = mobileApplicationAppointments[j];
                #>          
                

                    <tr onmouseover="this.style.color='#00F'"    data-app='<#= JSON.stringify(objRow)  #>'  onMouseOut="this.style.color=''" id="<#=j+1#>" ondblclick="onMobileAppointmentSelect(this);" style='cursor:pointer;'>                            
                        <td class="GridViewLabItemStyle">
                                <a  class="btn" onclick="onMobileAppointmentSelect(this);" style="cursor:pointer;padding:0px;font-weight:bold;width:60px">Select</a>
                        </td>                                                    
                        <td  class="GridViewLabItemStyle" id="td1"><#=objRow.Title#></td>
                        <td class="GridViewLabItemStyle" id="td2" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PFirstName#></td>
                        <td class="GridViewLabItemStyle" id="td3" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PLastName#></td>
                        <td class="GridViewLabItemStyle" id="td4" style=""><#=objRow.AppointmentDate#></td> 
                        <td class="GridViewLabItemStyle" id="td5" style=""><#=objRow.StartTime#></td> 
                        <td class="GridViewLabItemStyle" id="td12" style=""><#=objRow.Doctor#></td>                         
                        </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>

    <script type="text/javascript">
        var patientSearchOnpageload = function (mobileno) {
            var data = { PatientID: '', PName: '', LName: '', ContactNo: '', Address: '', FromDate: '', ToDate: '', PatientRegStatus: 1, isCheck: '0', IDProof: '', MembershipCardNo: '', DOB: '', IsDOBChecked: '0', Relation: '', RelationName: '', IPDNO: '', panelID: '', cardNo: '', visitID: '', emailID: '' };

            if (mobileno.length < 8) {
                modelAlert('Incomplete Mobile No');
                return;
            }
            data.ContactNo = mobileno

            getOldPatientDetails(data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var resultData = JSON.parse(response);
                    CountPatientTest(resultData[0].MRNo);
                    if (resultData.length > 1) {
                        bindOldPatientDetails(response);
                        $showOldPatientSearchModel()
                    }
                    else {
                        var patientIPDDetails = {
                            IPDTransactionID: resultData[0].IPDDetails.split('#')[0],
                            IPDAdmissionRoomType: resultData[0].IPDDetails.split('#')[1],
                            gender: resultData[0].Gender,
                            PID: resultData[0].MRNo
                        }
                        validatePatientSelection(patientIPDDetails, function () {
                            $patientSearchByPatientId({ PatientID: resultData[0].MRNo, PatientRegStatus: 1 }, function (response) {
                                $bindPatientDetails(response, function () { });
                            });
                        });
                    }
                }
            });
        }
    </script>
</asp:Content>

