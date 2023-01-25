<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wuc_PaymentDetailsJSON.ascx.cs" Inherits="Design_Controls_wuc_PaymentDetailsJSON" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%--<script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
<script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>--%>

<script type="text/javascript">
    if ($.browser.msie) {
        $(document).on("keydown", function (e) {
            var doPrevent;
            if (e.keyCode == 8) {
                var d = e.srcElement || e.target;
                if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                }
                else
                    doPrevent = true;
            }
            else
                doPrevent = false;
            if (doPrevent)
                e.preventDefault();
        });
    }
</script>

<script type="text/javascript">
    $(function () {
        $('#<%=txtPaidAmount.ClientID %>').bind("keyup", function () {
            if ((($('#<%= txtPaidAmount.ClientID %>').val()) > "0") ) 
                $('#btnAdd').attr("disabled", false);

            else 
                $('#btnAdd').attr("disabled", true);

            if ((eval($('#<%=txtPaidAmount.ClientID %>').val())) > (eval($('#<%=txtCurrencyBase.ClientID %>').val()))) {
                alert('Paid amount cannot greater than Balance amount');
                $("#<%=txtPaidAmount.ClientID%>").val($("#<%=txtPaidAmount.ClientID%>").val().substring(0, ($("#<%=txtPaidAmount.ClientID%>").val().length - 1)))

                $('#<%=txtPaidAmount.ClientID %>').focus();
                return;
            }
        });       
        $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>,.a").hide();
        if (($('#txtDisAmount').val() > 0) || ($('#txtDisPercent').val() > 0))
            $(".a").show();
        if ($("#spnBookDirectAppointment").length > 0) {
            bindPanelDirectApp();
            bindPaymentMode();

        }
        else if (($("span[id*=lblPanelID]").length > 0) || ($("span[id*=lblPanelIDOPDPayment]").length > 0))
            bindPaymentMode();
        else if ($("select[id*=ddlPanelCompany]").length > 0) {
            bindPanel();
            bindPaymentMode();
        }
        else if (($("span[id*=OPDRegSettlement]").length > 0) || ($("span[id*=lblOPDPharmacyEditBill]").length>0)) {
            //bindPaymentMode();
        }
        else
            bindPanel();
        //  bindPaymentMode();

        if ((($("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisAmount').val() > 0)) || (($("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisPercent').val() > 0))) {
            $(".imbRemove").hide();
            $("select[id*=ddlcategory],select[id*=ddlSubcategory]").prop('selectedIndex', 0).attr("disabled", true);
            $("input[id*=btnSelect],input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").attr("disabled", true);
        }
        else {
            $(".imbRemove").show();
            $("input[id*=btnSelect],input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").attr("disabled", false);
        }
        $('#<%=ddlCurrency.ClientID %>').change(function () {
            loadCountryFactor();
        });
        if (('<%=GetGlobalResourceObject("Resource", "TaxRequired") %>') == "0")
            $(".trGovTax,#<%=txtGovTaxAmt.ClientID%>").hide();
         else
            $(".trGovTax,#<%=txtGovTaxAmt.ClientID%>").show();
        $('#txtDisAmount').keyup(function () {
            $('#txtDisPercent').val('');
        });
        if ($.trim($("#txtBillAmount").val()) > 0) {
            $('#txtDisAmount, #txtDisPercent,#<%=txtPaidAmount.ClientID %>').removeAttr('disabled');
            // Hide on 15-07-2017
            //$('#btnAdd').attr('disabled', 'disabled');
        }
        else
            $('#txtDisAmount, #txtDisPercent,#<%=txtPaidAmount.ClientID %>,#btnAdd').attr('disabled', 'disabled');
    });  
    function precise_round(num, decimals) {
        return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
    }
    
</script>
<div>
    <div>
        <table style="width: 100%;border-collapse:collapse" runat="server" id="tblPayment">
            <tr>
                <td style="text-align: right; width:14%">
                    <strong>Bill&nbsp;Amount :&nbsp;</strong>
                </td>
                <td style="width: 36%; text-align: left;vertical-align:top" >
                    <asp:TextBox ID="txtBillAmount" ClientIDMode="Static" runat="server" Style="font-weight: 700"
                        CssClass="ItDoseTextinputNum" Text="0" Width="75px"></asp:TextBox>
                    <strong>&nbsp;</strong></td>
                <td style="width: 15%; text-align: right;">&nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <asp:Label ID="lblGovTaxPercentage" Style="display: none" Text="0" runat="server"></asp:Label>
                </td>
            </tr>
            <tr id="trDiscRow" runat="server" >
                <td style="text-align: right; width:14%">Disc. Amount :&nbsp;
                   
                </td>
                <td style="width: 36%; text-align: left">
                    <asp:TextBox ID="txtDisAmount" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum"
                        Width="75px" TabIndex="28" onkeyup="visibleDisAmount();" AutoCompleteType="Disabled"
                        ToolTip="Enter Discount Amount" onkeypress="return checkForSecondDecimal(this,event)"
                        MaxLength="10" />
                    <cc1:FilteredTextBoxExtender ID="fc1" runat="server" TargetControlID="txtDisAmount"
                        ValidChars=".0987654321">
                    </cc1:FilteredTextBoxExtender>
                    <span style="font-size: 10pt; font-family: Arial" id="paymentPer">&nbsp; &nbsp; Per. :&nbsp;
                        <asp:TextBox ID="txtDisPercent" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"
                            Width="75px" TabIndex="29" onkeyup="visibleDisPercent();" ToolTip="Enter Discount Percent"
                            AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"
                            MaxLength="10" />
                        <cc1:FilteredTextBoxExtender ID="fc2" runat="server" TargetControlID="txtDisPercent"
                            FilterMode="ValidChars" ValidChars="." FilterType="Numbers,Custom">
                        </cc1:FilteredTextBoxExtender>
                    </span>
                </td>
                <td style="width: 15%;text-align:right" class="a">&nbsp;
                </td>
                <td style="width: 35%; text-align:left"  class="a">&nbsp;
                </td>
            </tr>
            <tr id="trDiscReason" runat="server" class="a">
                <td style="text-align: right; width:14%">Disc. Reason :&nbsp;
                    
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:TextBox ID="txtDiscReason" runat="server"  TabIndex="55" ToolTip="Enter Disc. Reason"
                        Width="218px" MaxLength="50" AutoCompleteType="Disabled" ClientIDMode="Static" />
                    <asp:Label ID="v4" runat="server" Style="font-size: 10px; font-family: Verdana; color: Red;"
                        ClientIDMode="Static" Text="*" class="shat"></asp:Label>
                </td>
                <td style="width: 15%; text-align: right;">Approved By :&nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <asp:DropDownList ID="ddlApproveBy" ToolTip="Select Approved By" runat="server" Width="151px" TabIndex="57" ClientIDMode="Static" />
                    <asp:Label ID="v3" runat="server" Style="font-size: 10px; font-family: Verdana; color: Red;"
                        ClientIDMode="Static" Text="*" class="shat"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right; width:14%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Net&nbsp;Bill&nbsp;Amount&nbsp;:&nbsp;</strong>
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:TextBox ID="txtNetAmount" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"
                        Width="75px"></asp:TextBox>
                    <strong>Total&nbsp;Paid&nbsp;Amount&nbsp;:&nbsp;</strong>
                    <asp:TextBox ID="txtTotalPaidAmount" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"
                        Width="80px"></asp:TextBox>
                </td>
                <td style="width: 15%; text-align: right;">Amount :&nbsp;
                </td>
                <td style="width: 35%; text-align: left;"> <asp:TextBox ID="txtPaidAmount" ClientIDMode="Static" runat="server" AutoCompleteType="Disabled" Width="80px"
                        TabIndex="33" MaxLength="10" CssClass="ItDoseTextinputNum" ToolTip="Enter Paid Amount"
                        onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="fc3" runat="server" TargetControlID="txtPaidAmount"
                        FilterMode="ValidChars" FilterType="Numbers">
                    </cc1:FilteredTextBoxExtender>
                </td>
            </tr>
            <tr  style="display:none"  >
                <td style="text-align: right; width:14%;display:none" class="trGovTax">
                    <strong>
                        <asp:Label ID="lblGovTaxPer" runat="server" ></asp:Label></strong></td>
                <td style="width: 36%; text-align: left;" colspan="2">
                    <asp:TextBox ID="txtGovTaxAmt"  runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" Width="75px"></asp:TextBox>
                    
                </td>
                <td style="width: 15%; text-align: right;"></td>
                <td style="width: 35%; text-align: left;">&nbsp;</td>
            </tr>
            <tr style="display:none">
                <td style="text-align: right; width:14%;">Currency :&nbsp;
                </td>
                <td style="text-align: left; vertical-align:top"  >
                    <asp:DropDownList ID="ddlCurrency" runat="server" Width="100px" TabIndex="58">
                    </asp:DropDownList>
                    <asp:TextBox ID="txtCurrencyNotation" runat="server" Style="display: none;"></asp:TextBox>
                    <asp:Label ID="lblCurrencyBase" runat="server" ClientIDMode="Static" Style="color: Red; font-size: 10px; font-family: Verdana;"></asp:Label>
                    <asp:TextBox ID="txtCurrencyBase" runat="server" Width="30px" Style="display: none;"></asp:TextBox>
                </td>
                <td style="text-align: right;" >
                </td>
                <td style="text-align: left;" >
                   
                    <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;" class="shat">*</asp:Label>
                    <asp:Label ID="lblBaseCurrency" runat="server" Style="display: none"></asp:Label>
                    <asp:Label ID="lblBaseCurrencyID" runat="server" Style="display: none"></asp:Label>
                   

                </td>
            </tr>
            <tr id="trPaymentMode" runat="server">
                <td style="text-align: right; width:14%">Payment Mode :&nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    <asp:DropDownList ID="ddlPaymentMode" runat="server" TabIndex="59" Width="100px"
                        onchange="paymentmode();">
                    </asp:DropDownList>
                </td>
                <td style="width: 15%; text-align: right;">
                    <asp:Label ID="lblBank" runat="server">Bank&nbsp;Name&nbsp;:&nbsp;</asp:Label>
                </td>
                <td style="width: 35%; text-align: left;">
                    <asp:DropDownList ID="ddlBank" runat="server" Width="151px" TabIndex="60">
                    </asp:DropDownList>
                    <asp:Label ID="v1" runat="server" Style="font-size: 10px; display: none; font-family: Verdana; color: Red;"
                        ClientIDMode="Static" Text="*"></asp:Label>
                </td>
            </tr>
            <tr id="trPaymentModeCon" runat="server">
                <td style="text-align: right; width:14%">&nbsp;
                </td>
                <td style="width: 36%; text-align: left;">&nbsp;
                </td>
                <td style="width: 15%; text-align: right;">
                    <asp:Label ID="lblCardNo" runat="server">Card&nbsp;/&nbsp;Ref.&nbsp;No.&nbsp;:&nbsp;</asp:Label>
                </td>
                <td style="width: 35%; text-align: left;">
                    <asp:TextBox ID="txtrefNo" runat="server" TabIndex="36" AutoCompleteType="Disabled" MaxLength="61" Width="145px"></asp:TextBox>&nbsp;<asp:Label
                        ID="v2" runat="server" ClientIDMode="Static" Style="font-size: 10px; display: none; font-family: Verdana; color: Red;"
                        Text="*"></asp:Label>
                    <cc1:FilteredTextBoxExtender ID="ftbtrefNo" runat="server" TargetControlID="txtrefNo"
                        FilterType="Numbers">
                    </cc1:FilteredTextBoxExtender>
                </td>
            </tr>
            <tr id="trAddAmount" runat="server">
                <td style="text-align: right; width:14%">&nbsp;
                </td>
                <td style="width: 36%; text-align: left;">
                    <input type="button" id="btnAdd" class="ItDoseButton" value="Add" onclick="AddAmount()" />

                </td>
                <td style="width: 15%; text-align: right;">&nbsp;
                </td>
                <td style="width: 35%">&nbsp;
                </td>
            </tr>
        </table>
        <table style="width: 100%;border-collapse:collapse" border="0" runat="server" id="tblPaymentDetail">
            <tr>
                <td style="width: 15%;">&nbsp;</td>
                <td colspan="3" style="width:85%">
                    <table class="GridViewStyle" border="1" id="grdPaymentMode"
                        style="width: 100%; border-collapse: collapse; display: none;">
                        <tr id="Header">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px;display: none">S.No.
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px; display: none"></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 84px;">Payment Mode
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 74px;">Paid Amount
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px; display: none"></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 56px;">Currency
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Bank Name
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Ref No.
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 70px;display:none">Base Currency
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 50px;display:none">C.Factor
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 70px;display:none">Base Currency
                            </th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px; display: none"></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px;"></th>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="text-align: right; width:14%">&nbsp;</td>
                <td style="width: 36%; text-align: left;">&nbsp;</td>
                <td style="width: 15%; text-align: right;">&nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <strong>Total Amount Paid</strong>&nbsp;:
                    <asp:Label ID="lblTotalPaidAmount" Text="0" CssClass="ItDoseTextinputNum" runat="server"
                        Style="font-weight: 700" ClientIDMode="Static"></asp:Label>

                </td>
            </tr>
            <tr>
                <td style="text-align: right;width:14%">
                    Remarks :&nbsp; 
                </td>
                <td style="width: 36%; text-align: left;">

                    <asp:TextBox ID="txtRemarks" runat="server"  TabIndex="63"
                        Width="370px" MaxLength="50" ToolTip="Enter Remarks" ClientIDMode="Static"></asp:TextBox>
                </td>
                <td style="width: 15%; text-align: right;">&nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <strong>Balance :
                        <asp:Label ID="lblBalanceAmount" Text="0" CssClass="ItDoseTextinputNum" runat="server"
                            Style="font-weight: 700" ClientIDMode="Static"></asp:Label>

                    </strong>
                </td>
            </tr>
            <tr>
                <td style="text-align: right;width:14%">&nbsp;
                </td>
                <td style="width: 36%; text-align: left;">&nbsp;
                </td>
                <td style="width: 15%; text-align: right;">&nbsp;
                </td>
                <td style="width: 35%; text-align: left;">
                    <strong>Round Off :
                        <asp:Label ID="lblRoundVal" Text="0" CssClass="ItDoseTextinputNum" runat="server"
                            Style="font-weight: 700;" ClientIDMode="Static"></asp:Label>

                    </strong>
                </td>
            </tr>
        </table>
    </div>

</div>
<div runat="server" id="div_save" visible="false">
    <cc1:FilteredTextBoxExtender ID="validateDisPercent" TargetControlID="txtDisPercent"
        runat="server" FilterType="Custom,Numbers" ValidChars="%">
    </cc1:FilteredTextBoxExtender>

</div>

<script type="text/javascript">

    function bindPaymentMode() {
        var PanelID, type;
        if (jQuery("#spnBookDirectAppointment").length > 0) {
            PanelID = jQuery("select[id*=ddlPanelBookDirectApp]").val().split('#')[0];
            type = jQuery("select[id*=ddlPanelBookDirectApp]").val();
        }
        else if ($("select[id*=ddlPanelCompany]").length > 0) {
            PanelID = jQuery("select[id*=ddlPanelCompany]").val().split('#')[0];
            type = jQuery("select[id*=ddlPanelCompany]").val();
            
            if(jQuery("select[id*=ddlPanelCompany]").val().split('#')[2]=="1")
                jQuery('#<%=tblPayment.ClientID%>,#<%=tblPaymentDetail.ClientID%>,#paymentUserControl').hide();
            else
                jQuery('#<%=tblPayment.ClientID%>,#<%=tblPaymentDetail.ClientID%>,#paymentUserControl').show();
        }
        else if (jQuery("select[id*=ddlCardTypeReg]").length > 0) {
            PanelID = jQuery("select[id*=ddlCardTypeReg]").val().split('#')[1];
            type = jQuery("select[id*=ddlCardTypeReg]").val();
        }
        else if ($("span[id*=lblPanelIDOPDPayment]").length > 0) {
            PanelID = jQuery("span[id*=lblPanelIDOPDPayment]").text();
            type = jQuery("span[id*=lblPanelIDOPDPayment]").text();
        }
        else if (jQuery("span[id*=OPDRegSettlement]").length > 0) {
            PanelID = jQuery("span[id*=spnRegPanelID]").text();
            type = "1";
        }       
        if (type != "0") {
            jQuery("#<%=ddlPaymentMode.ClientID%> option").remove();           
            jQuery.ajax({
                type: "POST",
                url: "../Common/CommonService.asmx/BindPaymentModePanelWise",
                data: '{ PanelID: "' + PanelID + '"}',
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async:false,
                dataType: "json",
                success: function (result) {
                    paymentModeBind = jQuery.parseJSON(result.d);
                    
                    if (paymentModeBind != null) {
                        jQuery("#<%=ddlPaymentMode.ClientID%> option").remove();
                        for (i = 0; i < paymentModeBind.length; i++) {
                            jQuery("#<%=ddlPaymentMode.ClientID%>").append($("<option></option>").val(paymentModeBind[i].PaymentModeID).html(paymentModeBind[i].PaymentMode));
                        }
                    }
                    var items = jQuery("#<%=ddlPaymentMode.ClientID%> option");
                   
                    jQuery("#<%= ddlPaymentMode.ClientID %>").each(function () {
                        jQuery('option', this).each(function () {
                            if (items.length == "1") {
                                if ((jQuery(this).val() == "2") || ($(this).val() == "3"))
                                    paymentmode();
                                else if ((jQuery(this).val() == "4")) {
                                    jQuery("#<%=txtPaidAmount.ClientID %>,#txtDisAmount,#txtDisPercent").attr('disabled', 'disabled');         
                                    paymentmode();
                                }
                            }
                        });
                    });
                    if ((jQuery("#<%=ddlPaymentMode.ClientID%>").val() == "2") || (jQuery("#<%=ddlPaymentMode.ClientID%>").val() == "3")) {
                        paymentmode();
                    }
                    else if (jQuery("#<%=ddlPaymentMode.ClientID%>").val() == "4") {
                        paymentmode();
                    }
                },
                error: function (xhr, status) {

                }
            });

        }
        else {
            jQuery("#<%=ddlPaymentMode.ClientID%> option").remove().attr('disabled', 'disabled');
        }
        
    }

    function bookDirectApp() {
        jQuery("#ddlAppointmentType,#ddlDoctorList,#ddlPanelBookDirectApp").attr('disabled', 'disabled');
    }
    </script>

<script type="text/javascript">
    function savePaymentDetail() {
        var dataReceipt = new Array();
        var obj = new Object();
        if ((jQuery("#grdPaymentMode tr").length == "1") && (jQuery('select[id*=ddlPaymentMode]').val() == "1")) {
            jQuery.ajax({
                url: "../Common/CommonService.asmx/Cash",
                data: '{ }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                cache: false,
                success: function (result) {
                    CashData = jQuery.parseJSON(result.d);
                    if (CashData != null) {
                        obj.PaymentMode = "Cash";
                        obj.PaymentModeID = "1";
                        obj.S_Amount = "0";
                        obj.S_Currency = CashData[0]["S_Currency"];
                        obj.S_CountryID = CashData[0]["S_CountryID"];
                        obj.BankName = "";
                        obj.RefNo = "";
                        obj.BaceCurrency = CashData[0]["B_Currency"];
                        obj.C_Factor = CashData[0]["Selling_Specific"];
                        obj.Amount = "0";
                        obj.S_Notation = CashData[0]["S_Notation"];
                        obj.PaymentRemarks = jQuery("#<%=txtRemarks.ClientID%>").val();
                        dataReceipt.push(obj);
                    }
                },
                error: function (xhr, status) {
                    dataReceipt.push('');
                    return false;
                }
            });
        }
        else if ((jQuery("#grdPaymentMode tr").length == "1") && (jQuery('select[id*=ddlPaymentMode]').val() == "4")) {
            $.ajax({
                url: "../Common/CommonService.asmx/Credit",
                data: '{ }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                cache: false,
                success: function (result) {
                    CreditData = jQuery.parseJSON(result.d);
                    if (CreditData != null) {
                        obj.PaymentMode = "Credit";
                        obj.PaymentModeID = "4";
                        obj.S_Amount = $("#txtTotalPaidAmount").val();
                        obj.S_Currency = CreditData[0]["S_Currency"];
                        obj.S_CountryID = CreditData[0]["S_CountryID"];
                        obj.BankName = "";
                        obj.RefNo = "";
                        obj.BaceCurrency = CreditData[0]["B_Currency"];
                        obj.C_Factor = CreditData[0]["Selling_Specific"];
                        obj.Amount = $("#txtTotalPaidAmount").val();
                        obj.S_Notation = CreditData[0]["S_Notation"];
                        obj.PaymentRemarks = jQuery("#<%=txtRemarks.ClientID%>").val();
                        dataReceipt.push(obj);
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    dataReceipt.push('');
                    return false;
                }
            });
        }
        else {
            jQuery("#grdPaymentMode tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "Header") {
                    obj.PaymentMode = jQuery(this).find("#tdPaymentMode").html();
                    obj.PaymentModeID = jQuery(this).find("#tdPaymentModeID").html();
                    obj.S_Amount = jQuery(this).find("#tdPaidAmount").html();
                    obj.S_Currency = jQuery(this).find("#tdCurrency").html();
                    obj.S_CountryID = jQuery(this).find("#tdCountryID").html();
                    obj.BankName = jQuery(this).find("#tdBank").html();
                    obj.RefNo = jQuery(this).find("#tdRefNo").html();
                    obj.BaceCurrency = jQuery(this).find("#tdBaseCurrency").html();
                    obj.C_Factor = jQuery(this).find("#tdCFactor").html();
                    obj.Amount = jQuery(this).find("#tdBaseCurrencyAmount").html();
                    obj.S_Notation = jQuery(this).find("#tdNotation").html();
                    obj.PaymentRemarks = jQuery("#<%=txtRemarks.ClientID%>").val();
                    dataReceipt.push(obj);
                    obj = new Object();
                }
            });
        }
        return dataReceipt;
    }
</script>
<script type="text/javascript">
    function updateTotalAmount(totalAmount, NetAmount, totalDiscount, totalDiscountPer, count) {
        jQuery('#<%= txtDisAmount.ClientID %>').val(precise_round(totalDiscount, 2)).attr('disabled', 'disabled');
        jQuery('#<%= txtGovTaxAmt.ClientID%>').val(0);
        jQuery('#<%=txtDisPercent.ClientID %>').val(totalDiscountPer).attr('disabled', 'disabled');
        var CoPaymentType = 0;
        visibleDisAmount();
        DiscountAmountCalculate(totalAmount, NetAmount, totalDiscount);
        if (((totalAmount == "0") || ($('#<%= ddlPaymentMode.ClientID %>').val() == "4")))
            jQuery('#btnAdd,#<%= txtPaidAmount.ClientID %>,#<%= txtDisAmount.ClientID %>,#<%= txtDisPercent.ClientID %>').attr('disabled', 'disabled');
        else
            jQuery('#<%= txtPaidAmount.ClientID %>').removeAttr('disabled');
        jQuery('#<%=txtBillAmount.ClientID %>').val(precise_round(totalAmount, 2));
        if (totalDiscountPer > 0)
            NetAmount = parseFloat(parseFloat(NetAmount) - (parseFloat(NetAmount * totalDiscountPer) / 100));
        jQuery('#<%=txtNetAmount.ClientID %>').val(precise_round(NetAmount, 2));
        jQuery('#<%=ddlCurrency.ClientID %>').val('<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>');
        jQuery('#<%= lblBalanceAmount.ClientID %>').text(precise_round((totalAmount), 2));

        jQuery('#<%= txtTotalPaidAmount.ClientID%>').val(precise_round(((parseFloat($('#<%=txtNetAmount.ClientID %>').val())) + (parseFloat(jQuery('#<%= txtGovTaxAmt.ClientID%>').val()))), 2));
        var TotalPaidAmt = parseFloat($('#<%= txtTotalPaidAmount.ClientID%>').val());
        if (('<%=GetGlobalResourceObject("Resource", "IsRoundOff") %>') == "1")
            $('#<%= txtTotalPaidAmount.ClientID%>').val(Math.round($('#<%= txtTotalPaidAmount.ClientID%>').val()));
        else
            $('#<%= txtTotalPaidAmount.ClientID%>').val(precise_round(($('#<%= txtTotalPaidAmount.ClientID%>').val()), 0));
        jQuery('#<%=txtPaidAmount.ClientID%>').val($('#<%= txtTotalPaidAmount.ClientID%>').val());
        jQuery('#<%= lblBalanceAmount.ClientID%>').text(precise_round(($('#<%= txtTotalPaidAmount.ClientID%>').val()), 2));
        jQuery('#lblCurrencyBase').text($('#<%= txtTotalPaidAmount.ClientID%>').val() + " " + '<%=GetGlobalResourceObject("Resource", "BaseCurrencyNotation") %>');
        jQuery('#<%=txtCurrencyNotation.ClientID%>').val('<%=GetGlobalResourceObject("Resource", "BaseCurrencyNotation") %>');
        jQuery('#<%= lblRoundVal.ClientID%>').text(precise_round((parseFloat($('#<%= txtTotalPaidAmount.ClientID%>').val())) - (parseFloat((TotalPaidAmt))), 2));
        jQuery('#<%= txtCurrencyBase.ClientID%>').val($('#<%= txtTotalPaidAmount.ClientID%>').val());
        if ((($('#<%= txtBillAmount.ClientID %>').val() >= "0") && ($('#<%= ddlPaymentMode.ClientID %>').val() == "4")) )
            $('#btnAdd,#<%= txtPaidAmount.ClientID %>,#<%= txtDisAmount.ClientID %>,#<%= txtDisPercent.ClientID %>').attr('disabled', 'disabled');
        else
            $('#btnAdd,#<%= txtPaidAmount.ClientID %>').removeAttr('disabled');

    }
    function DiscountAmountCalculate(TotalBillAmt, NetAmount, DisAmt) {
        jQuery('#txtNetAmount').val(NetAmount);
        jQuery('#txtTotalPaidAmount').val(precise_round((parseFloat($('#txtNetAmount').val()) + (parseFloat($("#<%=txtGovTaxAmt.ClientID%>").val()))), 0));
        var TotalPaidAmt = parseFloat($('#txtTotalPaidAmount').val());
        if (('<%=GetGlobalResourceObject("Resource", "IsRoundOff") %>') == "1")
            $('#txtTotalPaidAmount').val(Math.round($('#txtTotalPaidAmount').val()));
        else
            $('#<%= txtTotalPaidAmount.ClientID%>').val(precise_round(($('#<%= txtTotalPaidAmount.ClientID%>').val()), 0));
        jQuery('#<%=lblBalanceAmount.ClientID %>').text(precise_round(($('#txtTotalPaidAmount').val()), 2));
        jQuery('#<%=lblRoundVal.ClientID %>').text(precise_round((parseFloat($('#txtTotalPaidAmount').val())) - (parseFloat((TotalPaidAmt))), 2));
        if (jQuery('#<%=txtNetAmount.ClientID %>').val() == "0") {
            jQuery("#<%=txtPaidAmount.ClientID %>").attr("disabled", true);
            jQuery('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
            jQuery("#<%=ddlPaymentMode.ClientID%> option[value='1']").attr("disabled", false);
            jQuery("#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3'],#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
            paymentmode();
        }
        else {
            if ((jQuery("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisAmount').val() > 0)) {
                jQuery("input[id*=btnSelect]").attr("disabled", true);
                jQuery(".imbRemove").hide();
                jQuery("select[id*=ddlCategory],select[id*=ddlSubcategory]").prop('selectedIndex', 0).attr("disabled", true);
                jQuery("input[id*=txtSearch],input[id*=txtCPTCode]").val('').attr("disabled", true);
            }
            else {
                jQuery(".imbRemove").show();
                jQuery("input[id*=btnSelect],input[id*=txtSearch],input[id*=txtCPTCode],select[id*=ddlCategory],select[id*=ddlSubcategory]").attr("disabled", false);
            }
            jQuery("#<%=txtPaidAmount.ClientID %>").attr("disabled", false);
            jQuery('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
            jQuery("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3'],#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
            if ((parseFloat($("#txtDisAmount").val()) > "0") || (parseFloat($("#txtDisPercent").val()) > "0")) {
                jQuery("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                jQuery("#txtDiscReason").val('Hospital Discount').attr('disabled', 'disabled');
                jQuery("#ddlApproveBy").prop('selectedIndex', 1).attr('disabled', 'disabled');
                jQuery("#txtDisPercent,#txtDisAmount").attr('disabled', 'disabled');
            }
            else {

            }
        }
        getCurrencyConditions();
    }
    </script>
<script type="text/javascript">
    function changeBaseAmt(paidAmt) {
        if (paidAmt > $('#txtTotalPaidAmount').val()) {
            getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), $('#txtTotalPaidAmount').val() - $('#<%=lblTotalPaidAmount.ClientID %>').text());
        }
        else if ($('#<%=lblTotalPaidAmount.ClientID %>').text() == "0") {
            getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), $('#txtTotalPaidAmount').val() - paidAmt);
            $('#<%=lblBalanceAmount.ClientID %>').text($('#txtTotalPaidAmount').val() - paidAmt);
        }
        else if ($('#<%=lblBalanceAmount.ClientID %>').text() == "0") {
            getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text());
        }
        else {
            getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text() - paidAmt);
        }
}
</script>
<script type="text/javascript">
    function ShowCon() {
       
        if ($("#grdPaymentMode tr").length > "1") {
            $("#<%=txtDisAmount.ClientID%>,#<%=txtDisPercent.ClientID%>,#<%=ddlApproveBy.ClientID%>,#<%=txtDiscReason.ClientID%>").attr('disabled', 'disabled');
            if (($("span[id*=lblCardRegistration]").length == "1")) {
                $("input[id*=btnNewCity],select[id*=ddlCardTypeReg]").attr('disabled', 'disabled');
                $("input[id*=btnSaveReg]").attr('disabled', false);
            }
            else if ($("select[id*=ddlPackage]").length > 0)
                $("select[id*=ddlPackage]").attr('disabled', 'disabled');
            else if ($("#spnBookDirectAppointment").length > 0)
                $("#ddlAppointmentType,#ddlDoctorList,#ddlPanelBookDirectApp,#txtBarcode,#OldPatient").attr('disabled', 'disabled');
            else if ($("#spnPharmacyIssue").length > 0) {
                $("#rdoHospitalPatient,#rdoGeneral,#rdoIPD,.classPharmacy").attr('disabled', 'disabled');
                $("#<%=txtDisAmount.ClientID%>,#<%=txtDisPercent.ClientID%>,#<%=ddlApproveBy.ClientID%>,#<%=txtDiscReason.ClientID%>").attr('disabled', 'disabled');
                $(".pharmacyRemove").hide();
            }
            else if ($("#OPDRegSettlement").length > 0) {
                $("#btnSearchOPDSettlenent,.clPaymentOption").attr('disabled', 'disabled');
                $(".paymentSelect").hide();
            }
            if (($("select[id*=ddlPanelCompany]").length > 0) && ($("select[id*=ddlPanelCompany]").is(':visible')))
                $("select[id*=ddlPanelCompany],#txtBarcode").attr('disabled', 'disabled');

        }
        else {
            if ($("#spnLabPrescription").length > 0) {
                if ($(".DiscClass").length > 0)
                    $("#<%=txtDisAmount.ClientID%>,#<%=txtDisPercent.ClientID%>,#<%=ddlApproveBy.ClientID%>,#<%=txtDiscReason.ClientID%>").attr('disabled', 'disabled');
                else
                    $("#<%=txtDisAmount.ClientID%>,#<%=txtDisPercent.ClientID%>,#<%=ddlApproveBy.ClientID%>,#<%=txtDiscReason.ClientID%>").attr('disabled', false);

            }
            else
            $("#<%=txtDisAmount.ClientID%>,#<%=txtDisPercent.ClientID%>,#<%=ddlApproveBy.ClientID%>,#<%=txtDiscReason.ClientID%>").attr('disabled', false);
            $('select[id*=ddlBank]').val(0).hide();
            $('span[id*=lblBank],span[id*=lblCardNo],span[id*=v1],span[id*=v2],span[id*=v3],span[id*=v4]').hide();
            $('input[id*=txtrefNo]').val('').hide();

            $('#<%=ddlCurrency.ClientID %>').val('<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>')
            $('select[id*=ddlPaymentMode]').val(1);
            if (($("span[id*=lblCardRegistration]").length == "1")) {
                $("input[id*=btnNewCity],select[id*=ddlCardTypeReg]").attr('disabled', false);
                $("input[id*=btnSaveReg]").attr('disabled', true);
            }
            else if ($("select[id*=ddlPackage]").length > 0)
                $("select[id*=ddlPackage],#txtBarcode").attr('disabled', false);
            else if ($("#spnLabPrescription").length > 0) {
                $("#btnAddInv,#tbSelected").attr('disabled', false);
                //$('#tbSelected tr').each(function () {
                //    var id = $(this).closest("tr").attr("id");
                //    if (id != "Header") {
                //        $(this).closest('tr').find("#imgRemove,#txtRate,#txtAmount,#txtQuantity,#txtDiscPer").attr('disabled', false);

                //    }

                //});
               
                jQuery("#tbSelected").find("input,img").attr('disabled', false);
            }
            else if ($("#spnBookDirectAppointment").length > 0)
                $("#ddlAppointmentType,#ddlDoctorList,#ddlPanelBookDirectApp,#txtBarcode,#OldPatient").removeAttr('disabled');
            else if ($("#spnPharmacyIssue").length > 0) {
                $("#rdoHospitalPatient,#rdoGeneral,#rdoIPD,.classPharmacy").removeAttr('disabled');
                $(".pharmacyRemove").show();
                var count = 0;
                jQuery("#tb_grdIssueItem tr").each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "IssueItemHeader") {
                        count += parseFloat(jQuery(this).closest("tr").find("#tdisItemWiseDisc").html());
                    }
                });
                if (count > 0) {
                    $("#<%=txtDisAmount.ClientID%>,#<%=txtDisPercent.ClientID%>,#<%=ddlApproveBy.ClientID%>,#<%=txtDiscReason.ClientID%>").attr('disabled', 'disabled');
                    jQuery('.itemWiseDisc').show();
                }
                else {
                    $("#<%=txtDisAmount.ClientID%>,#<%=txtDisPercent.ClientID%>,#<%=ddlApproveBy.ClientID%>,#<%=txtDiscReason.ClientID%>").removeAttr('disabled');
                    jQuery('.itemWiseDisc').hide();
                }

            }
            else if ($("#OPDRegSettlement").length > 0) {
                $("#btnSearchOPDSettlenent,.clPaymentOption").removeAttr('disabled');
                $(".paymentSelect").show();
            }
        }
        if (($("#OPDRegSettlement").length > 0) && ($("#chkRefund").is(':checked'))) {
            $("#<%=txtDisAmount.ClientID%>,#<%=txtDisPercent.ClientID%>,#<%=ddlApproveBy.ClientID%>,#<%=txtDiscReason.ClientID%>,#<%=ddlPaymentMode.ClientID%>,#<%=ddlCurrency.ClientID%>").attr('disabled', true);
        }

    }
