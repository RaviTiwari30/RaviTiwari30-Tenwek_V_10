<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TechnicianMaster.aspx.cs" Inherits="Design_Equipment_Masters_TechnicianMaster" %>

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
                    <b>Technician Master</b>
                </div>

            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">
                <div style="text-align: center">
                    <table class="ItDoseLabel" style="width: 700px" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="text-align: right; width: 20%;" align="right">Name :&nbsp;
                            </td>
                            <td style="width: 30%" align="left">
                                <asp:TextBox ID="txtname" runat="server" Width="192px"></asp:TextBox>
                            </td>
                            <td style="width: 10%" align="right">Code :&nbsp;
                            </td>
                            <td style="width: 40%" align="left">
                                <asp:TextBox ID="txtCode" runat="server" Width="100px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 20%; text-align: right">
                                <asp:CheckBox ID="chkIsEmployee" runat="server" Text="Is Employee" AutoPostBack="True" TextAlign="Left" OnCheckedChanged="chkIsEmployee_CheckedChanged" /></td>
                            <td align="left" style="width: 30%">
                                <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="ItDoseDropdownbox" Width="198px"></asp:DropDownList></td>
                            <td align="right" style="width: 10%"></td>
                            <td align="left" style="width: 40%">
                                <asp:CheckBox ID="chkActive" runat="server" Checked="True" Text="Active" /></td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 20%; text-align: right">Designation :&nbsp;
                            </td>
                            <td align="left" style="width: 30%">
                                <asp:TextBox ID="txtDesignation" runat="server" Width="192px"></asp:TextBox></td>
                            <td align="right" style="width: 10%">Description :&nbsp;
                            </td>
                            <td align="left" style="width: 40%">
                                <asp:TextBox ID="txtDescription" runat="server" Width="248px"></asp:TextBox></td>
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

                <div class="content" style="overflow: scroll; height: 370px; width: 99%;">
                    <asp:GridView ID="grdTechnician" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" OnRowCommand="grdTechnician_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" ToolTip="Edit Technician" runat="server" ImageUrl="../../Purchase/Image/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("TechnicianID")%>' CommandName="EditData" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Log">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="../../Purchase/Image/view.gif"
                                        CausesValidation="false" CommandArgument='<%# Eval("TechnicianID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                <ItemTemplate><%#Eval("TechnicianName") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Code">
                                <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("TechnicianCode") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Designation">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%#Eval("Designation") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Is Emp">
                                <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%#Eval("IsEmployee")%></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Employee Name">
                                <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate><%#Eval("EmployeeName") %></ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Desc">
                                <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("Description") %>
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
