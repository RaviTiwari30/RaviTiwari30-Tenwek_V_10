<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FollowUpnew.aspx.cs" Inherits="Design_CPOE_FollowUpNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    

</head>
<body>
     <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
        <script type="text/javascript">

            function Appoinment() {
                $('#lblMsg').text('');
                var $appointmentDate = $('#txtdate').val();
                var $DoctorID = $('#ddlAppointmentType').val();
                $validateAppointmenSlotData($appointmentDate, true, 0, function (data) {
                    $getDoctorAppointmentTimeSlot(data.appointmentDate, data.doctorId, data.isManualSlot, true, function (response) {
                    });
                });
            }
            $(document).ready(function () {
                $bindDoctor();
                $bindVisitType();
            });

            var $bindDoctor = function () {
                serverCall('../common/CommonService.asmx/bindDoctor', {}, function (response) {
                    $ddlDoctor = $('#ddlDoctor');
                    $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                });
            }

            var $validateAppointmenSlotData = function (appointmentDate, isAlertError, isManualSlot, callback) {
                $data = {
                    appointmentDate: $.trim(appointmentDate),
                    doctorId: $.trim($('#ddlDoctor').val()),
                    referenceCodeOPD: '78',
                    subCategoryID: $.trim($('#ddlAppointmentType').val()),
                    isManualSlot: isManualSlot
                }

                if (String.isNullOrEmpty($data.appointmentDate)) {
                    if (isAlertError)
                        //modelAlert('Select Appointment Date');
                        $('#lblMsg').text('Select Follow up Date');
                    return;
                }
                callback($data);
            }

            var $bindVisitType = function () {
                serverCall('../common/CommonService.asmx/bindAppVisitType', {}, function (response) {
                    $ddlAppointmentType = $('#ddlAppointmentType');
                    $ddlAppointmentType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                });
            }


            var $getDoctorAppointmentTimeSlot = function (appointmentDate, doctorID, isManualSlot, isModelShow, callback) {

                serverCall('FollowUpnew.aspx/GetAvaibality', { DoctorID: doctorID, Date: appointmentDate }, function (response) {
                    var $responseData = JSON.parse(response);

                    if ($responseData.status == true) {
                        if ($responseData.Isdro == 0) {
                            if (response.data == "0") {
                                $('#lblMsg').text('Leave of the day!!');
                            }
                        }
                    }

                    if ($responseData.status == true) {
                        if ($responseData.Isdro == 0) {
                            if (response.data == "1") {

                                $('#lblMsg').text('Holyday Leave!!');//   modelAlert('Holyday Leave!!');
                            }
                        }
                    }

                    if ($responseData.status == true) {
                        if ($responseData.Isdro == 1) {
                            $('#ddlalltime').html($responseData.data);
                        }
                    }
                    if ($responseData.status == true) {
                        if ($responseData.Isdro == 0) {
                            $ddlalltime = $('#ddlalltime');
                            $ddlalltime.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'StartTime', textField: 'EndTime' });
                        }
                    }
                    else {
                        modelAlert($responseData.response, function () {
                            clearAppointMentDetails(true);
                        });
                    }
                });
            };


            function AppoinmentSave() {
                var FollowUpNew = $('#txtFollowUpNew').val();
                var TnxID = "";
                var appointmentDate = $('#txtdate').val();
                var Time = $('#ddlalltime').val();
                var ConsultantType = $ddlAppointmentType.val();
                var PanelID = '<%= Request.QueryString["PanelID"].ToString()%>'
                var Patientid = '<%= Request.QueryString["PID"].ToString()%>'

                if ($('#txtFollowUpNew').val() == "") {
                    $('#lblMsg').text('Please Enter Follow Up');
                    $('#txtFollowUpNew').focus();
                    return false;
                }

                $ddlAppointmentType = $('#ddlAppointmentType');
                if ($ddlAppointmentType.val() == "0") {
                    $('#lblMsg').text('Please Select Consultation Type');
                    $ddlAppointmentType.focus();
                    return false;
                }

                if ($('#ddlalltime').val() == null) {
                    $('#lblMsg').text('Please Check Availability');
                    $('#ddlalltime').focus();
                    return false;
                }
                var responseapp = '';
                serverCall('FollowUpnew.aspx/CheckDoctorAppointment', { Time: Time, appointmentDate: appointmentDate, DoctorID: $('#ddlDoctor').val() }, function (response) {
                    responseapp = response
                    if (parseInt(responseapp) > 0) {
                        $('#lblMsg').text('Appointment Already Available for this slot time. Please book another time slot');
                    }
                    if (parseInt(responseapp) == 0) {
                        serverCall('FollowUpnew.aspx/AppoinmentBooking', { TnxID: $('#ddlDoctor').val(), Date: appointmentDate, Time: Time, FollowUpNew: FollowUpNew, ConsultantType: ConsultantType, PanelID: PanelID, Patientid: Patientid }, function (response) {
                            $('#lblMsg').text(response);
                        });
                    }
                });
            }

</script>
    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc1" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Schedule Appointment</b><br />
                <%--<asp:Label ID="lblMsg"  runat="server" CssClass="ItDoseLblError" />--%>
                <label id="lblMsg" class="ItDoseLblError" ></label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    <strong style="margin-left: 8px;">Comments for Receiving Clinician</strong>
                </div>
               <div class="row">
                   <div class="col-md-24">
                   <input type="text" id="txtFollowUpNew" class="requiredField" runat="server" rows="3" style="height: 90px; width: 954px;" onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);" /><%-- onkeyup="javascript:Check(this, 1000);" onchange="javascript:Check(this, 1000);"--%>
                   </div>
               </div>
                <div class="row">
                      <div class="col-md-4">
                    <label class="pull-left">Doctor</label>
                    <b class="pull-right">:</b>
                </div>
                    <div class="col-md-5">
                        <select id="ddlDoctor" class="requiredField" title="Select Doctor" ></select>
                    </div>
                <div class="col-md-4">
                    <label class="pull-left">Consultation Type</label>
                    <b class="pull-right">:</b>
                </div>
                    <div class="col-md-5">
                        <select id="ddlAppointmentType" class="requiredField" title="Select VisitType"  ></select>
                    </div>
                    </div>
                <div class="row">
                    <div class="col-md-4">
                     <label class="pull-left">Appointment Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtdate" runat="server" ReadOnly="false" autocomplete="off" data-title="Enter Date (DD-MM-YYYY)" placeholder="DD-MM-YYYY" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtOldInvestigationModelFromDate" runat="server" TargetControlID="txtdate" Enabled="True" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                      <div class="col-md-4">
                     <label class="pull-left">Time</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                          <select id="ddlalltime" class="requiredField" title="Select Slot Time" "></select>
                    </div>
                    <div class="col-md-4">
                        <input type="button" class="ItDoseButton" style="font-weight: bold;" value="Availability" id="btnAvailability" onclick="Appoinment();" />
                    </div>
                </div>
                <div class="row" style="text-align:center">
                     <input type="button" class="ItDoseButton" value="Save" id="btnsaveapp" onclick="AppoinmentSave();" />
                </div>
            <div class="row">
                <div class="col-md-24">

                    <asp:Label ID="lblShowMessage" runat="server" Visible="false" ForeColor="Red" Font-Bold="true"></asp:Label>
                </div>
            </div>
            </div>
        </div>

    </form>
</body>
</html>
