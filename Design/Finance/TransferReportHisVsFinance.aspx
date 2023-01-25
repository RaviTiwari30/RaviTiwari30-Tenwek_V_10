<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TransferReportHisVsFinance.aspx.cs"
    Inherits="Design_CommonReports_TransferReportHisVsFinance" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript">

        $(document).ready(function () {
            $bindCentre();
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
                    $('.DoseButton').attr('disabled', 'disabled');
                }
                else { $('.DoseButton').removeAttr('disabled'); }
            });
        }
        var $bindCentre = function () {
            serverCall('TransferReportHisVsFinance.aspx/BindCentre', {}, function (response) {
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
                  type: Number($('#ddlType').val()),
                  ReportName: $("#ddlType option:selected").text(),
                  reporttype: 'R'
              }
              serverCall('TransferReportHisVsFinance.aspx/GetExcelReports', data, function (response) {

                  var responseData = JSON.parse(response);

                  if (responseData.status)
                      window.open(responseData.URL, "_blank");
                  else
                      modelAlert(responseData.message);

              });
          }
          var getReports = function () {
              $('#PopupTable').html('');
              $('#lblperiod').text('');
              data = {
                  centreID: Number($('#ddlCentre').val()),
                  fromDate: $('#txtFromDate').val(),
                  toDate: $('#txtToDate').val(),
                  type: Number($('#ddlType').val()),
                  ReportName: $("#ddlType option:selected").text(),
                  reporttype: 'S'
              }
              serverCall('TransferReportHisVsFinance.aspx/GetExcelReports', data, function (response) {

                  var responseData = JSON.parse(response);

                  if (responseData.status) {
                      $('#divreport').show();
                      $('#lblperiod').text(responseData.period);
                      $('#PopupTable').append(CreateTableView(responseData.response, 'GridViewStyle', true)).customFixedHeader();
                      //$('#divBillDetailsDetails').html(output).customFixedHeader();
                  }
                  else {
                      $('#divreport').hide();
                      $('#lblperiod').text('');
                      $('#PopupTable').html('');
                      modelAlert(responseData.message);
                  }
              });
          }
          function CreateTableView(objArray, theme, enableHeader) {
              // set optional theme parameter
              if (theme === undefined) {
                  theme = 'mediumTable'; //default theme
              }

              if (enableHeader === undefined) {
                  enableHeader = true; //default enable headers
              }

              // If the returned data is an object do nothing, else try to parse
              var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
              var str = '<table class="GridViewStyle" style="width:99%;text-align:center" >';
              // table head
              if (enableHeader) {
                  str += '<thead><tr>';
                  for (var index in array[0]) {
                      str += '<th class="GridViewHeaderStyle" scope="col">' + index + '</th>';
                  }
                  str += '</tr></thead>';
              }

              // table body
              str += '<tbody>';
              for (var i = 0; i < array.length; i++) {
                  str += (i % 2 == 0) ? '<tr class="alt">' : '<tr>';
                  for (var index in array[i]) {
                      var ch = array[i][index] == null ? '' : array[i][index];
                      if ($.isNumeric(ch)) {
                          ch = addCommas(ch);
                          if (array.length - 1 == i) {
                              str += '<td class="GridViewItemStyle" style="text-align:right;font-weight:bold;color:red;margin-left:1px">' + ch + '</td>';
                          }
                          else
                              str += '<td class="GridViewItemStyle" style="text-align:right;margin-left:1px">' + ch + '</td>';
                      }
                      else
                          if (array.length - 1 == i) {
                              str += '<td class="GridViewItemStyle" style="text-align:left;font-weight:bold;color:red">' + ch + '</td>';
                          }
                          else { str += '<td class="GridViewItemStyle" style="text-align:left">' + ch + '</td>'; }
                  }
                  str += '</tr>';
              }
              str += '</tbody>'
              str += '</table>';
              return str;
          }
          function addCommas(nStr) {
              nStr += '';
              var x = nStr.split('.');
              var x1 = x[0];
              var x2 = x.length > 1 ? '.' + x[1] : '';
              var rgx = /(\d+)(\d{3})/;
              while (rgx.test(x1)) {
                  x1 = x1.replace(rgx, '$1' + ',' + '$2');
              }
              return x1 + x2;
          }
    </script>
    <cc1:ToolkitScriptManager ID="scManager" runat="server"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Transfer HIS Vs Finance Report
            </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2" style="font-weight:bold">
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
                            <label class="pull-left">Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ddlType" title="Select Type">
                                <option value="1">Revenue</option>
                                <option value="2">Collection</option>
                                <%--<option value="3">PurchaseReturn</option>--%>
                                <option value="4">Panel Allocation</option>
                                <%--<option value="15">Panel Due Btw Period</option>
                                <option value="5">Doctor Share</option>
                                <option value="6">Doctor allocation</option>
                                <option value="7">Panel Created Till Date</option>
                                <option value="8">Doctor Created Till Date</option>
                                <option value="9">Panel Unallocated Till To Date</option>
                                <option value="10">Purchase Order Advance</option>
                                <option value="11">Supplier Created Till Date</option>
                                <option value="12">Inventory Transfer</option>
                                <option value="13">Panel Writeoff</option>
                                <option value="14">Doctor Writeoff</option>
                                <option value="21">Service PO</option>
			                    <option value="16">Doctor Due Btw Period</option>--%>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="col-md-16" style="text-align:center;margin-left:206px">
                    <input type="button" class="ItDoseButton DoseButton" id="btnsearch" value="Search" onclick="getReports(this)" /></div>
                    <div class="col-md-4" style="text-align:right;">
                    <input type="button" class="ItDoseButton DoseButton" id="btnGetExcel" value="Get Excel" onclick="getExcelReports(this)" /></div>
                </div>
            </div>
        </div>
        
    
    <div  class="POuter_Box_Inventory" style="text-align:center;display:none;"  id="divreport">
            <label id="lblperiod" style="font-size:large;font-weight:300;color:red"></label>
                 <div id="PopupTable"  style="overflow:scroll;max-height:470px;"  ></div>
    </div>        </div>
</asp:Content>
