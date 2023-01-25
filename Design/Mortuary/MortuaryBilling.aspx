<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MortuaryBilling.aspx.cs" Inherits="Design_Mortuary_MortuaryBilling" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    TID = Request.QueryString["TransactionID"].ToString();
    CID = Request.QueryString["CorpseID"].ToString();    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mortuary Corpse Billing</title>
    <script type="text/javascript">
        window.history.forward(1);
    </script>   
    <frameset cols="20%,80%,*">
    <frame name="Menu" SRC="Mortuary_Menu.aspx?CorpseID=<%=CID%>&TransactionID=<%=TID%>" NAME=left>        
    <frameset id="CorpseFrame" rows="23%,75%">
        <frame name="Header" target="Contentframe" noresize="noresize" scrolling="no" src="Mortuary.aspx?CorpseID=<%=CID%>&TransactionID=<%=TID%>" />
        <frame name="Contentframe" target="Contentframe" noresize="noresize" scrolling="yes" src="Mortuary_Welcome.aspx?CorpseID=<%=CID%>&TransactionID=<%=TID%>" />
    </frameset>
    </frameset>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
