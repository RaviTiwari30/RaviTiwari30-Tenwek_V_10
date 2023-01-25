<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TermsAndCondition.aspx.cs" Inherits="Design_EDP_TermsAndCondition" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            var chkHeader = $(".chkHeader input");
            var chkItem = $(".chkItem input");
            chkHeader.click(function () {
                chkItem.each(function () {
                    this.checked = chkHeader[0].checked;
                })
            });
            chkItem.each(function () {
                $(this).click(function () {
                    if (this.checked == false) { chkHeader[0].checked = false; }
                })
            });
        });
        function Confirm() {
            modelConfirmation('Terms And Condition Delete Confirmation ?', 'Are you sure you want to delete This Terms And Condition?', 'Yes', 'Cancel', function (response) {
                if (response == true) {
                    return true;
                }
                else
                    return false;
            });
            return false;
        };
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Terms And Condition</b>&nbsp;<br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <asp:TextBox ID="txtName" runat="server" Style="" TextMode="MultiLine" Height="100%" Width="100%" Rows="10" CssClass="requiredField" />

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                                <asp:ListItem Value="0">Deactive</asp:ListItem>
                            </asp:RadioButtonList>
                            <span id="spnRateBoth" style="display: none">Both</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" class="ItDoseButton" OnClick="btnSave_Click" />
            <asp:Button ID="btnUpdate" runat="server" Text="Update" class="ItDoseButton" OnClick="btnUpdate_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" class="ItDoseButton" OnClick="btnCancel_Click" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Terms Condition Details
            </div>

            <asp:GridView ID="grdTerms" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                PageSize="5" Width="100%" OnRowCommand="grdTerms_RowCommand" OnRowDeleting="grdTerms_RowDeleting" OnRowEditing="grdTerms_RowEditing">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="#">
                        <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        <HeaderTemplate>
                            <asp:CheckBox runat="server" ID="chkSelectAll" CssClass="chkHeader" Text="All" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="chkSelect" CssClass="chkItem" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Terms And Condition">
                        <ItemTemplate>
                            <%#Eval("Terms")%>
                            <asp:Label ID="lblId" runat="server" Text='<%#Eval("Id")%>' Visible="false"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%#Eval("Active")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Edit">
                        <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imgEdit" runat="server" ImageUrl="~/Images/edit.png" AccessKey="p" CommandName="Edit" CommandArgument='<%# Eval("Terms")+"#"+Eval("IsActive")+"#"+Eval("Id")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete">
                        <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imgDelete" runat="server" ImageUrl="~/Images/Delete.gif" AccessKey="p" CommandName="Delete" OnClientClick="return confirm('Are you sure you want to delete This Terms And Condition?');" CommandArgument='<%# Eval("Id") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
