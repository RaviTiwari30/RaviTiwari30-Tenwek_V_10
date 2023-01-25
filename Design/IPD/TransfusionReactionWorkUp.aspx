<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TransfusionReactionWorkUp.aspx.cs" Inherits="Design_IPD_TransfusionReactionWorkUp" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 183px;
        }
    </style>
</head>
<body>
    
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
   <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
     <script type="text/javascript">
         $(document).ready(function () {
             $("#<%=ddlApprovedBy.ClientID %>").chosen();
             $("#<%=ddlApprovedBy1.ClientID %>").chosen();
             //$("#ctl00_ContentPlaceHolder1_rpRoomDoctor_ctl01_ddlDoctor").chosen();
             var x = setInterval("reloadPage()", 30000);
         });

         function validate() {
             //if ($('#ddlHeamoglobinUria').val() == "0")
             //{
             //    alert("Select Urine Heamoglobinuria");
             //    return false;
             //}
             //if ($('#ddlBilirubenuria').val() == "0") {
             //    alert("Select Bilirubenuria");
             //    return false;
             //}
             //if ($('#ddlUrobilinogen').val() == "0") {
             //    alert("Select Urobilinogen");
             //    return false;
             //}
             //if ($('#ddlDirect').val() == "0") {
             //    alert("Select Direct coombs on post EDTA Sample");
             //    return false;
             //}
             //if ($('#ddlABO1').val() == "0") {
             //    alert("Select ABO Pre Sample");
             //    return false;
             //}
             if ($('#ddlABO1').val() != "0" && $('#ddlRH1').val() == "0") {
                 alert("Select RH Pre Sample ");
                 return false;
             }
             if ($('#ddlABO1').val() == "0" && $('#ddlRH1').val() != "0") {
                 alert("Select ABO Pre Sample ");
                 return false;
             }

             //if ($('#ddlABO2').val() == "0") {
             //    alert("Select ABO Post sample");
             //    return false;
             //}
             if ($('#ddlABO2').val() != "0" && $('#ddlRH2').val() == "0") {
                 alert("Select RH Post sample ");
                 return false;
             }
             if ($('#ddlABO2').val() == "0" && $('#ddlRH2').val() != "0") {
                 alert("Select ABO Post sample ");
                 return false;
             }

             //if ($('#ddlABO3').val() == "0") {
             //    alert("Select ABO bag");
             //    return false;
             //}
             if ($('#ddlABO3').val() != "0" && $('#ddlRH3').val() == "0") {
                 alert("Select RH Bag ");
                 return false;
             }
             if ($('#ddlABO3').val() == "0" && $('#ddlRH3').val() != "0") {
                 alert("Select ABO Bag ");
                 return false;
             }

             //if ($('#ddlRH1').val() == "0") {
             //    alert("Select RH Pre Sample");
             //    return false;
             //}
             //if ($('#ddlRH2').val()== "0") {
             //    alert("Select RH Post sample");
             //    return false;
             //}
             //if ($('#ddlRH3').val() == "0") {
             //    alert("Select RH bag");
             //    return false;
             //}

             //if ($('#ddlMajor1').val() == "0") {
             //    alert("Select Major");
             //    return false;
             //}
             //if ($('#ddlMajor2').val() == "0") {
             //    alert("Select Major");
             //    return false;
             //}
             //if ($('#ddlMinor1').val() == "0") {
             //    alert("Select Minor");
             //    return false;
             //}
             //if ($('#ddlMinor2').val() == "0") {
             //    alert("Select Minor");
             //    return false;
             //}
         }
         function checkDate(sender, args) {
             var dt = new Date();
             if (sender._selectedDate > dt) {
                 sender._textbox
                .set_Value(dt.format(sender._format));
             }
         }

     </script>
    <form id="Form1" runat="server">
       
        <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Transfusion Reaction WorkUp</b>
                <br />
                
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
             </div>   
           
            
            <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                     <div class="col-md-8">
                         <label class="pull-left">Date/Time</label>
                         <b class="pull-right">:</b>
                        </div>
                        
                    <div class="col-md-8">
                                <asp:TextBox ID="txtDate" runat="server"  CssClass="disable_future_dates" 
                                ToolTip="Click To Select Date" Width="100px" TabIndex="1"  
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        
                            
                     </div>
                         <div class="col-md-8">
                               
                             
                            <asp:TextBox ID="txtTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                          
                         </div>
                 
                     
               </div> 
          </div>
                </div>
             <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                  Transfusion Reaction
                </div>
                </div>
           
             <div class="POuter_Box_Inventory">
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">Symptoms of Reaction 
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-5">
                                <asp:TextBox ID="txtSymtomsOfReaction" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Symptoms Of Reaction"  ></asp:TextBox>
                     </div>
                    <div class="col-md-3">Transfusion Start Time 
                          <b class="pull-right">:</b>
                         </div>
                    
                         <div class="col-md-5">
                               <asp:TextBox ID="txtTime1" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtTime1"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtTime1"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                          
                         </div>
                    <div class="col-md-3">Time Blood Stopped 
                          <b class="pull-right">:</b>
                         </div>
                    
                         <div class="col-md-5">
                                    <asp:TextBox ID="txtTime2" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtTime2"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlToValidate="txtTime2"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                          
                         </div>
                   
                     </div>
              </div>
               <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">Stopped By 
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-5">
                                <asp:TextBox ID="txtStoppedBy" runat="server"  Width="200px" ClientIDMode="Static"  ></asp:TextBox>
                     </div>
                    
              </div>
                 </div>
              </div>
                 
             <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                  Transfusion  Reaction WorkUp
                </div>
                </div>
             <div class="POuter_Box_Inventory">
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-3">Clinician Notified 
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-5">
                                <asp:TextBox ID="txtClinicianNotified" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Clinician Notified"  ></asp:TextBox>
                     </div>
                    <div class="col-md-3">By 
                          <b class="pull-right">:</b>
                         </div>
                    
                         <div class="col-md-5">
                                <asp:TextBox ID="txtNotifiedBy" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="By"  ></asp:TextBox>
                    
                             
                         </div>
                    </div>
              </div>
                 <div class="row">
                <div class="col-md-24">
                    <div class="col-md-3">Reported To Lab By 
                          <b class="pull-right">:</b>
                         </div>
                    
                         <div class="col-md-5">
                               <asp:TextBox ID="txtReportedToLabBy" runat="server"  Width="200px" ClientIDMode="Static"  ToolTip="Reported To Lab By"  ></asp:TextBox>
                    
                             
                         </div>
                      <div class="col-md-3">
                         <label class="pull-left">Date</label>
                         <b class="pull-right">:</b>
                        </div>
                        
                    <div class="col-md-5">
                                <asp:TextBox ID="txtDate1" runat="server"  CssClass="disable_future_dates" 
                                ToolTip="Click To Select Date" Width="100px" TabIndex="1"  
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate1"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        
                            
                     </div>
                         <div class="col-md-3">
                             
                         <label class="pull-left">Time</label>
                         <b class="pull-right">:</b>
                           </div>
                         <div class="col-md-5">
                               
                                       <asp:TextBox ID="txtTime9" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtTime9"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlToValidate="txtTime9"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                          
                         </div>
                   
                     </div>
              </div>
                 <div class="row">
                <div class="col-md-24">
                    <div class="col-md-8">Post Blood Sample Nurse Drawing Blood 
                          <b class="pull-right">:</b>
                         </div>
                    
                         <div class="col-md-5">
                               <asp:TextBox ID="txtNurseDrawingBlood" runat="server"  Width="200px" ClientIDMode="Static"    ></asp:TextBox>
                    
                             
                         </div>
                    <div class="col-md-3">
                             
                         <label class="pull-left">Time</label>
                         <b class="pull-right">:</b>
                           </div>
                         <div class="col-md-5">
                               
                                          <asp:TextBox ID="txtTime8" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtTime8"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlToValidate="txtTime8"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                          
                         </div>
                   
                 </div>
                     </div>
                 <div class="row">
                <div class="col-md-24">
                    <div class="col-md-8">Post Urine Sample Received  
                          <b class="pull-right">:</b>
                         </div>
                    
                         <div class="col-md-5">
                               <asp:TextBox ID="txtReceived" runat="server"  Width="200px" ClientIDMode="Static"    ></asp:TextBox>
                    
                             
                         </div>
                    <div class="col-md-3">
                             
                         <label class="pull-left">Time</label>
                         <b class="pull-right">:</b>
                           </div>
                         <div class="col-md-5">
                               
                                             <asp:TextBox ID="txtTime3" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtTime3"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlToValidate="txtTime3"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                          
                         </div>
                   
                 </div>
                     </div>
                 </div>
                 <div class="POuter_Box_Inventory">
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-8">
                         </div>
                     <div class="col-md-8">
                         <asp:Label ID="Label1" runat="server"  Visible="false"></asp:Label>
                        <%-- <asp:Button ID="btnSubmit" runat="server"  CssClass="ItDoseButton" Text="Save" ToolTip="Click To Save"  OnClick="btnSubmit_Click"  />--%>
              <asp:Button ID="Button1" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Update" ToolTip="Click To Update"   CausesValidation="false"  Visible="false" OnClick="btnUpdate_Click1" />
                
                         <asp:Button ID="Button3" type="submit" runat="server" Text="Save" OnClick="btnSubmit_Click1" CausesValidation="false"  />

                     </div>
                     <div class="col-md-8">
                         </div>
                    </div>
              </div>
                </div>
       
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                  Results Of WorkUp
                </div>
                </div>
            
             <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                     <div class="col-md-8">
                         <label class="pull-left">Date/Time</label>
                         <b class="pull-right">:</b>
                        </div>
                        
                    <div class="col-md-8">
                                <asp:TextBox ID="txtDateR" runat="server"  CssClass="disable_future_dates" 
                                ToolTip="Click To Select Date" Width="100px" TabIndex="1"  
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtDateR"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        
                            
                     </div>
                         <div class="col-md-8">
                               
                             
                            <asp:TextBox ID="txtTimeR" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtTimeR"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator6" runat="server" ControlToValidate="txtTimeR"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                          
                         </div>
                 
                     
               </div> 
          </div>
            </div>
             <div class="POuter_Box_Inventory">
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-4">1.Clerical Errors Checked
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-20">
                                <asp:TextBox ID="txtclericalErrorsChecked" runat="server"   ClientIDMode="Static"  ></asp:TextBox>
                     </div>
             </div>
              </div>
                 <div class="row">
                <div class="col-md-24">
                     <div class="col-md-6">2.a) Serum and Plasma Observed for homolysis 
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-18">
                                <asp:TextBox ID="txtSerum" runat="server"   ClientIDMode="Static"  ></asp:TextBox>
                     </div>
             </div>
              </div>
                 <div class="row">
                <div class="col-md-24">
                     <div class="col-md-5">2.b) Urine Heamoglobinuria 
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-3">
                               <asp:DropDownList id="ddlHeamoglobinUria" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                         </div>
            
                     <div class="col-md-3">b) Bilirubenuria 
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-3">
                               <asp:DropDownList id="ddlBilirubenuria" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                         </div>
                    
                     <div class="col-md-3">b) Urobilinogen 
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-3">
                               <asp:DropDownList id="ddlUrobilinogen" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                         </div>
             </div>
              </div>
                 <div class="row">
                <div class="col-md-24">
                     <div class="col-md-5">2.c) Direct coombs on post EDTA Sample 
                          <b class="pull-right">:</b>
                         </div>
                    
                     <div class="col-md-3">
                               <asp:DropDownList id="ddlDirect" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Positive" />
                                        <asp:ListItem value="2" Text="Negative" />
                                    </asp:DropDownList>
                                                         </div>
            
                 </div>
                     </div>
                  <div class="row">
                <div class="col-md-24">
                    <table style="width:100%;">
                        <tr><th colspan="4" style="text-align:left;">3. If any of Above is possitive do the following</th></tr>
                        <tr><td>  </td><td>Pre Sample </td><td>Post sample </td><td> bag</td></tr>
                        <tr><td>a  ABO Group</td>
                            <td>
                            <asp:DropDownList id="ddlABO1" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="A" Text="A" />
                                        <asp:ListItem value="B" Text="B" />
                                        <asp:ListItem value="AB" Text="AB" />
                                        <asp:ListItem value="O" Text="O" />
                                    </asp:DropDownList>
                               </td>
                            <td>
                        <asp:DropDownList id="ddlABO2" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="A" Text="A" />
                                        <asp:ListItem value="B" Text="B" />
                                        <asp:ListItem value="AB" Text="AB" />
                                        <asp:ListItem value="O" Text="O" />
                                    </asp:DropDownList>
                                </td>
                            <td> 
                         <asp:DropDownList id="ddlABO3" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="A" Text="A" />
                                        <asp:ListItem value="B" Text="B" />
                                        <asp:ListItem value="AB" Text="AB" />
                                        <asp:ListItem value="O" Text="O" />
                                    </asp:DropDownList>
                               </td></tr>
                        <tr><td>b  RH Type</td>
                            <td>
                           <asp:DropDownList id="ddlRH1" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Positive" />
                                        <asp:ListItem value="2" Text="Negative" />
                                    </asp:DropDownList>
                                </td>
                            <td>
                        <asp:DropDownList id="ddlRH2" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Positive" />
                                        <asp:ListItem value="2" Text="Negative" />
                                    </asp:DropDownList>
                                   </td>
                            <td> 
                         <asp:DropDownList id="ddlRH3" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Positive" />
                                        <asp:ListItem value="2" Text="Negative" />
                                    </asp:DropDownList>
                                  </td></tr>
                    </table>
                    </div>
                      </div>
                  <div class="row">
                <div class="col-md-24">
                    <table style="width:100%;">
                        <tr><th colspan="3" style="text-align:left;"> 4. Cross Match</th></tr>
                        <tr><td>a  Major</td>
                            <td>
                            <asp:DropDownList id="ddlMajor1" runat="server" Width="200px">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Compatible" />
                                        <asp:ListItem value="2" Text="Not Compatible" />
                                        <asp:ListItem value="3" Text="Not Done" />
                                    </asp:DropDownList>
                               </td>
                            <td>
                         
                            <asp:DropDownList id="ddlMajor2" runat="server" Width="200px">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Compatible" />
                                        <asp:ListItem value="2" Text="Not Compatible" />
                                        <asp:ListItem value="3" Text="Not Done" />
                                    </asp:DropDownList>         </td></tr>
                        <tr><td>b Minor</td>
                            <td>
                            
                            <asp:DropDownList id="ddlMinor1" runat="server" Width="200px">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Compatible" />
                                        <asp:ListItem value="2" Text="Not Compatible" />
                                        <asp:ListItem value="3" Text="Not Done" />
                                    </asp:DropDownList></td>
                            <td>
                         
                            <asp:DropDownList id="ddlMinor2" runat="server" Width="200px">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Compatible" />
                                        <asp:ListItem value="2" Text="Not Compatible" />
                                        <asp:ListItem value="3" Text="Not Done" />
                                    </asp:DropDownList>   </td></tr>
                    </table>
                    </div>
                      </div>
                 
                 <div class="row">
                <div class="col-md-24">
                <div class="col-md-24">
                    5. Check for bacterial contamination
                    </div>
                    </div>
             <div class="row">
                <div class="col-md-24">
                <div class="col-md-4">

                    a. Condition Of Bag and blood
                    </div>
                     <div class="col-md-20">
                         <asp:TextBox ID="txtCondition" runat="server"  Width="600px" ClientIDMode="Static"  ></asp:TextBox>
                  </div>
                    </div>
                    </div>
                 <div class="row">
                <div class="col-md-24">
                
                   If suspitious or if physician thinks the reaction is supicous of bacterial contaminated blood:<br />
                    b. Set a Blood Culture on Bag- Culture results to follow
                    </div>
                     </div>
                      <div class="row">
                <div class="col-md-24">
                <div class="col-md-6">Technician Or Technologist Signature</div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtTechnician" runat="server"  Width="200px" ClientIDMode="Static"  ></asp:TextBox>
                  
                </div>
                    <div class="col-md-4">Approved By</div>
                
                    
                    <div class="col-md-4">
                        <%-- <asp:TextBox ID="txtApprovedBy" runat="server"  Width="200px" ClientIDMode="Static"  ></asp:TextBox>
                  --%>
                        <asp:DropDownList id="ddlApprovedBy" runat="server">
                                        </asp:DropDownList>
                               
                    </div>
                    <div class="col-md-4">
                        
                        <asp:DropDownList id="ddlApprovedBy1" runat="server">
                                        </asp:DropDownList>
                    </div>
             
             
             </div>
                          </div>
                     </div>
                 </div>
            <div class="POuter_Box_Inventory">
          <div class="row">
                <div class="col-md-24">
                     <div class="col-md-8">
                         </div>
                     <div class="col-md-8">
                         <asp:Label ID="lblPID" runat="server"  Visible="false"></asp:Label>
                        <%-- <asp:Button ID="btnSubmit" runat="server"  CssClass="ItDoseButton" Text="Save" ToolTip="Click To Save"  OnClick="btnSubmit_Click"  />--%>
              <asp:Button ID="btnUpdate" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Update" ToolTip="Click To Update"   CausesValidation="false"  Visible="false" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" TabIndex="7" runat="server" Text="Cancel" CssClass="ItDoseButton" Visible="false"  OnClick="btnCancel_Click"    CausesValidation="false"  />
             
                         <asp:Button ID="btnSave" type="submit" runat="server" Text="Save" OnClientClick="return validate();" OnClick="btnSubmit_Click" CausesValidation="false"  />

                     </div>
                     <div class="col-md-8">
                         </div>
                    </div>
              </div>
                </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
            <div class="col-md-24">
                <div style="overflow:auto;">
                       <asp:GridView ID="grdGrid" runat="server" AutoGenerateColumns="False"   CssClass="GridViewStyle" OnRowDataBound="grdSickPatientsDetails_RowDataBound" OnRowCommand="grdSickPatientsDetails_RowCommand">

                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>

                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>

                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Symptoms">
                                            <ItemTemplate>
                                                <asp:Label ID="lblHistory" runat="server" Text='<%#Eval("Symptoms") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Entry By" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Entry Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDate" runat="server" Text='<%#Util.GetDateTime(Eval("Date1")).ToString("dd-MMM-yyyy") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                                        </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Entry Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTime" runat="server" Text='<%#Util.GetDateTime(Eval("Time1")).ToString("hh:mm tt") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Result Entry Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDateR" runat="server" Text='<%#Util.GetDateTime(Eval("DateR1")).ToString("dd-MMM-yyyy") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                                        </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Result Entry Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTimeR" runat="server" Text='<%#Util.GetDateTime(Eval("TimeR1")).ToString("hh:mm tt") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                                        </asp:TemplateField>
                        
                                       
                                        <asp:TemplateField HeaderText="Edit" >
                                            <ItemTemplate  >
                                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false"   CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                              
                                                <asp:Label ID="lblID" Text='<%#Eval("Id") %>' runat="server" Visible="FALSE"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Print" >
                                            <ItemTemplate  >
                                                <asp:ImageButton ID="imgbtnPrint" AlternateText="Print" CausesValidation="false"   CommandName="Print" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/print.gif" runat="server" />
                                              
                                                <asp:Label ID="lblID1" Text='<%#Eval("Id") %>' runat="server" Visible="FALSE"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                    </Columns>
                                    <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="5" />
                                </asp:GridView>
                  <div id="divdata"></div>


                    </div>
            </div>
            </div>
        </div>
            </div>
           
</form>
</body>
</html>


