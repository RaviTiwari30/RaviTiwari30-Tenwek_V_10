<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HomoDialysis.aspx.cs" Inherits="Design_CPOE_HomoDialysis" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />

    <style type="text/css">
        .hidden {
            display: none;
        }

        .tblBorder {
            border: solid thin;
            padding: 3px;
        }

        .txtUnderlineWithBold {
            font-weight: bolder;
            text-decoration-line: underline;
            margin-top: 10px;
        }

        .txtBold {
            font-weight: bolder;
        }
    </style>

</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />


    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>HEMODIALYSIS FLOWCHART</b>
                <br />
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" Style="display: none"></asp:TextBox>
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnPanelID" style="display: none" runat="server" clientidmode="Static"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display: none"></span>

                <span id="spnPreDialysisVitalId" style="display: none" runat="server" clientidmode="Static">0</span>
                <span id="spnDialysisOrderId" runat="server" clientidmode="Static" style="display: none">0</span>
                <span id="spnMachineCheckId" runat="server" clientidmode="Static" style="display: none">0</span>
                <span id="spnDialysisExaminationId" style="display: none" runat="server" clientidmode="Static">0</span>
                <span id="spnIntraDialyticObservationId" runat="server" clientidmode="Static" style="display: none">0</span>
                <span id="spnPostDialyticObservationId" runat="server" clientidmode="Static" style="display: none">0</span>


                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="cursor: pointer" id="divHemoDialysisFlowchart" onclick="togglePatientDetailSection(this,false)" class="Purchaseheader">
                    PRE-DIALYSIS VITAL SIGN
                </div>
                <div class="row divHemoDialysisFlowchart">
                    <div class="col-md-24">
                        <div class="row tblBorder">
                            <table width="100%">
                                <tr>
                                    <td class="tblBorder">Previous Weight :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtPreviousWeightpdv" /></td>
                                    <td class="tblBorder">Kg/Gram</td>
                                    <td class="tblBorder" rowspan="6" style="text-align: center;">
                                        <div style="transform: rotate(270deg)">
                                            <label>
                                                PRE-DIALYSIS
                                                <br />
                                                VITAL SIGN</label>
                                        </div>
                                    </td>
                                    <td class="tblBorder">BP :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtBPpdv" /></td>
                                    <td class="tblBorder">mmHg</td>
                                    
                                </tr>
                                <tr>
                                    <td class="tblBorder">Current Weight :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtCurrentweightpdv" /></td>
                                    <td class="tblBorder">Kg/Gram</td>
                                    <td class="tblBorder">Pulse :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtPulsepdv" /></td>

                                    <td class="tblBorder">b/m</td>
                                </tr>
                                <tr>
                                    <td class="tblBorder">Weight Gain :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtWeightGainpdv" /></td>
                                    <td class="tblBorder">Kg/Gram</td>
                                    <td class="tblBorder">Resp :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtResppdv" /></td>
                                    <td class="tblBorder">/m</td>
                                </tr>
                                <tr>
                                    <td class="tblBorder">Dry Weight :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtDryWeightpdv" /></td>
                                    <td class="tblBorder">Kg/Gram</td>
                                    <td class="tblBorder">SPO<sub>2</sub> :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtSPO2pdv" /></td>
                                    <td class="tblBorder">%</td>

                                </tr>
                                <tr>
                                    <td class="tblBorder" rowspan="1">Blood Group:</td>
                                    <td class="tblBorder" rowspan="1">
                                        <input type="text" id="txtBloodGrouppdv" /></td>
                                    <td class="tblBorder"></td>
                                    <td class="tblBorder">Temp:</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtTemppdv" /></td>
                                    <td class="tblBorder">&deg;  C</td>
                                </tr>
                                <tr>
                                    
                                    <td class="tblBorder" rowspan="1">Diagnosis:</td>
                                    <td class="tblBorder" rowspan="1">
                                        <input type="text" id="txtDiagnosis" /></td>
                                    <td class="tblBorder"></td>
                                    <td class="tblBorder">RBS :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtRBSpdv" /></td>
                                    <td class="tblBorder">mmol/L</td>
                                </tr>
                                <tr>
                                    <td class="tblBorder">HIV Test:</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtHivpdv" style="display:none;" />
                                        <select id="selectHivpdv">
                                            <option value="0">--Select--</option>
                                            <option value="Positive">Positive</option>
                                            <option value="Negative">Negative</option>
                                            <option value="Not Test">Not Test</option>
                                        </select>
                                    </td>
                                    <td class="tblBorder"></td>
                                    <td class="tblBorder">Screening Date:</td>
                                    <td class="tblBorder" colspan="2">
                                        <asp:TextBox ID="txtScreeingDate1" ClientIDMode="Static" runat="server" Width="120px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtScreeingDate1" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                                    </td>
                                    <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder">Hepatitis B Surface Ag:</td>
                                    <td class="tblBorder">
                                       <%-- <input type="text" id="txtHepatitiesBagpdv" />
                                       --%>
                                          <select id="selectHepatitiesBagpdv">
                                              
                                            <option value="0">--Select--</option>
                                            <option value="Positive">Positive</option>
                                            <option value="Negative">Negative</option>
                                        </select>
                                    </td>
                                    <td class="tblBorder"></td>
                                    <td class="tblBorder">Screening Date:</td>
                                    <td class="tblBorder" colspan="2">
                                        <asp:TextBox ID="txtScreeingDate2" ClientIDMode="Static" runat="server" Width="120px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtScreeingDate2" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                                    </td>
                                    <td class="tblBorder"></td>
                                </tr>

                                <tr>
                                    <td class="tblBorder">Hepatitis C Antibody:</td>
                                    <td class="tblBorder">
                                       <%-- <input type="text" id="txtHepatitiesCAntibodypdv" />--%>
                                        <select id="selectHepatitiesCAntibodypdv">
                                              
                                            <option value="0">--Select--</option>
                                            <option value="Positive">Positive</option>
                                            <option value="Negative">Negative</option>
                                        </select>
                                    </td>
                                    <td class="tblBorder"></td>
                                    <td class="tblBorder">Screening Date:</td>
                                    <td class="tblBorder" colspan="2">
                                        <asp:TextBox ID="txtScreeingDate3" ClientIDMode="Static" runat="server" Width="120px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtScreeingDate3" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                                    </td>
                                    <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder">Current HB:</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtCurrentHBpdv" /></td>
                                    <td class="tblBorder">g/dl</td>
                                    <td class="tblBorder">Date Done:</td>
                                    <td class="tblBorder" colspan="2">
                                        <asp:TextBox ID="txtDateDone" ClientIDMode="Static" runat="server" Width="120px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtDateDone" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                                    </td>
                                    <td class="tblBorder"></td>
                                </tr>
                            </table>

                        </div>
                        <div class="row tblBorder" style="text-align: center">
                            <input type="button" value="Save" id="btnprevital" onclick="saveHemodialysis_Pre_Dialysis_Vital()" />
                            <input type="button" value="Update" id="btnprevitalUp" style="display: none" onclick="UpdateHemodialysis_Pre_Dialysis_Vital()" />
                        </div>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory">
                <div style="cursor: pointer" id="divDialysisorder" onclick="togglePatientDetailSection(this)" class="Purchaseheader">
                    DIALYSIS ORDER
                </div>
                <div class="row divDialysisorder">
                    <div class="col-md-24">
                        <div class="row tblBorder">
                            <table width="100%">
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Vascular Access Type :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtVascularAccessType" /></td>
                                     <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Target UltraFiltration :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtTargetUltraFiltration" /></td>
                                    <td class="tblBorder">m/s</td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Duration/Time :</td>
                                    <td class="tblBorder">
                                        <%--<input type="text" id="txtDurationTime" class="Timetext" style="width: 20%" />--%>
                                        <input type="text" id="txtDurationTime"  style="width: 20%" />
                                    </td>
                                     <td class="tblBorder"></td>
                                </tr>

                                <tr>
                                    <td class="tblBorder" style="width: 30%">Treatment Type :</td>
                                    <td class="tblBorder">
