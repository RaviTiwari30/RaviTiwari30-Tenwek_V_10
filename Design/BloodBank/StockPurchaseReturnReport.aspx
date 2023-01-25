<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="StockPurchaseReturnReport.aspx.cs" Inherits="Design_BloodBank_StockPurchaseReturnReport" %>

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
            <b>Direct Blood Stock Purchase/Return Report
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
                                Orgnization
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlOrganisation" title="Select Organisation"></select>
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
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlBloodGroup" title="Select Blood Group"></select>
                        </div>
                    </div>
                    <div class="row">
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
                        <div class="col-md-3">
                           <label class="pull-left">
                            Type
                            </label>
                            <b class="pull-right">:</b>
                          </div>                
                        <div class ="col-md-5">
                             <asp:RadioButtonList ID="rdbReportType" runat="server" ClientIDMode="Static"
                                CssClass="ItDoseRadiobuttonlist" Font-Bold="True" Font-Size="Small"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Text="ALL" Value="All"></asp:ListItem>
                                <asp:ListItem Text="Purchase" Value="Purchase"></asp:ListItem>
                                <asp:ListItem Text="Return" Value="Return"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre " />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal" Height="16px">
                            </asp:CheckBoxList>
                        </div>
                    </div>   
                    </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button id="btnSearch" runat="server" Text="Report" tabindex="4" class="ItDoseButton" ClientIDMode="Static" OnClientClick="return PrintReport(this);" />
        </div>


    </div>
    <script type="text/javascript">
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

             if (status == true) {
                 $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
             }
             else {
                 $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
             }
         }
         function chkCentreCon() {
             if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
         }

        $(document).ready(function () {
            LoadOrganisation();
            LoadComponent();
            LoadBloodGroup();
        });
        function LoadOrganisation() {
            serverCall('StockPurchaseReturnReport.aspx/LoadOrganisation', {}, function (response) {
                ddlOrganisation = $('#ddlOrganisation');
                ddlOrganisation.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'id', textField: 'organisaction', isSearchAble: false });
            });
        }
        function LoadComponent() {
            serverCall('StockPurchaseReturnReport.aspx/LoadComponent', {}, function (response) {
                ddlComponent = $('#ddlComponent');
                ddlComponent.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'ComponentName', isSearchAble: false });
            });
        }
        function LoadBloodGroup() {
            serverCall('StockPurchaseReturnReport.aspx/LoadBloodGroup', {}, function (response) {
                ddlBloodGroup = $('#ddlBloodGroup');
                ddlBloodGroup.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });
            });
        }

    </script>
    <script type="text/javascript">
        function PrintReport(btn) {
            var Organisation = $('#ddlOrganisation option:selected').html();
            var Component = $('#ddlComponent option:selected').val();
            var BloodGroup = $('#ddlBloodGroup option:selected').html();
            var fromDate = $.trim($('#fromDate').val());
            var toDate = $.trim($('#ToDate').val());
            var ReportType = $('#rdbReportType input:checked').val();
            
            var selectedCentreIDs = [];
            $('#chkCentre input[type=checkbox]:checked').each(function () {
                selectedCentreIDs.push(this.value);
            });

            if (selectedCentreIDs == "")
            {
                modelAlert('Please Select Centre !!');
                return false;
            }
            serverCall('StockPurchaseReturnReport.aspx/SearchReport', { Organisation: Organisation, Component: Component, BloodGroup: BloodGroup, fromDate: fromDate, toDate: toDate, ReportType: ReportType, selectedCentreIDs: selectedCentreIDs }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    modelAlert(responseData.response);
            });
        }

    </script>
</asp:Content>