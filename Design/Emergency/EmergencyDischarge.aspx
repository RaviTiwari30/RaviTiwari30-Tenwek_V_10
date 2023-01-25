<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmergencyDischarge.aspx.cs" Inherits="Design_Emergency_EmergencyDischarge" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>

<%@ Register Src="~/Design/Controls/wuc_IPDBillDetail.ascx" TagName="IPDBillDetail" TagPrefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>

</head>
<body>
    <script type="text/javascript">
        if ($.browser.msie) {
            $(document).on("keydown", function (e) {
                var doPrevent;
                if (e.keyCode == 8) {
                    var d = e.srcElement || e.target;
                    if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                        doPrevent = d.readOnly
                            || d.disabled;
                    }
                    else
                        doPrevent = true;
                }
                else
                    doPrevent = false;
                if (doPrevent) {
                    e.preventDefault();
                }
            });
        }
        function disableButton(btn) {
            if ($.trim($("#txtDate").val()) == "") {
                $("#lblMsg").text('Please Select Date');
                $("#txtDate").focus();
                return false;
            }
            if ($.trim($("#txtTime").val()) == "") {
                $("#lblMsg").text('Please Enter Time');
                $("#txtTime").focus();
                return false;
            }

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnDischarge');

        }
    </script>

    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Emergency Patient Discharge</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">

                <asp:Label ID="lblTID" runat="server" Style="display: none"></asp:Label>

                <table style="border-collapse: collapse; width: 100%">
                    <tr>
                        <td style="width: 16%; text-align: right">Discharge :&nbsp;
                        </td>
                        <td style="width: 26%; text-align: left">
                            <asp:DropDownList ID="ddlType" runat="server" Width="200px" AutoPostBack="false" TabIndex="1">
                                <asp:ListItem>Normal</asp:ListItem>
                                <asp:ListItem>Referal</asp:ListItem>
                                <asp:ListItem>Death</asp:ListItem>
                                <asp:ListItem>Leave Against Medical Advice</asp:ListItem>
                                <asp:ListItem>Transfer</asp:ListItem>
                                <asp:ListItem>Left without being seen.</asp:ListItem>

                            </asp:DropDownList>
                        </td>
                        <td style="width: 20%; text-align: right;"></td>
                        <td style="width: 38%"></td>
                    </tr>
                    <tr>
                        <td style="width: 16%; text-align: right">Date :&nbsp;
                        </td>
                        <td style="width: 26%; text-align: left">
                            <asp:TextBox ID="txtDate" runat="server"
                                ToolTip="Click To Select Date" Width="100px" TabIndex="2"
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 20%; text-align: right;">Time :
                        </td>
                        <td style="width: 38%; text-align: left">

                            <asp:TextBox ID="txtTime" ClientIDMode="Static" Width="64px" runat="server" TabIndex="3"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:Button ID="btnDischarge" ClientIDMode="Static" runat="server" OnClick="btnDischarge_Click" Text="Discharge"
                    CssClass="ItDoseButton" TabIndex="4" OnClientClick="return disableButton(this)" />

            </div>

        </div>

    </form>
</body>
</html>
