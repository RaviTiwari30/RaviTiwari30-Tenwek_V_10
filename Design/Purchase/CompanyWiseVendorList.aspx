<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CompanyWiseVendorList.aspx.cs"
    Inherits="Design_Purchase_CompanyWiseVendorList" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
          
               
                    <b>Mapped Supplier & Manufacturer Report</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
               
           
        </div>
        <div class="POuter_Box_Inventory" id="DIV2">
            <div class="Purchaseheader">
                Report Criteria
            </div>
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlOrderBy" runat="server" style="margin-top:0px;" CssClass="ItDoseDropdownbox" OnSelectedIndexChanged="ddlOrderBy_SelectedIndexChanged"
                                AutoPostBack="true">
                                <asp:ListItem Value="0" Selected="True">Select</asp:ListItem>
                                <asp:ListItem Value="1">By Supplier </asp:ListItem>
                                <asp:ListItem Value="2">By Manufacturer </asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <asp:Panel ID="Panel1" runat="server" Height="300px">
            <div class="POuter_Box_Inventory">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="width: 15%; height: 300px;">
                                <asp:CheckBox ID="chkVendor" runat="server" AutoPostBack="true" Text="Select Vendor"
                                    Width="131px" OnCheckedChanged="chkVendor_CheckedChanged" />
                            </td>
                            <td colspan="4" style="height: 300px; width: 85%">
                                <asp:Panel ID="Panel3" runat="server" Height="300px" Width="100%" ScrollBars="Vertical">
                                    <asp:CheckBoxList ID="chklVendors" runat="server" RepeatDirection="Horizontal" RepeatColumns="4">
                                    </asp:CheckBoxList>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
               
            </div>
        </asp:Panel>
        <asp:Panel ID="Panel2" runat="server" Height="300px">
            <div class="POuter_Box_Inventory">
               
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="width: 15%; height: 300px;">
                                <asp:CheckBox ID="chkAllCompany" runat="server" AutoPostBack="true" Text="Select Company"
                                    Width="125px" CssClass="ItDoseCheckbox" OnCheckedChanged="chkAllCompany_CheckedChanged" />
                            </td>
                            <td colspan="4" style="height: 300px; width: 85%;">
                                <asp:Panel ID="Panel4" runat="server" Height="300px" Width="100%" ScrollBars="Vertical">
                                    <asp:CheckBoxList ID="chkCompany" runat="server" RepeatColumns="3" RepeatDirection="Horizontal"
                                        CssClass="ItDoseCheckboxlist">
                                    </asp:CheckBoxList>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
              
            </div>
        </asp:Panel>
        <div class="POuter_Box_Inventory">
          
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 15%; text-align: center;">
                            <asp:RadioButtonList ID="rdoReportFormat" Visible="false" runat="server" RepeatDirection="Horizontal"
                                CssClass="ItDoseRadiobuttonlist" Width="123px">
                                <asp:ListItem Text="PDF" Value="1" />
                                <asp:ListItem Text="Excel" Selected="True" Value="2" />
                            </asp:RadioButtonList><br />
                            <asp:Panel ID="Panel5" runat="server">
                                <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" OnClick="btnReport_Click" />
                            </asp:Panel>
                            &nbsp;
                        </td>
                    </tr>
                </table>
           
        </div>
    </div>
</asp:Content>
