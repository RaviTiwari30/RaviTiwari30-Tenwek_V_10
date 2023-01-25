<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="BloodBankStockIssue.aspx.cs" Inherits="Design_BloodBank_BloodBankStockIssue" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
         <script type="text/javascript">
        function validate() {
            if ($("#<%=ddlOrg.ClientID %>").val() == "0") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Organisation');
                $("#<%=ddlOrg.ClientID %>").focus();
                return false;
            }

            if ($("#<%=ddlComponent.ClientID %>").val() == "0") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Component');
                   $("#<%=ddlComponent.ClientID %>").focus();
                   return false;
               }
               if ($("#<%=txtTube.ClientID %>").val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Batch No.');
                   $("#<%=txtTube.ClientID %>").focus();
                   return false;
               }
               if ($("#<%=ddlBloodGroup.ClientID %>").val() == "0") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Blood Group');
                   $("#<%=ddlBloodGroup.ClientID %>").focus();
                   return false;
               }
               if ($("#<%=txtQty.ClientID %>").val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Quantity');
                   $("#<%=txtQty.ClientID %>").focus();
                   return false;
               }
               if ($("#<%=ddlBagtype.ClientID %>").val() == "0") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Bag Type');
                   $("#<%=ddlBagtype.ClientID %>").focus();
                   return false;
               }
               if ($.trim($("#<%=txtExpiryDate.ClientID %>").val()) == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Expiry Date');
                   $("#<%=txtExpiryDate.ClientID %>").focus();
                   return false;
               }
               if (Page_IsValid) {
                   document.getElementById('<%=btnAdd.ClientID%>').disabled = true;
                   document.getElementById('<%=btnAdd.ClientID%>').value = 'Submitting...';
                   __doPostBack('ctl00$ContentPlaceHolder1$btnAdd', '');
               }
               else {
                   document.getElementById('<%=btnAdd.ClientID%>').disabled = false;
                   document.getElementById('<%=btnAdd.ClientID%>').value = 'Add';
               }

           }
           $(document).ready(function () {

               $("#<%=btnSave.ClientID %>").click(function () {
                   if (Page_IsValid) {
                       document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                       document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                       __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
                   }
                   else {
                       document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                       document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
                   }
               });
           });
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Direct Stock Receive</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" runat="server">
                Direct Stock
            </div>
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillno" runat="server" MaxLength="25"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Custom,LowercaseLetters,UppercaseLetters,Numbers"
                                TargetControlID="txtBillno" ValidChars="/.\ -" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="Billdatecal" TargetControlID="txtBillDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Way Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtwaybillno" runat="server" MaxLength="25"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom,LowercaseLetters,UppercaseLetters,Numbers"
                                TargetControlID="txtBillno" ValidChars="/.\ -" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Way Bill Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtWayBillDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtWayBillDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Organisation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlOrg" CssClass="requiredField" runat="server">
                            </asp:DropDownList>
   <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Component
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" CssClass="requiredField" ID="ddlComponent" OnSelectedIndexChanged="ddlComponent_SelectedIndexChanged" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Batch No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTube" CssClass="requiredField" runat="server" MaxLength="15"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtTube"
                                FilterType="Custom,Numbers,LowercaseLetters,UppercaseLetters" ValidChars="/.\ ">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="requiredField">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtQty" Text="1" ReadOnly="true" runat="server" MaxLength="5"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="cftQty" runat="server" TargetControlID="txtQty"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RequiredFieldValidator ID="reqQty" SetFocusOnError="true" runat="server" ControlToValidate="txtQty"
                                ValidationGroup="Add" InitialValue="0" ErrorMessage="Please Enter Quantity" Display="None"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bag Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList CssClass="requiredField" runat="server" ID="ddlBagtype">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Expiry Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtExpiryDate" runat="server" CssClass="ItDoseTextinputText requiredField"> </asp:TextBox>
                        <cc1:CalendarExtender ID="callandate" TargetControlID="txtExpiryDate" Format="dd-MMM-yyyy"
                            runat="server">
                        </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="ItDoseButton" ValidationGroup="Add" CausesValidation="false" OnClick="btnAdd_Click" OnClientClick="return validate();" UseSubmitBehavior="false" />
        </div>
        <asp:Panel ID="pnlsave" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Direct Stock Receive Details
                </div>
                <div style="text-align: center;">
                    <asp:GridView ID="grdBloodItem" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                        OnRowCommand="grdBloodItem_RowCommand" Width="100%">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Component Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblComponentname" runat="server" Text='<%# Eval("Componentname") %>'></asp:Label>
                                    <asp:Label ID="lblComponentid" runat="server" Text='<%# Eval("Componentid") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Blood Group">
                                <ItemTemplate>
                                    <asp:Label ID="lblBloodGroup" runat="server" Text='<%# Eval("BloodGroup") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bag Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblBagType" runat="server" Text='<%# Eval("BagType")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tube No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblTubeNo" runat="server" Text='<%# Eval("TubeNo")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Quantity">
                                <ItemTemplate>
                                    <asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("Quantity")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Expiry Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblExpiry" runat="server" Text='<%# Eval("Date")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Reject">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                        CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center">
                &nbsp;<asp:Button ID="btnSave" Text="Save" runat="server" CssClass="ItDoseButton"
                    CausesValidation="False" ToolTip="Click To Save" OnClick="btnSave_Click" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>