</script>
<script type="text/javascript">
    function AddAmount() {
        var zeroRateCon = "Yes";              
        if ($("#spnLabPrescription").length > 0) {
            if (jQuery('.zeroRateColor').length > 0) {
                zeroRateCon = confirm(jQuery('.zeroRateColor').length + " Items Having Rate Zero. Do You Want To Add ?")
            }
        }
        if (zeroRateCon) {
            $('#btnAdd').attr('disabled', true).val("Submitting...");

            $('span[id*=lblMsg]').text('');
            if (parseFloat($('#<%=txtPaidAmount.ClientID %>').val()) <= "0") {
                alert('Please Add Valid Paid amount');
                $('#btnAdd').attr('disabled', false).val("Add");
                return false;
            }
            if ((parseFloat($('#<%=txtPaidAmount.ClientID %>').val())) > (parseFloat($('#<%=txtCurrencyBase.ClientID %>').val()))) {
                alert('Paid amount cannot greater than Balance amount');
                $('#btnAdd').attr('disabled', false).val("Add");
                return false;
            }
            if ($('#<%=ddlPaymentMode.ClientID %>').val() == "2" || $('#<%=ddlPaymentMode.ClientID %>').val() == "3") {
                if (($.trim($('#<%=ddlBank.ClientID %>').val()) == "")) {
                    alert('Please Select Bank');
                    $('#<%=ddlBank.ClientID %>').focus();
                    $('#btnAdd').attr('disabled', false).val("Add");
                    return false;
                }
                if (($.trim($('#<%=txtrefNo.ClientID %>').val()) == "")) {
                    alert('Please Enter Ref No.');
                    $('#<%=txtrefNo.ClientID %>').focus();
                    $('#btnAdd').attr('disabled', false).val("Add");
                    return false;
                }
            }
            if ($("#OPDRegSettlement").length > 0) {
                if (($('#<%=ddlPaymentMode.ClientID %>').val() == "5") && (parseFloat($('#<%=txtPaidAmount.ClientID %>').val()) > parseFloat($("#spnAdvanceAmt").text()))) {
                    alert('Please Enter Valid Paid Amount');
                    $('#<%=txtPaidAmount.ClientID %>').focus();
                    $('#btnAdd').attr('disabled', false).val("Add");
                    return false;
                }
            }
            //if (($("#spnPharmacyIssue").length == "0") && ($("#OPDRegSettlement").length == "0")) {
            if ($("#grdPaymentMode tr").length > "0") {
                var con = 0;
                $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
                $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                $("#grdPaymentMode tr").each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        var PaymentMode = $.trim($(this).find("#tdPaymentMode").html());
                        var Country = $.trim($(this).find("#tdCurrency").html());
                        if (PaymentMode == "Credit") {
                            $('#<%=txtPaidAmount.ClientID %>').attr("disabled", true);
                            $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 4);
                        }
                        if ((Country == ($.trim($("#<%=ddlCurrency.ClientID %> option:selected").text()))) && (PaymentMode == ($.trim($("#<%=ddlPaymentMode.ClientID%> option:selected").text())))) {
                            con = 1;
                        }
                    }
                });
                if (con == "1") {
                    alert('Same Currency already added in same Payment Mode');
                    $('#btnAdd').attr('disabled', false).val("Add");
                    return false;
                }
            }
            // }
            if ($("#spnOPDPackage").length > 0) {
                var Doccon = 0;
                $("#PackageDocSearch").find(".packageDoctor").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "DocHeader") {
                        var DocSno = $rowid.find("#tdDocSno").text();
                        if (($rowid.find('#ddlPackageDoctor' + DocSno).is(':visible')) && ($rowid.find('#ddlPackageDoctor' + DocSno + ' option:selected').text() == "Select")) {
                            $('span[id*=spnErrorMsg]').html('Please Select Package Doctor Name');
                            $rowid.find('#ddlPackageDoctor' + DocSno).focus();
                            Doccon = 1;
                            return false;
                        }
                    }
                });
                if (Doccon == "1") {
                    $('span[id*=spnErrorMsg]').html('Please Select Package Doctor Name');
                    $('#btnAdd').attr('disabled', false).val("Add");
                    return false;
                }
            }
            if ($.trim($('#<%=txtDisAmount.ClientID%>').val()) > "0" || $.trim($('#<%=txtDisPercent.ClientID%>').val()) > "0") {
                if (($('#<%=ddlApproveBy.ClientID %>').val() == "0")) {
                    $('#<%=ddlApproveBy.ClientID %>').focus();
                    alert('Please Select Approved By');
                    $('#btnAdd').attr('disabled', false).val("Add");
                    return false;
                }
                if ($.trim($('#<%=txtDiscReason.ClientID %>').val()) == "") {
                    $('#<%=txtDiscReason.ClientID %>').focus();
                    alert('Please Enter Disc. Reason');
                    $('#btnAdd').attr('disabled', false).val("Add");
                    return false;
                }
            }
            if (($("#<%=ddlPaymentMode.ClientID%> ").val() != "4") && ($("#<%=txtPaidAmount.ClientID%> ").val() <= "0")) {
                $('#<%=txtPaidAmount.ClientID %>').focus();
                alert('Please Enter Amount');
                $('#btnAdd').attr('disabled', false).val("Add");
                return false;
            }
            var RowCount;
            RowCount = $("#grdPaymentMode tr").length;
            RowCount = RowCount + 1;
            var BaseCurrencyAmount = $('#<%=txtPaidAmount.ClientID%>').val();
            // $.ajax({
            //     url: "../Common/CommonService.asmx/ConvertCurrency",
            //     data: '{countryID:"' + $('#<%=ddlCurrency.ClientID %>').val() + '",Amount:"' + $('#<%=txtPaidAmount.ClientID%>').val() + '"}',
            //     type: "POST",
            //     async: false,
            //     dataType: "json",
            //     contentType: "application/json; charset=utf-8",
            //     success: function (mydata) {
            //         var data = mydata.d;
            //         BaseCurrencyAmount = data;
            //         $('#lblCurrencyBase').text(data + ' ' + $('#<%=txtCurrencyNotation.ClientID %>').val());
            //     }
            //  });
            var CFactor = "1";
            // $.ajax({
            //     url: "../Common/CommonService.asmx/GetConversionFactor",
            //     data: '{countryID:"' + $('#<%=ddlCurrency.ClientID %>').val() + '"}',
            //     type: "POST",
            //      async: false,
            //      dataType: "json",
            //     contentType: "application/json; charset=utf-8",
            //     success: function (mydata) {
            //         var data = mydata.d;
            //         CFactor = data;
            //      }
            //  });
            //if ($("#grdPaymentMode tr").length > 1) {
            //    $("#grdPaymentMode tr:not(#Header)").remove();
            //}
            if (BaseCurrencyAmount != "" && CFactor != "") {
                var newRow = $('<tr />').attr('id', 'tr_' + RowCount);

                newRow.html('<td class="GridViewLabItemStyle" style="text-align:center;display: none">' + (RowCount - 1) +
                   '</td><td id="tdPaymentMode" class="GridViewLabItemStyle" style="text-align:center">' + $("#<%=ddlPaymentMode.ClientID%> option:selected").text() +
                   '</td><td id="tdPaymentModeID" class="GridViewLabItemStyle" style="text-align:center; display:none">' + $("#<%=ddlPaymentMode.ClientID%> ").val() +
                   '</td><td  id="tdPaidAmount"class="GridViewLabItemStyle" style="text-align:center">' + $("#<%=txtPaidAmount.ClientID%>").val() +
                   '</td><td id="tdCountryID" class="GridViewLabItemStyle" style="text-align:center;display:none">' + $("#<%=ddlCurrency.ClientID%>").val() +
                   '</td><td id="tdCurrency" class="GridViewLabItemStyle" style="text-align:center">' + $("#<%=ddlCurrency.ClientID%> option:selected").text() +
                   '</td><td id="tdBank" class="GridViewLabItemStyle"  style="text-align:center">' + $("#<%=ddlBank.ClientID%> option:selected").text() +
                   '</td><td id="tdRefNo" class="GridViewLabItemStyle" style="text-align:center" >' + $("#<%=txtrefNo.ClientID%>").val() +
                   '</td><td id="tdBaseCurrency" class="GridViewLabItemStyle" style="text-align:center;display:none" >' + $("#<%=lblBaseCurrency.ClientID%>").text() +
                   '</td><td id="tdCFactor" class="GridViewLabItemStyle" style="text-align:center;display:none" >' + CFactor +
                   '</td><td  id="tdBaseCurrencyAmount" class="GridViewLabItemStyle" style="text-align:center;display:none" >' + BaseCurrencyAmount +
                   '</td><td  id="tdNotation" class="GridViewLabItemStyle" style="text-align:center;display:none" >' + $("#<%=txtCurrencyNotation.ClientID%>").val() +
                   '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Remove"/></td>'
                    );
                $("#grdPaymentMode").append(newRow);
                $("#grdPaymentMode").show();

                ShowCon();
                var amt = 0;
                $("#grdPaymentMode tr").each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        amt += eval($(this).closest("tr").find("#tdBaseCurrencyAmount").html());
                    }
                });
                $('#btnAdd').attr('disabled', false).val("Add");
                $("#<%=lblTotalPaidAmount.ClientID%>").text((amt));
                $("#<%=lblBalanceAmount.ClientID%>").text(eval($("#<%=txtTotalPaidAmount.ClientID%>").val()) - eval(amt));
                $("#<%=txtPaidAmount.ClientID%> ").val('');

                if ($("select[id*=ddlPackage]").length > 0)
                    $("select[id*=ddlPackage]").attr('disabled', true);
                else if ($("#spnLabPrescription").length > 0) {
                    $("#btnAddInv,select[id*=ddlPanelCompany],#txtBarcode,#tbSelected").attr('disabled', true);
                    //$('#tbSelected tr').each(function () {
                    //    var id = $(this).closest("tr").attr("id");
                    //    if (id != "Header") {
                    //        $(this).closest('tr').find("#imgRemove,#txtRate,#txtAmount,#txtQuantity,#txtDiscPer").attr('disabled', true);
                    //    }
                    //});
                    jQuery("#tbSelected").find("input,img").attr("disabled", true);
                }
                else if ($("#spnbookdirectappointment").length > 0)
                    $("#ddlappointmenttype,#ddldoctorlist,#ddlpanelbookdirectapp,#txtBarcode,#OldPatient").attr('disabled', 'disabled');

                else if ($("#spnPharmacyIssue").length > 0) {
                    $("#rdoHospitalPatient,#rdoGeneral,#rdoIPD,.classPharmacy").attr('disabled', 'disabled');
                    $(".pharmacyRemove").hide();
                }

                if (($("select[id*=ddlPanelCompany]").length > 0) && ($("select[id*=ddlPanelCompany]").is(':visible')) && ($("#spnPharmacyIssue").length == "0"))
                    $("select[id*=ddlPanelCompany],#txtBarcode").attr('disabled', true);
                changeBaseAmt($("#<%=txtPaidAmount.ClientID%> ").val());
                $("#btnAdd").attr('disabled', 'disabled');
            }
        }
    }
