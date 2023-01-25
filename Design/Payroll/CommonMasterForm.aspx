<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CommonMasterForm.aspx.cs" Inherits="Design_Payroll_CommonMasterForm" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <style type="text/css">
        .hidden
        {
            display: none;
        }

        .divCenter
        {
            text-align: center;
        }
        #txtDescription {
            resize:none;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            ShowMasterForm();
        });
        var ShowMasterForm = function () {
            var MasterID = $('#ddlMasterName').val();
            switch (MasterID) {
                case '0': $('.divMaster').addClass('hidden');
                    break;
                case '1':
                    $('.divMaster').addClass('hidden');
                    $('#divUserGroup').removeClass('hidden');
                    ClearUserGroup();
                    bindUserGroup();
                    break;
                case '2':
                    $('.divMaster').addClass('hidden');
                    $('#divUserHead').removeClass('hidden');
                    ClearUserType();
                    bindUserType();
                    break;
                case '3':
                    $('.divMaster').addClass('hidden');
                    $('#divInterviewRound').removeClass('hidden');
                    ClearInterViewRound();
                    bindInterViewRound();
                    break;
                case '4':
                    $('.divMaster').addClass('hidden');
                    $('#divJobType').removeClass('hidden');
                    ClearJobType();
                    bindJobType();
                    break;
                case '5':
                    $('.divMaster').addClass('hidden');
                    $('#divDesignation').removeClass('hidden');
                    BindGrade(function () { });//
                    BindDesignation();//
                    ClearDesignation();//
                    break;
                case '6':
                    $('.divMaster').addClass('hidden');
                    $('#divDepartmentMaster').removeClass('hidden');
                    BindDepartment();//
                    ClearDepartment();//
                    break;
                case '7':
                    $('.divMaster').addClass('hidden');
                    $('#divDesignationIVMapping').removeClass('hidden');
                    BindDesignationForMap(function () { });//
                    BindInterViewRoundForMap(function () { });//
                    BindDesignationIVRoundMap(function () { });//
                    break;
                case '8':
                    $('.divMaster').addClass('hidden');
                    $("#divDocumentMaster").removeClass('hidden');
                    BindDocumentMaster();//
                    CancelDocumentMaster();//
                    break;
                case '9':
                    $('.divMaster').addClass('hidden');
                    $('#divDesignationDocumentMap').removeClass('hidden');
                    BindDesignationDocumentForMap(function () { });//
                    BindDocumentForMap(function () { });//
                    BindDesignationDocMap(0,function () { });
                    break;
                case '10':
                    $('.divMaster').addClass('hidden');
                    $('#divRatingMaster').removeClass('hidden');
                    BindRatingMaster();
                    CancelRatingMaster();
                    break;
            }
        }

        // User Group Master Secton Start
        var SaveUserGroup = function () {
            debugger;
            var data = {
                UserGroupID: $('#spnUserGroupID').text(),
                SaveType: $('#btnSaveUserGroup').val() == 'Save' ? 'Save' : 'Update',
                Name: $.trim($('#txtUserGroupName').val()),
                ProbationDays: $.trim($('#txtProbationDays').val()),
                NoticeDays: $.trim($('#txtNoticeDays').val()),
                IsActive: $('#rdbActive :checked').val(),
            }
            if (String.isNullOrEmpty(data.Name)) {
                modelAlert('Please Enter User Group Name', function () {
                    $('#txtUserGroupName').focus();
                });
                return false;
            }

            serverCall('Services/PayrollServices.asmx/SaveUserGroup', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    ClearUserGroup();
                    bindUserGroup();
                });
            });
        }
        var ClearUserGroup = function () {
            $('#txtUserGroupName').val('');
            $('#txtProbationDays').val('0')
            $('#txtNoticeDays').val('0');
            $('input:radio[id*="rdbActive"]').filter('[value="1"]').attr('checked', true);
            $('#btnSaveUserGroup').val('Save');
            $('#spnUserGroupID').text('');
        }
        var bindUserGroup = function () {
            serverCall('Services/CommonServices.asmx/BindUserGroup', {}, function (response) {
                ResultData = $.parseJSON(response);
                var output = $('#tb_UserGroup').parseTemplate(ResultData);
                $('#divUserGroupOutPut').html(output);
            });
        }
        var EditUserGroupRow = function (rowID) {
            row = $(rowID).closest('tr');
            $('#spnUserGroupID').text(row.find('#tdID').text().trim());
            $('#txtUserGroupName').val(row.find('#tdName').text().trim());
            $('#txtProbationDays').val(row.find('#tdProbtion').text().trim());
            $('#txtNoticeDays').val(row.find('#tdNotice').text().trim());
            IsActive = row.find('#tdIsActive').text().trim() == 'Yes' ? '1' : '0';
            $('input:radio[id*="rdbActive"]').filter('[value="' + IsActive + '"]').attr('checked', true);
            $('#btnSaveUserGroup').val('Update');
            $('#txtUserGroupName').focus();
        }

        // User Group Master Section End

        // User Type Master Section Start
        var SaveUserType = function () {
            debugger;
            var data = {
                UserTypeID: $('#spnUserTypeID').text(),
                SaveType: $('#btnSaveUserType').val() == 'Save' ? 'Save' : 'Update',
                Name: $.trim($('#txtUserTypeName').val()),
                IsActive: $('#rdbUTActive :checked').val(),
            }
            if (String.isNullOrEmpty(data.Name)) {
                modelAlert('Please Enter User Type Name', function () {
                    $('#txtUserTypeName').focus();
                });
                return false;
            }

            serverCall('Services/PayrollServices.asmx/SaveUserType', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        ClearUserType();
                        bindUserType();
                    }
                });
            });
        }
        var ClearUserType = function () {
            $('#txtUserTypeName').val('');
            $('input:radio[id*="rdbUTActive"]').filter('[value="1"]').attr('checked', true);
            $('#btnSaveUserType').val('Save');
            $('#spnUserTypeID').text('');
        }
        var bindUserType = function () {
            serverCall('Services/CommonServices.asmx/BindUserType', {}, function (response) {
                ResultData = $.parseJSON(response);
                var output = $('#tb_UserType').parseTemplate(ResultData);
                $('#divUserTypeOutPut').html(output);
            });
        }
        var EditUserTypeRow = function (rowID) {
            row = $(rowID).closest('tr');
            $('#spnUserTypeID').text(row.find('#tdutID').text().trim());
            $('#txtUserTypeName').val(row.find('#tdutName').text().trim());
            IsActive = row.find('#tdutActive').text().trim() == 'Yes' ? '1' : '0';
            $('input:radio[id*="rdbUTActive"]').filter('[value="' + IsActive + '"]').attr('checked', true);
            $('#btnSaveUserType').val('Update');
            $('#txtUserTypeName').focus();
        }
        //End User Type Master

        // InterView Round Section Start
        var SaveInterViewRound = function () {
            debugger;
            var data = {
                ID: $('#spnInterViewRoundID').text(),
                SaveType: $('#btnSaveIRound').val() == 'Save' ? 'Save' : 'Update',
                Name: $.trim($('#txtIRoundName').val()),
                IsActive: $('#rdbIRoundActive :checked').val(),
                Sequence: $('#txtSequence').val(),
            }
            if (String.isNullOrEmpty(data.Name)) {
                modelAlert('Please Enter InterView Round Name', function () {
                    $('#txtIRoundName').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data.Sequence)) {
                modelAlert('Please Enter Sequence', function () {
                    $('#txtSequence').focus();
                });
            }

            serverCall('Services/PayrollServices.asmx/SaveInterViewRound', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        ClearInterViewRound();
                        bindInterViewRound();
                    }
                });
            });
        }
        var ClearInterViewRound = function () {
            $('#txtIRoundName').val('');
            $('input:radio[id*="rdbIRoundActive"]').filter('[value="1"]').attr('checked', true);
            $('#btnSaveIRound').val('Save');
            $('#spnInterViewRoundID').text('');
            $('#txtSequence').val('');
        }
        var bindInterViewRound = function () {
            serverCall('Services/CommonServices.asmx/BindInterViewRound', {}, function (response) {
                ResultData = $.parseJSON(response);
                var output = $('#tb_InterviewRound').parseTemplate(ResultData);
                $('#divInterviewRoundOutPut').html(output);
            });
        }
        var EditInterViewRoundRow = function (rowID) {
            row = $(rowID).closest('tr');
            $('#spnInterViewRoundID').text(row.find('#tdIRID').text().trim());
            $('#txtIRoundName').val(row.find('#tdIRName').text().trim());
            IsActive = row.find('#tdIRActive').text().trim() == 'Yes' ? '1' : '0';
            $('input:radio[id*="rdbIRoundActive"]').filter('[value="' + IsActive + '"]').attr('checked', true);
            $('#btnSaveIRound').val('Update');
            $('#txtIRoundName').focus();
            $('#txtSequence').val(row.find('#tdSequence').text().trim());
        }
        function allnumericForDocumentMaster(inputtxt) {
            var numbers = /^[0-9]+$/;
            if (inputtxt.value.match(numbers)) {

                return true;
            }
            else {
                $("#txtSequence").val("");
                return false;
            }
        }
        //End InterView Master


        // JOB Type Section Start
        var SaveJobType = function () {
            debugger;
            var data = {
                ID: $('#spnJobTypeID').text(),
                SaveType: $('#btnSaveJobType').val() == 'Save' ? 'Save' : 'Update',
                Name: $.trim($('#txtJobType').val()),
                IsActive: $('#rdbJBActive :checked').val(),
            }
            if (String.isNullOrEmpty(data.Name)) {
                modelAlert('Please Enter Job Type Name', function () {
                    $('#txtJobType').focus();
                });
                return false;
            }

            serverCall('Services/PayrollServices.asmx/SaveJobType', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        ClearJobType();
                        bindJobType();
                    }
                });
            });
        }
        var ClearJobType = function () {
            $('#txtJobType').val('');
            $('input:radio[id*="rdbJBActive"]').filter('[value="1"]').attr('checked', true);
            $('#btnSaveJobType').val('Save');
            $('#spnJobTypeID').text('');
        }
        var bindJobType = function () {
            serverCall('Services/CommonServices.asmx/BindJobType', {}, function (response) {
                ResultData = $.parseJSON(response);
                var output = $('#tb_JobType').parseTemplate(ResultData);
                $('#divJobTypeOutPut').html(output);
            });
        }
        var EditJobType = function (rowID) {
            row = $(rowID).closest('tr');
            $('#spnJobTypeID').text(row.find('#tdJID').text().trim());
            $('#txtJobType').val(row.find('#tdJName').text().trim());
            IsActive = row.find('#tdJActive').text().trim() == 'Yes' ? '1' : '0';
            $('input:radio[id*="rdbJBActive"]').filter('[value="' + IsActive + '"]').attr('checked', true);
            $('#btnSaveJobType').val('Update');
            $('#txtJobType').focus();
        }
        //End Job Type

        /********************Designation Start************************/
        var BindGrade = function (callback) {
            $ddlGrade = $('#ddlGrade');
            serverCall('Services/CommonServices.asmx/BindGrade', {}, function (response) {
                var responseData = JSON.parse(response);
                $ddlGrade.bindDropDown({ data: JSON.parse(response), valueField: 'Grade', textField: 'Grade', isSearchAble: false });
                callback($ddlGrade.val());
            });
        }
        var BindDesignation = function () {
            serverCall('Services/CommonServices.asmx/BindDesignationtableinMaster', {}, function (response) {
                ResDesignation = $.parseJSON(response);
                var output = $('#tb_DesignationList').parseTemplate(ResDesignation);
                $('#divDesignationList').html(output);
            });

        }
        function SaveDesignation() {
            if ($('#txtDesignation').val() == "") {
                modelAlert("Please enter Designation");
                $('#txtDesignation').focus();
            }
            else {
                var designation = $('#txtDesignation').val();
                var grade = $('#ddlGrade option:selected').val();
                var desID = $('#lblDesignationID').text();
                if (desID == "") {
                    desID = 0;
                }
                var btnValue = $('#btnSaveDesignation').val();
                var activity = 0;
                if (btnValue == "Save") {
                    activity = 1;
                }
                else if (btnValue == "Update") {
                    activity = 2;
                }
                serverCall('Services/PayrollServices.asmx/SaveDesignation', { Designation: designation, Grade: grade, Activity: activity, desID: desID }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            ClearDesignation();
                            BindDesignation();
                        }
                    });
                });
            }
        }

        var ClearDesignation = function () {
            $('#txtDesignation').val('');
            $('#btnSaveDesignation').val('Save');
            //$('#ddlGrade').val('LOWER GRADE');
            $('#ddlGrade option:eq(0)').prop('selected', true);
            $('#lblDesignationID').text('');
        }

        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            var card = $('#txtDesignation').val();
                    if (card.charAt(0) == ' ') {
                        $('#txtDesignation').val('');
                        modelAlert('First Character Cannot Be Space');
                        return false;
                    }
             //List of special characters you want to restrict
                    if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "." || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                        return false;
                    }

                    else {
                        return true;
                    }
        }

        function validatespace() {
            var card = $('#txtDesignation').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.') {
                $('#txtDesignation').val('');
                modelAlert('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                
                return true;
            }

        }

        var EditDesignationRow = function (rowID) {
            row = $(rowID).closest('tr');
            $('#txtDesignation').val(row.find('#tdDesignationName').text().trim());
            $('#ddlGrade').val(row.find('#tdGrade').text().trim());
            $('#btnSaveDesignation').val("Update");
            $('#lblDesignationID').text(row.find('#tdDesID').text().trim());
        }
        
        /**********************Designation End**********************************/

        /**************************Department Start************************************/
        
        var BindDepartment = function () {
            serverCall('Services/CommonServices.asmx/BindDepartmenttableinMaster', {}, function (response) {
                ResDepartment = $.parseJSON(response);
                var output = $('#tbl_DepartmentList').parseTemplate(ResDepartment);
                $('#divDepartmentList').html(output);
            });
        }
        function SaveDepartment() {
            if ($('#txtDept').val() == "") {
                modelAlert("Please enter Depratment Name");
                $('#txtDept').focus();
            }
            else {
                var deptName = $('#txtDept').val();
                var empReq = $('#txtempreq').val();
                var btnValue = $('#btnSaveDepartment').val();
                var activity = 0;
                if (btnValue == "Save") {
                    activity = 1;
                }
                else if (btnValue == "Update") {
                    activity = 2;
                }
                var isActive = $("input[name='rbActive']:checked").val();
                var deptID = $("#spnDepartmentID").text();
                if (deptID == "") {
                    deptID = 0;
                }
                var deptHeadID = 0;
                    //deptHeadID = $("#ddlDepartmentHead option:selected").val();
                    //if (deptHeadID == "" || deptHeadID == 'undefined') {
                    //    deptHeadID = 0;
                    //}

                serverCall('Services/PayrollServices.asmx/SaveDepartment', { DepartmentName: deptName, EmpRequired: empReq, IsActive: isActive, Activity: activity, DeptID: deptID, DeptHeadID: deptHeadID }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            ClearDepartment();
                            BindDepartment();
                        }
                    });
                });

            }
        }

        var ClearDepartment = function () {
            $('#txtDept').val('');
            $('#txtempreq').val(0);
            $("input[name=rbActive][value=1]").prop("checked", true);
            $('#btnSaveDepartment').val('Save');
            $('#spnDepartmentID').text('');
            $("#divDepartmentHead").css("display", "none");
            $('#ddlDepartmentHead').val('');
        }
        var EditDepartmentRow = function (rowID) {
            row = $(rowID).closest('tr');
            $('#txtDept').val(row.find('#tdDepratmentName').text().trim());
            $('#txtempreq').val(row.find('#tdEmpRequired').text().trim());
            var active = row.find('#tdActive').text().trim();
            if (active == "Yes") {
                $("input[name=rbActive][value=1]").prop("checked", true);
            }
            else { $("input[name=rbActive][value=0]").prop("checked", true); }
            $('#btnSaveDepartment').val("Update");
            $('#spnDepartmentID').text(row.find('#tdDepID').text().trim());
            BindDepartmentHead(function () {
                GetDepratmentHeadID(row.find('#tdDepID').text().trim());
            });
            $("#divDepartmentHead").css("display", "");
        }
        var BindDepartmentHead = function (callback) {
            $ddlDepartmentHead = $('#ddlDepartmentHead');
            
            serverCall('Services/CommonServices.asmx/BindDepartmentHead', { DeptID: row.find('#tdDepID').text().trim() }, function (response) {
                var responseData = JSON.parse(response);
               
                if (responseData.length > 0) {
                    $ddlDepartmentHead.bindDropDown({  data: JSON.parse(response), valueField: 'EmployeeID', textField: 'NAME', isSearchAble: true });
                    callback($ddlDepartmentHead.val());
                    
                }
                else {
                    $("#divDepartmentHead").css("display", "none");
                    modelAlert("Department Head not found in this depratment");
                }
            });
           
        }
        function GetDepratmentHeadID(deptID) {
            serverCall('Services/CommonServices.asmx/GetDepratmentHeadID', { DeptID: deptID }, function (response) {
                var responseData = JSON.parse(response);
                    $('#ddlDepartmentHead').val(responseData.response).chosen('destroy').chosen();
            });
        }
        function allnumeric(inputtxt) {
            var numbers = /^[0-9]+$/;
            if (inputtxt.value.match(numbers)) {
          
                return true;
            }
            else {
                $("#txtempreq").val("");
                return false;
            }
        }
        /*****************************Department END*********************************************/

        /***************************Designation IV Round Map starts**********************************************/
        var BindDesignationIVRoundMap = function () {
            var desiID = $('#ddlDesignation option:selected').val();
            if (typeof(desiID) == 'undefined') {
                desiID = 0;
            }
            serverCall('Services/CommonServices.asmx/BindDesignationIVRoundMap', { DesiID: desiID }, function (response) {
                ResDesignationIVMap = $.parseJSON(response);
                if (ResDesignationIVMap.length > 0) {
                    var output = $('#tbl_Designation_IVRound_Map').parseTemplate(ResDesignationIVMap);
                    $('#divDesignationIVMap').html(output);
                }
                else {
                    modelAlert("Record not found...");
                    $('#divDesignationIVMap').html('');
                }
            });
        }

        var BindDesignationForMap = function (callback) {
            $ddlDesignation = $('#ddlDesignation');
            serverCall('Services/CommonServices.asmx/BindDesignation', {}, function (response) {
                var responseData = JSON.parse(response);
                $ddlDesignation.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Des_ID', textField: 'Designation_Name', isSearchAble: true });
                callback($ddlDesignation.val());
            });
        }

        var BindInterViewRoundForMap = function (callback) {
            $ddlInterviewRound = $('#ddlInterviewRound');
            serverCall('Services/CommonServices.asmx/BindInterViewRound', {}, function (response) {
                var responseData = JSON.parse(response);
                $ddlInterviewRound.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true });
                callback($ddlInterviewRound.val());
            });
        }

        function SaveDesignationWithIVRound() {
            var desiID = $('#ddlDesignation option:selected').val();
            var IVID = $('#ddlInterviewRound option:selected').val();
            var isActive = 1;   //$("input[name='rbDesignationMap']:checked").val();
            var btnvalu = $('#btnMap').val();
            var activity = 0;
            if (btnvalu == "Map") {
                activity = 1;
            }
            else if (btnvalu == "Update") {
                activity = 2;
            }
            var mapid = $("#SpnMapID").text();
            if (mapid == "") {
                mapid = 0;
            }

            if (IVID == 0) {
                modelAlert("Please select Interview Round");
                return false;
            }
            else {
                serverCall('Services/PayrollServices.asmx/SaveDesignationWithIVRound', { DesiID: desiID, IvRoundID: IVID, IsActive: isActive, Activity: activity, mapID: mapid }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            CancelMapping();
                            BindDesignationIVRoundMap();
                        }
                    });
                });
            }
        }

        function CancelMapping() {
           // $("input[name=rbDesignationMap][value=1]").prop("checked", true);
            $("#ddlInterviewRound").val(0);
            $("#btnMap").val("Map");
        }

        var EditDesignationMap = function (rowID) {
            row = $(rowID).closest('tr');
            var mapid = row.find('#tdMapID').text().trim();
            var IVId = row.find('#tdIVRoundID').text().trim();
            $("#ddlInterviewRound").val(IVId);
            $("#SpnMapID").text(mapid);
            $("#btnMap").val("Update");
            var act = row.find('#tdIsActiveOfMap').text().trim();
            if (act == "Yes") {
                $("input[name=rbDesignationMap][value=1]").prop("checked", true);
            }
            else { $("input[name=rbDesignationMap][value=0]").prop("checked", true); }
        }

        var DeleteDesignationMap = function (rowID) {
            row = $(rowID).closest('tr');
            var mapid = row.find('#tdMapID').text().trim();

            serverCall('Services/PayrollServices.asmx/DeleteDesignationMap', { mapID: mapid }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        CancelMapping();
                        BindDesignationIVRoundMap();
                    }
                });
            });
        }


        
        /***********************************END***********************************************/

        /***********************************Document Master***********************************************/

        var EditDocumentMaster = function (rowID) {
            row = $(rowID).closest('tr');
            var docname = row.find('#tdDocName').text().trim();
            $("#txtDocumentName").val(docname);
           
            var active = row.find('#tdDocActive').text().trim();
            if (active == "Yes") {
                $("input[name=rbDocument][value=1]").prop("checked", true);
            }
            else { $("input[name=rbDocument][value=0]").prop("checked", true); }
            var desc = row.find('#tdDescription').text().trim();
            $("#txtDescription").val(desc);
            $("#btnDocumentSave").val("Update");
            $("#SpnDocumentID").text(row.find('#tdDocID').text().trim());
        }

        var BindDocumentMaster = function () {
            serverCall('Services/CommonServices.asmx/BindDocumentMaster', {}, function (response) {
                ResDocument = $.parseJSON(response);
                var output = $('#tbl_DocumentMaster').parseTemplate(ResDocument);
                $('#divDocumentList').html(output);
            });
        }

        function GetLastSeqNum() {
            serverCall('Services/CommonServices.asmx/GetLastSeqNum', {}, function (response) {
                var responseData = JSON.parse(response);
                $("#txtSeq").val(responseData.response);
            });
        }

        function SaveDocumentMaster() {
            var docName = $("#txtDocumentName").val();
            var desc = $("#txtDescription").val();
            var seq = 0;
            var isActive = $("input[name='rbDocument']:checked").val();
            var btnvalu = $('#btnDocumentSave').val();
            var activity = 0;
            if (btnvalu == "Save") {
                activity = 1;
            }
            else if (btnvalu == "Update") {
                activity = 2;
            }
            var docid = $("#SpnDocumentID").text();
            if (docid == "") {
                docid = 0;
            }

            if (docName == "") {
                modelAlert("Please enter Document Name");
                return false;
            }
            else if (desc == "") {
                modelAlert("Please enter Description");
                return false;
            }
            else {
                serverCall('Services/PayrollServices.asmx/SaveDocumentMaster', { DocName: docName, Desc: desc, Seq: seq, IsActive: isActive, Activity: activity, DocID: docid }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            CancelDocumentMaster();
                            BindDocumentMaster();
                        }
                    });
                });
            }
        }

        function CancelDocumentMaster() {
            $("#txtDocumentName").val('');
            $("#txtDescription").val('');
            $("input[name=rbDocument][value=1]").prop("checked", true);
            $("#btnDocumentSave").val("Save");
        }

        
        
        /***********************************END***********************************************/

        /*****************Designation - Document Mapping*******************************/
        var BindDesignationDocumentForMap = function (callback) {
            $ddlDesigDocMap = $('#ddlDesigDocMap');
            serverCall('Services/CommonServices.asmx/BindDesignation', {}, function (response) {
                var responseData = JSON.parse(response);
                $ddlDesigDocMap.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Des_ID', textField: 'Designation_Name', isSearchAble: true });
                callback($ddlDesigDocMap.val());
            });
        }
        var BindDocumentForMap = function (callback) {
            $ddlDocumentMap = $('#ddlDocumentMap');
            serverCall('Services/CommonServices.asmx/BindDocumentForMap', {}, function (response) {
                var responseData = JSON.parse(response);
                $ddlDocumentMap.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DocID', textField: 'Doc_Name', isSearchAble: true });
                callback($ddlDocumentMap.val());
            });
        }

        function SaveDesigDocMap() {
            var desid = $("#ddlDesigDocMap option:selected").val();
            var docid = $("#ddlDocumentMap option:selected").val();
            if (docid == 0) {
                modelAlert("Please select Document");
                return false;
            }
            else {
                serverCall('Services/PayrollServices.asmx/SaveDesigDocMap', { DesigID: desid, DocID: docid }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            CancelDesigDocMapping();
                            BindDesignationDocMap(0,function () { });
                        }
                    });
                });
            }
        }

        var BindDesignationDocMap = function (desiID) {
           // var desiID = $("#ddlDesigDocMap option:selected").val();
            if (typeof (desiID) == 'undefined') {
                desiID = 0;
            }
            serverCall('Services/CommonServices.asmx/BindDesignationDocumentMap', { DesiID: desiID }, function (response) {
                ResDesigDocumentMap = $.parseJSON(response);
                var output = $('#tbl_DocumentMap').parseTemplate(ResDesigDocumentMap);
                $('#divDocumentMapList').html(output);
            });
        }

        var DeleteDocumentMap = function (rowID) {
            row = $(rowID).closest('tr');
            var mapid = row.find('#tdDocMapID').text().trim();

            serverCall('Services/PayrollServices.asmx/DeleteDocumentMap', { mapID: mapid }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        CancelDesigDocMapping();
                        BindDesignationDocMap(0,function () { });
                    }
                });
            });
        }

        function CancelDesigDocMapping() {
            $("#ddlDesigDocMap").val(0);
           $("#ddlDocumentMap").val(0);
        }
        /*****************************END**************************************/
        /***********************************Rating Master***********************************************/
        var EditRatingMaster = function (rowID) {
            row = $(rowID).closest('tr');
            var RatingName = row.find('#tdRatingName').text().trim();
            $("#txtRatingDetails").val(RatingName);
            var active = row.find('#tdRatingActive').text().trim();
            if (active == "Yes") {
                $("input[name=rbRating][value=1]").prop("checked", true);
            }
            else { $("input[name=rbRating][value=0]").prop("checked", true); }
            $("#btnSaveRating").val("Update");
            $("#spnRatingID").text(row.find('#tdRatingID').text().trim());
        }
        var BindRatingMaster = function () {
            serverCall('Services/CommonServices.asmx/BindRatingMaster', {}, function (response) {
                ResRating = $.parseJSON(response);
                var output = $('#tbl_RatingMaster').parseTemplate(ResRating);
                $('#divRatingList').html(output);
            });
        }
        function SaveRatingMaster() {
            var RatingName = $("#txtRatingDetails").val();
            var isActive = $("input[name='rbRating']:checked").val();
            var btnvalu = $('#btnSaveRating').val();
            var activity = 0;
            if (btnvalu == "Save") {
                activity = 1;
            }
            else if (btnvalu == "Update") {
                activity = 2;
            }
            var Ratingid = $("#spnRatingID").text();
            if (Ratingid == "") {
                Ratingid = 0;
            }
            if (RatingName == "") {
                modelAlert("Please enter Rating Details");
                return false;
            }           
            else {
                serverCall('Services/PayrollServices.asmx/SaveRatingMaster', { RatingName: RatingName, IsActive: isActive, Activity: activity, Ratingid: Ratingid }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            CancelRatingMaster();
                            BindRatingMaster();
                        }
                    });
                });
            }
        }
        function CancelRatingMaster() {
            $("#txtRatingDetails").val('');
            $("input[name=rbRating][value=1]").prop("checked", true);
            $("#btnSaveRating").val("Save");
        }
        /***********************************END***********************************************/
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory divCenter">
            <b>Common Master Form </b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-8"></div>
                <div class="col-md-3">
                    <label class="pull-left">Master Name</label>
                    <b class="pul-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlMasterName" title="Select Master Name here to show Master Entry Form " onchange="ShowMasterForm();">
                        <option value="0" selected="selected">Select</option>
                        <option value="1">Employee Group Master</option>
                        <option value="2" >Employee Type Master</option>
                      <%--  <option value="3">InterView Round Master</option>--%>
                        <option value="4">Job Type Master</option>
                        <option value="5">Designation Master</option>
                        <option value="6">Department Master</option>
                      <%--  <option value="7">Designation-Interview Round Mapping</option>--%>
                        <option value="8">Document Master</option>
                        <option value="9">Designation-Document Mapping</option>
                       <%-- <option value="10">Employee Rating Master</option>--%>
                    </select>
                </div>
                <div class="col-md-8"></div>
            </div>
        </div>
        <div id="divUserGroup" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    User Group Master
                    <span id="spnUserGroupID" class="hidden"></span>
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">User Group Name</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtUserGroupName" class="requiredField" maxlength="50" title="Please Enter UserGroup Name here" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Probation (Days)</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtProbationDays" value="0" onlynumber="true" class="requiredField" maxlength="3" title="Please Enter Probation Period in days" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Notice (Days)</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtNoticeDays" value="0" onlynumber="true" class="requiredField" maxlength="3" title="Please Enter Notice Period in days" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Active</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdbActive" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" ClientIDMode="Static" ToolTip="Select Active Or De-Active To Update Package">
                                    <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" id="btnSaveUserGroup" value="Save" onclick="SaveUserGroup()" />
                            <input type="button" id="btnClearUserGroup()" value="Clear" onclick="ClearUserGroup()" />
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    User Group Details
                </div>
                <div id="divUserGroupOutPut" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>
        </div>
        <div id="divUserHead" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    User Type Master
                    <span id="spnUserTypeID" class="hidden"></span>
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">User Type Name</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtUserTypeName" class="requiredField" maxlength="50" title="Please Enter User Type Name here" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Active</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdbUTActive" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" ClientIDMode="Static" ToolTip="Select Active Or De-Active To Update Package">
                                    <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" id="btnSaveUserType" value="Save" onclick="SaveUserType()" />
                            <input type="button" id="btnClearUserType" value="Clear" onclick="ClearUserType()" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    User Type Master Details
                </div>
                <div id="divUserTypeOutPut" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>

        </div>
        <div id="divInterviewRound" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    InterView Round Master
                    <span id="spnInterViewRoundID" class="hidden"></span>
                </div>
                 <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Round Name</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtIRoundName" class="requiredField" maxlength="50" title="Please Enter InterView Round Name here" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Sequence</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtSequence" maxlength="2" class="requiredField" title="Enter sequence" onkeyup="return allnumericForDocumentMaster(this);" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Active</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rdbIRoundActive" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" ClientIDMode="Static" ToolTip="Select Active Or De-Active To Update Package">
                                    <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" id="btnSaveIRound" value="Save" onclick="SaveInterViewRound()" />
                            <input type="button" id="btnClearIRound" value="Clear" onclick="ClearInterViewRound()" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    InterView Round Master Details
                </div>
                <div id="divInterviewRoundOutPut" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>
        </div>
        <div id="divJobType" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Job Type Master
                    <span id="spnJobTypeID" class="hidden"></span>
                </div>
                 <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Job Type</label>
                                    <b class="pul-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" id="txtJobType" class="requiredField" maxlength="50" title="Please Enter Job Type Name here" />
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Active</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:RadioButtonList ID="rdbJBActive" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" ClientIDMode="Static" ToolTip="Select Active Or De-Active To Update Package">
                                        <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                        <asp:ListItem Value="0">No</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                            </div>
                            <div class="row divCenter">
                                <input type="button" id="btnSaveJobType" value="Save" onclick="SaveJobType()" />
                                <input type="button" id="btnClearJobType" value="Clear" onclick="ClearJobType()" />
                            </div>
                        </div>
                    </div>
            </div>
             <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Job Type Master Details
                    </div>
                    <div id="divJobTypeOutPut" style="max-height: 250px; overflow-x: auto;">
                    </div>
                </div>
        </div>
        <div id="divDesignation" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Designation Master
                    
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Designation</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDesignation" runat="server" ClientIDMode="Static" CssClass="requiredField" MaxLength="50" ToolTip="Enter Designation"
                                    TabIndex="1" AutoCompleteType="Disabled" onkeypress="return check(event)" onkeyup="validatespace();"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Grade
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select title="Select Grade" id="ddlGrade" class="requiredField"></select>
                            </div>
                            <div class="col-md-6">
                                
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" value="Save" class="ItDoseButton" title="Click to Save" id="btnSaveDesignation" onclick="SaveDesignation()"/>
                            <input type="button" id="btnClearDesignation" value="Clear" onclick="ClearDesignation()" />
                            <span id="lblDesignationID" style="display:none;"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Designation Master Details
                </div>
                <div id="divDesignationList" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>
        </div>
        <div id="divDepartmentMaster" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Department Master
                    <span id="spnDepartmentID" class="hidden"></span>
                    <span id="spnDepartmentHeadID" class="hidden"></span>
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Department</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDept" runat="server" AutoCompleteType="Disabled" CssClass="requiredField"
                                MaxLength="50" TabIndex="1" ToolTip="Enter Department" onkeypress="return check(event)"
                                onkeyup="validatespace();" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee Required
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtempreq" Text="0" runat="server" CssClass="requiredField" MaxLength="4" TabIndex="2"
                                    ToolTip="Enter Employee Required" AutoCompleteType="Disabled" ClientIDMode="Static" onkeyup="return allnumeric(this)"></asp:TextBox>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">
                                     Active
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <input type="radio" name="rbActive" value="1" checked="checked" />Yes
                                <input type="radio" name="rbActive" value="0" />No
                            </div>
                        </div>
                        <div class="row" id="divDepartmentHead" style="display:none;">
                            <div class="col-md-3">
                                <label class="pull-left">
                                     Department Head
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDepartmentHead"></select>
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" value="Save" id="btnSaveDepartment" onclick="SaveDepartment()" />
                            <input type="button" value="Clear" id="btnClearDepartment" onclick="ClearDepartment()" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Department Master Details
                </div>
                <div id="divDepartmentList" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>
        </div>
        <div id="divDesignationIVMapping" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Designation - Interview Round Map
                    <span id="SpnMapID" class="hidden"></span>
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Designation</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDesignation" class="requiredField" title="Select Designation" onchange="BindDesignationIVRoundMap()"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Interview Round</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlInterviewRound" class="requiredField" title="Select Interview Round"></select>
                            </div>
                            <div class="col-md-3" style="display:none;">
                                <label class="pull-left">Active</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5" style="display:none;">
                                <input type="radio" name="rbDesignationMap" value="1" checked="checked" />Yes
                                <input type="radio" name="rbDesignationMap" value="0" />No
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" id="btnMap" value="Map" class="ItDoseButton" title="Click to Map" onclick="SaveDesignationWithIVRound();" />
                            <input type="button" value="Cancel" class="ItDoseButton" title="Click to Cancel" onclick="CancelMapping();"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Designation - Interview Round Mapping Details
                </div>
                <div id="divDesignationIVMap" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>
        </div>
        <div id="divDocumentMaster" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Document Master
                    <span id="SpnDocumentID" class="hidden"></span>
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Document Name</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtDocumentName" class="requiredField" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Description</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <textarea id="txtDescription" cols="5" rows="20" style="height:70px;max-width:340px;" class="requiredField"></textarea>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">Active</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <input type="radio" name="rbDocument" value="1" checked="checked" />Yes
                                <input type="radio" name="rbDocument" value="0" />No
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" value="Save" class="ItDoseButton" title="Click to Save" id="btnDocumentSave" onclick="SaveDocumentMaster();" />
                            <input type="button" value="Cancel" class="ItDoseButton" title="Click to Cancel" onclick="CancelDocumentMaster();" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Document Master Details
                </div>
                <div id="divDocumentList" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>
        </div>
        <div id="divDesignationDocumentMap" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Designation - Document Details
                    <span id="spnDocumentMapID" class="hidden"></span>
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Designation</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDesigDocMap" class="requiredField" title="Select Designation"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Document</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDocumentMap" class="requiredField" title="Select Document"></select>
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" id="btnDocMap" value="Map" class="ItDoseButton" title="Click to Map" onclick="SaveDesigDocMap();" />
                            <input type="button" id="btnDocCancel" value="Cancel" class="ItDoseButton" title="Click to Cancel" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Designation - Document Mapping Details
                </div>
                <div id="divDocumentMapList" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>
        </div>
         <div id="divRatingMaster" class="divMaster hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Rating Master
                    <span id="spnRatingID" class="hidden"></span>
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Rating Detail</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <textarea id="txtRatingDetails" cols="5" rows="20" style="height:70px;max-width:340px;" class="requiredField"></textarea>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">Active</label>
                                <b class="pul-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <input type="radio" name="rbRating" value="1" checked="checked" />Yes
                                <input type="radio" name="rbRating" value="0" />No
                            </div>
                        </div>
                        <div class="row divCenter">
                            <input type="button" value="Save" class="ItDoseButton" title="Click to Save" id="btnSaveRating" onclick="SaveRatingMaster();" />
                            <input type="button" value="Cancel" class="ItDoseButton" title="Click to Cancel" onclick="CancelRatingMaster();" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Rating Master Details
                </div>
                <div id="divRatingList" style="max-height: 250px; overflow-x: auto;">
                </div>
            </div>
        </div>
        </div>

    <script type="text/html" id="tb_UserGroup">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_UserGroupData" style="width:100%; border-collapse:collapse">
            <thead>
                <tr id="trHeader">
			        <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">User Group Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Probation Period(Days)</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Notice Period(Days)</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Edit</th>
		        </tr>
            </thead>
            <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
        #>
                <tr >                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;">
                        <#=j+1#>
                    </td>
                    <td class="GridViewLabItemStyle" id="tdID" style="width:200px; display:none" ><#=objRow.User_Type_ID#></td>
                    <td class="GridViewLabItemStyle" id="tdName" style="width:200px;" ><#=objRow.Name#></td> 
                    <td class="GridViewLabItemStyle" id="tdProbtion" style="width:100px;  text-align:center;" ><#=objRow.ProbationDays#></td> 
                    <td class="GridViewLabItemStyle" id="tdNotice" style="width:100px;  text-align:center;" ><#=objRow.NoticeDays#></td> 
                    <td class="GridViewLabItemStyle" id="tdIsActive" style="width:100px;  text-align:center;" ><#=objRow.IsActive#></td> 
                    <td class="GridViewLabItemStyle" id="td1" style="width:100px;  text-align:center;" >
                        <img id="imgEdit" src="../../Images/edit.png" onclick="EditUserGroupRow(this);" title="Click To Edit" style="cursor: pointer" />
                    </td> 
                </tr>           
        <#}#>      
        </table>
    </script>
    
    <script type="text/html" id="tb_UserType">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_UserTypeData" style="width:100%; border-collapse:collapse">
            <thead>
                <tr id="tr1">
			        <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">User Type Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Edit</th>
		        </tr>
            </thead>
            <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
        #>
                <tr >                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;">
                        <#=j+1#>
                    </td>
                    <td class="GridViewLabItemStyle" id="tdutID" style="width:200px; display:none" ><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="tdutName" style="width:200px;" ><#=objRow.Name#></td> 
                    <td class="GridViewLabItemStyle" id="tdutActive" style="width:100px;  text-align:center;" ><#=objRow.IsActive#></td> 
                    <td class="GridViewLabItemStyle" id="td7" style="width:100px;  text-align:center;" >
                        <img id="img1" src="../../Images/edit.png" onclick="EditUserTypeRow(this);" title="Click To Edit" style="cursor: pointer" />
                    </td> 
                </tr>           
        <#}#>      
        </table>
    </script>

    <script type="text/html" id="tb_InterviewRound">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_InterviewRoundData" style="width:100%; border-collapse:collapse">
            <thead>
                <tr id="tr2">
			        <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Round Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Sequence</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Edit</th>
		        </tr>
            </thead>
            <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
        #>
                <tr >                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;">
                        <#=j+1#>
                    </td>
                    <td class="GridViewLabItemStyle" id="tdIRID" style="width:200px; display:none" ><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="tdIRName" style="width:200px;" ><#=objRow.Name#></td> 
                    <td class="GridViewLabItemStyle" id="tdSequence" style="width:50px;" ><#=objRow.Sequence#></td> 
                    <td class="GridViewLabItemStyle" id="tdIRActive" style="width:100px;  text-align:center;" ><#=objRow.IsActive#></td> 
                    <td class="GridViewLabItemStyle" id="td5" style="width:100px;  text-align:center;" >
                        <img id="img2" src="../../Images/edit.png" onclick="EditInterViewRoundRow(this);" title="Click To Edit" style="cursor: pointer" />
                    </td> 
                </tr>           
        <#}#>      
        </table>
    </script>

     <script type="text/html" id="tb_JobType">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_JobTypeData" style="width:100%; border-collapse:collapse">
            <thead>
                <tr id="tr3">
			        <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Job Type Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Edit</th>
		        </tr>
            </thead>
            <#       
        var dataLength=ResultData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResultData[j];
        #>
                <tr >                            
                    <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;">
                        <#=j+1#>
                    </td>
                    <td class="GridViewLabItemStyle" id="tdJID" style="width:200px; display:none" ><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="tdJName" style="width:200px;" ><#=objRow.Name#></td> 
                    <td class="GridViewLabItemStyle" id="tdJActive" style="width:100px;  text-align:center;" ><#=objRow.IsActive#></td> 
                    <td class="GridViewLabItemStyle" id="td6" style="width:100px;  text-align:center;" >
                        <img id="img3" src="../../Images/edit.png" onclick="EditJobType(this);" title="Click To Edit" style="cursor: pointer" />
                    </td> 
                </tr>           
        <#}#>      
        </table>
    </script>

    <script type="text/html" id="tb_DesignationList">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_DesignationData" style="width:100%; border-collapse:collapse">
            <thead>
                <tr id="tr4">
                    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Designation</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Grade</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Edit</th>
                </tr>
            </thead>
            <tbody>
                    <#       
        var dataLength=ResDesignation.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ResDesignation[j];
        #>
            <tr>
                <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdDesID" style="width:200px; display:none" ><#=objRow.Des_ID#></td>
                <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" id="tdDesignationName"><#=objRow.Designation_Name#></td>
                <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" id="tdGrade"><#=objRow.Grade#></td>
                <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;">
                    <img id="img4" src="../../Images/edit.png" onclick="EditDesignationRow(this);" title="Click To Edit" style="cursor: pointer" />
                </td>
            </tr>
        <#}#>
            </tbody>
        </table>
    </script>

    <script type="text/html" id="tbl_DepartmentList">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_DepartmentData" style="width:100%; border-collapse:collapse">
            <thead>
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Department</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Emp. Required</th>
                    <%--<th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Department Head</th>--%>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Active</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Edit</th>
                </tr>
            </thead>
            <tbody>
                <#       
                    var dataLength=ResDepartment.length;
                    window.status="Total Records Found :"+ dataLength;
                    var objRow;   
                    var status;     
                    for(var j=0;j<dataLength;j++)
                    {       
                    objRow = ResDepartment[j];
                #>
                        <tr>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                            <td class="GridViewLabItemStyle" id="tdDepID" style="width:200px; display:none"><#=objRow.Dept_ID#></td>
                             <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" id="tdDepratmentName"><#=objRow.Dept_Name#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" id="tdEmpRequired"><#=objRow.EmployeeRequired#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" id="tdActive"><#=objRow.IsActive#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;">
                                <img id="img5" src="../../Images/edit.png" alt="" onclick="EditDepartmentRow(this);" title="Click To Edit" style="cursor: pointer" />
                            </td>
                        </tr>
                <#}#>
            </tbody>
        </table>
    </script>

    <script type="text/html" id="tbl_Designation_IVRound_Map">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_Designation_IVRound_Map" style="width:100%; border-collapse:collapse">
            <thead>
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Designation Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Interview Round</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Active</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Delete</th>
                </tr>
            </thead>
            <tbody>
                <#       
                    var dataLength=ResDesignationIVMap.length;
                    window.status="Total Records Found :"+ dataLength;
                    var objRow;   
                    var status;     
                    for(var j=0;j<dataLength;j++)
                    {       
                    objRow = ResDesignationIVMap[j];
                #>
                        <tr>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center; display:none;" id="tdMapID"><#=objRow.MapID#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center; display:none;" id="tdIVRoundID"><#=objRow.ID#></td>
                            
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" id="tdDesigName"><#=objRow.Designation_Name#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" id="tdIVRoundName"><#=objRow.Name#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;" id="tdIsActiveOfMap"><#=objRow.IsActive#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;">
                                <img id="img6" src="../../Images/delete.gif" alt="" title="Click To Edit" style="cursor: pointer" onclick="DeleteDesignationMap(this);" />
                            </td>
                        </tr>
                <#}#>
            </tbody>
        </table>
    </script>

    <script id="tbl_DocumentMaster" type="text/html">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_DocumentMaster" style="width:100%; border-collapse:collapse">
            <thead>
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 120px;">Document Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 180px;">Description</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Active</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Edit</th>
                </tr>
            </thead>
            <tbody>
                <#       
                    var dataLength=ResDocument.length;
                    window.status="Total Records Found :"+ dataLength;
                    var objRow;   
                    var status;     
                    for(var j=0;j<dataLength;j++)
                    {       
                    objRow = ResDocument[j];
                #>
                        <tr>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;display:none;" id="tdDocID"><#=objRow.DocID#></td>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;" id="tdDocName"><#=objRow.Doc_Name#></td>
                             <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;" id="tdDescription"><#=objRow.Description#></td>
                             <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;" id="tdDocActive"><#=objRow.IsActive#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;">
                                <img id="img8" src="../../Images/edit.png" alt="" onclick="EditDocumentMaster(this);" title="Click To Edit" style="cursor: pointer" />
                            </td>
                        </tr>
                <#}#>
            </tbody>
        </table>
    </script>

    <script id="tbl_DocumentMap" type="text/html">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_DocumentMap" style="width:100%; border-collapse:collapse">
            <thead>
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 120px;">Designation Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 180px;">Document Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Delete</th>
                </tr>
            </thead>
            <tbody>
                <#       
                    var dataLength=ResDesigDocumentMap.length;
                    window.status="Total Records Found :"+ dataLength;
                    var objRow;   
                    var status;     
                    for(var j=0;j<dataLength;j++)
                    {       
                    objRow = ResDesigDocumentMap[j];
                #>
                        <tr>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;display:none;" id="tdDocMapID"><#=objRow.MapDocID#></td>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;" id="tdDesignationNameDocForMap"><#=objRow.Designation_Name#></td>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;" id="tdDocNameForMap"><#=objRow.Doc_Name#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;">
                                <img id="img7" src="../../Images/delete.gif" alt="" title="Click To Edit" style="cursor: pointer" onclick="DeleteDocumentMap(this);" />
                            </td>
                        </tr>
                <#}#>
            </tbody>
        </table>
    </script>
       <script id="tbl_RatingMaster" type="text/html">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tbl_RatingData" style="width:100%; border-collapse:collapse">
            <thead>
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 180px;">Rating Details</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Active</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Edit</th>
                </tr>
            </thead>
            <tbody>
                <#       
                    var dataLength=ResRating.length;
                    window.status="Total Records Found :"+ dataLength;
                    var objRow;   
                    var status;     
                    for(var j=0;j<dataLength;j++)
                    {       
                    objRow = ResRating[j];
                #>
                        <tr>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;"><#=j+1#></td>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;display:none;" id="tdRatingID"><#=objRow.ID#></td>
                            <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;" id="tdRatingName"><#=objRow.RatingDetails#></td>
                             <td class="GridViewLabItemStyle" style="width:30px;  text-align:center;" id="tdRatingActive"><#=objRow.IsActive#></td>
                            <td class="GridViewLabItemStyle" style="width:100px;  text-align:center;">
                                <img id="img9" src="../../Images/edit.png" alt="" onclick="EditRatingMaster(this);" title="Click To Edit" style="cursor: pointer" />
                            </td>
                        </tr>
                <#}#>
            </tbody>
        </table>
    </script>
</asp:Content>
