<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="EditPO.aspx.cs" Inherits="Design_Purchase_EditPO" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
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

        function valiadtePO() {
            if ($("#<%=txtPONo.ClientID%>").val().trim() == "") {
                $("#<%=txtPONo.ClientID%>").focus();
                $("#<%=lblMsg.ClientID%>").text('Please Enter Order No.');
                return false;
            }
        }

        function validateItem() {
            if ($("#<%=lblQty.ClientID%>").val() == "") {
                $("#<%=lblItemUpdate.ClientID%>").text('Please Enter App. Qty.');
                $("#<%=lblQty.ClientID%>").focus();
                return false;
            }
            if ($("#<%=txtPrice.ClientID%>").val() == "") {
                $("#<%=lblItemUpdate.ClientID%>").text('Please Enter Rate');
            $("#<%=txtPrice.ClientID%>").focus();
            return false;
            }
            if (parseFloat($("#<%=txtDiscount.ClientID%>").val()) > 100) {
                $("#<%=lblItemUpdate.ClientID%>").text('Disc(%) cannot be greater than 100%');
                $("#<%=txtDiscount.ClientID%>").focus();
                return false;
            }
            if (parseFloat( parseFloat($("#<%=txtCGSTPer.ClientID%>").val()) + parseFloat($("#<%=txtSGSTPer.ClientID%>").val()) + parseFloat($("#<%=txtIGSTPer.ClientID%>").val()))>100){
                $("#<%=lblItemUpdate.ClientID%>").text('Total Tax cannot be greater than 100%');
                $("#<%=txtCGSTPer.ClientID%>").focus();
                return false;
            }
        }
    </script>
    <Ajax:ScriptManager ID="sm" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Purchase Order Amendment</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Order No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPONo" CssClass="requiredField" runat="server" Width="" Style=""
                                MaxLength="20">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-5">
                            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                                OnClick="btnSearch_Click" OnClientClick="return valiadtePO()" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Order Details
            </div>

            <div style="text-align: center;">
                <asp:Button ID="btnNarration" runat="server" Text="Narration" Enabled="false" CssClass="ItDoseButton" />
            </div>
            <br />
            <asp:GridView ID="gvOrderDetail" runat="server" AutoGenerateColumns="False" Width="100%" CssClass="GridViewStyle"
                OnRowCommand="gvOrderDetail_RowCommand" OnRowDataBound="gvOrderDetail_RowDataBound">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="20px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Order No." HeaderStyle-Width="146px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%#Eval("PurchaseOrderNo")%>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%#Eval("ItemName")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Free" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Util.GetBoolean(Eval("Free"))?"Yes":"No" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="App. Qty." HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%#Eval("ApprovedQty")%>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("Rate")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Disc." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("Discount_p")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="GST Type" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("GSTType")%>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="GST(%)" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("GSTPer")%>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="GST Amt" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("GSTAmt")%>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Deal" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("Deal")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Vendor Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%#Eval("VendorName")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Rec. Qty." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%#Eval("RecievedQty")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Edit" HeaderStyle-Width="30px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblPDID" runat="server" Visible="false" Text='<%# Eval("PurchaseOrderDetailID") %>' />
                            <asp:ImageButton ID="imbModify" ToolTip="Modify Item" runat="server" ImageUrl="~/Images/edit.png" CausesValidation="false" CommandArgument='<%# Eval("PurchaseOrderDetailID")%>' CommandName="AEdit" Visible='<%# !Util.GetBoolean(Eval("Free")) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <asp:Panel ID="pnlAddGroup" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none">
        <div class="Purchaseheader" id="dragHandle" runat="server">
            Update Item Details
        </div>
        <div class="content">
            <asp:Label ID="lblPDID" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblItemID" runat="server" Visible="False"></asp:Label>
            <table>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Label ID="lblItemUpdate" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
                </tr>
                <tr>
                    <td style="text-align: right">Order No. :</td>
                    <td class="left-align">
                        <asp:Label ID="lblPONO" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Item Name :</td>
                    <td class="left-align">
                        <asp:Label ID="lblItemName" runat="server"></asp:Label></td>
                </tr>
                <tr>
                    <td style="text-align: right">Narration :</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtComments" runat="server" Width="250px" /></td>
                </tr>


            </table>
            <table>
                <tr>
                    <td style="text-align: right; width: 93px;">App. Qty. :</td>
                    <td class="left-align" width="120px">
                        <asp:TextBox ID="lblQty" onkeypress="return checkForSecondDecimal(this,event)" MaxLength="10" runat="server" Width="75px"></asp:TextBox></td>
                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Custom, Numbers"
                        TargetControlID="lblQty" ValidChars=".">
                    </cc1:FilteredTextBoxExtender>

                    <td style="text-align: right">Deal :</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtDeal1" runat="server" Width="35px" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)">
                        </asp:TextBox>+
                        <asp:TextBox ID="txtDeal2" runat="server" Width="25px" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers"
                            TargetControlID="txtDeal1">
                        </cc1:FilteredTextBoxExtender>

                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Numbers"
                            TargetControlID="txtDeal2">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Rate :</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtPrice" runat="server" Width="75px" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtPrice" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="text-align: right">Discount :</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtDiscount" runat="server" Width="75px" MaxLength="3" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtDiscount" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">HSN Code :</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtHSNCode" runat="server" Width="75px"></asp:TextBox>
                    </td>
                    <td style="text-align: right">GST Type :</td>
                    <td class="left-align">
                        <asp:DropDownList ID="ddlGSTType" runat="server" Width="75px" ClientIDMode="Static" onchange="changeTax()"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">CGST(%) :</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtCGSTPer" runat="server" Width="75px" onkeypress="return checkForSecondDecimal(this,event)" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtCGSTPer" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="text-align: right">SGST(%) :</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtSGSTPer" runat="server" Width="75px" onkeypress="return checkForSecondDecimal(this,event)" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtSGSTPer" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">IGST(%) :</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtIGSTPer" runat="server" Width="75px" onkeypress="return checkForSecondDecimal(this,event)" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtIGSTPer" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
            </table>

        </div>

        <div class="filterOpDiv">
            <asp:Button ID="btnupdate" runat="server" Text="Update" CssClass="ItDoseButton"
                OnClick="btnupdate_Click" OnClientClick="return validateItem()" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpUpdate" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddGroup" PopupDragHandleControlID="dragHandle" />
    <asp:Panel ID="pnlNarration" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div1" runat="server">
            Update Order Info.
        </div>
        <div class="content">
            <label class="labelForTag">
                Order No. :</label>
            <asp:Label ID="lblNarPONo" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp">
            </asp:Label>
            <br />
            <br />
            <label class="labelForTag">
                Narration :</label>
            <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText"
                Width="265px" />
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnNarSave" runat="server" Text="Save" CssClass="ItDoseButton"
                OnClick="btnNarSave_Click" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnNarCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpNarration" runat="server" CancelControlID="btnNarCancel"
        DropShadow="true" TargetControlID="btnNarration" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlNarration" PopupDragHandleControlID="Div1" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true"
        ShowSummary="false" ValidationGroup="PREdit" />
    <asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false"
        ValidationGroup="Update" />
    <script>
        function changeTax() {
            if ($('#ddlGSTType').val() == "T4") {
                $('#txtCGSTPer,#txtSGSTPer').attr('disabled', 'disabled');
                $('#txtIGSTPer').removeAttr('disabled');
            }
            else {
                $('#txtCGSTPer,#txtSGSTPer').removeAttr('disabled');
                $('#txtIGSTPer').attr('disabled', 'disabled');
            }

            $('#txtCGSTPer,#txtSGSTPer,#txtIGSTPer').val('0.00');

        }

    </script>
</asp:Content>
