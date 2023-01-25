<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="LabRadItemConsumeReport.aspx.cs" Inherits="Design_EDP_LabRadItemConsumeReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content  ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    
    <script type="text/javascript">
      

    </script>


 <div id="Pbody_box_inventory" >     
  <div class="POuter_Box_Inventory" style="text-align: center;">
      <ajax:scriptmanager id="ScriptManager1" runat="server">
        </ajax:scriptmanager>
        <strong>Lab / Rad Consume Item Report In Excel Format</strong>
        <br />
        <asp:Label ID="lblErrorMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
  </div> 
  
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
          INDICATOR SEARCH
        </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                   <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Select From Date" />
                            <cc1:CalendarExtender ID="cl1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Select to Date" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>


                </div>
                <div class="col-md-1"></div>
            </div>

   </div>

     <div class="POuter_Box_Inventory">
         <div class="Purchaseheader">
             Additional Search Criteria
         </div>
         <table style="width: 100%">
             <tr>
                 <td style="width: 10%; text-align: left; border: groove">Mapped Items </td>
                 <td style="text-align: left; width: 100%; border: groove" colspan="6">
                     <div style="text-align: left;" class="scroll">
                         <asp:CheckBoxList ID="chkItemList" runat="server"   >
                </asp:CheckBoxList>
                     </div>
                 </td>
             </tr>
         </table>

         &nbsp;
     </div>



     <div class="POuter_Box_Inventory" style="text-align: center;">
         <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Height="25px"
             Text="Report" ToolTip="Click To Save" Width="71px" OnClick="btnSearch_Click" />
     </div>
</div>                       
</asp:Content>

