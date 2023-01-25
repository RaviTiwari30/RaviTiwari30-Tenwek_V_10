<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetSubTypeMaster.aspx.cs" Inherits="Design_Equipment_Masters_AssetSubTypeMaster" %>

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
                <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
                <div class="content" style="text-align: center">
                    <b>Asset SubType Master</b>
                </div>

            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">
                <div style="text-align: center">
                    <table class="ItDoseLabel">
                        <tr>
                            <td style="text-align: right">Name :</td>
                            <td>
                                <asp:TextBox ID="txtname" runat="server"></asp:TextBox>
                            </td>
                            <td>Code :</td>
                            <td>
                                <asp:TextBox ID="txtCode" runat="server"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right">Store Type :&nbsp; </td>
                            <td style="text-align: left" colspan="2">
                                <asp:DropDownList ID="ddlAssetType" runat="server" CssClass="ItDoseDropdownbox"></asp:DropDownList>
                            </td>

                            <td style="text-align: left">
                                <asp:CheckBox ID="chkActive" runat="server" Checked="True" Text="Active" />
                            </td>
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

                <div class="content" style="overflow: scroll; height: 400px; width: 99%;">
                    <asp:GridView ID="grdAssetType" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" OnRowCommand="grdAssetType_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit AssetType" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("AssetSubTypeID")%>' CommandName="EditAT" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.GIF"
                                        CausesValidation="false" CommandArgument='<%# Eval("AssetSubTypeID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Asset Type">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%#Eval("AssetType") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate><%#Eval("AssetSubTypeName") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Code">
                                <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("AssetSubTypeCode") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Active">
                                <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%#Eval("IsActive") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="User">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%# Eval("LastUpdatedby") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Date">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%# Eval("UpdateDate") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="IPAddress">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%# Eval("IPAddress") %></ItemTemplate>
                            </asp:TemplateField>


                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <asp:Panel ID="pnlLog" runat="server" Style="width: 600px; border: outset; background-color: #EAF3FD; display: none;">
                <div id="Div1" class="Purchaseheader" style="text-align: center">Log Detail </div>
                <div style="overflow: scroll; height: 250px; width: 595px; text-align: left; border: groove;">
                    <asp:Label ID="lblLog" runat="server"></asp:Label>
                </div>
                <div style="text-align: center;">
                    <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton"
                        Text="Close" />
                </div>
            </asp:Panel>
            <cc1:ModalPopupExtender ID="mdpLog" runat="server" CancelControlID="btnClose"
                TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlLog"
                X="100" Y="80">
            </cc1:ModalPopupExtender>
            <div style="display: none;">
                <asp:Button ID="btnHidden" runat="server" Text="Button" />
            </div>
        </div>
    </form>
</body>
</html>
