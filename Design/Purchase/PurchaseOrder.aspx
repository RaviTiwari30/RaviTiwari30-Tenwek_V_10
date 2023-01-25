<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="PurchaseOrder.aspx.cs" Inherits="Design_Purchase_PurchaseOrder" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        $(function () {
            $('#<%=ddlCurrency.ClientID %>').change(function () {
                getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), document.getElementById('<%=txtInvoiceAmount.ClientID %>').value);

            });
        });
        function getCurrencyBase(CountryID, Amount) {
            $.ajax({
                url: "../Common/CommonService.asmx/getConvertCurrecncy",
                data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $('#lblCurreny_Amount').text(data);
                    $('#txtCurreny_Amount').val(data);
                }
            });

        }
        function ButtonDisable(btn) {

            var narration = document.getElementById('<%=txtNarration.ClientID %>').value;

            if (narration != '') {
                btn.disabled = true;
                __doPostBack('<%=btnSave.ClientID %>');
            }

        }
        function LTrim(value) {

            var re = /\s*((\S+\s*)*)/;
            return value.replace(re, "$1");

        }
        function RTrim(value) {

            var re = /((\s*\S+)*)\s*/;
            return value.replace(re, "$1");

        }

        // Removes leading and ending whitespaces
        function trim(value) {

            return LTrim(RTrim(value)); 

        }
        $(document).ready(function () {
            sum();
        });
        function sum() {
            $('#<%=ddlCurrency.ClientID %>').val(<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>);
            CheckDot();
            var Nettotal = $('#<%=lbl.ClientID %>').val();
            if (Nettotal == "undefined" || Nettotal=="") {
                Nettotal = 0;
            } 
            var fright = $('#<%=txtFreight.ClientID %>').val();
            if (fright == "undefined" || fright =="") {
                fright = 0;
            }
            var RoundOff = $('#<%=txtRoundOff.ClientID %>').val();
            if (RoundOff == "undefined" || RoundOff =="") {
                RoundOff = 0;
            }
            var Scheme = $('#<%=txtScheme.ClientID %>').val();
            if (Scheme == "undefined" || Scheme =="") {
                Scheme = 0;
            }
            var Excise = $('#<%=txtExciseOnBill.ClientID %>').val();
            if (Excise == "undefined" || Excise == "") {
                Excise = 0;
            }
           

            Nettotal = eval(Nettotal) + eval(fright) + eval(Excise) - eval(Scheme);
           
            var _TAmt = Math.round(Nettotal * 100) / 100;
            Nettotal = Math.round(Nettotal);
            var _Round = Math.round((Nettotal - _TAmt) * 100) / 100;
            $('#lblCurreny_Amount').text(Nettotal);
            $('#txtCurreny_Amount').val(Nettotal);
            
            $('#<%=txtInvoiceAmount.ClientID %>').val(Nettotal);
            $('#<%=txtRoundOff.ClientID %>').val(_Round);

           

        }

        function CheckDot() {
            
            if (($("#<%=txtFreight.ClientID%>").val() >"0") ) {
                if (($("#<%=txtFreight.ClientID%>").val().charAt(0) == ".")) {
                    $("#<%=txtFreight.ClientID%>").val('');
                    return false;
                }
            }
            if (($("#<%=txtOrderQty.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtOrderQty.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtScheme.ClientID%>").val() > "0")) {
                if (($("#<%=txtScheme.ClientID%>").val().charAt(0) == ".")) {
                    $("#<%=txtScheme.ClientID%>").val('');
                    return false;
                }
            }
            if (($("#<%=txtExciseOnBill.ClientID%>").val() > "0")) {
                if (($("#<%=txtExciseOnBill.ClientID%>").val().charAt(0) == ".")) {
                    $("#<%=txtExciseOnBill.ClientID%>").val('');
                    return false;
                }
            }
            return true;
        }

        function getLength() {
            var MaxLength = 100;
            $("#<% =txtNarration.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtNarration.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
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
        }
    </script>
     
    <script type="text/javascript" >
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

        function validatetax() {
            $("input[id*=txtTaxPer]").bind("blur keyup keydown", function () {
                if (($(this).closest("tr").find("input[id*=txtTaxPer]").val().charAt(0) == ".")) {
                    $(this).closest("tr").find("input[id*=txtTaxPer]").val('');
                }
                var tax = $(this).closest("tr").find("input[id*=txtTaxPer]").val();
                if (Number(tax) > 100) {
                    $(this).closest("tr").find("input[id*=txtTaxPer]").val('');
                    alert('Invalid Discount');
                }
            });
            $("input[id*=txtTaxAmt]").bind("blur keyup keydown", function () {
                if (($(this).closest("tr").find("input[id*=txtTaxAmt]").val().charAt(0) == ".")) {
                    $(this).closest("tr").find("input[id*=txtTaxAmt]").val('');
                }
            });
            return true;
        }
        function hidedata() {
            $('#<%=txtItemName.ClientID %>,#<%=txtSpecification.ClientID %>,#<%=txtFreeQty.ClientID %>').val('');

            $('#<%=lblFree.ClientID %>').text('');
            $('#<%=ddlItems.ClientID %> option').each(function (i, option) { $(option).remove(); });

        }
        function validate() {
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
            }
        }
        function validateSet() {
            if ($("#<%=txtsetTerms.ClientID%>").val().trim() == "") {
                $("#<%=lblTermsErr.ClientID%>").text('Please Enter Term Set');
                $("#<%=txtsetTerms.ClientID%>").focus();
                return false;
            }
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="600">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Purchase Order</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:Label ID="lblMsg2" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%">
                <tr>
                    <td style="width: 15%; text-align: right;">Vendor :
                    </td>
                    <td style="width: 20%; text-align: right;">
                        <asp:DropDownList ID="ddlVendor" runat="server" Width="200px"
                            AutoPostBack="True" OnSelectedIndexChanged="ddlVendor_SelectedIndexChanged" />
                    </td>
                    <td style="width: 30%; text-align: right;">Vendor Details :
                    </td>
                    <td style="width: 35%; text-align: left;">
                        <asp:Label ID="lblVendorDetails" runat="server" Width="300px" CssClass="ItDoseTxtLabel" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right;">&nbsp;</td>
                    <td style="text-align: right;" colspan="2">
                        <asp:RadioButtonList ID="rdoItemType" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Selected="True" Value="28">General Items</asp:ListItem>
                            <asp:ListItem Value="11">Medical Items</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 35%; text-align: left;">&nbsp;</td>
                </tr>
                <tr align="center">
                    <td colspan="4" style="text-align: center;">
                        <asp:Button ID="btnGetRequestItem" runat="server" Text="Get Items"
                            CssClass="ItDoseButton" CausesValidation="False"
                            OnClick="btnGetRequestItem_Click1" />
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlItems" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Items Detail
                </div>
                <div style="text-align: center">
                    <asp:CheckBox ID="chkItems" runat="server" Checked="true" Text="All Items" AutoPostBack="true"
                        CssClass="ItDoseCheckbox" OnCheckedChanged="chkItems_CheckedChanged" Style="display: none;" />
                    <asp:GridView ID="gvItems" runat="Server" AutoGenerateColumns="False" Width="960px"
                        CssClass="GridViewStyle" OnRowDataBound="gvItems_RowDataBound" OnRowCommand="gvItems_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="server" AutoPostBack="true" OnCheckedChanged="chkSelect_CheckedChanged"
                                        Checked='<%# Util.GetBoolean(Eval("Save")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Request No." HeaderStyle-Width="135px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("PurchaseRequisitionNo")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("ItemName")%>
                                    <asp:Label ID="lblunit" runat="server" Text='<%#Eval("Unit") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Specification" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Specification")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Free" HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Util.GetBoolean(Eval("IsFree"))?"Yes":"No" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="InHand" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("InHandQty")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Rmn. Qty." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("PendingQty")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Order Qty." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblQty" runat="server" Text='<%# Eval("OrderQty")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="lblType_ID" runat="server" Text='<%# Eval("Type_ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblRate" runat="server" Text='<%# Eval("ApproxRate")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Disc." HeaderStyle-Width="45px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("Discount")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Selling Price" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tax" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Repeater ID="rpTax" runat="server">
                                        <ItemTemplate>
                                            <div>
                                                <label class="labelForTax">
                                                    <%# Eval("TaxName")%>
                                                </label>
                                                :&nbsp;
                                                <asp:Label ID="lblTax" runat="server" Text='<%# Eval("TaxDisplay")%>'></asp:Label>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Amt." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblNetAmount" runat="server" Text='<%# Eval("NetAmount")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit" HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbModify" ToolTip="Modify Item" runat="server" ImageUrl="~/Images/edit.png"
                                        CausesValidation="false" CommandArgument='<%# Eval("PuschaseRequistionDetailID") %>'
                                        CommandName="imbModify" Visible='<%# !Util.GetBoolean(Eval("IsFree")) %>' />
                                    <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                        CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove"
                                        Visible='<%# Util.GetBoolean(Eval("IsFree")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-Width="0px" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblPrDetailID" runat="server" Visible="false" Text='<%# Eval("PuschaseRequistionDetailID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:Button ID="btnFreeItems" AccessKey="F" runat="server" Text="Add Free Item"
                        CssClass="ItDoseButton" CausesValidation="False" />
                </div>
            </div>
            <div style="display: none">
                <asp:TextBox ID="lbl" runat="server">
                </asp:TextBox>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Terms & Conditions
                </div>
                <table style="width: 100%">
                    <tr>
                        <td style="width: 15%; text-align: right;">Terms :
                        </td>
                        <td style="width: 20%; text-align: right;">
                            <asp:DropDownList ID="ddlTermsSet" runat="server" CssClass="ItDoseLabel" Width="350px">
                            </asp:DropDownList>
                        </td>
                        <td style="width: 15%; text-align: right;">
                            <asp:Button ID="btnAddTerms" runat="server" Text="Add Terms & Conditions"
                                CssClass="ItDoseButton" ValidationGroup="Terms"
                                OnClick="btnAddTerms_Click" />
                        </td>
                        <td style="width: 50%; text-align: left;">
                            <asp:Button ID="btnAddSet" runat="server" Text="New" CssClass="ItDoseButton"
                                OnClick="btnAddSet_Click" />
                        </td>
                    </tr>
                    <tr align="center">
                        <td colspan="4" style="text-align: center;">
                            <asp:GridView ID="gvTerms" runat="Server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowCommand="gvTerms_RowCommand" Width="495px">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Terms & Conditions" HeaderStyle-Width="600px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%# Eval("Terms") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Remove" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                                CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
           
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Purchase Order Information
                </div>
                <table style="width: 100%">
                    <tr>
                        <td style="width: 10%; text-align: right">Freight :&nbsp;
                        </td>
                        <td style="width: 10%" class="left-align">
                            <asp:TextBox ID="txtFreight" runat="server" Width="75px"
                                CssClass="ItDoseTextinputNum" Text="0" AutoCompleteType="Disabled"
                                onkeypress="return checkForSecondDecimal(this,event)" MaxLength="8" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Custom, Numbers"
                                TargetControlID="txtFreight" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 10%; text-align: right">R/o&nbsp;Amt.&nbsp;:&nbsp;
                        </td>
                        <td style="width: 10%" class="left-align">
                            <asp:TextBox ID="txtRoundOff" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum" Text="0"
                                Width="75px" onkeypress="return checkForSecondDecimal(this,event)">
                            </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtRoundOff"
                                FilterType="Custom, Numbers" ValidChars=".-">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 10%; text-align: right">Scheme :&nbsp;
                        </td>
                        <td style="width: 10%" class="left-align">
                            <asp:TextBox ID="txtScheme" AutoCompleteType="Disabled" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                                Width="75px" onkeypress="return checkForSecondDecimal(this,event)"
                                MaxLength="8"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtScheme"
                                FilterType="Custom, Numbers" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 10%; text-align: right">Bill&nbsp;Amount&nbsp;:&nbsp;
                        </td>
                        <td style="width: 10%" class="left-align">
                            <asp:TextBox ID="txtInvoiceAmount" AutoCompleteType="Disabled" runat="server" Width="75px" CssClass="ItDoseTextinputNum">
                            </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtInvoiceAmount"
                                FilterType="Custom, Numbers" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 10%">Excise&nbsp;On&nbsp;Bill:&nbsp;
                        </td>
                        <td style="width: 10%" class="left-align">
                            <asp:TextBox ID="txtExciseOnBill" AutoCompleteType="Disabled" Width="75px" Text="0" CssClass="ItDoseTextinputNum"
                                runat="server" onkeypress="return checkForSecondDecimal(this,event)"
                                MaxLength="8"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtExciseOnBill"
                                FilterType="Custom, Numbers" ValidChars=".-">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 10%; text-align: right">Currency :&nbsp;</td>
                        <td colspan="2" class="left-align">
                            <asp:DropDownList ID="ddlCurrency" runat="server" CssClass="ItDoseLabel" />

                            &nbsp;<asp:Label ID="lblCurreny_Amount" runat="server" ClientIDMode="Static"
                                Style="color: #0000CC; font-weight: 700; background-color: #CCFF33;"></asp:Label>
                            <asp:TextBox ID="txtCurreny_Amount" Style="display: none" ClientIDMode="Static" runat="server"></asp:TextBox>
                        </td>
                        <td style="width: 10%">
                            <asp:TextBox ID="lblCurrencyNotation" runat="server" Style="display: none;"></asp:TextBox>
                            &nbsp;</td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%">&nbsp;</td>
                        <td style="width: 10%">&nbsp;</td>
                        <td style="width: 10%">&nbsp;</td>
                        <td style="width: 10%">&nbsp;</td>
                        <td style="width: 10%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 10%; text-align: right">PO Date :&nbsp;
                        </td>
                        <td style="width: 10%" class="left-align">
                            <asp:TextBox ID="ucPODate" runat="server" ClientIDMode="Static"
                                CssClass="ItDoseTextinputText" Width="100px"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Animated="true"
                                Format="dd-MMM-yyyy" TargetControlID="ucPODate">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 10%; text-align: right">Valid Date :&nbsp;
                        </td>
                        <td style="width: 10%" class="left-align">
                            <asp:TextBox ID="ucValidDate" runat="server" ClientIDMode="Static"
                                CssClass="ItDoseTextinputText" Width="100px"></asp:TextBox>
                            <cc1:CalendarExtender ID="Calendarextender1" runat="server"
                                Format="dd-MMM-yyyy" TargetControlID="ucValidDate">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 10%; text-align: right">Type :&nbsp;
                        </td>
                        <td style="width: 10%" class="left-align">
                            <asp:DropDownList ID="ddlPOType" runat="server" AutoPostBack="True"
                                CssClass="ItDoseLabel"
                                OnSelectedIndexChanged="ddlPOType_SelectedIndexChanged" />
                        </td>
                        <td style="width: 10%">
                            <asp:TextBox ID="bydate" runat="server" ClientIDMode="Static"
                                CssClass="ItDoseTextinputText" Visible="false" Width="100px"></asp:TextBox>
                            &nbsp;
                            <cc1:CalendarExtender ID="Calendarextender2" runat="server"
                                Format="dd-MMM-yyyy" TargetControlID="bydate">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%"></td>
                    </tr>
                    <tr>
                        <td style="width: 10%; text-align: right; vertical-align: top">Narration :&nbsp;
                        </td>
                        <td colspan="9" class="left-align">
                            <asp:TextBox ID="txtNarration" runat="server" Width="700px" TextMode="MultiLine"
                                CssClass="ItDoseTextinputText" ValidationGroup="Save" onkeyup="getLength()" />

                        </td>
                    </tr>
                    <tr>
                        <td style="width: 10%; text-align: right">Remarks :&nbsp;
                        </td>
                        <td colspan="9" class="left-align">
                            <asp:TextBox ID="txtRemarks" runat="server" Width="500px" MaxLength="200" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">

                <table width="100%">
                    <tr align="center">
                        <td style="text-align: center; width: 100%;">
                            <asp:Label ID="lblchktxt" runat="server" Text="Print"></asp:Label>
                            <asp:CheckBox ID="chkPrintImg" Checked="true" runat="server" />
                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                                ValidationGroup="Save" OnClick="btnSave_Click" OnClientClick="return validate();" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="ItDoseButton"
                                CausesValidation="False" OnClick="btnReset_Click" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtNarration"
                                Display="None" ErrorMessage="Specify Narration" SetFocusOnError="True" ValidationGroup="Save">*</asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
    </div>
    <asp:Panel ID="pnlAddFreeItem" runat="server" CssClass="pnlRequestItemsFilter" Style="display: none; width: 900px;">
        <div class="Purchaseheader">
            Add Free Items
        </div>
        <Ajax:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" RenderMode="Inline">
            <ContentTemplate>
                <div class="content">
                    <table>
                        <tr>
                            <td>Item Search :
                            </td>
                            <td>
                                <asp:TextBox ID="txtItemName" runat="server" AutoCompleteType="disabled" CssClass="ItDoseTextinputText"
                                    ValidationGroup="ItemLoad" Width="200px">
                                </asp:TextBox>
                            </td>
                            <td>
                                <asp:Button ID="btnLoadItem" runat="server" CssClass="ItDoseButton" OnClick="btnLoadItem_Click"
                                    Text="Load" ValidationGroup="ItemLoad" style="width:50px" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlItems" runat="server" CssClass="ItDoseLabel" />
                            </td>
                        </tr>
                        <tr>
                            <td>Specification :
                            </td>
                            <td>
                                <asp:TextBox ID="txtSpecification" runat="server" ValidationGroup="Free" AutoCompleteType="disabled"
                                    CssClass="ItDoseTextinputText" Width="200px">
                                </asp:TextBox>
                            </td>
                            <td>Quantity :
                            </td>
                            <td>
                                <asp:TextBox ID="txtFreeQty" runat="server" ValidationGroup="Free" MaxLength="8" AutoCompleteType="disabled"
                                    CssClass="ItDoseTextinputNum">
                                </asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers"
                                    TargetControlID="txtFreeQty">
                                </cc1:FilteredTextBoxExtender>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtFreeQty"
                                    Display="None" ErrorMessage="Enter Free Item Quantity" SetFocusOnError="True"
                                    ValidationGroup="Free">*</asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtSpecification"
                                    Display="None" ErrorMessage="Enter Item Specification" SetFocusOnError="True"
                                    ValidationGroup="Free">*</asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtItemName"
                                    Display="None" ErrorMessage="Enter ItemName" SetFocusOnError="True" ValidationGroup="ItemLoad">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </Ajax:UpdatePanel>
        <div class="filterOpDiv" style="text-align:center">
            <asp:Label ID="lblFree" runat="server" Style="color: Red; font-size: 11px;" Visible="false"></asp:Label>&nbsp;
            <asp:Button ID="btnAddFree" runat="server" Text="Add Item" CssClass="ItDoseButton"
                ValidationGroup="Free" OnClick="btnAddFree_Click" />&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" OnClientClick="return hidedata()" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnFreeItems" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddFreeItem" PopupDragHandleControlID="dragHandle" />
    <div style="display: none;">
        <asp:Button ID="btnDemo" runat="server" CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="pnlSetterms" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none; width: 550px; height: 300px;">
        <div class="Purchaseheader" id="Div1" runat="server">
            Enter Terms Set Name
        </div>
       
            <table>
                <tr>
                    <td colspan="2" style="text-align:center">
                        <asp:Label runat="server" ID="lblTermsErr" Style="color: Red;"></asp:Label>
                    </td>
                </tr>

                <tr>
                    <td class="right-align">Set Name :
                    </td>
                    <td class="left-align">
                        <asp:TextBox ID="txtsetTerms" MaxLength="50" runat="server">
                        </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top" class="right-align">Set Detail :
                    </td>
                    <td class="left-align">
                        <asp:TextBox ID="txtDetailTerms" runat="server" Width="422px" Height="50px">
                        </asp:TextBox>
                    </td>
                </tr>
            </table>      
        <div style="float: left;">
            <asp:GridView ID="grdSetterm" runat="Server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                OnRowCommand="grdSetterm_RowCommand">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Terms & Conditions" HeaderStyle-Width="600px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("Terms") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Remove" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
       
        <div style="text-align: center;">
            <asp:Button ID="btnAddItem" CssClass="ItDoseButton" runat="server" Text="AddItem" OnClick="btnAddItem_Click" />
            <asp:Button ID="btnSaveSet" OnClientClick="return validateSet()" CssClass="ItDoseButton" runat="server" Text="SaveSet" OnClick="btnSaveSet_Click" />
            <asp:Button ID="btncancelSet" CssClass="ItDoseButton" runat="server" Text="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpEnterSet" runat="server" CancelControlID="btncancelSet"
        DropShadow="true" TargetControlID="btnDemo" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlSetterms" PopupDragHandleControlID="dragUpdate" />
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Width="550px" Style="display: none;">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Update Item Details
        </div>
        <asp:Label ID="lblPDID" runat="server" Visible="false" />
        <asp:Label ID="lblItemID" runat="server" Visible="false" />
        <div class="content">
            <label class="labelForTag">
                Request No. :</label>
            <asp:Label ID="lblPRNo" runat="server" CssClass="ItDoseLabelSp" Font-Bold="true" />
            <br />
            <br />
            <label class="labelForTag">
                Item :</label>
            <asp:Label ID="lblItemName" runat="server" CssClass="ItDoseLabel" />
            <br />
            <br />
            <label class="labelForTag">
                Specification :</label>
            <asp:TextBox ID="lblSpecification" runat="server" CssClass="ItDoseTextinputText"
                Width="250px">
            </asp:TextBox>
            <br />
            <br />
            <div>
                <div style="float: left; clear: both;">
                    <label class="labelForTag">
                        In Hand Qty. :</label>
                    <asp:Label ID="lblInHandQty" runat="server" CssClass="ItDoseLabel" />
                    <br />
                    <br />
                    <label class="labelForTag">
                        Discount :</label>
                    <asp:TextBox ID="txtDiscount" runat="server" Width="50px" CssClass="ItDoseTextinputNum" />&nbsp;
                    <cc1:FilteredTextBoxExtender ID="fl1" runat="server" TargetControlID="txtDiscount"
                        FilterType="Custom,Numbers" ValidChars="." />
                </div>
                <div style="float: left;">
                    <label class="labelForTag">
                        Remain Qty. :</label>
                    <asp:Label ID="lblOrderQty" runat="server" CssClass="ItDoseLabel" />&nbsp;
                    <br />
                    <br />
                    <label class="labelForTag">
                        Order Qty. :</label>
                    <asp:TextBox ID="txtOrderQty" runat="server" Width="50px" CssClass="ItDoseTextinputNum"
                        ValidationGroup="Update" onkeypress="return checkForSecondDecimal(this,event)"  MaxLength="8" />&nbsp;
                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtOrderQty"
                        FilterType="Custom,Numbers" ValidChars="." />
                </div>
                <div style="float: left;">
                    <label class="labelForTag">
                        Rate :</label>
                    <asp:Label ID="lblRate" runat="server" CssClass="ItDoseLabel" />
                    <br />
                    <br />
                    <label class="labelForTag">
                        Rate :</label>
                    <asp:TextBox ID="txtRate" runat="server" Width="50px" CssClass="ItDoseTextinputNum"
                        ValidationGroup="Update" />&nbsp;
                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtRate"
                        FilterType="Custom,Numbers" ValidChars="." />
                </div>
            </div>
        </div>
        <br />
        <div style="text-align: center;" class="filterOpDiv">
            <br />
            <asp:GridView ID="gvTax" runat="Server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tax Name" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblTaxName" runat="server" Text='<%# Eval("TaxName")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tax Per." HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:TextBox ID="txtTaxPer" Visible='<%# Util.GetBoolean(Eval("isPer")) %>' runat="server"
                                Width="75px" CssClass="ItDoseTextinputNum" Text='<%# Eval("TaxPer") %>' onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatetax();" MaxLength="8" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtTaxPer"
                                FilterType="Custom,Numbers" ValidChars="." />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tax Amt." HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:TextBox ID="txtTaxAmt" runat="server" Visible='<%# Util.GetBoolean(Eval("isAmt")) %>'
                                Width="75px" CssClass="ItDoseTextinputNum" Text='<%# Eval("TaxAmt") %>' onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatetax();" MaxLength="8" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtTaxAmt"
                                FilterType="Custom,Numbers" ValidChars="." />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-Width="0px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblTaxID" runat="server" Text='<%# Eval("TaxID") %>' Visible="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <asp:CheckBox ID="chkTax" runat="server" Text="Tax Update" CssClass="ItDoseCheckbox" />
        </div>
        <div class="filterOpDiv">
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtOrderQty"
                Display="None" ErrorMessage="Specify Order Quantity " SetFocusOnError="True"
                ValidationGroup="Update">*</asp:RequiredFieldValidator>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtRate"
                Display="None" ErrorMessage="Specify Rate" SetFocusOnError="True" ValidationGroup="Update">*</asp:RequiredFieldValidator>
            <asp:Button ID="btnPdUpdate" runat="server" Text="Update" CssClass="ItDoseButton"
                ValidationGroup="Update" OnClick="btnPdUpdate_Click" />&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnUpdateCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpUpdate" runat="server" CancelControlID="btnUpdateCancel"
        DropShadow="true" TargetControlID="btnDemo" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate" PopupDragHandleControlID="dragUpdate" />
</asp:Content>
