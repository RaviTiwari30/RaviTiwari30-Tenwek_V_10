<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FalseAssessment.aspx.cs" Inherits="Design_Emergency_FalseAssessment" %>

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
                <b>Fall Assessment</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="col-md-24">
                    <div class="row">
                        <div class="row">
                            <div class="col-md-7 Purchaseheader">&nbsp;</div>
                            <div class="col-md-5 Purchaseheader">Falls Risk</div>
                            <div class="col-md-12 Purchaseheader">Scale</div>
                        </div>
                        <div class="row" style="display: none;">
                            <div class="col-md-5">
                                <label class="pull-left">Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-5">
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
                            <div class="col-md-4"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Confusion</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlConfusion" onchange="CalculateTotalScore();">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Disorientation</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDisorientation" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Dizziness / Balance Problem</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDizziness" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Hearing Impairment</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlHearing" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Hemiparesis</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlHemiparesis" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">History of Fall</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlHistory" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Memory Impairment</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlMemory" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Sight Impairment</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlSight" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">UnSteady Gait</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlUnsteadyGait" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Uses Walking Aid</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlWalkingAid" onchange="CalculateTotalScore()">
                                    <option value="0">Select</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left">Will Patient Need BedSide</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="radio" name="rdobedside" value="1" checked="checked" onclick="CalculateTotalScore();" />Day
                                <input type="radio" name="rdobedside" value="0" onclick="CalculateTotalScore();" />Night
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5"></div>
                            <div class="col-md-5">
                                <label class="pull-left" style="color:red; font-size:large">Total Score</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left">
                                <label id="lblTotalScore" style="color:red; font-size:large"></label>
                                <input type="text" id="txtTotalscore" disabled="disabled" style="display:none;" />
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-10">
                    </div>
                    <div class="col-md-4">
                        <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="saveRecord();" />
                        <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display: none;" onclick="UpdateRecord();" />
                        <asp:Button ID="btnPrint" runat="server" CssClass="ItDoseButton" OnClick="btnPrint_Click" Text="Print" />
                    </div>
                    <div class="col-md-10">
                        <label id="lblID" style="display: none"></label>
                        <label id="lblCreateDate" style="display: none"></label>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    $(document).ready(function () {
        SearchAssessmentData();
    });

    function SearchAssessmentData() {
        var TransID = '<%=Request.QueryString["TID"]%>';
        var Date = $("#txtDate").val();
        serverCall('FalseAssessment.aspx/SearchAssessmentData', { TID: TransID, Date: Date }, function (response) {
            StockData = jQuery.parseJSON(response);
            if (StockData.length != 0) {
                $('#ddlConfusion').val(StockData[0].Confusion);
                $('#ddlDisorientation').val(StockData[0].Disorientation);
                $('#ddlDizziness').val(StockData[0].Dizziness);
                $('#ddlHearing').val(StockData[0].Hearing);
                $('#ddlHemiparesis').val(StockData[0].Hemiparesis);
                $('#ddlHistory').val(StockData[0].HistoryofFall);
                $('#ddlMemory').val(StockData[0].MemoryImpairment);
                $('#ddlSight').val(StockData[0].SightImpairment);
                $('#ddlUnsteadyGait').val(StockData[0].UnsteadyGait);
                $('#ddlWalkingAid').val(StockData[0].WalkingAid);
                $('input[name="rdobedside"]').filter("[value='" + StockData[0].NeedBedSide + "']").attr('checked', true);
                $('#txtTotalscore').val(StockData[0].TotalScore);
                $('#lblTotalScore').text(StockData[0].TotalScore);
                $('#lblID').text(StockData[0].ID);
                $('#lblCreateDate').text(StockData[0].CreateDateTime)
                $('#btnSave').hide();
                $('#btnUpdate').show();
            }
        });
    }

    function saveRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TID"]%>';
        var PID = '<%=Request.QueryString["PID"]%>';
        var EMGNo = '<%=Request.QueryString["EMGNo"]%>';
        serverCall('FalseAssessment.aspx/SaveAssessMentRecord', { Data: resultData, TID: TID, PID: PID, EMGNo: EMGNo }, function (response) {
            var result = parseInt(response);
            if (result == 1) {
                modelAlert('Record Save Successfully', function (response) {
                    SearchAssessmentData();
                });
            }
            else
                modelAlert('Error Occured');
        });
    }

    function UpdateRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TID"]%>';
        var PID = '<%=Request.QueryString["PID"]%>';
        var EMGNo = '<%=Request.QueryString["EMGNo"]%>';
        serverCall('FalseAssessment.aspx/UpdateAssessMentRecord', { Data: resultData, TID: TID, PID: PID, EMGNo: EMGNo }, function (response) {
            var result = parseInt(response);
            if (result == 1) {
                modelAlert('Record Update Successfully');
            }
            else
                modelAlert('Error Occured');
        });
    }

    function getData() {
        var dataAssessment = new Array();
        var ObjAssessment = new Object();

        ObjAssessment.ID = $("#lblID").text();
        ObjAssessment.CreatedDate = $('#lblCreateDate').text();
        ObjAssessment.Date = $("#txtDate").val();
        ObjAssessment.Time = $("#txtTime").val();
        ObjAssessment.Confusion = $('#ddlConfusion option:selected').val();
        ObjAssessment.Disorientation = $('#ddlDisorientation option:selected').val();
        ObjAssessment.Dizziness = $('#ddlDizziness option:selected').val();
        ObjAssessment.Hearing = $('#ddlHearing option:selected').val();
        ObjAssessment.Hemiparesis = $('#ddlHemiparesis option:selected').val();
        ObjAssessment.HistoryofFall = $('#ddlHistory option:selected').val();
        ObjAssessment.MemoryImpairment = $('#ddlMemory option:selected').val();
        ObjAssessment.SightImpairment = $('#ddlSight option:selected').val();
        ObjAssessment.UnsteadyGait = $('#ddlUnsteadyGait option:selected').val();
        ObjAssessment.WalkingAid = $('#ddlWalkingAid option:selected').val();
        ObjAssessment.NeedBedSide = $('input:radio[name=rdobedside]:checked').val();
        ObjAssessment.TotalScore = $('#txtTotalscore').val();

        dataAssessment.push(ObjAssessment);
        return dataAssessment;
    }
</script>
<script type="text/javascript">
    function CalculateTotalScore() {
        var TotalScore = 0;
        var Confusion = Number($('#ddlConfusion option:selected').val());
        var DisOrientation = Number($('#ddlDisorientation option:selected').val());
        var Dizz = Number($('#ddlDizziness option:selected').val());
        var Hearing = Number($('#ddlHearing option:selected').val());
        var Hemi = Number($('#ddlHemiparesis option:selected').val());
        var History = Number($('#ddlHemiparesis option:selected').val());
        var Memory = Number($('#ddlMemory option:selected').val());
        var Sight = Number($('#ddlSight option:selected').val());
        var Unsteady = Number($('#ddlUnsteadyGait option:selected').val());
        var Walking = Number($('#ddlWalkingAid option:selected').val());
        var Need = Number($('input:radio[name=rdobedside]:checked').val());

        TotalScore = Confusion + DisOrientation + Dizz + Hearing + Hemi + History + Memory + Sight + Unsteady + Walking + Need;

        $('#txtTotalscore').val(TotalScore);
        $('#lblTotalScore').text(TotalScore);
    }
</script>
