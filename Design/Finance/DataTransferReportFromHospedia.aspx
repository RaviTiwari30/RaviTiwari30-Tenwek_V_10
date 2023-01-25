<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DataTransferReportFromHospedia.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_Finance_DataTransferReportFromHospedia" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript" src="../../Scripts/Message.js"></script>
      <script type="text/javascript">
          $(document).ready(function () {
              getDate();       
          });
          function getDate() {
              serverCall('../Common/CommonService.asmx/getDate', {}, function (response) {
                  $('#txtFromDate,#txtToDate').val(response);
              });
          }


          function ChkDate() {
              var data = {
                  DateFrom: $('#txtFromDate').val(),
                  DateTo: $('#txtToDate').val()
              }
              serverCall('../common/CommonService.asmx/CompareDate', data, function (response) {
                  if (response == false) {
                      $('#spnMsg').text('To date can not be less than from date!');
                      $('#btnSearch').attr('disabled', 'disabled');
                  }
                  else {
                      $('#spnMsg').text('');
                      $('#btnSearch').removeAttr('disabled');
                  }
              });
          }
</script>
     <div id="Pbody_box_inventory">
          <Ajax:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Release">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b> Data Transferd Status Report From Hospedia to Navaision</b><br />
            <asp:Label runat="server" CssClass="ItDoseLblError" ID="spnMsg" ClientIDMode="Static" ></asp:Label>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
             <div class="row">
                 <div class="col-md-3">
                     <label class="pull-left">Report Type</label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-5">
                     <asp:DropDownList ID="ddlReporttype" runat="server">
                         <asp:ListItem Value="1" Selected="True">Reveue Detail</asp:ListItem>
                         <asp:ListItem Value="2">Panel Allocation</asp:ListItem>
                         <asp:ListItem Value="3">Payment Collection</asp:ListItem>
                         <asp:ListItem Value="4">Inventory Details</asp:ListItem>
                         <asp:ListItem Value="5">Write Off</asp:ListItem>
                         <asp:ListItem Value="6">PO Advance</asp:ListItem>
                         <asp:ListItem Value="7">Supplier Created Master</asp:ListItem>
                     </asp:DropDownList>
                 </div>
                 <div class="col-md-3">
                     <label class="pull-left">From Data</label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-5">
                     <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control"   ClientIDMode="Static" onchange="ChkDate();"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate"
                                runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                 </div>
                 <div class="col-md-3">
                     <label class="pull-left">From Data</label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-5">
                     <asp:TextBox ID="txtToDate" CssClass="form-control" runat="server"   ClientIDMode="Static" onchange="ChkDate();"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate"
                                runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                 </div>

             </div>
             
             <div class="row" style="text-align:center">
                 
                 <div class="col-md-24">
                     <asp:Button ID="btnreport" runat="server" Text="Get Report" OnClick="btnreport_Click" />
                 </div>
             </div>
                 
            
         </div>
         </div>
    </asp:Content>