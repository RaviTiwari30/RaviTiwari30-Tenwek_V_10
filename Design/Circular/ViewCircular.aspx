<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ViewCircular.aspx.cs" Inherits="Design_Circular_ViewCircular"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript">
 function openPopup(str)
 {
        //the purpose of this function is to allow the enter key to 
        //point to the correct button to click.  
          
      
        //window.open('../OPD/PatientPopup.aspx?BTN='+buttonName,null,'left=200, top=100, height=350, width=600, status=no, resizable= no, scrollbars= no, toolbar= no,location= no, menubar= no');
     var winc = window.open('PopupCircular.aspx?id=' + str + '', 'popupcircular', 'left=100, top=100, height=520, width=840, status=no, resizable= yes, scrollbars= yes, toolbar= no,location= no, menubar= no');
     return;
       winc.focus();
   }
</script>
<div id="Pbody_box_inventory">
<div class="POuter_Box_Inventory">
 <div style="text-align:center;" >    
<b>Circular Inbox</b>&nbsp;<br />
<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />    
</div>
</div>
 <div class="POuter_Box_Inventory"> 
   <div>
       
        
        <table>
                    <tr>
                        <td valign="top"><asp:LinkButton ID="lbtnAll" runat="server" OnClick="lbtnAll_Click" Font-Bold="true">ALL Message</asp:LinkButton>&nbsp;
       <asp:LinkButton ID="lbtnUnread" OnClick="lbtnUnread_Click" runat="server" Font-Bold="true">Unread Message</asp:LinkButton>&nbsp;
       <asp:LinkButton ID="lbtnReaded" OnClick="lbtnReaded_Click" runat="server" Font-Bold="true">Read Message</asp:LinkButton>&nbsp;&nbsp;</td>
                        <td style="text-align: center; background-color:lightgreen;"><strong>Unread Message</strong></td></tr></table>
       <br />
       <table style="width:100%"><tr><td style="border:solid">
           <asp:Label ID="circilarMessage" runat="server" Visible="false" ForeColor="Red"></asp:Label>
       <asp:Repeater ID="grdCircular" OnItemCommand="grdCircular_ItemCommand" runat="server" OnItemDataBound="grdCircular_ItemDataBound" >
            <HeaderTemplate>
     <table class="GridViewStyle" cellspacing="0" style="border-collapse: collapse;width:100%" >
     <tr style="text-align:center;background-color:#afeeee;">
<th class="GridViewHeaderStyle" scope="col" style="width:163px">Date</th>
<th class="GridViewHeaderStyle" scope="col" style="width:150px" >From Department</th>
<th class="GridViewHeaderStyle" scope="col" style="width:150px">From User</th>
<th class="GridViewHeaderStyle" scope="col" style="width:400px">Subject</th>
<th class="GridViewHeaderStyle" scope="col" style="width:80px">Message</th>
 <th class="GridViewHeaderStyle" scope="col" style="width:80px">Attachment</th>
</tr>
     </HeaderTemplate>
     <ItemTemplate>
     <tr  id="trHead" runat="server">
     <td class="GridViewItemStyle" style="text-align:left;">
      <%#Eval("Date") %> 
         <asp:Label ID="lblIsView" runat="server" Text='<%#Eval("IsView") %>' Visible="false"></asp:Label>         
     </td> 
     <td class="GridViewItemStyle">
     <%#Eval("FromDept") %>
     </td> 
     <td class="GridViewItemStyle">
     <%#Eval("FromEmp") %>
     </td> 
     <td class="GridViewItemStyle" style="width:250px; overflow:hidden; white-space:nowrap;">
     <%#Eval("Sub") %>
     </td> 
     <td class="GridViewItemStyle" style="text-align:center">
       <a href="javascript:openPopup('<%#Eval("Id") %>');">view</a>  <sup><span id="Reply_Count" runat="server"  style="min-width: 12px; border-radius: 4px; background-color: Red; color: White; margin-top: 0px; margin-left: 10px; position: absolute; font-weight: bold; text-align: right; font-size: 13px" title="Unread Message Count"><%#Eval("Reply") %></span> </sup>              
     </td> 
      <td class="GridViewItemStyle" style="text-align:center">
        <%--  <img alt="" src="../../Images/view.GIF"    onclick="showAttachment('<%#Eval("URL") %>')" />--%>
          <asp:ImageButton ID="imgbtnAttachment" runat="server" CommandArgument='<%#Eval("URL") %>' CommandName="Attchment" AlternateText='<%#Eval("URL") %>'  ImageUrl="../../Images/view.GIF"  />
       
      </td>
     </tr>
    
     
     </ItemTemplate>
     <FooterTemplate>
     </table>
     </FooterTemplate>
       
       </asp:Repeater></td></tr></table>
    </div>
    </div>
    </div>
</asp:Content>

