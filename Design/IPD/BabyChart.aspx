<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BabyChart.aspx.cs" Inherits="Design_IPD_BabyChart" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/StartDate.ascx" TagName="StartDate" TagPrefix="uc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Baby Chart</title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <style>
                .textareas {
                    height: 75px;
                }
            </style>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>
                    <label style="display: none" id="lblhospitalname"></label>
                    Baby Chart</b>
                <span id="spnbabyChartID" style="display: none"></span>

                <span style="display: none"></span>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" id="divDemographicDetails" onclick="togglePatientDetailSection(this)" style="cursor: pointer">
                    Maternal details
                </div>
                <div class="row">
                    <div class="col-md-25" style="display: block;">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Baby UHID </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlBabyPatientUHID">
                                </select>
                                <span id="spnBabyUHID" style="display: none"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Gender</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">

                                <input id="rdoMale" type="radio" name="sex" checked="checked" value="Male" class="pull-left" />
                                <span class="pull-left">Male</span>
                                <input id="rdoFemale" type="radio" name="sex" value="Female" class="pull-left" />
                                <span class="pull-left">Female</span>
                                <input id="rdoTGender" type="radio" name="sex" value="TransGender" class="pull-left" />
                                <span class="pull-left">Others</span>

                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">Blood Group </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlBloodGroup">
                                    <option value="0">Select</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                </select>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">ObstetricHistory</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <textarea id="txtEnterObstetricHistory" class="customTextArea" data-title="Enter Obstetric History" maxlength="200"></textarea>

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Family history </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <textarea id="txtFamilyHistory" class="customTextArea" data-title="Enter Family History" maxlength="200"></textarea>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Medical history</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <textarea id="txtMedicalHistory" class="customTextArea" data-title="Enter Medical History" maxlength="200"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div id="divpregnancyDetails" class="Purchaseheader" onclick="togglePatientDetailSection(this)" style="cursor: pointer">
                    This pregnancy Details
                </div>
                <div class="row">
                    <div class="col-md-25" style="display: block;">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">LMP</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <asp:TextBox ID="txtGestationDate" runat="server" ReadOnly="true" autocomplete="off" data-title="Enter Date" placeholder="DD-MM-YYYY" ClientIDMode="Static" ToolTip="Select Date" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtGestationDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="By Scan">EDD ByDate</label>
                                <b class="pull-right">:</b></div>
                            <div class="col-md-5">

                                <asp:TextBox ID="txtEDDBydates" runat="server" ReadOnly="true" autocomplete="off" data-title="Enter Date" placeholder="DD-MM-YYYY" ClientIDMode="Static" ToolTip="Select Date" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" TargetControlID="txtEDDBydates" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">EDD ByScan</label>
                                <b class="pull-right">:</b></div>
                            <div class="col-md-5">
                                <input id="txtEDDByScan" type="text" /></div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Antenatal Care</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlAntenatalcare">
                                    <option value="YES">YES</option>
                                    <option value="NO">NO</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Booking date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBookingdate" runat="server" ReadOnly="true" autocomplete="off" data-title="Enter Date" placeholder="DD-MM-YYYY" ClientIDMode="Static" ToolTip="Select Date" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtBookingdate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                                <%--<cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtBookingdate" Format="dd-MM-yyyy" runat="server" ></cc1:CalendarExtender>
                                <cc1:FilteredTextBoxExtender  ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers,Custom" ValidChars="-" TargetControlID="txtBookingdate"></cc1:FilteredTextBoxExtender>--%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Smokes(PerDay)">Smokes(PerDay)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtSmokePerDay" type="text" onlynumber="2" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left" title="Alcohol">Alcohol</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlAlcohol">
                                    <option value="YES">YES</option>
                                    <option value="NO">NO</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Duration Of Labour</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <div style="margin-bottom: -11px">
                                    <label class="pull-left">1st Stage</label>&nbsp;&nbsp;<input id="txtDurationOfLabour1stStage" type="text" onlynumber="2" style="width: 116px; padding-right: 1px" /></div>
                                <br />
                                <div style="margin-bottom: -11px">
                                    <label class="pull-left">2nd Stage</label>&nbsp;<input id="txtDurationOfLabour2ndStage" type="text" onlynumber="2" style="width: 116px; padding-right: 1px" /></div>
                                <br />
                                <div>
                                    <label class="pull-left">3rd Stage</label>&nbsp;&nbsp;<input id="txtDurationOfLabour3rdStage" type="text" onlynumber="2" style="width: 116px; padding-right: 1px" /></div>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">AntenatalProblems & Drugs</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <textarea id="txtAntenatalproblemsdrugs" class="textareas" maxlength="200"></textarea>
                            </div>

                        </div>

                        <div class="row">
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Amnio</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlAmnio">
                                    <option value="YES">YES</option>
                                    <option value="NO">NO</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Result</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtResult" type="text" />

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Antenal Steroids</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlAntenalSteroids">
                                    <option value="YES">YES</option>
                                    <option value="NO">NO</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">MembranesRuptured</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlMembranesRuptured">
                                    <option value="YES">YES</option>
                                    <option value="NO">NO</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Placenta</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlPlacenta">
                                    <option value="YES">Removed</option>
                                    <option value="NO">Retain</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Delivery Mode</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtDeliveryMode" type="text" />

                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Indication</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtIndication" type="text" />

                            </div>


                            <div class="col-md-3">
                                <label class="pull-left">Ga (Week)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtGaWeek" type="text" onkeypress="return isNumber(event)" maxlength="2" value="0" />

                            </div>


                            <div class="col-md-3">
                                <label class="pull-left">Ga (Days)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtGaDays" type="text" onkeypress="return isNumber(event)" maxlength="1" value="0" />

                            </div>

                        </div>

                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div id="div1" class="Purchaseheader" onclick="togglePatientDetailSection(this)" style="cursor: pointer">
                    Infant Details
                </div>
                <div class="row">
                    <div class="col-md-25" style="display: block;">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Weight</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtweight" type="text" maxlength="50" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Length</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtLength" type="text" maxlength="50" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">H/C</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtOFC" type="text" maxlength="50" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left" title="Emergency LMP">Gestation By Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtLMPDate" type="text" maxlenght="50" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Gestation By Scan</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtGestationScan" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Gestation By Ballard</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtDubowitz" type="text" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">ApgarScore(min)</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <input id="txtApgarScorefirst" type="text" onlynumber="4" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">ApgarScore(2nd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtApgarScoreSecond" type="text" onlynumber="4" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">ApgarScore(3rd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtApgarScoreThird" type="text" onlynumber="4" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Colour</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <input id="txtColorFirst" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Colour(2nd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtColorSecond" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Colour(3rd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtColorThird" type="text" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Heart rate</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <input id="txtHeartrateFirst" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Heart rate(2nd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtHeartRateSecond" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Heart rate(3rd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtHeartRateThird" type="text" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Respiration</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <input id="txtRespirationFirst" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Respiration(2nd)</label>
                                <b class="pull-right">:</b>

                            </div>
                            <div class="col-md-5">
                                <input id="txtRespirationSecond" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Respiration(3rd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtRespirationThird" type="text" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Tone</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <input id="txtTonefirst" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Tone(2nd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtToneSecond" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Tone(3rd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtToneThird" type="text" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Response</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <input id="txtResponseFirst" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Respons(2nd)e</label>
                                <b class="pull-right">:</b>

                            </div>
                            <div class="col-md-5">
                                <input id="txtResponseSecond" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Response(3rd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtResponseThird" type="text" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Total</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-5">
                                <input id="txtTotalFirst" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Total(2nd)</label>
                                <b class="pull-right">:</b>

                            </div>
                            <div class="col-md-5">
                                <input id="txtTotalSecond" type="text" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Total(3rd)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtTotalThird" type="text" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Resuscitation</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <textarea id="txtResuscitation" class="customTextArea" maxlength="200"></textarea>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Vitamin K given">Vitamin K given</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlVitaminKgiven">
                                    <option value="YES">YES</option>
                                    <option value="NO">NO</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Eye Ointment">Eye Ointment</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlEyeOintmentgiven">
                                    <option value=""></option>
                                    <option value="YES">YES</option>
                                    <option value="NO">NO</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div id="div2" class="Purchaseheader" onclick="togglePatientDetailSection(this)" style="cursor: pointer">
                    Examination
                </div>
                <div class="row">
                    <div class="col-md-25" style="display: block;">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtExaminatioDate" runat="server" ReadOnly="true" autocomplete="off" data-title="Enter Date" placeholder="DD-MM-YYYY" ClientIDMode="Static" ToolTip="Select Date" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" TargetControlID="txtExaminatioDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Dr examining</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtDrExamining" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left" title="Length">Head/sutures/fontanelles</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <input id="txtHeadSuturesFontanelles" type="text" maxlength="100" />
                            </div>
                        </div>

                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Hips</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtHips" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Eyes</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtEyes" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Genitalia</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtGenitalia" type="text" maxlength="100" />
                            </div>
                        </div>

                        <div class="row">


                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Ears</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtEars" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Testes</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtTestes" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Palate</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtPalate" type="text" maxlength="100" />
                            </div>
                        </div>
                        <div class="row">


                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Spine</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtSpine" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Neck</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtNeck" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Lower limbs</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtLowerLimbs" type="text" maxlength="100" />
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Upper limbs</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtUpperLimbs" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Skin</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtSkin" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">RS/chest</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="RSChest" type="text" maxlength="100" />
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Tone</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtTone" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">CVS</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtCVS" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Movement</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtMovement" type="text" maxlength="100" />
                            </div>
                        </div>

                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Abdomen</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtAbdomen" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Moro</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtMoro" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Femoral pulses</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtFemoralPulses" type="text" maxlength="100" />
                            </div>
                        </div>

                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Grasp</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtGrasp" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Anus</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtAnus" type="text" maxlength="100" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Suck</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input id="txtSuck" type="text" maxlength="100" />
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-3">
                                <label class="pull-left" title="Length">Comments</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-13">
                                <input id="txtComments" type="text" maxlength="200" />
                            </div>

                        </div>


                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <input type="button" style="width: 100px; margin-top: 7px" id="btnSave" onclick="SaveBabyChartDetaills($('#btnSave'))" class="ItDoseButton" value="Save" />
                &nbsp; &nbsp;
                <asp:Button runat="server" ID="btnprint" ClientIDMode="Static" CssClass="ItDoseButton" Style="width: 100px; margin-top: 7px;" Text="Print" OnClick="btnprint_Click" />
            </div>

            <div class="row">
                <table class="FixedHeader" id="tblBabyDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle">SrNo</th>
                            <th class="GridViewHeaderStyle">MotherUHID</th>
                            <th class="GridViewHeaderStyle">BabyUHID</th>
                            <th class="GridViewHeaderStyle">BabyGender</th>
                            <th class="GridViewHeaderStyle">BabyName</th>
                            <th class="GridViewHeaderStyle">Edit</th>
                            <th class="GridViewHeaderStyle">Print</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

            </div>
            <script type="text/javascript">
                var togglePatientDetailSection = function (el, isForceHide) {
                    var x = $(el).parent().find('.row:first');
                    if (x.css('display') == 'block') {
                        x.css('display', 'none');
                    } else {
                        x.css('display', 'block');
                    }
                }
            </script>
            <script type="text/javascript">
                var TransactionID = '<%=Util.GetString(Request.QueryString["TransactionID"])%>';
                $(document).ready(function () {
                    $bindMandatory(function () {

                        if (!String.isNullOrEmpty(TransactionID)) {
                            $bindBabyUHID(function (callback) {

                            });
                            $GetBabyChartDetails(TransactionID, function (response) {
                                babydetails(response);
                                //$SetBabyCharDetails(response, function () {
                                //    $('#btnSave').val('Update');
                                //}); 
                            });
                        }
                    });
                });

                var onBlockUI = function () {
                    modelConfirmation('Attention !!', 'This patient is not a Baby...!!!', '', 'Close', function () { });
                    $('#btnSave,#btnprint').hide();
                }

                var $SetBabyCharDetails = function (data, callback) {
                    $('#ddlBloodGroup').val(data[0].BloodGroup);
                    $('#txtEnterObstetricHistory').val(data[0].ObstetricHistory);
                    $('#txtFamilyHistory').val(data[0].FamilyHistory);
                    $('#txtMedicalHistory').val(data[0].MedicalHistory);
                    $('#txtLMPDate').val(data[0].LMP);
                    $('#txtEDDBydates').val(data[0].EDDByDate);
                    $('#txtEDDByScan').val(data[0].EDDByScan);
                    $('#ddlAntenatalcare').val(data[0].AntenatalCare);
                    $('#txtBookingdate').val(data[0].BookingDate);
                    $('#txtSmokePerDay').val(data[0].SmokesPerDay);
                    $('#ddlAlcohol').val(data[0].Alcohol);
                    $('#txtDurationOfLabour1stStage').val(data[0].DurationOfLabourFirstStage);
                    $('#txtDurationOfLabour2ndStage').val(data[0].DurationOfLabourSecondStage);
                    $('#txtDurationOfLabour3rdStage').val(data[0].DurationOfLabourThirdStage);
                    $('#txtAntenatalproblemsdrugs').val(data[0].AntenatalProblemsAndDrugs);
                    $('#ddlAmnio').val(data[0].Amnio);
                    $('#ddlMembranesRuptured').val(data[0].MembranesRuptured);
                    $('#txtResult').val(data[0].Result);
                    $('#ddlAntenalSteroids').val(data[0].AntenalSteroids);
                    $('#ddlPlacenta').val(data[0].Placenta);
                    $('#txtDeliveryMode').val(data[0].DeliveryMode);
                    $('#txtIndication').val(data[0].Indication);
                    $('#txtLength').val(data[0].LENGTH);
                    $('#txtweight').val(data[0].Weight);
                    $('#txtOFC').val(data[0].OFC);
                    $('#txtGestationDate').val(data[0].GestationDate);
                    $('#txtGestationScan').val(data[0].GestationScan);
                    $('#txtDubowitz').val(data[0].Dubowitz);
                    $('#txtApgarScorefirst').val(data[0].ApgarScoreFirst);
                    $('#txtApgarScoreSecond').val(data[0].ApgarScoreSecond);
                    $('#txtApgarScoreThird').val(data[0].ApgarScoreThird);
                    $('#txtColorFirst').val(data[0].ColourFirst);
                    $('#txtColorSecond').val(data[0].ColourSecond);
                    $('#txtColorThird').val(data[0].ColourThird);
                    $('#txtHeartrateFirst').val(data[0].HeartRateFirst);
                    $('#txtHeartRateSecond').val(data[0].HeartRateSecond);
                    $('#txtHeartRateThird').val(data[0].HeartRateThird);
                    $('#txtRespirationFirst').val(data[0].RespirationFirst);
                    $('#txtRespirationSecond').val(data[0].RespirationSecond);
                    $('#txtRespirationThird').val(data[0].RespirationThird);
                    $('#txtTonefirst').val(data[0].ToneFirst);
                    $('#txtToneSecond').val(data[0].ToneSecond);
                    $('#txtToneThird').val(data[0].ToneThird);
                    $('#txtResponseFirst').val(data[0].ResponseFirst);
                    $('#txtResponseSecond').val(data[0].ResponseSecond);
                    $('#txtResponseThird').val(data[0].ResponseThird);
                    $('#txtTotalFirst').val(data[0].TotalFirst);
                    $('#txtTotalSecond').val(data[0].TotalThird);
                    $('#txtTotalThird').val(data[0].TotalThird);
                    $('#txtResuscitation').val(data[0].Resuscitation);
                    $('#ddlVitaminKgiven').val(data[0].VitaminKGiven);
                    $('#ddlEyeOintmentgiven').val(data[0].EyeOintmentGiven);
                    $('#txtExaminatioDate').val(data[0].DATE);
                    $('#txtDrExamining').val(data[0].DrExamining);
                    $('#txtHeadSuturesFontanelles').val(data[0].HeadSuturesFontanelles);
                    $('#txtHips').val(data[0].Hips);
                    $('#txtEyes').val(data[0].Eyes);
                    $('#txtGenitalia').val(data[0].Genitalia);
                    $('#txtEars').val(data[0].Ears);
                    $('#txtTestes').val(data[0].Testes);
                    $('#txtPalate').val(data[0].Palate);
                    $('#txtSpine').val(data[0].Spine);
                    $('#txtNeck').val(data[0].Neck);
                    $('#txtLowerLimbs').val(data[0].LowerLimbs);
                    $('#txtUpperLimbs').val(data[0].UpperLimbs);
                    $('#txtSkin').val(data[0].Skin);
                    $('#RSChest').val(data[0].RSChest);
                    $('#txtTone').val(data[0].Tone);
                    $('#txtCVS').val(data[0].CVS);
                    $('#txtMovement').val(data[0].Movement);
                    $('#txtAbdomen').val(data[0].Abdomen);
                    $('#txtMoro').val(data[0].Moro);
                    $('#txtFemoralPulses').val(data[0].FemoralPulses);
                    $('#txtGrasp').val(data[0].Grasp);
                    $('#txtAnus').val(data[0].Anus);
                    $('#txtSuck').val(data[0].Suck);
                    $('#txtComments').val(data[0].Comments);

                    $('#txtGaWeek').val(data[0].GaWeek);
                    $('#txtGaDays').val(data[0].GaDays);

                    $('#btnSave').val('Update');


                }
                function babydetails(data) {

                    $('#tblBabyDetails tbody').empty();
                    for (var i = 0; i < data.length > 0; i++) {
                        var row = '<tr>';
                        var j = $('#tblBabyDetails tbody tr').length + 1;
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BabyMotherUHID + '</td>';
                        row += '<td class="GridViewLabItemStyle" ID="tdBabyUHID"style="text-align: center;">' + data[i].BabyUHID + '</td>';
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BabyGender + '</td>';
                        row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BabyName + '</td>';
                        row += '<td class="GridViewLabItemStyle" ID="tdBabyID" style="text-align: center;display:none">' + data[i].ID + '</td>';
                        row += '<td class="GridViewLabItemStyle" style="text-align: center; "> <img id="imgEdit" src="../../Images/edit.png" onclick="editBabyDetails(this);" style="cursor: pointer; " title="Click To Edit" /></td>';
                        row += '<td class="GridViewLabItemStyle" style="text-align: center; "> <img id="imgPrint" src="../../Images/print.gif" onclick="Print(this);" style="cursor: pointer; " title="Click To Print" /></td>';
                        row += '</tr>';
                        $('#tblBabyDetails tbody').append(row);

                    }
                }

                function Print(el) {
                    var row = $(el).closest('tr');
                    var id = $(row).find('#tdBabyID').text();
                    window.open('BabyChartReport.aspx?TransactionID=' + TransactionID + '&ID=' + id);
                }

                function editBabyDetails(el) {
                    $('#ddlBabyPatientUHID_chosen').hide();
                    $('#spnBabyUHID').show();
                    var row = $(el).closest('tr');
                    var id = $(row).find('#tdBabyID').text();
                    var babyUHID = $(row).find('#tdBabyUHID').text();
                    $('#spnbabyChartID').text(id);
                    $('#spnBabyUHID').text(babyUHID);

                    serverCall('../IPD/Services/babychart.asmx/GetBabyCharDetailsID', { ID: id }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData != "") {
                            $SetBabyCharDetails(responseData, function () { });
                        }
                    });
                }

                var $bindBabyUHID = function (callback) {
                    serverCall('../IPD/Services/babychart.asmx/GetBabyUHID', { TransactionID: TransactionID }, function (response) {
                        $ddlBabyPatientUHID = $('#ddlBabyPatientUHID');

                        if (response != "") {
                            $ddlBabyPatientUHID.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BabyPatientID', isSearchAble: true });
                            callback($ddlBabyPatientUHID.val());
                        }

                    });
                }
                var $GetBabyChartDetails = function (TransactionID, callback) {
                    serverCall('../IPD/Services/babychart.asmx/GetBabyCharDetails', { TransactionID: TransactionID }, function (response) {
                        if ((JSON.parse(response)) != "") {
                            callback(JSON.parse(response))
                        }
                    });
                }
                var $bindMandatory = function (callback) {
                    var manadatory = [
                        { control: '#ddlBloodGroup', isRequired: false, erroMessage: 'Select Blood Group', tabIndex: 1, isSearchAble: false },
                        { control: '#txtEnterObstetricHistory', isRequired: true, erroMessage: 'Enter Enter Obstetric History', tabIndex: 2, isSearchAble: false },
                    ];
                    $(manadatory).each(function (index, item) {
                        $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                        if (item.isSearchAble)
                            $(item.control + '_chosen a').addClass('requiredField').attr('tabindex', item.tabIndex);
                        $(manadatory[0].control).focus();
                    });
                    callback(true);
                }
                var SaveBabyChartDetaills = function (btnSave) {

                    $gender = $('input[type=radio][name=sex]:checked').val();
                    if (String.isNullOrEmpty($gender)) {
                        modelAlert('Please Select Gender');
                        return false;
                    }
                   if( $('#btnSave').val() == 'Save')
                    {
                        if ($('#ddlBabyPatientUHID').val() == '0' ) {
                            modelAlert('Please Select Baby UHID ');
                            return false;
                        }
                    }

                    $getBabyChartDetails(function (BabyDetails) {
                        $(btnSave).attr('disabled', true).val('Submitting...');
                        serverCall('../IPD/Services/babychart.asmx/SaveBabyChart', BabyDetails, function (response) {
                            var $responseData = JSON.parse(response);
                            if ($responseData.status) {
                                ClearField();
                                modelAlert($responseData.response, function () {
                                    $bindBabyUHID(function (callback) { });
                                    $GetBabyChartDetails(TransactionID, function (response) {
                                        babydetails(response);
                                    });
                                });
                            }
                            else {
                                modelAlert($responseData.response, function () {
                                    $(btnSave).removeAttr('disabled').val('Save');
                                });
                            }
                        });
                    });
                }
                var $getBabyChartDetails = function (callback) {
                    var inValidElem = null;
                    $('#Pbody_box_inventory .requiredField').each(function (index, elem) {
                        if (String.isNullOrEmpty(elem.value) || elem.value == '0') {
                            inValidElem = elem;
                            modelAlert(this.attributes['errorMessage'].value, function () {
                                inValidElem.focus();
                            });
                            return false;
                        }
                    });
                    var TransactionID = '<%=Util.GetString(Request.QueryString["TransactionID"])%>';
                 if (String.isNullOrEmpty(TransactionID)) {
                     modelAlert('Transaction ID Can  Not Blank or Null');
                     return false;
                 }

                 if (parseInt($("#txtGaDays").val())>6) {
                     modelAlert('Enter Days Between 0 To 6');
                     return false;
                 }
                 if (String.isNullOrEmpty(inValidElem)) {
                     var Details = {
                         TransactionID: TransactionID,
                         BloodGroup: $('#ddlBloodGroup').val(),
                         ObstetricHistory: $('#txtEnterObstetricHistory').val(),
                         FamilyHistory: $('#txtFamilyHistory').val(),
                         MedicalHistory: $('#txtMedicalHistory').val(),
                         LMP: $('#txtLMPDate').val(),
                         EDDByDate: $('#txtEDDBydates').val(),
                         EDDByScan: $('#txtEDDByScan').val(),
                         AntenatalCare: $('#ddlAntenatalcare').val(),
                         BookingDate: $('#txtBookingdate').val(),
                         SmokesPerDay: $('#txtSmokePerDay').val(),
                         Alcohol: $('#ddlAlcohol').val(),
                         DurationOfLabourFirstStage: $('#txtDurationOfLabour1stStage').val(),
                         DurationOfLabourSecondStage: $('#txtDurationOfLabour2ndStage').val(),
                         DurationOfLabourThirdStage: $('#txtDurationOfLabour3rdStage').val(),
                         AntenatalProblemsAndDrugs: $('#txtAntenatalproblemsdrugs').val(),
                         Amnio: $('#ddlAmnio').val(),
                         Result: $('#txtResult').val(),
                         AntenalSteroids: $('#ddlAntenalSteroids').val(),
                         MembranesRuptured: $('#ddlMembranesRuptured').val(),
                         Placenta: $('#ddlPlacenta').val(),
                         DeliveryMode: $('#txtDeliveryMode').val(),
                         Indication: $('#txtIndication').val(),
                         Length: $('#txtLength').val(),
                         Weight: $('#txtweight').val(),
                         OFC: $('#txtOFC').val(),
                         GestationDate: $('#txtGestationDate').val(),
                         GestationScan: $('#txtGestationScan').val(),
                         Dubowitz: $('#txtDubowitz').val(),
                         ApgarScoreFirst: $('#txtApgarScorefirst').val(),
                         ApgarScoreSecond: $('#txtApgarScoreSecond').val(),
                         ApgarScoreThird: $('#txtApgarScoreThird').val(),
                         ColourFirst: $('#txtColorFirst').val(),
                         ColourSecond: $('#txtColorSecond').val(),
                         ColourThird: $('#txtColorThird').val(),
                         HeartRateFirst: $('#txtHeartrateFirst').val(),
                         HeartRateSecond: $('#txtHeartRateSecond').val(),
                         HeartRateThird: $('#txtHeartRateThird').val(),
                         RespirationFirst: $('#txtRespirationFirst').val(),
                         RespirationSecond: $('#txtRespirationSecond').val(),
                         RespirationThird: $('#txtRespirationThird').val(),
                         ToneFirst: $('#txtTonefirst').val(),
                         ToneSecond: $('#txtToneSecond').val(),
                         ToneThird: $('#txtToneThird').val(),
                         ResponseFirst: $('#txtResponseFirst').val(),
                         ResponseSecond: $('#txtResponseSecond').val(),
                         ResponseThird: $('#txtResponseThird').val(),
                         TotalFirst: $('#txtTotalFirst').val(),
                         TotalSecond: $('#txtTotalSecond').val(),
                         TotalThird: $('#txtTotalThird').val(),
                         Resuscitation: $('#txtResuscitation').val(),
                         VitaminKGiven: $('#ddlVitaminKgiven').val(),
                         EyeOintmentGiven: $('#ddlEyeOintmentgiven').val(),
                         Date: $('#txtExaminatioDate').val(),
                         DrExamining: $('#txtDrExamining').val(),
                         HeadSuturesFontanelles: $('#txtHeadSuturesFontanelles').val(),
                         Hips: $('#txtHips').val(),
                         Eyes: $('#txtEyes').val(),
                         Genitalia: $('#txtGenitalia').val(),
                         Ears: $('#txtEars').val(),
                         Testes: $('#txtTestes').val(),
                         Palate: $('#txtPalate').val(),
                         Spine: $('#txtSpine').val(),
                         Neck: $('#txtNeck').val(),
                         LowerLimbs: $('#txtLowerLimbs').val(),
                         UpperLimbs: $('#txtUpperLimbs').val(),
                         Skin: $('#txtSkin').val(),
                         RSChest: $('#RSChest').val(),
                         Tone: $('#txtTone').val(),
                         CVS: $('#txtCVS').val(),
                         Movement: $('#txtMovement').val(),
                         Abdomen: $('#txtAbdomen').val(),
                         Moro: $('#txtMoro').val(),
                         FemoralPulses: $('#txtFemoralPulses').val(),
                         Grasp: $('#txtGrasp').val(),
                         Anus: $('#txtAnus').val(),
                         Suck: $('#txtSuck').val(),
                         Comments: $('#txtComments').val(),
                         babyUHID: $("#ddlBabyPatientUHID option:selected").text(),
                         gender: $('input[type=radio][name=sex]:checked').val(),
                         BabyID: $('#ddlBabyPatientUHID').val(),
                         BabyChartID: $('#spnbabyChartID').text(),
                         GaWeek: $("#txtGaWeek").val(),
                         GaDays: $("#txtGaDays").val(),
                     }
                     callback({ DefaultlDetails: [Details] });
                 }
             }
             function ClearField() {
                 $('#ddlBloodGroup').val('0');
                 $('#txtEnterObstetricHistory').val('');
                 $('#txtFamilyHistory').val('');
                 $('#txtMedicalHistory').val('');
                 $('#txtLMPDate').val('');
                 $('#txtEDDByScan').val('');
                 $('#ddlAntenatalcare').val('0');
                 $('#txtSmokePerDay').val('');
                 $('#ddlAlcohol').val('0');
                 $('#txtDurationOfLabour1stStage').val('');
                 $('#txtDurationOfLabour2ndStage').val('');
                 $('#txtDurationOfLabour3rdStage').val('');
                 $('#txtAntenatalproblemsdrugs').val('');
                 $('#ddlAmnio').val('YES');
                 $('#ddlMembranesRuptured').val('YES')
                 $('#txtResult').val('');
                 $('#ddlAntenalSteroids').val('0');
                 $('#ddlPlacenta').val('0');
                 $('#txtDeliveryMode').val('');
                 $('#txtIndication').val('');
                 $('#txtLength').val('');
                 $('#txtweight').val('');
                 $('#txtOFC').val('');
                 $('#txtGestationScan').val('');
                 $('#txtDubowitz').val('');
                 $('#txtApgarScorefirst').val('');
                 $('#txtApgarScoreSecond').val('');
                 $('#txtApgarScoreThird').val('');
                 $('#txtColorFirst').val('');
                 $('#txtColorSecond').val('');
                 $('#txtColorThird').val('');
                 $('#txtHeartrateFirst').val('');
                 $('#txtHeartRateSecond').val('');
                 $('#txtHeartRateThird').val('');
                 $('#txtRespirationFirst').val('');
                 $('#txtRespirationSecond').val('');
                 $('#txtRespirationThird').val('');
                 $('#txtTonefirst').val('');
                 $('#txtToneSecond').val('');
                 $('#txtToneThird').val('');
                 $('#txtResponseFirst').val('');
                 $('#txtResponseSecond').val('');
                 $('#txtResponseThird').val('');
                 $('#txtTotalFirst').val('');
                 $('#txtTotalSecond').val('');
                 $('#txtTotalThird').val('');
                 $('#txtResuscitation').val('');
                 $('#ddlVitaminKgiven').val('');
                 $('#ddlEyeOintmentgiven').val('');
                 $('#txtDrExamining').val('');
                 $('#txtHeadSuturesFontanelles').val('');
                 $('#txtHips').val('');
                 $('#txtEyes').val('');
                 $('#txtGenitalia').val('');
                 $('#txtEars').val('');
                 $('#txtTestes').val('');
                 $('#txtPalate').val('');
                 $('#txtSpine').val('');
                 $('#txtNeck').val('');
                 $('#txtLowerLimbs').val('');
                 $('#txtUpperLimbs').val('');
                 $('#txtSkin').val('');
                 $('#RSChest').val('');
                 $('#txtTone').val('');
                 $('#txtCVS').val('');
                 $('#txtMovement').val('');
                 $('#txtAbdomen').val('');
                 $('#txtMoro').val('');
                 $('#txtFemoralPulses').val('');
                 $('#txtGrasp').val('');
                 $('#txtAnus').val('');
                 $('#txtSuck').val('');
                 $('#txtComments').val('');
                 $('#txtGaWeek').val('');
                 $('#txtGaDays').val('');
                 $(btnSave).removeAttr('disabled').val('Save');
                 $('#spnBabyUHID').hide();
             }





             function isNumber(evt) {
                 evt = (evt) ? evt : window.event;
                 var charCode = (evt.which) ? evt.which : evt.keyCode;
                 if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                     return false;
                 }
                 return true;
             }
            </script>
        </div>
    </form>
</body>
</html>