<%--                                        <input type="text" id="txtTreatmentType" />--%>
                                        <select id="selectTreatmentType">
                                            <option value="0">--Select--</option>
                                            <option value="HDF Postdilution">HDF Postdilution</option>
                                            <option value="HD">HD</option>
                                            <option value="HDF Predilution">HDF Predilution</option>
                                            <option value="HF Predilution">HF Predilution</option>
                                            <option value="HF Postdilution">HF Postdilution</option>
                                        </select>

                                    </td>
                                     <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Blood Flow Rate :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtBloodFlowRate" /></td>
                                     <td class="tblBorder">ms/min</td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Priming :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtPriming" /></td>
                                    <td class="tblBorder"></td>
                                </tr>

                                <tr>
                                    <td class="tblBorder" style="width: 30%">Dialysis Solutions :</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtDialysisSolutions" /></td>
                                    <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Dialyser Type :</td>
                                    <td class="tblBorder">
                                        <%--<input type="text" id="txtDialyserType" />--%>
                                        <select id="selectDialyserType">
                                            <option value="0">--Select--</option>
                                            <option value="FX40">FX40</option>
                                            <option value="FX50">FX50</option>
                                            <option value="FX60">FX60</option>
                                            <option value="FX70">FX70</option>
                                            <option value="FX80">FX80</option>
                                            <option value="FX90">FX90</option>
                                            <option value="FX100">FX100</option>
                                        </select>

                                    </td>
                                    <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Membrane Type:</td>
                                    <td class="tblBorder">
                                        <%--<input type="text" id="txtMembraneType" />--%>
                                        <select id="selectMembraneType">
                                            <option value="0">--Select--</option>
                                            <option value="High Flux">High Flux</option>
                                            <option value="Low Flux">Low Flux</option>
                                            </select>

                                    </td>
                                    <td class="tblBorder"></td>
                                </tr>

                                <tr>
                                    <td class="tblBorder" style="width: 30%">Bath K<sup>+</sup>:</td>
                                    <td class="tblBorder">
                                        <input type="text" id="txtBathk" /></td>
                                    <td class="tblBorder">mmol/L</td>
                                </tr>


                                <tr>
                                    <td class="tblBorder" style="width: 30%">Heparinization :</td>
                                    <td class="tblBorder" colspan="1">
                                        <table width="100%">
                                            <tr>
                                                <td class="tblBorder">Loading Dose :</td>
                                                <td class="tblBorder">
                                                    <input type="text" id="txtLoadingDose" />
                                                </td>
                                                <td class="tblBorder">IU</td>
                                            </tr>
                                            <tr>
                                                <td class="tblBorder">Unit/Hour :</td>
                                                <td class="tblBorder">
                                                    <input type="text" id="txtUnitLitre" /></td>
                                                <td class="tblBorder">IU/Hr</td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td class="tblBorder" colspan="1">
                                       
                                    </td>

                                </tr>
                            </table>

                        </div>

                        <div class="row tblBorder" style="text-align: center">
                            <input type="button" value="Save" id="btnDialysisOrder" onclick="saveHemodialysis_Dialysis_Order()" />
                            <input type="button" value="Update" id="btnDialysisOrderUp" style="display: none" onclick="UpdateHemodialysis_Dialysis_Order()" />
                        </div>
                    </div>

                </div>

            </div>

            <div class="POuter_Box_Inventory">
                <div style="cursor: pointer" id="divmachinecheck" onclick="togglePatientDetailSection(this)" class="Purchaseheader">
                    MACHINE CHECK
                </div>
                <div class="row divmachinecheck">
                    <div class="col-md-24">
                        <div class="row tblBorder">
                            <table width="100%">
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Blood Leak Assessment :<input type="text" id="txtBloodLeakAccessMent" style="display:none;" /></td>
                                    <td class="tblBorder">Tested :</td>
                                    <td class="tblBorder">
                                        <%--<input type="text" id="txtBloodTested" />--%>
                                        <select id="selectBloodTested">
                                            <option value="0">--Select--</option>
                                            <option value="yes">Yes</option>
                                            <option value="No">No</option>
                                        </select>

                                    </td>
                                    <td class="tblBorder">On :</td>
                                    <td class="tblBorder">
                                        <%--<input type="text" id="txtBloodTestedOn" />--%>
                                           <asp:TextBox ID="txtBloodTestedOn" CssClass="" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtBloodTestedOn"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           


                                    </td>
                                    <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Air Detection :<input type="text" id="txtAirDetection"  style="display:none;" /></td>
                                    <td class="tblBorder">Tested : </td>
                                    <td class="tblBorder">
