<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetMasterGRN.aspx.cs" Inherits="Design_Equipment_Masters_AssetMasterGRN" %>

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
                    <b>Asset Master (From GRN)<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div>
                    <table class="ItDoseLabel" border="0">
                        <tr>
                            <td style="width: 13%; text-align: right;" align="right">Date From :&nbsp;
                            </td>
                            <td style="text-align: left;" >
                                <asp:TextBox ID="ucDateFrom" runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="cal1" TargetControlID="ucDateFrom" Format="yyyy-MM-dd" runat="server"></cc1:CalendarExtender>
                            </td>
                            <td style="text-align: right; width: 14%;">Supplier Type :&nbsp;
                            </td>
                            <td style="width: 30%; text-align: left;">
                                <asp:DropDownList ID="ddlSupplierType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSupplierType_SelectedIndexChanged"
                                    Width="220px">
                                </asp:DropDownList></td>
                            <td style="width: 10%" align="right">Grn No :&nbsp;</td>
                            <td style="width: 15%" align="left">
                                <asp:DropDownList ID="ddlGrnNo" runat="server" Width="110px">
                                </asp:DropDownList></td>
                        </tr>
                        <tr>
                            <td style="width: 13%; text-align: right" align="right">Date To :&nbsp;
                            </td>
                            <td style="text-align: left;" >
                                <asp:TextBox ID="ucDateTo" runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="ucDateTo" Format="yyyy-MM-dd" runat="server"></cc1:CalendarExtender>
                            </td>
                            <td style="width: 14%; text-align: right">Supplier :&nbsp;
                            </td>
                            <td style="width: 30%; text-align: left">
                                <asp:DropDownList ID="ddlSupplier" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSupplier_SelectedIndexChanged"
                                    Width="220px">
                                </asp:DropDownList></td>
                            <td style="width: 10%" align="right"></td>
                            <td style="width: 15%" align="left">
                                <asp:Button ID="btnShowItem" runat="server" Text="Show Items" CssClass="ItDoseButton" OnClick="btnShowItem_Click" /></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Equipmentheader" id="Div2" runat="server">
                </div>
                <div class="content" style="overflow: scroll; height: 200px; width: 99%;">
                    <asp:GridView ID="grdGRN" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" EnableModelValidation="True" OnRowCommand="grdGRN_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="SelectItem">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Asset" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("itemid")+"#"+Eval("itemname") %>' CommandName="EditData" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="GRN No">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("grnno") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="GRN Date">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("grndate") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ItemName">
                                <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("itemname") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Qty">
                                <ItemTemplate>
                                    <%#Eval("qty") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ItemType">
                                <ItemTemplate>
                                    <%#Eval("ItemType")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Supplier">
                                <ItemTemplate>
                                    <%#Eval("VendorName") %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 52%; text-align: right;">&nbsp;</td>
                        <td style="width: 48%; text-align: left;">&nbsp;&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Equipmentheader" id="Div3" runat="server">
                </div>
                <div class="content" style="overflow: scroll; height: 200px; width: 99%;">
                    <asp:GridView ID="grdAsset" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="grdAsset_RowCommand" EnableModelValidation="True" Width="998px">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Asset" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="EditData" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.GIF"
                                        CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("ItemName") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Asset Code">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate>
                                    <%#Eval("assetcode") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Model No">
                                <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("modelno") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Serial No">
                                <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("serialno") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Acquired Date">
                                <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("acquireddate") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Is Active">
                                <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("isactive") %>
                                </ItemTemplate>
                            </asp:TemplateField>
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




            <asp:Panel ID="Panel1" runat="server" Style="width: 600px; border: outset; background-color: #EAF3FD;">
                <div id="Div4" class="Purchaseheader" style="text-align: center">
                    Asset Detail
                </div>
                <table cellpadding="2" class="auto-style2">
                    <tr>
                        <td class="auto-style3">&nbsp;</td>
                        <td>Item Name</td>
                        <td>
                            <asp:TextBox ID="txtitemname" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                            <asp:Label ID="lbit" runat="server" Visible="False"></asp:Label>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="auto-style3">&nbsp;</td>
                        <td>Asset Code</td>
                        <td>
                            <asp:TextBox ID="txtassetcode" runat="server" Width="150px"></asp:TextBox>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="auto-style3">&nbsp;</td>
                        <td>Serial No</td>
                        <td>
                            <asp:TextBox ID="txtserial" runat="server" Width="150px"></asp:TextBox>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="auto-style3">&nbsp;</td>
                        <td>Model No</td>
                        <td>
                            <asp:TextBox ID="txtmodel" runat="server" Width="150px"></asp:TextBox>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="auto-style3">&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>
                            <asp:CheckBox ID="chk" runat="server" Text="Is Active" Checked />
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
                <div style="text-align: center;">
                    <asp:Button ID="btn_saveasset" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btn_saveasset_Click" />
                    <asp:Button ID="btn_close" runat="server" CssClass="ItDoseButton" Text="Close" />
                </div>
            </asp:Panel>
            <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="btn_Close" TargetControlID="btnHidden"
                BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1" X="100" Y="80">
            </cc1:ModalPopupExtender>
        </div>
    </form>
</body>
</html>
