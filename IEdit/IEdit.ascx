<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IEdit.ascx.cs" Inherits="IEdit_IEdit" %>
<%-- <link href="../../csskit/default.css" rel="stylesheet" type="text/css" />--%>
<script type="text/javascript" src="../../IEdit/jskit/wysiwyg.js"></script>
		<script type="text/javascript" src="../../IEdit/jskit/wysiwyg-settings.js"></script>
		<!-- 
			Attach the editor on the textareas
		-->
		<script type="text/javascript">
			// Use it to attach the editor to all textareas with full featured setup
			//WYSIWYG.attach('all', full);
			
			// Use it to attach the editor directly to a defined textarea
			WYSIWYG.attach('<%=txtIEdit.ClientID %>'); // default setup
			//WYSIWYG.attach('textarea2', full); // full featured setup
			//WYSIWYG.attach('textarea3', small); // small setup
			
			// Use it to display an iframes instead of a textareas
			//WYSIWYG.display('all', full);  
		</script>
 <asp:TextBox ID="txtIEdit" runat="server" TextMode="MultiLine" 
        Width="780px">

        </asp:TextBox>