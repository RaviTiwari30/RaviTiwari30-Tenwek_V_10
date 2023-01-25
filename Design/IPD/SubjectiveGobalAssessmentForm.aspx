<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SubjectiveGobalAssessmentForm.aspx.cs" Inherits="Design_IPD_SubjectiveGobalAssessmentForm" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%-- <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>
    <style type="text/css">
        #rdbUnderP td{
       width:200px;
             }
        #rdbTriceps td {
       width:200px;
             }
        #rdbRobs td {
       width:200px;
             }
        
        #rdbTemple td {
       width:200px;
             }
        #rdbClavicle  td {
       width:200px;
             }
        
        #rdbShoulder td {
       width:200px;
             }
        
        #rdbScapula  td {
       width:200px;
             }
        
        #rdbQuadriceps  td {
       width:200px;
             }
        
        #rdbInterrosseous  td {
       width:200px;
             }
           
        #rdbEdema  td {
       width:200px;
             }
        #rdbAscites  td {
       width:200px;
             }
    </style>
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
   <%-- <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');
            //bindData();
            $("#txtGlascowComaScaleScore").blur(function () {
                if ($("#txtGlascowComaScaleScore").val() > 20) {
                    modelAlert("Glascow Coma Scale Score can not exceed 20", function () {
                        $("#txtGlascowComaScaleScore").val("");
                        $("#txtGlascowComaScaleScore").focus();
                    });


                }
                else {
                    $("#lblGlascowComaScaleScore1").text($("#txtGlascowComaScaleScore").val());
                }

            });
        });
        function validate() {
            if ($('#txtFacial').val() == "" && $('#txtCry').val() == "" && $('#txtBreathing').val() == "" && $('#txtArms').val() == "" && $('#txtLegs').val() == "" && $('#txtState').val() == "" && $('#txtTotal').val() == "" && $('#txtAction').val() == "") {
                modelAlert("Please Fill Details.", function () { });
                return false;
            }
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <div class="Purchaseheader" style="text-align: center">
                  <b>Subjective Global Assessment Form </b>
                </div>
 
             
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            
 
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-2" >Date
                        </div>
                     <div class="col-md-5">
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                                   <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                        </div>
                     <div class="col-md-2" >Time
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
                 
 
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="row">
                    <div class="col-md-24">
                             <table style="width:100%;" class="FixedTables" >
                            <tr style='background-color:gray;color:white;text-align:left;'>
                                <th class="GridViewLabItemStyle" scope="col" colspan="3" >Nutrient Intake</th>
                                

                            </tr>
                                 <tr>
                            <td class="GridViewLabItemStyle"   colspan="3"    >
                              1.  <asp:CheckBox ID="chkNoChange" runat="server" Text="No Change Adequate"/>  

                            </td></tr>
                             <tr>
                            <td class="GridViewLabItemStyle"   colspan="2"    >
                              2. Inadequate duration of inadequate intake  
                            </td>
                                 
                            <td class="GridViewLabItemStyle"   colspan="1"    >
                               <asp:TextBox ID="txtInadequate1" CssClass="" runat="server"    ClientIDMode="Static"  ></asp:TextBox>
                                  
                            </td>
                             </tr>
                                   <tr>
                            <td class="GridViewLabItemStyle"   colspan="3"    >
                             <asp:RadioButtonList ID="rdbInadequate2" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Suboptimal solid diet</asp:ListItem>
                                          <asp:ListItem Value="2">Full fluids or only oral nutrition suppliments</asp:ListItem>
                                          <asp:ListItem Value="3">Minimal intake clear fluids or starvation</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                            </td></tr>
                                 <tr>
                                <th class="GridViewLabItemStyle" scope="col" colspan="3" >3.NutrientIntake in past 2 weeks*</th>
                                

                            </tr>
                            
                                <tr>
                            <td class="GridViewLabItemStyle"   colspan="2"    >
                             <asp:RadioButtonList ID="rdbNutrient1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Adequate</asp:ListItem>
                                          <asp:ListItem Value="2">Improved but not adequate</asp:ListItem>
                                          <asp:ListItem Value="3">No Improvement or Inadequate</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                            </td>
                                    
                            <td class="GridViewLabItemStyle"   colspan="1"    >
                                <asp:TextBox ID="txtNutrient2" CssClass="" runat="server"    ClientIDMode="Static"  ></asp:TextBox>
                               
                                </td>
                                </tr>
                              <tr style="background-color:gray;color:white;text-align:left;">
                                <th class="GridViewLabItemStyle" scope="col" colspan="1" >Weight (kg)</th>
                                <th class="GridViewLabItemStyle" scope="col" colspan="1" ><table style="width:100%;" ><tr><td>Usual Weight (kg)
                                    </td><td>
                                     <asp:TextBox ID="txtUsual" CssClass="" runat="server" Width="80px"  ClientIDMode="Static"  ></asp:TextBox>
                                </td></tr></table>
                                </th>
                                <th class="GridViewLabItemStyle" scope="col" colspan="1" ><table style="width:100%;" ><tr><td>Current Weight (kg)</td><td>
                                    <asp:TextBox ID="txtCurrent" CssClass="" runat="server" Width="80px"  ClientIDMode="Static"  ></asp:TextBox>
                                    </td></tr></table>
                               
                                </th>
                                
                            </tr>
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >1.Nonfluid weight change past 6 months</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Weight loss (kg)</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                    <asp:TextBox ID="txtWeightLoss1" CssClass="" runat="server"    ClientIDMode="Static"  ></asp:TextBox>
                                    
                                </td>
                              </tr>
                                  <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                    <asp:RadioButtonList ID="rdbWeightLoss2" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >< 5% loss or  weight stability</asp:ListItem>
                                          <asp:ListItem Value="2">5-10% loss without stablization or increase</asp:ListItem>
                                          <asp:ListItem Value="3">>10% loss or ongoing </asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                </td>
                                
                              </tr>
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                    If above not known has there been a subjective loss of weight during  the past 6 months?
                                  </td>
                                     </tr>
                                <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                    <asp:RadioButtonList ID="rdbloss" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >None or mild</asp:ListItem>
                                          <asp:ListItem Value="2">Moderate</asp:ListItem>
                                          <asp:ListItem Value="3">Severe</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                </td>
                                
                              </tr>
                             <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                    Weight change past 2 weeks
                                  </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                    Amount (If known)
                                  </td>
                                 
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                     <asp:TextBox ID="txtAmount" CssClass="" runat="server" Width="70px"    ClientIDMode="Static"  ></asp:TextBox>
                                   
                                  </td>
                                     </tr>
                                <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                    <asp:RadioButtonList ID="rdbChange" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Increased</asp:ListItem>
                                          <asp:ListItem Value="2">No change</asp:ListItem>
                                          <asp:ListItem Value="3">Decreased</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                </td>
                                
                              </tr>
                                 <tr style="background-color:gray;color:white;text-align:left;">
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
       Symptoms (experiencing symptoms affecting oral intake)
                                  </td>
                             </tr>
                                  <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   1. <asp:CheckBoxList id="chkSymptoms1"  runat= "server" RepeatDirection="Horizontal">
                                            <asp:ListItem Value="1"> Pain on eating </asp:ListItem>
                                            <asp:ListItem Value="2"> Anorexia </asp:ListItem>
                                            <asp:ListItem Value="3"> Vomiting </asp:ListItem>
                                            <asp:ListItem Value="4"> Nausea </asp:ListItem>
                                            <asp:ListItem Value="5"> Dysphagia </asp:ListItem>
                                            <asp:ListItem Value="6"> Diarrhea </asp:ListItem>
                                            <asp:ListItem Value="7"> Dental problems </asp:ListItem>
                                            <asp:ListItem Value="8"> Feels full quickly</asp:ListItem>
                                            <asp:ListItem Value="9"> Constipation </asp:ListItem>
                                             
                                        </asp:CheckBoxList>

                                </td>
                             </tr>
                                 
                                  <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   2. <asp:RadioButtonList ID="rdbSymptoms2" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >None</asp:ListItem>
                                          <asp:ListItem Value="2">Intermittent/Mild/Few</asp:ListItem>
                                          <asp:ListItem Value="3">Contstant/Severe/Multiple</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                           
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   3. Symptoms in past 2 weeks
                                  </td>
                             </tr>
                                        <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   2. <asp:RadioButtonList ID="rdbSymptoms3" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Resolution of Symptoms</asp:ListItem>
                                          <asp:ListItem Value="2">Improving</asp:ListItem>
                                          <asp:ListItem Value="3">No change or worsened</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                                 
                                 <tr style="background-color:gray;color:white;text-align:left;">
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   Functional capacity(fatigue and progressive loss of function)
                                  </td>
                             </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >1.No dysfunction</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                   <asp:RadioButtonList ID="rdbNoDysfunction" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                           <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Reduced capacity duration of change</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                    <asp:TextBox ID="txtReduced1" CssClass="" runat="server" Width="70px"    ClientIDMode="Static"  ></asp:TextBox>
                                    </td>
                                      </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   <asp:RadioButtonList ID="rdbReduced2" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Difficulty with ambulation/normal activities</asp:ListItem>
                                          <asp:ListItem Value="2">Bed/chair-ridden</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                           
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   Functional capacity in the past 2 weeks*
                                  </td>
                             </tr>
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   <asp:RadioButtonList ID="rdbFunctional" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Improved</asp:ListItem>
                                          <asp:ListItem Value="2">No change</asp:ListItem>
                                          <asp:ListItem Value="3">Decreased</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                            <tr style="background-color:gray;color:white;text-align:left;">
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   Metabolic requirement
                                  </td>
                             </tr>
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >High Metabolic Requirement</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                   <asp:RadioButtonList ID="rdbHigh" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                                 
                                 
                           <tr style="background-color:gray;color:white;text-align:left;">
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   Physical Examination
                                  </td>
                             </tr>
                                 
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Loss of body fat</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                   <asp:RadioButtonList ID="rdbLossA" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >No</asp:ListItem>
                                          <asp:ListItem Value="2">Mild/Moderate</asp:ListItem>
                                          <asp:ListItem Value="3">Severe</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                                 
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Loss of muscle mass</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                   <asp:RadioButtonList ID="rdbLossB" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >No</asp:ListItem>
                                          <asp:ListItem Value="2">Mild/Moderate</asp:ListItem>
                                          <asp:ListItem Value="3">Severe</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                                 
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Presence of Edema/ascites</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                   <asp:RadioButtonList ID="rdbPresence" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >No</asp:ListItem>
                                          <asp:ListItem Value="2">Mild/Moderate</asp:ListItem>
                                          <asp:ListItem Value="3">Severe</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                                  <tr style="background-color:gray;color:white;text-align:left;">
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   SGA Rating
                                  </td>
                             </tr>
                          
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   <asp:RadioButtonList ID="rdbSGA" runat="server" RepeatDirection="Vertical"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" ><b>A</b> Well nourished normal</asp:ListItem>
                                          <asp:ListItem Value="2"><b>B</b> Mildly/Moderately malnourished some progressive nutritional loss</asp:ListItem>
                                          <asp:ListItem Value="3"><b>C</b> Severely malnourished evidence of wasting and progressive symptoms</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                                 
                                  <tr style="background-color:gray;color:white;text-align:left;">
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   Contributing Factor
                                  </td>
                             </tr>
                          
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                   <asp:RadioButtonList ID="rdbContributing" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Cauchexia (fat and muscle wasting due to desease and inflammation</asp:ListItem>
                                          <asp:ListItem Value="2">Sarcopenia (reduced muscle mass and strength)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                      </tr>
                                 </table>
                        <div class="Purchaseheader" style="text-align: center">
                  <b>Subcutaneous Fat </b>
                </div>
                        <table style="width:100%;" border="1">
                                 <tr>
                                <th class="GridViewLabItemStyle" scope="col" colspan="3" >Subcutaneous Fat
                            </th>
                                     </tr>
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                    <table style="width:100%;" border="1">
                                        <tr style="background-color:gray;color:white;text-align:center;"><th>Physical Examination</th><th>Normal</th><th style="text-align:center;">Mild/Moderate</th><th>Severe</th></tr>
                                            <tr><td>Under the eyes</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbUnderP" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Slightly bulging area</asp:ListItem>
                                          <asp:ListItem Value="2">Somewhat hollow look,Slightly dark circles</asp:ListItem>
                                          <asp:ListItem Value="3">Hollowed look,depression dark circles</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                         <tr><td>Triceps</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbTriceps" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Large space between fingers</asp:ListItem>
                                          <asp:ListItem Value="2">Some depth to fat tissue but not ample loose fitting skin</asp:ListItem>
                                          <asp:ListItem Value="3">Very little space between fingers or fingers touch</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                    <tr><td>Robs lower back, sides of trunk</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbRobs" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Chest is full,ribs do not show,<br />Slight to no protrusion of the iliac crest</asp:ListItem>
                                          <asp:ListItem Value="2">Ribs obvious but identations are not marked Iliac crest somewhat prominent</asp:ListItem>
                                          <asp:ListItem Value="3">Indentation between ribs very obvious.Iliac crest very prominent</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
     
                                                                       </table>
                                    </td>
                                     </tr>
                                 <tr>
                                <th class="GridViewLabItemStyle" scope="col" colspan="3" >Muscle Wasting
                            </th>
                                     </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                    <table style="width:100%;" border="1">
                                        <tr style="background-color:gray;color:white;text-align:center;"><th>Physical Examination</th><th>Normal</th><th style="text-align:center;">Mild/Moderate</th><th>Severe</th></tr>
                                            <tr><td>Temple</td>
                                                <td colspan="3" > 
                                                    <asp:RadioButtonList ID="rdbTemple" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Well defined muscle</asp:ListItem>
                                          <asp:ListItem Value="2">Slight depression</asp:ListItem>
                                          <asp:ListItem Value="3">Hollowing , depression</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                         <tr><td>Clavicle</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbClavicle" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1"   >Not visible in males ,may be visible <br />but not prominent in females</asp:ListItem>
                                          <asp:ListItem Value="2">Some protrusion may not be all <br />he way along</asp:ListItem>
                                          <asp:ListItem Value="3">Protruding/prominent  bone</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                    <tr><td>Shoulder</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbShoulder" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Rounded</asp:ListItem>
                                          <asp:ListItem Value="2">no square look, acromion process<br /> may protrude slightly</asp:ListItem>
                                          <asp:ListItem Value="3">Square look bones prominent</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                           <tr><td>Scapula/ribs</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbScapula" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Bones not prominent, no significant depressions</asp:ListItem>
                                          <asp:ListItem Value="2">Mild depressions or bone may show slightly not all areas</asp:ListItem>
                                          <asp:ListItem Value="3">Bones prominent, significant depressions</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                                
                                           <tr><td>Quadriceps</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbQuadriceps" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >well defined</asp:ListItem>
                                          <asp:ListItem Value="2">Depression/atrophy medially</asp:ListItem>
                                          <asp:ListItem Value="3">Prominent knee severe depression<br /> medially</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                        <tr><td>Interrosseous muscle between thumb and<br /> forefinger (back of hand)**</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbInterrosseous" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Muscle protrudes could be<br /> flat in females</asp:ListItem>
                                          <asp:ListItem Value="2">Slightly depressed</asp:ListItem>
                                          <asp:ListItem Value="3">Flat or depressed area</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                           
                                                                       </table>
                                    </td>
                                     </tr>
                                  <tr>
                                <th class="GridViewLabItemStyle" scope="col" colspan="3" >Flud Retension
                            </th>
                                     </tr>
                                 <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="3" >
                                    <table style="width:100%;" border="1">
                                        <tr style="background-color:gray;color:white;text-align:center;"><th>Physical Examination</th><th>Normal</th><th style="text-align:center;">Mild/Moderate</th><th>Severe</th></tr>
                                            <tr><td>Edema</td>
                                                <td colspan="3" > 
                                                    <asp:RadioButtonList ID="rdbEdema" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >None</asp:ListItem>
                                          <asp:ListItem Value="2">Pitting edema of extremities/pitting <br />to knees possible secral edema if bedridden</asp:ListItem>
                                          <asp:ListItem Value="3">Pitting beyond knees secral edema if<br /> beridden may also have generalized edema</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                         <tr><td>Ascites</td>
                                                <td colspan="3">
                                                    <asp:RadioButtonList ID="rdbAscites" runat="server" Width="100%" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1">Absent</asp:ListItem>
                                          <asp:ListItem Value="2">Present (may only be present on imaging)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                                </td>
                                                </tr>
                                           
                                                                       </table>
                                    </td>
                                     </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"   colspan="3" >
                                A.Well nourished no decrease in food/nutrient intake<5% weight loss no minimal symptoms affecting food intake no deficit in function no deficit in fat or 
                                muscle mass or an indivisual  with criteria for <br /> SGA A or C but with recent adequate food intake non fluid weight gain significant recent improvement
                                in symptoms allowing adequate oral  intake significant recent improvement in function and chronic deficit fat and muscle mass but with recent clinical improvement in function.
                            <br />
                                B.Mildly/moderatly malnourished definite decrease in food nutrient intake. 5% -10% weight loss without stablization or gain; mild/some symptoms affecting food intake
                                moderate functional deficit or recent deterioration <br />mild/moderate loss of fat and/or muscle mass OR an indivisual meeting criteria for SGA C but with improvement
                                (but not adequate) of oral intake recent stablization of weight decrease in symptoms affecting oral intake and stablization of functional status.
                                <br />
                                C.Severly malnourished sebvere deficit in food/nutrient intake>10% weight loss which is ongoing significant symptoms  affecting food/nutient
                                intake severe functional deficit or recent significant detoriaration obvious sign of fat and/or muscle loss.<br />
                                Cachexia- if there is an underlying predisposing disorder(e.g.malignancy) and there is evidence of reduced mscle and fat and no or limited
                                improvement with optimal nutrient intake this is consistant with cachexia.
                                <br />
                                Sarcopenia-if there is an underlying disorder(e.g. aging) and there is evidence of reduced muscle and strength and no or limited improvement 
                                with optimal nutrient intake.
                            </td>
                                </tr>
                            
                            </table>
                        
                        
                        
                    </div>
                </div>
               
               
               
               
                
                </div>
                
            
            <div class="POuter_Box_Inventory" style="text-align: center">
                
                                                <asp:Label ID="lblID"  runat="server" Visible="FALSE"></asp:Label>
                <asp:Button ID="btnSave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton"  OnClientClick="return validate();"   />
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return validate();" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
               <%--  <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" />
            
              <input type="button" value="Save" id="btnSave" title="Save All Details" onclick="SaveData();" />--%>
            </div>
                 
             <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" Visible="true" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Transaction ID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("TransactionID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                <asp:Label ID="lblCreatedID" runat="server" Text='<%#Eval("CreatedBy") %>' Visible="false"></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time1") %>'></asp:Label>
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
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60" />
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


