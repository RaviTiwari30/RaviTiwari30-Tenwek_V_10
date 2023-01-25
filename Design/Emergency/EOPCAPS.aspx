<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EOPCAPS.aspx.cs" Inherits="Design_Emergency_EOPCAPS" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>OT SCreen</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Patient Details</div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">Age(< 16 or > 65)</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoAge" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoAge" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                    <div class="col-md-7">
                        <label class="pull-left">Language or Hearing Barrier</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoLanguage" value="1" onclick="CalculateTotalScore();" />Yes
                        <input type="radio" name="rdoLanguage" value="0" checked="checked" onclick="CalculateTotalScore();" />No
                    </div>
                    </div>
                <div class="row">
                        <div class="col-md-7">
                            <label class="pull-left">Family Support</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdoFamily" value="1" onclick="CalculateTotalScore();"  />Yes
                            <input type="radio" name="rdoFamily" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                        </div>
                        <div class="col-md-7">
                            <label class="pull-left">Internation Patient</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdoInternation" value="1" onclick="CalculateTotalScore();"  />Yes
                            <input type="radio" name="rdoInternation" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                        </div>
                    </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Medication</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">high Risk Drugs</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoHighDrugs" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoHighDrugs" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Drugs (>8)</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoDrugs" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoDrugs" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Blood Transfusion</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoBloodTrans" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoBloodTrans" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Equipment</div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">Ventilator/BIPAP</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoVentilator" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoVentilator" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                    <div class="col-md-7">
                        <label class="pull-left">Syringe/Infusion Pump</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoSyringe" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoSyringe" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Airway</div>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoAirway" value="2" onclick="CalculateTotalScore();"  />Tracheostomy/EIT
                    </div>
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoAirway" value="1" onclick="CalculateTotalScore();"  />Nasal Canula/Face Mask
                    </div>
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoAirway" value="0" checked="checked" onclick="CalculateTotalScore();"  />None
                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Clinical</div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">High Risk Deseases(DM, Cardiac, Neurological)</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <input type="radio" name="rdohighDesease" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdohighDesease" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                    <div class="col-md-9">
                        <label class="pull-left">High Risk Surgery(Transplant, Cancer, Brain, Arotic, Surgery)</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <input type="radio" name="rdoHighSurgery" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoHighSurgery" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Fall Risk</div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">History of fall(With in 1 Year)</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoHistoryFall" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoHistoryFall" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                    <div class="col-md-7">
                        <label class="pull-left">Mobidity Aid</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoMorbidity" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoMorbidity" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                    </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">Gait</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoGait" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoGait" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                    <div class="col-md-7">
                        <label class="pull-left">Mental Status</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoMental" value="1" onclick="CalculateTotalScore();"  />Yes
                        <input type="radio" name="rdoMental" value="0" checked="checked" onclick="CalculateTotalScore();"  />No
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-8">
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left"  style="color:red; font-size:large">Total Score</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <input type="text" id="txtTotalScore" disabled="disabled" style="display:none;"/>
                         <label id="lblTotalScore" style="color:red; font-size:large;"></label>
                    </div>
                    <div class="col-md-8">
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-10">
                    </div>
                    <div class="col-md-4">
                        <input type="button" id="btnSave" class="ItdoseButton" value="Save" onclick="SaveRecord();" />
                        <input type="button" id="btnUpdate" class="ItdoseButton" value="Update" onclick="UpdateRecord();" style="display:none;" />
                    </div>
                    <div class="col-md-10">
                        <label id="lblID" style="display:none"></label>
                        <label id="lblCreateDate" style="display:none"></label>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    $(document).ready(function () {
        SearchEOPData();
    });

    function SearchEOPData() {
        var TransID = '<%=Request.QueryString["TID"]%>';
        serverCall('EOPCAPS.aspx/SearchEOPData', { TID: TransID}, function (response) {
            StockData = jQuery.parseJSON(response);
            if (StockData.length != 0) {
                $('input[name="rdoAge"]').filter("[value='" + StockData[0].Age + "']").attr('checked', true);
                $('input[name="rdoLanguage"]').filter("[value='" + StockData[0].LanguageBarier + "']").attr('checked', true);
                $('input[name="rdoFamily"]').filter("[value='" + StockData[0].FamilySupport + "']").attr('checked', true);
                $('input[name="rdoInternation"]').filter("[value='" + StockData[0].International + "']").attr('checked', true);
                $('input[name="rdoHighDrugs"]').filter("[value='" + StockData[0].HighRiskDrugs + "']").attr('checked', true);
                $('input[name="rdoDrugs"]').filter("[value='" + StockData[0].Drugs + "']").attr('checked', true);
                $('input[name="rdoBloodTrans"]').filter("[value='" + StockData[0].BloodTransfusion + "']").attr('checked', true);
                $('input[name="rdoVentilator"]').filter("[value='" + StockData[0].Ventilator + "']").attr('checked', true);
                $('input[name="rdoSyringe"]').filter("[value='" + StockData[0].Syringe + "']").attr('checked', true);
                $('input[name="rdoAirway"]').filter("[value='" + StockData[0].Airway + "']").attr('checked', true);
                $('input[name="rdohighDesease"]').filter("[value='" + StockData[0].HighRiskDesease + "']").attr('checked', true);
                $('input[name="rdoHighSurgery"]').filter("[value='" + StockData[0].HighRiskSurgery + "']").attr('checked', true);
                $('input[name="rdoHistoryFall"]').filter("[value='" + StockData[0].HistoryofFall + "']").attr('checked', true);
                $('input[name="rdoMorbidity"]').filter("[value='" + StockData[0].MobidityAid + "']").attr('checked', true);
                $('input[name="rdoGait"]').filter("[value='" + StockData[0].Gait + "']").attr('checked', true);
                $('input[name="rdoMental"]').filter("[value='" + StockData[0].MentalStatus + "']").attr('checked', true);
                $('#txtTotalScore').val(StockData[0].TotalScore);
                $('#lblTotalScore').text(StockData[0].TotalScore);
                $('#lblID').text(StockData[0].ID);
                $('#lblCreateDate').text(StockData[0].CreateDate)
                $('#btnSave').hide();
                $('#btnUpdate').show();
            }
        });
    }

    function SaveRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TID"]%>';
        var PID = '<%=Request.QueryString["PID"]%>';
        var EMGNo = '<%=Request.QueryString["EMGNo"]%>';
         serverCall('EOPCAPS.aspx/SaveEOPRecord', { Data: resultData, TID: TID, PID: PID, EMGNo: EMGNo }, function (response) {
             var result = parseInt(response);
             if (result == 1) {
                 modelAlert('Record Save Successfully', function (response) {
                     SearchEOPData();
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
        serverCall('EOPCAPS.aspx/UpdateEOPRecord', { Data: resultData, TID: TID, PID: PID, EMGNo: EMGNo }, function (response) {
            var result = parseInt(response);
            if (result == 1) {
                modelAlert('Record Update Successfully', function (repsonse) {
                    SearchEOPData();
                });
            }
            else
                modelAlert('Error Occured');
        });
    }

    function getData() {
        var dataEOP = new Array();
        var ObjEOP = new Object();
                           
        ObjEOP.ID = $("#lblID").text();
        ObjEOP.CreatedDate = $('#lblCreateDate').text();
        ObjEOP.Age = $('input:radio[name=rdoAge]:checked').val();
        ObjEOP.LanguageBarier = $('input:radio[name=rdoLanguage]:checked').val();
        ObjEOP.FamilySupport = $('input:radio[name=rdoFamily]:checked').val();
        ObjEOP.International = $('input:radio[name=rdoInternation]:checked').val();
        ObjEOP.HighRiskDrugs = $('input:radio[name=rdoHighDrugs]:checked').val();
        ObjEOP.Drugs = $('input:radio[name=rdoDrugs]:checked').val();
        ObjEOP.BloodTransfusion = $('input:radio[name=rdoBloodTrans]:checked').val();
        ObjEOP.Ventilator = $('input:radio[name=rdoVentilator]:checked').val();
        ObjEOP.Syringe = $('input:radio[name=rdoSyringe]:checked').val();
        ObjEOP.Airway = $('input:radio[name=rdoAirway]:checked').val();
        ObjEOP.HighRiskDesease = $('input:radio[name=rdohighDesease]:checked').val();
        ObjEOP.HighRiskSurgery = $('input:radio[name=rdoHighSurgery]:checked').val();
        ObjEOP.HistoryofFall = $('input:radio[name=rdoHistoryFall]:checked').val();
        ObjEOP.MobidityAid = $('input:radio[name=rdoMorbidity]:checked').val();
        ObjEOP.Gait = $('input:radio[name=rdoGait]:checked').val();
        ObjEOP.MentalStatus = $('input:radio[name=rdoMental]:checked').val();
        ObjEOP.TotalScore = $('#txtTotalScore').val();

        dataEOP.push(ObjEOP);
        return dataEOP;
    }
</script>
<script type="text/javascript">
    function CalculateTotalScore()
    {
        var Age = Number($('input:radio[name=rdoAge]:checked').val());
       var LanguageBarier = Number($('input:radio[name=rdoLanguage]:checked').val());
       var FamilySupport = Number($('input:radio[name=rdoFamily]:checked').val());
       var International = Number($('input:radio[name=rdoInternation]:checked').val());
       var HighRiskDrugs = Number($('input:radio[name=rdoHighDrugs]:checked').val());
       var Drugs = Number($('input:radio[name=rdoDrugs]:checked').val());
       var BloodTransfusion = Number($('input:radio[name=rdoBloodTrans]:checked').val());
       var Ventilator = Number($('input:radio[name=rdoVentilator]:checked').val());
       var Syringe = Number($('input:radio[name=rdoSyringe]:checked').val());
       var Airway = Number($('input:radio[name=rdoAirway]:checked').val());
       var HighRiskDesease = Number($('input:radio[name=rdohighDesease]:checked').val());
       var HighRiskSurgery = Number($('input:radio[name=rdoHighSurgery]:checked').val());
       var HistoryofFall = Number($('input:radio[name=rdoHistoryFall]:checked').val());
       var MobidityAid = Number($('input:radio[name=rdoMorbidity]:checked').val());
       var Gait = Number($('input:radio[name=rdoGait]:checked').val());
       var MentalStatus = Number($('input:radio[name=rdoMental]:checked').val());
       var TotalScore = Age + LanguageBarier + FamilySupport + International + HighRiskDesease + Drugs + BloodTransfusion + Ventilator + Syringe + Airway + HighRiskDrugs + HighRiskSurgery + HistoryofFall + MobidityAid + Gait + MentalStatus;

       $('#txtTotalScore').val(TotalScore);
       $('#lblTotalScore').text(TotalScore);
    }
</script>