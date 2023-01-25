<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AdvanceRoomBooking.aspx.cs" Inherits="Design_IPD_AdvanceRoomBooking" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="OldPatientSearchControl" TagPrefix="UC1" %>
<%@ Register Src="~/Design/Controls/UCAdmissionBedDetails.ascx" TagName="AdmissionDetailsControl" TagPrefix="UC2" %>
<%@ Register Src="~/Design/Controls/UCPanel.ascx" TagName="PanelDetailsControl" TagPrefix="UC3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('input').keyup(function () {
                if (event.keyCode == 13)
                    if ($(this).val() != "")
                        $searchOldPatientDetail();
            });
            $panelControlInit(function () {
                $bindMandatory(function () {
                    $commonJsInit(function () {
                        $pageInit(function () {
                            $IPDAdmissionDetailsControlInit(function () {
                                $bindDoctor('ALL', function () { });
                            });
                        });
                    });
                });
            });
        });

        $bindMandatory = function (callBack) {
            var manadatory = [
                { control: '#txtAdmissionDate', erroMessage: 'Please Select Admission Date', tabIndex: 4, isSearchAble: false },
                { control: '#ddlRoomType', erroMessage: 'Please Select Room Type', tabIndex: 5, isSearchAble: false },
             //   { control: '#ddlRoomNo', erroMessage: 'Please Select Room NO', tabIndex: 6, isSearchAble: false },
                { control: '#ddlRoomBilling', erroMessage: 'Please Select Room Billing', tabIndex: 7, isSearchAble: false },
                //{ control: '#ddlDoctor', erroMessage: 'Please Select Doctor', tabIndex: 8, isSearchAble: true }
            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass('requiredField');
                if (item.isSearchAble)
                    $(item.control + '_chosen a').addClass('requiredField').attr('tabindex', item.tabIndex);
                $(manadatory[0].control).focus();
            });
            callBack(true);
        }

        $pageInit = function (callBack) {
            $('.doctorName,.mlcDetail').hide();
            $('#dvPatient,#dvAdmission1,#dvCommand,#dvAdmission3').hide();
            $('#btnStatus').hide();
            $('#txtIssuedVisitorCardNo,#ddlRequestRoomType,#ddlPro,#btnPROName').attr('disabled', 'disabled');
            callBack(true);
        }

        $bindDoctor = function (department, callBack) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callBack(true);
            });
        }

        $showOldPatientSearchModel = function () {
            $('#oldPatientModel .modal-body').find('input[type=text]').not('#txtSearchModelFromDate,#txtSerachModelToDate').val('');
            $('#oldPatientModel').showModel();
        }

        $searchOldPatientDetail = function () {
            var data = {
                PatientID: $('#txtSearchModelMrNO').val(),
                PName: $('#txtSearchModelFirstName').val(),
                LName: $('#txtSearchModelLastName').val(),
                ContactNo: $('#txtSerachModelContactNo').val(),
                Address: $('#txtSearchModelAddress').val(),
                FromDate: $('#txtSearchModelFromDate').val(),
                ToDate: $('#txtSerachModelToDate').val(),
                PatientRegStatus: 1,
                isCheck: '0',
                IDProof: '',
                MembershipCardNo: '',
                DOB: '',
                IsDOBChecked: '0',
                Relation: '',
                RelationName: '',
                IPDNO: $('#txtIPDNo').val(),
                panelID: '',
                cardNo: '',
                visitID: '',
                emailID: '',
                patientType: '2',
                FamilyNo: ''
            }
            getOldPatientDetails(data, function (response) {
                bindOldPatientDetails(response);
            });
        }

        var _PageSize = 9;
        var _PageNo = 0;
        var bindOldPatientDetails = function (data) {
            if (!String.isNullOrEmpty(data)) {
                OldPatient = JSON.parse(data);
                if (OldPatient != null) {
                    _PageCount = OldPatient.length / _PageSize;
                    showPage(0);
                }
                else {
                    $('#divSearchModelPatientSearchResults').html('');
                }
            }
            else
                $('#divSearchModelPatientSearchResults').html('');
        }

        var getOldPatientDetails = function (data, callback) {
            serverCall('../Common/CommonService.asmx/oldPatientSearch', data, function (response) {
                callback(response);
            });
        }

        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
            $('#divSearchModelPatientSearchResults').html(outputPatient);
        }

        $closeOldPatientSearchModel = function () {
            $('#oldPatientModel').hideModel();
        }

        var onPatientSelect = function (elem) {
            $searchPatient({ PatientID: $.trim($(elem).closest('tr').find('#tdPatientID').text()), PatientRegStatus: 1 },
            $(elem).find('#spnIPDDetails').text(),
            $(elem).find('#spnAdvRoomBookingDetails').text(),
            $.trim($(elem).closest('tr').find('#tdGender').text()),
            function (response) {
                $bindPatientDetails(response, function () { });
            });
        }

        $searchPatient = function (data, IPDDetails, AdvRoomBookingDetails, gender, callback) {
            var patientIPDDetails = {
                IPDTransactionID: IPDDetails.split('#')[0],
                IPDAdmissionRoomType: IPDDetails.split('#')[1],
                gender: gender
            }
            var advRoomBookingDetails = {
                BookingDate: AdvRoomBookingDetails.split('#')[0],
                RoomType: AdvRoomBookingDetails.split('#')[1],
                RoomName: AdvRoomBookingDetails.split('#')[2]
            }
            validatePatientSelection(patientIPDDetails, advRoomBookingDetails, function () {
                $patientSearchByPatientId(data, function (response) {
                    callback(response);
                });
            });
        }

        var validatePatientSelection = function (patientDetails, advRoomBookingDetails, callback) {
            var pageName = window.location.href.split('/')[window.location.href.split('/').length - 1];
            if (!String.isNullOrEmpty(patientDetails.IPDTransactionID) && patientDetails.gender.toLowerCase() == 'female' && pageName == 'IPDAdmissionNew.aspx') {
                modelConfirmation('Do You Want To Admit her Child ?', 'Patient is Already Admited </br><span style="color: black;"> With IPD NO. :<span> &nbsp;<span style="color: blue;"> ' + patientDetails.IPDTransactionID.replace('ISHHI', '') + '</span></br><span style="color: black;">IN Room Type :</span>&nbsp; <span style="color: blue;">' + patientDetails.IPDAdmissionRoomType + '</span>', 'Admit Child', 'Close', function (response) {
                    if (response) {
                        $('#spnIPDNo').text(patientDetails.IPDTransactionID.replace('ISHHI', '')).parent().show();
                        callback(response);
                    }
                });
            }
            else {
                if (!String.isNullOrEmpty(patientDetails.IPDTransactionID)) {
                    modelConfirmation('<span style="color: red;">Patient is Already Admited !</span>', '<span style="color: black;"> With IPD NO. :<span> &nbsp;<span style="color: blue;"> ' + patientDetails.IPDTransactionID.replace('ISHHI', '') + '</span></br><span style="color: black;">IN Room Type :</span>&nbsp; <span style="color: blue;">' + patientDetails.IPDAdmissionRoomType + '</span>', '', 'Close', function (response) {
                        if (pageName == 'Lab_PrescriptionOPD.aspx' || pageName == 'DirectPatientReg.aspx')
                            callback(true);
                    });
                }
                else if (!String.isNullOrEmpty(advRoomBookingDetails.BookingDate)) {
                    modelConfirmation('<span style="color: red;">Room Already Booked For Patient !</span>', '<span style="color: black;"> Booking Date :<span> &nbsp;<span style="color: blue;"> ' + advRoomBookingDetails.BookingDate + '</span></br><span style="color: black;">Room Type :</span>&nbsp; <span style="color: blue;">' + advRoomBookingDetails.RoomType + '</span></br><span style="color: black;">Room Name :</span>&nbsp; <span style="color: blue;">' + advRoomBookingDetails.RoomName + '</span>', '', 'Close', function (response) {
                    });
                }
                else {
                    $('#spnIPDNo').text('').parent().hide();
                    callback(true);
                }
            }
        }

        var $patientSearchByPatientId = function (data, callback) {
            if (data.PatientID != "") {
                getPatientOutStanding(data.PatientID, function () {
                    serverCall('../Common/CommonService.asmx/PatientSearchByBarCode', data, function (response) {
                        $responseData = JSON.parse(response)
                        if ($responseData.length > 0)
                            callback($responseData[0]);
                    });
                });
            }
        }

        var getPatientOutStanding = function (patientID, callback) {
            serverCall('../Common/CommonService.asmx/PatientOutstanding', { PatientID: patientID }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var blanceAmount = response.replace(' ', ':').split(':');
                    var message = '<div class="row"><div class="col-md-18"><label class="pull-left">Balance Amount (OPD)</label><b class="pull-right">:</b></div><div class="col-md-6 pull-left"><label class="pull-right">' + blanceAmount[1] + '</label></div></div>';
                    message += '<div class="row"><div class="col-md-18"><label class="pull-left">Balance Amount (IPD)</label><b class="pull-right">:</b></div><div class="col-md-6 pull-left"><label class="pull-right">' + blanceAmount[3] + '</label></div></div>';
                    modelConfirmation('Balance Amount Confirmation ?', message, 'Continue', 'Cancel', function (response) {
                        if (response)
                            callback();
                    });
                }
                else
                    callback();
            });
        }

        var patientSearchOnEnter = function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13) {
                var data = { PatientID: '', PName: '', LName: '', ContactNo: '', Address: '', FromDate: '', ToDate: '', PatientRegStatus: 1, isCheck: '0', IDProof: '', MembershipCardNo: '', DOB: '', IsDOBChecked: 0, Relation: '', RelationName: '', IPDNO: '', panelID: '', cardNo: '', visitID: '', emailID: '' };
                if (e.target.id == 'txtBarcode')
                    data.PatientID = e.target.value;

                getOldPatientDetails(data, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        var resultData = JSON.parse(response);
                        if (resultData.length > 1) {
                            bindOldPatientDetails(response);
                            $showOldPatientSearchModel()
                        }
                        else {
                            var patientIPDDetails = {
                                IPDTransactionID: resultData[0].IPDDetails.split('#')[0],
                                IPDAdmissionRoomType: resultData[0].IPDDetails.split('#')[1],
                                gender: resultData[0].Gender
                            }
                            var advRoomBookingDetails = {
                                BookingDate: resultData[0].AdvRoomBookingDetails.split('#')[0],
                                RoomType: resultData[0].AdvRoomBookingDetails.split('#')[1],
                                RoomName: resultData[0].AdvRoomBookingDetails.split('#')[2]
                            }
                            validatePatientSelection(patientIPDDetails, advRoomBookingDetails, function () {
                                $patientSearchByPatientId({ PatientID: resultData[0].MRNo, PatientRegStatus: 1 }, function (response) {
                                    $bindPatientDetails(response, function () { });
                                });
                            });
                        }
                    }
                    else
                        modelAlert('No Record Found');
                });
            }
        }

        $patientSearchOnButtonClick = function () {
            var data = {
                PatientID: '',
                PName: '',
                LName: '',
                ContactNo: '',
                Address: '',
                FromDate: '',
                ToDate: '',
                PatientRegStatus: 1,
                isCheck: '0',
                IDProof: '',
                MembershipCardNo: '',
                DOB: '',
                IsDOBChecked: 0,
                Relation: '',
                RelationName: '',
                IPDNO: '',
                panelID: '',
                cardNo: '',
                visitID: '',
                emailID: ''
            };
            var $patientID = $('#txtMRNo');
            var $barcode = $('#txtBarcode');
            if ($patientID.val().trim() != '')
                data.PatientID = $patientID.val().trim();
            else if ($barcode.val().trim() != '') {
                data.PatientID = $barcode.val().trim();
            }
            else {
                modelAlert('Please Enter UHID');
                return;
            }

            getOldPatientDetails(data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var resultData = JSON.parse(response);
                    if (resultData.length > 1) {
                        bindOldPatientDetails(response);
                        $showOldPatientSearchModel()
                    }
                    else {
                        var patientIPDDetails = {
                            IPDTransactionID: resultData[0].IPDDetails.split('#')[0],
                            IPDAdmissionRoomType: resultData[0].IPDDetails.split('#')[1],
                            gender: resultData[0].Gender
                        }
                        var advRoomBookingDetails = {
                            BookingDate: resultData[0].AdvRoomBookingDetails.split('#')[0],
                            RoomType: resultData[0].AdvRoomBookingDetails.split('#')[1],
                            RoomName: resultData[0].AdvRoomBookingDetails.split('#')[2]
                        }
                        validatePatientSelection(patientIPDDetails, advRoomBookingDetails, function () {
                            $patientSearchByPatientId({ PatientID: resultData[0].MRNo, PatientRegStatus: 1 }, function (response) {
                                $bindPatientDetails(response, function () { });
                            });
                        });
                    }
                }
                else
                    modelAlert('No Record Found');
            });
        }

        var $bindPatientDetails = function (data, callback) {
            $("#spnPName").text(data.Title + ' ' + data.PFirstName);
            $("#spnPatientID").text(data.PatientID);
            $("#spnAge").text(data.Age + " / " + data.Gender);
            $("#spnContactNo").text(data.Mobile);
            $("#spnAddress").text(data.House_No + " " + data.City + " " + data.District);
            $("#dvPatient,#dvAdmission1,#dvCommand,#dvAdmission3").show();
            $("#ddlRomType").focus();
            $closeOldPatientSearchModel();
            callback(true);
        }

        var $getAdvanceRoomBookingDetails = function (callback) {
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
                $getPanelDetails(function (panelDetails) {
                    $getAdmissionDetails(function (admissionDetails) {
                        getPanelUploadedDocuments(function (panelDocuments) {
                            $bookingDetails = {
                                PatientID: $('#spnPatientID').text().trim(),
                                BookingDate: admissionDetails.admissionDate,
                                IPDCaseType_ID: admissionDetails.roomType,
                                Room_ID: admissionDetails.roomNo,
                                IPDCaseType_ID_Bill: admissionDetails.roomBilling,
                                DoctorID: '',
                                Remarks: admissionDetails.AdmissionReason,
                                EntryBy: $('#lblUserID').text().trim(),
                                PanelID: panelDetails.panel.panelID,
                                ApprovalAmount: Number($('#txtApprovalAmount').val()),
                                PolicyNo: panelDetails.policyNo,
                                ExpiryDate: panelDetails.expireDate,
                                PolicyCardNo: panelDetails.cardNo,
                                NameOnCard: panelDetails.nameOnCard,
                                CardHolder: panelDetails.cardHolderRelation,
                                IgnorePolicy: panelDetails.ignorePolicy ? 1 : 0,
                                IgnorePolicyReason: panelDetails.ignorePolicy,
                                ApprovalAmount: panelDetails.approvalAmount,
                                ApprovalRemark: panelDetails.approvalRemark,
                                admissionType: admissionDetails.admissionType,
                                referedSource: admissionDetails.referSource,
                            };

                            var IsAdvance = 0;
                            console.log({ bookingDetails: [$bookingDetails] });
                            callback({ bookingDetails: [$bookingDetails], panelDocuments: panelDetails.panelDocuments });
                        });
                    });
                });
            }
        }

        $printBookingReport = function (data, callback) {
            serverCall('Services/AdvanceRoomBooking.asmx/RoomBookingPrintOut', data, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    window.open('../../Design/common/Commonreport.aspx');
                    callback();
                    //  window.location.reload();
                }
            });
        }

        $saveAdvanceRoomBookingDetails = function () {
            $getAdvanceRoomBookingDetails(function (bookingDetails) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/AdvanceRoomBooking.asmx/SaveAdvanceRoomBooking', bookingDetails, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {

                        if ($responseData.PanelID != '1') {
                            modelAlert($responseData.response, function () {
                                sendPanelApprovalConfirmation({ patientID: bookingDetails.bookingDetails[0].PatientID, booking_ID: $responseData.booking_ID, transactionID: '' }, function () {

                                });
                            });
                        }
                        else {
                            modelAlert($responseData.response, function () {
                                securityDepositConfirmation($responseData, function (s) { });
                            });
                        }
                    }
                    else {
                        modelAlert($responseData.response, function () {
                            $(btnSave).removeAttr('disabled').val('Save');
                        });
                    }
                });
            });
        }





        var securityDepositConfirmation = function ($responseData) {
            $printBookingReport({ booking_ID: $responseData.booking_ID, userID: $('#lblUserID').text().trim() }, function () {
                modelConfirmation('Patient Advance Deposit Confirmation ?', 'Continue With Patient Advance Deposit Against </br><span class="patientInfo"> UHID No. ' + $responseData.patientID + '</span>', 'Yes Continue', 'Cancel', function (res) {
                    if (res)
                        location.href = '../OPD/OPDAdvance.aspx?IsAdvanceRoomBookingAmountUpdate=1&PatientID=' + $responseData.patientID + '&AdvanceBookingId=' + $responseData.booking_ID;
                    else {
                        window.location.reload();

                    }
                });
            });
        }



        var getApprovalEmailToPanel = function (callback) {
            $getPanelDetails(function (panelDetails) {
                var data = {
                    transactionID: '',
                    patientID: '',
                    panelID: panelDetails.panel.panelID,
                    approvalAmount: panelDetails.approvalAmount,
                    approvalRemark: panelDetails.approvalRemark,
                    policyNumber: panelDetails.policyNo,
                    policyCardNumber: panelDetails.cardNo,
                    policyExpiryDate: panelDetails.expireDate,
                    panelDocuments: panelDetails.panelDocuments,
                }
                callback(data);
            });
        }



        var sendPanelApprovalConfirmation = function (responseData, callback) {
            var c = callback;
            modelConfirmation('Approval Email Confirmation ?', 'Are You Want to Send Email.', 'Yes Send', 'Cancel', function (response) {
                if (response) {
                    modelConfirmation('Are you Sure ?', 'To Attach Cost Estimation .', 'Yes Continue', 'Cancel', function (res) {
                        sendApprovalEmailToPanel(responseData, res, function (res) {
                            securityDepositConfirmation(responseData, function (s) { });
                        });
                    });
                }
                else
                    securityDepositConfirmation(responseData, function (s) { });
            });
        }





        var sendApprovalEmailToPanel = function ($responseData, attachCostEstimation, callback) {
            getApprovalEmailToPanel(function (data) {
                data.transactionID = $responseData.transactionID;
                data.patientID = $responseData.patientID;
                data.attachCostEstimation = attachCostEstimation;
                serverCall('Services/IPDAdmission.asmx/SendPanelApprovalEmail', { panelApprovalDetails: data, isAdvanceRoomBooking: true }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        callback(responseData);
                    });
                });
            });
        }




    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Advance Room Booking<br />
            </b>
            <span id="spnRoomName" style="display: none;"></span>
            <span id="spnBookDate" style="display: none;"></span>
            <asp:Label ID="lblAdvanceRoomBooking" runat="server" ClientIDMode="Static" Style="display: none;" />
            <asp:Label ID="lblUserID" runat="server" ClientIDMode="Static" Style="display: none;" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">

                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><strong>Barcode</strong></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBarcode" maxlength="20" title="Enter BarCode" onkeyup="patientSearchOnEnter(event)" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtMRNo" value="" maxlength="20" title="Enter UHID" />
                        </div>
                        <div class="col-md-5" style="text-align:center">  <input type="button" id="btnSearch" class="margin-top-on-btn" onclick="$patientSearchOnButtonClick();" value="Search" title="Click To Search" /></div>
                        <div class="col-md-3" style="text-align:center">
                            <input type="button" id="btnOldPatient" class="pull-left ItDoseButton" value="Old Patient Search" title="Click To Search Old Patient" onclick="$showOldPatientSearchModel()" style="display: <%=GetGlobalResourceObject("Resource", "OldPatientLink") %>" />
                        </div>
                    </div>
                </div>
                <div class="col-md-3"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="dvPatient" style="display: none">
            <div class="Purchaseheader">
                Patient Details
            </div>
            <div class="row">

                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnPatientID" class="pull-left ItDoseLabelBl"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnPName" class="pull-left ItDoseLabelBl"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Age / Sex</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnAge" class="pull-left ItDoseLabelBl"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Contact No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnContactNo" class="pull-left ItDoseLabelBl"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnAddress" class="pull-left ItDoseLabelBl"></span>
                        </div>
                        <%-- <div class="col-md-3">
                            <label class="pull-left">Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"></div>--%>
                    </div>
                </div>
                <div class="col-md-3"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="display: none" id="dvAdmission1">
            <div class="Purchaseheader">
                Room Details
            </div>
            <UC2:AdmissionDetailsControl ID="admissionDetails" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="display: none" id="dvAdmission2">
            <div class="row">

                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3 hidden">
                            <label class="pull-left">Doctor</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 hidden">
                            <select id="ddlDoctor" title="Select Doctor"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtRemarks" title="Enter Remarks" style="height: 50px; width: 215px;" rows="5" onlytextnumber="500"></textarea>
                        </div>
                        <div class="col-md-3"></div>
                        <div class="col-md-5">
                            <input id="btnStatus" type="button" class="ItDoseButton" value="View Room Status" title="Click To View Booking Status" />
                        </div>
                    </div>
                </div>
                <div class="col-md-3"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="display: none" id="dvAdmission3">
            <div class="Purchaseheader">
                Panel Details
            </div>
            <div class="col-md-21">
                <UC3:PanelDetailsControl ID="admissionPanelDetails" runat="server" />
            </div>
            <div class="col-md-3"></div>
        </div>

        


        <div class="POuter_Box_Inventory textCenter" style="display: none" id="dvCommand">
            <input type="button" id="btnSave" value="Save" class="save margin-top-on-btn" title="Click To Save" onclick="$saveAdvanceRoomBookingDetails();" />
        </div>
    </div>

    <div id="oldPatientModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 900px">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closeOldPatientSearchModel()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Old Patient Search</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">

                            <input type="text" id="txtSearchModelMrNO" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">IPD No.</label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" maxlength="10" autocomplete="off" id="txtIPDNo" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">First Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" onlytext="50" id="txtSearchModelFirstName" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Last Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" onlytext="50" id="txtSearchModelLastName" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Contact No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" onlynumber="10" id="txtSerachModelContactNo" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" id="txtSearchModelAddress" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div style="text-align: center" class="row">
                        <button type="button" onclick="$searchOldPatientDetail()">Search</button>
                    </div>
                    <div style="height: 200px" class="row">
                        <div id="divSearchModelPatientSearchResults" class="col-md-24"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: orange" class="circle"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Admited Patients</b>
                    <button type="button" onclick="$closeOldPatientSearchModel()">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script id="tb_OldPatient" type="text/html">
        <table  id="tablePatient" cellspacing="0" rules="all" border="1" style="width:876px;border-collapse :collapse;">
            <thead>
                <tr id="Header">
                    <th class="GridViewHeaderStyle" scope="col" >Select</th>
                    <th class="GridViewHeaderStyle" scope="col" >Title</th>
                    <th class="GridViewHeaderStyle" scope="col" >First Name</th>
                    <th class="GridViewHeaderStyle" scope="col" >L.Name</th>
                    <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                    <th class="GridViewHeaderStyle" scope="col" >Age</th>
                    <th class="GridViewHeaderStyle" scope="col" >Sex</th>
                    <th class="GridViewHeaderStyle" scope="col" >Date</th>
                    <th class="GridViewHeaderStyle" scope="col" >Address</th>
                    <th class="GridViewHeaderStyle" scope="col" >Contact&nbsp;No.</th> 
                    <th class="GridViewHeaderStyle" scope="col" >Card No.</th> 
                    <th class="GridViewHeaderStyle" scope="col" >Valid To</th> 
                </tr>
            </thead>
            <tbody>
            <#           
                var dataLength=OldPatient.length;
                if(_EndIndex>dataLength){           
                   _EndIndex=dataLength;
                }

                for(var j=_StartIndex;j<_EndIndex;j++)
                {           
                    var objRow = OldPatient[j];
            #>              
                <tr onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=j+1#>" ondblclick="onPatientSelect(this);" style='cursor:pointer;<#=objRow.IPDDetails!=''?'background-color:orange':'' #>'>                            
                    <td class="GridViewLabItemStyle">
                        <a class="btn" onclick="onPatientSelect(this);" style="cursor:pointer;padding:0px;font-weight:bold;width:60px">
                            Select
                            <span style="display:none" id="spnIPDDetails"><#=objRow.IPDDetails#></span>
                            <span style="display:none" id="spnAdvRoomBookingDetails"><#=objRow.AdvRoomBookingDetails#></span>
                        </a>
                    </td>                                                    
                    <td  class="GridViewLabItemStyle" id="tdTitle"  ><#=objRow.Title#></td>
                    <td class="GridViewLabItemStyle" id="tdPFirstName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PFirstName#></td>
                    <td class="GridViewLabItemStyle" id="tdPLastName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PLastName#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID"  ><#=objRow.MRNo#></td>
                    <td class="GridViewLabItemStyle" id="tdAge" ><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" id="tdGender" ><#=objRow.Gender#></td>
                    <td class="GridViewLabItemStyle" id="tdDate" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.Date#></td>
                    <td class="GridViewLabItemStyle" id="tdHouseNo" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"  ><#=objRow.SubHouseNo#></td>
                    <td class="GridViewLabItemStyle" id="tdContactNo" ><#=objRow.ContactNo#></td>  
                    <td class="GridViewLabItemStyle" id="tdCardNo" ><#=objRow.MemberShipCardNo#></td>   
                    <td class="GridViewLabItemStyle" id="tdValidTo" ><#=objRow.MemberShipValidTo#></td>                    
                    <td class="GridViewLabItemStyle" id="tdPatientRegStatus" style="width:80px;display:none"><#=objRow.PatientRegStatus#></td>                         
                </tr>            
            <#}#>
            </tbody>      
        </table>  
        <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
                <tr>
                <# if(_PageCount>1) {
                    for(var j=0;j<_PageCount;j++){ #>
                    <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
                <#  }         
                } #>
                </tr>     
        </table>  
    </script>


    
    


</asp:Content>

