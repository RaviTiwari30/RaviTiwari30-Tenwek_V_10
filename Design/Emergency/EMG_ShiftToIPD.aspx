<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EMG_ShiftToIPD.aspx.cs" Inherits="Design_Emergency_EMG_ShiftToIPD" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/MarcTooltips.js"></script>
    <link href="../../Styles/MarcTooltips.css" rel="stylesheet" />
    <script type="text/javascript">
        var EmergencyPatientDetails = [];
        $(document).ready(function () {
            $getHashCode(function () {
                $loadPatientDetails(function () {
                    $bindRoomType(function () {
                        $bindBillingCategory(function () {
                            $bindDoctor(function () {
                            });
                        });
                    });
                });
            });
        });
        $loadPatientDetails = function (callback) {
            $EMGNo = "<%=Request.QueryString["EMGNo"].ToString()%>";
            serverCall('../Emergency/Services/EmergencyBilling.asmx/getEmergencyPatientDetails', { EmergencyNo: $EMGNo }, function (response) {
                if (jQuery.parseJSON(response) == null)
                    location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Shifted To IPD.'
                    else
                {
                    EmergencyPatientDetails = jQuery.parseJSON(response)[0];

                     if (EmergencyPatientDetails.Status != 'RFI')
                         location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Yet Not Released for IPD.';
                     else if (EmergencyPatientDetails.BillNo != '')
                         location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Bill Has Been Generated.'
                    else
                        callback(true);
                }
            });
        }
        $bindRoomType = function (callback) {
            $ddlRoomType = $('#ddlRoomType');
            $ddlRequestRoomType = $('#ddlRequestRoomType');
            serverCall('../IPD/Services/IPDAdmission.asmx/bindRoomType', {}, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    $ddlRoomType.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'IPDCaseTypeID', textField: 'Name', });
                    $ddlRequestRoomType.bindDropDown({ data: JSON.parse(response), defaultValue: 'No', valueField: 'IPDCaseTypeID', textField: 'Name', });
                    callback($ddlRoomType.val());
                }
                else {
                    $ddlRoomType.empty();
                    $ddlRequestRoomType.empty();
                    callback($ddlRoomType.val());
                }
            });
        };
        var $bindRoomBed = function (roomType, callback) {
            $ddlRoomNo = $('#ddlRoomNo');
            getCurrentDate(function (CurDate) {
                serverCall('../IPD/Services/IPDAdmission.asmx/bindRoomBed', { caseType: roomType, IsDisIntimated: '0', type: $("#lblAdvanceRoomBooking").length, bookingDate: CurDate }, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        $ddlRoomNo.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'RoomID', textField: 'Name' });
                        $('#ddlRoomBilling').val($.trim(roomType));
                        callback($ddlRoomNo.val());
                    }
                    else {
                        $ddlRoomNo.empty();
                        callback($ddlRoomNo.val());
                    }
                });
            });
        };

        $bindBillingCategory = function (callback) {
            $ddlRoomBilling = $('#ddlRoomBilling');
            serverCall('../IPD/Services/IPDAdmission.asmx/bindBillingCategory', {}, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    $ddlRoomBilling.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'IPDCaseTypeID', textField: 'Name', });
                    callback($ddlRoomBilling.val());
                }
                else {
                    $ddlRoomBilling.empty();
                    callback($ddlRoomBilling.val());
                }
            });
        }

        $bindDoctor = function (callback) {
            ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: 'ALL' }, function (response) {
                ddlDoctor.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback(ddlDoctor.val());
            });
        }
        var getCurrentDate = function (callback) {
            serverCall('EmergencyAdmission.aspx/getCurrentDate', {}, function (response) {
                callback(response);
            });
        }
        var $getHashCode = function (callback) {
            serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
                $('#spanHashCode').text(response);
                callback(true);
            });
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Shift Emergency To IPD</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <span id="spanHashCode" style="display:none;"></span>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Room Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlRoomType" onchange="$bindRoomBed(this.value,function(){})" title="Select Room Type" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Room/Bed No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlRoomNo" title="Select Bed No" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Billing Category
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlRoomBilling" title="Select Billing Category" class="requiredField"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                   Doctor
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDoctor" class="requiredField"></select>
                            </div>
                            </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align: center;">
                    <input type="button" value="Shift Patient" onclick="$shiftPatient(this)" />
                </div>
            </div>


        </div>

    </form>
    <script>
        $shiftPatient = function (btn) {
            if ($('#ddlRoomType').val() == "0") {
                modelAlert('Please Select Room Type', function () {
                    $('#ddlRoomType').focus();
                });
                return false;
            }
            if ($('#ddlRoomNo').val() == "0") {
                modelAlert('Please Select Room/Bed No.', function () {
                    $('#ddlRoomNo').focus();
                });
                return false;
            }
            if ($('#ddlRoomBilling').val() == "0") {
                modelAlert('Please Select Billing Type', function () {
                    $('#ddlRoomBilling').focus();
                });
                return false;
            }
            if ($('#ddlDoctor').val() == "0") {
                modelAlert('Please Select Doctor', function () {
                    $('#ddlDoctor').focus();
                });
                return false;

            }
            modelConfirmation('Alert!!!', 'Do You Want To Shift in IPD ?', 'Shift', 'Close', function (response) {
                if (response) {
                    var data = {
                        LTnxNo: EmergencyPatientDetails.LTnxNo,
                        PID: EmergencyPatientDetails.PatientID,
                        oldTID: EmergencyPatientDetails.TID,
                        oldRoomId: EmergencyPatientDetails.RoomId,
                        newRoomId: $('#ddlRoomNo').val(),
                        newBillCategory: $('#ddlRoomBilling').val(),
                        IPDCaseTypeId: $('#ddlRoomType').val(),
                        HashCode: $('#spanHashCode').text(),
                        doctorID: $('#ddlDoctor').val(),
                    };
                    serverCall('Services/EmergencyBilling.asmx/ShiftToIPD', data, function (response) {
                        var $responseData = JSON.parse(response);
                        modelAlert($responseData.response, function () {
                            if ($responseData.status) {
                                window.open('../../Design/IPD/PatientAdmissionPrintOut.aspx?TID=' + $responseData.IPDNO + '&PID=' + $responseData.patientID + '');
                               // window.open('../../Design/IPD/IPDConsentFromPrintout.aspx?TID=' + $responseData.IPDNO + '&PID=' + $responseData.patientID + '');
                               // window.open('../../Design/IPD/AttendantPass.aspx?TID=' + $responseData.IPDNO + '');
                                location.reload();
                            }
                        });
                    });


                }
            });


        }
    </script>
</body>
</html>
