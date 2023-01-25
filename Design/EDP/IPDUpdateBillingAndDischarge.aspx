<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IPDUpdateBillingAndDischarge.aspx.cs" Inherits="Design_IPD_IPDUpdateBillingAndDischarge" %>
  <%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  
    <%-- <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>

    <div id="Pbody_box_inventory">
           <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" >       
           </cc1:ToolkitScriptManager>
         <div class="POuter_Box_Inventory" style="text-align: center">
            <b><span id="lblHeader" style="font-weight: bold;">IPD Update Billing And Discharge</span></b><br />
            <span id="spnErrorMsg" class="ItDoseLblError">
                <asp:Label ID="lblMsg" runat="server"></asp:Label>
            </span>
            <span id="spnIPDAdmission"></span>
            <input type="text" id="txtHash" style="display: none" />
            <span id="lblAppID" style="display: none"></span>
            <span id="spntransactionID" style="display:none;" ></span>
        </div>
        
        <div class="POuter_Box_Inventory">
            <div id="divPatientSearch">
              <div class="Purchaseheader">
                  Enter Patient
              </div>
            <br />
             <table style="width: 100%;border-collapse:collapse">
                 <tr>
                    <td style="width:100px">
                        &nbsp;
                        IPD No :
                    </td>
                      <td  style="width: 250px;text-align:left" colspan="2">
                        <asp:TextBox ID="txtIPDNo" runat="server" ClientIDMode="Static" Width="130px" 
                            TabIndex="1"></asp:TextBox>
                       <cc1:FilteredTextBoxExtender ID="ftbIPDNo" runat="server" TargetControlID="txtIPDNo"  FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    &nbsp;<asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="ItDoseButton" />
                    </td>
                      <td  style="width:100px">
                        UHID :
                    </td>
                      <td  style="width: 250px;text-align:left" colspan="2">
                        <asp:Label ID="txtMRNo" runat="server" ClientIDMode="Static" TabIndex="2"></asp:Label>
                     </td>
                     <td  style="width:100px">
                        First Name :
                    </td>
                      <td style="width: 250px;text-align:left" colspan="2">
                        <asp:Label ID="txtFirstname" runat="server" ClientIDMode="Static" 
                            TabIndex="3"></asp:Label>
                      </td>
                      <td  style="width:100px">
                        Last Name :
                    </td>
                      <td  style="width: 250px;text-align:left" colspan="2">
                        <asp:Label ID="txtLastname" runat="server" ClientIDMode="Static"  
                            TabIndex="4"></asp:Label>
                     </td>
                 </tr>
                 </table>
            <br />
            <div id="divBilling&Discharge">
             <div class="Purchaseheader">
                 Billing & Discharge Details
              </div>
            <table style="width: 100%;border-collapse:collapse">
                 <tr style="height:35px">
                     <td style="width:30px"><asp:CheckBox ID="chkAdmissionDT" OnCheckedChanged="chkAdmissionDT_CheckedChanged" AutoPostBack="true" runat="server" /></td>
                     <td style="width:200px">Admission Date & Time :</td>
                     <td style="width:200px">
                         <asp:TextBox ID="txtAdmissionDate" runat="server" ClientIDMode="Static" Width="130px" TabIndex="4"></asp:TextBox>
                         <cc1:CalendarExtender ID="txtAdmissionDate_CalendarExtender" runat="server" TargetControlID="txtAdmissionDate" Format="dd-MMM-yyyy">
                         </cc1:CalendarExtender>
                     </td>
                
                     <td>
                         <asp:TextBox ID="txtAdmissionTime" runat="server" ClientIDMode="Static" Width="130px" TabIndex="4"></asp:TextBox>
                          <cc1:MaskedEditExtender ID="maskTimeExt_Admission" Mask="99:99" runat="server" MaskType="Time" 
                                TargetControlID="txtAdmissionTime" AcceptAMPM="true" UserTimeFormat="none">
                           </cc1:MaskedEditExtender>                                                
                     </td>
                 </tr>
                 <tr style="height:35px">
                     <td><asp:CheckBox ID="chkDischargeType" OnCheckedChanged="chkDischargeType_CheckedChanged" AutoPostBack="true" runat="server" /></td>
                     <td>Discharge Type :</td>
                     <td>
                         <asp:DropDownList ID="ddlDischargeType" style="width:135px" runat="server"></asp:DropDownList>
                     </td>
                 </tr>
                  <tr style="height:35px">
                     <td><asp:CheckBox ID="chkDischargeDT" OnCheckedChanged="chkDischargeDT_CheckedChanged" AutoPostBack="true" runat="server" /></td>
                     <td>Discharge Date & Time:</td>
                     <td>
                         <asp:TextBox ID="txtDischargeDate" runat="server" ClientIDMode="Static" Width="130px" TabIndex="4"></asp:TextBox>
                          <cc1:CalendarExtender ID="txtDischargeDate_CalendarExtender" runat="server" TargetControlID="txtDischargeDate" Format="dd-MMM-yyyy" ClearTime="true">
                         </cc1:CalendarExtender>
                     </td>
                  
                     <td>
                         <asp:TextBox ID="txtDischargeTime" runat="server" ClientIDMode="Static" Width="130px" TabIndex="4"></asp:TextBox>
                           <cc1:MaskedEditExtender ID="maskTimeExt_Discharge" Mask="99:99" runat="server" MaskType="Time" 
                                TargetControlID="txtDischargeTime" AcceptAMPM="true" UserTimeFormat="none">
                            </cc1:MaskedEditExtender>
                          
                     </td>
                 </tr>
                  <tr style="height:35px">
                     <td><asp:CheckBox ID="chkBillingDT" OnCheckedChanged="chkBillingDT_CheckedChanged" AutoPostBack="true" runat="server" /></td>
                     <td>Billing Date & Time:</td>
                     <td>
                         <asp:TextBox ID="txtBillingDate" runat="server" ClientIDMode="Static" Width="130px" TabIndex="4"></asp:TextBox>
                         <cc1:CalendarExtender ID="txtBillingDate_CalendarExtender" runat="server" TargetControlID="txtBillingDate" Format="dd-MMM-yyyy" ClearTime="true">
                         </cc1:CalendarExtender>
                    </td>                          
                   
                  
                     <td>
                         <asp:TextBox ID="txtBillingTime" runat="server" ClientIDMode="Static" Width="130px" TabIndex="4"></asp:TextBox>
                          <cc1:MaskedEditExtender ID="maskTimeExt_Billing" Mask="99:99" runat="server" MaskType="Time" 
                                TargetControlID="txtBillingTime" AcceptAMPM="true" UserTimeFormat="none">
                            </cc1:MaskedEditExtender>
                          
                     </td>
                 </tr>
                 
             </table>
                <br />
                   <div id="DivUpdate" style="text-align:center">
                         <asp:Button ID="BtnUpdate" runat="server" Text="Update" OnClick="BtnUpdate_Click" CssClass="ItDoseButton" />
                         <asp:Button ID="BtnReset" runat="server" Text="Reset" OnClick="BtnReset_Click" CssClass="ItDoseButton" />
                    </div>
                <br />
             </div>
            </div>
        </div>


</asp:Content>

