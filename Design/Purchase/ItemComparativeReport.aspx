<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="ItemComparativeReport.aspx.cs" Inherits="Design_Purchase_ItemComparativeReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Item Comparative Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="content">
                <table width="100%">
                    <tr>
                        <td style="width: 20%; text-align: right;">Report Type :&nbsp;
                        </td>
                        <td colspan="4"  style="width: 80%; text-align: left;">
                            <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal"
                                CssClass="ItDoseRadiobutton">
                                <asp:ListItem Selected="True" Text="Supplier List" Value="1" />
                                <asp:ListItem Text="Comparative Report" Value="2" />
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Groups :&nbsp;
                        </td>
                        <td colspan="4" style="width: 85%; text-align: left;">
                            <asp:CheckBoxList ID="ChkSubcategory" runat="server" CssClass="ItDoseCheckboxlist"
                                RepeatColumns="5" RepeatDirection="Horizontal" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnBinSearch" runat="server" Text="Search" CssClass="ItDoseButton"
                OnClick="btnBinSearch_Click" />
        </div>
    </div>
</asp:Content>
