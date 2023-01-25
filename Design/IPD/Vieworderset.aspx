<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Vieworderset.aspx.cs" Inherits="Design_IPD_Vieworderset" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                View Order Set
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
            <asp:Panel ID="Panel1" runat="server" Height="264px" ScrollBars="Vertical">
                <asp:GridView ID="GridView1" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                    OnRowCommand="GridView1_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="createddate" HeaderText="Date">
                            <ItemStyle Width="125px" HorizontalAlign="Center" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Doctor_name" HeaderText="Doctor Name">
                            <ItemStyle Width="280px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Groups" HeaderText="Group">
                            <ItemStyle Width="370px" HorizontalAlign="left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbedit" runat="server" ImageUrl="~/Images/edit.png" CausesValidation="false"
                                    CommandArgument='<%# Eval("TransactionID")+"#"+Eval("GroupID")+"#"+Eval("RelationalID")%>' CommandName="editemp" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbview" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false"
                                    CommandName="view"   CommandArgument='<%# Eval("TransactionID")+"#"+Eval("GroupID")+"#"+Eval("RelationalID")%>'/>
                            </ItemTemplate>
                            <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle"  HorizontalAlign="Center"/>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </asp:Panel>
        </div>
    </div>
    </form>
</body>
</html>