</script>
<script type="text/javascript">

    function DeleteRow(rowid) {
        var row = rowid;
        var amt = 0;
        var prePaidAmt = $(row).closest('tr').find("#tdPaidAmount").html();
        $("#<%=txtPaidAmount.ClientID%>").val('');


        $(row).closest('tr').remove();
        $("#grdPaymentMode tr").each(function () {
            var id = $(this).closest("tr").attr("id");
            if (id != "Header") {
                amt += eval($(this).closest("tr").find("#tdBaseCurrencyAmount").html());
            }
        });
        $("#<%=lblTotalPaidAmount.ClientID%>").text((amt));
        $("#<%=lblBalanceAmount.ClientID%>").text(eval($("#<%=txtTotalPaidAmount.ClientID%>").val()) - eval(amt));
        changeBaseAmt($("#<%=txtPaidAmount.ClientID%> ").val());

        if ($("#grdPaymentMode tr").length == "1") {
            $("#grdPaymentMode").hide();
            ShowCon();
            if ($("#<%=ddlPaymentMode.ClientID%> option[value=4]").is(':disabled'))
                $("#<%=ddlPaymentMode.ClientID%> option[value=4]").removeAttr('disabled');

            changeBaseAmt($("#<%=txtPaidAmount.ClientID%> ").val());
        }
        //if (($("#txtDisAmount").val() > 0) || ($("#txtDisPercent").val() > 0)) {
        //    $("#btnAddInv").attr('disabled', 'disabled');
        //    //$('#tbSelected tr').each(function () {
        //    //    var id = $(this).closest("tr").attr("id");
        //    //    if (id != "Header") {
        //    //        $(this).closest('tr').find("#imgRemove,#txtRate,#txtAmount,#txtQuantity,#txtDiscPer").attr('disabled', 'disabled');
        //    //    }
        //    //});
        //    jQuery("#tbSelected").find("input,img").attr('disabled', 'disabled');
        //}
        //else {
        //    $("#btnAddInv").removeAttr('disabled');
        //    //$('#tbSelected tr').each(function () {
        //    //    var id = $(this).closest("tr").attr("id");
        //    //    if (id != "Header") {
        //    //        $(this).closest('tr').find("#imgRemove,#txtRate,#txtAmount,#txtQuantity,#txtDiscPer").removeAttr('disabled');
        //    //    }
        //    //});
        //    jQuery("#tbSelected").find("input,img").removeAttr('disabled');
        //}
        $("#<%=txtPaidAmount.ClientID%>").val(prePaidAmt);
        $('#btnAdd').removeAttr('disabled');
    }

    function chngcur() {
        document.body.style.cursor = 'pointer';
    }
