<%@ Page Language="C#" AutoEventWireup="true" CodeFile="cpoe_Vital.aspx.cs" Inherits="Design_CPOE_cpoe_Vital" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ipad.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CPOE_AddToFavorites.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
    <%--  <script type="text/javascript" src="../../Scripts/CheckUnSaveData.js"></script>--%>
    <script type="text/javascript">
        $(document).ready(function () {
            if ($("#txtHt").val() > 0 && $("#txtWt").val() > 0) {
                convfromcmeters();
            }
            $bindMandatory(function(){})
        });
        var $bindMandatory = function (callback) {
            serverCall('cpoe_Vital.aspx/bindMandtoryVitial', { deptid: '<%=(Request.QueryString["DeptID"]) %>' }, function (response) {
                responseData = JSON.parse(response);
                if (responseData.length > 0)
                {
                    for(var i=0;i<responseData.length;i++) {
                        $(responseData[i].VitialSiginTextID).attr('errorMessage', responseData[i].ErrorMessage).addClass(responseData[i].isRequired == '1' ? 'requiredField' : '');
                    };
                }
            });
        }


        function convfromcmeters() {
            $("#lblBmi").text('');
            $("#lblBSA").text('');
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
                    $("#txtBSA").val(0);
                 
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
                    $("#lblBmi").text('Your BMI Is : ' + Bmi + '');
                    $("#txtBMI").val(Bmi);
                }

                var Bsa = cal_bsa(i, w);

                if (Bsa != "") {

                    $("#lblBSA").text('Your BSA Is : ' + precise_round(Number(Bsa), 3) + '');
                    $("#txtBSA").val(precise_round(Number(Bsa), 3));
                    
                }

            }
            if (Bmi == null) {
                $("#txtBMI").val(0);
                $("#txtBSA").val(0);
            }
            //             f.bmi.value = cal_bmi(w, i);
            //             f.bmi.focus();
        }

         
         
        function cal_bsa(h, w) {
            debugger;
            var hei = (h / 0.39370);
            var Wei = (w / 2.20462)
            var bsa = Math.sqrt(((precise_round(Number(hei), 3) * precise_round(Number(Wei), 3)) / 3600));
            return bsa;
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
            //OffBeforeUnload();
            //if (($("#txtBp").val() === "") && ($("#txtP").val() === "") && ($("#txtR").val() === "") && ($("#txtT").val() === "") && ($("#txtHt").val() === "") && ($("#txtWt").val() === "") && ($("#txtArmSpan").val() === "") && ($("#txtSittingHeight").val() === "") && ($("#txtIBW").val() === "")) {
            //    $("#lblMsg").text('Please Enter BP OR Pulse OR Arm Span');
            //    $("#txtBp").focus();
            //    return false;
            //}
            //if ($("#txtBp").val() != "") {
            //    var con = bp();
            //    if (bp() == 1)
            //        return false;

            //}
            //if ($("#txtBMI").val() == null || $("#txtBMI").val() == "" || $("#txtBMI").val() == "0") {
            //    $("#lblMsg").text('Please Enter Valid HT OR WT');
            //    $("#txtHt").focus();
            //    return false;
            //}

            var validateStatus = true;
            $('#Pbody_box_inventory .requiredField').each(function (index, elem) {
                if ($.trim($(elem).val()) == '' || $.trim($(elem).val()) == '0') {
                    validateStatus = false;
                    modelAlert(this.attributes['errorMessage'].value, function () {

                    });
                    return false;
                }
            });
            if (!validateStatus)
                return false;
            id.disabled = true;
            id.value = 'Submitting...';
            if ($("#btnSave").is(':visible'))
                __doPostBack('btnSave');
            else if ($("#btnUpdate").is(':visible'))
                __doPostBack('btnUpdate');
        }
        function bp() {
            var bp = $('#<%=txtBp.ClientID %>').val();
            var con = 0;
            var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
            if ($('#<%=txtBp.ClientID %>').val() != "") {
                if (!bpexp.test(bp)) {
                    alert('Please Enter Valid BP ');
                    $('#<%=txtBp.ClientID %>').focus();
                    con = 1;
                }
            }
            return con;
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
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <%--<div>&nbsp;&nbsp;&nbsp;<a id="AddToFavorites" onclick="AddPage('cpoe_Vital.aspx','Vital Sign')" href="#">Add To Favorites</a>&nbsp;&nbsp;&nbsp;&nbsp;<span id="Msg" class="ItDoseLblError"></span></div>--%>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Vital Examination</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
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
                                    BP
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtBp" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onchange="return bp()" TabIndex="15" MaxLength="7" ToolTip="Enter BP"></asp:TextBox>
                                <span class="style2">mm/Hg</span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pulse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtP" autocomplete="off" runat="server"  Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="16" MaxLength="5"
                                    ToolTip="Enter p"></asp:TextBox>
                                <span class="style2">bpm</span>
                                <cc1:FilteredTextBoxExtender ID="fttxtP" runat="server" TargetControlID="txtP" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Resp
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtR" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="17" MaxLength="5"
                                    ToolTip="Enter R"></asp:TextBox><span class="style2">/min</span><span style="color: Red; font-size: 8px;"></span>
                                <cc1:FilteredTextBoxExtender ID="fttxtR" runat="server" TargetControlID="txtR" ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Temp.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtT" autocomplete="off" runat="server" Width="49px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="18" MaxLength="5"
                                    ToolTip="Enter T"></asp:TextBox>
                                <%--      <span class="style2">&deg;C</span><span style="color: Red; font-size: 8px;"></span>--%>
                                <asp:DropDownList ID="ddltemperature" runat="server" Width="56px">
                                    <asp:ListItem Value="C">&deg;C</asp:ListItem>
                                    <asp:ListItem Value="F">&deg;F</asp:ListItem>
                                </asp:DropDownList>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtT"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    HT
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtHt" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="19" MaxLength="5"
                                    ToolTip="Enter HT" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbHT" runat="server" TargetControlID="txtHt" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                               <%-- <span class="style2">CM</span>--%>
                                  <asp:DropDownList ID="ddlHeightType" runat="server" Width="56px">
                                    <asp:ListItem Value="CM">CM</asp:ListItem>
                                    <asp:ListItem Value="Inch">Inch</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    WT
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtWt" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter WT" Onkeyup="convfromcmeters();" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbWt" runat="server" TargetControlID="txtWt" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                              <%--  <span class="style2">Kg</span>--%>
                                 <asp:DropDownList ID="ddlWeightType" runat="server" Width="56px">
                                    <asp:ListItem Value="KG">KG</asp:ListItem>
                                    <asp:ListItem Value="POUND">POUND</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Arm Span
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtArmSpan" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Arm Span" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2">CM</span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtArmSpan"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Sitting Height
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtSittingHeight" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbSitting" runat="server" TargetControlID="txtSittingHeight" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                                <span class="style2">CM</span>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    IBW
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtIBW" autocomplete="off" runat="server" Width="50px" ClientIDMode="Static"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter IBW" AutoCompleteType="None"></asp:TextBox>
                                <span class="style2">Kg</span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtIBW"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    SPO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtSPO2" autocomplete="off" runat="server" Width="50px"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                    ToolTip="Enter SPO2 Percentage" AutoCompleteType="None"></asp:TextBox>&nbsp;%
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtSPO2"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Blood Glucose
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtCBG" autocomplete="off" runat="server" Width="50px" TabIndex="21" MaxLength="10" ToolTip="Enter Capilary Blood Glucose" AutoCompleteType="None"></asp:TextBox>
                                &nbsp;mmol/L
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pain Score
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-3">
                                <asp:TextBox ID="txtPainScore" autocomplete="off" runat="server" Width="50px"
                                    onkeypress="return checkForSecondDecimal(this,event)" TabIndex="22" MaxLength="5"
                                    ToolTip="Enter Pain Score" AutoCompleteType="None"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtPainScore"
                                    ValidChars="0987654321.">
                                </cc1:FilteredTextBoxExtender>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">
                                    GCS
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                              <div class="col-md-6">
                                <asp:TextBox ID="txtGCS" autocomplete="off" runat="server"  TabIndex="23"  ToolTip="Enter GCS" AutoCompleteType="None"></asp:TextBox>
                            </div>
                              <div class="col-md-3">
                                  </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                    CIWA
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                              <div class="col-md-3">
                                <asp:TextBox ID="txtCIWA" autocomplete="off" runat="server" Width="50px" TabIndex="24"  ToolTip="Enter CIWA" AutoCompleteType="None"></asp:TextBox>
                            </div>
                            </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Remark
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-20">
                                <asp:TextBox ID="txtRemark" autocomplete="off" runat="server" Width="97%" TabIndex="25" MaxLength="200" ToolTip="Enter Remarks" AutoCompleteType="None"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right; display: none">BF:</td>
                        <td style="display: none">
                            <asp:TextBox ID="txtBF" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtBF"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align: right; display: none">MUAC:</td>
                        <td style="display: none">
                            <asp:TextBox ID="txtMuac" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
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
                            <asp:TextBox ID="txtFBS" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter FBS" AutoCompleteType="None"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtFBS"
                                ValidChars="0987654321.">
                            </cc1:FilteredTextBoxExtender>
                            <span class="style2">mmol/L</span>
                        </td>
                        <td style="text-align: right;">TW:</td>
                        <td>
                            <asp:TextBox ID="txtTw" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">Kg</span></td>
                        <td style="text-align: right;">VF:</td>
                        <td>
                            <asp:TextBox ID="txtVf" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                        <td style="text-align: right;">MUSCLE:</td>
                        <td>
                            <asp:TextBox ID="txtMuscle" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                        <td style="text-align: right;">RM:</td>
                        <td>
                            <asp:TextBox ID="txtRm" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter Sitting Height" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">Kcal</span></td>
                        <td style="text-align: right;">WFA:</td>
                        <td>
                            <asp:TextBox ID="txtWFA" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                    </tr>
                    <tr style="display: none">
                        <td style="text-align: right;">BMIFA:</td>
                        <td>
                            <asp:TextBox ID="txtBMIFA" autocomplete="off" runat="server" Style="margin-left: 11px" Width="50px"
                                onkeypress="return checkForSecondDecimal(this,event)" TabIndex="20" MaxLength="5"
                                ToolTip="Enter BF" AutoCompleteType="None"></asp:TextBox>
                            <span class="style2">%</span></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: middle; text-align: center" colspan="6">
                            <asp:Label ID="lblBmi" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                            <asp:TextBox ID="txtBMI" runat="server" Style="display: none" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="lblID" Text="" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                        </td>
                        <td style="vertical-align: middle; text-align: center" colspan="6">
                            <asp:Label ID="lblBSA" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                            <asp:TextBox ID="txtBSA" runat="server" Style="display: none" ClientIDMode="Static"></asp:TextBox>
                           
                        </td>
                    </tr>

                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">

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
                        <asp:TemplateField HeaderText="BP">
                            <ItemTemplate>
                                <asp:Label ID="lblBP" runat="server" Text='<%#Eval("BP", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Pulse">
                            <ItemTemplate>
                                <asp:Label ID="lblP" runat="server" Text='<%#Eval("P", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Resp.">
                            <ItemTemplate>
                                <asp:Label ID="lblR" runat="server" Text='<%#Eval("R", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Temp(C/F)">
                            <ItemTemplate>
                                <asp:Label ID="lblTemp" runat="server" Text='<%#Eval("TTType", "{0:f2}") %>'></asp:Label>
                                <asp:Label ID="lblTType" runat="server" Text='<%#Eval("TType") %>' Visible="false"></asp:Label>
                                 <asp:Label ID="lblT" runat="server" Text='<%#Eval("T", "{0:f2}") %>'  Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Height(CM/Inch)">
                            <ItemTemplate>
                                <asp:Label ID="lblHeight" runat="server" Text='<%#Eval("HHTType", "{0:f2}") %>'></asp:Label>
                                 <asp:Label ID="lblHTType" runat="server" Text='<%#Eval("HTType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblHT" runat="server" Text='<%#Eval("HT", "{0:f2}") %>'  Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Weight(KG/Pound)">
                            <ItemTemplate>
                                <asp:Label ID="lblWeight" runat="server" Text='<%#Eval("WWTType", "{0:f2}") %>'></asp:Label>
                                <asp:Label ID="lblWTType" runat="server" Text='<%#Eval("WTType") %>' Visible="false"></asp:Label>
                                 <asp:Label ID="lblWT" runat="server" Text='<%#Eval("WT", "{0:f2}") %>'  Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BMI" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblBMI" runat="server" Text='<%#Eval("BMI", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="BSA" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblBsa" runat="server" Text='<%#Eval("BSA", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Arm Span">
                            <ItemTemplate>
                                <asp:Label ID="lblArmSpan" runat="server" Text='<%#Eval("ArmSpan", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SHeight">
                            <ItemTemplate>
                                <asp:Label ID="lblSHeight" runat="server" Text='<%#Eval("SHight", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="IBW">
                            <ItemTemplate>
                                <asp:Label ID="lblIBWKg" runat="server" Text='<%# Util.GetDecimal( Eval("IBWKg")) == 0 ?  "" : Eval("IBWKg", "{0:f2}")  %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SPO2">
                            <ItemTemplate>
                                <asp:Label ID="lblSPO2" runat="server" Text='<%# Util.GetDecimal( Eval("SPO2"))==0 ? "" : Eval("SPO2", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BF" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblBF" runat="server" Text='<%#Eval("BF", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MUAC" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblMUAC" runat="server" Text='<%#Eval("MUAC", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FBS" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblFBS" runat="server" Text='<%#Eval("FBS", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="TW" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lbltw" runat="server" Text='<%#Eval("tw", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="VF" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblvf" runat="server" Text='<%#Eval("vf", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MUSCLE" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblmuscle" runat="server" Text='<%#Eval("muscle", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="RM" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblrm" runat="server" Text='<%#Eval("rm", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="WFA" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblWFA" runat="server" Text='<%#Eval("WFA", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BMIFA" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblBMIFA" runat="server" Text='<%#Eval("BMIFA", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Blood Glucose">
                            <ItemTemplate>
                                <asp:Label ID="lblCBG" runat="server" Text='<%#Eval("CBG", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PainScore">
                            <ItemTemplate>
                                <asp:Label ID="lblPainScore" runat="server" Text='<%#Eval("PainScore", "{0:f2}") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="GCS">
                            <ItemTemplate>
                                <asp:Label ID="lblGCS" runat="server" Text='<%#Eval("GCS") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="CIWA">
                            <ItemTemplate>
                                <asp:Label ID="lblCIWA" runat="server" Text='<%#Eval("CIWA") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remark">
                            <ItemTemplate>
                                <asp:Label ID="lblRemarks" runat="server" Text='<%#Eval("Remarks") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("Username") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry Date Time">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Util.GetDateTime(Eval("EntryDate")).ToString("dd-MMM-yyyy HH:mm tt") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblUserID" Text='<%#Eval("EntryBy") %>' runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
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
