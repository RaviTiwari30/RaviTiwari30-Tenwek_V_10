<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdultFallAssessmenttool.aspx.cs" Inherits="Design_IPD_AdultFallAssessmenttool" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
   
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>HARRIS 2 - ADULT FALL RISK ASSESSMENT SCORING TOOL</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="col-md-24">
                    <div class="row">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Time
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTime" runat="server" Width="90px"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A-AM/P-PM)</span></em>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Age
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlAge" title="choose only 1- will be consistent throughout patient’s stay">
                                    <option value="">Select</option>
                                    <option value="0">Less Than 60 years old (0 to 59)</option>
                                    <option value="1">80 or more years old</option>
                                    <option value="2">60-69 years old</option>
                                    <option value="3">70-79 years old (less likely age to request help)</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Mental Status</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlMentalStatus" title="choose only 1- this may vary throughout the patient’s stay">
                                    <option value="">Select</option>
                                    <option value="0">Oriented at all times or comatose</option>
                                    <option value="2">Confusion at all times</option>
                                    <option value="3">Inability to understand and follow directions</option>
                                    <option value="4">Night Time disorientation/ intermittent confusion </option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Length of Stay</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlLengthofStay">
                                    <option value="">Select</option>
                                    <option value="0">Greater than 7 days</option>
                                    <option value="1">4-7 days</option>
                                    <option value="2">0-3 days</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Elimination</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlElimination">
                                    <option value="">Select</option>
                                    <option value="0">Independent and continent</option>
                                    <option value="1">Catheter and / or ostomy</option>
                                    <option value="3">Elimination with assistance</option>
                                    <option value="5">Independent and incontinent</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Impairment</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlImpairment">
                                    <option value="">Select</option>
                                    <option value="0">No impairments known</option>
                                    <option value="1">Mild visual or hearing impairment </option>
                                    <option value="2">Moderate visual or hearing impairment </option>
                                    <option value="3">Confined to bed / chair </option>
                                    <option value="4">Blind or Deaf</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Blood pressure</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlBloodPressure">
                                    <option value="">Select</option>
                                    <option value="0">Blood pressure WNL</option>
                                    <option value="1">Systolic BP consistently Less than 90 </option>
                                    <option value="2">BP of Greater than 20mm Hg with change of position</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>
                        <div class="row" style="border:groove">
                            <div class="col-md-3">
                                <label class="pull-left">Gait & Mobi.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21" style="text-align: left;">
                                <div class="row">
                                    <div class="col-md-12">
                                        <input type="checkbox" id="chkG_Diagnosis" value="5" />
                                        <label id="lblDiagnosis">Diagnosis related to a fall during admission</label>

                                    </div>
                                    <div class="col-md-12">
                                        <input type="checkbox" id="chkG_History" value="5" />
                                        <label id="lblHistory">History of 1 or more falls within last 6 months</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <input type="checkbox" id="chkG_LosswitoutHold" value="1" />
                                        <label id="lblLossWithoutHold">Loss of balance while standing for 30 seconds without holding onto something</label>
                                    </div>
                                    <div class="col-md-12">
                                        <input type="checkbox" id="chkG_LossStraight" value="1" />
                                        <label id="lblLossStraight">Loss of balance while walking straight or turning</label>
                                    </div>
                                </div>
                               	
                                <div class="row">
                                    <div class="col-md-12">
                                        <input type="checkbox" id="chkG_Decreased" value="1" />
                                        <label id="lblDecreased"> Decreased muscular coordination</label>
                                    </div>
                                     <div class="col-md-12">
                                        <input type="checkbox" id="chkG_Lurching" value="1" />
                                        <label id="lblLurching">Lurching, swaying, shuffling gait</label>
                                    </div>
                                </div>
                                <div class="row">
                                  
                                    <div class="col-md-12">
                                        <input type="checkbox" id="chkg_UsesCane" value="1" />
                                        <label id="lblUsesCane">Uses cane / walker / crutches</label>
                                    </div>
                                    <div class="col-md-12">
                                        <input type="checkbox" id="chkG_Holds" value="1" />
                                        <label id="lblHolds">Holds onto furniture / doorways for support</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <input type="checkbox" id="chkg_WideBase" value="1" />
                                        <label id="lblWideBase">Wide base of support</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row" style="border:groove">
                            <div class="col-md-3">
                                <label class="pull-left">Medications/ Alcohol  in past 24 hours</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21" style="text-align: left;">
                                <div class="row">
                                    <div class="col-md-5">
                                        <input type="checkbox" id="chkM_Alcohol" value="1" />
                                        <label id="lblAlcohol">Alcohol</label>
                                    </div>
                                    <div class="col-md-8">
                                        <input type="checkbox" id="chkM_Post" value="1" />
                                        <label id="lblMpost">Post general anesthesia</label>
                                    </div>
                                    <div class="col-md-11">
                                        <input type="checkbox" id="chkM_Cardiovascular" value="1" />
                                        <label id="lblCardiovascular">Cardiovascular agents</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-5">
                                        <input type="checkbox" id="chkM_Diuretics" value="1" />
                                        <label id="lblDiuretics">Diuretics</label>
                                    </div>
                                    <div class="col-md-8">
                                        <input type="checkbox" id="chkM_Cathartics" value="1" />
                                        <label id="lblCathartics">Cathartics / laxatives / enemas</label>
                                    </div>
                                    <div class="col-md-11">
                                        <input type="checkbox" id="chkM_Sedatives" value="1" />
                                        <label id="lblSedatives">Sedatives / psychotropic / tranquilizers /barbiturates</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-5">
                                        <input type="checkbox" id="chkM_Histamine" value="1" />
                                        <label id="lblHistamine">Histamine inhibitors</label>
                                    </div>
                                    <div class="col-md-8">
                                        <input type="checkbox" id="chkM_Chemotherapy" value="1" />
                                        <label id="lblChemotherapy">Chemotherapy</label>
                                    </div>
                                    <div class="col-md-11">
                                        <input type="checkbox" id="chkM_Narcotics" value="1" />
                                        <label id="lblNarcotics">Narcotics</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3"></div>
                            <div class="col-md-21" style="text-align: left;">
                                <input type="checkbox" id="chkTotalRisk" value="10" />
                                <label id="lblTotalRiskValue"><b>If the Healthcare Team feels the patient is at high risk to fall(10)</b></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="POuter_Box_Inventory">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-10"></div>
                        <div class="col-md-6">
                            <input type="button" id="btnSave" value="Save" title="Click to Save" class="ItDoseButton" onclick="SaveRecord();" />
                           
                            <input type="button" id="btnUpdate" value="Update" title="Click to Update" class="ItDoseButton" onclick="UpdateRecord();" style="display:none" />
                            <input type="button" id="btnCancel" value="Cancel" title="Click to Clear" class="ItDoseButton" onclick="ClearControls();" style="display:none" />
                             
                        </div>
                        <div class="col-md-8">
                             <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Select From Date" Width="110px"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="ucFromDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                             <asp:TextBox ID="ucToDate" runat="server" ToolTip="Select From Date" Width="110px"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ucToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                            <asp:Button ID="btnPrint" runat="server" Text="Print" ClientIDMode="Static" ToolTip="Click to Print" CssClass="ItDoseButton" OnClick="btnPrint_Click" />
                        </div>
                        <div class="col-md-10"></div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <label id="lblID" style="display:none"></label>
                  <label id="lblCreateDate" style="display:none"></label>
                <div class="Purchaseheader">Result</div>
                 <div id="SearchOutPut" style="max-height: 250px; overflow-x: auto; display:none;"></div>
            </div>
        </div>
    </form>