</script>
<script type="text/javascript">
    function paymentmode() {
        if (($("#<%=ddlPaymentMode.ClientID %>").val() == "1") || ($("#<%=ddlPaymentMode.ClientID %>").val() == "5")) {
            jQuery("#<%=txtrefNo.ClientID %>").val('');
            jQuery("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>,#v1,#v2").hide();
            jQuery('#<%=ddlBank.ClientID%> option:nth-child(1)').attr('selected', '0');
            if (jQuery('#<%=txtNetAmount.ClientID %>').val() != "0")
                jQuery("#<%=txtPaidAmount.ClientID %>,#btnAdd,#txtDisAmount,#txtDisPercent").attr("disabled", false);
            else
                jQuery("#<%=txtPaidAmount.ClientID %>,#btnAdd,#txtDisAmount,#txtDisPercent").attr("disabled", true);
            jQuery("#<%=Label10.ClientID %>").show();
        }
        else if ($("#<%=ddlPaymentMode.ClientID %>").val() == "4") {
            $("#<%=txtrefNo.ClientID %>,#<%=txtPaidAmount.ClientID %>").val('');
            $("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>,#v1,#v2,#<%=Label10.ClientID %>").hide();
            $('#<%=ddlBank.ClientID%> option:nth-child(1)').attr('selected', '0');
            $("#<%=txtPaidAmount.ClientID %>,#btnAdd,#txtDisAmount,#txtDisPercent").attr("disabled", true);
        }
        else {
            jQuery("#<%=txtrefNo.ClientID %>").val('');
            jQuery("#<%=ddlBank.ClientID %>,#<%=txtrefNo.ClientID %>,#<%=lblCardNo.ClientID %>,#<%=lblBank.ClientID %>").show();
            jQuery('#<%=ddlBank.ClientID%> option:nth-child(1)').attr('selected', '0');
            if (jQuery('#<%=txtNetAmount.ClientID %>').val() != "0")
                jQuery("#<%=txtPaidAmount.ClientID %>,#btnAdd,#txtDisAmount,#txtDisPercent").attr("disabled", false);
            else
                jQuery("#<%=txtPaidAmount.ClientID %>,#btnAdd,#txtDisAmount,#txtDisPercent").attr("disabled", true);
            jQuery("#<%=Label10.ClientID %>,#v1,#v2").show();
        }
}
function visibleDisAmount() {
    sum();
    if (jQuery('#txtDisAmount').val() != "")
        jQuery('#txtDisPercent').removeAttr('tabindex');
    else
        jQuery('#txtDisPercent').attr('tabindex', 29);
    ValidateDecimalAmt();
    var DisAmount = jQuery('#<%=txtDisAmount.ClientID %>').val();
    var DisPercent = jQuery('#<%=txtDisPercent.ClientID %>').val();

        if (($("#<%=txtDisAmount.ClientID %>").val() <= "0") && ($("#<%=txtDisPercent.ClientID %>").val() <= "0")) {
            jQuery("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,.a,#v3,#v4").hide();
            jQuery("#<%=ddlApproveBy.ClientID %> option:nth-child(1)").attr('selected', '0');
            jQuery("#<%=txtDiscReason.ClientID%>").val('');
            jQuery("#btnAddInv").removeAttr('disabled');
            //jQuery('#tbSelected tr').each(function () {
            //    var id = $(this).closest("tr").attr("id");
            //    if (id != "Header")
            //        $(this).closest('tr').find("#imgRemove,#txtRate,#txtAmount,#txtQuantity,#txtDiscPer").removeAttr('disabled');
            //});   
            jQuery("#tbSelected").find("input,img").removeAttr('disabled');
        }
        else {
            $("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,.a,#v3,#v4").show();
            $("#<%=ddlApproveBy.ClientID %>").attr('selectedIndex', 0);
            $("#<%=txtDiscReason.ClientID%>").removeAttr('disabled');
            $("#btnAddInv").attr('disabled', 'disabled');
            //$('#tbSelected tr').each(function () {
            //    var id = $(this).closest("tr").attr("id");
            //    if (id != "Header")
            //        $(this).closest('tr').find("#imgRemove,#txtRate,#txtAmount,#txtQuantity,#txtDiscPer").attr('disabled', 'disabled');
            //});

            jQuery("#tbSelected").find("input,img").attr('disabled', 'disabled');
        }
    }
    function visibleDisPercent() {
        amt();
        if ($('#txtDisPercent').val() != "")
            $('#txtDisPercent').attr('tabindex', 29);
        ValidateDecimal();
        var DisAmount = $('#<%=txtDisAmount.ClientID %>').val();
        var DisPercent = $('#<%=txtDisPercent.ClientID %>').val();

        if (($("#<%=txtDisAmount.ClientID %>").val() <= "0") && ($("#<%=txtDisPercent.ClientID %>").val() <= "0")) {
            $("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,.a").hide();
            $("#<%=ddlApproveBy.ClientID %> option:nth-child(1)").attr('selected', '0');
            $("#<%=txtDiscReason.ClientID%>").val('');
            $("#btnAddInv").removeAttr('disabled');
            //$('#tbSelected tr').each(function () {
            //    var id = $(this).closest("tr").attr("id");
            //    if (id != "Header")
            //        $(this).closest('tr').find("#imgRemove,#txtRate,#txtAmount,#txtQuantity,#txtDiscPer").removeAttr('disabled');
            //});
            jQuery("#tbSelected").find("input,img").removeAttr('disabled');
            //if ($("#spnBookDirectAppointment").length > 0)
            //    $("#ddlAppointmentType,#ddlDoctorList,#ddlPanelBookDirectApp").removeAttr('disabled');
        }
        else {
            $("#<%=ddlApproveBy.ClientID %>,#<%=txtDiscReason.ClientID%>,.a").show();
            $("#<%=ddlApproveBy.ClientID %>").attr('selectedIndex', 0);
            $("#btnAddInv").attr('disabled', 'disabled');
            //$('#tbSelected tr').each(function () {
            //    var id = $(this).closest("tr").attr("id");
            //    if (id != "Header")
            //        $(this).closest('tr').find("#imgRemove,#txtRate,#txtAmount,#txtQuantity,#txtDiscPer").attr('disabled', 'disabled');
            //});

            jQuery("#tbSelected").find("input,img").attr('disabled', 'disabled');
        }
    }
