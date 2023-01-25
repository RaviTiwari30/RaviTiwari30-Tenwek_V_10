<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SupplierMaster.aspx.cs" Inherits="Design_Equipment_Masters_SupplierMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" />
    <link href="../../../Styles/grid24.css" rel="stylesheet" type="text/css" />
    <style>
        .ItDoseDropdownbox
        {
            margin-top:0px;
        }
    </style>
</head>
<body style="margin-top: 1px; margin-left: 1px;overflow:hidden;">
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="width: 100%;">
            <div class="POuter_Box_Inventory" style="width: 100%;">
                <asp:ScriptManager ID="smManager" runat="server">
                </asp:ScriptManager>
                <div style="text-align: center">
                    <b>Supplier Master<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b>

                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <div style="text-align: center">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Supplier type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSupplierType" runat="server" CssClass="ItDoseDropdownbox" AutoPostBack="True" Style="min-width: 150px;">
                                </asp:DropDownList><span style="color: red;">*</span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" Width="190px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <span style="color: red;">*</span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Bank Name </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBankName" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Account No </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAccountNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Payment Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPaymentType" runat="server" CssClass="ItDoseDropdownbox" AutoPostBack="false" Style="min-width: 150px;">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Shipment Detail </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtShipDetail" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">TIN No </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTinNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">D.L. No </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDLNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">VAT No </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtVatNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Contact Person </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtContact" runat="server" CssClass="ItDoseTextinputText" MaxLength="200"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Mobile </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMob1" runat="server" CssClass="ItDoseTextinputText" MaxLength="15"
                                    Width="190px"></asp:TextBox><span style="color: red;">*</span>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbeMob" TargetControlID="txtTel1" FilterType="Numbers" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Phone </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTel1" runat="server" CssClass="ItDoseTextinputText" MaxLength="15"
                                    Width="190px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbeTel" TargetControlID="txtMob1" FilterType="Numbers" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Address 1 </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAdd1" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Address 2 </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAdd2" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Address 3 </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAdd3" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">City </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCity1" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Country </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCountry" runat="server" CssClass="ItDoseTextinputText" MaxLength="100"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Pin </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPinCode" runat="server" CssClass="ItDoseTextinputText" MaxLength="15"
                                    Width="190px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender runat="server" ID="ftbePinCode" TargetControlID="txtPinCode" FilterType="Numbers" />
                        </div>
                        
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Email </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="ItDoseTextinputText" MaxLength="200"
                                    Width="190px"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Credit Days </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtCreditDays" runat="server" Width="190px" MaxLength="200" CssClass="ItDoseTextinputText"></asp:TextBox>
                                <span style="color: red;">*</span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtCreditDays"
                                    FilterType="Custom, Numbers" ValidChars="0987654321" Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkActive" runat="server" Checked="True" Text="Active" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="ItDoseButton" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 1031px;">
                <div class="Equipmentheader" id="Div3" runat="server">
                </div>
                <div class="content" style="overflow: scroll; height: 190px; width: 99%;">
                    <asp:GridView ID="grdSupplier" runat="server" AutoGenerateColumns="false" CssClass="GridViewScrollHeaderStyle" OnRowCommand="grdSupplier_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Supplier" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("Vendor_ID")%>' CommandName="EditAT" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--<asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.gif"
                                        CausesValidation="false" CommandArgument='<%# Eval("Vendor_ID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                            <asp:TemplateField HeaderText="Supplier Name" ItemStyle-Width="100px">
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
                                <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="TIN No">
                                <ItemTemplate>
                                    <%#Eval("TinNo") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="D.L. No">
                                <ItemTemplate>
                                    <%#Eval("Druglicence") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Vat No">
                                <ItemTemplate>
                                    <%#Eval("VatNo") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Address1">
                                <ItemTemplate>
                                    <%#Eval("Address1")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Address2">
                                <ItemTemplate>
                                    <%#Eval("Address2") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Address3">
                                <ItemTemplate>
                                    <%#Eval("Address3") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="City">
                                <ItemTemplate>
                                    <%#Eval("City") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Country">
                                <ItemTemplate>
                                    <%#Eval("Country") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Phone">
                                <ItemTemplate>
                                    <%#Eval("Telephone") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Mobile">
                                <ItemTemplate>
                                    <%#Eval("Mobile") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Email">
                                <ItemTemplate>
                                    <%#Eval("Email")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Active">
                                <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("IsActive") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="User">
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("LastUpdatedby") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("UpdateDate") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--   <asp:TemplateField HeaderText="IPAddress">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <%# Eval("IPAddress") %>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <asp:Panel ID="pnlLog" runat="server" Style="width: 500px; border: outset; background-color: #EAF3FD; display: none;">
                <div id="Div1" class="Purchaseheader" style="text-align: center">
                    Log Detail
                </div>
                <div style="overflow: scroll; height: 250px; width: 495px; text-align: left; border: groove;">
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
    </form>
</body>
</html>
