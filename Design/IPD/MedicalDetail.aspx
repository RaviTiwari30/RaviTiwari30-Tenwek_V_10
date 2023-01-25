<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicalDetail.aspx.cs" Inherits="Design_EMR_MedicalDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript" ></script>
    <script type="text/javascript" >
        $(document).ready(function () {
            $('[id$=chkSuppressReceipt]').click(function () {
                $("[id$=chkSelect]").attr('checked', this.checked);
            });
            $("[id$=chkSelect]").click(function () {
                if ($('[id$=chkSelect]').length == $('[id$=chkSelect]:checked').length) {
                    $('[id$=chkSuppressReceipt]').attr("checked", "checked");
                }
                else {
                    $('[id$=chkSuppressReceipt]').removeAttr("checked");
                }
            });
        });

    </script>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Patient Bill Print</b>
            </div>
        </div>
       
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                &nbsp;<br />
                <br />
                &nbsp;&nbsp;
                <asp:Button ID="btnDetailBill" runat="server" OnClick="btnDetailBill_Click" Text="Detailed Bill"
                    CssClass="ItDoseButton" />
                &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
            </div>
        </div>
    </div>
    </form>
</body>
</html>