</script>
<script type="text/javascript">
    function ValidateDecimalAmt() {
        var DigitsAfterDecimal = 2;
        var val = $("#<%=txtDisAmount.ClientID%>").val();
    var valIndex = val.indexOf(".");
    if (valIndex > "0") {
        if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
            alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
            $("#<%=txtDisAmount.ClientID%>").val($("#<%=txtDisAmount.ClientID%>").val().substring(0, ($("#<%=txtDisAmount.ClientID%>").val().length - 1)))
                return false;
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
    function validatedot() {
        if ((($("#<%=txtPaidAmount.ClientID%>").val().charAt(0) == ".")) || ($("#<%=txtPaidAmount.ClientID%>").val().charAt(0) == "0")) {
            $("#<%=txtPaidAmount.ClientID%>").val('');
            return false;
        }


    }
</script>
<script type="text/javascript">
    function loadCountryFactor() {
        $.ajax({
            url: "../Common/CommonService.asmx/loadCountryFactor",
            data: '{CountryID:"' + $('#<%=ddlCurrency.ClientID %>').val() + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var dtdata = jQuery.parseJSON(mydata.d);
                if (dtdata.length > 0) {
                    $('#<%=txtCurrencyNotation.ClientID %>').val(dtdata[0].Notation);
                    getCurrencyConditions();
                }
            }
        });
    }
    function getCurrencyConditions() {
        if ($('#<%=lblTotalPaidAmount.ClientID %>').text() == "0")
            getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), $('#txtTotalPaidAmount').val());
        else
            getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), $('#<%=lblBalanceAmount.ClientID %>').text());
    }
    function getCurrencyBase(CountryID, Amount) {
        //$.ajax({
        //    url: "../Common/CommonService.asmx/getConvertCurrecncy",
        //    data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
        //    type: "POST",
        //    async: false,
        //    dataType: "json",
        //    contentType: "application/json; charset=utf-8",
        //    success: function (mydata) {
        //        var data = mydata.d;
        $('#lblCurrencyBase').text(Amount + ' ' + $('#<%=txtCurrencyNotation.ClientID %>').val());
        $("#<%=txtCurrencyBase.ClientID %>").val(Amount);
        //shatrughan 08.04.2014

        if ($.trim($("#<%=txtCurrencyBase.ClientID%>").val()) == "0") {
            $("#<%=txtPaidAmount.ClientID%>").attr('disabled', true).val('');
                    $("#btnAdd").attr('disabled', true);
                    $("#btnSaveReg").attr('disabled', false);
                    if ($("#grdPaymentMode tr").length > "1") {
                        $("#<%=ddlPaymentMode.ClientID%>,#<%=ddlCurrency.ClientID%>").attr('disabled', true);
                        $("#btnSaveReg").attr('disabled', false);
                    }
                }
                else {
                    $("#<%=txtPaidAmount.ClientID%>,#<%=ddlPaymentMode.ClientID%>,#<%=ddlCurrency.ClientID%>").attr('disabled', false);
                    $("#btnSaveReg").attr('disabled', true);
                }
        //   }
        // });
            }
            function ValidateDecimal() {
                var DigitsAfterDecimal = 2;
                var val = $("#<%=txtDisPercent.ClientID%>").val();
        var valIndex = val.indexOf(".");
        if (valIndex > "0") {
            if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                alert("Please Enter Valid Discount Percent, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                $("#<%=txtDisPercent.ClientID%>").val($("#<%=txtDisPercent.ClientID%>").val().substring(0, ($("#<%=txtDisPercent.ClientID%>").val().length - 1)))
                return false;
            }
        }
    }
