<%@ Page Language="C#" AutoEventWireup="true" CodeFile="POApproval.aspx.cs" Inherits="Design_Purchase_POApproval"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
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
        function validatedots() {
            if (($("#<%=txtFreight.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtFreight.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtRoundOff.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtRoundOff.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtScheme.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtScheme.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtExciseOnBill.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtExciseOnBill.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtApproveQty.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtApproveQty.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtPrice.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtPrice.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtDiscount.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtDiscount.ClientID%>").val('');
                return false;
            }
            return true;
        }
        $(document).ready(function () {
            var MaxLength = 200;
            $("#<% =txtNarration.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtNarration.ClientID%>').bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });

        });
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpNarration")) {
                    $find('mpNarration').hide();
                }
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
                if ($find("mpCancel")) {
                    $find('mpCancel').hide();
                }
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mapItemCancel")) {
                    $find('mapItemCancel').hide();
                }
            }
        }
        function validateRej() {
            if ($.trim($("#<%=txtItemReason.ClientID%>").val()) == "") {
                $("#<%=lblCancelItem.ClientID%>").text('Please Enter Reason');
                $("#<%=txtItemReason.ClientID%>").focus();
                return false;
            }
        }
        function validateGRN() {
            if ($.trim($("#<%=txtCancelReason.ClientID%>").val()) == "") {
                $("#<%=lblGrn.ClientID%>").text('Please Enter Reason');
                $("#<%=txtCancelReason.ClientID%>").focus();
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

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Purchase Order Approval</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Purchase Orders
            </div>
            <div class="">
                <div style="float: left; clear: right; text-align: center;display:none;">
                    <asp:CheckBox ID="chkUnchek" runat="server" Enabled="false" AutoPostBack="True" Checked="false"
                        OnCheckedChanged="chkUnchek_CheckedChanged" Text="All" />
                </div>
                <div style="float: left; padding-left: 150px;">
                    <asp:RadioButtonList ID="rdbApprove" runat="server"
                        RepeatDirection="Horizontal" RepeatLayout="Flow">
                        <asp:ListItem Text="Approve" Value="Approve" Selected="True" />
                        <asp:ListItem Text="Reject" Value="Reject" />
                    </asp:RadioButtonList>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnSave" runat="server" Enabled="false" Text="Save" OnClick="btnSave_Click"
                        CssClass="ItDoseButton" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnItem" runat="server" Text="View" Enabled="false" OnClick="btnItem_Click"
                        CssClass="ItDoseButton" />
                </div>
                <br />
                <br />
                <div style="text-align: center;">
                    <asp:Panel ID="pnlgv1" runat="server" ScrollBars="vertical" Height="200px" Width="100%">
                        <asp:GridView ID="GridView1" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowCommand="GridView1_RowCommand" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderTemplate>
                                        <asp:CheckBox ID="chkall" onchange="return SelectAll();" runat="server" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" Checked="false" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PO No." HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPONumber" runat="server" Text='<%# Eval("PurchaseOrderNo") %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Subject" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNarration" runat="server" Text='<%# Eval("Subject") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Supplier" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("VendorName")%>
                                        <%--<asp:Label ID="lblvendorid" runat="server" Text='<%# Eval("VendorId") %>' Visible="false"></asp:Label>--%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="vendorid" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblVendorid" runat="server" Text='<%# Eval("ledgeruserid") %>'></asp:Label>
                                        <%--<asp:Label ID="lblvendorid" runat="server" Text='<%# Eval("VendorId") %>' Visible="false"></asp:Label>--%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Net Amt." ItemStyle-HorizontalAlign="Right" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Eval("GrossTotal")%>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Raised User" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUser" runat="server" Text='<%# Eval("UserName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Raised Date" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRaisedDate" runat="server" Text='<%# Eval("RaisedDate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="~/Images/edit.png" CommandArgument='<%# Eval("PurchaseOrderNo")+"#"+Eval("Narration")+"#"+Eval("Freight")+"#"+Eval("Roundoff")+"#"+Eval("Scheme")+"#"+Eval("ExciseOnBill")  %>' />

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Reject" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject" ImageUrl="~/Images/Delete.gif" CommandArgument='<%#Container.DataItemIndex %>' />
                                        <%--<asp:Label ID="lblPriority" runat="server" Text='<%# Eval("Priority") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lblIsLast" runat="server" Text='<%# Eval("IsLast") %>' Visible="False"></asp:Label>--%>
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
                Order Details
            </div>
            <div class="" style="text-align: right">
                <div style="text-align: center;">
                    <asp:Panel ID="Panel1" runat="server" ScrollBars="vertical" Height="285px" Style="width: 100%">
                        <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdItem_RowCommand" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PO No." HeaderStyle-Width="170px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPONo" runat="server" Text='<%# Eval("PurchaseOrderNo") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Specification" Visible="false" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSpecification" runat="server" Text='<%# Eval("Specification") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Free" HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Util.GetBoolean(Eval("IsFree"))?"Yes":"No" %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Order Qty." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrderQty" runat="server" Text='<%# Eval("OrderedQty") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Aprd. Qty." HeaderStyle-Width="45px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblApprove" runat="server" Text='<%# Eval("ApprovedQty") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Rate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Disc." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("Discount_p") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Tax" Visible="false" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Eval("TaxName" )%>&nbsp;&nbsp;:&nbsp;<%#Eval("TaxDisplay")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="~/Images/edit.png" CommandArgument='<%#Container.DataItemIndex %>' Visible='<%# !Util.GetBoolean(Eval("IsFree")) %>' />
                                        <asp:Label ID="lblPODetailID" runat="server" Text='<%# Eval("PurchaseOrderDetailID") %>'
                                            Visible="False"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Reject" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject" ImageUrl="~/Images/Delete.gif" CommandArgument='<%#Container.DataItemIndex %>' />

                                        <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>'
                                            Visible="False"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>


                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
                <asp:Button ID="btnTermsConditions" runat="server" Visible="false" Text="Edit Terms & Conditions"
                    CssClass="ItDoseButton" OnClick="btnTermsConditions_Click" />
            </div>
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <asp:Panel ID="pnlAddGroup" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none; width: 650px">
        <div class="Purchaseheader" id="dragHandle" runat="server">
            Update Item Details
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;           
            
        </div>
        <div class="">
            <asp:Label ID="lblPODetailID" runat="server" Text="" Visible="false"></asp:Label>
            <asp:Label ID="lblItemID" runat="server" Text="" Visible="false"></asp:Label>
            <table>
                <tr>
                    <td style="text-align: right">PO No. :&nbsp;</td>
                    <td class="left-align">
                        <asp:Label ID="lblPONO" runat="server" Font-Bold="true"></asp:Label></td>
                </tr>
                <tr>
                    <td style="text-align: right">Item Name :&nbsp;</td>
                    <td class="left-align">
                        <asp:Label ID="lblItemName" runat="server"></asp:Label></td>
                </tr>
                <tr style="display: none">
                    <td style="text-align: right">Specification :&nbsp;</td>
                    <td class="left-align">
                        <asp:TextBox ID="lblSpecification" runat="server" MaxLength="100"
                            Width="290px">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" FilterType="LowercaseLetters,UppercaseLetters"
                            TargetControlID="lblSpecification">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Order Qty. :&nbsp;</td>
                    <td class="left-align">
                        <asp:Label ID="lblOrderQty" runat="server"></asp:Label></td>
                </tr>



            </table>
            <table>
                <tr>
                    <td style="text-align: right">Approve Qty. :&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtApproveQty" runat="server" Width="50px" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedots();">
                        </asp:TextBox></td>
                    <td style="text-align: right">Rate :&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtPrice" runat="server" Width="50px" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedots();">
                        </asp:TextBox></td>
                    <td style="text-align: right">Discount :&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtDiscount" runat="server" Width="50px" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedots();">
                        </asp:TextBox></td>
                </tr>
                <tr>
                    <td style="text-align:right"> Tax Calculated On :&nbsp;</td>
                     <td><asp:Label ID="lblTaxCalulatedOn" runat="server" Width="50px">
                    </asp:Label>                        
                     </td>
                    <td style="text-align:right">Deal :&nbsp;</td>
                    <td><asp:Label ID="lblDeal" runat="server" Width="100px"></asp:Label></td>
                     <td style="text-align:right"> HSNCode :&nbsp;</td>
                    <td><asp:Label ID="lblHSNCode" runat="server" Width="100px"> ></asp:Label></td>
                    
                </tr>
                <tr>
                    <td style="text-align: right">IGST(%) :&nbsp;</td>
                    <td>
                        <asp:Label ID="lblIGSTPer" runat="server" Width="50px">
                        </asp:Label>
                    </td>
                    <td style="text-align: right">GST Type :&nbsp;</td>
                    <td>
                        <asp:Label ID="lblGSTType" runat="server" Width="100px"> ></asp:Label></td>
                    <td style="text-align: right"></td>
                    <td></td>
                </tr>

                <tr>
                    <td style="text-align: right">CGST(%) :&nbsp;</td>
                    <td>
                        <asp:Label ID="lblCGSTPer" runat="server" Width="50px">
                        </asp:Label>
                    </td>
                    <td style="text-align: right">SGST(%) :&nbsp;</td>
                    <td>
                        <asp:Label ID="lblSGSTPer" runat="server" Width="100px"> ></asp:Label></td>
                    <td style="text-align: right"></td>
                    <td></td>
                </tr>
            </table>


        </div>
        <br />
        <div style="text-align: center;" class="filterOpDiv">
            <%--  display:none--%>
            <br />
            <asp:GridView ID="grdTax" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <%--<asp:BoundField DataField="TaxName" HeaderText="Tax Name" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                    <asp:TemplateField HeaderText="Tax Name" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblTaxName" runat="server" Text='<%# Eval("TaxName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Tax(%)" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:TextBox ID="txtPer" runat="server" Visible='<%# Util.GetBoolean(Eval("isPer")) %>' Text='<%# Eval("Tax") %>' Width="75px" CssClass="ItDoseTextinputNum" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                                TargetControlID="txtPer" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            <asp:Label ID="lblOldTaxPer" runat="server" Text='<%# Eval("Tax") %>' Visible="False"></asp:Label>
                            <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ITemID") %>' Visible="False"></asp:Label>
                            <asp:Label ID="lblTaxID" runat="server" Text='<%# Eval("TaxID") %>' Visible="False"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tax Amount" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:TextBox ID="txtAmt" Visible='<%# Util.GetBoolean(Eval("isAmt")) %>' runat="server" Text='<%# Eval("TaxAmt") %>' Width="75px" CssClass="ItDoseTextinputNum"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers"
                                TargetControlID="txtAmt" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            <asp:Label ID="lblOldTaxAmt" runat="server" Text='<%# Eval("TaxAmt") %>' Visible="False"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <asp:CheckBox ID="chkTax" runat="server" Text="Tax Update" CssClass="ItDoseCheckbox" Style="display: none" />
        </div>
        <div class="filterOpDiv" style="text-align: center">
            <asp:Button ID="btnupdate" runat="server" Text="Update" CssClass="ItDoseButton"
                OnClick="btnupdate_Click" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel" BehaviorID="mpeCreateGroup"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddGroup" PopupDragHandleControlID="dragHandle" />
    <asp:Panel ID="pnlNarration" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div1" runat="server">
            Update Order Info. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           
                                
                                
        </div>
        <div class="">
            <table>
                <tr>
                    <td style="text-align: right">Order No. :&nbsp;</td>
                    <td class="left-align">
                        <asp:Label ID="lblNarPONo" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp">
                        </asp:Label></td>
                </tr>
                <tr>
                    <td style="text-align: right; vertical-align: top">Narration :&nbsp;</td>
                    <td class="left-align">
                        <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" CssClass="ItDoseTextinputText"
                            Width="340px" Height="30px" /></td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right; display: none">Freight :&nbsp;
                    </td>
                    <td style="width: 100px; display: none" class="left-align">
                        <asp:TextBox ID="txtFreight" runat="server" Width="102px" MaxLength="20" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedots();">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtFreight" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right; display: none">R/O Amt. :&nbsp;
                    </td>
                    <td style="width: 100px; display: none" class="left-align">
                        <asp:TextBox ID="txtRoundOff" runat="server" Width="102px" MaxLength="20" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedots();">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtRoundOff" ValidChars="-.">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right; display: none">Scheme :&nbsp;
                    </td>
                    <td style="width: 100px; display: none" class="left-align">
                        <asp:TextBox ID="txtScheme" runat="server" Width="102px" MaxLength="20" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedots();">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtScheme" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 120px; text-align: right; display: none">Excise On Bill :&nbsp;
                    </td>
                    <td style="width: 100px; display: none" class="left-align">
                        <asp:TextBox ID="txtExciseOnBill" runat="server" Width="102px" MaxLength="20" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedots();">
                        </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtExciseOnBill" ValidChars="-.">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnNarSave" runat="server" Text="Save" CssClass="ItDoseButton"
                OnClick="btnNarSave_Click" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnNarCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpNarration" runat="server" CancelControlID="btnNarCancel" BehaviorID="mpNarration"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlNarration" PopupDragHandleControlID="dragHandle" />
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div2" runat="server">
            Cancel PO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>
        <div class="" style="margin-left: 20px">
            <table width="530px">
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Label ID="lblGrn" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">PO No. :&nbsp;&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:Label ID="lblPoNo1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 135px; text-align: right;">Reason :&nbsp;&nbsp;
                    </td>
                    <td style="width: 395px" class="left-align">
                        <asp:TextBox ID="txtCancelReason" runat="server" CssClass="ItDoseTextinputText" Width="250px"
                            MaxLength="100" />
                        <asp:Label ID="lblReason" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>


                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv" style="text-align: center">
            <asp:Button ID="btnGRNCancel" runat="server" CssClass="ItDoseButton" Text="Reject"
                ValidationGroup="GRNCacnel" OnClick="btnGRNCancel_Click" OnClientClick="return validateGRN()" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpCancel" runat="server" CancelControlID="btnCancel" BehaviorID="mpCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel2" PopupDragHandleControlID="Div2">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel3" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div4" runat="server">
            Cancel Item  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            Press esc to close
        </div>

        <table width="530px">
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblCancelItem" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
            </tr>
            <tr>
                <td style="width: 135px; text-align: right;">PO No. :&nbsp;&nbsp;
                </td>
                <td style="width: 395px" class="left-align">
                    <asp:Label ID="lblPoNo2" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="width: 135px; text-align: right;">Item Name :&nbsp;&nbsp;
                </td>
                <td style="width: 395px" class="left-align">
                    <asp:Label ID="lblItemName1" runat="server" />
                    <asp:Label ID="lblCancelItemID" runat="server" Visible="false"></asp:Label>
                    <asp:Label ID="lblPODetailID1" runat="server" Visible="false"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 135px; text-align: right;">Reason :&nbsp;&nbsp;
                </td>
                <td style="width: 395px" class="left-align">
                    <asp:TextBox ID="txtItemReason" runat="server" Width="250px"
                        MaxLength="100" ValidationGroup="ItemCacnel" />
                    <asp:Label ID="lblReasonpo" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>




                </td>
            </tr>
        </table>

        <div class="filterOpDiv" style="text-align: center">
            <asp:Button ID="btnRejectItem" runat="server" CssClass="ItDoseButton" Text="Reject Item"
                ValidationGroup="ItemCacnel" OnClick="btnRejectItem_Click" OnClientClick="return validateRej()" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancelItem" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mapItemCancel" runat="server" CancelControlID="btnCancelItem" BehaviorID="mapItemCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel3" PopupDragHandleControlID="Div4">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlConditions" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;"
        Width="543px">
        <div class="Purchaseheader" id="Div3" runat="server">
            Update Terms and Conditions 
        </div>
        <div class="">
            <Ajax:UpdatePanel ID="upTerms" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div style="float: left; clear: both; width: 542px;">
                        <label style="width: 59px">
                            PO No. :</label>&nbsp;&nbsp;
                        <asp:Label ID="lblPONo_Terms" runat="server" Width="453px" Style="text-align: left;" />
                        <label style="width: 59px">
                            Terms :</label>&nbsp;&nbsp;
                        <asp:TextBox ID="txtConditions" runat="server" Width="445px" CssClass="ItDoseTextinputText"
                            ValidationGroup="Terms" AccessKey="T" />
                        <cc1:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="txtConditions"
                            MinimumPrefixLength="1" ServicePath="../../POTermsConditions.asmx" ServiceMethod="GetList"
                            CompletionInterval="1000" EnableCaching="true" CompletionSetCount="10" />
                        <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtConditions"
                            Display="None" ErrorMessage="Specify Terms & Conditions" SetFocusOnError="True"
                            ValidationGroup="Terms">*</asp:RequiredFieldValidator>
                        <asp:Button ID="btnAddTerms" runat="server" Text="Add Terms" CssClass="ItDoseButton"
                            ValidationGroup="Terms" OnClick="btnAddTerms_Click" />
                    </div>


                    <br />
                    <br />
                    <div style="float: left; width: 540px;">
                        <asp:GridView ID="gvTerms" runat="Server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="gvTerms_RowCommand" Width="535px">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Terms &amp; Conditions">
                                    <ItemTemplate>
                                        <%# Eval("Terms") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Remove">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                            CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                        <asp:Label ID="lblPONumber" runat="server" Visible="false" Text='<%# Eval("PONumber") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </ContentTemplate>
            </Ajax:UpdatePanel>
        </div>
        <div class="filterOpDiv" style="width: 100%; text-align: center">
            <asp:Button ID="btnUpdateCondition" runat="server" CssClass="ItDoseButton" Text="Save"
                OnClick="btnUpdateCondition_Click" />
            &nbsp; &nbsp;
            <asp:Button ID="btnCancelCondition" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCondtions" runat="server" CancelControlID="btnCancelCondition"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlConditions" PopupDragHandleControlID="Div2">
    </cc1:ModalPopupExtender>

    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="true"
        ShowSummary="false" ValidationGroup="ItemCacnel" />
    <asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false"
        ValidationGroup="GRNCacnel" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
        ShowSummary="False" ValidationGroup="Terms" />
</asp:Content>
