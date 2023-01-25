<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FinanceRevenue.aspx.cs"
    Inherits="Design_CommonReports_FinanceRevenue" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
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
            $('.multiselect').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false, width: 100
            });
            $(".multiselect").width('100%');
            
            $bindCentre();
            $bindRevenueCenter();
        });
        $.fn.listbox = function (params) {
            try {
                var elem = this.empty();
                if (params.defaultValue != null || params.defaultValue != '')
                    $.each(params.data, function (index, data) {
                        var dataAttr = {};
                        var option = $(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]).attr('data', JSON.stringify(dataAttr));
                        $(params.customAttr).each(function (i, d) { $(option).attr(d, data[d]); });
                        elem.append(option);

                    });
                if (params.selectedValue != null || params.selectedValue != '' || params.selectedValue != undefined)
                    $(elem).val(params.selectedValue);


                if (params.isSearchAble || params.isSearchable) {
                    $(elem).multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                }
            } catch (e) {
                console.error(e.stack);
            }
        };
        var $bindCentre = function () {
            serverCall('SICReport.aspx/BindCentre', {}, function (response) {
                Centre = $('#ddlCentre');
                var DefaultCentre = '<%=Session["CentreID"].ToString() %>';
                  Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false, selectedValue: DefaultCentre });
              });
          }

        var $bindRevenueCenter = function () {
            
            serverCall('FinanceRevenue.aspx/BindRevenue', {}, function (response) {
                RevenueCentre = $('#lstrevenue');
                RevenueCentre.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'RevenueID', textField: 'RevenueName', isSearchAble: true });
            });
        }

          var getExcelReports = function () {
              data = {
                  centreID: Number($('#ddlCentre').val()),
                  fromDate: $('#txtFromDate').val(),
                  toDate: $('#txtToDate').val(),
                  reporttype: $('#ddlreporttype').val(),
                  RevenueID: Getmultiselectvalue($('#lstrevenue')),
                  RevenueType: $('#ddlRevenueType').val()
              }
              serverCall('FinanceRevenue.aspx/GetExcelReports', data, function (response) {
                  var responseData = JSON.parse(response);
                  if (responseData.status)
                      window.open(responseData.responseURL);
                  else
                      modelAlert(responseData.message);
              });
          }

          function Getmultiselectvalue(controlvalue) {
              var DepartmentID = "";
              var input = "";
              var SelectedLaength = $(controlvalue).multipleSelect("getSelects").join().split(',').length;
              if (SelectedLaength > 1)
                  DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
              else {
                  if ($(controlvalue).val() != null) {
                      DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
                  }
              }
              return DepartmentID;
          }


      </script>
    <cc1:ToolkitScriptManager ID="scManager" runat="server"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Finance Revenue Report
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
                              <option value="S">Summary</option>
                              <option value="D">Detailed</option>
                          </select>
                       </div>
                     
                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">Revenue</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
            <asp:ListBox ID="lstrevenue" CssClass="multiselect" SelectionMode="Multiple" placeholder="Select Revenue" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Revenue Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlRevenueType">
                                <option value="1">Discharged</option>
                                <option value="2">Un-Disachrged</option>
                            </select>
                        </div>
                    </div>

                                 <div class="row">
                                     <span style="font-size:xx-small;font-style:italic;color:red;font-weight:bold">NOTE: This report is generated as per bill date.</span>
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