</script>
<script type="text/javascript">
    function amt() {
        $('#txtDisPercent').bind("blur keyup keydown", function () {
            if ($(this).val().charAt(0) == ".") {
                $(this).val('0.');
                $(".a").hide();
                return false;
            }
            $('#txtDisAmount,#<%=txtPaidAmount.ClientID%>').val('');
            var TotalBillAmt = Number($('#txtBillAmount').val());
            var DisPer = Number($('#txtDisPercent').val());
            if (DisPer > 100) {
                $('#txtDisPercent').val('');
                $('#txtNetAmount').val(TotalBillAmt);
                $(".a").hide();
                return;
            }
            if ($("#txtBillAmount").val() == "0.00") {
                $('#txtDisPercent').val('');
                $('#txtNetAmount').val(TotalBillAmt);
                $(".a").hide();
                return;
            }
            $('#txtNetAmount').val((TotalBillAmt - ((TotalBillAmt * DisPer) / 100)));
            var netamount = precise_round($('#txtNetAmount').val(), 2);
            $('#txtNetAmount').val(netamount);
            var GovTaxPer = $("#<%=lblGovTaxPercentage.ClientID%>").text();

            if (($("span[id*=lblCardRegistration]").length == "1") || ($("span[id*=lblAppGetPayment]").length == "1"))
                $("#<%=txtGovTaxAmt.ClientID%>").val(0);
            else
                $("#<%=txtGovTaxAmt.ClientID%>").val(precise_round(((($('#txtNetAmount').val()) * parseFloat(GovTaxPer)) / 100), 2));
            //  $('#<%=lblBalanceAmount.ClientID %>').text((TotalBillAmt - ((TotalBillAmt * DisPer) / 100))+ parseFloat($("#<%=txtGovTaxAmt.ClientID%>").val()));
            // var BalanceAmount = precise_round($('#<%=lblBalanceAmount.ClientID %>').text(), 2);
            // $('#<%=lblBalanceAmount.ClientID %>').text(math.round(BalanceAmount));
            $('#txtTotalPaidAmount').val(precise_round(((parseFloat($('#txtNetAmount').val())) + (parseFloat($("#<%=txtGovTaxAmt.ClientID%>").val()))), 2));

            var TotalPaidAmt = parseFloat($('#txtTotalPaidAmount').val());
            $('#txtTotalPaidAmount,#txtPaidAmount').val(Math.round($('#txtTotalPaidAmount').val()));
            $('#<%=lblBalanceAmount.ClientID %>').text($('#txtTotalPaidAmount').val());

            $('#<%=lblRoundVal.ClientID %>').text(precise_round((parseFloat($('#txtTotalPaidAmount').val())) - (parseFloat((TotalPaidAmt))), 2));

            if ($('#<%=txtNetAmount.ClientID %>').val() == "0") {
                $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlPaymentMode.ClientID%> option[value='1']").attr("disabled", false);
                $("#<%=txtPaidAmount.ClientID %>,#btnAdd,#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='2']#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
            }
            else {
                if (($("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisPercent').val() > 0)) {
                    $("input[id*=btnSelect]").attr("disabled", true);
                    $(".imbRemove").hide();
                    $("select[id*=ddlcategory],select[id*=ddlSubcategory]").prop('selectedIndex', 0).attr("disabled", true);
                    $("input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").val('').attr("disabled", true);
                }
                else {
                    $("input[id*=btnSelect]").attr("disabled", false);
                    $(".imbRemove").show();
                    $("select[id*=ddlcategory],select[id*=ddlSubcategory],input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").attr("disabled", false);
                }
                $("#<%=txtPaidAmount.ClientID %>").attr("disabled", false);
                $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3'],#btnAdd").attr("disabled", false);
                if ($("select[id*=ddlPanelCompany]").val() != null) {
                    if ($("select[id*=ddlPanelCompany]").val() == "1#1")
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    else
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                else if ($("select[id*=ddlPanel]").val() != null) {
                    if ($("select[id*=ddlPanel]").val() == "1")
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    else
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                else if ($("span[id*=lblPanelID]").text() != null) {
                    if ($("span[id*=lblPanelID]").text() == "1")
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    else
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                else {
                    $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                //if ($("#spnBookDirectAppointment").length>0)
                //    $("#ddlAppointmentType,#ddlDoctorList,#ddlPanelBookDirectApp").prop('disabled', 'disabled');
    }
            getCurrencyConditions();
        });
}
    function sum() {
        $('#txtDisAmount').bind("blur keyup keydown", function () {
            if (($(this).val().charAt(0) == ".")) {
                $(this).val('0.');
                $(".a").hide();
                return false;
            }
            $('#txtDisPercent,#<%=txtPaidAmount.ClientID%>').val('');
            var TotalBillAmt = $('#txtBillAmount').val();
            var DisAmt = Number($('#txtDisAmount').val());
            //  var CurrencyBase = Number($('#lblCurrencyBase').val());
            if (DisAmt > TotalBillAmt) {
                $('#txtDisAmount').val('');
                $('#txtNetAmount').val(TotalBillAmt);
                $(".a").hide();
                return;
            }
            var GovTaxPer = $("#<%=lblGovTaxPercentage.ClientID%>").text();

            $('#txtNetAmount').val(precise_round((Number(TotalBillAmt) - DisAmt), 2));
            if (($("span[id*=lblCardRegistration]").length == "1") || ($("span[id*=lblAppGetPayment]").length == "1")) {
                $("#<%=txtGovTaxAmt.ClientID%>").val(0);
            }
            else {
                $("#<%=txtGovTaxAmt.ClientID%>").val(precise_round((((parseFloat($('#txtNetAmount').val()) * (parseFloat(GovTaxPer))) / 100)), 2));
            }
            //   $('#<%=lblBalanceAmount.ClientID %>').text(Number(TotalBillAmt) - DisAmt);
            $('#txtTotalPaidAmount').val(precise_round((parseFloat($('#txtNetAmount').val()) + (parseFloat($("#<%=txtGovTaxAmt.ClientID%>").val()))), 2));

            var TotalPaidAmt = parseFloat($('#txtTotalPaidAmount').val());
            $('#txtTotalPaidAmount,#txtPaidAmount').val(Math.round($('#txtTotalPaidAmount').val()));
            $('#<%=lblBalanceAmount.ClientID %>').text($('#txtTotalPaidAmount').val());
            $('#<%=lblRoundVal.ClientID %>').text(precise_round((parseFloat($('#txtTotalPaidAmount').val())) - (parseFloat((TotalPaidAmt))), 2));

            if ($('#<%=txtNetAmount.ClientID %>').val() == "0") {
                $("#<%=txtPaidAmount.ClientID %>").attr("disabled", true);
                $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlPaymentMode.ClientID%> option[value='1']").attr("disabled", false);
                $("#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3'],#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                // paymentmode();
            }
            else {
                if (($("span[id*=lblOPDLabPrescription]").length > 0) && ($('#txtDisAmount').val() > 0)) {
                    $("input[id*=btnSelect]").attr("disabled", true);
                    $(".imbRemove").hide();
                    $("select[id*=ddlcategory],select[id*=ddlSubcategory]").prop('selectedIndex', 0).attr("disabled", true);
                    $("input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode]").val('').attr("disabled", true);
                }
                else {
                    $(".imbRemove").show();
                    $("input[id*=btnSelect],input[id*=txtsearchword],input[id*=txtSearch],input[id*=txtCPTCode],select[id*=ddlcategory],select[id*=ddlSubcategory]").attr("disabled", false);
                }
                $("#<%=txtPaidAmount.ClientID %>").attr("disabled", false);
                $('#<%=ddlPaymentMode.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlPaymentMode.ClientID%> option[value='1'],#<%=ddlPaymentMode.ClientID%> option[value='2'],#<%=ddlPaymentMode.ClientID%> option[value='3']").attr("disabled", false);
                if ($("select[id*=ddlPanelCompany]").val() != null) {
                    if ($("select[id*=ddlPanelCompany]").val() == "1#1")
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    else
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                else if ($("select[id*=ddlPanel]").val() != null) {
                    if ($("select[id*=ddlPanel]").val() == "1")
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    else
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                else if ($("span[id*=lblPanelID]").text() != null) {
                    if ($("span[id*=lblPanelID]").text() == "1")
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", true);
                    else
                        $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                else {
                    $("#<%=ddlPaymentMode.ClientID%> option[value='4']").attr("disabled", false);
                }
                //if ($("#spnBookDirectAppointment").length > 0)
                //    $("#ddlAppointmentType,#ddlDoctorList,#ddlPanelBookDirectApp").prop('disabled', 'disabled');
            }
            getCurrencyConditions();
        });

    }



</script>
