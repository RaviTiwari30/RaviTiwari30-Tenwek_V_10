<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RichmondAgitationSedationScaleRASS.aspx.cs" Inherits="Design_IPD_RichmondAgitationSedationScaleRASS" %>

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
        th {
              text-align:center;
            }
        .col-md-8 {
              text-align:left;
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
        function change(id) {
           
            $("#txtScore").val($(id).val());
        }


        $(document).ready(function () {
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');

        });
        function validate() {
            if ($("#txtScore").val() == "")
            {
                modelAlert("please Select  Score", function () { 
                });
                return false;
            }
        }
        
    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>Richmond Agitation Sedation Scale (RASS)</b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                 Richmond Agitation Sedation Scale (RASS)
                </div>
 </div>
        
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-4" >Date
                        </div>
                     <div class="col-md-8" style="text-align:left;" >
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                         
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
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
                </div>
                 
 
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="row">
                    <div class="col-md-24">

                        
                        <table style="width:100%;" border="1">
                            <tr style="background-color:royalblue;color:white;"><th>Score</th><th >Term</th><th>Description</th><th></th></tr>
                            <tr><td><input type="radio" id="radio0" name="radio" value="4" onclick="change(this);" />+4</td><td>Combative</td><td>Overly combative, Violent, immediate danger to staff</td><td></td></tr>
                            <tr><td><input type="radio" id="Radio1"  name="radio" value="3" onclick="change(this);"   />+3</td><td>Very Agitated </td><td>pulls or removes tube(s) or Cather(s), Aggressive</td><td></td></tr>
                            <tr><td><input type="radio" id="Radio2"  name="radio" value="2" onclick="change(this);"    />+2</td><td>Agitated </td><td>Frequent non-purposeful movement, fights ventilator</td><td></td></tr>
                            <tr><td><input type="radio" id="Radio3" name="radio" value="1"  onclick="change(this);"   />+1</td><td>Restless</td><td>Anxious but movement not aggressive vigorous</td><td></td></tr>
                            <tr><td><input type="radio" id="Radio4" name="radio" value="0"  onclick="change(this);"   />0</td><td>alert and calm</td><td></td><td></td></tr>
                            <tr><td><input type="radio" id="Radio5" name="radio" value="-1" onclick="change(this);"    />-1</td><td>Drowsy</td><td>Not fully alert, but has sustained awakening (eye- Opening/ eye contact) to Voice (>10 seconds)</td><td rowspan="3">Verbal Stimulation</td></tr>
                            <tr><td><input type="radio" id="Radio6" name="radio"  value="-2" onclick="change(this);"   />-2</td><td>Light Sedation</td><td>Briefly awakens with eye contact to Voice (<10 seconds)</td></tr>
                            <tr><td><input type="radio" id="Radio7" name="radio"  value="-3" onclick="change(this);"   />-3</td><td>Moderate sedation</td><td>movement or eye opening to voice(but no eye contact)</td></tr>
                            <tr><td><input type="radio" id="Radio8" name="radio" value="-4"  onclick="change(this);"   />-4</td><td>Deep sedation </td><td> No response to voice, but movement or eye opening to physical Stimulation </td><td rowspan="2">Physical Stimulation</td></tr>
                            <tr><td><input type="radio" id="Radio9" name="radio" value="-5" onclick="change(this);"    />-5</td><td>Unarousable    </td><td>No Response to voice or physical Simulation </td></tr>
                        <tr><td colspan="1">Score:</td><td colspan="3"><asp:TextBox ID="txtScore" runat="server" Width="200px" ></asp:TextBox></td></tr>    
                        </table>
                        
                        <table style="width:100%;" border="1">
                            <tr style="background-color:royalblue;color:white;"><th></th><th >Procedure for RASS assessment</th><th></th></tr>
                            <tr><td>1</td><td>Observe Patient </td><td></td></tr>
                            <tr><td></td><td>a. Patient is alert , restllesss, or agitated </td><td>(score 0 to +4)</td></tr>
                            <tr><td>2</td><td>If not alert,state patient's name and say to open eyes and look at speaker </td><td></td></tr>
                            <tr><td></td><td>b. Patient awakens with sustained eye opening and eye contact</td><td>(Score -1)</td></tr>
                            <tr><td></td><td>c. Patient awakens with eye opening and eye contact but not sustained. </td><td>(Score -2)</td></tr>
                            <tr><td></td><td>d. Patient has any movement in response to voice but no eye contact. </td><td>(Score -3)</td></tr>
                            <tr><td>3</td><td>When no response to verbal stimulation , physically stimulate patient by shaking shoulder and /or rubbing sternum </td><td></td></tr>
                            <tr><td></td><td>e. Patient has any movement to physical Stimulation </td><td>(Score -4)</td></tr>
                            <tr><td></td><td>f. Patient has no response to any stimulation </td><td>(Score -5)</td></tr>
                            </table>
                            
                        <table style="width:100%;display:none;" border="1">
                            <tr style="background-color:royalblue;color:white;"><th rowspan="2">Parameter</th><th colspan="4">Guide Score</th><th rowspan="2">Patient Score</th></tr>
                            <tr style="background-color:royalblue;color:white;"><th >0</th><th >1</th><th >2</th><th >3</th></tr>
                            <tr><td>Behaviour</td>
                                <td>Playing 
                                    appropriately or
                                    sleeping 
                                    Comfortably</td>
                                <td>Irritable and consolable</td>
                                <td>Irritable, not consolable</td>
                                <td>Lethargic, confused,reduced response to pain</td>
                                <td>
                                     <asp:TextBox ID="txtBehaviour" runat="server" CssClass="" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="2" ToolTip=""></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtBehaviour" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                               
                                </td></tr>
                            <tr><td>Cardiovascular</td>
                                <td>Pink, Capillary Refill <2 secs</td>
                                <td>Pale capillary refill 2-3 secs</td>
                                <td>Grey, Capillary refill 3-4 secs, heart rate more than 20/min above or below normal range</td>
                                <td>Grey, Motted skin, Capillary refill >4 secs, Heart rate more than 30/min above or below normal range</td>
                                <td>
                                     <asp:TextBox ID="txtCardiovascular" runat="server" CssClass="" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="2" ToolTip=""></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtCardiovascular" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                               
                                </td></tr>
                            <tr><td>Respiratory</td>
                                <td>Normal Respiratory
rate, No chest indrawing, normal oxygen Saturation on room air</td>
                                <td>RR more than 10/min above normal range, oxygen saturation normal on oxygen supplementation , chest indrawing</td>
                                <td>RR>20/min above normal range, desaturating on oxygen (90-93%), Chest indrawing</td>
                                <td>RR more than 5 below normal range , oxygen saturation>90%, Chest Retractions,Grunting</td>
                                <td>
                                     <asp:TextBox ID="txtRespiratory" runat="server" CssClass="" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="2" ToolTip=""></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtRespiratory" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                               
                                </td></tr>
                            <tr><td>Output</td>
                                <td>Urine output 0.5 1 ml /kg/hr over the previous 4 hours and 0-1 bowel movement or vomitting in the previous 12 Hours</td>
                                <td>2 bowel movements or vomitting in the previous 12 hours</td>
                                <td>3 Bowel movements or vomitting in the previous 12 hours</td>
                                <td>0.5 ml/Kg/hr or urine output over the previous 4 hours or>3 bowel movements or vomitting in the previous 12 hours</td>
                                <td>
                                     <asp:TextBox ID="txtOutput" runat="server" CssClass="" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="2" ToolTip=""></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtOutput" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                               
                                </td></tr>
                            <tr><td>Actrion</td><td colspan="3">
                                  <asp:TextBox ID="txtAction" runat="server" CssClass=""  ClientIDMode="Static"
                                     TabIndex="15"  ToolTip="Action"></asp:TextBox>
                                 
                                                </td>
                                <td>Total Score</td>
                                <td><%--<asp:Label ID="lblTotalScore" runat="server" ></asp:Label>--%>
                                     <asp:TextBox ID="txtTotalScore" runat="server" Width="50px" CssClass=""  ClientIDMode="Static"
                                     TabIndex="15"  ToolTip=""></asp:TextBox>
                                 
                                </td>
                            </tr>
                            </table>
                        
                        <br />
                        
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
                        
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Score">
                            <ItemTemplate>
                                <asp:Label ID="lblScore" runat="server" Text='<%# Eval("Score") %>'></asp:Label>
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
                        
                        <asp:TemplateField HeaderText=" Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry Time">
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



