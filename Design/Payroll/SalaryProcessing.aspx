<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    EnableEventValidation="false" CodeFile="SalaryProcessing.aspx.cs" Inherits="Design_Payroll_SalaryProcessing" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function Disabele() {
            document.getElementById("ctl00$ContentPlaceHolder1$btnCurrentSalary").disabled = true;
            __doPostBack('ctl00$ContentPlaceHolder1$btnCurrentSalary', '')
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Salary Process </b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 20%;" align="right">Salary Month :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <%--<uc1:EntryDate ID="txtDate" runat="server" />--%>
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                    </td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnCurrentSalary" OnClientClick="Disabele()" runat="server" OnClick="btnCurrentSalary_Click"
                            Text="Start Salary Process" CssClass="ItDoseButton" ToolTip="Click to Start Salary Process" />
                    </td>
                    <td style="width: 14%; display: none">Salary&nbsp;Calculate&nbsp;On :&nbsp;
                    </td>
                    <td style="width: 25%; display: none">
                        <asp:RadioButtonList ID="rbtnCalOn" OnSelectedIndexChanged="rbtnCalOn_SelectedIndexChanged"
                            AutoPostBack="true" runat="server" RepeatDirection="horizontal" Enabled="False">
                            <asp:ListItem Text="Days" Selected="True" Value="Days"></asp:ListItem>
                            <asp:ListItem Text="Hours" Value="Hours"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 3px"></td>
                </tr>
                <tr>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td align="center" style="width: 20%"></td>
                    <td style="width: 14%"></td>
                    <td style="width: 25%"></td>
                    <td style="width: 3px"></td>
                </tr>
                <tr>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td align="center" style="width: 20%">
                        <asp:Button Visible="false" ID="Button1" runat="server" Text="Search" ToolTip="Click to Search" CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 14%"></td>
                    <td style="width: 25%"></td>
                    <td style="width: 3px"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5">&nbsp;&nbsp;
                    </td>
                    <td style="width: 3px"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:Panel ID="pnl1" runat="server" ScrollBars="Auto" Height="450" Width="950">
                    <asp:GridView ID="EmpGrid" runat="server" HeaderStyle-CssClass="GridViewHeaderStyle"
                        RowStyle-CssClass="GridViewItemStyle" CssClass="GridViewStyle">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>