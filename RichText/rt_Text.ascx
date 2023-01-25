<%@ Control Language="C#" AutoEventWireup="true" CodeFile="rt_Text.ascx.cs" Inherits="RichText_rt_Text" %>
<script src="../../RichText/nicEdit-latest.js" type="text/javascript"></script>
<script type="text/javascript">
//bkLib.onDomLoaded(function() {
//	new nicEditor({iconsPath : '../../RichText/nicEditorIcons.gif'}).panelInstance('<%=txtIEdit.ClientID %>');
////	new nicEditor({fullPanel : true}).panelInstance('area2');
////	new nicEditor({iconsPath : '../nicEditorIcons.gif'}).panelInstance('area3');
////	new nicEditor({buttonList : ['fontSize','bold','italic','underline','strikeThrough','subscript','superscript','html','image']}).panelInstance('area4');
////	new nicEditor({maxHeight : 100}).panelInstance('area5');
//});

</script>
<script type="text/javascript">bkLib.onDomLoaded(nicEditors.allTextAreas);</script>

<div style="background-color:#FFFFFF;">
<asp:TextBox ID="txtIEdit" runat="server" TextMode="MultiLine" Width="850px" Height="227px" ></asp:TextBox>
</div>