<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cardiac_BloodGasChart.aspx.cs" Inherits="Design_ip_Cardiac_BloodGasChart" %>



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
                <b>Blood Gas Chart</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
              <div class="content">
                            <div class="row">
                                <div class="col-sm-2">

                                    
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left"> Date     </label>
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
                    Blood&nbsp;Gas&nbsp;Chart&nbsp;
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    pH
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtpH" runat="server"  Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="7" ToolTip="Enter pH"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtpH" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                                <span class="style2"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PCO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtPCO2" runat="server"  Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="16" MaxLength="5"
                                    ToolTip="Enter PCO2"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="fttxtP" runat="server" TargetControlID="txtPCO2" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                   PO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtPO2" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="17" MaxLength="5"
                                    ToolTip="Enter PO2"></asp:TextBox><span class="style2"></span><span style="color: Red; font-size: 8px;"></span>
                                <cc1:FilteredTextBoxExtender ID="fttxtR" runat="server" TargetControlID="txtPO2" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    BEecf
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtBEecf" runat="server" Width="49px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="18" MaxLength="5"
                                    ToolTip="Enter BEecf"></asp:TextBox>
                                <span class="style2"></span><span style="color: Red; font-size: 8px;"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtBEecf"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    HCO3
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtHCO3" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="19" MaxLength="5"
                                    ToolTip="Enter HCO3" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbHT" runat="server" TargetControlID="txtHCO3" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    TCO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtTCO2" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter TCO2" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbWt" runat="server" TargetControlID="txtTCO2" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                   sO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtsO2" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter sO2" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtsO2"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Na
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtNa" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Na" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbSitting" runat="server" TargetControlID="txtNa" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2"></span>
                            </div>
                           
                        </div>
                        <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                    K
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtK" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter K" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtK"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    iCa
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtiCa" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter iCa" AutoCompleteType="None"></asp:TextBox>&nbsp;
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtiCa"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                        Glu (mg/dl)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtGlumgdl" runat="server"  Width="50px" TabIndex="21" MaxLength="10" ToolTip="Enter Glu mg/dl" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txtGlumgdl"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                                &nbsp;
                            </div>
                              <div class="col-md-3">
                                <label class="pull-left">
                                   Hct %
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                          
                            <div class="col-md-3">
                                <asp:TextBox ID="txtHct" runat="server"  Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="22" MaxLength="5"
                                ToolTip="Enter Hct" AutoCompleteType="None"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtHct"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            </div>
                              
                        </div>
                        
                           <div class="row">
                             <div class="col-md-3">
                                <label class="pull-left">
                                    Hb g/dl
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtHbgdl" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Hb g/dl" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtHbgdl"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                              
                        </div>
                    </div>
                </div>
                
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
                        <asp:TemplateField HeaderText="pH">
                            <ItemTemplate>
                                <asp:Label ID="lblpH" runat="server" Text='<%#Eval("pH", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PCO2">
                            <ItemTemplate>
                                <asp:Label ID="lblPCO2" runat="server" Text='<%#Eval("PCO2", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PO2">
                            <ItemTemplate>
                                <asp:Label ID="lblPO2" runat="server" Text='<%#Eval("PO2", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BEecf">
                            <ItemTemplate>
                                <asp:Label ID="lblBEecf" runat="server" Text='<%#Eval("BEecf", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="HCO3">
                            <ItemTemplate>
                                <asp:Label ID="lblHCO3" runat="server" Text='<%#Eval("HCO3", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="TCO2">
                            <ItemTemplate>
                                <asp:Label ID="lblTCO2" runat="server" Text='<%#Eval("TCO2", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="sO2" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblsO2" runat="server" Text='<%#Eval("sO2", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Na">
                            <ItemTemplate>
                                <asp:Label ID="lblNa" runat="server" Text='<%#Eval("Na", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="K">
                            <ItemTemplate>
                                <asp:Label ID="lblK" runat="server" Text='<%#Eval("K", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="iCa">
                            <ItemTemplate>
                                <asp:Label ID="lbliCa" runat="server" Text='<%# Util.GetDecimal( Eval("iCa")) == 0 ?  "" : Eval("iCa", "{0:f2}")  %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Glu mg/dl">
                            <ItemTemplate>
                                <asp:Label ID="lblGlumgdl" runat="server" Text='<%# Util.GetDecimal( Eval("Glumgdl"))==0 ? "" : Eval("Glumgdl", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Hct %" >
                            <ItemTemplate>
                                <asp:Label ID="lblHct" runat="server" Text='<%#Eval("Hct", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Hb g/dl" >
                            <ItemTemplate>
                                <asp:Label ID="lblHbgdl" runat="server" Text='<%#Eval("Hbgdl", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EntryBy1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Entry Date ">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Util.GetDateTime(Eval("Date")).ToString("dd-MMM-yyyy") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
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
