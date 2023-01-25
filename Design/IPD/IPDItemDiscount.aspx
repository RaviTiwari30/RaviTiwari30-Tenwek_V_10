<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPDItemDiscount.aspx.cs"
    Inherits="Design_IPD_IPDItemDiscount" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>

    <script type="text/javascript">
       
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnFinalDiscount', '');
        }
        function confirm_Bill(btn) {
            if (!($("#<%=rdbBillType.ClientID%> input[type=radio]").is(":checked"))) {
                $("#<%=lblMsg.ClientID%>").text('Please Select Billing Type');
                $("#<%=rdbBillType.ClientID%>").focus();
                return false;
            }
            modelConfirmation('Bill Generate', 'Are you sure you want to Generate Bill ??', 'YES', 'NO', function (response) {
                if (response) {
                    btn.disabled = true;
                    __doPostBack('btnGenerateBill', '');
                    return true;
                }
            });
            return false
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

</head>
<body>
     <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function CurrencyChange() {
            getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), $("#<%=txtNetBillAmt.ClientID %>").val());
        };

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
                    $bindBillCurrencyDetails(CountryID);
                }
            });
        }

        var $bindBillCurrencyDetails = function (CountryID) {

            serverCall('IPDItemDiscount.aspx/BindCurrencyDetails', { countryID: CountryID }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);

                    $("#lblBillCurrency").text(responseData[0].S_Currency);
                    $("#lblBillCountryId").text(responseData[0].S_CountryID);
                    $("#lblBillNotation").text(responseData[0].S_Notation);
                    $("#lblBillConFactor").text(responseData[0].Selling_Specific);

                    $("#txtBillCurrency").val(responseData[0].S_Currency);
                    $("#txtBillCountryId").val(responseData[0].S_CountryID);
                    $("#txtBillNotation").val(responseData[0].S_Notation);
                    $("#txtBillConFactor").val(responseData[0].Selling_Specific);
                }
            });
        }

        $(document).ready(function () {
            var MaxLength = 200;
            $("#<% =txtNarration.ClientID%>,#<% =txtDisReason.ClientID%>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });


            $("#lblremaingCharacters").html(MaxLength - ($("#<%=txtDisReason.ClientID %>").val().length));
            $("#<%=txtDisReason.ClientID %>").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > MaxLength) {
                    $(this).val($(this).val().substr(0, MaxLength));
                }
                var characterRemaining = MaxLength - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });
            $("#lblremaingCharacters1").html(MaxLength - ($("#<%=txtNarration.ClientID %>").val().length));
            $("#<%=txtNarration.ClientID %>").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > MaxLength) {
                    $(this).val($(this).val().substr(0, MaxLength));
                }
                var characterRemaining = MaxLength - characterInserted;
                $("#lblremaingCharacters1").html(characterRemaining);
            });

            $('#<%=txtNarration.ClientID%>,#<% =txtDisReason.ClientID%>').bind("keypress", function (e) {
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
        });
        $(document).ready(function () {
            var DisAmount = $('#txtDisAmount').val();
            var DisPercent = $('#txtDisPercent').val();
            $('#txtDisAmount').bind("keyup keydown", function () {
                if ($('#txtDisAmount').val() > 0) {
                    $('#txtDisPercent').val('');
                }
                if ((parseFloat($('#txtDisAmount').val())) > ($("#<%=lblAmount.ClientID %>").text())) {
                    modelAlert("Discount Amount Can Not Greater then Net Amount");
                    $('#txtDisAmount').val(DisAmount);
                    return false;
                }


            });
            $('#txtDisPercent').bind("keyup keydown", function () {
                if ($('#txtDisPercent').val() > 0) {
                    $('#txtDisAmount').val('');
                }
                if ($('#txtDisPercent').val() > 100) {
                    modelAlert("Please Enter Valid Discount Percent");
                    $('#txtDisPercent').val(DisPercent);
                }

            });
            $('#txtDisAmount1').bind("keyup keydown", function () {
                if ($('#txtDisAmount1').val() > 0) {
                    $('#txtDisPercent1').val('');
                }
                if ((parseFloat($('#txtDisAmount1').val())) > ($("#<%=lblBillAfterDiscount.ClientID %>").text())) {
                    modelAlert("Discount Amount Can Not Greater then Net Amount");
                    $('#txtDisAmount1').val($('#txtDisAmount1').val().substring(0, ($('#txtDisAmount1').val().length - 1)))
                    return false;
                }
            });
            $('#txtDisPercent1').bind("keyup keydown", function () {
                if ($('#txtDisPercent1').val() > 0) {
                    $('#txtDisAmount1').val('');
                }
                if ($('#txtDisPercent1').val() > 100) {
                    modelAlert("Please Enter Valid Discount Percent");
                    $('#txtDisPercent1').val($('#txtDisPercent1').val().substring(0, ($('#txtDisPercent1').val().length - 1)))
                }
            });
        });
        function CheckBilling() {
            if (($('#txtDisAmount1').val() == '' && $('#txtDisPercent1').val() == '') || ($('#txtDisAmount1').val() == 0 && $('#txtDisPercent1').val() == 0)) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Discount Amount OR Discount Percentge');
                $("#txtDisPercent1").focus();
                return false;
            }

            if ($('#txtDisAmount1').val() > 0 || $('#txtDisPercent1').val() > 0) {
                if ($("#<%= ddlApproveBy1.ClientID%>").val() == "0") {
                    $("#<%=lblMsg.ClientID%>").text('Please Select Discount Approval');
                    $("#<%= ddlApproveBy1.ClientID%>").focus();
                    return false;
                }

                if ($("#<%=ddlControlDiscountReason.ClientID%>").val() == "--Please Select Reason--") {
                    $("#<%=lblMsg.ClientID%>").text('Please Discount Reason');
                    $("#<%=ddlControlDiscountReason.ClientID%>").focus();
                    return false;
                }                
            }
            $("#<%=lblMsg.ClientID%>").text('')
            document.getElementById('<%=btnSaveFinalBill.ClientID%>').disabled = true;
            document.getElementById('<%=btnSaveFinalBill.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSaveFinalBill', '');
        }
        function ItemDis() {
            if ($('#txtDisAmount').val() > 0 || $('#txtDisPercent').val() > 0) {
                if ($("#ddlApproveBy option:selected").text() == "Select") {
                    $("#lblItemDis").text('Please Select Discount Approval');
                    $("#ddlApproveBy").focus();
                    return false;
                }
                if ($.trim($("#<%= txtDisReason.ClientID%>").val()) == "") {
                    $("#lblItemDis").text('Please Enter Discount Reason');
                    $("#<%= txtDisReason.ClientID%>").focus();
                    return false;
                }

            }
            $("#lblItemDis").text('')
            document.getElementById('<%=btnSaveItem.ClientID%>').disabled = true;
            document.getElementById('<%=btnSaveItem.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSaveItem', '');
        }

        function CheckPanelDocumentReason() {
            var TargetBaseControl = document.getElementById('<%=this.grdPanelDocs.ClientID%>');
            var TargetChildControl1 = "txtInput";
            var Inputs = TargetBaseControl.getElementsByTagName("input");
            for (var n = 0; n < Inputs.length; ++n) {
                if (Inputs[n].type == 'text') {
                    if (Inputs[n].value == '') {
                        $('#<%=lblDoc.ClientID %>').text('Enter Reason to Ignore');
                        return false;
                    }
                    else {
                        $('#<%=lblDoc.ClientID %>').text('');
                    }

                }
            }
        }
        function checkPolicy() {
            if ($('#txtPolicyNo').val() == '') {
                $('#lblErr').text('Please Enter Policy No.');
                $('#txtPolicyNo').focus();
                return false;

            }
            if ($('#txtCardNo').val() == '') {
                $('#lblErr').text('Please Enter Card No.');
                $('#txtCardNo').focus();
                return false;

            }
            if ($('#txtEmpID').val() == '') {
                $('#lblErr').text('Please Enter Staff ID');
                $('#txtEmpID').focus();
                return false;

            }
            if ($('#txtFileNo').val() == '') {
                $('#lblErr').text('Please Enter File No.');
                $('#txtFileNo').focus();
                return false;

            }
            if ($('#txtCHName').val() == '') {
                $('#lblErr').text('Please Enter Card Holder Name');
                $('#txtCHName').focus();
                return false;

            }
            if ($('#ddlHolder_Relation option:selected').text() == "Select") {
                $('#lblErr').text('Please Select Card Holder Relation');
                $('#ddlHolder_Relation').focus();
                return false;
            }
            else {
                $('#lblErr').text('');
            }
        }
        function ClearControl() {
            $('#txtDisReason').val('');
        }

        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpDisc")) {
                    $find("mpDisc").hide();
                    $("#txtDisReason").val('');
                }
                if ($find("mpePolicy")) {
                    $find("mpePolicy").hide();
                }
                if ($find("mpeDocs")) {
                    $find("mpeDocs").hide();
                }
            }
        }

        function closeItemsDiscount() {
            if ($find("mpDisc")) {
                $find("mpDisc").hide();
                $("#txtDisReason").val('');
            }
        }
        var openDiscountReasonModel = function () {
            $("#myModal").showModel();
        }

        var $closeDiscountreasonPopup = function () {
            $("#myModal").hideModel();
        }

    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
            </cc1:ToolkitScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Item Discount Details</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content">
                    <table cellpadding="0" cellspacing="0" style="width: 100%;">
                        <tr>
                            <td style="width: 12%; text-align: right">Gross Bill :&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblGrossBillAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">Total Disc. :&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblBillDiscount" runat="server" CssClass="ItDoseLabelSp" />&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">Net Amt. :&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblNetAmount" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">Advance :&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblAdvanceAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">Deduction :&nbsp</td>
                            <td style="width: 10%; text-align: left">
                                <asp:Label ID="lblDeduction" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="width: 12%; text-align: right">Disc. On Bill :&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblDiscOnBill" runat="server" CssClass="ItDoseLabelSp" />&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">Item&nbsp;Wise&nbsp;Disc.&nbsp;:&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblDiscItem" runat="server" CssClass="ItDoseLabelSp" />&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">&nbsp;</td>
                            <td style="width: 6%; text-align: right">&nbsp;</td>
                            <td style="width: 12%; text-align: right"></td>
                            <td style="width: 6%; text-align: right"></td>
                            <td style="width: 12%; text-align: right"></td>
                            <td style="width: 6%; text-align: right"></td>
                        </tr>
                        <tr>
                            <td style="width: 12%; text-align: right">Tax :&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblTaxPer" runat="server" CssClass="ItDoseLabelSp" />(%)&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">Total&nbsp;Tax&nbsp;:&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblTotalTax" runat="server" CssClass="ItDoseLabelSp" />&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">Net&nbsp;Bill&nbsp;Amt.&nbsp;:&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblNetBillAmt" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">Round&nbsp;Off&nbsp;:&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblRoundOff" runat="server" CssClass="ItDoseLabelSp" />&nbsp;
                            </td>
                            <td style="width: 12%; text-align: right">Remn.&nbsp;Amt.&nbsp;:&nbsp;
                            </td>
                            <td style="width: 6%; text-align: left">
                                <asp:Label ID="lblBalanceAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Bill Details
                </div>
                <div class="content" style="text-align: center;">
                    <div style="text-align: center;">
                        <asp:GridView ID="grdBasket" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnSelectedIndexChanged="grdBasket_SelectedIndexChanged" OnRowDataBound="grdBasket_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="SubCategory" ItemStyle-HorizontalAlign="Left" HeaderText="Department"
                                    HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Quantity" HeaderText="Quantity" HeaderStyle-Width="70px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="GrossAmt" HeaderText="Gross Amount" HeaderStyle-Width="120px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="ItemWiseDisc" HeaderText="Item Wise Disc. " HeaderStyle-Width="130px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="Amount" HeaderText="Amount" HeaderStyle-Width="100px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="UserName" HeaderText="Disc. Given By" HeaderStyle-Width="140px"
                                    ItemStyle-HorizontalAlign="Left">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DiscountReason" HeaderText="Disc. Reason" HeaderStyle-Width="140px"
                                    ItemStyle-HorizontalAlign="Left">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:CommandField ShowSelectButton="True" Visible="false" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image" HeaderText="View"
                                    SelectImageUrl="~/Images/view.GIF" />
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDisplayName" runat="server" Text='<%# Eval("DisplayName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsDiscountable" runat="server" Text='<%# Eval("IsDiscountable") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <br />
                    </div>
                    <div style="text-align: right; padding-right: 25px;">
                        &nbsp;
                    <asp:Button ID="btnFinalDiscount" runat="server" CssClass="ItDoseButton" OnClick="btnFinalDiscount_Click"
                        Text="Final Bill Discount"  OnClientClick="RestrictDoubleEntry(this)" />
                    </div>
                </div>
            </div>
            <asp:Panel ID="Panel2" runat="server">
                <div class="POuter_Box_Inventory">
                    <table style="width: 960px">
                        <tr>
                            <td style="text-align: right; width: 170px">UHID :&nbsp;
                            </td>
                            <td style="text-align: left; width: 10px">
                                <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                            <td style="text-align: right; width: 200px">Paid Amount :&nbsp;
                            </td>
                            <td style="text-align: left; width: 20px">
                                <asp:Label ID="lblPaidAmount" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                            <td style="text-align: right; width: 360px; color: red; font-weight: 700;" colspan="2">Disc. Amt. for Settlement Remaining Bill :&nbsp;<asp:Label ID="lblSettAmt" runat="server"></asp:Label>
                            </td>

                        </tr>
                        <tr>
                            <td style="text-align: right; width: 170px">Gross Bill :&nbsp;
                            </td>
                            <td style="text-align: left; width: 10px">
                                <asp:Label ID="lblBillAmount" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                            <td style="text-align: right; width: 200px">Disc. Amount :&nbsp;
                            </td>
                            <td style="width: 20px; text-align: left">
                                <asp:Label ID="lblDisAlreadygiven" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                            <td style="text-align: right; width: 160px">&nbsp;
                            </td>
                            <td style="text-align: right; width: 200px">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 170px">Net Amount :&nbsp;
                            </td>
                            <td style="text-align: left; width: 10px">
                                <asp:Label ID="lblBillAfterDiscount" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                            <td style="text-align: right; width: 200px">Disc. (%) :&nbsp;
                            </td>
                            <td style="width: 20px; text-align: left">
                                <asp:Label ID="lblDiscountPercent" runat="server" CssClass="ItDoseLabelSp" />
                            </td>
                            <td style="text-align: right; width: 160px">&nbsp;
                            </td>
                            <td style="text-align: right; width: 200px">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 170px">Total Bill Disc. :&nbsp;
                            </td>
                            <td style="text-align: left; width: 10px">
                                <asp:TextBox ID="txtDisAmount1" runat="server" Enabled="false"  Width="90px"
                                    MaxLength="10" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" />
                                <cc1:FilteredTextBoxExtender ID="fl1" runat="server" FilterType="Custom,Numbers"
                                    TargetControlID="txtDisAmount1" ValidChars="." />
                            </td>
                            <td style="text-align: right; width: 200px">Bill Disc. (%) :&nbsp;
                            </td>
                            <td style="width: 20px; text-align: left">
                                <asp:TextBox ID="txtDisPercent1" runat="server" Enabled="false"  Width="60px"
                                    MaxLength="5" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" />
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Custom,Numbers"
                                    ValidChars="." TargetControlID="txtDisPercent1" />
                            </td>
                            <td style="text-align: left; width: 160px">&nbsp;
                            </td>
                            <td style="text-align: left; width: 200px">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 170px">Approval :&nbsp;
                            </td>
                            <td style="text-align: left; width: 10px">
                                <asp:DropDownList ID="ddlApproveBy1" runat="server"></asp:DropDownList>
                            </td>
                            <td style="text-align: right; width: 200px"></td>
                            <td style="width: 20px; text-align: left"></td>
                            <td style="text-align: left; width: 160px">&nbsp;
                            </td>
                            <td style="text-align: left; width: 200px">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; vertical-align: top; width: 170px">Disc. Reason :&nbsp;
                            </td>
                            <td colspan="3" style="width: 580px">
                                <asp:DropDownList runat="server" ID="ddlControlDiscountReason"></asp:DropDownList>
                                <%--  <asp:TextBox ID="txtDisReason1" runat="server" TextMode="MultiLine"
                                    Width="340px" Height="56px" />
                                Number of Characters Left:
                            <label id="lblremaingCharacters2" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                            </label>--%>
                            </td>
                            <td colspan="2" style="width: 580px;display:none">
                                <input style="float: left; box-shadow: none;" type="button" value="New" onclick="openDiscountReasonModel()" />
                            </td>

                        </tr>
                    </table>
                </div>

                <div class="POuter_Box_Inventory" style="text-align: center">
                    <asp:Button ID="btnSaveFinalBill" runat="server" CssClass="ItDoseButton"
                        OnClick="btnSaveFinalBill_Click" OnClientClick="return CheckBilling();" Text="Save" />
                </div>
            </asp:Panel>
            <div class="POuter_Box_Inventory">

                <table cellpadding="0" cellspacing="0" style="width: 100%" runat="server">
                    <tr style="display: none">
                        <td style="width: 15%; text-align: right; vertical-align: top">Tax :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtServiceChg" runat="server" CssClass="ItDoseTextinputNum" Width="80px">0</asp:TextBox>%

                        </td>
                        <td style="width: 25%; text-align: right; display: none">Surcharge @
                            <cc1:FilteredTextBoxExtender ID="fteb5" runat="server" FilterType="Custom,Numbers"
                                ValidChars="." TargetControlID="txtSurchg" />
                            <asp:DropDownList
                                ID="cmbNarration" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="cmbNarration_SelectedIndexChanged" Visible="false" />
                            <asp:TextBox ID="txtSurchg" runat="server" CssClass="ItDoseTextinputNum" Width="20px">0</asp:TextBox>
                            %
                        </td>
                        <td style="width: 35%; text-align: right;">Tax Applied on :&nbsp;<asp:TextBox ID="txtSerTaxBillAmount" runat="server"
                            CssClass="ItDoseTextinputNum" Width="100px">0</asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="fteb4" runat="server" FilterType="Custom,Numbers"
                                ValidChars="." TargetControlID="txtServiceChg" />
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td style="width: 15%; text-align: right; vertical-align: top">Total&nbsp;Tax&nbsp;:&nbsp;

                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtTotalTaxAmt" runat="server" CssClass="ItDoseTextinputNum" Width="80px">0</asp:TextBox>

                        </td>
                        <td style="width: 25%; text-align: right">Round Off :&nbsp;<asp:TextBox ID="txtRoundOff" runat="server" CssClass="ItDoseTextinputNum" Width="100px">0</asp:TextBox>
                        </td>
                        <td style="width: 35%; text-align: right;">Net Bill Amt.:&nbsp;<asp:TextBox ID="txtNetBillAmt" runat="server" CssClass="ItDoseTextinputNum" Width="100px">0</asp:TextBox>
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 15%; text-align: right; vertical-align: top">Narration :&nbsp;
                        </td>
                        <td colspan="2" style="width: 28%; text-align: left">
                            <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" Width="280px"
                                Height="64px"></asp:TextBox>
                            Number of Characters Left:
                            <label id="lblremaingCharacters1" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                            </label>
                        </td>

                        <td style="width: 45%; text-align: left;">
                            <table>
                                <tr>
                                    <td style="text-align: right">Billing Type :&nbsp;
                                    </td>
                                    <td style="text-align: left">
                                        <asp:RadioButtonList ID="rdbBillType" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="Open Bill" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="Package Bill" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="Mixed Bill" Value="3"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </table>

                        </td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>

                </table>

            </div>
            <div class="POuter_Box_Inventory">
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: left;">
                    <table>

                        <tr>
                            <td style="width: 15%; vertical-align: top">Currency :
                                    <asp:DropDownList ID="ddlCurrency" onchange="CurrencyChange()" runat="server" ClientIDMode="Static" CssClass="ItDoseLabel" Width="100px" />
                                &nbsp;<asp:Label ID="lblCurreny_Amount" runat="server" ClientIDMode="Static"
                                    Style="color: #0000CC; font-weight: 700; background-color: #CCFF33;"></asp:Label>
                                <asp:TextBox ID="txtCurreny_Amount" ClientIDMode="Static" runat="server" Style="display: none"></asp:TextBox>
                                <asp:TextBox ID="lblCurrencyNotation" runat="server" Style="display: none"></asp:TextBox>
                            </td>

                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="Purchaseheader">
                          Billing Currency Detail
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Currency
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:Label ID="lblBillCurrency" ClientIDMode="Static" runat="server"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Notation
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:Label ID="lblBillNotation" ClientIDMode="Static" runat="server"></asp:Label>
                    </div>
                    <div class="col-md-5">
                        <label class="pull-left">
                            Conversion Factor
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:Label ID="lblBillConFactor" ClientIDMode="Static" runat="server"></asp:Label>
                        <asp:Label ID="lblBillCountryId" ClientIDMode="Static" runat="server" Style="display: none;"></asp:Label>
                        <asp:TextBox ID="txtBillCurrency" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                         <asp:TextBox ID="txtBillNotation" runat="server" ClientIDMode="Static"  Style="display: none;"></asp:TextBox>
                         <asp:TextBox ID="txtBillConFactor" runat="server" ClientIDMode="Static"  Style="display: none;"></asp:TextBox>
                         <asp:TextBox ID="txtBillCountryId" runat="server" ClientIDMode="Static"  Style="display: none;"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="display:none;">
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Panel Rate Currency
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:Label runat="server" BackColor="YellowGreen" Font-Bold="true" ID="lblPanelRateCurrency"></asp:Label>
                        <asp:Label runat="server" Visible="false" ID="lblPanelID"></asp:Label>
                        <asp:Label runat="server" Visible="false" ID="lblPanelRateCurrencyCountryID"></asp:Label>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            Panel  Currency Factor
                        </label>
                        <b class="pull-ri
          
                    
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox runat="server" ID="txtPanelCurrencyFactor"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <asp:Button runat="server" ID="btnCalculate" OnClick="btnCalculate_Click" Text="Calculate" />
                    </div>
                </div>
            </div>





            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <asp:Button ID="btnUpdateBilling" runat="server" CssClass="ItDoseButton" OnClick="btnUpdateBilling_Click"
                        UseSubmitBehavior="false" Text="Update Billing" Visible="false" /><asp:Button ID="btnGenerateBill"
                            runat="server" CssClass="ItDoseButton" OnClick="btnGenerateBill_Click" OnClientClick="return confirm_Bill(this);"
                            Text="Generate Bill" />
                    &nbsp;&nbsp;&nbsp;
                </div>
            </div>
        </div>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" />
        </div>
        <asp:Panel ID="pnlAddItems" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; width: 740px; overflow: scroll; height: 400px">
            <div class="Purchaseheader" runat="server" id="dragHandle" style="width: 710px">
                Items Discount&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp; <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeItemsDiscount()" alt="" />
                to close</span></em>
            </div>



            <table style="border-collapse: collapse">
                <tr>
                    <td colspan="4" style="text-align: center">
                        <asp:Label ID="lblItemDis" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>

                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Department :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:Label ID="lblDept" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="text-align: right"></td>
                    <td style="text-align: left"></td>
                </tr>
                <tr>
                    <td style="text-align: right">Quantity :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:Label ID="lblQty" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="text-align: right">Amount :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:Label ID="lblAmount" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Disc. Amount :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtDisAmount" runat="server" Enabled="false" Width="75px" CssClass="ItDoseTextinputNum"
                            MaxLength="12" ClientIDMode="Static" ToolTip="Enter Discount Amount" TabIndex="1"
                            onkeypress="return checkForSecondDecimal(this,event)" />
                        OR Disc. (%) :&nbsp;
                    <asp:TextBox ID="txtDisPercent" runat="server" Enabled="false" Width="75px" CssClass="ItDoseTextinputNum"
                        ClientIDMode="Static" MaxLength="5" ToolTip="Enter Discount %" TabIndex="2" onkeypress="return checkForSecondDecimal(this,event)" />
                    </td>
                    <td style="text-align: right">
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom,Numbers"
                            ValidChars="." TargetControlID="txtDisAmount" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom,Numbers"
                            ValidChars="." TargetControlID="txtDisPercent" />
                        Approval :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:DropDownList ID="ddlApproveBy" ClientIDMode="Static" runat="server" Width="170px"
                            ToolTip="Select Approval" TabIndex="3" />
                        <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; vertical-align: top">Disc. Reason :&nbsp;
                    </td>
                    <td style="text-align: left" colspan="3">
                        <asp:TextBox ID="txtDisReason" runat="server" CssClass="ItDoseTextinputText" TextMode="MultiLine"
                            Width="370px" Height="54px" ToolTip="Enter Discount Reason" TabIndex="4" ClientIDMode="Static" />
                        <asp:Label ID="Label8" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        Number
                    of Characters Left:
                    <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                    </label>
                    </td>
                </tr>
            </table>
            <asp:GridView ID="grdBasketItem" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="ItemName" HeaderText="Item Name">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Quantity" HeaderText="Quantity">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="GrossAmt" HeaderText="Gross Amt.">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ItemWiseDisc" HeaderText="Item Wise Disc.">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DiscountPercentage" HeaderText="Disc. %">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="UserName" HeaderText="Disc. Given By">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DiscountReason" HeaderText="Disc. Reason">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:TemplateField Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID")
    %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="lblDisplayName" runat="server" Text='<%# Eval("DisplayName")
    %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <div class="filterOpDiv" style="width: 702px">
                <asp:Button ID="btnSaveItem" runat="server" CssClass="ItDoseButton" OnClick="btnSaveItem_Click"
                    Text="Save" TabIndex="5" ToolTip="Click to Save" OnClientClick="return ItemDis();" />
                <asp:Button ID="btnCancelItem" runat="server" CssClass="ItDoseButton" OnClick="btnCancelItem_Click"
                    Text="Cancel" TabIndex="6" ToolTip="click to Cancel" />
            </div>
        </asp:Panel>
        <%--</div>--%>
        <cc1:ModalPopupExtender ID="mpDisc" runat="server" CancelControlID="btnCancelItem"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlAddItems" PopupDragHandleControlID="dragHandle" BehaviorID="mpDisc"
            OnCancelScript="ClearControl();" />
        <br />
        <asp:Panel ID="pnlPolicy" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none">
            <div class="Purchaseheader" runat="server" id="Div1">
                Provide Patient Policy Details &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            Press esc to close
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td colspan="2" style="width: 90%; text-align: center">
                        <asp:Label ID="lblErr" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 35%; text-align: right">Policy No. :&nbsp;
                    </td>
                    <td style="width: 65%; text-align: left">
                        <asp:TextBox ID="txtPolicyNo" runat="server" CssClass="ItDoseTextbox" MaxLength="30"
                            ClientIDMode="Static" Width="228px" TabIndex="1" ToolTip="Enter Policy No."></asp:TextBox>
                        <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 35%; text-align: right">Card No. :&nbsp;
                    </td>
                    <td style="width: 65%; text-align: left">
                        <asp:TextBox ID="txtCardNo" runat="server" CssClass="ItDoseTextbox" MaxLength="30"
                            ClientIDMode="Static" Width="228px" TabIndex="1" ToolTip="Enter Policy No."></asp:TextBox>
                        <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:FilteredTextBoxExtender ID="ftbcardNo" runat="server" TargetControlID="txtCardNo"
                            FilterType="Numbers">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 35%; text-align: right">Staff ID :&nbsp;
                    </td>
                    <td style="width: 65%; text-align: left">
                        <asp:TextBox ID="txtEmpID" runat="server" CssClass="ItDoseTextbox" MaxLength="30"
                            ClientIDMode="Static" Width="228px" TabIndex="2" ToolTip="Enter Staff ID"></asp:TextBox>
                        <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 35%; text-align: right">File No. :&nbsp;
                    </td>
                    <td style="width: 65%; text-align: left">
                        <asp:TextBox ID="txtFileNo" runat="server" CssClass="ItDoseTextbox" MaxLength="30"
                            ClientIDMode="Static" Width="228px" TabIndex="3" ToolTip="Enter File No."></asp:TextBox>
                        <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 35%; text-align: right">Card Holder Name :&nbsp;
                    </td>
                    <td style="width: 65%; text-align: left">
                        <asp:TextBox ID="txtCHName" runat="server" CssClass="ItDoseTextbox" ClientIDMode="Static"
                            Width="228px" TabIndex="4" ToolTip="Enter Card Holder Name" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 35%; text-align: right">Relation With CH :&nbsp;
                    </td>
                    <td style="width: 65%; text-align: left">
                        <asp:DropDownList ID="ddlHolder_Relation" runat="server" Width="234px" TabIndex="5"
                            ToolTip="Select Relation With Card Holder" ClientIDMode="Static">
                        </asp:DropDownList>
                        <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 35%"></td>
                    <td style="width: 65%">
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="File No Should be Only Numbers"
                            ControlToValidate="txtFileNo" ValidationExpression="^\d+$">File No. Should be Only Numbers</asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width: 35%"></td>
                    <td style="width: 65%">
                        <asp:Button ID="btnUpdatePolicy" runat="server" CssClass="ItDoseButton" OnClick="btnUpdatePolicy_Click"
                            Text="Update" OnClientClick="return checkPolicy();" />
                        <asp:Button ID="btnCancelPolicy" runat="server" CssClass="ItDoseButton" OnClick="btnCancelItem_Click"
                            Text="Cancel" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <br />
        <cc1:ModalPopupExtender ID="mpePolicy" runat="server" CancelControlID="btnCancelPolicy"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlPolicy" PopupDragHandleControlID="dragHandle" BehaviorID="mpePolicy" />
        <br />
        <asp:Panel ID="pnlDocs" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="650px">
            <div class="Purchaseheader" runat="server" id="Div2">
                Pending Panel Document Details &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            Press esc to close
            </div>
            <div class="content">
                <table cellpadding="0" cellspacing="0" style="width: 100%;">
                    <tr>
                        <td style="text-align: center">
                            <asp:Label ID="lblDoc" runat="server" CssClass="ItDoseLblError"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16px; text-align: Left">
                            <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click" ToolTip="Click to Upload Panel Document">Upload
    Pending Documents</asp:LinkButton>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 16px">
                            <asp:GridView ID="grdPanelDocs" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                Width="640px">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                            <asp:Label runat="server" Visible="false" ID="lblPanelDocumentID" Text='<%# Eval("PanelDocumentID") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Document" HeaderText="Document Name">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Reason To Ignore">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                        <ItemTemplate>
                                            <asp:TextBox runat="server" ID="txtReason" ClientIDMode="Static" Width="240px" TabIndex="1"
                                                MaxLength="50" ToolTip="Enter Reason To Ignore"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <table style="width: 100%">
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 25%"></td>
                        <td style="width: 75%; text-align: center">
                            <asp:Button ID="btnDocUpdate" runat="server" CssClass="ItDoseButton" OnClientClick="javascript:return CheckPanelDocumentReason();"
                                Text="Update" TabIndex="2" ToolTip="Click to Update" OnClick="btnDocUpdate_Click" />
                            <asp:Button ID="btnCancelDoc" runat="server" CssClass="ItDoseButton" OnClick="btnCancelItem_Click"
                                Text="Cancel" TabIndex="3" ToolTip="Click to Cancel" ClientIDMode="Static" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <br />
        <cc1:ModalPopupExtender ID="mpeDocs" runat="server" CancelControlID="btnCancelDoc"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlDocs" PopupDragHandleControlID="dragHandle" BehaviorID="mpeDocs" />

        <div class="modal fade" id="myModal">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 300px">
                    <div class="modal-header">
                        <button type="button" class="close"  onclick="$closeDiscountreasonPopup()" aria-hidden="true">&times;               odal-title">Add Discount Reasonunt Reason</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div style="width: 100.666667%" class="col-md-14">
                                <textarea  runat="server" clientidmode="Static" maxlength="50" id="txtDiscReason" class="requiredField" ></textarea>

                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button runat="server" ID="btnsave" Text="Save" OnClick="btnsave_Click" Style="padding: 2px 5px; border: 1px solid transparent; font-size: 14px;" />
                        </div>
                </div>

            </div>
        </div>
    </form>
</body>
</html>
