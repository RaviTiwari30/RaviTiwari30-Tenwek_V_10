<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MortuaryReceipt.aspx.cs" Inherits="Design_Mortuary_MortuaryReceipt"
    Culture="auto" StylesheetTheme="Theme1" meta:resourcekey="PageResource1" UICulture="auto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript">
        function printpage() {

        }
    </script>
    <link href="../../App_Themes/Theme1/mm.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .auto-style1 {
            width: 40%;
            border-top: 1px solid #000000;
            border-bottom: 1px solid #000000;
        }

        .auto-style2 {
            height: 20px;
            width: 52%;
            border-top: 1px solid #000000;
            border-bottom: 1px solid #000000;
        }

        .auto-style3 {
            width: 11%;
            height: 18px;
        }

        .auto-style4 {
            width: 2%;
            height: 18px;
        }

        .auto-style5 {
            width: 38%;
            height: 18px;
        }

        .auto-style6 {
            height: 20px;
            width: 46%;
        }
    </style>
</head>
<body onload="printpage();">
    <form id="form1" runat="server">
        <div>
            <table style="width: 722px;">
                <tr>
                    <td>
                        <table style="width: 730px; margin-left: 5px; margin-right: -50px; border-collapse: collapse" class='textreceipt'>
                            <tr>
                                <td style="text-align: center; width: 100%" colspan="6">
                                    <table border="0" style="width: 100%; border-collapse: collapse">
                                        <tr>
                                            <td style="text-align: left; vertical-align: top">
                                                <asp:Label ID="lblHeaderText" runat="server" meta:resourcekey="lblHeaderTextResource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100%; height: 22px; vertical-align: bottom; text-align: center">


                                                <asp:Label ID="lblrefund" Font-Size="12pt" Font-Underline="True" Font-Bold="True" runat="server" Visible="False" meta:resourcekey="lblrefundResource1">Refund Mortuary Receipt</asp:Label>
                                                <asp:Label ID="lblHeader" Font-Size="12pt" Font-Underline="True" Font-Bold="True" runat="server" meta:resourcekey="lblHeaderResource1">Mortuary Receipt</asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table style="width: 100%; border-collapse: collapse">
                            <tr style="font-size: 12pt">
                                <td style="vertical-align: top; width: 10%;">
                                    <asp:Label ID="lblName" runat="server" Text="Name" meta:resourcekey="lblNameResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%;">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top; width: 38%;">
                                    <asp:Label ID="LblCorpseName" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="False" meta:resourcekey="LblPatientNameResource1"></asp:Label></td>
                                <td style="vertical-align: top; width: 10%;">
                                    <asp:Label ID="lbldatetime" runat="server" Text="Date/Time" meta:resourcekey="lbldatetimeResource1"></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 2%;">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top; width: 38%;">
                                    <asp:Label ID="LblDate" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="LblDateResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr style="font-size: 12pt;">
                                <td style="vertical-align: top;" class="auto-style3">
                                    <asp:Label ID="lblsex" runat="server" Text="Age/Sex" meta:resourcekey="lblsexResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top;" class="auto-style4">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top;" class="auto-style5">
                                    <asp:Label ID="LblAgeSex" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="LblAgeSexResource1"></asp:Label></td>
                                <td style="vertical-align: top;" class="auto-style3">
                                    <asp:Label ID="lblFreezerNo" runat="server" Text="Freezer No." meta:resourcekey="lblBedNo1Resource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top;" class="auto-style4">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top;" class="auto-style5">
                                    <asp:Label ID="LblBedno" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="False" meta:resourcekey="LblBednoResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top; width: 10%;">
                                    <asp:Label ID="lblMrNo" runat="server" Text="Corpse No." meta:resourcekey="lblMrNoResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%;">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top; width: 38%; height: 14px">
                                    <asp:Label ID="LblRegNo" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="LblRegNoResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 10%;">
                                    <asp:Label ID="lblReceipt" runat="server" Text="Receipt No."></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 2%;">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top; width: 38%;">
                                    <asp:Label ID="LblReceiptNo" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="False" meta:resourcekey="LblReceiptNoResource1"></asp:Label></td>
                            </tr>
                            <tr style="font-size: 12pt;">
                                <td style="vertical-align: top;" class="auto-style3">
                                    <asp:Label ID="lblAddress1" runat="server" Text="Address" meta:resourcekey="lblAddress1Resource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top;" class="auto-style4">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top;" class="auto-style5">
                                    <asp:Label ID="LblAddress" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="LblAddressResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top;" class="auto-style3">
                                    <asp:Label ID="lbldoctor" runat="server" Text="Doctor" meta:resourcekey="lbldoctorResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top;" class="auto-style4">
                                    <strong>:</strong>
                                </td>
                                <td style="vertical-align: top;" class="auto-style5">
                                    <asp:Label ID="LblDoctorName" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="False" meta:resourcekey="LblDoctorNameResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr style="font-size: 12pt;">
                                <td style="vertical-align: top;" class="auto-style3">
                                    <asp:Label ID="lblIPDNo" runat="server" Text="Deposite No." meta:resourcekey="lblIPDNoResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top;" class="auto-style4">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top;" class="auto-style5">
                                    <asp:Label ID="LblCrNo" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="LblCrNoResource1"></asp:Label></td>
                                <td style="vertical-align: top;" class="auto-style3"></td>
                                <td style="vertical-align: top;" class="auto-style4">
                                    <strong></strong>
                                </td>
                                <td style="vertical-align: top;" class="auto-style5"></td>
                            </tr>
                            <tr style="display: none;">
                                <td style="vertical-align: top; width: 10%;">
                                    <span>
                                        <asp:Label ID="lblPanelHead" runat="server" meta:resourcekey="lblPanelHeadResource1"></asp:Label></span>
                                </td>
                                <td style="vertical-align: top; width: 2%;">&nbsp;</td>
                                <td style="vertical-align: top; width: 38%;">
                                    <asp:Label ID="lblPanelName" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="9pt" meta:resourcekey="lblPanelNameResource1"></asp:Label>
                                    <asp:Label ID="lblMobile" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="lblMobileResource1"></asp:Label>
                                    <asp:Label ID="lblcono" runat="server" Text="Contact&nbsp;No." meta:resourcekey="lblconoResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 10%;">&nbsp;</td>
                                <td style="vertical-align: top; width: 2%;">&nbsp;</td>
                                <td style="vertical-align: top; width: 38%;">&nbsp;</td>
                            </tr>
                        </table>
                        <table style="width: 100%; height: 18px; border-collapse: collapse">
                            <tr>
                                <td style="width: 90%; vertical-align: top; height: 5px; text-align: left;">
                                    <table style="width: 95%; border-collapse: collapse">
                                        <tr>
                                            <td class="auto-style1" style="text-align: left">
                                                <asp:Label ID="lblParticular" runat="server" Text="Particulars" meta:resourcekey="lblParticularResource1" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" Style="font-weight: 700"></asp:Label>
                                            </td>
                                            <td style="font-size: 10pt; text-align: center; font-family: Verdana;" class="topbottom">
                                                <asp:Label ID="lnlAmount" runat="server" Text="Amount(₹)" Style="font-weight: 700" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false"></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table style="width: 95%; border-collapse: collapse">
                            <tr>
                                <td class="auto-style6">
                                    <asp:Label ID="lblAdvDisplay" runat="server" Text="ADVANCE COLLECTION" meta:resourcekey="lblAdvDisplayResource1"></asp:Label>
                                </td>
                                <td style="font-size: 10pt; width: 25%; font-family: Verdana; text-align: left">
                                    <span style="font-size: 10pt; font-family: Verdana">
                                        <asp:Label ID="lblNetAmount" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="lblNetAmountResource1"></asp:Label></span></td>
                            </tr>
                            <tr>
                                <td style="display: none" class="auto-style2">
                                    <b>Total :</b>&nbsp; &nbsp;&nbsp;&nbsp;</td>
                                <td style="width: 25%; display: none; font-size: 10pt; font-family: Verdana;" class="topbottom">
                                    <span style="font-size: 10pt; font-family: Verdana;">
                                        <asp:Label ID="lblamount" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="lblamountResource1"></asp:Label></span></td>
                            </tr>
                            <tr style="display: none;">
                                <td colspan="2">
                                    <table style="width: 100%;">
                                        <tr>
                                            <td class="auto-style1" style="text-align: right; width: 90%;">
                                                <asp:Label ID="lblReceived" runat="server" Text="Received Amount" Visible="false"></asp:Label>
                                            </td>
                                            <td style="font-size: 10pt; width: 10%; font-family: Verdana; text-align: right;">
                                                <asp:Label ID="lblReceivedAmt" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" Visible="false"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style1" style="text-align: right; width: 90%;">
                                                <asp:Label ID="lblChange" runat="server" Text="Change Amount" Visible="false"></asp:Label>
                                            </td>
                                            <td style="font-size: 10pt; width: 10%; font-family: Verdana; text-align: right;">
                                                <asp:Label ID="lblChangeAmt" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" Visible="false"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                               <td  class="top" style="vertical-align: top" colspan="6">
                                    <asp:Label ID="lblPaymentInCDF" runat="server" Visible="false" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="lblPaymentInCDF"></asp:Label>
                                </td>   
                            </tr>
                            <tr>
                                <td colspan="6" style="height: 4px;"></td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top; width: 95%" colspan="6">
                                    <asp:Label ID="lblpaymntmode" runat="server" Font-Bold="true" Text="Payment mode :"></asp:Label>
                                    <asp:Label ID="lblPaymentMode" runat="server" Font-Names="Verdana" Font-Size="9pt" Font-Bold="false" meta:resourcekey="lblPaymentModeResource1"></asp:Label></td>

                            </tr>
                            <tr>
                                <td style="vertical-align: top" colspan="6">
                                    <asp:Label ID="Label11" runat="server" Font-Bold="False" Font-Italic="False" Font-Names="Verdana" Width="548px" Font-Size="8pt" meta:resourcekey="Label11Resource1"></asp:Label></td>
                            </tr>
                              <tr>
                                <td colspan="6" style="height:10px;">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top" colspan="2">
                                    <asp:Label ID="lblNaration" runat="server" Font-Bold="False" Font-Italic="False"
                                        Font-Names="Verdana" Font-Size="9pt" Visible="False" Width="551px" meta:resourcekey="lblNarationResource1"></asp:Label></td>
                            </tr>
                            <tr>
                                <td class="bottom" style="vertical-align: top" colspan="6">
                                    <div style="font-family: Arial; font-size: 8.5pt; width: 550px;">
                                        <asp:Label ID="footertext1" runat="server" Text=" Note: This is a computerised Bill and not require Seal. & Sign."></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td style="vertical-align: top; text-align: left" colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;</td>

                                <td style="vertical-align: top; width: 25%">
                                    <div class="topdashed" style="text-align: center; font-family: Verdana; font-size: 9pt; width: 160px; font-weight: bold; margin-left: 0px;">
                                        <asp:Label ID="lblSignature" runat="server" Text="Signature" meta:resourcekey="lblSignatureResource1"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top" colspan="6">
                                    <asp:Label ID="lblfooter" runat="server" Font-Bold="false" Font-Names="Verdana" Font-Size="9pt" meta:resourcekey="lblfooterResource1"></asp:Label></td>
                            </tr>
                            <tr style="display: none">
                                <td colspan="2" style="text-align: center">&nbsp;
                                      <asp:Label ID="lbll" runat="server" Text="Thank You For Your Business." Font-Names="Verdana" Font-Size="9pt" Style="font-weight: 700" meta:resourcekey="lbllResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="height: 16px; text-align: left; vertical-align: middle">&nbsp;</td>
                            </tr>

                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
