<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeathCertificate.aspx.cs" Inherits="Design_IPD_DeathCertificate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script>
        $(document).ready(function () {
            $("#txtDeathNature,#spnDeathNature").hide();
            if($("#txtDeathNature").val()!="")
            {
                if (($("#ddlDeathNature").find("[value='" + $.trim($("#txtDeathNature").val()) + "']").length) > 0) {
                    $("#ddlDeathNature").val($.trim($("#txtDeathNature").val()));
                }
                else {
                    $("#ddlDeathNature").val('Other');
                    $("#txtDeathNature,#spnDeathNature").show();
                }
            }
        });
        function checkNature() {
            if ($("#ddlDeathNature").val() == "Other") {
                $("#txtDeathNature,#spnDeathNature").show();
                $("#txtDeathNature").val('');
            }
            else {
                $("#txtDeathNature,#spnDeathNature").hide();
                debugger;
                $("#txtDeathNature").val($("#ddlDeathNature").val());
            }

        }
        function validate() {
            if ($("#ddlDeathNature").val() == "") {
                $("#lblMsg").text('Please Select Nature Of Death');
                $("#ddlDeathNature").focus();
                return false;
            }
            else {
                if ($("#ddlDeathNature").val() == "Other" && $("#txtDeathNature").val() == "") {
                    $("#lblMsg").text('Please Enter Nature Of Death');
                    $("#txtDeathNature").focus();
                    return false;
                }
            }
            if ($("#txtDeathCause").val()=="")
            {
                $("#lblMsg").text('Please Enter Cause Of Death');
                $("#txtDeathCause").focus();
                return false;
            }
            if ($("#ddlCertifiedDoctor").val() == "0") {
                $("#lblMsg").text('Please Select Death Certified  by Doctor');
                $("#ddlCertifiedDoctor").focus();
                return false;
            }
            if ($("#txtBodyHandOvered").val() == "") {
                $("#lblMsg").text('Please Enter Body Hand Overed to Name');
                $("#txtBodyHandOvered").focus();
                return false;
            }
            return true;
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">


            <div class="POuter_Box_Inventory">
                <div style="text-align: center">
                    <b>Death Certificate Entry</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                </div>
            </div>
            <div class="POuter_Box_Inventory">

                <table style="width: 100%">
                    <tr>
                        <td style="text-align: right; vertical-align: top;">Nature Of Death :
                        </td>
                        <td style="text-align: left;">
                            <asp:DropDownList ID="ddlDeathNature" runat="server" Width="205px" onchange="checkNature()" ClientIDMode="Static" TabIndex="1">
                                <asp:ListItem Text="Select" Selected="True" Value=""></asp:ListItem>
                                <asp:ListItem Text="Natural" Value="Natural"></asp:ListItem>
                                <asp:ListItem Text="Accident" Value="Accident"></asp:ListItem>
                                <asp:ListItem Text="Suicide" Value="Suicide"></asp:ListItem>
                                <asp:ListItem Text="Undetermined" Value="Undetermined"></asp:ListItem>
                                <asp:ListItem Text="Other" Value="Other"></asp:ListItem>
                            </asp:DropDownList><span style="color: red">*</span>
                            <br />
                            <asp:TextBox ID="txtDeathNature" runat="server" Width="200px" ClientIDMode="Static" ToolTip="Enter Death Nature" TabIndex="2"></asp:TextBox><span id="spnDeathNature" style="color: red">*</span>
                        </td>
                        <td style="text-align: right; vertical-align: top;">Cause of Death :
                        </td>
                        <td style="text-align: left; vertical-align: top;">
                            <asp:TextBox ID="txtDeathCause" runat="server" Width="200px" MaxLength="100" TabIndex="3" ClientIDMode="Static"></asp:TextBox><span style="color: red">*</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">Pronounce Dead At :
                        </td>
                        <td style="text-align: left;">
                            <asp:TextBox ID="txtPronounceDate" runat="server" Width="120px" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtPronounceDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="txtPronounceTime" runat="server" Width="70px" MaxLength="10" TabIndex="5" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                            <cc1:MaskedEditExtender ID="masTime" runat="server" TargetControlID="txtPronounceTime" MaskType="Time" AcceptAMPM="true" Mask="99:99"></cc1:MaskedEditExtender>

                        </td>
                        <td style="text-align: right;">Estimated Time of Death :
                        </td>
                        <td style="text-align: left;">
                            <asp:TextBox ID="txtDeathDate" runat="server" Width="120px" ClientIDMode="Static" TabIndex="6"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDeathDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="txtDeathTime" runat="server" Width="70px" MaxLength="10" TabIndex="7" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtDeathTime" MaskType="Time" AcceptAMPM="true" Mask="99:99"></cc1:MaskedEditExtender>

                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">Death Certified By :
                        </td>
                        <td style="text-align: left;">
                            <asp:DropDownList ID="ddlCertifiedDoctor" runat="server" Width="205px" TabIndex="8" ClientIDMode="Static" >
                            </asp:DropDownList><span style="color: red">*</span>
                        </td>
                        <td style="text-align:right">
                            Body Hand Overed To :
                        </td>
                        <td style="text-align:left;">
                            <asp:TextBox ID="txtBodyHandOvered" runat="server" Width="200px" MaxLength="100" ClientIDMode="Static" TabIndex="9"></asp:TextBox><span style="color: red">*</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static" TabIndex="10" OnClick="btnSave_Click" OnClientClick="return validate();" />
                            <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" ClientIDMode="Static" TabIndex="11" OnClick="btnPrint_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
