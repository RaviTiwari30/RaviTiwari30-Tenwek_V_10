<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wuc_IpdAdvance.ascx.cs"
    Inherits="Design_Controls_wuc_IpdAdvance" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script  type="text/javascript">
    function changeBaseAmt(paidAmt) {
        if (paidAmt > $('#txtNetAmount').val()) {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#txtNetAmount').val() - $('#<%=lblTotalPaidAmount.ClientID %>').text());
        }
        else if ($('#<%=lblTotalPaidAmount.ClientID %>').text() == "0") {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#txtNetAmount').val() - paidAmt);
        }
        else if ($('#<%=lblBalanceAmount.ClientID %>').text() == "0") {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text());
        }
        else {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text() - paidAmt);
        }
    }
    function changeBaseAmtRoundoff(paidAmt) {
        if (paidAmt > $('#txtNetAmount').val()) {
            getCurrencyBaseRoundOff($('#<%=ddlCountry.ClientID %>').val(), $('#txtNetAmount').val() - $('#<%=lblTotalPaidAmount.ClientID %>').text());
        }
        else if ($('#<%=lblTotalPaidAmount.ClientID %>').text() == "0") {
            getCurrencyBaseRoundOff($('#<%=ddlCountry.ClientID %>').val(), $('#txtNetAmount').val() - paidAmt);
        }
        else if ($('#<%=lblBalanceAmount.ClientID %>').text() == "0") {
            getCurrencyBaseRoundOff($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text());
        }
        else {
            getCurrencyBaseRoundOff($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text() - paidAmt);
        }
}
</script>
<script  type="text/javascript">
    $(document).ready(function () {
        $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>").hide();
        paymentmode();
        $(".a").hide();
        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
        $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
        $('#<%=ddlCountry.ClientID %>').change(function () {
            loadCountryFactor();
        });
        if ($("span[id*=lblOPDFinalSettlement]").length > 0) {
            var amount = parseFloat($.trim($("#<%=lblBalanceAmount.ClientID %>").text()));
            if (amount == "0.00") {
                $('#<%=txtPaidAmount.ClientID %>,#<%=ddlPaymentMode.ClientID%>,#<%=btnAdd.ClientID%>,#<%=ddlCountry.ClientID%>').attr("disabled", true);
            }
            else {
                $('#<%=txtPaidAmount.ClientID %>,#<%=ddlPaymentMode.ClientID%>,#<%=btnAdd.ClientID%>,#<%=ddlCountry.ClientID%>').attr("disabled", false);
            }
        }
        
        if ($("#lblIPDAdvanceRefund").length>0) {
            HospLedger();
        }
    });
    function paymentmode() {
        if ($("#<%=ddlPaymentMode.ClientID %>").val() == "1" || $("#<%=ddlPaymentMode.ClientID %>").val() == "4" || $("#<%=ddlPaymentMode.ClientID %>").val() == "5") {
            $("#<%=txtrefNo.ClientID %>").val('');
            $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>").hide();
            $('#<%=ddlBank.ClientID%> option:nth-child(1)').attr('selected', '0');
            $('#v1,#v2').hide();
        }
        else {
            $("#<%=txtrefNo.ClientID %>").val('');
            $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>").show();
            $('#<%=ddlBank.ClientID%> option:nth-child(1)').attr('selected', '0');
            $('#v1,#v2').show();
        }
    }
    function loadCountryFactor() {
        $.ajax({
            url: "../Common/CommonService.asmx/loadCountryFactor",
            data: '{CountryID:"' + $('#<%=ddlCountry.ClientID %>').val() + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var dtdata = jQuery.parseJSON(mydata.d);
                if (dtdata.length > 0) {
                    $('#<%=lblCurrencyNotation.ClientID %>').val(dtdata[0].Notation);
                    getCurrencyConditions();
                    getMinCurrency($('#<%=ddlCountry.ClientID %>').val());
                }
            }
        });
    }
    function precise_round(num, decimals) {
        return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
    }
    function getMinCurrency(CountryID) {
        if ('<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>' != CountryID) {
            $.ajax({
                url: "../Common/CommonService.asmx/MinCurrency",
                data: '{CountryID:"' + $('#<%=ddlCountry.ClientID %>').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var Curr = mydata.d;
                    if (Curr > "1") {
                        var RoundOff = 0; var NewAmount = 0;
                        var Amount = parseFloat($("#<%=lblCurrencyBase.ClientID %>").text().split(' ')[0]);
                        if (Amount != "0") {
                            if (Amount < 100) {

                                if (Amount > Curr) {
                                    RoundOff = precise_round((100 - Amount), 2);
                                    NewAmount = precise_round((Amount + RoundOff), 2);
                                    $("#txtCurrencyRoffAmt").val(RoundOff);
                                    $("#lblCurrencyRoffAmt").text(RoundOff);
                                    $("#<%=lblCurrencyBase.ClientID %>").text(NewAmount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                                    $("#<%=txtCurrencyBase.ClientID %>").val(NewAmount);
                                }
                                else {
                                    RoundOff = precise_round((Curr - Amount), 2);
                                    NewAmount = precise_round((Amount + RoundOff), 2);
                                    $("#txtCurrencyRoffAmt").val(RoundOff);
                                    $("#lblCurrencyRoffAmt").text(RoundOff);
                                    $("#<%=lblCurrencyBase.ClientID %>").text(NewAmount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                                    $("#<%=txtCurrencyBase.ClientID %>").val(NewAmount);
                                }
                            }
                            else if (Amount > 100) {
                                var Last2Digit = $("#<%=lblCurrencyBase.ClientID %>").text().split(' ')[0];
                                var length = Last2Digit.length;
                                Last2Digit = Last2Digit.substr(length - 2);
                                if ((Last2Digit) > Curr) {
                                    RoundOff = precise_round((100 - (Last2Digit)), 2);
                                    NewAmount = precise_round((Amount + RoundOff), 2);
                                    $("#txtCurrencyRoffAmt").val(RoundOff);
                                    $("#lblCurrencyRoffAmt").text(RoundOff);
                                    $("#<%=lblCurrencyBase.ClientID %>").text(NewAmount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                                    $("#<%=txtCurrencyBase.ClientID %>").val(NewAmount);

                                }
                                else if ((Last2Digit) > 0) {
                                    RoundOff = precise_round((Curr - (Last2Digit)), 2);
                                    NewAmount = precise_round((Amount + RoundOff), 2);
                                    $("#txtCurrencyRoffAmt").val(RoundOff);
                                    $("#lblCurrencyRoffAmt").text(RoundOff);
                                    $("#<%=txtCurrencyBase.ClientID %>").val(NewAmount);
                                    $("#<%=lblCurrencyBase.ClientID %>").text(NewAmount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());

                                }
                                else {
                                    $("#<%=txtCurrencyBase.ClientID %>").val(Amount);
                                    $("#<%=lblCurrencyBase.ClientID %>").text(Amount + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                                    $("#txtCurrencyRoffAmt").val(0);
                                    $("#lblCurrencyRoffAmt").text(0);
                                }
                            }
                            else {
                                $("#txtCurrencyRoffAmt").val(0);
                                $("#lblCurrencyRoffAmt").text(0);
                            }
                        }
                    }
                    else {
                        $("#txtCurrencyRoffAmt").val(0);
                        $("#lblCurrencyRoffAmt").text(0);
                    }
                }
            });
        }
        else {
            $("#txtCurrencyRoffAmt").val(0);
            $("#lblCurrencyRoffAmt").text(0);
        }
    }
    function getCurrencyConditions() {
        if ($('#<%=lblTotalPaidAmount.ClientID %>').text() == "0") {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#txtNetAmount').val());
        }
        else {
            getCurrencyBase($('#<%=ddlCountry.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text());
        }
    }
    function getCurrencyBase(CountryID, Amount) {
        $.ajax({
            url: "../Common/CommonService.asmx/getConvertCurrecncy",
            data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
            type: "POST",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                
               //  data = parseFloat(data) + parseFloat($("#txtCurrencyRoffAmt").val()); 
                $('#<%=lblCurrencyBase.ClientID %>').text(data + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
                $("#<%=txtCurrencyBase.ClientID %>").val(data);
               
            }
        });
    }
    function getCurrencyBaseRoundOff(CountryID, Amount) {
        $.ajax({
            url: "../Common/CommonService.asmx/getConvertCurrecncy",
            data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
            type: "POST",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
              //  getMinCurrency($('#<%=ddlCountry.ClientID %>').val());
                if ('<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>' != CountryID) {
                    data = parseFloat(data) + parseFloat($("#txtCurrencyRoffAmt").val());
                    
                }
                $('#<%=lblCurrencyBase.ClientID %>').text(data + ' ' + $('#<%=lblCurrencyNotation.ClientID %>').val());
              
                if (data == "0") {
                    $("#lblCurrencyRoffAmt").text('0');
                }              
                $("#<%=txtCurrencyBase.ClientID %>").val(data);
                if (data != "0") {
                    getMinCurrency($('#<%=ddlCountry.ClientID %>').val());
                }
                
            }

        
        });
    }
    function validate() {
        if (($("#<%=ddlPaymentMode.ClientID%> ").val() != "4") && ($.trim($("#<%=txtPaidAmount.ClientID%> ").val()) == "") || $("#<%=txtPaidAmount.ClientID%> ").val() == "0") {
            $('#<%=txtPaidAmount.ClientID %>').focus();
            alert('Please Enter Amount');
            return false;
        }
        if ($('#<%=ddlPaymentMode.ClientID %>').val() == "2" || $('#<%=ddlPaymentMode.ClientID %>').val() == "3") {
            if (($('#<%=ddlBank.ClientID %>').val() == "")) {
                alert('Please Select Bank');
                $("#<%=ddlBank.ClientID %>").focus();
                return false;
            }
            if (($('#<%=txtrefNo.ClientID %>').val() == "")) {
                alert('Please Enter Ref. No.');
                $("#<%=txtrefNo.ClientID %>").focus();
                return false;
            }
        }
        if ($("#<%=grdPaymentMode.ClientID %> tr").length > "0") {
            var con = 0;
            $("#<%=grdPaymentMode.ClientID %> tr").each(function () {
                if (!this.rowIndex)
                    return;
                var PaymentMode = $.trim($(this).find("td:eq(1)").text());
                var Currency = $.trim($(this).find("td:eq(3)").text());
                if ((Currency == ($.trim($("#<%=ddlCountry.ClientID %> option:selected").text()))) && (PaymentMode == ($.trim($("#<%=ddlPaymentMode.ClientID%> option:selected").text())))) {
                    con = 1;
                }
            });
            if (con == "1") {
                alert('Same Currency already added in same Payment Mode');
                return false;
            }
        }
        if ($("span[id*=lblOPDFinalSettlement]").length > 0) {
            var amount = parseFloat($.trim($("#<%=lblCurrencyBase.ClientID %>").text()).split(' '));
            var amount1 = parseFloat($.trim($('#<%=txtPaidAmount.ClientID %>').val()));
            if ((($("#<%=ddlPaymentMode.ClientID%> ").val() != "4")) && (amount < amount1)) {
                alert('Paid amount cannot greater than Balance amount');
                $('#<%=txtPaidAmount.ClientID %>').focus();
                return false;
            }         
        }
        else if ($("span[id*=lblIPDAdvance]").length > 0) {
            if ($('#txtNetAmount').is(':visible')) {
                var amount = parseFloat($("#<%=lblCurrencyBase.ClientID %>").text().split(' '));
                var amount1 = parseFloat($.trim($('#<%=txtPaidAmount.ClientID %>').val()));
                if ((($("#<%=ddlPaymentMode.ClientID%> ").val() != "4")) && (amount < amount1)) {
                    alert('Paid amount cannot greater than Balance amount');
                    $('#<%=txtPaidAmount.ClientID %>').focus();
                    return false;
                }
            }
        }
    }
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
    
</script>
<div>
    <div>
        <table cellpadding="0" cellspacing="0" style="width: 100%" runat="server" id="tblPayment">
            <tr>
                <td style="text-align: right;" >
                    <strong>
                      <asp:Label ID="lblNetBillAmt" runat="server" Text="Net&nbsp;Bill&nbsp;Amount&nbsp;:&nbsp;"></asp:Label></strong>
                </td>
                <td style="width: 35%; text-align: left;" >
                    <asp:TextBox ID="txtNetAmount" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"
                        Width="94px"></asp:TextBox>
                </td>
                <td style="width: 10%; text-align: right;">
                  
                    Amount :&nbsp;
                                  
                </td>
                <td style="width: 36%; text-align: left;">
                   
                    <asp:TextBox ID="txtPaidAmount" runat="server" Width="111px" MaxLength="9" onkeypress="return checkForSecondDecimal(this,event)"
                        CssClass="ItDoseTextinputNum" ToolTip="Enter Amount" ClientIDMode="Static" AutoCompleteType="Disabled"></asp:TextBox>
                   
                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" TargetControlID="txtPaidAmount"
                        runat="server" ValidChars=".0987654321">
                    </cc1:FilteredTextBoxExtender>
                   
                    <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                   
                </td>
            </tr>
            <tr style="display:none">
                <td style="width: 12%; text-align: right;">
                    Currency :&nbsp;
                </td>
                <td style="width: 35%; text-align: left;" >
                    <asp:DropDownList ID="ddlCountry" runat="server" Width="100px" ToolTip="Select Currency">
                    </asp:DropDownList>
                    <asp:TextBox ID="lblCurrencyNotation" runat="server" Style="display: none;"></asp:TextBox>
                    <asp:Label ID="lblCurrencyBase" runat="server" Style="color: Red; font-size: 10px;
                        font-family: Verdana;"></asp:Label>
                    <asp:TextBox ID="txtCurrencyBase" runat="server" Style="display: none;" Width="30px" ></asp:TextBox>
                    <asp:Label ID="lblCurrencyRoff" runat="server" Text="Currency Round Off" Style="display: none;"></asp:Label>
                     <asp:Label ID="lblCurrencyRoffAmt"  Style="color: Red;
                        font-size: 10px; font-family: Verdana; display:none" runat="server" Width="20px" ClientIDMode="Static" Text="0"></asp:Label>

                    <asp:TextBox ID="txtCurrencyRoffAmt" Style="display: none;"  runat="server" Width="20px" ClientIDMode="Static" Text="0"></asp:TextBox>
                </td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;</td>
                <td style="width: 36%; text-align: left;">
                   
                   
                    <asp:Label ID="lblBaseCurrency" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblBaseCurrencyID" runat="server" Visible="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 12%; text-align: right;">
                    Payment Mode :&nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <asp:DropDownList ID="ddlPaymentMode" runat="server" TabIndex="34" Width="100px"
                        onchange="paymentmode();" ToolTip="Select Payment Mode">
                    </asp:DropDownList>
                </td>
                <td style="width: 10%; text-align: right;">
                    <asp:Label ID="lblBank" runat="server" Text="Bank&nbsp;Name&nbsp;:&nbsp;"></asp:Label>
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:DropDownList ID="ddlBank" runat="server" ToolTip="Select Bank" Width="153px">
                    </asp:DropDownList>
                    <asp:Label ID="v1" runat="server" Style="font-size: 10px; display: none; font-family: Verdana;
                        color: Red;" ClientIDMode="Static" Text="*"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 12%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    &nbsp;
                </td>
                <td style="width: 11%; text-align: right;">
                    <asp:Label ID="lblCardNo" runat="server" Text="Card&nbsp;/&nbsp;Ref.&nbsp;No.&nbsp;:&nbsp;"></asp:Label>
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:TextBox ID="txtrefNo" runat="server" ToolTip="Enter Card / Ref. No." MaxLength="20"></asp:TextBox>
                    <asp:Label ID="v2" runat="server" ClientIDMode="Static" Style="font-size: 10px; display: none;
                        font-family: Verdana; color: Red;" Text="*"></asp:Label>
                    <cc1:FilteredTextBoxExtender ID="ftbtrefNo" runat="server" TargetControlID="txtrefNo"
                        FilterType="Numbers">
                    </cc1:FilteredTextBoxExtender>
                </td>
            </tr>
            <tr>
                <td style="width: 12%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <asp:Button ID="btnAdd" runat="server" Text="Add" ValidationGroup="add" OnClick="btnAdd_Click"
                        TabIndex="37" OnClientClick="return validate();" CssClass="ItDoseButton" ToolTip="Click To Add Amount" />
                </td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style1">
                </td>
                <td colspan="3">
                    <asp:GridView ID="grdPaymentMode" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                        TabIndex="21" OnRowCommand="grdPaymentMode_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Payment Mode">
                                <ItemTemplate>
                                    <asp:Label ID="lblPaymentMode" runat="server" Text='<%# Eval("PaymentMode")%>'></asp:Label>
                                    <asp:Label ID="lblPaymentModeID" Visible="false" runat="server" Text='<%# Eval("PaymentModeID")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Paid Amount">
                                <ItemTemplate>
                                    <asp:Label ID="lblAmount" runat="server" Text='<%# Eval("Amount")%>' Width="65px"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Currency">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblCountryID" runat="server" Text='<%#Eval("CountryID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCFactor" runat="server" Text='<%#Eval("CFactor") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblCurrency" runat="server" Text='<%#Eval("Currency") %>' Visible="true"></asp:Label>
                                    <asp:Label ID="lblNotation" runat="server" Text='<%#Eval("Notation") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bank Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblBankName" Text='<%#Eval("BankName") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Card/Ref. No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblRefNo" Text='<%#Eval("RefNo") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Base Currency" Visible="false">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblBaseCurrency" Text='<%#Eval("BaseCurrency") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="C Factor" Visible="false">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblConversionFactor" Text='<%#Eval("CFactor") %>' runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Base Currency" Visible="false">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblBaseCurrencyAmount" CssClass="ItDoseTextinputNum" Text='<%#Eval("BaseCurrencyAmount") %>'
                                        runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CRoundOff" Visible="false" >
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblCurrencyRoundOff" CssClass="ItDoseTextinputNum" Text='<%#Eval("CurrencyRoundOff") %>'
                                        runat="server"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                        CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="width: 12%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                </td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    <strong>
                        <asp:Label ID="lblTotalPaid" Text="Total Amount :" runat="server"></asp:Label></strong>
                    <asp:Label ID="lblTotalPaidAmount" Text="0" CssClass="ItDoseTextinputNum" runat="server"
                        Style="font-weight: 700"></asp:Label>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" class="style1">
                    &nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    &nbsp;
                </td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong><asp:Label ID="lblBalance"
                        Text="Balance :" runat="server"></asp:Label>
                        <asp:Label ID="lblBalanceAmount" Text="0" CssClass="ItDoseTextinputNum" runat="server"
                            Style="font-weight: 700"></asp:Label>
                        
                    </strong>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;" class="style1">
                    &nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    &nbsp;
                </td>
                <td style="width: 10%; text-align: right;">
                    &nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong><asp:Label ID="lblRound" Text="Round Off :"
                        runat="server"></asp:Label>
                        <asp:Label ID="lblRoundVal" Text="0" CssClass="ItDoseTextinputNum" runat="server"
                            Style="font-weight: 700;"></asp:Label>
                    </strong>
                </td>
            </tr>
        </table>
    </div>
    &nbsp;
</div>
<div runat="server" id="div_save" visible="false">
    &nbsp;&nbsp;<cc1:FilteredTextBoxExtender ID="validateDisAmount" TargetControlID="txtDisAmount"
        runat="server" FilterType="Numbers">
    </cc1:FilteredTextBoxExtender>
    <cc1:FilteredTextBoxExtender ID="validateDisPercent" TargetControlID="txtDisPercent"
        runat="server" FilterType="Custom,Numbers" ValidChars="%">
    </cc1:FilteredTextBoxExtender>
</div>
