<%@ Page Language="C#" ValidateRequest="false" EnableEventValidation="false" AutoEventWireup="true"
    MaintainScrollPositionOnPostback="true" CodeFile="Notecreationnew.aspx.cs" Inherits="Design_IPD_Notecreationnew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>IPD Patient Billing</title>


</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <script type="text/javascript">
        
        $(document).ready(function () {
            $("#<%=txtTempHeader.ClientID %>").val('').attr('disabled', 'disabled');
            $('#<%=rdbTemplate.ClientID %> input').change(function () {
                var radios = $("#<%=rdbTemplate.ClientID%> input[type=radio]:checked").val();
                if (radios == "New" || radios == "Update") {
                    $("#<%=lbltemplateheader.ClientID %>").val('').removeAttr('disabled');
                    $("#<%=txtTempHeader.ClientID %>").val('').removeAttr('disabled');
                    if ($("#<%=ddlTemplates.ClientID %>").val() != "") {
                        $.trim($("#<%=txtTempHeader.ClientID %>").val($("#<%=ddlTemplates.ClientID %> option:selected").text()));
                    }
                }
                else {
                    $("#<%=lbltemplateheader.ClientID %>").val('').attr('disabled', 'disabled');
                    $("#<%=txtTempHeader.ClientID %>").val('').attr('disabled', 'disabled');
                }
            });

                NoteTypeHeaderID = '<%=Request.QueryString["notettypeID"].ToString()%>';
            

            NoteTypePatientHeaderID = '<%=Request.QueryString["PatientCreationtblid"].ToString()%>';
            if (NoteTypeHeaderID != "") {
                serverCall('Notecreationnew.aspx/Bindnotecreationdetails', { NoteTypeHeaderID: NoteTypeHeaderID, TID: '<%=Request.QueryString["TID"]%>', NoteTypePatientHeaderID: NoteTypePatientHeaderID }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData(responseData.response[0]["Value"]);

                        $('#ddlHeader').val(NoteTypeHeaderID).chosen("destroy").chosen();
                    }
                });
            }
            else { $('#ddlHeader').chosen(); }
            //  ChangeColourdropdown

            OtherTemplateUserlist();
            
            GetCodeData();

            
        });

      
        
        function GetCodeData() {

            serverCall('../Employee/CodeMaster.aspx/GetActiveCodeData', {}, function (response) {

                var CodeData = JSON.parse(response);

                if (CodeData.status) {
                    data = CodeData.data;
                    items = data;

                    console.log(items)
                }

            });
        }

        function CheckSuggestedText(event, textId) {

            var str = $('#' + textId + '').val();
            if (str.indexOf("@") != -1) {
                var arr = str.split("@");

                // debugger;
                if (arr[arr.length - 1].length == 4) {
                    GetSuggestionText(arr[arr.length - 1], textId, event, function (callback) { })
                }
            }


        }
 
        
        
     
        
      

        function GetSuggestionText(code, textId, event, callback) {
            var str = $('#' + textId + '').val();
            var replacment = '@' + code;

            if (event.keyCode == 32) {
                var filteredValue = items.filter(function (item) {
                    return item.Code == code.toUpperCase();
                });
                if (filteredValue.length > 0) {

                    // If Want To Replace All  Matching Word from string Uncomment Bellow line 

                    /*
                    if (str.indexOf("@") != -1) {
                        var arr = str.split("@");
                    }
                    for (var i = 0; i < arr.length - 1; i++) {
                        str = str.replace(replacment, filteredValue[0].Description)

                    }
                    */

                    // this part only replace last occurrance 
                    var currentIndex = str.lastIndexOf(replacment);
                    str = str.substring(0, currentIndex) + filteredValue[0].Description;
                    /// 


                   // $('#' + textId + '').val(str)
                     CKEDITOR.instances['<%=txtDetail.ClientID%>'].insertHtml(str);

                }

            }
            callback(true)




        }


        var OtherTemplateUserlist = function () {
            serverCall('Notecreationnew.aspx/bindotherTemplateuserlist', {}, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var $ddlTemplateOtherUserHeader = $('#ddlTemplateOtherUserHeader');
                    $ddlTemplateOtherUserHeader.bindDropDown({ defaultValue: 'Select', data: responseData.response, valueField: 'CreatedBy', textField: 'UserName' });
                }

                else { $('#ddlUserWiseTemplate').empty(); }
             
            });
        }


        var OtherUserTemplate = function () {
            if ($('#ddlHeader').val() == "Select" )
            {
                modelAlert('Please Select  NoteType', function () {

                    OtherTemplateUserlist();
                    return;
                });
                
            }

           
            serverCall('Notecreationnew.aspx/BindOtherUserTemplate', { NoteType: $('#ddlHeader').val(), Employee:$('#ddlTemplateOtherUserHeader').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var $ddlUserWiseTemplate = $('#ddlUserWiseTemplate');
                    $ddlUserWiseTemplate.bindDropDown({ defaultValue: 'Select', data: responseData.response, valueField: 'Headerid', textField: 'Temp_Name' });
                }
                else {
                    modelAlert('No Template Found', function () {
                        $('#ddlUserWiseTemplate').empty();
                        return;
                    }); 
                }

            });
        }

        function ShowHide() {
            var radios = $("#<%=rdbTemplate.ClientID%> input[type=radio]:checked").val();
            if (radios == "New" || radios == "Update") {
                $("#<%=lbltemplateheader.ClientID %>").val('').removeAttr('disabled');
                $("#<%=txtTempHeader.ClientID %>").val('').removeAttr('disabled');
                if ($("#<%=ddlTemplates.ClientID %>").val() != "") {
                    $.trim($("#<%=txtTempHeader.ClientID %>").val($("#<%=ddlTemplates.ClientID %> option:selected").text()));
                }
            }
            else {
                $("#<%=lbltemplateheader.ClientID %>").val('').attr('disabled', 'disabled');
                $("#<%=txtTempHeader.ClientID %>").val('').attr('disabled', 'disabled');
            }
        }


        var ChangeColourdropdown = function () {

            var TID = $('#hdntransactionId').val();


            serverCall('../EMR/Services/EMR.asmx/bindNoteTypemandatory', { TID: TID }, function (response) {

                var responseData = JSON.parse(response);
                var Maindt = responseData.dtmandatory;
                var dt1 = responseData.dtadded;
                var select = $('#ddlHeader')[0];

                for (var i = 1; i < select.length; i++) {
                    var option = select.options[i];
                    for (var j = 0; j < Maindt.length; j++) {
                        if (option.text == Maindt[j].HeaderName && Maindt[j].mandatoryType == '1') {
                            //$(option.value).attr('style', 'background-color:red;');
                            $("#ddlHeader option[value=" + option.value + "]").css("background-color", "yellow");
                            //$(option.value).css("background-color", "red");
                            // $('#ddlHeader').chosen();
                        }
                        for (var k = 0; k < dt1.length; k++) {
                            if (Maindt[j].HeaderName == dt1[k].HeaderName) {
                                if (option.text == dt1[k].HeaderName) {

                                    // $('#ddlHeader').chosen('destroy'); 
                                    $("#ddlHeader option[value=" + option.value + "]").css("background-color", "lightgreen");
                                    // $('#ddlHeader').chosen();

                                }

                            }

                        }

                    }

                }
                $('#ddlHeader').chosen();

            });
        }
        function listSource(el) {
            var TID = '<%=Request.QueryString["TID"]%>';
            serverCall('Notecreationnew.aspx/BindPatientNoteCreation', { NoteTypevalue: $('#ddlListSource').val(), TID: TID }, function (response) {
                var responsedata = JSON.parse(response)
                if (responsedata.status) {
                    bindPatientNotelistfornotewriter(responsedata.response)
                }
            });
        }
        function bindPatientNotelistfornotewriter(data) {
            if ($('#ddlListSource').val() == 'PMH') {
                $('#tblPatientnotecreationlistpmh tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tblPatientnotecreationlistpmh tbody tr').length + 1;

                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Problem + '</td>';
                    row += '<td id="tdOnSet" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].OnSet + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Code + '</td>';
                    row += '</tr>';
                    $('#tblPatientnotecreationlistpmh tbody').append(row);
                }
                $('#divPatientNotelistpmh').show();
            }
            if ($('#ddlListSource').val() == 'PSH') {
                $('#tblPatientNotelistpsh tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tblPatientNotelistpsh tbody tr').length + 1;
                    row += '<td class="GridViewLabItemStyle checkedpsh" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Surgery + '</td>';
                    row += '<td id="tdOnSet" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SurgeryDate + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Code + '</td>';
                    row += '</tr>';
                    $('#tblPatientNotelistpsh tbody').append(row);
                }
                $('#divPatientNotelistpsh').show();
            }
            if ($('#ddlListSource').val() == 'FH') {
                $('#tblPatientNotelistFH tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tblPatientNotelistFH tbody tr').length + 1;
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Illness + '</td>';
                    row += '<td id="tdOnSet" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].RelationShip + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Code + '</td>';
                    row += '</tr>';
                    $('#tblPatientNotelistFH tbody').append(row);
                }
                $('#divPatientNotelistFH').show();
            }
            if ($('#ddlListSource').val() == 'SH') {
                $('#tblPatientNotelistSH tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tblPatientNotelistSH tbody tr').length + 1;
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Issue + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Code + '</td>';
                    row += '</tr>';
                    $('#tblPatientNotelistSH tbody').append(row);
                }
                $('#divPatientNotelistSH').show();

            }
            if ($('#ddlListSource').val() == 'ProblemList') {
                $('#tblPatientNotelistPL tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tblPatientNotelistPL tbody tr').length + 1;
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Problem + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Code + '</td>';
                    row += '</tr>';
                    $('#tblPatientNotelistPL tbody').append(row);
                }
                $('#divPatientNotelistPL').show();
            }
            if ($('#ddlListSource').val() == 'DM') {
                $('#tbldivPatientNotelistDM tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tbldivPatientNotelistDM tbody tr').length + 1;
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdDrugName" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].DrugName + '</td>';
                    row += '<td id="tdNextDose" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].NextDose + '</td>';
                    row += '<td id="tdDose" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Dose + '</td>';
                    row += '<td id="tdDuration" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Duration + '</td>';
                    row += '<td id="tdMeal" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Meal + '</td>';
                    row += '</tr>';
                    $('#tbldivPatientNotelistDM tbody').append(row);
                }
                $('#divPatientNotelistDM').show();
            }
            if ($('#ddlListSource').val() == 'Allergy') {
                $('#tbldivPatientNotelistallergy tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tbldivPatientNotelistallergy tbody tr').length + 1;
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdAllergies" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Allergies + '</td>';
                    row += '</tr>';
                    $('#tbldivPatientNotelistallergy tbody').append(row);
                }
                $('#divPatientNotelistallergy').show();
            }
            if ($('#ddlListSource').val() == 'FD') {
                $('#tbldivPatientNotelistFD tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tbldivPatientNotelistFD tbody tr').length + 1;
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdDiagnosis" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Diagnosis + '</td>';
                    row += '<td id="tdDiagnosiscode" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].DiagnosisCode + '</td>';
                    row += '</tr>';
                    $('#tbldivPatientNotelistFD tbody').append(row);
                }
                $('#divPatientNotelistFD').show();
            }
            if ($('#ddlListSource').val() == 'Vital') {


                CKEDITOR.instances['<%=txtDetail.ClientID%>'].insertHtml(data[0]["Vitals"]);
            }

            if ($('#ddlListSource').val() == 'Lab') {


                CKEDITOR.instances['<%=txtDetail.ClientID%>'].insertHtml(data[0]["LAB"]);
            }
            if ($('#ddlListSource').val() == 'OT') {

                $('#tblOperativeNote tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tblOperativeNote tbody tr').length + 1;
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdDiagnosiscode" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Surgery + '</td>';
                    row += '</tr>';
                    $('#tblOperativeNote tbody').append(row);
                }

                $('#divOperativeNote').show();
            }
        }
        function add(tblPatientnotecreationlist) {

            $checkedlist = tblPatientnotecreationlist.find('tbody input[type=checkbox]:checked');
            var table = "";

            if ($checkedlist.length > 0) {

                if ($('#ddlListSource').val() == 'PMH') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblpatientfhbindlist">';
                    table += '<thead>';
                    table += '<tr> <br/>';
                    table += '<td colspan="5"><b>Patient Medical History:</b></td>';
                    table += '</tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Problem Notes</th>';
                    table += '<th>OnSet</th>';
                    table += '<th>Desciption</th>';
                    table += '<th>Code</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdProblem').text() + '</td>';
                            table += '<td style="text-align: center;">' + $(this).find('#tdOnSet').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdDescription').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdCode').text() + '</td>';
                            table += '</tr>';
                        }

                    });
                    table += '</tbody>';
                    table += '</table>';

                    $('#divPatientNotelistpmh').hide();
                }
                else if ($('#ddlListSource').val() == 'PSH') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblpatientfhbindlist">';
                    table += '<thead>';
                    table += '<tr> <br/>';
                    table += '<td colspan="5"><b>Patient Surgical History:</b></td>';
                    table += '</tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Surgery</th>';
                    table += '<th>Surgery Date</th>';
                    table += '<th>Desciption</th>';
                    table += '<th>Code</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdProblem').text() + '</td>';
                            table += '<td style="text-align: center;">' + $(this).find('#tdOnSet').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdDescription').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdCode').text() + '</td>';
                            table += '</tr>';
                        }

                    });
                    table += '</tbody>';
                    table += '</table>';

                    $('#divPatientNotelistpsh').hide();
                }
                else if ($('#ddlListSource').val() == 'FH') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblpatientfhbindlist">';
                    table += '<thead>';
                    table += '<tr> <br/>';
                    table += '<td colspan="5"><b>Family History:</b></td>';
                    table += '</tr>';
                    table += '<tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Illness</th>';
                    table += '<th>Relationship</th>';
                    table += '<th>Desciption</th>';
                    table += '<th>Code</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdProblem').text() + '</td>';
                            table += '<td style="text-align: center;">' + $(this).find('#tdOnSet').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdDescription').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdCode').text() + '</td>';
                            table += '</tr>';
                        }

                    });
                    table += '</tbody>';
                    table += '</table>';

                    $('#divPatientNotelistFH').hide();
                }
                else if ($('#ddlListSource').val() == 'SH') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblpatientfhbindlist">';
                    table += '<thead>';
                    table += '<tr> <br/>';
                    table += '<td colspan="5"><b>Social History:</b></td>';
                    table += '</tr>';
                    table += '<tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Issue</th>';
                    table += '<th>Desciption</th>';
                    table += '<th>Code</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdProblem').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdDescription').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdCode').text() + '</td>';
                            table += '</tr>';
                        }

                    });
                    table += '</tbody>';
                    table += '</table>';

                    $('#divPatientNotelistSH').hide();
                }
                else if ($('#ddlListSource').val() == 'ProblemList') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblpatientfhbindlist">';
                    table += '<thead>';
                    table += '<tr> <br/>';
                    table += '<td colspan="5"><b>Problem List:</b></td>';
                    table += '</tr>';
                    table += '<tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Problem Notes</th>';
                    table += '<th>Desciption</th>';
                    table += '<th>Code</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdProblem').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdDescription').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdCode').text() + '</td>';
                            table += '</tr>';
                        }

                    });


                    table += '</tbody>';
                    table += '</table>';


                    $('#divPatientNotelistPL').hideModel();
                }
                else if ($('#ddlListSource').val() == 'DM') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblpatientfhbindlist">';
                    table += '<thead>';
                    table += '<tr> <br/>';
                    table += '<td colspan="5"><b>Discharge Medication:</b></td>';
                    table += '</tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Drug</th>';
                    table += '<th>Time</th>';
                    table += '<th>Dose</th>';
                    table += '<th>Duration</th>';
                    table += '<th>Meal</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdDrugName').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdNextDose').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdDose').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdDuration').text() + '</td>';
                            table += '<td  style="text-align: center;">' + $(this).find('#tdMeal').text() + '</td>';
                            table += '</tr>';
                        }

                    });


                    table += '</tbody>';
                    table += '</table>';


                    $('#divPatientNotelistDM').hideModel();
                }
                else if ($('#ddlListSource').val() == 'Allergy') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblpatientfhbindlist">';
                    table += '<thead>';
                    table += '<tr> <br/>';
                    table += '<td colspan="5"><b>Allergy:</b></td>';
                    table += '</tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Allergy</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdAllergies').text() + '</td>';
                            table += '</tr>';
                        }

                    });
                    table += '</tbody>';
                    table += '</table>';
                    $('#divPatientNotelistallergy').hideModel();
                }
                else if ($('#ddlListSource').val() == 'FD') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblpatientfhbindlist">';
                    table += '<thead>';
                    table += '<tr> <br/>';
                    table += '<td colspan="5"><b>Final Diagnosis:</b></td>';
                    table += '</tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Diagnosis</th>';
                    table += '<th>Diagnosis Code</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdDiagnosis').text() + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdDiagnosiscode').text() + '</td>';
                            table += '</tr>';
                        }

                    });
                    table += '</tbody>';
                    table += '</table>';
                    table += '<br />';
                    $('#divPatientNotelistFD').hideModel();
                }
                else if ($('#ddlListSource').val() == 'OT') {
                    table = '<table border="0" cellpadding="1" cellspacing="1" style="width:500px"  id="tblOperativeNote">';
                    table += '<thead>';
                   // table += '<tr> <br/>';
                   //// table += '<td colspan="5"><b>Procedure:</b></td>';
                   // table += '</tr>';
                    table += '<tr>';
                    table += '<th>Sr No</th>';
                    table += '<th>Procedure</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblOperativeNote tbody tr').length + 1;
                            table += '<td  style="text-align: center;">' + (++i) + '</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdDiagnosiscode').text() + '</td>';
                            table += '</tr>';
                        }

                    });
                    table += '</tbody>';
                    table += '</table>';
                    table += '<br />';
                    $('#divOperativeNote').hideModel();
                }
                CKEDITOR.instances['<%=txtDetail.ClientID%>'].insertHtml(table);
            }



        }

        function headerchange() {

            serverCall('Notecreationnew.aspx/bindheadertemplate', { HeaderID: $('#ddlHeader').val(), TID: $('#hdntransactionId').val() }, function (response) {

                var responseData = JSON.parse(response);


                if (responseData.status) {
                    var $ddlTemplates = $('#ddlTemplates');
                    $ddlTemplates.bindDropDown({ defaultValue: 'Select', data: responseData.response, valueField: 'Template_Value', textField: 'Temp_Name' });

                    if (responseData.PatientData.length > 0) {
                        //CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData(responseData.PatientData[0]["Value"]);
                        if ($('#ddlHeader').val() != 'Select') {
                            var data = '</br><b>' + $('#ddlHeader option:selected').text() + '</b></br>';
                            CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData(responseData.PatientData[0]["templateDisc"]);
                        }
                        
                    }

                    else {
                        if ($('#ddlHeader').val() != 'Select') {
                            var data = '</br><b>' + $('#ddlHeader option:selected').text() + '</b></br>';
                            CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData(data);
                        }
                    }
                    $('#lblMsg').text('');
                }

                else {
                    $('#ddlTemplates').empty();

                    if ($('#ddlHeader').val() != 'Select') {
                        var data = '</br><b>' + $('#ddlHeader option:selected').text() + '</b></br>';
                        CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData(data);
                    }
                }


            });
        }


        function Headertemplate() {

            serverCall('Notecreationnew.aspx/bindtemplatedata', { TemplateID: $('#ddlTemplates').val() }, function (response) {
                var responsedata = JSON.parse(response);
                if (responsedata.status) {
                    CKEDITOR.instances['<%=txtDetail.ClientID%>'].insertHtml(responsedata.response[0]['Template_Value']);
                }
            });
        }

        function DeleteTemplate() {

            if ($('#ddlTemplates').val() != '0' && $('#ddlHeader').val() != "Select") {
                modelConfirmation('Confirmation!!!', 'You Want To Delete this Template', 'Yes', 'No', function (response) {
                    if (response) {
                        serverCall('Notecreationnew.aspx/deleteTemplate', { TemplateID: $('#ddlTemplates').val() }, function (response) {

                            var responsedata = JSON.parse(response);
                            if (responsedata.status) {
                                modelAlert(responsedata.response, function () {
                                    bindtemplate()
                                });
                            }

                            else { modelAlert(responsedata.response) }
                        });
                    }
                });
            }
            else { modelAlert('Please select note type and template for deletion'); }
        }

        function bindtemplate() {

            serverCall('Notecreationnew.aspx/bindtemplateHeaderwise', { HeaderID: $('#ddlHeader').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var $ddlTemplates = $('#ddlTemplates');
                    $ddlTemplates.bindDropDown({ defaultValue: 'Select', data: responseData.response, valueField: 'Template_Value', textField: 'Temp_Name' });
                }

            });
        }

        function ViewNoteSummary() {
            serverCall('Notecreationnew.aspx/bindAllNoteType', { TID: '<%=Request.QueryString["TID"]%>' }, function (response) {

                var responsedata = JSON.parse(response);
                if (responsedata.status) {
                    CKEDITOR.instances['<%=txtViewNoteType.ClientID%>'].setData(responsedata.response[0]['Detail']);
                    $('#divViewNoteType').show();
                }

            });
        }

        function BindTemplateinEditor() {
            serverCall('Notecreationnew.aspx/bindTemplateinEditor', { ID: $('#ddlUserWiseTemplate').val() }, function (response) {

                var responsedata = JSON.parse(response);
                if (responsedata.status) {
                    CKEDITOR.instances['<%=txtDetail.ClientID%>'].insertHtml(responsedata.response[0]['Template_Value']);
                    
                }
            });
        }
        function validate(btn) {
           
             btn.disabled = true;
             btn.value = 'Submitting...';
             __doPostBack('btnAddItem', '');
         }
    </script>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hdntransactionId" runat="server" />
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager" runat="Server" />
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Note Writer
                </b>
                <%-- <br />--%>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Note Type Entries&nbsp;
                </div>
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3" style="display: none">
                            <label class="pull-left">
                                Discharge Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display: none">
                            <asp:Label ID="lbldischargeType" runat="server" Style="color: black;" CssClass="ItDoseLblError" />

                        </div>
                        <div class="col-md-3" style="display: none">
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5" style="display: none">
                            >
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightgreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Already Added</b> &nbsp;

                        </div>
                        <div class="col-md-3" style="display: none">
                            >
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5" style="display: none">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellow;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Mandatory Header</b> &nbsp;

                        </div>

                    </div>
                    <div class="row" style="display: none">

                        <div class="col-md-3">
                            <label class="pull-left">
                                User
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlEmployee" runat="server" AutoPostBack="True" TabIndex="5">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Is Shared                           
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkIsSahred" runat="server" />
                        </div>
                    </div>
                    <div class="row">
                    </div>
                    <div class="row">

                        <div class="col-md-3">
                            <label class="pull-left">
                                Note Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlHeader" runat="server"
                                TabIndex="5" ClientIDMode="Static" onchange="headerchange();">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Templates
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlTemplates" runat="server" TabIndex="6" onchange="Headertemplate();" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-3">

                            <input type="button" value="Delete Template" id="btnDelete" onclick="DeleteTemplate()" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">

                                <asp:Label ID="lbllistofsurces" runat="server">List of Sources</asp:Label>
                            </label>
                            <b class="pull-right">
                                <asp:Label ID="lbllistofdot" runat="server">:</asp:Label>
                            </b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlListSource" runat="server" TabIndex="6" ClientIDMode="Static" onchange="listSource(this)">
                                <asp:ListItem Value="Select">Select</asp:ListItem>
                                <asp:ListItem Value="PMH">Past Medical History</asp:ListItem>
                                <asp:ListItem Value="PSH">Past Surgical History</asp:ListItem>
                                <asp:ListItem Value="FH">Family History</asp:ListItem>
                                <asp:ListItem Value="SH">Social History</asp:ListItem>
                                <asp:ListItem Value="Allergy">Allergies</asp:ListItem>
                                <asp:ListItem Value="ProblemList">Problem List</asp:ListItem>
                                <asp:ListItem Value="DM">Discharge Medications</asp:ListItem>
                                <asp:ListItem Value="FD">Final Diagnoses</asp:ListItem>
                                <asp:ListItem Value="Vital">24Hrs Vitals</asp:ListItem>
                                <asp:ListItem Value="Lab">24Hrs Lab</asp:ListItem>
                                <asp:ListItem Value="AM">Active Medicine</asp:ListItem>
                                <asp:ListItem Value="OT">Procedure List</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                     <div class="row">
                         <div class="col-md-3"></div>
                         <div class="col-md-4"> <asp:TextBox ID="txtnote"  runat="server" TextMode="MultiLine" Height="29" Width="205" onkeypress="CheckSuggestedText(event,this.id)" ToolTip="You can use your acronym expension"></asp:TextBox></div>
                    </div>
                </div>
            </div>
            
            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                <tr>
                    <td style="width: 15%; text-align: right">
                        <%--Details :--%>&nbsp;
                    </td>
                    <td style="width: 50%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <%--<td align="right" colspan="2">--%>
                    <td style="height: 12px; vertical-align: middle; text-align: left" colspan="2">

                        <CKEditor:CKEditorControl ID="txtDetail" BasePath="~/ckeditor" runat="server" EnterMode="BR" onkeypress="CheckSuggestedText(event,this.id)" ClientIDMode="Static"></CKEditor:CKEditorControl>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: right"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1">
                       <asp:Button ID="btnAddItem" runat="server" CausesValidation="False" CssClass="ItDoseButton"
                            Text="Save" OnClick="btnAddItem_Click" TabIndex="8"  OnClientClick="return validate(this);"  />
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-8">
                     <asp:RadioButtonList ID="rdbTemplate" runat="server" CssClass="ItDoseRadiobuttonlist" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Nothing" Selected="True">Create Note</asp:ListItem>
                            <asp:ListItem Value="New">New Temp.</asp:ListItem>
                            <asp:ListItem Value="Update"> Update Temp.</asp:ListItem>
                        </asp:RadioButtonList>
                </div>
                <div class="col-md-2">
                    <asp:Label runat="server" ID="lbltemplateheader" Text="TName :"></asp:Label>
                </div>
                <div class="col-md-3">
                     <asp:TextBox ID="txtTempHeader" runat="server"  TabIndex="10"></asp:TextBox>
                </div>
                <div class="col-md-1">
                    <label class="pull-left">User</label>
                </div>
                <div class="col-md-4">
                     <asp:DropDownList ID="ddlTemplateOtherUserHeader" runat="server" ClientIDMode="Static" onchange="OtherUserTemplate()"></asp:DropDownList>
                </div>
                <div class="col-md-4">
                     <asp:DropDownList ID="ddlUserWiseTemplate" runat="server" ClientIDMode="Static" onchange="BindTemplateinEditor()" ></asp:DropDownList>
                     <input type="button" id="viewBtn" title="View Note Summary " onclick="ViewNoteSummary();" value="View" style="display:none" />
                </div>
                </div>
            
        </div>
        <div class="POuter_Box_Inventory" style="display: none">
            <div class="Purchaseheader">
                Note Type Entries Details
            </div>
            <div style="text-align: center;">
                <asp:GridView ID="grdHeader" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    PageSize="5" Width="100%" OnRowCommand="grdHeader_RowCommand" OnRowDataBound="grdHeader_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Header Added">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="500px" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblheader" runat="server" Text='<%#Eval("HeaderName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                &nbsp;<asp:ImageButton ID="imbModify" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                    CommandName="AEdit" ImageUrl="~/Images/edit.png" ToolTip="Modify Item" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Delete">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                &nbsp;<asp:ImageButton ID="imbDelete" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                    CommandName="ADelete" ImageUrl="~/Images/Delete.gif" ToolTip="Delete Item" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lblReportTypeHeaderID" runat="server" Text='<%# Eval("Header_ID") %>'
                                    Visible="False"></asp:Label>

                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%">
                <tr style="text-align: center">
                    <td style="width: 100px">
                  
                    </td>
                    <td style="width: 100px; display: none">
                        <asp:RadioButtonList ID="rbtnFormat" runat="server" RepeatDirection="Horizontal" Width="145px">
                            <asp:ListItem Selected="True">PDF</asp:ListItem>
                            <asp:ListItem>Word</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="text-align: center">
                        <asp:Button ID="btnPrint" runat="server" CausesValidation="False" CssClass="ItDoseButton"
                            OnClick="btnPrint_Click" Text="Print" />&nbsp;&nbsp;&nbsp;&nbsp;
                            

                    </td>
                </tr>
            </table>
        </div>
       
        <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" BackColor="#F3F7FA"
            Width="869px" Style="display: none">
            <%--  <div class="Purchaseheader">
                &nbsp;</div>--%>
        &nbsp;<div class="Outer_Box_Inventory" id="DIV1" onclick="return DIV1_onclick()"
            style="width: 606px">
            <div class="Purchaseheader" style="text-align: center">
                Available Items&nbsp;
            </div>
            <div class="content">
                <table border="0" cellpadding="0" cellspacing="0" class="border1" style="width: 590px">
                    <tbody>
                        <tr>
                            <td style="height: 23px; text-align: left; vertical-align: middle">
                                <asp:CheckBoxList ID="chk" runat="server" DataTextField="itemname" RepeatColumns="1"
                                    Width="581px" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headingtext2" style="text-align: center; height: 32px; vertical-align: middle">
                                <br />
                                &nbsp;<asp:Button ID="btn_Cancel" CssClass="ItDoseButton" runat="server" Text="CLOSE"
                                    OnClick="btn_Cancel_Click" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        </asp:Panel>
        <div style="display: none">
            <cc1:ModalPopupExtender ID="ModalPopupExtender1" DropShadow="true" runat="server"
                BackgroundCssClass="filterPupupBackground" TargetControlID="btn1" X="75" Y="50"
                PopupControlID="panel1">
            </cc1:ModalPopupExtender>
            <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton" />
        </div>

        <div id="divPatientNotelistpmh" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPatientNotelistpmh" aria-hidden="true">&times;</button>

                        <div class="row">
                            <div class="col-md-5">
                                <h4 class="modal-title">Note Type List
                                </h4>
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btndadd" value="Add" onclick="add($('#tblPatientnotecreationlistpmh'));" class="pull-left" />
                            </div>
                        </div>

                    </div>
                    <div class="modal-body">
                        <div class="row">

                            <table class="FixedHeader" id="tblPatientnotecreationlistpmh" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkall" onchange="$('#tblPatientnotecreationlistpmh tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Problem Note</th>
                                        <th class="GridViewHeaderStyle">OnSet</th>
                                        <th class="GridViewHeaderStyle">Description</th>
                                        <th class="GridViewHeaderStyle">Code</th>

                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer" style="display: none">
                        <div class="row">
                            <div class="col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divPatientNotelistpsh" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPatientNotelistpsh" aria-hidden="true">&times;</button>
                        <div class="row">
                            <div class="col-md-5">
                                <h4 class="modal-title">Note Type List
                                </h4>
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btnPatientNotelistpsh" value="Add" onclick="add($('#tblPatientNotelistpsh'));" class="pull-left" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">

                            <table class="FixedHeader" id="tblPatientNotelistpsh" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkallpsh" onchange="$('#tblPatientNotelistpsh tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Surgery</th>
                                        <th class="GridViewHeaderStyle">SurgeryDate</th>
                                        <th class="GridViewHeaderStyle">Description</th>
                                        <th class="GridViewHeaderStyle">Code</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer" style="display: none">
                        <div class="row">
                            <div class="col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divPatientNotelistFH" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPatientNotelistFH" aria-hidden="true">&times;</button>
                        <div class="row">
                            <div class="col-md-5">
                                <h4 class="modal-title">Note Type List
                                </h4>
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btnPatientNotelistFH" value="Add" onclick="add($('#tblPatientNotelistFH'));" class="pull-left" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <table class="FixedHeader" id="tblPatientNotelistFH" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkall" onchange="$('#tblPatientNotelistFH tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Illness</th>
                                        <th class="GridViewHeaderStyle">Relationship</th>
                                        <th class="GridViewHeaderStyle">Description</th>
                                        <th class="GridViewHeaderStyle">Code</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer" style="display: none">
                        <div class="row">
                            <div class="col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divPatientNotelistSH" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPatientNotelistSH" aria-hidden="true">&times;</button>
                        <div class="row">
                            <div class="col-md-5">
                                <h4 class="modal-title">Note Type List
                                </h4>
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btnPatientNotelistSH" value="Add" onclick="add($('#tblPatientNotelistSH'));" class="pull-left" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <table class="FixedHeader" id="tblPatientNotelistSH" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkall" onchange="$('#tblPatientNotelistSH tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Issue</th>
                                        <th class="GridViewHeaderStyle">Description</th>
                                        <th class="GridViewHeaderStyle">Code</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer" style="display: none">
                        <div class="row">
                            <div class="col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divPatientNotelistPL" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPatientNotelistPL" aria-hidden="true">&times;</button>
                        <div class="row">
                            <div class="col-md-5">
                                <h4 class="modal-title">Note Type List
                                </h4>
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btnPatientNotelistPL" value="Add" onclick="add($('#tblPatientNotelistPL'));" class="pull-left" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <table class="FixedHeader" id="tblPatientNotelistPL" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkall" onchange="$('#tblPatientNotelistPL tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Problem</th>
                                        <th class="GridViewHeaderStyle">Description</th>
                                        <th class="GridViewHeaderStyle">Code</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer" style="display: none">
                        <div class="row">
                            <div class="col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divPatientNotelistDM" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPatientNotelistDM" aria-hidden="true">&times;</button>
                        <div class="row">
                            <div class="col-md-5">
                                <h4 class="modal-title">Note Type List
                                </h4>
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btntbldivPatientNotelistDM" value="Add" onclick="add($('#tbldivPatientNotelistDM'));" class="pull-left" />
                            </div>
                        </div>


                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <table class="FixedHeader" id="tbldivPatientNotelistDM" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkall" onchange="$('#tbldivPatientNotelistDM tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Drug Name</th>
                                        <th class="GridViewHeaderStyle">Time</th>
                                        <th class="GridViewHeaderStyle">Dose</th>
                                        <th class="GridViewHeaderStyle">Duration</th>
                                        <th class="GridViewHeaderStyle">Meal</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer" style="display: none">
                        <div class="row">
                            <div class="col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divPatientNotelistallergy" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPatientNotelistallergy" aria-hidden="true">&times;</button>
                        <div class="row">
                            <div class="col-md-5">
                                <h4 class="modal-title">Note Type List
                                </h4>
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btndivPatientNotelistallergy" value="Add" onclick="add($('#tbldivPatientNotelistallergy'));" class="pull-left" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <table class="FixedHeader" id="tbldivPatientNotelistallergy" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkall" onchange="$('#tbldivPatientNotelistallergy tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Allergy</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer" style="display: none">
                        <div class="row">
                            <div class="col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divPatientNotelistFD" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 260px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPatientNotelistFD" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Note Type List
                        </h4>
                    </div>
                    <div class="modal-body" style="overflow-x: auto">
                        <div class="row">
                            <table class="FixedHeader" id="tbldivPatientNotelistFD" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkall" onchange="$('#tbldivPatientNotelistFD tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Diagnosis Code</th>
                                        <th class="GridViewHeaderStyle">Diagnosis</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer">
                        <div class="row">
                            <div class="col-md-3">
                                <input type="button" id="btntbldivPatientNotelistFD" value="Add" onclick="add($('#tbldivPatientNotelistFD'));" class="pull-left" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divViewNoteType" style="display: none" class="modal fade ">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 965px; height: 418px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewNoteType" aria-hidden="true">&times;</button>
                        <label class="pull-left">Note View</label>
                    </div>

                    <div class="modal-body">
                        <div class="row Purchaseheader">
                            <div class="col-md-5 ">
                                <label class="pull-left">View All Note Type</label>
                                <b class="pull-right">:</b>
                            </div>


                        </div>
                        <div class="row">

                            <div class="col-md-24">
                                <CKEditor:CKEditorControl ID="txtViewNoteType" BasePath="~/ckeditor" runat="server" EnterMode="BR" ClientIDMode="Static"></CKEditor:CKEditorControl>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>

        <div id="divOperativeNote" class="modal fade " style="display: none">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divOperativeNote" aria-hidden="true">&times;</button>
                        <div class="row">
                            <div class="col-md-5">
                                <h4 class="modal-title">Note Type List
                                </h4>
                            </div>
                            <div class="col-md-5">
                                <input type="button" id="btnOperativeNote" value="Add" onclick="add($('#tblOperativeNote'));" class="pull-left" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <table class="FixedHeader" id="tblOperativeNote" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle">
                                            <input type="checkbox" class="checkall" onchange="$('#tblOperativeNote tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                        <th class="GridViewHeaderStyle">SrNo</th>
                                        <th class="GridViewHeaderStyle">Procedure</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                    </div>

                    <div class="modal-footer" style="display: none">
                        <div class="row">
                            <div class="col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
