<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UpperEndoscopyForm.aspx.cs" Inherits="Design_IPD_UpperEndoscopyForm" %>
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
    
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
   <%-- <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />--%>
    <script type="text/javascript">

        function convfromcmeters() {
            $("#lblBMI").text('');
            var frm = $("#txtHeight").val();
            var weight = $("#txtWeight").val();
            var feet2 = 0;
            var inches2 = 0;
            var pound = parseFloat(weight * 2.20462).toFixed(3);
            inches2 = ((frm) * .39370078740157477);

            if (inches2 == 0) {
            }
            else if (inches2 == "") {
                alert("Please enter valid values into the boxes");
            }
            feet2 = parseInt(inches2 / 12);
            inches2 = inches2 % 12;

            if (feet2 != "0" && inches2 != "0" && pound != "0.000") {
                compute(feet2, inches2, pound);
            }
            else {
                $("#lblBMI").text(0);
            }
        }
        function cal_bmi(lbs, ins) {
            h2 = ins * ins;
            bmi = lbs / h2 * 703
            f_bmi = Math.floor(bmi);
            diff = bmi - f_bmi;
            diff = diff * 10;
            diff = Math.round(diff);
            if (diff == 10)    // Need to bump up the whole thing instead
            {
                f_bmi += 1;
                diff = 0;
            }
            if (isNaN(f_bmi)) f_bmi = 0;
            if (isNaN(diff)) diff = 0;
            bmi = f_bmi + "." + diff;
            return bmi;
        }
        function compute(feet, inch, weight) {
            var f = self.document.forms[1];
            w = weight;
            v = feet;
            u = inch;
            //w = document.getElementById('height_feet').value;
            // Format values for the BMI calculation
            var fi = parseInt(feet * 12);
            var i = parseInt(feet * 12) + inch * 1.0;
            // Do validation of remaining fields to check for existence of values
            if (w != "" && i != "") {
                // Perform the calculation
                var Bmi = cal_bmi(w, i);
                if (Bmi != "") {
                    $("#lblBMI").text('Your Bmi Is : ' + Bmi + '');
                    $("#lblBMI").text(Bmi);
                }
            }
            if (Bmi == null)
                $("#txtBMI").val(0);
            //             f.bmi.value = cal_bmi(w, i);
            //             f.bmi.focus();
        }
        $(document).ready(function () {
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');
            //bindData();
            $("#txtHeight").change(function () {
                convfromcmeters();

            });
            $("#txtWeight").change(function () {
                convfromcmeters();

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
             <b>Upper Endoscopy </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Upper Endoscopy
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
                                   <td class="GridViewLabItemStyle"    style="width:16.6%;"    >Sur Name</td>
                                   <td class="GridViewLabItemStyle"    style="width:16.6%;"    >
                                         <asp:Label ID="lblSurName" runat="server" ></asp:Label>
                                   </td>
                                <td class="GridViewLabItemStyle"     style="width:16.6%;"   >First Name</td>
                                   <td class="GridViewLabItemStyle"   style="width:16.6%;"     >
                                         <asp:Label ID="lblFirstName" runat="server" ></asp:Label>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     style="width:16.6%;"   >Other Name</td>
                                   <td class="GridViewLabItemStyle"   style="width:16.6%;"     >
                                         <asp:Label ID="lblOtherName" runat="server" ></asp:Label>
                                   </td>
                                </tr>
                            <tr>
                                   <td class="GridViewLabItemStyle"     >Age </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblAge" runat="server" ></asp:Label>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Sex </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblSex" runat="server" ></asp:Label>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Tribe </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtTribe" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                
                                   </td>
                                </tr>
                            <tr>
                                   <td class="GridViewLabItemStyle"     >County </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblCounty" runat="server" ></asp:Label>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Location </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblLocation" runat="server" ></asp:Label>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Village </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblVillage" runat="server" ></asp:Label>
                                
                                   </td>
                                </tr>
                            
                            <tr>
                                   <td class="GridViewLabItemStyle"     >Phone </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblPhone" runat="server" ></asp:Label>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Chief </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtChief" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Alternative Number </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblAlternative" runat="server" ></asp:Label>
                                
                                   </td>
                                </tr>
                            <tr>
                                   <td class="GridViewLabItemStyle"     >Health Information </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtHealth" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Symptoms </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtSymptoms" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Height(cms) </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtHeight" CssClass="" runat="server"    ClientIDMode="Static"  MaxLength="5"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtHeight"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            
                                   </td>
                                </tr>
                            
                            <tr>
                                   <td class="GridViewLabItemStyle"     >Weight(kg)</td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtWeight" CssClass="" runat="server"    ClientIDMode="Static"  MaxLength="5"></asp:TextBox>
                                       <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtWeight"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            
                                   </td>
                                <td class="GridViewLabItemStyle"     >BMI(kg/m<sup>2</sup>) </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:Label ID="lblBMI" runat="server" ></asp:Label>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Swallows Solid </td>
                                   <td class="GridViewLabItemStyle"     >
                                       <asp:DropDownList id="ddlSwallows" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                
                                
                                   </td>
                                </tr>
                            <tr>
                                   <td class="GridViewLabItemStyle"     >Liquids</td>
                                   <td class="GridViewLabItemStyle"     >
                                       <asp:DropDownList id="ddlLiquids" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Saliva </td>
                                   <td class="GridViewLabItemStyle"     >
                                       <asp:DropDownList id="ddlSaliva" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Odynophagia </td>
                                   <td class="GridViewLabItemStyle"     >
                                       <asp:DropDownList id="ddlOdynophagia" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                
                                
                                   </td>
                                </tr>
                            <tr>
                                   <td class="GridViewLabItemStyle"     >Emesis </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtEmesis" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Hematemesis </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtHematemesis" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Abd pain (Location) </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtAbdPain" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                
                                   </td>
                                </tr>
                             <tr>
                                   <td class="GridViewLabItemStyle"     >Dyspepsia </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtDyspepsia" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Anemia/Hgb </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtAnemia" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Weight loss </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtWeightLoss" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                
                                   </td>
                                </tr>
                             <tr>
                                   <td class="GridViewLabItemStyle"     >Black Stools </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtBlackStools" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Bloody Stools </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtBloodyStools" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                
                                <td class="GridViewLabItemStyle"     >Other </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtOther" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                
                                   </td>
                                </tr>
                            
                             <tr>
                                   <td class="GridViewLabItemStyle"     >Duration of Symptoms </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:TextBox ID="txtDuration" CssClass="" runat="server"    ClientIDMode="Static" ></asp:TextBox>
                                   </td>
                                <td class="GridViewLabItemStyle"     >Alcohol Use(past) </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:DropDownList id="ddlAlcohol1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                </td>
                                
                                <td class="GridViewLabItemStyle"     >Smoking(past) </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:DropDownList id="ddlSmoking1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                
                                   </td>
                                </tr>
                           
                             <tr>
                                   <td class="GridViewLabItemStyle"     >NSAIDS(past) </td>
                                   <td class="GridViewLabItemStyle"     >
                                           <asp:DropDownList id="ddlNSAIDS1" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>                                   </td>
                                <td class="GridViewLabItemStyle"     >Alcohol Use(now) </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:DropDownList id="ddlAlcohol2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                </td>
                               
                                <td class="GridViewLabItemStyle"     >Smoking(now) </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:DropDownList id="ddlSmoking2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                
                                   </td>
                                </tr>
                           <tr>
                                   <td class="GridViewLabItemStyle"     >NSAIDS(now) </td>
                                   <td class="GridViewLabItemStyle"     >
                                           <asp:DropDownList id="ddlNSAIDS2" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>                                   </td>
                                <td class="GridViewLabItemStyle"     >Eso Ca/Dysphagia </td>
                                   <td class="GridViewLabItemStyle"     >
                                          <asp:DropDownList id="ddlEso" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>
                                </td>
                               
                                <td class="GridViewLabItemStyle"     >Person and Age </td>
                                   <td class="GridViewLabItemStyle"     >
                                         
                              <asp:TextBox ID="txtPersonAge1" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                                   </td>
                                </tr>
                           
                           <tr>
                                   <td class="GridViewLabItemStyle"     >Other Cancer </td>
                                   <td class="GridViewLabItemStyle"     >
                                           <asp:DropDownList id="ddlOtherCancer" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>                                   </td>
                                <td class="GridViewLabItemStyle"     >Person and Age </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:TextBox ID="txtPersonAge2" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                              
                                </td>
                               
                                <td class="GridViewLabItemStyle"     >Last EGD Date </td>
                                   <td class="GridViewLabItemStyle"     >
                                         
                              <asp:TextBox ID="txtLastEGDDate" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtLastEGDDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                                   </td>
                                </tr>
                            
                            <tr style="background-color:royalblue;color:white;"><th colspan="6">Findings</th></tr>
                            
                           <tr>
                                   <td class="GridViewLabItemStyle" colspan="2"    >Additional History </td>
                                   <td class="GridViewLabItemStyle"   colspan="4"    >
                                        <asp:TextBox ID="txtAdditionalHistory" CssClass="" runat="server"  ClientIDMode="Static"  TextMode="MultiLine"   ></asp:TextBox>
                             
                                    </td>
                               </tr>
                             <tr>
                                   <td class="GridViewLabItemStyle" colspan="2"    >Pharnyx/Larynx </td>
                                   <td class="GridViewLabItemStyle"   colspan="4"    >
                                        <asp:TextBox ID="txtPharnyx" CssClass="" runat="server"  ClientIDMode="Static" TextMode="MultiLine"  ></asp:TextBox>
                             
                                    </td>
                               </tr>
                           <tr>
                                   <td class="GridViewLabItemStyle" colspan="2"    >Esophagus </td>
                                   <td class="GridViewLabItemStyle"   colspan="4"    >
                                        <asp:TextBox ID="txtEsophagus" CssClass="" runat="server"  ClientIDMode="Static"   TextMode="MultiLine"  ></asp:TextBox>
                             
                                    </td>
                               </tr>
                           <tr>
                                   <td class="GridViewLabItemStyle" colspan="2"    >Stomach </td>
                                   <td class="GridViewLabItemStyle"   colspan="4"    >
                                        <asp:TextBox ID="txtStomach" CssClass="" runat="server"  ClientIDMode="Static"  TextMode="MultiLine"   ></asp:TextBox>
                             
                                    </td>
                               </tr>
                           <tr>
                                   <td class="GridViewLabItemStyle" colspan="2"    >Duodenum </td>
                                   <td class="GridViewLabItemStyle"   colspan="4"    >
                                        <asp:TextBox ID="txtDuodenum" CssClass="" runat="server"  ClientIDMode="Static"  TextMode="MultiLine"   ></asp:TextBox>
                             
                                    </td>
                               </tr>
                           <tr>
                                   <td class="GridViewLabItemStyle"     >Sedation Used </td>
                                   <td class="GridViewLabItemStyle"     >
                                           <asp:DropDownList id="ddlSedation" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>                                   </td>
                                <td class="GridViewLabItemStyle"     >Versed </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:TextBox ID="txtVersed" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                              
                                </td>
                               
                                <td class="GridViewLabItemStyle"     >Fentanyl </td>
                                   <td class="GridViewLabItemStyle"     >
                                         
                              <asp:TextBox ID="txtFentanyl" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                                        
                                   </td>
                                </tr>
                           <tr>
                                   <td class="GridViewLabItemStyle"     >Ketamine </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:TextBox ID="txtKetamine" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                                                                 </td>
                                <td class="GridViewLabItemStyle"     >Oxygen </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:TextBox ID="txtOxygen" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                              
                                </td>
                               
                                <td class="GridViewLabItemStyle"     >Other </td>
                                   <td class="GridViewLabItemStyle"     >
                                         
                              <asp:TextBox ID="txtOther2" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                                        
                                   </td>
                                </tr>
                           <tr>
                                   <td class="GridViewLabItemStyle"     >Images Captured </td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:DropDownList id="ddlImages" runat="server" Width="200">
                                        <asp:ListItem value="0" Text="--Select--" />
                                        <asp:ListItem value="1" Text="Yes" />
                                        <asp:ListItem value="2" Text="No" />
                                    </asp:DropDownList>

                                   </td>
                                <td class="GridViewLabItemStyle"     >Impression(s)</td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:TextBox ID="txtImpression" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                              
                                </td>
                               
                                <td class="GridViewLabItemStyle"     >Endoscopy Intervention(s) </td>
                                   <td class="GridViewLabItemStyle"     >
                                         
                              <asp:TextBox ID="txtEndoscopyIntervention" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                                        
                                   </td>
                                </tr>
                           <tr>
                                   <td class="GridViewLabItemStyle"     >Recommendations </td>
                                   <td class="GridViewLabItemStyle"     >
                                        <asp:TextBox ID="txtRecommendations" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                              
                                   </td>
                                <td class="GridViewLabItemStyle"     >FollowUp Date</td>
                                   <td class="GridViewLabItemStyle"     >
                                         <asp:TextBox ID="txtFollowUpDate" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                              <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtFollowUpDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                                </td>
                               
                                <td class="GridViewLabItemStyle"     >Report by</td>
                                   <td class="GridViewLabItemStyle"     >
                                         
                              <asp:TextBox ID="txtReportBy" CssClass="" runat="server"  ClientIDMode="Static" disabled  ></asp:TextBox>
                                        
                                   </td>
                                </tr>
                            
                           <tr>
                                   <td class="GridViewLabItemStyle"     >Procedure Performed By </td>
                                   <td class="GridViewLabItemStyle"     >
                                   <asp:TextBox ID="txtProcedure" CssClass="" runat="server"  ClientIDMode="Static"   ></asp:TextBox>
                             
                                   </td>
                               <td class="GridViewLabItemStyle"     ></td>
                               <td class="GridViewLabItemStyle"     ></td>
                               <td class="GridViewLabItemStyle"     ></td>
                               <td class="GridViewLabItemStyle"     ></td>
                               </tr>
                          
                             </table>
                        
  <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>                        
                        
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
                        <asp:TemplateField HeaderText="Tribe">
                            <ItemTemplate>
                                <asp:Label ID="lblTribe" runat="server" Text='<%#Eval("Tribe") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Chief ">
                            <ItemTemplate>
                                <asp:Label ID="lblChief" runat="server" Text='<%#Eval("Chief") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Health">
                            <ItemTemplate>
                                <asp:Label ID="lblHealth" runat="server" Text='<%#Eval("Health") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Symptoms">
                            <ItemTemplate>
                                <asp:Label ID="lblSymptoms" runat="server" Text='<%#Eval("Symptoms") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ANormalPower1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblHeight" runat="server" Text='<%#Eval("Height") %>'></asp:Label>
                                <asp:Label ID="lblWeight" runat="server" Text='<%#Eval("Weight") %>'></asp:Label>
                                <asp:Label ID="lblBMI" runat="server" Text='<%#Eval("BMI") %>'></asp:Label>
                                <asp:Label ID="lblSwallowsSolids" runat="server" Text='<%#Eval("SwallowsSolids") %>'></asp:Label>
                                <asp:Label ID="lblLiquids" runat="server" Text='<%#Eval("Liquids") %>'></asp:Label>
                                <asp:Label ID="lblSaliva" runat="server" Text='<%#Eval("Saliva") %>'></asp:Label>
                                <asp:Label ID="lblOdynophagia" runat="server" Text='<%#Eval("Odynophagia") %>'></asp:Label>
                                <asp:Label ID="lblEmesis" runat="server" Text='<%#Eval("Emesis") %>'></asp:Label>
                                <asp:Label ID="lblHematemesis" runat="server" Text='<%#Eval("Hematemesis") %>'></asp:Label>
                                <asp:Label ID="lblAbdPain" runat="server" Text='<%#Eval("AbdPain") %>'></asp:Label>
                                <asp:Label ID="lblDyspepsia" runat="server" Text='<%#Eval("Dyspepsia") %>'></asp:Label>
                                <asp:Label ID="lblAnemia" runat="server" Text='<%#Eval("Anemia") %>'></asp:Label>
                                <asp:Label ID="lblWeightLoss" runat="server" Text='<%#Eval("WeightLoss") %>'></asp:Label>
                                <asp:Label ID="lblBlack" runat="server" Text='<%#Eval("Black") %>'></asp:Label>
                                <asp:Label ID="lblBloody" runat="server" Text='<%#Eval("Bloody") %>'></asp:Label>
                                <asp:Label ID="lblOther" runat="server" Text='<%#Eval("Other") %>'></asp:Label>
                                <asp:Label ID="lblDuration" runat="server" Text='<%#Eval("Duration") %>'></asp:Label>
                                <asp:Label ID="lblAlcohol1" runat="server" Text='<%#Eval("Alcohol1") %>'></asp:Label>
                                <asp:Label ID="lblSmoking1" runat="server" Text='<%#Eval("Smoking1") %>'></asp:Label>
                                <asp:Label ID="lblNSAIDS1" runat="server" Text='<%#Eval("NSAIDS1") %>'></asp:Label>
                                <asp:Label ID="lblAlcohol2" runat="server" Text='<%#Eval("Alcohol2") %>'></asp:Label>
                                <asp:Label ID="lblSmoking2" runat="server" Text='<%#Eval("Smoking2") %>'></asp:Label>
                                <asp:Label ID="lblNSAIDS2" runat="server" Text='<%#Eval("NSAIDS2") %>'></asp:Label>
                                <asp:Label ID="lblEso" runat="server" Text='<%#Eval("Eso") %>'></asp:Label>
                                <asp:Label ID="lblPersonAge1" runat="server" Text='<%#Eval("PersonAge1") %>'></asp:Label>
                                <asp:Label ID="lblOtherCancer" runat="server" Text='<%#Eval("OtherCancer") %>'></asp:Label>
                                <asp:Label ID="lblPersonAge2" runat="server" Text='<%#Eval("PersonAge2") %>'></asp:Label>
                                <asp:Label ID="lblLastEGDDate" runat="server" Text='<%#Eval("LastEGDDate1") %>'></asp:Label>
                                <asp:Label ID="lblAdditional" runat="server" Text='<%#Eval("Additional") %>'></asp:Label>
                                <asp:Label ID="lblPharnyx" runat="server" Text='<%#Eval("Pharnyx") %>'></asp:Label>
                                <asp:Label ID="lblEsophagus" runat="server" Text='<%#Eval("Esophagus") %>'></asp:Label>
                                <asp:Label ID="lblStomach" runat="server" Text='<%#Eval("Stomach") %>'></asp:Label>
                                <asp:Label ID="lblDuodenum" runat="server" Text='<%#Eval("Duodenum") %>'></asp:Label>
                                <asp:Label ID="lblSedation" runat="server" Text='<%#Eval("Sedation") %>'></asp:Label>
                                <asp:Label ID="lblVersed" runat="server" Text='<%#Eval("Versed") %>'></asp:Label>
                                <asp:Label ID="lblFentanyl" runat="server" Text='<%#Eval("Fentanyl") %>'></asp:Label>
                                <asp:Label ID="lblKetamine" runat="server" Text='<%#Eval("Ketamine") %>'></asp:Label>
                                <asp:Label ID="lblOxygen" runat="server" Text='<%#Eval("Oxygen") %>'></asp:Label>
                                <asp:Label ID="lblOther2" runat="server" Text='<%#Eval("Other2") %>'></asp:Label>
                                <asp:Label ID="lblImages" runat="server" Text='<%#Eval("Images") %>'></asp:Label>
                                <asp:Label ID="lblImpression" runat="server" Text='<%#Eval("Impression") %>'></asp:Label>
                                <asp:Label ID="lblEndoscopy" runat="server" Text='<%#Eval("Endoscopy") %>'></asp:Label>
                                <asp:Label ID="lblRecommendations" runat="server" Text='<%#Eval("Recommendations") %>'></asp:Label>
                                <asp:Label ID="lblFollowUpDate" runat="server" Text='<%#Eval("FollowUpDate1") %>'></asp:Label>
                                <asp:Label ID="lblReportBy" runat="server" Text='<%#Eval("ReportBy") %>'></asp:Label>
                                <asp:Label ID="lblProcedure" runat="server" Text='<%#Eval("Procedure1") %>'></asp:Label>
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

