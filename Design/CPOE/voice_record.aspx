<%@ Page Language="C#" AutoEventWireup="true" CodeFile="voice_record.aspx.cs" Inherits="Design_CPOE_voice_record" %>

<%@ Register Src="~/Design/Controls/wuc_AudioRecording.ascx" TagPrefix="uc1" TagName="wuc_AudioRecording" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../Styles/PurchaseStyle.css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Voice Record</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div> 
            <uc1:wuc_AudioRecording runat="server" ID="wuc_AudioRecording" />            
        </div>        
        <asp:Label ID="lblPatientID" runat="server" Style="display: none;" />
        <asp:Label ID="lblTransactionID" runat="server" Style="display: none;" />
        <asp:Label ID="lblUser_ID" runat="server" Style="display: none;" />
    </form>
</body>
</html>
