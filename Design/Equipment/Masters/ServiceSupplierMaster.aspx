<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ServiceSupplierMaster.aspx.cs" Inherits="Design_Equipment_Masters_ServiceSupplierMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" />
</head>
<body style="margin-top: 1px; margin-left: 1px;">
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <asp:ScriptManager ID="smManager" runat="server">
                </asp:ScriptManager>
                <div class="content" style="text-align: center">
                    <b>Service Supplier Master</b>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div style="text-align: center">
                    <%--<table class="ItDoseLabel" style="width: 731px; height: 104px;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="text-align: right; width: 15%;">service Supplier type :&nbsp;</td>
                            <td style="text-align: left; width: 20%;" align="left">
                                <asp:DropDownList ID="ddlSupplierType" runat="server" CssClass="ItDoseDropdownbox" AutoPostBack="false">
                                </asp:DropDownList></td>
                            <td style="width: 10%" align="right">Name :&nbsp;</td>
                            <td align="left" colspan="3">
                                <asp:TextBox ID="txtname" runat="server" Width="283px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">TIN No:&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtTinNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="150px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">D.L. No :&nbsp;
                            </td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtDLNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="150px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">VAT No :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtVatNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="150px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">Contact Person :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtContact" runat="server" CssClass="ItDoseTextinputText" MaxLength="200"
                                    Width="150px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">Mobile :&nbsp;
                            </td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtTel1" runat="server" CssClass="ItDoseTextinputText" MaxLength="15"
                                    Width="150px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbeTel" TargetControlID="txtTel1" FilterType="Numbers" />

                            </td>
                            <td align="right" style="width: 10%">Phone :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtMob1" runat="server" CssClass="ItDoseTextinputText" MaxLength="15"
                                    Width="150px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbeMob" TargetControlID="txtMob1" FilterType="Numbers" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">Address 1 :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtAdd1" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="150px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">Address 2 :&nbsp;</td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtAdd2" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="150px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">Address 3 :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtAdd3" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="150px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">City :&nbsp;</td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtCity1" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="150px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">Country :&nbsp;
                            </td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtCountry" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="150px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">Pin :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtPinCode" runat="server" CssClass="ItDoseTextinputText" MaxLength="20"
                                    Width="150px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbePin" TargetControlID="txtPinCode" FilterType="Numbers" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 15%; text-align: right">Email :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="ItDoseTextinputText" MaxLength="200"
                                    Width="150px"></asp:TextBox></td>
                            <td align="right" style="width: 10%"></td>
                            <td align="left" style="width: 20%">
                                <asp:CheckBox ID="chkActive" runat="server" Checked="True" Text="Active" /></td>
                            <td align="right" style="width: 10%"></td>
                            <td align="left" style="width: 20%; text-align: left"></td>
                        </tr>
                    </table>--%>
                    <table class="ItDoseLabel" style="width: 820px; height: 147px;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="text-align: right; width: 17%;">Supplier type :&nbsp;</td>
                            <td style="text-align: left; width: 20%;" align="left">
                                <asp:DropDownList ID="ddlSupplierType" runat="server" CssClass="ItDoseDropdownbox" AutoPostBack="True">
                                </asp:DropDownList></td>
                            <td style="width: 20%" align="right">Name :&nbsp;</td>
                            <td align="left" colspan="3">
                                <asp:TextBox ID="txtname" runat="server" Width="190px" CssClass="ItDoseTextinputText"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="width: 17%; text-align: right">TIN No:&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtTinNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox></td>
                            <td align="right" style="width: 20%">D.L. No :&nbsp;
                            </td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtDLNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">&nbsp;</td>
                            <td align="left" style="width: 20%; text-align: left">&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="width: 17%; text-align: right">VAT No :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtVatNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox></td>
                            <td align="right" style="width: 20%">Contact Person :&nbsp;</td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtContact" runat="server" CssClass="ItDoseTextinputText" MaxLength="200"
                                    Width="190px"></asp:TextBox>

                            </td>
                            <td align="right" style="width: 10%">&nbsp;</td>
                            <td align="left" style="width: 20%; text-align: left">&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="width: 17%; text-align: right">Mobile :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtMob1" runat="server" CssClass="ItDoseTextinputText" MaxLength="15"
                                    Width="190px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbeTel" TargetControlID="txtTel1" FilterType="Numbers" />

                            </td>
                            <td align="right" style="width: 20%">Phone :&nbsp;
                            </td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtTel1" runat="server" CssClass="ItDoseTextinputText" MaxLength="15"
                                    Width="190px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbeMob" TargetControlID="txtMob1" FilterType="Numbers" />

                            </td>
                            <td align="right" style="width: 10%">&nbsp;</td>
                            <td align="left" style="width: 20%; text-align: left">&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="width: 17%; text-align: right">Address 1 :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtAdd1" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px" TextMode="MultiLine"></asp:TextBox></td>
                            <td align="right" style="width: 20%">Address 2 :&nbsp;</td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtAdd2" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px" TextMode="MultiLine"></asp:TextBox></td>
                            <td align="right" style="width: 10%">&nbsp;</td>
                            <td align="left" style="width: 20%; text-align: left">&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="width: 17%; text-align: right">Address 3 :&nbsp;</td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtAdd3" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px" TextMode="MultiLine"></asp:TextBox></td>
                            <td align="right" style="width: 20%">City :&nbsp;</td>
                            <td align="left" style="width: 20%">
                                <asp:TextBox ID="txtCity1" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">&nbsp;</td>
                            <td align="left" style="width: 20%; text-align: left">&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 17%; text-align: right;">Country :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left;">
                                <asp:TextBox ID="txtCountry" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox></td>
                            <td align="right" style="width: 20%">Pin :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtPinCode" runat="server" CssClass="ItDoseTextinputText" MaxLength="15"
                                    Width="190px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbePinCode" TargetControlID="txtPinCode" FilterType="Numbers" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 17%; text-align: right">Email :&nbsp;
                            </td>
                            <td align="left" style="width: 20%; text-align: left">
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="ItDoseTextinputText" MaxLength="200"
                                    Width="190px"></asp:TextBox></td>
                            <td align="right" style="width: 20%"></td>
                            <td align="left" style="width: 20%">
                                <asp:CheckBox ID="chkActive" runat="server" Checked="True" Text="Active" /></td>
                            <td align="right" style="width: 10%"></td>
                            <td align="left" style="width: 20%; text-align: left"></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <table>
                    <tr>
                        <td style="width: 52%; text-align: right;">

                            <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="ItDoseButton" />
                        </td>
                        <td style="width: 48%; text-align: left;">&nbsp;&nbsp;
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Equipmentheader" id="Div3" runat="server">
                </div>
                <div style="overflow: scroll; height: 100%; width: 100%;">
                    <asp:GridView ID="grdSupplier" runat="server" AutoGenerateColumns="false" CssClass="GridViewScrollHeaderStyle"
                        OnRowCommand="grdSupplier_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Supplier" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("Vendor_ID")%>' CommandName="EditAT" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.GIF"
                                        CausesValidation="false" CommandArgument='<%# Eval("Vendor_ID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Supplier Name">
                                <ItemTemplate>
                                    <%#Eval("VendorName") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Supplier Type">
                                <ItemTemplate>
                                    <%#Eval("SupplierTypeName") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="TIN No">
                                <ItemTemplate>
                                    <%#Eval("TinNo") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="D.L. No">
                                <ItemTemplate>
                                    <%#Eval("Druglicence") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Vat No">
                                <ItemTemplate>
                                    <%#Eval("VatNo") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Address1">
                                <ItemTemplate>
                                    <%#Eval("Address1")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Address2">
                                <ItemTemplate>
                                    <%#Eval("Address2") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Address3">
                                <ItemTemplate>
                                    <%#Eval("Address3") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="City">
                                <ItemTemplate>
                                    <%#Eval("City") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Country">
                                <ItemTemplate>
                                    <%#Eval("Country") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Phone">
                                <ItemTemplate>
                                    <%#Eval("Telephone") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Mobile">
                                <ItemTemplate>
                                    <%#Eval("Mobile") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Email">
                                <ItemTemplate>
                                    <%#Eval("Email")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Active">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("IsActive") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="User">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("LastUpdatedby") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("UpdateDate") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--    <asp:TemplateField HeaderText="IPAddress">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <%# Eval("IPAddress") %>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                        </Columns>
                    </asp:GridView>
                </div>

                <asp:Panel ID="pnlLog" runat="server" Style="width: 650px; border: outset; background-color: #EAF3FD; display: none;">
                    <div id="Div1" class="Purchaseheader" style="text-align: center">
                        Log Detail
                    </div>
                    <div style="overflow: scroll; height: 250px; width: 645px; text-align: left; border: groove;">
                        <asp:Label ID="lblLog" runat="server"></asp:Label>
                    </div>
                    <div style="text-align: center;">
                        <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton" Text="Close" />
                    </div>
                </asp:Panel>
                <cc1:ModalPopupExtender ID="mdpLog" runat="server" CancelControlID="btnClose" TargetControlID="btnHidden"
                    BackgroundCssClass="filterPupupBackground" PopupControlID="pnlLog" X="100" Y="80">
                </cc1:ModalPopupExtender>
                <div style="display: none;">
                    <asp:Button ID="btnHidden" runat="server" Text="Button" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
