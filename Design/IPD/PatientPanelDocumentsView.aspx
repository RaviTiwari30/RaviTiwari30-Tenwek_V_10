<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientPanelDocumentsView.aspx.cs"
    Inherits="Design_IPD_PatientPanelDocumentsView" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Patient Panel Document Status</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory" >
                <div class="Purchaseheader">
                    Bill Details
                </div>
                <table style="width: 100%">
                    <tr>
                        <td style="width: 20%" align="right" class="ItDoseLabel">
                            Bill Amount :</td>
                        <td style="width: 5%;" class="ItDoseLabel" align="right">
                            <asp:Label ID="lblBillAmount" runat="server" CssClass="ItDoseLabelSp" /></td>
                        <td style="width: 20%;" align="right" class="ItDoseLabel">
                            Panel Company :</td>
                        <td style="width: 35%; text-align: left" class="ItDoseLabel">
                            <asp:Label ID="lblPanelNAme" runat="server" CssClass="ItDoseLabelSp" /></td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%" class="ItDoseLabel">
                            Final Approval Amount :</td>
                        <td style="width: 5%" class="ItDoseLabel" align="right">
                            <asp:Label ID="lblApprovalAmt" runat="server" CssClass="ItDoseLabelSp" ></asp:Label></td>
                        <td align="right" style="width: 20%" class="ItDoseLabel">
                            Claim No :</td>
                        <td style="width: 35%; text-align: left" class="ItDoseLabel">
                            <asp:Label ID="lblClaimNo" runat="server" CssClass="ItDoseLabelSp" ></asp:Label></td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" >
                <div class="Purchaseheader">
                    Panel Approval Details
                </div>
                <div class="content" style="text-align: center">
                    <asp:GridView ID="grdDocuments" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowDataBound="grdDocuments_RowDataBound" Width="701px" OnRowCommand="grdDocuments_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                                    <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("Status") %>' />
                                    <asp:Label ID="lblPanelDocumentID" runat="server" Visible="false" Text='<%# Eval("PanelDocumentID") %>' />
                                    <asp:Label ID="Label1" runat="server" Visible="false" Text='<%# Container.DataItemIndex+1 %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>                           
                            <asp:TemplateField HeaderText="Document Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblDocument" runat="server" Text='<%# Eval("Document") %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                            </asp:TemplateField>                            
                            <asp:TemplateField HeaderText="View">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                <asp:ImageButton ID="btnView" runat="server" ToolTip="View Document"
                                    ImageAlign="middle" CausesValidation="false" ImageUrl="~/Images/view.GIF" Enabled='<%# Util.GetBoolean(Eval("FileStatus")) %>' CommandName="VIEW" CommandArgument='<%# Eval("FilePath") %>'/>
                                    <%--<asp:Button ID="btnView" runat="server" Enabled='<%# Util.GetBoolean(Eval("FileStatus")) %>'
                                        CommandName="VIEW" CommandArgument='<%# Eval("FilePath") %>' Text="View" />--%></td>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>            
        </div>
    </form>
</body>
</html>
