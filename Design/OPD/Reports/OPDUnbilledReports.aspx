<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDUnbilledReports.aspx.cs" Inherits="Design_OPD_OPDUnbilledReports" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">


        $(document).ready(function () {
            $bindDoctor(function () { });
        });


        var getSearchResults = function () {

            var data = {
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                patientID: $.trim($('#txtUHID').val()),
                searchType: Number($('#ddlSearchType').val()),
                doctorID: $('#ddlDoctor').val()
            };

            if (data.doctorID == '0')
                data.doctorID = '';

            serverCall('OPDUnbilledReports.aspx/GetUnbilled', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open('../../../Design/common/ExportToExcel.aspx');
                else
                    modelAlert("No Record Found");
            });

        }



        var $bindDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../../common/CommonService.asmx/bindDoctorDept', { Department: 'All' }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }
    </script>




    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Unbilled Items Analysis  </b>
            <cc1:ToolkitScriptManager runat="server" ID="scrPT"></cc1:ToolkitScriptManager>
        </div>
        <div class="POuter_Box_Inventory ">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtFromDate" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExteFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtToDate" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtenderToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">UHID NO. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtUHID" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSearchType">
                                <option value="0">All</option>
                                <option value="1">Appointment</option>
                                <option value="2">Consuables</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Doctor</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctor">
                            </select>
                        </div>
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-5">
                        </div>


                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter ">
            <input type="button" value="Search" onclick="getSearchResults(this)" class="margin-top-on-btn save" />
        </div>
    </div>

</asp:Content>

