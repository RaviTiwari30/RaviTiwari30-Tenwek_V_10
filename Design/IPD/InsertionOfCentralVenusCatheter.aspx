<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InsertionOfCentralVenusCatheter.aspx.cs" Inherits="Design_IPD_InsertionOfCentralVenusCatheter" %>

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
        function calcMin()
        {
            var st = new Date($("#txtStartTime").val());
            var et =new Date( $("#txtEndTime").val());
            var diff = st - st;
            //alert(st +et+diff);
        }


        $(document).ready(function () {
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');

        });

        function validate() {

        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>Insertion Of Central Venus Catheter</b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Insertion Of Central Venus Catheter
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
                <div class="row">
                    <div class="col-md-4" >Start Date
                        </div>
                     <div class="col-md-8">
                                   <asp:TextBox ID="txtStartDate" CssClass="" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtStartDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                    </div>
                    <div class="col-md-4" >Start Time
                        </div>
                     <div class="col-md-8">
                                <asp:TextBox ID="txtStartTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtStartTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                         
                        </div>
                    </div>
                
                <div class="row">
                    <div class="col-md-4" >End Date
                        </div>
                     <div class="col-md-8">
                           <asp:TextBox ID="txtEndDate" CssClass="" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtEndDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                         </div>
                     <div class="col-md-4" >End Time
                        </div>
                     <div class="col-md-8">
                          <asp:TextBox ID="txtEndTime" runat="server" Width="100px"  ClientIDMode="Static" onblur="calcMin();" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtEndTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            
                        </div>
                    </div>
                <div class="row">
                    <div class="col-md-4" >Post Insertion(Min)
                        </div>
                     <div class="col-md-8">
                                <asp:TextBox ID="txtPostInsertion" runat="server" Width="100px"  ClientIDMode="Static" disabled ></asp:TextBox>
                               </div>
                    
                    <div class="col-md-4" >Type Of Catheter
                        </div>
                     <div class="col-md-8">
                                <asp:TextBox ID="txtTypeOfCatheter" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                               </div>
                    </div>
                <div class="row">
                    <div class="col-md-4" >Catheter Site
                        </div>
                     <div class="col-md-8">
                                <asp:TextBox ID="txtCatheterSite" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                               </div>
                    
                    <div class="col-md-4" >Proceduralist
                        </div>
                     <div class="col-md-8">
                                <asp:TextBox ID="txtProceduralist" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                               </div>
                    </div>
                
        <div class="row">
                    <div class="col-md-4" >Procedure Assistant
                        </div>
                     <div class="col-md-8">
                                <asp:TextBox ID="txtProcedureAssistant" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                               </div>
            </div>
                </div>
                 
 
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="row">
                    <div class="col-md-24">
                        <table style="width:100%;" border="1">
                            <tr style="background-color:royalblue;color:white;"><th colspan="2">Time Out Verification</th></tr>
                            <tr><td>Correct patient verified by using two patient Identifiers</td><td>
                                <asp:DropDownList id="ddlVerification1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Correct Site Identified</td><td>
                                <asp:DropDownList id="ddlVerification2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Correct Procedure Verified</td><td>
                                <asp:DropDownList id="ddlVerification3" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Completed Correct Signed Procedure Consent Form</td><td>
                                <asp:DropDownList id="ddlVerification4" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Relevant Documentation Available</td><td>
                                <asp:DropDownList id="ddlVerification5" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Allergies</td><td>
                                <asp:TextBox ID="txtAllergies" CssClass="" runat="server" Width="200"  ClientIDMode="Static"   ></asp:TextBox>
                                                                                                     </td></tr>
                                 <tr><td>Any safety Precautions dictated by patient history on medication use</td><td>
                                <asp:DropDownList id="ddlVerification6" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Explaination</td><td>
                                 <asp:TextBox ID="txtSaftyExplaination" CssClass="" runat="server" Width="200"  ClientIDMode="Static"   ></asp:TextBox>
                                                                                                 </td></tr>
                           <tr><td>Physical Examination of the patient done to establish suitability for central line insertion</td><td>
                                <asp:DropDownList id="ddlVerification7" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Assessment of most suitable site for central line insertion done by proceduralist</td><td>
                                <asp:DropDownList id="ddlVerification8" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Patient/Family received education:prevention of central line associated blood stream infections</td><td>
                                <asp:DropDownList id="ddlVerification9" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr style="background-color:royalblue;color:white;"><th colspan="2">Procedure</th></tr>
                           <tr><td>0.5% to 2%  chlorohexidine in 70% alcohol used to disinfect site</td><td>
                                <asp:DropDownList id="ddlProcedure1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Chlorohexidine allowed to dry before skin puncture</td><td>
                                <asp:DropDownList id="ddlProcedure2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Hand hygiene performed before catheter insertion or manipuation</td><td>
                                <asp:DropDownList id="ddlProcedure3" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Hand cover mask and sterile gown and gloves worn for procedure</td><td>
                                <%--<asp:DropDownList id="ddlProcedure4" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                --%>                                                                  </td></tr>
                        <tr><td>Proceduralist</td><td>
                                <asp:DropDownList id="ddlProcedure5" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Procedure Assistant</td><td>
                                <asp:DropDownList id="ddlProcedure6" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Large Sterile drapes used as per protocol</td><td>
                                <asp:DropDownList id="ddlProcedure7" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Sterile Field maintained throughout procedure</td><td>
                                <asp:DropDownList id="ddlProcedure8" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Dressing applied using sterile technique</td><td>
                                <asp:DropDownList id="ddlProcedure9" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Dressing dated as per policy</td><td>
                                <asp:DropDownList id="ddlProcedure10" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Central line insertion guided by ultrasound</td><td>
                                <asp:DropDownList id="ddlProcedure11" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Femoral vein not used unless other sites are not available</td><td>
                                <asp:DropDownList id="ddlProcedure12" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Explain</td><td>
                                <asp:TextBox ID="txtExplain1" CssClass="" runat="server"  Width="200px"  ClientIDMode="Static"  ></asp:TextBox> 
                                                                                                   </td></tr>
                         <tr style="background-color:royalblue;color:white;"><th colspan="2">Post Procedure Checks</th></tr>
                             <tr><td>Procedure Documented in the patients medical record</td><td>
                                <asp:DropDownList id="ddlPostProcedure1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                         <tr><td>Post check X-Ray ordered</td><td>
                                <asp:DropDownList id="ddlPostProcedure2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                         <tr><td>Confirmation of correct placement received</td><td>
                                <asp:DropDownList id="ddlPostProcedure3" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                       <tr><td>Any Equipment Problems to be addressed</td><td>
                                <asp:DropDownList id="ddlPostProcedure4" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                                                                                  </td></tr>
                        <tr><td>Explain</td><td>
                                <asp:TextBox ID="txtExplain2" CssClass="" runat="server"  Width="200px"  ClientIDMode="Static"  ></asp:TextBox> 
                                                                                                   </td></tr>
                        
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
                        
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="PostInsertion">
                            <ItemTemplate>
                                <asp:Label ID="lblPostInsertion" runat="server" Text='<%# Eval("Minutes") %>'></asp:Label>
                                <asp:Label ID="lblTypeOfCatheter" runat="server" Text='<%# Eval("TypeOfCatheter") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblCatheterSite" runat="server" Text='<%# Eval("CatheterSite") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProceduralist" runat="server" Text='<%# Eval("Proceduralist") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedureAssistant" runat="server" Text='<%# Eval("ProcedureAssistant") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification1" runat="server" Text='<%# Eval("Verification1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification2" runat="server" Text='<%# Eval("Verification2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification3" runat="server" Text='<%# Eval("Verification3") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification4" runat="server" Text='<%# Eval("Verification4") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification5" runat="server" Text='<%# Eval("Verification5") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification6" runat="server" Text='<%# Eval("Verification6") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification7" runat="server" Text='<%# Eval("Verification7") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification8" runat="server" Text='<%# Eval("Verification8") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVerification9" runat="server" Text='<%# Eval("Verification9") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure1" runat="server" Text='<%# Eval("Procedure1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure2" runat="server" Text='<%# Eval("Procedure2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure3" runat="server" Text='<%# Eval("Procedure3") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure4" runat="server" Text='<%# Eval("Procedure4") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure5" runat="server" Text='<%# Eval("Procedure5") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure6" runat="server" Text='<%# Eval("Procedure6") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure7" runat="server" Text='<%# Eval("Procedure7") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure8" runat="server" Text='<%# Eval("Procedure8") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure9" runat="server" Text='<%# Eval("Procedure9") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure10" runat="server" Text='<%# Eval("Procedure10") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure11" runat="server" Text='<%# Eval("Procedure11") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblProcedure12" runat="server" Text='<%# Eval("Procedure12") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPostProcedure1" runat="server" Text='<%# Eval("PostProcedure1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPostProcedure2" runat="server" Text='<%# Eval("PostProcedure2") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPostProcedure3" runat="server" Text='<%# Eval("PostProcedure3") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblPostProcedure4" runat="server" Text='<%# Eval("PostProcedure4") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblExplain1" runat="server" Text='<%# Eval("Explain1") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblExplain2" runat="server" Text='<%# Eval("Explain2") %>' Visible="false"></asp:Label>
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
                        
                        <asp:TemplateField HeaderText=" Start Date">
                            <ItemTemplate>
                                <asp:Label ID="lblStartDate" runat="server" Text='<%#Eval("StartDate1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Start Time">
                            <ItemTemplate>
                                <asp:Label ID="lblStartTime" runat="server" Text='<%#Eval("StartTime1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText=" End Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEndDate" runat="server" Text='<%#Eval("EndDate1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="End Time">
                            <ItemTemplate>
                                <asp:Label ID="lblEndTime" runat="server" Text='<%#Eval("EndTime1") %>'></asp:Label>
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



