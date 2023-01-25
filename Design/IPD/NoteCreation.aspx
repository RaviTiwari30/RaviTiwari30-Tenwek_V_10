<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NoteCreation.aspx.cs" Inherits="Design_IPD_NoteCreation" %>

<!DOCTYPE html>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
       
     <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
       <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />
      <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>

  
  
    <script type="text/javascript">

       $(document).ready(function(){
           NoteType();
       });
        
        $('.datepicker').datepicker({
            minDate: 0,
            maxDate: 1,
            dateFormat: 'yy-mm-dd',

        });

        //var d = new Date(1980, 2, 2);
        //$('.datepicker').datepicker({
        //    changeMonth: true,
        //    changeYear: true,
        //    defaultDate: d,
        //    yearRange: '1970:1992',
        //    dateFormat: 'yy-mm-dd',
        //    monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        //    dayNamesMin: ['Mon', 'Tue', 'Wed', 'Thu', '&#268;et', 'Pet', 'Sub']
        //});
        $('.timepicker').timepicker({
            timeFormat: 'h:mm p',
            interval: 1,
            minTime: '00:01',
            maxTime: '11:59pm',
            // defaultTime: '00:01',
            startTime: '00:01',
            dynamic: false,
            dropdown: true,
            scrollbar: true
        });
  
        function bindPatientNoteCreation(data) {
            $('#btnSave').show();
        if($('#ddlNoteType').val()=='PMH'){
          $('#tblPMH tbody').empty();
          $('#tblPMH').show(); $('#tblPSH').hide(); $('#tblFH').hide(); $('#tblSH').hide(); $('#tblProblem').hide(); $('#tblProgressnote').hide();
              for (var i = 0; i < data.length > 0; i++)
            {
                  var row = '<tr>';
                var j = $('#tblPMH tbody tr').length + 1;
                row += '<td id="tdSqno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdPMHCreatedDate" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].CreatedDate + '</td>';
                row += '<td id="tdNoteType" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].NoteType + '</td>';
                row += '<td id="tdpmhAuthor" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Author + '</td>';
                row += '<td id="tdpmhProblem" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Problem + '</td>';
                row += '<td id="tdpmhOnSet" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].OnSet + '</td>';
                row += '<td id="tdpmhDescription" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Description + '</td>';
                row += '<td id="tdpmhCode" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Code + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHEdit" src="../../Images/edit.png" onclick="EditPMHNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHDelete" src="../../Images/Delete.gif" onclick="rejectNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdNoteID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].id + '</td>';
                
                  row += '</tr>';
                $('#tblPMH tbody').append(row);
                  
              }
              $('#tblPMH').tableDnD({
                  onDragClass: "myDragClass",
                  onDragStart: function (table, row) {
                  },
                  dragHandle: ".dragHandle"

              });
        }
        else if ($('#ddlNoteType').val() == 'PSH') {

        

            $('#tblPSH tbody').empty();
            $('#tblPMH').hide(); $('#tblPSH').show(); $('#tblFH').hide(); $('#tblSH').hide(); $('#tblProblem').hide(); $('#tblProgressnote').hide();
            for (var i = 0; i < data.length > 0; i++)
            {
                var row = '<tr>';
                var j = $('#tblPSH tbody tr').length + 1;
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdPSHCreatedDate" class="GridViewLabItemStyle" style="text-align: center;" onmouseover="chngcurmove()">' + data[i].CreatedDate + '</td>';
                row += '<td id="tdNoteType" class="GridViewLabItemStyle" style="text-align: center;" onmouseover="chngcurmove()">' + data[i].NoteType + '</td>';
                row += '<td id="tdPSHAuthor" class="GridViewLabItemStyle" style="text-align: center;" onmouseover="chngcurmove()">' + data[i].Author + '</td>';
                row += '<td id="tdPSHSurgry" class="GridViewLabItemStyle" style="text-align: center;" onmouseover="chngcurmove()" >' + data[i].Surgery + '</td>';
                row += '<td id="tdPSHSurgeryDate" class="GridViewLabItemStyle" style="text-align: center;" onmouseover="chngcurmove()" >' + data[i].SurgeryDate + '</td>';
                row += '<td id="tdPSHDescription" class="GridViewLabItemStyle" style="text-align: center;" onmouseover="chngcur()" >' + data[i].Description + '</td>';
                row += '<td id="tdPSHCode" class="GridViewLabItemStyle" style="text-align: center;" onmouseover="chngcurmove()" >' + data[i].Code + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHEdit" src="../../Images/edit.png" onclick="EditPSHNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHDelete" src="../../Images/Delete.gif" onclick="rejectNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdNoteID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].id + '</td>';
                
                row += '</tr>';
                $('#tblPSH tbody').append(row);
                  
            }
            $('#tblPSH').tableDnD({
                onDragClass: "myDragClass",
                onDragStart: function (table, row) {
                },
                dragHandle: ".dragHandle"

            });
    
        }
        else if ($('#ddlNoteType').val() == 'FH') {
            $('#tblFH tbody').empty();
            $('#tblPMH').hide(); $('#tblPSH').hide(); $('#tblFH').show(); $('#tblSH').hide(); $('#tblProblem').hide(); $('#tblProgressnote').hide();
            for (var i = 0; i < data.length > 0; i++) {
                var row = '<tr>';
                var j = $('#tblFH tbody tr').length + 1;
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdFHCreatedDate" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].CreatedDate + '</td>';
                row += '<td id="tdNoteType" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].NoteType + '</td>';
                row += '<td id="tdFHAuthor" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Author + '</td>';
                row += '<td id="tdFHIllness" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Illness + '</td>';
                row += '<td id="tdFHRelationShip" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].RelationShip + '</td>';
                row += '<td id="tdFHDescription" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Description + '</td>';
                row += '<td id="tdFHCode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Code + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHEdit" src="../../Images/edit.png" onclick="EditFHNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHDelete" src="../../Images/Delete.gif" onclick="rejectNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdNoteID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].id + '</td>';

                row += '</tr>';
                $('#tblFH tbody').append(row);

              

            }
            $('#tblFH').tableDnD({
                onDragClass: "myDragClass",
                onDragStart: function (table, row) {
                },
                dragHandle: ".dragHandle"

            });
        }
        else if ($('#ddlNoteType').val() == 'SH') {
            $('#tblSH tbody').empty();
            $('#tblPMH').hide(); $('#tblPSH').hide(); $('#tblFH').hide(); $('#tblSH').show(); $('#tblProblem').hide(); $('#tblProgressnote').hide();
            for (var i = 0; i < data.length > 0; i++) {
                var row = '<tr>';
                var j = $('#tblSH tbody tr').length + 1;
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdSHCreatedDate" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].CreatedDate + '</td>';
                row += '<td id="tdNoteType" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].NoteType + '</td>';
                row += '<td id="tdSHAuthor" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Author + '</td>';
                row += '<td id="tdSHIssue" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Issue + '</td>';
                row += '<td id="tdSHDescription" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Description + '</td>';
                row += '<td id="tdSHCode" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Code + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHEdit" src="../../Images/edit.png" onclick="EditSHNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHDelete" src="../../Images/Delete.gif" onclick="rejectNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdNoteID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].id + '</td>';

                row += '</tr>';
                $('#tblSH tbody').append(row);

            }
            $('#tblSH').tableDnD({
                onDragClass: "myDragClass",
                onDragStart: function (table, row) {
                },
                dragHandle: ".dragHandle"

            });
        }
        else if ($('#ddlNoteType').val() == 'ProblemList') {
            $('#tblProblem tbody').empty();
            $('#tblPMH').hide(); $('#tblPSH').hide(); $('#tblFH').hide(); $('#tblSH').hide(); $('#tblProblem').show(); $('#tblProgressnote').hide();
            for (var i = 0; i < data.length > 0; i++) {
                var row = '<tr>';
                var j = $('#tblProblem tbody tr').length + 1;
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdSHCreatedDate" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].CreatedDate + '</td>';
                row += '<td id="tdNoteType" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].NoteType + '</td>';
                row += '<td id="tdSHAuthor" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Author + '</td>';
                row += '<td id="tdPProblem" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Problem + '</td>';
                row += '<td id="tdPDescription" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Description + '</td>';
                row += '<td id="tdPCode" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Code + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHEdit" src="../../Images/edit.png" onclick="EditPNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHDelete" src="../../Images/Delete.gif" onclick="rejectNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdNoteID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].id + '</td>';

                row += '</tr>';
                $('#tblProblem tbody').append(row);

            }
            $('#tblProblem').tableDnD({
                onDragClass: "myDragClass",
                onDragStart: function (table, row) {
                },
                dragHandle: ".dragHandle"

            });
            
        }
        else if ($('#ddlNoteType').val() == 'PRGNote') {
            $('#tblProgressnote tbody').empty();
            $('#tblPMH').hide(); $('#tblPSH').hide(); $('#tblFH').hide(); $('#tblSH').hide(); $('#tblProblem').hide(); $('#tblProgressnote').show();
            for (var i = 0; i < data.length > 0; i++) {
                var row = '<tr>';
                var j = $('#tblProgressnote tbody tr').length + 1;
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdSHCreatedDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Dates + '</td>';
                row += '<td id="tdNoteType" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Notetype + '</td>';
                row += '<td id="tdSHAuthor" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Author + '</td>';
                row += '<td id="tdPProblem" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].ProgressNote + '</td>';
                row += '<td id="tdPDescription" class="GridViewLabItemStyle" style="text-align: center;onmouseover="chngcurmove()"">' + data[i].Careplan + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHEdit" src="../../Images/edit.png" onclick="EditPrgNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPMHDelete" src="../../Images/Delete.gif" onclick="rejectNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdNoteID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].ID + '</td>';

                row += '</tr>';
                $('#tblProgressnote tbody').append(row);

            }
            $('#tblProgressnote').tableDnD({
                onDragClass: "myDragClass",
                onDragStart: function (table, row) {
                },
                dragHandle: ".dragHandle"

            });

        }

        else {
            $('#tblProblem').hide(); $('#tblPSH').hide(); $('#tblFH').hide(); $('#tblSH').hide(); $('#tblProblem').hide(); $('#divnotewriter').hide(); $('#tblPMH').hide(); $('#PRGNote').hide();
        }
        }

        
        function rejectNote(el) {
            var row = $(el).closest('tr');
            var id = $(row).find('#tdNoteID').text();
            var Notetype = $(row).find('#tdNoteType').text();

            modelConfirmation('Confirmation!!!', 'Are you sure, you want to delete this note.', 'Yes', 'No', function (response) {
                if (response) {

                    serverCall('NoteCreation.aspx/DeactivePatientNotes', { id: id, Notetype: Notetype }, function (response) {
                        var responsedata = JSON.parse(response);
                        if (responsedata.status) {
                            modelAlert(responsedata.response, function () {
                                NoteType();
                            });
                        }
                        else {
                            modelAlert(responsedata.response, function () {

                            });
                        }
                    });

                }
            });
        }
        function EditPrgNote(el) {
            var row = $(el).closest('tr');
            $('#txtprgnote').val($(row).find('#tdPProblem').text());
            $('#txtprgCareplan').val($(row).find('#tdPDescription').text());
            $('#spnEditNoteID').text($(row).find('#tdNoteID').text());
            $('#btnSave').val('Update');

        }
        function EditPNote(el) {
            var row = $(el).closest('tr');
            $('#txtPlProblem').val($(row).find('#tdPProblem').text());
            $('#txtPdescription').val($(row).find('#tdPDescription').text());
            $('#txtPCode').val($(row).find('#tdPCode').text());
            $('#spnEditNoteID').text($(row).find('#tdNoteID').text());
            $('#btnSave').val('Update');

        }
        function EditSHNote(el) {
            var row = $(el).closest('tr');
            $('#txtSHIssue').val($(row).find('#tdSHIssue').text());
            $('#txtSHDescription').val($(row).find('#tdSHDescription').text());
            $('#txtSHCode').val($(row).find('#tdSHCode').text());
            $('#spnEditNoteID').text($(row).find('#tdNoteID').text());
            $('#btnSave').val('Update');

        }
        function EditFHNote(el) {
            var row = $(el).closest('tr');
            $('#txtFHillness').val($(row).find('#tdFHIllness').text());
            $('#txtFHRelationship').val($(row).find('#tdFHRelationShip').text());
            $('#txtFHDescription').val($(row).find('#tdFHRelationShip').text());
            $('#txtFHCode').val($(row).find('#tdFHDescription').text());
            $('#spnEditNoteID').text($(row).find('#tdNoteID').text());
            $('#btnSave').val('Update');

        }
        function EditPSHNote(el) {
            var row = $(el).closest('tr');
            $('#txtPSHSurgery').val($(row).find('#tdPSHSurgry').text());
            $('#txtPSHSurgeryDate').val($(row).find('#tdPSHSurgeryDate').text());
            $('#txtPSHDescription').val($(row).find('#tdPSHDescription').text());
            $('#txtPSHCode').val($(row).find('#tdPSHCode').text());
            $('#spnEditNoteID').text($(row).find('#tdNoteID').text());
            $('#btnSave').val('Update');

        }
        function EditPMHNote(el)
        {
            var row= $(el).closest('tr');
            $('#txtPMHProblem').val($(row).find('#tdpmhProblem').text());
            $('#txtPMHOnset').val($(row).find('#tdpmhOnSet').text());
            $('#txtPMHDescription').val($(row).find('#tdpmhDescription').text());
            $('#txtPMHCode').val($(row).find('#tdpmhCode').text());
            $('#spnEditNoteID').text($(row).find('#tdNoteID').text())
            $('#btnSave').val('Update');
          
        }
        function NoteType() {
            NoteTypevalue = $('#ddlNoteType').val();
            TID='<%=Request.QueryString["TID"]%>'
            if(NoteTypevalue!='Select')
                {
                      serverCall('NoteCreation.aspx/BindPatientNoteCreation', {NoteTypevalue:NoteTypevalue,TID:TID}, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) {
                            bindPatientNoteCreation(responseData.response);
                            $('#divPatientNote').show();
                            $('#btnSave').val('Save');
                            $('#spnEditNoteID').text();
                        }
                        else { $('#tblPMH tbody').empty(); $('#divPatientNote').hide(); }
                    });
                }
            if (NoteTypevalue == 'PMH')
            {
                $('#divPMH').show(); $('#divPSH').hide(); $('#divFH').hide(); $('#divSH').hide(); $('#divProblemList').hide(); $('#divnotewriter').hide(); $('#divProgressNote').hide();
            }
            else if (NoteTypevalue == 'PSH') {
                $('#divPMH').hide(); $('#divPSH').show(); $('#divFH').hide(); $('#divSH').hide(); $('#divProblemList').hide(); $('#divnotewriter').hide(); $('#divProgressNote').hide();
           }
           else if (NoteTypevalue == 'FH') {
               $('#divPMH').hide(); $('#divPSH').hide(); $('#divFH').show(); $('#divSH').hide(); $('#divProblemList').hide(); $('#divnotewriter').hide(); $('#divProgressNote').hide();
           }
           else if (NoteTypevalue == 'SH') {
               $('#divPMH').hide(); $('#divPSH').hide(); $('#divFH').hide(); $('#divSH').show(); $('#divProblemList').hide(); $('#divnotewriter').hide(); $('#divProgressNote').hide();
           }
           else if (NoteTypevalue == 'ProblemList') {
               $('#divPMH').hide(); $('#divPSH').hide(); $('#divFH').hide(); $('#divSH').hide(); $('#divProblemList').show(); $('#divProgressNote').hide();
           }
           else if (NoteTypevalue == 'Notewriter') {
               $('#btnSave').hide();
               $('#divPMH').hide(); $('#divPSH').hide(); $('#divFH').hide(); $('#divSH').hide(); $('#divProblemList').hide(); $('#divnotewriter').show(); $('#divProgressNote').hide(); $('#divnotewriter').show();
               var TID = '<%=Request.QueryString["TID"]%>';
               bindPatientnotewriterlist(TID);
           }
           else if (NoteTypevalue == 'PRGNote') {
               $('#divPMH').hide(); $('#divPSH').hide(); $('#divFH').hide(); $('#divSH').hide(); $('#divProblemList').hide(); $('#divnotewriter').hide(); $('#divProgressNote').show();
           }

        }
        function Save()
        {
            if ($('#ddlNoteType').val() == 'Select')
            {
                modelAlert("Please Select Note Type");
                return;
            }
            if ($('#ddlNoteType').val() == 'PMH') {

                if ($('#txtPMHProblem').val() == '') {
                    modelAlert("Please enter problem");
                    return;
                }
            }
            if ($('#ddlNoteType').val() == 'PSH') {

                if ($('#txtPSHSurgery').val() == '') {
                    modelAlert("Please enter Surgery Name");
                    return;
                }
            }
            if ($('#ddlNoteType').val() == 'FH') {

                if ($('#txtFHillness').val() == '') {
                    modelAlert("Please enter  Illness ");
                    return;
                }
            }
            if ($('#ddlNoteType').val() == 'SH') {

                if ($('#txtSHIssue').val() == '') {
                    modelAlert("Please enter Issue ");
                    return;
                }
            }
         
            if ($('#ddlNoteType').val() == 'ProblemList') {

                if ($('#txtPlProblem').val() == '') {
                    modelAlert("Please enter Problem ");
                    return;
                }
            }


            getNoteCreationDetails(function (data) {
                 $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('NoteCreation.aspx/SavePatentNoteCreation', data, function (response) {
                var responseData = JSON.parse(response);
             if (responseData.status) {
                 modelAlert(responseData.response, function () {
                     NoteType();
                 clear();
               $(btnSave).removeAttr('disabled').val('Save');
                 
             });
            
             }
                else{      modelAlert(responseData.response,function(){
               $(btnSave).removeAttr('disabled').val('Save');
             });}
            });
            });
    
        }
        function SaveTable() {
            if ($('#ddlNoteType').val() == 'Select') {
                modelAlert("Please Select Note Type");
                return;
            }
            savenoteCreationTypeTable(function (data) {
            //    $(btnSavesqtable).attr('disabled', true).val('Submitting...');
                serverCall('NoteCreation.aspx/SavePatentNoteCreationtable', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            NoteType();
                            clear();
                            $(btnSavesqtable).removeAttr('disabled').val('Save');

                        });

                    }
                    else {
                        modelAlert(responseData.response, function () {
                            $(btnSavesqtable).removeAttr('disabled').val('Save');
                        });
                    }
                });
            });

        }

        function clear(){
            $('#txtPMHProblem').val('');
            $('#txtPMHOnset').val('');
            $('#txtPMHDescription').val('');
            $('#txtPMHCode').val('');
            $('#txtPSHSurgery').val('');
            $('#txtPSHDescription').val('');
            $('#txtPSHCode').val('');
            $('#txtFHillness').val();
            $('#txtFHRelationship').val('');
            $('#txtFHDescription').val('');
            $('#txtFHCode').val('');
            $('#txtSHIssue').val('');
            $('#txtSHDescription').val('');
            $('#txtSHCode').val('');
            $('#txtPlProblem').val('');
            $('#txtPdescription').val('');
            $('#txtPCode').val('');
            $('#txtprgnote').val('');
            $('#txtprgCareplan').val('');
        
        }

        function getNoteCreationDetails(callback) {
            $NoteCreation = [];
            var TID= '<%=Request.QueryString["TID"]%>';
            var PID= '<%=Request.QueryString["PID"]%>';
            var DoctorID= '<%=Request.QueryString["DoctorID"]%>';
            if ($('#ddlNoteType').val() == 'PMH') {
                    $NoteCreation.push({
                        NoteType: $('#ddlNoteType').val(),
                        Problem: $('#txtPMHProblem').val(),
                        OnSet: $('#txtPMHOnset').val(),
                        Description: $('#txtPMHDescription').val(),
                        Code: $('#txtPMHCode').val(),
                        Surgery: '',
                        SurgeryDate: '',
                        Illness: '',
                        RelationShip: '',
                        Issue: '',
                        DoctorID: DoctorID,
                        PatientID: PID,
                        TransactionID: TID,
                        NoteCreationDate: $('#txtdate').val(),
                        ProgressNote: '',
                        Careplan: '',
                        SaveType: $('#btnSave').val(),
                        ID: $('#spnEditNoteID').text()
                    });
                }
              
                    if ($('#ddlNoteType').val() == 'PSH') {
                        $NoteCreation.push({
                            NoteType: $('#ddlNoteType').val(),
                            Problem: '',
                            OnSet: '',
                            Description: $('#txtPSHDescription').val(),
                            Code: $('#txtPSHCode').val(),
                            Surgery: $('#txtPSHSurgery').val(),
                            SurgeryDate: $('#txtPSHSurgeryDate').val(),
                            Illness: '',
                            RelationShip: '',
                            Issue: '',
                            DoctorID: DoctorID,
                            PatientID: PID,
                            TransactionID: TID,
                            NoteCreationDate: $('#txtdate').val(),
                            ProgressNote: '',
                            Careplan: '',
                            SaveType: $('#btnSave').val(),
                            ID: $('#spnEditNoteID').text()
                        });
                        }
                      else  if ($('#ddlNoteType').val() == 'FH') {
                            $NoteCreation.push({
                                NoteType: $('#ddlNoteType').val(),
                                Problem: '',
                                OnSet: '',
                                Description: $('#txtFHDescription').val(),
                                Code: $('#txtFHCode').val(),
                                Surgery: '',
                                SurgeryDate: '',
                                Illness:  $('#txtFHillness').val(),
                                RelationShip: $('#txtFHRelationship').val(),
                                Issue: '',
                                DoctorID: DoctorID,
                                PatientID: PID,
                                TransactionID: TID,
                                NoteCreationDate: $('#txtdate').val(),
                                ProgressNote: '',
                                Careplan: '',
                                SaveType: $('#btnSave').val(),
                                ID: $('#spnEditNoteID').text()

                            });
                            }
                           else if ($('#ddlNoteType').val() == 'SH') {
                                $NoteCreation.push({
                                    NoteType: $('#ddlNoteType').val(),
                                    Problem: '',
                                    OnSet: '',
                                    Description: $('#txtSHDescription').val(),
                                    Code: $('#txtSHCode').val(),
                                    Surgery: '',
                                    SurgeryDate: '',
                                    Illness: '',
                                    RelationShip: '',
                                    Issue: $('#txtSHIssue').val(),
                                    DoctorID: DoctorID,
                                    PatientID: PID,
                                    TransactionID: TID,
                                    NoteCreationDate: $('#txtdate').val(),
                                    ProgressNote: '',
                                    Careplan: '',
                                    SaveType: $('#btnSave').val(),
                                    ID: $('#spnEditNoteID').text()

                                });
                                }
          else  if ($('#ddlNoteType').val() == 'ProblemList') {
                                $NoteCreation.push({
                                    NoteType: $('#ddlNoteType').val(),
                                    Problem: $('#txtPlProblem').val(),
                                    OnSet: '',
                                    Description: $('#txtPdescription').val(),
                                    Code: $('#txtPCode').val(),
                                    Surgery: '',
                                    SurgeryDate: '',
                                    Illness: '',
                                    RelationShip: '',
                                    Issue: '',
                                    DoctorID: DoctorID,
                                    PatientID: PID,
                                    TransactionID: TID,
                                    NoteCreationDate: $('#txtdate').val(),
                                    ProgressNote: '',
                                    Careplan: '',
                                    SaveType: $('#btnSave').val(),
                                    ID: $('#spnEditNoteID').text()
                                });
          }
          else if ($('#ddlNoteType').val() == 'PRGNote') {
              $NoteCreation.push({
                  NoteType: $('#ddlNoteType').val(),
                  Problem: $('#txtPlProblem').val(),
                  OnSet: '',
                  Description: $('#txtPdescription').val(),
                  Code: $('#txtPCode').val(),
                  Surgery: '',
                  SurgeryDate: '',
                  Illness: '',
                  RelationShip: '',
                  Issue: '',
                  DoctorID: DoctorID,
                  PatientID: PID,
                  TransactionID: TID,
                  NoteCreationDate: $('#txtdate').val(),
                  ProgressNote: $('#txtprgnote').val(),
                  Careplan: $('#txtprgCareplan').val(),
                  SaveType: $('#btnSave').val(),
                  ID: $('#spnEditNoteID').text()
              });
          }
                callback({ NoteCreation: $NoteCreation });
        }

        //$("#tb_grdEMR tr").each(function () {
        //    var id = $(this).attr("id");
        //    var $rowid = $(this).closest("tr");
        //    if (id != "Header") {
        //        EMR.push({ "SNo": $(this).attr("id"), "HeaderID": $.trim($rowid.find("#tdHeaderID").text()), "HeaderName": $.trim($rowid.find("#tdHeaderName").text()), "SequenceNo": $.trim($rowid.find('#tdSeqNo').text()), "Active": $.trim($rowid.find('#tdActive input[type:radio]:checked').val()) });
        //    }
        //});


        function savenoteCreationTypeTable(callback) {
            $NoteCreation = [];
            var TID = '<%=Request.QueryString["TID"]%>';
            var PID = '<%=Request.QueryString["PID"]%>';
            var DoctorID = '<%=Request.QueryString["DoctorID"]%>';
            if ($('#ddlNoteType').val() == 'PMH') {
                $('#tblPMH tbody tr').each(function (index, elem) {
                    var $row = $(elem);
                    var id = $(this).attr("id");
                    $($row).find('#spnPPanelID').text()
                    $NoteCreation.push({
                        NoteType: $('#ddlNoteType').val(),
                        Problem: $($row).find('#tdpmhProblem').text(),
                        OnSet: $($row).find('#tdpmhOnSet').text(),
                        Description: $($row).find('#tdpmhDescription').text(),
                        Code: $($row).find('#tdpmhCode').text(),
                        Surgery: '',
                        SurgeryDate: '',
                        Illness: '',
                        RelationShip: '',
                        Issue: '',
                        DoctorID: DoctorID,
                        PatientID: PID,
                        TransactionID: TID,
                        NoteCreationDate: $($row).find('#tdPMHCreatedDate').text(), 
                        ProgressNote: '',
                        Careplan: '',
                        SaveType: $('#btnSave').val(),
                        ID: $('#spnEditNoteID').text(),
                        sqno: $(this).attr("id"),
                    });
                });
            }

            if ($('#ddlNoteType').val() == 'PSH') {
                $('#tblPSH tbody tr').each(function (index, elem) {
                    var $row = $(elem);
                    var id = $(this).attr("id");
                    $NoteCreation.push({
                        NoteType: $('#ddlNoteType').val(),
                        Problem: '',
                        OnSet: '',
                        Description: $($row).find('#tdPSHDescription').text(),
                        Code: $($row).find('#tdPSHCode').text(),
                        Surgery: $($row).find('#tdPSHSurgry').text(),
                        SurgeryDate: $($row).find('#tdPSHSurgeryDate').text(),
                        Illness: '',
                        RelationShip: '',
                        Issue: '',
                        DoctorID: DoctorID,
                        PatientID: PID,
                        TransactionID: TID,
                        NoteCreationDate: $($row).find('#tdPSHCreatedDate').text(),
                        ProgressNote: '',
                        Careplan: '',
                        SaveType: $('#btnSave').val(),
                        ID: $('#spnEditNoteID').text(),
                        sqno: $(this).attr("id")
                    });
                });
            }
            else if ($('#ddlNoteType').val() == 'FH') {
                $('#tblFH tbody tr').each(function (index, elem) {
                    var $row = $(elem);
                    var id = $(this).attr("id");
                    $NoteCreation.push({
                        NoteType: $('#ddlNoteType').val(),
                        Problem: '',
                        OnSet: '',
                        Description: $($row).find('#tdFHDescription').text(),
                        Code: $($row).find('#tdFHCode').text(),
                        Surgery: '',
                        SurgeryDate: '',
                        Illness: $($row).find('#tdFHIllness').text(),
                        RelationShip: $($row).find('#tdFHRelationShip').text(),
                        Issue: '',
                        DoctorID: DoctorID,
                        PatientID: PID,
                        TransactionID: TID,
                        NoteCreationDate: $($row).find('#tdFHCreatedDate').text(),
                        ProgressNote: '',
                        Careplan: '',
                        SaveType: $('#btnSave').val(),
                        ID: $('#spnEditNoteID').text(),
                        sqno: $(this).attr("id")

                    });
                });
            }
            else if ($('#ddlNoteType').val() == 'SH') {
                $('#tblSH tbody tr').each(function (index, elem) {
                    var $row = $(elem);
                    var id = $(this).attr("id");
                    $NoteCreation.push({
                        NoteType: $('#ddlNoteType').val(),
                        Problem: '',
                        OnSet: '',
                        Description: $($row).find('#tdSHDescription').text(),
                        Code: $($row).find('#tdSHCode').text(),
                        Surgery: '',
                        SurgeryDate: '',
                        Illness: '',
                        RelationShip: '',
                        Issue: $($row).find('#tdSHIssue').text(),
                        DoctorID: DoctorID,
                        PatientID: PID,
                        TransactionID: TID,
                        NoteCreationDate: $($row).find('#tdSHCreatedDate').text(),
                        ProgressNote: '',
                        Careplan: '',
                        SaveType: $('#btnSave').val(),
                        ID: $('#spnEditNoteID').text(),
                        sqno: $(this).attr("id")

                    });
                });
            }
            else if ($('#ddlNoteType').val() == 'ProblemList') {
                $('#tblProblem tbody tr').each(function (index, elem) {
                    var $row = $(elem);
                    var id = $(this).attr("id");
                    $NoteCreation.push({
                        NoteType: $('#ddlNoteType').val(),
                        Problem: $($row).find('#tdPProblem').text(),
                        OnSet: '',
                        Description: $($row).find('#tdPDescription').text(),
                        Code: $($row).find('#tdPCode').text(),
                        Surgery: '',
                        SurgeryDate: '',
                        Illness: '',
                        RelationShip: '',
                        Issue: '',
                        DoctorID: DoctorID,
                        PatientID: PID,
                        TransactionID: TID,
                        NoteCreationDate: $($row).find('#tdSHCreatedDate').text(),
                        ProgressNote: '',
                        Careplan: '',
                        SaveType: $('#btnSave').val(),
                        ID: $('#spnEditNoteID').text(),
                        sqno: $(this).attr("id")
                    });
                });
            }
            else if ($('#ddlNoteType').val() == 'PRGNote') {
                $NoteCreation.push({
                    NoteType: $('#ddlNoteType').val(),
                    Problem: $('#txtPlProblem').val(),
                    OnSet: '',
                    Description: $('#txtPdescription').val(),
                    Code: $('#txtPCode').val(),
                    Surgery: '',
                    SurgeryDate: '',
                    Illness: '',
                    RelationShip: '',
                    Issue: '',
                    DoctorID: DoctorID,
                    PatientID: PID,
                    TransactionID: TID,
                    NoteCreationDate: $('#txtdate').val(),
                    ProgressNote: $('#txtprgnote').val(),
                    Careplan: $('#txtprgCareplan').val(),
                    SaveType: $('#btnSave').val(),
                    ID: $('#spnEditNoteID').text()
                });
            }
            callback({ NoteCreation: $NoteCreation });
        }
   
                      
       
        function listSource(el) {
            var TID= '<%=Request.QueryString["TID"]%>';
            serverCall('NoteCreation.aspx/BindPatientNoteCreation', { NoteTypevalue: $('#ddlListSource').val(),TID:TID }, function (response) {
                var responsedata = JSON.parse(response)
                if (responsedata.status){
                    bindPatientNotelistfornotewriter(responsedata.response)               
                }
            });
        }
      
        function bindPatientNotelistfornotewriter(data)
        {
            if ($('#ddlListSource').val() == 'PMH') {
                $('#tblPatientnotecreationlistpmh tbody').empty();
                for (var i = 0; i < data.length > 0; i++) {
                    var row = '<tr>';
                    var j = $('#tblPatientnotecreationlistpmh tbody tr').length + 1;

                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Problem + '</td>';
                    row += '<td id="tdOnSet" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].OnSet + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Code + '</td>';
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
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
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
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Illness + '</td>';
                    row += '<td id="tdOnSet" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RelationShip + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Code + '</td>';
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
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Issue + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Code + '</td>';
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
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdProblem" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Problem + '</td>';
                    row += '<td id="tdOnSet" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].OnSet + '</td>';
                    row += '<td id="tdDescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';
                    row += '<td id="tdCode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Code + '</td>';
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
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdDrugName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DrugName + '</td>';
                    row += '<td id="tdNextDose" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].NextDose + '</td>';
                    row += '<td id="tdDose" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Dose + '</td>';
                    row += '<td id="tdDuration" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Duration + '</td>';
                    row += '<td id="tdMeal" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Meal + '</td>';
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
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type=checkbox></td>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                    row += '<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdAllergies" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Allergies + '</td>';
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
                    row += '<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none">' + JSON.stringify(data) + ')#></td>';
                    row += '<td id="tdDiagnosis" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Diagnosis + '</td>';
                    row += '<td id="tdDiagnosiscode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DiagnosisCode + '</td>';
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
                    table += '<th>Onset</th>';
                    table += '<th>Desciption</th>';
                    table += '<th>Code</th>';
                    table += '</tr>';
                    table += '</thead>';
                    var i = 0;
                    $checkedlist.parent().parent().each(function () {
                        if ($(this).find('input[type=checkbox]:checked')) {
                            table += '<tr>';
                            var j = $('#tblpatientfhbindlist tbody tr').length + 1;
                            table += '<td  style="text-align: center;">'+(++i)+'</td>';
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
                            table += '<td  style="text-align: center;">'+(++i)+'</td>';
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
               else   if ($('#ddlListSource').val() == 'FH') {
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
                            table += '<td  style="text-align: center;">'+(++i)+'</td>';
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
              else  if ($('#ddlListSource').val() == 'SH') {
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
                            table += '<td  style="text-align: center;">'+(++i)+'</td>';
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
              else  if ($('#ddlListSource').val() == 'ProblemList') {
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
                            table += '<td  style="text-align: center;">'+(++i)+'</td>';
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
                else  if ($('#ddlListSource').val() == 'DM') {
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
                            table += '<td  style="text-align: center;">'+(++i)+'</td>';
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
                 else  if ($('#ddlListSource').val() == 'Allergy') {
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
                            table += '<td  style="text-align: center;">'+(++i)+'</td>';
                            table += '<td   style="text-align: center;">' + $(this).find('#tdAllergies').text() + '</td>';
                            table += '</tr>';
                        }

                    });
                    table += '</tbody>';
                    table += '</table>';
                    $('#divPatientNotelistallergy').hideModel();
                }
                 else  if ($('#ddlListSource').val() == 'FD') {
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
                            table += '<td  style="text-align: center;">'+(++i)+'</td>';
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
        function notewriterdetailsadd() {

            if (CKEDITOR.instances['<%=txtDetail.ClientID%>'].getData('') == '') {
                modelAlert("Note writer field should not be  blank");
                return;
            }
            var TID = '<%=Request.QueryString["TID"]%>';
            var PatientID = '<%=Request.QueryString["PID"]%>';
            var DoctorID = '<%=Request.QueryString["DoctorID"]%>';
            var data = {
                Detail: CKEDITOR.instances['<%=txtDetail.ClientID%>'].getData(),
                TID: TID,
                PatientID: PatientID,
                SaveType: $('#btnNotewritersave').val(),
                ID: $('#spnNotewriterentriesid').text(),
                DoctorID: DoctorID,
                createdate: $('#txtdate').val()
            }
            serverCall('NoteCreation.aspx/notewriterdetailsave', data, function (response) {
                var responsedata = JSON.parse(response);
                if (responsedata.status) {
                    modelAlert(responsedata.response, function () {
                        $('#btnNotewritersave').val('Add Details');
                        bindPatientnotewriterlist(TID);
                        CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData('');

                    });
                }
            });
        }
        function bindPatientnotewriterlist(tid)
        {
            serverCall('NoteCreation.aspx/bindpatientnotewriterdetail', { TID: tid }, function (response) {
                var responsedata = JSON.parse(response)
                if (responsedata.status) {
                    bindNotewriterpatientlist(responsedata.response);
                }
            });
        }
        function bindNotewriterpatientlist(data) {
            $('#tblNotewriterenteries tbody').empty();
            for (var i = 0; i < data.length > 0; i++)
            {
                var row = '<tr>';

                var j = $('#tblNotewriterenteries tbody tr').length + 1;

                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdNotewritername" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreateDate + '</td>';
                row += '<td id="tAuthor" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Author + '</td>';
                row += '<td id="tAuthor" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Cadre + '</td>';
                row += '<td id="tAuthor" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Tier + '</td>';
                row += '<td id="tAuthor" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Specialty + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="Editnotewriterentries(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgDelete" src="../../Images/Delete.gif" onclick="rejectnotewriterentries(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdNoteEditID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
           
                row += '</tr>';
                $('#tblNotewriterenteries tbody').append(row);
            }

            $('#divNotewriterenteries').show()
        }

        function Editnotewriterentries(el){
            var row = $(el).closest('tr');
            var id = $(row).find('#tdNoteEditID').text();

            serverCall('NoteCreation.aspx/bindPatientnotewritedata', { ID: id }, function (response) {
                var responsedata = JSON.parse(response);
                if(responsedata.status)
                    CKEDITOR.instances['<%=txtDetail.ClientID%>'].setData(responsedata.response[0]['Detail']);

            });
        
            $('#spnNotewriterentriesid').text(id);
            $('#ddlListSource').val($(row).find('#tdNotetype').text());
            $('#btnNotewritersave').val('Update Details');

        }

        
     
        function chngcur() {
            document.body.style.cursor = 'pointer';
        }
        function chngcurmove() {
            document.body.style.cursor = 'move';
        }
         function rejectnotewriterentries(el) {
             var TID = '<%=Request.QueryString["TID"]%>';
             var row = $(el).closest('tr');
             var id = $(row).find('#tdNoteEditID').text();

             modelConfirmation('Confirmation!!!', 'Are you sure, you want to delete this note.', 'Yes', 'No', function (response) {
                 if (response) {

                     serverCall('NoteCreation.aspx/rejectnotewriterentries', { id: id }, function (response) {
                         var responsedata = JSON.parse(response);
                         if (responsedata.status) {
                             modelAlert(responsedata.response, function () {
                                 bindPatientnotewriterlist(TID);

                             });
                         }
                         else {
                             modelAlert(responsedata.response, function () {

                             });
                         }
                     });

                 }
             });
         }


    </script>

    <form id="form1" runat="server">
          <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>History Sources</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                    <span class="hidden" id="spnEditNoteID" style="display: none;"></span>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Creation Date</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">

                    <asp:TextBox ID="txtdate" runat="server" ToolTip="Click to Select Date" Width="150px"></asp:TextBox>
                    <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtdate" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Source Type</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">

                    <select id="ddlNoteType" title="Note Type" onchange="NoteType();">
                        <option value="Select">Select</option>
                        <option value="PMH">PMH</option>
                        <option value="PSH">PSH</option>
                        <option value="FH">FH</option>
                        <option value="SH">SH</option>
                        <option value="ProblemList" selected="selected" >Problem List</option>
                        <option value="Notewriter"  style="display:none" >Note Writer</option>
                         <option value="PRGNote" style="display:none" >Progress Note</option>
                    </select>

                </div>
            </div>
            <div class="POuter_Box_Inventory" id="divPMH" style="display: none">
                <div class="Purchaseheader">
                    Past Medical History
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Problem</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPMHProblem" title="Problem" class="required"></textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Onset</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPMHOnset" title="Onset"></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Description</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPMHDescription" title="Description"></textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Code</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPMHCode" title="Code"></textarea>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory" id="divPSH" style="display: none">
                <div class="Purchaseheader">
                    Past Surgical History
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Surgery</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPSHSurgery" title="Surgery" class="required"></textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <asp:TextBox ID="txtPSHSurgeryDate" runat="server" ToolTip="Click to Select Date" Width="150px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calucSurgeryDate" runat="server" TargetControlID="txtPSHSurgeryDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Description</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPSHDescription" title="Description"></textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Code</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPSHCode" title="Code"></textarea>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory" id="divFH" style="display: none">
                <div class="Purchaseheader">
                    Family History
                </div>
                <div class="row">

                    <div class="col-md-3">
                        <label class="pull-left">Illness</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtFHillness" title="Illness" class="required"></textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Relationship</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtFHRelationship" title="RelationShip"></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Description</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtFHDescription" title="Description"></textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Code</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtFHCode" title="Code"></textarea>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory" id="divSH" style="display: none">
                <div class="Purchaseheader">
                    Social History
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Issue</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtSHIssue" title="Issue" class="required"></textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Description</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtSHDescription" title="Onset"></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Code</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtSHCode" title="Code"></textarea>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory" id="divProblemList" style="display: none">
                <div class="Purchaseheader">
                    Problem List
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left" >Problem</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPlProblem" title="Problem" class="required"></textarea>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Comments</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPdescription" title="Onset"></textarea>
                    </div>
                </div>
                <div class="row">

                    <div class="col-md-3">
                        <label class="pull-left">Code</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <textarea id="txtPCode" title="Code"></textarea>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory" id="divnotewriter" style="display:none">
                <div class="Purchaseheader">
                    Note Writer
                </div>
                <div class="row">
                    <div class="col-md-3">
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
                        </select>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-24">
                        <CKEditor:CKEditorControl ID="txtDetail" BasePath="~/ckeditor" runat="server" EnterMode="BR" ClientIDMode="Static" ></CKEditor:CKEditorControl>

                    </div>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <input  type="button" id ="btnNotewritersave" onclick="notewriterdetailsadd();" value="Add Details"/>

                    </div>
                </div>
                   <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Note Writer Entries&nbsp;
            </div>
                     <div class="row" id="divNotewriterenteries" style="display:none">
                         <span id="spnNotewriterentriesid" style="display:none"></span>
                                <table class="FixedHeader" id="tblNotewriterenteries" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle">SrNo</th>
                                            <th class="GridViewHeaderStyle">Date</th>
                                            <th class="GridViewHeaderStyle">Author</th>
                                            <th class="GridViewHeaderStyle">Cadre</th>
                                            <th class="GridViewHeaderStyle">Tier</th>
                                            <th class="GridViewHeaderStyle">Specialty</th>
                                            <th class="GridViewHeaderStyle">Edit</th>
                                            <th class="GridViewHeaderStyle">Delete</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>

                            </div>
               </div>
            </div>

            <div class="POuter_Box_Inventory" id="divProgressNote" style="display: none">
                <div class="Purchaseheader">
                    Progress Notes
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Progress Note</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-21">
                        <textarea id="txtprgnote" title="Progress Note"></textarea>
                    </div>
               
                </div>
                   <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Care Plan</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-21">
                        <textarea id="txtprgCareplan" title="Care Plan"></textarea>
                    </div>
               
                </div>
              

            </div>
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <input type="button" id="btnSave" onclick="Save();" value="Save" />

                </div>
            </div>
            <div id="divPatientNote" style="max-height: 300px; overflow-x: auto; display: none" class="POuter_Box_Inventory">
            <div class="row">
                
                    <table class="FixedHeader " id="tblPMH" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse; display: none; ">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Date</th>
                                <th class="GridViewHeaderStyle">Source Type</th>
                                <th class="GridViewHeaderStyle">Author</th>
                                <th class="GridViewHeaderStyle">Problem</th>
                                <th class="GridViewHeaderStyle">Onset</th>
                                <th class="GridViewHeaderStyle">Description</th>
                                <th class="GridViewHeaderStyle">Code</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                                <th class="GridViewHeaderStyle">Reject</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <table class="FixedHeader" id="tblPSH" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse; display: none; ">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Date</th>
                                <th class="GridViewHeaderStyle">Source Type</th>
                                <th class="GridViewHeaderStyle">Author</th>
                                <th class="GridViewHeaderStyle">Surgery</th>
                                <th class="GridViewHeaderStyle">Surgery Date</th>
                                <th class="GridViewHeaderStyle">Description</th>
                                <th class="GridViewHeaderStyle">Code</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                                <th class="GridViewHeaderStyle">Delete</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>  
                    <table class="FixedHeader" id="tblFH" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse; display: none;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Date</th>
                                <th class="GridViewHeaderStyle">Source Type</th>
                                <th class="GridViewHeaderStyle">Author</th>
                                <th class="GridViewHeaderStyle">Illness</th>
                                <th class="GridViewHeaderStyle">Rleationship</th>
                                <th class="GridViewHeaderStyle">Description</th>
                                <th class="GridViewHeaderStyle">Code</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                                <th class="GridViewHeaderStyle">Delete</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <table class="FixedHeader" id="tblSH" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse; display: none;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Date</th>
                                <th class="GridViewHeaderStyle">Source Type</th>
                                <th class="GridViewHeaderStyle">Author</th>
                                <th class="GridViewHeaderStyle">Issue</th>
                                <th class="GridViewHeaderStyle">Description</th>
                                <th class="GridViewHeaderStyle">Code</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                                <th class="GridViewHeaderStyle">Delete</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <table class="FixedHeader" id="tblProblem" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse; display: none;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Date</th>
                                <th class="GridViewHeaderStyle">Source Type</th>
                                <th class="GridViewHeaderStyle">Author</th>
                                <th class="GridViewHeaderStyle">Problem</th>
                                <th class="GridViewHeaderStyle">Description</th>
                                <th class="GridViewHeaderStyle">Code</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                                <th class="GridViewHeaderStyle">Delete</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                     <table class="FixedHeader" id="tblProgressnote" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse; display: none;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Date</th>
                                <th class="GridViewHeaderStyle">Source Type</th>
                                <th class="GridViewHeaderStyle">Author</th>
                                <th class="GridViewHeaderStyle">Prgoress Note</th>
                                <th class="GridViewHeaderStyle">Care Plan</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                                <th class="GridViewHeaderStyle">Delete</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                 <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <input type="button" id="btnSavesqtable" onclick="SaveTable();" value="Save" />

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
                                            <th class="GridViewHeaderStyle">Check</th>
                                            <th class="GridViewHeaderStyle">SrNo</th>
                                            <th class="GridViewHeaderStyle">Problem Note</th>
                                            <th class="GridViewHeaderStyle">Onset</th>
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
                                            <th class="GridViewHeaderStyle">Check</th>
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
                                            <th class="GridViewHeaderStyle">Check</th>
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
                                            <th class="GridViewHeaderStyle">Check</th>
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
                                            <th class="GridViewHeaderStyle">Check</th>
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
                                            <th class="GridViewHeaderStyle">Check</th>
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
                                            <th class="GridViewHeaderStyle">Check</th>
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
                                            <th class="GridViewHeaderStyle">Check</th>
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
        </div>
    </form>
</body>
</html>
