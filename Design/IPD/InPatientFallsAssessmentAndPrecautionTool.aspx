<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InPatientFallsAssessmentAndPrecautionTool.aspx.cs" Inherits="Design_IPD_InPatientFallsAssessmentAndPrecautionTool" %>


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
        function addEvent() {
            $("#txtMobility").change(function () {
                calculateTotal();
            });
            $("#txtMentalState").change(function () {
                calculateTotal();
            });
            $("#txtToileting").change(function () {
                calculateTotal();
            });
            $("#txtPatientAge").change(function () {
                calculateTotal();
            });
            $("#txtDiagnosis").change(function () {
                calculateTotal();
            });
            $("#txtGender").change(function () {
                calculateTotal();
            });
            $("#txtMedication").change(function () {
                calculateTotal();
            });
            //$("#txtTotal").attr('disabled',true);

        }
        function calculateTotal() {
            var total = 0;
            if ($("#txtMobility").val() != "") {
                total += parseFloat($("#txtMobility").val());
            }
            if ($("#txtMentalState").val() != "") {
                total += parseFloat($("#txtMentalState").val());
            }
            if ($("#txtToileting").val() != "") {
                total += parseFloat($("#txtToileting").val());
            }
            if ($("#txtPatientAge").val() != "") {
                total += parseFloat($("#txtPatientAge").val());
            }
            if ($("#txtDiagnosis").val() != "") {
                total += parseFloat($("#txtDiagnosis").val());
            }
            if ($("#txtGender").val() != "") {
                total += parseFloat($("#txtGender").val());
            }
            if ($("#txtMedication").val() != "") {
                total += parseFloat($("#txtMedication").val());
            }
            $("#txtTotal").val(total.toFixed(0));

        }

        function validate() {
            if ($('#txtFacial').val() == "" && $('#txtCry').val() == "" && $('#txtBreathing').val() == "" && $('#txtArms').val() == "" && $('#txtLegs').val() == "" && $('#txtState').val() == "" && $('#txtTotal').val() == "" && $('#txtAction').val() == "") {
                modelAlert("Please Fill Details.", function () { });
                return false;
            }
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>InPatient Falls Assessment And Precaution Tool </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Falls Risk Assessment
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
                                <th class="GridViewHeaderStyle" scope="col" > </th>
                                <th class="GridViewHeaderStyle" scope="col"  >Write the Score against each column</th>
                                <th class="GridViewHeaderStyle" scope="col" >Score </th>
                                <th class="GridViewHeaderStyle" scope="col" > </th>
                            </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;"  rowspan="4" >Mobility</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Completely Immobile
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                            
                                <td class="GridViewLabItemStyle" style="width:500px;"  rowspan="4" >
                                    <asp:TextBox ID="txtMobility" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="1" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtMobility" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                                </tr>
                            
                            
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Ambulant with no gait disturbance
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Ambulate and transfer with assistive device
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Ambulate with Unsteady gait and no assistive device
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                                
                                </tr>

                             <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;"  rowspan="4" >Mental State</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Coma/Unreasponsive
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                            
                                <td class="GridViewLabItemStyle" style="width:500px;"  rowspan="4" >
                                    <asp:TextBox ID="txtMentalState" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="1" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtMentalState" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Developmentally appropriate and alert
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Developmentally delayed

                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >DisOrientated
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >2
                            </td>
                                
                                </tr>
                           
                              <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;"  rowspan="4" >Toileting</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Nappies
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                            
                                <td class="GridViewLabItemStyle" style="width:500px;"  rowspan="4" >
                                    <asp:TextBox ID="txtToileting" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="1" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtToileting" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Independent
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Needs assistance with toileting

                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Independent with Urinary frequency diarrhea 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                                
                                </tr>
                          
                                <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;"  rowspan="4" >Patient Age</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Less than 3 years
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >3
                            </td>
                            
                                <td class="GridViewLabItemStyle" style="width:500px;"  rowspan="4" >
                                    <asp:TextBox ID="txtPatientAge" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="1" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtPatientAge" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >3 to less than 7 years old
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >2
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >7 to less than 13 years old

                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >13 years and above
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                                
                                </tr>
                          
                                       <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;"  rowspan="3" >Diagnosis</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Alteration in Oxygenation(Respiratory diagnosis,Dehydration, Anemia,Anorexai,Syncope dizziness etc)
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >2
                            </td>
                            
                                <td class="GridViewLabItemStyle" style="width:500px;"  rowspan="3" >
                                    <asp:TextBox ID="txtDiagnosis" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="1" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtDiagnosis" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Phsyc/Behavioral disorders
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Other diagnosis

                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                                
                                </tr>
                            
                            <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;"  rowspan="2" >Gender</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Boys
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                            
                                <td class="GridViewLabItemStyle" style="width:500px;"  rowspan="2" >
                                    <asp:TextBox ID="txtGender" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="1" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtGender" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Girls
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                                
                                </tr>
                            
                                            <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;"  rowspan="3" >Medication</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Multiple Usage of AntiConvulsants , opiads ,diuretiocs ,sedetives bowel prep
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >2
                            </td>
                            
                                <td class="GridViewLabItemStyle" style="width:500px;"  rowspan="3" >
                                    <asp:TextBox ID="txtMedication" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="1" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtMedication" ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>

                            </td>
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >Atleast one of the above
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >1
                            </td>
                                
                                </tr>
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:500px;" >None of the Above

                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >0
                            </td>
                                
                                </tr>
                       
                            <tr>
                            <td class="GridViewLabItemStyle"  style="width:500px;" >Total</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Total Falls risk score
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >20
                            </td>
                            
                                <td class="GridViewLabItemStyle" style="width:500px;"   >
                                    <asp:TextBox ID="txtTotal" CssClass="" runat="server" Width="100"  ClientIDMode="Static"  MaxLength="4"  ></asp:TextBox>
                                    
                               <%-- <asp:TextBox ID="lblTotal1" runat="server" disabled></asp:TextBox>
                               --%>     
                            </td>
                                </tr>
                             
                              
                           <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" colspan="2" >Action
                            </td>
                                
                                <td class="GridViewLabItemStyle" style="width:500px;"  colspan="2"   >
                                    <asp:TextBox ID="txtTotalFallsRiskScore" CssClass="" runat="server" Width="500"  ClientIDMode="Static"   ></asp:TextBox>
                                    
                            </td>
                                </tr>
                            <tr>
                            
                            <td class="GridViewLabItemStyle" colspan="2" style="width:500px;" >Assessment Done By (Nurse Initials)</td>
                                <td class="GridViewLabItemStyle" style="width:500px;"  colspan="2" >
                                    <asp:TextBox ID="txtAssessedBy" CssClass="" runat="server" Width="500"  ClientIDMode="Static"   disabled></asp:TextBox>
                                   
                            </td>
                                </tr>
                           
                            </table>
                        
                        
                        
                    </div>
                </div>
               
               
               
               
                
                </div>
                
            <div class="POuter_Box_Inventory" style="text-align: center;">
<div class="Purchaseheader" style="text-align: left;">
                   Falls Precautions
                </div>
 
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-2" >Date
                        </div>
                     <div class="col-md-5">
                          <span  style="display:none;"  id="Span1"></span>
                   
                        <span style="display:none;" id="Span2"></span>
                        
                        <span  style="display:none;"  id="Span3"></span>
                                   <asp:TextBox ID="txtFPDate" CssClass="requiredField" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFPDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                        </div>
                     <div class="col-md-2" >Time
                        </div>
                     <div class="col-md-8">
                          <asp:TextBox ID="txtFPTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtFPTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtFPTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                        </div>
                    </div>

                </div>
                 
 
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="row">
                    <div class="col-md-24">
                        <table style="width:100%;" class="FixedTables" >
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" > </th>
                                <th class="GridViewHeaderStyle" scope="col"  >Falls/Precautions </th>
                                <th class="GridViewHeaderStyle" scope="col" >Yes/No </th>
                                
                            </tr>
                            <tr>
                            <td class="GridViewLabItemStyle"  rowspan="3" >Supervision</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Patient is under 24 hr care by care taker
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlSuperVision1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Patient is supervised during transfer
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlSuperVision2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >During Procedure Patient is supervised 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlSuperVision3" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>

                             <tr>
                            <td class="GridViewLabItemStyle"  rowspan="6" >Patient room</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Room is free of clutter and unsecured cords
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientRoom1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >cot rails are up
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientRoom2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Wheeled equipments secured 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientRoom3" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                             <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Patient is not left on unsecured bed or high places 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientRoom4" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                             <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Room is well fit and obstructions free 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientRoom5" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                             <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Call bells are accessable and functional 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientRoom6" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>


                                <tr>
                            <td class="GridViewLabItemStyle"  rowspan="3" >high risk patients score>=6</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Room is closed to nurses station or view
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlHRPS1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >yellow identification snap is put on patient's arm band
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlHRPS2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >falls high risk posters has been placed 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlHRPS3" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                         
                            <tr>
                            <td class="GridViewLabItemStyle"  rowspan="4" >Patient and family</td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Oriented to room and ward/department
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientAndFamily1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Educated on falls prevention and these falls precaution
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientAndFamily2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Did Patient experience any fall associated with injury today?(Yes/No) high risk posters has been placed 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientAndFamily3" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                            <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Q-Pulse SE No if Yes in 4.3(For follow Up) 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                    <asp:DropDownList id="ddlPatientAndFamily4" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>  
                            </td>
                            
                                </tr>
                         
                              <tr>
                            <td class="GridViewLabItemStyle"  ></td>
                          <td class="GridViewLabItemStyle" style="width:500px;" >Checked By( Nurse initials) 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" >
                                   <asp:TextBox ID="txtCheckedBy" CssClass="" runat="server" Width="500"  ClientIDMode="Static"   disabled></asp:TextBox>
                                     
                            </td>
                            
                                </tr>
                          <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" > 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" colspan="2" >
                                     KEY
                            </td>
                            
                                </tr>
                          <tr>
                          <th  class="GridViewHeaderStyle" scope="col"  >Total Score 
                            </th>
                                <th  class="GridViewHeaderStyle" scope="col"  colspan="2" >
                                     Action
                            </th>
                            
                                </tr>
                          <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >0-5 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" colspan="2" >
                                     Initiate Falls Prevention Precautions
                            </td>
                            
                                </tr>
                          <tr>
                          <td class="GridViewLabItemStyle" style="width:500px;" >6 To 10 
                            </td>
                                <td class="GridViewLabItemStyle" style="width:500px;" colspan="2" >Falls high risk patient, initiate falls prevention precautions and 
                                    in additional put a yellow snap on the patient armband pl risk poster on the patient door and where possible move patient closer to the nurse station
                                     
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
                        <asp:TemplateField HeaderText="Mobility">
                            <ItemTemplate>
                                <asp:Label ID="lblMobility" runat="server" Text='<%#Eval("Mobility") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MentalState ">
                            <ItemTemplate>
                                <asp:Label ID="lblMentalState" runat="server" Text='<%#Eval("MentalState") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Toileting">
                            <ItemTemplate>
                                <asp:Label ID="lblToileting" runat="server" Text='<%#Eval("Toileting") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientAge">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientAge" runat="server" Text='<%#Eval("PatientAge") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Diagnosis ">
                            <ItemTemplate>
                                <asp:Label ID="lblDiagnosis" runat="server" Text='<%#Eval("Diagnosis") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Gender">
                            <ItemTemplate>
                                <asp:Label ID="lblGender" runat="server" Text='<%#Eval("Gender") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Medication" >
                            <ItemTemplate>
                                <asp:Label ID="lblMedication" runat="server" Text='<%#Eval("Medication") %>'></asp:Label>
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
                        <asp:TemplateField HeaderText="TotalFallsRiskScore"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblTotalFallsRiskScore" runat="server" Text='<%#Eval("TotalFallsRiskScore") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="AssessmentBy"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblAssessmentBy" runat="server" Text='<%#Eval("AssessmentBy1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SuperVision1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblSuperVision1" runat="server" Text='<%#Eval("SuperVision1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SuperVision2" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblSuperVision2" runat="server" Text='<%#Eval("SuperVision2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SuperVision3" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblSuperVision3" runat="server" Text='<%#Eval("SuperVision3") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientRoom1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblPatientRoom1" runat="server" Text='<%#Eval("PatientRoom1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientRoom2" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblPatientRoom2" runat="server" Text='<%#Eval("PatientRoom2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientRoom3" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblPatientRoom3" runat="server" Text='<%#Eval("PatientRoom3") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientRoom4" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblPatientRoom4" runat="server" Text='<%#Eval("PatientRoom4") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientRoom5" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblPatientRoom5" runat="server" Text='<%#Eval("PatientRoom5") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientRoom6" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblPatientRoom6" runat="server" Text='<%#Eval("PatientRoom6") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="HRPS1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblHRPS1" runat="server" Text='<%#Eval("HRPS1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="HRPS2"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblHRPS2" runat="server" Text='<%#Eval("HRPS2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                       
                         <asp:TemplateField HeaderText="HRPS3"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblHRPS3" runat="server" Text='<%#Eval("HRPS3") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="PatientAndFamily1" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblPatientAndFamily1" runat="server" Text='<%#Eval("PatientAndFamily1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientAndFamily2"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientAndFamily2" runat="server" Text='<%#Eval("PatientAndFamily2") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientAndFamily3"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientAndFamily3" runat="server" Text='<%#Eval("PatientAndFamily3") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientAndFamily4"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientAndFamily4" runat="server" Text='<%#Eval("PatientAndFamily4") %>'></asp:Label>
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
                        <asp:TemplateField HeaderText="Checked By" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblCheckedID" runat="server" Text='<%#Eval("CheckedBy") %>' Visible="false"></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
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
                        <asp:TemplateField HeaderText="FPDate">
                            <ItemTemplate>
                                <asp:Label ID="lblFPDate" runat="server" Text='<%#Eval("FPDate1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="FPTime">
                            <ItemTemplate>
                                <asp:Label ID="lblFPTime" runat="server" Text='<%#Eval("FPTime1") %>'></asp:Label>
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

