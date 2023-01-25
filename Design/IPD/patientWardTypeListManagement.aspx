<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientWardTypeListManagement.aspx.cs" Inherits="Design_IPD_PatientWardTypeListManagement" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">

        function showuploadbox(obj, href, maxh, maxw, w, h, obj) {

            $.fancybox({
                maxWidth: maxw,
                maxHeight: maxh,
                fitToView: false,
                width: w,
                href: href,
                height: h,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
        $(document).ready(function () {

            bindRoomType();
            bindDoctorTeam();
        });
        function bindDoctorTeam() {
            serverCall('PatientWardTypeListManagement.aspx/bindDoctorTeamList', { TeamID: $('#ddlDoc').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var $ddlDoctorTeam = $('#ddlDoctorTeam');
                    $ddlDoctorTeam.bindDropDown({ defaultValue: 'ALL', data: responseData.response, valueField: 'DoctorID', textField: 'DoctorName' });
                }

                else { $('#ddlDoctorTeam').empty(); }
            });
        }

        function bindRoomType() {
            jQuery("#cmbRoom option").remove();
            jQuery.ajax({
                url: "../IPD/PatientSearch.aspx/BindRoomType",
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
                TID: $('#txtTransactionNo').val(),
                Team: $('#ddlDoctorTeam').val()
            }
            serverCall('PatientWardTypeListManagement.aspx/Bindwardtypepatientlist', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    bindWardTypePatientList(responseData.data,responseData.IsDrExist);
                    $('#divPatientlist').show();
                }
                else { modelAlert(responseData.response); }
            });



        }
        function bindWardTypePatientList(data,IsExist) {
            $('#tblPatientList tbody').empty();

            for (var i = 0; i < data.length > 0; i++) {
                var j = i + 1;

                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdRommType" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Location + '</td>';
                row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Pname + '</td>';
                row += '<td id="tdUHID" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].UHID + '</td>';
                row += '<td id="tdCODE" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CODE + '</td>';
                row += '<td id="tdDOA" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DOA + '</td>';
                row += '<td id="tdAge" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Age + '</td>';
                row += '<td id="tdFistCall" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FistCall + '</td>';
                row += '<td id="tdGA" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].GA + '</td>';
                row += '<td id="tdCGA" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CGA + '</td>';
                row += '<td id="tdDays" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Days + '</td>';
                row += '<td id="tdISS" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ISS + '</td>';
                row += '<td id="tdWeight" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Weight + '</td>';
                row += '<td id="tdHeight" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Height + '</td>';
                row += '<td id="tdBp" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Bp + '</td>';
                row += '<td id="tdTemp" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Temp + '</td>';
                row += '<td id="tdResp" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Resp + '</td>';
                row += '<td id="tdOxygen" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Oxygen + '</td>';
                row += '<td id="tdLAB" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LAB + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none;"><img id="imgEdit" src="../../Images/Post.gif" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="ViewPMP(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TransactionID + '</td>';
                row += '<td id="tdDoctorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].DoctorID + '</td>';
                if (IsExist=="1") {
                    if (data[i].IsDrInvolved == 0) {
                        row += '<td class="GridViewLabItemStyle"><input type="button" id="tdSave" style="background-color: green;" onclick="AddInvolvedDr(this)" value="Add"/> </td>';

                    }
                    else if (data[i].IsDrInvolved > 0) {
                        row += '<td class="GridViewLabItemStyle"><input type="button" id="tdSave" style="background-color: red;" onclick="RemoveInvolvedDr(this)" value="Remove"/> </td>';

                    }
                }
               
                

                //  row += '<td id="tdLink" class="GridViewLabItemStyle" style="width:255px;" style="text-align: center; ">';
              //  row += '<a target="pagecontent" class="ClassDoctorNoteBlink" id=' + data[i].DoctorID + ' name="a"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox(' + data[i].DoctorID + ',"/Design/IPD/DoctorProgressNote.aspx?PatientId=' + data[i].DoctorID + '&amp;TransactionId=' + data[i].DoctorID + '"," 1050, 1050, "73%", "90%"");" style=color:yellow; >Doctor</a>';'</td>';
      
                

                row += '</tr>';




                row += '<tr>'
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"></td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TransactionID + '</td>';
                row += '<td   id="tdDoctorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].DoctorID + '</td>';
                row += '<td colspan="10" class="GridViewLabItemStyle"><textarea class="required" id="tdtxtProblemNote"  title="Problem Notes" style="height:30px">' + data[i].ProblemNotes + '</textarea></td>';
                row += '<td colspan="9" class="GridViewLabItemStyle"><textarea  class="required" id="tdtxtPlanNotes"  title="Plan Notes" style="height:30px">' + data[i].PlanNotes + '</textarea> </td>';
                row += '<td class="GridViewLabItemStyle"><input type="button" id="tdSave" onclick="SaveData(this)" value="Save"/> </td>';
                row += '</tr>';

                $('#tblPatientList tbody').append(row);
            }
        }
        function ViewPMP(el) {
            var row = $(el).closest('tr');
            var TID = $(row).find('#tdTransactionID').text();
            serverCall('PatientWardTypeListManagement.aspx/bindPMP', { TID: TID }, function (response) {
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
                TID: $('#txtTransactionNo').val(),
                Team: $('#ddlDoctorTeam').val()
                
            }
            serverCall('PatientWardTypeListManagement.aspx/Bindwardtypepatientlistreport', data, function (response) {
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
            serverCall('PatientWardTypeListManagement.aspx/bindpatientnotes', { TransactionID: tid }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    bindPatientNotestlist(responseData.response);
                }
                else { $('#tblDoctorNoteslist tbody').empty(); clear();}
            });
        }


        function SaveData(rowId) {
            var row = $(rowId).closest('tr');

            var TID = $(row).find('#tdTransactionID').text();
            var DrID = $(row).find('#tdDoctorID').text();
            var ProblemNote = $(row).find('#tdtxtProblemNote').val();
            var PlanNote = $(row).find('#tdtxtPlanNotes').val();
            var PatientID = $('#spnPatientID').text();

            var data = {
                DoctorID: DrID,
                TransactionID: TID,
                PatientID: PatientID,
                ProblemNote: ProblemNote,
                PlanNote: PlanNote,
                
            }

            if (data.TransactionID=="") {
                modelAlert("Some Error Occured! Contact to Administrator.");
                return false;

            }


            if (data.ProblemNote == '' ) {
                modelAlert('Please Enter Problem  Note');
                $(row).find('#tdtxtProblemNote').selectRange(0);
                return false;
            }
            if ( data.PlanNote == '') {
                modelAlert('Please Enter Plan Note');

                $(row).focus.find('#tdtxtPlanNotes');
                return false;

            }


            serverCall('PatientWardTypeListManagement.aspx/SaveProblemNotes', data, function (response) {
                responeData = JSON.parse(response);
                if (responeData.status) {
                    modelAlert(responeData.response, function () {
                        Search();
                    });

                }
                 else { modelAlert(responeData.response); }
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
                ID:$('#spnEditPatientNote').text()

            }
            serverCall('PatientWardTypeListManagement.aspx/SaveNotes', data, function (response) {
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


        function RemoveInvolvedDr(rowId) {
            var row = $(rowId).closest('tr');
            var TID = $(row).find('#tdTransactionID').text();
           // alert(TID)
            serverCall('PatientWardTypeListManagement.aspx/RemoveInvolvedDr', { TransactionID: TID }, function (response) {
                responeData = JSON.parse(response);
                if (responeData.status) {
                    modelAlert(responeData.response, function () {
                        Search();
                    });
                } else {
                    modelAlert(responeData.response, function () {

                    });
                }
            });

        };

        function AddInvolvedDr(rowId) {
            var row = $(rowId).closest('tr');

            var TID = $(row).find('#tdTransactionID').text();


            serverCall('PatientWardTypeListManagement.aspx/AddInvolvedDr', { TransactionID: TID }, function (response) {
                responeData = JSON.parse(response);
                if (responeData.status) {
                    modelAlert(responeData.response, function () {
                        Search();
                    });
                } else {
                    modelAlert(responeData.response, function () {
                    });
                }

            });

        };




    </script>

    <div id="Pbody_box_inventory">
	   <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Patient Ward Type List Management</b>
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
							Team 
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							  <select id="ddlDoctorTeam" title="Select Doctor Team"   tabindex="10" ></select>
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

                    </div>
                    <div class="row">
                     <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTransactionNo" runat="server" ClientIDMode="Static" Style="text-transform: uppercase" MaxLength="10" TabIndex="9" AutoCompleteType="Disabled" data-title="Enter IPD No." onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>

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
                                <th class="GridViewHeaderStyle">Location</th>
                                <th class="GridViewHeaderStyle">PatientName</th>
                                <th class="GridViewHeaderStyle">UHID</th>
                                <th class="GridViewHeaderStyle">Code Status</th>
                                <th class="GridViewHeaderStyle">DOA</th>
                                <th class="GridViewHeaderStyle">AGE</th>
                                <th class="GridViewHeaderStyle">FirstCall</th>
                                <th class="GridViewHeaderStyle">GA</th>
                                <th class="GridViewHeaderStyle">CGA</th>
                                <th class="GridViewHeaderStyle">HD</th>
                                <th class="GridViewHeaderStyle">ISS</th>
                                <th class="GridViewHeaderStyle">Weight</th>
                                <th class="GridViewHeaderStyle">Height</th>
                                <th class="GridViewHeaderStyle">Bp</th>
                                <th class="GridViewHeaderStyle">Temp</th>
                                <th class="GridViewHeaderStyle">RR</th>
                                <th class="GridViewHeaderStyle">SPO2</th>
                                <th class="GridViewHeaderStyle">LAB</th>
                                <th class="GridViewHeaderStyle" title="Create Problem and Plan Notest" style="display: none">Create Pro/plan</th>
                                <th class="GridViewHeaderStyle">View P/M/Plan</th>
                                <th class="GridViewHeaderStyle">Action</th>

                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
          
        </div>
    <div id="divViewPMP" class="modal fade " >
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
                            <textarea id="txtPlanNotes" title="Plan Notes" style="height: 100px"></textarea>


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
</asp:Content>