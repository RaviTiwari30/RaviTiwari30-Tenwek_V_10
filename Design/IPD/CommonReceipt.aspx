<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CommonReceipt.aspx.cs"
    Inherits="Design_IPD_CommonReceipt" StylesheetTheme="Theme1" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>IPD Bill</title>
    <script language="vbscript" type="text/vbscript">
    
    Function Print()    
           OLECMDID_PRINT = 6
           OLECMDEXECOPT_DONTPROMPTUSER = 2
           OLECMDEXECOPT_PROMPTUSER = 1
           call WB.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER,1)
 'window.close
    End Function
       
    document.write "<object ID='WB' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>"  
    </script>
    <link href="../../App_Themes/Theme1/mm.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .auto-style1 {
            width: 54%;
            border-top: 1px solid #000000;
            border-bottom: 1px solid #000000;
        }

        .auto-style2 {
            width: 54%;
            border-top: 1px solid #000000;
        }

        .auto-style3 {
            width: 54%;
        }
    </style>
</head>
<body onload="vbscript:Print()" style="margin-left: 10px;">
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        $(function () {

            var Duplicate = '<%=Request.QueryString["Duplicate"].ToString() %>';
            if (Duplicate == 1) {
                document.getElementById('tbDuplicate').style.backgroundImage = 'url(../../Images/Duplicate_watermark.gif)';
                document.getElementById('tbDuplicate').style.backgroundRepeat = 'no-repeat';
            }
        }
        );
    </script>
    <form id="form1" runat="server">
        <div>

            <table id="tbDuplicate" style="width: 722px;">
                <tr>
                    <td>
                        <table style="width: 730px; margin-left: 5px; margin-right: -50px; border-collapse: collapse" class='textreceipt'>
                            <tr>
                                <td style="text-align: center; width: 100%;" colspan="6">
                                    <table border="0" style="width: 100%; border-collapse: collapse">
                                        <tr>
                                            <td style="text-align: left; vertical-align: top">
                                                <asp:Label ID="lblHeaderText" runat="server" meta:resourcekey="lblHeaderTextResource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td rowspan="1" style="width: 5%; text-align: center; height: 22px; vertical-align: bottom">
                                                <asp:Label ID="lblHeader" runat="server" Text="IPD RECEIPT" Font-Bold="True"
                                                    Font-Size="12pt" Font-Underline="True"></asp:Label>
                                                &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                                            </td>

                                        </tr>
                                        <tr>
                                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
                                    &nbsp;&nbsp;
                                                <br />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table style="width: 100%; border-collapse: collapse">

                            <tr style="font-size: 12pt">
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblName" runat="server" Text="Name" meta:resourcekey="lblNameResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblPatientName" runat="server" Font-Names="Verdana" Font-Size="9pt"
                                        Font-Bold="False" meta:resourcekey="LblPatientNameResource1"></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 10%; height: 14%">

                                    <asp:Label ID="lblRecp" runat="server" Text="Receipt No." Font-Bold="False" Style="display: none"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong style="display: none">:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblReceiptNo" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                        Font-Bold="False" meta:resourcekey="LblReceiptNoResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr style="font-size: 12pt">
                                <td style="vertical-align: top; width: 10%; height: 14%">

                                    <asp:Label ID="lblAge" runat="server" Text="Age/Sex" meta:resourcekey="lblAgeResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblAgeSex" runat="server" Font-Names="Verdana" Font-Size="9pt"
                                        Width="193px" meta:resourcekey="LblAgeSexResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 10%; height: 14%">

                                    <asp:Label ID="lblDate1" runat="server" Text="Date" meta:resourcekey="lblDate1Resource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblDate" runat="server" Font-Names="Verdana" Width="112px" Font-Size="9pt" meta:resourcekey="LblDateResource1"></asp:Label><asp:Label
                                        ID="LblTime" runat="server" Font-Size="9pt" Font-Names="Verdana" meta:resourcekey="LblTimeResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr style="font-size: 12pt">
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblMrNo" runat="server" Text="UHID" Width="100%"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblRegNo" runat="server" Font-Names="Verdana" Font-Size="9pt"
                                        Width="193px"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblLabNoHeading" runat="server" Font-Bold="False" Text="Lab No." Visible="False"
                                        Width="63px"></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">

                                    <asp:Label ID="lbla" Text=":" runat="server" Visible="false"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="lblLabNo" runat="server" Font-Bold="False" Text="Lab No." Visible="False"></asp:Label>

                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top; width: 10%; height: 14%">

                                    <asp:Label ID="lblAddress1" runat="server" Text="Address"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>:</strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="lblAddress" runat="server" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                                </td>
                                <td style="width: 10%; vertical-align: top">

                                    <asp:Label ID="lblConsultant" runat="server" Text="Doctor" meta:resourcekey="lblConsultantResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>:</strong></td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="LblDoctorName" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                        Font-Bold="False" meta:resourcekey="LblDoctorNameResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top; width: 10%; height: 14%">

                                    <asp:Label ID="lblRelation" runat="server" Text=""></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>
                                        <asp:Label ID="lblreldot" runat="server" Visible="false" Text=":"></asp:Label></strong>
                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="lblRelationName" runat="server" Text="" Style="font-size: 9pt"></asp:Label>
                                </td>
                                <td style="width: 10%; vertical-align: top;">
                                    <asp:Label ID="lblContactno" runat="server" Text="Contact No."></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>:</strong>

                                </td>
                                <td style="vertical-align: top; width: 38%; height: 14%">

                                    <asp:Label ID="lblMobile" runat="server" Font-Names="Verdana" Font-Size="9pt"></asp:Label>

                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top; width: 10%; height: 14%">

                                    <asp:Label
                                        ID="lblRefByH" runat="server" meta:resourcekey="lblRefByHResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>
                                        <asp:Label ID="lbldotRef" Text=":" runat="server" Visible="False" meta:resourcekey="lbldotRefResource1"></asp:Label></strong></td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="lblRefBy" runat="server"
                                        Font-Bold="False" Font-Names="Verdana" Font-Size="8pt" meta:resourcekey="lblRefByResource1"></asp:Label>
                                </td>
                                <td style="width: 10%; vertical-align: top;">
                                    <asp:Label ID="lblCityHeading" runat="server" Text="City" Font-Names="Verdana" Font-Size="9pt" Visible="False" meta:resourcekey="lblCityHeadingResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>
                                        <asp:Label ID="Label3" Text=":" runat="server" Visible="False"></asp:Label></strong></td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="lblCity" runat="server" Font-Names="Verdana" Font-Size="9pt" Visible="False" meta:resourcekey="lblCityResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top; width: 10%; height: 14%">
                                    <asp:Label ID="lblIPD" runat="server" Text="IPD No." Visible="false"></asp:Label>

                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%">
                                    <strong>

                                        <asp:Label ID="lblIP" Text=":" runat="server" Visible="False"></asp:Label>
                                    </strong></td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="lblIPDNo" runat="server"
                                        Font-Bold="False" Font-Names="Verdana" Visible="false" Font-Size="8pt"></asp:Label>


                                </td>
                                <td style="width: 10%; vertical-align: top">
                                    <asp:Label ID="lblward" runat="server" Text="Ward/Room" Visible="false"></asp:Label>
                                    &nbsp;
                                </td>
                                <td style="vertical-align: top; width: 2%; height: 14%"><strong>

                                    <asp:Label ID="lblroom" Text=":" runat="server" Visible="false"></asp:Label>
                                </strong></td>
                                <td style="vertical-align: top; width: 38%; height: 14%">
                                    <asp:Label ID="lblroomward" runat="server"
                                        Font-Bold="False" Font-Names="Verdana" Font-Size="8pt"></asp:Label>
                                </td>
                            </tr>

                        </table>
                        <table style="width: 100%; border-collapse: collapse">
                            <tr>
                                <td colspan="6">
                                    <table style="width: 100%; height: 18px; border-collapse: collapse">
                                        <tr>
                                            <td colspan="4" style="width: 70%; vertical-align: top; height: 5px; text-align: left;">
                                                <table style="width: 95%; border-collapse: collapse">
                                                    <tr>
                                                        <td class="auto-style1" style="text-align: left">
                                                            <asp:Label ID="lblParticular" runat="server" Text="Particulars" meta:resourcekey="lblParticularResource1"></asp:Label>
                                                        </td>
                                                        <td class="topbottom" style="width: 12%; text-align: right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                            <asp:Label ID="lblUnits" runat="server" Text="Units" meta:resourcekey="lblUnitsResource1"></asp:Label>
                                                        </td>
                                                        <td class="topbottom" style="width: 14%; text-align: right;">
                                                            <asp:Label ID="lblRates" runat="server" Text="Rate" meta:resourcekey="lblRatesResource1"></asp:Label>
                                                        </td>
                                                        <td class="topbottom" style="width: 10%; text-align: right;">
                                                            <asp:Label ID="lblAmounts" runat="server" Text="Amount" meta:resourcekey="lblAmountsResource1"></asp:Label>

                                                        </td>
                                                        <td class="topbottom" style="width: 11%"></td>

                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="width: 60%; text-align: left;">
                                                            <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                                                        </td>
                                                        <td style="width: 11%; height: 16px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="auto-style2"></td>
                                                        <td class="top" style="width: 12%"></td>
                                                        <td class="top" style="width: 14%; text-align: right;">
                                                            <asp:Label ID="Label1" runat="server" Font-Bold="False" Text="Total" Font-Names="Verdana" meta:resourcekey="Label1Resource1"></asp:Label>
                                                        </td>
                                                        <td class="top" style="width: 14%; text-align: right;">
                                                            <asp:Label ID="LblTotal" runat="server" Font-Names="Verdana" Font-Size="8pt" Font-Bold="False"></asp:Label>
                                                        </td>
                                                        <td class="top" style="width: 11%; height: 17px;"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>

                                                        <td colspan="2" style="width: 14%; text-align: right;">&nbsp;
                                                        </td>
                                                        <td style="width: 14%; text-align: right;">&nbsp;
                                                        </td>
                                                        <td style="width: 11%; height: 17px;">&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table style="width: 100%; border-collapse: collapse">
                            <tr>
                                <td style="vertical-align: top; text-align: left;width:70%">
                                    <asp:Label ID="lblPanelName" runat="server" Font-Bold="False" Text="Sponsored By  :  "
                                        Visible="False" meta:resourcekey="lblPanelNameResource1"></asp:Label>
                                    <asp:Label ID="lblPanel" runat="server" Font-Bold="False" Font-Names="Verdana" Font-Size="8pt"
                                        Visible="False" meta:resourcekey="lblPanelResource1"></asp:Label>
                                </td>
                                <td style="vertical-align: top; text-align: right; width:30%">
                                    <div class="topdashed" style="text-align: center; font-family: Verdana; font-size: 9pt; width: 160px; font-weight: bold;">
                                        <asp:Label ID="lblSignature" runat="server" Text="Signature" Width="93px"></asp:Label>

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: middle" colspan="6">
                                    <asp:Label ID="lblfooter" runat="server" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                                    <span id="spnmsg" runat="server"></span>
                                    <br />
                                </td>
                            </tr>
                        </table>



                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