<%--                                        <input type="text" id="txtAirTested" />--%>
                                          <select id="selectAirTested">
                                            <option value="0">--Select--</option>
                                            <option value="yes">Yes</option>
                                            <option value="No">No</option>
                                        </select>
                                    </td>
                                    <td class="tblBorder">On : </td>
                                    <td class="tblBorder">
                                        <%--<input type="text" id="txtAirTestedOn" />--%>
                                         <asp:TextBox ID="txtAirTestedOn" CssClass="" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtAirTestedOn"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           

                                    </td>
                                    
                                    <td class="tblBorder"></td>
                                </tr>

                                <tr>
                                    <td class="tblBorder" style="width: 30%">Machine Number :</td>
                                    <td class="tblBorder" colspan="4">
                                        <input type="text" id="txtMachineNumber" /></td>
                                    
                                    <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Temperature :</td>
                                    <td class="tblBorder" colspan="4">
                                        <input type="text" id="txtTemprature" /></td>
                                    
                                    <td class="tblBorder">&deg; C</td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Conductivity :</td>
                                    <td class="tblBorder" colspan="4">
                                        <input type="text" id="txtConductivity" /></td>
                                    
                                    <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Staff Setting Machine :</td>
                                    <td class="tblBorder" colspan="4">
                                        <input type="text" id="txtStaffSettingMachine" /></td>
                                    
                                    <td class="tblBorder"></td>
                                </tr>
                                <tr>
                                    <td class="tblBorder" style="width: 30%">Nurse Commencing Dialysis :</td>
                                    <td class="tblBorder" colspan="4">
                                        <input type="text" id="txtNurseCommencingDialysis" /></td>
                                    
                                    <td class="tblBorder"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="row tblBorder" style="text-align: center">
                            <input type="button" value="Save" id="btnMachineCheck" onclick="saveHemodialysis_Machine_Check()" />
                            <input type="button" value="Update" id="btnMachineCheckUp" onclick="UpdateHemodialysis_Machine_Check()" />
                        </div>
                    </div>

                </div>

            </div>

            <div class="POuter_Box_Inventory">
                <div style="cursor: pointer" id="divdialysisexamination" onclick="togglePatientDetailSection(this)" class="Purchaseheader">
                    DIALYSIS EXAMINATION 
                </div>
                <div class="row divdialysisexamination">
                    <div class="col-md-24">
                        <div class="row txtUnderlineWithBold ">
                            HISTORY OF PRESENTING ILLNESS  

                        </div>
                        <div class="row  ">
                            <textarea id="txthistoryOfPresentingIllness" cols="10" rows="1"></textarea>
                        </div>
                        <div class="row  txtUnderlineWithBold">
                            PREVIOUS DIALYSIS HISTORY 

                        </div>
                        <div class="row  ">
                            <textarea id="txtPreviousDialysisHistory" cols="10" rows="1"></textarea>
                        </div>
                        <div class="row  txtUnderlineWithBold">
                            PATIENT ASSESSMENT 
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="row txtBold">
                                    CNS -
                                </div>
                                <div class="row  ">
                                    <textarea id="txtCns" cols="10" rows="1"></textarea>
                                </div>

                                <div class="row txtBold">
                                    CVS -
                                </div>
                                <div class="row  ">
                                    <textarea id="txtCVS" cols="10" rows="1"></textarea>
                                </div>

                                <div class="row txtBold">
                                    RESP -
                                </div>
                                <div class="row  ">
                                    <textarea id="txtResp" cols="10" rows="1"></textarea>
                                </div>

                                <div class="row txtBold">
                                    RENAL -
                                </div>
                                <div class="row  ">
                                    <textarea id="txtRenal" cols="10" rows="1"></textarea>
                                </div>


                                <div class="row txtBold">
                                    GIT -
                                </div>
                                <div class="row  ">
                                    <textarea id="txtGit" cols="10" rows="1"></textarea>
                                </div>

                                <div class="row txtBold">
                                    SKIN/EXTREMITIES -
                                </div>
                                <div class="row  ">
                                    <textarea id="txtSkinExtremities" cols="10" rows="1"></textarea>
                                </div>



                            </div>
                        </div>

                        <div class="row  txtUnderlineWithBold">
                            STATUS OF THE ACCESS
                        </div>

                        <div class="row  ">
                            <textarea id="txtStatusOfTheAccess" cols="10" rows="1"></textarea>
                        </div>

                        <div class="row  txtUnderlineWithBold">
                            NURSING DIAGNOSIS
                        </div>
                        <div class="row  ">
                            <textarea id="txtNurshingDiagnosis" cols="10" rows="1"></textarea>
                        </div>

                        <div class="row  txtUnderlineWithBold">
                            PLAN OF CARE / DRS ORDER
                        </div>
                        <div class="row  ">
                            <textarea id="txtPlanOfCare" cols="10" rows="1"></textarea>
                        </div>

                        <div class="row" style="text-align: center">
                            <input type="button" value="Save" id="btnDialysisExamination" onclick="saveHemodialysis_Dialysis_Examination()" />
                            <input type="button" value="Update" id="btnDialysisExaminationUp" onclick="UpdateHemodialysis_Dialysis_Examination()" style="display: none" />
                        </div>
                    </div>

                </div>

            </div>

            <div class="POuter_Box_Inventory">
                <div style="cursor: pointer" id="divintradylaticobservation" onclick="togglePatientDetailSection(this)" class="Purchaseheader">
                    INTRA-DIALYTIC OBSERVATION
                </div>
                <div class="row divintradylaticobservation">
                    <div class="col-md-24">
                        <div class="row tblBorder">
                            <div id="divOutput" style="max-height: 200px; overflow-y: auto; overflow-x: auto;">
                                <%-- <div id="divOutput" style="overflow-x: auto;">--%>
                                <table id="tblObservation" rules="all" border="1" style="border-collapse: collapse; width: 100%;" class="GridViewStyle">
                                    <thead>

                                        <tr>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center; width: 150px">TIME</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">BP</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">HR</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">TEMP</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">VP</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">AP</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">TMP</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">UF</th>

                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Heparin</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">BFR</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">REMARK</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Entry By</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center">ACTION</th>

                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="row tblBorder" style="text-align: center">
                            <input type="button" value="Save" id="btnIntraDialytic" onclick="saveHemodialysis_Intra_Dialytic_Observation()" />
                            <input type="button" value="Update" id="btnIntraDialyticUp" style="display: none" onclick="UpdateHemodialysis_Intra_Dialytic_Observation()" />
                        </div>
                    </div>

                </div>

            </div>

            <div class="POuter_Box_Inventory">
                <div style="cursor: pointer" id="divpostdylaticobservation" onclick="togglePatientDetailSection(this)" class="Purchaseheader">
                    POST-DIALYTIC OBSERVATION
                </div>
                <div class="row divpostdylaticobservation">
                    <div class="col-md-24 tblBorder">
                        <div class="row">
                            <div class="col-md-3">Hours Dialyzed :</div>
                            <div class="col-md-4">
                                <input type="text" id="txtPdHoureDialyzed" />
                                
                            </div>
                            
                            <div class="col-md-2">Hr/Min</div>
                            <div class="col-md-2">BP :</div>
                            <div class="col-md-4">
                                <input type="text" id="txtPDBp" />
                            </div>
                            
                            <div class="col-md-2">mmhg</div>
                            <div class="col-md-2">Pulse :</div>
                            <div class="col-md-4">
                                <input type="text" id="txtPDPulse" />
                            </div>
                            
                            <div class="col-md-1">b/m</div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">UF Achieved:</div>
                            <div class="col-md-4">
                                <%--<input type="text" id="txtPdAchieved" />--%>
                                <select id="selectPdAchieved">
                                    <option value="0">--Select--</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                </select>

                            </div>
                            
                            <div class="col-md-2"></div>
                            <div class="col-md-2">Weight :</div>
                            <div class="col-md-4">
                                <input type="text" id="txtPdWeight" />
                            </div>
                            
                            <div class="col-md-2">Kg</div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">Blood Transfusion :</div>
                            <div class="col-md-4">
<%--                                <input type="text" id="txtBloodTransfused" />--%>
                                <select id="selectBloodTransfused">
                                    <option value="0">--Select--</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                </select>
                            </div>
                            
                            <div class="col-md-2"></div>
                            <div class="col-md-4">Complication During Dialysis :</div>
                            <div class="col-md-4">
