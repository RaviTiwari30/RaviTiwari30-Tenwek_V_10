<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewBornDetails.aspx.cs" Inherits="Design_ip_NewBornDetails" %>


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
    <style type="text/css">
        .style2 {
            font-size: x-small;
        }
    </style>
</head>
<body>
     <script type="text/javascript">
       
         $(document).ready(function () {
            
             $("#grdPhysical").load(location.href + " #grdPhysical");
             $('.Number').keypress(function (event) {
                 var keycode;

                 keycode = event.keyCode ? event.keyCode : event.which;

                 if (!(event.shiftKey == false && (keycode == 46 || keycode == 8 ||
                         keycode == 37 || keycode == 39 || (keycode >= 48 && keycode <= 57)))) {
                     event.preventDefault();
                 }
             });
            // bindGrid();
             
         });
         function isAlphaNumeric(e) {
             var k;
             document.all ? k = e.keycode : k = e.which;
             return ((k > 47 && k < 58) || (k > 64 && k < 91) || (k > 96 && k < 123) || k == 0);

         }

         function getCurrDate()
         {
             var d = new Date();
             var dd = d.getDate();
             var mm = d.getMonth();
             var yyyy = d.getFullYear();
             var MMM = "";
             switch (mm)
             {
                 case 0:
                     MMM = "Jan";
                     break;
                 case 1:
                     MMM = "Feb";
                     break;
                 case 2:
                     MMM = "Mar";
                     break;
                 case 3:
                     MMM = "Apr";
                     break;
                 case 4:
                     MMM = "May";
                     break;
                 case 5:
                     MMM = "Jun";
                     break;
                 case 6:
                     MMM = "Jul";
                     break;
                 case 7:
                     MMM = "Aug";
                     break;
                 case 8:
                     MMM = "Sep";
                     break;
                 case 9:
                     MMM = "Oct";
                     break;
                 case 10:
                     MMM = "Nov";
                     break;
                 case 11:
                     MMM = "Dec";
                     break;
             }
             return dd+'-'+ MMM+ '-'+yyyy;
         }
         function getCurrTime() {

             var d = new Date();
             var HH = d.getHours();
             var mm = d.getMinutes();
             var ampm = "";
             if (mm < 10) {
                 mm = '0' + mm;
             }
             if (HH > 12) {
                 ampm = "PM";
                 HH = HH - 12;
                 if (HH < 10)
                 {
                     HH='0' + HH;
                 }
             }
             else {
                 ampm = "AM";
             }
             return HH+':'+mm+ ' '+ ampm;
         }
         function prepareData() {

             var dataIntake = new Array();
             var ObjIntake = new Object();

             ObjIntake.Id = "0";

             ObjIntake.Date = $("#txtDate").val();
             ObjIntake.Time = $("#StartTime_txtTime").val();
             if ($("#chkAlive").is(':checked') == true) {
                 ObjIntake.Alive = "1";
             }
             else {
                 ObjIntake.Alive = "0";
             }

             if ($("#chkFreshStillBirth").is(':checked') == true) {
                 ObjIntake.FreshStillBirth = "1";
             }
             else {
                 ObjIntake.FreshStillBirth = "0";
             }
             if ($("#chkMaceratedStillBirth").is(':checked') == true) {

                 ObjIntake.MaceratedStillBirth = "1";
             }
             else {
                 ObjIntake.MaceratedStillBirth = "0";
             }

             if ($("#chkSingle").is(':checked') == true) {

                 ObjIntake.Single = "1";
             }
             else {
                 ObjIntake.Single = "0";
             }
             if ($("#chkTwin").is(':checked') == true) {

                 ObjIntake.Twin = "1";
             }
             else {
                 ObjIntake.Twin = "0";
             }

             if ($("#chkTriplet").is(':checked') == true) {

                 ObjIntake.Triplet = "1";
             }
             else {
                 ObjIntake.Triplet = "0";
             }
             ObjIntake.BirthWeight = $("#txtBirthWeight").val();
             ObjIntake.HC = $("#txtHC").val();
             ObjIntake.Length = $("#txtLength").val();
             ObjIntake.ApgarScore3 = $("#txtApgarScore3").val();
             ObjIntake.Heart1 = $("#txtHeart1").val();
             ObjIntake.Heart2 = $("#txtHeart2").val();
             ObjIntake.Heart3 = $("#txtHeart3").val();
             ObjIntake.RespiratoryEffort1 = $("#txtRespiratoryEffort1").val();
             ObjIntake.RespiratoryEffort2 = $("#txtRespiratoryEffort2").val();
             ObjIntake.RespiratoryEffort3 = $("#txtRespiratoryEffort3").val();
             ObjIntake.Muscletone1 = $("#txtMuscletone1").val();
             ObjIntake.Muscletone2 = $("#txtMuscletone2").val();
             ObjIntake.Muscletone3 = $("#txtMuscletone3").val();
             ObjIntake.RefluxResponseToStimulus1 = $("#txtRefluxResponseToStimulus1").val();
             ObjIntake.RefluxResponseToStimulus2 = $("#txtRefluxResponseToStimulus2").val();
             ObjIntake.RefluxResponseToStimulus3 = $("#txtRefluxResponseToStimulus3").val();
             ObjIntake.Colour1 = $("#txtColour1").val();
             ObjIntake.Colour2 = $("#txtColour2").val();
             ObjIntake.Colour3 = $("#txtColour3").val();
             ObjIntake.TotalScore1 = $("#txtTotalScore1").val();
             ObjIntake.TotalScore2 = $("#txtTotalScore2").val();
             ObjIntake.TotalScore3 = $("#txtTotalScore3").val();
             if ($("#chkMicroniumAspiration").is(':checked') == true) {

                 ObjIntake.MicroniumAspiration = "1";
             }
             else {
                 ObjIntake.MicroniumAspiration = "0";
             }
             if ($("#chkCordAroundNeckx").is(':checked') == true) {

                 ObjIntake.CordAroundNeckx = "1";
             }
             else {
                 ObjIntake.CordAroundNeckx = "0";
             }

             if ($("#chkOther").is(':checked') == true) {

                 ObjIntake.Other = "1";
             }
             else {
                 ObjIntake.Other = "0";
             }
             ObjIntake.OtherComment = $("#txtOtherComment").val();

             if ($("#chkTetracycline").is(':checked') == true) {

                 ObjIntake.Tetracycline = "1";
             }
             else {
                 ObjIntake.Tetracycline = "0";
             }

             if ($("#chkVitK").is(':checked') == true) {

                 ObjIntake.VitK = "1";
             }
             else {
                 ObjIntake.VitK = "0";
             }
             if ($("#chkResuscitation").is(':checked') == true) {

                 ObjIntake.Resuscitation = "1";
             }
             else {
                 ObjIntake.Resuscitation = "0";
             }
             if ($("#chkO2").is(':checked') == true) {

                 ObjIntake.O2 = "1";
             }
             else {
                 ObjIntake.O2 = "0";
             }
             if ($("#chkAmbu").is(':checked') == true) {

                 ObjIntake.Ambu = "1";
             }
             else {
                 ObjIntake.Ambu = "0";
             }
             if ($("#chkIntubation").is(':checked') == true) {

                 ObjIntake.Intubation = "1";
             }
             else {
                 ObjIntake.Intubation = "0";
             }
             if ($("#chkCardiacCompression").is(':checked') == true) {

                 ObjIntake.CardiacCompression = "1";
             }
             else {
                 ObjIntake.CardiacCompression = "0";
             }
             if ($("#chkInjury").is(':checked') == true) {

                 ObjIntake.Injury = "1";
             }
             else {
                 ObjIntake.Injury = "0";
             }
             ObjIntake.InjurySpecify = $("#txtInjurySpecify").val();

             if ($("#chkCongenitalAbnormalities").is(':checked') == true) {

                 ObjIntake.CongenitalAbnormalities = "1";
             }
             else {
                 ObjIntake.CongenitalAbnormalities = "0";
             }
             ObjIntake.CongenitalAbnormalitiesSpecify = $("#txtCongenitalAbnormalitiesSpecify").val();
             if ($("#chkRespiratoryDistress").is(':checked') == true) {

                 ObjIntake.RespiratoryDistress = "1";
             }
             else {
                 ObjIntake.RespiratoryDistress = "0";
             }
             if ($("#chkOther1").is(':checked') == true) {

                 ObjIntake.Other1 = "1";
             }
             else {
                 ObjIntake.Other1 = "0";
             }
             ObjIntake.Other1Specify = $("#txtOther1Specify").val();
             ObjIntake.Date1 = $("#txtDate1").val();
             if ($("#chkToMotherCare").is(':checked') == true) {

                 ObjIntake.ToMotherCare = "1";
             }
             else {
                 ObjIntake.ToMotherCare = "0";
             }
             ObjIntake.Date2 = $("#txtDate2").val();
             if ($("#chkToNursary").is(':checked') == true) {

                 ObjIntake.ToNursary = "1";
             }
             else {
                 ObjIntake.ToNursary = "0";
             }
             ObjIntake.Date3 = $("#txtDate3").val();
             ObjIntake.Reason = $("#txtReason").val();
             ObjIntake.DischargeDate = $("#txtDischargeDate").val();
             ObjIntake.Days = $("#txtDays").val();
             ObjIntake.MotherAge = $("#txtMotherAge").val();
             ObjIntake.G = $("#txtG").val();
             ObjIntake.P = $("#txtP").val();
             ObjIntake.Plus = $("#txtPlus").val();
             ObjIntake.LMP = $("#txtLMP").val();
             ObjIntake.GestationByDate = $("#txtGestationByDate").val();
             ObjIntake.GestationByUIS = $("#txtGestationByUIS").val();
             ObjIntake.NoOfPrenatal = $("#txtNoOfPrenatal").val();
             ObjIntake.Where = $("#txtWhere").val();
             ObjIntake.BloodTypeRhesus = $("#txtBloodTypeRhesus").val();
             ObjIntake.Hgb = $("#txtHgb").val();
             ObjIntake.VRDL = $("#txtVRDL").val();
             ObjIntake.PMCTSerology = $("#txtPMCTSerology").val();
             if ($("#chkpos").is(':checked') == true) {

                 ObjIntake.pos = "1";
             }
             else {
                 ObjIntake.pos = "0";
             }
             if ($("#chkneg").is(':checked') == true) {

                 ObjIntake.neg = "1";
             }
             else {
                 ObjIntake.neg = "0";
             }

             if ($("#chkrefused").is(':checked') == true) {

                 ObjIntake.refused = "1";
             }
             else {
                 ObjIntake.refused = "0";
             }
             ObjIntake.PrenatalComplications = $("#txtPrenatalComplications").val();
             if ($("#chkpreeclampsia1").is(':checked') == true) {

                 ObjIntake.preeclampsia1 = "1";
             }
             else {
                 ObjIntake.preeclampsia1 = "0";
             }
             if ($("#chkEclampsia").is(':checked') == true) {

                 ObjIntake.Eclampsia = "1";
             }
             else {
                 ObjIntake.Eclampsia = "0";
             }
             if ($("#chkOligoHydramnios").is(':checked') == true) {

                 ObjIntake.OligoHydramnios = "1";
             }
             else {
                 ObjIntake.OligoHydramnios = "0";
             }
             if ($("#chkPolyHydramnios").is(':checked') == true) {

                 ObjIntake.PolyHydramnios = "1";
             }
             else {
                 ObjIntake.PolyHydramnios = "0";
             }
             if ($("#chkAPH1").is(':checked') == true) {

                 ObjIntake.APH1 = "1";
             }
             else {
                 ObjIntake.APH1 = "0";
             }
             if ($("#chkGestDiabetes").is(':checked') == true) {

                 ObjIntake.GestDiabetes = "1";
             }
             else {
                 ObjIntake.GestDiabetes = "0";
             }

             if ($("#chkTwins1").is(':checked') == true) {

                 ObjIntake.Twins1 = "1";
             }
             else {
                 ObjIntake.Twins1 = "0";
             }
             if ($("#chkOther2").is(':checked') == true) {

                 ObjIntake.Other2 = "1";
             }
             else {
                 ObjIntake.Other2 = "0";
             }
             ObjIntake.Other2Comment = $("#txtOther2Comment").val();

             if ($("#chkAbnormalDeliveries").is(':checked') == true) {

                 ObjIntake.AbnormalDeliveries = "1";
             }
             else {
                 ObjIntake.AbnormalDeliveries = "0";
             }
             if ($("#chkCS").is(':checked') == true) {

                 ObjIntake.CS = "1";
             }
             else {
                 ObjIntake.CS = "0";
             }

             if ($("#chkVacuumForceps").is(':checked') == true) {

                 ObjIntake.VacuumForceps = "1";
             }
             else {
                 ObjIntake.VacuumForceps = "0";
             }
             if ($("#chkTwins").is(':checked') == true) {

                 ObjIntake.Twins = "1";
             }
             else {
                 ObjIntake.Twins = "0";
             }

             if ($("#chkAPH").is(':checked') == true) {

                 ObjIntake.APH = "1";
             }
             else {
                 ObjIntake.APH = "0";
             }
             if ($("#chkPPH").is(':checked') == true) {

                 ObjIntake.PPH = "1";
             }
             else {
                 ObjIntake.PPH = "0";
             }
             if ($("#chkpreeclampsia").is(':checked') == true) {

                 ObjIntake.preeclampsia = "1";
             }
             else {
                 ObjIntake.preeclampsia = "0";
             }
             if ($("#chkstillbirth").is(':checked') == true) {

                 ObjIntake.stillbirth = "1";
             }
             else {
                 ObjIntake.stillbirth = "0";
             }
             if ($("#chkpreterm").is(':checked') == true) {

                 ObjIntake.preterm = "1";
             }
             else {
                 ObjIntake.preterm = "0";
             }
             if ($("#chkFirstWeekMortality").is(':checked') == true) {

                 ObjIntake.FirstWeekMortality = "1";
             }
             else {
                 ObjIntake.FirstWeekMortality = "0";
             }
             if ($("#chkNeonatalJaundice").is(':checked') == true) {

                 ObjIntake.NeonatalJaundice = "1";
             }
             else {
                 ObjIntake.NeonatalJaundice = "0";
             }
             if ($("#chkCongeriltalAbnorm").is(':checked') == true) {

                 ObjIntake.CongeriltalAbnorm = "1";
             }
             else {
                 ObjIntake.CongeriltalAbnorm = "0";
             }
             if ($("#chkOther3").is(':checked') == true) {

                 ObjIntake.Other3 = "1";
             }
             else {
                 ObjIntake.Other3 = "0";
             }

             ObjIntake.Other3Comment = $("#txtOther3Comment").val();
             if ($("#chkHx").is(':checked') == true) {

                 ObjIntake.Hx = "1";
             }
             else {
                 ObjIntake.Hx = "0";
             }
             if ($("#chkTh").is(':checked') == true) {

                 ObjIntake.Th = "1";
             }
             else {
                 ObjIntake.Th = "0";
             }
             if ($("#chkKidney").is(':checked') == true) {

                 ObjIntake.Kidney = "1";
             }
             else {
                 ObjIntake.Kidney = "0";
             }
             if ($("#chkHeartDisease").is(':checked') == true) {

                 ObjIntake.HeartDisease = "1";
             }
             else {
                 ObjIntake.HeartDisease = "0";
             }

             if ($("#chkHypertension").is(':checked') == true) {

                 ObjIntake.Hypertension = "1";
             }
             else {
                 ObjIntake.Hypertension = "0";
             }
             if ($("#chkDiabetes").is(':checked') == true) {

                 ObjIntake.Diabetes = "1";
             }
             else {
                 ObjIntake.Diabetes = "0";
             }
             if ($("#chkConvulsions").is(':checked') == true) {

                 ObjIntake.Convulsions = "1";
             }
             else {
                 ObjIntake.Convulsions = "0";
             }
             ObjIntake.Other4 = $("#txtOther4").val();
             ObjIntake.PresentingHxonAdmissionMother = $("#txtPresentingHxonAdmissionMother").val();
             ObjIntake.Date4 = $("#txtDate4").val();
             ObjIntake.Time1 = $("#txtTime1_txtTime").val();
             ObjIntake.RupturedMembranesDate = $("#txtRupturedMembranesDate").val();
             ObjIntake.Time3 = $("#txtTime3_txtTime").val();
             ObjIntake.Colour = $("#txtColour").val();
             ObjIntake.Comment = $("#txtComment").val();
             if ($("#chkNST").is(':checked') == true) {

                 ObjIntake.NST = "1";
             }
             else {
                 ObjIntake.NST = "0";
             }
             if ($("#chkReactive").is(':checked') == true) {

                 ObjIntake.Reactive = "1";
             }
             else {
                 ObjIntake.Reactive = "0";
             }
             if ($("#chkNonReactive").is(':checked') == true) {

                 ObjIntake.NonReactive = "1";
             }
             else {
                 ObjIntake.NonReactive = "0";
             }
             ObjIntake.Comment1 = $("#txtComment1").val();
             ObjIntake.US = $("#txtUS").val();
             ObjIntake.OneStage = $("#txtOneStage").val();
             ObjIntake.TwoStage = $("#txtTwoStage").val();
             ObjIntake.ThreeStage = $("#txtThreeStage").val();
             ObjIntake.TotalHoursOfLabour = $("#txtTotalHoursOfLabour").val();

             if ($("#chkVagVtx").is(':checked') == true) {

                 ObjIntake.VagVtx = "1";
             }
             else {
                 ObjIntake.VagVtx = "0";
             }
             if ($("#chkAssistedBreech").is(':checked') == true) {

                 ObjIntake.AssistedBreech = "1";
             }
             else {
                 ObjIntake.AssistedBreech = "0";
             }
             if ($("#chkPitocinCytotec").is(':checked') == true) {

                 ObjIntake.PitocinCytotec = "1";
             }
             else {
                 ObjIntake.PitocinCytotec = "0";
             }

             if ($("#chkVacuum2").is(':checked') == true) {

                 ObjIntake.Vacuum2 = "1";
             }
             else {
                 ObjIntake.Vacuum2 = "0";
             }

             if ($("#chkForceps2").is(':checked') == true) {

                 ObjIntake.Forceps2 = "1";
             }
             else {
                 ObjIntake.Forceps2 = "0";
             }
             if ($("#chkCSElectiveEmergency").is(':checked') == true) {

                 ObjIntake.CSElectiveEmergency = "1";
             }
             else {
                 ObjIntake.CSElectiveEmergency = "0";
             }
             ObjIntake.Reason1 = $("#txtReason1").val();

             if ($("#chkDexamethasone").is(':checked') == true) {

                 ObjIntake.Dexamethasone = "1";
             }
             else {
                 ObjIntake.Dexamethasone = "0";
             }
             if ($("#chkAntibiotics").is(':checked') == true) {

                 ObjIntake.Antibiotics = "1";
             }
             else {
                 ObjIntake.Antibiotics = "0";
             }
             if ($("#chkMagSO4").is(':checked') == true) {

                 ObjIntake.MagSO4 = "1";
             }
             else {
                 ObjIntake.MagSO4 = "0";
             }

             if ($("#chkOther5").is(':checked') == true) {

                 ObjIntake.Other5 = "1";
             }
             else {
                 ObjIntake.Other5 = "0";
             }
             ObjIntake.Other5Comment = $("#txtOther5Comment").val();
             if ($("#chkRecordedOnRegistrationBook").is(':checked') == true) {

                 ObjIntake.RecordedOnRegistrationBook = "1";
             }
             else {
                 ObjIntake.RecordedOnRegistrationBook = "0";
             }
             if ($("#chkNoAckOfBirthNotCompleted").is(':checked') == true) {

                 ObjIntake.NoAckOfBirthNotCompleted = "1";
             }
             else {
                 ObjIntake.NoAckOfBirthNotCompleted = "0";
             }
             ObjIntake.DischargeDate1 = $("#txtDischargeDate1").val();
             ObjIntake.DischargeCondition = $("#txtDischargeCondition").val();
             ObjIntake.DischargeWeight = $("#txtDischargeWeight").val();
             ObjIntake.HeadCircumtrence = $("#txtHeadCircumtrence").val();
             if ($("#chkChildHealthCardMade").is(':checked') == true) {

                 ObjIntake.ChildHealthCardMade = "1";
             }
             else {
                 ObjIntake.ChildHealthCardMade = "0";
             }
             ObjIntake.BCGDate = $("#txtBCGDate").val();
             ObjIntake.PolioDate = $("#txtPolioDate").val();
             ObjIntake.ReturnToMCHDate = $("#txtReturnToMCHDate").val();
             ObjIntake.IfDeathDate = $("#txtIfDeathDate").val();
             ObjIntake.DeathTime = $("#txtDeathTime_txtTime").val();
             ObjIntake.CauseOfDeath = $("#txtCauseOfDeath").val();
             ObjIntake.AgeAtDeath = $("#txtAgeAtDeath").val();
             ObjIntake.ParentGuardian = $("#txtParentGuardian").val();
             ObjIntake.Witness = $("#txtWitness").val();
             ObjIntake.HusbandGuardian1 = $("#txtHusbandGuardian1").val();
             ObjIntake.Witness1 = $("#txtWitness1").val();
             dataIntake.push(ObjIntake);
             return dataIntake;
         }
         function bindGrid() {

             location.reload(true);
        }
        function saveIntake1() {

            var d = prepareData();
            var TID = '<%=Util.GetString(Request.QueryString["TransactionID"])%>';
            var PID = '<%=Util.GetString(Request.QueryString["PID"])%>';
            if (d != "") {
                $.ajax({
                    type: "POST",
                    data: JSON.stringify({ intake: d, PID: PID, TID: TID }),
                    url: "./NewBornDetails.aspx/saveIntake",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        output = (result.d);
                        if (output == "1") {
                            alert('Record Saved Successfully');
                            clear();
                            $("#btnSave").show();
                            $("#btnUpdate").hide();
                            bindGrid();

                        }
                        else {
                            alert('Error occurred, Please contact administrator');
                            bindGrid();
                        }
                        $('#btnSave').removeProp('disabled');

                    },
                    error: function (xhr, status) {

                    }

                });
            }
            else {
                // $("#lblMsg").text('Please Select At Least One CheckBox');
            }
        }
        function updateIntake1() {

            var d = prepareData();
            var id =$("#txtPID").val();
            var TID = "";
            var PID = "";
            if (d != "") {
                $.ajax({
                    type: "POST",
                    data: JSON.stringify({ intake: d, PID: id, TID: '' }),
                    url: "./NewBornDetails.aspx/updateIntake",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (result) {
                        output = (result.d);
                        if (output == "1") {
                            
                            alert('Record Updated Successfully');
                            $("#grdPhysical").load(location.href + " #grdPhysical");

                            clear();
                            $("#btnSave").show();
                            $("#btnUpdate").hide();
                            
                            
                            
                        }
                        else {
                            alert('Error occurred, Please contact administrator');
                           
                        }


                    },
                    error: function (xhr, status) {

                    }

                });
                
            }
            else {
                // $("#lblMsg").text('Please Select At Least One CheckBox');
            }
            
        }
        function clear() {
            $("input[type=text]").val('');

            $("input[type=checkbox]").prop('checked', false);


            $("#txtDate").val(getCurrDate());
            $("#txtDate1").val(getCurrDate());
            $("#txtDate2").val(getCurrDate());
            $("#txtDate3").val(getCurrDate());
            $("#txtDischargeDate").val(getCurrDate());
            $("#txtDischargeDate1").val(getCurrDate());
            $("#txtGestationByDate").val(getCurrDate());
            $("#txtDate4").val(getCurrDate());
            $("#txtRupturedMembranesDate").val(getCurrDate());
            $("#txtBCGDate").val(getCurrDate());
            $("#txtPolioDate").val(getCurrDate());
            $("#txtReturnToMCHDate").val(getCurrDate());
            $("#txtIfDeathDate").val(getCurrDate());

            $("#StartTime_txtTime").val(getCurrTime());
            $("#txtTime1_txtTime").val(getCurrTime());
            $("#txtTime3_txtTime").val(getCurrTime());
            $("#txtDeathTime_txtTime").val(getCurrTime());
           
         }

    </script>
   
    <form id="form1" runat="server">
    
       <cc1:ToolkitScriptManager ID="toolScriptManageer1" runat="server"></cc1:ToolkitScriptManager> 
        <%--<div>&nbsp;&nbsp;&nbsp;<a id="AddToFavorites" onclick="AddPage('cpoe_Vital.aspx','Vital Sign')" href="#">Add To Favorites</a>&nbsp;&nbsp;&nbsp;&nbsp;<span id="Msg" class="ItDoseLblError"></span></div>--%>
        <div id="Pbody_box_inventory" style="text-align: center;">
                <b>New Born Admission Note</b><br />
                <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
                  
            <div class="POuter_Box_Inventory" style="text-align: center;">
                            <div class="row">
                                <div class="col-sm-2">

                                    
                                </div>
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
                                <div class="col-md-8">
                                    
                            <uc2:StartTime ID="StartTime" runat="server" />
                                </div>

                            </div>



                        </div>
        
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="Purchaseheader">
                    &nbsp;New Born Details&nbsp;:&nbsp;
                </div>
               </div>
        
            <div class="POuter_Box_Inventory">
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-10">
                            <input runat="server" id="chkAlive" type="checkbox" /><label >Alive</label>
                            <input runat="server" id="chkFreshStillBirth" type="checkbox" /><label >Fresh StillBirth</label>
                            <input runat="server" id="chkMaceratedStillBirth" type="checkbox" /><label >Macerated StillBirth</label>
                            <input runat="server" id="chkSingle" type="checkbox" /><label >Single</label>
                            <input runat="server" id="chkTwin" type="checkbox" /><label >Twin</label>
                            <input runat="server" id="chkTriplet" type="checkbox" /><label >Triplet</label>
                        </div>
                               </div>
                    
                       
                </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">Birth weight</div>
                               <div class="col-md-5">
                                    <asp:TextBox ID="txtBirthWeight" runat="server" Width="200px"  onkeypress="return isAlphaNumeric(event,this.value);" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            
                               </div>
                               <div class="col-md-3">H.C </div>
                               <div class="col-md-5">
                                    <asp:TextBox ID="txtHC" runat="server" Width="200px"  onkeypress="return isAlphaNumeric(event,this.value);" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            
                               </div>
                               <div class="col-md-3">Length</div>
                               <div class="col-md-5">
                                    <asp:TextBox ID="txtLength" runat="server" CssClass="Number"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            
                               </div>
                        
                        
                               </div>
                    
                
            </div>
            <div class="row">
                           <div class="col-md-24">
                           
                               <div class="col-md-8">
                                    <table style="width:100%;">
                                        <tr><td>APGAR SCORE</td><td>1 min</td><td>5 min</td><td><asp:TextBox ID="txtApgarScore3" runat="server" Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </td></tr>
                                         <tr><td>Heart </td>
                                             <td><asp:TextBox ID="txtHeart1"  CssClass="Number"  runat="server" Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtHeart2"  CssClass="Number"  runat="server" Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtHeart3" CssClass="Number"  runat="server" Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </td></tr>
                                         <tr><td>Respiratory Effort </td>
                                             <td><asp:TextBox ID="txtRespiratoryEffort1" CssClass="Number"  runat="server"  Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtRespiratoryEffort2" CssClass="Number"  runat="server"  Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtRespiratoryEffort3" CssClass="Number"  runat="server"  Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </td></tr>
                                          <tr><td>Muscle tone  </td>
                                             <td><asp:TextBox ID="txtMuscletone1" CssClass="Number"  runat="server"   Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtMuscletone2" CssClass="Number"  runat="server" Width="30px"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtMuscletone3" CssClass="Number"  runat="server" Width="30px"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </td></tr>
                                          <tr><td>Reflux response to stimulus </td>
                                             <td><asp:TextBox ID="txtRefluxResponseToStimulus1" CssClass="Number"  runat="server"  Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtRefluxResponseToStimulus2" CssClass="Number"  runat="server"  Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtRefluxResponseToStimulus3" CssClass="Number"  runat="server"  Width="30px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </td></tr>
                                          <tr><td>Colour  </td>
                                             <td><asp:TextBox ID="txtColour1" CssClass="Number"  runat="server" Width="30px"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtColour2" CssClass="Number"  runat="server" Width="30px"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtColour3" CssClass="Number"  runat="server" Width="30px"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </td></tr>
                                          <tr><td>Total score  </td>
                                             <td><asp:TextBox ID="txtTotalScore1" runat="server" Width="30px"  CssClass="Number"   ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtTotalScore2" runat="server" Width="30px"  CssClass="Number"   ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox></td>
                                             <td><asp:TextBox ID="txtTotalScore3" runat="server" Width="30px"  CssClass="Number"   ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </td></tr>
                                    </table>
                               </div>
                </div>
                </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">ATTENTION</div>
                               
                        <div class="col-md-8">
                            
                            <input runat="server" id="chkMicroniumAspiration" type="checkbox" /><label >miconium Aspiration</label>
                            <input runat="server" id="chkCordAroundNeckx" type="checkbox" /><label >Cord around neck x</label>
                            <input runat="server" id="chkOther" type="checkbox" /><label >Other</label>
                         
                        </div>
                               
                        <div class="col-md-3"><asp:TextBox ID="txtOtherComment" runat="server" Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                            </div>
                               </div>
                    </div>
            </div>
        
        
            <div class="POuter_Box_Inventory">Treatment To Baby</div>
        
            <div class="POuter_Box_Inventory">
                
                <div class="row">
                           
                        <div class="col-md-24">
                              <input runat="server" id="chkTetracycline" type="checkbox"  name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Tetracycline</label>
                            
                              <input runat="server" id="chkVitK" type="checkbox" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Vit.K</label>
                            
                              <input runat="server" type="checkbox" id="chkResuscitation" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Resuscitation</label>
                            
                              <input runat="server" type="checkbox" id="chkO2" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> O<sub>2</sub></label>
                            
                              <input runat="server" type="checkbox" id="chkAmbu" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Ambu</label>
                            
                              <input runat="server" type="checkbox" id="chkIntubation" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Intubation</label>
                            
                              <input runat="server" type="checkbox" id="chkCardiacCompression" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Cardiac Compression</label>
                        </div>
                               
                    </div>
                     
                <div class="row">
                        <div class="col-md-3">NewBorn Exam
                            </div>
                                  
                        <div class="col-md-4">
                            
                              
                            </div>
                               
                        
                           
                        <div class="col-md-6">
                              <input runat="server" type="checkbox" id="chkInjury" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> injury : specify</label>
                            <input runat="server" id="txtInjurySpecify" type="text" style="width:200px;" onkeypress="return isAlphaNumeric(event,this.value);"  />
                            </div>
                               
                        <div class="col-md-8">
                              <input runat="server" type="checkbox" id="chkCongenitalAbnormalities" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> congenital abnormalities:specify</label>
                            <input runat="server" type="text" id="txtCongenitalAbnormalitiesSpecify" onkeypress="return isAlphaNumeric(event,this.value);"  style="width:200px;" />
                            </div>
                               
                        <div class="col-md-10">
                              <input runat="server" type="checkbox" id="chkRespiratoryDistress" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Respiratory distress</label>
                            
                              <input runat="server" type="checkbox" id="chkOther1" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> other:specify</label>
                            <input runat="server" id="txtOther1Specify" type="text"  onkeypress="return isAlphaNumeric(event,this.value);"  style="width:200px;" />
                            </div>
                               </div>
                    
                    <div class="row">
                        
                        <div class="col-md-6">Signature of Admitting Nurse
                            </div>
                                  
                        <div class="col-md-4">
                            
                           
                            </div>
                        
                        <div class="col-md-3">Date 
                            </div>
                                  
                        <div class="col-md-4">
                            
                            <asp:TextBox ID="txtDate1" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender12" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDate1" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                
                            </div>
                    </div>
                    
                    <div class="row">
                        
                        <div class="col-md-3">Baby
                            </div>
                                  
                        <div class="col-md-12">
                            
                              <input runat="server" type="checkbox" id="chkToMotherCare" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> to mother care date</label>
                          <asp:TextBox ID="txtDate2" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender1" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDate2" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                
                            
                              <input runat="server" type="checkbox" id="chkToNursary" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> to nursary date</label>
                            <asp:TextBox ID="txtDate3" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender2" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDate3" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                
                            </div>
                        <div class="col-md-3">Reason 
                            </div>
                                  
                        <div class="col-md-4">
                            
                            <asp:TextBox ID="txtReason" runat="server" Width="200px" onkeypress="return isAlphaNumeric(event,this.value);"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                        </div>
                    
                    <div class="row">
                        <div class="col-md-3">Discharge Date 
                            </div>
                                  
                        <div class="col-md-4">
                            <asp:TextBox ID="txtDischargeDate" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender3" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDischargeDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                
                            
                            </div>
                        <div class="col-md-3"># Days 
                            </div>
                                  
                        <div class="col-md-4">
                            
                            <asp:TextBox ID="txtDays" runat="server" Width="200px"  CssClass="Number"   ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>



                        </div>
                </div>
                    </div>
                               
            </div>
          </div>
        <div class="POuter_Box_Inventory">
            
                <div class="Purchaseheader">
                    &nbsp;MOTHER PRENATAL HISTORY&nbsp;:&nbsp;
                </div>
            </div>
        <div class="POuter_Box_Inventory">
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">Mothers age</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMotherAge"  CssClass="Number"   runat="server" Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               
                        <div class="col-md-3">G</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtG" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               
                        <div class="col-md-3">P</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtP" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">+</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPlus" onkeypress="return isAlphaNumeric(event,this.value);"  runat="server" Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               
                        <div class="col-md-3">LMP</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLMP" runat="server" Width="200px" onkeypress="return isAlphaNumeric(event,this.value);"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               
                        <div class="col-md-3">Gestation By date</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtGestationByDate" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender5" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtGestationByDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">Gestation By UIS</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtGestationByUIS" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               <div class="col-md-3">No of Prenatal</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtNoOfPrenatal" runat="server"  CssClass="Number"   Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               <div class="col-md-3">Where</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtWhere" runat="server" Width="200px" onkeypress="return isAlphaNumeric(event,this.value);"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               </div>
                    </div>


        </div>
        
        <div class="POuter_Box_Inventory">Prenatal Lab Result</div>
        <div class="POuter_Box_Inventory">
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">BloodType/Rhesus</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBloodTypeRhesus" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               
                        <div class="col-md-3">Hgb</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtHgb" runat="server" Width="200px" onkeypress="return isAlphaNumeric(event,this.value);"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               
                        <div class="col-md-3">VRDL</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtVRDL" runat="server" Width="200px" onkeypress="return isAlphaNumeric(event,this.value);"  ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">PMCT Serology</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPMCTSerology" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               
                       
                               
                        <div class="col-md-8">
                           
                              <input runat="server" type="checkbox" id="chkpos" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> pos</label>
                            
                              <input runat="server" type="checkbox" id="chkneg" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> neg</label>
                            
                              <input runat="server" type="checkbox" id="chkrefused" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> refused</label>
                        </div>
                               
                        <div class="col-md-3">Prenatal Complications</div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPrenatalComplications" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                           </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                               
                        <div class="col-md-18">
                            <input runat="server" type="checkbox" id="chkpreeclampsia1" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Pre-eclampsia</label>
                            
                            <input runat="server" type="checkbox" id="chkEclampsia" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Eclampsia</label>
                            
                            <input runat="server" type="checkbox" id="chkOligoHydramnios" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Oligo hydramnios</label>
                            
                            <input runat="server" type="checkbox" id="chkPolyHydramnios" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Polyhydramnios</label>
                            
                            <input runat="server" type="checkbox" id="chkAPH1" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> APH</label>
                            
                            <input runat="server" type="checkbox" id="chkGestDiabetes" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Gest,Diabetes</label>
                            
                            <input runat="server" type="checkbox" id="chkTwins1" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> twins</label>
                            
                              <input runat="server" type="checkbox" id="chkOther2" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Others</label>
                            <input runat="server" id="txtOther2Comment" type="text" onkeypress="return isAlphaNumeric(event,this.value);"  style="width:200px;" />
                            </div>
                               </div>
                    </div>
            </div>
        
        <div class="POuter_Box_Inventory">Previous OB Hx</div>
        <div class="POuter_Box_Inventory">
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-24">
                            
                              <input runat="server" type="checkbox" id="chkAbnormalDeliveries" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Abnormal Deliveries</label>
                            
                              <input runat="server" type="checkbox" id="chkCS" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> C/S</label>
                            
                              <input runat="server" type="checkbox" id="chkVacuumForceps" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> vacuum /forceps</label>
                            
                              <input runat="server" type="checkbox" id="chkTwins" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> twins</label>
                            
                              <input runat="server" type="checkbox" id="chkAPH" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> APH</label>
                            
                              <input runat="server" type="checkbox" id="chkPPH" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> PPH</label>
                            
                              <input runat="server" type="checkbox" id="chkpreeclampsia" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> pre-eclampsia</label>
                            
                              <input runat="server" type="checkbox" id="chkstillbirth" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> still birth</label>
                            
                              <input runat="server" type="checkbox" id="chkpreterm" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> preterm</label>
                            
                              <input runat="server" type="checkbox" id="chkFirstWeekMortality" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> 1st week mortality</label>
                            
                              <input runat="server" type="checkbox" id="chkNeonatalJaundice" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> neonatal jaundice</label>
                            
                              <input runat="server" type="checkbox" id="chkCongeriltalAbnorm" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> congeriltal abnorm</label>
                            <br />
                              <input runat="server" type="checkbox" id="chkOther3" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> other</label>
                            <input runat="server" id="txtOther3Comment" onkeypress="return isAlphaNumeric(event,this.value);"  type="text" style="width:200px;" />

                        </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-24">
                            MedlSurg
                            <input runat="server" type="checkbox" id="chkHx" name="vehicle1" value="Bike" />
                              <label for="vehicle1">  Hx</label>
                            <input runat="server" type="checkbox" id="chkTh" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Th</label>
                            <input runat="server" type="checkbox" id="chkKidney" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Kidney</label>
                            <input runat="server" type="checkbox" id="chkHeartDisease" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Heart disease</label>
                            <input runat="server" type="checkbox" id="chkHypertension" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Hypertension</label>
                            <input runat="server" type="checkbox" id="chkDiabetes" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> diabetes</label>
                            <input runat="server" type="checkbox" id="chkConvulsions" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> convulsions Other</label>
                            
                            <input runat="server" id="txtOther4" onkeypress="return isAlphaNumeric(event,this.value);"  type="text" style="width:200px;" />
                            </div>

                           </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                       <div class="col-md-3">Presenting Hx on Admission Mother
                            </div>
                                  
                        <div class="col-md-4">
                            
                            <asp:TextBox ID="txtPresentingHxonAdmissionMother" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>

        </div>
                    </div>
            </div>
        
        <div class="POuter_Box_Inventory">Labour History :onset</div>
        <div class="POuter_Box_Inventory">
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">Date
                            </div>
                               
                        <div class="col-md-5">
                             <asp:TextBox ID="txtDate4" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender4" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDate4" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                
                            </div>
                               <div class="col-md-3">Time
                            </div>
                               
                        <div class="col-md-5">
                           
                            <uc2:StartTime ID="txtTime1" runat="server" />
                            </div>
                               <div class="col-md-3">Ruptured membranes date
                            </div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRupturedMembranesDate" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender6" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtRupturedMembranesDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                
                            </div>
                             
                                 </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">Time
                            </div>
                               
                        <div class="col-md-5">
                           
                            <uc2:StartTime ID="txtTime3" runat="server" />
                            </div>
                               
                        <div class="col-md-3">Colour
                            </div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtColour" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                               
                        <div class="col-md-3">Comment
                            </div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtComment" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-8">
                            
                            <input runat="server" type="checkbox" id="chkNST" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> NST</label>
                            
                            <input runat="server" type="checkbox" id="chkReactive" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> reactive</label>
                            
                            <input runat="server" type="checkbox" id="chkNonReactive" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> non-reactive </label>
                            </div>
                               
                        <div class="col-md-3">Comment
                            </div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtComment1" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                               
                        <div class="col-md-3">U/S
                            </div>
                               
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUS" runat="server" onkeypress="return isAlphaNumeric(event,this.value);"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">Length 1' Stage
                            </div>
                               <div class="col-md-5">
                            <asp:TextBox ID="txtOneStage" runat="server"  CssClass="Number"   Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                               
                        <div class="col-md-3">2' Stage
                            </div>
                               <div class="col-md-5">
                            <asp:TextBox ID="txtTwoStage" runat="server"  CssClass="Number"   Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                               
                        <div class="col-md-3">3' Stage
                            </div>
                               <div class="col-md-5">
                            <asp:TextBox ID="txtThreeStage" runat="server"  CssClass="Number"  Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                        
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                           
                        <div class="col-md-3">=Total hours of Labour
                            </div>
                               <div class="col-md-5">
                            <asp:TextBox ID="txtTotalHoursOfLabour" runat="server"  CssClass="Number"   Width="200px" ClientIDMode="Static" TabIndex="6" MaxLength="100" ToolTip="Enter Nr. of fetuses" AutoCompleteType="None"></asp:TextBox>                                
                          
                            </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                               
                               <div class="col-md-24"> Type of delivery
                                   
                            <input runat="server" type="checkbox" id="chkVagVtx" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> vag/vtx</label>
                                   
                            <input runat="server" type="checkbox" id="chkAssistedBreech" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> assisted breech</label>
                                   
                            <input runat="server" type="checkbox" id="chkPitocinCytotec" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Pitocin/Cytotec</label>
                                   
                            <input runat="server" type="checkbox" id="chkVacuum2" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Vacuum</label>
                                   
                            <input runat="server" type="checkbox" id="chkForceps2" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> forceps</label>
                                   
                            <input runat="server" type="checkbox" id="chkCSElectiveEmergency" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> C/S Elective/Emergency </label>
                                   Reason
                                   
                            <input runat="server" id="txtReason1" type="text" onkeypress="return isAlphaNumeric(event,this.value);"  style="width:200px;" />
                                   </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                               
                               <div class="col-md-24"> Treatment given to mother
                                   
                            <input runat="server" type="checkbox" id="chkDexamethasone" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Dexamethasone</label>
                                   
                            <input runat="server" type="checkbox" id="chkAntibiotics" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Antibiotics</label>
                                   
                            <input runat="server" type="checkbox" id="chkMagSO4" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> MagSO<sub>4</sub></label>
                                   
                            <input runat="server" type="checkbox" id="chkOther5" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Other</label>
                                   
                            
                            <input runat="server" id="txtOther5Comment" onkeypress="return isAlphaNumeric(event,this.value);"  type="text" style="width:200px;" />

                               </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                               
                               <div class="col-md-16">
                            <input runat="server" type="checkbox" id="chkRecordedOnRegistrationBook" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Newborn recorded on BIRTH Registration Book</label>
                                   
                                   
                            <input runat="server" type="checkbox" id="chkNoAckOfBirthNotCompleted" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> No Acknowledgement of Birth Notification Completed</label>

                                   
                                   
                                   </div>
                               
                               <div class="col-md-3">
                                   Discharge Date
                                   </div>
                               
                               <div class="col-md-3">
                                   <asp:TextBox ID="txtDischargeDate1" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender7" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDischargeDate1" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                            
                                   </div>


                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                               
                           <div class="col-md-3">Condition At Discharge if Living

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtDischargeCondition" onkeypress="return isAlphaNumeric(event,this.value);"  type="text" style="width:200px;" />
                                   </div>
                    <div class="col-md-3">Discharge Weight

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtDischargeWeight"  class="Number"   type="text" style="width:200px;" />
                                   </div>
                                <div class="col-md-3">Head circumtrence

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtHeadCircumtrence" onkeypress="return isAlphaNumeric(event,this.value);"  type="text" style="width:200px;" />
                                   </div>
                   
                   
                                </div>
            </div>
            
                <div class="row">
                           <div class="col-md-24">
                               
                           <div class="col-md-3">

                               </div>
                               <div class="col-md-5">
                                   <input runat="server" type="checkbox" id="chkChildHealthCardMade" name="vehicle1" value="Bike" />
                              <label for="vehicle1"> Child Health Card Made</label>
                                   
                            
                                   </div>
                               
                                <div class="col-md-3">BCG Date

                               </div>
                               <div class="col-md-5">
                                   
                                      <asp:TextBox ID="txtBCGDate" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender10" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtBCGDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                 </div>
                               
                                <div class="col-md-3">Polio Date

                               </div>
                               <div class="col-md-5">
                                   
                                      <asp:TextBox ID="txtPolioDate" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender11" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtPolioDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                 </div>
                               </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                               
                           <div class="col-md-3">Date of return to MCH Clinic

                               </div>
                               <div class="col-md-5">
                                    <asp:TextBox ID="txtReturnToMCHDate" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender8" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtReturnToMCHDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                            
                                   </div>
                            <div class="col-md-3">if death Date

                               </div>
                               <div class="col-md-5">
                                           <asp:TextBox ID="txtIfDeathDate" runat="server" Width="200px" ></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="CalendarExtender9" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtIfDeathDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                            
                                   </div>
                               <div class="col-md-3">Time

                               </div>
                               <div class="col-md-5">
                                   
                            <uc2:StartTime ID="txtDeathTime" runat="server" />
                                   </div>
                            
                            
                                  </div>
                    </div>
            
                <div class="row">
                           <div class="col-md-24">
                               
                           <div class="col-md-3">Cause of Death

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtCauseOfDeath" onkeypress="return isAlphaNumeric(event,this.value);"  type="text" style="width:200px;" />
                                   </div>
                            <div class="col-md-3">Age At Death

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtAgeAtDeath" type="text"  class="Number"   style="width:200px;" />
                                   </div>
                                           </div>
                    </div>
                 </div>
        <div class="POuter_Box_Inventory">Signature Of Person taking Body for Burial</div>
                <div class="POuter_Box_Inventory">
                     <div class="row">
                           <div class="col-md-24">
                            <div class="col-md-3">Parent/guardian

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtParentGuardian" onkeypress="return isAlphaNumeric(event,this.value);"  type="text" style="width:200px;" />
                                   </div>
                   
                               
                           <div class="col-md-3">Witness(Hospital)

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtWitness" onkeypress="return isAlphaNumeric(event,this.value);"  type="text" style="width:200px;" />
                                   </div>
                               </div>
                         </div>
                    </div>
        <div class="POuter_Box_Inventory">Consent for Disposal of body if not taken Home</div>
                <div class="POuter_Box_Inventory">
                     <div class="row">
                           <div class="col-md-24">
                               
                           <div class="col-md-3">Husband /Guardian

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtHusbandGuardian1" type="text" onkeypress="return isAlphaNumeric(event,this.value);"  style="width:200px;" />
                                   </div>
                               
                           <div class="col-md-3">Witness(Hospital)

                               </div>
                               <div class="col-md-5">
                                   
                               <input runat="server" id="txtWitness1" type="text" onkeypress="return isAlphaNumeric(event,this.value);"  style="width:200px;" />
                                   </div>
                               </div>
                    </div>
            </div>
                               
          <div class="POuter_Box_Inventory" style="text-align: center">
              <input id="txtPID" runat="server" type="hidden" />
                <asp:Label ID="lblPID" runat="server"  Visible="false"></asp:Label>
              <button id="btnSave" onclick="saveIntake1();" value="Save" class="ItDoseButton" runat="server" >Save</button>
                <%--<asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static" OnClientClick="saveIntake1()" TabIndex="69"  />
                --%>
              <%--<asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="false" ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return chkVital(this)" OnClick="btnUpdate_Click" />
              --%>
              <button id="btnUpdate" onclick="updateIntake1();" value="Update" class="ItDoseButton" runat="server"  >Update</button>
            
              <button id="btnCancel" onclick="clear();" value="Cancel" class="ItDoseButton" >Cancel</button>
               <%-- <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" OnClick="btnCancel_Click" />
            --%>

          </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                
				<%--<div id="IPDOutput" style="height:280px;width:100%;overflow-y:auto"> </div>
           --%>
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
                        <asp:TemplateField HeaderText="Birth Weight">
                            <ItemTemplate>
                                <asp:Label ID="lblPUPLISLR" runat="server" Text='<%#Eval("BirthWeight") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="HC">
                            <ItemTemplate>
                                <asp:Label ID="lblReactionLR" runat="server" Text='<%#Eval("HC") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Length">
                            <ItemTemplate>
                                <asp:Label ID="lblTemp" runat="server" Text='<%#Eval("Length") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MotherAge">
                            <ItemTemplate>
                                <asp:Label ID="lblHR" runat="server" Text='<%#Eval("MotherAge") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="G">
                            <ItemTemplate>
                                <asp:Label ID="lblRhythm" runat="server" Text='<%#Eval("G") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="P">
                            <ItemTemplate>
                                <asp:Label ID="lblABP" runat="server" Text='<%#Eval("P") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Plus" Visible="true">
                            <ItemTemplate>
                                <asp:Label ID="lblMAP" runat="server" Text='<%#Eval("Plus") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="LMP">
                            <ItemTemplate>
                                <asp:Label ID="lblCVP" runat="server" Text='<%#Eval("LMP") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="GestationByUIS">
                            <ItemTemplate>
                                <asp:Label ID="lblPulses" runat="server" Text='<%#Eval("GestationByUIS") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
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
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false"  CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblUserID" Text='<%#Eval("EntryBy") %>' runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblID" Text='<%#Eval("Id") %>' CssClass="siteLbl" runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        
     
	  

    </form>
</body>
</html>
