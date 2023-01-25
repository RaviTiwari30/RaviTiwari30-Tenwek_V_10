<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="UnPost.aspx.cs" Inherits="Design_Payroll_UnPost" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Un Post Salary </b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <br />
            <table width="100%">
                <tr>
                    <td style="width: 30%" align="right">Salary Month :&nbsp;
                    </td>
                    <td style="width: 30%" align="left">
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                    </td>
                    <td style="width: 30%">
                        <asp:Button ID="btnUnPostSalary" OnClientClick="return confirm('Are You Sure? Un-Post Salary');"
                            Visible="true" runat="server" ToolTip="Click to Un Post Salary" Text="Un-Post Salary" OnClick="btnUnPostSalary_Click" CssClass="ItDoseButton" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>