<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Notefinder.aspx.cs" Inherits="Design_IPD_Notefinder" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
   
     <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

     <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $SearchtControlInit(function () { });
        });

        function showuploadbox(obj, href, maxh, maxw, w, h, obj) {

            $.fancybox({
                maxWidth: '1049',
                maxHeight: '1050',
                fitToView: false,
                width: 1099,
                href: href,
                height: 717,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
        var $SearchtControlInit = function (callback) {
            $bindCadre(function () {
                $bindTier(function () {
                    $bindSpecilty(function () {
                        $bindNote(function () {
                            noterfindersearch();
                            hidShowButton();
                        });
                    });
                });
            })
        };
  
        var $bindNote = function (callback) {

            serverCall('Notefinder.aspx/bindNoteTypeMaster', {}, function (response) {
                var $ddlNoteType = $('#ddlNoteType');
                $ddlNoteType.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Header_Id', textField: 'HeaderName' });
                callback($ddlNoteType.val());
            });
        }
        var $bindCadre = function (callback) {
            serverCall('../EDP/UserPrivilege/UserPrivilege.asmx/bindCadreType', {}, function (response) {
                var $ddlCadre = $('#ddlCadre');
                $ddlCadre.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'CadreName' });
                callback($ddlCadre.val());
            });
        }
        var $bindTier = function (callback) {
            serverCall('../EDP/UserPrivilege/UserPrivilege.asmx/bindTierType', {}, function (response) {
                var $ddltier = $('#ddltier');
                $ddltier.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'TierName' });
                callback($ddltier.val());
            });
        }
        var $bindSpecilty = function (callback) {
            serverCall('../Doctor/services/DocGrouprateMaster.asmx/bindDocSpecialization', {}, function (response) {
                var $ddlSpecialty = $('#ddlSpecialty');
                $ddlSpecialty.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name' });
                callback($ddlSpecialty.val());
            });
        }

        function noterfindersearch() {
            var encounterType = "";

            if ($('#ddlEncounter').val() == '0') {
                encounterType = '<%=Request.QueryString["TID"]%>';
            }
            else if ($('#ddlEncounter').val() == '2') {
                encounterType = '<%=Request.QueryString["TID"]%>';
                  }
            else { encounterType = '<%=Request.QueryString["PID"]%>'; }

            var data = {
                cadreID: $('#ddlCadre').val(),
                tierID: $('#ddltier').val(),
                specialtyID: $('#ddlSpecialty').val(),
                noteType: $('#ddlNoteType').val(),
                encounter: $('#ddlEncounter').val(),
                encounterType: encounterType,
                fromdate: $('#txtFromDate').val(),
                todate: $('#txtToDate').val()
            }
            serverCall('Notefinder.aspx/notefindersearch', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    bindNoteFinderdetail(responseData.response);
                }
                else {
                    modelAlert(responseData.response, function () {
                        $('#tblnotefinderdetails tbody').empty();
                    });
                }
            });
        }
        var PID='<%=Request.QueryString["PID"]%>';
        var TID='<%=Request.QueryString["TID"]%>';
        var Path = "Notecreationnew.aspx?PID=" + PID + "&TID=" + TID + "";

        function bindNoteFinderdetail(data) {
            $('#tblnotefinderdetails tbody').empty();
            for (var i = 0; i < data.length > 0; i++) {
                var row = '<tr>';

                var j = $('#tblnotefinderdetails tbody tr').length + 1;

                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';

                row += '<td id="tdRoleName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RoleName + '</td>';
                row += '<td id="tdchkIsview" class="GridViewLabItemStyle" style="text-align: center;">';
                if (data[i].IsView == "0") {
                    row += '<input type="checkbox" class="ack_Checkbox" id="chkAck" value=' + data[i].ID + '  checked="checked" />';

                } else {
                    row += '<input type="checkbox" class="ack_Checkbox" id="chkAck" value=' + data[i].ID + '   disabled="disabled" />';

                }
                row += '   </td>';


                row += '<td id="tdNotewritername" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Dates + '</td>';
                row += '<td id="tAuthor" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Author + '</td>';
                row += '<td id="tdNoteType" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].NoteType + '</td>';
                row += '<td id="tdCadre" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Cadre + '</td>';
                row += '<td id="tdTier" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Tier + '</td>';
                row += '<td id="tdSpecialty" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Specialty + '</td>';
                row += '<td id="tdAckstring" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Ackstring + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="viewnotefinderDetails(this);" style="cursor: pointer;" title="Click To View" /></td>';
                if (data[i].Isedit == '0')
                { row += '<td class="GridViewLabItemStyle" style="text-align: center;"><span style="color: red;"><b>Edit Time Has Expired</span></b></td>'; }

                else { row += '<td class="GridViewLabItemStyle" style="text-align: center; "> <img id="imgDelete" src="../../Images/edit.png" onclick="editNoteFinderDetails(this);" style="cursor: pointer; " title="Click To Add" /></td>'; }
                


                if (data[i].IsApproved == '1') {
                    row += '<td id="tdApprovedStatus" class="GridViewLabItemStyle" style="text-align: center; color:green;font-weight:bolder">' + data[i].ApprovedStatus + '</td>';
                } else {
                    row += '<td id="tdApprovedStatus" class="GridViewLabItemStyle" style="text-align: center;color:red;font-weight:bolder">' + data[i].ApprovedStatus + '</td>';
                }


                if (data[i].IsApproved == '1')
                { row += '<td class="GridViewLabItemStyle" style="text-align: center;"></td>'; }

                else { row += '<td class="GridViewLabItemStyle" style="text-align: center; "> <img id="imgApprove" src="../../Images/Post.gif" onclick="openApproveModel(this);" style="cursor: pointer; " title="Click To Add" /></td>'; }


                row += '<td id="tdApprovedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ApprovedBy + '</td>';
                row += '<td id="tdApprovedRemark" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ApprovedRemark + '</td>';
                row += '<td id="tdApprovedDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ApprovedDate + '</td>';




                row += '<td id="tdNoteTypeID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '<td id="tdnotetypecreation" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].Notetypecreation + '</td>';
                row += '<td id="tdnoteTransactionID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TransactionID + '</td>';
                row += '<td id="tdnotetypevalue" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].notetypevalue + '</td>';
                row += '<td id="tdPatientCreationtblid" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].PatientDetailID + '</td>';


                row += '</tr>';
                $('#tblnotefinderdetails tbody').append(row);
            }
        }
        function viewnotefinderDetails(el) {
            var encounterType = "";
            if ($('#ddlEncounter').val() == '0' || $('#ddlEncounter').val()=='2') {
                encounterType = '<%=Request.QueryString["TID"]%>';
            }
            else { encounterType = '<%=Request.QueryString["PID"]%>'; }
            var row = $(el).closest('tr');
            var Notetype = $(row).find('#tdNoteType').text();
            var NoteTypeID = $(row).find('#tdNoteTypeID').text();
            var notetypecreation = $(row).find('#tdnotetypecreation').text();
            var notetypevalue = $(row).find('#tdnotetypevalue').text();

            tdnotetypevalue
            var editview = "1"
            if (notetypecreation == '1')
            {
                notecreationdetails(Notetype, encounterType, NoteTypeID, notetypecreation, editview)
            }
            else if (notetypecreation == '0') {

                notefinderwriterdetails(encounterType, NoteTypeID, editview, notetypevalue)
            }
            else {
                notefinderprogressdetails(encounterType, NoteTypeID, editview)
            }
        }
        function editNoteFinderDetails(el) {
            var encounterType = "";
            if ($('#ddlEncounter').val() == '0') {
                encounterType = '<%=Request.QueryString["TID"]%>';
            }
            else { encounterType = '<%=Request.QueryString["PID"]%>'; }
            var row = $(el).closest('tr');
            var Notetype = $(row).find('#tdNoteType').text();
            var notetypecreation = $(row).find('#tdnotetypecreation').text();
            var NoteTypeID = $(row).find('#tdNoteTypeID').text();
            $('#spnEditNoteID').text($(row).find('#tdNoteTypeID').text());
            $('#spnEditNotetype').text($(row).find('#tdNoteType').text());
            $('#spnTransactionID').text($(row).find('#tdnoteTransactionID').text())
            $('#spnNotefinderTypeID').text($(row).find('#tdnotetypecreation').text());
            $('#spnNoteTypeValue').text($(row).find('#tdnotetypevalue').text());
            $('#spnPatientCreationtblID').text($(row).find('#tdPatientCreationtblid').text());
            var notetypevalue = $(row).find('#tdnotetypevalue').text();
            var editview = "2"
            if (notetypecreation == '1')
            { notecreationdetails(Notetype, encounterType, NoteTypeID, notetypecreation, editview) }
            else if (notetypecreation == '0') { notefinderwriterdetails(encounterType, NoteTypeID, editview, notetypevalue) }

        else {
                notefinderprogressdetails(encounterType, NoteTypeID, editview)
        }
        }

        function notefinderprogressdetails(encounterType, NoteTypeID, editview)
        {
            serverCall('Notefinder.aspx/bindpatientprogressnotedata', { encounterType: encounterType, encounter: $('#ddlEncounter').val(), NoteTypeID: NoteTypeID }, function (response) {
                var responsedata = JSON.parse(response);
                if (responsedata.status) {

                    $('#txtViewProgressnote').val(responsedata.response[0]["ProgressNote"]);
                    $('#txtViewCarePlan').val(responsedata.response[0]["Careplan"]);

                    if (editview == '1') {
                        $('.readonly').prop('readonly', true);
                    }

                    else { $('.readonly').prop('readonly', false); }

                    $('#divViewNoteProgressNote').show();
                }
                else { modelAlert(responsedata.response, function () { $('#divViewNoteProgressNote').hide(); }); }
              });
        }
        function notefinderwriterdetails(encounterType, NoteTypeID, editview, notetypevalue) {
            serverCall('Notefinder.aspx/bindPatientnotewritedata', { encounterType: encounterType, encounter: $('#ddlEncounter').val(), NoteTypeID: NoteTypeID, notetypevalue: notetypevalue }, function (response) {
                var responsedata = JSON.parse(response);
                if (responsedata.status) {
                    $('#noteTypeDetailID').text(responsedata.response[0]["ID"]);
                    CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData(responsedata.response[0]['Detail']);
                    if (editview == '1') {
                        CKEDITOR.instances['<%=txtDetail.ClientID%>'].setReadOnly(true);
                        $('.readonly').prop('readonly', true);
                        $('#btnViewnotewriter').prop('disabled', true);
                    }

                    else {
                        CKEDITOR.instances['<%=txtDetail.ClientID%>'].setReadOnly(false);
                        $('.readonly').prop('readonly', true);
                        $('#btnViewnotewriter').prop('disabled', false);
                    }


                    $('#divViewNotewriter').show();
                }
            });
        }

        function NotePrint() {
            TID='<%=Request.QueryString["TID"]%>';
            //window.open('../../Design/IPD/printNoteCreationReport_pdf.aspx?TID='<%=Request.QueryString["TID"]%>'&Status=IN&ReportType=PDF');
            window.open('printNoteCreationReport_pdf.aspx?TID=' + TID + '&Status=IN&ReportType=PDF&NoteID='+$('#noteTypeDetailID').text()+'');

                
            };
        function notecreationdetails(Notetype, encounterType, NoteTypeID, notetypecreation, editview) {

            serverCall('Notefinder.aspx/bindnotecreationdetails', { encounterType: encounterType, encounter: $('#ddlEncounter').val(), NoteTypeID: NoteTypeID }, function (response) {
                var responsedata = JSON.parse(response);
                if (editview == '1')
                { bindnotecreationdetails(responsedata.response, Notetype) }

                else { editnotecreationdetails(responsedata.response, Notetype) }
            });
        }
        function editnotecreationdetails(data, Notetype) {
            $('.readonly').prop('readonly', false);
            if (Notetype == 'PMH') {
                $('#txtViewPMHProblem').val(data[0].Problem);
                $('#txtViewPMHOnset').val(data[0].OnSet);
                $('#txtViewPMHDescription').val(data[0].Description);
                $('#txtViewPMHCode').val(data[0].Code);
                $('#divViewPMH').show();
            }
            else if (Notetype == 'PSH') {
                $('#txtPSHSurgeryDate').show();
                $('#lblViewPSHSurgeryDae').hide();
                $('#txtViewPSHSurgery').val(data[0].Surgery);
                $('#txtPSHSurgeryDate').val(data[0].SurgeryDate);
                $('#txtViewPSHDescription').val(data[0].Description);
                $('#txtViewPSHCode').val(data[0].Code);
                $('#divViewPSH').show();

                
            }
            else if (Notetype == 'FH') {
                $('#txtViewFHIllness').val(data[0].Illness);
                $('#txtViewFHRelationship').val(data[0].RelationShip);
                $('#txtFHIDescription').val(data[0].Description);
                $('#txtViewFHCode').val(data[0].Code);
                $('#divViewFH').show();
            }
            else if (Notetype == 'SH') {
                $('#txtSHViewIssue').val(data[0].Issue);
                $('#txtViewDescription').val(data[0].Description);
                $('#txtSHViewCode').val(data[0].Code);

                $('#divViewSH').show();
            }
            else if (Notetype == 'ProblemList') {
                $('#txtPLProblem').val(data[0].Problem);
                $('#txtPLDescription').val(data[0].Description);
                $('#txtPLCode').val(data[0].Code);
                $('#divViewProblemlist').show();
            }

        }

        function bindnotecreationdetails(data, Notetype) {
            $('.readonly').prop('readonly', true);
            if (Notetype == 'PMH') {

                $('#txtViewPMHProblem').val(data[0].Problem);
                $('#txtViewPMHOnset').val(data[0].OnSet);
                $('#txtViewPMHDescription').val(data[0].Description);
                $('#txtViewPMHCode').val(data[0].Code);

                $('#divViewPMH').show();
            }

            else if (Notetype == 'PSH') {
                $('#txtPSHSurgeryDate').hide();
                $('#lblViewPSHSurgeryDae').show()
                $('#txtViewPSHSurgery').val(data[0].Surgery);
                $('#lblViewPSHSurgeryDae').text(data[0].SurgeryDate);
                $('#txtViewPSHDescription').val(data[0].Description);
                $('#txtViewPSHCode').val(data[0].Code);
                $('#divViewPSH').show();
            }
            else if (Notetype == 'FH') {
                $('#txtViewFHIllness').val(data[0].Illness);
                $('#txtViewFHRelationship').val(data[0].RelationShip);
                $('#txtFHIDescription').val(data[0].Description);
                $('#txtViewFHCode').val(data[0].Code);
                $('#divViewFH').show();
            }
            else if (Notetype == 'SH') {
                $('#txtSHViewIssue').val(data[0].Issue);
                $('#txtViewDescription').val(data[0].Description);
                $('#txtSHViewCode').val(data[0].Code);

                $('#divViewSH').show();
            }
            else if (Notetype == 'ProblemList') {
                $('#txtPLProblem').val(data[0].Problem);
                $('#txtPLDescription').val(data[0].Description);
                $('#txtPLCode').val(data[0].Code);

                $('#divViewProblemlist').show();
            }
        }
        function getNoteCreationDetails(callback) {
            $NoteCreation = [];
            var Notetype = $('#spnEditNotetype').text();
            var noteid = $('#spnEditNoteID').text();
            if (Notetype == 'PMH') {
                   $NoteCreation.push({
                       Problem: $('#txtViewPMHProblem').val(),
                       OnSet: $('#txtViewPMHOnset').val(),
                       Description: $('#txtViewPMHDescription').val(),
                       Code:$('#txtViewPMHCode').val(),
                       Surgery: '',
                       SurgeryDate: '',
                       Illness: '',
                       RelationShip: '',
                       Issue: '',
                       ID: noteid

                   });
               }

            if (Notetype == 'PSH') {
                   $NoteCreation.push({
                      
                       Problem: '',
                       OnSet: '',
                       Description: $('#txtViewPSHDescription').val(),
                       Code: $('#txtPSHCode').val(),
                       Surgery: $('#txtViewPSHCode').val(),
                       SurgeryDate: $('#txtPSHSurgeryDate').val(),
                       Illness: '',
                       RelationShip: '',
                       Issue: '',
                       ID: noteid
                   });
               }
            else if (Notetype == 'FH') {
                   $NoteCreation.push({
                       Problem: '',
                       OnSet: '',
                       Description: $('#txtFHIDescription').val(),
                       Code: $('#txtViewFHCode').val(),
                       Surgery: '',
                       SurgeryDate: '',
                       Illness: $('#txtViewFHIllness').val(),
                       RelationShip: $('#txtViewFHRelationship').val(),
                       Issue: '',
                       ID: noteid

                   });
               }
            else if (Notetype == 'SH') {
                   $NoteCreation.push({
                       
                       Problem: '',
                       OnSet: '',
                       Description: $('#txtViewDescription').val(),
                       Code: $('#txtSHViewCode').val(),
                       Surgery: '',
                       SurgeryDate: '',
                       Illness: '',
                       RelationShip: '',
                       Issue: $('#txtSHViewIssue').val(),
                       ID: noteid

                   });
               }
            else if (Notetype == 'ProblemList') {
                   $NoteCreation.push({
                  
                       Problem: $('#txtPLProblem').val(),
                       OnSet: '',
                       Description: $('#txtPLDescription').val(),
                       Code: $('#txtPLCode').val(),
                       Surgery: '',
                       SurgeryDate: '',
                       Illness: '',
                       RelationShip: '',
                       Issue: '',
                       ID: noteid
                   });
               }
               callback({ NoteCreation: $NoteCreation });
           }

        function updatenotecreation() {
       
                getNoteCreationDetails(function (data) {
                   // $(btnSave).attr('disabled', true).val('Submitting...');
                    serverCall('Notefinder.aspx/UpdateNoteCreationpatientlist', data, function (response) {

                        var responseData = JSON.parse(response);
                        if (responseData.status)
                        { modelAlert(responseData.response); }
                        else { modelAlert(responseData.response); }
                    });
                });

        }

        function listSource(el) {
            var TID = $('#spnTransactionID').text();
             serverCall('NoteCreation.aspx/BindPatientNoteCreation', { NoteTypevalue: $('#ddlListSource').val(), TID: TID }, function (response) {
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
                     row += '<td class="GridViewLabItemStyle checked" style="text-align: center;"><input type=checkbox></td>';
                     row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                     row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                     row += '<td id="tdProblem" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Surgery + '</td>';
                     row += '<td id="tdOnSet" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].SurgeryDate + '</td>';
                     row += '<td id="tdDescription" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Description + '</td>';
                     row += '<td id="tdCode" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Code + '</td>';
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
                     row += '<td id="tdOnSet" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].OnSet + '</td>';
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
                     row += '<td class="GridViewLabItemStyle checked" style="text-align: center;"><input type=checkbox></td>';
                     row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                     row += '<td id="tdData" class="GridViewLabItemStyle checked" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                     row += '<td id="tdDiagnosis" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].Diagnosis + '</td>';
                     row += '<td id="tdDiagnosiscode" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].DiagnosisCode + '</td>';
                     row += '</tr>';
                     $('#tbldivPatientNotelistFD tbody').append(row);
                 }
                 $('#divPatientNotelistFD').show();
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
                     table += '<th>On Set</th>';
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
                     table += '<td colspan="5"><b>Disharge Medication:</b></td>';
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
                 CKEDITOR.instances['<%=txtDetail.ClientID%>'].insertHtml(table);
              }



         }
        function updatenotewriterlist() {
            var noteid = $('#spnEditNoteID').text();
            var Details = CKEDITOR.instances['<%=txtDetail.ClientID%>'].getData();

            serverCall('Notefinder.aspx/UpdateNotewriterpatientlist', { noteid: noteid, Details: Details }, function (response) {
                var responsedata = JSON.parse(response);
                if (responsedata.status) {
                    modelAlert(responsedata.response);
                }
                else { modelAlert(responsedata.response); }

            });
        }
        function checkdaterang()
        {
            if ($('#ddlEncounter').val() == '2') {
                $('#divdaterange').show();
            }
            else {
                $('#divdaterange').hide();
            }
        }
        function updateProgressnote()
        {
            var data = {
                noteid: $('#spnEditNoteID').text(),
                progressnote: $('#txtViewProgressnote').val(),
                careplan: $('#txtViewCarePlan').val(),
            }

            serverCall('Notefinder.aspx/updateProgressnotelist', data, function (response) {
                var responsedata = JSON.parse(response);
                if (responsedata.status) {
                    modelAlert(responsedata.response);
                }
                else { modelAlert(responsedata.response); }

            });
        }

        function checkAll() {
            if ($(".checkall").attr('checked')) {
                $(".checked :checkbox").prop('checked', true);
            }
            else {
                $(".checked :checkbox").prop('checked', false);
            }
        }
    </script>
    <form id="form1" runat="server">
         <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Note Finder</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                    <span class="hidden" id="spnEditNoteID" style="display: none;"></span>
                    <span class="hidden" id="spnEditNotetype" style="display: none;"></span>
                    <span class="hidden" id="spnTransactionID" style="display: none;"></span>
                    <span class="hidden" id="spnNotefinderTypeID" style="display: none;"></span>
                     <span class="hidden" id="spnNoteTypeValue" style="display: none;"></span>
                    <span class="hidden" id="spnPatientCreationtblID" style="display: none;"></span>
                </div>

            <div class="Purchaseheader">
                <b>Searching Criteria</b>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Cadre</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4">
                  <select id="ddlCadre" title="All Cadre"></select>
                </div>
                  <div class="col-md-4">
                    <label class="pull-left">Tier</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4">
                  <select id="ddltier" title="All Tier"></select>
                </div>
                  <div class="col-md-4">
                    <label class="pull-left">Specialty</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4">
                  <select id="ddlSpecialty" title="All Specialty"></select>
                </div>

            </div>
             <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Note Type</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4">
                    <select id="ddlNoteType" title="Note Type" >
                      <%--  <option value="0" selected="selected">All</option>
                        <option value="PMH">PMH</option>
                        <option value="PSH">PSH</option>
                        <option value="FH">FH</option>
                        <option value="SH">SH</option>
                        <option value="ProblemList">Problem List</option>
                        <option value="Notewriter">Note Writer</option>
                         <option value="PRGNote" >Progress Note</option>--%>
                    </select>
                </div>
                  <div class="col-md-4">
                    <label class="pull-left">Encounter</label>
                    <b class="pull-right">:</b>

                </div>

                 <%--0 :means Current Transaction ID,1: means Patient UHID --%>

                <div class="col-md-4">
                  <select id="ddlEncounter" title="Encounter" onclick="checkdaterang()">
                      <option value="0">This Encounter</option>
                       <option value="1">All Encounter</option>
                      <option value="2">Date Range</option>
                  </select>
                </div>
             

            </div>
            <div class="row" id="divdaterange" style="display:none">
               <div class="col-md-4">
                   <label class="pull-left">From Date</label>
                   <b class="pull-right">:</b>
               </div> 
                <div class="col-md-4">
                   <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click to Select Date" Width="150px"    ClientIDMode="Static"  ></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
               </div> 
                   <div class="col-md-4">
                   <label class="pull-left">To Date</label>
                   <b class="pull-right">:</b>
               </div> 
                <div class="col-md-4">
                   <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click to Select Date" Width="150px"    ClientIDMode="Static"  ></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTodate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
               </div>

            </div>

            <div class="row" style="text-align:center">
                <input  type="button" title="Search" value="Search" onclick="noterfindersearch()"/>
                
                <input type="button" id="btnAck" style="display: none" onclick="AckbyNurse()" value="Acknowledge" />

            </div>

            <div class="row" style="width:100%;overflow-x:auto">
                  <table class="FixedHeader" id="tblnotefinderdetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle">SrNo</th>
                                            <th class="GridViewHeaderStyle">From Role</th>

                                            <th class="GridViewHeaderStyle">Ack</th>
                                            <th class="GridViewHeaderStyle">Date&Time</th>

                                            <th class="GridViewHeaderStyle">Author</th>
                                            <th class="GridViewHeaderStyle">Note Type</th>
                                            <th class="GridViewHeaderStyle">Cadre</th>
                                            <th class="GridViewHeaderStyle">Tier</th>
                                            <th class="GridViewHeaderStyle">Specialty</th>
                                             <th class="GridViewHeaderStyle">Ack By </th> 
                                             
                                            <th class="GridViewHeaderStyle">View Note</th>
                                             <th class="GridViewHeaderStyle">Addend Note</th>
                                             <th class="GridViewHeaderStyle">Approved Status</th>
                                            <th class="GridViewHeaderStyle">Approve</th>
                                            <th class="GridViewHeaderStyle">Approved By</th>
                                            <th class="GridViewHeaderStyle">Approved Comment</th>
                                             <th class="GridViewHeaderStyle">Approve DateTime </th>

                                            
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>

            </div>
            </div>
    
    </div>


        <div id="divViewPMH" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 801px; height: 317px;overflow-x:auto"">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewPMH" aria-hidden="true">&times;</button>
                        </div>

                 <div class="modal-body">
                     <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">Problem</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtViewPMHProblem" class="readonly"></textarea>
                        
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">On Set</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                            <textarea id="txtViewPMHOnset"  class="readonly"></textarea>
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">Description</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                               <textarea id="txtViewPMHDescription"  class="readonly"></textarea>
                             
                         </div>
                     </div>
                        <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">Code</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                              <textarea id="txtViewPMHCode" class="readonly"></textarea>
                         </div>
                     </div>

                     </div>
                 <div class="modal-footer" id="divviewpmhfooter" >
                     <div class="row readonly" style="text-align:center">
                          <button type="button"  id="btnupdate" onclick="updatenotecreation()">Update</button>
                     </div>
						
				</div>
                
                </div>
            </div>
        </div>
    
        <div id="divViewPSH" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 801px; height: 317px;overflow-x:auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewPSH" aria-hidden="true">&times;</button>
                        </div>

                 <div class="modal-body">
                     <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Surgery</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtViewPSHSurgery" class="readonly"></textarea>
                             
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">SurgeryDate</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <label id="lblViewPSHSurgeryDae" style="display:none"></label>
                             <asp:TextBox ID="txtPSHSurgeryDate" runat="server" ToolTip="Click to Select Date" Width="150px" style="display:none"   ClientIDMode="Static"  ></asp:TextBox>
                            <cc1:CalendarExtender ID="calucSurgeryDate" runat="server" TargetControlID="txtPSHSurgeryDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Description</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                              <textarea id="txtViewPSHDescription" class="readonly"></textarea>
                             
                         </div>
                     </div>
                        <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Code</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                              <textarea id="txtViewPSHCode" class="readonly"></textarea>
                             
                         </div>
                     </div>

                     </div>
                 <div class="modal-footer" id="divViewPSHfooter">
                     <div class="row readonly" style="text-align:center">
                          <button type="button"  id="btnFHpdate" onclick="updatenotecreation()"  >Update</button>
                     </div>
						
				</div>
                </div>
            </div>
        </div>
        <div id="divViewFH" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 801px;height: 317px;overflow-x:auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewFH" aria-hidden="true">&times;</button>
                        </div>
              
                 <div class="modal-body">
                     <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Illness</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtViewFHIllness" class="readonly"></textarea>
                          
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Relationship</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtViewFHRelationship" class="readonly"></textarea>
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Description</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                              <textarea id="txtFHIDescription" class="readonly"></textarea>
                             
                         </div>
                     </div>
                        <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Code</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtViewFHCode" class="readonly"></textarea>
                         </div>
                     </div>

                     </div>
                 <div class="modal-footer" id="divViewFHfooter" >
                     <div class="row readonly" style="text-align:center">
                          <button type="button"  id="btnFHUpdate" onclick="updatenotecreation()"   >Update</button>
                     </div>
						
				</div>
                </div>
             
            </div>
        </div>
         <div id="divViewSH" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 801px; height: 317px;overflow-x:auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewSH" aria-hidden="true">&times;</button>
                        </div>

                 <div class="modal-body">
                     <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Issue</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtSHViewIssue" class="readonly"></textarea>
                             
                         </div>
                     </div>
                 
                      <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Description</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtViewDescription" class="readonly"></textarea>
                             
                         </div>
                     </div>
                        <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Code</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtSHViewCode" class="readonly"></textarea>
                             
                         </div>
                     </div>

                     </div>
                </div>
             <div class="modal-footer" id="divViewSHfooter">
                     <div class="row readonly" style="text-align:center">
                          <button type="button"   id="btnSHUpdate" onclick="updatenotecreation()"  >Update</button>
                     </div>
						
				</div>
            </div>
        </div>
          <div id="divViewProblemlist" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 801px; height: 317px;overflow-x:auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewProblemlist" aria-hidden="true">&times;</button>
                        </div>

                 <div class="modal-body">
                     <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Problem List</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtPLProblem" class="readonly"></textarea>
                             
                         </div>
                     </div>
                 
                      
                     <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Description</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtPLDescription" class="readonly"></textarea>
                             
                         </div>
                     </div>
                        <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Code</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtPLCode" class="readonly"></textarea>
                             
                         </div>
                     </div>

                     </div>
                <div class="modal-footer" id="divViewPLfooter">
                     <div class="row readonly" style="text-align:center" >
                          <button type="button" id="btnPLUpdate" onclick="updatenotecreation()" >Update</button>
                     </div>
						
				</div>
                </div>
            </div>
        </div>

         <div id="divViewNotewriter" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 965px; height: 418px;overflow-x:auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewNotewriter" aria-hidden="true">&times;</button>
                        <label class="pull-left"><b>Note View</b></label>&nbsp;&nbsp;&nbsp;
                        <input type="button" id="btnNotePrint" onclick="NotePrint();" value="Print"/>
                                  <button type="button" id="btnViewnotewriter" onclick="updatenotewriterlist()"  class="readonly">Update</button>
                        <span style="display:none" id="noteTypeDetailID"></span>
                        </div>

                 <div class="modal-body">
                     <div class="row Purchaseheader" style="display:none">
                    <div class="col-md-5 ">
                        <label class="pull-left">List of sources</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlListSource" onchange="listSource(this)">
                             <option value="Select">Select</option>
                            <option value="PMH">Past Medical History</option>
                            <option value="PSH">Past Surgical History</option>
                            <option value="FH">Family History</option>
                            <option value="SH">Social History</option>
                            <option value="Allergy">Allergies</option>
                            <option value="ProblemList">Problem List</option>
                            <option value="DM">Discharge Medications</option>
                            <option value="FD">Final Diagnoses</option>
                            <option value="Vital">24Hrs Vitals</option>
                            <option value="Lab">24Hrs Lab</option>
                            <option value="AM">Active Medicine</option>
                        </select>
                    </div>

                </div>
                     <div class="row">
               
                         <div class="col-md-24">
                             <CKEditor:CKEditorControl ID="txtDetail" BasePath="~/ckeditor" runat="server" EnterMode="BR" ClientIDMode="Static" ></CKEditor:CKEditorControl>
                         </div>
                     </div>

                     </div>
                  <div class="modal-footer" id="div1">
                       
                    
						
				</div>
                </div>
            </div>
        </div>
          <div id="divViewNoteProgressNote" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 681px; height: 208px;overflow-x:auto">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewNoteProgressNote" aria-hidden="true">&times;</button>
                        
                        <label class="pull-left">Progress Note</label>
                        </div>

                 <div class="modal-body">
                     <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Progress Note</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <textarea id="txtViewProgressnote" class="readonly"></textarea>
                        
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-4">
                        <label class="pull-left">Care Plan</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                            <textarea id="txtViewCarePlan"  class="readonly"></textarea>
                         </div>
                     </div>

                     </div>
                  <div class="modal-footer" id="divprogressnote">
                       
                     <div class="row readonly" style="text-align:center" >
                          <button type="button" id="btnprogress" onclick="updateProgressnote()" >Update</button>
                     </div>
						
				</div>
                </div>
            </div>
        </div>
          <div id="divPatientNotelistpmh" class="modal fade " style="display: none">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="divPatientNotelistpmh" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Note Type List
                            </h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">

                                <table class="FixedHeader" id="tblPatientnotecreationlistpmh" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle"><input type="checkbox" class="checkall" onclick="checkAll();" /></th>
                                            <th class="GridViewHeaderStyle">SrNo</th>
                                            <th class="GridViewHeaderStyle">Problem Note</th>
                                            <th class="GridViewHeaderStyle">On Set</th>
                                            <th class="GridViewHeaderStyle">Description</th>
                                            <th class="GridViewHeaderStyle">Code</th>
                                      
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>

                            </div>
                        </div>

                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-md-3">
                                    <input type="button" id="btndadd" value="Add" onclick="add($('#tblPatientnotecreationlistpmh'));" class="pull-left" />
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
                            <h4 class="modal-title">Note Type List
                            </h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">

                                <table class="FixedHeader" id="tblPatientNotelistpsh" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle"><input type="checkbox" class="checkall" onclick="checkAll();" /></th>
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

                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-md-3">
                                    <input type="button" id="btnPatientNotelistpsh" value="Add" onclick="add($('#tblPatientNotelistpsh'));" class="pull-left" />
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
                            <h4 class="modal-title">Note Type List
                            </h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <table class="FixedHeader" id="tblPatientNotelistFH" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle"><input type="checkbox" class="checkall" onclick="checkAll();" /></th>
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

                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-md-3">
                                    <input type="button" id="btnPatientNotelistFH" value="Add" onclick="add($('#tblPatientNotelistFH'));" class="pull-left" />
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
                            <h4 class="modal-title">Note Type List
                            </h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <table class="FixedHeader" id="tblPatientNotelistSH" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle"><input type="checkbox" class="checkall" onclick="checkAll();" /></th>
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

                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-md-3">
                                    <input type="button" id="btnPatientNotelistSH" value="Add" onclick="add($('#tblPatientNotelistSH'));" class="pull-left" />
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
                            <h4 class="modal-title">Note Type List
                            </h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <table class="FixedHeader" id="tblPatientNotelistPL" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle"><input type="checkbox" class="checkall" onclick="checkAll();" /></th>
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

                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-md-3">
                                    <input type="button" id="btnPatientNotelistPL" value="Add" onclick="add($('#tblPatientNotelistPL'));" class="pull-left" />
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
                            <h4 class="modal-title">Note Type List
                            </h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <table class="FixedHeader" id="tbldivPatientNotelistDM" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle"><input type="checkbox" class="checkall" onclick="checkAll();" /></th>
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

                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-md-3">
                                    <input type="button" id="btntbldivPatientNotelistDM" value="Add" onclick="add($('#tbldivPatientNotelistDM'));" class="pull-left" />
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
                            <h4 class="modal-title">Note Type List
                            </h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <table class="FixedHeader" id="tbldivPatientNotelistallergy" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle"><input type="checkbox" class="checkall" onclick="checkAll();" /></th>
                                            <th class="GridViewHeaderStyle">SrNo</th>
                                            <th class="GridViewHeaderStyle">Allergy</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>

                            </div>
                        </div>

                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-md-3">
                                    <input type="button" id="btndivPatientNotelistallergy" value="Add" onclick="add($('#tbldivPatientNotelistallergy'));" class="pull-left" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="divPatientNotelistFD" class="modal fade " style="display: none">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 839px; height: 211px; overflow-x: auto">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="divPatientNotelistFD" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Note Type List
                            </h4>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <table class="FixedHeader" id="tbldivPatientNotelistFD" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle"><input type="checkbox" class="checkall" onclick="checkAll();" /></th>
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
   
         <div class="modal fade" id="modelApproved">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeApproveModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Approved</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">

                            <label id="lblOrderIdToApprove" style="display:none" ></label>
                            <div class="col-md-3">
                                Comment :
                            </div>

                            <div class="col-md-13">
                                   <textarea cols="2" rows="5" id="txtComment" class="required"></textarea>
                            </div>

                            <div class="col-md-4">
                                Is Approve :
                                </div>
                            <div class="col-md-4">
                                <input type="checkbox"  id="chkIsApprovd" checked="checked" />
                            </div>

                        </div>
                        
                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnApproved" onclick="ApproveOrderOfStudent()" value="Submit" style="padding: 2px 5px; border: 1px solid transparent; font-size: 14px;" />
                    </div>
                </div>

            </div>
        </div>

        
         
        
        
        
         </form>

    <script type="text/javascript">


        function hidShowButton() {
            var field = 'IsView';
            var url = window.location.href;
            var IsView = "0";
            if (url.indexOf('?' + field + '=') != -1) {
                IsView = "1";
            }
            else if (url.indexOf('&' + field + '=') != -1) {
                IsView = "1";

            }

            if (IsView == "1") {
                $("#btnAck").show();
            } else {
                $("#btnAck").hide();
            }
        }

        function AckbyNurse() {
            var ordId = "";
            var count = ""

            $("#tblnotefinderdetails #chkAck:checked").each(function () {
                if (count == 0) {
                    ordId = this.value;

                } else {
                    ordId = ordId + ',' + this.value;
                }
                count = count + 1;

            });

            if (ordId != "") {
                serverCall('Notefinder.aspx/ViewOrders', { Id: ordId }, function (response) {
                    var responsedata = JSON.parse(response);
                    modelAlert(responsedata.response, function () {
                        if (responsedata.status) {
                            noterfindersearch();
                        }
                    });

                });
            } else {
                modelAlert("Select Orders to Acknowledge.")
            }

        }


    </script>


    <script type="text/javascript">

        var openApproveModel = function (el) {
          
            var row = $(el).closest('tr'); 
            var NoteTypeID = $(row).find('#tdNoteTypeID').text();
           
            $("#lblOrderIdToApprove").text(NoteTypeID);
            $("#modelApproved").showModel();
        }

        var $closeApproveModel = function () {
            $("#modelApproved").hideModel();
            $('#lblOrderIdToApprove').text("");
        }





        function ApproveOrderOfStudent() {

            var ordId = $("#lblOrderIdToApprove").text();
            var Comment = $("#txtComment").val();
            var IsApprovd = $('#chkIsApprovd').is(':checked');
            var Approve = 0;
            if (IsApprovd) {
                Approve = 1;
            }

            serverCall('Notefinder.aspx/ApproveOrder', { Id: ordId, ApprovedRemark: Comment, isApproved: Approve }, function (response) {
                var responsedata = JSON.parse(response);
                modelAlert(responsedata.response, function () {
                    if (responsedata.status) {
                        window.location.reload();
                    }
                })

            });
        }

    </script>

</body>
</html>
