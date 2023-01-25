<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="GSTReport.aspx.cs" Inherits="Design_Store_GSTReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <script type="text/javascript">
           $(function () {
               $('#ucFromDate').change(function () {
                   ChkDate();
               });
               $('#ucToDate').change(function () {
                   ChkDate();
               });
           });
           function ChkDate() {
               $.ajax({
                   url: "../Common/CommonService.asmx/CompareDate",
                   data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                   type: "POST",
                   dataType: "json",
                   contentType: "application/json; charset=utf-8",
                   success: function (mydata) {
                       var data = mydata.d;
                       if (data == false) {
                           $('#lblMsg').text('To date can not be less than from date!');
                           $('#btnSearch').attr('disabled', 'disabled');
                           $("#tbAppointment table").remove();
                       }
                       else {
                           $('#lblMsg').text('');
                           $('#btnSearch').removeAttr('disabled');
                       }
                   }
               });
           }
       
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>GST Report</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
   <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                       <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                              <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="todate" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server"  ></asp:DropDownList>
                        </div>
                    </div> 
                    <div class="row">
                        <div class="col-md-3">
                             <asp:CheckBox ID="chkGroupHead" runat="server" Text="GROUP HEAD" TextAlign="Left" />
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:DropDownList ID="ddlGroup" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlGroup_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div> 
                          <div class="col-md-3">
                              <asp:CheckBox ID="chkItem" runat="server" Text="ITEM NAME" TextAlign="Left" />
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                          <asp:DropDownList ID="ddlItem" runat="server" >
                            </asp:DropDownList>
                        </div>
                        
                         </div> 
                    
                          <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Format Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                              <asp:RadioButtonList ID="rblFormattype" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="1">Bill-Wise</asp:ListItem>
                                 <asp:ListItem Value="2">Item-Wise</asp:ListItem>
                                  <asp:ListItem Value="3">HSN-Wise</asp:ListItem>
                                  <asp:ListItem Value="4">Detail</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:RadioButtonList ID="rbtReportType" runat="server" RepeatDirection="Horizontal">
                                 <asp:ListItem Selected="True" Value="1">Sale Issue</asp:ListItem>
                                 <asp:ListItem Value="2">Sale Return</asp:ListItem>
                                 <asp:ListItem Value="3">Purchase</asp:ListItem>
                                 <asp:ListItem Value="4">Purchase Return</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div> 
</div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click" ClientIDMode="Static" />
        </div>
         </div>
</asp:Content>

