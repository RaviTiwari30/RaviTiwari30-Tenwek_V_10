<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ManageApproval.aspx.cs" Inherits="Design_Purchase_ManageApproval" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        function alertDelete() {
            var answer = confirm("Are you sure to remove Approval right?")
            if (answer) {
                return true;
            }
            else
                return false;
        }
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Purchase Manage Approval
                        <br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory" id="DIV2">
            <div class="Purchaseheader">
                Select Approval
            </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Approval For
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlAppFor" runat="server" OnSelectedIndexChanged="ddlAppFor_SelectedIndexChanged" AutoPostBack="True">
                                    <asp:ListItem Value="PR">Purchase Request</asp:ListItem>
                                    <asp:ListItem Value="PO">Purchase Order</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlEmployee" runat="server">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblSig" Text="Signature" runat="server"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:FileUpload ID="fuSign" runat="server" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-10">
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Add" CssClass="ItDoseButton" />
                            </div>
                            <div class="col-md-10">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                All Selected Approval
            </div>
            <div>
                <asp:GridView ID="grdObs" runat="server" AutoGenerateColumns="False" Width="100%"
                    OnRowDeleting="grdObs_RowDeleting">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                S.No.
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                Employee Name
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%# Eval("empName")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <%-- <asp:TemplateField>
                            <HeaderTemplate>
                                Department Name
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%# Eval("Department")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>--%>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                Approval For
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%# Eval("ApprovalFor")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField Visible="false">
                            <HeaderTemplate>
                                Signature
                            </HeaderTemplate>
                            <ItemTemplate>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                Delete
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:ImageButton ID="ibDelete" runat="server" ImageUrl="~/Images/Delete.gif"
                                    CommandName="delete" OnClientClick="return alertDelete();" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField Visible="False">
                            <HeaderTemplate>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%#Eval("id") %>'>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>
