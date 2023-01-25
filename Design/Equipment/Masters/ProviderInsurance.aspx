<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProviderInsurance.aspx.cs" Inherits="Design_Equipment_Masters_ProviderInsurance" %>



<%--<%@ Register Src="../../Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>--%>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
                    <b>Provider Insurance</b>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div>
                    <table class="ItDoseLabel" style="text-align: left;">
                        <tr>
                            <td colspan="4" style="text-align: center;">
                                <asp:Label ID="lbmsg" runat="server" ForeColor="Red"></asp:Label>
                            </td>

                        </tr>
                        <tr>
                            <td>Name:</td>
                            <td>
                                <asp:TextBox ID="txtname" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td>Address1:</td>

                            <td>
                                <asp:TextBox ID="txtadd1" runat="server" Width="200px"></asp:TextBox>
                            </td>

                        </tr>
                        <tr>
                            <td>City:</td>
                            <td>
                                <asp:DropDownList ID="ddlcity" runat="server" AutoPostBack="True"
                                    Width="204px">
                                </asp:DropDownList></td>
                            <td>Address2:</td>

                            <td>
                                <asp:TextBox ID="txtadd2" runat="server" Width="200px"></asp:TextBox>
                            </td>

                        </tr>
                        <tr>
                            <td>Pincode:</td>
                            <td>

                                <asp:TextBox ID="txtpin" runat="server" Width="200px"></asp:TextBox>

                            </td>
                            <td>Telephone:</td>



                            <td>
                                <asp:TextBox ID="txtph" runat="server" Width="200px"></asp:TextBox>
                            </td>



                        </tr>
                        <tr>
                            <td>Fax No:</td>
                            <td>
                                <asp:TextBox ID="txtfax" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td>Mobile:</td>



                            <td>
                                <asp:TextBox ID="txtmobile" runat="server" Width="200px"></asp:TextBox>
                            </td>



                        </tr>
                        <tr>
                            <td>Contact Person 1:</td>
                            <td>
                                <asp:TextBox ID="txtconper1" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td>Email</td>



                            <td>
                                <asp:TextBox ID="txtemail" runat="server" Width="200px"></asp:TextBox>
                            </td>



                        </tr>
                        <tr>
                            <td>Contact Per1 Desig:</td>
                            <td>
                                <asp:TextBox ID="txtconper1desi" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td>Contact Person 2:</td>



                            <td>
                                <asp:TextBox ID="txtconper2" runat="server" Width="200px"></asp:TextBox>
                            </td>



                        </tr>
                        <tr>
                            <td>Contact Per1 Email:</td>
                            <td>
                                <asp:TextBox ID="txtconper1email" runat="server" Width="200px"></asp:TextBox>
                            </td>
                            <td>Contact Per2 Desig:</td>



                            <td>
                                <asp:TextBox ID="txtconper2desi" runat="server" Width="200px"></asp:TextBox>
                            </td>



                        </tr>
                        <tr>
                            <td>Is Active</td>
                            <td style="text-align: left;">
                                <asp:CheckBox ID="chkact" runat="server" Checked /><asp:Label ID="lbip" runat="server" Visible="false"></asp:Label>
                            </td>
                            <td>Contact Per2 Email:</td>



                            <td>
                                <asp:TextBox ID="txtconper2email" runat="server" Width="200px"></asp:TextBox>
                            </td>



                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>



                            <td>&nbsp;</td>



                        </tr>
                        <tr>
                            <td colspan="4" style="text-align: center;">
                                <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="ItDoseButton"/>
                                <asp:Button ID="btnclear" runat="server" Text="Clear" OnClick="btnclear_Click" CssClass="ItDoseButton"/>
                            </td>



                        </tr>
                    </table>
                </div>
            </div>


            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Equipmentheader" id="Div3" runat="server">
                </div>
                <div class="content" style="overflow: scroll; height: 200px; width: 90%;">
                    <asp:GridView ID="grddetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" EnableModelValidation="True" OnRowCommand="grddetail_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("ipcode")%>' CommandName="EditData" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.gif"
                                        CausesValidation="false" CommandArgument='<%# Eval("ipcode")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("Name") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="City">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate>
                                    <%#Eval("City") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Mobile">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("Mobile") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Email">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("Email") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contact Per1">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("Conper1") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Designation">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("conper1desi") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Con1 Email">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("conper1email") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contact Per2">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("conper2") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Designation">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("conper2desi") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Con2 Email">
                                <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Eval("conper2email") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <asp:Panel ID="pnlLog" runat="server" Style="width: 600px; border: outset; background-color: #EAF3FD; display: none;">
                <div id="Div1" class="Purchaseheader" style="text-align: center">
                    Log Detail
                </div>
                <div style="overflow: scroll; height: 250px; width: 595px; text-align: left; border: groove;">
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
