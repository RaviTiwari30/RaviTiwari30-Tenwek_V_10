<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="StatesReports.aspx.cs" Inherits="Design_CommonReports_StatesReports" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
     <script type="text/javascript">
         $(function () {
             $('#txtFromDate').change(function () {
                 checkdate(function () { });
             });
             $('#txtToDate').change(function () {
                 checkdate(function () { });
             });
         });
         var checkdate = function () {
             var data = {
                 DateFrom: $('#txtFromDate').val(),
                 DateTo: $('#txtToDate').val()
             };
             serverCall('../Common/CommonService.asmx/CompareDate', data, function (response) {
                 responseData = JSON.parse(response);
                 if (responseData == false) {
                     modelAlert("To date can not be less than from date!");
                     $('#btnGetExcel').attr('disabled', 'disabled');
                 }
                 else { $('#btnGetExcel').removeAttr('disabled'); }
             });
         }
         $(document).ready(function () {
             $bindCentre();
         });
       
         var $bindCentre = function () {
             serverCall('StatesReports.aspx/BindCentre', {}, function (response) {
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
                reporttype: $('#ddlreporttype').val(),
                reportName: $('#ddlreporttype option:selected').val(),
            }
            serverCall('StatesReports.aspx/GetExcelReports', data, function (response) {
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
            <b>DepartmentWise Statistics Report
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
                              <option value="1">OPD Statistics</option>
                              <option value="2">IPD Statistics</option>
<%-- <option value="3">EMG Statistics</option>--%>
                              <option value="4">Surgery Statistics</option>

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

