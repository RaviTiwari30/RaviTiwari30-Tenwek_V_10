<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OT_Master.aspx.cs" Inherits="Design_OT_OT_Master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCOTScheduling.ascx" TagName="OTSchedulingControl" TagPrefix="UC1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager runat="server" ID="scr1"></cc1:ToolkitScriptManager>

    <style type="text/css">
        /*.ui-tabs {
            background: none !important;
            border: none;
        }

        .ui-widget-content {
            z-index: auto;
        }*/
    </style>



    <script type="text/javascript">

        $(document).ready(function () {
            getExitingOTs(function () {
                bindDoctorLists(function () {
                    bindOTs(function () { });
                });
            });
        });


        var createOT = function () {

            var data = {
                OTName: $.trim($('#txtNewOT').val()),
                OTStartTime: $.trim($('#txtOTStartTime').val()),
                OTEndTime: $.trim($('#txtOTEndTime').val()),
                SlotMins: $.trim($('#txtOTSlotMins').val()),
            };


            serverCall('OT_Master.aspx/CreateOT', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.message, function () {
                    if (responseData.status) {
                        window.location.reload();
                    }
                });
            });
        }





        var getExitingOTs = function (callback) {
            serverCall('OT_Master.aspx/GetExitingOTs', {}, function (response) {
                responseData = JSON.parse(response);
                var parseHTML = $('#template_exitingOTs').parseTemplate(responseData);
                $('.divExitingOT .row').html(parseHTML);
                callback();
            });
        }


        var bindDoctorLists = function (callback) {
            var ddlDoctor = $('#ddlDoctorName');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: 'All' }, function (response) {

                var option = {
                    defaultValue: 'Select',
                    data: JSON.parse(response),
                    valueField: 'DoctorID',
                    textField: 'Name',
                    isSearchAble: true
                };

                ddlDoctor.bindDropDown(option);
                callback(ddlDoctor.val());
            });
        }




        var bindOTs = function (callback) {
            serverCall('Services/OT_Master.asmx/GetOTs', {}, function (response) {
                var responseData = JSON.parse(response);
                var ddlAvailableOT = $('#ddlAvailableOT');
                var option = {
                    defaultValue: 'Select',
                    data: JSON.parse(response),
                    valueField: 'ID',
                    textField: 'Name',
                    isSearchAble: true
                };

                ddlAvailableOT.bindDropDown(option);
                callback(ddlAvailableOT.val());
            });
        }





        var openOTScheduling = function () {
            var doctorID = $('#ddlDoctorName').val();

            if (doctorID == '0') {
                modelAlert('Please Select Doctor First.');
                return false;
            }

            doctorID = doctorID == '0' ? '' : doctorID;

            var isDayWiseSelection = Number($('#ddlScheduleBy').val()) == 1 ? 1 : 0;
            var scheduleDate = $('#txtDoctorSchedulingDate').val();
            var scheduleDay = $('#ddlDoctorSchedulingDays').val();

            if (isDayWiseSelection)
                scheduleDate = '';
            else
                scheduleDay = '';

            getAllocatedSlotDetails(function (selectedSlots) {
                var alreadySelectedSlots = selectedSlots.slotLists.filter(function (s) { return s.id == 0 });
                _openOTScheduling({
                    allowMultipleOTSlotSelection: 1,
                    checkedDoctorBookedSlots: 1,
                    checkedPatientBookedSlots: 0,
                    doctorID: doctorID,
                    selectedSlots: alreadySelectedSlots,
                    isDayWiseSelection: isDayWiseSelection,
                    scheduleDate: scheduleDate,
                    scheduleDay: scheduleDay,
                    applyExpiredFilter: isDayWiseSelection > 0 ? 0 : 1,
                    isForDoctorSlotAllocation: 1,
                    filterDoctorSpecifiedSlot: 0
                }, function () {


                }, onSlotSelection);
            });
        }



        var onSlotSelection = function (data) {

            console.log(data);

            var scheduleBy = Number($('#ddlScheduleBy').val());
            var scheduleByDay = $('#ddlDays').val();
            var scheduleByDate = $('#txtDoctorSchedulingDate').val();
            var scheduleOnText = [];
            var divOTSlotList = $('#divOTSlotList')
            var alreadySelectedSlots = divOTSlotList.find('[id=0]');//.remove();

            for (var i = 0; i < data.slots.length; i++) {
                data.slots[i].isDayWiseSelection = data.slots[i].isDayWiseSelection;

                scheduleOnText = data.slots[i].scheduleOnText;
                for (var j = 0; j < scheduleOnText.length; j++) {

                    for (var k = 0; k < alreadySelectedSlots.length; k++) {
                        var alreadySelectedSlotsData = JSON.parse($(alreadySelectedSlots[k]).find('.tdData').text());
                        if (alreadySelectedSlotsData.scheduleOnText == scheduleOnText[j])
                            $(alreadySelectedSlots[k]).remove();
                    }

                    data.slots[i].scheduleOnText = scheduleOnText[j];
                    addOTSlotLists({ data: data.slots[i], value: 0, text: data.slots[i].OTName + ' : ' + data.slots[i].startTime + ' - ' + data.slots[i].endTime + ' ' + 'On ' + scheduleOnText[j] })
                }
            }
        }


        var addOTSlotLists = function (data) {

            var divOTSlotList = $('#divOTSlotList');
            divOTSlotList.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a><span class="hidden tdData">' + JSON.stringify(data.data) + '</span></li>');

        }

        var getAllocatedSlotDetails = function (callback) {

            var doctorID = $('#ddlDoctorName').val();

            if (doctorID == '0') {
                modelAlert('Please Select Doctor First.');
                return false;
            }


            var data = {
                doctorID: doctorID,
                slotLists: []
            };
            $('#divOTSlotList ul li .tdData').each(function () {
                var tdData = JSON.parse($(this).text());
                data.slotLists.push({
                    OTID: tdData.OTID,
                    startTime: tdData.startTime,
                    endTime: tdData.endTime,
                    id: tdData.id,
                    startSlotUniqueID: tdData.startSlotUniqueID,
                    endSlotUniqueID: tdData.endSlotUniqueID,
                    isDayWiseSelection: tdData.isDayWiseSelection,
                    scheduleOnText: tdData.scheduleOnText,
                });

            });

            callback(data);
        }


        var saveDoctorOTSlotAllocation = function (btnSave) {
            getAllocatedSlotDetails(function (data) {
                serverCall('OT_Master.aspx/SaveDoctorSlotAllocations', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.message, function () {
                        if (responseData.status)
                            window.location.reload();

                    });
                });
            });
        }




        var getDoctorBookedSlots = function (doctorID) {
            serverCall('OT_Master.aspx/GetDoctorBookedSlots', { doctorID: doctorID }, function (response) {
                var responseData = JSON.parse(response);
                var divOTSlotList = $('#divOTSlotList')
                divOTSlotList.find('ul li').remove();
                for (var i = 0; i < responseData.length; i++) {
                    debugger;
                    addOTSlotLists({ data: responseData[i], value: responseData[i].ID, text: responseData[i].Name + ' : ' + responseData[i].startTime + ' - ' + responseData[i].endTime + ' On ' + responseData[i].scheduleOnText })
                }
            });
        }



        var onScheduleByChange = function (el) {
            var scheduleBy = Number(el.value);

            if (scheduleBy == 2) {
                $('.scheduleByDate').removeClass('hidden');
                $('.scheduleByDay').addClass('hidden');

            }
            else {
                $('.scheduleByDay').removeClass('hidden');
                $('.scheduleByDate').addClass('hidden');
            }

        }

    </script>


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b>OT Master</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Create New OT
            </div>
           
            <div class="row">

                <div class="col-md-1"></div>
                <div class="col-md-22">
                     <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        OT Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtNewOT" class="requiredField" />
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        OT Start Time
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox runat="server" ClientIDMode="Static" ID="txtOTStartTime" CssClass="ItDoseTextinputNum requiredField"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtOTStartTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator ID="maskTimeStart" runat="server" ControlToValidate="txtOTStartTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>
                </div>


                <div class="col-md-3">
                    <label class="pull-left">
                        OT End Time
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox runat="server" ClientIDMode="Static" ID="txtOTEndTime" CssClass="ItDoseTextinputNum requiredField"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtOTEndTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtOTEndTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        OT/Slot In Mins
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtOTSlotMins" value="10" class="ItDoseTextinputNum requiredField" />
                </div>
            </div>

                </div>
                <div class="col-md-1"></div>


            </div>




        </div>

        <div class="POuter_Box_Inventory textCenter">
            <input type="button" value="Save" class="save margin-top-on-btn"  onclick="createOT(this)" />
        </div>


        <div class="POuter_Box_Inventory textCenter divExitingOT">
            <div class="Purchaseheader">
                Exiting OT
            </div>


            <div class="row"></div>

        </div>


         <div class="POuter_Box_Inventory textCenter">
            <div class="Purchaseheader">
                Doctor OT Scheduling
            </div>
           
             <div class="row">
                 <div class="col-md-1"></div>
                 <div class="col-md-22">

                     <div class="row">

                           <div class="col-md-3">
                                <label class="pull-left">
                                Doctor Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                           <div class="col-md-5">
                                <select id="ddlDoctorName"  onchange="getDoctorBookedSlots(this.value)" ></select>
                              </div>


                      


                         

                     </div>

                     <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                   Schedule By
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                         <div class="col-md-5">
                                <select id="ddlScheduleBy" onchange="onScheduleByChange(this)">
                                    <option value="1">Days</option>
                                    <option value="2">Date</option>
                                </select>
                          </div>



                          <div class="col-md-3 scheduleByDay">
                                <label class="pull-left">
                                   Select Day
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                         <div class="col-md-5 scheduleByDay">
                                <select id="ddlDoctorSchedulingDays">
                                    <option value="Mon">Mon</option>
                                    <option value="Tue">Tue</option>
                                    <option value="Wed">Wed</option>
                                    <option value="Thu">Thu</option>
                                    <option value="Fri">Fri</option>
                                    <option value="Sat">Sat</option>
                                    <option value="Sun">Sun</option>
                                </select>
                          </div>



                          <div class="col-md-3 hidden scheduleByDate">
                                <label class="pull-left">
                                   Select Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                         <div class="col-md-5 hidden scheduleByDate">
                                <asp:TextBox  runat="server" ClientIDMode="Static" ID="txtDoctorSchedulingDate"></asp:TextBox>
                                 <cc1:CalendarExtender runat="server" Id="calExtenderTxtDoctorSchedulingDate" Format="dd-MMM-yyyy" TargetControlID="txtDoctorSchedulingDate"></cc1:CalendarExtender>
                          </div>






                         <div class="col-md-3">
                                <label class="pull-left">
                                   Select  Schedule
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                         <div class="col-md-5">
                               <button  onclick="openOTScheduling();" id="btnOTAvailableSlots" type="button" class="pull-left" style="box-shadow : none;"><span id="spnOTAvailableSlotsCounts" class="badge badge-warning">0</span><b>Available OT Slots</b> </button> 
                           </div>
                     </div>


                     <div class="row">


                           <div class="col-md-3">
                                <label class="pull-left">
                                   Selected Schedule
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                           <div class="col-md-21">
                                <div id="divOTSlotList" class="chosen-container-multi">
                                <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                                </ul>
                                </div>
                           </div>
                     </div>




                 </div>
                 <div class="col-md-1"></div>
             </div>
             
                   
        </div>

         <div class="POuter_Box_Inventory textCenter">
             <input type="button" value="Save"  class="save margin-top-on-btn" onclick="saveDoctorOTSlotAllocation(this)"/>
         </div>


  <script id="template_exitingOTs" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblOldInvestigation" style="width:100%;border-collapse:collapse;">
		 

		<thead>
						   <tr  id='Header'>
								<th class='GridViewHeaderStyle'>#</th>
								<th class='GridViewHeaderStyle'>OT Name</th>
								<th class='GridViewHeaderStyle'>Start Time</th>
								<th class='GridViewHeaderStyle'>End Time</th>
								<th class='GridViewHeaderStyle'>Slots Durations</th>
                                <th class='GridViewHeaderStyle'>Created By</th>
                                <th class='GridViewHeaderStyle'>Created On</th>
                                <%--<th class='GridViewHeaderStyle'></th>--%>
						   </tr>
		</thead>
		 
		<tbody>

		<#
		var dataLength=responseData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{

		objRow = responseData[j];
		
		  #>
						<tr>
						    <td class="GridViewLabItemStyle tdIndex textCenter"><#=j+1#></td>
						    <td class="GridViewLabItemStyle"><#=objRow.Name#></td>
                            <td class="GridViewLabItemStyle"><#=objRow.StartTime#></td>
                            <td class="GridViewLabItemStyle"><#=objRow.EndTime#></td>
                            <td class="GridViewLabItemStyle"><#=objRow.SlotMins#></td>
                            <td class="GridViewLabItemStyle"><#=objRow.CreatedBy#></td>
                            <td class="GridViewLabItemStyle"><#=objRow.CreatedOn#></td>
                            <td class="GridViewLabItemStyle tdData hidden"><#=JSON.stringify(objRow)#></td>
                            <%--<td class="GridViewLabItemStyle">
                                <a href="javascript:void(0)">Edit</a>
                            </td>--%>
						</tr>   

			<#}#>
</tbody>
	 </table>    
	</script>

    </div>















<UC1:OTSchedulingControl ID="sch" runat="server"/>
</asp:Content>

