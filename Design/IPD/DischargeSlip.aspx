<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DischargeSlip.aspx.cs" Inherits="Design_IPD_DischargeSlip" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Bill Print</title>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
</head>
<body>
        <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
     
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Discharge Slip</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align:center">
                 
                <div class="row">
                    <div class="col-md-24">
                       <asp:Button runat="server" ID="btnDischargeSlip" Text="Genrate Discharge Slip" OnClick="btnDischargeSlip_Click" />
                    </div> 
                </div>
            </div> 
        </div>
    </form>
     
</body>
</html>
