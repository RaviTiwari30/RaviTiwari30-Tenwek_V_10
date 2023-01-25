<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MapVendor_Company.aspx.cs"
    Inherits="Design_Purchase_MapVendor_Company" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">


            <b>Map Supplier Manufacturer</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Map Supplier
            </div>
            <div>

                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Supplier
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlVendor" runat="server" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged" Width="">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Manufacturer
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlmanufacture" runat="server"
                                    Width="">
                                </asp:DropDownList>
                            </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            &nbsp;&nbsp;
            <asp:Button ID="btnMapVendor" runat="server" Text="Map Supplier" CssClass="ItDoseButton"
                OnClick="btnMapVendor_Click" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Map Supplier Detail
            </div>
            <div class="">
                <div style="clear: both; text-align: center;">
                    <asp:GridView ID="grdHeader" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        PageSize="5" Width="100%" OnRowCommand="grdHeader_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ID" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                </ItemTemplate>

                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Supplier Name">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <%#Eval("VendorName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Manufacturer Name">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <%#Eval("CompanyName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Delete">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    &nbsp;<asp:ImageButton ID="imbDelete" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                        CommandName="ADelete" ImageUrl="~/Images/Delete.gif" ToolTip="Delete Item" />

                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
