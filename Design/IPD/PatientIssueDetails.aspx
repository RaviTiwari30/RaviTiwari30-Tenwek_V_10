<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="PatientIssueDetails.aspx.cs" Inherits="Design_IPD_PatientIssueDetails" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
        <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />

</head>
    
<body>
     <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ak" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            
                <div style="text-align: center;">
                    <b>Patient Medical Issue Report</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div style="text-align:center">
                <table style="width:100%">
                    <tr>
                        <td style="margin-left:80px">
                              <asp:Label ID="lbltype" Text="Type :" runat="server"></asp:Label>
                <asp:CheckBox ID="chkissue" runat="server" Checked="true" Text="Issue" />
                <asp:CheckBox ID="chkreturn" runat="server" Text="Return " />
                        </td>
                    </tr>
                </table>
              
            </div>
            
        </div>
       <div class="POuter_Box_Inventory" style="text-align:center">
                            <asp:Button ID="btnView" runat="server" Text="Search" CssClass="ItDoseButton" Width="60px" OnClick="btnView_Click" />

           </div>
    </div>


         </form>
</body>
</html>