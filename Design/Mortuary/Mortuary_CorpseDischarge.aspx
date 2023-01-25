<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mortuary_CorpseDischarge.aspx.cs"
    Inherits="Design_Mortuary_Mortuary_CorpseDischarge" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/StartDate.ascx" TagName="StartDate" TagPrefix="uc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>

<%@ Register Src="~/Design/Controls/wuc_IPDBillDetail.ascx" TagName="IPDBillDetail" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
</head>
<body>
    <script type="text/javascript">
        function validate(btn) {
            if ($.trim($("#txtName").val()) == "") {
                $("#lblMsg").text("Please Enter Receiver Name");
                $("#txtName").focus();
                return false;
            }

            if ($.trim($("#txtContactNo").val()) == "") {
                $("#lblMsg").text("Please Enter Receiver Contact No");
                $("#txtContactNo").focus();
                return false;
            }

            if (($.trim($('#txtContactNo').val()) != "") && ($.trim($('#txtContactNo').val()).length < "10")) {
                $('#lblMsg').text('Please Enter Valid Receiver Contact No.');
                $('#txtContactNo').focus();
                return false;
            }

            if ($.trim($("#txtAddress").val()) == "") {
                $("#lblMsg").text("Please Enter Receiver Address");
                $("#txtAddress").focus();
                return false;
            }

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnRelease', '');
            return true;
        }
        function popup() {

            $("#lblMsg").text("");

            if (parseFloat($('#<%=lblNetBillAmt.ClientID %>').text()) > 0) {
                $('#lblBal').text('Remaining Balance Is (' + $('#<%=lblNetBillAmt.ClientID %>').text() + ') Are You Sure You Want To Release ?');
            }

            $find("<%=mpNarration.ClientID%>").show();

        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpNarration")) {
                    $find("mpNarration").hide();
                }

            }

        }

        function check(sender, e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                return false;
            else
                return true;
        }

    </script>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Corpse Release</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="">
                                        <table style="width: 100%">
                        <tr>
                            <td style="width: 8%">
                                &nbsp;</td>
                            <td style="width: 10%; text-align: right">Gross&nbsp;Bill&nbsp;:&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblGrossBillAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="width: 5%; text-align: right">Discount :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblBillDiscount" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">Net Amt. :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblNetAmount" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 6%; text-align: right">Advance :&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblAdvanceAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                            <td style="width: 10%; text-align: right"></td>
                            <td style="width: 10%; text-align: right"></td>
                        </tr>
                        <tr>
                            <td style="width: 10%">&nbsp;</td>
                            <td style="width: 10%; text-align: right">Tax&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblTaxPer" runat="server" CssClass="ItDoseLabelSp" />(%)&nbsp;&nbsp;&nbsp;</td>
                            <td style="width: 5%; text-align: right">Total&nbsp;Tax&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblTotalTax" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;</td>
                            <td style="width: 10%; text-align: right">Net&nbsp;Bill&nbsp;Amt.&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblNetBillAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;</td>
                            <td style="width: 6%; text-align: right">Round&nbsp;Off&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblRoundOff" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;                              
                            </td>
                            <td style="width: 10%; text-align: right">Remn.&nbsp;Amt.&nbsp;:&nbsp;</td>
                            <td style="width: 10%; text-align: right">
                                <asp:Label ID="lblBalanceAmt" runat="server" CssClass="ItDoseLabelSp" />&nbsp;&nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Released Information
                    </div>
                    <table>
                        <tr>
                            <td style="width: 20%" align="right">Date :&nbsp;
                            </td>
                            <td style="width: 30%" align="left">
                                <uc1:StartDate ID="txtDate" runat="server" />
                            </td>
                            <td style="width: 20%; text-align: right;" align="left">Time :
                            </td>
                            <td style="width: 30%" align="left">
                                <uc2:StartTime ID="StartTime" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" width="100%">
                                <asp:Panel ID="pnlReceiver" runat="server">
                                    <table width="100%">
                                        <tr>
                                            <td style="width: 20%; text-align: right">Receiver Name&nbsp;:&nbsp;</td>
                                            <td style="width: 30%; text-align: left">
                                                <asp:TextBox ID="txtName" runat="server" MaxLength="20" ToolTip="Enter Name" ClientIDMode="Static" Width="150" onkeypress="return check(this,event)"/>
                                                <span class="ItDoseLblError">*</span>
                                            </td>
                                            <td style="width: 20%; text-align: right">Receiver Contact No&nbsp;:&nbsp;</td>
                                            <td style="width: 30%; text-align: left;">
                                                <asp:TextBox ID="txtContactNo" runat="server" MaxLength="15" ToolTip="Enter Contact No" ClientIDMode="Static" Width="150" />
                                                <span class="ItDoseLblError">*</span>
                                                <cc1:FilteredTextBoxExtender ID="ftbeContactNo" runat="server" TargetControlID="txtContactNo" FilterType="Numbers" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%; text-align: right">Receiver Address&nbsp;:&nbsp;</td>
                                            <td style="text-align: left;width: 80%" colspan="2">
                                                <asp:TextBox ID="txtAddress" runat="server" MaxLength="200" ToolTip="Enter Address" ClientIDMode="Static" TextMode="MultiLine" Height="50" Width="300" onkeypress="return check(this,event)"/>
                                                <span class="ItDoseLblError">*</span>
                                            </td>
                                             </tr>
                                        <tr>
                                             <td style="width: 20%; text-align: right">Permit No&nbsp;:&nbsp;</td>
                                           
                                            <td style="width: 30%; text-align: left;">
                                                <asp:Label ID="lblPermitNo" runat="server" CssClass="ItDoseLabelSp" />
                                                
                                            </td>
                                            
                                             <td style="width: 20%; text-align: right">National ID&nbsp;:&nbsp;</td>
                                           
                                            <td style="width: 30%; text-align: left;">
                                               <asp:Label ID="lblNationalID" runat="server" CssClass="ItDoseLabelSp" /> 
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnRelease" runat="server" OnClick="btnRelease_Click" Text="Release" CssClass="ItDoseButton" OnClientClick="return validate(this)" />
                <asp:Button ID="btnRelIntimate" runat="server" Text="Release Intimate" CssClass="ItDoseButton" OnClientClick="return popup();" />
            </div>
            <asp:Label ID="lblCorpseID" runat="server" CssClass="general3" Visible="False"></asp:Label>
            <asp:Label ID="lblTransactionID" runat="server" Visible="False"></asp:Label>
        </div>
        <asp:Panel ID="pnlDisIntimate" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none" Width="666px">
            <div class="Purchaseheader" id="Div1" runat="server">
                Released Intimation &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; 
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Press esc to close
            </div>
            <table style="width: 91%">
                <tr>
                    <td colspan="4">
                        <asp:Label ID="lblBal" runat="server" Font-Bold="true" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 7%; text-align: right">Date :&nbsp;</td>
                    <td style="width: 11%">
                        <uc1:StartDate ID="EntryDate1" runat="server" />
                    </td>
                    <td style="width: 5%">Time :</td>
                    <td style="width: 25%">
                        <uc2:StartTime ID="EntryTime1" runat="server" />
                    </td>
                </tr>
            </table>
            <div class="filterOpDiv">
                <asp:Button ID="btnNarSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnNarSave_Click" />
                &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnNarCancel" runat="server" Text="Cancel" CausesValidation="false" CssClass="ItDoseButton" />
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpNarration" runat="server" CancelControlID="btnNarCancel"
            DropShadow="true" TargetControlID="btnRelIntimate" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlDisIntimate" BehaviorID="mpNarration" PopupDragHandleControlID="dragHandle" />
    </form>
</body>
</html>
