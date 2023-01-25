<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientBillPrint.aspx.cs" Inherits="Design_Finance_PatientBillPrint" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
      <script type="text/javascript" src="../../Scripts/Message.js"></script>

</head>
<body>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript" ></script>
    <script type="text/javascript" >
        $(document).ready(function () {
            $('[id$=chkSuppressReceipt]').click(function () {
                $("[id$=chkSelect]").attr('checked', this.checked);
            });
            $("[id$=chkSelect]").click(function () {
                if ($('[id$=chkSelect]').length == $('[id$=chkSelect]:checked').length) {
                    $('[id$=chkSuppressReceipt]').attr("checked", "checked");
                }
                else {
                    $('[id$=chkSuppressReceipt]').removeAttr("checked");
                }
            });
        });

    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Corpse Bill Print</b>
            </div>
            <div class="POuter_Box_Inventory">
                <table cellpadding="0" cellspacing="0" style="width: 100%">                    <tr>
                        <td style="height: 20px; text-align: center;" colspan="2">
                            <asp:CheckBox ID="chkSuppressReceipt" runat="server" CssClass="ItDoseCheckbox" Font-Bold="true" Text="Show Receipt/Refund in Bill" Checked="True" AutoPostBack="False" OnCheckedChanged="chkSuppressReceipt_CheckedChanged" /></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <asp:GridView ID="grdReceipt" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Select">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" Checked="True" AutoPostBack="False" />

                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Receipt No.">
                                        <ItemTemplate>
                                            <asp:Label ID="lblReceipt" runat="server" Text='<%# Eval("ReceiptNo") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Amount Paid">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAmountPaid" runat="server" Text='<%# Eval("AmountPaid") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Date">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Date") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Type">
                                        <ItemTemplate>
                                            <asp:Label ID="lblType" runat="server" Text='<%# Eval("Type") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Transaction_ID" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTID" runat="server" Text='<%# Eval("Transaction_ID") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 25%"></td>
                        <td style="width: 25%"></td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    &nbsp;<br />
                    <br />
                    &nbsp;&nbsp;
    <asp:Button ID="btnDetailBill" runat="server" OnClick="btnDetailBill_Click" Text="Detailed Bill" CssClass="ItDoseButton" />
                    &nbsp;&nbsp;
     <asp:Button ID="btnSummaryBill" runat="server" OnClick="btnSummaryBill_Click" Text="Summarized Bill" CssClass="ItDoseButton" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
