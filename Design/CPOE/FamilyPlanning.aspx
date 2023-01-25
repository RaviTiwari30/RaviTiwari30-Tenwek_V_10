<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FamilyPlanning.aspx.cs" Inherits="Design_CPOE_FamilyPlanning" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ipad.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CPOE_AddToFavorites.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
    <%--  <script type="text/javascript" src="../../Scripts/CheckUnSaveData.js"></script>--%>
    <style type="text/css">
        .GridViewLabItemStyle {
        
        text-align:left;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <script type="text/javascript">
            $(document).ready(function () {
                if ($("#txtHt").val() > 0 && $("#txtWt").val() > 0) {
                    convfromcmeters();
                }
                $bindMandatory(function () { })
            });
            var $bindMandatory = function (callback) {
                serverCall('cpoe_Vital.aspx/bindMandtoryVitial', { deptid: '<%=(Request.QueryString["DeptID"]) %>' }, function (response) {
                responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    for (var i = 0; i < responseData.length; i++) {
                        $(responseData[i].VitialSiginTextID).attr('errorMessage', responseData[i].ErrorMessage).addClass(responseData[i].isRequired == '1' ? 'requiredField' : '');
                    };
                }
            });
        }


    </script>
    
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <%--<div>&nbsp;&nbsp;&nbsp;<a id="AddToFavorites" onclick="AddPage('cpoe_Vital.aspx','Vital Sign')" href="#">Add To Favorites</a>&nbsp;&nbsp;&nbsp;&nbsp;<span id="Msg" class="ItDoseLblError"></span></div>--%>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Family Planning</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    &nbsp;First Visit Card&nbsp;:&nbsp;
                </div>
                           <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-4" >Date
                        </div>
                     <div class="col-md-8" style="text-align:left;" >
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                         
                                <asp:Label ID="Label1" runat="server" Visible="false"></asp:Label>
                                   <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                        </div>
                     <div class="col-md-4" >Time
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
                               
                               <div class="row">
                    <div class="col-md-24" >
                        <table  style="width:100%;">
                            <tr>
                                <td class="GridViewLabItemStyle" style="width:25%;">
                                    Facility Name
                                </td>
                                <td class="GridViewLabItemStyle" style="width:25%;">
                                   <asp:Label ID="lblFacilityName" runat="server" ></asp:Label>
                                </td>
                                
                                <td class="GridViewLabItemStyle" style="width:25%;">Encounter No
                                    </td>
                                <td class="GridViewLabItemStyle" style="width:25%;">
                          <asp:Label ID="lblEncounterNo" runat="server" ></asp:Label>
                                    </td>
                            </tr>
                            <tr>
                                <td class="GridViewLabItemStyle">
                                    County
                                </td>
                                <td class="GridViewLabItemStyle">
                                <asp:Label ID="lblCounty" runat="server" ></asp:Label>
                                </td>
                                
                                <td class="GridViewLabItemStyle">Sub County
                                    </td>
                                <td class="GridViewLabItemStyle">
                          <asp:Label ID="lblSubCounty" runat="server" ></asp:Label>
                                    </td>
                            </tr>
                            <tr>
                                <td class="GridViewLabItemStyle">Service Area(FP/CCC/PNC/CWC/YFC/SGBV/Other(Specify)
                                    </td>
                                <td class="GridViewLabItemStyle">
                                    <asp:TextBox ID="txtServiceArea" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Service Area"></asp:TextBox>
                               
                                    </td>
                                
                                <td class="GridViewLabItemStyle"></td>
                                <td class="GridViewLabItemStyle"></td>
                            </tr>
                            <tr>
                                	<th class="GridViewHeaderStyle" colspan="4">Client Information</th>
                            </tr>
                            <tr>
                                <td class="GridViewLabItemStyle">
                                    Client's Full Name
                                </td>
                                <td class="GridViewLabItemStyle">
                                <asp:Label ID="lblClientFullName" runat="server" ></asp:Label>
                                </td>
                                
                                <td class="GridViewLabItemStyle">Client No
                                    </td>
                                <td class="GridViewLabItemStyle">
                          <asp:Label ID="lblClientNo" runat="server" ></asp:Label>
                                    </td>
                            </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle">
                                    Date Of Birth
                                </td>
                                <td class="GridViewLabItemStyle">
                                <asp:Label ID="lblDOB" runat="server" ></asp:Label>
                                </td>
                                
                                <td class="GridViewLabItemStyle">Age 
                                    </td>
                                <td class="GridViewLabItemStyle">
                          <asp:Label ID="lblAge" runat="server" ></asp:Label>
                                    </td>
                            </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle">
                                    Sex
                                </td>
                                <td class="GridViewLabItemStyle">
                                <asp:Label ID="lblSex" runat="server" ></asp:Label>
                                </td>
                                
                                <td class="GridViewLabItemStyle">Highest Education Level 
                                    </td>
                                <td class="GridViewLabItemStyle">
                                    <asp:TextBox ID="txtHighestEducationLevel" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Highest Education Level"></asp:TextBox>
                               
                                    </td>
                            </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle">
                                    Marital Status(Single/Maried/Divorced/Widowed)
                                </td>
                                <td class="GridViewLabItemStyle">
                                <asp:Label ID="lblMaritalStatus" runat="server" ></asp:Label>
                                </td>
                                
                                <td class="GridViewLabItemStyle">Client Contact No 
                                    </td>
                                <td class="GridViewLabItemStyle">
                                     <asp:Label ID="lblClientContactNo" runat="server" ></asp:Label>
                              
                                    </td>
                            </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle">
                                    Email
                                </td>
                                <td class="GridViewLabItemStyle">
                                <asp:Label ID="lblEmail" runat="server" ></asp:Label>
                                </td>
                                
                                <td class="GridViewLabItemStyle">Physical Address 
                                    </td>
                                <td class="GridViewLabItemStyle">
                                     <asp:Label ID="lblPhysicalAddress" runat="server" ></asp:Label>
                              
                                    </td>
                            </tr>
                             <tr>
                                	<th class="GridViewHeaderStyle" colspan="4">Obstetric/Gynecological History</th>
                            </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle">
                                    LMP
                                </td>
                                <td class="GridViewLabItemStyle"> 
                                    <asp:TextBox ID="txtLMP" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter LMP"></asp:TextBox>
                               
                                </td>
                                
                                <td class="GridViewLabItemStyle">Regular/Irregular 
                                    </td>
                                <td class="GridViewLabItemStyle">
                                     <asp:TextBox ID="txtRegular" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Regular/Irregular"></asp:TextBox>
                               
                                    </td>
                            </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle">
                                    No Of Bleeding days
                                </td>
                                <td class="GridViewLabItemStyle"> 
                                    <asp:TextBox ID="txtNoOfBleedingDays" autocomplete="off" runat="server"  ClientIDMode="Static" MaxLength="3"
                                     ToolTip="Enter LMP"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtNoOfBleedingDays" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                                
                                </td>
                                
                                <td class="GridViewLabItemStyle">Current FP Method(Y/N)
                                   
                                    </td>
                                <td class="GridViewLabItemStyle">
                                     <asp:RadioButtonList ID="rdbCurrentFPMethod" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
 
                                     <asp:TextBox ID="txtCurrentFPMethod" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Regular/Irregular"></asp:TextBox>
                               
                                    </td>
                            </tr>
                            <tr>
                                <td class="GridViewLabItemStyle">Is The Client Pregnant(Y/N)
                                   
                                    </td>
                                <td class="GridViewLabItemStyle">
                                     <asp:RadioButtonList ID="rdbPregnant" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
 
                                     <asp:TextBox ID="txtPregnant" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Regular/Irregular"></asp:TextBox>
                               
                                    </td>
                          
                                
                                <td class="GridViewLabItemStyle">Is The Client Breast Feeding(Y/N)
                                   
                                    </td>
                                <td class="GridViewLabItemStyle">
                                     <asp:RadioButtonList ID="rdbIsBreastFeeding" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
 
                                    
                                    </td>
                                  </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle">
                                 No Of Desired Children
                                </td>
                                <td class="GridViewLabItemStyle"> 
                                    <asp:TextBox ID="txtNoOfDesiredChildren" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter LMP"></asp:TextBox>
                               
                                </td>
                                
                                <td class="GridViewLabItemStyle">Parity
                                   
                                    </td>
                                <td class="GridViewLabItemStyle">
                                    
                                     <asp:TextBox ID="txtParity" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Parity"></asp:TextBox>
                               
                                    </td>
                            </tr>
                           <tr>
                                <td class="GridViewLabItemStyle">
                                 No Living
                                </td>
                                <td class="GridViewLabItemStyle"> 
                                    <asp:TextBox ID="txtNoLiving" autocomplete="off" runat="server"  ClientIDMode="Static" MaxLength="3"
                                     ToolTip="Enter LMP"></asp:TextBox>
                               <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtNoLiving" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                                
                                </td>
                                
                                <td class="GridViewLabItemStyle">No Dead
                                   
                                    </td>
                                <td class="GridViewLabItemStyle">
                                    
                                     <asp:TextBox ID="txtNoDead" autocomplete="off" runat="server"  ClientIDMode="Static" MaxLength="3"
                                     ToolTip="Enter Parity"></asp:TextBox>
                               <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtNoDead" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                               
                                    </td>
                            </tr>
                            
                           <tr>
                                <td class="GridViewLabItemStyle">
                                 Date Of Last Devivery
                                </td>
                                <td class="GridViewLabItemStyle"> 
                                      <asp:TextBox ID="txtDateOfLastDelivery" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDateOfLastDelivery"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                                </td>
                                
                                <td class="GridViewLabItemStyle">Mode Of Last Delivery
                                   
                                    </td>
                                <td class="GridViewLabItemStyle">
                                    
                                     <asp:TextBox ID="txtMode" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Parity"></asp:TextBox>
                               
                                    </td>
                            </tr>
                            <tr>
                                <td class="GridViewLabItemStyle">Current Medication Specify(Y/N)
                                   
                                    </td>
                                <td class="GridViewLabItemStyle">
                                     <asp:RadioButtonList ID="rdbCurrentMedication" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                                     <asp:TextBox ID="txtCurrentMedicationSpecify" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Parity"></asp:TextBox>
                               
                                    
                                    </td>
                          
                                
                                <td class="GridViewLabItemStyle">For Men Surgical history/Genito urinary operations Y/N if specify
                                   
                                    </td>
                                <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbSurgicalHistory" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                                     <asp:TextBox ID="txtSurgicalHistory" autocomplete="off" runat="server"  ClientIDMode="Static"
                                     ToolTip="Enter Parity"></asp:TextBox>
                               
                                    
                                    </td>
                                  </tr>
                            </table>
                        <table style="width:100%;">
                             <tr>
                                	<th class="GridViewHeaderStyle" colspan="6">Medical Surgical History/Medical Eligibility criteria(MEC):</th>
                            </tr>
                            <tr>
                                	<th class="GridViewHeaderStyle" colspan="6">Indicate Y/N as Possible</th>
                            </tr>
                            <tr>
                                	<th  class="GridViewLabItemStyle">Condition</th> 	<th class="GridViewLabItemStyle" >History</th> 	<th class="GridViewLabItemStyle" >Observed</th>
                                <th  class="GridViewLabItemStyle">Condition</th> 	<th  class="GridViewLabItemStyle">History</th> 	<th  class="GridViewLabItemStyle">Observed</th>
                            </tr>
                            <tr>
                             <td class="GridViewLabItemStyle">Smoking</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbSmoking1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbSmoking2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">Hypertension</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbHypertension1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbHypertension2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">Alcohol Use</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbAlcohol1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbAlcohol2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">Dibetes</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbDibetes1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbDibetes2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">Jaundice</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbJaundice1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbJaundice2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">Cardiac desease</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbCardiac1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbCardiac2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">HIV/AIDS</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbHIV1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbHIV2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">Goitre</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbGoitre1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbGoitre2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">RT cancer</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbRTCancer1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbRTCancer2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">Tuberculosis</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbTuberculosis1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbTuberculosis2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">Varicos Veins</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbVaricos1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbVaricos2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">DVT</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbDVT1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbDVT2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">STI/RTI/</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbSTI1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbSTI2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">Epilepsy</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbEpilepsi1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbEpilepsi2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">PID</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbPID1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbPID2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">Uterine Fibroids</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbUterine1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbUterine2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">Other</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbOther1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbOther2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                                
                             <td class="GridViewLabItemStyle">Migraine</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbMigraine1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbMigraine2" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                            
                                    </tr>
                            <tr>
                             <td class="GridViewLabItemStyle">Has Client undergone any surgery specify if yes</td>
                                <td class="GridViewLabItemStyle">
                                <asp:RadioButtonList ID="rdbSurgery" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            </td>
                                 <td class="GridViewLabItemStyle">
                                <asp:TextBox ID="txtSuergerySpecify" autocomplete="off" runat="server"  ClientIDMode="Static"
                                    onchange="return bp()" TabIndex="15"  ></asp:TextBox>
                                </td>
                        </table>

                          <table style="width:100%;">
                            <tr>
                                	<th class="GridViewHeaderStyle" colspan="3">Physical Examination (Indicate as Possible)</th>
                            </tr>
                            <tr>
                                	<th  class="GridViewLabItemStyle">Area</th> 	<th class="GridViewLabItemStyle" >Normal/Abnormal</th>
                                <th  class="GridViewLabItemStyle">Specify</th> 	
                            </tr>
                            <tr>
                             <td class="GridViewLabItemStyle">Breast</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbBreast" runat="server" RepeatDirection="Horizontal"  >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtBreast1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                
                             
                                    </tr>
                            
                            <tr>
                             <td class="GridViewLabItemStyle">Abdomen</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbAbdomen" runat="server" RepeatDirection="Horizontal"   >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtAbdomen1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                
                             
                                    </tr>
                              
                            <tr>
                             <td class="GridViewLabItemStyle">External Genitalia</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbExternal" runat="server" RepeatDirection="Horizontal"   >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtExternal1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                
                             
                                    </tr>
                            <tr>
                             <td class="GridViewLabItemStyle">Veginal Discharge</td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbVeginal" runat="server" RepeatDirection="Horizontal"   >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtVeginal1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                
                             
                                    </tr>
                              <tr>
                             <td class="GridViewLabItemStyle">Cervix </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbCervix" runat="server" RepeatDirection="Horizontal"   >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtCervix1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                
                             
                                    </tr>
                              <tr>
                             <td class="GridViewLabItemStyle">Uterus </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbUterus" runat="server" RepeatDirection="Horizontal"   >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtUterus1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                    </tr>
                              <tr>
                             <td class="GridViewLabItemStyle">Adnexae </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbAdnexae" runat="server" RepeatDirection="Horizontal"   >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtAdnexae1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                    </tr>
                             <tr>
                             <td class="GridViewLabItemStyle">Other Systems </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbOtherSystems" runat="server" RepeatDirection="Horizontal"   >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtOtherSystems1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                    </tr>
                              <tr>
                             <td class="GridViewLabItemStyle">Disability Specify </td>
                             <td class="GridViewLabItemStyle">
                                           <asp:RadioButtonList ID="rdbDisability" runat="server" RepeatDirection="Horizontal"   >
                                              <asp:ListItem Value="1">Normal</asp:ListItem>
                                          <asp:ListItem Value="2">Abnormal</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                               </td>
                             <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtDisability1" autocomplete="off" runat="server"  ClientIDMode="Static" Width="400px"
                                     ToolTip="Specify"></asp:TextBox>
                               
                               </td>
                                    </tr>
                              <tr>
                             <td class="GridViewLabItemStyle" colspan="1" style="width:33%;">For male clients perform a scrotal examination to rule out infections swellings presence or absence of testies screen for breast and prostate cancer(Type of screening PSA/DRA) results </td>
                             <td class="GridViewLabItemStyle"  colspan="2">
                               <asp:TextBox ID="TextBox1" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip="Result"></asp:TextBox>
                               </td>
                                  </tr>
                              </table>
                        
                <table style="width: 100%; border-collapse: collapse">
                            <tr>
                                	<th class="GridViewHeaderStyle" colspan="6">Counselling</th>
                            </tr>
                              <tr>
                                	<th class="GridViewLabItemStyle" colspan="6">FP Counseling done using appropriate FP Method specific checklist Y/N (if not done counsel client)
                                        incase of disability use appropriate communication method/interventions
                                	</th>
                            </tr>
                              <tr>
                                	<th class="GridViewHeaderStyle" colspan="6">Method of Contraception Adapted</th>
                            </tr>
                            
                            <tr>
                                	 <td class="GridViewLabItemStyle">IUCD:Type</td>
                                	 <td class="GridViewLabItemStyle" style="width:400px;">
                               <asp:TextBox ID="txtIUCDType" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Batch No</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtIUCDBatch" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Expiry Date</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:TextBox ID="txtIUCDExpiryDate" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtIUCDExpiryDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                                	 </td>	
                            </tr>
                            <tr>
                                	 <td class="GridViewLabItemStyle">Implant:Type</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtImplantType" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Batch No</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtImplantBatch" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Expiry Date</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:TextBox ID="txtImplantExpiryDate" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         
                                         <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtImplantExpiryDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                                	 </td>	
                            </tr>
                     <tr>
                                	 <td class="GridViewLabItemStyle" colspan="2">Permanent Methods:Female sterilization(BTL) / Male Sterilization Vasectomy fertility Awareness based Methods </td>
                                	 
                                	 <td class="GridViewLabItemStyle">Type</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtPermanentType" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">LAM</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtPermanentLAM" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                           </tr>
                    <tr>
                                	 <td class="GridViewLabItemStyle">Injection:Type</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtInjectionType" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Batch No</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtInjectionBatch" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Expiry Date</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:TextBox ID="txtInjectionExpiryDate" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         
                                         <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtInjectionExpiryDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                                	 </td>	
                            </tr>
                    <tr>
                                	 <td class="GridViewLabItemStyle" colspan="2">
                                         <table style="width:100%;"><tr><td style="width:25%;">Pill:Type</td><td style="width:25%;">
                                             <asp:TextBox ID="txtPillType" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox></td>
                                             <td style="width:25%;">No Of Cycles</td><td style="width:25%;">
                                             <asp:TextBox ID="txtPillNoOfCycles" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox></td></tr></table></td>
                                	 <td class="GridViewLabItemStyle">Batch No</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtPillBatch" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Expiry Date</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:TextBox ID="txtPillExpiryDate" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         
                                         <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtPillExpiryDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                                	 </td>	
                            </tr>
                    <tr>
                                	 <td class="GridViewLabItemStyle" colspan="2">
                                         <table style="width:100%;"><tr><td style="width:25%;">Condoms:Type</td><td style="width:25%;">
                                             <asp:TextBox ID="txtCondomsType" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox></td>
                                             <td style="width:25%;">No Issued</td><td style="width:25%;">
                                             <asp:TextBox ID="txtCondomsNoIssued" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox></td></tr></table></td>
                                	 <td class="GridViewLabItemStyle">Batch No</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtCondomsBatch" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Expiry Date</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:TextBox ID="txtCondomsExpiryDate" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         
                                         <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtCondomsExpiryDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                                	 </td>	
                            </tr>
                             <tr>
                                	 <td class="GridViewLabItemStyle">ECPs:Batch No</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtECPsBatch" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle">Expiry Date</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:TextBox ID="txtECPsExpiryDate" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         
                                         <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtECPsExpiryDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                                	 </td>	
                                 <td class="GridViewLabItemStyle">Dual Method Use</td>
                                	 <td class="GridViewLabItemStyle">
                                         <table style="width:100%;"><tr><td>
                                             <asp:RadioButtonList ID="rdbDual" runat="server" RepeatDirection="Horizontal"  >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
 
                                                    </td>
                                             <td>
                                                 <asp:TextBox ID="txtDual1" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                             </td>
                                                </tr></table>
                                          
                               </td>
                            </tr>
                   <tr>
                                	 <td class="GridViewLabItemStyle">Others(Specify)</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtOthersSpecify" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                       
                                	 <td class="GridViewLabItemStyle">None</td>
                                	 <td class="GridViewLabItemStyle">
                               <asp:TextBox ID="txtNone" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>
                                	 <td class="GridViewLabItemStyle"></td>
                             </tr>
                    <tr>
                             
                                	 <td class="GridViewLabItemStyle">Reason</td>
                                	 <td class="GridViewLabItemStyle" colspan="6">
                               <asp:TextBox ID="txtReason" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>

                                	 </td>

                     </tr>
                    </table>
                        
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                                	<th class="GridViewHeaderStyle" colspan="8">Other Services Provided</th>
                            </tr>
                            <tr>
                                
                                	 <td class="GridViewLabItemStyle">HTC</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:RadioButtonList ID="rdbHTC" runat="server" RepeatDirection="Horizontal"  >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                	 </td>
                                
                                	 <td class="GridViewLabItemStyle">Results</td>
                                	 <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtHTCResults" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         </td>
                                
                                	 <td class="GridViewLabItemStyle">CA Cervix Screening</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:RadioButtonList ID="rdbCA" runat="server" RepeatDirection="Horizontal"  >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                	 </td>
                                
                                	 <td class="GridViewLabItemStyle">Method Used</td>
                                	 <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtMethodUsed" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         </td>
                            </tr>
                    <tr>
                        
                                	 <td class="GridViewLabItemStyle">Results</td>
                                	 <td class="GridViewLabItemStyle" colspan="7">
                                          <asp:TextBox ID="txtResults" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         </td>
                        
                    </tr>
                             <tr>
                                
                                	 <td class="GridViewLabItemStyle">STI/RTI Screening</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:RadioButtonList ID="rdbSTI" runat="server" RepeatDirection="Horizontal"  >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                	 </td>
                                
                                	 <td class="GridViewLabItemStyle">Results</td>
                                	 <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtSTIResults" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         </td>
                                
                                	 <td class="GridViewLabItemStyle">Prostate Cancer Screening</td>
                                	 <td class="GridViewLabItemStyle">
                                         <asp:RadioButtonList ID="rdbSTIProstat" runat="server" RepeatDirection="Horizontal"  >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                	 </td>
                                
                                	 <td class="GridViewLabItemStyle"></td>
                                	 <td class="GridViewLabItemStyle">
                                          <asp:TextBox ID="txtSTI" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         </td>
                            </tr>
                    <tr>
                        
                                	 <td class="GridViewLabItemStyle">Results</td>
                                	 <td class="GridViewLabItemStyle" colspan="7">
                                          <asp:TextBox ID="txtResults2" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         </td>
                        
                    </tr>
                    <tr>
                        
                                	 <td class="GridViewLabItemStyle">Referral</td>
                                	 <td class="GridViewLabItemStyle" colspan="1">
                                         <asp:RadioButtonList ID="rdbReferral" runat="server" RepeatDirection="Horizontal"  >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList></td>
                        
                                	 <td class="GridViewLabItemStyle">Reason Of Referral</td>
                                	 <td class="GridViewLabItemStyle" colspan="5"><asp:TextBox ID="txtReferralReason" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox></td>
                    </tr>
                    <tr>
                        
                                	 <td class="GridViewLabItemStyle">Summary/Comment</td>
                                	 <td class="GridViewLabItemStyle" colspan="7">
                                          <asp:TextBox ID="txtSummary" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         </td>
                        
                    </tr>
                    <tr>
                        
                                	 <td class="GridViewLabItemStyle">Service Provider</td>
                                	 <td class="GridViewLabItemStyle" colspan="4">
                                          <asp:TextBox ID="txtServiceProvider" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                                         </td>
                        
                        <td class="GridViewLabItemStyle" colspan="1">Return Date
                                     </td>
                        <td class="GridViewLabItemStyle" colspan="1">
                                          <asp:TextBox ID="txtReturnDate" autocomplete="off" runat="server"  ClientIDMode="Static" 
                                     ToolTip=""></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtReturnDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                                         </td>
                                	 <td class="GridViewLabItemStyle"></td>
                        
                    </tr>
                    
                    
                   
                       </table>
                    </div>
                                   </div>
                               
                    </div>
                               </div>
                </div>
                 
 
                <div class="row" style="display:none;">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    BP
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtBp" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onchange="return bp()" TabIndex="15" MaxLength="7" ToolTip="Enter BP"></asp:TextBox>
                                <span class="style2">mm/Hg</span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pulse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtP" autocomplete="off" runat="server"  Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="16" MaxLength="5"
                                    ToolTip="Enter p"></asp:TextBox>
                                <span class="style2">bpm</span>
                                <cc1:FilteredTextBoxExtender ID="fttxtP" runat="server" TargetControlID="txtP" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Resp
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtR" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="17" MaxLength="5"
                                    ToolTip="Enter R"></asp:TextBox><span class="style2">/min</span><span style="color: Red; font-size: 8px;"></span>
                                <cc1:FilteredTextBoxExtender ID="fttxtR" runat="server" TargetControlID="txtR" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Temp.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtT" autocomplete="off" runat="server" Width="49px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="18" MaxLength="5"
                                    ToolTip="Enter T"></asp:TextBox>
                                <%--      <span class="style2">&deg;C</span><span style="color: Red; font-size: 8px;"></span>--%>
                                <asp:DropDownList ID="ddltemperature" runat="server" Width="56px">
                                    <asp:ListItem Value="C">&deg;C</asp:ListItem>
                                    <asp:ListItem Value="F">&deg;F</asp:ListItem>
                                </asp:DropDownList>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtT"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    HT
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtHt" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="19" MaxLength="5"
                                    ToolTip="Enter HT" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbHT" runat="server" TargetControlID="txtHt" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                               <%-- <span class="style2">CM</span>--%>
                                  <asp:DropDownList ID="ddlHeightType" runat="server" Width="56px">
                                    <asp:ListItem Value="CM">CM</asp:ListItem>
                                    <asp:ListItem Value="Inch">Inch</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    WT
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtWt" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter WT" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbWt" runat="server" TargetControlID="txtWt" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                              <%--  <span class="style2">Kg</span>--%>
                                 <asp:DropDownList ID="ddlWeightType" runat="server" Width="56px">
                                    <asp:ListItem Value="KG">KG</asp:ListItem>
                                    <asp:ListItem Value="POUND">POUND</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Arm Span
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtArmSpan" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Arm Span" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2">CM</span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtArmSpan"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Sitting Height
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtSittingHeight" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbSitting" runat="server" TargetControlID="txtSittingHeight" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2">CM</span>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    IBW
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtIBW" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter IBW" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2">Kg</span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtIBW"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    SPO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtSPO2" autocomplete="off" runat="server" Width="50px"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter SPO2 Percentage" AutoCompleteType="None"></asp:TextBox>&nbsp;%
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtSPO2"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Blood Glucose
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtCBG" autocomplete="off" runat="server" Width="50px" TabIndex="21" MaxLength="10" ToolTip="Enter Capilary Blood Glucose" AutoCompleteType="None"></asp:TextBox>
                                &nbsp;mmol/L
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pain Score
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-3">
                                <asp:TextBox ID="txtPainScore" autocomplete="off" runat="server" Width="50px"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="22" MaxLength="5"
                                    ToolTip="Enter Pain Score" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtPainScore"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>

                        </div>
 <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Remark
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-20">
                                <asp:TextBox ID="txtRemark" autocomplete="off" runat="server" Width="97%" TabIndex="23" MaxLength="200" ToolTip="Enter Remarks" AutoCompleteType="None"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right; display: none">BF:</td>
                        <td style="display: none">
                            <asp:TextBox ID="txtBF" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtBF"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align: right; display: none">MUAC:</td>
                        <td style="display: none">
                            <asp:TextBox ID="txtMuac" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">CM</span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtBF"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td style="text-align: right;">FBS:</td>
                        <td>
                            <asp:TextBox ID="txtFBS" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter FBS" AutoCompleteType="None"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtFBS"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            <span class="style2">mmol/L</span>
                        </td>
                        <td style="text-align: right;">TW:</td>
                        <td>
                            <asp:TextBox ID="txtTw" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">Kg</span></td>
                        <td style="text-align: right;">VF:</td>
                        <td>
                            <asp:TextBox ID="txtVf" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                        <td style="text-align: right;">MUSCLE:</td>
                        <td>
                            <asp:TextBox ID="txtMuscle" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                        <td style="text-align: right;">RM:</td>
                        <td>
                            <asp:TextBox ID="txtRm" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">Kcal</span></td>
                        <td style="text-align: right;">WFA:</td>
                        <td>
                            <asp:TextBox ID="txtWFA" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                    </tr>
                    <tr style="display: none">
                        <td style="text-align: right;">BMIFA:</td>
                        <td>
                            <asp:TextBox ID="txtBMIFA" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: middle; text-align: center" colspan="12">
                            <asp:Label ID="lblBmi" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                            <asp:TextBox ID="txtBMI" runat="server" Style="display: none" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="lblID" Text="" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                        </td>
                    </tr>

                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">

                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static" OnClientClick="return chkVital(this)" TabIndex="69" OnClick="btnSave_Click" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="false" ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return chkVital(this)" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" OnClick="btnCancel_Click" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ServiceArea">
                            <ItemTemplate>
                                <asp:Label ID="lblServiceArea" runat="server" Text='<%#Eval("ServiceArea") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Highest">
                            <ItemTemplate>
                                <asp:Label ID="lblHighest" runat="server" Text='<%#Eval("Highest") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LMP">
                            <ItemTemplate>
                                <asp:Label ID="lblLMP" runat="server" Text='<%#Eval("LMP") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Regular">
                            <ItemTemplate>
                                <asp:Label ID="lblRegular" runat="server" Text='<%#Eval("Regular") %>'></asp:Label>
                               </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BleedingDays">
                            <ItemTemplate>
                                <asp:Label ID="lblBleedingDays" runat="server" Text='<%#Eval("BleedingDays") %>'></asp:Label>
                                <asp:Label ID="lblIsCurrent" runat="server" Text='<%#Eval("IsCurrent") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCurrent" runat="server" Text='<%#Eval("Current") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIsPregnant" runat="server" Text='<%#Eval("IsPregnant") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPregnant" runat="server" Text='<%#Eval("Pregnant") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIsBreastFeeding" runat="server" Text='<%#Eval("IsBreastFeeding") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblNoOfDesiredChildren" runat="server" Text='<%#Eval("NoOfDesiredChildren") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblParity" runat="server" Text='<%#Eval("Parity") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblNoLiving" runat="server" Text='<%#Eval("NoLiving") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblNoDead" runat="server" Text='<%#Eval("NoDead") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDateOfLastDelivery" runat="server" Text='<%#Eval("DateOfLastDelivery1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMode" runat="server" Text='<%#Eval("Mode") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIsCurrentMedication" runat="server" Text='<%#Eval("IsCurrentMedication") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCurrentMedication" runat="server" Text='<%#Eval("CurrentMedication") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIsOperations" runat="server" Text='<%#Eval("IsOperations") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblOperations" runat="server" Text='<%#Eval("Operations") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSmoking1" runat="server" Text='<%#Eval("Smoking1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSmoking2" runat="server" Text='<%#Eval("Smoking2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblHypertension1" runat="server" Text='<%#Eval("Hypertension1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblHypertension2" runat="server" Text='<%#Eval("Hypertension2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblAlcohol1" runat="server" Text='<%#Eval("Alcohol1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblAlcohol2" runat="server" Text='<%#Eval("Alcohol2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDibetes1" runat="server" Text='<%#Eval("Dibetes1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDibetes2" runat="server" Text='<%#Eval("Dibetes2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblJaundice1" runat="server" Text='<%#Eval("Jaundice1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblJaundice2" runat="server" Text='<%#Eval("Jaundice2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCardiac1" runat="server" Text='<%#Eval("Cardiac1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCardiac2" runat="server" Text='<%#Eval("Cardiac2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblHIV1" runat="server" Text='<%#Eval("HIV1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblHIV2" runat="server" Text='<%#Eval("HIV2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblGoitre1" runat="server" Text='<%#Eval("Goitre1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblGoitre2" runat="server" Text='<%#Eval("Goitre2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCancer1" runat="server" Text='<%#Eval("Cancer1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCancer2" runat="server" Text='<%#Eval("Cancer2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblTuberculosis1" runat="server" Text='<%#Eval("Tuberculosis1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblTuberculosis2" runat="server" Text='<%#Eval("Tuberculosis2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVaricos1" runat="server" Text='<%#Eval("Varicos1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVaricos2" runat="server" Text='<%#Eval("Varicos2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDVT1" runat="server" Text='<%#Eval("DVT1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDVT2" runat="server" Text='<%#Eval("DVT2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSTI1" runat="server" Text='<%#Eval("STI1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSTI2" runat="server" Text='<%#Eval("STI2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblEpilepsy1" runat="server" Text='<%#Eval("Epilepsy1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblEpilepsy2" runat="server" Text='<%#Eval("Epilepsy2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPID1" runat="server" Text='<%#Eval("PID1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPID2" runat="server" Text='<%#Eval("PID2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUterine1" runat="server" Text='<%#Eval("Uterine1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUterine2" runat="server" Text='<%#Eval("Uterine2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblOther1" runat="server" Text='<%#Eval("Other1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblOther2" runat="server" Text='<%#Eval("Other2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMigraine1" runat="server" Text='<%#Eval("Migraine1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMigraine2" runat="server" Text='<%#Eval("Migraine2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIssurgery" runat="server" Text='<%#Eval("Issurgery") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSurgery" runat="server" Text='<%#Eval("Surgery") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIUCDType" runat="server" Text='<%#Eval("IUCDType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIUCDBatch" runat="server" Text='<%#Eval("IUCDBatch") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIUCDExpiryDate" runat="server" Text='<%#Eval("IUCDExpiryDate1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblImplantType" runat="server" Text='<%#Eval("ImplantType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblImplantBatch" runat="server" Text='<%#Eval("ImplantBatch") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblImplantExpiryDate" runat="server" Text='<%#Eval("ImplantExpiryDate1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPermanentType" runat="server" Text='<%#Eval("PermanentType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPermanentLAM" runat="server" Text='<%#Eval("PermanentLAM") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblInjectionType" runat="server" Text='<%#Eval("InjectionType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblInjectionBatch" runat="server" Text='<%#Eval("InjectionBatch") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblInjectionExpiryDate" runat="server" Text='<%#Eval("InjectionExpiryDate1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPillType" runat="server" Text='<%#Eval("PillType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPillNoOfCycles" runat="server" Text='<%#Eval("PillNoOfCycles") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPillBatch" runat="server" Text='<%#Eval("PillBatch") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPillExpiryDate" runat="server" Text='<%#Eval("PillExpiryDate1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCondomsType" runat="server" Text='<%#Eval("CondomsType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCondomsNoIssued" runat="server" Text='<%#Eval("CondomsNoIssued") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCondomsBatch" runat="server" Text='<%#Eval("CondomsBatch") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCondomsExpiryDate" runat="server" Text='<%#Eval("CondomsExpiryDate1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblECPsBatch" runat="server" Text='<%#Eval("ECPsBatch") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblECPsExpiryDate" runat="server" Text='<%#Eval("ECPsExpiryDate1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblECPsDual" runat="server" Text='<%#Eval("ECPsDual") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblOthersSpecify" runat="server" Text='<%#Eval("OthersSpecify") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblNone" runat="server" Text='<%#Eval("None") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblReason" runat="server" Text='<%#Eval("Reason") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblHTC" runat="server" Text='<%#Eval("HTC") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblHTCResults" runat="server" Text='<%#Eval("HTCResults") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCA" runat="server" Text='<%#Eval("CA") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMethodUsed" runat="server" Text='<%#Eval("MethodUsed") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblResults" runat="server" Text='<%#Eval("Results") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSTI" runat="server" Text='<%#Eval("STI") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSTIResults" runat="server" Text='<%#Eval("STIResults") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSTIProstat" runat="server" Text='<%#Eval("STIProstat") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSTI3" runat="server" Text='<%#Eval("STI3") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblReferral" runat="server" Text='<%#Eval("Referral") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblReferralReason" runat="server" Text='<%#Eval("ReferralReason") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblSummary" runat="server" Text='<%#Eval("Summary") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblServiceProvider" runat="server" Text='<%#Eval("ServiceProvider") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblReturnDate" runat="server" Text='<%#Eval("ReturnDate1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblBreast" runat="server" Text='<%#Eval("Breast") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblBreast1" runat="server" Text='<%#Eval("Breast1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblAbdomen" runat="server" Text='<%#Eval("Abdomen") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblAbdomen1" runat="server" Text='<%#Eval("Abdomen1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblExternal" runat="server" Text='<%#Eval("External") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblExternal1" runat="server" Text='<%#Eval("External1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVeginal" runat="server" Text='<%#Eval("Veginal") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVeginal1" runat="server" Text='<%#Eval("Veginal1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCervix" runat="server" Text='<%#Eval("Cervix") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCervix1" runat="server" Text='<%#Eval("Cervix1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUterus" runat="server" Text='<%#Eval("Uterus") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUterus1" runat="server" Text='<%#Eval("Uterus1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblAdnexae" runat="server" Text='<%#Eval("Adnexae") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblAdnexae1" runat="server" Text='<%#Eval("Adnexae1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblOtherSpecify" runat="server" Text='<%#Eval("OtherSpecify") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblOtherSpecify1" runat="server" Text='<%#Eval("OtherSpecify1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDisability" runat="server" Text='<%#Eval("Disability") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDisability1" runat="server" Text='<%#Eval("Disability1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblDual1" runat="server" Text='<%#Eval("Dual1") %>' Visible="false"></asp:Label>
                               </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                   <asp:TemplateField HeaderText=" Entry Date" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry Time" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit" >
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   Width="50"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit1" AlternateText="Edit" CommandName="Print" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/print.gif" runat="server" />
                                                <asp:Label ID="lblID1" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="60" />
                        </asp:TemplateField>
                    
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </form>
</body>
</html>
