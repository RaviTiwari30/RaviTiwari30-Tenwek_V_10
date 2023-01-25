<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UpdateAdmitDisDetails.aspx.cs"
    Inherits="Design_MRD_UpdateAdmitDetails" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript" src="../../Scripts/jquery-1.7.1.js"></script>
<script type="text/javascript" src="../../Scripts/Message.js"></script>
<link href="../../Styles/grid24.css" rel="stylesheet" />
<link href="../../Styles/framestyle.css" rel="stylesheet" />
<script type="text/javascript" src="../../Scripts/Common.js"></script>
<link href="../../Styles/CustomStyle.css" rel="stylesheet" />   


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
        if (($("#<%=txtWeight.ClientID%>").val().charAt(0) == ".")) {
            $("#<%=txtWeight.ClientID%>").val('');
            return false;
        }
        return true;
    }
    // $(document).ready(function () {
    //      if ($('input[id*=rbOthers]').is(":checked") == "true") {
    //          $("#<%=txtOthers.ClientID %>").removeAttr("disabled", "disabled");
    //      }
    //      else {
    //          $("#<%=txtOthers.ClientID %>").attr("disabled", "disabled");
    //      }

    //      $('#<%=rbAccident.ClientID%>').change(function () {
    //          if ($(this).is(':checked')) {
    //              $("#<%=txtOthers.ClientID %>").attr("disabled", "disabled");
    //          }
    //      });
    //  });
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="margin-top: 0px;">
            <Ajax:ScriptManager ID="sc" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Update Details </b>
                <br />
                <asp:Label ID="lblMSG" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" id="birth" runat="server" visble="false">
                <div class="Purchaseheader" style="display:none">
                    Delivery Detail
                </div>

                <div class="row" style="display:none">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Delivery</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTypeofDelivery" runat="server" Width="175px" TabIndex="1">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Deli(Weeks)</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlWeeks" runat="server" TabIndex="2">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Days</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDays" runat="server" TabIndex="3">
                            </asp:DropDownList>
                        </div>
                            </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Weight</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtWeight" runat="server"  onkeypress="return checkForSecondDecimal(this,event)"
                                    onkeyup="validatedot();" MaxLength="3" CssClass="ItDoseTextinputNum" TabIndex="4"></asp:TextBox>
                            </div>
                            <div class="col-md-2">
                                <asp:DropDownList ID="ddlWeight" runat="server"  TabIndex="5">
                                    <asp:ListItem Selected="True" Value="KG">KG</asp:ListItem>
                                    <asp:ListItem Value="Lb">Lb</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Age</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtAge" runat="server" MaxLength="4" ToolTip="Enter Age"
                                    onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlAge" runat="server"  OnChange="validateAge();">
                                    <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                    <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                    <asp:ListItem>DAYS(S)</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row" style="text-align: center">

                            <asp:Button ID="btnBirthUpdate" runat="server" Text="Update Birth Detail" OnClick="btnBirthUpdate_Click"
                                TabIndex="8" CssClass="ItDoseButton" />
                        </div>
                        </div>
                    <div class="col-md-1"></div>

                </div>





            </div>
            <asp:Panel ID="pnl" runat="server" Visible="false">
            </asp:Panel>
            <div class="POuter_Box_Inventory" id="Death" runat="server">
                <div class="Purchaseheader" id="DeathDetails" runat="server">
                    Update Death Details&nbsp;
                </div>
                <table style="width: 930px">
                    <tr>
                        <td style="width: 200px; text-align: right;">
                            <asp:Label ID="lblDischarge" Text="Discharge Type :" runat="server"></asp:Label>
                        </td>
                        <td style="width: 400px; text-align: left;">
                            <%--<asp:DropDownList ID="ddlType" runat="server" Width="175px" 
                                TabIndex="9" />--%>
                            <asp:Label ID="lblDischargeType" runat="server"></asp:Label>
                        </td>
                        <td style="width: 200px; text-align: right;">
                            <asp:Label ID="lblDateofdeath" runat="server" Text="Date Of Death :"></asp:Label>
                        </td>
                        <td style="width: 300px; text-align: left;">
                            <asp:TextBox ID="EntryDateDeath" runat="server" Width="170px" ToolTip="Select Date Of Death"
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDateDeath">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 200px; text-align: right;">
                            <asp:Label ID="lblTime" runat="server" Text="Time Of Death :"></asp:Label>
                        </td>
                        <td style="width: 400px; text-align: left;">
                            <asp:TextBox ID="txtDeathTime" runat="server" ToolTip="Enter Time Of Death" TabIndex="2"
                                Width="72px" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtDeathTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="MskD" runat="server" ControlToValidate="txtDeathTime"
                                ControlExtender="MaskedEditExtender1" ValidationGroup="Death" IsValidEmpty="true"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                            <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                        </td>
                        <td style="width: 200px; text-align: right">
                            <asp:Label ID="lblCauseOfDeath" runat="server" Text="Cause Of Death :"></asp:Label>
                        </td>
                        <td style="width: 300px; text-align: left">
                            <asp:TextBox ID="txtcauseOfDeath" runat="server" ToolTip="Enter Cause of Death" Width="170px"
                                TabIndex="3" AutoCompleteType="Disabled" MaxLength="50" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 200px; text-align: right">
                            <asp:Label ID="lblremarks" runat="server" Text="Remarks :"></asp:Label>
                        </td>
                        <td style="width: 400px; text-align: left">
                            <asp:TextBox ID="txtRemarks" runat="server" ToolTip="Enter Remarks" Width="170px"
                                TabIndex="4" MaxLength="50" AutoCompleteType="Disabled" />
                        </td>
                        <td style="width: 200px; text-align: right">
                            <asp:Label ID="lbltypeOfDeath" runat="server" Text="Type Of Death :"></asp:Label>
                        </td>
                        <td style="width: 300px; text-align: left">
                            <asp:DropDownList ID="ddltypeOfDeath" runat="server" Width="175px" TabIndex="5" ToolTip="Select Type Of Death">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 200px; text-align: right"></td>
                        <td style="width: 300px; text-align: left">
                            <asp:CheckBox ID="chkDeathover48hrs" runat="server" Text="Death over 48 hrs" TabIndex="6" />
                        </td>
                        <td style="width: 200px"></td>
                        <td style="width: 300px"></td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: right; text-align: center;">
                            <asp:Button ID="btnDeathDetail" runat="server" Text="Update Death Detail" OnClick="btnDeathDetail_Click"
                                CssClass="ItDoseButton" ValidationGroup="Death" TabIndex="7" ToolTip="Click to Update Death Detail" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" id="Mlc" runat="server">
                <div class="Purchaseheader" id="MLCDetails" runat="server">
                    Update MLC Details&nbsp;
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row" style="display:none;">
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButton ID="rbAccident" runat="server" GroupName="B" Text="Accident"
                                    Width="66px" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    MLC Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtAccidentDate" runat="server" Width="" TabIndex="8"
                                    ToolTip="Select MLC Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy"
                                    TargetControlID="txtAccidentDate">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblTimeMLC" runat="server" Text="MLC Time "></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtMlcTime" runat="server" TabIndex="10" ToolTip="Enter MLC Time"
                                    Width="" />
                                <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                    TargetControlID="txtMlcTime">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtMlcTime"
                                    ControlExtender="masTime" IsValidEmpty="false" InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblMLCNo" runat="server" Text="MLC No."> </asp:Label>&nbsp;
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                               
                                <asp:TextBox ID="txtMlcNo" runat="server" ToolTip="Enter MLC No." Width="" TabIndex="9"
                                    MaxLength="15"></asp:TextBox>
                                </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlMLCType" runat="server">
                                   <asp:ListItem>Select</asp:ListItem>
                                      <asp:ListItem Value="0">RTA</asp:ListItem>
                                      <asp:ListItem Value="Poisoining">Poisoining</asp:ListItem>
                                      <asp:ListItem Value="Burns">Burns</asp:ListItem>
                                      <asp:ListItem Value="Hanging" >Hanging</asp:ListItem>
                                      <asp:ListItem Value="Assaults">Assaults</asp:ListItem>
                                   </asp:DropDownList>
                            </div>
                            
        </div>
        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblPCNo" runat="server" Text=" PC No. :"> </asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPcNo" runat="server" ToolTip="Enter PC No." AutoCompleteType="Disabled"
                                    Width="" TabIndex="11" MaxLength="50"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblLocation" runat="server" Text="Location"> </asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtAccLocation" TabIndex="12" ToolTip="Enter Location" MaxLength="50"
                                    runat="server" Width="" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblBroughtBy" runat="server" Text=" Brought By"> </asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBroughtby" runat="server" ToolTip="Enter Brought By" Width=""
                                    TabIndex="21" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                               <%-- <asp:RadioButton ID="rbOthers" runat="server" TabIndex="13" GroupName="B" Text="Others"
                                    Width="" />--%>
                                <label class="pull-left">
                                    <asp:Label ID="lblOthers" runat="server" Text="Others"> </asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtOthers" runat="server" ToolTip="Enter Others" TabIndex="14" MaxLength="50"
                                    Width="" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row" style="text-align: center;">
                            <asp:Button ID="btnMLCDetail" runat="server" Text="Update MLC Detail" OnClick="btnMLCDetail_Click"
                                TabIndex="15" CssClass="ItDoseButton" ToolTip="Click to Update MLC Detail" />
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