</body>
</html>

<script type="text/javascript">
    $(document).ready(function () {
        SearchAssessmentData();
        $('#ucFromDate').change(function () {
            ChkDate();

        });

        $('#ucToDate').change(function () {
            ChkDate();

        });
    });
    function ChkDate() {

        $.ajax({
          
            url: "../common/CommonService.asmx/CompareDate",
            data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {
                var data = mydata.d;
                if (data == false) {
                    $('#lblMsg').text('To date can not be less than from date!');
                    $('#btnPrint').attr('disabled', 'disabled');

                }
                else {
                    $('#lblMsg').text('');
                    $('#btnPrint').removeAttr('disabled');
                }
            }
        });

    }
    function getData() {
        var dataAssessment = new Array();
        var ObjAssessment = new Object();
        ObjAssessment.ID = $("#lblID").text();
        ObjAssessment.CreatedDate = $('#lblCreateDate').text();
        ObjAssessment.Date = $("#txtDate").val();
        ObjAssessment.Time = $("#txtTime").val();
        ObjAssessment.AgeValue = $("#ddlAge option:selected").val();
        ObjAssessment.AgeText = $("#ddlAge option:selected").val() != "" ? $("#ddlAge option:selected").text() : "";
        ObjAssessment.MentalStatusValue = $("#ddlMentalStatus option:selected").val();
        ObjAssessment.MentalStatusText = $("#ddlMentalStatus option:selected").val() != "" ? $("#ddlMentalStatus option:selected").text() : "";
        ObjAssessment.LengthofStayValue = $("#ddlLengthofStay option:selected").val();
        ObjAssessment.LengthodStayText = $("#ddlLengthofStay option:selected").val() != "" ? $("#ddlLengthofStay option:selected").text() : "";
        ObjAssessment.EliminationValue = $("#ddlElimination option:selected").val();
        ObjAssessment.EliminationText = $("#ddlElimination option:selected").val() != "" ? $("#ddlElimination option:selected").text() : "";
        ObjAssessment.ImpairmentValue = $("#ddlImpairment option:selected").val();
        ObjAssessment.ImpairmentText = $("#ddlImpairment option:selected").val() != "" ? $("#ddlImpairment option:selected").text() : "";
        ObjAssessment.BloodPressueValue = $("#ddlBloodPressure option:selected").val();
        ObjAssessment.BloodPressueText = $("#ddlBloodPressure option:selected").val() != "" ? $("#ddlBloodPressure option:selected").text() : "";
        if ($('#chkG_Diagnosis').is(':checked')) {
            ObjAssessment.G_Diagnosis_Value = $('#chkG_Diagnosis').val()
            ObjAssessment.G_Diagnosis_Text = $('#lblDiagnosis').text()
        }
        if ($('#chkG_History').is(':checked')) {
            ObjAssessment.G_History_Value = $('#chkG_History').val()
            ObjAssessment.G_History_Text = $('#lblHistory').text()
        }
        if ($('#chkG_LosswitoutHold').is(':checked')) {
            ObjAssessment.G_LossWithoutHold_Value = $('#chkG_LosswitoutHold').val()
            ObjAssessment.G_LossWithoutHold_Text = $('#lblLossWithoutHold').text()
        }
        if ($('#chkG_LossStraight').is(':checked')) {
            ObjAssessment.G_LossStraight_Value = $('#chkG_LossStraight').val()
            ObjAssessment.G_LossStraight_Text = $('#lblLossStraight').text()
        }
        if ($('#chkG_Decreased').is(':checked')) {
            ObjAssessment.G_Decreased_Value = $('#chkG_Decreased').val()
            ObjAssessment.G_Decreased_Text = $('#lblDecreased').text()
        }
        if ($('#chkG_Lurching').is(':checked')) {
            ObjAssessment.G_Lurching_Value = $('#chkG_Lurching').val()
            ObjAssessment.G_Lurching_Text = $('#lblLurching').text()
        }
        if ($('#chkg_UsesCane').is(':checked')) {
            ObjAssessment.G_UsesCane_Value = $('#chkg_UsesCane').val()
            ObjAssessment.G_UsesCane_Text = $('#lblUsesCane').text()
        }
        if ($('#chkG_Holds').is(':checked')) {
            ObjAssessment.G_Holds_Value = $('#chkG_Holds').val()
            ObjAssessment.G_Holds_Text = $('#lblHolds').text()
        }
        if ($('#chkg_WideBase').is(':checked')) {
            ObjAssessment.G_WideBase_Value = $('#chkg_WideBase').val()
            ObjAssessment.G_WideBase_Text = $('#lblWideBase').text()
        }
        if ($('#chkM_Alcohol').is(':checked')) {
            ObjAssessment.M_Alcohol_Value = $('#chkM_Alcohol').val()
            ObjAssessment.M_Alcohol_Text = $('#lblAlcohol').text()
        }
        if ($('#chkM_Post').is(':checked')) {
            ObjAssessment.M_Post_Value = $('#chkM_Post').val()
            ObjAssessment.M_Post_Text = $('#lblMpost').text()
        }
        if ($('#chkM_Cardiovascular').is(':checked')) {
            ObjAssessment.M_Cardiovascular_Value = $('#chkM_Cardiovascular').val()
            ObjAssessment.M_Cardiovascular_Text = $('#lblCardiovascular').text()
        }
        if ($('#chkM_Diuretics').is(':checked')) {
            ObjAssessment.M_Diuretics_Value = $('#chkM_Diuretics').val()
            ObjAssessment.M_Diuretics_Text = $('#lblDiuretics').text()
        }
        if ($('#chkM_Cathartics').is(':checked')) {
            ObjAssessment.M_Cathartics_Value = $('#chkM_Cathartics').val()
            ObjAssessment.M_Cathartics_Text = $('#lblCathartics').text()
        }
        if ($('#chkM_Sedatives').is(':checked')) {
            ObjAssessment.M_Sedatives_Value = $('#chkM_Sedatives').val()
            ObjAssessment.M_Sedatives_Text = $('#lblSedatives').text()
        }
        if ($('#chkM_Histamine').is(':checked')) {
            ObjAssessment.M_Histamine_Value = $('#chkM_Histamine').val()
            ObjAssessment.M_Histamine_Text = $('#lblHistamine').text()
        }
        if ($('#chkM_Narcotics').is(':checked')) {
            ObjAssessment.M_Narcotics_Value = $('#chkM_Narcotics').val()
            ObjAssessment.M_Narcotics_Text = $('#lblNarcotics').text()
        }
        if ($('#chkM_Chemotherapy').is(':checked')) {
            ObjAssessment.M_Chemotherapy_Value = $('#chkM_Chemotherapy').val()
            ObjAssessment.M_Chemotherapy_Text = $('#lblChemotherapy').text()
        }
        if ($('#chkTotalRisk').is(':checked')) {
            ObjAssessment.TotalRisk_Value = $('#chkTotalRisk').val()
            ObjAssessment.TotalRisk_Text = $('#lblTotalRiskValue').text()
        }
        dataAssessment.push(ObjAssessment);
        return dataAssessment;
    }

    function SaveRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TransactionID"]%>';
        var PID = '<%=Request.QueryString["PatientId"]%>';
        serverCall('AdultFallAssessmenttool.aspx/SaveAssessMentRecord', { Data: resultData, TID: TID, PID: PID }, function (response) {
            var result = parseInt(response);
            if (result == 1)
                modelAlert('Record Save Successfully');
            else
                modelAlert('Error Occured');
        });
        ClearControls();
        SearchAssessmentData();
    }
    function SearchAssessmentData() {
        var TransID = '<%=Request.QueryString["TransactionID"]%>';
        var Date = $("#txtDate").val();
        serverCall('AdultFallAssessmenttool.aspx/SearchAssessmentData', { TID: TransID, Date: Date }, function (response) {
            StockData = jQuery.parseJSON(response);
            var output = $('#tb_SearchData').parseTemplate(StockData);
            $('#SearchOutPut').html(output);
            $('#SearchOutPut').show();
        });
    }

    function UpdateRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TransactionID"]%>';
        var PID = '<%=Request.QueryString["PatientId"]%>';
         serverCall('AdultFallAssessmenttool.aspx/UpdateAssessMentRecord', { Data: resultData, TID: TID, PID: PID }, function (response) {
             var result = parseInt(response);
             if (result == 1) {
                 modelAlert('Record Updated Successfully');
             }
             else
                 modelAlert('Error Occured');
         });
         ClearControls();
         SearchAssessmentData();
    }

    

    function ClearControls()
    {
        $('#ddlAge').val("");
        $('#ddlMentalStatus').val("");
        $('#ddlLengthofStay').val("");
        $('#ddlElimination').val("");
        $('#ddlImpairment').val("");
        $('#ddlBloodPressure').val("");
        $('#chkG_Diagnosis').removeAttr("checked", "checked");
        $('#chkG_History').removeAttr("checked", "checked");
        $('#chkG_LosswitoutHold').removeAttr("checked", "checked");
        $('#chkG_LossStraight').removeAttr("checked", "checked");
        $('#chkG_Decreased').removeAttr("checked", "checked");
        $('#chkG_Lurching').removeAttr("checked", "checked");
        $('#chkg_UsesCane').removeAttr("checked", "checked");
        $('#chkG_Holds').removeAttr("checked", "checked");
        $('#chkg_WideBase').removeAttr("checked", "checked");
        $('#chkM_Alcohol').removeAttr("checked", "checked");
        $('#chkM_Post').removeAttr("checked", "checked");
        $('#chkM_Cardiovascular').removeAttr("checked", "checked");
        $('#chkM_Diuretics').removeAttr("checked", "checked");
        $('#chkM_Cathartics').removeAttr("checked", "checked");
        $('#chkM_Sedatives').removeAttr("checked", "checked");
        $('#chkM_Histamine').removeAttr("checked", "checked");
        $('#chkM_Chemotherapy').removeAttr("checked", "checked");
        $('#chkTotalRisk').removeAttr("checked", "checked");
        $('#chkM_Narcotics').removeAttr("checked", "checked")
        $('#btnUpdate').hide();
        $('#btnCancel').hide();
        $('#btnSave').show();
     
    }

    

    function BindDatatoControls(rowid) {
        $('#lblID').text($.trim($(rowid).closest("tr").find("#tdID").text()));
        $('#lblCreateDate').text($.trim($(rowid).closest("tr").find("#tdCreateDate").text()));
        $('#ddlAge').val($.trim($(rowid).closest("tr").find("#Age_Value").text()));
        $('#ddlMentalStatus').val($.trim($(rowid).closest("tr").find("#MentalStatus_Value").text()));
        $('#ddlLengthofStay').val($.trim($(rowid).closest("tr").find("#Lengthofstay_Value").text()));
        $('#ddlElimination').val($.trim($(rowid).closest("tr").find("#Elimination_Value").text()));
        $('#ddlImpairment').val($.trim($(rowid).closest("tr").find("#Impairment_Value").text()));
        $('#ddlBloodPressure').val($.trim($(rowid).closest("tr").find("#BloodPressure_Value").text()));
        if ($.trim($(rowid).closest("tr").find("#G_Diagnosis_Value").text())!="")
            $('#chkG_Diagnosis').attr("checked", "checked")
        else
            $('#chkG_Diagnosis').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#G_History_Value").text()) != "")
            $('#chkG_History').attr("checked", "checked")
        else
            $('#chkG_History').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#G_LosswithoutHold_Value").text()) != "")
            $('#chkG_LosswitoutHold').attr("checked", "checked")
        else
            $('#chkG_LosswitoutHold').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#G_LossStraight_Value").text()) != "")
            $('#chkG_LossStraight').attr("checked", "checked")
        else
            $('#chkG_LossStraight').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#G_Decreased_Value").text()) != "")
            $('#chkG_Decreased').attr("checked", "checked")
        else
            $('#chkG_Decreased').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#G_Lurching_Value").text()) != "")
            $('#chkG_Lurching').attr("checked", "checked")
        else
            $('#chkG_Lurching').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#G_UsesCane_Value").text()) != "")
            $('#chkg_UsesCane').attr("checked", "checked")
        else
            $('#chkg_UsesCane').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#G_Holds_Value").text()) != "")
            $('#chkG_Holds').attr("checked", "checked")
        else
            $('#chkG_Holds').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#G_Widebase_Value").text()) != "")
            $('#chkg_WideBase').attr("checked", "checked")
        else
            $('#chkg_WideBase').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Alcohol_Value").text()) != "")
            $('#chkM_Alcohol').attr("checked", "checked")
        else
            $('#chkM_Alcohol').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Pos_Value").text()) != "")
            $('#chkM_Post').attr("checked", "checked")
        else
            $('#chkM_Post').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Cardio_Value").text()) != "")
            $('#chkM_Cardiovascular').attr("checked", "checked")
        else
            $('#chkM_Cardiovascular').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Diuretics_Value").text()) != "")
            $('#chkM_Diuretics').attr("checked", "checked")
        else
            $('#chkM_Diuretics').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Cath_Value").text()) != "")
            $('#chkM_Cathartics').attr("checked", "checked")
        else
            $('#chkM_Cathartics').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Sedatives_Value").text()) != "")
            $('#chkM_Sedatives').attr("checked", "checked")
        else
            $('#chkM_Sedatives').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Histamine_Value").text()) != "")
            $('#chkM_Histamine').attr("checked", "checked")
        else
            $('#chkM_Histamine').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Chemo_Value").text()) != "")
            $('#chkM_Chemotherapy').attr("checked", "checked")
        else
            $('#chkM_Chemotherapy').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_Narco_Value").text()) != "")
            $('#chkM_Narcotics').attr("checked", "checked")
        else
            $('#chkM_Narcotics').removeAttr("checked", "checked")

        if ($.trim($(rowid).closest("tr").find("#M_HishRisk_Value").text()) != "")
            $('#chkTotalRisk').attr("checked", "checked")
        else
            $('#chkTotalRisk').removeAttr("checked", "checked")

        $('#btnUpdate').show();
        $('#btnCancel').show();
        $('#btnSave').hide();
        
    }
