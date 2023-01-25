<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmergencyComplaint.aspx.cs" Inherits="Design_Emergency_EmergencyComplaint" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
     <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />

    <script type="text/javascript">
        function Check(textBox, maxLength) {
            if (textBox.value.length > maxLength) {
                $("#<%=lblMsg.ClientID%>").text("You cannot enter more than " + maxLength + " characters.");
                textBox.value = textBox.value.substr(0, maxLength);
            }
        }

        function validate() {
            if ($.trim($("#<%=txtComplaint.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Chief Complaint');
                $("#<%=txtComplaint.ClientID%>").focus();
                return false;
            }
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }

    </script>
</head>
<body>
    <form id="form2" runat="server">
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Chief Compalint</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                  Chief Complaint
                </div>
                <table style="width: 100%; border-collapse: collapse;">
                    
                    <tr>
                        <td>
                            <asp:TextBox ID="txtComplaint" CssClass="requiredField" runat="server" TextMode="MultiLine" Height="70px" Width="560px" onkeyup="javascript:Check(this, 100);" onchange="javascript:Check(this, 100);"></asp:TextBox>
                            
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" OnClientClick="return validate()"/>
            </div>

        </div>

    </form>
</body>
</html>

