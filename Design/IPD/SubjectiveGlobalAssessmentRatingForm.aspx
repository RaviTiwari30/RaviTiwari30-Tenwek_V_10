<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SubjectiveGlobalAssessmentRatingForm.aspx.cs" Inherits="Design_IPD_SubjectiveGlobalAssessmentRatingForm" %>


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
             <b>Subjective Global Assessment Rating Form </b>
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
                                <th class="GridViewHeaderStyle" scope="col" colspan="3" >History</th>
                                

                            </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"  colspan="2"   >
                                
                        <table style="width:100%;" class="FixedTables" >
                            <tr>
                            <td class="GridViewLabItemStyle"   colspan="3"    ><b>Weight/Weight Change(included in K/DOOI SGA)</b></td></tr>
                                <tr>
                            <td class="GridViewLabItemStyle"    >1.BaseLine Weight</td>
                            <td class="GridViewLabItemStyle"    > <asp:TextBox ID="txtBaseLine" Width="70px" CssClass="" runat="server"    ClientIDMode="Static" MaxLength="5" ></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtBaseLine" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                Kg
                            </td>
                            <td class="GridViewLabItemStyle"    >Dry Weight from 6b month ago</td>
                                    </tr>
                                <tr>
                            <td class="GridViewLabItemStyle"    > Current Weight</td>
                            <td class="GridViewLabItemStyle"    > <asp:TextBox ID="txtCurrentWeight" CssClass=""  Width="70px"  runat="server"    ClientIDMode="Static" MaxLength="5"  ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtCurrentWeight" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            Kg
                                                                  </td>
                            <td class="GridViewLabItemStyle"    >Dry Weight today</td>
                                    </tr>
                            
                                <tr>
                            <td class="GridViewLabItemStyle"    > Actual Weight loss past 6 month</td>
                            <td class="GridViewLabItemStyle"    > <asp:TextBox ID="txtActual"  Width="70px"  CssClass="" runat="server"    ClientIDMode="Static" MaxLength="5"  ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtActual" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                Kg
                            
                            </td>
                            <td class="GridViewLabItemStyle"    ><table style="width:100%;"><tr><td class="GridViewLabItemStyle"    >% loss</td>
                                <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtPercentLoss" CssClass="" runat="server"    ClientIDMode="Static" MaxLength="5"  ></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtPercentLoss" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </td><td class="GridViewLabItemStyle"    >
                                Actual loss from baseline or last SGA</td>
                                </tr>
                                </table>
                            </td>
                                    </tr>
                            
                                <tr>
                            <td class="GridViewLabItemStyle"    >2.Weight change over past 2 weeks</td>
                            <td class="GridViewLabItemStyle"    >
                             <asp:RadioButtonList ID="rdbWeight" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="1" >No Change</asp:ListItem>
                                          <asp:ListItem Value="2">Increase</asp:ListItem>
                                          <asp:ListItem Value="3">Decrease</asp:ListItem>
                                          
                                          
                                      </asp:RadioButtonList>

           
                            </td>
                            <td class="GridViewLabItemStyle"    >
                                <asp:TextBox ID="txtDetail" CssClass="" runat="server"    ClientIDMode="Static"   ></asp:TextBox>

                            </td>
                                    </tr>
                                    </table>
                             
                                 
                        

                            </td>
                            <td class="GridViewLabItemStyle" style="width:10%;vertical-align:top;display:none;" >
                                
                                          <asp:TextBox ID="txtRisk" CssClass="" runat="server"    ClientIDMode="Static"  MaxLength="1"></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtRisk" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                                
                        </td>
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"  colspan="2"   >
                                
                        <table style="width:100%;" class="FixedTables" >
                            <tr>
                            <td class="GridViewLabItemStyle"   colspan="4"    ><b>Dietry Intake</b></td></tr>
                                <tr>
                            <td class="GridViewLabItemStyle"   colspan="1" >No Change</td><td class="GridViewLabItemStyle"   colspan="1" >
                                <asp:RadioButtonList ID="rdbNoChange1" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio11_Changed" AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">adequate</asp:ListItem>
                                          <asp:ListItem Value="2">Inadequate</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                </td>
                            <td class="GridViewLabItemStyle"  style="display:none;"  > <asp:TextBox ID="txtNoChange1" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                            <td class="GridViewLabItemStyle"   style="display:none;"   >No Change(Inadequate)</td>
                            <td class="GridViewLabItemStyle"    > <asp:TextBox ID="txtNoChange2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                                    </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"    >
                                <table style="width:100%;">
                                    <tr><td   >1.Change:Sub Optimal Intake</td>
                                        <td   >
                                <asp:TextBox ID="txtSub" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td></tr></table></td>
                            <td class="GridViewLabItemStyle"  >
                                <table style="width:100%;">
                                    <tr><td     >
                                        Protein</td><td    ><asp:TextBox ID="txtProtein" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox> </td></tr></table></td>
                            <td class="GridViewLabItemStyle"    >
                                <table style="width:100%;">
                                    <tr><td   >Kcal</td><td><asp:TextBox ID="txtKcal" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td></tr></table></td>
                            <td class="GridViewLabItemStyle"    > 
                                 <table style="width:100%;">
                                    <tr><td   >Duration</td><td><asp:TextBox ID="txtDuration" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td></tr></table></td>
                                    </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"    ></td>
                            <td class="GridViewLabItemStyle"    > 
                                <table style="width:100%;">
                                    <tr><td   >Full Liquid</td><td><asp:TextBox ID="txtFull" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                        </td></tr></table>
                                        </td>
                            <td class="GridViewLabItemStyle"    >
                                 <table style="width:100%;">
                                    <tr><td   >Hypocaloric Liquid</td><td><asp:TextBox ID="txtHypocaloric" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                        </td></tr></table>
                                        </td>
                            <td class="GridViewLabItemStyle"    > 
                                 <table style="width:100%;">
                                    <tr><td   >Starvation</td><td><asp:TextBox ID="txtStarvation" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                        </td></tr></table>
                                        </td>
                                    </tr>
                            </table>
                                </td>
                                <td class="GridViewLabItemStyle" style="width:10%;display:none;" >
                                
                                          <asp:TextBox ID="txtRate2" CssClass="" runat="server"    ClientIDMode="Static" MaxLength="1" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtRate2" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                                
                        </td>
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"  colspan="2"   >
                                
                        <table style="width:100%;" class="FixedTables" >
                            <tr>
                            <td class="GridViewLabItemStyle"   colspan="4"    ><b>GastroIntestinal Symptoms</b></td></tr>
                            <tr>
                                <td class="GridViewLabItemStyle"       ></td>
                            <td class="GridViewLabItemStyle"     >Symptom</td>
                            
                            <td class="GridViewLabItemStyle"      >Frequency</td>
                            <td class="GridViewLabItemStyle"    >Duration</td>
                                </tr>   
                             <tr>
                                 <td class="GridViewLabItemStyle"    > None</td>
                            <td class="GridViewLabItemStyle"    >
                                 <asp:RadioButtonList ID="rdbNone1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                               
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtNone2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtNone3" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                                <tr>
                                    <td class="GridViewLabItemStyle"    > Anorexia</td>
                            <td class="GridViewLabItemStyle"    ><asp:RadioButtonList ID="rdbAnorexia1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList></td>
                            
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtAnorexia2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtAnorexia3" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                                <tr>
                                     <td class="GridViewLabItemStyle"    > Nausea</td>
                            <td class="GridViewLabItemStyle"    >
                                <asp:RadioButtonList ID="rdbNausea1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            </td>
                           
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtNausea2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtNausea3" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                                <tr>
                                    <td class="GridViewLabItemStyle"    > Vomiting</td>
                            <td class="GridViewLabItemStyle"    >
                                 <asp:RadioButtonList ID="rdbVomiting1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                            
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtVomiting2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtVomiting3" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                                <tr>
                                    <td class="GridViewLabItemStyle"    > Diarrhea</td>
                            <td class="GridViewLabItemStyle"    >
                                <asp:RadioButtonList ID="rdbDiarrhea1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                            
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtDiarrhea2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtDiarrhea3" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" colspan="4"   >Never, daily 2-3 times/week >2-weeks < 2 weeks</td>
                            </tr>
                        </table>
                                </td>
                                   <td class="GridViewLabItemStyle" style="width:10%;display:none;" >
                                
                                          <asp:TextBox ID="txtRisk3" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                         <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtRisk3" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                                
                        </td>
                                </tr>
                            <tr>
                                
                                   <td class="GridViewLabItemStyle" colspan="2" >
                                       <table style="width:100%;" class="FixedTables" >
                            <tr>
                            <td class="GridViewLabItemStyle"   colspan="3"    ><b>Functional Capacity</b></td></tr>
                            <tr>
                                <td class="GridViewLabItemStyle"       ></td>
                            <td class="GridViewLabItemStyle"     >Description</td>
                            
 
                            <td class="GridViewLabItemStyle"    >Duration</td>
                                </tr>   
                             <tr>
                                   <td class="GridViewLabItemStyle"    > No Dysfunction</td>
                            <td class="GridViewLabItemStyle"    >
                                 <asp:RadioButtonList ID="rdbNoDysfunction1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                          
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtNoDysfunction2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                                           
                             <tr>
                                 <td class="GridViewLabItemStyle"    > Change in Function</td>
                            <td class="GridViewLabItemStyle"    >
                                <asp:RadioButtonList ID="rdbChange1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                            
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtChange2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                             <tr>
                                 <td class="GridViewLabItemStyle"    > Difficulty with Ambulation</td>
                            <td class="GridViewLabItemStyle"    >
                                 <asp:RadioButtonList ID="rdbDifficulty11" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                            
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtDifficulty12" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                             <tr>
                                 <td class="GridViewLabItemStyle"    > Difficulty With activity(Patient Specific normal)</td>
                            <td class="GridViewLabItemStyle"    >
                                 <asp:RadioButtonList ID="rdbDifficulty21" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                            
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtDifficulty22" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                             <tr>
                                  <td class="GridViewLabItemStyle"    > Light Activity</td>
                            <td class="GridViewLabItemStyle"    >
                                <asp:RadioButtonList ID="rdbLight1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                           
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtLight2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                                           <tr>
                                               <td class="GridViewLabItemStyle"    > Bed/Chair ridden with little or no activity</td>
                            <td class="GridViewLabItemStyle"    >
                                 <asp:RadioButtonList ID="rdbBed1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                            
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtBed2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                                            <tr>
                                                  <td class="GridViewLabItemStyle"    > improvement in function</td>
                            <td class="GridViewLabItemStyle"    >
                                <asp:RadioButtonList ID="rdbimprovement1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            
                            </td>
                          
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtimprovement2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                           
                                     </tr>
                        </table>
                                   </td>
                                      <td class="GridViewLabItemStyle" style="width:10%;display:none;" >
                                
                                          <asp:TextBox ID="txtRisk4" CssClass="" runat="server"    ClientIDMode="Static" MaxLength="1" ></asp:TextBox>
                                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtRisk4" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                                
                        </td>
                            </tr>
                            <tr>
                                  <td class="GridViewLabItemStyle" colspan="2" >
                                       <table style="width:100%;" class="FixedTables" >
                            <tr>
                            <td class="GridViewLabItemStyle"   colspan="6"    >Desease State/Comorbidities as related to Nutritional needs</td></tr>
                             <tr>
                                 <td class="GridViewLabItemStyle"    >Primary diagnosis</td>
                            <td class="GridViewLabItemStyle"    ><asp:TextBox ID="txtPrimary" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox></td>
                            <td class="GridViewLabItemStyle"    >Comorbidities</td>
                                 <td class="GridViewLabItemStyle"    >
                                     
                               <asp:DropDownList id="ddlComorbidities" runat="server">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="DM" Text="DM" />
                                        <asp:ListItem value="CHF" Text="CHF" />
                                        <asp:ListItem value="HTN" Text="HTN" />
                                        <asp:ListItem value="OTHERS" Text="OTHERS" />
                                    </asp:DropDownList>
                                 </td>
                                 
                            <td class="GridViewLabItemStyle"    ></td>
                            <td class="GridViewLabItemStyle"    ></td>
                                     </tr>
                                            <tr>
                                                 <td class="GridViewLabItemStyle"    >Normal Requirements</td>
                                 <td class="GridViewLabItemStyle"    >
                                      <asp:RadioButtonList ID="rdbNormal" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                      <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label></td>
                           
                           
                                 <td class="GridViewLabItemStyle"    >Increased Requirements</td>
                            <td class="GridViewLabItemStyle"    >
                                <asp:RadioButtonList ID="rdbIncreased" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                            </td>
                            <td class="GridViewLabItemStyle"    >Decreased Requirements</td>
                                 <td class="GridViewLabItemStyle"    > 
                                      <asp:RadioButtonList ID="rdbDecreased" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                
                                          <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                 </td>
                           
                                     </tr>
                                           
                                            <tr>
                                 <td class="GridViewLabItemStyle"    >Acute Metabolic stress</td>
                                 <td class="GridViewLabItemStyle" colspan="5"   >
                                      <asp:RadioButtonList ID="rdbAcute" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >None</asp:ListItem>
                                          <asp:ListItem Value="1">Low</asp:ListItem>
                                          <asp:ListItem Value="2">Moderate</asp:ListItem>
                                          <asp:ListItem Value="3">High</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                                 </td>
                                                </tr>
                                 </table>
                                      </td>
                                 <td class="GridViewLabItemStyle" style="width:10%;display:none;" >
                                
                                          <asp:TextBox ID="txtRisk5" CssClass="" runat="server"    ClientIDMode="Static" MaxLength="1" ></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtRisk5" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                                
                        </td>
                            </tr>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" colspan="2" >Physical Exam</th>
                                </tr>
                            <tr>
                                
                                 <td class="GridViewLabItemStyle" colspan="2" >
                                     
                        <table style="width:100%;" class="FixedTables" >
                            <tr>
                                
                                 <td class="GridViewLabItemStyle"  >Loss of subcutaneous fat </td>
                                <td class="GridViewLabItemStyle" colspan="4" >
                                         <asp:RadioButtonList ID="rdbLoss1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                                <asp:ListItem Value="0" >Below Eye</asp:ListItem>
                                          <asp:ListItem Value="1">Triceps</asp:ListItem>
                                          <asp:ListItem Value="2">Some Areas</asp:ListItem>
                                          <asp:ListItem Value="3">All Areas</asp:ListItem>
                                          <asp:ListItem Value="4">biceps</asp:ListItem>
                                          <asp:ListItem Value="5">chest</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                 </td>
                                
                                
                                 <td class="GridViewLabItemStyle"  >
                                     
                                          <asp:TextBox ID="txtLoss2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                 </td>
                                
                                                            </tr>
                            <tr>
                                
                                 <td class="GridViewLabItemStyle"  >Muscle wasting</td>
                                 <td class="GridViewLabItemStyle" colspan="4" >
                                     
                                         <asp:RadioButtonList ID="rdbMuscle1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                               
                                          <asp:ListItem Value="1">Temple</asp:ListItem>
                                          <asp:ListItem Value="2">Clavicle</asp:ListItem>
                                          <asp:ListItem Value="3">Scapula</asp:ListItem>
                                          <asp:ListItem Value="4">Ribs</asp:ListItem>
                                          <asp:ListItem Value="5">Some Areas</asp:ListItem>
                                          <asp:ListItem Value="6">All Areas</asp:ListItem>
                                          <asp:ListItem Value="7">Quardiceps</asp:ListItem>
                                          <asp:ListItem Value="8">Calf</asp:ListItem>
                                          <asp:ListItem Value="9">Knee</asp:ListItem>
                                          <asp:ListItem Value="10">Interroseous</asp:ListItem>

                                          
                                      </asp:RadioButtonList>
                                 </td>
                                
                                
                                 <td class="GridViewLabItemStyle"  >
                                     
                                          <asp:TextBox ID="txtMuscle2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                 </td>
                                
                                </tr>
                            <tr>
                                
                                 <td class="GridViewLabItemStyle" colspan="1"  >Edema(related to undernutrition/use to evaluate weight change)</td>
                                 <td class="GridViewLabItemStyle" colspan="4" >
                                     
                                          
                                         <asp:RadioButtonList ID="rdbEdema1" runat="server" RepeatDirection="Horizontal"  AutoPostBack="false" >
                                               
                                          <asp:ListItem Value="1">related to undernutrition</asp:ListItem>
                                          <asp:ListItem Value="2">use to evaluate weight change</asp:ListItem>
                                          
                                      </asp:RadioButtonList>                                 </td>
                                 <td class="GridViewLabItemStyle"  >
                                     
                                          <asp:TextBox ID="txtEdema2" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                 </td>
                                
                                </tr>
                                </table>
                                     </td>   
                                 <td class="GridViewLabItemStyle" style="width:10%;display:none;" >
                                
                                          <asp:TextBox ID="txtRisk6" CssClass="" runat="server"    ClientIDMode="Static" MaxLength="1" ></asp:TextBox>
                                      <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtRisk6" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                                
                        </td>
                            </tr>
                             <tr>
                                <th class="GridViewHeaderStyle" scope="col" colspan="3" >Overall SGA Rating</th>
                           </tr>
                            <tr>
                                
                                 <td class="GridViewLabItemStyle" colspan="3"  >
                                     Very mild risk to well nourished 1-7 most categories or significant continued improvement.<br />
                                     Mild moderate=3,4,5 ratings . no clear sign of normal status or severe malnutrition.<br />
                                     Severe Malnourished=1 or 2 ratings in most categories/significant physical signs of malnutrition.
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
                        <asp:TemplateField HeaderText="BaseLine">
                            <ItemTemplate>
                                <asp:Label ID="lblBaseLine" runat="server" Text='<%#Eval("BaseLine") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Current ">
                            <ItemTemplate>
                                <asp:Label ID="lblCurrent" runat="server" Text='<%#Eval("Current") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actual">
                            <ItemTemplate>
                                <asp:Label ID="lblActual" runat="server" Text='<%#Eval("Actual") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="loss">
                            <ItemTemplate>
                                <asp:Label ID="lblloss" runat="server" Text='<%#Eval("loss") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Weight1 ">
                            <ItemTemplate>
                                <asp:Label ID="lblWeight1" runat="server" Text='<%#Eval("Weight1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Risk1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblRisk1" runat="server" Text='<%#Eval("Risk1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Nochange1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblNochange1" runat="server" Text='<%#Eval("Nochange1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Nochange1"  Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblNochange2" runat="server" Text='<%#Eval("Nochange2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Change"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblChange" runat="server" Text='<%#Eval("Change3") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Protein"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblProtein" runat="server" Text='<%#Eval("Protein") %>'></asp:Label>
                                <asp:Label ID="lblKcal" runat="server" Text='<%#Eval("Kcal") %>'></asp:Label>
                                <asp:Label ID="lblDuration1" runat="server" Text='<%#Eval("Duration1") %>'></asp:Label>
                                <asp:Label ID="lblFullLiquid" runat="server" Text='<%#Eval("FullLiquid") %>'></asp:Label>
                                <asp:Label ID="lblHypocaloric" runat="server" Text='<%#Eval("Hypocaloric") %>'></asp:Label>
                                <asp:Label ID="lblStarvation" runat="server" Text='<%#Eval("Starvation") %>'></asp:Label>
                                <asp:Label ID="lblNone1" runat="server" Text='<%#Eval("None1") %>'></asp:Label>
                                <asp:Label ID="lblNone2" runat="server" Text='<%#Eval("None2") %>'></asp:Label>
                                <asp:Label ID="lblNone3" runat="server" Text='<%#Eval("None3") %>'></asp:Label>
                                <asp:Label ID="lblAnorexia1" runat="server" Text='<%#Eval("Anorexia1") %>'></asp:Label>

                                <asp:Label ID="lblAnorexia2" runat="server" Text='<%#Eval("Anorexia2") %>'></asp:Label>

                                <asp:Label ID="lblAnorexia3" runat="server" Text='<%#Eval("Anorexia3") %>'></asp:Label>
                                <asp:Label ID="lblNausea1" runat="server" Text='<%#Eval("Nausea1") %>'></asp:Label>
                                <asp:Label ID="lblNausea2" runat="server" Text='<%#Eval("Nausea2") %>'></asp:Label>
                                <asp:Label ID="lblNausea3" runat="server" Text='<%#Eval("Nausea3") %>'></asp:Label>
                                <asp:Label ID="lblVomiting1" runat="server" Text='<%#Eval("Vomiting1") %>'></asp:Label>
                                <asp:Label ID="lblVomiting2" runat="server" Text='<%#Eval("Vomiting2") %>'></asp:Label>
                                <asp:Label ID="lblVomiting3" runat="server" Text='<%#Eval("Vomiting3") %>'></asp:Label>
                                <asp:Label ID="lblDiarrhea1" runat="server" Text='<%#Eval("Diarrhea1") %>'></asp:Label>
                                <asp:Label ID="lblDiarrhea2" runat="server" Text='<%#Eval("Diarrhea2") %>'></asp:Label>
                                <asp:Label ID="lblDiarrhea3" runat="server" Text='<%#Eval("Diarrhea3") %>'></asp:Label>
                                <asp:Label ID="lblNoDysfunction1" runat="server" Text='<%#Eval("NoDysfunction1") %>'></asp:Label>
                                <asp:Label ID="lblNoDysfunction2" runat="server" Text='<%#Eval("NoDysfunction2") %>'></asp:Label>
                                <asp:Label ID="lblChange1" runat="server" Text='<%#Eval("Change1") %>'></asp:Label>
                                <asp:Label ID="lblChange2" runat="server" Text='<%#Eval("Change2") %>'></asp:Label>
                                <asp:Label ID="lblDifficulty11" runat="server" Text='<%#Eval("Difficulty11") %>'></asp:Label>
                                <asp:Label ID="lblDifficulty12" runat="server" Text='<%#Eval("Difficulty12") %>'></asp:Label>
                                <asp:Label ID="lblDifficulty21" runat="server" Text='<%#Eval("Difficulty21") %>'></asp:Label>
                                <asp:Label ID="lblDifficulty22" runat="server" Text='<%#Eval("Difficulty22") %>'></asp:Label>
                                <asp:Label ID="lblLight1" runat="server" Text='<%#Eval("Light1") %>'></asp:Label>
                                <asp:Label ID="lblLight2" runat="server" Text='<%#Eval("Light2") %>'></asp:Label>
                                <asp:Label ID="lblBed1" runat="server" Text='<%#Eval("Bed1") %>'></asp:Label>
                                <asp:Label ID="lblBed2" runat="server" Text='<%#Eval("Bed2") %>'></asp:Label>
                                <asp:Label ID="lblimprovement1" runat="server" Text='<%#Eval("improvement1") %>'></asp:Label>
                                <asp:Label ID="lblimprovement2" runat="server" Text='<%#Eval("improvement2") %>'></asp:Label>
                                <asp:Label ID="lblPrimary" runat="server" Text='<%#Eval("Primary1") %>'></asp:Label>
                                <asp:Label ID="lblComorbidities" runat="server" Text='<%#Eval("Comorbidities") %>'></asp:Label>
                                <asp:Label ID="lblNormal" runat="server" Text='<%#Eval("Normal") %>'></asp:Label>
                                <asp:Label ID="lblIncreased" runat="server" Text='<%#Eval("Increased") %>'></asp:Label>
                                <asp:Label ID="lblDecreased" runat="server" Text='<%#Eval("Decreased") %>'></asp:Label>
                                <asp:Label ID="lblAcute" runat="server" Text='<%#Eval("Acute") %>'></asp:Label>
                                <asp:Label ID="lblLoss2" runat="server" Text='<%#Eval("Loss2") %>'></asp:Label>
                                <asp:Label ID="lblLoss1" runat="server" Text='<%#Eval("Loss1") %>'></asp:Label>
                                <asp:Label ID="lblSome1" runat="server" Text='<%#Eval("Some1") %>'></asp:Label>
                                <asp:Label ID="lblAll1" runat="server" Text='<%#Eval("All1") %>'></asp:Label>
                                <asp:Label ID="lblMuscle" runat="server" Text='<%#Eval("Muscle") %>'></asp:Label>
                                <asp:Label ID="lblMuscle1" runat="server" Text='<%#Eval("Muscle1") %>'></asp:Label>
                                <asp:Label ID="lblSome2" runat="server" Text='<%#Eval("Some2") %>'></asp:Label>
                                <asp:Label ID="lblAll2" runat="server" Text='<%#Eval("All2") %>'></asp:Label>
                                <asp:Label ID="lblEdema" runat="server" Text='<%#Eval("Edema") %>'></asp:Label>
                                <asp:Label ID="lblEdema1" runat="server" Text='<%#Eval("Edema1") %>'></asp:Label>
                                <asp:Label ID="lblRisk2" runat="server" Text='<%#Eval("Risk2") %>'></asp:Label>
                                <asp:Label ID="lblRisk3" runat="server" Text='<%#Eval("Risk3") %>'></asp:Label>
                                <asp:Label ID="lblRisk4" runat="server" Text='<%#Eval("Risk4") %>'></asp:Label>
                                <asp:Label ID="lblRisk5" runat="server" Text='<%#Eval("Risk5") %>'></asp:Label>
                                <asp:Label ID="lblDetail" runat="server" Text='<%#Eval("Detail") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
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
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>  
                                            
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

