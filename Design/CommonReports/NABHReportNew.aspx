<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="NABHReportNew.aspx.cs" Inherits="Design_EDP_NABHReportNew" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content  ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">




 <div id="Pbody_box_inventory" >     
  <div class="POuter_Box_Inventory" style="text-align: center;">
      <ajax:scriptmanager id="ScriptManager1" runat="server">
        </ajax:scriptmanager>
        <strong>NABH reports Excel Format</strong>
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
                 <td style="width: 10%; text-align: left; border: groove"></td>
                 <td style="text-align: left; width: 100%; border: groove" colspan="6">
                     <div style="text-align: left;" class="scroll">
                         <asp:RadioButtonList ID="rbtActive" runat="server" RepeatDirection="Vertical" RepeatColumns="3">
                             <asp:ListItem Selected="True" Value="1">Laboratory Detailed Report</asp:ListItem>
                             <asp:ListItem Value="2">Laboratory Indicator</asp:ListItem>
                             <asp:ListItem Value="3">Radiology Indicator</asp:ListItem>
                             <asp:ListItem Value="4">Medical Assessment Indicator </asp:ListItem>
                             <asp:ListItem Value="5">Nursing Assessment Indicator </asp:ListItem>
                             <asp:ListItem Value="6">Medical Assessment Detailed Report</asp:ListItem>
                             <asp:ListItem Value="7">Nursing Assessment Detailed Report</asp:ListItem>
                             <asp:ListItem Value="8">HIA Detailed Indicator Report</asp:ListItem>
                             <asp:ListItem Value="9">NIA Detailed Indicator Report</asp:ListItem>
                             <asp:ListItem Value="10">Patient Incident Indicator Report</asp:ListItem>
                             <asp:ListItem Value="11">OT Detailed Indicator Report</asp:ListItem>
                             <asp:ListItem Value="12">LAB Co-Relation Indicator Report</asp:ListItem>
                             <asp:ListItem Value="13">RADIO Co-Relation Indicator Report</asp:ListItem>
                             <asp:ListItem Value="14">Return To ICU within 48 Hours Report</asp:ListItem>
                             <asp:ListItem Value="15">Mortality Indicator Report</asp:ListItem>
                             <asp:ListItem Value="16">Return to Casualty Indicator Report</asp:ListItem>
                             <asp:ListItem Value="17">Re-Intubation Indicator Report</asp:ListItem>
                             <asp:ListItem Value="18">Time taken For Discharge(In Hours) Report</asp:ListItem>
                             <asp:ListItem Value="31">Time taken For Discharge In Detail Report</asp:ListItem>
                             <asp:ListItem Value="19">ICU Equipment Utilization Indicator Report</asp:ListItem>
                             <asp:ListItem Value="20">ICU BED Utilization Report</asp:ListItem>
                             <asp:ListItem Value="21">Missing Record Report</asp:ListItem>
                             <asp:ListItem Value="22">Incident Reporting</asp:ListItem>
                             <asp:ListItem Value="23">HAI Indicator Report</asp:ListItem>
                             <asp:ListItem Value="24">NSI/BBF Indicator Report</asp:ListItem>
                             <asp:ListItem Value="25">OT Indicator Report</asp:ListItem>
                             <asp:ListItem Value="26">OT Utilization Report</asp:ListItem>
                             <asp:ListItem Value="27">Drug Procured By LP Report</asp:ListItem>
                             <asp:ListItem Value="28">Rejection Before GRN Report</asp:ListItem>
                             <asp:ListItem Value="29">Re-Intubation Detailed Report</asp:ListItem>
                             <asp:ListItem Value="30">Return To ICU Detailed Report</asp:ListItem>
                             <asp:ListItem Value="32">Dispensing time of medication in Detailed Report</asp:ListItem>
                         </asp:RadioButtonList>
                     </div>
                 </td>
             </tr>
         </table>

         &nbsp;
     </div>



     <div class="POuter_Box_Inventory" style="text-align: center;">
         <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Height="25px"
             Text="Search" ToolTip="Click To Save" Width="71px" OnClick="btnSearch_Click" />
     </div>
</div>                       
</asp:Content>

