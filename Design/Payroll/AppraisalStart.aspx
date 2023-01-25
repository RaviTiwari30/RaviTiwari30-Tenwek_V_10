<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AppraisalStart.aspx.cs" Inherits="Design_Payroll_AppraisalStart" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>
                    <asp:Label ID="lblStartDate" runat="server" Text=""></asp:Label>
                </b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <asp:Label ID="lblStartAppraisal" runat="server" Text=""></asp:Label>
            </div>
            <div class="content" style="text-align: center;">
                <table style="text-align: center; width: 909px;">
                    <tr>
                        <td></td>
                        <td align="right">
                            <asp:Label ID="lblDate" runat="server">Start Date :</asp:Label>
                        </td>
                        <td></td>
                        <td align="left">
                            <asp:TextBox ID="txtDate" runat="server" TabIndex="1" ToolTip="Select Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucToDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td colspan='4'></td>
                    </tr>
                    <tr>
                        <td colspan='4'>
                            <asp:Button ID="btnSave" runat="server" TabIndex="2" ToolTip="Click to Save" Text="Save"
                                CssClass="ItDoseButton" OnClick="btnSave_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>