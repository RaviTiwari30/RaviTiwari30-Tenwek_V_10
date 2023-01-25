<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PharmacyInvoice.aspx.cs" Inherits="Design_IPD_PharmacyInvoice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">


                <b>Patient Pharmacy Report</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>


            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnReport_Click" />

            </div>
        </div>
    </form>
</body>
</html>
