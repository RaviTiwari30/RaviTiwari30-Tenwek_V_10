<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Nursing_BloodTransfuse.aspx.cs"
    Inherits="Design_IPD_OrderSet_BloodTransfuse" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" id="styleSheet"/>
    
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js" ></script>
    <script type="text/javascript" >
        $(document).ready(function () {

            var width = window.screen.availWidth;
            var height = screen.height;

            if (screen.width > 1024) {

                $("link#styleSheet").attr("href", "../../../Styles/OrderSet_1366.css");
            }
            else if (screen.width <= 1024) {

                $("link#styleSheet").attr("href", "../../../Styles/OrderSet_1024.css");

            }
        });
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
        function checkForSecondslash(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


                if ((charCode == 47)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '/');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function validate() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style=" text-align: center">
            <b>&nbsp;Blood Transfusion Record</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                SECTION I:PRE-TRANSFUSION(COMPLETE SECTION PRIOR TO TRANSFUSION)
            </div>
            <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td align="right">
                        Date :
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtDateSection1" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDateSection1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtDateSection1">
                        </cc1:CalendarExtender>
                    </td>
                    <td align="right">
                        Time :
                    </td>
                    <td align="left" colspan="3">
                        <asp:TextBox ID="txtTimeSection1" Width="80px" runat="server"></asp:TextBox>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                        <cc1:MaskedEditExtender ID="masTimeSection1" Mask="99:99" runat="server" MaskType="Time"
                            TargetControlID="txtTimeSection1" AcceptAMPM="True">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTimeSection1" runat="server" ControlToValidate="txtTimeSection1"
                            ControlExtender="masTimeSection1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        REVIEW :
                    </td>
                    <td colspan="5" align="left">
                        <asp:CheckBoxList ID="chkReview" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
                            <asp:ListItem Text="Consent" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Written" Value="2"></asp:ListItem>
                            <asp:ListItem Text="D.Order" Value="3"></asp:ListItem>
                            <asp:ListItem Text="IV Access" Value="4"></asp:ListItem>
                            <asp:ListItem Text="Blood Tubing primed with Nacl 0.9%" Value="5"></asp:ListItem>
                        </asp:CheckBoxList>
                        <tr>
                            <td align="right">
                                BLOOD&nbsp;REQUESTED:
                            </td>
                            <td colspan="3" align="left">
                                <asp:CheckBoxList ID="chkBloodRequest" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Text="Autologous" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Hemologous" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Designated" Value="3"></asp:ListItem>
                                </asp:CheckBoxList>
                            </td>
                            <td align="right">
                                Donor&nbsp;Number&nbsp;
                            </td>
                            <td align="left">
                                <asp:TextBox ID="txtDonorNo" Width="100px" MaxLength="50" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                <tr>
                    <td colspan="4" align="left">
                        <asp:CheckBoxList ID="chkortho" runat="server" RepeatColumns="4" RepeatDirection="Horizontal"
                            RepeatLayout="Table">
                            <asp:ListItem Text="Ortho Pat" Value="1"> </asp:ListItem>
                            <asp:ListItem Text="Whole Blood" Value="2"> </asp:ListItem>
                            <asp:ListItem Text="Packed Cells" Value="3"> </asp:ListItem>
                            <asp:ListItem Text="Platelets" Value="4"> </asp:ListItem>
                        </asp:CheckBoxList>
                    </td>
                    <td align="right">
                        Exp.&nbsp;Date &nbsp;
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtExpdateSection1" Width="100px" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calExpdateSection1" runat="server" Format="dd-MMM-yyyy"
                            TargetControlID="txtExpdateSection1">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        &nbsp; &nbsp; &nbsp; Lot#&nbsp;&nbsp;<asp:TextBox ID="txtLot" Width="100px" MaxLength="50"
                            runat="server"></asp:TextBox>
                    </td>
                    <td colspan="3" align="left">
                        <asp:CheckBoxList ID="chkLot" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
                            <asp:ListItem Text="FFP" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Cryoprecipitate" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Other" Value="3"></asp:ListItem>
                        </asp:CheckBoxList>
                    </td>
                    <td align="right">
                        Patient&nbsp;Blood&nbsp;Group&nbsp;
                    </td>
                    <td align="left">
                        <%--<asp:TextBox ID="txtPatientBloodGroup" Width="100px" runat="server" MaxLength="50"></asp:TextBox>--%>
                        <asp:DropDownList ID="ddlPatientBloodGroup" runat="server" Width="106px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="2">
                        Exp.&nbsp;Date&nbsp;
                        <asp:TextBox ID="txtExpDate1" Width="100px" MaxLength="50" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calExpDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtExpDate1">
                        </cc1:CalendarExtender>
                    </td>
                    <td colspan="2">
                    </td>
                    <td align="right">
                        Rh&nbsp;
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtRH" Width="100px" MaxLength="50" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                    </td>
                    <td colspan="3" align="right">
                        Donor Blood Group&nbsp;
                    </td>
                    <td align="left">
                        <%--                        <asp:TextBox ID="txtDonorBloodGroup" MaxLength="50" Width="100px" runat="server"></asp:TextBox>
                        --%>
                        <asp:DropDownList ID="ddlDonorBloodGroup" runat="server" Width="106px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr align="left">
                    <td colspan="5" align="left">
                        <asp:CheckBoxList ID="chkVisual" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Visual appearance of blood product acceptable" Value="1"></asp:ListItem>
                            <asp:ListItem Text="unacceptable retum to Blood Bank" Value="2"></asp:ListItem>
                        </asp:CheckBoxList>
                    </td>
                    <td align="left">
                        Rh
                        <asp:TextBox ID="txtRH1" MaxLength="50" Width="80px" runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table >
                <tr>
                    <td>
                        <asp:CheckBox ID="chkPreTrans" runat="server" Text="Pre-Transfusion" />
                    </td>
                    <td>
                        B/P
                        <asp:TextBox ID="txtResp" MaxLength="7" onkeypress="return checkForSecondslash(this,event)"
                            runat="server" Width="60px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbResp" runat="server" ValidChars="0987654321/"
                            TargetControlID="txtResp">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td>
                        Temp
                        <asp:TextBox ID="txtTemp" MaxLength="5" onkeypress="return checkForSecondDecimal(this,event)"
                            runat="server" Width="60px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbtemp" runat="server" ValidChars=".0987654321"
                            TargetControlID="txtTemp">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td>
                        <asp:CheckBox ID="chlPreMed" runat="server" Text="Pre Med" />
                        <asp:TextBox ID="txtPreMed" MaxLength="50" runat="server" Width="100px"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: center">
            <div class="Purchaseheader">
                SECTION II: TRANSFUSION
            </div>
            <table class="style1">
                <tr>
                    <td colspan="3" align="right">
                        Blood product is initiated
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtBloodProductinitiated" Width="100px" MaxLength="50" runat="server"></asp:TextBox>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                        <cc1:MaskedEditExtender ID="masBloodIni" Mask="99:99" runat="server" MaskType="Time"
                            TargetControlID="txtBloodProductinitiated" AcceptAMPM="True">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskBloodini" runat="server" ControlToValidate="txtBloodProductinitiated"
                            ControlExtender="masBloodIni" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="3" align="right">
                        Blood product is terminated
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtBloodProductterminated" Width="100px" MaxLength="50" runat="server"></asp:TextBox>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                        <cc1:MaskedEditExtender ID="masBloodProduct" Mask="99:99" runat="server" MaskType="Time"
                            TargetControlID="txtBloodProductterminated" AcceptAMPM="True">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskBloodProduct" runat="server" ControlToValidate="txtBloodProductterminated"
                            ControlExtender="masBloodProduct" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="3" align="right">
                        Count
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtCount" onkeypress="return checkForSecondDecimal(this,event)"
                            MaxLength="5" Width="100px" runat="server"></asp:TextBox>
                        ml
                        <cc1:FilteredTextBoxExtender ID="fltCount" TargetControlID="txtCount" runat="server"
                            ValidChars=".0987654321">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" align="right">
                        Amount Absorbed
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtAmountAbsorbed" onkeypress="return checkForSecondDecimal(this,event)"
                            Width="100px" MaxLength="5" runat="server"></asp:TextBox>
                        ml
                        <cc1:FilteredTextBoxExtender ID="fltAmount" TargetControlID="txtAmountAbsorbed" runat="server"
                            ValidChars=".0987654321">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: center">
            <div class="Purchaseheader">
                SECTION III: POST-TRANSFUSION
            </div>
            <table class="style1">
                <tr>
                    <td align="right">
                        Date
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtDateSection3" Width="120px" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDateSection3" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtDateSection3">
                        </cc1:CalendarExtender>
                    </td>
                    <td align="right">
                        Time
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtTimeSection3" Width="120px" runat="server"></asp:TextBox>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                        <cc1:MaskedEditExtender ID="masTimesection3" Mask="99:99" runat="server" MaskType="Time"
                            TargetControlID="txtTimeSection3" AcceptAMPM="True">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTimeSection3"
                            ControlExtender="masTimesection3" IsValidEmpty="true" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <asp:CheckBox ID="chkNoReactionNoted" runat="server" Text="No Reaction Noted" />
                        <asp:CheckBox ID="chkAdverseReaction" runat="server" Text="Adverse Reaction Noted" />
                        <asp:CheckBox ID="chkTransfusionSlip" runat="server" Text="Transfusion slip completed and returned to Blood Bank" />
                    </td>
                </tr>
            </table>
            <table >
                <tr>
                    <td style="width: 54%">
                        <table border="1" style="width: 100%">
                            <tr>
                                <td colspan="2">
                                    <b>IF REACTION, COMPLETE BELOW:</b>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:CheckBox ID="chkReactionNotedAt" runat="server" Text="Reaction Noted At" />
                                </td>
                                <td align="left">
                                    <asp:TextBox ID="txtReactionNotedAt" Width="100px" MaxLength="50" runat="server"></asp:TextBox>
                                    <cc1:MaskedEditExtender ID="maskReaction" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtReactionNotedAt" AcceptAMPM="True">
                                    </cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="masReaction" runat="server" ControlToValidate="txtReactionNotedAt"
                                        ControlExtender="maskReaction" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:CheckBox ID="chkTransfusion" runat="server" Text="Transfusion discontinued" />
                                </td>
                                <td align="left">
                                    <asp:TextBox ID="txtTransfusion" Width="100px" MaxLength="50" runat="server"></asp:TextBox>
                                    <cc1:MaskedEditExtender ID="maskTransfusion" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtTransfusion" AcceptAMPM="True">
                                    </cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="mastransfusion" runat="server" ControlToValidate="txtTransfusion"
                                        ControlExtender="maskTransfusion" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:CheckBox ID="chkAmounttransfused" runat="server" Text="Amount transfused" />
                                </td>
                                <td align="left">
                                    <asp:TextBox ID="txtAmounttransfused" Width="100px" MaxLength="6" runat="server"></asp:TextBox>
                                    <cc1:MaskedEditExtender ID="masktrans" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtAmounttransfused" AcceptAMPM="True">
                                    </cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="mastrans" runat="server" ControlToValidate="txtAmounttransfused"
                                        ControlExtender="masktrans" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                    <asp:CheckBox ID="chkReIdentify" runat="server" Text="Re-identify patient/blood product/expiration date" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:CheckBox ID="chkMDNotify" runat="server" Text="MD notified" />
                                </td>
                                <td align="left">
                                    <asp:TextBox ID="txtPhy" Width="140px" MaxLength="100" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                    <asp:CheckBox ID="chkRemainderOfBlood" runat="server" Text="Remainder of blood product and completed reaction form sent to blood bank." />
                                </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                    <asp:CheckBox ID="chkUrinespecimen" runat="server" Text="Urine specimen for HGB analysis to hematology lab sent" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                    <asp:CheckBox ID="chkbloodred" runat="server" Text="blood in red top tube to Blood Bank sent" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                    <asp:CheckBox ID="chklavender" runat="server" Text="lavender top tube to Blood Bank sent." />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top" style="width: 46%">
                        <table border="1" style="width: 100%">
                            <tr>
                                <td colspan="2">
                                    <b>TYPE OF REACTION:</b>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:CheckBox ID="chkRash" runat="server" Text="rash" />
                                </td>
                                <td align="left">
                                    <asp:CheckBox ID="chkChangeTemp" runat="server" Text="change in temperature> 200" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:CheckBox ID="chkurticana" runat="server" Text="urticana" />
                                </td>
                                <td align="left">
                                    <asp:CheckBox ID="chknausea" runat="server" Text="nausea" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:CheckBox ID="chkbachache" runat="server" Text="bachache" />
                                </td>
                                <td align="left">
                                    <asp:CheckBox ID="chkchills" runat="server" Text="chills" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <asp:CheckBox ID="chkhemoglobinuria" runat="server" Text="hemoglobinuria" />
                                </td>
                                <td align="left">
                                    <asp:CheckBox ID="chkCtherspecifybelow" runat="server" Text="Cther -specify below" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server"  UseSubmitBehavior ="false" OnClientClick="validate();" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" />
        </div>
    </div>
    </form>
</body>
</html>
