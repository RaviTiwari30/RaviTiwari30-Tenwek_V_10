<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorShareReportNew.aspx.cs" Inherits="Design_DocAccount_DoctorShareReportNew" %>

<%@ Register TagPrefix="CE" Namespace="CuteEditor" Assembly="CuteEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .selectedRow {
            background-color: aqua !important;
        }
    </style>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Doctor Share Report</b>&nbsp;<br />
                <label id="lblMsg" class="ItDoseLblError"></label>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Filter Criteria
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Centre</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCentre" tabindex="1" onchange="onCentreChange(function(){});" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Doctor</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctor" tabindex="2"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Panel</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <select id="ddlPanel" tabindex="3"></select>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Share Month</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlShareMonth" tabindex="4" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Patient Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPatientType" tabindex="5">
                                <option value="All" selected="selected">All</option>
                                <option value="OPD">OPD</option>
                                <option value="IPD">IPD</option>
                                <option value="EMG">EMG</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Share Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlShareType" tabindex="6">
                                <option value="2" selected="selected">All</option>
                                <option value="1">Posted</option>
                                <option value="0">Not-Posted</option>
                            </select>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Doctor Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctorType" tabindex="7">
                                <option value="All" selected="selected">All</option>
                                <option value="No">Single</option>
                                <option value="Yes">Unit</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Report Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlReportType" tabindex="8">
                                <option value="1" selected="selected">Detail</option>
                                <option value="2">Summary</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left"></label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnReport" class="ItDoseButton" tabindex="9" value="Report" onclick="getDoctorShareReport(function () { });" />
        </div>
    </div>

    <script type="text/javascript">
        //*****Global Variables*******
        var DoctorSharePageChache = [];
        $(function () {
            configureDoctorSharePageChache(function () {
                $bindCentre(function () {
                    $bindPanel(function () { });
                    $bindDoctor(function () { });
                    $bindShareMonth(function () { });
                });
            });
        });

        var configureDoctorSharePageChache = function (callback) {
            serverCall('DoctorShareReportNew.aspx/bindDoctorShareControls', {}, function (response) {
                var responseData = JSON.parse(response);
                DoctorSharePageChache = responseData; //assign to global variables
                callback();
            });
        }

        var $bindCentre = function (callback) {
            var responseData = DoctorSharePageChache.filter(function (i) { return i.TypeID == 5 });
            $Centre = $('#ddlCentre');
            $Centre.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=Util.GetString(ViewState["CurrentCentreID"])%>' });
            callback($Centre.find('option:selected').text());
        }
        var $bindDoctor = function (callback) {
            var responseData = DoctorSharePageChache.filter(function (i) { return i.TypeID == 1 && i.CentreID == Number($('#ddlCentre').val()) });
            var $ddlDoctor = $('#ddlDoctor');
            $ddlDoctor.bindDropDown({ defaultValue: 'All', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: "Select" });
            callback($ddlDoctor.find('option:selected').text());
        }

        var $bindPanel = function (callback) {
            var centreId = Number($('#ddlCentre').val());
            var responseData = DoctorSharePageChache.filter(function (i) { return i.TypeID == 3 && i.CentreID == centreId });
            var $ddlPanel = $('#ddlPanel');
            $ddlPanel.bindDropDown({ defaultValue: 'All', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: "Select" });
            callback($ddlPanel.find('option:selected').text());
        }

        var $bindShareMonth = function (callback) {
            var centreId = Number($('#ddlCentre').val());

            var responseData = DoctorSharePageChache.filter(function (i) { return i.TypeID == 6 && i.CentreID == centreId });
            var $ddlShareMonth = $('#ddlShareMonth');
            $ddlShareMonth.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: "Select" });
            callback($ddlShareMonth.find('option:selected').text());
        }

        var onCentreChange = function () {
            $bindPanel(function () { });
            $bindDoctor(function () { });
            $bindShareMonth(function () { });
        }

        var getDoctorShareReport = function () {
            $('#lblMsg').text("");

            if ($('#ddlCentre').val() == "0") {
                $('#lblMsg').text("Please Select Centre");
                return false;
            }

            if ($('#ddlShareMonth').val() == "0") {
                $('#lblMsg').text("Please Select Share Month");
                return false;
            }

            data = {
                centreID: Number($('#ddlCentre').val()),
                doctorID: Number($('#ddlDoctor').val()),
                patientType: $('#ddlPatientType').val(),
                panelID: Number($('#ddlPanel').val()),
                fromDate: $('#ddlShareMonth').val().split('#')[0],
                toDate: $('#ddlShareMonth').val().split('#')[1],
                reportType: Number($('#ddlReportType').val()),
                ShareMonth: $('#ddlShareMonth option:selected').text(),
                printFormat: 'R',
                doctorType: $('#ddlDoctorType').val(),
                isPosted: Number($('#ddlShareType').val()),

            }
            serverCall('DoctorShareReportNew.aspx/GetDoctorShareReport', data, function (response) {

                var responseData = JSON.parse(response);

                if (responseData.status)
                    window.open(responseData.URL, "_blank");
                else
                    modelAlert(responseData.message);
            });
        }
    </script>
</asp:Content>
