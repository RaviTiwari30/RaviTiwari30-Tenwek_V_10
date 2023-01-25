<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Document_downloads.aspx.cs"    Inherits="Document_downloads" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            color: #800000;
        }
        .style2
        {
            color: #003399;
            text-align: left;
        }
        .style3
        {
            text-align: left;
        }
    
.ItDoseLblError{color:red; font-size:9pt; font-family:Verdana, Arial, sans-serif, sans-serif; font-weight:bold }

        .style4
        {
            width: 239px;
        }
        .style5
        {
            text-align: left;
            }

        .style6
        {
            font-size: small;
            font-family: Arial, Helvetica, sans-serif;
        }
        .style7
        {
            text-align: right;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table style="width: 100%; background-image:url(Images/brush.jpg)">
            <tr>
                <td class="style1" colspan="2" style="text-align: center">
                    <strong>Download User Manuals</strong>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td class="style2" colspan="2">
                    <strong style="text-align: left">HIS User Manuals</strong> (<span class="style1"><strong>Note:</strong></span> Click On Module To Download User Manual.)</td>
            </tr>
            <tr>
                <td class="style2" colspan="2">
                    &nbsp;</td>
            </tr>
            <tr>
                <td style="text-align: left" class="style4">
                    <asp:LinkButton ID="lnkOPD" runat="server"  onclick="lnkOPD_Click">OPD Module</asp:LinkButton>
                    &nbsp;&nbsp;&nbsp;
                    <asp:ImageButton ID="imgVideo" Visible="false" runat="server" ImageUrl="Images/Video (.ico" Width="20" AlternateText="Click To Download Video Manual" OnClick="imgVideo_Click" />

                        

                </td>
                <td rowspan="9">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"/>
                    <br />
                </td>
            </tr>
            <tr>
                <td class="style5">
                    <asp:LinkButton ID="lnkCPOE" runat="server" onclick="lnkCPOE_Click" 
                        >CPOE Module</asp:LinkButton>
                </td>
            </tr>
            <tr style="display:none">
                <td class="style5" style="display:none">
                    <asp:LinkButton ID="lnkPharmacy" runat="server" onclick="lnkPharmacy_Click">Pharmacy Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style5">
                    <asp:LinkButton ID="lnkMedical" runat="server" onclick="lnkMedical_Click">Medical Store Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style5">
                    <asp:LinkButton ID="lnkGeneral" runat="server" onclick="lnkGeneral_Click">General Store Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style5">
                    <asp:LinkButton ID="lnkPurchase" runat="server" onclick="lnkPurchase_Click">Purchase Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style5">
                    <asp:LinkButton ID="lnkBilling" runat="server" onclick="lnkBilling_Click">Billing Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style5">
                    <asp:LinkButton ID="lnkLaboratory" runat="server" onclick="lnkLaboratory_Click">Laboratory Module</asp:LinkButton>
                </td>
            </tr>
            <tr style="display:none">
                <td class="style5">
                    <asp:LinkButton ID="lnkRadiology" runat="server" onclick="lnkRadiology_Click">Radiology Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style3" colspan="2">
                    <asp:LinkButton ID="lnkMRD" runat="server" onclick="lnkMRD_Click" >MRD Module</asp:LinkButton>
                </td>
            </tr>
            <tr style="display:none">
                <td class="style3" colspan="2">
                    <asp:LinkButton ID="lnkPayroll" runat="server" onclick="lnkPayroll_Click">Payroll Module</asp:LinkButton>
                </td>
            </tr>
            <tr style="display:none">
                <td class="style3" colspan="2">
                    <asp:LinkButton ID="lnkHR" runat="server" onclick="lnkHR_Click">HR Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:LinkButton ID="lnkMIS" runat="server" onclick="lnkMIS_Click">MIS Module</asp:LinkButton>
                </td>
                <td class="style7">
                    &nbsp;</td>
            </tr>
            <tr style="display:none">
                <td class="style3" colspan="2">
                    <asp:LinkButton ID="lnkAdmissionDischarge" runat="server" 
                        onclick="lnkAdmissionDischarge_Click">Admission-Discharge Transfer Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style5" colspan="2">
                    <asp:LinkButton ID="lnkEMR" runat="server" onclick="lnkEMR_Click">EMR Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style3" colspan="2">
                    <asp:LinkButton ID="lnkEDP" runat="server" onclick="lnkEDP_Click">EDP Module</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td class="style3" colspan="2">
                    <asp:LinkButton ID="lnkNursing" runat="server" onclick="lnkNursing_Click">Nursing Ward Module</asp:LinkButton>
                </td>
            </tr>
            <tr style="display:none">
                <td class="style3" colspan="2">
                    <asp:LinkButton ID="lnkBloodBank" runat="server" onclick="lnkBloodBank_Click">Blood Bank Module</asp:LinkButton>
                </td>
            </tr>
            <tr style="display:none">
                <td class="style3" colspan="2">
                    <asp:LinkButton ID="lnkCSSD" runat="server" onclick="lnkCSSD_Click">CSSD Module</asp:LinkButton>
                </td>
            </tr>
            <tr style="display:none">
                <td colspan="2" style="text-align: left">
                    &nbsp;</td>
            </tr>
            <tr style="display:none">
                <td colspan="2" style="text-align: left">
                    &nbsp;</td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
