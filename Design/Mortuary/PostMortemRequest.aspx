<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PostMortemRequest.aspx.cs" Inherits="Design_Mortuary_PostMortemRequest" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="ucTime" TagName="Time" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#txtPostTime_txtTime").attr("tabindex", "3");
            $("#")
        });

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
</head>
<body style="font-size: 10pt">
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>POST-MORTEM REQUEST TO PATHOLOGIST</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <table style="width: 100%">
                    <tr>
                        <td>Doctor
                            Name:</td>
                        <td>
                            <asp:TextBox ID="txtName" runat="server" Width="250px" TabIndex="1" ClientIDMode="Static" ToolTip="Enter Doctor Name" onkeypress="return check(this,event)"></asp:TextBox>
                            <span style="color: red; font-size: 10px;">*</span>
                        </td>
                        <td>Location:</td>
                        <td>
                            <asp:TextBox ID="txtLocation" runat="server" Width="250px" TabIndex="2" ToolTip="Enter Location Name" ClientIDMode="Static" onkeypress="return check(this,event)"></asp:TextBox>
                            <span style="color: red; font-size: 10px;">*</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Postmortem Date:</td>
                        <td>
                            <asp:TextBox ID="txtPostDate" runat="server" Width="100px" TabIndex="3" ToolTip="Click To Select Date"></asp:TextBox>
                            <span style="color: red; font-size: 10px;">*</span>
                            <cc1:CalendarExtender ID="calPostDate" runat="server" TargetControlID="txtPostDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td>Postmortem Time:</td>
                        <td>
                            <ucTime:Time ID="txtPostTime" TabIndex="4" runat="server" />
                            <span style="color: red; font-size: 10px;">*</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">&nbsp;</td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" TabIndex="5" OnClick="btnSave_Click" />
                <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton" Text="Update" TabIndex="5" OnClick="btnUpdate_Click" />
            </div>
        </div>
    </form>
</body>
</html>
