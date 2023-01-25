<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BillFinalised.aspx.cs" Inherits="Design_dup_d_IPDItemDiscount" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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


        function confirm_Bill() {
            if (confirm("Are you sure you want to Generate Bill ??") == true)
                return true;
            else
                return false;
        }



    </script>
</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Bill Finalised</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <table style="width: 80%">
                    <tr>
                        <td style="width: 25%; text-align: right">UHID :&nbsp;</td>
                        <td style="width: 25%; text-align: left">
                            <asp:Label ID="lblPID" runat="server" CssClass="ItDoseLabelSp" /></td>
                        <td style="width: 25%; text-align: right">Bill Amount :</td>
                        <td style="width: 25%; text-align: left">
                            <asp:Label ID="lblBillAmount" runat="server" CssClass="ItDoseLabelSp" /></td>
                    </tr>
                    <tr>
                        <td style="width: 25%; text-align: right">IPD No. :</td>
                        <td style="width: 25%; text-align: left">
                            <asp:Label ID="lblTID" runat="server" CssClass="ItDoseLabelSp" /></td>
                        <td style="width: 25%; text-align: right">Paid Amount :</td>
                        <td style="width: 25%; text-align: left">
                            <asp:Label ID="lblPaidAmount" runat="server" CssClass="ItDoseLabelSp" /></td>

                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnGenerateBill" runat="server" CssClass="ItDoseButton" OnClick="btnGenerateBill_Click"
                    OnClientClick="return confirm('No More Editing will be Possible. Are you sure you want to Finalize this Bill ??');" Text="Finalize Bill" />                       
            </div>

        </div>



    </form>
</body>
</html>
