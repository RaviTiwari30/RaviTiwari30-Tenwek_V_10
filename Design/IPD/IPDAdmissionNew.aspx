<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IPDAdmissionNew.aspx.cs" Inherits="Design_IPD_IPDAdmissionNew" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="OldPatientSearchControl" TagPrefix="UC1" %>
<%@ Register Src="~/Design/Controls/UCAdmissionBedDetails.ascx" TagName="AdmissionDetailsControl" TagPrefix="UC2" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager ID="sc1" runat="server"></asp:ScriptManager>
    <script type="text/javascript">
        $(document).ready(function () {
            var roleid = '<%=Session["RoleID"]%>';
            if (parseInt(roleid) == 9) {
                $('#btnregistrationcharges').css("display", "none");
            }
        });


        $(document).ready(function () {
            // $.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
            $bindMandatory(function () {
                $commonJsInit(function () {
                    $getHashCode(function () {
                        $patientControlInit(function () {
                            $IPDAdmissionDetailsControlInit(function () {
                                $panelControlInit(function () {
                                    var patientID = $.trim('<%=Util.GetString(Request.QueryString["PID"])%>');
                                    var transactionID = $.trim('<%=Util.GetString(Request.QueryString["TID"])%>');
                                    if (!String.isNullOrEmpty(patientID) && !String.isNullOrEmpty(patientID)) {
                                        $patientSearchByPatientId({ PatientID: patientID, PatientRegStatus: 1 }, function (response) {
                                            response.DoctorID = '';
                                            $bindPatientDetails(response, function () {
                                                 
                                                getAdmitedPatientDetails({ patientID: patientID, transactionID: transactionID }, function (data) {
                                                    console.log(data);
                                                    
                                                    if (data.admissionDetails.length > 0) {
                                                        data.admissionDetails[0].doctorsList = data.doctorList;

                                                        $setAdmissionDetails(data.admissionDetails[0], function () {
                                                            disableDemographicChanges(data.admissionDetails[0], function () {
                                                                $('#btnSave').val('Update');
                                                            });
                                                            // $.unblockUI();
                                                        });
                                                    }
                                                });

                                            });


                                        });
                                    }


                                });
                                // if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1')
                                //    $bindRegistrationCharges(function () { });

                                //for Avail Advance Room Booking
                                var IsAvailAdvanceRoomBooking = Number('<%=Util.GetString(Request.QueryString["IsAvailAdvanceRoomBooking"])%>');
                                if (IsAvailAdvanceRoomBooking == 1) {
                                    var patientID = '<%=Util.GetString(Request.QueryString["advPatientID"])%>';
                                    $patientSearchByPatientId({ PatientID: patientID, PatientRegStatus: 1 }, function (response) {
                                        $bindPatientDetails(response, function () {
                                        });
                                    });
                                }
                                else
                                    $("#ddlType").attr('disabled', false);

                                onPatientIDChange(function () { });
                                // $.unblockUI();
                            });
                        });
                    });
                });
            });
            $("#txtAdmissionDate").attr('disabled', true);
            $("#txtAdmissionTimeHour").attr('disabled', true);
            $("#txtAdmissionTimeMinute").attr('disabled', true); 
            $("#ddlAdmissionTimeMeridiem").attr('disabled', true);
        });

        var onPatientIDChange = function () {
            $('#txtPID').change(function () {
                //for Avail Advance Room Booking
                var IsAvailAdvanceRoomBooking = Number('<%=Util.GetString(Request.QueryString["IsAvailAdvanceRoomBooking"])%>');
                if (IsAvailAdvanceRoomBooking == 1) {
                    var advanceBookingID = Number('<%=Util.GetString(Request.QueryString["advanceBookingID"])%>');
                    var AdvanceBookingRoomID = '<%=Util.GetString(Request.QueryString["advRoom_ID"])%>';
                    var AdvanceBookingIPDCaseTypeID = '<%=Util.GetString(Request.QueryString["advIPDCaseType_ID"])%>';
                    $("#ddlRoomType").val(AdvanceBookingIPDCaseTypeID);
                    $bindRoomBed(AdvanceBookingIPDCaseTypeID, function () {
                        $("#ddlRoomNo").val(AdvanceBookingRoomID);
                        $("#lblIpdAdmissionAgainstAdvanceBooking").text('1');
                        $("#lblAdvanceId").text(advanceBookingID);
                    });
                }
                else {
                    $("#lblIpdAdmissionAgainstAdvanceBooking,#lblAdvanceId").text('0');
                    getAdvanceRoomBookDetail(function () { });
                }
            });
        }
        var getAdvanceRoomBookDetail = function () {
            serverCall('../Common/CommonService.asmx/AdvanceRoomBookDetail', { PatientID: $('#txtPID').val() }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    var message = '<div class="row" style="width:550px;font-weight:bold;"><div class="col-md-6"><label class="pull-left">Booking Date</label><b class="pull-right">:</b></div><div class="col-md-6 pull-left"><label class="pull-left patientInfo">' + responseData[0].BookingDate + '</label></div><div class="col-md-6"><label class="pull-left">Room Type</label><b class="pull-right">:</b></div><div class="col-md-6 pull-left"><label class="pull-left patientInfo">' + responseData[0].RoomType + '</label></div></div>';
                    message += '<div class="row" style="width:550px;font-weight:bold;"><div class="col-md-6"><label class="pull-left">Room Name</label><b class="pull-right">:</b></div><div class="col-md-18 pull-left"><label class="pull-left patientInfo">' + responseData[0].RoomName + '</label></div></div>';
                    modelConfirmation('Advance Room Booking Confirmation ?', message, 'Admission Against Advance Booking', 'Cancel', function (res) {
                        if (res) {
                            $("#ddlRoomType").val(responseData[0].IPDCaseTypeID);
                            $bindRoomBed(responseData[0].IPDCaseTypeID, function () {
                                $("#ddlRoomNo").val(responseData[0].RoomID);
                                $("#lblIpdAdmissionAgainstAdvanceBooking").text('1');
                                $("#lblAdvanceId").text(responseData[0].ID);
                            });
                        }
                        else {
                            $("#lblIpdAdmissionAgainstAdvanceBooking,#lblAdvanceId").text('0');
                        }
                    });
                }
            });
        }
        var $getHashCode = function (callback) {
            serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
                $('#spnHashCode').text(response);
                callback(true);
            });
        };

        var $bindMandatory = function (callback) {
            var manadatory = [
               { control: '#ddlTitle', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                  { control: '#txtPMiddleName', isRequired: false, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
                { control: '#txtPLastName', isRequired: true, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
			//	{ control: '#txtDOB', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                { control: '#txtAge', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                //{ control: '#ddlMarried', erroMessage: 'Select Marital Status', tabIndex: 3, isSearchAble: false },
                { control: '#txtMobile', isRequired: true, erroMessage: 'Enter Mobile Number', tabIndex: 4, isSearchAble: false },
                { control: '#ddlMarried', isRequired: false, erroMessage: 'Select Marital Status', tabIndex: 5, isSearchAble: false },
              //  { control: '#txtIDProofNo', isRequired: true, erroMessage: 'Enter NIC No.', tabIndex: 4, isSearchAble: false },
                 //{ control: '#txtAddress', isRequired: true, erroMessage: 'Enter Address', tabIndex: 5, isSearchAble: false },
                  { control: '#txtParmanentAddress', isRequired: true, erroMessage: 'Enter Address', tabIndex: 5, isSearchAble: false },

                //{ control: '#txtRelationName', isRequired: true, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },
                { control: '#ddlCountry', isRequired: true, erroMessage: 'Please Select Country', tabIndex: 6, isSearchAble: true },
                { control: '#ddlDistrict', isRequired: true, erroMessage: 'Please Select DIstrict', tabIndex: 7, isSearchAble: true },
                { control: '#ddlCity', isRequired: true, erroMessage: 'Please Select City', tabIndex: 8, isSearchAble: true },
                { control: '#ddlDoctor', isRequired: true, erroMessage: 'Please Select Doctor', tabIndex: 9, isSearchAble: true },
                { control: '#txtAdmissionDate', isRequired: true, erroMessage: 'Please Select Admission Date', tabIndex: 10, isSearchAble: false },
                { control: '#txtAdmissionTimeHour', isRequired: true, erroMessage: 'Please Enter Admission Time', tabIndex: 11, isSearchAble: false },
                { control: '#txtAdmissionTimeMinute', isRequired: true, erroMessage: 'Please Enter Admission Time', tabIndex: 12, isSearchAble: false },
                { control: '#ddlAdmissionTimeMeridiem', isRequired: true, erroMessage: 'Please Enter Admission Time', tabIndex: 13, isSearchAble: false },
                { control: '#ddlRoomType', isRequired: true, erroMessage: 'Please Select Room Type', tabIndex: 14, isSearchAble: false },
                { control: '#ddlRoomNo', isRequired: true, erroMessage: 'Please Select Room NO', tabIndex: 15, isSearchAble: false },
                { control: '#ddlRoomBilling', isRequired: true, erroMessage: 'Please Select Room Billing', tabIndex: 16, isSearchAble: false },
                { control: '#ddlAdmissionType', isRequired: true, erroMessage: 'Please Select Admission Type', tabIndex: 17, isSearchAble: false },
                { control: '#ddlReferSource', isRequired: false, erroMessage: 'Please Enter Refer Source', tabIndex: 18, isSearchAble: false },
				{ control: '#ddlTaluka', isRequired: true, erroMessage: 'Please Select Village', tabIndex: 8, isSearchAble: true },
                 { control: '#txtIDProofNo', isRequired: false, erroMessage: 'Please Enter ID Proof.', tabIndex: 18, isSearchAble: false },
                { control: '#ddlDepartment', isRequired: false, erroMessage: 'Please select Department', tabIndex: 20, isSearchAble: true }
            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                if (item.isSearchAble)
                    $(item.control + '_chosen a').addClass('requiredField').attr('tabindex', item.tabIndex);
                $(manadatory[0].control).focus();
            });
            callback(true);
        }

        var $getIPDAdmissionDetails = function (callback) {
            var hashCode = $('#spnHashCode').text();
            var inValidElem = null;
            $('#Pbody_box_inventory .requiredField').each(function (index, elem) {
                if (String.isNullOrEmpty(elem.value) || elem.value == '0') {
                    inValidElem = elem;
                    modelAlert(this.attributes['errorMessage'].value, function () {
                        inValidElem.focus();
                    });
                    return false;
                }
            });
            if (String.isNullOrEmpty(inValidElem)) {
                $getPatientDetails(function (patientDetails) {
                    $getAdmissionDetails(function (admissionDetails) {
                        $PM = patientDetails.defaultPatientMaster;
                        $PMH = {
                            PatientID: patientDetails.PatientID,
                            // DoctorID: admissionDetails.doctorsList[0].doctorID,
                            TransactionID: '',
                            DateOfVisit: admissionDetails.admissionDate,
                            Time: admissionDetails.admissionTime,
                            FeesPaid: 0,
                            Type: 'IPD',
                            PanelID: patientDetails.PanelID,
                            Source: admissionDetails.referSource,
                            ReferedBy: patientDetails.ReferedBy,
                            ProId: patientDetails.PROID,
                            ParentID: patientDetails.ParentID,
                            Admission_Type: admissionDetails.admissionType,
                            patient_type: patientDetails.PatientType.text,
                            PolicyNo: patientDetails.panelDetails.policyNo,
                            PanelIgnoreReason: patientDetails.panelDetails.ignorePolicyReason,
                            EmployeeDependentName: patientDetails.panelDetails.nameOnCard,
                            ExpiryDate: patientDetails.panelDetails.expireDate,
                            //DependentRelation: patientDetails.panelDetails.policyNo,
                            CardHolderName: patientDetails.panelDetails.nameOnCard,
                            CardNo: patientDetails.panelDetails.cardNo,
                            ScheduleChargeID: 0,//ADD LATER
                            KinRelation: patientDetails.Relation.text,
                            KinName: patientDetails.RelationName,
                            KinPhone: patientDetails.RelationPhoneNo,
                            RelationWith_holder: patientDetails.panelDetails.cardHolderRelation,
                            Remarks: '',
                            HashCode: hashCode,
                            TypeOfPatient: patientDetails.PatientType.text,
                            MLC_NO: admissionDetails.mlcNo,
                            MLC_Type: admissionDetails.mlcType,
                            IssuedVisitorCardNo: admissionDetails.IssuedVisitorCardNo,
                            Weight: admissionDetails.childWeight,
                            Height: admissionDetails.childHeight,
                            TypeOfDelivery: admissionDetails.TypeOfDelivery,
                            DeliveryWeeks: admissionDetails.DeliveryWeeks,
                            BirthIgnoreReason: admissionDetails.BirthIgnoreReason,
                            ReferenceCode: patientDetails.panelDetails.ReferenceCodeOPD,
                            isBirthDetail: admissionDetails.isBirthDetail,
                            MotherTID: admissionDetails.MotherTID,
                            patientTypeID: patientDetails.PatientType.value,
                            AdmissionReason: admissionDetails.AdmissionReason,
                            ReferralTypeID: patientDetails.ReferralTypeID
                        }
                        $IPDCaseHistory = {
                            Employed: 'No',
                            DateOfAdmit: admissionDetails.admissionDate,
                            TimeOfAdmit: admissionDetails.admissionTime,
                            Status: 'IN',
                            Insurance: 'No',//clear latar
                            RequestedRoomType: admissionDetails.requestRoomType,
                            IsRoomRequest: (String.isNullOrEmpty(admissionDetails.requestRoomType) || admissionDetails.requestRoomType == '0') ? '0' : '1'
                        }
                        $IPDProfile = {
                            IsTempAllocated: 0,
                            Status: 'IN',
                            IPDCaseTypeID: admissionDetails.roomType,
                            StartDate: admissionDetails.admissionDate,
                            StartTime: admissionDetails.admissionTime,
                            RoomID: admissionDetails.roomNo,
                            DateOfDischarge: '01/01/0001',
                            TimeOfDischarge: '00:00:00',
                            TobeBill: 1,
                            PatientID: patientDetails.PatientID,
                            IPDCaseTypeID_Bill: admissionDetails.roomBilling,
                            PanelID: patientDetails.PanelID
                        }

                        $IPDAdjustment = {
                            PatientID: patientDetails.PatientID,
                            CreditLimitPanel: '0',//Add Later
                            // DoctorID: admissionDetails.doctorsList[0].doctorID,
                            PanelID: patientDetails.PanelID,
                            CreditLimitType: 'A',//Add Late r
                            BillingRemarks: ''
                        }

                        var IsAdvance = 0;
                    
                        var data = {
                            PM: [$PM],
                            PMH: [$PMH],
                            ICH: [$IPDCaseHistory],
                            PIP: [$IPDProfile],
                            IPDAdj: [$IPDAdjustment],
                            doctors: admissionDetails.doctorsList,
                            IsAdvance: IsAdvance,
                            patientDocuments: patientDetails.patientDocuments,
                            panelDocuments: patientDetails.panelDocuments,
                            isAdmissionAgainstAdvanceBooking: admissionDetails.isIPDAdmissionAgainstAdvanceBooking,
                            advanceID: admissionDetails.advanceId,
                            sendApprovalEmail: true,
                            approvalAmount: patientDetails.panelDetails.approvalAmount,
                            approvalRemark: patientDetails.panelDetails.approvalRemark
                        };


                        if (String.isNullOrEmpty($PMH.PanelIgnoreReason) && $('#divPanelRequiredDocuments button').length > 0 && patientDetails.panelDocuments <= 0) {
                            modelAlert('Panel Document Required...!!!<br/> Please Upload');
                            return false;
                        }


                        if (parseInt($PMH.PanelID) > 1) {
                            modelConfirmation('Panel Patient Admission Confirmation ?', 'Are You Sure To Admit Patient  Under </br><span class="patientInfo"> ' + patientDetails.panelDetails.panel.panelName + '</span>', 'Yes Continue', 'Cancel', function (response) {
                                if (response)
                                    callback(data);
                            });
                        }
                        else
                            callback(data);
                    });
                });
            }
        }




        var getApprovalEmailToPanel = function (callback) {
            $getPatientDetails(function (patientDetails) {
                var data = {
                    transactionID: '',
                    patientID: '',
                    panelID: patientDetails.PanelID,
                    approvalAmount: patientDetails.panelDetails.approvalAmount,
                    policyNumber: patientDetails.panelDetails.policyNo,
                    policyCardNumber: patientDetails.panelDetails.cardNo,
                    policyExpiryDate: patientDetails.panelDetails.expireDate,
                    approvalRemark: patientDetails.panelDetails.approvalRemark,
                    panelDocuments: patientDetails.panelDetails.panelDocuments,
                }
                callback(data);
            });
        }




        var $saveAdmissionDetails = function (btnSave) {
            if ($('#txtPID').val() == '') { modelAlert(" Patient is not Register,For Registration Kindly Go To Record Department"); return; }

            $getIPDAdmissionDetails(function (admissionDetails) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/IPDAdmission.asmx/SaveIPDAdmission', admissionDetails, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        modelAlert($responseData.response, function () {

                          //  if (admissionDetails.PMH[0].PanelID != Number('<%=Resources.Resource.DefaultPanelID%>'))
                              // sendPanelApprovalConfirmation($responseData, function (r) { });
                            //else
                            //securityDepositConfirmation($responseData, function (s) { });
                            window.location.reload();
                        });
                        }
                        else {
                            modelAlert($responseData.response, function () {
                                $(btnSave).removeAttr('disabled').val('Save');
                            });
                        }
                });
            });
        }


            var sendPanelApprovalConfirmation = function (responseData, callback) {
                var c = callback;
                modelConfirmation('Approval Email Confirmation ?', 'Are You Want to Send Email.', 'Yes Send', 'Cancel', function (response) {
                    if (response) {
                        modelConfirmation('Are you Sure ?', 'To Attach Cost Estimation .', 'Yes Continue', 'Cancel', function (res) {
                            sendApprovalEmailToPanel(responseData,res,function (res) {
                                securityDepositConfirmation(responseData, function (s) { });
                            });
                        });
                    }
                    else
                        securityDepositConfirmation(responseData, function (s) {});
                });
            }


          


            var sendApprovalEmailToPanel = function ($responseData,attachCostEstimation, callback) {
                getApprovalEmailToPanel(function (data) {
                    data.transactionID = $responseData.transactionID;
                    data.patientID = $responseData.patientID;
                    data.attachCostEstimation = attachCostEstimation;
                    serverCall('Services/IPDAdmission.asmx/SendPanelApprovalEmail', { panelApprovalDetails: data, isAdvanceRoomBooking: false }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            callback(responseData);
                        });
                    });
                });
            }


            var securityDepositConfirmation = function ($responseData, callback) {
                window.open('../../Design/IPD/PatientAdmissionPrintOut.aspx?TID=' + $responseData.transactionID + '&PID=' + $responseData.patientID + '');
              //  window.open('../../Design/IPD/IPDConsentFromPrintout.aspx?TID=' + $responseData.transactionID + '&PID=' + $responseData.patientID + '');
                //window.open('../../Design/IPD/AttendantPass.aspx?TID=' + $responseData.transactionID + '');//+ 'ISHHI'
                modelConfirmation('Security Deposit Confirmation ?', 'Continue With Security Deposit Against </br><span class="patientInfo"> IPD NO. ' + $responseData.IPDNO + '</span>', 'Yes Continue', 'Cancel', function (response) {
                    if (response)
                        location.href = 'ReceiptBill.aspx?TransactionID=' + $responseData.transactionID;
                    else {
                        var IsAvailAdvanceRoomBooking = Number('<%=Util.GetString(Request.QueryString["IsAvailAdvanceRoomBooking"])%>');
                    if (IsAvailAdvanceRoomBooking == 1)
                        location.href = '../IPD/AdvanceRoomBookingSearch.aspx';
                    else
                        window.location.reload();
                }
            });
        }


        var onSaveAdmissionDetaills = function (btnSave) {
            var transactionID = $.trim('<%=Util.GetString(Request.QueryString["TID"])%>');
            if (String.isNullOrEmpty(transactionID))
                $saveAdmissionDetails(btnSave);
            else
                updateAdmissionDetails(btnSave, transactionID);

        }

        var updateAdmissionDetails = function (btnSave, transactionID) {
            getUpDatedAdmissionDetails(function (data) {
                data.transactionID = transactionID;
                serverCall('Services/IPDAdmission.asmx/UpdatePatientAdmissionDetails', data, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        location.href = '../IPD/PatientRegSearch.aspx';
                    });
                });
            })
        }

        var getAdmitedPatientDetails = function (data, callback) {
            serverCall('Services/IPDAdmission.asmx/getPatientAdmissionDetails', data, function (response) {
                callback(JSON.parse(response));
            });
        }

            var disableDemographicChanges = function (data,callback) {

                $('#PatientDetails').find('input,select,button,textarea,.chosen-container').not('#ddlDoctor,#ddlDoctor_chosen input').prop('disabled', true).trigger("chosen:updated")
                $('#PatientDetails').find('#txtRelationName,#txtRelationPhoneNo,#ddlRelation').prop('disabled', false);
                $('#PatientDetails').find('#txtRelationName').val(data.KinName);
                $('#PatientDetails').find('#txtRelationPhoneNo').val(data.KinPhone);
                $('#PatientDetails').find('#ddlRelation').val(data.KinRelation);


                callback();
            }


        var getUpDatedAdmissionDetails = function (callback) {
		getPatientBasicDetails(function (patientDetails) {
            $getAdmissionDetails(function (admissionDetails) {
                var data = {
                    mlcNo: admissionDetails.mlcNo,
                    mlcType: admissionDetails.mlcType,
                    IssuedVisitorCardNo: admissionDetails.IssuedVisitorCardNo,
                    Admission_Type: admissionDetails.admissionType,
                    Source: admissionDetails.referSource,
                    RequestedRoomType: admissionDetails.requestRoomType,
                    IPDCaseTypeID_Bill: admissionDetails.roomBilling,//
                    TimeOfAdmit: admissionDetails.admissionTime,
                    AdmissionReason: admissionDetails.AdmissionReason,
					KinRelation: patientDetails.Relation.text,
                    KinName: patientDetails.RelationName,
                    KinPhone: patientDetails.RelationPhoneNo,
                    ReferralTypeID: patientDetails.ReferralTypeID,  //
                    ReferedBy: patientDetails.ReferedBy    //
                }
                callback({ data: data, doctors: admissionDetails.doctorsList });
            });
			});
        }

        $(function () {
            shortcut.add('Alt+S', function () {
                var btnSave = $('#btnSave');
                if (btnSave.length > 0) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        onSaveAdmissionDetaills(btnSave[0]);
                    }
                }
            }, addShortCutOptions);
        });


    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b><span id="lblHeader" style="font-weight: bold;">IPD Admission</span></b>
            <span style="display: none" id="spnHashCode"></span>
            <asp:Label ID="lblIpdAdmissionAgainstAdvanceBooking" runat="server" ClientIDMode="Static" Style="display: none;" />
            <asp:Label ID="lblAdvanceId" runat="server" ClientIDMode="Static" Style="display: none;" />
        </div>
        <UC1:OldPatientSearchControl ID="patientInfo" runat="server" />
        <div class="POuter_Box_Inventory">
            <UC2:AdmissionDetailsControl ID="admissionDetails" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" style="width: 100px; margin-top: 7px" id="btnSave" onclick="onSaveAdmissionDetaills($('#btnSave'))" class="ItDoseButton" value="Save" />

        </div>
    </div>
</asp:Content>

