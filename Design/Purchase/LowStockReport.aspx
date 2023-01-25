<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="LowStockReport.aspx.cs" Inherits="Design_Purchase_LowStockReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Low Stock Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <table>
                <tr>
                    <td style="width:576px; text-align: right;">Store Type :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:RadioButtonList ID="rbtnMedNonMed" runat="server" RepeatDirection="horizontal">
                            <asp:ListItem Text="Medical Items" Enabled="false" Value="STO00001">
                            </asp:ListItem>
                            <asp:ListItem Text="General Items" Enabled="false" Value="STO00002">
                            </asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            &nbsp;&nbsp;
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton"
                OnClick="btnSearch_Click" />
        </div>
    </div>
</asp:Content>
