<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="NewAppointment.aspx.cs" Inherits="Design_OPD_NewAppointment" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="wuc_OldPatientSearch"
    TagPrefix="uc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>--%>
    <%--<script type="text/javascript" src="../../Scripts/json2.js"></script>--%>
    <%--<script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>--%>
    <script src="../../Scripts/moment.min.js" type="text/javascript"></script>
   <%-- <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>--%>
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
    <link type="text/javascript" href="../../Styles/CustomStyle.css" rel="stylesheet" />
<script type="text/javascript" src="../../Scripts/Common.js"></script>

    <style type="text/css">
        .SelectApp {
            background-color: Lime;
        }

        .BlockApp {
            background-color: Red;
        }

        .ConfirmApp {
            background-color: Green;
        }

        .style1 {
            width: 202px;
        }

        .style2 {
            width: 18%;
        }

        .style3 {
            width: 36%;
        }
    </style>
    <script src="<%= ResolveUrl("~/Scripts/jquery-ui.js") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function verifyDate(sender, args) {
            var d = new Date();
            d.setDate(d.getDate() - 1);
            if (sender._selectedDate < d) {
                alert("Date should be Today or Greater than Today");
                sender._textbox.set_Value('')
            }
        }
    </script>
    <script type="text/javascript">
        jQuery(document).on("keydown", function (e) {
            if ((e.which == 13) && (e.target.id == "")) {
                e.preventDefault();
            }
            if (e.which == 8) {
                var rx = /INPUT|SELECT|TEXTAREA/i;
                if (!rx.test(e.target.tagName) || e.target.disabled || e.target.readOnly) {
                    e.preventDefault();
                }
            }
        });
        jQuery(function () {
            //Remove Refer Doctor from User Control & add in Page
            var refDoctor = jQuery('#td_userControlReferDoctor').html();
            jQuery('#td_userControlReferDoctor').html('');
            jQuery('#lblReferDoctor').show();
            jQuery('#td_DirectRefDoc').html(refDoctor);
            jQuery('#ddlReferDoctor').attr('tabIndex', 30);

            jQuery("#divApp").hide();
            var today = "";
            if ('<%=Resources.Resource.TokenDisplay%>' == "0" || '<%=Resources.Resource.TokenDisplay%>' == "")
                $('#btnOpen').hide();

            getTypeOfApp();
            getPurposeofVisit();
            getDepartment();
            getAppVisitType();
            getAppDoctor();
            if (jQuery('#lblHeader').text() != "Reschedule Appointment")
                bindHashCode();
            bindAppPanel();
            jQuery('#btnDoctorSchedule,#btnAppSave').attr('disabled', true);
            jQuery('#btnProcess').hide();
            AppID();
            jQuery('#btnProcess').click(function () {
                jQuery('#lblDocSchedule').text("Appointment Date Is :" + jQuery('#txtSelectedDate').val());
                var ScheduledTime = jQuery('#txtSelectTime').val().split('#');
                var LastTime = ScheduledTime.length;
                var value = (parseFloat(ScheduledTime[LastTime - 1].split(':')[1]) + 10);
                var ampm = jQuery('#txtSelectTime').val().split('#')[1].split(' ')[1];
                if (value < 60)
                    jQuery('#lblDocScheduleTime').text("Appointment Time From: " + ScheduledTime[0] + " To: " + ScheduledTime[LastTime - 1].split(':')[0] + ":" + value + " " + ampm);
                else
                    jQuery('#lblDocScheduleTime').text("Appointment Time From: " + ScheduledTime[0] + " To: " + (parseFloat(ScheduledTime[LastTime - 1].split(':')[0]) + 1) + ":00" + " " + ampm);
                if (AppID == "")
                    jQuery('#btnAppSave').removeProp('disabled');
                else
                    jQuery('#btnAppUpdate').removeProp('disabled');
            });

            jQuery('#ddlDoctorList').change(function () {
                ClearSlot();
                if (jQuery('#ddlDoctorList').val() != "0") {

                    GetLastVisitDetail(jQuery("#txtPID").val(), jQuery('#ddlDoctorList').val());
                     GetRate();
                    setDayforDoc();
                    bindDocTimingDateWise();
                    if (jQuery('#ddlAppointmentType').val() != "0") {
                        jQuery('#btnDoctorSchedule').removeAttr('disabled');
                    }
                    else
                        jQuery('#btnDoctorSchedule').attr('disabled', 'disabled');
                    ClearAppointment();
                  
                    jQuery('#lblDoctorName').text(jQuery('#ddlDoctorList option:selected').text());
                }
                else {
                    jQuery('#lblAmount,#lblDocSchedule,#lblDocScheduleTime').text('');
                    jQuery('#txtItemId').val('');
                    jQuery('#lblRateListID').text('0');
                    jQuery('#btnDoctorSchedule').attr("disabled", "disabled");
                }
                if (jQuery('#lblDocSchedule').val() == "" || jQuery('#lblDocScheduleTime').val() == "") {
                    jQuery('#btnAppSave').attr("disabled", "disabled");
                }
            });
            jQuery('#ddlAppointmentType').change(function () {
                ClearSlot();
                jQuery('#btnProcess').hide();
                jQuery('#btnAppSave').attr("disabled", "disabled");
                if (jQuery('#ddlDoctorList').val() != "0") {
                    GetRate();
                    jQuery('#btnDoctorSchedule').removeAttr('disabled');
                    ClearAppointment();
                }
                else {
                    jQuery('#lblAmount').text('');
                    jQuery('#txtItemId').val('');
                    jQuery('#lblRateListID').text('0');
                    jQuery('#btnDoctorSchedule,#btnAppSave').attr("disabled", "disabled");
                }
            });
            jQuery("#ddlDepartment").change(function () {
                ClearAppointment();
                jQuery('#lblAmount').text('');
                jQuery('#lblRateListID').text('0');
                jQuery("#ddlAppointmentType").prop('selectedIndex', 0);
                jQuery("#ddlDoctorList option").remove();
                var doctorName = jQuery("#ddlDoctorList");
                jQuery.ajax({
                    url: "../Common/CommonService.asmx/bindDoctorDept",
                    data: '{ Department: "' + jQuery("#ddlDepartment").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        doctorNameData = jQuery.parseJSON(result.d);
                        if (doctorNameData > "0") {
                            jQuery("#ddlDoctorList").empty().append('<option selected="selected" value="0">Select</option>');
                            for (i = 0; i < doctorNameData.length; i++) {
                                doctorName.append(jQuery("<option></option>").val(doctorNameData[i].DoctorID).html(doctorNameData[i].Name));
                            }
                        }
                    },
                    error: function (xhr, status) {
                        jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        return false;
                    }
                });
            });
        });
        function getTypeOfApp() {
            var ddlTypeOfApp = jQuery("#ddlTypeOfApp");
            jQuery("#ddlTypeOfApp option").remove();
            jQuery.ajax({
                url: "../Common/CommonService.asmx/bindTypeOfApp",
                data: '{ }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    typeOfAppData = jQuery.parseJSON(result.d);
                    if (typeOfAppData != null) {
                        for (i = 0; i < typeOfAppData.length; i++) {
                            ddlTypeOfApp.append(jQuery("<option></option>").val(typeOfAppData[i].AppointmentTypeID).html(typeOfAppData[i].AppointmentType));
                            if (typeOfAppData[i].IsDefault == "1") {
                                jQuery("#ddlTypeOfApp option:contains('" + typeOfAppData[i].AppointmentType + "')").prop('selected', true);
                                jQuery("#spnTypeOfApp").text(typeOfAppData[i].AppointmentType);
                            }
                        }

                    }

                },
                error: function (xhr, status) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    ddlTypeOfApp.attr("disabled", false);
                }
            });
        }
        function getPurposeofVisit() {
            var ddlPurposeofVisit = jQuery("#ddlPurposeofVisit");
            jQuery("#ddlPurposeofVisit option").remove();
            var PurposeofVisit = {
                type: "POST",
                url: "../Common/CommonService.asmx/bindComplaint",
                data: '{ }',
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    purposeofVisit = jQuery.parseJSON(result.d);
                    if (purposeofVisit != null) {
                        ddlPurposeofVisit.append(jQuery("<option></option>").val("0").html("Select"));

                        for (i = 0; i < purposeofVisit.length; i++) {
                            ddlPurposeofVisit.append(jQuery("<option></option>").val(purposeofVisit[i].Complain_id).html(purposeofVisit[i].Complain));
                        }

                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            };
            jQuery.ajax(PurposeofVisit);

        }
        function getDepartment() {
            var ddlDepartment = jQuery("#ddlDepartment");
            jQuery("#ddlDepartment option").remove();
            var department = {
                type: "POST",
                url: "../Common/CommonService.asmx/bindDepartment",
                data: '{ }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    department = jQuery.parseJSON(result.d);
                    if (department != null) {
                        ddlDepartment.append(jQuery("<option></option>").val("ALL").html("ALL"));
                        if (department.length == 0) {
                            ddlDepartment.append(jQuery("<option></option>").val("ALL").html("---No Data Found---"));
                        }
                        else {
                            for (i = 0; i < department.length; i++) {
                                ddlDepartment.append(jQuery("<option></option>").val(department[i].Name).html(department[i].Name));
                            }
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            };
            jQuery.ajax(department);
        }
        function getAppVisitType() {
            var ddlAppointmentType = jQuery("#ddlAppointmentType");
            jQuery("#ddlAppointmentType option").remove();
            var appVisitType = {
                type: "POST",
                url: "NewAppointment.aspx/bindAppVisitType",
                data: '{ }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    VisitType = jQuery.parseJSON(result.d);
                    if (VisitType != null) {
                        ddlAppointmentType.append(jQuery("<option></option>").val("0").html("Select"));
                        if (VisitType.length == 0) {
                            ddlAppointmentType.append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            for (i = 0; i < VisitType.length; i++) {
                                ddlAppointmentType.append(jQuery("<option></option>").val(VisitType[i].SubCategoryID).html(VisitType[i].Name));

                            }
                        }
                    }
                    ddlAppointmentType.attr("disabled", false);
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            };
            jQuery.ajax(appVisitType);
        }
        function getAppDoctor() {
            var ddlDoctorList = jQuery("#ddlDoctorList");
            var appDoctor = {
                type: "POST",
                url: "../Common/CommonService.asmx/bindAppDoctor",
                data: '{ Department: "' + jQuery("#ddlDepartment option:selected").text() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    appDoctor = jQuery.parseJSON(result.d);
                    if (appDoctor != null) {
                        ddlDoctorList.append(jQuery("<option></option>").val("0").html("Select"));
                        if (appDoctor.length == 0) {
                            ddlDoctorList.append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            for (i = 0; i < appDoctor.length; i++) {
                                ddlDoctorList.append(jQuery("<option></option>").val(appDoctor[i].DoctorID).html(appDoctor[i].Name));

                            }
                        }
                    }
                    ddlDoctorList.attr("disabled", false);
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            };
            jQuery.ajax(appDoctor);
        }
        
        function ClearAppointment() {
            jQuery('#lblDocSchedule,#lblDocScheduleTime').text('');
        }
        function GetRate() {
            jQuery.ajax({
                url: "../Common/CommonService.asmx/Loadrate",
                data: '{DoctorID:"' + jQuery('#ddlDoctorList').val() + '",referenceCodeOPD:"' + jQuery('#ddlPanel').val().split('#')[1] + '",SubCategoryID:"' + jQuery('#ddlAppointmentType').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var obsData = jQuery.parseJSON(mydata.d);
                    if (obsData != "") {
                        jQuery('#lblAmount').text(obsData[0]["Rate"]);
                        jQuery('#lblRateListID').text(obsData[0]["ID"]);
                        jQuery('#txtItemId').val(obsData[0]["ItemID"]);
                        if (obsData[0]["Rate"] >= 0)
                            jQuery('#btnDoctorSchedule').attr('disabled', false);
                        else
                            jQuery('#btnDoctorSchedule').attr('disabled', true);
                    }
                    else {
                        jQuery('#lblAmount').text('');
                        jQuery('#txtItemId').val('');
                        jQuery('#btnDoctorSchedule').attr('disabled', true);
                        jQuery('#lblRateListID').text('0');
                    }
                }
            });
        }
        function ClearSlot() {
            jQuery('#appointment').html('');
        }
        
        function StartTime() {
            jQuery.ajax({
                url: "NewAppointment.aspx/StartTime",
                data: '{DoctorID:"' + jQuery('#ddlDoctorList').val() + '",Day:"' + DayofWeek + '",Date:"' + jQuery('#txtSelectedDate').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    jQuery('#txtStartTime').val(mydata.d);
                }
            });
        }
        function EndTime() {
            jQuery.ajax({
                url: "NewAppointment.aspx/EndTime",
                data: '{DoctorID:"' + jQuery('#ddlDoctorList').val() + '",Day:"' + DayofWeek + '",Date:"' + jQuery('#txtSelectedDate').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    jQuery('#txtEndTime').val(mydata.d);
                    CreateTimeSlot();
                }
            });
        }
        function DurationforOldPatient() {
            jQuery.ajax({
                url: "NewAppointment.aspx/DurationforOldPatient",
                data: '{DoctorID:"' + jQuery('#ddlDoctorList').val() + '",Day:"' + DayofWeek + '",Date:"' + jQuery('#txtSelectedDate').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data > 0) {
                        jQuery('#txtDuration,#ddlDuration').val(mydata.d);
                        jQuery('#lblAppMsg').text('');
                    }
                    else {
                        jQuery('#lblAppMsg').text('Appointment is not Available');
                        jQuery('#btnProcess').hide();
                    }
                }
            });
        }
        function DurationforNewPatient() {
            jQuery.ajax({

                url: "NewAppointment.aspx/DurationforNewPatient",
                data: '{DoctorID:"' + jQuery('#ddlDoctorList').val() + '",Day:"' + DayofWeek + '",Date:"' + jQuery('#txtSelectedDate').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data > 0) {
                        jQuery('#txtDuration,#ddlDuration').val(mydata.d);
                        jQuery('#lblAppMsg').text('');
                    }
                    else {
                        jQuery('#lblAppMsg').text('Appointment is not Available');
                        jQuery('#btnProcess').hide();
                    }
                }
            });
        }
        function tablefunc() {
            jQuery("#main").find("#row").click(function () {
                jQuery('.SelectApp').removeClass('SelectApp');
                jQuery(this).addClass('SelectApp');
                jQuery('#txtSelectTime').val(jQuery(this).text());
                var slot = Number(jQuery('#txtDuration').val()) / 10;
                if (slot == 1) {
                    jQuery(this).addClass('SelectApp');
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).text());
                    if (jQuery(this).text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('BlockApp')) {
                        alert('Appointment Is Scheduled!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('ConfirmApp')) {
                        alert('Appointment Is Confirmed!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                }
                if (slot == 2) {
                    jQuery(this).next('div').addClass('SelectApp');
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').text());
                    if (jQuery(this).next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('BlockApp')) {
                        alert('Appointment Is Scheduled!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('ConfirmApp')) {
                        alert('Appointment Is Confirmed!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                }
                if (slot == 3) {
                    if (jQuery(this).next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('BlockApp')) {
                        alert('Appointment Is Scheduled!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('ConfirmApp')) {
                        alert('Appointment Is Confirmed!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }

                    jQuery(this).next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').addClass('SelectApp');
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').text());
                }
                if (slot == 4) {
                    if (jQuery(this).next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    else if (jQuery(this).next('div').next('div').text() == "") {

                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    else if (jQuery(this).next('div').next('div').next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('BlockApp')) {
                        alert('Appointment Is Scheduled!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('ConfirmApp')) {
                        alert('Appointment Is Confirmed!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }

                    jQuery(this).next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').next('div').addClass('SelectApp');
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').next('div').text());
                }
                if (slot == 5) {
                    if (jQuery(this).next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    else if (jQuery(this).next('div').next('div').next('div').text() == "") {

                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    else if (jQuery(this).next('div').next('div').next('div').next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }

                    if (jQuery(this).hasClass('BlockApp')) {
                        alert('Appointment Is Scheduled!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('ConfirmApp')) {
                        alert('Appointment Is Confirmed!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').next('div').next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').next('div').next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    jQuery(this).next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').next('div').next('div').addClass('SelectApp');
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').next('div').next('div').text());
                }
                if (slot == 6) {
                    if (jQuery(this).next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    else if (jQuery(this).next('div').next('div').next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    else if (jQuery(this).next('div').next('div').next('div').next('div').text() == "") {
                        alert('Doctor Time Slot is Not Available');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('BlockApp')) {
                        alert('Appointment Is Scheduled!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).hasClass('ConfirmApp')) {
                        alert('Appointment Is Confirmed!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').next('div').next('div').hasClass('BlockApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    if (jQuery(this).next('div').next('div').next('div').next('div').hasClass('ConfirmApp')) {
                        alert('Kindly Go For Next Time Slot!');
                        jQuery('.SelectApp').removeClass('SelectApp');
                        jQuery('#btnProcess').hide();
                        return;
                    }
                    jQuery(this).next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').next('div').next('div').addClass('SelectApp');
                    jQuery(this).next('div').next('div').next('div').next('div').next('div').addClass('SelectApp');
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').next('div').next('div').text());
                    jQuery('#txtSelectTime').val(jQuery('#txtSelectTime').val() + '#' + jQuery(this).next('div').next('div').next('div').next('div').next('div').text());
                }
                jQuery('#btnProcess').show();
                if (jQuery('#txtAppNo').val() != "") {
                    getScheduledAppTime(slot);
                }
            });
        }
        function getScheduledAppTime(slot) {
            jQuery.ajax({
                url: "NewAppointment.aspx/getScheduledAppTime",
                data: '{DoctorID:"' + jQuery('#ddlDoctorList').val() + '",Date:"' + jQuery('#txtSelectedDate').val() + '",App_ID:"' + jQuery('#txtAppNo').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data != "") {
                        jQuery("#main").find('div').each(function () {
                            if (jQuery(this).html() == data) {
                                if (slot == 1) {
                                    jQuery(this).removeClass('BlockApp');
                                }
                                if (slot == 2) {
                                    jQuery(this).removeClass('BlockApp');
                                    jQuery(this).next('div').removeClass('BlockApp');
                                }
                                if (slot == 3) {
                                    jQuery(this).removeClass('BlockApp');
                                    jQuery(this).next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').removeClass('BlockApp');
                                }
                                if (slot == 4) {
                                    jQuery(this).removeClass('BlockApp');
                                    jQuery(this).next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').next('div').removeClass('BlockApp');
                                }
                                if (slot == 5) {
                                    jQuery(this).removeClass('BlockApp');
                                    jQuery(this).next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').next('div').next('div').removeClass('BlockApp');
                                }
                                if (slot == 6) {
                                    jQuery(this).removeClass('BlockApp');
                                    jQuery(this).next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').next('div').next('div').removeClass('BlockApp');
                                    jQuery(this).next('div').next('div').next('div').next('div').next('div').next('div').removeClass('BlockApp');
                                }
                            }
                        });
                    }
                }
            });

        }
        function CreateTimeSlot() {
            jQuery.ajax({
                url: "NewAppointment.aspx/CreateSlot",
                data: '{start:"' + jQuery('#txtStartTime').val() + '",end:"' + jQuery('#txtEndTime').val() + '",DoctorID:"' + jQuery('#ddlDoctorList').val() + '",Date:"' + jQuery('#txtSelectedDate').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    jQuery('#btnProcess').hide();
                    var data = mydata.d;
                    if (data == "<div id='main'></div>")
                        jQuery('#lblAppMsg').text('Appointment Slot Not Available');
                    else
                        jQuery('#lblAppMsg').text('');
                    jQuery('#appointment').html(mydata.d);
                    tablefunc();
                    jQuery('#imgloading').hide();
                }
            });
        }

        jQuery(document).on("change", "#datepicker", function () {
            ClearSlot();
            jQuery('#imgloading').show();
            jQuery('#txtSelectedDate').val(jQuery.datepicker.formatDate('dd-M-yy', new Date(jQuery(this).val())));
            var selectdate = new Date(jQuery(this).val());
            GetDay(selectdate.getDay());
            if (jQuery('#ddlVisitType').val() == "1")
                DurationforNewPatient();
            else
                DurationforOldPatient();
            StartTime();
            EndTime();
        });
        jQuery(document).on("click", "#imgCloseButton", function () {
            ClearSlot();
            jQuery('#btnProcess').hide();
        });

         </script>
   <script type="text/javascript">

       function setDayforDoc() {
           jQuery('#spnAppStatus').text('');
           var tomorrow = "";
           var Format = "yy mm dd";
           jQuery.ajax({
               url: "../Common/CommonService.asmx/getFormatedDate",
               data: '{}',
               type: "POST",
               async: false,
               dataType: "json",
               contentType: "application/json; charset=utf-8",
               success: function (mydata) {
                   today = moment(mydata.d).format('MM/DD/YYYY h:mm a');
               }
           });

           var daysObj;
           var docAv = 0;
           var dayscomp = [];
           jQuery.ajax({
               url: "../Common/CommonService.asmx/getDocDays",
               data: '{DoctorID:"' + jQuery('#ddlDoctorList').val() + '"}',
               type: "POST",
               async: false,
               dataType: "json",
               contentType: "application/json; charset=utf-8",
               success: function (mydata) {
                   daysObj = jQuery.parseJSON(mydata.d);
                   if (daysObj != null) {
                       var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
                       docAv = 1;
                       for (var i = 0; i < daysObj.length; i++) {
                           for (var j = 0; j < days.length; j++) {
                               if (days[j] == daysObj[i].DAY) {
                                   dayscomp.push(j);
                                   break;
                               }
                           }
                       }
                   }
                   else {
                       jQuery('#<%=btnDoctorSchedule.ClientID%>').attr('disabled', 'disabled');
                   }
               }
           });
           if (docAv == "1") {
               jQuery('#<%=btnDoctorSchedule.ClientID%>').removeAttr('disabled');
                jQuery.noConflict();
                jQuery("#datepicker").html('');
                createdate(dayscomp, today);
            }
            else {
                jQuery.noConflict();
                var disableDates = [];
                jQuery.ajax({
                    url: "../Common/CommonService.asmx/getDoTimingDateWise",
                    data: '{DoctorID:"' + jQuery('#ddlDoctorList').val() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (msg) {
                        var result = msg.d;
                        if (result != "") {
                            docAv = 2;
                            for (var i = 0; i < result.length; i++) {
                                disableDates.push(result[i]);
                            }
                        }
                    }
                });
                jQuery('#spnAppStatus').text('');
                // var disableDates1 = ["2015/04/25"];   
                if (docAv == "2") {
                    jQuery('#spnAppStatus,#lblAppMsg').text('');
                    jQuery('#<%=btnDoctorSchedule.ClientID%>').removeAttr('disabled');
                    jQuery.noConflict();
                    jQuery("#datepicker").datepicker("destroy");
                    jQuery("#datepicker").datepicker({
                        changeYear: true,
                        changeMonth: true,
                        buttonImageOnly: true,
                        minDate: today,
                        beforeShowDay: function (date) {
                            dmy = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
                            if (jQuery.inArray(dmy, disableDates) != -1) {
                                return [true, ""];
                            } else {

                                return [false, "", "Unavailable"];
                            }
                        }
                    });
                }
                else {
                    jQuery.noConflict();
                    jQuery("#datepicker").datepicker("destroy");
                    jQuery('#<%=btnDoctorSchedule.ClientID%>').attr('disabled', 'disabled');
                    jQuery('#lblAppMsg,#spnAppStatus').text('Appointment Slot Not Available');
                    jQuery('#btnProcess').hide();
                }
            }
        }
        function createdate(dayscomp, today) {
            jQuery("#datepicker").datepicker("destroy");
            jQuery('#<%=btnProcess.ClientID%>').hide();
            jQuery("#datepicker").datepicker({
                changeYear: true,
                changeMonth: true,
                buttonImageOnly: true,
                minDate: today,
                beforeShowDay: function (date) {
                    var arr = [];
                    switch (dayscomp.length) {
                        case 1:
                            arr.push(date.getDay() == dayscomp[0], "");
                            break;
                        case 2:
                            arr.push(date.getDay() == dayscomp[0] || date.getDay() == dayscomp[1], "");
                            break;
                        case 3:
                            arr.push(date.getDay() == dayscomp[0] || date.getDay() == dayscomp[1] || date.getDay() == dayscomp[2], "");
                            break;
                        case 4:
                            arr.push(date.getDay() == dayscomp[0] || date.getDay() == dayscomp[1] || date.getDay() == dayscomp[2] || date.getDay() == dayscomp[3], "");
                            break;
                        case 5:
                            arr.push(date.getDay() == dayscomp[0] || date.getDay() == dayscomp[1] || date.getDay() == dayscomp[2] || date.getDay() == dayscomp[3] || date.getDay() == dayscomp[4], "");
                            break;
                        case 6:
                            arr.push(date.getDay() == dayscomp[0] || date.getDay() == dayscomp[1] || date.getDay() == dayscomp[2] || date.getDay() == dayscomp[3] || date.getDay() == dayscomp[4] || date.getDay() == dayscomp[5], "");
                            break;
                        case 7:
                            arr.push(date.getDay() == dayscomp[0] || date.getDay() == dayscomp[1] || date.getDay() == dayscomp[2] || date.getDay() == dayscomp[3] || date.getDay() == dayscomp[4] || date.getDay() == dayscomp[5] || date.getDay() == dayscomp[6], "");
                            break;
                    }
                    return arr;
                }
            });
        }
        var DayofWeek;
        function GetDay(d) {
            switch (d) {
                case 0:
                    DayofWeek = "Sunday";
                    break;
                case 1:
                    DayofWeek = "Monday";
                    break;
                case 2:
                    DayofWeek = "Tuesday";
                    break;
                case 3:
                    DayofWeek = "Wednesday";
                    break;
                case 4:
                    DayofWeek = "Thursday";
                    break;
                case 5:
                    DayofWeek = "Friday";
                    break;
                case 6:
                    DayofWeek = "Saturday";
                    break;
            }
        }
         </script>
     <script type="text/javascript">
         function SelectDuration() {
             StartTime();
             EndTime();
             jQuery('#txtDuration').val(jQuery("#ddlDuration ").val());
         }
         function hideAppDetail() {
             jQuery("#ddlAppointmentType").prop('selectedIndex', 0);
             jQuery("#ddlDoctorList").prop('selectedIndex', 0);
             jQuery("#lblAmount").text('');
             jQuery('#lblRateListID').text('0');
             jQuery("#btnDoctorSchedule").attr('disabled', 'disabled');
         }

    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b> <span id="lblHeader" Style="font-weight: bold;">Book New Appointment<br />
                <input type="button" class="ItDoseButton" title="Click to Open Token" value="Open Token Window" id="btnOpen" onclick="showToken()" />
            </span></b><br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <span id="spnAppointment"></span>
            <input type="text" id="txtHash" style="display: none" />
            <span id="lblAppID" Style="display: none"></span>
            
        </div>
        <table border="0" style="width: 100%; border-collapse: collapse;">
            <tr>
                <td colspan="4" style="width: 100%">
        <uc1:wuc_OldPatientSearch ID="PatientInfo" runat="server" />
                </td>
            </tr>
        </table>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table border="0" style="width: 100%; border-collapse: collapse;">
                 <tr>
                        <td  style="width: 15%; text-align:right ">
                            Panel :&nbsp;
                        </td>
                        <td  style="width: 35%;text-align:left ">
                            <select id="ddlPanel" onchange="hideAppDetail()" title="Select Panel" style="width:225px" tabindex="31"  ></select>
                          <span style="color: red; font-size: 10px;">*</span>
                            
                        </td>
                        <td style="width: 15%; text-align:right  ">
                            <%--Patient Type :&nbsp;                                                                                --%>
                            <label id="lblReferDoctor" style="display:none">Refer Doctor :&nbsp;</label>
                        </td>
                        <td  style="width: 35%;text-align:left" id="td_DirectRefDoc">
                           <select id="ddlVisitType"  disabled="disabled" style="display:none">
                                <option value="1">New Patient</option>
                                <option value="2">Old Patient</option>
                            </select>
                        </td>
                    </tr>
                <tr>
                    <td style="width: 15%; text-align: right">Purpose of Visit :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <select id="ddlPurposeofVisit" style="width: 225px" tabindex="32" title="Select Purpose of Visit"></select>
                        <asp:Button ID="btnPurposeofVisit" runat="server" CssClass="ItDoseButton" Text="New"
                            ToolTip="Click To Add New Purpose Of Visit "  ClientIDMode="Static" />
                    </td>
                    <td style="width: 15%; text-align: right">Type of App. :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <span id="spnTypeOfApp" style="display:none"></span>
                        <select id="ddlTypeOfApp" style="width: 225px" tabindex="33" title="Select Type of Appointment" onchange="chkConfirmCon()"></select>
                        <asp:Button ID="btnTypeOfApp" runat="server" CssClass="ItDoseButton" Text="New" ToolTip="Click To Add New Appointmnet"
                           ClientIDMode="Static"/>
                    </td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Appointment Details
            </div>
            <table style="width: 100%; border-collapse:collapse">
                <tr>
                    <td style="width: 15%; text-align: right">Department :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <select id="ddlDepartment" style="width: 225px" title="Select Department" tabindex="34"></select>


                    </td>
                    <td style="width: 15%; text-align: right">&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right;">Doctor List :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <table style="width:100%;border-collapse:collapse">
                            <tr>
                                <td style="text-align: left;width:227px">
                         <select id="ddlDoctorList" style="width: 225px" title="Select Doctor" tabindex="35"></select>
                                 </td>
                                <td style="text-align:left">
                                    <span style="color: red; font-size: 10px;" class="shat">*</span>
                                </td>
                            </tr>
                        </table>

                    </td>
                    <td style="width: 15%; text-align: right; color:blue;display:none" class="patientLastVisit"><strong>Last Visit Date :</strong></td>
                    <td style="width: 35%; text-align: left; color:blue;display:none" class="patientLastVisit">
                        <label id="lblLastVisitDate" style="font-weight:bold"></label>&nbsp;<strong>Days : <label id="lblDays"></label></strong>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">Visit Type :&nbsp; 
                    </td>
                    <td style="width: 35%; text-align: left">
                       
                        <select id="ddlAppointmentType" style="width: 225px" title="Select Visit Type" tabindex="36"></select>

                        <span style="color: red; font-size: 10px;">*</span>
                    </td>
                    <td style="width: 15%; text-align: right;color:blue;display:none" class="patientLastVisit"><strong>Last Visit Doctor :</strong></td>
                    <td style="width: 35%; text-align: left;color:blue;display:none" class="patientLastVisit">
                        <label id="lblLastVisitDoctor" style="font-weight:bold"></label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">Doctor Rate :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        
                        <span id="lblAmount" style="font-weight: 700">0</span>
                     <span id="lblRateListID" style="display:none"></span>
                        <input type="text" id="txtItemId" style="display: none;" />
                    
                    </td>
                    <td style="width: 15%; text-align: right">
                        <asp:Button ID="btnDoctorSchedule" runat="server" Text="Doctor Schedule" ClientIDMode="Static"
                            CssClass="ItDoseButton" ToolTip="Click To Select Doctor Schedule" TabIndex="37" />
                    </td>
                    <td style="width: 35%; text-align: left">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">&nbsp;
                    </td>
                    <td style="text-align: left;" colspan="3">

                        <span id="lblDocSchedule" style="font-weight: bold;"></span>&nbsp;
                         <span id="lblDocScheduleTime" style="font-weight: bold;"></span>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Remarks
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="width: 15%; text-align: right; vertical-align: top">Remarks :&nbsp;
                    </td>
                    <td style="width: 85%; text-align: left" colspan="3">
                        <textarea id="txtNotes" tabindex="38" style="width: 396px; height: 45px" title="Enter Notes" onkeyup="javascript:ValidateCharactercount(200,this);"></textarea>

                        <div id="divmessage" style="color: Red;">
                        </div>
                    </td>

                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" class="ItDoseButton" title="Click to Save" disabled="disabled" tabindex="39" value="Save" id="btnAppSave" onclick="SaveAppointment()" />
            <input type="button" class="ItDoseButton"  title="Click to Update" value="Update" tabindex="40" disabled="disabled" id="btnAppUpdate" onclick="UpdateAppointment()" />
            <b>
                <input type="checkbox"  id="chkApp" value="Confirm Appointment" />Confirm Appointment
            </b>
        </div>
        <asp:Panel ID="pnlDoctorSchedule" runat="server" Style="display: none" CssClass="pnlVendorItemsFilter"
            Height="600px" ScrollBars="Vertical" Width="530px">
            <div id="Div3">
                <table>
                    <tr>
                        <td colspan="2">
                            <div class="Purchaseheader">
                                Doctor Appointment &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <em ><span style="font-size: 7.5pt">
                       Press esc or click
                                <asp:ImageButton ID="imgCloseButton" runat="server" ClientIDMode="Static" ImageUrl="~/Images/Delete.gif" />
                                to close</span></em>
                            </div>
                            &nbsp;Doctor :&nbsp;
                            <span id="lblDoctorName" style="font-weight: bold;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <span id="lblConfirm" class="ConfirmApp">Confirm</span>
                            &nbsp;&nbsp;
                            <span id="lblScheduled" class="BlockApp">Scheduled</span>
                            &nbsp;&nbsp;
                             <span id="lblSelectedText" style="background-color: Lime;">Selected</span> &nbsp;&nbsp;
                             <span id="lblAvailable">Available</span>
                            <input type="text" id="txtAppNo" style="display: none" />
                            <select id="ddlDuration" onchange="SelectDuration()">
                                <option value="10">10 Min</option>
                                <option value="20">20 Min</option>
                                <option value="30">30 Min</option>
                                <option value="40">40 Min</option>
                                <option value="50">50 Min</option>
                                <option value="60">60 Min</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="display:none" >
                            <input id="txtSelectedDate" type="text"  />
                            <input id="txtDuration" type="text"   />
                            <input id="txtStartTime" type="text"  />
                            <input id="txtEndTime" type="text"  />
                            <input id="txtSelectTime" type="text"  />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%; vertical-align: top; text-align: center">
                            <div id="datepicker">
                            </div>
                            <br />
                            <br />
                            <asp:Button ID="btnProcess" CssClass="ItDoseButton" ClientIDMode="Static" runat="server"
                                Text="Proceed"  />
                            <br />
                            <span id="lblAppMsg" class="ItDoseLblError"></span>
                              <br />
                              <br />
                            <div id="docTimingDateWiseOutput" style="max-height: 300px; overflow-x: auto;">
                        </div>
                        </td>
                        <td style="width: 70%">
                            <img src="../../Images/ajax-loader.gif" alt="Loading" id="imgloading" style="display: none" />
                            <div id="appointment">
                            </div>
                        </td>
                    </tr>
                </table>
                &nbsp;&nbsp;&nbsp;
            </div>
        </asp:Panel>
        <cc2:ModalPopupExtender ID="mpDoctorSchedule" runat="server" CancelControlID="imgCloseButton"
            OkControlID="btnProcess" DropShadow="true" TargetControlID="btnDoctorSchedule"
            BackgroundCssClass="filterPupupBackground" PopupControlID="pnlDoctorSchedule"
            BehaviorID="mpDoctorSchedule" PopupDragHandleControlID="Div3">
        </cc2:ModalPopupExtender>
        <asp:Panel ID="PnlComplaint" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="320px" DefaultButton="btnComplaintCancel">
            <div class="Purchaseheader" id="Div2" >
                <b>Create Visit</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<em ><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeComplaint()"/> to close
                               </span></em>
                               
            </div>

            <table style="width:100%">
                <tr>
                    <td style="width:30%;text-align:right">Visit Name :
                    </td>
                    <td style="width:70%;text-align:left">
                        <input type="text" id="txtComplaintName" maxlength="50" style="width: 180px" />
                        <span style="color: red; font-size: 10px;">*</span>
                    </td>
                </tr>
                <tr>
                    
                    <td colspan="2"  style="text-align:center"  >
                        <input id="btnComplaintSave" class="ItDoseButton" type="button" value="Save" onclick="SaveComplaint()" />
                        <asp:Button ID="btnComplaintCancel" ClientIDMode="Static" runat="server" CssClass="ItDoseButton"
                            Text="Cancel" CausesValidation="false" />
                    </td>
                </tr>
            </table>

        </asp:Panel>
        <cc2:ModalPopupExtender ID="mpCompalint" runat="server" CancelControlID="btnComplaintCancel"
            DropShadow="true" TargetControlID="btnPurposeofVisit" BackgroundCssClass="filterPupupBackground"
            PopupControlID="PnlComplaint" PopupDragHandleControlID="Div2" OnCancelScript="VisitName()" BehaviorID="mpCompalint">
        </cc2:ModalPopupExtender>
        <asp:Panel ID="PnlTypeOfApp" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="440px">
            <div class="Purchaseheader"  >
                <b>Create Type of Appointment</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <em ><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeTypeOfApp()"/>
                               
                                to close</span></em>
            </div>

              <table style="width:100%">
                <tr>
                    <td style="width:40%;text-align:right">Type of Appointment :
                    </td>
                    <td style="width:60%;text-align:left">

                        <input type="text" id="txtTypeOfAppoinment" style="width: 180px" maxlength="50" />
                        <span style="color: red; font-size: 10px;">*</span>

                    </td>
                </tr>
                <tr>
                   
                   <td colspan="2"  style="text-align:center"  >
                        <input id="btnTypeOfAppoinment" class="ItDoseButton" type="button" value="Save" onclick="SaveTypeOfAppoinment()" />
                        <asp:Button ID="btnTypeOfAppCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                            CausesValidation="false" />
                    </td>
                </tr>
            </table>

        </asp:Panel>
        <cc2:ModalPopupExtender ID="mpTypeOfApp" runat="server" CancelControlID="btnTypeOfAppCancel"
            DropShadow="true" TargetControlID="btnTypeOfApp" BackgroundCssClass="filterPupupBackground" BehaviorID="mpTypeOfApp"
            PopupControlID="PnlTypeOfApp" PopupDragHandleControlID="Div2" OnCancelScript="TypeOfAppoinmentBlank()">
        </cc2:ModalPopupExtender>
    </div>
    <script type="text/javascript">
        function VisitName() {
            jQuery("#txtComplaintName").val('');
        }
        function TypeOfAppoinmentBlank() {
            jQuery("#txtTypeOfAppoinment").val('');
        }
        function closeComplaint() {
            jQuery("#txtComplaintName").val('');
            $find('mpCompalint').hide();
        }
        function closeTypeOfApp() {
            jQuery("#txtTypeOfAppoinment").val('');
            $find('mpTypeOfApp').hide();
        }
    </script>
    <script type="text/javascript">
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if (jQuery(id).text().length > charlimit) {
                jQuery(id).text(jQuery(id).text().substring(0, charlimit));
                jQuery("#divmessage").html("Maximum cahracter allowes :" + charlimit);
            }
            else
                jQuery("#divmessage").html("");
        }
    </script>
    <script type="text/javascript">
        function SaveComplaint() {
            if (jQuery.trim(jQuery("#txtComplaintName").val()) != "") {
                var PurposeofVisit = jQuery("#ddlPurposeofVisit");
                jQuery.ajax({
                    url: "../Common/CommonService.asmx/Complaint",
                    data: '{ CName: "' + jQuery("#txtComplaintName").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data > "0") {
                            getPurposeofVisit();
                            jQuery("#ddlPurposeofVisit option:contains('" + jQuery("#txtComplaintName").val() + "') ").prop('selected', true);
                            jQuery('#spnErrorMsg').text('Purpose of Visit Saved Successfully');
                            jQuery("#txtComplaintName").val('');
                            $find('mpCompalint').hide();
                        }
                        else if (Data == "0") {
                            jQuery('#spnErrorMsg').text('Purpose of Visit Already Exist');
                            jQuery("#txtComplaintName").val('');
                            $find('mpCompalint').hide();
                        }
                        else {
                            jQuery('#spnErrorMsg').text('Purpose of Visit Not Saved');
                            $find('mpCompalint').hide();
                        }

                    },
                    error: function (xhr, status) {
                        alert("Error");
                        return false;
                    }
                });
            }
            else {
                jQuery('#spnErrorMsg').html("Please Enter Purpose of Visit");
                jQuery("#txtComplaintName").focus();
                $find('mpCompalint').show();
            }
        }
        function SaveTypeOfAppoinment() {
            if (jQuery.trim(jQuery("#txtTypeOfAppoinment").val()) != "") {
                jQuery.ajax({
                    url: "../Common/CommonService.asmx/TypeOfAppointment",
                    data: '{ TypeOfAppointment: "' + jQuery("#txtTypeOfAppoinment").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data > "0") {
                            jQuery('#spnErrorMsg').text('Type Of Appointment Saved Successfully');
                            jQuery("#ddlTypeOfApp").append(jQuery("<option></option>").val(jQuery("#txtTypeOfAppoinment").val()).html(jQuery("#txtTypeOfAppoinment").val()));
                            jQuery("#ddlTypeOfApp").val(jQuery("#txtTypeOfAppoinment").val());

                            jQuery("#txtTypeOfAppoinment").val('');
                            $find('mpTypeOfApp').hide();
                        }
                        else if (Data == "0") {
                            jQuery('#spnErrorMsg').text('Type Of Appointment Already Exist');
                            jQuery("#txtTypeOfAppoinment").val('');
                            $find('mpTypeOfApp').hide();
                        }
                        else {
                            jQuery('#spnErrorMsg').text('Type Of Appointment Not Saved');
                            $find('mpTypeOfApp').hide();
                        }

                    },
                    error: function (xhr, status) {
                        jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        return false;
                    }
                });
            }
            else {
                jQuery('#spnErrorMsg').html("Please Enter Type Of Appointment");
                jQuery("#txtTypeOfAppoinment").focus();
                $find('mpTypeOfApp').show();
            }
        }
    </script>
    <script type="text/javascript">
        function enableControl() {
            if (jQuery('#btnAppUpdate').is(':visible'))
                jQuery('#btnAppUpdate').removeProp('disabled').val("Update");
            else
                jQuery('#btnAppSave').removeProp('disabled').val("Save");
        }
        function validateAppointment() {
            var app = 0;
            if (validatePatientInfo() != true)
                return false;

            if (jQuery('#ddlPanel option:selected').text() == "Select") {
                jQuery('#spnErrorMsg').text('Please Select Panel');
                jQuery('#ddlPanel').focus();
                enableControl();
                app = 1;
                return false;
            }
            return true;
        }
        function SaveAppointment() {
            jQuery('#btnAppSave').attr('disabled', true).val("Submitting...");
            if (validateAppointment() == true) {
                var resultApp = appointment();
                jQuery.ajax({
                    url: "Services/AppointmentNew.asmx/SaveApp",
                    data: JSON.stringify({ Data: resultApp }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        AppNo = result.d;
                        if (AppNo != "") {
                            jQuery("#spnErrorMsg").text('Record Saved Successfully');
                            alert('Appointment No. :' + AppNo.split('#')[1] + '');
                            if ((jQuery("#chkApp").is(":checked")) && (jQuery("#ddlVisitType").val() == "2") && (jQuery("#ddlTypeOfApp option:selected").text() == "Walk-In"))
                                location.href = 'GetPayment.aspx?&App_ID=' + AppNo.split('#')[0] + '&PatientID=' + jQuery("#txtPID").val() + '&DoctorID=' + jQuery("#ddlDoctorList").val() + '';
                            else
                                clearAppControl();
                            jQuery('#btnAppSave').val("Save");
                        }
                        else {
                            jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');                            
                            jQuery('#btnAppSave').attr('disabled', false).val("Save");
                        }
                    },
                    error: function (xhr, status) {
                        jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        jQuery('#btnAppSave').attr('disabled', false).val("Save");

                    }

                });
            }
            else
                jQuery('#btnAppSave').attr('disabled', false).val("Save");
        }
        function appointment() {
            var data = new Array();
            var objApp = new Object();
            if (jQuery('#txtPID').val().length == 0)
                objApp.PatientID = "";
            else
                objApp.PatientID = jQuery('#txtPID').val();
            objApp.Title = jQuery('#ddlTitle').val();
            objApp.PFirstName = jQuery('#txtPFirstName').val();
            objApp.PLastName = jQuery('#txtPLastName').val();
            objApp.PName = jQuery('#txtPFirstName').val() + " " + jQuery('#txtPLastName').val();
            if (jQuery('#rdoDOB').is(':checked')) {
                objApp.DOB = jQuery('#<%=PatientInfo.FindControl("txtDOB").ClientID %>').val();
                objApp.Age = "";
            }
            else
                objApp.Age = jQuery('#txtAge').val() + " " + jQuery("#ddlAge option:selected").text();
            if (jQuery('#rdoMale').is(':checked'))
                objApp.Sex = "Male";
            else
                objApp.Sex = "Female";
            objApp.ContactNo = jQuery('#txtMobile').val();
            objApp.Email = jQuery('#txtEmailAddress').val();
            objApp.Address = jQuery('#txtAddress').val();
            objApp.Nationality = jQuery("#ddlCountry option:selected").text();
            objApp.City = jQuery("#ddlCity option:selected").text();
            objApp.District = jQuery("#ddlDistrict option:selected").text();
            //objApp.Taluka = jQuery("#ddlTaluka option:selected").text();
            if (jQuery("#ddlPatientType option:selected").text() != "Select")
                objApp.PatientType = jQuery("#ddlPatientType option:selected").text();
            else
                objApp.PatientType = "";
            if ((jQuery("#ddlPurposeofVisit").val() != null) && (jQuery("#ddlPurposeofVisit").val() != "0")) {
                objApp.PurposeOfVisit = jQuery("#ddlPurposeofVisit option:selected").text();
                objApp.PurposeOfVisitID = jQuery("#ddlPurposeofVisit").val();
            }
            else {
                objApp.PurposeOfVisitID = "0";
                objApp.PurposeOfVisit = "";
            }
            objApp.TypeOfApp = jQuery("#ddlTypeOfApp").val();
            objApp.VisitType = jQuery("#ddlVisitType option:selected").text();
            objApp.Date = jQuery.trim(jQuery("#txtSelectedDate").val());
            objApp.DoctorID = jQuery("#ddlDoctorList").val();
            objApp.SelectTime = jQuery.trim(jQuery("#txtSelectTime").val());
            objApp.Notes = jQuery.trim(jQuery("#txtNotes").val());
            objApp.Amount = jQuery.trim(jQuery("#lblAmount").text());
            objApp.PanelID = jQuery("#ddlPanel").val().split('#')[0];
            objApp.ItemID = jQuery.trim(jQuery("#txtItemId").val());
            objApp.SubCategoryID = jQuery("#ddlAppointmentType").val();
            if (jQuery.trim(jQuery("#txtPID").val()) != "")
                objApp.PatientID = jQuery.trim(jQuery("#txtPID").val());
            else
                objApp.PatientID = "";
            objApp.chkApp = jQuery("#chkApp").is(":checked");
            objApp.hashCode = jQuery.trim(jQuery("#txtHash").val());

            objApp.LandMark = jQuery('#txtLandMark').val();

            objApp.Pincode = jQuery('#txtPincode').val();
            objApp.Place = jQuery('#txtPlace').val();
            objApp.Occupation = jQuery('#txtOccupation').val();
            objApp.MaritalStatus = jQuery('#ddlMarried option:selected').text();
            if (jQuery('#ddlRelation').val() != "0")
                objApp.Relation = jQuery('#ddlRelation option:selected').text();
            else
                objApp.Relation = "";
            objApp.RelationName = jQuery('#txtRelationName').val();
            objApp.CountryID = jQuery("#ddlCountry").val();
            objApp.DistrictID = jQuery('#ddlDistrict').val();
            objApp.CityID = jQuery("#ddlCity").val();
            // objApp.TalukaID = 0;
            objApp.TalukaID = jQuery("#ddlTaluka").val();
            objApp.AdharCardNo = jQuery.trim(jQuery("#txtAdharCardNo").val());
            objApp.RateListID = jQuery.trim(jQuery("#lblRateListID").text());
            data.push(objApp);
            return data;
        }
        function bindHashCode() {
            jQuery.ajax({
                url: "../Common/CommonService.asmx/bindHashCode",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    jQuery('#txtHash').val(result.d);
                },
                error: function (xhr, status) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            });
        }
        function bindAppPanel() {
            jQuery("#ddlPanel option").remove();
            jQuery.ajax({
                url: "../Common/CommonService.asmx/bindPanel",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    panel = jQuery.parseJSON(result.d);
                    for (i = 0; i < panel.length; i++) {
                        jQuery("#ddlPanel").append(jQuery("<option></option>").val(panel[i].PanelID + "#" + panel[i].ReferenceCodeOPD).html(panel[i].Company_Name));
                    }
                    jQuery("#ddlPanel").val('<%=Resources.Resource.DefaultPanelID %>' + '#' + '<%=Resources.Resource.DefaultPanelID %>');
                },
                error: function (xhr, status) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            });
        }
    </script>
    <script type="text/javascript">
        function clearAppControl() {
            jQuery("input[type=text], textarea").val('');
            jQuery("select").not('#ctl00_ddlUserName,#ddlCountry,#ddlCity').prop('selectedIndex', 0);
            jQuery("select").removeAttr('disabled');
            bindHashCode();
            if ((jQuery("#ddlCountry option:selected").text != '<%=Resources.Resource.DefaultCountry%>') && (jQuery("#ddlCity option:selected").text != '<%=Resources.Resource.DefaultCity%>'))
                getCountry();

            jQuery('#txtBarcode,#ddlPanel').removeAttr('disabled');
            jQuery('#rdoAge').prop('checked', false);
            jQuery('#rdoDOB').prop('checked', true);
            jQuery('#rdoMale').prop('checked', true);
            jQuery('#btnAppSave').attr('disabled', true).val("Save");
            jQuery("#ddlPanel").val('<%=Resources.Resource.DefaultPanelID %>' + '#' + '<%=Resources.Resource.DefaultPanelID %>');

            var TypeOfApp = jQuery("#spnTypeOfApp").text()
            jQuery("#ddlTypeOfApp option:selected").text(TypeOfApp);
            if (jQuery("#OldPatient").is(':visible'))
                jQuery("#OldPatient").removeAttr('disabled');
            jQuery('#lblAmount,#lblRateListID').text('0');
            jQuery('#lblDocSchedule,#lblDocScheduleTime').text('');
            jQuery('#btnDoctorSchedule,#ddlVisitType').attr('disabled', 'disabled');
            jQuery("input[type=text], textarea").not(jQuery("#txtDOB,#txtPID")).prop('readOnly', false);
            jQuery('#btnAppSave').attr('disabled', 'disabled').val("Save");
            jQuery('#spnDOB,#spnRelation,#spnOldPID,#txtOldPID').hide();
            jQuery('#spnAge,#txtPID').show();
            jQuery('.patientLastVisit').hide();
        }
    </script>
    <script type="text/javascript">
        function UpdateAppointment() {
            jQuery('#btnAppUpdate').attr('disabled', true).val("Submitting...");
            if (validateAppointment() == true) {
                var data = new Array();
                var obj = new Object();
                obj.SelectTime = jQuery("#txtSelectTime").val();
                obj.App_ID = jQuery("#lblAppID").text();
                obj.DoctorID = jQuery("#ddlDoctorList").val();
                obj.Date = jQuery("#txtSelectedDate").val();
                obj.chkApp = jQuery("#chkApp").is(":checked");
                data.push(obj);
                if (data.length > 0) {
                    jQuery.ajax({
                        url: "Services/AppointmentNew.asmx/UpdateApp",
                        data: JSON.stringify({ Data: data }),
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            NewAppNo = result.d;
                            if (NewAppNo != "") {
                                var url = '<%=Util.GetString(Request.QueryString["RedirectUrl"])%>';
                                    jQuery("#spnErrorMsg").text('Record Saved Successfully');
                                    alert('New Appointment No. :' + NewAppNo + '');
                                    location.href = '<%=Util.GetString(Request.QueryString["RedirectUrl"])%>';
                                }
                            },
                            error: function (xhr, status) {
                                jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            }

                        });
                    }
                }
            }
            var AppID;
            function AppID() {
                AppID = '<%=Util.GetString(Request.QueryString["App_ID"])%>';
            if (AppID != "") {

                jQuery(':text, textarea').prop('readonly', 'readonly');
                jQuery("input:radio,#OldPatient,#btnTypeOfApp,#btnPurposeofVisit,#btnRefferBy").attr('disabled', 'disabled');
                jQuery("#txtDOB,#ddlDoctorList,#ddlTitle,#ddlAge,#ddlCountry,#ddlCity,#ddlRelation,#ddlDepartment,#ddlTypeOfApp,#pop1,#ddlPurposeofVisit,#ddlDistrict,#ddlCity,#ddlTaulka,#ddlPatientType,#ddlReferDoctor").attr('disabled', 'disabled');
                jQuery('#btnAppSave').hide();
                jQuery('#btnAppUpdate').show();
                jQuery('#lblHeader').text('Reschedule Appointment');
                bindTitle();
                bindRelation();
                getCountry();

                bindReferDoctor();
                bindPatientDetailApp(AppID);
            }
            else {
                jQuery('#btnAppUpdate').hide();
                jQuery('#btnAppSave').show();
                //   setDayforDoc();
                bindDocTimingDateWise();
            }
        }
        function bindPatientDetailApp(AppID) {

            jQuery.ajax({
                url: "NewAppointment.aspx/bindAppDetail",
                data: '{ App_ID: "' + AppID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    appDetail = jQuery.parseJSON(result.d);
                    if (appDetail != null) {
                        jQuery("#ddlTitle").val(appDetail[0].Title);
                        jQuery("#txtPFirstName").val(appDetail[0].PFirstName);
                        jQuery("#txtPLastName").val(appDetail[0].PlastName);

                        if (appDetail[0].dateb != "01-Jan-0001") {
                            jQuery('#<%=PatientInfo.FindControl("txtDOB").ClientID %>').val(appDetail[0].dateb);
                            jQuery("#rdoDOB").prop('checked', true);
                            jQuery("#rdoAge").prop('checked', false);
                        }
                        else {
                            jQuery("#txtAge").val(appDetail[0].Age.split(' ')[0]);
                            jQuery("#ddlAge option:selected").text(appDetail[0].Age.split(' ')[1]);
                            jQuery("#rdoAge").prop('checked', true);
                            jQuery("#rdoDOB").prop('checked', false);
                        }
                        jQuery("#txtMobile").val(appDetail[0].ContactNo);
                        jQuery("#txtEmailAddress").val(appDetail[0].Email);
                        if (appDetail[0].Relation != "")
                            jQuery("#ddlRelation option:selected").text(appDetail[0].Relation);
                        jQuery("#txtRelationName").val(appDetail[0].RelationName);
                        jQuery("#txtAddress").val(appDetail[0].Address);

                        jQuery("#ddlCountry option:selected").text(appDetail[0].Nationality);
                        jQuery('#ddlDistrict option:selected').text(appDetail[0].District);
                        jQuery("#ddlCity option:selected").text(appDetail[0].City);
                        jQuery('#ddlTaulka option:selected').text(appDetail[0].Taluka);

                        jQuery("#ddlPanel").val(appDetail[0].PanelID).attr('disabled', 'disabled');
                        jQuery("#ddlVisitType option:selected").text(appDetail[0].VisitType);
                        if (appDetail[0].PurposeOfVisitID != "0")
                            jQuery("#ddlPurposeofVisit").val(appDetail[0].PurposeOfVisitID);
                        jQuery("#ddlTypeOfApp option:selected").text(appDetail[0].TypeOfApp1);
                        jQuery("#ddlVisitType").val('2');

                        jQuery("#ddlDoctorList").val(appDetail[0].DoctorID).attr('disabled', 'disabled');

                        jQuery("#txtAdharCardNo").val(appDetail[0].AdharCardNo);
                        if (appDetail[0].PatientType != "")
                            jQuery("#ddlPatientType option:selected").text(appDetail[0].PatientType);
                        jQuery("#txtNotes").val(appDetail[0].Notes);
                        jQuery("#lblAmount").text(appDetail[0].Amount);
                        jQuery("#lblAppID").text(appDetail[0].App_ID);
                       ///////////---------Ankur--------------//////////////

                        jQuery('#txtLandMark').val(appDetail[0]["LandMark"]);

                        jQuery('#txtPincode').val(appDetail[0]["PinCode"]);
                        jQuery('#txtPlace').val(appDetail[0]["Place"]);
                        jQuery('#txtOccupation').val(appDetail[0]["Occupation"]);
                        if (appDetail[0]["MaritalStatus"] == "Married")
                            jQuery('#ddlMarried').val(1).attr('disabled', 'disabled');
                        else if (appDetail[0]["MaritalStatus"] == "Unmarried")
                            jQuery('#ddlMarried').val(2).attr('disabled', 'disabled');
                        else
                            jQuery('#ddlMarried').val(0).attr('disabled', 'disabled');
                       /////////////////////////////////////

                        jQuery("#txtItemId").val(appDetail[0].ItemID);
                        jQuery.ajax({
                            url: "NewAppointment.aspx/bindAppointmentDetail",
                            data: '{ App_ID: "' + AppID + '"}',
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            async: false,
                            success: function (result) {
                                appointmentDetail = jQuery.parseJSON(result.d);
                                if (appointmentDetail != null) {
                                    var i = appointmentDetail.length;
                                    jQuery("#lblDocSchedule").text(" Previous Appointment Date Is :" + appointmentDetail[0].AppDate + " ");
                                    jQuery("#lblDocScheduleTime").text('Appointment Time From :' + appointmentDetail[0].AppTime + ' To  ' + appointmentDetail[0].maxAppTime + ' ');
                                }
                            },
                            error: function (xhr, status) {
                                jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');

                            }
                        });
                        jQuery.ajax({
                            url: "NewAppointment.aspx/bindSubCategory",
                            data: '{ ItemID: "' + jQuery("#txtItemId").val() + '"}',
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            async: false,
                            success: function (result) {
                                var subCategory = jQuery.parseJSON(result.d);
                                if (subCategory != null)
                                    jQuery("#ddlAppointmentType").val(subCategory[0].SubCategoryID).attr('disabled', 'disabled');
                            },
                            error: function (xhr, status) {
                                jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            }
                        });
                        chkConfirmCon();

                       // setDayforDoc();

                        jQuery('#btnNewDistrict,#btnNewTaluka,#btnNewCity').attr('disabled', 'disabled');
                        jQuery("#btnDoctorSchedule").removeAttr('disabled');
                        setDayforDoc();
                        bindDocTimingDateWise();

                    }
                },
                error: function (xhr, status) {
                    jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function chkConfirmCon() {
            //if (jQuery("#ddlTypeOfApp").val() != null) {
            if ((jQuery("#ddlTypeOfApp option:selected").text() == "Walk-In"))
                jQuery("#chkApp").prop('checked', true);
            else
                jQuery("#chkApp").prop('checked', false);
        }
        // }
        jQuery(function () {
            chkConfirmCon();
        });
    </script>
    <script type="text/javascript">
        function bindDocTimingDateWise() {
            jQuery.ajax({
                url: "../Common/CommonService.asmx/docTimingDateWise",
                data: '{ DoctorID: "' + jQuery("#ddlDoctorList").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d != "") {
                        DocTimingDateWise = jQuery.parseJSON(result.d);
                        if (DocTimingDateWise != null) {
                            var output = jQuery('#tb_grdDocTimingDateWise').parseTemplate(DocTimingDateWise);
                            jQuery('#docTimingDateWiseOutput').html(output);
                            jQuery('#docTimingDateWiseOutput').show();
                        }
                    }
                    else {
                        jQuery('#docTimingDateWiseOutput').html('');
                        jQuery('#docTimingDateWiseOutput').hide();

                    }
                },
                error: function (xhr, status) {

                }
            });
        }
   </script>
    <script id="tb_grdDocTimingDateWise" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_DocShareSearch"
    style="width:160px;border-collapse:collapse;text-align:center">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Year</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Month</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Date</th>
</tr>
       <#
              var dataLength=DocTimingDateWise.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;
        for(var j=0;j<dataLength;j++)
        {

        objRow = DocTimingDateWise[j];
            #>
                    <tr id="<#=j+1#>">
 <td  class="GridViewLabItemStyle"><#=objRow.DocYear#></td>                       
<td  class="GridViewLabItemStyle"><#=objRow.DocMonth#></td>
<td class="GridViewLabItemStyle"><#=objRow.DocDate#></td>
</tr>

            <#}#>
     </table>
   
    </script>
 
</asp:Content>

