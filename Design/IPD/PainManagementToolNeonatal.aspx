<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PainManagementToolNeonatal.aspx.cs" Inherits="Design_IPD_PainManagementToolNeonatal" %>

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
            addEvent();
        });
        function addEvent()
        {
            $("#txtFacial").change(function () {
                calculateTotal();
            });
            $("#txtCry").change(function () {
                calculateTotal();
            });
            $("#txtBreathing").change(function () {
                calculateTotal();
            });
            $("#txtArms").change(function () {
                calculateTotal();
            });
            $("#txtLegs").change(function () {
                calculateTotal();
            });
            $("#txtState").change(function () {
                calculateTotal();
            });
        }
        function calculateTotal(){
            var total = 0;
            if ($("#txtFacial").val() != "")
            {
                total +=parseFloat( $("#txtFacial").val());
            }
            if ($("#txtCry").val() != "") {
                total +=parseFloat( $("#txtCry").val());
            }
            if ($("#txtBreathing").val() != "") {
                total += parseFloat($("#txtBreathing").val());
            }
            if ($("#txtArms").val() != "") {
                total +=parseFloat( $("#txtArms").val());
            }
            if ($("#txtLegs").val() != "") {
                total +=parseFloat( $("#txtLegs").val());
            }
            if ($("#txtState").val() != "") {
                total +=parseFloat( $("#txtState").val());
            }
            $("#txtTotal").val(total.toFixed(0));
            
        }
        function validate() {
            if ($('#txtFacial').val() == "" && $('#txtCry').val() == "" && $('#txtBreathing').val() == "" && $('#txtArms').val() == "" && $('#txtLegs').val() == "" && $('#txtState').val() == "" && $('#txtTotal').val() == "" && $('#txtAction').val() == "" ) {
                modelAlert("Please Fill Details.", function () { });
                return false;
            }
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>Pain Management Tool(Neonatal) </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Pain Management Tool(Neonatal)
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
                                <th class="GridViewHeaderStyle" scope="col" >Parameter</th>
                                <th class="GridViewHeaderStyle" scope="col" colspan="3" >Neonatal Guide Score</th>
                                <th class="GridViewHeaderStyle" scope="col" >Patient Score</th>

                            </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"  ></td>
                            <td class="GridViewLabItemStyle"  >0</td>
                            <td class="GridViewLabItemStyle"  >1</td>
                            <td class="GridViewLabItemStyle"  >2</td>
                            <td class="GridViewLabItemStyle"  ></td>
                           </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"  >Facial Expression</td>
                            <td class="GridViewLabItemStyle"  >Restful,Neutral Expression</td>
                            <td class="GridViewLabItemStyle"  >Tight Facial Muscles Furrowed brow,chin jaw </td>
                            <td class="GridViewLabItemStyle"  ></td>
                            <td class="GridViewLabItemStyle"  >
                              <asp:TextBox ID="txtFacial" CssClass="" runat="server" Width="80"  ClientIDMode="Static"  MaxLength="2" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtFacial" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                           </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"  >Cry Score</td>
                            <td class="GridViewLabItemStyle"  >Quite not crying</td>
                            <td class="GridViewLabItemStyle"  >Mild Intermittent Moaning</td> 
                            <td class="GridViewLabItemStyle"  >Loud Scream rising Shrill continious</td>
                            <td class="GridViewLabItemStyle"  >
                                
                              <asp:TextBox ID="txtCry" CssClass="" runat="server" Width="80"  ClientIDMode="Static" MaxLength="2" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtCry" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                           </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"  >Breathing Patterns</td>
                            <td class="GridViewLabItemStyle"  >Usual for Infant</td>
                            <td class="GridViewLabItemStyle"  >Indrawing Iregular Tachy phoea</td> 
                            <td class="GridViewLabItemStyle"  ></td>
                            <td class="GridViewLabItemStyle"  >
                                
                              <asp:TextBox ID="txtBreathing" CssClass="" runat="server" Width="80"  ClientIDMode="Static" MaxLength="2" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtBreathing" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                           </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"  >Arms </td>
                            <td class="GridViewLabItemStyle"  >Muscular rigidity ocassional random arm movement</td>
                            <td class="GridViewLabItemStyle"  >Tense straight rigid and/or rapid extension/flexion of arm</td> 
                            <td class="GridViewLabItemStyle"  ></td>
                            <td class="GridViewLabItemStyle"  >
                                <asp:TextBox ID="txtArms" CssClass="" runat="server" Width="80"  ClientIDMode="Static" MaxLength="2" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtArms" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                           </tr>
                          
                              <tr>
                            <td class="GridViewLabItemStyle"  >Legs </td>
                            <td class="GridViewLabItemStyle"  >Muscular rigidity ocassional random leg movement</td>
                            <td class="GridViewLabItemStyle"  >Tense straight rigid and/or rapid extension/flexion of leg</td> 
                            <td class="GridViewLabItemStyle"  ></td>
                            <td class="GridViewLabItemStyle"  >
                              <asp:TextBox ID="txtLegs" CssClass="" runat="server" Width="80"  ClientIDMode="Static" MaxLength="2" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtLegs" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                           </tr>

                            
                              <tr>
                            <td class="GridViewLabItemStyle"  >State of arousal </td>
                            <td class="GridViewLabItemStyle"  >Quit peaceful sleeping or alert random limb movement</td> 
                            <td class="GridViewLabItemStyle"  >Alert Restless and threshing</td> 
                            <td class="GridViewLabItemStyle"  ></td>
                            <td class="GridViewLabItemStyle"  >
                                
                              <asp:TextBox ID="txtState" CssClass="" runat="server" Width="80"  ClientIDMode="Static" MaxLength="2" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtState" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                           </tr>

                            
                              <tr>
                            <td class="GridViewLabItemStyle " colspan="4"  >Total Score </td>
                            <td class="GridViewLabItemStyle"  >
                                
                              <asp:TextBox ID="txtTotal" CssClass="" runat="server" Width="80"  ClientIDMode="Static" MaxLength="2"  ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtTotal" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                           </tr>
                            
                              <tr>
                            <td class="GridViewLabItemStyle " colspan="2"  >Action </td>
                                  <td class="GridViewLabItemStyle " colspan="3"  > 
                                
                              <asp:TextBox ID="txtAction" CssClass="" runat="server"   ClientIDMode="Static"  ></asp:TextBox>
                                   
                            </td>
                          
                           </tr>

                            
                              <tr>
                            <td class="GridViewLabItemStyle "   > </td>
                            <td class="GridViewLabItemStyle " colspan="3"  >Assessment done by (Nurse initials) </td>
                            <td class="GridViewLabItemStyle "   >
                                
                              <asp:TextBox ID="txtAssessmentBy" CssClass="" runat="server" Width="80"  ClientIDMode="Static" MaxLength="200" disabled></asp:TextBox>
                                      <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
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
                        <asp:TemplateField HeaderText="Facial">
                            <ItemTemplate>
                                <asp:Label ID="lblFacial" runat="server" Text='<%#Eval("Facial") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cry ">
                            <ItemTemplate>
                                <asp:Label ID="lblCry" runat="server" Text='<%#Eval("Cry") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Breathing">
                            <ItemTemplate>
                                <asp:Label ID="lblBreathing" runat="server" Text='<%#Eval("Breathing") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Arms">
                            <ItemTemplate>
                                <asp:Label ID="lblArms" runat="server" Text='<%#Eval("Arms") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Legs ">
                            <ItemTemplate>
                                <asp:Label ID="lblLegs" runat="server" Text='<%#Eval("Legs") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="State">
                            <ItemTemplate>
                                <asp:Label ID="lblState" runat="server" Text='<%#Eval("State") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total" >
                            <ItemTemplate>
                                <asp:Label ID="lblTotal" runat="server" Text='<%#Eval("Total") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action" >
                            <ItemTemplate>
                                <asp:Label ID="lblAction" runat="server" Text='<%#Eval("Action") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="AssessmentBy" >
                            <ItemTemplate>
                                <asp:Label ID="lblAssessmentBy" runat="server" Text='<%#Eval("AssessmentBy1") %>'></asp:Label>
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

