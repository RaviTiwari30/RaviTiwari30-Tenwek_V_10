<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDAdvanceUtilization.aspx.cs" Inherits="Design_OPD_OPDAdvanceUtilization" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        var getSearchResults = function () {
            var data = {
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                patientID: $.trim($('#txtUHID').val()),
                searchType: Number($('#ddlSearchType').val())
            };

            serverCall('OPDAdvanceUtilization.aspx/GetOpdAdvanceUtilization', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open('../../Design/common/ExportToExcel.aspx');
            });

        }
    </script>




    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Advance Utilization Details</b>
            <cc1:ToolkitScriptManager runat="server" ID="scrPT"></cc1:ToolkitScriptManager>
        </div>
        <div class="POuter_Box_Inventory ">
            <div class="row">
                <div class="row">
                    <div class="col-md-2">
                        <label class="pull-left">From Date </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox runat="server" ID="txtFromDate" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExteFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">To Date </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox runat="server" ID="txtToDate" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtenderToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">UHID NO. </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <input type="text" id="txtUHID" />
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">Search Type </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <select id="ddlSearchType">
                            <option value="0">All</option>
                            <option value="1">Advance</option>
                            <option value="2">Advance Utilization</option>
                        </select>
                    </div>

                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter ">
            <input type="button" value="Search" onclick="getSearchResults(this)" class="margin-top-on-btn save" />
        </div>
    </div>

</asp:Content>

