<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wuc_IPDBillDetail.ascx.cs" Inherits="Design_Controls_wuc_IPDBillDetail" %>
<table style="width: 99%">
                     <tr>
                            <td style="width: 8%">&nbsp;</td>
                            <td style="width: 10%; text-align: right">Gross Bill :&nbsp;
                            </td>
                            <td style="width: 13%; text-align: left">
                                <asp:Label ID="lblGrossBillAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="width: 5%; text-align: right">Discount :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: left">
                                <asp:Label ID="lblBillDiscount" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">Net Amt. :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: left">
                                <asp:Label ID="lblNetAmount" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 6%; text-align: right">Advance :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: left">
                                <asp:Label ID="lblAdvanceAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right"></td>
                            <td style="width: 7%"; text-align: right"></td>
                        </tr>
                        <tr>
                           <td style="width: 8%">&nbsp;</td>
                            <td style="width: 10%; text-align: right">Tax&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: left">
                                <asp:Label ID="lblTaxPer" runat="server" CssClass="ItDoseLabelSp" />(%)&nbsp;&nbsp;&nbsp;</td>
                            <td style="width: 5%; text-align: right">Total&nbsp;Tax&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: left">
                                <asp:Label ID="lblTotalTax" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;</td>
                            <td style="width: 10%; text-align: right">Net&nbsp;Bill&nbsp;Amt.&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: left">
                                <asp:Label ID="lblNetBillAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;</td>
                            <td style="width: 6%; text-align: right">Round&nbsp;Off&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: left">
                                <asp:Label ID="lblRoundOff" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;                              
                            </td>
                            <td style="width: 10%; text-align: right">Remn.&nbsp;Amt.&nbsp;:&nbsp;</td>
                            <td style="width: 9%; text-align: left">
                                <asp:Label ID="lblBalanceAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;</td>
                        </tr>
                 </table>