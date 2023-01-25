<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PRApproval.aspx.cs" MasterPageFile="~/DefaultHome.master"
    Inherits="Design_Purchase_PRApproval" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#ddldepartment').chosen();
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
        function validatedots() {
            var appqty = $("#<%=txtApproveQty.ClientID%>").val();
            var ReqQty = $("#<%=lblRQty.ClientID%>").text();
            if (($("#<%=txtApproveQty.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtApproveQty.ClientID%>").val('');
                return false;
            }

            else {
                $('#<%=lblApp.ClientID %>').text('');
            }
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpeCreateGroup")) {
                    $find('mpeCreateGroup').hide();
                }
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mapItemCancel")) {
                    $('#<%=txtItemReason.ClientID %>').val('');
                    $find('mapItemCancel').hide();
                }
            }
        }
        function validateApprovedQty() {
            if ($.trim($('#<%=txtApproveQty.ClientID %>').val()) == "") {
                $("#lblItem").text('Please Enter Approve Qty.');
                $('#<%=txtApproveQty.ClientID %>').focus();
                return false;
            }

        }
        function validateReject() {
            if ($.trim($('#<%=txtCancelReason.ClientID %>').val()) == "") {
                $("#lblReject").text('Please Enter Reason');
                $('#<%=txtCancelReason.ClientID %>').focus();
                return false;
            }


        }

        function validateRejectItem() {
            if ($.trim($('#<%=txtItemReason.ClientID %>').val()) == "") {
                $("#lblCancelItem").text('Please Enter Reason');
                $('#<%=txtItemReason.ClientID %>').focus();
                return false;
            }
        }
        function SelectAll() {
            if ($('[id$=chkall]').is(':checked')) {
                $('[id$=GridView1] tr').each(function () {
                    $(this).find('[id$=chkSelect]').prop('checked', true)
                });
            }
            else {
                $('[id$=GridView1] tr').each(function () {
                    if ($(this).find('[id$=chkSelect]').prop('checked', false)) {
                    }
                });
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Purchase Request Approval</b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddldepartment" ClientIDMode="Static" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddldepartment_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Store Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList ID="rdbLedMas" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rdbLedMas_SelectedIndexChanged"
                                RepeatDirection="Horizontal" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Purchase Request
            </div>
            <div runat="server" id="divApproval">
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <asp:CheckBox ID="CheckBox1" runat="server" Visible="false" AutoPostBack="True" Checked="false" OnCheckedChanged="CheckBox1_CheckedChanged"
                                    CssClass="ItDoseCheckbox" Text="All" />
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdbPRApproval" runat="server"
                                    RepeatDirection="Horizontal" RepeatLayout="Flow">
                                    <asp:ListItem Text="Approve" Value="Approve" Selected="True" />
                                    <asp:ListItem Text="Reject" Value="Reject" />
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="btnSave" Enabled="false" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" />
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="btnItem" Enabled="false" runat="server" Text="View" OnClick="btnItem_Click" CssClass="ItDoseButton" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row"></div>
                <div class="row"></div>
                <div style="text-align: center;">
                    <asp:Panel ID="pnlgv1" runat="server" ScrollBars="vertical" Height="150px" Width="100%">
                        <asp:GridView ID="GridView1" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowCommand="GridView1_RowCommand" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="35px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderTemplate>
                                        <asp:CheckBox ID="chkall" onchange="return SelectAll();" runat="server" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="PurchaseRequestNo" HeaderText="PR No." ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="325px" />
                                <asp:BoundField DataField="DepartMentName" HeaderText="DepartMent Name" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="200px" />
                                <asp:BoundField DataField="Subject" HeaderStyle-Width="350px" HeaderText="Narration"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Name" HeaderText="Requested User" HeaderStyle-Width="125px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="RaisedDate" HeaderText="Requested Date" HeaderStyle-Width="140px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="45px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject"
                                            ImageUrl="~/Images/Delete.gif" CommandArgument='<%#Container.DataItemIndex %>' />
                                        <asp:Label ID="lblPRNO" runat="server" Text='<%# Eval("PurchaseRequestNo") %>' Visible="False"></asp:Label>
                                        <%--<asp:Label ID="lblIsLast" runat="server" Text='<%# Eval("IsLast") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lblPriority" runat="server" Text='<%# Eval("Priority") %>' Visible="False"></asp:Label>--%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Request Details
            </div>
            <div class="">
                <div style="text-align: center;">
                    <asp:Panel ID="Panel1" runat="server" ScrollBars="vertical" Height="285px">
                        <asp:GridView ID="grdItemDetails" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowCommand="grdItemDetails_RowCommand" OnRowDataBound="grdItemDetails_RowDataBound" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:BoundField DataField="PurchaseRequisitionNo" HeaderText="PR No." ReadOnly="True"
                                    HeaderStyle-Width="85px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ItemName" HeaderText="Item Name" ReadOnly="True" HeaderStyle-Width="130px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Specification" HeaderText="Remarks" ReadOnly="True"
                                    HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Purpose" HeaderText="Purpose" ReadOnly="True" HeaderStyle-Width="75px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ApproxRate" HeaderText="Unit Price" HeaderStyle-Width="40px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:BoundField DataField="Discount" HeaderText="Discount" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:BoundField DataField="RequestedQty" HeaderText="Req. Qty." ReadOnly="True" HeaderStyle-Width="43px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ApprovedQty" HeaderText="App. Qty." HeaderStyle-Width="43px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />

                                <%-- <asp:BoundField DataField="LedgerName" HeaderText="Supplier" ReadOnly="True" HeaderStyle-Width="100px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:BoundField DataField="AvgConsumption" HeaderText="Avg. Consm." ReadOnly="True"
                                    HeaderStyle-Width="30px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ReorderLevel" HeaderText="ROL" ReadOnly="True" HeaderStyle-Width="30px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>

                                <asp:BoundField DataField="POStock" HeaderText="PO Stock" ReadOnly="True"
                                    HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />

                                 <asp:BoundField DataField="DeptStock" HeaderText="Dept. Stock" ReadOnly="True"
                                    HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />

                                 <asp:BoundField DataField="MainStock" HeaderText="Main Stock" ReadOnly="True"
                                    HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />

                                <asp:BoundField DataField="Indent_Department" HeaderText="Requisition Department" ReadOnly="True"
                                    HeaderStyle-Width="30px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:TemplateField HeaderText="Tax" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                    <ItemTemplate>
                                        <asp:Repeater ID="rpTax" runat="server">
                                            <ItemTemplate>
                                                <%#Eval("TaxName" )%>&nbsp;&nbsp;&nbsp;&nbsp;<%#Eval("TaxPer") %>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit"
                                            ImageUrl="~/Images/edit.png" CommandArgument='<%#Container.DataItemIndex %>' />
                                        <asp:Label ID="lblReqDetailID" runat="server" Text='<%# Eval("PuschaseRequistionDetailID") %>'
                                            Visible="False"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject"
                                            ImageUrl="~/Images/Delete.gif" CommandArgument='<%#Container.DataItemIndex %>' />
                                        <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lblPurchaseRequisitionNo" runat="server" Text='<%# Eval("PurchaseRequisitionNo") %>'
                                            Visible="False"></asp:Label>
                                        <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>' Visible="False"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="View Stock" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                            ImageUrl="~/Images/view.gif" CommandArgument='<%# Eval("ItemID")+"$"+Eval("ItemName")  %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
        </div>
        <asp:Panel ID="Panel5" runat="server" BackColor="#EAF3FD" BorderStyle="None" Style="display: none; height: 500px; width: 850px;"
            ScrollBars="Both">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" id="DivAuto">
                    Auto Purchase Order Item Details
                    <br />
                </div>
                <div class="content">
                    <div style="text-align: center;">
                        <asp:Label EnableViewState="false" runat="server" ID="lblMsgAuto" CssClass="ItDoseLblError">
                        </asp:Label>
                    </div>
                    <div style="text-align: center;">
                        <asp:GridView ID="grdAutoPo" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelectNew" runat="server" Checked="True" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <%-- <asp:BoundField DataField="PurchaseRequisitionNo" HeaderText="PRNO" ReadOnly="True" HeaderStyle-Width="145px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                                <asp:TemplateField HeaderText="PRNO" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPRNOAuto" runat="server" Text='<%# Eval("PurchaseRequisitionNo") %>'>
                                        </asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ItemID" Visible="false" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemIDAuto" runat="server" Text='<%# Eval("ItemID") %>' Visible="False">
                                        </asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ItemName" HeaderText="ItemName" ReadOnly="True" HeaderStyle-Width="150px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Specification" HeaderText="Specf." ReadOnly="True" HeaderStyle-Width="50px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Purpose" HeaderText="Purpose" ReadOnly="True" HeaderStyle-Width="75px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ApproxRate" HeaderText="Rate" HeaderStyle-Width="40px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Discount" HeaderText="Disc" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:BoundField DataField="RequestedQty" HeaderText="Req Qty" ReadOnly="True" HeaderStyle-Width="40px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ApprovedQty" HeaderText="Aprd Qty" HeaderStyle-Width="40px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="LedgerName" HeaderText="Vendor" ReadOnly="True" HeaderStyle-Width="100px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="AvgConsumption" HeaderText="Avg Consm" ReadOnly="True"
                                    HeaderStyle-Width="30px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ReorderLevel" HeaderText="ROL" ReadOnly="True" HeaderStyle-Width="30px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="CurrentStock" HeaderText="Current Stock" ReadOnly="True"
                                    HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:TemplateField HeaderText="Tax" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Repeater ID="rpTax" runat="server">
                                            <ItemTemplate>
                                                <%#Eval("TaxName" )%>&nbsp;&nbsp;&nbsp;&nbsp;<%#Eval("TaxPer") %>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblReqDetailIDNew" runat="server" Text='<%# Eval("PuschaseRequistionDetailID") %>'
                                            Visible="False">
                                        </asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div style="text-align: center;">
                    <asp:Label ID="lblchktxtAuto" runat="server" Text="Print:"></asp:Label>
                    <asp:CheckBox ID="chkPrintImgAuto" Checked="true" runat="server" />
                    <asp:Button ID="btnSaveAuto" runat="server" Text="Save" OnClick="btnSaveAuto_Click" CssClass="ItDoseButton" />
                    <asp:Button ID="btnCancelAuto" runat="server" Text="Cancel" CssClass="ItDoseButton" />
                </div>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeAutoPo" runat="server" CancelControlID="btnCancelAuto"
            DropShadow="true" TargetControlID="Button2" BackgroundCssClass="filterPupupBackground"
            PopupControlID="Panel5" PopupDragHandleControlID="DivAuto">
        </cc1:ModalPopupExtender>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none;"
        Width="450px">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Update Item Details
        </div>
        <div class="content" style="margin-left: 20px">
            <table width="530px">
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Label ID="lblItem" ClientIDMode="Static" CssClass="ItDoseLblError" runat="server"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">PR No. :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:Label ID="lblPRNO" runat="server" Font-Bold="true"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">Item Name :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:Label ID="lblItemName" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">Available Qty. :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:Label ID="lblInitQty" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">Requested Qty. :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:Label ID="lblRQty" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">Approved Qty. :&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtApproveQty" runat="server" ValidationGroup="Update" Width="50px"
                            MaxLength="8" CssClass="ItDoseTextinputNum requiredField" onkeypress="return checkForSecondDecimal(this,event)"
                            onkeyup="validatedots();">
                        </asp:TextBox>
                        <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        <cc1:FilteredTextBoxExtender ID="fl1" runat="server" TargetControlID="txtApproveQty"
                            FilterType="Custom,Numbers" ValidChars="." />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div class="filterOpDiv" style="text-align: center">
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtApproveQty"
                Display="None" ErrorMessage="Specify Approve Quantity " SetFocusOnError="True"
                ValidationGroup="Update">*</asp:RequiredFieldValidator>
            <asp:Label ID="lblApp" runat="server" Style="color: Red; font-size: 10px; font-weight: bold;"></asp:Label>&nbsp;
            <asp:Button ID="btnupdate" runat="server" Text="Update" CssClass="ItDoseButton"
                ValidationGroup="Update" OnClick="btnupdate_Click" OnClientClick="return validateApprovedQty()" />&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel" BehaviorID="mpeCreateGroup"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate" PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div1" runat="server">
            Cancel PR
        </div>
        <div class="content" style="margin-left: 20px">
            <table width="530px">
                <tr>
                    <td colspan="2">
                        <asp:Label ID="lblReject" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">PR No. :&nbsp;&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:Label ID="lblPRNo2" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">Reason :&nbsp;&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtCancelReason" runat="server" Width="250px"
                            MaxLength="100" />
                        <asp:Label ID="lblcancelreason" runat="server" Text="*" ForeColor="Red"></asp:Label>
                        <cc1:FilteredTextBoxExtender ID="cfsreason" TargetControlID="txtCancelReason"
                            FilterType="LowercaseLetters,UppercaseLetters" runat="server">
                        </cc1:FilteredTextBoxExtender>

                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnGRNCancel" runat="server" CssClass="ItDoseButton" Text="Reject"
                OnClick="btnGRNCancel_Click" OnClientClick="return validateReject()" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="Button1" runat="server" CssClass="ItDoseButton" Text="Cancel" CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpCancel" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel2" PopupDragHandleControlID="Div1">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel3" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;" Height="162px">
        <div class="Purchaseheader" id="Div4" runat="server">
            Cancel Item &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Press esc 
                                to close
        </div>

        <table width="530px">
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblCancelItem" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 135px;" class="right-align">PR No. :&nbsp;
                </td>
                <td style="width: 395px" class="left-align">
                    <asp:Label ID="lblPRNO1" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="width: 135px;" class="right-align">Item Name :&nbsp;
                </td>
                <td style="width: 395px" class="left-align">
                    <asp:Label ID="lblItemName1" runat="server" />
                    <asp:Label ID="lblreqno" runat="server" CssClass="ItDoseLabelSp" Visible="False" />
                    <asp:Label ID="lblitemid" runat="server" CssClass="ItDoseLabelSp" Visible="False" />
                </td>
            </tr>
            <tr>
                <td style="width: 135px;" class="right-align">Reason :&nbsp;
                </td>
                <td style="width: 395px" class="left-align">
                    <asp:TextBox ID="txtItemReason" runat="server" Width="280px"
                        MaxLength="100" />
                    <asp:Label ID="Label1" runat="server" Text="*" ForeColor="Red"></asp:Label>

                </td>
            </tr>
        </table>

        <div class="filterOpDiv" style="text-align: center">
            <asp:Button ID="btnRejectItem" runat="server" CssClass="ItDoseButton" Text="Reject Item"
                OnClick="btnRejectItem_Click" OnClientClick="return validateRejectItem()" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancelItem" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <asp:Panel ID="Panel4" runat="server" BackColor="#EAF3FD" BorderStyle="None" Style="display: none; height: 300px; width: 400px;"
        ScrollBars="Both">
        <div class="Purchaseheader" id="Div2" runat="server">
            <strong>Department  Stock Status</strong>
        </div>
        <asp:Label ID="lblPopupItem" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
        <table>
            <tr style="width: 100%">
                <td>
                    <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="False" Style="width: 372px">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:BoundField DataField="LedgerName" HeaderText="Department Name">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="inhand" HeaderText="Current Stock">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="AvgCon" HeaderText="Average Consumption">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="text-align: center">
                    <asp:Button ID="btnNo" runat="server" CssClass="ItDoseButton" Text="Close" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Button ID="Button2" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton" />
    <%--    <cc1:modalpopupextender id="mdlView" runat="server" CancelControlID="btnNo" 
    TargetControlID="Button2" BackgroundCssClass = "filterPupupBackground" PopupControlID="Panel4"
    X="200" Y="200">
    </cc1:modalpopupextender>--%>
    <cc1:ModalPopupExtender ID="mdlView" runat="server" CancelControlID="btnNo" DropShadow="true"
        TargetControlID="Button2" BackgroundCssClass="filterPupupBackground" PopupControlID="Panel4"
        PopupDragHandleControlID="Div2">
    </cc1:ModalPopupExtender>
    <cc1:ModalPopupExtender ID="mapItemCancel" runat="server" CancelControlID="btnCancelItem" BehaviorID="mapItemCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel3" PopupDragHandleControlID="Div4">
    </cc1:ModalPopupExtender>
    <asp:ValidationSummary ID="ValidationSummary3" runat="server" ShowMessageBox="True"
        ShowSummary="False" ValidationGroup="Update" />
    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="true"
        ShowSummary="false" ValidationGroup="ItemCacnel" />
    <asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false"
        ValidationGroup="GRNCacnel" />
</asp:Content>
