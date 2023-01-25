<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorTiming.aspx.cs" Inherits="Design_HelpDesk_DoctorTiming" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <style type="text/css">
        .slotDetails
        {
            height: 440px !important;
            overflow: auto !important;
        }
     </style>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            //$('#txtAppointmentSlotDate').change(function (e) {
            //    var $appointmentDate = (e.target.type == 'text' ? e.target.value : $('#txtAppointmentSlotDate').val());
            //    var appSlotMin = $('#ddlSolotMin').val();
            //    var centreID = 0;
            //    serverCall('../OPD/BookDirectAppointment.aspx/GetDoctorAppointmentTimeSlot', { DoctorId: $('.docid').val(), appointmentDate: $appointmentDate, appointmentType: 2, centreId: centreID, AppSlot: appSlotMin, IsManualSlot: 0 }, function (response) {
            //        var $responseData = JSON.parse(response);
            //        if ($responseData.status) {
            //            $('#divSlotAvailabilityBody').html($responseData.response);

            //            String.isNullOrEmpty($('.time').val()) ? ($('.time').val($responseData.defaultAvilableSlot)) : '';
            //            $('#divSlotAvailabilityBody div #spnAppointmentTime').each(function (index, elem) {
            //                if ($.trim($(elem).text()) == $responseData.defaultAvilableSlot)
            //                    $(elem).parent().addClass('badge-pink');
            //            });

            //            $('#txtAppointmentSlotDate').val($appointmentDate)
            //            $('#divSlotAvailability').showModel();

            //        }
            //        else {
            //            modelAlert($responseData.response, function () {
            //                clearAppointMentDetails();
            //            });

            //        }
            //    });


            //});

            $bindCentre(function () {
                $('#ddlDepartment,#ddlDoctor,#ddlSpecialization,#ddlCentre').chosen({ width: '100%' });
                searchDocTiming();
            });

            $('#txtAppointmentSlotDate,#ddlSolotMin').change(function () {
                var doctorID = $('#spnSelectedDoctorId').text();
                var appdate = $('#txtAppointmentSlotDate').val();
                var centerid = $("#spnSelectedCentre").text();
                var appSlotMin = $('#ddlSolotMin').val();
                var booktype = $("#spnBooktype").text();
                NextDateSlot(doctorID, appdate, centerid, appSlotMin, booktype);
               // var isSlotWiseToken = $('#spnSelectedDoctorIsSlotWiseToken').text();
                //$getDoctorAppointmentTimeSlot2(doctorID, 1, false, isSlotWiseToken, function (response) { });
            });
        });

        function NextDateSlot(DoctorId, AppDate, centreID, appSlotMin, booktype) {
            serverCall('../OPD/Lab_PrescriptionOPD.aspx/GetDoctorAppointmentTimeSlotConsecutive', { DoctorId: DoctorId, _appointmentDate: AppDate, appointmentType: 2, centreId: centreID, AppSlot: appSlotMin, IsManualSlot: 0 }, function (response) {
                var responseData = JSON.parse(response);

                var divSlotAvailabilityBody = $('#divSlotAvailabilityBody').find('.slotDetails');
                var divSlotAvailabilityHead = $('#divSlotAvailabilityBody').find('.patientInfo');
                for (var i = 0; i < responseData.response.length; i++) {
                    $(divSlotAvailabilityHead[i]).text(responseData.response[i].appointmentDate);
                    $(divSlotAvailabilityBody[i]).html(responseData.response[i].response);
                }

                //var $responseData = JSON.parse(response);

                var $responseData = responseData.response[0];

                if ($responseData.status) {
                    // $('#divSlotAvailabilityBody').html($responseData.response);

                    // String.isNullOrEmpty(time) ? (time = $responseData.defaultAvilableSlot) : '';

                    $('#divSlotAvailabilityBody div #spnAppointmentTime').each(function (index, elem) {
                        //if ($.trim($(elem).text()) == $responseData.defaultAvilableSlot)
                        //    $(elem).parent().addClass('badge-pink');
                        if ($.trim($(elem).text()) == $responseData.defaultAvilableSlot) {
                            var currentAppointmentDate = $(elem).closest('.col-md-5').find('.patientInfo').text();
                            var defaultAppointmentDate = $('#txtAppointmentSlotDate').val();
                            if (defaultAppointmentDate == currentAppointmentDate)
                                $(elem).parent().addClass('badge-pink');
                        }
                    });

                    if (booktype == '1')
                        $('.badge-avilable,.badge-pink,.badge-grey,.badge-info').parent().remove();

                    if (booktype == '2')
                        $('.badge-pink,.badge-grey,.badge-info,.badge-yellow,.badge-purple').parent().remove();

                    //$('#txtAppointmentSlotDate').val(AppDate)
                    $('#divSlotAvailability').showModel();

                    MarcTooltips.add('div .badge-avilable', 'Select Slot for Block', {
                        position: 'up',
                        align: 'left'
                    });
                }
                else {
                    modelAlert($responseData.response, function () {
                        clearAppointMentDetails();
                    });

                }
            });
        }

        var $bindCentre = function (callback) {
            serverCall('Services/HelpDesk.asmx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                $Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: '<%= ViewState["CentreID"].ToString() %>' });
                $bindDoctor($Centre.val(), function () {
                    callback($Centre.find('option:selected').text());
                });
            });
        }
        var $bindDoctor = function (centreId, callback) {
            serverCall('DoctorTiming.aspx/bindDoctorCentrewise', { CentreID: centreId, Department: $('#ddlDepartment').val(), Specilization: $('#ddlSpecialization option:selected').text() }, function (response) {
                $Centre = $('#ddlDoctor');
                $Centre.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($Centre.find('option:selected').text());
            });
        }
        function searchDocTiming() {
            $("#lblErrormsg").text('');
            if (Number($("#ddlCentre").val()) == "0")
            {
                $("#lblErrormsg").text('Please Select Centre !!!');
                return false;
            }

            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/doctorTimingDetail",
                data: '{doctorID:"' + $("#ddlDoctor").val() + '",Department:"' + $("#ddlDepartment").val() + '",Specialization:"' + $("#ddlSpecialization option:selected").text() + '",Centre:"' + $("#ddlCentre").val() + '",Date:"' + $("#txtAppDate").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    DocTiming = jQuery.parseJSON(response.d);
                    if (DocTiming != null) {
                        var output = $('#tb_DocTiming').parseTemplate(DocTiming);
                        $('#DocTimingOutput').html(output).customFixedHeader();;
                        $('#DocTimingOutput').show();
                        MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                    }
                    else {
                        DisplayMsg('MM04', 'lblErrormsg');
                        $('#DocTimingOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        function TotalSlot(el,booktype) {
            clearAppointMentDetails();
            var rowID = $(el).closest('tr');
            var DoctorId = $(rowID).find('#tddoctorid').text();
            var AppDate = $(rowID).find('#tdAppDate').text();
            var starttime = $(rowID).find('#tdstarttime').text();
            var endtime = $(rowID).find('#tdendtime').text();
            var centreID = $(rowID).find('#tdCentreID').text();
            var time = starttime + '-' + endtime;
            var doctorname = $(rowID).find('#tdDoctorName').text();//
            var dname = $(rowID).find('#tdDName').text();//
            if (doctorname == "") {
                $("#spnSelectedDoctor").text(dname);
            }
            else { $("#spnSelectedDoctor").text(doctorname);}//
            $("#spnSelectedDoctorId").text(DoctorId);
            $("#spnSelectedAppDate").text(AppDate);
            $("#spnSelectedstarttime").text(starttime);
            $("#spnSelectedendtime").text(endtime);
            $("#spnSelectedCentre").text(centreID);
            $('.time').val(time);
            $('.docid').val($(rowID).find('#tddoctorid').text());
            var appSlotMin = $('#ddlSolotMin').val();
            $("#spnBooktype").text(booktype);
            serverCall('../OPD/Lab_PrescriptionOPD.aspx/GetDoctorAppointmentTimeSlotConsecutive', { DoctorId: DoctorId, _appointmentDate: AppDate, appointmentType: 2, centreId: centreID, AppSlot: appSlotMin, IsManualSlot: 0 }, function (response) {

                var responseData = JSON.parse(response);

                var divSlotAvailabilityBody = $('#divSlotAvailabilityBody').find('.slotDetails');
                var divSlotAvailabilityHead = $('#divSlotAvailabilityBody').find('.patientInfo');
                for (var i = 0; i < responseData.response.length; i++) {
                    $(divSlotAvailabilityHead[i]).text(responseData.response[i].appointmentDate);
                    $(divSlotAvailabilityBody[i]).html(responseData.response[i].response);
                }

                //var $responseData = JSON.parse(response);

                var $responseData = responseData.response[0];

                if ($responseData.status) {
                   // $('#divSlotAvailabilityBody').html($responseData.response);

                   // String.isNullOrEmpty(time) ? (time = $responseData.defaultAvilableSlot) : '';

                    $('#divSlotAvailabilityBody div #spnAppointmentTime').each(function (index, elem) {
                        //if ($.trim($(elem).text()) == $responseData.defaultAvilableSlot)
                        //    $(elem).parent().addClass('badge-pink');
                        if ($.trim($(elem).text()) == $responseData.defaultAvilableSlot) {
                            var currentAppointmentDate = $(elem).closest('.col-md-5').find('.patientInfo').text();
                            var defaultAppointmentDate = $('#txtAppointmentSlotDate').val();
                            if (defaultAppointmentDate == currentAppointmentDate)
                                $(elem).parent().addClass('badge-pink');
                        }
                    });

                    if (booktype == '1')
                        $('.badge-avilable,.badge-pink,.badge-grey,.badge-info').parent().remove();

                    if (booktype == '2')
                        $('.badge-pink,.badge-grey,.badge-info,.badge-yellow,.badge-purple').parent().remove();

                    //$('#txtAppointmentSlotDate').val(AppDate)
                    $('#divSlotAvailability').showModel();

                    MarcTooltips.add('div .badge-avilable', 'Select Slot for Block', {
                        position: 'up',
                        align: 'left'
                    });
                }
                else {
                    modelAlert($responseData.response, function () {
                        clearAppointMentDetails();
                    });

                }
            });
        }
        var clearAppointMentDetails = function () {
            // $('#divSlotAvailabilityBody').html('');
            $('#divSlotAvailabilityBody').find('.slotDetails').html('');
            $('#divSlotAvailabilityBody').find('.patientInfo').html('');
        }
        var $selectSlot = function (elem) {
            $('#divSlotAvailabilityBody .circle').removeClass('badge-pink');
            $(elem).addClass('badge-pink');
        }

        var onNextPrevDateChange = function (addDays, callback) {
            var data = {
                selectedDate: $('#txtAppointmentSlotDate').val(),
                addDays: addDays
            };
            onNextPreDataBind(data, function () { });

        }

        var onNextPreDataBind = function (data) {
            serverCall('../OPD/Lab_PrescriptionOPD.aspx/NextPrevDate', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    $('#txtAppointmentSlotDate').val(responseData.calculatedAppointmentDate).change();
                else {
                    modelAlert(responseData.message, function () { });
                }
            });
        }

        var $dobuleClick = function (elem) {
            //  alert($.trim($(elem).find('#spnAppointmentTime').text()));
            var slotTiming = $(elem).closest('.slotDetails').prev().text() + '_' + $.trim($(elem).find('#spnAppointmentTime').text());
            var slotTimingDisplay = $(elem).closest('.slotDetails').prev().text() + ' ' + $.trim($(elem).find('#spnAppointmentTime').text());
            $CheckAuthorization(function (responce) {
                if (responce == "0") {
                    modelAlert("You are not authorized");
                }
                else {
                    BookAppointment($.trim($(elem).find('#spnAppointmentTime').text()), slotTiming, slotTimingDisplay);
                }
            });
        }
        function BookAppointment(selectedSlot, slotTiming, slotTimingDisplay) {
            var DoctorId = $("#spnSelectedDoctorId").text();
            var Centre = Number($("#spnSelectedCentre").text());
            var BackUrl = '../HelpDesk/DoctorTiming.aspx';

            getItemIDByDoctorID(DoctorId,Centre, function (DoctorItemID) {
                var s = '../OPD/Lab_PrescriptionOPD.aspx?itemId=' + DoctorItemID + '&centreId=' + Centre + '&helpDeskBooking=1&backUrl=' + BackUrl + '&SlotTiming=' + slotTiming + '&SlotTimingDisplay=' + slotTimingDisplay;//BookDirectAppointment.aspx
                window.location = s;
            });
           
        }


        var getItemIDByDoctorID = function (doctorID, CentreID,callback) {
            data = {
                SubCategoryID: '<%=Resources.Resource.FirstVisitSubCategoryID%>',
                DoctorID: Number(doctorID),
                centreID: CentreID 
            }
            serverCall('../common/CommonService.asmx/GetItemIDBySubCategoryIDAndDoctorID', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    callback(responseData.DoctorItemID);
                else {
                    modelAlert(responseData.DoctorItemID);
                    return false;
                }
            });
        }
        var $CheckAuthorization = function (callback) {
            serverCall('../common/CommonService.asmx/CheckAuthorization', {}, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData.data);
            });
        }
    </script>
     <script type="text/javascript">
         function PrintDoctorSticker(rowid) {
             var NoofPrint = $(rowid).closest('tr').find("#txtPrint").val();
             var DoctorName = $(rowid).closest('tr').find(".tdDoctorName").text();
             var Department = $(rowid).closest('tr').find(".tdDepartment").text();
             var Degree = $(rowid).closest('tr').find("#tdDegree").text();
             var data = "";
             if (NoofPrint != 0 && NoofPrint != "") {
                 var Ok = confirm("Do you Want To Print (" + NoofPrint + ") Sticker of " + DoctorName);
                 if (Ok == true) {

                     for (var i = 0; i < NoofPrint; i++) {
                         data = data + "" + (data == "" ? "" : "^") + DoctorName + "#" + Department + "#" + Degree;
                     }
                     // alert(data);
                     window.location = 'barcode://?cmd=' + data + '&test=1&source=Barcode_Source_Doctor';
                 }
                 else
                     return false;
             }
             else
                 alert("Please Enter No of printOut at Least 1");
         }
         function checkprintOut(rowid) {
             var PrintOut = $.trim($(rowid).closest('tr').find("#txtPrint").val());
             if (PrintOut > 10) {
                 $(rowid).closest('tr').find("#txtPrint").val('1');
                 alert("Not more than 10");
                 return false;
             }
         }
         function onlyNumeric(element, evt) {
             var charCode = (evt.which) ? evt.which : event.keyCode
             if (
                 (charCode < 48 || charCode > 57) && (charCode != 8)) {
                 alert('Enter Numeric Value Only');
                 return false;
             }
             else {
                 $("#lblMsg").text(' ');
                 return true;
             }
         }

    </script>
      <%--Time Slot Availability Templates--%>
   <input type="hidden" class="docid" value="0" />
    <input type="hidden" class="time" value="0" />
    <div id="Pbody_box_inventory">
         <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Doctor Detail</b><br />

            <asp:Label ID="lblErrormsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Centre  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:DropDownList ID="ddlCentre" onchange="$bindDoctor($('#ddlCentre').val(),function(){});" runat="server" ClientIDMode="Static" disabled="disabled">
                        </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Specialization   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlSpecialization" runat="server" ClientIDMode="Static" onchange=" $bindDoctor($('#ddlCentre').val(), function () {});">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Department   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static" onchange=" $bindDoctor($('#ddlCentre').val(), function () {});">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                  <div class="col-md-3">
                    <label class="pull-left"> Doctor </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:DropDownList ID="ddlDoctor" runat="server" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtAppDate" ReadOnly="true" runat="server" ToolTip="Select Appointment Date" ClientIDMode="Static" ></asp:TextBox>
                            <cc1:calendarextender ID="cdAppDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtAppDate" />
                                                                                                                   
                </div>              
                <div class="col-md-8">
                   
                    <div class="danger" style=" background-color: #a1f986;border-left: 6px solid #298c0b;">
              <p><strong>&nbsp;Note!</strong>  Click on Avail. Slots for doctor appointment.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Click on Total Slots & Booked Slots for view Status.</p></div></div>
              </div>
            </div>
         <div class="POuter_Box_Inventory"  style="text-align:center;">
                     <input type="button" value="Search" class="ItDoseButton" onclick="searchDocTiming()" />
        </div>
         <div class="POuter_Box_Inventory">
                <div id="DocTimingOutput" style="max-height: 400px; overflow-x: auto;">
                    </div>
        </div>
    </div>
    <div class="modal-body">
				<div style="max-height:200px"  class="row">
					<div id="divOnline" style="max-height:190px;overflow:auto" class="col-md-24">
					</div>
				</div>
			</div>
   <script id="tb_DocTiming" type="text/html">

       <table  id="tableApp" cellspacing="0" class="yui" style="width:100%;border-collapse:collapse;">
            <thead>
		   <tr class="tblTitle" id="Header">
			    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
               <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Centre</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Doctor Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Mobile</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Department</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Specialization</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Room No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Floor</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Day</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Shift</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:170px;">Start Time</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:170px;">End Time</th>		
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Total Slots</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Booked Slots</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Avail. Slots</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">DoctorID</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">AppDate</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none">No. of Print</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none"></th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">DoctorDegree</th>
               <th class="GridViewHeaderStyle" scope="col" style="display:none">CentreID</th>
		    </tr></thead>
            <#       
            var dataLength=DocTiming.length;
            window.status="Total Records Found :"+ dataLength;
            var objRow;   
            for(var j=0;j<dataLength;j++)
            {       
            objRow = DocTiming[j];
            #> <tbody>
                        <tr  id="<#=j+1#>" >                            
                        <td  data-title="<#=objRow.Rate#>"  class="GridViewLabItemStyle" style="width:10px;"><input type="hidden" value="<#=objRow.DoctorID#>" class="doctorid" /><#=j+1#>
                        </td>
                              <#
    if(j>0)
      {
        if(DocTiming[j].CentreID !=DocTiming[j-1].CentreID)
         {#> 
              <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" style="width:300px;"><#=objRow.CentreName#></td>
         <#}
      else
        {#>
              <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"  style="width:300px;"></td>
        <#}

        if(DocTiming[j].DoctorID!=DocTiming[j-1].DoctorID)
        {#>    
                     <td class="GridViewLabItemStyle tdDoctorName" id="tdDName" data-title="<#=objRow.Rate#>"  style="width:300px;text-align:center" ><#=objRow.DName#></td>
                      <td class="GridViewLabItemStyle" id="tdMobile" data-title="<#=objRow.Rate#>"  ><#=objRow.Mobile#></td>
                        <td class="GridViewLabItemStyle tdDepartment" data-title="<#=objRow.Rate#>" id="tdDepartment"  style="width:200px;text-align:left" ><#=objRow.Department#></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdSpecialization"  style="width:200px;" ><#=objRow.Specialization#></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdRoomNo" style="width:80px;"><#=objRow.Room_No#></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdDocFloor" style="width:80px;"><#=objRow.DocFloor#></td>
        <#}
        else
        {#>
                            
                       <td class="GridViewLabItemStyle tdDoctorName" data-title="<#=objRow.Rate#>"  style="width:300px;text-align:center" ></td>
                       <td class="GridViewLabItemStyle tdDepartment" data-title="<#=objRow.Rate#>"   ></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"   style="width:200px;text-align:left" ></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"   style="width:200px;" ></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"  style="width:80px;"></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"  style="width:80px;"></td>
        <#}

       if(DocTiming[j].Day!=DocTiming[j-1].Day)
         {#> 
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="td6" style="width:90px;"><#=objRow.Day#></td>
         <#}
      else
        {#>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"  style="width:90px;"></td>
        <#}
      }
    else
        {#>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" style="width:300px;"><#=objRow.CentreName#></td>
                        <td class="GridViewLabItemStyle tdDoctorName" id="tdDoctorName" data-title="<#=objRow.Rate#>"   style="width:300px;text-align:center" ><#=objRow.DName#></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"  ><#=objRow.Mobile#></td>
                        <td class="GridViewLabItemStyle tdDepartment" data-title="<#=objRow.Rate#>"   style="width:200px;text-align:left" ><#=objRow.Department#></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"   style="width:200px;" ><#=objRow.Specialization#></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" style="width:180px;"><#=objRow.Room_No#></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" style="width:180px;"><#=objRow.DocFloor#></td>
                        <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="td1" style="width:90px;"><#=objRow.Day#></td>
        <#}
        #>
         
                            <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>"  id="tdshift" style="width:200px;" ><#=objRow.ShiftName#></td>
                            <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdstarttime" style="width:170px;"><#=objRow.StartTime#></td>
                            <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdendtime" style="width:170px;"><#=objRow.EndTime#></td>
                            <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdtotalslots" onclick="TotalSlot(this,0);" style="width:200px; text-align:center;background-color:yellow; font-weight:bold;color:black;"><#=objRow.TotalSlots#></td>
                            <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdbooked" onclick="TotalSlot(this,1);" style="width:200px;text-align:center;background-color:purple; font-weight:bold;color:white;"><#=objRow.Booked#></td>
                            <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdAvailslots" onclick="TotalSlot(this,2);" style="width:200px; background-color:green; color:white; font-weight:bold;text-align:center;"><#=objRow.TotalSlots - objRow.Booked #></td>
                            <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tddoctorid" style="display:none;"><#=objRow.DoctorID#></td>
                            <td class="GridViewLabItemStyle" data-title="<#=objRow.Rate#>" id="tdAppDate" style="display:none;"><#=objRow.AppDate#></td>
                            <td class="GridViewLabItemStyle"  style="width:10px;display:none"><input type="text" id="txtPrint" value="1" style="width:30px" class="ItDoseTextinputNum" onkeypress="return onlyNumeric(this,event)" onkeyup="return checkprintOut(this)" /></td>             
                            <td class="GridViewLabItemStyle"  style="width:10px;display:none"><img src="../../Images/print.gif"  style="cursor:pointer" onclick="PrintDoctorSticker(this)"/></td>
                         <td class="GridViewLabItemStyle"  id="tdDegree" style="width:180px;text-align:center;display:none"><#=objRow.Degree#></td>
                             <td class="GridViewLabItemStyle"  id="tdCentreID" style="text-align:center;display:none"><#=objRow.CentreID#></td>
                        </tr>            
            <#}        
            #>      
         </tbody></table>  

    </script>
    
      <%--Doctor Time Slot Availability Model--%>
    <div id="divSlotAvailability"   class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 1250px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSlotAvailability" aria-hidden="true">&times;</button>

                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Appointment Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtAppointmentSlotDate" runat="server" Style="width: 172px" ClientIDMode="Static" ToolTip="Select Booking Date"></asp:TextBox>
                            <asp:Label ID="lblAppointmentCurrentDate" runat="server" Style="display: none;" ClientIDMode="Static"></asp:Label>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtAppointmentSlotDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-1">
                            <button type="button" onclick="onNextPrevDateChange('-1',function(){})">Prev</button>
                        </div>
                        <div class="col-md-1">
                            <button type="button" onclick="onNextPrevDateChange('1',function(){})">Next</button>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Doctor </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnSelectedDoctor" class="patientInfo" style="font-weight: bold"></span>
                            <span id="spnSelectedDoctorId" style="display: none"></span>
                            <span id="spnSelectedDoctorIsSlotWiseToken" style="display: none"></span>
                            <span id="spnSelectedAppDate" style="display:none;"></span>
                            <span id="spnSelectedstarttime" style="display:none;"></span>
                            <span id="spnSelectedendtime" style="display:none;"></span>
                            <span id="spnSelectedCentre" style="display:none;"></span>
                            <span id="spnBooktype" style="display:none;"></span>
                        </div>
                        <div class="col-md-2" style="display:none">
                            <select id="ddlSolotMin">
                                <option value="5">5 Min</option>
                                <option value="10">10 Min</option>
                                <option value="15">15 Min</option>
                                <option value="20">20 Min</option>
                                <option value="25">25 Min</option>
                                <option value="30">30 Min</option>
                                <option value="35">35 Min</option>
                                <option value="40">40 Min</option>
                                <option value="45">45 Min</option>
                                <option value="50">50 Min</option>
                                <option value="55">55 Min</option>
                                <option value="60">60 Min</option>
                            </select>
                        </div>
                    </div>
                    
                   </div>
                <div class="modal-body">
                   <div id="divSlotAvailabilityBody" style="padding-left: 30px;width:1250px;">
                       <div class="row">
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="patientInfo bold textCenter"></div>
                                <div class="slotDetails">
                                </div>
                            </div>
                        </div>
                   </div>
                </div>
                <div class="modal-footer">
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-avilable"></button><b style="float:left;margin-top:5px;margin-left:5px">Avilable</b> 
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-yellow"></button><b style="float:left;margin-top:5px;margin-left:5px">Booked</b>  
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-purple"></button><b style="float:left;margin-top:5px;margin-left:5px">Confirmed</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-pink"></button><b style="float:left;margin-top:5px;margin-left:5px">Selected</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-grey"></button><b style="float:left;margin-top:5px;margin-left:5px">Expired</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-info"></button><b style="float:left;margin-top:5px;margin-left:5px">Mobile</b>

                    <button type="button"  data-dismiss="divSlotAvailability">Close</button>
                    
                </div>
            </div>
        </div>
   </div>
   
</asp:Content>

