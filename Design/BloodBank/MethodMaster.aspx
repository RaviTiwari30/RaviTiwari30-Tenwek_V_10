<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MethodMaster.aspx.cs" Inherits="Design_BloodBank_MethodMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        var oldgridcolor;
        function SetMouseOver(element) {
            oldgridcolor = element.style.backgroundColor;
            element.style.backgroundColor = '#C2D69B';
            element.style.cursor = 'pointer';
            element.style.textDecoration = 'underline';
        }
        function SetMouseOut(element) {
            element.style.backgroundColor = oldgridcolor;
            element.style.textDecoration = 'none';
        }

    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="" style="text-align: center;">
                <b>Method Master</b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Method Details &nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Method
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMethod" CssClass="requiredField" runat="server" MaxLength="30"
                                TabIndex="1" ToolTip="Enter Method"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqMethod" runat="server" ControlToValidate="txtMethod"
                                ErrorMessage="Please Enter Method" ValidationGroup="btnsave"></asp:RequiredFieldValidator>
                            <cc1:FilteredTextBoxExtender ID="ftbPhone" ValidChars="?/.,()" FilterType="Custom,LowercaseLetters,UppercaseLetters,Numbers" runat="server" InvalidChars="'" TargetControlID="txtMethod">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal" TabIndex="3">
                                <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click"
                TabIndex="8" CssClass="ItDoseButton" OnClientClick="if(Page_ClientValidate()){__doPostBack;this.disabled=true;}" UseSubmitBehavior="false" ValidationGroup="btnsave" />
            <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click"
                Text="Update" CssClass="ItDoseButton" ValidationGroup="btnsave" OnClientClick="if(Page_ClientValidate()){__doPostBack;this.disabled=true;}" UseSubmitBehavior="false" />
            <asp:Button ID="btnCancel" runat="server" OnClick="btncancel_Click" CssClass="ItDoseButton"
                Text="Cancel" />
        </div>
        <div class="POuter_Box_Inventory">
            <asp:GridView ID="grdMethod" runat="server" AutoGenerateColumns="False" Width="100%"
                AllowPaging="true" PageSize="10" CssClass="GridViewStyle" OnSelectedIndexChanged="grdMethod_SelectedIndexChanged"
                OnPageIndexChanging="grdMethod_PageIndexChanging" OnRowDataBound="grdMethod_RowDataBound">
                <PagerTemplate>
                    <strong><b>Number of Pages: <%=grdMethod.PageCount%></b></strong>&nbsp;&nbsp;
                    <asp:Button ID="btnFirst" runat="server" CommandName="Page" ToolTip=" Select First" CssClass="ItDoseButton"
                        CommandArgument="First" Text="<<" />

                    <asp:Button ID="btnPrev" runat="server" CommandName="Page" ToolTip="Select Prev" CssClass="ItDoseButton"
                        CommandArgument="Prev" Text="<" />

                    <asp:Button ID="btnNext" runat="server" CommandName="Page" ToolTip="Select Next" CssClass="ItDoseButton"
                        CommandArgument="Next" Text=">" />

                    <asp:Button ID="btnLast" runat="server" CommandName="Page" ToolTip="Select Last" CssClass="ItDoseButton"
                        CommandArgument="Last" Text=">>" />

                </PagerTemplate>
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" Visible="false">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Method" HeaderText="Method">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="560px" HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="IsActive" Visible="false">
                        <ItemTemplate>
                            <div style="display: none;">
                                <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("ID")+"#"+Eval("Method")+"#"+Eval("IsActive")%>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                    </asp:TemplateField>
                    <asp:CommandField ShowSelectButton="True" SelectText="Edit" HeaderText="Edit">
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                    </asp:CommandField>

                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

