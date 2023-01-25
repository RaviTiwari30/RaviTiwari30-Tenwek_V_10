<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="WardTypeListManagment.aspx.cs" Inherits="Design_IPD_WardTypeListManagment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Team List Management</b>
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
                                Ward 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="cmbRoom" title="Select Room Type" tabindex="10" onkeyup="if(event.keyCode==13){Search(0);};"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Team 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctorTeam" title="Select Doctor Team" tabindex="10" onchange="Search()"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientID" onkeyup="if(event.keyCode==13){Search(0);};" tabindex="1" autocomplete="off" data-title="Enter UHID" />
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

                        <div class="col-md-3">
                            <label class="pull-left">
                                My Patient List
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-3">
                            <input type="checkbox" id="chkIsOwn" title="Click To Search Only Own Patient" onclick="Search()" />
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
                    <input type="button" class="ItDoseButton" title="Click to Export Report" tabindex="16" value="Report In Excel" id="Button1" onclick="report()" />
                </div>
                <div class="col-md-9">
                </div>
            </div>

            <div class="row" style="display: none" id="divPatientlist">
                <div class="Purchaseheader">
                    <label id="lblPrimaryHeader"></label>
                </div>
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblPatientList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Select</th>
                                <th class="GridViewHeaderStyle">ShortCut</th>
                                <th class="GridViewHeaderStyle">Location</th>
                                <th class="GridViewHeaderStyle">PatientName</th>
                                <th class="GridViewHeaderStyle">IPDNo</th>
                                <th class="GridViewHeaderStyle">UHID</th>
                                <th class="GridViewHeaderStyle">Code Status</th>
                                <th class="GridViewHeaderStyle">DOA</th>
                                <th class="GridViewHeaderStyle">Age</th>
                                <th class="GridViewHeaderStyle">FirstCall</th>
                                <th class="GridViewHeaderStyle">GA</th>
                                <th class="GridViewHeaderStyle">CGA</th>
                                <th class="GridViewHeaderStyle">HD</th>
                                <th class="GridViewHeaderStyle">ISS</th>
                                <th class="GridViewHeaderStyle">Weight</th>
                                <th class="GridViewHeaderStyle" style="display:none">Height</th>
                                <th class="GridViewHeaderStyle">BP</th>
                                <th class="GridViewHeaderStyle">Temp</th>
                                <th class="GridViewHeaderStyle">RR</th>
                                <th class="GridViewHeaderStyle">SPO2</th>
                                <th class="GridViewHeaderStyle">LAB</th>
                                <th class="GridViewHeaderStyle" scope="col">MAR</th>
                                <th class="GridViewHeaderStyle" title="Create Problem and Plan Notest" style="display: none">Create Pro/plan</th>
                                <th class="GridViewHeaderStyle">View P/M/Plan</th>
                                <th class="GridViewHeaderStyle">Hide/Show</th>
                                <th class="GridViewHeaderStyle">Action</th>

                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>


            <div class="row" style="display: none" id="divSecodaryList">
                <div class="Purchaseheader">
                    <label id="lblSecondaryHeader"></label>
                </div>
                <div id="divSList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblSecondaryList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">Select</th>
                                <th class="GridViewHeaderStyle">Location</th>
                                <th class="GridViewHeaderStyle">Short Cuts</th>
                                <th class="GridViewHeaderStyle">PatientName</th>
                                <th class="GridViewHeaderStyle">IPDNo</th>
                                <th class="GridViewHeaderStyle">UHID</th>
                                <th class="GridViewHeaderStyle">Code Status</th>
                                <th class="GridViewHeaderStyle">DOA</th>
                                <th class="GridViewHeaderStyle">Age</th>
                                <th class="GridViewHeaderStyle">FirstCall</th>
                                <th class="GridViewHeaderStyle">GA</th>
                                <th class="GridViewHeaderStyle">CGA</th>
                                <th class="GridViewHeaderStyle">HD</th>
                                <th class="GridViewHeaderStyle">ISS</th>
                                <th class="GridViewHeaderStyle">Weight</th>
                                <th class="GridViewHeaderStyle" style="display:none">Height</th>
                                <th class="GridViewHeaderStyle">BP</th>
                                <th class="GridViewHeaderStyle">Temp</th>
                                <th class="GridViewHeaderStyle">RR</th>
                                <th class="GridViewHeaderStyle">SPO2</th>
                                <th class="GridViewHeaderStyle">LAB</th>
                                <th class="GridViewHeaderStyle" scope="col">MAR</th>
                                <th class="GridViewHeaderStyle" title="Create Problem and Plan Notest" style="display: none">Create Pro/plan</th>
                                <th class="GridViewHeaderStyle">View P/M/Plan</th>
                                <th class="GridViewHeaderStyle">Hide/Show</th>
                                <th class="GridViewHeaderStyle">Action</th>

                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>


        </div>

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




    <div id="divAdded" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 800px;">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAdded" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><span id="spnHeading">Add Patient</span></h4>
                    <label id="lblMTransactionId" style="display: none"></label>
                </div>
                <div class="modal-body">

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <input type="radio" id="btnSelf" value="0" name="btntype" checked="checked" onclick="hideshowdivteamlist(0)" />
                            <label for="btnSelf">Add To List</label>
                            <input type="radio" id="btnTeam" value="1" name="btntype" onclick="hideshowdivteamlist(1)" />
                            <label for="btnTeam">Add To Team</label>
                        </div>

                        <div class="col-md-3 divteamlist" style="display: none">
                            <label class="pull-left">Team List</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6 divteamlist" style="display: none">
                            <select id="ddlTeamList" title="Select Doctor Team" tabindex="10" class="required"></select>
                        </div>

                    </div>

                </div>
                <div class="modal-footer">
                    <input type="button" id="btnAddPatient" value="Save" onclick="AddInvolvedDr()" />

                </div>

            </div>
        </div>
    </div>




    <script type="text/javascript">

        function showuploadbox(obj, href, w, h) {
            //if (obj != "") {
            //    $.fancybox({
            //        maxWidth: maxw,
            //        maxHeight: maxh,
            //        fitToView: false,
            //        width: w,
            //        href: href,
            //        height: h,
            //        autoSize: false,
            //        closeClick: false,
            //        openEffect: 'none',
            //        closeEffect: 'none',
            //        'type': 'iframe'
            //    });
            //}

            if (obj != "") {
                window.open(href);
            }
        }

        function showuploadboxOther(obj, href, maxh, maxw, w, h, obj) {
            $.fancybox({
                maxWidth: maxw,
                maxHeight: maxh,
                fitToView: false,
                width: 1050,
                href: href,
                height: 1050,
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
            serverCall('WardTypeListManagment.aspx/bindDoctorTeamList', { TeamID: $('#ddlDoc').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var $ddlDoctorTeam = $('#ddlDoctorTeam');
                    $ddlDoctorTeam.bindDropDown({ defaultValue: 'Select', data: responseData.response, valueField: 'DoctorID', textField: 'DoctorName' });
                }

                else { $('#ddlDoctorTeam').empty(); }
            });
        }

        function ViewPMP(el) {
            var row = $(el).closest('tr');
            var TID = $(row).find('#tdTransactionID').text();
            serverCall('WardTypeListManagment.aspx/bindPMP', { TID: TID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    $('#lblViewProblem').text(responseData.response[0].ProblemNotes);
                    $('#lblViewPlan').text(responseData.response[0].PlanNotes);
                    $('#lblViewMedication').text(responseData.response[0].Medication);

                    
                    $('#divViewPMP').show();

                }
                else { modelAlert(responseData.response) };
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


          

            chkIsOwn = 0;
            if ($('#chkIsOwn').is(":checked"))
                chkIsOwn = 1;

            

            var data = {
                RoomType: $('#cmbRoom').val(),
                PID: $('#txtPatientID').val(),
                TID: $('#txtTransactionNo').val(),
                Team: $('#ddlDoctorTeam').val(),
                IsOwnPatient: chkIsOwn,
            }
            serverCall('WardTypeListManagment.aspx/Bindwardtypepatientlist', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    getHeaderName();
                    if (responseData.Pstatus) {
                        bindWardTypePatientList(responseData.Primarydata);
                        $('#divPatientlist').show();
                    } else {
                        $('#divPatientlist').hide();
                        $('#tblPatientList tbody').empty();
                    }

                    if (responseData.Sstatus) {
                        bindWardTypeSecondaryList(responseData.Secondarydata);
                        $('#divSecodaryList').show();
                    }
                    else {
                        $('#divSecodaryList').hide();
                        $('#tblSecondaryList tbody').empty();

                    }
                }
                else {
                    $('#divPatientlist').hide();
                    $('#divSecodaryList').hide();
                    $('#tblSecondaryList tbody').empty();
                    $('#tblPatientList tbody').empty();
                    modelAlert(responseData.response);
                }
            });



        }
        function bindWardTypePatientList(data) {
            $('#tblPatientList tbody').empty();

            for (var i = 0; i < data.length > 0; i++) {
                var j = i + 1;


                var RRColorCode = "";
                var BPColorCode = "";
                var TempColorCode = "";

                if (data[i].RRColorCode=="0") {
                    RRColorCode = "#ddc84ad6";
                } else if (data[i].RRColorCode=="1") {
                    RRColorCode = "#8eeb98";
                } else if (data[i].RRColorCode=="2") {
                    RRColorCode = "#eb9e8e";
                }


                if (data[i].TempColorCode == "0") {
                    TempColorCode = "#ddc84ad6";
                } else if (data[i].TempColorCode == "1") {
                    TempColorCode = "#8eeb98";
                } else if (data[i].TempColorCode == "2") {
                    TempColorCode = "#eb9e8e";
                }

                 
                if (data[i].SystolicColorCode == "1" && data[i].DialoticColorCode == "1") {
                    BPColorCode = "#8eeb98";
                } else if (data[i].SystolicColorCode == "0" || data[i].DialoticColorCode == "0") {
                    BPColorCode = "#ddc84ad6";
                } else if (data[i].SystolicColorCode == "2" || data[i].DialoticColorCode == "2") {
                    BPColorCode = "#eb9e8e";
                }  

                 

                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                
                row += '<td id="tdRommTypes" class="GridViewLabItemStyle" style="text-align: center;"><a  href="javascript:void(0)" class="btnselect" onClick=showuploadbox("' + data[i].UHID + '","../IPD/OutsideipdFolder.aspx?App_ID=&amp;TID=' + data[i].TransactionID + '&amp;BillNo=' + data[i].BillNo + '&amp;PID=' + data[i].UHID + '&amp;LoginType=' + data[i].LoginType + '&amp;BillNo=' + data[i].BillNo + '&amp;sex=' + data[i].Sex + '&amp;PanelID=' + data[i].PanelID + '&amp;DoctorID=' + data[i].DoctorID + '","100%","100%");> <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" id="imgframe"/></a>  </td>';
                row += '<td id="td" class="GridViewLabItemStyle" style="width:200px"><a  target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/Notefinder.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");>Note &nbsp' +
                     '<a target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/IntakeOutPutChart.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");>I/O &nbsp' +
                     '<a target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/FlowSheetView.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");>FlowSheet &nbsp' +
                     '<a target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/TreatmentDoctor.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");>First Call </td>';
                     
             
                
                row += '<td id="tdRommType" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Location + '</td>';
                row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Pname + '</td>';
                row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TransNo + '</td>';
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
                row += '<td id="tdHeight" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].Height + '</td>';
                row += '<td id="tdBp" class="GridViewLabItemStyle" style="text-align: center; background-color:' + BPColorCode + '">' + data[i].Bp + '</td>';
                row += '<td id="tdTemp" class="GridViewLabItemStyle" style="text-align: center; background-color:' + TempColorCode + '">' + data[i].Temp + '</td>';
                row += '<td id="tdResp" class="GridViewLabItemStyle" style="text-align: center; background-color:'+RRColorCode+'">' + data[i].Resp + '</td>';
                row += '<td id="tdOxygen" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Oxygen + '</td>';
                row += '<td id="tdLAB" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LAB + '</td>';
                row += '<td id="tdMAR" class="GridViewLabItemStyle" style="text-align: center;"><a  target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/ViewMedicationOrder.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");> Rx </td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none;"><img id="imgEdit" src="../../Images/Post.gif" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="ViewPMP(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TransactionID + '</td>';
                row += '<td id="tdDoctorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].DoctorID + '</td>';
                row += '<td class="GridViewLabItemStyle"><input type="button" id="btnpshow' + j + '" style="background-color: green;" onclick="HideShowTrTextbox(0,' + j + ')" value="Show"/> <input type="button" id="btnphide' + j + '" style="background-color: red;display:none" onclick="HideShowTrTextbox(1,' + j + ')" value="Hide"/></td>';


                row += '<td class="GridViewLabItemStyle"><input type="button" id="tdSave" style="background-color: green;" onclick="OpenModel(this)" value="Add"/> </td>';

                row += '</tr>';


                row += '<tr id="trPrimaryhideshow' + j + '" style="display:none">'
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"></td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TransactionID + '</td>';
                row += '<td   id="tdDoctorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].DoctorID + '</td>';
                row += '<td colspan="10" class="GridViewLabItemStyle"><textarea class="required" id="tdtxtProblemNote"  title="Problem Notes" style="height:30px">' + data[i].ProblemNotes + '</textarea></td>';
                row += '<td colspan="11" class="GridViewLabItemStyle"><textarea  class="required" id="tdtxtPlanNotes"  title="Plan Notes" style="height:30px">' + data[i].PlanNotes + '</textarea> </td>';
                row += '<td class="GridViewLabItemStyle"><input type="button" id="tdSave" onclick="SaveData(this)" value="Save"/> </td>';
                row += '</tr>';


                $('#tblPatientList tbody').append(row);
            }
        }

        function bindWardTypeSecondaryList(data) {
            $('#tblSecondaryList tbody').empty();

            for (var i = 0; i < data.length > 0; i++) {
                var j = i + 1;


                var RRColorCode = "";
                var BPColorCode = "";
                var TempColorCode = "";

                if (data[i].RRColorCode == "0") {
                    RRColorCode = "#ddc84ad6";
                } else if (data[i].RRColorCode == "1") {
                    RRColorCode = "#8eeb98";
                } else if (data[i].RRColorCode == "2") {
                    RRColorCode = "#eb9e8e";
                }


                if (data[i].TempColorCode == "0") {
                    TempColorCode = "#ddc84ad6";
                } else if (data[i].TempColorCode == "1") {
                    TempColorCode = "#8eeb98";
                } else if (data[i].TempColorCode == "2") {
                    TempColorCode = "#eb9e8e";
                }


                if (data[i].SystolicColorCode == "1" && data[i].DialoticColorCode == "1") {
                    BPColorCode = "#8eeb98";
                } else if (data[i].SystolicColorCode == "0" || data[i].DialoticColorCode == "0") {
                    BPColorCode = "#ddc84ad6";
                } else if (data[i].SystolicColorCode == "2" || data[i].DialoticColorCode == "2") {
                    BPColorCode = "#eb9e8e";
                }




                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdRommTypes" class="GridViewLabItemStyle" style="text-align: center;"><a  href="javascript:void(0)" class="btnselect" onClick=showuploadbox("' + data[i].UHID + '","../IPD/OutsideipdFolder.aspx?App_ID=&amp;TID=' + data[i].TransactionID + '&amp;BillNo=' + data[i].BillNo + '&amp;PID=' + data[i].UHID + '&amp;LoginType=' + data[i].LoginType + '&amp;BillNo=' + data[i].BillNo + '&amp;sex=' + data[i].Sex + '&amp;PanelID=' + data[i].PanelID + '&amp;DoctorID=' + data[i].DoctorID + '","100%","100%");> <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" id="imgframe"/></a>  </td>';
                row += '<td id="tdRommType" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Location + '</td>';
                row += '<td id="td" class="GridViewLabItemStyle" style="width:200px"><a  target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/Notefinder.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");>Note &nbsp' +
                     '<a target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/IntakeOutPutChart.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");>I/O &nbsp' +
                     '<a target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/FlowSheetView.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");>FlowSheet &nbsp' +
                     '<a target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/TreatmentDoctor.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");>First Call </td>';


                row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Pname + '</td>';
                row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TransNo + '</td>';
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
                row += '<td id="tdHeight" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].Height + '</td>';
                row += '<td id="tdBp" class="GridViewLabItemStyle" style="text-align: center; background-color:' + BPColorCode + '">' + data[i].Bp + '</td>';
                row += '<td id="tdTemp" class="GridViewLabItemStyle" style="text-align: center; background-color:' + TempColorCode + '">' + data[i].Temp + '</td>';
                row += '<td id="tdResp" class="GridViewLabItemStyle" style="text-align: center; background-color:' + RRColorCode + '">' + data[i].Resp + '</td>';
                row += '<td id="tdOxygen" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Oxygen + '</td>';
                row += '<td id="tdLAB" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LAB + '</td>';
                row += '<td id="tdMAR" class="GridViewLabItemStyle" style="text-align: center;"><a  target="pagecontent" style="cursor: pointer;color:blue;text-decoration: underline;" class="btnselect" onClick=showuploadboxOther("' + data[i].UHID + '","../IPD/ViewMedicationOrder.aspx?PatientId=' + data[i].UHID + '&amp;TransactionId=' + data[i].TransactionID + '","73%","90%");> Rx </td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none;"><img id="imgEdit" src="../../Images/Post.gif" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="ViewPMP(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TransactionID + '</td>';
                row += '<td id="tdDoctorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].DoctorID + '</td>';
                row += '<td class="GridViewLabItemStyle"><input type="button" id="btnSshow' + j + '" style="background-color: green;" onclick="HideShowTrTextbox(2,' + j + ')" value="Show"/> <input type="button" id="btnShide' + j + '" style="background-color: red;display:none" onclick="HideShowTrTextbox(3,' + j + ')" value="Hide"/></td>';

                row += '<td class="GridViewLabItemStyle"><input type="button" id="tdSave" style="background-color: red;" onclick="RemoveInvolvedDr(this)" value="Remove"/> </td>';


                row += '</tr>';


                row += '<tr id="trSecondaryhideshow' + j + '"  style="display:none">'
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"></td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TransactionID + '</td>';
                row += '<td   id="tdDoctorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].DoctorID + '</td>';
                row += '<td colspan="10" class="GridViewLabItemStyle"><textarea class="required" id="tdtxtProblemNote"  title="Problem Notes" style="height:30px">' + data[i].ProblemNotes + '</textarea></td>';
                row += '<td colspan="11" class="GridViewLabItemStyle"><textarea  class="required" id="tdtxtPlanNotes"  title="Plan Notes" style="height:30px">' + data[i].PlanNotes + '</textarea> </td>';
                row += '<td class="GridViewLabItemStyle"><input type="button" id="tdSave" onclick="SaveData(this)" value="Save"/> </td>';
                row += '</tr>';

                $('#tblSecondaryList tbody').append(row);
            }
        }




        function report() {
            chkIsOwn = 0;
            if ($('#chkIsOwn').is(":checked"))
                chkIsOwn = 1;

            var data = {
                RoomType: $('#cmbRoom').val(),
                PID: $('#txtPatientID').val(),
                TID: $('#txtTransactionNo').val(),
                Team: $('#ddlDoctorTeam').val(),
                IsOwnPatient: chkIsOwn,
            }
            serverCall('WardTypeListManagment.aspx/Bindwardtypepatientlistreport', data, function (response) {
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
            serverCall('WardTypeListManagment.aspx/bindpatientnotes', { TransactionID: tid }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    bindPatientNotestlist(responseData.response);
                }
                else { $('#tblDoctorNoteslist tbody').empty(); clear(); }
            });
        }







        function hideshowdivteamlist(typ) {

            if (typ == 0) {
                $(".divteamlist").hide();
            } else {
                bindAddDoctorTeam();
                $(".divteamlist").show();
            }


        }

        function bindAddDoctorTeam() {
            var Typ = 0;
            if ($('#chkIsOwn').is(":checked"))
                Typ = 1;
            var TeamId = "";

            if (Typ == 0) {
                TeamId = $('#ddlDoctorTeam').val();
            }

            serverCall('WardTypeListManagment.aspx/bindAddDoctorTeam', { TeamID: TeamId }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    var $ddlDoctorTeam = $('#ddlTeamList');
                    $ddlDoctorTeam.bindDropDown({ defaultValue: 'Select', data: responseData.response, valueField: 'DoctorID', textField: 'DoctorName' });
                }

                else { $('#ddlTeamList').empty(); }
            });
        }



        function OpenModel(rowId) {
            var row = $(rowId).closest('tr');
            var TID = $(row).find('#tdTransactionID').text();

            var chkIsOwn = 0;
            if ($('#chkIsOwn').is(":checked"))
                chkIsOwn = 1;

            $("input[name=btntype][value=" + chkIsOwn + "]").attr('checked', 'checked');
            if (chkIsOwn == 1) {
                $("input[name=btntype][value=0]").attr("disabled", true);
                bindAddDoctorTeam();
                hideshowdivteamlist(1)
            } else {
                $("input[name=btntype][value=0]").attr("disabled", false);
                hideshowdivteamlist(0)
            }

            $("#lblMTransactionId").text(TID);
            $("#divAdded").show();


        }


        function RemoveInvolvedDr(rowId) {
            var row = $(rowId).closest('tr');
            var TID = $(row).find('#tdTransactionID').text();
            var Name = $(row).find('#tdPname').text();
            var IsTeam = 1;
            if ($('#chkIsOwn').is(":checked"))
                IsTeam = 0;
            var TeamId = $('#ddlDoctorTeam').val();

            var FromTeam = "Team";

            if (IsTeam == 1) {
                FromTeam = $("#ddlDoctorTeam option:selected").text();

            }
            else {
                FromTeam = '<%= Session["EmployeeName"].ToString() %>';

               }



        modelConfirmation('Remove Pateint  ?', 'Are You Sure to Remove Patient '+Name+' from ' + FromTeam, 'Yes', 'No', function (res) {
            if (res) {
                serverCall('WardTypeListManagment.aspx/RemoveInvolvedDr', { TransactionID: TID, IsTeam: IsTeam, TeamId: TeamId }, function (response) {
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
            }
        });


    };

    function AddInvolvedDr() {
        var TID = $('#lblMTransactionId').text();
        var IsTeam = $('input[name="btntype"]:checked').val();
        var TeamId = $('#ddlTeamList').val();

        serverCall('WardTypeListManagment.aspx/AddInvolvedDr', { TransactionID: TID, IsTeam: IsTeam, TeamId: TeamId }, function (response) {
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

    function getHeaderName() {

        var IsTeam = 1;
        if ($('#chkIsOwn').is(":checked"))
            IsTeam = 0;

        if (IsTeam == 1) {
            var TeamName = $("#ddlDoctorTeam option:selected").text();
            var PrimaryName = "Primary Patients : " + TeamName;
            var SecodaryName = "Other Patients : " + TeamName;
            $("#lblPrimaryHeader").text(PrimaryName)
            $("#lblSecondaryHeader").text(SecodaryName)

        }
        else {
            var TeamName = '<%= Session["EmployeeName"].ToString() %>';
                var PrimaryName = "First Call : " + TeamName;
                var SecodaryName = "Other Patients : " + TeamName;

                $("#lblPrimaryHeader").text(PrimaryName)
                $("#lblSecondaryHeader").text(SecodaryName)
            }

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

        if (data.TransactionID == "") {
            modelAlert("Some Error Occured! Contact to Administrator.");
            return false;

        }


        if (data.ProblemNote == '') {
            modelAlert('Please Enter Problem  Note');
            $(row).find('#tdtxtProblemNote').selectRange(0);
            return false;
        }
        if (data.PlanNote == '') {
            modelAlert('Please Enter Plan Note');

            $(row).focus.find('#tdtxtPlanNotes');
            return false;

        }


        serverCall('WardTypeListManagment.aspx/SaveProblemNotes', data, function (response) {
            responeData = JSON.parse(response);
            if (responeData.status) {
                modelAlert(responeData.response, function () {
                    Search();
                });

            }
            else { modelAlert(responeData.response); }
        });


    }

    function HideShowTrTextbox(Typ, Id) {

        if (Typ == 0) {
            $("#trPrimaryhideshow" + Id + "").show()
            $("#btnpshow" + Id + "").hide()
            $("#btnphide" + Id + "").show()

             
        } else if (Typ == 1) {
            $("#trPrimaryhideshow" + Id + "").hide()
            $("#btnpshow" + Id + "").show()
            $("#btnphide" + Id + "").hide()


        }
        else if (Typ == 2) {
            $("#trSecondaryhideshow" + Id + "").show()
            $("#btnSshow" + Id + "").hide()
            $("#btnShide" + Id + "").show()

        }
        else if (Typ == 3) {
            $("#trSecondaryhideshow" + Id + "").hide()
            $("#btnSshow" + Id + "").show()
            $("#btnShide" + Id + "").hide()

        }

    }

    </script>





</asp:Content>
