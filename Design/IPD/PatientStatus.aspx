<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientStatus.aspx.cs" Inherits="Design_IPD_PatientStatus" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />

</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script src="../../Scripts/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            CheckDetails();
            BindDetails();


        });

        function CheckDetails() {
            
            var data = {
                ID: '<%=Util.GetString(ViewState["ID"])%>',
                RoleID: '<%=Util.GetString(Session["RoleID"])%>',
                TID: $('#hdnTID').val(),
            }
            serverCall('PatientStatus.aspx/CheckDetails', data, function (response) {
                
               if (response != null && response != undefined && response != '' && response.length > 0) {

                    var responseData = JSON.parse(response);
                    $(responseData).each(function () {
                        modelAlert(responseData.message, function () {
                           
                        });
                    });
                }
            });
        }

        function BindDetails() {
            
            var data = {
                CenterId: '<%=Util.GetString(Session["CentreID"])%>',
                TID: $('#hdnTID').val(),
            }
            serverCall('PatientStatus.aspx/LoadDetails', data, function (response) {
                
                if (response != null && response != undefined && response != '' && response.length > 0) {

                    var responseData = JSON.parse(response);
                    $(responseData).each(function () {
                        $('#PatStatusScreenDiv').show();
                        bindDischargeScreen(responseData);
                    });
                }
            });
        }


        var bindDischargeScreen = function (data, callback) {
            
            //var _tablePStatus = $('#PatientStatusScreen tbody');
            var _Table1 = $('#Table1 tbody');
            var _Table2 = $('#Table2 tbody');
            var _Table3 = $('#Table3 tbody');
            var _Table4 = $('#Table4 tbody');
            var _Table5 = $('#Table5 tbody');
            var _Table6 = $('#Table6 tbody');
            var _Table7 = $('#Table7 tbody');
            var _Table8 = $('#Table8 tbody');


            $('#Table1 tbody').find('tr').remove();
            $('#Table2 tbody').find('tr').remove();
            $('#Table3 tbody').find('tr').remove();
            $('#Table4 tbody').find('tr').remove();
            $('#Table5 tbody').find('tr').remove();
            $('#Table6 tbody').find('tr').remove();
            $('#Table7 tbody').find('tr').remove();
            $('#Table8 tbody').find('tr').remove();

            var rdisInt = '<tr class="GridViewItemStyle" >';
            var rmed = '<tr class="GridViewItemStyle" >';
            var rBillF = '<tr class="GridViewItemStyle" >';
            var rDisch = '<tr class="GridViewItemStyle" >';
            var rBillG = '<tr class="GridViewItemStyle" >';
            var rPatClr = '<tr class="GridViewItemStyle" >';
            var rNurClr = '<tr class="GridViewItemStyle" >';
            var rRomClr = '<tr class="GridViewItemStyle" >';
         
                if (data[0].Intemation == '') {
                    rdisInt += '<td  id="tdDischargeINT"><input type="button" id="btnDischargeINt" value="Discharge Intimation"  disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" /><br /><label  id="lblDisInt" style="text-align:center">' + data[0].Intemation + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].IntemationTime + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].DischargeIntimateBy + '</label></td>  ';

                    rmed += '<td  id="tdMeddClear"><input   type="button" id="btnMedClearance" value="Pharmacy Clearance" onclick="$openPharmacyDiv()" disabled="disabled"style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" /><br /><label  id="lblMedClen" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].MedClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].MedClearnaceTime + '</label><br /><label  id="lblMedClenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].MedClearedBy + '</label></td>  ';
                    $('#disInDiv').css('background-color', 'Yellow');
                }
                else {
                    rdisInt += '<td  id="tdDischargeINT"><input type="button" id="btnDischargeINt" value="Discharge Intimation"  disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" /><br /><label  id="lblDisInt" style="text-align:center">' + data[0].Intemation + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].IntemationTime + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].DischargeIntimateBy + '</label></td>  ';

                    $('#disInDiv').css('background-color', 'LightGreen');
                }
                if (data[0].MedClearnace == '' && data[0].Intemation != '') {
                    rmed += '<td id="tdMeddClear" ><input  type="button" id="btnMedClearance" value="Pharmacy Clearance" onclick="$openMobileAppBookingModel()"    style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" /><br /> <label  id="lblMedClen" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].MedClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].MedClearnaceTime + '</label><br /><label  id="lblMedClenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].MedClearedBy + '</label></td>  ';

                    $('#MEDClrDiv').css('background-color', 'Red');
                }
                else {
                    if (data[0].MedClearnace == '') {
                        rmed += '<td  id="tdMeddClear" ><input  type="button" id="btnMedClearance" value="Pharmacy Clearance" onclick="$openPharmacyDiv()"   disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" /><br /><label  id="lblMedClen" style="text-align:center">' + data[0].MedClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].MedClearnaceTime + '</label><br /><label  id="lblMedClenBy" style="text-align:center">' + data[0].MedClearedBy + '</label></td>  ';
                        $('#MEDClrDiv').css('background-color', 'Yellow');
                    }
                    else {
                        rmed += '<td id="tdMeddClear" ><input  type="button" id="btnMedClearance" value="Pharmacy Clearance" onclick="$openPharmacyDiv()"   disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" /><br /><label  id="lblMedClen" style="text-align:center">' + data[0].MedClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].MedClearnaceTime + '</label><br /><label  id="lblMedClenBy" style="text-align:center">' + data[0].MedClearedBy + '</label></td>  ';
                        $('#MEDClrDiv').css('background-color', 'LightGreen');
                    }
                }
                if (data[0].BillFreeze == '' && data[0].MedClearnace != '') {
                    rBillF += '<td  id="tdBillFreeze"><input type="button" id="btnBillFreeze" value="Bill Freezed"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" onclick="SaveBillFreezed()" /><br /><label  id="lblBillFreeze" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillFreezeTime + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillFreezedUser + '</label></td>  ';

                    $('#BILLFrzDiv').css('background-color', 'Red');
                }
                else {
                    if (data[0].BillFreeze == '') {
                        rBillF += '<td  id="tdBillFreeze"><input type="button" id="btnBillFreeze" value="Bill Freezed"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" onclick="$openBillFreezeDiv()"  disabled="disabled"/><br /><label  id="lblBillFreeze" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillFreeze + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillFreezeTime + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillFreezedUser + '</label></td>  ';

                        $('#BILLFrzDiv').css('background-color', 'Yellow');
                    }
                    else {
                        rBillF += '<td  id="tdBillFreeze"><input type="button" id="btnBillFreeze" value="Bill Freezed"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;" onclick="$openBillFreezeDiv()" disabled="disabled" /><br /><label  id="lblBillFreeze" style="text-align:center">' + data[0].BillFreeze + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].BillFreezeTime + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].BillFreezedUser + '</label></td>  ';

                        $('#BILLFrzDiv').css('background-color', 'LightGreen');
                    }
                }
                if (data[0].DischargeDate == '' && data[0].BillFreeze != '') {
                    rDisch += '<td id="tdDischarge"  ><input type="button" id="btnDischarge" value="Discharge" disabled="disabled" style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblDis" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].DischargeDate + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].DischargeTime + '</label><br /><label  id="lblDisBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].DischargedBy + '</label></td> ';
                    $('#DischrgDiv').css('background-color', 'Red');
                }

                else {
                    if (data[0].BillFreeze == '') {
                        rDisch += '<td id="tdDischarge" ><input type="button" id="btnDischarge" value="Discharge" disabled="disabled"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblDis" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].DischargeDate + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].DischargeTime + '</label><br /><label  id="lblDisBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].DischargedBy + '</label></td> ';
                        $('#DischrgDiv').css('background-color', 'Yellow');
                    }
                    else {
                        rDisch += '<td  id="tdDischarge" ><input type="button" id="btnDischarge" value="Discharge" disabled="disabled"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblDis" style="text-align:center">' + data[0].DischargeDate + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].DischargeTime + '</label><br /><label  id="lblDisBy" style="text-align:center">' + data[0].DischargedBy + '</label></td> ';
                        $('#DischrgDiv').css('background-color', 'LightGreen');
                    }
                }
                if (data[0].BillDate == '' && data[0].DischargeDate != '') {
                    rBillG += '<td  id="tdBillGenerate" ><input type="button" id="btnBillGenerated" value="Bill Generated" disabled="disabled"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblBillGen" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillDate + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillTime + '</label><br /><label  id="lblBillGenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillGenBy + '</label></td> ';
                    $('#BillGenDiv').css('background-color', 'Red');
                }
                else {
                    if (data[0].DischargeDate == '') {
                        rBillG += '<td  id="tdBillGenerate" ><input type="button" id="btnBillGenerated" value="Bill Generated" disabled="disabled"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblBillGen" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillDate + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillTime + '</label><br /><label  id="lblBillGenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].BillGenBy + '</label></td> ';
                        $('#BillGenDiv').css('background-color', 'Yellow');
                    }
                    else {
                        rBillG += '<td  id="tdBillGenerate" ><input type="button" id="btnBillGenerated" value=" Bill Generated " disabled="disabled"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblBillGen" style="text-align:center">' + data[0].BillDate + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].BillTime + '</label><br /><label  id="lblBillGenBy" style="text-align:center">' + data[0].BillGenBy + '</label></td> ';
                        $('#BillGenDiv').css('background-color', 'LightGreen');
                    }

                } if (data[0].PatientClearnace == '' && data[0].BillDate != '') {
                    rPatClr += '<td id="tdPatientClear" ><input type="button" id="btnPatientClearnace" value="Patient Clearance" onclick="SavePatientClearance()"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblPatClen" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].PatientClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].PatientClearnaceTime + '</label><br /><label  id="lblPatClenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].ClearanceUser + '</label></td> ';
                    $('#PatClrDiv').css('background-color', 'Red');
                }
                else {
                    if (data[0].PatientClearnace == '') {
                        rPatClr += '<td  id="tdPatientClear" ><input type="button" id="btnPatientClearnace" value="Patient Clearance" onclick="SavePatientClearance()" disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblPatClen" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].PatientClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].PatientClearnaceTime + '</label><br /><label  id="lblPatClenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].ClearanceUser + '</label></td> ';
                        $('#PatClrDiv').css('background-color', 'Yellow');
                    }
                    else {
                        rPatClr += '<td  id="tdPatientClear" ><input type="button" id="btnPatientClearnace" value="Patient Clearance" onclick="SavePatientClearance()" disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblPatClen" style="text-align:center">' + data[0].PatientClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].PatientClearnaceTime + '</label><br /><label  id="lblPatClenBy" style="text-align:center">' + data[0].ClearanceUser + '</label></td> ';
                        $('#PatClrDiv').css('background-color', 'LightGreen');
                    }
                }

                if (data[0].NurseClearnace == '' && data[0].PatientClearnace != '') {
                    rNurClr += '<td  id="tdNurseClear"  "><input type="button" id="btnNurseClearnace" value="Nurse Clearance" onclick="SaveNurseClearance()"   style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblNurseClearnace" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].NurseClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].NurseClearnaceTime + '</label><br /><label  id="lblNurseClenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].NurseCleanUser + '</label></td> ';
                    $('#NurClrDiv').css('background-color', 'Red');
                }
                else {
                    if (data[0].NurseClearnace == '') {
                        rNurClr += '<td  id="tdNurseClear" "><input type="button" id="btnNurseClearnace" value="Nurse Clearance" onclick="SaveNurseClearance()" disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblNurseClearnace" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].NurseClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].NurseClearnaceTime + '</label><br /><label  id="lblNurseClenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].NurseCleanUser + '</label></td> ';
                        $('#NurClrDiv').css('background-color', 'Yellow');
                    }
                    else {
                        rNurClr += '<td  id="tdNurseClear" "><input type="button" id="btnNurseClearnace" value="Nurse Clearance" onclick="SaveNurseClearance()" disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblNurseClearnace" style="text-align:center">' + data[0].NurseClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].NurseClearnaceTime + '</label><br /><label  id="lblNurseClenBy" style="text-align:center">' + data[0].NurseCleanUser + '</label></td> ';
                        $('#NurClrDiv').css('background-color', 'LightGreen');
                    }
                }
                if (data[0].RoomClearnace == '' && data[0].NurseClearnace != '') {
                    rRomClr += '<td  id="tdRoomClear" ><input type="button" id="btnRoomClearnace" value="Room Clearance" onclick="SaveRoomClearance()"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblRoomClean" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].RoomClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].RoomClearnaceTime + '</label><br /><label  id="lblroomClenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].RoomCleanUser + '</label></td>  ';
                    $('#RoomClrDiv').css('background-color', 'Red');
                }
                else {
                    if (data[0].RoomClearnace == '') {
                        rRomClr += '<td  id="tdRoomClear" "><input type="button" id="btnRoomClearnace" value="Room Clearance" onclick="SaveRoomClearance()" disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblRoomClean" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].RoomClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].RoomClearnaceTime + '</label><br /><label  id="lblroomClenBy" style="text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + data[0].RoomCleanUser + '</label></td>  ';
                        $('#RoomClrDiv').css('background-color', 'Yellow');
                    }
                    else {
                        rRomClr += '<td  id="tdRoomClear" "><input type="button" id="btnRoomClearnace" value="Room Clearance" onclick="SaveRoomClearance()" disabled="disabled"  style="width: 150px; height: 50px; text-align:center;background-color:#2C5A8B;"  /><br /><label  id="lblRoomClean" style="text-align:center">' + data[0].RoomClearnace + '</label><br /><label  id="lblDisIntBy" style="text-align:center">' + data[0].RoomClearnaceTime + '</label><br /><label  id="lblNurseClenBy" style="text-align:center">' + data[0].RoomCleanUser + '</label></td> ';
                        $('#RoomClrDiv').css('background-color', 'LightGreen');

                    }
                }
          

            rdisInt += '</tr>'
            rmed += '</tr>'
            rBillF += '</tr>'
            rDisch += '</tr>'
            rBillG += '</tr>'
            rPatClr += '</tr>'
            rNurClr += '</tr>'
            rRomClr += '</tr>'
            //_tablePStatus.append(r);

            _Table1.append(rdisInt);
            _Table2.append(rmed);
            _Table3.append(rBillF);
            _Table4.append(rDisch);
            _Table5.append(rBillG);
            _Table6.append(rPatClr);
            _Table7.append(rNurClr);
            _Table8.append(rRomClr);


        }

        //Pharmacy Clearance

        $openMobileAppBookingModel = function () {
            
            modelConfirmation('Pharmacy Clearance', 'Do you want to Pharmacy Clearance ?', 'YES', 'NO', function (response) {
                if (response) {
                    $('#divPharmacyClearance').showModel();
                    BindMedRequisition();
                    return true;
                }
            });
                          
        }

  
        var BindMedRequisition = function () {
            
            var data = {

                TID: $('#hdnTID').val(),
            }
            serverCall('PatientStatus.aspx/LoadMedRequisition', data, function (response) {
                
                if (response != null && response != undefined && response != '' && response.length > 0) 
                {
                    
                    if (response != '') {
                        OnlineData = JSON.parse(response);
                        var $template = $('#template_searchOnlineInvestigation').parseTemplate(OnlineData);
                        $('#divOnline').html($template);
                        MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
                    }
                   
                }
                else
                    $("#divViewReq").css("display", "none");

            });

        }
    

        var ViewMedicineRequitision = function (elem) {
            
            $('#tbSelected tbody').find('tr').remove();
            var PatientData = JSON.parse($(elem).closest('tr').attr('data-app'));
                      
            serverCall('PatientStatus.aspx/ViewMedRequition', { indentNo: PatientData.indentno, DeptTo: PatientData.DeptTo, status: PatientData.StatusNew }, function (response) {
                
                if (response != null && response != undefined && response != '' && response.length > 0) {
                                      
                    if (response != '') {
                        OnlineData = JSON.parse(response);
                        var $template = $('#templatedIndent').parseTemplate(OnlineData);
                        $('#divIndent').html($template);
                        MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
                        if (OnlineData[0].RejectQty) {                          
                            $('#Tr3').css('background-color', '#ffb6c1');
                            $('#btnReject').attr('disabled', 'disabled');
                        }
                    }
                };
            });

        }
       

        var RejectIndent = function (elem) {
            
            $('#tbSelected tbody').find('tr').remove();
            var PatientIndentData = JSON.parse($(elem).closest('tr').attr('data-app'));           
            var ID = '<%=Util.GetString(ViewState["ID"])%>';
            serverCall('PatientStatus.aspx/RejectIndent', { indentNo: PatientIndentData.IndentNo, ItemId: PatientIndentData.ItemId, status: PatientIndentData.StatusNew, ID: ID }, function (response) {
                
                        if (response != null && response != undefined && response != '' && response.length > 0) {

                            var responseData = JSON.parse(response);
                            serverCall('PatientStatus.aspx/ViewMedRequition', { indentNo: PatientIndentData.IndentNo, DeptTo: PatientIndentData.DeptTo, status: PatientIndentData.StatusNew }, function (response) {
                                
                                if (response != null && response != undefined && response != '' && response.length > 0) {
                                    if (response != '') {
                                        OnlineData = JSON.parse(response);
                                        var $template = $('#templatedIndent').parseTemplate(OnlineData);
                                        $('#divIndent').html($template);
                                        MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
                                        $('#Tr3').css('background-color', '#ffb6c1');
                                        $('#btnReject').attr('disabled', 'disabled');
                                       
                                    }
                                  
                                };
                            });

                        };
                    });

        }


        function SaveMedClearance() {
            
            var data = {

                ID: '<%=Util.GetString(ViewState["ID"])%>',
                TID: $('#hdnTID').val(),
            }
            if ($("input[type=checkbox]").is(":checked")) {
                serverCall('PatientStatus.aspx/SaveMedClearance', data, function (response) {
                    
                    if (response != null && response != undefined && response != '' && response.length > 0) {

                        var responseData = JSON.parse(response);
                        $(responseData).each(function () {
                            modelAlert(responseData.message, function () {
                                $('#divPharmacyClearance').hideModel();
                                BindDetails();
                            });
                        });
                    }
                    else {
                        modelAlert(responseData.message, function () {
                            $('#divPharmacyClearance').hideModel();
                            BindDetails();
                        });
                    }
                });
            }
            else
                modelAlert('Please select checkbox !', function () {});
        }

        //Bill Freezed

        function SaveBillFreezed() {
         
            modelConfirmation('Bill Freezed', 'Please note that once saved no changes can be done', 'YES', 'NO', function (response) {
                if (response) {                   
                    BillFreezed();                   
                    return true;
                }
            });
        }

        function BillFreezed() {
            var data = {

                ID: '<%=Util.GetString(ViewState["ID"])%>',
                RoleID: '<%=Util.GetString(Session["RoleID"])%>',
                TID: $('#hdnTID').val(),
            }
           
                serverCall('PatientStatus.aspx/SaveBillFreezed', data, function (response) {
                    
                    if (response != null && response != undefined && response != '' && response.length > 0) {

                        var responseData = JSON.parse(response);
                        $(responseData).each(function () {
                            
                            modelAlert(responseData.message, function () {
                                BindDetails();
                            });                                                      
                        });
                    }                  
                   
                });
        }



        //PatientClearance

        function SavePatientClearance() {
                      
            modelConfirmation('Patient Cleareance', 'Do you want to Patient Cleareance ?', 'YES', 'NO', function (response) {
                if (response) {
                    $('#DivPatientClearance').showModel();                   
                    return true;
                }
            });
        }

        function PatientClearance() {
            
            var data = {

                ID: '<%=Util.GetString(ViewState["ID"])%>',
                RoleID: '<%=Util.GetString(Session["RoleID"])%>',
                TID: $('#hdnTID').val(),
                Naration: $('textarea#txtNaration').val(),
            }

            if ($('textarea#txtNaration').val() != '') {
                serverCall('PatientStatus.aspx/SavePatientClearance', data, function (response) {
                    
                    if (response != null && response != undefined && response != '' && response.length > 0) {

                        var responseData = JSON.parse(response);
                        $(responseData).each(function () {
                            
                            modelAlert(responseData.message, function () {
                                $('#DivPatientClearance').hideModel();
                                BindDetails();
                            });
                        });
                    }

                });
            }
            else
                modelAlert('Please enter Naration !!');
        }

        //Nurse Clearance

        function SaveNurseClearance() {
            modelConfirmation('Nurse Cleareance', 'Do you want to Nurse Cleareance ', 'YES', 'NO', function (response) {
                if (response) {
                    NurseClearance();
                    return true;
                }
            });
        }

        function NurseClearance() {
            
            var data = {

                ID: '<%=Util.GetString(ViewState["ID"])%>',
                RoleID: '<%=Util.GetString(Session["RoleID"])%>',
                TID: $('#hdnTID').val(),
            }

            serverCall('PatientStatus.aspx/SaveNurseClearance', data, function (response) {
                
                if (response != null && response != undefined && response != '' && response.length > 0) {

                    var responseData = JSON.parse(response);
                    $(responseData).each(function () {
                        
                        modelAlert(responseData.message, function () {
                            BindDetails();
                        });
                    });
                }

            });
        }
         
        //Room Clearance

        function SaveRoomClearance() {                  
            modelConfirmation('Room Cleareance', 'Do you want to Room Cleareance ?', 'YES', 'NO', function (response) {
                if (response) {
                    RoomClearance();
                    return true;
                }
            });
        }

        function RoomClearance() {
            
            var data = {

                ID: '<%=Util.GetString(ViewState["ID"])%>',
                RoleID: '<%=Util.GetString(Session["RoleID"])%>',
                TID: $('#hdnTID').val(),
            }

            serverCall('PatientStatus.aspx/SaveRoomClearance', data, function (response) {
                
                if (response != null && response != undefined && response != '' && response.length > 0) {

                    var responseData = JSON.parse(response);
                    $(responseData).each(function () {
                        
                        modelAlert(responseData.message, function () {
                            BindDetails();
                        });
                    });
                }

            });
        }


                        

    </script>


   

    <%--Patient Clearance--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#txtNaration").bind("cut copy paste", function (e) {
                e.preventDefault();
            });
        });

        function check(sender, e) {
            var keynum
            var keychar
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            //List of special characters you want to restrict

            if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "/" || keychar == "`") {
                return false;
            }
            else {
                return true;
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {

            var IsCheckListApplicable = '<%= Resources.Resource.NursingCheckListApplicable.ToString()%>';
            var CheckListApplicableOn = '<%= Resources.Resource.NursingCheckListApplicableOn.ToString()%>';
            var NursingClearanceId = '<%= (int)AllGlobalFunction.DischargeProcessStep.PatientClearance%>';
            if (Number(IsCheckListApplicable) == 1 && Number(CheckListApplicableOn) == Number(NursingClearanceId)) {
                e.preventDefault();
                validateCheckList();
            }
            else
                return true;
        });

        var validateCheckList = function () {
            var TID = '<%= ViewState["TransactionID"].ToString() %>';
              serverCall('Services/IPD.asmx/getDischargeCheckList', { TID: TID }, function (response) {
                  if (response != '') {
                      var $responseData = JSON.parse(response);
                      $('#divCheckListItems').empty();
                      $.each($responseData, function (i, v) {
                          $('#divCheckListItems').append('<div class="col-md-8"  style="font-weight: bold;"><input type="checkbox" class="cbCheckList" />' + v.Item + '</div>');
                      });
                      $('#divCheckList').showModel();

                  }
                  else {
                      modelAlert('No Check List Item Mapped with the Room Type.', function () {
                          __doPostBack('btnSave', '');
                      });

                  }
              });
          }
    </script>

    <%--Nurse Clreance--%>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#btnSave').bind('click', function (e) {
                var IsCheckListApplicable = '<%= Resources.Resource.NursingCheckListApplicable.ToString()%>';
                var CheckListApplicableOn = '<%= Resources.Resource.NursingCheckListApplicableOn.ToString()%>';
                var NursingClearanceId = '<%= (int)AllGlobalFunction.DischargeProcessStep.NursingClearance%>';
                if (Number(IsCheckListApplicable) == 1 && Number(CheckListApplicableOn) == Number(NursingClearanceId)) {
                    e.preventDefault();
                    validateCheckList();
                }
                else
                    return true;
            });



        });
        var validateCheckList = function () {
            var TID = '<%= ViewState["TransactionID"].ToString() %>';
            serverCall('Services/IPD.asmx/getDischargeCheckList', { TID: TID }, function (response) {
                if (response != '') {
                    var $responseData = JSON.parse(response);
                    $('#divCheckListItems').empty();
                    $.each($responseData, function (i, v) {
                        $('#divCheckListItems').append('<div class="col-md-8" style="font-weight: bold;"><input type="checkbox" class="cbCheckList" />' + v.Item + '</div>');
                    });
                    $('#divCheckList').showModel();

                }
                else {
                    modelAlert('No Check List Item Mapped with the Room Type.', function () {
                        __doPostBack('btnSave', '');
                    });

                }
            });
        }
        var saveNursingClearance = function () {
            if ($('.cbCheckList:checked').length != $('.cbCheckList').length) {
                modelAlert('All the Items should be Checked.');
                return false;
            }
            __doPostBack('btnSave', '');
        }
    </script>

    <%--Room Clearance--%>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#btnSave').bind('click', function (e) {

                var IsCheckListApplicable = '<%= Resources.Resource.NursingCheckListApplicable.ToString()%>';
                var CheckListApplicableOn = '<%= Resources.Resource.NursingCheckListApplicableOn.ToString()%>';
                var NursingClearanceId = '<%= (int)AllGlobalFunction.DischargeProcessStep.RoomClearance%>';
                if (Number(IsCheckListApplicable) == 1 && Number(CheckListApplicableOn) == Number(NursingClearanceId)) {
                    e.preventDefault();
                    validateCheckList();
                }
                else
                    return true;
            });



        });
        var validateCheckList = function () {
            var TID = '<%= ViewState["TransactionID"].ToString() %>';
            serverCall('Services/IPD.asmx/getDischargeCheckList', { TID: TID }, function (response) {
                if (response != '') {
                    var $responseData = JSON.parse(response);
                    $('#divCheckListItems').empty();
                    $.each($responseData, function (i, v) {
                        $('#divCheckListItems').append('<div class="col-md-8" style="font-weight: bold;"><input type="checkbox" class="cbCheckList" />' + v.Item + '</div>');
                    });
                    $('#divCheckList').showModel();

                }
                else {
                    modelAlert('No Check List Item Mapped with the Room Type.', function () {
                        __doPostBack('btnSave', '');
                    });

                }
            });
        }
     
    </script>

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="hdnTID" runat="server" Value="" />
       <div id="Pbody_box_inventory">
        <div id="Div3">
            <div class="POuter_Box_Inventory" >
                
                <div class="content" style="text-align: center; font-size:15px">
                    <b>Patient Status</b>
                    <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
