<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ICUNutritionAssessment.aspx.cs" Inherits="Design_IPD_ICUNutritionAssessment" %>


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
        .col-md-16 {
              display: flex;
            }
        .col-md-16 > div {
                  border: 1px solid black;
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
             <b>ICU Nutrition Assessment </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                  Subjective Global Assessment Rating Form
                </div>
 
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
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >1.Nutritional Status</td>
                                <td class="GridViewLabItemStyle" scope="col" >
                                     <asp:RadioButtonList ID="rdbNutritional" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Data Not Available</asp:ListItem>
                                          <asp:ListItem Value="2">Good</asp:ListItem>
                                          <asp:ListItem Value="3">Poor</asp:ListItem>
                                          <asp:ListItem Value="4">Malnourished</asp:ListItem>
                                          
                                          
                                      </asp:RadioButtonList>


                                </td>
                                

                            </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >2.Suspected Malnourishment Type</td>
                                <td class="GridViewLabItemStyle" scope="col" >
                                     <asp:RadioButtonList ID="rdbSuspected" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Not Applicable</asp:ListItem>
                                          <asp:ListItem Value="2">Kwashiorkor</asp:ListItem>
                                          <asp:ListItem Value="3">Marasmus</asp:ListItem>
                                          <asp:ListItem Value="4">Mixed</asp:ListItem>
                                          
                                          
                                      </asp:RadioButtonList>


                                </td>
                                

                            </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >3.Factors Contributing To Increased Nutrition Risk</td>
                                </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Suboptimal Intake</td>
                                <td class="GridViewLabItemStyle" scope="col" >
                                     <asp:RadioButtonList ID="rdbSuboptimal" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Not Applicable</asp:ListItem>
                                          <asp:ListItem Value="2">3-6 days</asp:ListItem>
                                          <asp:ListItem Value="3">>=7-10 days</asp:ListItem>
                                          <asp:ListItem Value="4">>=10-20 days</asp:ListItem>
                                          <asp:ListItem Value="5">>=20 days</asp:ListItem>
                                          <asp:ListItem Value="6">>=30 days</asp:ListItem>
                                      </asp:RadioButtonList>
                                     <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label></td>
                           
                                
                               </tr>
                           
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Weight Loss(% over past 6 months)</td>
                                <td class="GridViewLabItemStyle" scope="col" >
                                     <asp:RadioButtonList ID="rdbWeightLoss" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Not Applicable</asp:ListItem>
                                          <asp:ListItem Value="2">10%</asp:ListItem>
                                          <asp:ListItem Value="3">11%-15%</asp:ListItem>
                                          <asp:ListItem Value="4">16%-20%</asp:ListItem>
                                          <asp:ListItem Value="5">>20%</asp:ListItem>
                                      </asp:RadioButtonList>
                                </td>
                               </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Metabolic Stress</td>
                                <td class="GridViewLabItemStyle" scope="col" >
                                     <asp:RadioButtonList ID="rdbMetabolic" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >None</asp:ListItem>
                                          <asp:ListItem Value="2">Mild</asp:ListItem>
                                          <asp:ListItem Value="3">Moderate</asp:ListItem>
                                          <asp:ListItem Value="4">High</asp:ListItem>
                                          <asp:ListItem Value="5">Extreme</asp:ListItem>
                                      </asp:RadioButtonList>
                                </td>
                               </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Substance Abuse</td>
                                <td class="GridViewLabItemStyle" scope="col" >
                                     <asp:RadioButtonList ID="rdbSubstance" runat="server" RepeatDirection="Horizontal" AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Unknown</asp:ListItem>
                                          <asp:ListItem Value="2">ETOH</asp:ListItem>
                                          <asp:ListItem Value="3">Drugs</asp:ListItem>
                                      </asp:RadioButtonList>
                                </td>
                               </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Other</td>
                                <td class="GridViewLabItemStyle" scope="col" >
                                     <asp:RadioButtonList ID="rdbOther" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Large Wound(s)</asp:ListItem>
                                          <asp:ListItem Value="2">High Output fistula</asp:ListItem>
                                          <asp:ListItem Value="3">Chronic Diarrhea</asp:ListItem>
                                      </asp:RadioButtonList>
                                </td>
                               </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >4.Nutrition Risk(Determined from assessment of <br />nutritional status at time of ICU Admit,degree of<br /> metabolic stress,ability to use gut within 48-72 hours of ICU admit)</td>
                                <td class="GridViewLabItemStyle" scope="col" >
                                     <asp:RadioButtonList ID="rdbNutritionRisk" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Low</asp:ListItem>
                                          <asp:ListItem Value="2">Moderate</asp:ListItem>
                                          <asp:ListItem Value="3">High</asp:ListItem>
                                      </asp:RadioButtonList>
                                </td>
                               </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                    <table style="width:100%;">
                                        <tr>
                                            <td class="GridViewLabItemStyle" scope="col" >
                                                Anthropometrics
                                            </td>
                                            
                                            <td class="GridViewLabItemStyle" scope="col" >
                                                Ht
                                                <asp:TextBox ID="txtHt" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                                 cm(actual/est)   
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtHt" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                                
                                            </td>
                                            <td class="GridViewLabItemStyle" scope="col" >
                                                Wt
                                                <asp:TextBox ID="txtWt" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                                 Kg(actual/est)   
                                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtWt" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                                
                                            </td>
                                            <td class="GridViewLabItemStyle" scope="col" >
                                                Corrected Wt
                                                <asp:TextBox ID="txtCorrectedWt" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                                 Kg(actual/est)   
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtCorrectedWt" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                                
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >6.Recommended Nutrition Support
                            </td>

                            </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Timing
                            </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                    <asp:RadioButtonList ID="rdbTiming" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" ><=24 hours</asp:ListItem>
                                          <asp:ListItem Value="2"><=48 hours</asp:ListItem>
                                          <asp:ListItem Value="3"><=72 hours</asp:ListItem>
                                          <asp:ListItem Value="4"><=96 hours</asp:ListItem>
                                          <asp:ListItem Value="5"><=120 hours</asp:ListItem>
                                      </asp:RadioButtonList>
                          
                            </td>
                           </tr>
                            
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Route
                            </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                    <asp:RadioButtonList ID="rdbRoute" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >NG tube</asp:ListItem>
                                          <asp:ListItem Value="2">ND tube</asp:ListItem>
                                          <asp:ListItem Value="3">NJ tube</asp:ListItem>
                                          <asp:ListItem Value="4">G tube</asp:ListItem>
                                          <asp:ListItem Value="5">G-J tube</asp:ListItem>
                                          <asp:ListItem Value="6">J tube</asp:ListItem>
                                          <asp:ListItem Value="7">TPN</asp:ListItem>
                                      </asp:RadioButtonList>
                          
                            </td>
                           </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Final Energy Goal:HBE
                            </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                   <asp:TextBox ID="txtFinal1" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtFinal1" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                                
                                    X
                                   <asp:TextBox ID="txtFinal2" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtFinal2" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                                
                          =
                                             <asp:TextBox ID="txtFinal3" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                            kcal/24 hours
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtFinal3" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                                
                            </td>
                           </tr>
                           <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Refeeding Risk
                            </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >kcal/kg=
                                   <asp:TextBox ID="txtRefeeding1" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox> kcal
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtRefeeding1" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                                
                                    X
                                   <asp:TextBox ID="txtRefeeding2" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>hours
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtRefeeding2" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                                
                                             <asp:TextBox ID="txtRefeeding3" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtRefeeding3" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                           
                                            kcal/kg=
                                             <asp:TextBox ID="txtRefeeding4" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtRefeeding4" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                           
                                            kcal X
                                             <asp:TextBox ID="txtRefeeding5" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtRefeeding5" ValidChars="0987654321.">
                                                 </cc1:FilteredTextBoxExtender>
                           
                                            hours
                            </td>
                           </tr>
                           <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Final Protein Goal
                            </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >grams/kg=
                                   <asp:TextBox ID="txtProtein1" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox> kcal
                                    grams/24 hours
                                    <asp:CheckBox ID="chkProtein2" runat="server" Text="CVV Hemodialysis"/> 
                                   <asp:TextBox ID="txtProtein3" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                          
                                            
                            </td>
                           </tr>
                           <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                    <table style="width:100%;">
                                        <tr>
                                            
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Formula
                                    </td>   
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                     <asp:RadioButtonList ID="rdbFormula1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >IsoSource</asp:ListItem>
                                          <asp:ListItem Value="2">Resource 2.0</asp:ListItem>
                                          <asp:ListItem Value="3">Promote</asp:ListItem>
                                          <asp:ListItem Value="4">Other</asp:ListItem>
                                      </asp:RadioButtonList>
                          
                                    </td>
                                            
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                   <asp:TextBox ID="txtFormula2" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox> 
                                  </td>
                                        </tr>
                                    </table>
                                            
                            </td>
                           </tr>
                           <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                    <table style="width:100%;">
                                        <tr>
                                            
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Goal Feed rate
                                    </td>   
                                            
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                   <asp:TextBox ID="txtGoal1" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>mL/hr 
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txtGoal1" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                
                                  </td>
                             <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                   <asp:TextBox ID="txtGoal2" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>kcal
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender12" runat="server" TargetControlID="txtGoal2" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                 
                                  </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                   <asp:TextBox ID="txtGoal3" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>grams protein 
                                       <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender13" runat="server" TargetControlID="txtGoal3" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                
                                  </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                   <asp:TextBox ID="txtGoal4" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>grams/kg 
                                       <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender14" runat="server" TargetControlID="txtGoal4" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                
                                  </td>
                               
                                        </tr>
                                    </table>
                                            
                            </td>
                           </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >Recommended ICU Protocol/Guideline/Routine
                           </td>
                                  </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                               <asp:RadioButtonList ID="rdbRecommended" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="1" >Gastric/Duodenal</asp:ListItem>
                                          <asp:ListItem Value="2">Electrolite Replacement</asp:ListItem>
                                          <asp:ListItem Value="3">Bowel Protocol(regular/spine)</asp:ListItem>
                                          <asp:ListItem Value="4">micronutrient</asp:ListItem>
                                          <asp:ListItem Value="5">Refeeding risk</asp:ListItem>
                                          <asp:ListItem Value="6">Indirect calorimetry</asp:ListItem>
                                      </asp:RadioButtonList>
                          
                           </td>
                                </tr>
                           <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >8.Nutrition Care Plan
                           </td>
                                  </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                    <table style="width:100%;">
                                         <tr>
                                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >Problem<br />
                                                    <asp:TextBox ID="txtProblem" runat="server"  TextMode="MultiLine"  ClientIDMode="Static" ></asp:TextBox> 
                                  
                                                </td>
                                         <td class="GridViewLabItemStyle" scope="col" colspan="1" >Plan<br />
                                                    <asp:TextBox ID="txtPlan" runat="server" TextMode="MultiLine"  ClientIDMode="Static" ></asp:TextBox> 
                                  
                                                </td>
                                             <td class="GridViewLabItemStyle" scope="col" colspan="1" >Action<br />
                                                    <asp:TextBox ID="txtAction" runat="server"  TextMode="MultiLine"  ClientIDMode="Static" ></asp:TextBox> 
                                  
                                                </td>    
                                         </tr>
                          
                                    </table>
                                    </td>
                                </tr>
                            <tr>
                                <td class="GridViewLabItemStyle" scope="col" colspan="2" >
                                     <table style="width:100%;">
                                         <tr>
                                             
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                     Signature</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                    <asp:TextBox ID="txtSignature" runat="server"  width="300px"  ClientIDMode="Static" ></asp:TextBox> 
                                  
                                </td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                     Date</td>
                                <td class="GridViewLabItemStyle" scope="col" colspan="1" >
                                    <asp:TextBox ID="txtSignatureDate" CssClass="" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtSignatureDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           </td>
                                             </tr>
                                         </table>
                                </td>
                           </tr>
                                  </table>
                             </div>
                    </div>
                </div>     
 
            
                
            
            <div class="POuter_Box_Inventory" style="text-align: center">
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


