<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="CentreStockTransferReport.aspx.cs" Inherits="Design_BloodBank_CentreStockTransferReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <script type="text/javascript" src="../../Scripts/Search.js"> </script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script  src="../../Scripts/json2.js" type="text/javascript"></script>
      
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Centre Stock Transfer Report
            </b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" runat="server">
                Search Criteria
            </div>
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlFromCentre" class="requiredField" title="Select From Centre"></select>
                        </div>
                       <div class="col-md-3">
                            <label class="pull-left">
                                To Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlToCentre"  title="Select to Centre"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Component
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <select id="ddlComponent" title="Select Component" ></select>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlBloodGroup" title="Select Blood Group"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:TextBox ID="fromDate" runat="server" ToolTip="Select From Date"  ClientIDMode="Static"   TabIndex="4" ></asp:TextBox>
                        <cc1:CalendarExtender ID="clcFromDate" runat="server" TargetControlID="fromDate" Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="ToDate" runat="server" ToolTip="Select To Date" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcToDate" runat="server" TargetControlID="ToDate" Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                                             
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
             <input type="button" id="btnSearch" value="Report" tabindex="4" class="ItDoseButton" onclick="PrintReport();" />
             </div>


    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadFromCentre();
            LoadToCentre();
            LoadComponent();
            LoadBloodGroup();
        });
        function LoadFromCentre() {
            serverCall('CentreStockTransferReport.aspx/LoadFromCentre', {}, function (response) {
                ddlFromCentre = $('#ddlFromCentre');
                ddlFromCentre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false });
            });
        }
        function LoadToCentre() {
            serverCall('CentreStockTransferReport.aspx/LoadToCentre', {}, function (response) {
                ddlToCentre = $('#ddlToCentre');
                ddlToCentre.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false });
            });
        }
        function LoadComponent() {
            serverCall('CentreStockTransferReport.aspx/LoadComponent', {}, function (response) {
                ddlComponent = $('#ddlComponent');
                ddlComponent.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'ComponentName', isSearchAble: false });
            });
        }
        function LoadBloodGroup() {
            serverCall('CentreStockTransferReport.aspx/LoadBloodGroup', {}, function (response) {
                ddlBloodGroup = $('#ddlBloodGroup');
                ddlBloodGroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });
            });
        }

    </script>
    <script type="text/javascript">
        function PrintReport() {
            var FromCentreID = $('#ddlFromCentre option:selected').val();
            var toCentreID = $('#ddlToCentre option:selected').val();
            var Component = $('#ddlComponent option:selected').val();
            var BloodGroup = $('#ddlBloodGroup option:selected').html();
            var fromDate = $.trim($('#fromDate').val());
            var toDate = $.trim($('#ToDate').val());

            if (FromCentreID == "0") {
                modelAlert('Please Select From Centre !!');
                return false;
            }



            serverCall('CentreStockTransferReport.aspx/SearchReport', { FromCentreID: FromCentreID, toCentreID: toCentreID, Component: Component, BloodGroup: BloodGroup, fromDate: fromDate, toDate: toDate }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    modelAlert(responseData.response);
            });

            //$.ajax({
            //    url: "CentreStockTransferReport.aspx/SearchReport",
            //    data: '{FromCentreID:"' + FromCentreID + '",toCentreID:"'+toCentreID+'",Component:"' + Component + '",BloodGroup:"' + BloodGroup + '",fromDate:"' + fromDate + '",toDate:"' + toDate + '"}',
            //    type: "POST",
            //    contentType: "application/json; charset=utf-8",
            //    timeout: 120000,
            //    async: true,
            //    dataType: "json",
            //    success: function (result) {
            //            var Data = (result.d);
            //            if (Data == "1") {
            //                window.open('../common/ExportToExcel.aspx');
            //            }
            //        else {
            //            $("#lblMsg").text('Record Not Found');
            //        }
            //    },
            //    error: function (xhr, status) {
            //        window.status = status + "\r\n" + xhr.responseText;
            //        modelAlert('Error');
            //    }
            //});
        }
    </script>
</asp:Content>