<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="InvestigationNumeric.aspx.cs" Inherits="Design_EMR_InvestigationNumeric" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
     

    <title></title>
   

</head>
<body>

         
    <form id="form1" runat="server">
        <ajax:ScriptManager ID="ScriptManager1" runat="server">
        </ajax:ScriptManager>
        
        <div id="Pbody_box_inventory">
           
           <asp:Label ID="lblTID" runat="server" Visible="false"></asp:Label>
             <div class="POuter_Box_Inventory" style="text-align:center">
                 <asp:RadioButtonList ID="rdoType"  runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                     <asp:ListItem Text ="Numeric" Selected="True" Value="1"></asp:ListItem>
                     <asp:ListItem Text ="Text"  Value="2"></asp:ListItem>
                 </asp:RadioButtonList>
                 </div>
          
            
            
            <div class="POuter_Box_Inventory" style="text-align:center">
                <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnReport_Click"  />  
                </div>
        </div>
   <asp:GridView ID="grdInvText" runat="server" AutoGenerateColumns="False" OnRowDataBound="grdInvText_RowDataBound"
                    CssClass="GridViewStyle" >
                    <Columns>                                             
                        <asp:TemplateField HeaderText="Investigation">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemTemplate>
                                <label><%# Util.GetString(Eval("Investigation"))%></label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Date">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            <ItemTemplate>
                                <label><%# Util.GetString(Eval("Date"))%></label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Result" HeaderText="Result" >
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                       



                       
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>


           <asp:GridView ID="grdNumeric" runat="server" AutoGenerateColumns="False" 
                    CssClass="GridViewStyle" >
                    <Columns>                                             
                        <asp:TemplateField HeaderText="Name">
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                            <ItemTemplate>
                                <label><%# Util.GetString(Eval("Name"))%></label>
                            </ItemTemplate>
                        </asp:TemplateField>
                         


                       
                        <asp:BoundField DataField="Value" HeaderText="Value" >
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Reading Format" HeaderText="Reading Format" >
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         <asp:BoundField DataField="Min Value" HeaderText="Min Value" >
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         <asp:BoundField DataField="Max Value" HeaderText="Max Value" >
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                           <asp:BoundField DataField="DATE" HeaderText="DATE" >
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>


                       
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>

    </form>
</body>
</html>
