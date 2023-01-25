<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NeurologicalObservationChart.aspx.cs" Inherits="Design_IPD_NeurologicalObservationChart" %>

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
             <b>Neurological Observation Chart </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Neurological Observation Chart
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
                                <th class="GridViewHeaderStyle" scope="col" colspan="2" >Glascow Coma Scale-Mark With X in the row of the appropriate score below</th>
                                <th class="GridViewHeaderStyle" scope="col" > </th>

                            </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;"   >Eye Opening</td>
                            <td class="GridViewLabItemStyle" style="width:500px;" >
                                
            <asp:RadioButtonList ID="rdbEyeOpening" runat="server" RepeatDirection="Vertical" OnSelectedIndexChanged="Radio1_Changed" AutoPostBack="true" >
                                                <asp:ListItem Value="4" >Spontaneous-4</asp:ListItem>
                                          <asp:ListItem Value="3">To Speech-3</asp:ListItem>
                                          <asp:ListItem Value="2">To Pain-2</asp:ListItem>
                                          <asp:ListItem Value="1">None-1</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                            </td>
                            <td class="GridViewLabItemStyle"  >Score:
                                
                                <asp:Label ID="lblEyeOpening1" runat="server" ></asp:Label>

                            </td>
                            </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"  >Verbal</td>
                            <td class="GridViewLabItemStyle"  >
                                
                            <asp:RadioButtonList ID="rdbVerbalAdult" runat="server" RepeatDirection="Vertical"  OnSelectedIndexChanged="Radio2_Changed" AutoPostBack="true"  >
                                                <asp:ListItem Value="5" >Oriented-5</asp:ListItem>
                                          <asp:ListItem Value="4">Confused-4</asp:ListItem>
                                          <asp:ListItem Value="3">In Appropriate Words-3</asp:ListItem>
                                          <asp:ListItem Value="2">Non Specific Sound-2</asp:ListItem>
                                          <asp:ListItem Value="1">No Response-1</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                            </td>
                            <td class="GridViewLabItemStyle"  >Score:
                                
                                <asp:Label ID="lblVerbalAdult1" runat="server" ></asp:Label>
                            </td>
                            </tr>

                            
                            <tr>
                            <td class="GridViewLabItemStyle"  >Best Motor Response</td>
                            <td class="GridViewLabItemStyle"  >
                                
                            <asp:RadioButtonList ID="rdbBestMotorResponse" runat="server" RepeatDirection="Vertical"  OnSelectedIndexChanged="Radio3_Changed" AutoPostBack="true"  >
                                                <asp:ListItem Value="6" >Obeys Command-6</asp:ListItem>
                                          <asp:ListItem Value="5">Localizes Pain-5</asp:ListItem>
                                          <asp:ListItem Value="4">Withdraws from Pain-4</asp:ListItem>
                                          <asp:ListItem Value="3">Flexion to pain-3</asp:ListItem>
                                          <asp:ListItem Value="2">Extension to pain-2</asp:ListItem>
                                          <asp:ListItem Value="1">None-1</asp:ListItem>
                                          
                                      </asp:RadioButtonList>

                            </td>
                            <td class="GridViewLabItemStyle"  >Score:
                                
                                <asp:Label ID="lblBestMotorResponse1" runat="server" ></asp:Label>
                            </td>
                            </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"  >Total Glascow Coma Scale Score</td>
                            <td class="GridViewLabItemStyle"  >
                                
                            
                              <asp:TextBox ID="txtGlascowComaScaleScore" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="2" Visible="false" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtGlascowComaScaleScore" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                            <td class="GridViewLabItemStyle"  >Score:
                                
                                <asp:Label ID="lblGlascowComaScaleScore1" runat="server" ></asp:Label>
                            </td>
                            </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"  >Pupils</td>
                            <td class="GridViewLabItemStyle"  colspan='2'   >
                             <table style="width:100%;" border="1">
                                 <tr><td style="width:100px;" >Brisk++</td><td rowspan="2" style="width:100px;text-align:center;" >Right </td><td style="width:100px;" >Size-mm</td><td style="width:100px;" >
                                     <asp:TextBox ID="txtRisk" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtRisk" ValidChars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321- ">
                                </cc1:FilteredTextBoxExtender>

                                                                                               </td></tr>
                                 <tr><td>Sluggish--</td><td>Reaction</td><td>
                                      <asp:TextBox ID="txtSluggish" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtSluggish" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321ABCDEFGHIJKLMNOPQRSTUVWXYZ- ">
                                </cc1:FilteredTextBoxExtender>
                                                                         </td></tr>
                                 <tr><td>No Reaction++</td><td rowspan="2" style="text-align:center;">Left </td><td>Size-mm</td><td>
                                     <asp:TextBox ID="txtNoReaction" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txtNoReaction" ValidChars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321- ">
                                </cc1:FilteredTextBoxExtender>
                                      
                                                                                                     </td></tr>
                                 <tr><td>Eyes Closed--</td><td>Reaction</td><td>
                                      <asp:TextBox ID="txtEyesClosed" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender12" runat="server" TargetControlID="txtEyesClosed" ValidChars="abcdefghijklmnopqrstuvwxyz0987654321ABCDEFGHIJKLMNOPQRSTUVWXYZ- ">
                                </cc1:FilteredTextBoxExtender>
                                    
                                                                            </td></tr>
                             </table>   
                            
                             
                            </td>
                            
                            </tr>

                             
                            <tr>
                            <td class="GridViewLabItemStyle"  >Limb Movements</td>
                            <td class="GridViewLabItemStyle"  colspan='2'  >
                              <table style="width:100%;" border="1">
                                  <tr><td rowspan="6"  style="width:100px;" >Arms record R or L to indicate side if Asymmetric</td><td style="width:100px;" ></td><td style="width:100px;" > 
                                     R
                                    </td>
                                      <td style="width:100px;" >
                                           L
                                    </td>

                                  </tr>
                                  
                                  <tr><td style="width:100px;" >Normal Power</td><td style="width:100px;" > 
                                      <asp:TextBox ID="txtArmsNormalPower1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td style="width:100px;" >
                                           <asp:TextBox ID="txtArmsNormalPower2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>

                                  </tr>
                                  
                                  <tr><td>Severe Weakness</td><td>
                                      <asp:TextBox ID="txtArmsSevereWeakness1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td>
                                           <asp:TextBox ID="txtArmsSevereWeakness2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>

                                  </tr>
                                  <tr><td>Spastic Flexion</td>
                                      <td><asp:TextBox ID="txtArmsSpasticFlexion1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td>
                                           <asp:TextBox ID="txtArmsSpasticFlexion2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td></tr>
                                  <tr><td>Extension</td><td>
                                      <asp:TextBox ID="txtArmsExtension1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td>
                                           <asp:TextBox ID="txtArmsExtension2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td></tr>
                                  <tr><td>No Response</td><td>
                                      <asp:TextBox ID="txtArmsNoResponse1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td>
                                           <asp:TextBox ID="txtArmsNoResponse2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td></tr>
                                  </table>  
                            <table style="width:100%;" border="1">
                                <tr><td rowspan="6" style="width:100px;" >Lags record R or L to indicate side if Asymmetric</td><td style="width:100px;" > </td><td style="width:100px;" > 
                                      R
                                    </td>
                                      <td style="width:100px;" >
                                           L
                                    </td>

                                  </tr>
                                  
                                  <tr><td style="width:100px;" >Normal Power</td><td style="width:100px;" > 
                                      <asp:TextBox ID="txtLegsNormalPower1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td style="width:100px;" >
                                           <asp:TextBox ID="txtLegsNormalPower2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>

                                  </tr>
                                  <tr><td>Mild Weakness</td><td>
                                      <asp:TextBox ID="txtLegsMildWeakness1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td>
                                           <asp:TextBox ID="txtLegsMildWeakness2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>

                                  </tr>
                                  <tr><td>Spastic Flexion</td>
                                      <td><asp:TextBox ID="txtLegsSpasticFlexion1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td>
                                           <asp:TextBox ID="txtLegsSpasticFlexion2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td></tr>
                                  <tr><td>Extension</td><td>
                                      <asp:TextBox ID="txtLegsExtension1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td>
                                           <asp:TextBox ID="txtLegsExtension2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td></tr>
                                  <tr><td>No Response</td><td>
                                      <asp:TextBox ID="txtLegsNoResponse1" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                    </td>
                                      <td>
                                           <asp:TextBox ID="txtLegsNoResponse2" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="20" ></asp:TextBox>
                                          
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                                    </td></tr>
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
                        <asp:TemplateField HeaderText="EyeOpening">
                            <ItemTemplate>
                                <asp:Label ID="lblEyeOpening" runat="server" Text='<%#Eval("EyeOpening") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="VerbalAdult ">
                            <ItemTemplate>
                                <asp:Label ID="lblVerbalAdult" runat="server" Text='<%#Eval("VerbalAdult") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BestMotorResponse">
                            <ItemTemplate>
                                <asp:Label ID="lblBestMotorResponse" runat="server" Text='<%#Eval("BestMotorResponse") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Glascow" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblGlascow" runat="server" Text='<%#Eval("Glascow") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Risk ">
                            <ItemTemplate>
                                <asp:Label ID="lblRisk" runat="server" Text='<%#Eval("Risk") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sluggish">
                            <ItemTemplate>
                                <asp:Label ID="lblSluggish" runat="server" Text='<%#Eval("Sluggish") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="NoReaction" >
                            <ItemTemplate>
                                <asp:Label ID="lblNoReaction" runat="server" Text='<%#Eval("NoReaction") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EyesClosed" >
                            <ItemTemplate>
                                <asp:Label ID="lblEyesClosed" runat="server" Text='<%#Eval("EyesClosed") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ANormalPower1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblANormalPower1" runat="server" Text='<%#Eval("ANormalPower1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ANormalPower2"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblANormalPower2" runat="server" Text='<%#Eval("ANormalPower2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ASevereWeakness1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblASevereWeakness1" runat="server" Text='<%#Eval("ASevereWeakness1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ASevereWeakness2" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblASevereWeakness2" runat="server" Text='<%#Eval("ASevereWeakness2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ASpasticFlexion1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblASpasticFlexion1" runat="server" Text='<%#Eval("ASpasticFlexion1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ASpasticFlexion2" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblASpasticFlexion2" runat="server" Text='<%#Eval("ASpasticFlexion2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="AExtension1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblAExtension1" runat="server" Text='<%#Eval("AExtension1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="AExtension2"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblAExtension2" runat="server" Text='<%#Eval("AExtension2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                       
                         <asp:TemplateField HeaderText="ANoResponse1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblANoResponse1" runat="server" Text='<%#Eval("ANoResponse1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="ANoResponse2" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblANoResponse2" runat="server" Text='<%#Eval("ANoResponse2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LNormalPower1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblLNormalPower1" runat="server" Text='<%#Eval("LNormalPower1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LNormalPower2"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblLNormalPower2" runat="server" Text='<%#Eval("LNormalPower2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LMildWeakness1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblLMildWeakness1" runat="server" Text='<%#Eval("LMildWeakness1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LMildWeakness2"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblLMildWeakness2" runat="server" Text='<%#Eval("LMildWeakness2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LSpasticFlexion1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblLSpasticFlexion1" runat="server" Text='<%#Eval("LSpasticFlexion1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LSpasticFlexion2"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblLSpasticFlexion2" runat="server" Text='<%#Eval("LSpasticFlexion2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="LExtension1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblLExtension1" runat="server" Text='<%#Eval("LExtension1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LExtension2" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblLExtension2" runat="server" Text='<%#Eval("LExtension2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                       
                         <asp:TemplateField HeaderText="LNoResponse1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblLNoResponse1" runat="server" Text='<%#Eval("LNoResponse1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="LNoResponse2" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblLNoResponse2" runat="server" Text='<%#Eval("LNoResponse2") %>'></asp:Label>
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
                        <asp:TemplateField HeaderText="Entry By" Visible="false">
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

