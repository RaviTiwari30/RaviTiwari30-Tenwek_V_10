<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EmergencyAdmissionReport.aspx.cs" Inherits="Design_Emergency_EmergencyAdmissionReport" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
	 <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript">

        function showuploadbox(pid, trans, t) {
            if (t == 1) {
                $.fancybox({
                    maxWidth: '70%',
                    maxHeight: '53%',
                    fitToView: false,
                    width: '700',
                    href: '../Lab/ViewLabReportsWard.aspx?PatientId='+pid+'&amp;TransactionId='+trans+'',
                    height: '500',
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                });
            }
            if (t == 0) {
                $.fancybox({
                    maxWidth: '70%',
                    maxHeight: '53%',
                    fitToView: false,
                    width: '700',
                    href: '../IPD/FlowSheetView.aspx?PatientId='+pid+'&amp;TransactionId='+trans+'',
                    height: '500',
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                });
            }
        }
        $(document).ready(function () {

            bindRoomType();
        })
        function bindRoomType() {
            jQuery("#cmbRoom option").remove();
            jQuery.ajax({
                url: "./EmergencyAdmissionReport.aspx/BindRoomType",
                data: '{FloorID:"' + $('#ddlFloor').val() + '",isAttenderRoom:"' + 0 + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    RoomData = jQuery.parseJSON(result.d);
                    $("#cmbRoom").append($("<option></option>").val("0").html("ALL"));
                    for (i = 0; i < RoomData.length; i++) {
                        $("#cmbRoom").append($("<option></option>").val(RoomData[i].IPDCaseTypeID).html(RoomData[i].Name)).chosen('destroy').chosen();

                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function Search() {

            var data = {
                RoomType: $('#cmbRoom').val(),
                PID: $('#txtPatientID').val(),
                EmergencyNo: $('#txtEmergencyNo').val()
            }
            serverCall('EmergencyAdmissionReport.aspx/BindEMRPatientDetails', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    bindWardTypePatientList(responseData);
                    $('#divPatientlist').show();
                }
                else { modelAlert(responseData.response); }
            });



        }
        function bindWardTypePatientList(data) {
            $('#tblPatientList tbody').empty();

            for (var i = 0; i < data.length > 0; i++) {
                var j = $('#tblPatientList tbody tr').length + 1;

                var row = '<tr>';

                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';

                row += ' <td class="GridViewLabItemStyle" style="text-align:center" >';
                row += '<a  href="javascript:void(0)" class="btnselect" onclick="checkIsReceived(this)"  >';
                row += '<input type="hidden" value=' + data[i].Ispatientreceived + ' class="hdnselect" />';
                row += '<input type="hidden" value=' + data[i].TID + ' class="hdnTID" />';
                row += '<input type="hidden" value="IPFolder.aspx?TID=' + data[i].TID + '&amp;PID=' + data[i].PatientID + '&amp;EMGNo=' + data[i].EmergencyNo + '&amp;LTnxNo=' + data[i].LTnxNo + '&amp;App_ID=&amp;PanelID=' + data[i].PanelID + '&amp;RoomID=' + data[i].RoomId + '" class="hdnredirect" />';
                if (data[i].Status == "STI") {
                    row += '<img alt="Select" src="../../Images/Post.gif"  style="display:none;"> id="imgframe"/>';

                } else {
                    row += '<img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" id="imgframe"/>';

                }

               

                row += '</a>	';
                row += '</td>';
                
                row += '<td id="tdRommType" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Bed_No1 + '</td>';
                row += '<td id="tdAge" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ColorSeq + '</td>';
                row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PatientID + '</td>';
                row += '<td id="tdUHID" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Name + '</td>';
                row += '<td id="tdCODE" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AgeSex + '</td>';
                row += '<td id="tdDOA" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Complaint + '</td>';
                row += '<td id="tdFistCall" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TT + '</td>';
                row += '<td id="tdGA" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ConsultantStatus + '</td>';
                row += '<td id="tdGA" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].WaitingType + '</td>';

                row += '<td id="tdCGA" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].NurseName + '</td>';
                row += '<td id="tdDays" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Doctor + '</td>';
                row += '<td id="tdMedicResidenceDoc" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].MedicResidenceDoc + '</td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; ">' + data[i].Temp + '</td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; ">' + data[i].Pulse + '</td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; ">' + data[i].BP + '</td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; ">' + data[i].Resp + '</td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; ">' + data[i].SPO2 + '</td>';
                row += '<td id="tdResp" class="GridViewLabItemStyle" style="text-align: center;"><a target="pagecontent" class=""  id="A2"  name="c" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox(' + data[i].PatientID + ',' + data[i].TransactionID1 + ',1);" style="color:yellow;" >Labs</a>&nbsp;&nbsp;&nbsp;<a target="pagecontent" class=""  id="A2"  name="c" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox(' + data[i].PatientID + ',' + data[i].TransactionID1 + ',0);" style="color:yellow;" >Flowsheet</a></td>';

                row += '<td id="tdBp" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].v1 + '/' + data[i].v3 + '</td>';
                row += '<td id="tdTemp" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].v2 + '/' + data[i].v5 + '</td>';
                row += '<td id="tdResp" class="GridViewLabItemStyle" style="text-align: center;">'+data[i].Alert+'</td>';
                
                
                row += '<td id="tdOxygen" class="GridViewLabItemStyle" style="text-align: center;display:none;"></td>';
                row += '<td id="tdLAB" class="GridViewLabItemStyle" style="text-align: center;display:none;"></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;display:none;">' + data[i].PatientReceiveddate + '</td>';

                row += '<td id="tdDoctorID" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].EmergencyNo + '</td>';
                //  row += '<td id="tdLink" class="GridViewLabItemStyle" style="width:255px;" style="text-align: center; ">';
                //  row += '<a target="pagecontent" class="ClassDoctorNoteBlink" id=' + data[i].DoctorID + ' name="a"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox(' + data[i].DoctorID + ',"/Design/IPD/DoctorProgressNote.aspx?PatientId=' + data[i].DoctorID + '&amp;TransactionId=' + data[i].DoctorID + '"," 1050, 1050, "73%", "90%"");" style=color:yellow; >Doctor</a>';'</td>';


                row += '<td id="tdMPatientID" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].PatientID + '</td>';
                row += '<td id="tdMPatientName" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].Name + '</td>';
                row += '<td id="tdMDoctorID" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].DoctorID + '</td>';
                 row += '<td id="tdMEMGNo" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].EmergencyNo + '</td>';
                 row += '<td id="tdMRoom" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].Room + '</td>';
                 row += '<td id="tdMPanel" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].PanelID + '</td>';
                row += '<td id="tdMSex" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].AgeSex + '</td>';
                row += '<td id="tdMDOB" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].DOB + '</td>';

                row += '<td id="tdMInDateTime" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].PatientReceiveddate + '</td>';
                row += '<td id="tdMDischargeDateTime" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].ReleasedDateTime + '</td>';
                row += '<td id="tdMTransactionID" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].TID + '</td>';
                row += '<td id="tdMDoctor" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].Doctor + '</td>';
                row += '<td id="tdMLTnxNo" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].LTnxNo + '</td>';
                row += '<td id="tdMstatus" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].Status + '</td>';
                row += '<td id="tdMRoomId" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].RoomId + '</td>';
                row += '<td id="tdMPatientCode" class="GridViewLabItemStyle" style="text-align: center;display:none; ">' + data[i].EmergencyNo + '</td>';
                
                row += '</tr>';
                $('#tblPatientList tbody').append(row);
            }
        }
        function ViewPMP(el) {
            var row = $(el).closest('tr');
            var TID = $(row).find('#tdTransactionID').text();
            serverCall('EmergencyAdmissionReport.aspx/bindPMP', { TID: TID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    $('#lblViewProblem').text(responseData.response[0].ProblemNotes);
                    $('#lblViewPlan').text(responseData.response[0].PlanNotes);
                    $('#divViewPMP').show();

                }
                else { modelAlert(responseData.response) };
            });

        }
        function report() {
            var data = {
                RoomType: $('#cmbRoom').val(),
                PID: $('#txtPatientID').val(),
                EmergencyNo: $('#txtEmergencyNo').val()

            }
            serverCall('EmergencyAdmissionReport.aspx/Bindwardtypepatientlistreport', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    window.open('../../Design/common/ExportToExcel.aspx');
                }
                else { modelAlert(responseData.response) };
            });
        }

        function Edit(el) {
            var row = $(el).closest('tr');
            $('#spnTransactionID').text($(row).find('#tdTransactionID').text());
            $('#spnDoctorID').text($(row).find('#tdDoctorID').text());
            $('#spnPatientID').text($(row).find('#tdUHID').text());
            $('#spnPname').text($(row).find('#tdPname').text());
            $('#spnLocation').text($(row).find('#tdRommType').text());

            bindList($('#spnTransactionID').text())
            $('#divNotesWrite').show();
        }

        function bindList(tid) {
            serverCall('EmergencyAdmissionReport.aspx/bindpatientnotes', { TransactionID: tid }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    bindPatientNotestlist(responseData.response);
                }
                else { $('#tblDoctorNoteslist tbody').empty(); clear(); }
            });
        }

        function clear() {
            $('#txtProblemNote').val('');
            $('#txtPlanNotes').val('');
            $('#btnSave').val('Save');

        }
        function bindPatientNotestlist(data) {
            $('#tblDoctorNoteslist tbody').empty();
            for (var i = 0; i < data.length > 0; i++) {
                var j = $('#tblDoctorNoteslist tbody tr').length + 1;

                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdProblemNotes" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ProblemNotes + '</td>';
                row += '<td id="tdPlanNotes" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PlanNotes + '</td>';
                row += '<td id="tdCreatedBy" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedBy + '</td>';
                row += '<td id="tdCreatedDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDate + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditPatientNote(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdEditID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '</tr>';
                $('#tblDoctorNoteslist tbody').append(row);
            }
        }

        function EditPatientNote(el) {
            var row = $(el).closest('tr');

            $('#txtProblemNote').val($(row).find('#tdProblemNotes').text());
            $('#txtPlanNotes').val($(row).find('#tdPlanNotes').text());
            $('#spnEditPatientNote').text($(row).find('#tdEditID').text())
            $('#btnSave').val('Update')

        }
        function SaveNotes() {

            if (($('#txtProblemNote').val() == '' || $('#txtPlanNotes').val() == '')) {
                modelAlert('Please Enter Problem or Plan Note');
                return;
            }
            var data = {
                DoctorID: $('#spnDoctorID').text(),
                TransactionID: $('#spnTransactionID').text(),
                PatientID: $('#spnPatientID').text(),
                ProblemNote: $('#txtProblemNote').val(),
                PlanNote: $('#txtPlanNotes').val(),
                SaveType: $('#btnSave').val(),
                ID: $('#spnEditPatientNote').text()

            }
            serverCall('EmergencyAdmissionReport.aspx/SaveNotes', data, function (response) {
                responeData = JSON.parse(response);
                if (responeData.status) {
                    modelAlert(responeData.response, function () {
                        clear();
                        bindList($('#spnTransactionID').text());
                    });

                }
                else if (responeData.Type == "Update") {
                    modelAlert(responeData.response, function () {

                        $BindAllergy();
                    });

                }
                else { modelAlert(responeData.response); }
            });
        }
    </script>

    <div id="Pbody_box_inventory">
	   <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Emergency Admission Report</b>
					<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
		</div>
		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">
				Search Criteria
			</div>
             <div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
                         <div class="col-md-3">
							<label class="pull-left">
								Ward Type 
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							  <select id="cmbRoom" title="Select Room Type"   tabindex="10" onkeyup="if(event.keyCode==13){Search(0);};"></select>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								UHID
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text" id="txtPatientID" onkeyup="if(event.keyCode==13){Search(0);};"  tabindex="1" autocomplete="off" data-title="Enter UHID" />
						</div>


                        <div class="col-md-3">
                            <label class="pull-left">
                                Emergency No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmergencyNo" runat="server" ClientIDMode="Static" Style="text-transform: uppercase" MaxLength="30" TabIndex="9" AutoCompleteType="Disabled" data-title="Enter IPD No." onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>

                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-9">
                </div>
                <div class="col-md-2">
                    <input type="button" class="ItDoseButton" title="Click to Search Patient" tabindex="16" value="Search" id="btnSearch" onclick="Search()" />
                </div>
                <div class="col-md-4">
                    <input type="button" class="ItDoseButton" title="Click to Search Patient" tabindex="16" value="Report In Excel" id="Button1" onclick="report()" />
                </div>
                <div class="col-md-9">
                </div>
            </div>

            <div class="row" style="display: none" id="divPatientlist">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblPatientList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" scope="col">Select</th>
                                <th class="GridViewHeaderStyle" scope="col">Bed</th>

                                <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">Acuity Level</th>
                                <th class="GridViewHeaderStyle" scope="col">UHID</th>
                                <th class="GridViewHeaderStyle" scope="col">Patient Name</th>
                                <th class="GridViewHeaderStyle" scope="col">Age/Sex</th>
                                <th class="GridViewHeaderStyle" scope="col">Chief Complaint</th>
                                <th class="GridViewHeaderStyle" scope="col">Treatment Time</th>
                                <th class="GridViewHeaderStyle" scope="col">Doctor Time in Status</th>
                                <th class="GridViewHeaderStyle" scope="col">Doctor Waiting Type</th>

                                <th class="GridViewHeaderStyle" scope="col">Nurse</th>
                                <th class="GridViewHeaderStyle" scope="col">Doctor</th>
                                  <th class="GridViewHeaderStyle" scope="col">R/M</th>
                                <th class="GridViewHeaderStyle" scope="col">Temp</th>
                                <th class="GridViewHeaderStyle" scope="col">Pulse</th>
                                <th class="GridViewHeaderStyle" scope="col">BP</th>
                                <th class="GridViewHeaderStyle" scope="col">Resp</th>
                                <th class="GridViewHeaderStyle" scope="col">SPO2</th>

                                <th class="GridViewHeaderStyle" scope="col">New Results</th>
                                <th class="GridViewHeaderStyle" scope="col">Lab Status</th>
                                <th class="GridViewHeaderStyle" scope="col">Imaging status</th>

                                <th class="GridViewHeaderStyle" scope="col">Alerts</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">SCR</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">Unack</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">Consult stat</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">dispo</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">Pending Services</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">Received Date Time</th>

                                <th class="GridViewHeaderStyle" style="width: 60px; display: none">Emergency No.</th>



                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">Panel</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">Release For IPD</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display: none">TransactionID</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 30px; display: none">LedgerTransactionNo</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 30px; display: none">Status</th>

                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

  
        
        
      <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>
	
          </div>
    <div id="divViewPMP" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1050px; height: 200px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divViewPMP" aria-hidden="true">&times;</button>
                        </div>

                 <div class="modal-body">
                     <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">Problem</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <label id="lblViewProblem"></label>
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">Plan</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <label id="lblViewPlan"></label>
                         </div>
                     </div>
                      <div class="row">
                         <div class="col-md-3">
                        <label class="pull-left">Medication</label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-20">
                             <label id="lblViewMedication"></label>
                         </div>
                     </div>

                     </div>
                </div>
            </div>
        </div>
    
    <div id="divNotesWrite" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1050px; height: 474px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divNotesWrite" aria-hidden="true">&times;</button>
                  <div class="row">

                        <div class="col-md-5">
                            <h4 class="modal-title">Problem Plan Note</h4>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">PName</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnPname"></span>

                        </div>
                       <div class="col-md-3">
                            <label class="pull-left">Location</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnLocation"></span>

                        </div>
                        </div>
                          <span class="hidden" id="spnTransactionID"></span>
                    <span class="hidden" id="spnDoctorID"></span>
                        <span class="hidden" id="spnPatientID"></span>
                        <span class="hidden" id="spnEditPatientNote"></span>
                        </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Problem</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20">
                            <textarea id="txtProblemNote" title="Problem Notes" style="height: 100px"></textarea>


                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Plan</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20">
                            <textarea id="txtPlanNotes" title="Problem Notes" style="height: 100px"></textarea>


                             </div>
                         </div>

                          <div class="row" style="text-align: center">
                              <div class="col-md-24">
                                  <input type="button" value="Save" id="btnSave" title="Save All Details" onclick="SaveNotes();" />
                              </div>
                              </div>

                         
       
            <div class="row">
                <div id="divDoctorPatientNote" style="max-height: 133px; overflow-x: auto">
                    <table class="FixedHeader" id="tblDoctorNoteslist" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Problem Note</th>
                                <th class="GridViewHeaderStyle">Plan Note</th>
                                <th class="GridViewHeaderStyle">Createdby</th>
                                <th class="GridViewHeaderStyle">Created Date</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
            </div>
                         
                </div>

        </div>
    </div>


    <script type="text/javascript">
        //=====By AJEET====
        var checkIsReceived = function (elem) {
            var closestTr = $(elem).closest('tr');
            var IsReceived = $.trim(closestTr.find('.hdnselect').val());
            var TID = $.trim(closestTr.find('.hdnTID').val());
            var URL = $.trim(closestTr.find('.hdnredirect').val());


            if (IsReceived == 0) {
                modelConfirmation('Alert!!!', 'Do You Want To Receive Patient?', 'YES', 'NO', function (response) {
                    if (response) {
                        serverCall('Services/EmergencyAdmission.asmx/IsReceivedPatient', { TID: TID, IsReceived: 1 }, function (response) {
                            var $responseData = JSON.parse(response);
                            modelAlert($responseData.response, function () {
                                closestTr.remove();
                                $("#iframePatient").attr("src", URL);
                                reseizeIframe(closestTr);

                            });
                        });
                    }
                });
            }
            else {
                $("#iframePatient").attr("src", URL);

                reseizeIframe(closestTr);


            }
        }

        function reseizeIframe(elem) {
            $modelBlockUI();
            var iframe = document.getElementById("iframePatient");
            var row = $(elem).closest('tr');
            iframe.onload = function () {
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.display = '';
                try {


                    var contentDocument = document.getElementById("iframePatient").contentDocument;
                    contentDocument.getElementById('lblPatientName').innerHTML = row.find('#tdMPatientName').text();
                    contentDocument.getElementById('lblDoctorName').innerHTML = row.find('#tdMDoctor').text();
                    localStorage.setItem("doctorid", row.find('#tdMDoctorID').text());
                    // $('#ddlDoctor').val(row.find('#tdDoctorID').text()).chosen();
                    contentDocument.getElementById('lblPatientID').innerHTML = row.find('#tdMPatientID').text();
                    contentDocument.getElementById('lblEMGNo').innerHTML = row.find('#tdMEMGNo').text();
                    contentDocument.getElementById('lblRoomNo').innerHTML = row.find('#tdMRoom').text();
                    contentDocument.getElementById('lblPanel').innerHTML = row.find('#tdMPanel').text();
                    contentDocument.getElementById('lblGender').innerHTML = row.find('#tdMSex').text().split('/')[1];
                    contentDocument.getElementById('lblAge').innerHTML = row.find('#tdMSex').text().split('/')[0];
                    contentDocument.getElementById('lblDOB').innerHTML = row.find('#tdMDOB').text();
                    contentDocument.getElementById('lblAdmitDate').innerHTML = row.find('#tdMInDateTime').text();
                    contentDocument.getElementById('lblDischargeDate').innerHTML = row.find('#tdMDischargeDateTime').text();
                    contentDocument.getElementById('txtTID').value = row.find('#tdMTransactionID').text();
                    contentDocument.getElementById('txtLTnxNo').value = row.find('#tdMLTnxNo').text();
                    contentDocument.getElementById('txtStatus').value = row.find('#tdMstatus').text();
                    contentDocument.getElementById('txtRoomId').value = row.find('#tdMRoomId').text();
                    contentDocument.getElementById('lblPatientCode').innerHTML = row.find('#tdMPatientCode').text();
 
                    $modelUnBlockUI();
                }
                catch (e) {
                    $modelUnBlockUI();
                }

            };
        }

        function closeIframe() {
            var iframe = document.getElementById("iframePatient");
            iframe.style.width = '0%';
            iframe.style.height = '0%';
            iframe.style.display = 'none';
            iframe.contentWindow.document.write('');
        }

        </script>
</asp:Content>