<%--                                <input type="text" id="txtPdDialysis" />--%>
                                <%--<select id="selectPdDialysis">
                                    <option value="0">--Select--</option>
                                    <option value="Yes">Yes</option>
                                    <option value="No">No</option>
                                    <option value="None">None</option>
                                </select>--%>
                                 <asp:RadioButtonList ID="rdbPdDialysis" runat="server" RepeatDirection="Horizontal" AutoPostBack="false" >
                                              <asp:ListItem Value="1">Yes</asp:ListItem>
                                          <asp:ListItem Value="2">No</asp:ListItem>
                                          <asp:ListItem Value="3">None</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
 
                            </div>
                            
                            <div class="col-md-2"></div>

                        </div>


                        <div class="row  txtUnderlineWithBold">
                            <div class="col-md-24 txtUnderlineWithBold">SPECIAL ORDER / DISCHARGE NOTES</div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <textarea id="txtSpecialOrder" cols="10" rows="1"></textarea>
                            </div>
                        </div>


                        <div class="row" style="text-align: center">
                            <input type="button" value="Save" id="btnPostDialytic" onclick="saveHemodialysis_Post_Dialytic_Observation()" />
                            <input type="button" value="Update" id="btnPostDialyticUp" style="display: none" onclick="UpdateHemodialysis_Post_Dialytic_Observation()" />
                        </div>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory">
				<div id="IPDOutput" style="height:326px;width:100%;overflow-y:auto"> </div>
		</div>


        </div>

    </form>


    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>


    <script type="text/javascript">

        $(document).ready(function () {
            bindGrid("");
            InitialSearch();
            $('.Timetext').timepicker({
                timeFormat: 'h:mm p',
                interval: 10,
                minTime: '00:01',
                maxTime: '11:59pm',
                defaultTime: new Date(),
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });
        });
        var togglePatientDetailSection = function (el, isForceHide, isForceShow) {
            var _divPatientBasicDetails = $(el).parent().find('.row:first');
            if (isForceHide && !isForceShow) {
                _divPatientBasicDetails.addClass('hidden');

            }
            else if (isForceShow && !isForceHide) {
                _divPatientBasicDetails.removeClass('hidden');

            }
            else {
                _divPatientBasicDetails.hasClass('hidden') ? _divPatientBasicDetails.removeClass('hidden') : _divPatientBasicDetails.addClass('hidden');


            }
        }

        function HideOrShowAllDivByDefault(Typ) {
            if (Typ == 1) {
                togglePatientDetailSection($('#divHemoDialysisFlowchart'), true, false);

                togglePatientDetailSection($('#divDialysisorder'), true, false);

                togglePatientDetailSection($('#divmachinecheck'), true, false);

                togglePatientDetailSection($('#divdialysisexamination'), true, false);

                togglePatientDetailSection($('#divintradylaticobservation'), true, false);

                togglePatientDetailSection($('#divpostdylaticobservation'), true, false);
            } else {
                togglePatientDetailSection($('#divHemoDialysisFlowchart'), false, true);

                togglePatientDetailSection($('#divDialysisorder'), false, true);

                togglePatientDetailSection($('#divmachinecheck'), false, true);

                togglePatientDetailSection($('#divdialysisexamination'), false, true);

                togglePatientDetailSection($('#divintradylaticobservation'), false, true);

                togglePatientDetailSection($('#divpostdylaticobservation'), false, true);
            }


        }



        function AddNewRow() {


            var row = "";

            row += '<tr>';


            row += '<td class="GridViewLabItemStyle" >  <input type="text" id="txtIntraTime" class="ItDoseTextinputText TimeField required" /></td>';
            row += '<td class="GridViewLabItemStyle" > <input id="txtBP" type="text"   /> </td>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtHR" type="text"   /> </td>';
            row += '<td class="GridViewLabItemStyle" > <input id="txtTemp" type="text"   /> </td>';
            row += '<td class="GridViewLabItemStyle" > <input id="txtVP" type="text"   /> </td>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtAP" type="text" /> </td>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtTMP" type="text"   /> </td>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtUF" type="text"  /> </td>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtHaparin" type="text"   /> </td>';

            row += '<td class="GridViewLabItemStyle" > <input id="txtBFR" type="text"   /> </td>';


            row += '<td class="GridViewLabItemStyle" > <input id="txtRemark" type="text" />  </td>';

            row += '<td class="GridViewLabItemStyle">' + '<%=Util.GetString(Session["EmployeeName"])%>' + '</td>';

            row += '<td class="GridViewLabItemStyle" style="display:none" > <input id="txtEntryBy" type="text" value="' + '<%=Util.GetString(Session["ID"])%>' + '" />  </td>';

            row += '<td class="GridViewLabItemStyle" ><img id="btnAddNewRow" class="clsbtnAddShow"  src="../../Images/plus_in.gif" style="cursor:pointer" onclick="AddNewRow()"> <img id="btnRemove" class="clsbtnRemoveShow"  src="../../Images/Delete.gif" style="cursor:pointer;" onclick="RemoveRow(this)">  </td>';


            row += '</tr>';


            $("#tblObservation tbody").append(row);

            $('.TimeField').timepicker({
                timeFormat: 'h:mm p',
                interval: 10,
                minTime: '00:01',
                maxTime: '11:59pm',
                defaultTime: new Date(),
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });

        }

        function RemoveRow(rowId) {
            $(rowId).closest("tr").remove();

            var rowCount = $('#tblObservation tbody tr').length;
            if (rowCount == 0) {
                AddNewRow();
            }
        }

        function DeletePreviousObservationRow() {
            $('#tblObservation tbody').empty();
        }
        // Hemodialysis_Pre_Dialysis_Vital Start Work

        function GetHemodialysis_Pre_Dialysis_VitalDetails() {
            var objRec = new Object();
            objRec.Id = $("#spnPreDialysisVitalId").text();
            objRec.PatientId = $("#spnPatientID").text();
            objRec.TransactionId = $("#spnTransactionID").text();
            objRec.PreviousWeight = $("#txtPreviousWeightpdv").val();
            objRec.CurrentWeight = $("#txtCurrentweightpdv").val();
            objRec.WeightGain = $("#txtWeightGainpdv").val();
            objRec.DryWeight = $("#txtDryWeightpdv").val();
            objRec.BloodGroup = $("#txtBloodGrouppdv").val();
            //objRec.HivTest = $("#txtHivpdv").val();
            objRec.HivTest = $("#selectHivpdv").val();

            //objRec.HepatitisBSurfaceAg = $("#txtHepatitiesBagpdv").val();
            objRec.HepatitisBSurfaceAg = $("#selectHepatitiesBagpdv").val();
            //objRec.HeapatitisCAntiBody = $("#txtHepatitiesCAntibodypdv").val();
            objRec.HeapatitisCAntiBody = $("#selectHepatitiesCAntibodypdv").val();
            objRec.BP = $("#txtBPpdv").val();
            objRec.Pulse = $("#txtPulsepdv").val();
            objRec.Resp = $("#txtResppdv").val();
            objRec.Spo2 = $("#txtSPO2pdv").val();
            objRec.Temp = $("#txtTemppdv").val();
            objRec.RBS = $("#txtRBSpdv").val();
            objRec.ScreeingDate1 = $("#txtScreeingDate1").val();
            objRec.ScreeingDate2 = $("#txtScreeingDate2").val();
            objRec.ScreeingDate3 = $("#txtScreeingDate3").val();
            objRec.DateDone = $("#txtDateDone").val();
            objRec.CurrentHB = $("#txtCurrentHBpdv").val();
            objRec.Diagnosis = $("#txtDiagnosis").val();

            return objRec;
        }


        function saveHemodialysis_Pre_Dialysis_Vital() {
            var resultVital = GetHemodialysis_Pre_Dialysis_VitalDetails();
            serverCall('HomoDialysis.aspx/saveHemodialysis_Pre_Dialysis_Vital', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Pre_Dialysis_Vital();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function UpdateHemodialysis_Pre_Dialysis_Vital() {
            var resultVital = GetHemodialysis_Pre_Dialysis_VitalDetails();
            serverCall('HomoDialysis.aspx/UpdateHemodialysis_Pre_Dialysis_Vital', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Pre_Dialysis_Vital();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function GetHemodialysis_Pre_Dialysis_Vital() {
            serverCall('HomoDialysis.aspx/GetHemodialysis_Pre_Dialysis_Vital', { Pid: $("#spnPatientID").text(), Tid: $("#spnTransactionID").text() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var Resdata = responseData.data;
                    $("#spnPreDialysisVitalId").text(Resdata[0].Id);
                    $("#txtPreviousWeightpdv").val(Resdata[0].PreviousWeight);
                    $("#txtCurrentweightpdv").val(Resdata[0].CurrentWeight);
                    $("#txtWeightGainpdv").val(Resdata[0].WeightGain);
                    $("#txtDryWeightpdv").val(Resdata[0].DryWeight);
                    $("#txtBloodGrouppdv").val(Resdata[0].BloodGroup);
                    //$("#txtHivpdv").val(Resdata[0].HivTest);
                    $("#selectHivpdv").val(Resdata[0].HivTest);
                    
                    // $("#txtHepatitiesBagpdv").val(Resdata[0].HepatitisBSurfaceAg);
                    $("#selectHepatitiesBagpdv").val(Resdata[0].HepatitisBSurfaceAg);
                    //$("#txtHepatitiesCAntibodypdv").val(Resdata[0].HeapatitisCAntiBody);
                    $("#selectHepatitiesCAntibodypdv").val(Resdata[0].HeapatitisCAntiBody);
                    $("#txtBPpdv").val(Resdata[0].BP);
                    $("#txtPulsepdv").val(Resdata[0].Pulse);
                    $("#txtResppdv").val(Resdata[0].Resp);
                    $("#txtSPO2pdv").val(Resdata[0].Spo2);
                    $("#txtTemppdv").val(Resdata[0].Temp);
                    $("#txtRBSpdv").val(Resdata[0].RBS);
                    $("#txtScreeingDate1").val(Resdata[0].ScreeingDate1);
                    $("#txtScreeingDate2").val(Resdata[0].ScreeingDate2);
                    $("#txtScreeingDate3").val(Resdata[0].ScreeingDate3);
                    $("#txtDateDone").val(Resdata[0].DateDone);
                    $("#txtCurrentHBpdv").val(Resdata[0].CurrentHB);
                    $("#txtDiagnosis").val(Resdata[0].Diagnosis);

                    BtnPre_Dialysis_Vital_HideShow(1);
                }
                else {
                    $("#spnPreDialysisVitalId").text(0);
                    $("#txtPreviousWeightpdv").val("");
                    $("#txtCurrentweightpdv").val("");
                    $("#txtWeightGainpdv").val("");
                    $("#txtDryWeightpdv").val("");
                    $("#txtBloodGrouppdv").val("");
                    //$("#txtHivpdv").val("");
                    $("#selectHivpdv").val("");
                    //$("#txtHepatitiesBagpdv").val("");
                    $("#selectHepatitiesBagpdv").val("");
                    //$("#txtHepatitiesCAntibodypdv").val("");
                    $("#selectHepatitiesCAntibodypdv").val("");
                    $("#txtBPpdv").val("");
                    $("#txtPulsepdv").val("");
                    $("#txtResppdv").val("");
                    $("#txtSPO2pdv").val("");
                    $("#txtTemppdv").val("");
                    $("#txtRBSpdv").val("");
                    $("#txtCurrentHBpdv").val("");

                    BtnPre_Dialysis_Vital_HideShow(0);
                }

            });
        }

        function BtnPre_Dialysis_Vital_HideShow(Typ) {

            if (Typ == 0) {
                $("#btnprevital").show();
                $("#btnprevitalUp").hide();

            } else {
                $("#btnprevital").hide();
                $("#btnprevitalUp").show();

            }
        }
        // Hemodialysis_Pre_Dialysis_Vital End Work


        // Hemodialysis_Dialysis_Order Start Work

        function GetHemodialysis_Dialysis_OrderDetails() {
            var objRec = new Object();
            objRec.Id = $("#spnDialysisOrderId").text();
            objRec.PatientId = $("#spnPatientID").text();
            objRec.TransactionId = $("#spnTransactionID").text();


            objRec.VascularAccessType = $("#selectVascularAccessType").val();
            objRec.TargetUltraFiltration = $("#txtTargetUltraFiltration").val();
            objRec.Duration = $("#txtDurationTime").val();
            // objRec.TreatmentType = $("#txtTreatmentType").val();
            objRec.TreatmentType = $("#selectTreatmentType").val();
            objRec.BloodFlowRate = $("#txtBloodFlowRate").val();
            objRec.Priming = $("#txtPriming").val();
            objRec.DialysisSolution = $("#txtDialysisSolutions").val();
            objRec.DialyserType = $("#selectDialyserType").val();
            objRec.MembraneType = $("#selectMembraneType").val();
            objRec.BathK = $("#txtBathk").val();
            objRec.LoadingDose = $("#txtLoadingDose").val();
            objRec.UnitLitre = $("#txtUnitLitre").val();

            return objRec;
        }


        function saveHemodialysis_Dialysis_Order() {
            var resultVital = GetHemodialysis_Dialysis_OrderDetails();
            serverCall('HomoDialysis.aspx/saveHemodialysis_Dialysis_Order', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Dialysis_Order();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function UpdateHemodialysis_Dialysis_Order() {
            var resultVital = GetHemodialysis_Dialysis_OrderDetails();
            serverCall('HomoDialysis.aspx/UpdateHemodialysis_Dialysis_Order', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Dialysis_Order();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function GetHemodialysis_Dialysis_Order() {
            serverCall('HomoDialysis.aspx/GetHemodialysis_Dialysis_Order', { Pid: $("#spnPatientID").text(), Tid: $("#spnTransactionID").text() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var Resdata = responseData.data;
                    $("#spnDialysisOrderId").text(Resdata[0].Id);

                    $("#selectVascularAccessType").val(Resdata[0].VascularAccessType);
                    $("#txtTargetUltraFiltration").val(Resdata[0].TargetUltraFiltration);
                    $("#txtDurationTime").val(Resdata[0].Duration);
                    //$("#txtTreatmentType").val(Resdata[0].TreatmentType);
                    $("#selectTreatmentType").val(Resdata[0].TreatmentType);
                    $("#txtBloodFlowRate").val(Resdata[0].BloodFlowRate);
                    $("#txtPriming").val(Resdata[0].Priming);
                    $("#txtDialysisSolutions").val(Resdata[0].DialysisSolution);
                    $("#selectDialyserType").val(Resdata[0].DialyserType);
                    $("#selectMembraneType").val(Resdata[0].MembraneType);
                    $("#txtBathk").val(Resdata[0].BathK);
                    $("#txtLoadingDose").val(Resdata[0].LoadingDose);
                    $("#txtUnitLitre").val(Resdata[0].UnitLitre);

                    BtnHemodialysis_Dialysis_Order_HideShow(1);
                }
                else {
                    $("#spnDialysisOrderId").text(0);

                    $("#selectVascularAccessType").val("");
                    $("#txtTargetUltraFiltration").val("");
                    $("#txtDurationTime").val("");
                    //$("#txtTreatmentType").val("");
                    $("#selectTreatmentType").val("");
                    $("#txtBloodFlowRate").val("");
                    $("#txtPriming").val("");
                    $("#txtDialysisSolutions").val("");
                    $("#selectDialyserType").val("");
                    $("#selectMembraneType").val("");
                    $("#txtBathk").val("");
                    $("#txtLoadingDose").val("");
                    $("#txtUnitLitre").val("");
                    BtnHemodialysis_Dialysis_Order_HideShow(0);
                }

            });
        }


        function BtnHemodialysis_Dialysis_Order_HideShow(Typ) {

            if (Typ == 0) {
                $("#btnDialysisOrder").show();
                $("#btnDialysisOrderUp").hide();

            } else {
                $("#btnDialysisOrder").hide();
                $("#btnDialysisOrderUp").show();

            }
        }

        // Hemodialysis_Dialysis_Order End Work

        // Hemodialysis_Machine_Check Start Work

        function GetHemodialysis_Machine_CheckDetails() {
            var objRec = new Object();
            objRec.Id = $("#spnMachineCheckId").text();
            objRec.PatientId = $("#spnPatientID").text();
            objRec.TransactionId = $("#spnTransactionID").text();


            objRec.BloodLeakAssessment = $("#txtBloodLeakAccessMent").val();
            objRec.BloodTested = $("#selectBloodTested").val();
            objRec.BloodTestedOn = $("#txtBloodTestedOn").val();
            objRec.AirDetaction = $("#txtAirDetection").val();
            objRec.AirTested = $("#selectAirTested").val();
            objRec.AirTestedOn = $("#txtAirTestedOn").val();
            objRec.MachineNumber = $("#txtMachineNumber").val();
            objRec.Temprature = $("#txtTemprature").val();
            objRec.Conductivity = $("#txtConductivity").val();
            objRec.StaffSettingMachine = $("#txtStaffSettingMachine").val();
            objRec.NureseCommencingDialysis = $("#txtNurseCommencingDialysis").val();

            return objRec;
        }


        function saveHemodialysis_Machine_Check() {
            var resultVital = GetHemodialysis_Machine_CheckDetails();
            serverCall('HomoDialysis.aspx/saveHemodialysis_Machine_Check', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Machine_Check();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function UpdateHemodialysis_Machine_Check() {
            var resultVital = GetHemodialysis_Machine_CheckDetails();
            serverCall('HomoDialysis.aspx/UpdateHemodialysis_Machine_Check', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Machine_Check();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function GetHemodialysis_Machine_Check() {
            serverCall('HomoDialysis.aspx/GetHemodialysis_Machine_Check', { Pid: $("#spnPatientID").text(), Tid: $("#spnTransactionID").text() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var Resdata = responseData.data;
                    $("#spnMachineCheckId").text(Resdata[0].Id);

                    $("#txtBloodLeakAccessMent").val(Resdata[0].BloodLeakAssessment);
                    $("#selectBloodTested").val(Resdata[0].BloodTested);
                    $("#txtBloodTestedOn").val(Resdata[0].BloodTestedOn1);
                    $("#txtAirDetection").val(Resdata[0].AirDetaction);
                    $("#selectAirTested").val(Resdata[0].AirTested);
                    $("#txtAirTestedOn").val(Resdata[0].AirTestedOn1);
                    $("#txtMachineNumber").val(Resdata[0].MachineNumber);
                    $("#txtTemprature").val(Resdata[0].Temprature);
                    $("#txtConductivity").val(Resdata[0].Conductivity);
                    $("#txtStaffSettingMachine").val(Resdata[0].StaffSettingMachine);
                    $("#txtNurseCommencingDialysis").val(Resdata[0].NureseCommencingDialysis);

                    BtnHemodialysis_Machine_CheckHideShow(1);
                }
                else {
                    $("#spnMachineCheckId").text(0);

                    $("#txtBloodLeakAccessMent").val("");
                    $("#selectBloodTested").val("");
                    $("#txtBloodTestedOn").val("");
                    $("#txtAirDetection").val("");
                    $("#selectAirTested").val("");
                    $("#txtAirTestedOn").val("");
                    $("#txtMachineNumber").val("");
                    $("#txtTemprature").val("");
                    $("#txtConductivity").val("");
                    $("#txtStaffSettingMachine").val("");
                    $("#txtNurseCommencingDialysis").val("");

                    BtnHemodialysis_Machine_CheckHideShow(0);
                }

            });
        }


        function BtnHemodialysis_Machine_CheckHideShow(Typ) {

            if (Typ == 0) {
                $("#btnMachineCheck").show();
                $("#btnMachineCheckUp").hide();

            } else {
                $("#btnMachineCheck").hide();
                $("#btnMachineCheckUp").show();

            }
        }



        // Hemodialysis_Machine_Check Start Work

        // Hemodialysis_Dialysis_Examination Start Work

        function GetHemodialysis_Dialysis_ExaminationDetails() {
            var objRec = new Object();
            objRec.Id = $("#spnDialysisExaminationId").text();
            objRec.PatientId = $("#spnPatientID").text();
            objRec.TransactionId = $("#spnTransactionID").text();

            objRec.HistoryOfPresentingIllness = $("#txthistoryOfPresentingIllness").val();
            objRec.PreviousDialysisHistory = $("#txtPreviousDialysisHistory").val();
            objRec.CNS = $("#txtCns").val();
            objRec.CVS = $("#txtCVS").val();
            objRec.Resp = $("#txtResp").val();
            objRec.Renal = $("#txtRenal").val();
            objRec.Git = $("#txtGit").val();
            objRec.Skin = $("#txtSkinExtremities").val();
            objRec.StatusOfTheAccess = $("#txtStatusOfTheAccess").val();
            objRec.NurshingDiagnosis = $("#txtNurshingDiagnosis").val();
            objRec.PlanOfCare = $("#txtPlanOfCare").val();
            return objRec;
        }


        function saveHemodialysis_Dialysis_Examination() {
            var resultVital = GetHemodialysis_Dialysis_ExaminationDetails();
            serverCall('HomoDialysis.aspx/saveHemodialysis_Dialysis_Examination', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Dialysis_Examination();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function UpdateHemodialysis_Dialysis_Examination() {
            var resultVital = GetHemodialysis_Dialysis_ExaminationDetails();
            serverCall('HomoDialysis.aspx/UpdateHemodialysis_Dialysis_Examination', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Dialysis_Examination();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function GetHemodialysis_Dialysis_Examination() {
            serverCall('HomoDialysis.aspx/GetHemodialysis_Dialysis_Examination', { Pid: $("#spnPatientID").text(), Tid: $("#spnTransactionID").text() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var Resdata = responseData.data;
                    $("#spnDialysisExaminationId").text(Resdata[0].Id);
                    $("#txthistoryOfPresentingIllness").val(Resdata[0].HistoryOfPresentingIllness);
                    $("#txtPreviousDialysisHistory").val(Resdata[0].PreviousDialysisHistory);
                    $("#txtCns").val(Resdata[0].CNS);
                    $("#txtCVS").val(Resdata[0].CVS);
                    $("#txtResp").val(Resdata[0].Resp);
                    $("#txtRenal").val(Resdata[0].Renal);
                    $("#txtGit").val(Resdata[0].Git);
                    $("#txtSkinExtremities").val(Resdata[0].Skin);
                    $("#txtStatusOfTheAccess").val(Resdata[0].StatusOfTheAccess);
                    $("#txtNurshingDiagnosis").val(Resdata[0].NurshingDiagnosis);
                    $("#txtPlanOfCare").val(Resdata[0].PlanOfCare);

                    BtnHemodialysis_Dialysis_ExaminationHideShow(1);
                }
                else {
                    $("#spnDialysisExaminationId").text(0);
                    $("#txthistoryOfPresentingIllness").val("");
                    $("#txtPreviousDialysisHistory").val("");
                    $("#txtCns").val("");
                    $("#txtCVS").val("");
                    $("#txtResp").val("");
                    $("#txtRenal").val("");
                    $("#txtGit").val("");
                    $("#txtSkinExtremities").val("");
                    $("#txtStatusOfTheAccess").val("");
                    $("#txtNurshingDiagnosis").val("");
                    $("#txtPlanOfCare").val("");

                    BtnHemodialysis_Dialysis_ExaminationHideShow(0);
                }

            });
        }


        function BtnHemodialysis_Dialysis_ExaminationHideShow(Typ) {

            if (Typ == 0) {
                $("#btnDialysisExamination").show();
                $("#btnDialysisExaminationUp").hide();

            } else {
                $("#btnDialysisExamination").hide();
                $("#btnDialysisExaminationUp").show();

            }
        }

        // Hemodialysis_Dialysis_Examination Start Work


        // Hemodialysis_Post_Dialytic_Observation Start Work

        function GetHemodialysis_Post_Dialytic_ObservationDetails() {
            var objRec = new Object();
            objRec.Id = $("#spnPostDialyticObservationId").text();
            objRec.PatientId = $("#spnPatientID").text();
            objRec.TransactionId = $("#spnTransactionID").text();

            objRec.HoursDialyzed = $("#txtPdHoureDialyzed").val();
            objRec.BP = $("#txtPDBp").val();
            objRec.Pulse = $("#txtPDPulse").val();
            objRec.UFAchieved = $("#selectPdAchieved").val();
            objRec.Weight = $("#txtPdWeight").val();
            objRec.BloodTransfusion = $("#selectBloodTransfused").val();
            // objRec.ComplicationDuringDialysis = $("#selectPdDialysis").val();
            objRec.ComplicationDuringDialysis =$('#rdbPdDialysis input:checked').val() ;

            objRec.SpecialOrder = $("#txtSpecialOrder").val();

            return objRec;
        }


        function saveHemodialysis_Post_Dialytic_Observation() {
            var resultVital = GetHemodialysis_Post_Dialytic_ObservationDetails();
            serverCall('HomoDialysis.aspx/saveHemodialysis_Post_Dialytic_Observation', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Post_Dialytic_Observation();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function UpdateHemodialysis_Post_Dialytic_Observation() {
            var resultVital = GetHemodialysis_Post_Dialytic_ObservationDetails();
            serverCall('HomoDialysis.aspx/UpdateHemodialysis_Post_Dialytic_Observation', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Post_Dialytic_Observation();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function GetHemodialysis_Post_Dialytic_Observation() {
            serverCall('HomoDialysis.aspx/GetHemodialysis_Post_Dialytic_Observation', { Pid: $("#spnPatientID").text(), Tid: $("#spnTransactionID").text() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var Resdata = responseData.data;
                    $("#spnPostDialyticObservationId").text(Resdata[0].Id);

                    $("#txtPdHoureDialyzed").val(Resdata[0].HoursDialyzed);
                    $("#txtPDBp").val(Resdata[0].BP);
                    $("#txtPDPulse").val(Resdata[0].Pulse);
                    $("#selectPdAchieved").val(Resdata[0].UFAchieved);
                    $("#txtPdWeight").val(Resdata[0].Weight);
                    $("#selectBloodTransfused").val(Resdata[0].BloodTransfusion);
                    //$("#selectPdDialysis").val(Resdata[0].ComplicationDuringDialysis);
                    $('#<%=rdbPdDialysis.ClientID %>').find("input[value='" + Resdata[0].ComplicationDuringDialysis + "']").attr("checked", "checked");
                    $("#txtSpecialOrder").val(Resdata[0].SpecialOrder);

                    BtnHemodialysis_Post_Dialytic_ObservationHideShow(1);
                }
                else {
                    $("#spnPostDialyticObservationId").text(0);

                    $("#txtPdHoureDialyzed").val("");
                    $("#txtPDBp").val("");
                    $("#txtPDPulse").val("");
                    $("#selectPdAchieved").val("");
                    $("#txtPdWeight").val("");
                    $("#selectBloodTransfused").val("");
                    $("#rdbPdDialysis").val("");
                    $("#txtSpecialOrder").val("");

                    BtnHemodialysis_Post_Dialytic_ObservationHideShow(0);
                }

            });
        }


        function BtnHemodialysis_Post_Dialytic_ObservationHideShow(Typ) {

            if (Typ == 0) {
                $("#btnPostDialytic").show();
                $("#btnPostDialyticUp").hide();

            } else {
                $("#btnPostDialytic").hide();
                $("#btnPostDialyticUp").show();

            }
        }

        //Hemodialysis_Post_Dialytic_Observation End Work 

        // Hemodialysis_Intra_Dialytic_Observation Start Work

        function GetHemodialysis_Intra_Dialytic_ObservationDetails() {
            var dataObservation = new Array();
            var objObs = new Object();
            $("#tblObservation tbody tr").each(function () {
                
                var $rowid = $(this).closest("tr");
                if ($("#spanId").text() != "") {

                    objObs.Id = $("#spanId").text();
                }
                else {
                    objObs.Id = 0;
                }
                objObs.PatientId = $("#spnPatientID").text();
                objObs.TransactionId = $("#spnTransactionID").text();

                objObs.Time = $.trim($rowid.find("#txtIntraTime").val());
                objObs.BP = $.trim($rowid.find("#txtBP").val());
                objObs.Temp = $.trim($rowid.find("#txtTemp").val());
                objObs.HR = $.trim($rowid.find("#txtHR").val());
                objObs.VP = $.trim($rowid.find("#txtVP").val());
                objObs.AP = $.trim($rowid.find("#txtAP").val());
                objObs.TMP = $.trim($rowid.find("#txtTMP").val());
                
                objObs.UF = $.trim($rowid.find("#txtUF").val());
                objObs.Heparin = $.trim($rowid.find("#txtHaparin").val());
                objObs.BFR = $.trim($rowid.find("#txtBFR").val());
                 

                objObs.Remark = $.trim($rowid.find("#txtRemark").val());
                objObs.EntryBy = $.trim($rowid.find("#txtEntryBy").val());
                objObs.EntryName = $.trim($rowid.find("#spanEntryName").text());
                

                dataObservation.push(objObs);
                objObs = new Object();


            });
            return dataObservation;
        }



        function saveHemodialysis_Intra_Dialytic_Observation() {
            var resultVital = GetHemodialysis_Intra_Dialytic_ObservationDetails();
            serverCall('HomoDialysis.aspx/saveHemodialysis_Intra_Dialytic_Observation', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Post_Dialytic_Observation();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function UpdateHemodialysis_Intra_Dialytic_Observation() {
            var resultVital = GetHemodialysis_Intra_Dialytic_ObservationDetails();
            serverCall('HomoDialysis.aspx/UpdateHemodialysis_Intra_Dialytic_Observation', { Vital: resultVital }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    modelAlert(GetData.response, function () {
                        GetHemodialysis_Post_Dialytic_Observation();
                    });

                } else {
                    modelAlert(GetData.response);
                }


            });
        }

        function GetHemodialysis_Intra_Dialytic_Observation() {
            serverCall('HomoDialysis.aspx/GetHemodialysis_Intra_Dialytic_Observation', { Pid: $("#spnPatientID").text(), Tid: $("#spnTransactionID").text() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var Resdata = responseData.data;
                    bindNewrow(Resdata);
                    BtnHemodialysis_Intra_Dialytic_ObservationHideShow(1);
                }
                else {
                    DeletePreviousObservationRow();
                    AddNewRow();
                    BtnHemodialysis_Intra_Dialytic_ObservationHideShow(0);
                }

            });
        }
        function bindGrid(id) {
            $.ajax({
                type: "POST",
                url: "HomoDialysis.aspx/BindGrid",
                data: '{Id:"' + id + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    IPD = jQuery.parseJSON(response.d);
                    if (IPD != null) {
                        var output = $('#tb_Search').parseTemplate(IPD);
                        $('#IPDOutput').html(output).customFixedHeader();
                        //$('#divAppointmentDetails').customFixedHeader();
                        $('#IPDOutput').show();

                    }

                },
                error: function (xhr, status) {
                    $("#btnSearch").val('Search').removeAttr("disabled");
                }
            });
        }

      
        function bindNewrow(data) {

            DeletePreviousObservationRow();
            $.each(data, function (i, item) {

                var row = "";
                 
                row += '<tr>';

                row += '<td class="GridViewLabItemStyle" > <span id="spanId" style="display:none;" >'+item.Id+'</span> <input type="text" id="txtIntraTime" class="ItDoseTextinputText TimeField required" value="'+item.Time+'" /></td>';
                row += '<td class="GridViewLabItemStyle" > <input id="txtBP" type="text"   value="'+item.BP+'" /> </td>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtHR" type="text"  value="'+item.HR+'"  /> </td>';
                row += '<td class="GridViewLabItemStyle" > <input id="txtTemp" type="text"   value="'+item.Temp+'" /> </td>';
                row += '<td class="GridViewLabItemStyle" > <input id="txtVP" type="text"  value="'+item.VP+'"  /> </td>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtAP" type="text" value="'+item.AP+'" /> </td>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtTMP" type="text"  value="'+item.TMP+'"  /> </td>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtUF" type="text"  value="'+item.UF+'" /> </td>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtHaparin" type="text"  value="'+item.Heparin+'"  /> </td>';

                row += '<td class="GridViewLabItemStyle" > <input id="txtBFR" type="text"   value="'+item.BFR+'" /> </td>';


                row += '<td class="GridViewLabItemStyle" > <input id="txtRemark" type="text" value="'+item.REMARK+'" />  </td>';

                row += '<td class="GridViewLabItemStyle"><span id="spanEntryName">'+item.EntryByName+'</span></td>';

                row += '<td class="GridViewLabItemStyle" style="display:none" > <input id="txtEntryBy" type="text" value="' + item.EntryBy + '" />  </td>';
                if ((i + 1) == data.length) {
                    row += '<td class="GridViewLabItemStyle" ><img id="btnAddNewRow" class="clsbtnAddShow"  src="../../Images/plus_in.gif" style="cursor:pointer" onclick="AddNewRow()"> <img id="btnRemove" class="clsbtnRemoveShow"  src="../../Images/Delete.gif" style="cursor:pointer;" onclick="RemoveRow(this)">  </td>';

                }
                else {
                    row += '<td class="GridViewLabItemStyle" ><img id="btnAddNewRow" class="clsbtnAddShow"  src="../../Images/plus_in.gif" style="cursor:pointer;" onclick="AddNewRow()"  > <img id="btnRemove" class="clsbtnRemoveShow"  src="../../Images/Delete.gif" style="cursor:pointer;" onclick="RemoveRow(this)">  </td>';

                }

                row += '</tr>';


                $("#tblObservation tbody").append(row);
            });


            $('.TimeField').timepicker({
                timeFormat: 'h:mm p',
                interval: 10,
                minTime: '00:01',
                maxTime: '11:59pm',
                // defaultTime: new Date(),
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });

        }


        function BtnHemodialysis_Intra_Dialytic_ObservationHideShow(Typ) {

            if (Typ == 0) {
                $("#btnIntraDialytic").show();
                $("#btnIntraDialyticUp").hide();

            } else {
                $("#btnIntraDialytic").hide();
                $("#btnIntraDialyticUp").show();

            }
        }

        //Hemodialysis_Intra_Dialytic_Observation End Work 

    </script>

    <script type="text/javascript">
        function InitialSearch() {
            HideOrShowAllDivByDefault(1);
            AddNewRow();
            BtnPre_Dialysis_Vital_HideShow(0);
            GetHemodialysis_Pre_Dialysis_Vital();
            GetHemodialysis_Dialysis_Order();
            GetHemodialysis_Machine_Check();
            GetHemodialysis_Dialysis_Examination();
            GetHemodialysis_Post_Dialytic_Observation();
            GetHemodialysis_Intra_Dialytic_Observation();
        }

    </script>
    <script id="tb_Search" type="text/html">
		<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdIPD" style="width:100%;border-collapse:collapse;">
			<thead>
			<tr id="Header">
                <th class="GridViewHeaderStyle" scope="col">Sr. No</th>
                <th class="GridViewHeaderStyle"  scope="col" style="display:none;" >Entry By</th>
				<th class="GridViewHeaderStyle" scope="col" >Entry Date</th>
				<th class="GridViewHeaderStyle" scope="col">Print</th>
			</tr>
				</thead>
			<#       
				var dataLength=IPD.length;
				window.status="Total Records Found :"+ dataLength;
				var objRow;   
				
				for(var j=0;j<dataLength;j++)
				{       
					objRow = IPD[j];
			#>
			<tbody>
			<tr >  
				
                <td class="GridViewLabItemStyle" id="td1" ><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdTeamName"  style="display:none;"><#=objRow.EntryBy1#></td>     
				<td class="GridViewLabItemStyle" id="tdPatientCode" ><#=objRow.EntryDate1#></td> 
                <td class="GridViewLabItemStyle" >
					<img alt="Select" src="../../Images/print.gif" style="cursor:pointer"  onclick="window.open('./HomoDialysis_PDF.aspx?date=<#=objRow.EntryDate1#>&TestID=O23&LabType=&LabreportType=11&ID=')" />
				</td>
				                                                                    
			</tr>     
			</tbody>      
			<#}#>       
        </table>    
	</script>
</body>
</html>

