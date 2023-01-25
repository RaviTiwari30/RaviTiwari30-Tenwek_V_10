<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="DiscardStock.aspx.cs" Inherits="Design_BloodBank_DiscardStock" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtexpiryfrom').change(function () {
                ChkDate();
            });
            $('#txtexpiryTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtexpiryfrom').val() + '",DateTo:"' + $('#txtexpiryTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdDiscard.ClientID %>').hide();

                    }
                    else {
                        $('#<%=lblerrmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeProp('disabled');

                    }
                }
            });
        }

    </script>

    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Discard Blood Stock</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Stock ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtStockId" runat="server" MaxLength="20"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbStock" runat="server" FilterType="Numbers,LowercaseLetters,UppercaseLetters" TargetControlID="txtStockId"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collection ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBloodCollectionID" runat="server" MaxLength="20"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbBlood" runat="server" FilterType="Numbers,LowercaseLetters,UppercaseLetters" TargetControlID="txtBloodCollectionID"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Tube No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTubeNo" runat="server" MaxLength="10"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3" style="display:none;">
                            <label class="pull-left">
                                Bag Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <asp:DropDownList ID="ddlBagType" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Expiry From 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtexpiryfrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calexpiryfrom"
                                TargetControlID="txtexpiryfrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Expiry To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtexpiryTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calexpiryTo"
                            TargetControlID="txtexpiryTo" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>

                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server"
                OnClick="btnSearch_Click" />&nbsp;
           
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:GridView ID="grdDiscard" runat="server" AutoGenerateColumns="false" Width="100%" CssClass="GridViewStyle">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="15px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Stock ID" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("Stock_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection ID" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodCollectionID" runat="server" Text='<%# Eval("BloodCollection_Id") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBagType" runat="server" Text='<%# Eval("BagType") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tube No." HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBBTubeNo" runat="server" Text='<%# Eval("BBTubeNo") %>' />
                                <asp:Label ID="lblBloodGroup" runat="server" Text='<%# Eval("BloodGroup") %>' Visible="false" />

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component Name" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblComponentName" runat="server" Text='<%# Eval("ComponentName") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection&nbsp;Date" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblCollectionDate" runat="server" Text='<%# Eval("EntryDate") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiryDate" runat="server" Text='<%# Eval("ExpiryDate") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Select" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkCheck" runat="server" Checked="false" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Reason" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                            <ItemTemplate>
                                <%--<asp:TextBox ID="txtReason" runat="server" ToolTip="Enter Reason"></asp:TextBox>--%>
                                <asp:DropDownList ID="ddlReason" runat="server" ToolTip="Please Select Reason"></asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

            </div>
        </asp:Panel>
        <asp:Panel ID="pnlHide1" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:Button ID="btnSave" runat="server" Text="Save" ValidationGroup="btnsave" CssClass="ItDoseButton"
                    OnClick="btnSave_Click" OnClientClick="return RestrictDoubleEntry(this);" />&nbsp;&nbsp;
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CssClass="ItDoseButton" />

            </div>
        </asp:Panel>
    </div>
</asp:Content>
