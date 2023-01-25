<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewAgeingReport.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_IPD_NewAgeingReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

  <script type="text/javascript" >
function hideOrShowContent(ChktxtAge)
{
if (ChktxtAge.checked )
 {
    document.getElementById('<%= txtAge.ClientID %>').style.display = '';
 
 }
 else
 {
    document.getElementById('<%= txtAge.ClientID %>').style.display = 'none';
 
 }
}

</script>
<Ajax:ScriptManager ID="ScripManager1" runat="server"></Ajax:ScriptManager>
 <div id="Pbody_box_inventory" >
 <div class="POuter_Box_Inventory">
    <div class="content" style="text-align:center;">    
    <b>Ageing Report</b>      
    <br /><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
    </div>
    </div>
    <div class="POuter_Box_Inventory">
     <div class="Purchaseheader">
     Report Search Criteria
    </div>
        <table style="width: 100%">
            <tr>
                <td style="width:20%;text-align:right">Type :&nbsp;</td>
                <td style="width: 30%">
                   <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal">
                       <asp:ListItem Selected="True" Text="OPD" Value="0" />
                       <asp:ListItem Text="IPD" Value="1" />                       
                   </asp:RadioButtonList></td>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
                
            </tr>
            <tr>
                <td style="width:20%;text-align:right">Age :&nbsp;</td>
                <td style="width: 30%">
                  <asp:RadioButtonList ID="rdoAgeLimit" runat="server" RepeatDirection="Horizontal" Width="694px"  >
                       <asp:ListItem Selected="True" Text="ALL" Value="ALL" />
                       <asp:ListItem Text="Less Than 60 Days" Value="LessThan60" />
                       <asp:ListItem Text="60-120 days" Value="60-120" /> 
                       <asp:ListItem Text="120-180 Days" Value="120-180" />     
                       <asp:ListItem Text="Greater Than 180 Days" Value="GreaterThan180" />  
                                      
                   </asp:RadioButtonList></td>
                <td style="width: 20%;text-align:right">
                   <asp:CheckBox ID="ChktxtAge" runat="server" Text="CustomAge :&nbsp;" Height="25px" onclick="hideOrShowContent(this);" /></td>
                <td style="width: 30%">
                  <asp:TextBox ID="txtAge" runat="server" CssClass="ItDoseTextinputNum"   Width="70px" ToolTip="No. Of Copies" style="display:none" ></asp:TextBox></td>
            </tr>
            <tr>
                
                            
                   <td style="width:20%;text-align:right" >
                        Panel Group :&nbsp;</td>
                    <td  style="text-align: left;width:30%">
                        <asp:DropDownList ID="ddlPanelGroup" runat="server" AutoPostBack="True" CssClass="searchable" ClientIDMode="Static"
                            Width="240px"  OnSelectedIndexChanged="ddlPanelGroup_SelectedIndexChanged">
                        </asp:DropDownList></td>
                <td style="width: 20%">
                </td>
                <td style="width: 30%">
                </td>
            </tr>
            
        </table>
     
    <div style="border:groove">
    <table style="width:100%"><tr><td style="width:20%;text-align:right;border-right:groove"><asp:CheckBox id="chkCompAll" runat="server" AutoPostBack="True" Text="Panel :&nbsp" OnCheckedChanged="chkCompAll_CheckedChanged"></asp:CheckBox>
    </td><td colspan="3"><asp:CheckBoxList id="cblPanel" runat="server" RepeatDirection="Horizontal" Font-Size="8pt" CssClass="ItDoseCheckboxlist" RepeatLayout="Table" RepeatColumns="6"></asp:CheckBoxList></td></tr></table>
    
                 
</div>
 </div>
 <div class="POuter_Box_Inventory" style="text-align:center;">
    
   <asp:Button ID="btnSearch" runat="server"  Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click" /> 
    </div>
 </div>
 



</asp:Content>
