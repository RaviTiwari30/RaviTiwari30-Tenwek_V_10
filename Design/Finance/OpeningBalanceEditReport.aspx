<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OpeningBalanceEditReport.aspx.cs" Inherits="Design_CommonReports_OpeningBalanceEditReport" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">

        $(document).ready(function () {
            $bindCentre();
        });
        var $bindCentre = function () {
            serverCall('OpeningBalanceEditReport.aspx/BindCentre', {}, function (response) {
                Centre = $('#ddlCentre');
                var DefaultCentre = '<%=Session["CentreID"].ToString() %>';
             Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false, selectedValue: DefaultCentre });
         });
     }

     var getExcelReports = function () {
         data = {
             centreID: Number($('#ddlCentre').val()),
             fromDate: $('#txtFromDate').val(),
             toDate: $('#txtToDate').val(),
             reporttype: Number($('#ddlreporttype').val())
         }
         serverCall('OpeningBalanceEditReport.aspx/GetExcelReports', data, function (response) {
             var responseData = JSON.parse(response);
             if (responseData.status)
                 window.open(responseData.URL, "_blank");
             else
                 modelAlert(responseData.message);
         });
     }

    </script>
    <cc1:ToolkitScriptManager ID="scManager" runat="server"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Opening Balance Edit Report
            </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">Centre </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ddlCentre" title="Select Centre"></select>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtFromDate" ClientIDMode="Static" runat="server" Width="150px"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-2">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtToDate" ClientIDMode="Static" runat="server" Width="150px"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ddlreporttype">
                                <option value="1">Item-Wise</option>
                                <option value="2">Bill-Wise</option>
                            </select>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <input type="button" class="ItDoseButton" id="btnGetExcel" value="Get Report" onclick="getExcelReports(this)" />

                </div>
            </div>
        </div>



    </div>

</asp:Content>

