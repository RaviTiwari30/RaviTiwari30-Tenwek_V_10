<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Insurance.aspx.cs" Inherits="Design_Equipment_Masters_Insurance" %>

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
                    <b>Insurance<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="showheader">Policy Detail</div>
                <table class="ItDoseLabel" style="text-align: left;">
                    <tr>
                        <td>Policy Number:</td>
                        <td>
                            <asp:TextBox ID="txtpolicyno" runat="server" Width="170px"></asp:TextBox>
                        </td>
                        <td>Inclusion</td>

                        <td>
                            <asp:TextBox ID="txtinc" runat="server" Width="170px" TextMode="MultiLine"></asp:TextBox>
                        </td>

                    </tr>
                    <tr>
                        <td>Insurance Provider:</td>
                        <td>
                            <asp:DropDownList ID="ddlpro" runat="server" Width="174px">
                            </asp:DropDownList>
                        </td>
                        <td>Exclusion</td>

                        <td>
                            <asp:TextBox ID="txtenc" runat="server" Width="170px" TextMode="MultiLine"></asp:TextBox>
                        </td>

                    </tr>
                    <tr>
                        <td>Ins Start Date:</td>
                        <td>
                            <%--<uc1:entrydate id="ucDateFrom" runat="server" />--%>
                             <asp:TextBox ID="ucDateFrom" runat="server" Width="170px"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID ="ucDateFrom" Format="yyyy-MM-dd" runat="server"></cc1:CalendarExtender>
                             
                        </td>
                        <td>Ins End Date</td>



                        <td>
                            <%--<uc1:entrydate id="ucDateto" runat="server" />--%>
                             <asp:TextBox ID="ucDateto" runat="server" Width="170px"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID ="ucDateto" Format="yyyy-MM-dd" runat="server"></cc1:CalendarExtender>
                        </td>



                    </tr>
                    <tr>
                        <td>Insurance Value</td>
                        <td>
                            <asp:TextBox ID="txtval" runat="server" Width="170px"></asp:TextBox>
                        </td>
                        <td>Upload Doc</td>



                        <td>
                            <asp:FileUpload ID="FileUpload1" runat="server" />
                        </td>



                    </tr>
                    <tr>
                        <td>Status</td>
                        <td>
                            <asp:CheckBox ID="chk" runat="server" Checked="True" Text="Active" />
                        </td>
                        <td>&nbsp;</td>



                        <td>&nbsp;</td>



                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>



                        <td>&nbsp;</td>



                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center;">


                            <table border="1" style="text-align: left; width: 70%;">
                                <tr>
                                    <td colspan="2">
                                        <div class="showheader">Asset</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Select Asset </td>
                                    <td>
                                        <asp:DropDownList ID="ddlasset" runat="server" Width="204px">
                                        </asp:DropDownList>
                                    </td>

                                </tr>
                                <tr>
                                    <td>Description</td>
                                    <td>
                                        <asp:TextBox ID="txtdes" runat="server" TextMode="MultiLine" Width="200px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: center;">
                                        <asp:Button ID="btnadd" runat="server" Text="Add Asset" CssClass="ItDoseButton" OnClick="btnsave_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: center;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: center;">

                                        <asp:GridView ID="grasset" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            EnableModelValidation="True" OnRowCommand="grasset_RowCommand">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Asset Code">
                                                    <ItemStyle CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lbid" Visible="false" Text='<%#Eval("AssetId") %>'></asp:Label>
                                                        <%#Eval("AssetCode") %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Asset Name">
                                                    <ItemStyle CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                    <ItemTemplate>
                                                        <%#Eval("AssetName") %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Description">
                                                    <ItemStyle CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lbdes" Visible="false" Text='<%#Eval("Description") %>' />
                                                        <%#Eval("Description") %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Remove">
                                                    <ItemStyle CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                                            CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>


                                    </td>
                                </tr>
                            </table>


                        </td>



                    </tr>
                    <tr>
                        <td colspan="4">&nbsp;</td>



                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: center;">&nbsp;</td>



                    </tr>
                </table>

            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">
                <table>
                    <tr>
                        <td style="text-align: center;">&nbsp;&nbsp;
                        <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click1" CssClass="ItDoseButton"/>
                            <asp:Button ID="btnclear" runat="server" OnClick="btnclear_Click" Text="Clear"  CssClass="ItDoseButton"/>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="showheader">Policy List</div>
                <div class="content" style="overflow: scroll; height: 200px; width: 95%;">
                    <asp:GridView ID="grdAsset" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="grdAsset_RowCommand" EnableModelValidation="True">
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
                                    <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="~/Images/view.gif"
                                        CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="ViewLog" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Policy No">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("policyno") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Provider">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("NAME") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Start Date">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("sdate") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="End Date">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("edate") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Value">
                                <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("insval") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Is Active">
                                <ItemStyle CssClass="GridViewItemStyle" Width="75px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%#Eval("STATUS") %>
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

