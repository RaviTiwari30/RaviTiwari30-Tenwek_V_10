<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Canteen_Return.aspx.cs" Inherits="Design_Kitchen_Canteen_Return" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/wuc_PaymentDetails.ascx" TagName="PaymentControl" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
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

        function validatedot() {
            if (($(".GridViewStyle").find(".ItDoseTextinputNum").val().charAt(0) == ".")) {
                $(".GridViewStyle").find(".ItDoseTextinputNum").val('');
                return false;
            }
            return true;
        }

        $(document).ready(function () {
            $("select[id*=ddlPaymentMode]").prop("disabled", "disabled");
            if ($('#<%=PaymentControl.FindControl("lblBalanceAmount").ClientID %>').text() == "0.00") {
                $('#<%=PaymentControl.FindControl("ddlCountry").ClientID %>').prop("disabled", "disabled");
                $('#<%=PaymentControl.FindControl("btnAdd").ClientID %>').prop("disabled", "disabled");
                $('#<%=PaymentControl.FindControl("txtPaidAmount").ClientID %>').prop("disabled", "disabled");
            }
            else {
                $('#<%=PaymentControl.FindControl("ddlCountry").ClientID %>').removeProp("disabled");
                $('#<%=PaymentControl.FindControl("btnAdd").ClientID %>').removeProp("disabled");
                $('#<%=PaymentControl.FindControl("txtPaidAmount").ClientID %>').removeProp("disabled");
            }
        });

        function RestrictDoubleEntry(btn) {
            if (parseFloat($('#<%=PaymentControl.FindControl("lblBalanceAmount").ClientID %>').text()) > "0") {
             //   $('#<%=lblMsg.ClientID %>').text('Please Return Total Amount');
                modelAlert('Please Return Total Amount');
                return false;
            }

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }

        function chkBillReceiptno() {
            if (($.trim($('#<%=txtReceiptNo.ClientID %>').val()) == "") && ($.trim($('#<%=txtBillNo.ClientID %>').val()) == "")) {
                modelAlert('Please Enter Receipt or Bill Number');
              //  $('#<%=lblMsg.ClientID %>').text('Please Enter Receipt or Bill Number');
                $('#<%=txtReceiptNo.ClientID%>').focus();
                return false;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ToolkitScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Canteen Return</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" style="display:none;"></asp:Label>
            <asp:TextBox ID="txtHash" runat="server" CssClass="txtHash" Style="display: none" Width="85px"></asp:TextBox>
            <asp:Label ID="lblOPDPharmacyReturn" runat="server" Style="display: none"></asp:Label>
            <div style="text-align: center;">
                <asp:RadioButtonList ID="rdoReturn" runat="server" CssClass="ItDoseRadiobuttonlist" RepeatDirection="Horizontal" RepeatLayout="Flow" AutoPostBack="True" OnSelectedIndexChanged="rdoReturn_SelectedIndexChanged" Style="display: none;">
                    <asp:ListItem Value="OPD">OPD Patient Return</asp:ListItem>
                    <asp:ListItem Value="GENERAL" Selected="True">WalkIn Patient Return</asp:ListItem>
                </asp:RadioButtonList>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: right; width: 15%;">Receipt No. :&nbsp;</td>
                        <td style="text-align: left; width: 25%;">
                            <asp:TextBox ID="txtReceiptNo" runat="server" Width="250px" CssClass="required">
                            </asp:TextBox>&nbsp;<%--<span style="color: Red; font-size: 10px;">*</span>--%>
                        </td>
                        <td style="text-align: left; width: 10%;">
                            <asp:Button ID="btnGen" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnGen_Click" Visible="false" />
                        </td>
                        <td style="text-align: right; width: 15%;">
                            <asp:Label ID="lblBill" runat="server">Bill No. :&nbsp;</asp:Label>
                        </td>
                        <td style="text-align: left; width: 25%;">
                            <asp:TextBox ID="txtBillNo" runat="server" Width="250px"  CssClass="required" ></asp:TextBox>
                          <%--  <asp:Label ID="lblRed" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                        </td>
                        <td style="text-align: left; width: 10%;">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="ItDoseButton" OnClientClick="return chkBillReceiptno();" />
                        </td>
                        <td style="text-align: left; width: 10%;"></td>
                    </tr>
                    <tr>
                        <td colspan="7">&nbsp;</td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:Panel ID="pnlInfo" runat="server">
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <table style="width: 100%">
                        <tr style="display: none">
                            <td style="width: 20%; text-align: right;">Payment Status :&nbsp;</td>
                            <td colspan="2" style="width: 40%; text-align: left;">
                                <asp:RadioButtonList ID="rdbpaid" Visible="false" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobutton">
                                    <asp:ListItem Text="Paid" Value="0" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Unpaid" Value="2"></asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            <td style="width: 20%"></td>
                            <td style="width: 20%"></td>
                        </tr>
                        <tr>
                            <td style="width: 20%; text-align: right">MR No. :&nbsp;</td>
                            <td style="width: 20%; text-align: left">
                                <asp:Label ID="lblMRNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 20%; text-align: right">Patient Name :&nbsp;</td>
                            <td colspan="2" style="width: 20%; text-align: left">
                                <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:Label ID="lblLedgerno" runat="server" Visible="false"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20%; text-align: right">Contact No. :&nbsp;</td>
                            <td style="width: 20%; text-align: left">
                                <asp:Label ID="lblContactNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 20%; text-align: right">Net Amt. :&nbsp;</td>
                            <td style="width: 20%; text-align: left">
                                <asp:Label ID="lblNetAmt" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 20%">
                                <asp:Label ID="lblCustomerId" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                                <asp:Label ID="lblRefund_Against_BillNo" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 20%">Age :&nbsp;</td>
                            <td style="text-align: left; width: 20%">
                                <asp:Label ID="lblAge" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="text-align: right; width: 20%">Amount Paid :&nbsp;</td>
                            <td style="width: 20%; text-align: left">
                                <asp:Label ID="lblAmtPaid" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:Label ID="lblreceiptno" runat="server" Visible="false"></asp:Label>
                            </td>
                            <td style="width: 20%">
                                <asp:Label ID="lblDoctor_ID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                                <asp:Label ID="lblPanel_ID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 20%">Address :&nbsp;</td>
                            <td style="text-align: left; width: 20%">
                                <asp:Label ID="lblAddress" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="text-align: right; width: 20%">Balance  :&nbsp;</td>
                            <td style="width: 20%; text-align: left">
                                <asp:Label ID="lblBalAmt" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 20%">
                                <asp:Label ID="lblAppBy" runat="server" CssClass="ItDoseLabel" Visible="false"></asp:Label>
                                <asp:Label ID="lblDiscReason" runat="server" CssClass="ItDoseLabel" Visible="false"></asp:Label>
                                <asp:Label ID="lblGovTaxAmt" runat="server" Visible="false" CssClass="ItDoseLabel"></asp:Label>
                                <asp:Label ID="lblGovTaxPer" runat="server" Visible="false" CssClass="ItDoseLabel"></asp:Label>
                                <asp:Label ID="lblPatientType" runat="server" Visible="false" CssClass="ItDoseLabel"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 20%">Payment Status :&nbsp;</td>
                            <td style="text-align: left; width: 20%">
                                <asp:Label ID="lblPaymentStatus" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="text-align: right; width: 20%">IPD No. :&nbsp;</td>
                            <td style="width: 20%; text-align: left">
                                <asp:Label ID="lblIPDNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td style="width: 20%"></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:GridView ID="grdItem" TabIndex="3" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="Server" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="HSNCode">
                                <ItemTemplate>
                                    <asp:Label ID="lblHSNCode" runat="server" Text='<%# Eval("HSNCode") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Batch">
                                <ItemTemplate>
                                    <asp:Label ID="lblBatchNumber" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Expiry">
                                <ItemTemplate>
                                    <%#Eval("MedExpiryDate")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="MRP">
                                <ItemTemplate>
                                    <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Avail Qty.">
                                <ItemTemplate>
                                    <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvlQty") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Unit">
                                <ItemTemplate>
                                    <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="GST %">
                                <ItemTemplate>
                                    <asp:Label ID="lblGSTPercent" runat="server" Text='<%# (Util.GetDecimal(Eval("IGSTPercent"))+Util.GetDecimal(Eval("CGSTPercent"))+Util.GetDecimal(Eval("SGSTPercent"))).ToString("f2") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField
                                HeaderText="Return Qty.">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtReturnQty" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum"
                                        Width="50px" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="8"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftb" runat="server"
                                        FilterType="Numbers" TargetControlID="txtReturnQty">
                                    </cc1:FilteredTextBoxExtender>
                                    <asp:Label ID="lblTnxNo" runat="server" Text='<%# Eval("LedgerTransactionNo") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblExpiry" runat="server" Text='<%# Eval("MedExpiryDate") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblGrossAmt" runat="server" Text='<%# Eval("GrossAmount") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblDiscAmtonTotal" runat="server" Text='<%# Eval("DiscountOnTotal") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblPerUnitBuyPrice" runat="server" Text='<%# Eval("PerUnitBuyPrice") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblIsUsable" runat="server" Text='<%# Eval("IsUsable") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblToBeBilled" runat="server" Text='<%# Eval("ToBeBilled") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblType_ID" runat="server" Text='<%# Eval("Type_ID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblServiceItemID" runat="server" Text='<%# Eval("ServiceItemID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblIsExpirable" runat="server" Text='<%# Eval("IsExpirable") %>'
                                        Visible="False"></asp:Label>
                                    <!--Add new on 29-06-2017 - For GST -->
                                    <asp:Label ID="lblIGSTPercent" runat="server" Text='<%# Eval("IGSTPercent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCGSTPercent" runat="server" Text='<%# Eval("CGSTPercent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblSGSTPercent" runat="server" Text='<%# Eval("SGSTPercent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblGSTType" runat="server" Text='<%# Eval("GSTType") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblBillDate" runat="server" Text='<%# Eval("Date") %>' Visible="false"></asp:Label>
                                    <!--Add new on 29-06-2017 - For GST -->
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <br />
                    <asp:Button ID="btnAddItem" CssClass="ItDoseButton" runat="server" Text="Add Item" OnClick="btnAddItem_Click" />
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlOpdReturn" runat="server">
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:GridView ID="gvIssueItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="gvIssueItem_RowCommand" Width="900px">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="S.No."
                                ItemStyle-CssClass="GridViewItemStyle" ItemStyle-Width="30px">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="290px"
                                HeaderText="Item Name" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%#Eval("ItemName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="HSNCode">
                                <ItemTemplate>
                                    <asp:Label ID="lblHSNCode" runat="server" Text='<%# Eval("HSNCode") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="90px"
                                HeaderText="Batch No." ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%#Eval("BatchNumber")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px"
                                HeaderText="Expiry" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%#Eval("Expiry")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="80px"
                                HeaderText="Return Qty." ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Label ID="lblReturnQty" runat="server" Text='<%# Eval("ReturnQty") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="30px"
                                HeaderText="Unit" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%#Eval("UnitType")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="65px"
                                HeaderText="Rate" ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="GST %">
                                <ItemTemplate>
                                    <asp:Label ID="lblGSTPercent" runat="server" Text='<%# (Util.GetDecimal(Eval("IGSTPercent"))+Util.GetDecimal(Eval("CGSTPercent"))+Util.GetDecimal(Eval("SGSTPercent"))).ToString("f2") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="65px"
                                HeaderText="Amt." ItemStyle-CssClass="GridViewItemStyle" ItemStyle-HorizontalAlign="Right">
                                <ItemTemplate>
                                    <asp:Label ID="lblAmount" runat="server" Text='<%# Eval("Amount") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="30px">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                        CommandName="imbRemove" ImageUrl="~/Images/Delete.gif"
                                        ToolTip="Remove Item" />
                                    <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblExpiry" runat="server" Text='<%# Eval("Expiry") %>'
                                        Visible="False"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Payment Detail
                </div>
                <uc:PaymentControl ID="PaymentControl" runat="server" />
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:Button ID="btnSave" runat="server" UseSubmitBehavior="false" OnClientClick="return RestrictDoubleEntry(this);" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
