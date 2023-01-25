<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UpdatePanelApproval.aspx.cs" Inherits="Design_Finance_UpdatePanelApproval" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/StartDate.ascx" TagName="StartDate" TagPrefix="uc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />


    <script type="text/javascript">

        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Generating....';
            document.getElementById("btnFinalDiscount").disabled = true;
        }

        function CalculateDiff(NetBill_ID, Cash_ID, PanelID) {
            var NetBillAmt = NetBill_ID.innerHTML;
            var CashAmt = Cash_ID.innerHTML;
            var PanelAmt = PanelID.value;
            Cash_ID.innerHTML = parseFloat(NetBillAmt - PanelAmt);
        }
    </script>
</head>
<body>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function validateRej() {
            if ($.trim($("#txtCancelReason").val()) == "") {

                $("#lblReject").text('Please Enter Reject Reason');
                $("#txtCancelReason").focus();
                return false;
            }
        }
        $(document).ready(function () {
            var MaxLength = 300;
            $("#<% =txtRemarks.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#<% =txtRemarks.ClientID %>").bind("keypress", function (e) {
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
        var characterLimit = 300;
        $(document).ready(function () {
            $("#lblremaingCharacters").html(characterLimit - ($("#<%=txtRemarks.ClientID %>").val().length));
            $("#<%=txtRemarks.ClientID %>").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > characterLimit) {
                    $(this).val($(this).val().substr(0, characterLimit));
                }
                var characterRemaining = characterLimit - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });

        });
        function validate(btn) {

            if ($('#txtPanelBillAmt').val() <= 0) {
                $('#txtPanelBillAmt').focus();
                $('#lblMsg').text('Please Enter Panel Approved Amount');
                return false;
            }
            //if ($('#fileUpload1').val() == "") {
            //    $('#fileUpload1').focus();
            //    $('#lblMsg').text('Please Browse File');
            //    return false;

           // }
            if (($('#rdoAppType').is(':visible') == true) && ($('#rdoAppType input:checked').index() == '-1')) {
                $('#rdoAppType').focus();
                $('#lblMsg').text('Please Select Panel Approval Type');
                return false;
            }
            if ($("#<%=txtRemarks.ClientID %>").val() == "") {
                $("#<%=txtRemarks.ClientID %>").focus();
                $('#lblMsg').text('Please Enter Remarks for Approval');
                return false;

            }

            if ($('#rdoAppWay input:checked').index() == '-1') {
                $('#rdoAppWay').focus();
                $('#lblMsg').text('Please select Amount Approval Type');
                return false;
            }
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnUpdateBilling', '');
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
        }
        function ValidateDecimalAmt() {
            var DigitsAfterDecimal = 2;
            var val = $('#txtPanelBillAmt').val();
            var valIndex = val.indexOf(".");
            alert(val);
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    $('#txtPanelBillAmt').val($('#txtPanelBillAmt').val().substring(0, ($('#txtPanelBillAmt').val().length - 1)));
                    return false;
                }
            }
        }

        $("#txtPanelBillAmt").bind("blur keyup keydown", function () {
            if (($(this).val().charAt(0) == ".")) {
                $(this).val('0.');
            }

        });
    </script>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Update Patient Amount / Panel Approved Amount</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Bill Details
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 20%" align="right">Bill Amount :&nbsp;</td>
                        <td align="left">
                            <asp:Label ID="lblBillAmount" runat="server" CssClass="ItDoseLabelSp" /></td>
                        <td style="width: 20%;" align="right">Panel :&nbsp;</td>
                        <td style="width: 35%; text-align: left">
                            <asp:Label ID="lblPanelNAme" runat="server" CssClass="ItDoseLabelSp" Visible="false" />
                            <asp:DropDownList ID="ddlPanelCompany" runat="server" Width="155px" OnSelectedIndexChanged="ddlPanelCompany_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%">Patient Amount :&nbsp;</td>
                        <td style="width: 15%" align="left">
                            <asp:Label ID="lblCashBillAmt" runat="server" CssClass="ItDoseLabelSp" /></td>
                        <td align="right" style="width: 20%">Panel Approved Amount :&nbsp;</td>
                        <td style="width: 35%; text-align: left">
                            <asp:TextBox ID="txtPanelBillAmt" runat="server" Width="140px" MaxLength="12" onkeypress="return checkForSecondDecimal(this,event)" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum requiredField" ClientIDMode="Static" />
                            <%--<asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                            <cc1:FilteredTextBoxExtender ID="ftbBill" runat="server" ValidChars=".0987654321" TargetControlID="txtPanelBillAmt"></cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%">Approval Date :&nbsp;</td>
                        <td style="width: 15%">

                            <asp:TextBox ID="txtAppDate" runat="server" Width="90px"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtAppDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                        <td align="right" style="width: 20%">Claim No. :&nbsp;
                        </td>
                        <td style="width: 35%; text-align: left">
                            <asp:TextBox ID="txtClaimNo" runat="server" Width="139px" MaxLength="20" ClientIDMode="Static" /></td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%">Final Approval Amount :&nbsp;
                        </td>
                        <td style="width: 15%">
                            <asp:Label ID="lblApprovalAmt" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        <td align="right" style="width: 20%;display:none">Panel Approval Type :&nbsp;
                        </td>
                        <td style="width: 35%; text-align: left;display:none">
                            <asp:RadioButtonList ID="rdoAppType" CssClass="ItDoseRadiobuttonlist" runat="server" RepeatColumns="2" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="Additional" Value="A" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Cummulative" Value="C"></asp:ListItem>
                            </asp:RadioButtonList></td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%">Browse Approval File :&nbsp;
                        </td>
                        <td colspan="3" style="text-align: left">
                            <asp:FileUpload ID="fileUpload1" runat="server" Width="200px" ClientIDMode="Static"  />
                            <%--<asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>

                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%" valign="top">Remarks :&nbsp;</td>
                        <td colspan="3" valign="top">
                            <asp:TextBox ID="txtRemarks" runat="server" CssClass="required" Width="515px"
                                Height="50px" TextMode="MultiLine" />
                            <%--<asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>--%>
                            Number of Characters Left:
                        <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                        </label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 20%;display:none">Amount Approval Type :&nbsp;
                        </td>
                        <td colspan="3" valign="top" style="display:none">
                            <Ajax:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;                                   
                                     <div class="Search_Outer_Box" style="clear: both; float: left; width: 486px;">
                                         <asp:RadioButtonList ID="rdoAppWay" runat="server" AutoPostBack="true" RepeatColumns="2" RepeatDirection="Horizontal" OnSelectedIndexChanged="rdoAppWay_SelectedIndexChanged" Width="309px" ClientIDMode="Static">
                                             <asp:ListItem Text="Open Approval" Value="Open" Selected="True"></asp:ListItem>
                                             <asp:ListItem Text="Fixed By Date Approval" Value="Fix"></asp:ListItem>
                                         </asp:RadioButtonList>

                                         <asp:Panel ID="pnlVisible" runat="server" Visible="false">
                                             &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
                        <uc1:StartDate ID="txtType" runat="server" />
                                         </asp:Panel>
                                     </div>
                                </ContentTemplate>
                            </Ajax:UpdatePanel>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnUpdateBilling" runat="server" CssClass="ItDoseButton" OnClick="btnUpdateBilling_Click"
                    Text="Update Billing" OnClientClick="return validate(this);" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Panel Approval Details&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#90EE90">Reject</span>
                </div>
                <asp:GridView ID="grdPanel_App" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowCommand="grdPanel_App_RowCommand" OnRowDataBound="grdPanel_App_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemTemplate>
                                <asp:Label ID="lblTransactionID" runat="server" Text='<%# Eval("TransactionID") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Panel Name">
                            <ItemTemplate>
                                <asp:Label ID="lblPanelName" runat="server" Text='<%# Eval("Company_Name") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Approval Amt. ">
                            <ItemTemplate>
                                <asp:Label ID="lblPanelApprovedAmt" runat="server" Text='<%# Eval("PanelApprovedAmt") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Approval Date">
                            <ItemTemplate>
                                <asp:Label ID="lblPanelApprovalDate" runat="server" Text='<%# Eval("PanelApprovalDate") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Claim No. ">
                            <ItemTemplate>
                                <asp:Label ID="lblClaimNo" runat="server" Text='<%# Eval("ClaimNo") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Approval Type" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblApprovalType" runat="server" Text='<%# Eval("PanelApprovalType") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remarks">
                            <ItemTemplate>
                                <asp:Label ID="lblPanelAppRemarks" runat="server" Text='<%# Eval("PanelAppRemarks") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Amt. App. Type" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblAmtAppType" runat="server" Text='<%# Eval("AmountApprovalType") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="App. Expiry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblAppExpiryDate" runat="server" Text='<%# Eval("AppExpiryDate") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Created By">
                            <ItemTemplate>
                                <asp:Label ID="lblUserID" runat="server" Text='<%# Eval("UserID") %>' />
                                <asp:Label ID="lblFileName" runat="server" Visible="false" Text='<%# Eval("ApprovalFileName") %>'></asp:Label>
                                <asp:Label ID="lblIsActive" runat="server" Visible="false" Text='<%# Eval("IsActive") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" runat="server" CommandName="AView" ToolTip="View Approval"
                                    ImageAlign="middle" CausesValidation="false" ImageUrl="~/Images/view.GIF"
                                    CommandArgument='<%# Eval("TransactionID")+"$"+Eval("ApprovalFileName") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgEdit" runat="server" CommandName="AEdit" ToolTip="Edit Approval"
                                    ImageAlign="middle" CausesValidation="false" ImageUrl="~/Images/Edit.png"
                                    CommandArgument='<%# Eval("TransactionID")+"$"+Eval("ID") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgReject" runat="server" CausesValidation="false" CommandName="Reject"
                                    ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("TransactionID")+"$"+Eval("ApprovalFileName") +"$"+ Container.DataItemIndex%>' />

                                <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px"  />
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
            <cc1:ModalPopupExtender ID="mpeRejection" runat="server" CancelControlID="btnCancelRejection"
                DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
                PopupControlID="pnlRejection" PopupDragHandleControlID="dragHandle" />
            <asp:Panel ID="pnlRejection" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 280px">
                <div class="Purchaseheader" id="Div1" runat="server">
                    Rejection Reason
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <asp:Label ID="lblReject" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Reason :&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtCancelReason" runat="server" ClientIDMode="Static" Width="150px"
                                MaxLength="100" CssClass="required" />
                            <%--<span style="color: red; font-size: 10px;" class="shat">*</span>--%>
                        </td>
                    </tr>
                </table>



                <br />

                <div class="filterOpDiv">
                    <asp:Button ID="btnOKRejection" runat="server" Text="Reject" CssClass="ItDoseButton"
                        OnClick="btnOKRejection_Click" OnClientClick="return validateRej()" />
                    &nbsp; &nbsp;&nbsp;
            <asp:Button ID="btnCancelRejection" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" Width="50px" />
                </div>
            </asp:Panel>
            <div style="display: none;">
                <asp:Button ID="btnHidden" runat="server" />
            </div>
        </div>


    </form>
</body>
</html>
