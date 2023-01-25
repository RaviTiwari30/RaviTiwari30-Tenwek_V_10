<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ICUAdmission.aspx.cs" Inherits="Design_CPOE_ICUAdmission" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>



<%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
<%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script lang="javascript" type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#lblTotal").text($("#txtTotalScore").val());
            $("#txtChest").hide();
            $("#txtECG").hide();
            $("#TxtPanic").hide();
            $("#txtAdmission").hide();
            bind();
            Admission();
            var score = 0;
            $('.rb1 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == "<70") {
                    value = 3;
                }
                else if (selectedtext == "70-80" || selectedtext == ">200") {
                    value = 2;
                }
                else if (selectedtext == "80-100" || selectedtext == "161-199") {
                    value = 1;
                }
                else if (selectedtext == "100-160") {
                    value = 0;
                }
                $("#txtSystolic").val(value);
                $("#lblSystolic").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb2 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == ">130") {
                    value = 3;
                }
                else if (selectedtext == "<40" || selectedtext == "110-130") {
                    value = 2;
                }
                else if (selectedtext == "40-50" || selectedtext == "100-110") {
                    value = 1;
                }
                else if (selectedtext == "50-100") {
                    value = 0;
                }
                $("#txtHR").val(value);
                $("#lblHR").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb3 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == ">40") {
                    value = 3;
                }
                else if (selectedtext == "<35" || selectedtext == "38.6-40") {
                    value = 2;
                }
                else if (selectedtext == "35.1-36" || selectedtext == "38.1-38.5") {
                    value = 1;
                }
                else if (selectedtext == "36.1-38") {
                    value = 0;
                }
                $("#txtTemp").val(value);
                $("#lblTemp").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb4 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == ">30") {
                    value = 3;
                }
                else if (selectedtext == "<9" || selectedtext == "21-29") {
                    value = 2;
                }
                else if (selectedtext == "15-20") {
                    value = 1;
                }
                else if (selectedtext == "9-14") {
                    value = 0;
                }
                $("#txtRR").val(value);
                $("#lblRR").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb5 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == "<90%") {
                    value = 3;
                }
                else if (selectedtext == "91-93%") {
                    value = 2;
                }
                else if (selectedtext == "94-100%") {
                    value = 0;
                }
                $("#txtSPO").val(value);
                $("#lblSPO").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb6 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == "None or <10 ml/2hrs") {
                    value = 3;
                }
                else if (selectedtext == "<30 ml/2hrs") {
                    value = 2;
                }
                else if (selectedtext == "<50 ml/2hrs") {
                    value = 1;
                }
                else if (selectedtext == ">50 ml/2hrs") {
                    value = 0;
                }
                $("#txtUrine").val(value);
                $("#lblUrine").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb7 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == "Unresponsive") {
                    value = 3;
                }
                else if (selectedtext == "Responds to Pain") {
                    value = 2;
                }
                else if (selectedtext == "Drowsy/ responds voice" || selectedtext == "New Agitation/Confusion") {
                    value = 1;
                }
                else if (selectedtext == "Alert") {
                    value = 0;
                }
                $("#txtLevel").val(value);
                $("#lblLevel").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());

                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb8 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == "3 Points") {
                    $("#txtChest").hide();
                    value = 3;
                }
                else if (selectedtext == "Specify") {
                    $("#txtChest").show();
                    value = 2;
                }
                $("#txtChestScore").val(value);
                $("#lblChest").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb9 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == "3 Points") {
                    $("#TxtPanic").hide();
                    value = 3;
                }
                else if (selectedtext == "Specify") {
                    $("#TxtPanic").show();
                    value = 2;
                }
                $("#txtPanicScore").val(value);
                $("#lblPanic").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
            $('.rb10 input').click(function () {
                var value = 0;
                var selectedtext = $(this).next().text();
                if (selectedtext == "3 Points") {
                    $("#txtECG").hide();

                    value = 3;
                }
                else if (selectedtext == "Specify") {
                    $("#txtECG").show();
                    value = 2;
                }
                $("#txtECGScore").val(value);
                $("#lblECG").val(selectedtext);
                score = parseInt($("#txtECGScore").val()) + parseInt($("#txtPanicScore").val()) + parseInt($("#txtChestScore").val()) + parseInt($("#txtLevel").val()) + parseInt($("#txtUrine").val()) + parseInt($("#txtSPO").val()) + parseInt($("#txtRR").val()) + parseInt($("#txtTemp").val()) + parseInt($("#txtHR").val()) + parseInt($("#txtSystolic").val());
                $("#lblTotal").text(score);
                $("#txtTotalScore").val(score);
            });
        });

        function bind() {
            var Systolic = 0;
            if ($("#lblSystolic").val() == "<70") {
                Systolic = 3;
            }
            else if ($("#lblSystolic").val() == "70-80" || $("#lblSystolic").val() == ">200") {
                Systolic = 2;
            }
            else if ($("#lblSystolic").val() == "80-100" || $("#lblSystolic").val() == "161-199") {
                Systolic = 1;
            }
            else if ($("#lblSystolic").val() == "100-160") {
                Systolic = 0;
            }
            $("#txtSystolic").val(Systolic);

            var HR = 0;
            if ($("#lblHR").val() == ">130") {
                HR = 3;
            }
            else if ($("#lblHR").val() == "<40" || $("#lblHR").val() == "110-130") {
                HR = 2;
            }
            else if ($("#lblHR").val() == "40-50" || $("#lblHR").val() == "100-110") {
                HR = 1;
            }
            else if ($("#lblHR").val() == "50-100") {
                HR = 0;
            }
            $("#txtHR").val(HR);
            var temp = 0;
            if ($("#lblTemp").val() == ">40") {
                temp = 3;
            }
            else if ($("#lblTemp").val() == "<35" || $("#lblTemp").val() == "38.6-40") {
                temp = 2;
            }
            else if ($("#lblTemp").val() == "35.1-36" || $("#lblTemp").val() == "38.1-38.5") {
                temp = 1;
            }
            else if ($("#lblTemp").val() == "36.1-38") {
                temp = 0;
            }
            $("#txtTemp").val(temp);


            var RR = 0;
            if ($("#lblRR").val() == ">30") {
                RR = 3;
            }
            else if ($("#lblRR").val() == "<9" || $("#lblRR").val() == "21-29") {
                RR = 2;
            }
            else if ($("#lblRR").val() == "15-20") {
                RR = 1;
            }
            else if ($("#lblRR").val() == "9-14") {
                RR = 0;
            }
            $("#txtRR").val(RR);

            var SPO = 0;
            if ($("#lblSPO").val() == "<90%") {
                SPO = 3;
            }
            else if ($("#lblSPO").val() == "91-93%") {
                SPO = 2;
            }
            else if ($("#lblSPO").val() == "94-100%") {
                SPO = 0;
            }

            $("#txtSPO").val(SPO);

            var Urine = 0;
            if ($("#lblUrine").val() == "None or <10 ml/2hrs") {
                Urine = 3;
            }
            else if ($("#lblUrine").val() == "<30 ml/2hrs") {
                Urine = 2;
            }
            else if ($("#lblUrine").val() == "<50 ml/2hrs") {
                Urine = 1;
            }
            else if ($("#lblUrine").val() == ">50 ml/2hrs") {
                Urine = 0;
            }
            $("#txtUrine").val(Urine);
            var level = 0;

            if ($("#lblLevel").val() == "Unresponsive") {
                level = 3;
            }
            else if ($("#lblLevel").val() == "Responds to Pain") {
                level = 2;
            }
            else if ($("#lblLevel").val() == "New Agitation/Confusion" || $("#lblLevel").val() == "Drowsy/ responds voice") {
                level = 1;
            }
            else if ($("#lblLevel").val() == "Alert") {
                level = 0;
            }

            $("#txtLevel").val(level);

            var chest = 0;
            if ($("#lblChest").val() == "3 Points") {
                $("#txtChest").hide();
                chest = 3;
            }
            else if ($("#lblChest").val() == "Specify") {
                $("#txtChest").show();
                chest = 2;
            }
            $("#txtChestScore").val(chest);

            var Panic = 0;
            if ($("#lblPanic").val() == "3 Points") {
                $("#TxtPanic").hide();
                Panic = 3;
            }
            else if ($("#lblPanic").val() == "Specify") {
                $("#TxtPanic").show();
                Panic = 2;
            }
            $("#txtPanicScore").val(Panic);

            var ECG = 0;
            if ($("#lblECG").val() == "3 Points") {
                $("#txtECG").hide();
                ECG = 3;
            }
            else if ($("#lblECG").val() == "Specify") {
                $("#txtECG").show();
                ECG = 2;
            }
            $("#txtECGScore").val(ECG);
        }
        function Admission() {
            var rblval = $('#rdoAdmission input:checked').val();
            if (rblval == "4" || rblval == "5") {
                $("#txtAdmission").show();
            }
            else {
                $("#txtAdmission").hide();
            }
        }
        function validatecontrol(btn) {
            if ($("#ddlCriteria").val() == "Select") {
                $("#lblMsg").text('');
                alert('Please Select Admission Criteria');
                return false;
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
            </cc1:ToolkitScriptManager>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <strong>ICU Admission Criteria</strong><b><br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b>&nbsp;<br />
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    ICU Admission Criteria
                </div>
                <table style="width: 100%;
    font-family: Verdana, Arial, sans-serif;
    font-size: 13px;
">
                    <tr>
                        <td style="width: 17%">Hospital Admission Date</td>
                        <td style="width: 35%">
                            <asp:TextBox ID="txtAdmissiondate" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputText"
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtAdmissiondate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 14%">ICU Admission Date</td>
                        <td style="width: 35%">
                            <asp:TextBox ID="txtICUAdmission" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputText"
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtICUAdmission" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 17%">Admission From </td>
                        <td colspan="2" style="text-align: center">
                            <asp:RadioButtonList ID="rdoAdmission" runat="server" RepeatDirection="Horizontal"  onclick="Admission();">
                                <asp:ListItem Text="None" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="ER" Value="1"></asp:ListItem>
                                <asp:ListItem Text="OR" Value="2"></asp:ListItem>
                                <asp:ListItem Text="OPD" Value="3"></asp:ListItem>
                                <asp:ListItem Text="Ward" Value="4"></asp:ListItem>
                                <asp:ListItem Text="Outside Facility" Value="5"></asp:ListItem>
                            </asp:RadioButtonList></td>
                        <td style="width: 30%">
                            <asp:TextBox ID="txtAdmission" runat="server" Width="250px" TabIndex="33" MaxLength="50"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 17%"><b>Admission Criteria</b></td>
                        <td style="width: 30%"></td>
                        <td style="width: 14%">&nbsp;</td>
                        <td style="width: 30%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2">Patient condition must fall under one of the following categories :</td>
                        <td colspan="2">
                            <asp:DropDownList ID="ddlCriteria" runat="server" Width="282px">
                                <asp:ListItem Text="Select"></asp:ListItem>
                                <asp:ListItem Text="Respiratory Disease"></asp:ListItem>
                                <asp:ListItem Text="Neurlological/Neuromuscular disease"></asp:ListItem>
                                <asp:ListItem Text="Shock"></asp:ListItem>
                                <asp:ListItem Text="Cardiovascular disease"></asp:ListItem>
                                <asp:ListItem Text="Immunological disorder"></asp:ListItem>
                                <asp:ListItem Text="Nutritional/Gastrointestinal disorders"></asp:ListItem>
                                <asp:ListItem Text="Endrocrine Metabolic disorders"></asp:ListItem>
                                <asp:ListItem Text="Oncological and Hematological disorders"></asp:ListItem>
                                <asp:ListItem Text="OB/GYN disease"></asp:ListItem>
                                <asp:ListItem Text="Trauma"></asp:ListItem>
                                <asp:ListItem Text="Overdose and poisoning"></asp:ListItem>
                                <asp:ListItem Text="Renal disorder"></asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                </table>
                Any patient with total score of 3 or more is eligible for admission based on the following scale
                <table style="width: 100%;    font-family: Verdana, Arial, sans-serif;
    font-size: 13px;    " border="1">
                    <tr>
                        <th style="width: 30%">Score</th>
                        <th style="width: 10%">3</th>
                        <th style="width: 15%">2</th>
                        <th style="width: 10%">1</th>
                        <th style="width: 10%">0</th>
                        <th style="width: 10%">1</th>
                        <th style="width: 10%">2</th>
                        <th style="width: 10%">3</th>
                    </tr>
                    <tr>
                        <td style="width: 30%">Systotic BP</td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="rdbSystolic3" CssClass="rb1" GroupName="Systotic" runat="server" Text="<70" /></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="rdbSystolic2" CssClass="rb1" GroupName="Systotic" runat="server" Text="70-80" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="rdbSystolic1" CssClass="rb1" GroupName="Systotic" runat="server" Text="80-100" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="rdbSystolic0" CssClass="rb1" GroupName="Systotic" runat="server" Text="100-160" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="rdbSystolic11" CssClass="rb1" GroupName="Systotic" runat="server" Text="161-199" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="rdbSystolic22" CssClass="rb1" GroupName="Systotic" runat="server" Text=">200" /></td>
                        <td style="width: 10%">

                            <asp:TextBox ID="txtSystolic" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblSystolic" runat="server" Text=" " Style="display: none"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">HR</td>
                        <td style="width: 10%"></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbHR2" CssClass="rb2" GroupName="HR" runat="server" Text="<40" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbHR1" CssClass="rb2" GroupName="HR" runat="server" Text="40-50" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbHR0" CssClass="rb2" GroupName="HR" runat="server" Text="50-100" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbHR11" CssClass="rb2" GroupName="HR" runat="server" Text="100-110" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbHR22" CssClass="rb2" GroupName="HR" runat="server" Text="110-130" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbHR33" CssClass="rb2" GroupName="HR" runat="server" Text=">130" />
                            <asp:TextBox ID="txtHR" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblHR" runat="server" Text=" " Style="display: none"></asp:TextBox>

                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">Temperature(&#176;C)</td>
                        <td style="width: 10%"></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbTemp2" CssClass="rb3" GroupName="Temp" runat="server" Text="<35" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbTemp1" CssClass="rb3" GroupName="Temp" runat="server" Text="35.1-36" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbTemp0" CssClass="rb3" GroupName="Temp" runat="server" Text="36.1-38" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbTemp11" CssClass="rb3" GroupName="Temp" runat="server" Text="38.1-38.5" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbTemp22" CssClass="rb3" GroupName="Temp" runat="server" Text="38.6-40" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbTemp33" CssClass="rb3" GroupName="Temp" runat="server" Text=">40" />
                            <asp:TextBox ID="txtTemp" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblTemp" runat="server" Text=" " Style="display: none"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">RR</td>
                        <td style="width: 10%"></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbRR2" CssClass="rb4" GroupName="RR" runat="server" Text="<9" /></td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbRR0" CssClass="rb4" GroupName="RR" runat="server" Text="9-14" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbRR11" CssClass="rb4" GroupName="RR" runat="server" Text="15-20" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbRR22" CssClass="rb4" GroupName="RR" runat="server" Text="21-29" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbRR33" CssClass="rb4" GroupName="RR" runat="server" Text=">30" />
                            <asp:TextBox ID="txtRR" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblRR" runat="server" Text=" " Style="display: none"></asp:TextBox>

                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">SPO2 with appropriate O2Therapy</td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbSPO3" CssClass="rb5" GroupName="SPO" runat="server" Text="<90%" />
                        </td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbSPO2" CssClass="rb5" GroupName="SPO" runat="server" Text="91-93%" /></td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbSPO0" CssClass="rb5" GroupName="SPO" runat="server" Text="94-100%" /></td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%">
                            <asp:TextBox ID="txtSPO" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblSPO" runat="server" Text=" " Style="display: none"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">Urine output</td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbUrine3" CssClass="rb6" GroupName="Urine" runat="server" Text="None or <10 ml/2hrs" /></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbUrine2" CssClass="rb6" GroupName="Urine" runat="server" Text="<30 ml/2hrs" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbUrine1" CssClass="rb6" GroupName="Urine" runat="server" Text="<50 ml/2hrs" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbUrine0" CssClass="rb6" GroupName="Urine" runat="server" Text=">50 ml/2hrs" /></td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%">
                            <asp:TextBox ID="txtUrine" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblUrine" runat="server" Text=" " Style="display: none"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">ConsciousnessLevel(AVPU)</td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbLevel3" CssClass="rb7" GroupName="Level" runat="server" Text="Unresponsive" /></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbLevel2" CssClass="rb7" GroupName="Level" runat="server" Text="Responds to Pain" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbLevel1" CssClass="rb7" GroupName="Level" runat="server" Text="Drowsy/ responds<br/> voice" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbLevel0" CssClass="rb7" GroupName="Level" runat="server" Text="Alert" /></td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbLevel11" CssClass="rb7" GroupName="Level" runat="server" Text="New Agitation/Confusion" />
                        </td>
                        <td style="width: 10%"></td>
                        <td style="width: 10%">
                            <asp:TextBox ID="txtLevel" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblLevel" runat="server" Text=" " Style="display: none"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">Chest Paint</td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbChest3" CssClass="rb8" GroupName="Chest" runat="server" Text="3 Points" /></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbChest2" CssClass="rb8" GroupName="Chest" runat="server" Text="Specify" /></td>
                        <td colspan="5">
                            <asp:TextBox ID="txtChest" runat="server" TextMode="MultiLine" Width="450"></asp:TextBox>
                            <asp:TextBox ID="txtChestScore" runat="server" Text="0" Style="display: none">
                            </asp:TextBox>
                            <asp:TextBox ID="lblChest" runat="server" Text=" " Style="display: none"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">Panic Lab Values</td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbPanic3" CssClass="rb9" GroupName="Panic" runat="server" Text="3 Points" /></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbPanic2" CssClass="rb9" GroupName="Panic" runat="server" Text="Specify" /></td>
                        <td colspan="5">
                            <asp:TextBox ID="TxtPanic" runat="server" TextMode="MultiLine" Width="450"></asp:TextBox>
                            <asp:TextBox ID="txtPanicScore" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblPanic" runat="server" Text=" " Style="display: none"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%">ECG changes/dysrhythmia</td>
                        <td style="width: 10%">
                            <asp:RadioButton ID="RdbECG3" CssClass="rb10" GroupName="ECG" runat="server" Text="3 Points" /></td>
                        <td style="width: 15%">
                            <asp:RadioButton ID="RdbECG2" CssClass="rb10" GroupName="ECG" runat="server" Text="Specify" /></td>
                        <td colspan="5">
                            <asp:TextBox ID="txtECG" runat="server" TextMode="MultiLine" Width="450"></asp:TextBox>
                            <asp:TextBox ID="txtECGScore" runat="server" Text="0" Style="display: none"></asp:TextBox>
                            <asp:TextBox ID="lblECG" runat="server" Text=" " Style="display: none"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <table style="width: 100%">
                    <tr>
                        <td style="width: 35%; border-bottom: groove; border-left: groove; border-right: groove; border-top: groove;"><b>Total Score</b></td>
                        <td style="width: 25%; border-bottom: hidden; border-left: hidden; border-right: hidden; border-top: hidden;">
                            <asp:Label ID="lblTotal" runat="server" Text="0" CssClass="ItDoseLblSpBl"></asp:Label></td>
                        <td style="width: 20%">
                            <asp:TextBox ID="txtTotalScore" runat="server" Style="display: none"></asp:TextBox></td>
                        <td style="width: 30%"></td>
                    </tr>
                    <tr>
                        <td style="width: 35%;">Additional Information</td>
                        <td colspan="3" rowspan="2">
                            <asp:TextBox ID="txtAdd" runat="server" TextMode="MultiLine" Width="751px" Height="50px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 20%;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 35%;">&nbsp;</td>
                        <td style="width: 25%">&nbsp;</td>
                        <td style="width: 10%">&nbsp;</td>
                        <td style="width: 10%">&nbsp;</td>
                    </tr>
                </table>

            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center">
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="save margin-top-on-btn" OnClick="btnSave_Click" OnClientClick="return validatecontrol(this);" />

                </div>
            </div>
        </div>
    </form>
</body>
</html>
