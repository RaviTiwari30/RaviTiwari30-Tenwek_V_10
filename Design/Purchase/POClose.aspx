<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="POClose.aspx.cs" Inherits="Design_Purchase_POClose" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <Ajax:ScriptManager ID="sm" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Purchase Order Close<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Order No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPONo" runat="server" CssClass="ItDoseTextinputText"
                                ValidationGroup="PREdit" MaxLength="20">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPONo"
                                Display="None" ErrorMessage="Specify Order No" SetFocusOnError="True" ValidationGroup="PREdit">*</asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-2"></div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" ValidationGroup="PREdit"
                                OnClick="btnSearch_Click" />
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true"
                                ShowSummary="false" ValidationGroup="PREdit" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Order Details
            </div>
            <div>
                <asp:GridView ID="gvOrderDetail" runat="server" AutoGenerateColumns="False" Width="100%" CssClass="GridViewStyle">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Order No." HeaderStyle-Width="135px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>

                                <asp:Label ID="lblOrderNo" runat="server" Text='<%#Eval("PurchaseOrderNo")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>

                                <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Free" HeaderStyle-Width="45px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Util.GetBoolean(Eval("Free"))?"Yes":"No" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="App. Qty." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>

                                <asp:Label ID="lblAppQty" runat="server" Text='<%#Eval("ApprovedQty")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>

                                <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disc." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>

                                <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("Discount_p")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tax" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Repeater ID="rpTax" runat="server">
                                    <ItemTemplate>
                                        <div><%# Eval("TaxName")%> &nbsp;&nbsp;:&nbsp;<%# Eval("TaxPer")%></div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Vendor Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>

                                <asp:Label ID="lblVendorName" runat="server" Text='<%#Eval("VendorName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Rec. Qty." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblRecQty" runat="server" Text='<%#Eval("RecievedQty")%>'></asp:Label>
                                <asp:Label ID="lblVendorID" Visible="False" runat="server" Text='<%#Eval("VendorID")%>'></asp:Label>
                                <asp:Label ID="lblItemID" Visible="False" runat="server" Text='<%#Eval("ItemID")%>'></asp:Label>

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Narration
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Narration
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:TextBox ID="txtNarration" runat="server" Height="57px" TextMode="MultiLine"
                                Width="569px" ValidationGroup="n">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNarration"
                                Display="None" ErrorMessage="Narration" SetFocusOnError="True" ValidationGroup="n">*</asp:RequiredFieldValidator>
                            <asp:ValidationSummary ShowMessageBox="true" ID="ValidationSummary2" runat="server"
                                ValidationGroup="n" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-5">
                            <asp:Button ID="btnSave" OnClick="btnSave_Click" CssClass="ItDoseButton" runat="server" Text="Save" ValidationGroup="n" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div>

</asp:Content>
