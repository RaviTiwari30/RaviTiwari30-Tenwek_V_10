<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="OTPatientSearch.aspx.cs" Inherits="Design_OT_OTPatientSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OT Patient Search</b><br />
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
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientID" tabindex="1" autocomplete="off" data-title="Enter UHID" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtName" tabindex="2" autocomplete="off" data-title="Enter Patient Name" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctor" title="Select Doctor" tabindex="3"></select>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                OT Booking No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtOTBookingNo" tabindex="4" autocomplete="off" data-title="Enter OT Booking No." />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                OT
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlOT" title="Select OT" tabindex="5"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtTransactionNo" tabindex="6" autocomplete="off" maxlength="10" data-title="Enter IPD No." />

                        </div>
                    </div>
                    <div class="row">


                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Confirm Date" ReadOnly="true" ClientIDMode="Static" TabIndex="7"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true" ClientIDMode="Static" TabIndex="8" ToolTip="Click To Select To Confirm Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Received
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlReceived" runat="server" TabIndex="9" ClientIDMode="Static">
                                <asp:ListItem Value="2" Selected="True">All</asp:ListItem>
                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No </asp:ListItem>
                            </asp:DropDownList>

                        </div>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-11">
                </div>
                <div class="col-md-2">
                    <input type="button" class="ItDoseButton" title="Click to Search Patient" tabindex="10" value="Search" id="btnSearch" onclick="bindOTPatientData(2, function () { })" />
                </div>
                <div class="col-md-11">
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div style="text-align: center; display: block" class="col-md-5">
                            <button type="button" onclick="bindOTPatientData(0,function () { })" title="Click To Search Only Patient Not Received" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #d699ff;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Patient Not Received</b>
                        </div>
                        <div style="text-align: center; display: block" class="col-md-5">
                            <button type="button" onclick="bindOTPatientData(1,function () { })" title="Click To Search Only Patient Received" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #90ee90;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Patient Received</b>
                        </div>

                         <div style="text-align: center; display: block" class="col-md-5">
                            <button type="button" onclick="bindOTPatientData(3,function () { })" title="Click To Search Only Patient Received" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color:pink;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">IPD Not Map</b>
                        </div>
                        <div class="col-md-3"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div id="OTPatientDetailOutput" style="height: 280px; width: 100%; overflow-y: auto"></div>
        </div>
    </div>


      <div id="divBookingConfirmationDetails" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 800px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divBookingConfirmationDetails" aria-hidden="true">×</button>
                    <h4 class="modal-title">Booking Confirmation Details</h4>
                    <label class="lblBookingConfirmationData hidden"></label>
                    <label class="lblIPDPatientDetailsData hidden"></label>
                    <label class="lblbookingid hidden"></label>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                OT Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11" >
                            <label class="patientInfo lblOTNumber"></label>
                        </div>
                        <div class="col-md-4" >
                            <label class="pull-left">
                                Map IPD Patient
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5" >
                            <select id="ddlIPDPatient" class="requiredField" onchange="onAdmitPatientSelect(this,function(){})"></select>
                        </div>
                    </div>

                    <div class="row">

                        <div class="col-md-4" >
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11" >
                            <label class="patientInfo lblPatientName"></label>
                        </div>
                        <div class="col-md-4" >
                            <label class="pull-left">
                                Age
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5" >
                            <label class="patientInfo lblAge"></label>
                        </div>

                       

                    </div>


                    <div class="row">
                        <div class="col-md-4" >
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11" >
                            <label class="patientInfo lblDoctor"></label>
                        </div>

                         <div class="col-md-4" >
                            <label class="pull-left">
                                Gender
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5" >
                            <label class="patientInfo lblGender"></label>
                        </div>
                      
                    </div>

                    <div class="row">
                        <div class="col-md-4" >
                            <label class="pull-left">
                                Ward/Room No 
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11" >
                               <label class="patientInfo lblWardRoomNo"></label>
                        </div> 

                         

                          <div class="col-md-4">
                            <label class="pull-left">
                                Contact
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5" >
                            <label class="patientInfo lblContactNo"></label>
                        </div>

                    </div>
                       <div class="row">
                        <div class="col-md-4" >
                            <label class="pull-left">
                               Address 
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-20" >
                               <label class="patientInfo lbladdress"></label>
                        </div> 
                           </div>

                    <div class="row" style="display:none">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Equipment 
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11">
                            <select id="ddlEquipment"></select>
                        </div>

                        <div class="col-md-4">
                            <label class="pull-left">
                                Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <input type="text" class="txtEquipmentQuantity ItDoseTextinputNum requiredField" placeholder="Enter To Add"   onlynumber="2" decimalplace="0" max-value="99" onkeyup="addEquipmentOnBooking(event,this,function(){})" />
                        </div>
                        


                    </div>


                    


                    <div class="row" style="display:none">
                           <div class="col-md-4">
                            <label class="pull-left">
                                Equipment's
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-20">
                            <div id="divEquipmentDetails" class="chosen-container-multi">
                                <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0;min-height: 150px;max-height:250px;overflow:auto" class="chosen-choices"></ul>
                                </div>
                        </div>
                    </div>

                  <%--  <div class="row">
                           <div class="col-md-4">
                            <label class="pull-left">
                                Remark
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-20">
                            <textarea cols="" rows="" style="min-height:29px;max-height:29px;height:29px;min-width:634px;max-width:634px;width:634px" class="txtConfirmationRemarks"></textarea>
                        </div>
                    </div>--%>

                </div>
                <div class="modal-footer">
                    <button type="button" class="save" onclick="_confirmBooking(this)">Save</button>
                    <button type="button" class="save" data-dismiss="divBookingConfirmationDetails">Close</button>
                </div>
            </div>
        </div>
    </div>

    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>
    <script type="text/javascript">


        var _confirmBooking = function (btnSave) {
            debugger;
            //getSelectedEquipmentDetails(function (e) {
                var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
                var selectedPatientIPDNo = divBookingConfirmationDetails.find('#ddlIPDPatient').val();
                if (selectedPatientIPDNo == '0') {
                    modelAlert('Please Select Admitted Patient.', function () {
                        divBookingConfirmationDetails.find('#ddlIPDPatient').focus();
                    });

                    return false;
                }
              //  var bookingData = JSON.parse(divBookingConfirmationDetails.find('.lblBookingConfirmationData').text());
                var patientDetails = JSON.parse(divBookingConfirmationDetails.find('.lblIPDPatientDetailsData').text());
                var bookingid=divBookingConfirmationDetails.find('.lblbookingid').text();
                var data = {
                   
                    patientID:  patientDetails.PatientID,
                    PatientName:patientDetails.PatientName,
                    Age:patientDetails.Age,
                    Gender:patientDetails.Gender,
                    Address:patientDetails.Address,
                    ContactNo:patientDetails.Phone,
                    transactionID: patientDetails.TransactionID,
                    bookingID: bookingid
                }
                $(btnSave).attr('disabled', true).text('Submitting...');
                serverCall('Services/OTBooking.asmx/mappatientid', data, function (response) {
                    var responseData = JSON.parse(response);
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            window.location.reload();
                        }
                        else
                            $(btnSave).removeAttr('disabled').text('Save');
                    });
                });
          //  });
        }





        var getAdmittedPatient = function (data, callback) {
            serverCall('Services/OTBooking.asmx/GetAdmittedPatient', data, function (response) {
                var responseData = JSON.parse(response);
                var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
                divBookingConfirmationDetails.find('#ddlIPDPatient').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'TransactionID', textField: 'TransactionID', isSearchAble: true, selectedValue: 'Select' });
                callback(responseData);
            });
        }
        var validateExpiredBooking = function (data, callback) {
            serverCall('Services/OTBooking.asmx/ValidateExpiredBooking', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    callback()
                else
                    modelAlert(responseData.response, function () {

                    });

            });
        }

        var confirmBooking = function (otBookingID, otnumber, PatientID) {
            var bookingid = otBookingID// JSON.parse($(el).closest('tr').find('.tdData').text());
            // validateExpiredBooking({ bookingID:bookingID }, function () {
            getAdmittedPatient({ patientID: PatientID }, function () {

                //var params = {
                //    scheduleDate: tdData.SurgeryDate,
                //    startTime: tdData.SlotFromTime,
                //    endTime: tdData.SlotToTime,
                //};
                //getEquipments(params, function (response) {
                var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
                divBookingConfirmationDetails.find('#ddlIPDPatient').val('0');
                //    divBookingConfirmationDetails.find('#divEquipmentDetails ul li').remove();
                onAdmitPatientSelect(divBookingConfirmationDetails.find('#ddlIPDPatient')[0], function () {

                    divBookingConfirmationDetails.find('.lblOTNumber').text(otnumber);
                    divBookingConfirmationDetails.find('.lblbookingid').text(otBookingID);
                    //divBookingConfirmationDetails.find('.lblBookingConfirmationData').text(JSON.stringify(tdData));
                    divBookingConfirmationDetails.showModel();
                    //});
                    //});
                });
                if (PatientID!="") {                    
                    $('#ddlIPDPatient').val($('#ddlIPDPatient option').eq(1).val()).chosen('destroy').chosen({ width: "100%" });

                    onAdmitPatientSelectAutomatically($('#ddlIPDPatient option').eq(1).val(), function () {

                        divBookingConfirmationDetails.find('.lblOTNumber').text(otnumber);
                        divBookingConfirmationDetails.find('.lblbookingid').text(otBookingID);
                        //divBookingConfirmationDetails.find('.lblBookingConfirmationData').text(JSON.stringify(tdData));
                        divBookingConfirmationDetails.showModel();

                    })
                }
               

            });
        }

        var onAdmitPatientSelect = function (el, callback) {

            //var selectedIPD = 'ISHHI' + el.value;
            var selectedIPD = el.value;
            var data = {
                transactionID: selectedIPD
            };
            getAdmitPatientDetails(data, function (p) {
                bindSelectedIPDDetails(p, function () {
                    callback();
                });
            });
        }


        var onAdmitPatientSelectAutomatically = function (val, callback) {

            //var selectedIPD = 'ISHHI' + el.value;
            var selectedIPD =val;
            var data = {
                transactionID: selectedIPD
            };
            getAdmitPatientDetails(data, function (p) {
                bindSelectedIPDDetails(p, function () {
                    callback();
                });
            });
        }


        var getAdmitPatientDetails = function (data, callback) {
            serverCall('Services/OTBooking.asmx/GetAdmitPatientDetails', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0)
                    callback(responseData[0]);
                else
                    callback({ PatientName: '', Age: '', DoctorName: '', Gender: '', BedDetail: '', Phone: '',Address:'' });

            });

        }


        var bindSelectedIPDDetails = function (data, callback) {
            var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
            divBookingConfirmationDetails.find('.lblPatientName').text(data.PatientName);
            divBookingConfirmationDetails.find('.lblAge').text(data.Age);
            divBookingConfirmationDetails.find('.lblDoctor').text(data.DoctorName);
            divBookingConfirmationDetails.find('.lblGender').text(data.Gender);
            divBookingConfirmationDetails.find('.lblWardRoomNo').text(data.BedDetail);
            divBookingConfirmationDetails.find('.lblContactNo').text(data.Phone);
            divBookingConfirmationDetails.find('.lbladdress').text(data.Address);
            divBookingConfirmationDetails.find('.lblIPDPatientDetailsData').text(JSON.stringify(data));
            callback();
        }


        var checkIsReceived = function (elem) {
            var closestTr = $(elem).closest('tr');
            var IsReceived = $.trim(closestTr.find('.hdnselect').val());
            var otBookingID = $.trim(closestTr.find('.hdnOTBookingID').val());
            var PatientID = $.trim(closestTr.find('#tdPatientID').text());
            var ipdno = $.trim(closestTr.find('#tdIPDNo').text());
            var otnumber = $.trim(closestTr.find('#tdOTNumber').text());
            var URL = $.trim(closestTr.find('.hdnredirect').val());
            if (ipdno == "") {
                confirmBooking(otBookingID, otnumber, PatientID);
            }
            else if (IsReceived == 0) {
                modelConfirmation('Alert!!!', 'Do You Want To Receive Patient?', 'YES', 'NO', function (response) {
                    if (response) {
                        serverCall('OTPatientSearch.aspx/ReceivedOTPatient', { otBookingID: otBookingID }, function (response) {
                            var $responseData = JSON.parse(response);
                            modelAlert($responseData.response, function () {
                                //   closestTr.remove();
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
            var row = elem;
            iframe.onload = function () {
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.display = '';
                try {
                    var contentDocument = document.getElementById("iframePatient").contentDocument;
                    contentDocument.getElementById('lblPatientName').innerHTML = row.find('#tdPName').text();
                    contentDocument.getElementById('lblPatientID').innerHTML = row.find('#tdPatientID').text();
                    contentDocument.getElementById('lblIPDNo').innerHTML = row.find('#tdIPDNo').text();
                    contentDocument.getElementById('lblOTNumber').innerHTML = row.find('#tdOTNumber').text();
                    contentDocument.getElementById('lblAgeSex').innerHTML = row.find('#tdAgeSex').text();
                    contentDocument.getElementById('lblOTName').innerHTML = row.find('#tdOTName').text();
                    contentDocument.getElementById('lblSurgeryName').innerHTML = row.find('#tdSurgeryName').text();
                    contentDocument.getElementById('lblSurgeryDate').innerHTML = row.find('#tdSurgeryDate').text();
                    contentDocument.getElementById('lblSurgeryTiming').innerHTML = row.find('#tdSurgeryTiming').text();

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
    <script type="text/javascript">
        $(document).ready(function () {
            bindDoctor(function () {
                bindOT(function () {
                    bindOTPatientData(2,function () { });
                });
            });
        });

        var bindDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: "ALL" }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }


        var bindOT = function (callback) {
            var $ddlOT = $('#ddlOT');
            serverCall('OTPatientSearch.aspx/bindOT', {}, function (response) {
                $ddlOT.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true });
                callback($ddlOT.val());
            });
        }
        var bindOTPatientData = function (searchType, callback) {
            var isMap = 0;

            var IsReceived = searchType;
            if (searchType != 2)
                IsReceived = searchType;
            else 
                IsReceived = Number($("#ddlReceived").val());


            if (searchType == 3) {
                isMap = 1
                IsReceived = 2
            }

            data = {
                UHID: $("#txtPatientID").val(),
                IPDNo: $("#txtTransactionNo").val(),
                PatientName: $("#txtName").val(),
                DoctorID: $("#ddlDoctor").val(),
                BookingOTNo: $("#txtOTBookingNo").val(),
                OTID: Number($("#ddlOT").val()),
                FromDate: $("#txtFromDate").val(),
                ToDate: $("#txtToDate").val(),
                isReceived: IsReceived,
                isMap: isMap
            }
            serverCall('OTPatientSearch.aspx/GetOTPatientSearchData', data, function (response) {
                OTPatient = JSON.parse(response);
                var message = $('#tb_OTPatientDetail').parseTemplate(OTPatient);
                $('#OTPatientDetailOutput').html(message);
                callback(true);
            });
        }
    </script>
    
         <script id="tb_OTPatientDetail" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOTPatientDetail" style="width:100%; border-collapse: collapse;">
            <thead>

            <tr id="TrHead">
                <th class="GridViewHeaderStyle" scope="col" >S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Select</th>
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >IPD No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
                <th class="GridViewHeaderStyle" scope="col" style=" display:none;" >Age/Sex</th>
                <th class="GridViewHeaderStyle" scope="col" >OT Booking No.</th>
                <th class="GridViewHeaderStyle" scope="col" >OT Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Doctor Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none;" >Surgery Name</th>
                <th class="GridViewHeaderStyle" scope="col" >OT Date</th>
                <th class="GridViewHeaderStyle" scope="col" >OT Timing</th>
                <th class="GridViewHeaderStyle" scope="col" >Confirmed Date</th>
                
            </tr>
                </thead><tbody>
        <#       
        var dataLength=OTPatient.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = OTPatient[j];
        #>
               <tr id="TrBody" 
                 <#if(objRow.IPDNo==""){#>
					style="background-color:#ffc0cb"
				<#}
                   else if(objRow.IsPatientReceived=="0") {#>
					style="background-color:#d699ff"
				<#}
                   
                   else {#>
					style="background-color:#90EE90"
				<#}#>
                   >        
                   <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
                   <td class="GridViewLabItemStyle" style="text-align:center">
                        <a  href="javascript:void(0)" class="btnselect" onclick="checkIsReceived(this)"  >
                        <input type="hidden" value="<#=objRow.IsPatientReceived#>" class="hdnselect" />
                        <input type="hidden" value="<#=objRow.OTBookingID#>" class="hdnOTBookingID" />
                        <input type="hidden" value="OTFolder.aspx?TID=<#=objRow.TransactionID#>&amp;&amp;IsPatientReceived=<#=objRow.IsPatientReceived#>&amp;OTNumber=<#=objRow.OTNumber#>&amp;PID=<#=objRow.PatientID#>&amp;SurgeryID=<#=objRow.SurgeryID#>&amp;OTID=<#=objRow.OTID#>&amp;OTBookingID=<#=objRow.OTBookingID#>" class="hdnredirect" />
					   <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" id="imgframe"/>
					 </a>
                   </td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:80px;" id="tdPatientID"><#=objRow.PatientID #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:80px;" id="tdIPDNo"><#=objRow.IPDNo #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center; width:200px;" id="tdPName"><#=objRow.PName #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:100px; display:none;" id="tdAgeSex"><#=objRow.AgeSex #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:185px;" id="tdOTNumber"><#=objRow.OTNumber #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center; width:150px;" id="tdOTName"><#=objRow.OTName #></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;width:200px;" id="tdDoctorName"><#=objRow.DoctorName #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:100px; display:none;" id="tdSurgeryName"><#=objRow.SurgeryName #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center; width:100px;" id="tdSurgeryDate"><#=objRow.SurgeryDate #></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;width:200px;" id="tdSurgeryTiming"><#=objRow.SurgeryTiming #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:100px;" id="tdConfirmedDate"><#=objRow.ConfirmedDate #></td>
               </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>
</asp:Content>