</script>
<script id="tb_SearchData" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_SearchResultData" style="width:100%;border-collapse:collapse;">
		<tr id="trNotifiHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Mental Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Length Of Stay</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Elimination</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Impairment</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Blood Pressure</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Entry by</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>
		</tr>
        <#       
        var dataLength=StockData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = StockData[j];
        #>
                <tr id="tr1">            
                    <td class="GridViewLabItemStyle" id="tdID" style="display:none;"><#=objRow.ID#></td>                
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdDate" style="width:80px;" ><#=objRow.Date#></td> 
                    <td class="GridViewLabItemStyle" style="width:50px;" ><#=objRow.Time#></td> 
                    <td class="GridViewLabItemStyle" id="tdAge_text" style="width:80px;" ><#=objRow.Age_Text#></td> 
                    <td class="GridViewLabItemStyle" id="MentalStatus_Text" style="width:80px;" ><#=objRow.MentalStatus_Text#></td> 
                    <td class="GridViewLabItemStyle" id="Lengthofstay_Text" style="width:80px;" ><#=objRow.Lengthofstay_Text#></td> 
                    <td class="GridViewLabItemStyle" id="Elimination_Text" style="width:80px;" ><#=objRow.Elimination_Text#></td> 
                    <td class="GridViewLabItemStyle" id="Impairment_Text" style="width:80px;" ><#=objRow.Impairment_Text#></td> 
                    <td class="GridViewLabItemStyle" id="BloodPressure_Text" style="width:80px;" ><#=objRow.BloodPressure_Text#></td> 
                    <td class="GridViewLabItemStyle" id="entryby" style="width:100px;" ><#=objRow.entryby#></td>
                    <td class="GridViewLabItemStyle" id="edit" style="width:30px;" ><img id="ImgEdit" alt="Change" src="../../Images/edit.png" onclick="BindDatatoControls(this);" <#if(objRow.IsEdit =="0"){#>style="display:none"<#} #> /></td>
                    <td class="GridViewLabItemStyle" id="Age_Value" style="width:30px; display:none;"><#=objRow.Age_Value#></td>
                    <td class="GridViewLabItemStyle" id="MentalStatus_Value" style="width:30px; display:none;"><#=objRow.MentalStatus_Value#></td>
                    <td class="GridViewLabItemStyle" id="Lengthofstay_Value" style="width:30px; display:none;"><#=objRow.Lengthofstay_Value#></td>
                    <td class="GridViewLabItemStyle" id="Elimination_Value" style="width:30px; display:none;"><#=objRow.Elimination_Value#></td>
                    <td class="GridViewLabItemStyle" id="Impairment_Value" style="width:30px; display:none;"><#=objRow.Impairment_Value#></td>
                    <td class="GridViewLabItemStyle" id="BloodPressure_Value" style="width:30px; display:none;"><#=objRow.BloodPressure_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_Diagnosis_Value" style="width:30px; display:none;"><#=objRow.G_Diagnosis_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_History_Value" style="width:30px; display:none;"><#=objRow.G_History_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_LosswithoutHold_Value" style="width:30px; display:none;"><#=objRow.G_LosswithoutHold_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_LossStraight_Value" style="width:30px; display:none;"><#=objRow.G_LossStraight_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_Decreased_Value" style="width:30px; display:none;"><#=objRow.G_Decreased_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_Lurching_Value" style="width:30px; display:none;"><#=objRow.G_Lurching_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_UsesCane_Value" style="width:30px; display:none;"><#=objRow.G_UsesCane_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_Holds_Value" style="width:30px; display:none;"><#=objRow.G_Holds_Value#></td>
                    <td class="GridViewLabItemStyle" id="G_Widebase_Value" style="width:30px; display:none;"><#=objRow.G_Widebase_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Alcohol_Value" style="width:30px; display:none;"><#=objRow.M_Alcohol_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Pos_Value" style="width:30px; display:none;"><#=objRow.M_Pos_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Cardio_Value" style="width:30px; display:none;"><#=objRow.M_Cardio_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Diuretics_Value" style="width:30px; display:none;"><#=objRow.M_Diuretics_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Cath_Value" style="width:30px; display:none;"><#=objRow.M_Cath_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Sedatives_Value" style="width:30px; display:none;"><#=objRow.M_Sedatives_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Histamine_Value" style="width:30px; display:none;"><#=objRow.M_Histamine_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Chemo_Value" style="width:30px; display:none;"><#=objRow.M_Chemo_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_Narco_Value" style="width:30px; display:none;"><#=objRow.M_Narco_Value#></td>
                    <td class="GridViewLabItemStyle" id="M_HishRisk_Value" style="width:30px; display:none;"><#=objRow.M_HishRisk_Value#></td>
                    <td class="GridViewLabItemStyle" id="tdCreateDate" style="width:30px; display:none;"><#=objRow.CreateDate#></td>
                </tr>           
        <#}#>                     
     </table>    
    </script>

