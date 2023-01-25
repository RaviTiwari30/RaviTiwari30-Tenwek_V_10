<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DoctorwiseRevenue.aspx.cs" Inherits="Design_Finance_ServicewiseBillingDetai" MasterPageFile="~/DefaultHome.master" StylesheetTheme="Theme1" %>
<%@ Register Src="../Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
<div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory">
    <div class="content">
    <div style="text-align:center;">
    <b>Doctorwise Revenue</b>
    <br />
    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
    </div>
    </div>
    </div>
    <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">
    Report Critaria
    </div>
    <div class="content">             
        <table cellpadding="0" cellspacing="0" style="width: 75%">
            <tr>
                <td style="width: 20%; text-align: right">
                    Doctors :&nbsp;
                </td>
                <td colspan="2">
                    <asp:DropDownList ID="ddlDoctor" runat="server" CssClass="ItDoseDropdownbox" Width="325px">
                    </asp:DropDownList></td>
                <td style="width: 30%">
                    <asp:RadioButtonList ID="rbtActive" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rbtActive_SelectedIndexChanged"
                        RepeatDirection="Horizontal" Width="153px">
                        <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                        <asp:ListItem Value="0">In-Active</asp:ListItem>
                    </asp:RadioButtonList></td>
            </tr>
            <tr>
                <td style="width: 20%">
                    &nbsp;</td>
                <td style="width: 30%">
                    &nbsp;</td>
                <td style="width: 20%">
                    &nbsp;</td>
                <td style="width: 30%">
                    &nbsp;</td>
            </tr>
            <tr>
                <td style="width: 20%; text-align: right">
                    Date From :&nbsp;
                </td>
                <td style="width: 30%">
         <uc1:EntryDate ID="ucFromDate" runat="server" />
                </td>
                <td style="width: 20%; text-align: right">
                    Date To :</td>
                <td style="width: 30%">
         <uc1:EntryDate ID="ucToDate" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
            </tr>
        </table>
    </div>
    </div>
    
    <div class="POuter_Box_Inventory" style="text-align:center;">    &nbsp;<asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" Width="60px" OnClick="btnSearch_Click" />
        <asp:Button ID="btnExport" runat="server" Text="Export To Excel" CssClass="ItDoseButton" Width="122px" OnClick="btnExport_Click" Visible="False" />
        <asp:Button ID="btnOpenOffice" runat="server" Text="Export To OpenOffice" CssClass="ItDoseButton" Width="156px" OnClick="btnOpenOffice_Click" Visible="False" /></div><div class="POuter_Box_Inventory" style="text-align:center;">
        <asp:Panel ID="pnl" runat="server" Height="490" ScrollBars="Auto" Width="962px">
            <asp:GridView ID="grdDetail" runat="server" OnRowDataBound="grdDetail_RowDataBound">
            </asp:GridView>
        </asp:Panel>
        &nbsp;</div>
    rr</div>
   </asp:Content>