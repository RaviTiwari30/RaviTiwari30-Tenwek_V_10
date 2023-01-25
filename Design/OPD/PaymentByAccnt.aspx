<%@ Page Language="C#"  MasterPageFile="~/DefaultHome.master"  AutoEventWireup="true" CodeFile="PaymentByAccnt.aspx.cs" Inherits="Design_OPD_PaymentByAccnt" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Payment From Account</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Payment Detail
            </div>
            <table style="text-align: center; border-collapse: collapse">
                <tr>
                    <td style="width: 120px; text-align: right;">Expence Type :&nbsp;</td>
                    <td style="width: 300px; text-align: left;">
                        <asp:DropDownList ID="ddlExpenceType" runat="server" Width="146px"
                            AutoPostBack="True" TabIndex="1" ClientIDMode="Static"
                            OnSelectedIndexChanged="ddlExpenceType_SelectedIndexChanged">
                        </asp:DropDownList>
                        <span style="color: red; font-size: 10px;">*</span>
                    </td>
                    <td style="width: 120px; text-align: right;">Expence To :&nbsp;</td>
                    <td style="width: 300px; text-align: left;">
                        <asp:DropDownList ID="ddlExpenceTo" runat="server" Width="150px" TabIndex="2"
                            Visible="False" ClientIDMode="Static">
                        </asp:DropDownList>
                        
                        <asp:TextBox ID="txtExpenceType" runat="server" Visible="False" ClientIDMode="Static" MaxLength="50" TabIndex="2"></asp:TextBox>
                        <span style="color: red; font-size: 10px;">*</span>
                    </td>
                    <td>
                        <asp:Button ID="btnNewFile" runat="server" CssClass="ItDoseButton" Text="Add New Expense Head" />
                    </td>

                </tr>
                <tr>
                    <td style="text-align: right;">Amount :&nbsp;</td>
                    <td style="text-align: left;">
                        <asp:TextBox ID="txtAmount" runat="server" TabIndex="3" onkeypress="return checkForSecondDecimal(this,event)" ClientIDMode="Static" AutoCompleteType="Disabled"></asp:TextBox>
                        <span style="color: red; font-size: 10px;">*</span>
                        <cc1:FilteredTextBoxExtender ID="ftbAmt" runat="server" TargetControlID="txtAmount" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="text-align: right;">Approved By :&nbsp;</td>
                    <td style="text-align: left;">
                        <asp:DropDownList ID="ddlApprovedBy" runat="server" Width="150px" TabIndex="4" ClientIDMode="Static">
                        </asp:DropDownList>
                        <span style="color: red; font-size: 10px;">*</span>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;">Remarks :&nbsp;</td>
                    <td style="text-align: left;">
                        <asp:TextBox ID="txtRemarks" runat="server" Width="273px" MaxLength="50" TabIndex="5" ClientIDMode="Static"></asp:TextBox>
                    </td>
                    <td style="text-align: right;">&nbsp;</td>
                    <td style="text-align: left; display:none">
                        <asp:CheckBox ID="chkreceived" runat="server" Text="Received" ClientIDMode="Static"/></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnsave" runat="server" CssClass="ItDoseButton" OnClientClick="return validate(this)" ClientIDMode="Static"
                TabIndex="6" Text="Save" Enabled="False"
                OnClick="btnsave_Click" />
        </div>

    </div>
    <asp:Panel ID="pnlNfile" runat="server" CssClass="pnlFileFilter" Style="width: 380px;
        display: none">
        <div class="Purchaseheader" id="Div2" runat="server">
            Add Expense To:  </div> <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="text-align:right" >
                        Expense Type :&nbsp;
                    </td>
                    <td style="text-align:left">
                        <asp:DropDownList ID="ddlNfile" runat="server" Width="245px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        Expense&nbsp;To :&nbsp;
                    </td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtdispName" runat="server" CssClass="ItDoseTextinputText" Width="240px"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtdispName"
                            ErrorMessage="Specify File Name" Display="None" SetFocusOnError="True" ValidationGroup="NFile">*</asp:RequiredFieldValidator><br />
                    </td>
                </tr>                 
            </table>
       
        <div class="filterOpDiv">
            <asp:Button ID="btnFileSave" runat="server" CssClass="ItDoseButton" OnClick="btnFileSave_Click"
                Text="Save" ValidationGroup="NFile" Width="65px" />&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnFileCancel" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="btnFileCancel"
        DropShadow="true" TargetControlID="btnNewFile" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlNfile" PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>
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

        function validate(btn) {
            if ($("#ddlExpenceType").val() == "0") {
                $("#lblMsg").text('Please Select Expence Type');
                $("#ddlExpenceType").focus();
                return false;

            }
            if ($("#ddlExpenceTo").val() == "0" && $("#ddlExpenceType option:selected").text() != "Others") {
                $("#lblMsg").text('Please Select Expence To');
                $("#ddlExpenceTo").focus();
                return false;

            }
            if ($("#ddlExpenceType option:selected").text() == "Others" && $.trim($("#txtExpenceType").val()) == "") {

                $("#lblMsg").text('Please Enter Expence To');
                $("#txtExpenceType").focus();
                return false;
            }
            if (($.trim($("#txtAmount").val()) == "0") || ($.trim($("#txtAmount").val()) == "")) {
                $("#lblMsg").text('Please Enter Amount');
                $("#txtAmount").focus();
                return false;

            }
            if ($("#ddlApprovedBy").val() == "0") {
                $("#lblMsg").text('Please Select Approved By');
                $("#ddlApprovedBy").focus();
                return false;

            }
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnsave', '');
        }
    </script>
</asp:Content>
