<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BloodBankComponmentMaster.aspx.cs" Inherits="Design_BloodBank_BloodBankComponmentMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            if ($('#rdbiscomponent input:checked').val() == "1") {
                $('#txtExpiryDays').addClass('requiredField');
            }
            else {
                $('#txtExpiryDays').removeClass('requiredField');
            }
            if ($('#rdbcrossmatch input:checked').val() == "1") {
                $('#txtCrossMatchValiditydays').addClass('requiredField');
            }
            else {
                $('#txtCrossMatchValiditydays').removeClass('requiredField');
            }
        });
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        function Validate() {
            if ($('#txtComponmentName').val() == "") {
                modelAlert('Plese Enter Component Name');
                return false;
            }
            if ($('#rdbiscomponent input:checked').val() == "1") {
                if ($('#txtExpiryDays').val() == "") {
                    modelAlert('Plese Enter Expiry Days');
                    return false;
                }
            }
            if ($('#txtrate').val() == "") {
                modelAlert('Plese Enter Rate');
                return false;
            }
            if ($('#rdbcrossmatch input:checked').val() == "1") {
                if ($('#txtCrossMatchValiditydays').val() == "") {
                    modelAlert('Please Enter Cross Match Validity Days');
                    return false;
                }
            }
        }
        function mandatoryCrossMatch() {
            if ($('#rdbcrossmatch input:checked').val() == "1") {
                $('#txtCrossMatchValiditydays').addClass('requiredField');
            }
            else {
                $('#txtCrossMatchValiditydays').removeClass('requiredField');
            }
        }
        function mandatoryExpiry() {
            if ($('#rdbiscomponent input:checked').val() == "1") {
                $('#txtExpiryDays').addClass('requiredField');
            }
            else {
                $('#txtExpiryDays').removeClass('requiredField');
            }
        }
    </script>
     <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Blood Componment Master</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div id="Div1" class="Purchaseheader" runat="server">
                Blood Componment Master
            </div>
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               Compon. Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtComponmentName" runat="server" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Compon. Alias</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtComponentAlias" runat="server" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Is Componment</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbiscomponent" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" onchange="mandatoryExpiry();">
                                <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Expiry Days
                            </label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtExpiryDays" runat="server"  CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="cftQty" runat="server" TargetControlID="txtExpiryDays"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rate
                            </label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtrate" runat="server" CssClass="requiredField" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftextrate" runat="server" TargetControlID="txtrate"
                              ValidChars=".9876543210">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Is CrossMatch </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbcrossmatch" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" onchange="mandatoryCrossMatch();">
                                <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                CrossMatch Valid.                           
                            </label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCrossMatchValiditydays" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtCrossMatchValiditydays"
                             FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                       <div class="col-md-3">
                            <label class="pull-left">Is Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbActive" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                       </div>
                </div>
                <div class="col-md-1"></div>
                </div>
            </div>
           <div class="POuter_Box_Inventory">
            <div class="row">
                 <div class="col-md-10"></div>
                        <div class="col-md-4" style="text-align:center">
                            <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" OnClientClick="return Validate(this);" />
                            <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" Text="Update" Visible="false" OnClientClick="return Validate(this);" />
                        </div>
                <div class="col-md-10"></div>
                    </div>
               </div>
                  <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" runat="server">
                Result
            </div>
                      <asp:Label ID="lblComponentID" Visible="false" runat="server"></asp:Label>
                         <asp:GridView ID="grdbbComponment" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%" OnRowCommand="grdbbComponment_RowCommand" >
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Component Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblComponmentName" runat="server" Text='<%#Eval("ComponentName") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Component Alias">
                                            <ItemTemplate>
                                                <asp:Label ID="lblComponentalias" runat="server" Text='<%#Eval("AliasName") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="IsComponent">
                                            <ItemTemplate>
                                                <asp:Label ID="lbliscomponent" runat="server" Text='<%#Eval("isComponent") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" VerticalAlign="Middle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Rate">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAmount" runat="server" Text='<%#Eval("Amount") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" VerticalAlign="Middle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Expiry Days">
                                            <ItemTemplate>
                                                <asp:Label ID="lblExpiryDays" runat="server" Text='<%#Eval("dtExpiry") %>' ></asp:Label>
                                                <asp:Label ID="lblActive" runat="server" Text='<%#Eval("Active") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Is CrossMatch Apply">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIsCrossMatchApply" runat="server" Text='<%#Eval("isCrosschargesapply") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" VerticalAlign="Middle" />
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="CrossMatch Validity Days">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCrossMatchValidityDays" runat="server" Text='<%#Eval("CrossmatchValidity") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" VerticalAlign="Middle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Entry By">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EmployeeName") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Entry Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDate") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Edit">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                </div>
        </div>
</asp:Content>