</div>
            </div>
        </div>


        <div class="POuter_Box_Inventory" style="text-align: center">

            <div class="row" >
                <div class="col-md-20" style=" margin-left: 70px; float: left">
                    <div style="text-align: center">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 180px; float: left; background-color: pink" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Discharge Delay</b>
                    </div>
                    <div style="text-align: center">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: red" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                    </div>
                    <div style="text-align: center">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightgreen" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Status Done</b>
                    </div>
                    <div style="text-align: center">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellow" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Not Reached</b>
                    </div>
                </div>
            </div>
        </div>

        <div>
        </div>


        <div class="POuter_Box_Inventory">
            <div id="PatStatusScreenDiv" style="display:none;">
                <div class="row">
                    <table>
                        <tr>
                             <td class="col" style="width: 40px;">

                            </td>
                            <td class="col">
                                <div id="disInDiv">

                                    <div style="font-size: 11px;" class="well span3 top-block">


                                        <table id="Table1" border="1" style="width: 100%; border-collapse: collapse;">
                                         
                                            <tbody>
                                            </tbody>
                                        </table>

                                    </div>

                                </div>
                            </td>
                            <td class="col-md-1.5">
                           <img id="left"  src="../../Images/Right-arrow.png" alt="" />

                            </td>

                            <td class="col">
                                <div id="MEDClrDiv">

                                    <div style="font-size: 11px;" class="well span3 top-block">
                                        <table id="Table2" border="1" style="width: 100%; border-collapse: collapse;">                                     
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>

                                </div>
                            </td>
                            <td class="col-md-1.5">
                       <img id="Img1" src="../../Images/Right-arrow.png" alt="" />


                            </td>
                            <td class="col">
                                <div id="BILLFrzDiv">

                                    <div style="font-size: 11px;" class="well span3 top-block">
                                        <table id="Table3" border="1" style="width: 100%; height: 50px; border-collapse: collapse;">                                          
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>

                                </div>
                            </td>
                            <td class="col-md-1.5">
                                <img id="Img5" src="../../Images/Right-arrow.png" alt="" />

                            </td>

                            <td class="col">
                                <div id="DischrgDiv">

                                    <div style="font-size: 11px;" class="well span3 top-block">
                                        <table id="Table4"  border="1" style="width: 100%; border-collapse: collapse;">
                                           
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>

                                </div>
                            </td>
                            <td class="col-md-1.5" rowspan="2">

                                <img id="Img6" src="../../Images/turn-back.png" alt="" />

                            </td>

                        </tr>               
                        <tr>
                            <td class="col" style="width: 40px;">

                            </td>
                            <td class="col">
                               <div id="RoomClrDiv">

                                    <div style="font-size: 11px;" class="well span3 top-block">
                                        <table id="Table8"  border="1" style="width: 100%; border-collapse: collapse;">
                                           
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>

                                </div> 
                            </td>
                            <td class="col-md-1.5">
                                <img id="Img2" src="../../Images/Left-arrow.png" alt="" />

                            </td>

                            <td class="col">
                                <div id="NurClrDiv">

                                    <div style="font-size: 11px;" class="well span3 top-block">
                                        <table id="Table7" border="1" style="width: 100%; border-collapse: collapse;">
                                           
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>

                                </div>
                            </td>
                            <td class="col-md-1.5">
                                <img id="Img3" src="../../Images/Left-arrow.png" alt="" />

                            </td>

                            <td class="col">
                               <div id="PatClrDiv">

                                    <div style="font-size: 11px;" class="well span3 top-block">
                                        <table id="Table6"  border="1" style="width: 100%; border-collapse: collapse;">
                                            
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>

                                </div> 
                            </td>

                             <td class="col-md-1.5">
                                <img id="Img7" src="../../Images/Left-arrow.png" alt="" />

                            </td>

                            <td class="col">
                                <div id="BillGenDiv">

                                    <div style="font-size: 11px;" class="well span3 top-block">
                                        <table id="Table5"  border="1" style="width: 100%; border-collapse: collapse;">
                                           
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </div>

                                </div>
                            </td>

                            <td class="col-md-1.5">
                             

                            </td>
                        </tr>
                    </table>

                    <div>
                    </div>

                </div>
            </div>


        </div>

           <%--model Pharmacy Clearance--%>
           <div id="divPharmacyClearance" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 860px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divPharmacyClearance" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Search Results</h4>
                </div>
                
                <div class="modal-body">
                    <div id="divViewReq" style="height: 50px;" class="row">
                        <div id="divOnline" style="max-height: 190px; overflow: auto" class="col-md-24">
                        </div>
                    </div>
                    <div class="row">
                        <div id="divIndent"  class="col-md-24">
                        </div>
                    </div>
                </div>
                 <div class="modal-body">

                            <table style="width: 100%">
                                <tr>
                                    <td style="height: 20px; text-align: center;">
                                        <input type="checkbox" id="chkIsMedCleared" runat="server" class="ItDoseCheckbox"  />Check for clearance Medicion / Pharmacy
                                        <%--<asp:CheckBox ID="chkIsMedCleared2" runat="server" CssClass="ItDoseCheckbox"  Text="Check for clearance Medicion / Pharmacy" />--%>
                                    </td>
                                </tr>
                            </table>
                       
                            <div style="text-align: center;">
                                <input type="button"   id="btnIsMedClear" onclick="SaveMedClearance()" class="ItDoseButton" value="Save"  />

                                <%--<asp:Button ID="btnIsMedClear" runat="server" CssClass="ItDoseButton" Text="Save" Font-Bold="true" OnClick="btnIsMedClear_Click" OnClientClick="return confirm('Are You Sure ??');" />--%>

                                <%--<asp:Button ID="btnIsMedClear" runat="server" OnClick="btnIsMedClear_Click" CssClass="ItDoseButton" Text="Save" Font-Bold="true"  />--%>
                          
                        </div>
                 </div>
                <div class="modal-footer">
                    <%--<button type="button" style="width:30px;height:30px;float:left;margin-left:5px;background-color:lightgreen" class="circle"></button>
				 <b style="float:left;margin-top:5px;margin-left:5px">Done Investigations</b>--%>
                    <button type="button" data-dismiss="divPharmacyClearance">Close</button>
                </div>
            </div>
        </div>



    </div>


           <script id="template_searchOnlineInvestigation" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblOnlineInvestigation" style="width:100%;border-collapse:collapse;">
		<#if(OnlineData.length>0){#>

		<thead>
						   <tr  id='trOnlineHeader'>
                               <th class='GridViewHeaderStyle'>Sr.No</th>
								<th class='GridViewHeaderStyle'>CR.No</th>
                                <th class='GridViewHeaderStyle' >RequisitionDate</th>
								<th class='GridViewHeaderStyle'>RequisitionNo</th>
								<th class='GridViewHeaderStyle'>ToDepartment</th>								
                                <th class='GridViewHeaderStyle' style="display:none;">StatusNew</th>
                                <th class='GridViewHeaderStyle'>View Requisition</th>
						   </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=OnlineData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRowOnline;   
		for(var k=0;k<dataLength;k++)
		{

		objRowOnline = OnlineData[k];
		
		  #>
						<tr  onmouseover="this.style.color='#00F'"    data-app='<#= JSON.stringify(objRowOnline)  #>'  onMouseOut="this.style.color=''" id="<#=k+1#>"  style='cursor:pointer;'>
						<td id="tdOnlineIndex" class="GridViewLabItemStyle" style="text-align:center"><#=k+1#></td>
                        <td id="tdOnlineEntryNo" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.TransactionID#></td>
						<td id="tdOnlineTitle" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowOnline.dtEntry#></td>
						<td id="tdOnlinePatientName" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.indentno#></td>
						<td id="tdOnlineMobile" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.DeptTo#></td>
                        <td id="tdSelectOnlineInvest" class="GridViewLabItemStyle" style="text-align:center;"><button type="button"  onclick="ViewMedicineRequitision(this)"  >View</button></td>
                        <td id="tdOnlineOnlinePID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRowOnline.StatusNew#></td>      
                                <%-- BookingDate,OnlinePID,ItemID,PanelID,Title,PatientName,Age,Mobile,Gender,TotalTest--%>          
						</tr>   

			<#}#>
</tbody>
	 </table> 
         
           </script>
           <script id="templatedIndent" type="text/html">
               <table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="Table9" style="width:100%;border-collapse:collapse;">
		<#if(OnlineData.length>0){#>

		<thead>
						   <tr  id='tr1'>
                               <th class='GridViewHeaderStyle'>Sr.No</th>
								<th class='GridViewHeaderStyle'>RequisitionNo</th>
                                <th class='GridViewHeaderStyle' >ItemName</th>
								<th class='GridViewHeaderStyle'>UnitType</th>
								<th class='GridViewHeaderStyle'>BatchNo</th>	
                               	<th class='GridViewHeaderStyle'>ReqQty</th>
                                <th class='GridViewHeaderStyle' >ReceiveQty</th>
								<th class='GridViewHeaderStyle'>RejectQty</th>
								<th class='GridViewHeaderStyle'>DATE</th>								
                                <th class='GridViewHeaderStyle' >Reject</th>
                                
						   </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=OnlineData.length;
               window.status="Total Records Found :"+ dataLength;
               var objRowOnline;   
               for(var k=0;k<dataLength;k++)
               {

                   objRowOnline = OnlineData[k];
		
                 #>
                               <tr  onmouseover="this.style.color='#00F'"    data-app='<#= JSON.stringify(objRowOnline)  #>'  onMouseOut="this.style.color=''" id="Tr3"  style='cursor:pointer;'>
                               <td id="td1" class="GridViewLabItemStyle" style="text-align:center"><#=k+1#></td>
                               <td id="td2" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.IndentNo#></td>
                               <td id="td3" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowOnline.ItemName#></td>
                               <td id="td4" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.UnitType#></td>
                               <td id="td5" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.BatchNumber#></td>
                               <td id="td8" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.ReqQty#></td>
                               <td id="td9" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.ReceiveQty#></td>
                               <td id="td10" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.RejectQty#></td>
                               <td id="td11" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.DATE#></td>
                               <td id="td6" class="GridViewLabItemStyle" style="text-align:center;"><button type="button" id="btnReject"  onclick="RejectIndent(this)"  >Reject</button></td>
		    <%--                        <td id="td7" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRowOnline.StatusNew#></td>      --%>
		    <%-- BookingDate,OnlinePID,ItemID,PanelID,Title,PatientName,Age,Mobile,Gender,TotalTest--%>          
						</tr>   

			<#}#>
</tbody>
	 </table>
           </script>

          <%--model BillFreezed--%> 
           <div id="DivBillFreezemodel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 860px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="DivBillFreezemodel" aria-hidden="true">&times;</button>
                   
                </div>
                
                <div class="modal-body">
                    <div style="height: 50px" class="row">
                        <div id="div11" style="max-height: 190px; overflow: auto" class="col-md-24">
                        </div>
                    </div>
                    
                </div>
                 <div class="modal-body">
                                                   
                            <div style="text-align: center;">
                              <%--<asp:Button ID="btnSavefreeze" Text="Bill Freezed" OnClick="btnSave_Click" ClientIDMode="Static" CssClass="ItDoseButton" OnClientClick="return confirm_Bill(this)" runat="server" />--%>

                                <input type="button"   id="btnSavefreeze" onclick="SaveBillFreezed()" class="ItDoseButton" value="Bill Freezed"  />                             
                        </div>
                 </div>
                <div class="modal-footer">
                    <%--<button type="button" style="width:30px;height:30px;float:left;margin-left:5px;background-color:lightgreen" class="circle"></button>
				 <b style="float:left;margin-top:5px;margin-left:5px">Done Investigations</b>--%>
                    <button type="button" data-dismiss="DivBillFreezemodel">Close</button>
                </div>
            </div>
        </div>



    </div>



            <%--model PatientClearance--%> 
           <div id="DivPatientClearance" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 860px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="DivPatientClearance" aria-hidden="true">&times;</button>
                   
                </div>
                                
                 <div class="modal-body">
                                
                     <table style="width: 100%">
                                <tr style="height: 20px; text-align: center;">
                                    <td>
                                   <label style="text-align: center;">Naration :</label>

                                    </td>
                                    <td >
                                        <textarea id="txtNaration" name="textarea" style="width:400px;height:80px;margin-left:45px; float:left;" ></textarea>
                                    </td>
                                </tr>
                            </table>                   
                            <div style="text-align: center;">
                              <%--<asp:Button ID="btnSavefreeze" Text="Bill Freezed" OnClick="btnSave_Click" ClientIDMode="Static" CssClass="ItDoseButton" OnClientClick="return confirm_Bill(this)" runat="server" />--%>

                                <input type="button"   id="btnPatientClr" onclick="PatientClearance()" class="ItDoseButton" value="Patient Clearance"  />                             
                        </div>
                 </div>
                <div class="modal-footer">                 
                    <button type="button" data-dismiss="DivPatientClearance">Close</button>
                </div>
            </div>
        </div>



    </div>       
           </div>
    </form>
</body>
</html>
