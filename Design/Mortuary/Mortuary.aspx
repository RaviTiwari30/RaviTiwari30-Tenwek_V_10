<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mortuary.aspx.cs" Inherits="Design_Mortuary_Mortuary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../Styles/PurchaseStyle.css" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
      <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <style>
        body {
            font-size: 75%;
        }

        .auto-style1 {
            width: 34%;
        }

        .auto-style2 {
            width: 45%;
        }
    </style>
    <script type="text/javascript">
        function change(img1) {
            if (img1.alt == "hide") {
                parent.parent.document.getElementById('ak1').setAttribute('rows', '20,*', 0);
                Pbody_box_inventory.style.display = "none";
                img1.alt = "show";
                img1.src = "/Images/Show.gif";
            }
            else {
                parent.parent.document.getElementById('ak1').setAttribute('rows', '135,*', 0);
                Pbody_box_inventory.style.display = "";
                img1.alt = "hide";
                img1.src = "/Images/Hide.gif";
            }
        }
        function hideSelfFrame() {
            if (window.top.document.getElementById("iframeCorpse") != null)
                window.top.document.getElementById("iframeCorpse").style.width = "0px";
            if (window.top.document.getElementById("iframeCorpse") != null)
                window.top.document.getElementById("iframeCorpse").style.height = "0px";
            if (window.top.document.getElementById("iframeCorpse") != null)
                window.top.document.getElementById("iframeCorpse").src = "";
            if (window.top.document.getElementById("iframeCorpse") != null)
                window.top.document.getElementById("iframeCorpse").style.display = "none";

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <table style="width: 100%; margin: 0; border-collapse: collapse; border: 0">
            <tr>
                <td colspan="3" style="height:27px;"></td>
            </tr>
            <tr>
                <td style="width: 10%; text-align: center">
                    <asp:Image ID="imgPatient" Height="85px" Width="92px" runat="server" />
                </td>
                <td style="width: 40%; vertical-align: top">
                    <table style="width: 100%">
                        <tr>
                            <td style="text-align: right" class="auto-style1">Corpse No. :</td>
                            <td style="width: 80%">
                                <asp:Label ID="lblCorpseNo" runat="server" CssClass="ItDoseLblSpBl" ClientIDMode="Static" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right" class="auto-style1">Name :</td>
                            <td style="width: 80%">
                                <asp:Label ID="lblCorpseName" runat="server" CssClass="ItDoseLblSpBl" /></td>
                        </tr>
                        <tr>
                            <td style="text-align: right" class="auto-style1">Age :</td>
                            <td style="width: 80%">
                                <asp:Label ID="lblDOB" runat="server" CssClass="ItDoseLabelBl" Font-Size="11px" />&nbsp;
                                <asp:Label ID="lblGender" runat="server" CssClass="ItDoseLblSpBl" ClientIDMode="Static" /></td>
                        </tr>
                        <tr>
                            <td style="text-align: right" class="auto-style1">Status :</td>
                            <td style="width: 80%">
                                <asp:Label ID="lblStatus" runat="server" CssClass="ItDoseLblSpBl" ClientIDMode="Static" /></td>
                        </tr>

                        <tr>
                            <td style="text-align: right" class="auto-style1">Type of Death :</td>
                            <td style="width: 80%">
                                <asp:Label ID="lblDeathType" runat="server" CssClass="ItDoseLblSpBl" ClientIDMode="Static" /></td>
                        </tr>

                        <tr>
                            <td style="text-align: right" class="auto-style1">Doctor&nbsp;:&nbsp;</td>
                            <td style="width: 80%">
                                <asp:Label ID="lblDoctorName" runat="server" CssClass="ItDoseLblSpBl" ClientIDMode="Static" />
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="width: 50%; vertical-align: top">
                    <table style="width: 100%">
                        <tr>
                            <td style="text-align: right" class="auto-style2">Deposite&nbsp;No.&nbsp;:&nbsp;</td>
                            <td style="width: 50%" colspan="2">
                                <asp:Label ID="lblDepositeID" runat="server" CssClass="ItDoseLblSpBl" Font-Size="11px" /></td>
                            <td style="width: 30%; text-align: right" colspan="2">
                                <a href="javascript:void(0);" onclick="hideSelfFrame();">Corpse&nbsp;Search</a>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right" class="auto-style2">Date of Death&nbsp;:&nbsp;</td>
                            <td style="width: 50%" colspan="2">
                                <asp:Label ID="lblDeathDate" runat="server" CssClass="ItDoseLblSpBl" Font-Size="11px" /></td>
                            <td style="width: 30%; text-align: right" colspan="2"></td>
                        </tr>
                        <tr>
                            <td style="text-align: right" class="auto-style2">Rack/Shelf&nbsp;:&nbsp;</td>
                            <td style="width: 80%">
                                <asp:Label ID="lblRoomNo" runat="server" CssClass="ItDoseLblSpBl" Font-Size="11px" /></td>
                            <td colspan="2" style="width: 80%; text-align: right;">&nbsp;</td>
                            <td style="width: 80%">&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="text-align: right; vertical-align: top;" class="auto-style2">Deposite&nbsp;Date&nbsp;:&nbsp;</td>
                            <td style="width: 50%; vertical-align: top;" colspan="2">
                                <asp:Label ID="lblDepositeDate" runat="server" CssClass="ItDoseLblSpBl" Font-Size="11px" /></td>
                            <td style="width: 80%">&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="text-align: right; vertical-align: top;" class="auto-style2">Released Date&nbsp;:&nbsp;</td>
                            <td style="width: 50%; vertical-align: top;">
                                <asp:Label ID="lblReleasedDate" runat="server" CssClass="ItDoseLblSpBl" Font-Size="11px"></asp:Label></td>
                            <td style="width: 30%; text-align: right" colspan="2"></td>
                            <td style="width: 30%; text-align: right" colspan="2">
                                <a id="pre" href="IPD_Welcome.aspx?TID=<%=("CRSHHI"+lblDepositeID.Text)%>&PID=<%=lblCorpseNo.Text%>" target="Contentframe">
                                    <img src="../../Images/home.gif" style="border: none" />
                                </a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
