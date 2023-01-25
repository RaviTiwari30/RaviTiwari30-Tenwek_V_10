<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SideLink.ascx.cs" Inherits="Design_Controls_SideLink" %>
<%@ OutputCache Duration="1800" VaryByParam="None"  %>
<table style="width:100%">
    <tr>
        <td style="width: 100%">
            <a href="http://www.pepidonline.com/" target="_blank">
                <asp:Image runat="server" ID="imgPEPID"  ImageUrl='<%# ResolveClientUrl("Images/PEPID.jpg")%>'  alt="PEPID" Width="125px" /></a>
        </td>
    </tr>
    <tr>
        <td style="width: 100%">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 100%">
            <a href="http://www.uptodate.com/" target="_blank">
                <asp:Image runat="server" ID="Image2" ImageUrl='<%# ResolveClientUrl("Images/uptodate.png")%>' alt="PEPID" Width="125px" /></a>
        </td>
    </tr>
    <tr>
        <td style="width: 100%">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 100%">
            <a href="http://www.webmd.com/" target="_blank">
                <asp:Image runat="server" ID="imgwebMD" ImageUrl='<%# ResolveClientUrl("Images/WebMD.jpg")%>' alt="WebMD" Width="125px" /></a>
        </td>
    </tr>
    <tr>
        <td style="width: 100%">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 100%">
            <a href="http://www.ncbi.nlm.nih.gov/pubmed" target="_blank">
                <asp:Image runat="server" ID="imgpubmed" ImageUrl='<%# ResolveClientUrl("Images/pubmed.jpg")%>' alt="PUB MED" Width="125px" /></a></td>
    </tr>
    <tr>
        <td style="width: 100%">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 100%">
            <a href="http://www.epocrates.com/online?CID=PPC-Epoc+Branded-Google-epocrates-epocrates+General-e" target="_blank">
                <asp:Image runat="server" ID="imgEpocrates" ImageUrl='<%# ResolveClientUrl("Images/Epocrates.jpg")%>' alt="Epocrates" Width="125px" /></a></td>
    </tr>
    <tr>
        <td style="width: 100%">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 100%">
            <a href="<%=Page.ResolveUrl("~/Document_downloads.aspx") %>" target="_blank">
                <asp:Image runat="server" ID="imgusermanual" ImageUrl='<%# ResolveClientUrl("Images/usermanual.jpg")%>' alt="User Manual" Width="125px" /></a></td>
    </tr>
    <tr>
        <td style="width: 100%">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 100%">
            <asp:ImageButton ID="imgICDCode10" runat="server" ImageUrl='<%# ResolveClientUrl("Images/icd-10.jpg")%>'
                Width="125px" OnClick="imgICDCode10_Click" /></td>
    </tr>
    <tr>
        <td style="width: 100%">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 100%">
            <asp:ImageButton ID="imgCPTCode" runat="server" ImageUrl='<%# ResolveClientUrl("Images/CptCode.jpg")%>'
                OnClick="imgCPTCode_Click" /></td>
    </tr>
    <tr>
        <td style="width: 100%">&nbsp;</td>
    </tr>
    <tr>
        <td style="width: 100%">
            <a href="<%=Page.ResolveUrl("~/Design/CPOE/BMI_Calculator.htm") %>" target="_blank">
                <asp:Image runat="server" ID="Image1" ImageUrl='<%# ResolveClientUrl("Images/BMI.jpg")%>' alt="BMI Calculator" Width="125px" /></a></td>
    </tr>
    <tr>
        <td style="width: 100%" align="right">
            <span id="hide_Help" style="cursor: pointer">hide</span>
        </td>
    </tr>
</table>
