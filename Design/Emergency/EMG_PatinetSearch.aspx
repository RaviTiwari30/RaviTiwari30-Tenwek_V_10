<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EMG_PatinetSearch.aspx.cs" Inherits="Design_Emergency_EMG_PatinetSearch" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	 <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
		<script type="text/javascript">
		    var dataRoom = [];
		    var dataFloor = [];

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
		    jQuery(function () {
		        $('#txtPatientID').focus();
		        //getDepartment();
		        //BindFloor();
		        //bindRoomType();
		        //bindAdmissionDoctor();
		        bindPanel();
		        bindTriagingCodes();
		        bindWaitingMaster();
		    });

		    function getDepartment() {
		        var ddlDepartment = jQuery("#ddlDepartment");
		        jQuery("#ddlDepartment option").remove();
		        var department = {
		            type: "POST",
		            url: "../Common/CommonService.asmx/bindDepartment",
		            data: '{ }',
		            contentType: "application/json; charset=utf-8",
		            dataType: "json",
		            async: false,
		            success: function (result) {
		                department = jQuery.parseJSON(result.d);
		                if (department != null) {
		                    ddlDepartment.chosen('destroy');
		                    ddlDepartment.append(jQuery("<option></option>").val("ALL").html("ALL"));
		                    if (department.length == 0) {
		                        ddlDepartment.append(jQuery("<option></option>").val("ALL").html("---No Data Found---"));
		                    }
		                    else {
		                        for (i = 0; i < department.length; i++) {
		                            ddlDepartment.append(jQuery("<option></option>").val(department[i].ID).html(department[i].Name));
		                        }
		                    }
		                    ddlDepartment.chosen();
		                }
		            },
		            error: function (xhr, ajaxOptions, thrownError) {
		                jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
		            }
		        };
		        jQuery.ajax(department);
		    }

		    function BindFloor() {
		        var ddlFloor = jQuery("#ddlFloor");
		        jQuery("#ddlFloor option").remove();
		        var Floor = {
		            type: "POST",
		            url: "../IPD/PatientSearch.aspx/BindFloor",
		            data: '{ }',
		            contentType: "application/json; charset=utf-8",
		            dataType: "json",
		            async: false,
		            success: function (result) {
		                Floor = jQuery.parseJSON(result.d);
		                if (Floor != null) {
		                    ddlFloor.chosen('destroy');
		                    ddlFloor.append(jQuery("<option></option>").val("0").html("ALL"));
		                    if (Floor.length == 0) {
		                        ddlFloor.append(jQuery("<option></option>").val("0").html("---No Data Found---"));
		                    }
		                    else {

		                        for (i = 0; i < Floor.length; i++) {
		                            ddlFloor.append(jQuery("<option></option>").val(Floor[i].ID).html(Floor[i].NAME));
		                            dataFloor.push(Floor[i].ID);
		                            if (Floor.length == 1)
		                                ddlFloor.val(Floor[i].ID).attr('disabled', 'disabled');
		                        }
		                    }
		                    ddlFloor.chosen();
		                }
		            },
		            error: function (xhr, ajaxOptions, thrownError) {
		                jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
		            }
		        };
		        jQuery.ajax(Floor);
		    }

		    function bindRoomType() {
		        jQuery("#cmbRoom option").remove();
		        jQuery.ajax({
		            url: "EMG_PatinetSearch.aspx/BindEmergencyRoomType",
		            data: '{FloorID:"' + $('#ddlFloor').val() + '"}',
		            type: "Post",
		            contentType: "application/json; charset=utf-8",
		            timeout: 120000,
		            async: false,
		            dataType: "json",
		            success: function (result) {
		                RoomData = jQuery.parseJSON(result.d);
		                $("#cmbRoom").append($("<option></option>").val("0").html("ALL"));
		                $("#cmbRoom").chosen('destroy');
		                for (i = 0; i < RoomData.length; i++) {
		                    $("#cmbRoom").append($("<option></option>").val(RoomData[i].IPDCaseType_ID).html(RoomData[i].Name));
		                    dataRoom.push(RoomData[i].IPDCaseType_ID);
		                    if (RoomData.length == 1)
		                        $("#cmbRoom").val(RoomData[i].IPDCaseType_ID).attr('disabled', 'disabled');
		                }
		                $('#cmbRoom').chosen();
		            },
		            error: function (xhr, status) {
		            }
		        });
		    }

		    function bindAdmissionDoctor() {
		        jQuery("#ddlDoctor option").remove();
		        jQuery.ajax({
		            url: "../common/CommonService.asmx/bindEmergencyDoctor",
		            data: '{}',
		            type: "Post",
		            contentType: "application/json; charset=utf-8",
		            timeout: 120000,
		            async: false,
		            dataType: "json",
		            success: function (result) {
		                Data = jQuery.parseJSON(result.d);
		                $("#ddlDoctor").append($("<option></option>").val("0").html("ALL"));
		                $("#ddlDoctor").chosen('destroy');
		                for (i = 0; i < Data.length; i++) {
		                    $("#ddlDoctor").append($("<option></option>").val(Data[i].DoctorID).html(Data[i].Name));
		                }
		                $("#ddlDoctor").chosen()
		            },
		            error: function (xhr, status) {
		            }
		        });
		    }

		    function bindPanel() {
		        jQuery("#ddlParentPanel option").remove();
		        jQuery("#ddlPanel option").remove();
		        jQuery.ajax({
		            url: "../IPD/Services/IPDAdmission.asmx/bindPanelRoleWisePanelGroupWise",
		            data: '{}',
		            type: "Post",
		            contentType: "application/json; charset=utf-8",
		            timeout: 120000,
		            async: false,
		            dataType: "json",
		            success: function (result) {
		                Data = jQuery.parseJSON(result.d);
		                if (Data != null) {
		                    if (Data != '') {
		                        $("#ddlParentPanel,#ddlPanel").chosen('destroy');
		                        $("#ddlParentPanel").append($("<option></option>").val("0").html("ALL"));
		                        $("#ddlPanel").append($("<option></option>").val("0").html("ALL"));
		                        for (i = 0; i < Data.length; i++) {
		                            $("#ddlParentPanel").append($("<option></option>").val(Data[i].PanelID).html(Data[i].Company_Name));
		                            $("#ddlPanel").append($("<option></option>").val(Data[i].PanelID).html(Data[i].Company_Name));
		                        }
		                        $("#ddlParentPanel,#ddlPanel").chosen();
		                    }
		                }
		                else {
		                    $("#ddlParentPanel").append($("<option></option>").val("0").html("--No Panel Found--"));
		                }
		            },
		            error: function (xhr, status) {
		            }
		        });
		    }

		    function CheckCreditCase() {
		        if ($('#chkCreditCase').is(':checked'))
		            $('#ddlPanel').val('0').attr('disabled', 'disabled');
		        else
		            $('#ddlPanel').val('0').removeAttr('disabled');
		    }

		    function bindTriagingCodes() {
		        serverCall('Services/EmergencyAdmission.asmx/GetTriagingCodes', {}, function (response) {
		            var responseData = JSON.parse(response);
		            var ddlTriaging = $('#ddlTriageCode');
		            ddlTriaging.append($(new Option).val(0).text('Select'));
		            for (var i = 0; i < responseData.length; i++) {
		                ddlTriaging.append($(new Option).val(responseData[i].ID).text(responseData[i].ID).css('background-color', responseData[i].ColorCode));
		            }
		        });
		    }
		    function bindWaitingMaster() {
		        serverCall('EMG_PatinetSearch.aspx/getWaitingType', {}, function (response) {
		            var responseData = JSON.parse(response);
		            var ddlWaitingType = $('#ddlWaitingType');
		            ddlWaitingType.append($(new Option).val(0).text('Select'));
		        //    ddlWaitingType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'WaitingType', isSearchAble: true });
		            for (var i = 0; i < responseData.length; i++) {

		                ddlWaitingType.append($(new Option).val(responseData[i].ID).text(responseData[i].WaitingType).css('background-color', responseData[i].WaitingColorCode));
		            }
		        });
		    }
		    
		 
		    
		    function ChkDate() {
		        serverCall('../common/CommonService.asmx/CompareDate', { DateFrom: $('#ucFromDate').val(), DateTo: $('#ucToDate').val() }, function (response) {
		            if (!response) {
		                modelAlert('To date can not be less than from date!', function () {
		                    $('#btnSearch').attr('disabled', 'disabled');
		                });
		            } else {
		                $('#btnSearch').removeAttr('disabled');
		            }
		        });
		    }
	</script>
	<div id="Pbody_box_inventory">
	   <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Emergency Patient Search</b><br />
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
							<input type="text" id="txtPatientID" onkeyup="if(event.keyCode==13){Search(0);};" data-title="Enter UHID" tabindex="1" />
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Patient Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text" id="txtName" onkeyup="if(event.keyCode==13){Search(0);};" tabindex="1" data-title="Enter Patient Name" />
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								Emergency No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtEmergencyNo" runat="server" ClientIDMode="Static" MaxLength="20" TabIndex="9" data-title="Enter Emergency No." onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>
						
						</div>
					</div>
					
					  <div class="row">
					  
						  <div class="col-md-3">
							<label class="pull-left">
								<input type="checkbox" id="chkCreditCase" style="display:none" title="Click To Search Only Credit Patient" onclick="CheckCreditCase()" />
								Panel
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select id="ddlPanel"  title="Select Panel" tabindex="11" onkeyup="if(event.keyCode==13){Search(0);};"></select>
						   <%-- <select id="ddlParentPanel"  title="Select Parent Panel"  tabindex="12" onkeyup="if(event.keyCode==13){Search(0);};"></select>--%>
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								From Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						 <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ReadOnly="true"  ClientIDMode="Static" TabIndex="13" onkeyup="if(event.keyCode==13){Search(0);};" onchange="ChkDate();"></asp:TextBox>
						<cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
						   <div class="col-md-3">
							<label class="pull-left">
								To Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						<asp:TextBox ID="ucToDate" runat="server"   ReadOnly="true"  onkeyup="if(event.keyCode==13){Search(0);};" ClientIDMode="Static" TabIndex="14" ToolTip="Click To Select To Date" onchange="ChkDate();"></asp:TextBox>
						<cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
					</div>
					  <div class="row">
                         <div class="col-md-3">
							<label class="pull-left">
							Acuity Level
							</label>
							  <b class="pull-right">:</b>
						 </div>
					 <div class="col-md-5">
                         <select id="ddlTriageCode" title="Select Triage Code"></select>
                         </div>
                            <div class="col-md-3">
							<label class="pull-left">
							Waiting Type
							</label>
							  <b class="pull-right">:</b>
						 </div>
					 <div class="col-md-5">
                         <select id="ddlWaitingType" title="Select Waiting"></select>
                         </div>
					</div>
					<div class="row">
						 <div class="col-md-3">
							<label class="pull-left">
								Status
							</label>
							  <b class="pull-right">:</b>
						 </div>
					 <div class="col-md-21">
						 <asp:RadioButtonList ID="rblStatus" runat="server" CssClass="ItDoseLblSpBl" RepeatDirection="Horizontal" ClientIDMode="Static" TabIndex="15" RepeatLayout="Flow">
							<asp:ListItem Text="All Emergency Patient" Value="IN" Selected="True"></asp:ListItem>
                             <asp:ListItem Text="Emergency Admission" Value="Admission"></asp:ListItem>
							<asp:ListItem Text="Released Patient" Value="OUT"></asp:ListItem>
                             <asp:ListItem Text="Released For IPD" Value="RFI"></asp:ListItem>
                             <asp:ListItem Text="Shifted To IPD" Value="STI"></asp:ListItem>
						</asp:RadioButtonList>
					</div>
						 </div>
					
					  <div class="row">
						 <div class="col-md-11">
						 </div>
						  <div class="col-md-2">
								<input type="button" class="ItDoseButton"  title="Click to Search Patient" tabindex="16" value="Search" id="btnSearch" onclick="Search('All')" />
						 </div>
						  <div class="col-md-11">
						 </div>
					  </div>
					<div class="row"></div>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>
		<div class="POuter_Box_Inventory">
			   <div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3"></div>
						<div style="text-align:center" class="col-md-5">
							<button type="button" onclick="Search('IN')" title="Click To Search Only Emergency Admitted Patient" style="width:25px;height:25px;margin-left:5px;float:left;background-color:white;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Currently Admitted</b> 
						</div>
						<div style="text-align:center" class="col-md-5">
							<button type="button" onclick="Search('OUT')" title="Click To Search Only Released Patient" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #90ee90;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Released Patient</b> 
						</div>
                        <div style="text-align:center" class="col-md-5">
							<button type="button" onclick="Search('RFI')" title="Click To Search Only Released For IPD" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #ee90e7;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Released For IPD</b> 
						</div>
                        <div style="text-align:center" class="col-md-5">
							<button type="button" onclick="Search('STI')" title="Click To Search Only Shifted To IPD" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #a5f7e0;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Shifted To IPD</b> 
						</div>
						<div class="col-md-1"></div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>
		<div class="POuter_Box_Inventory">
				<div id="IPDOutput" style="height:280px;width:100%;overflow-y:auto;overflow-x:auto"> </div>
		</div>
	</div>
	<iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>
	<script type="text/javascript">
	    function Search(id) {
	        $Status = $('#rblStatus').find(':checked').val();
	        if (id != 'All')
	            $Status = id;


	        $("#btnSearch").attr("disabled", "disabled");

	        $("#lblMsg").text('');
	        $.ajax({
	            type: "POST",
	            url: "EMG_PatinetSearch.aspx/PatientSearch",
	            data: '{MRNo:"' + $.trim($("#txtPatientID").val()) + '",PName:"' + $.trim($("#txtName").val()) + '",EmergencyNo:"' + $.trim($('#txtEmergencyNo').val()) + '",PanelId:"' + $('#ddlPanel').val() + '",fromDate:"' + $('#ucFromDate').val() + '",toDate:"' + $('#ucToDate').val() + '",Status:"' + $Status + '",TriageCode:"' + $('#ddlTriageCode').val() + '",WaitingType:"' + $('#ddlWaitingType').val() + '"}',
	            dataType: "json",
	            contentType: "application/json;charset=UTF-8",
	            async: true,
	            success: function (response) {
	                IPD = jQuery.parseJSON(response.d);
	                if (IPD != null) {
	                    var output = $('#tb_Search').parseTemplate(IPD);
	                    $('#IPDOutput').html(output).customFixedHeader();
	                    //$('#divAppointmentDetails').customFixedHeader();
	                    $('#IPDOutput').show();
	                    $("#btnSearch").removeAttr("disabled");
	                    $("#lblMsg").text("Total Records Found :" + IPD.length);
	                }
	                else {
	                    $('#IPDOutput').hide();

	                    $("#lblMsg").text('No Record Found');
	                }
	                $("#btnSearch").val('Search').removeAttr("disabled");
	            },
	            error: function (xhr, status) {
	                $("#btnSearch").val('Search').removeAttr("disabled");
	            }
	        });
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
	                contentDocument.getElementById('lblPatientName').innerHTML = row.find('#tdPName').text();
	                contentDocument.getElementById('lblDoctorName').innerHTML = row.find('#tdDoctor').text();
	                localStorage.setItem("doctorid", row.find('#tdDoctorID').text());
	               // $('#ddlDoctor').val(row.find('#tdDoctorID').text()).chosen();
	                contentDocument.getElementById('lblPatientID').innerHTML = row.find('#tdPatientID').text();
	                contentDocument.getElementById('lblEMGNo').innerHTML = row.find('#tdEMGNo').text();
	                contentDocument.getElementById('lblRoomNo').innerHTML = row.find('#tdRoom').text();
	                contentDocument.getElementById('lblPanel').innerHTML = row.find('#tdPanel').text();
	                contentDocument.getElementById('lblGender').innerHTML = row.find('#tdSex').text().split('/')[1];
	                contentDocument.getElementById('lblAge').innerHTML = row.find('#tdSex').text().split('/')[0];
	                contentDocument.getElementById('lblDOB').innerHTML = row.find('#tdDOB').text();
	                contentDocument.getElementById('lblAdmitDate').innerHTML = row.find('#tdInDateTime').text();
	                contentDocument.getElementById('lblDischargeDate').innerHTML = row.find('#tdDischargeDateTime').text();
	                contentDocument.getElementById('txtTID').value = row.find('#tdTransactionID').text();
	                contentDocument.getElementById('txtLTnxNo').value = row.find('#tdLTnxNo').text();
	                contentDocument.getElementById('txtStatus').value = row.find('#tdstatus').text();
	                contentDocument.getElementById('txtRoomId').value = row.find('#tdRoomId').text();
	                contentDocument.getElementById('lblPatientCode').innerHTML = row.find('#tdPatientCode').text();
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

	    function ViewDischargeSummary(rowid) {
	        var TID = $.trim(jQuery(rowid).closest("tr").find("#tdTransactionID").text());
	        var status = $.trim(jQuery(rowid).closest("tr").find("#tdstatus").text());

	        //window.open('../../Design/EMR/printDischargeReport_pdf.aspx?TID=' + TID + '&Status=' + status + '&ReportType=PDF');

	        window.open('../../Design/EMR/DischargeReportNew.aspx?TID=' + TID + '&Status=' + status + '&ReportType=PDF');
	    }

	    function checkProvisionalDiagnosis(trasnaction_ID) {
	        var flag = true;
	        $.ajax({
	            url: "../common/CommonService.asmx/checkProvisionalDiagnosis",
	            data: '{trasnaction_ID:"' + trasnaction_ID + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                if (result.d == "0") {
	                    alert("Please Enter Diagnosis & Treatment Given in the Diagnosis page before proceeding to Print Summary");
	                    flag = false;
	                }
	            },
	            error: function (xhr, status) {
	                $("#lblMsg").text("Error occurred, Please contact administrator");
	                flag = false;
	            }
	        });
	        return flag;
	    }


	    var printSticker = function (elem) {
	        var closestTr = $(elem).closest('tr');
	        var patientID = $.trim(closestTr.find('#tdPatientID').text());
	        var transactionID = $.trim(closestTr.find('#tdTransactionID').text());
	        serverCall('PatientSearch.aspx/PrintSticker', { patientID: patientID, TID: transactionID }, function (response) {
	            var responseData = JSON.parse(response);
	            if (responseData.status)
	                window.open(responseData.response)
	            else
	                modelAlert(responseData.response);
	        });

	    }

	    var $ReleaseForIPD = function (sender) {
	        modelConfirmation('Alert!!!', 'Do You Want To Release Patient For IPD ?', 'Release', 'Close', function (response) {
	            if (response) {
	                $TID = $(sender).closest('tr').find('#tdTransactionID').text();
	                $EMGNo = $(sender).closest('tr').find('#tdEMGNo').text();
	                $RoomId = $(sender).closest('tr').find('#tdRoomId').text();
	                serverCall('Services/EmergencyBilling.asmx/RelaseForIPD', { TID: $TID, EMGNo: $EMGNo, RoomId: $RoomId }, function (response) {
	                    var $responseData = JSON.parse(response);
	                    modelAlert($responseData.response, function () {
	                        if ($responseData.status)
	                            location.reload();
	                    });
	                });
	            }
	        });


	    }
	    function Getdischargesummary(tid){
	        window.open('../../Design/Emergency/Report/EmergencyDischargeReport.aspx?TID=' + tid);
	    }

	  

	</script>
    <iframe id="iframe1" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>
	<script type="text/javascript">
	    //=====By Amit====
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
        </script>
	<script id="tb_Search" type="text/html">
		<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdIPD" style="width:100%;border-collapse:collapse;">
			<thead>
			<tr id="Header">
				<th class="GridViewHeaderStyle" scope="col">Select</th>
                <th class="GridViewHeaderStyle" scope="col">Bed</th>
                <th class="GridViewHeaderStyle" scope="col">UHID</th>
                <th class="GridViewHeaderStyle" scope="col">Patient Name</th>
                <th class="GridViewHeaderStyle" scope="col">Age/Sex</th>
                <th class="GridViewHeaderStyle" scope="col">Complaint</th>
                <th class="GridViewHeaderStyle" scope="col">A</th>
                <th class="GridViewHeaderStyle" scope="col">TT</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">MOA</th>
                <th class="GridViewHeaderStyle" scope="col">RN</th>
                <th class="GridViewHeaderStyle" scope="col">ATT</th>
                <th class="GridViewHeaderStyle" scope="col">R/M</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">SCR</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">Unack</th>
                <th class="GridViewHeaderStyle" scope="col">Lab Stat</th>
                <th class="GridViewHeaderStyle" scope="col">Img Stat</th>
                <th class="GridViewHeaderStyle" scope="col">Consult stat</th>
                <th class="GridViewHeaderStyle" scope="col">Waiting Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">dispo</th>
                <th class="GridViewHeaderStyle" scope="col"  style="width:60px;display:none">Pending Services</th>
				<th class="GridViewHeaderStyle" scope="col">Received Date Time</th>
                <%--<th class="GridViewHeaderStyle" scope="col">Received Date Time</th>--%>
                <th class="GridViewHeaderStyle" scope="col" style="width:300px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vital&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                  <th class="GridViewHeaderStyle" scope="col" style="display:none;">Alert</th>
                <th class="GridViewHeaderStyle" scope="col">Shortcuts</th>
                
				<th class="GridViewHeaderStyle" style="width: 70px;" scope="col">Emergency No.</th>
                <th class="GridViewHeaderStyle" style="width: 70px;" scope="col">AdmittedBy</th>
				
				
				
				<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">Panel</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">Release For IPD</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">TransactionID</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">LedgerTransactionNo</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">Status</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">Patient Code</th>
			</tr>
				</thead>
			<#       
				var dataLength=IPD.length;
				window.status="Total Records Found :"+ dataLength;
				var objRow;   
				var status;
				for(var j=0;j<dataLength;j++)
				{       
					objRow = IPD[j];
			#>
			<tbody>
			<tr id="<#=j+1#>" 
				<#if(objRow.Status=="IN"){#>
					<%--style="background-color:#a179ef"--%>
                <#}else if(objRow.Status=="OUT"){#>
                    style="background-color:#90ee90"
                <#}else if(objRow.Status=="RFI"){#>
                    style="background-color:#ee90e7"
				<#}else{#>
					style="background-color:#a5f7e0"
				<#}#>
			 > 
				<td class="GridViewLabItemStyle" style="text-align:center" >
                       <a  href="javascript:void(0)" class="btnselect" onclick="checkIsReceived(this)"  >
                        <input type="hidden" value="<#=objRow.Ispatientreceived#>" class="hdnselect" />
                        <input type="hidden" value="<#=objRow.TID#>" class="hdnTID" />
                        <input type="hidden" value="IPFolder.aspx?TID=<#=objRow.TID#>&amp;PID=<#=objRow.PatientID#>&amp;EMGNo=<#=objRow.EmergencyNo#>&amp;LTnxNo=<#=objRow.LTnxNo#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;RoomID=<#=objRow.RoomId#>" class="hdnredirect" />
                        <img alt="Select" src="../../Images/Post.gif" <#if(objRow.Status=="STI"){#> style="display:none;"<#}else{#>style="border: 0px solid #FFFFFF;" <#}#> id="imgframe"/>
					 </a>
					 <%--<a target="iframePatient" onclick="reseizeIframe(this);"  href="IPFolder.aspx?TID=<#=objRow.TID#>&amp;PID=<#=objRow.PatientID#>&amp;EMGNo=<#=objRow.EmergencyNo#>&amp;LTnxNo=<#=objRow.LTnxNo#>&amp;App_ID=<#=objRow.App_ID#>" >
					   
					 </a> --%>                                                                                       
				</td>
                		<td class="GridViewLabItemStyle" id="td8" ><#=objRow.Room#></td>
                		<td class="GridViewLabItemStyle" id="tdPatientID"   ><#=objRow.PatientID#></td>
                		<td class="GridViewLabItemStyle" id="tdPName" ><#=objRow.Name#></td>
                <td class="GridViewLabItemStyle" id="tdSex" ><#=objRow.AgeSex#></td>
                    <td class="GridViewLabItemStyle" id="td9" ><#=objRow.Complaint#></td>
                <td class="GridViewLabItemStyle" style="width:100px;" scope="col"
                    style='text-align:center;background-color:<#= objRow.ColorCode #>'
                    >
                    <#=objRow.ColorSeq#>
                    <%--</br>
                    <#=objRow.CodeType#>--%>

                </td>
                <td class="GridViewLabItemStyle" id="td10" ><#=objRow.TT#></td>  
                <td class="GridViewLabItemStyle" id="td11"  style="width:60px;display:none"></td>   
                 <td class="GridViewLabItemStyle" id="tdnurseassign" ><#=objRow.NurseName#></td>
                <td class="GridViewLabItemStyle" id="tdDoctorID" style="display:none;"><#=objRow.DoctorID#></td>
                   <td class="GridViewLabItemStyle" id="tdDoctor" ><#=objRow.Doctor#></td>
                <td class="GridViewLabItemStyle" id="tdMediResiDoc"><#=objRow.MedicResidenceDoc#></td>
                <td class="GridViewLabItemStyle" id="td13" style="width:60px;display:none" ></td>
                <td class="GridViewLabItemStyle" id="td14" style="width:60px;display:none" ></td>
                <td class="GridViewLabItemStyle" id="td15" ><#=objRow.v1#>/<#=objRow.v3#></td>
                <td class="GridViewLabItemStyle" id="td16" ><#=objRow.v2#>/<#=objRow.v5#></td>
                <td class="GridViewLabItemStyle" id="td17" style='background-color:<#=objRow.WaitingColorCode#>' ><#=objRow.WaitingType#></td>
                <td class="GridViewLabItemStyle" id="tdwatingType"><img alt="Select" src="../../Images/Post.gif" onclick="WaitingType(this);" id="imgWaitngType"/></td>
                <td class="GridViewLabItemStyle" id="td18"  style="width:60px;display:none"></td>
                <td class="GridViewLabItemStyle textCenter" id="td1"  style="width:60px;display:none" >
                     <img alt="Select" title="View Summary." src="../../Images/view.GIF" onclick="Getdischargesummary('<#=objRow.TID#>')" />
                    <#if(objRow.MedPending !="0"){#> 
					 <img alt="Select" title="View Pending Medicines." src="../../Images/Post.gif"   onclick="getPendingMedicines(this);" />
                    <#}else{#>
                    <img alt="Select" title="View Pending Medicines." src="../../Images/Post.gif" style="display:none;" />
                    <#}#>
                    <#if(objRow.TestPending !="0"){#> 
                     <img alt="Select" title="View Pending Services/Investigations." src="../../Images/Post.gif"  onclick="getPendingInvestigationAndServices(this);"/>
                     <#}else{#>
                     <img alt="Select" title="View Pending Services/Investigations." src="../../Images/Post.gif" style="display:none;"/>
                    <#}#>
                </td>
                <td class="GridViewLabItemStyle" id="tdInDateTime"  ><#=objRow.PatientReceiveddate#></td>
                <%--<td class="GridViewLabItemStyle" id="td2"  ><#=objRow.PatientReceiveddate#></td>--%>
		
                <td class="GridViewLabItemStyle" id="tdVital"  style="width:300px;"  >Temp:<#=objRow.Temp#>,Pulse: <#=objRow.Pulse#>,BP:<#=objRow.BP#>,Resp:<#=objRow.RESP#>,SPO2:<#=objRow.SPO2#> </td> 
                

               
				<td class="GridViewLabItemStyle" id="tdTransactionID" style="width:60px;display:none;"><#=objRow.Alert#></td>  
                 <td  class="GridViewLabItemStyle" style="width:200px;" >                                 
               <%-- <a target="pagecontent" class='<%# Eval("ClassDoctorNoteBlink") %>' id='<#=objRow.PatientID#>' name="a"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../Emergency/Investigation.aspx?TID=<#=objRow.TID#>&amp;TransactionId=<#=objRow.TID#>&amp;PID=<#=objRow.PatientID#>&amp;PatientId=<#=objRow.PatientID#>&amp;EMGNo=<#=objRow.EmergencyNo#>&amp;LTnxNo=<#=objRow.LTnxNo#>&amp;App_ID=&amp;LnxNo=<#=objRow.LTnxNo#>', 1400, 360, '73%', '90%');" style="color:yellow;" >Doctor</a>--%>
               <%-- <a target="pagecontent" class='<%# Eval("ClassNursingNoteBlink") %>'  id='A1'  name="b"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/NursingProgress.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TID#>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Nursing</a>--%>
                <a target="pagecontent" class='<%# Eval("ClassLabsBlink") %>'  id='A2'  name="c" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../Lab/ViewLabReportsWard.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TID#>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Labs</a>
                <a target="pagecontent" class='<%# Eval("ClassMedBlink") %>'  id='A4' name="e"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/PatientRequisitionSearch.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TID#>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Meds</a>
               <%-- <a target="pagecontent" class='<%# Eval("ClassIOBlink") %>'  id='A6'  name="g" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/IntakeOutPutChart.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TID#>', 1050, 1050, '73%', '90%');" style="color:yellow;" >I/O</a>--%>
                 <a target="pagecontent" class='<%# Eval("ClassFlowSheetsBlink") %>'  id='A7'  name="h"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/FlowSheetView.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<%# Eval("TransactionID") %>', 1050, 1050, '73%', '90%');" style="color:yellow;" >FlowSheets</a><br />

                 </td>
				<td class="GridViewLabItemStyle" id="tdEMGNo" ><#=objRow.EmergencyNo#></td>
                <td class="GridViewLabItemStyle" id="td2" ><#=objRow.AdmittedBy#></td>
		
				
				
               
              <%--  <td class="GridViewLabItemStyle" id="tdDischargeDateTime"><#=objRow.ReleasedDateTime#></td>--%>
				<td class="GridViewLabItemStyle" id="tdPanel"  style="width:60px;display:none"><#=objRow.Panel#></td> 
                 <td class="GridViewLabItemStyle" style="text-align:center; display:none " >
					 <img alt="Select" src="../../Images/Post.gif" <#if(objRow.Status!="IN" || objRow.BillNo!="" || objRow.CentreID =="2"){#>style="display:none;"<#}else{#>style="border: 0px solid #FFFFFF;" <#}#> id="imgShiftToIPD" onclick="$ReleaseForIPD(this);"/>
				</td>                      
				<td class="GridViewLabItemStyle" id="tdTID" style="width:60px;display:none"><#=objRow.TID#></td>                     
				<td class="GridViewLabItemStyle" id="tdLTnxNo" style="width:60px;display:none"><#=objRow.LTnxNo#></td>    
				<td class="GridViewLabItemStyle" id="tdstatus"  style="width:60px;display:none" ><#=objRow.Status#></td>
                <td class="GridViewLabItemStyle" id="tdRoom"  style="width:60px;display:none" ><#=objRow.Room#></td>
                <td class="GridViewLabItemStyle" id="tdRoomId"  style="width:60px;display:none" ><#=objRow.Room_Id#></td>  
                <td class="GridViewLabItemStyle" id="tdDOB"  style="width:60px;display:none" ><#=objRow.DOB#></td>   
                <td class="GridViewLabItemStyle" id="tdPatientCode"  style="width:60px;display:none" ><#=objRow.PatientCode#></td>                                                                     
			</tr>     
			</tbody>      
			<#}#>       
		</table>    
	</script>
    
    
    
    
    
    
    
    <script id="templateInvestigationAndServices" type="text/html">
		<table class="FixedTables" cellspacing="0" rules="all" border="1" id="Table1" style="width:100%;border-collapse:collapse;">
			<thead>
			<tr id="Tr1">
				<th class="GridViewHeaderStyle" scope="col">#</th>
                <th class="GridViewHeaderStyle" scope="col">Date</th>
                <th class="GridViewHeaderStyle" scope="col">ItemName</th>
                <th class="GridViewHeaderStyle" scope="col">Quantity</th>
				<th class="GridViewHeaderStyle" scope="col">Doctor Name</th>
			</tr>
				</thead>
			<#       
				var dataLength=responseData.length;
				window.status="Total Records Found :"+ dataLength;
				var objRow;   
				var status;
				for(var j=0;j<dataLength;j++)
				{       
					objRow = responseData[j];
			#>
			<tbody>
			<tr id="Tr2" >
		
                <td class="GridViewLabItemStyle" id="td3"  ><#= j+1 #></td>
				<td class="GridViewLabItemStyle textCenter" id="td4"   ><#=objRow.Date#></td>
				<td class="GridViewLabItemStyle" id="td5" ><#=objRow.Name#></td>
				<td class="GridViewLabItemStyle textCenter" id="td6" ><#=objRow.Quantity#></td>
				<td class="GridViewLabItemStyle textCenter" id="td7" ><#=objRow.DoctorName#></td>
			</tr>     
			</tbody>      
			<#}#>       
		</table>    
	</script>
    	


    <script type="text/javascript">

        var getPendingInvestigationAndServices = function (el) {
            var transactionID = $.trim($(el).closest('tr').find('#tdTransactionID').text());
            serverCall('EMG_PatinetSearch.aspx/GetPendingInvestigationAndServices', { transactionID: transactionID }, function (response) {
                responseData = JSON.parse(response);

                if (responseData.length < 1) {
                    modelAlert('0 Pending Investigation.');
                    return false;
                }
                var rowHTML = $('#templateInvestigationAndServices').parseTemplate(responseData);
                var divPendingInvestigations = $('#divPendingInvestigations');
                divPendingInvestigations.find('.modal-title').text('Pending Investigations');
                divPendingInvestigations.find('.modal-body').html(rowHTML);
                divPendingInvestigations.showModel();
            });
        }



        var getPendingMedicines = function (el) {
            var transactionID = $.trim($(el).closest('tr').find('#tdTransactionID').text());
            serverCall('EMG_PatinetSearch.aspx/GetPendingMedicines', { transactionID: transactionID }, function (response) {
                responseData = JSON.parse(response);

                if (responseData.length < 1) {
                    modelAlert('0 Pending Medicnes.');
                    return false;
                }
                var rowHTML = $('#templateInvestigationAndServices').parseTemplate(responseData);
                var divPendingInvestigations = $('#divPendingInvestigations');
                divPendingInvestigations.find('.modal-title').text('Pending Medicines');
                divPendingInvestigations.find('.modal-body').html(rowHTML);
                divPendingInvestigations.showModel();
            });
        }

        function WaitingType(sender) {
            var row = $(sender).closest('tr');
            $('#spnTID').text($(row).find('#tdTID').text());
            $('#divWaitingType').hideModel();
            bindType();
            $('#ddlWaiting').val(0);
            $('#divWaitingType').showModel();
        }
        function bindType() {

            
            var $ddlWaiting = $('#ddlWaiting');
            
                    serverCall('EMG_PatinetSearch.aspx/getWaitingType', {}, function (response) {
                        $ddlWaiting.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'WaitingType', isSearchAble: true });
                       

                    });
        }

        function $PrimaryDoctorchange() {
            var ddlWaiting = $('#ddlWaiting');
            if ($(ddlWaiting).val() == 0) {
                modelAlert('Please Select the Waiting Type', function () {
                    $(ddlWaiting).focus();
                });
                return;
            }
            else {
                serverCall('EMG_PatinetSearch.aspx/SaveWaitingType', { waitingID: $('#ddlWaiting').val(), TID: $('#spnTID').text() }, function (response) {
                    var responseData = JSON.parse(response);
                    
                    modelAlert(responseData.response, function () {
                        $('#divWaitingType').hideModel();
                        Search('All')
                    });
                });
            }
        }
    </script>






    <div id="divPendingInvestigations" class="modal fade" >
	<div class="modal-dialog">
		<div class="modal-content" style="width: 860px">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="divPendingInvestigations" aria-hidden="true">×</button>
				<h4 class="modal-title">Pending Investigations </h4>
			</div>
			<div class="modal-body">
			   
				 
		    </div>
			<div class="modal-footer">
				 <button type="button" data-dismiss="divPendingInvestigations">Close</button>
			</div>
		</div>
	</div>
</div>
    <div id="divWaitingType"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:450px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divWaitingType" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Waiting Category</h4>
                    <span id="spnTID" style="display:none;"></span>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">Waiting</label>
                        <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							<select id="ddlWaiting" title="Select Type"></select>
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$PrimaryDoctorchange()">Save</button>
						 <button type="button"  data-dismiss="divWaitingType" >Close</button>
				</div>
			</div>
		</div>
	</div>

</asp:Content>

