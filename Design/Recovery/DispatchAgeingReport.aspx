<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DispatchAgeingReport.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_Recovery_DispatchAgeingReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Src="../Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript" src="../../Design/Common/popcalendar.js"></script>


  <script type="text/javascript" language="javascript">
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
    <b>Dispatch Ageing Report</b>      
    <br /><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
    </div>
    </div>
    <div class="POuter_Box_Inventory">
     <div class="Purchaseheader">
     Report Search Critaria
    </div>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
           
            <tr>
                <td style="width: 100px">
                  <asp:RadioButtonList ID="rdoAgeLimit" runat="server" RepeatDirection="Horizontal" Width="694px" Font-Bold="True" onclick="rblSelectedValue()" >
                       <asp:ListItem Selected="True" Text="ALL" Value="ALL" />
                       <asp:ListItem Text="Less Than 60 Days" Value="LessThan60" />
                       <asp:ListItem Text="60-120 days" Value="60-120" /> 
                       <asp:ListItem Text="120-180 Days" Value="120-180" />     
                       <asp:ListItem Text="Greater Than 180 Days" Value="GreaterThan180" />  
                                      
                   </asp:RadioButtonList></td>
                <td style="width: 100px">
                   <asp:CheckBox ID="ChktxtAge" runat="server" Text="CustomDays" Height="25px" onclick="hideOrShowContent(this);" /></td>
                <td style="width: 100px">
                  <asp:TextBox ID="txtAge" runat="server" CssClass="ItDoseTextinputNum"   Width="71px" ToolTip="No. Of Copies" Style="display: none"  ></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 100px">
                  <table>
                  <tr>                 
                   <td style="height: 22px" >
                        Panel Group&nbsp;&nbsp;</td>
                    <td  style="text-align: left; height: 22px;">
                        <asp:DropDownList ID="ddlPanelGroup" runat="server" AutoPostBack="True" CssClass="ItDoseDropdownbox"
                            Width="240px" Height="18px" OnSelectedIndexChanged="ddlPanelGroup_SelectedIndexChanged">
                        </asp:DropDownList></td>
                        </tr>
</table>
                </td>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
        </table>
        <br />
                                
                 <label class="labelForTag">Panel :</label>
    <div style="height:300px;overflow:scroll;">
    <Ajax:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <asp:CheckBox id="chkCompAll" runat="server" AutoPostBack="True" Text="Select All" OnCheckedChanged="chkCompAll_CheckedChanged"></asp:CheckBox><br /><br />
                 <asp:CheckBoxList id="cblPanel" runat="server" RepeatDirection="Horizontal" Font-Size="8pt" CssClass="ItDoseCheckboxlist" RepeatLayout="Table" RepeatColumns="3"></asp:CheckBoxList>
</ContentTemplate> 
</Ajax:UpdatePanel>
</div>
 </div>
 <div class="POuter_Box_Inventory" style="text-align:center;">
    <div style="display:none;">
        <asp:CheckBox ID="chkRoundOff" Text="Ignore O/s Data between (+/-) " runat="server" />&nbsp;
        <asp:TextBox ID="txtIgnoreData" Width="50px" runat="server"></asp:TextBox>
    </div>
   <asp:Button ID="btnSearch" runat="server" Width="60px" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click" /> 
    </div>
 </div>
 



</asp:Content>
