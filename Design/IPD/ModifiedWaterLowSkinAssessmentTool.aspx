<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ModifiedWaterLowSkinAssessmentTool.aspx.cs" Inherits="Design_IPD_ModifiedWaterLowSkinAssessmentTool" %>

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
        });
        
        function validate() {
            //alert($('#rdbAge input:checked').val());
            if ($('#rdbAge input:checked').val()==undefined) {
                modelAlert("Please Fill Age.", function () { });
                return false;
            }
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>Modified WaterLoo Skin Assessment Tool</b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Ring Scores in Tables, add total more than 1 score category can be used
                </div>
 </div>
        
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-2" >Date
                        </div>
                     <div class="col-md-5">
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                         
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
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
                        <table style="width:100%;"  border="1" >
                            <tr style="background-color:royalblue;color:white;">
                                <th style="width:400px;">BUILD/WEIGHT FOR HEIGHT</th>
                                <th  style="width:100px;"></th>
                                <th style="width:400px;">SKIN TYPE HIGH RISK AREAS</th>
                                <th style="width:100px;"></th>
                                <th style="width:400px;">SEX/AGE</th>
                                <th style="width:100px;"></th>
                                <th style="width:400px;" >MALNUTRITION SCREENING TOOL(MST)<br />Nutrition Vol.15,No 6 1999 Australia</th>
                                <th style="width:100px;"></th>
                            </tr>
                            <tr>
                                <td>
                                    <asp:RadioButtonList ID="rdbBuildWeightForHeight" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Average BMI=20-24.9(0)</asp:ListItem>
                                          <asp:ListItem Value="1">Above Average BMI=25-25.9(1)</asp:ListItem>
                                          <asp:ListItem Value="2">Obese BMI>30(2)</asp:ListItem>
                                          <asp:ListItem Value="3">Below Average BMI<20(3)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    BMI=Wt(Kg)/Ht(cm)

                                </td>
                                <td>
                                     <asp:Label ID="lblBWFH" runat="server" ></asp:Label>

                                </td>
                                <td>
                                    <asp:RadioButtonList ID="rdbSkinType" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio2_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Health(0)</asp:ListItem>
                                          <asp:ListItem Value="1">Tissue Paper(1)</asp:ListItem>
                                          <asp:ListItem Value="2">Dry(1)</asp:ListItem>
                                          <asp:ListItem Value="3">Odemetous(1)</asp:ListItem>
                                          <asp:ListItem Value="4">Clammy Pyraxia(1)</asp:ListItem>
                                          <asp:ListItem Value="5">Discoloured grade 1(2)</asp:ListItem>
                                          <asp:ListItem Value="6">Broken Spots grade 2-4(3)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    

                                </td>
                                <td>
                                     <asp:Label ID="lblSkinType" runat="server" ></asp:Label>

                                </td>
                                
                                <td>
                                    <asp:RadioButtonList ID="rdbSex" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio3_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Male(1)</asp:ListItem>
                                          <asp:ListItem Value="1">Female(2)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    
                                    <asp:RadioButtonList ID="rdbAge" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio4_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >14-49(1)</asp:ListItem>
                                          <asp:ListItem Value="1">50-64(2)</asp:ListItem>
                                          <asp:ListItem Value="2">65-74(3)</asp:ListItem>
                                          <asp:ListItem Value="3">75-80(4)</asp:ListItem>
                                          <asp:ListItem Value="4">Above 80(5)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                </td>
                                <td>
                                     <asp:Label ID="lblSex" runat="server" ></asp:Label><br />
                                     <asp:Label ID="lblAge" runat="server" ></asp:Label>

                                </td>
                                <td colspan="2">
                                    <table style="width:100%;"  border="1">
                                        <tr><td>
                                            Has Patient Lost weight recently
                                            
                                    <asp:RadioButtonList ID="rdbLostWeight" runat="server" RepeatDirection="Vertical"  >
                                                <asp:ListItem Value="0" >Yes Go to B</asp:ListItem>
                                          <asp:ListItem Value="1">No Go to C</asp:ListItem>
                                          <asp:ListItem Value="2">UnSure Go to C</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                            </td>
                                            <td>
                                                Weight Loss Score
                                                
                                    <asp:RadioButtonList ID="rdbWeightLossScore" runat="server" RepeatDirection="Vertical" AutoPostBack="true" OnSelectedIndexChanged="Radio10_Changed"  >
                                                <asp:ListItem Value="1" >.5 to 5 kg(1)</asp:ListItem>
                                          <asp:ListItem Value="2">5 to 10 kg(2)</asp:ListItem>
                                          <asp:ListItem Value="3">10 to 15 kg(3)</asp:ListItem>
                                          <asp:ListItem Value="4">Above 15 kg(4)</asp:ListItem>
                                          <asp:ListItem Value="5">UnSure(2)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                            </td>
                                            <td> <asp:Label ID="lblWeightLossScore" runat="server" ></asp:Label></td>
                                        </tr>
                                        <tr><td>
                                            <table><tr><td colspan="2">Patient Eating Poorly or lack of Appetite
</td></tr>
                                                <tr><td ><asp:RadioButtonList ID="rdbEatingPoorly" runat="server" RepeatDirection="Vertical"  AutoPostBack="true" OnSelectedIndexChanged="Radio11_Changed"   >
                                                <asp:ListItem Value="0" >Yes(1)</asp:ListItem>
                                          <asp:ListItem Value="1">No(0)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                    </td>
                                                    <td><asp:Label ID="lblEatingPoorly" runat="server" ></asp:Label></td>
                                                </tr>
                                            </table>
                                            
                                            
                                                
                                            </td><td colspan="2">
                                                Nutrition Score If >2 refer for nutrition assessment intervention
                                                 </td></tr>
                                    </table>
                                </td>
                            </tr>
                         <%--   </table>
                        <table style="width:100%;"  border="1" >--%>
                            <tr style="background-color:royalblue;color:white;">
                                <th>Continence</th>
                                <th></th>
                                <th>Mobility</th>
                                <th></th>
                                <th colspan="4">Special Risk</th>
                            </tr>
                            <tr>
                                <td>
                                     <asp:RadioButtonList ID="rdbContinence" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio5_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Complete(0)</asp:ListItem>
                                          <asp:ListItem Value="1">Catherised(1)</asp:ListItem>
                                          <asp:ListItem Value="2">Urine InCont Faecal Incont(2)</asp:ListItem>
                                          <asp:ListItem Value="3">Urine+ Faecal Incontinence(3)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                </td>
                                <td>
                                     <asp:Label ID="lblContinence" runat="server" ></asp:Label>

                                </td>
                                 <td>
                                     <asp:RadioButtonList ID="rdbMobility" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio6_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Fully(0)</asp:ListItem>
                                          <asp:ListItem Value="1">Rested/Fidgety(1)</asp:ListItem>
                                          <asp:ListItem Value="2">Apathetic(2)</asp:ListItem>
                                          <asp:ListItem Value="3">Restricted(3)</asp:ListItem>
                                          <asp:ListItem Value="4">BedBound(e.g. traction)(4)</asp:ListItem>
                                          <asp:ListItem Value="5">Chairbound Wheelchair(5)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                </td>
                                <td>
                                     <asp:Label ID="lblMobility" runat="server" ></asp:Label>

                                </td>
                                <td colspan="4">
                                    <table  style="width:100%;" border="1">
                                        <tr>
                                             <td style="width:400px;">Tissue MalNutrition</td>
                                <td  style="width:100px;"></td>
                                <td style="width:400px;">Neurological Deficit</td>
                                <td style="width:100px;"></td>
                               
                                        </tr>
                                         <tr>
                                             <td style="width:400px;">
                                                  <asp:RadioButtonList ID="rdbTissueMalNutrition" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio7_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Terminal Cachexia(6)</asp:ListItem>
                                          <asp:ListItem Value="1">Multiple Organ Failure(6)</asp:ListItem>
                                          <asp:ListItem Value="2">Single Organ Failure(Resp,Renal,Cargiac)(5)</asp:ListItem>
                                          <asp:ListItem Value="3">Peripheral Vascular Disease(5)</asp:ListItem>
                                          <asp:ListItem Value="4">Anaemia(2)</asp:ListItem>
                                          <asp:ListItem Value="5">Smoking(1)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                                   
                                             </td>
                                <td>
                                    <asp:Label ID="lblTissueMalnutrition" runat="server" ></asp:Label>
                                </td>
                                <td colspan="2">
                                    <table style="width:100%;" border="1">
                                        <tr>
                                            <td  style="width:400px;">
                                                  <asp:RadioButtonList ID="rdbNeurologicalDeficit" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio8_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Diabetes MS CVA(6)</asp:ListItem>
                                          <asp:ListItem Value="1">Motor/Sensory(6)</asp:ListItem>
                                          <asp:ListItem Value="2">ParaPlegia(Max of 6)(6)</asp:ListItem>
                                      </asp:RadioButtonList>
                                   
                                             </td>
                                <td  style="width:100px;">
                                    <asp:Label ID="lblNeurologicalDeficit" runat="server" ></asp:Label>
                                </td>
                                        </tr>
                                        <tr>
                                            
                                <td  style="width:400px;">Major Surgery or Trauma</td>
                                <td  style="width:100px;"></td>
                                        </tr>
                                        
                                        <tr>
                                            <td>
                                                  <asp:RadioButtonList ID="rdbMajorSurgeryOrTrauma" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio9_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="0" >Orthopedic/Spinal(5)</asp:ListItem>
                                          <asp:ListItem Value="1">On table>2 hrs(5)</asp:ListItem>
                                          <asp:ListItem Value="2">On Table >5 hrs(5)</asp:ListItem>
                                      </asp:RadioButtonList>
                                   
                                             </td>
                                <td>
                                    <asp:Label ID="lblMajorSurgeryOrTrauma" runat="server" ></asp:Label>
                                </td>
                                        </tr>
                                    </table>
                                </td>
                                        </tr>
                                    <tr><td colspan="4">Medication CycoToxics Long Term/High Dose Teroids Anti Inflamatory Max of 4</td></tr>
                                    </table>
                               </td>
                            </tr>
                            <tr>
                                <td colspan="8">Total Score:
                                     <asp:Label ID="lblTotalScore" runat="server" Text="0"></asp:Label>&nbsp &nbsp &nbsp &nbsp&nbsp &nbsp &nbsp &nbsp 10+ At Risk &nbsp &nbsp &nbsp &nbsp&nbsp &nbsp &nbsp &nbsp 15+ High Risk &nbsp &nbsp &nbsp &nbsp&nbsp;&nbsp;&nbsp;&nbsp; 20+ Very High Risk
                                
                                </td>
                            </tr>
                        </table>
                        
                        
                        
                        
                         
                    </div>
                </div>
               
               
               
               
                
                </div>
                
            <div class="POuter_Box_Inventory" style="text-align: center;">

            
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
                        <asp:TemplateField HeaderText="BWFH">
                            <ItemTemplate>
                                <asp:Label ID="lbBWFH1" runat="server" Text='<%#Eval("BWFH1") %>'></asp:Label>
                                <asp:Label ID="lbBWFH" runat="server" Text='<%#Eval("BWFH") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SkinType">
                            <ItemTemplate>
                                <asp:Label ID="lblSkinType1" runat="server" Text='<%#Eval("SkinType1") %>'></asp:Label>
                                <asp:Label ID="lblSkinType" runat="server" Text='<%#Eval("SkinType") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sex">
                            <ItemTemplate>
                                <asp:Label ID="lblSex1" runat="server" Text='<%#Eval("Sex1") %>'></asp:Label>
                                <asp:Label ID="lblSex2" runat="server" Text='<%#Eval("Sex") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Age">
                            <ItemTemplate>
                                <asp:Label ID="lblAge1" runat="server" Text='<%#Eval("Age1") %>'></asp:Label>
                                <asp:Label ID="lblAge" runat="server" Text='<%#Eval("Age") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Total Score">
                            <ItemTemplate>
                                <asp:Label ID="lblTotalScore1" runat="server" Text='<%#Eval("TotalScore") %>' ></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LostWeight" Visible="false">
                            <ItemTemplate>
                                 <asp:Label ID="lblLostWeight" runat="server" Text='<%#Eval("LostWeight") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="WeightLossScore" Visible="false">
                            <ItemTemplate>
                                 <asp:Label ID="lblWeightLossScore" runat="server" Text='<%#Eval("WeightLossScore") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EatingPoorly" Visible="false">
                            <ItemTemplate>
                                 <asp:Label ID="lblEatingPoorly" runat="server" Text='<%#Eval("EatingPoorly") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Continence" Visible="false">
                            <ItemTemplate>
                                 <asp:Label ID="lblContinence" runat="server" Text='<%#Eval("Continence") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Mobility" Visible="false">
                            <ItemTemplate>
                                 <asp:Label ID="lblMobility" runat="server" Text='<%#Eval("Mobility") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="TissueMalNutrition" Visible="false">
                            <ItemTemplate>
                                 <asp:Label ID="lblTissueMalNutrition" runat="server" Text='<%#Eval("TissueMalNutrition") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="NeurologicalDeficit" Visible="false">
                            <ItemTemplate>
                                 <asp:Label ID="lblNeurologicalDeficit" runat="server" Text='<%#Eval("NeurologicalDeficit") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="MajorSurgeryTrauma" Visible="false">
                            <ItemTemplate>
                                 <asp:Label ID="lblMajorSurgeryTrauma" runat="server" Text='<%#Eval("MajorSurgeryTrauma") %>' Visible="false"></asp:Label>
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


