<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EMG_BedShift.aspx.cs" Inherits="Design_Emergency_EMG_BedShift" %>

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
            $bindEmergencyRoomType(function () {
                    $EMGNo = "<%=Request.QueryString["EMGNo"].ToString()%>";
                     serverCall('../Emergency/Services/EmergencyBilling.asmx/getEmergencyPatientDetails', { EmergencyNo: $EMGNo }, function (response) {
                         if (jQuery.parseJSON(response) == null)
                             location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Shifted To IPD.'
                         else {
                             EmergencyPatientDetails = jQuery.parseJSON(response)[0];
                             if (EmergencyPatientDetails.Status == 'OUT')
                                 location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released.';
                             else if (EmergencyPatientDetails.BillNo != '')
                                 location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Bill Has Been Generated.'
                             else if (EmergencyPatientDetails.Status == "RFI")
                                 location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released for IPD.';
                             else
                                 $('#spnCurrentBed').text(EmergencyPatientDetails.Room);
                         }
                     });
             });
         });

        $bindEmergencyRoomType = function (callback) {
            $ddlRoomType = $('#ddlRoomType');
            serverCall('EmergencyAdmission.aspx/bindEmergencyRoomType', {}, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    $ddlRoomType.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'IPDCaseTypeID', textField: 'Name', });
                    callback($ddlRoomType.val());
                }
                else {
                    $ddlRoomType.empty();
                    callback($ddlRoomType.val());
                }
            });
        }
        var $bindRoomBed = function (roomType, callback) {
            $ddlRoomNo = $('#ddlRoomNo');
            getCurrentDate(function (CurDate) {
                serverCall('../IPD/Services/IPDAdmission.asmx/bindRoomBed', { caseType: roomType, IsDisIntimated: '0', type: $("#lblAdvanceRoomBooking").length, bookingDate: CurDate }, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        $ddlRoomNo.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'RoomID', textField: 'Name' });
                        $('#ddlRoomBilling').val(roomType.trim());
                        callback($ddlRoomNo.val());
                    }
                    else {
                        $ddlRoomNo.empty();
                        callback($ddlRoomNo.val());
                    }
                });
            });
        }
        var getCurrentDate = function (callback) {
            serverCall('EmergencyAdmission.aspx/getCurrentDate', {}, function (response) {
                callback(response);
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Emergency Bed Shift</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Current Bed
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                               <span id="spnCurrentBed" style="color:#d01515;font-weight:bold;"></span>
                            </div>
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
                                   Room/BedNo
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlRoomNo" title="Select Bed No" class="requiredField"></select>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align:center">
                <input type="button" value="Save" style="width:100px;margin-top:7px;" onclick="$ShiftBed(this)" />
                </div>
        </div>

    </form>
</body>
    <script>
        $ShiftBed = function (btn) {
            if ($('#ddlRoomType').val() == "0") {
                modelAlert('Please Select Room Type');
                return false;
            }
            if ($('#ddlRoomNo').val() == "0")
            {
                modelAlert('Please Select Room/Bed No');
                return false;
            }
            $(btn).attr('disabled', 'disabled');
            var data = { TID: EmergencyPatientDetails.TID, LtnxNo: EmergencyPatientDetails.LTnxNo, oldRoomId: EmergencyPatientDetails.RoomId, newRoomType: $('#ddlRoomType').val(), newRoomId: $('#ddlRoomNo').val(), DoctorId: EmergencyPatientDetails.DoctorID, PanelId: EmergencyPatientDetails.PanelID };
            serverCall('Services/EmergencyBilling.asmx/shiftEmergencyBed',data, function (response) {
                var $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    if ($responseData.status) {

                        window.location.reload();
                    }
                    else
                        $(btn).removeAttr('disabled').val('Save');

                });
            });
        }

    </script>
</html>
