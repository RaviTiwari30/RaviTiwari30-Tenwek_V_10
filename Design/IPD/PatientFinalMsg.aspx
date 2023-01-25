<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientFinalMsg.aspx.cs" Inherits="Design_IPD_PatientFinalMsg" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
               
                    <asp:Label ID="lblMsg" runat="server" Font-Size="X-Large" ForeColor="Red" />
                
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Demographic Details
                </div>
                <div style="text-align: center;">
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%" id="tblPatient"
                        runat="server">
                        <tr>
                            <td style="width: 20%;text-align:right" >
                                Patient Name :&nbsp;</td>
                            <td style="width: 30%; text-align:left" >
                                <asp:Label ID="lblPname" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 20%;text-align:right" >
                                Age / Sex :&nbsp;
                            </td>
                            <td style="width: 30%; text-align:left" >
                                <asp:Label ID="lblAgeSex" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="width: 20%;text-align:right" >
                                UHID :&nbsp;
                            </td>
                            <td style="width: 30%; text-align:left" >
                                <asp:Label ID="lblPID" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 20%;text-align:right">
                                Address :&nbsp;
                            </td>
                            <td style="width: 30%; text-align:left" >
                                <asp:Label ID="lblAddress" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="width: 20%;text-align:right" >
                                IPD No. :&nbsp;
                            </td>
                            <td style="width: 30%; text-align:left" >
                                <asp:Label ID="lblTID" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 20%;text-align:right" >
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 20%;text-align:right" >
                                <asp:Label ID="lblRelation" runat="server" ></asp:Label></td>
                            <td style="width: 30%; text-align:left" >
                                <asp:Label ID="lblRelationOf" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            <td style="width: 20%;text-align:right" >
                                Contact No.&nbsp;:&nbsp;</td>
                            <td style="width: 30%; text-align:left" >
                                <asp:Label ID="lblMobile" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                        </tr>
                       
                    </table>
                </div>
            </div>
            <asp:Label ID="lblDetails" runat="server"></asp:Label>
        </div>
    </form>
</body>
</html>

