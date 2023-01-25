<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cardiac_Vital_Examination.aspx.cs" Inherits="Design_CPOE_Cardiac_Vital_Examination" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>
  
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ipad.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CPOE_AddToFavorites.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
  <%--  <script type="text/javascript" src="../../Scripts/CheckUnSaveData.js"></script>--%>
    <script type="text/javascript">
        $(document).ready(function () {
            if ($("#txtHt").val() > 0 && $("#txtWt").val() > 0) {
                convfromcmeters();
            }
        });
        function convfromcmeters() {
            $("#lblBmi").text('');
            var frm = $("#txtHt").val();
            var weight = $("#txtWt").val();
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
                $("#txtBMI").val(0);
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
                    $("#lblBmi").text('Your Bmi Is : ' + Bmi + '');
                    $("#txtBMI").val(Bmi);
                }
            }
            if (Bmi == null)
                $("#txtBMI").val(0);
            //             f.bmi.value = cal_bmi(w, i);
            //             f.bmi.focus();
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function checkForSecond(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 47)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '/');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        function chkVital(id) {
            OffBeforeUnload();
            if ( ($("#txtP").val() === "") && ($("#txtR").val() === "") && ($("#txtT").val() === "") && ($("#txtHt").val() === "") && ($("#txtWt").val() === "") && ($("#txtArmSpan").val() === "") && ($("#txtSittingHeight").val() === "") && ($("#txtPulses").val() === "")) {
                $("#lblMsg").text('Please Enter BP OR Pulse OR Arm Span');
                //$("#txtBp").focus();
                return false;
            }
            //if ($("#txtBp").val() != "") {
            //    var con = bp();
            //    if (bp() == 1)
            //        return false;

        }
        if ($("#txtBMI").val() == null || $("#txtBMI").val() == "" || $("#txtBMI").val() == "0") {
            $("#lblMsg").text('Please Enter Valid HT OR WT');
            $("#txtHt").focus();
            return false;
        }
        id.disabled = true;
        id.value = 'Submitting...';
        if ($("#btnSave").is(':visible'))
            __doPostBack('btnSave');
        else if ($("#btnUpdate").is(':visible'))
            __doPostBack('btnUpdate');
        }
    </script>
    <style type="text/css">
        .style2 {
            font-size: x-small;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
       <cc1:ToolkitScriptManager ID="toolScriptManageer1" runat="server"></cc1:ToolkitScriptManager> 
        <%--<div>&nbsp;&nbsp;&nbsp;<a id="AddToFavorites" onclick="AddPage('cpoe_Vital.aspx','Vital Sign')" href="#">Add To Favorites</a>&nbsp;&nbsp;&nbsp;&nbsp;<span id="Msg" class="ItDoseLblError"></span></div>--%>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Cardiac Vital Examination</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
              <div class="POuter_Box_Inventory">
                            <div class="row">                               
                                <div class="col-md-4">
                                    <label class="pull-left">Examination Date     </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDate" runat="server"></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="caldate" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Examination Time </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-6">
                                    <%--<asp:TextBox ID="txtTime" runat="server" MaxLength="5" ToolTip="Enter Time"
                                        TabIndex="2" />
                                <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtTime" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>

                                      <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                        ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator> 
                                    <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                --%>
                                    
                            <uc2:StartTime ID="StartTime" runat="server" />
                                </div>

                            </div>



                        </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Physical&nbsp;Examination&nbsp;:&nbsp;
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PUOILS L/R
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtPUOILSLR" runat="server" CssClass="requiredField" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="7" ToolTip="Enter PUOILSlr"></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtPUOILSLR" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                                <span class="style2"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Reaction L/R
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtReactionLR" runat="server" CssClass="requiredField" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="16" MaxLength="5"
                                    ToolTip="Enter p"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="fttxtP" runat="server" TargetControlID="txtReactionLR" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                   Temp
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtTemp" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="17" MaxLength="5"
                                    ToolTip="Enter R"></asp:TextBox><span class="style2"></span><span style="color: Red; font-size: 8px;"></span>
                                <cc1:FilteredTextBoxExtender ID="fttxtR" runat="server" TargetControlID="txtTemp" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    HR
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtHR" runat="server" Width="49px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="18" MaxLength="5"
                                    ToolTip="Enter T"></asp:TextBox>
                                <span class="style2"></span><span style="color: Red; font-size: 8px;"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtHR"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Rhythm
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtRhythm" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="19" MaxLength="5"
                                    ToolTip="Enter HT" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbHT" runat="server" TargetControlID="txtRhythm" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    ABP
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtABP" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter WT" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbWt" runat="server" TargetControlID="txtABP" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                   MAP
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtMAP" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Arm Span" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtMAP"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    CVP
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtCVP" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbSitting" runat="server" TargetControlID="txtCVP" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2"></span>
                            </div>
                           
                        </div>
                        <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                    Pulses
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtPulses" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Pulses" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtPulses"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Radial L/R
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtRadialLR" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter SPO2 Percentage" AutoCompleteType="None"></asp:TextBox>&nbsp;
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtRadialLR"
                                ValidChars="0987654321/.">
                            </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                        DP L/R
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtDPLR" runat="server"  Width="50px" TabIndex="21" MaxLength="10" ToolTip="Enter Capilary Blood Glucose" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender18" runat="server" TargetControlID="txtDPLR" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                                &nbsp;
                            </div>
                              <div class="col-md-3">
                                <label class="pull-left">
                                   PT L/R
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                          
                            <div class="col-md-3">
                                <asp:TextBox ID="txtPTLR" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="22" MaxLength="5"
                                ToolTip="Enter Pain Score" AutoCompleteType="None"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtPTLR"
                                ValidChars="0987654321/.">
                            </cc1:FilteredTextBoxExtender>
                            </div>
                              
                        </div>
                        
                           <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                    NBP
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtNBP" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter IBW" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtNBP"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    INT/EXT
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtINTEXT" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter SPO2 Percentage" AutoCompleteType="None"></asp:TextBox>&nbsp;
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtINTEXT"
                                ValidChars="0987654321/.">
                            </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                        RR
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtRR" runat="server"  Width="50px" TabIndex="21" MaxLength="10" ToolTip="Enter Capilary Blood Glucose" AutoCompleteType="None"></asp:TextBox>
                                &nbsp;
                            </div>
                              <div class="col-md-3">
                                <label class="pull-left">
                                    SaO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                          
                            <div class="col-md-3">
                                <asp:TextBox ID="txtSaO2" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="22" MaxLength="5"
                                ToolTip="Enter Pain Score" AutoCompleteType="None"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txtSaO2"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            </div>
                              
                        </div>


                           <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                    FiO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtFiO2" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter IBW" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender12" runat="server" TargetControlID="txtFiO2"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Breath Sound L
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtBreathSoundL" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter SPO2 Percentage" AutoCompleteType="None"></asp:TextBox>&nbsp;
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender13" runat="server" TargetControlID="txtBreathSoundL"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                        Breath Sound R
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtBreathSoundR" runat="server"  Width="50px" TabIndex="21" MaxLength="10" ToolTip="Enter Capilary Blood Glucose" AutoCompleteType="None"></asp:TextBox>
                                &nbsp;
                            </div>
                              <div class="col-md-3">
                                <label class="pull-left">
                                    RBS
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                          
                            <div class="col-md-3">
                                <asp:TextBox ID="txtRBS" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="22" MaxLength="5"
                                ToolTip="Enter Pain Score" AutoCompleteType="None"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender14" runat="server" TargetControlID="txtRBS"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            </div>
                              
                        </div>


                           <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                   IV Ass. weight
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtIVAssessmentweight" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter IBW" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender15" runat="server" TargetControlID="txtIVAssessmentweight"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Drip/Doses
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtDripDoses" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter SPO2 Percentage" AutoCompleteType="None"></asp:TextBox>&nbsp;
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender16" runat="server" TargetControlID="txtDripDoses"
                                ValidChars="0987654321/.">
                            </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3">
                                  <label class="pull-left">
                                      Remark
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <asp:TextBox ID="txtRemark" runat="server" TabIndex="23" MaxLength="200" ToolTip="Enter Remarks" AutoCompleteType="None"></asp:TextBox>
                            </div> 
                        </div>
                        
                         <div class="row Purchaseheader">
                             <div class="col-md-24" >
                                 <b>IABP Support</b><br />
                         </div>
                            </div>
                         <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                      Operation Mode
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlOperationMode" runat="server" >
                                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                                    <asp:ListItem Value="1" >Auto</asp:ListItem>
                                    <asp:ListItem Value="2" >Manual</asp:ListItem>
                                </asp:DropDownList>
                              </div>
                              <div class="col-md-3">
                                <label class="pull-left">
                                      Trigger
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlTrigger" runat="server" >
                                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                                    <asp:ListItem Value="1" >ECG</asp:ListItem>
                                    <asp:ListItem Value="2" >Pressure</asp:ListItem>
                                    <asp:ListItem Value="3" >Pacer V/AV</asp:ListItem>
                                    <asp:ListItem Value="4" >Pacer A</asp:ListItem>
                                </asp:DropDownList>
                              </div>
                             
                              <div class="col-md-3">
                                <label class="pull-left">
                                      Support
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSupport" runat="server" >
                                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                                    <asp:ListItem Value="1" >1:1</asp:ListItem>
                                    <asp:ListItem Value="2" >1:2</asp:ListItem>
                                    <asp:ListItem Value="3" >1:3</asp:ListItem>
                                </asp:DropDownList>
                              </div>
                                     </div>
                    </div>
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right; display: none">BF:</td>
                        <td style="display: none">
                            <asp:TextBox ID="txtBF" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtBF"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align: right; display: none">MUAC:</td>
                        <td style="display: none">
                            <asp:TextBox ID="txtMuac" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">CM</span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtBF"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td style="text-align: right;">FBS:</td>
                        <td>
                            <asp:TextBox ID="txtFBS" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter FBS" AutoCompleteType="None"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtFBS"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            <span class="style2">mmol/L</span>
                        </td>
                        <td style="text-align: right;">TW:</td>
                        <td>
                            <asp:TextBox ID="txtTw" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2"></span></td>
                        <td style="text-align: right;">VF:</td>
                        <td>
                            <asp:TextBox ID="txtVf" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                        <td style="text-align: right;">MUSCLE:</td>
                        <td>
                            <asp:TextBox ID="txtMuscle" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                        <td style="text-align: right;">RM:</td>
                        <td>
                            <asp:TextBox ID="txtRm" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">Kcal</span></td>
                        <td style="text-align: right;">WFA:</td>
                        <td>
                            <asp:TextBox ID="txtWFA" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                    </tr>
                    <tr style="display: none">
                        <td style="text-align: right;">BMIFA:</td>
                        <td>
                            <asp:TextBox ID="txtBMIFA" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: middle; text-align: center" colspan="12">
                            <asp:Label ID="lblBmi" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                            <asp:TextBox ID="txtBMI" runat="server" Style="display: none" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="lblID" Text="" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                        </td>
                    </tr>
                   
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Label ID="lblPID" runat="server"  Visible="false"></asp:Label>
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static" OnClientClick="return chkVital(this)" TabIndex="69" OnClick="btnSave_Click" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="false" ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return chkVital(this)" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" OnClick="btnCancel_Click" />
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
                        <%-- <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientName" runat="server" Text='<%#Eval("Pname") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="PUPLIS L/R">
                            <ItemTemplate>
                                <asp:Label ID="lblPUPLISLR" runat="server" Text='<%#Eval("PUOILSLR", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reaction L/R">
                            <ItemTemplate>
                                <asp:Label ID="lblReactionLR" runat="server" Text='<%#Eval("ReactionLR", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Temp">
                            <ItemTemplate>
                                <asp:Label ID="lblTemp" runat="server" Text='<%#Eval("Temp", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="HR">
                            <ItemTemplate>
                                <asp:Label ID="lblHR" runat="server" Text='<%#Eval("HR", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Rhythm">
                            <ItemTemplate>
                                <asp:Label ID="lblRhythm" runat="server" Text='<%#Eval("Rhythm", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ABP">
                            <ItemTemplate>
                                <asp:Label ID="lblABP" runat="server" Text='<%#Eval("ABP", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MAP" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblMAP" runat="server" Text='<%#Eval("MAP", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="CVP">
                            <ItemTemplate>
                                <asp:Label ID="lblCVP" runat="server" Text='<%#Eval("CVP", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Pulses">
                            <ItemTemplate>
                                <asp:Label ID="lblPulses" runat="server" Text='<%#Eval("Pulses", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Radial L/R">
                            <ItemTemplate>
                                <asp:Label ID="lblRadialLR" runat="server" Text='<%#Eval("RadialLR", "{0:f2}")  %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="DP L/R">
                            <ItemTemplate>
                                <asp:Label ID="lblDPLR" runat="server" Text='<%# Eval("DPLR", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PT L/R" >
                            <ItemTemplate>
                                <asp:Label ID="lblPTLR" runat="server" Text='<%#Eval("PTLR", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="NBP" >
                            <ItemTemplate>
                                <asp:Label ID="lblNBP" runat="server" Text='<%#Eval("NBP", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="INT/EXT" >
                            <ItemTemplate>
                                <asp:Label ID="lblINTEXT" runat="server" Text='<%#Eval("INTEXT", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="RR" >
                            <ItemTemplate>
                                <asp:Label ID="lblRR" runat="server" Text='<%#Eval("RR", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SaO2" >
                            <ItemTemplate>
                                <asp:Label ID="lblSaO2" runat="server" Text='<%#Eval("SaO2", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FiO2" >
                            <ItemTemplate>
                                <asp:Label ID="lblFiO2" runat="server" Text='<%#Eval("FiO2", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Breath Sound L" >
                            <ItemTemplate>
                                <asp:Label ID="lblBreathSoundL" runat="server" Text='<%#Eval("BreathSoundL", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Breath Sound R" >
                            <ItemTemplate>
                                <asp:Label ID="lblBreathSoundR" runat="server" Text='<%#Eval("BreathSoundR", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="RBS" >
                            <ItemTemplate>
                                <asp:Label ID="lblRBS" runat="server" Text='<%#Eval("RBS", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>

                           <asp:TemplateField HeaderText="IV Assessment weight">
                            <ItemTemplate>
                                <asp:Label ID="lblIVAssessmentweight" runat="server" Text='<%#Eval("IVAssessmentweight", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Drip/Doses">
                            <ItemTemplate>
                                <asp:Label ID="lblDripDoses" runat="server" Text='<%#Eval("DripDoses", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>
                          <%-- <asp:TemplateField HeaderText="RBS" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblRBS" runat="server" Text='<%#Eval("RBS", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>--%>
                          <asp:TemplateField HeaderText="Remark">
                            <ItemTemplate>
                                <asp:Label ID="lblRemark" runat="server" Text='<%#Eval("Remark") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Operation Mode"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblOperationMode" runat="server" Text='<%#Eval("OperationMode") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100"  />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Trigger"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblTrigger1" runat="server" Text='<%#Eval("Trigger1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Support" Visible="false" >
                            <ItemTemplate>
                                <asp:Label ID="lblSupport" runat="server" Text='<%#Eval("Support") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EntryBy1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Util.GetDateTime(Eval("Date")).ToString("dd-MMM-yyyy") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Util.GetDateTime(Eval("Time")).ToString("hh:mm tt") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblUserID" Text='<%#Eval("EntryBy") %>' runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblID" Text='<%#Eval("Id") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </form>
</body>
</html>
