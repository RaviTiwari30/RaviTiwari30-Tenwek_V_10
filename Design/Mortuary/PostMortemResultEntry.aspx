<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PostMortemResultEntry.aspx.cs" Inherits="Design_Mortuary_PostMortemResultEntry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <style type="text/css">
        .auto-style1
        {
            width: 100%;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>POST-MORTEM RESULT ENTRY</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">

                <table class="auto-style1">
                    <tr>
                        <td>
                            <div class="Purchaseheader">
                                PATHOLOGICAL TEST
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>

                            <asp:GridView ID="gvResultEnter" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Test Group" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="150px"
                                        ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSubCategory" runat="server" Text='<%#Eval("SubCategory") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Test Name" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTestName" runat="server" Text='<%#Eval("TestName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Result Entry" HeaderStyle-Width="505px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtResultEntry" runat="server" Width="490px" Height="45px" Text='<%#Eval("ResultEntry") %>' TextMode="MultiLine"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ItemStyle-CssClass="GridViewItemStyle" Visible="false"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>
                            </asp:GridView>

                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" />
            </div>
        </div>
    </form>
</body>
</html>
