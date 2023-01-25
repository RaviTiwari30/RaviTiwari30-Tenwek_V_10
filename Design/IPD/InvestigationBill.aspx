<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvestigationBill.aspx.cs" Inherits="Design_IPD_InvestigationBill" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            
                <div style="text-align: center;">
                    <b>Patient Investigation/Porcedure/Diet Bill</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div style="text-align:center">
                <table style="width:100%;display:none">
                    <tr>
                        <td style="margin-left:80px">
                              <asp:Label ID="lbltype" Text="Type :" runat="server"></asp:Label>
                <asp:CheckBox ID="chkissue" runat="server" Checked="true" Text="Issue" />
                <asp:CheckBox ID="chkreturn" runat="server" Text="Return " />
                        </td>
                    </tr>
                </table>
                <table style="width:100%">
                    <tr style="text-align:center">
                        <td  style="width:45%;text-align:right"></td>
                         <td style="text-align: center; width: 55%">
                            <asp:RadioButtonList ID="rblBillFormat" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                <asp:ListItem Value="0" Selected="True">PDF</asp:ListItem>
                                <asp:ListItem Value="1">Export(Word,Excel,PDF)</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        </tr>
                    <tr>
                        <td style="width:45%;text-align:right">
                            Bill Type :&nbsp;
                        </td>
                        <td style=" width:55%;text-align:left;">
                            <asp:DropDownList ID="ddlBillType" runat="server" Width="225px"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
              
            </div>
            `
        </div>
       <div class="POuter_Box_Inventory" style="text-align:center">
       <asp:Button ID="btnView" runat="server" Text="Search" CssClass="ItDoseButton" Width="60px" OnClick="btnView_Click" />
           </div>
    </div>

    </form>
</body>
</html>
