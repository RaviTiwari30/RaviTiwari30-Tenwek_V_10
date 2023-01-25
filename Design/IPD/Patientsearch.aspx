<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PatientSearch.aspx.cs" Inherits="Design_IPD_PatientSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	  <style>
	      blink {
	          color: #054b24;
	          font-size: 13px;
	          font-weight: bold;
	          cursor: pointer;
	      }


	      .blink_text {
	          animation: 2s blinker linear infinite;
	          -webkit-animation: 1s blinker linear infinite;
	          -moz-animation: 1s blinker linear infinite;
	          color: red;
	      }

	      @-moz-keyframes blinker {
	          0% {
	              opacity: 1.0;
	          }

	          50% {
	              opacity: 0.0;
	          }

	          100% {
	              opacity: 1.0;
	          }
	      }

	      @-webkit-keyframes blinker {
	          0% {
	              opacity: 1.0;
	          }

	          50% {
	              opacity: 0.0;
	          }

	          100% {
	              opacity: 1.0;
	          }
	      }

	      @keyframes blinker {
	          0% {
	              opacity: 1.0;
	          }

	          50% {
	              opacity: 0.0;
	          }

	          100% {
	              opacity: 1.0;
	          }
	      }
	  </style>
	 <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
	<script type="text/javascript">

	    //showuploadbox(obj, href, maxh, maxw, w, h, obj)
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
	    var dataRoom = [];
	    var dataFloor = [];

	    jQuery(function () {
	        $('#txtPatientID').focus();
	        getDepartment();
	        BindFloor();
	        bindRoomType();
	        bindAdmissionDoctor();
	        bindPanel();
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
	                }
	                ddlDepartment.chosen();
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
				url: "PatientSearch.aspx/BindFloor",
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
								ddlFloor.append(jQuery("<option></option>").val(Floor[i].ID).html(Floor[i].NAME))
								dataFloor.push(Floor[i].ID);
								if (Floor.length == 1)
									ddlFloor.val(Floor[i].ID).attr('disabled', 'disabled');
							}
						}
					}

ddlFloor.chosen();
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
				url: "PatientSearch.aspx/BindRoomType",
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
						dataRoom.push(RoomData[i].IPDCaseTypeID);
						if (RoomData.length == 1)
							$("#cmbRoom").val(RoomData[i].IPDCaseTypeID).attr('disabled', 'disabled');
					}
				},
				error: function (xhr, status) {
				}
			});
		}

		function bindAdmissionDoctor() {
		    jQuery("#ddlDoctor option").remove();
		    jQuery.ajax({
		        url: "Services/IPDAdmission.asmx/bindAdmissionDoctor",
		        data: '{}',
		        type: "Post",
		        contentType: "application/json; charset=utf-8",
		        timeout: 120000,
		        async: false,
		        dataType: "json",
		        success: function (result) {
		            Data = jQuery.parseJSON(result.d);
		            $("#ddlDoctor").chosen('destroy');
		            $("#ddlDoctor").append($("<option></option>").val("0").html("ALL"));
		            for (i = 0; i < Data.length; i++) {
		                $("#ddlDoctor").append($("<option></option>").val(Data[i].DoctorID).html(Data[i].Name));
		            }
		            if ('<%=ViewState["DoctorID"].ToString()%>' != "" && '<%=ViewState["DoctorID"].ToString()%>' != "1") {
		                $("#ddlDoctor").val('<%=ViewState["DoctorID"].ToString()%>').attr('disabled','disabled');
		            }
		            $("#ddlDoctor").chosen();
		        },
		        error: function (xhr, status) {
		        }
		    });
		}

		function bindPanel() {
			jQuery("#ddlParentPanel option").remove();
			jQuery("#ddlPanel option").remove();
			jQuery.ajax({
			    url: "Services/IPDAdmission.asmx/bindPanelRoleWisePanelGroupWise",
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
                        //$("#ddlParentPanel").chosen();
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
	</script>
	<div id="Pbody_box_inventory">
	   <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Patient Search</b>
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
							<input type="text" id="txtPatientID" onkeyup="if(event.keyCode==13){Search(0);};"  tabindex="1" autocomplete="off" data-title="Enter UHID" />
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Patient Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text" id="txtName" onkeyup="if(event.keyCode==13){Search(0);};" tabindex="1" autocomplete="off" data-title="Enter Patient Name" />
						</div>
							 <div class="col-md-3">
							<label class="pull-left">
								<input type="checkbox" id="chkCreditCase"  title="Click To Search Only Credit Patient" onclick="CheckCreditCase()" />
								Panel
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select id="ddlPanel"  title="Select Panel" tabindex="11" onkeyup="if(event.keyCode==13){Search(0);};"></select>
						   <%-- <select id="ddlParentPanel"  title="Select Parent Panel"  tabindex="12" onkeyup="if(event.keyCode==13){Search(0);};"></select>--%>
						</div>


					</div>
					  <div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Department
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <select id="ddlDepartment"  title="Select Department" tabindex="2" onkeyup="if(event.keyCode==13){Search(0);};"></select>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Doctor
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select id="ddlDoctor"  title="Select Consultant"  tabindex="3" onkeyup="if(event.keyCode==13){Search(0);};"></select>
						</div>
                          <div class="col-md-3">
							<label class="pull-left">
								Ward 
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							  <select id="cmbRoom" title="Select Room Type"   tabindex="10" onkeyup="if(event.keyCode==13){Search(0);};"></select>
						</div>
							
					</div>
					  <div class="row" style="display:none">
						<div class="col-md-3">
							<label class="pull-left">
								Age From
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtAgeFrom" runat="server" AutoCompleteType="Disabled" TabIndex="4" ClientIDMode="Static" ToolTip="Enter Age From" Width="71px" MaxLength="3" onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>
						<asp:DropDownList ID="ddlAgeFrom" runat="server" TabIndex="5" Width="148px"  ClientIDMode="Static" onkeyup="if(event.keyCode==13){Search(0);};">
							<asp:ListItem Value="YRS">YRS</asp:ListItem>
							<asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
							<asp:ListItem>DAYS(S)</asp:ListItem>
						</asp:DropDownList>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Age To
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtAgeTo" runat="server" AutoCompleteType="Disabled" TabIndex="6" ClientIDMode="Static" onkeyup="if(event.keyCode==13){Search(0);};" ToolTip="Enter Age To" Width="71px" MaxLength="3"></asp:TextBox>
						<asp:DropDownList ID="ddlAgeTo" runat="server" TabIndex="7" Width="148px">
							<asp:ListItem Value="YRS">YRS</asp:ListItem>
							<asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
							<asp:ListItem>DAYS(S)</asp:ListItem>
						</asp:DropDownList>
						<cc1:FilteredTextBoxExtender ID="Fage" runat="Server" FilterType="Numbers,Custom" TargetControlID="txtAgeFrom" ValidChars="."></cc1:FilteredTextBoxExtender>
						<cc1:FilteredTextBoxExtender ID="Tage" runat="server" Enabled="False" FilterType="Numbers,Custom" TargetControlID="txtAgeTo" ValidChars="."></cc1:FilteredTextBoxExtender>
					
						</div>
                          <div class="col-md-3">
							<label class="pull-left">
								Floor
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select id="ddlFloor"  title="Select Floor"  tabindex="8" onchange="bindRoomType()" onkeyup="if(event.keyCode==13){Search(0);};"></select>
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
							 <asp:TextBox ID="txtTransactionNo" runat="server" ClientIDMode="Static" style="text-transform:uppercase" MaxLength="10" TabIndex="9" AutoCompleteType="Disabled" data-title="Enter IPD No." onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>
						
						</div>
						 
							<div class="col-md-3">
							<label class="pull-left">
								From Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						 <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ReadOnly="true"  ClientIDMode="Static" TabIndex="13" onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>
						<cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
						   <div class="col-md-3">
							<label class="pull-left">
								To Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						<asp:TextBox ID="ucToDate" runat="server"   ReadOnly="true"  onkeyup="if(event.keyCode==13){Search(0);};" ClientIDMode="Static" TabIndex="14" ToolTip="Click To Select To Date"></asp:TextBox>
						<cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
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
						 <asp:RadioButtonList ID="rdblAdDis" runat="server" CssClass="ItDoseLblSpBl" RepeatDirection="Horizontal" ClientIDMode="Static" TabIndex="15" RepeatLayout="Flow">
							<asp:ListItem Selected="True" Value="CAD">Currently Admitted</asp:ListItem>
							<asp:ListItem Value="AD">Admissions</asp:ListItem>
							<asp:ListItem Value="ID">Intimation Discharge</asp:ListItem>
                            <asp:ListItem Value="PC">Pending Pharmacy Clearance</asp:ListItem>
							<asp:ListItem Value="DI">Discharged</asp:ListItem>
							<asp:ListItem Value="BNF">Bill Not Finalised</asp:ListItem>
							<asp:ListItem Value="BF">Bill Finalised</asp:ListItem>
						</asp:RadioButtonList>
					</div>
						 </div>

                    
					<div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
								My patient list 
							</label>
							  <b class="pull-right">:</b>
                            
                        </div>
                         <div class="col-md-3">
                        <input type="checkbox" id="chkIsOwn"  title="Click To Search Only Own Patient"   />
					</div>
					</div>

					<div class="row"></div>
					  <div class="row">
						 <div class="col-md-11">
						 </div>
						  <div class="col-md-2">
								<input type="button" class="ItDoseButton"  title="Click to Search Patient"  tabindex="16" value="Search" id="btnSearch" onclick="Search(0)" />
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
						
                        <%--<div style="text-align:center;display:block" class="col-md-2 divAll">
							<button type="button" onclick="Search(4)" title="Click To Search All Received/NonReceived" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #cce6ff;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">All</b> 
						</div>
                          <div style="text-align:center;display:block" class="col-md-4 divReceived">
							<button type="button" onclick="Search(5)" title="Click To Search Only  Patient Received" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #ffb366;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Patient Received</b> 
						</div>--%>
                    <div class="col-md-2"></div>
                          <div style="text-align:center;display:block" class="col-md-5 divNonReceived">
							<button type="button" onclick="Search(6)" title="Click To Search Only Patient Not Received" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #d699ff;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Patient Not Received</b> 
						</div>
                        <div style="text-align:center;display:block" class="col-md-4 divZero">
							<button type="button" onclick="Search(3)" title="Click To Search Only Zero Advance Patient" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #FF99CC;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Zero Advance</b> 
						</div>
						<div style="text-align:center;display:block" class="col-md-6 divAbove">
							<button type="button" onclick="Search(1)" title="Click To Search Only Above Threshold Limit Patient" style="width:25px;height:25px;margin-left:5px;float:left;background-color: yellow;"  class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Above Threshold Limit</b> 
						</div>
                        <div style="text-align:center;display:block" class="col-md-6 divBelow">
							<button type="button" onclick="Search(2)" title="Click To Search Only Below Threshold Limit Patient" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #90ee90;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">Below Threshold Limit</b> 
						</div>
						<div class="col-md-4"></div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>
		<div class="POuter_Box_Inventory">
				<div id="IPDOutput" style="height:326px;width:100%;overflow-y:auto"> </div>
		</div>
	</div>

	<iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>
	<script type="text/javascript">
        //=====By Amit====
	    var checkIsReceived = function (elem) {
	        var closestTr = $(elem).closest('tr');
	        var IsReceived = $.trim(closestTr.find('.hdnselect').val());
	        var TID = $.trim(closestTr.find('.hdnTID').val());
	        var userauthorization = $.trim(closestTr.find('.hdnuserauthorization').val());        
	        var URL = $.trim(closestTr.find('.hdnredirect').val());
	        var PatientType = $.trim(closestTr.find('.hdnPatientType').val()); 

	        var IPDNo = $.trim(closestTr.find('#tdIPDNo').text());
	        var scheduleChargeID = $(closestTr).find('#tdSchedulechargeID').text().trim();
	        var doctorID = $(closestTr).find('#tdDoctorID').text();
	        var panelID = $(closestTr).find('#tdPanelID').text();
	        var patientID = $(closestTr).find('#tdPatientID').text();
	        if (IsReceived == 0) {
	            // if (userauthorization == 1) {
	            modelConfirmation('Alert!!!', 'Do You Want To Receive Patient?', 'YES', 'NO', function (response) {
	                if (response) {
	                    serverCall('../common/CommonService.asmx/IsReceivedPatient', { TID: TID, IsReceived: 1 }, function (response) {
	                        var $responseData = JSON.parse(response);
	                        modelAlert($responseData.response, function () {
	                            closestTr.remove();
	                            $("#iframePatient").attr("src", URL);
	                            if (PatientType == "VIP" || PatientType == "HANDLED WITH CARE") {
	                                //modelAlert('Patient admitted under the Patient Type : <span class="patientInfo">' + PatientType + "</span>", function () {
	                                //    reseizeIframe(closestTr);
	                                //});
	                                modelConfirmation('Do you want to continue ???', 'Patient admitted under the Patient Type : <span class="patientInfo">' + PatientType + '</span>', 'YES', 'NO', function (response) {
	                                    if (response) {
	                                        reseizeIframe(closestTr);
	                                    }
	                                });
	                                
	                            }
	                            else {
	                                reseizeIframe(closestTr);
	                            }
	                        });
	                    });
	                }
	            });
	            // }
	            // else {
	            //   modelAlert('You Have No Authority To Receive This Patient.');
	            //}
	            $('#divRecievePatient').show();
	            var ipdCaseTypeID = $(closestTr).find('#tdIPDCaseTypeID').text();
	            var CurrBed = $(closestTr).find('#tdRoom').text();
	            bindBedRoom(ipdCaseTypeID, function (roomID) {
	                $('#divRecievePatient').showModel();
	                $('#divRecievePatient #spnredirectURL').text(URL);
	                $('#divRecievePatient #spnIpdNo').text(IPDNo);
	                $('#divRecievePatient #spnscheduleChargeID').text(scheduleChargeID);
	                $('#divRecievePatient #spnipdCaseTypeID').text(ipdCaseTypeID);
	                $('#divRecievePatient #spndoctorID').text(doctorID);
	                $('#divRecievePatient #spnpanelID').text(panelID);
	                $('#divRecievePatient #spnPatientID').text(patientID);
	                $('#divRecievePatient #spnRoomBed').text(CurrBed);
	                $('#divRecievePatient #spnTID').text(TID);
	            });
	        }
	        else {
	            $("#iframePatient").attr("src", URL);
	            if (PatientType == "VIP" || PatientType == "HANDLED WITH CARE") {
	                //modelAlert('Patient admitted under the Patient Type : <span class="patientInfo">' + PatientType + "</span>", function () {
	                //    reseizeIframe(closestTr);
	                //});
	                modelConfirmation('Do you want to continue ???', 'Patient admitted under the Patient Type : <span class="patientInfo">' + PatientType + '</span>', 'YES', 'NO', function (response) {
	                    if (response) {
	                        reseizeIframe(closestTr);
	                    }
	                });
	            }
	            else {
	                reseizeIframe(closestTr);
	            }

	            }       
	    }

	    var bindBedRoom = function (ipdCaseTypeID, callback) {
	        var ddlRoombed = $('#ddlRoomShift');
	        serverCall('PatientSearch.aspx/bindAvailableRooms', { ipdCaseTypeID: ipdCaseTypeID }, function (response) {
	            ddlRoombed.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'RoomId', textField: 'Name', isSearchAble: true });
	            callback(ddlRoombed.val());
	        });
	    }
	    var recievePatientinRoom = function () {
	        var scheduleChargeID = $('#spnscheduleChargeID').text().trim();
	        var ipdCaseTypeID = $('#spnipdCaseTypeID').text().trim();
	        var roomID = $('#ddlRoomShift').val();
	        var doctorID = $('#spndoctorID').text().trim()
	        var panelID = $('#spnpanelID').text().trim()
	        //if (roomID == "0") {
	        //    modelAlert('Please Select Room/Bed');
	        //    return false;
	        //}
	        var PID = $('#spnPatientID').text().trim();
	        serverCall('PatientSearch.aspx/recieveandShiftPatient', { TID: $('#spnTID').text().trim(), scheduleChargeID: scheduleChargeID, ipdCaseTypeID: ipdCaseTypeID, roomID: roomID, panelID: panelID, doctorID: doctorID, PID: PID }, function (response) {
	            var $responseData = JSON.parse(response);
	            modelAlert($responseData.response, function () {
	                $('#divRecievePatient').hideModel();
	                var URL = $('#spnredirectURL').text().trim();
	                //  closestTr.remove();
	                $("#iframePatient").attr("src", URL);
	                reseizeIframe(closestTr);
	            });
	        });
	    }
	    //=====END====
	    function Search(id) {
	        if ('<%=ViewState["DoctorID"].ToString()%>' == "") {
	            modelAlert("You are not authorize for this center. Kindly Contact to IT Department.");
	            return;
	        }
	        var FloorID = "";
	        var RoomID = "";
	        var IsPatientReceived = 2;
	        if (id == 4) {
	            IsPatientReceived = 2;
	        }

	        if (id == 5) {
	            IsPatientReceived = 1;
	        }

	        if (id == 6) {
	            IsPatientReceived = 0;
	        }

	        $("#btnSearch").attr("disabled", "disabled");
	        if ($('#ddlFloor').val() == "0") {
	            if (dataFloor.length > 0) {
	                $.each(dataFloor, function (index, valueFloor) {
	                    if (FloorID == "")
	                        FloorID = "'" + valueFloor + "'";
	                    else
	                        FloorID += ",'" + valueFloor + "'";
	                });
	            }
	        }
	        else {
	            FloorID = $('#ddlFloor').val();
	        }
	        if ($('#cmbRoom').val() == "0") {
	            if (dataRoom.length > 0) {
	                $.each(dataRoom, function (index, valueRoom) {
	                    if (RoomID == "")
	                        RoomID = "'" + valueRoom + "'";
	                    else
	                        RoomID += ",'" + valueRoom + "'";
	                });
	            }
	        }
	        else {
	            RoomID = "'" + $('#cmbRoom').val() + "'";
	        }
	        var radios = $("#<%=rdblAdDis.ClientID%> input[type=radio]:checked").val();
			var Credit = 0;
			if ($('#chkCreditCase').is(":checked"))
			    Credit = 1;


			chkIsOwn = 0;
			if ($('#chkIsOwn').is(":checked"))
			    chkIsOwn = 0;

			

			$("#lblMsg").text('');
			$.ajax({
				type: "POST",
				url: "PatientSearch.aspx/PatientSearch",
				data: '{MRNo:"' + $.trim($("#txtPatientID").val()) + '",PName:"' + $.trim($("#txtName").val()) + '",Department:"' + $.trim($("#ddlDepartment").val()) + '",Floor:"' + FloorID + '",AgeFrom:"' + $.trim($("#<%=txtAgeFrom.ClientID%>").val()) + '",ddlAgeFrom:"' + $.trim($("#<%=ddlAgeFrom.ClientID%>").val()) + '",AgeTo:"' + $.trim($("#<%=txtAgeTo.ClientID%>").val()) + '",ddlAgeTo:"' + $.trim($("#<%=ddlAgeTo.ClientID%>").val()) + '",RoomType:"' + RoomID + '",IPDNo:"' + $('#txtTransactionNo').val() + '",DoctorID:"' + $('#ddlDoctor').val() + '",Panel:"' + $('#ddlPanel').val() + '",ParentPanel:"' + 0 + '",FromDate:"' + $('#ucFromDate').val() + '",ToDate:"' + $('#ucToDate').val() + '",AdmitDischarge:"' + radios + '",Type:"' + Credit + '",id:"' + id + '",IsPatientReceived:' + IsPatientReceived + ',IsownPrescription:' + chkIsOwn + '}',
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
						if (id == 3) {						    
						    $('#tb_grdIPD').find('tbody').find('tr').css("background-color", "#FF99CC");
						}
					    if (id == 1) {
						    $('#tb_grdIPD').find('tbody').find('tr').css("background-color", "yellow");
						}
						if (id == 2) {
						    $('#tb_grdIPD').find('tbody').find('tr').css("background-color", "#90ee90");
						}
						if (id == 6) {
						    $('#tb_grdIPD').find('tbody').find('tr').css("background-color", "#d699ff");
						}						
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
			var row = elem;
			iframe.onload = function () {
				iframe.style.width = '100%';
				iframe.style.height = '100%';
				iframe.style.display = '';
				try{
					var contentDocument = document.getElementById("iframePatient").contentDocument;
					contentDocument.getElementById('lblPatientName').innerHTML = row.find('#tdPName').text();
					contentDocument.getElementById('lblDoctorName').innerHTML = row.find('#tdDoctor').text();
					contentDocument.getElementById('lblPatientID').innerHTML = row.find('#tdPatientID').text();
					contentDocument.getElementById('lblIPDNo').innerHTML = row.find('#tdIPDNo').text();
					contentDocument.getElementById('lblRoomNo').innerHTML = row.find('#tdRoom').text();
					contentDocument.getElementById('lblPanel').innerHTML = row.find('#tdPanel').text();
					contentDocument.getElementById('lblGender').innerHTML = row.find('#tdGender').text();
					contentDocument.getElementById('lblAge').innerHTML = row.find('#tdAge').text();
					contentDocument.getElementById('lblAdmitDate').innerHTML = row.find('#tdAdmitDateTime').text();
					contentDocument.getElementById('lblTeam').innerHTML = row.find('#tdTeamName').text();
					contentDocument.getElementById('lblPatientCode').innerHTML = row.find('#tdPatientCode').text();
					contentDocument.getElementById('lblIdProof').innerHTML = row.find('#tdIdProofNo').text();

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
				window.open('../../Design/EMR/printDischargeReport_pdf.aspx?TID=' + TID + '&Status=' + status + '&ReportType=PDF');
		}

        function ViewRadiologyNotification(rowid) {
            var TID = $.trim(jQuery(rowid).closest("tr").find("#tdTransactionID").text());
            var IPDNO = $.trim(jQuery(rowid).closest("tr").find("#tdIPDNo").text());
            serverCall('PatientSearch.aspx/ViewRadiologyNotification', { TransactionID: TID }, function (response) {
                    StockData = jQuery.parseJSON(response);
                    var output = $('#tb_RadioNotifiSearch').parseTemplate(StockData);
                    $('#divRadiologyNotification #RadioNotifiOutput').html(output);
                    $('#divRadiologyNotification #RadioNotifiOutput').show();
                    $('#divRadiologyNotification').showModel();
                    $('#divRadiologyNotification #lblIPNO').text(IPDNO);
            });
        }



        var getRadiologyNotificationDetails = function (transactionID,callback) {
            serverCall('PatientSearch.aspx/ViewRadiologyNotification', { TransactionID: transactionID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
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
            serverCall('PatientSearch.aspx/PrintSticker', { patientID: patientID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.response)
                else
                    modelAlert(responseData.response);
            });

        }


        var replyOnNotification = function (el) {
            var divReplyOnNotification = $('#divReplyOnNotification');
            var tdData = JSON.parse($(el).closest('tr').find('.tdData').text());
            divReplyOnNotification.find('.lblRemarks').attr('notificationID', tdData.ID).text(tdData.Remarks);
            divReplyOnNotification.find('textarea').val('');
            divReplyOnNotification.showModel();
        }


        var saveReplyOnNotification = function () {

            var divReplyOnNotification = $('#divReplyOnNotification');

 
            var notificationID = Number(divReplyOnNotification.find('.lblRemarks').attr('notificationID'));
            var reply = $.trim(divReplyOnNotification.find('textArea').val());


            if (String.isNullOrEmpty(reply)) {
                modelAlert('Please Enter Reply  Content.', function () {
                    divReplyOnNotification.find('textArea').focus();
                });
                return false;
            }


        

            var data = {
                notificationID: notificationID,
                reply:reply
             }
            

            serverCall('PatientSearch.aspx/SaveNotificationReply', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    divReplyOnNotification.closeModel();
                }
                else {
                    modelAlert(responseData.message, function () {

                    })
                }

            });




		}



	</script>
	<script id="tb_Search" type="text/html">
		<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdIPD" style="width:100%;border-collapse:collapse;">
			<thead>
			<tr id="Header">
				<th class="GridViewHeaderStyle" scope="col">Select</th>
                <th class="GridViewHeaderStyle" scope="col">UHID</th>
                <th class="GridViewHeaderStyle" scope="col">Patient Name</th>
                 <th class="GridViewHeaderStyle" style="width: 70px;" scope="col">Reg. Info</th>
                <th class="GridViewHeaderStyle" style="width: 70px;" scope="col">IPDNo.</th>
				<th class="GridViewHeaderStyle" scope="col" style="display:none">Sticker</th>
				<th class="GridViewHeaderStyle" scope="col" style="display:none">Status</th>
                <th class="GridViewHeaderStyle" scope="col">Shortcuts</th>
                <th class="GridViewHeaderStyle" scope="col">Vitals</th>
                <th class="GridViewHeaderStyle" scope="col">Age/Sex</th>
                <th class="GridViewHeaderStyle" scope="col">Team</th>
                <th class="GridViewHeaderStyle" scope="col">First Call</th>
                <th class="GridViewHeaderStyle" scope="col">Pri.Nurse</th>
				<th class="GridViewHeaderStyle" scope="col">Admit Date</th>
                <th class="GridViewHeaderStyle" scope="col">Discharge Date</th>
				<th class="GridViewHeaderStyle" scope="col">Panel</th>
				<th class="GridViewHeaderStyle" scope="col">Ward Name</th>
                <th class="GridViewHeaderStyle" scope="col">Contact No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">Relation</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">TransactionID</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">LoginType</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">BillNo</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">Status</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">PanelID</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">DoctorID</th>                   
				<th class="GridViewHeaderStyle" style="width: 100px;" scope="col" >Admitted By</th>
				<th class="GridViewHeaderStyle" scope="col" style="display:none">Patient Code</th>
                <th class="GridViewHeaderStyle" scope="col" ">ReceivedBy</th>
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
                <#if(objRow.IsPatientReceived=="0"){#>
					style="background-color:#d699ff"
				<#}
                
                else{#>
					<#if(objRow.amtpaid=="1"){#>
					style="background-color:yellow"
				<#}else if(objRow.amtpaid =="0"){#>
					style="background-color:#FF99CC"
				<#}else{#>
					style="background-color:#90EE90"
				<#}#>
				<#}#>


				
			 > 
				<td class="GridViewLabItemStyle" style="text-align:center" >
                    <a  href="javascript:void(0)" class="btnselect" onclick="checkIsReceived(this)"  >
                        <input type="hidden" value="<#=objRow.IsPatientReceived#>" class="hdnselect" />
                        <input type="hidden" value="<#=objRow.TransactionID#>" class="hdnTID" />
                         <input type="hidden" value="<#=objRow.PatientType#>" class="hdnPatientType" />
                         <input type="hidden" value="<#=objRow.userauthorization#>" class="hdnuserauthorization" />
                        <input type="hidden" value="IPFolder.aspx?App_ID=<#=objRow.App_ID#>&amp;TID=<#=objRow.TransactionID#>&amp;BillNo=<#=objRow.BillNo#>&amp;PID=<#=objRow.PatientID#>&amp;LoginType=<#=objRow.LoginType#>&amp;BillNo=<#=objRow.BillNo#>&amp;sex=<#=objRow.Gender#>&amp;PanelID=<#=objRow.PanelID#>&amp;DoctorID=<#=objRow.DoctorID#>" class="hdnredirect" />
					   <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" id="imgframe"/>
					 </a>
					 <%--<a target="iframePatient" onclick="reseizeIframe(this);"  href="" >
					   <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" id="imgframe"/>
					 </a>--%>                                                                                        
				</td>  
				<td class="GridViewLabItemStyle" style="text-align:center;display:none" >
					<img alt="Select" src="../../Images/print.GIF" style="cursor:pointer"  onclick="printSticker(this)" />
				</td>
				<td class="GridViewLabItemStyle" style="text-align:center;display:none" >
					<#if(objRow.DischargeSummary !="0"){#> 
						<img alt="Select" src="../../Images/view.GIF" style="border: 0px solid #FFFFFF;" onclick="ViewDischargeSummary(this)" />
					<#}else{#>
						<img alt="Select" src="../../Images/view.GIF" style="border: 0px solid #FFFFFF;display:none" /> 
					<#}#>
                    <#if(objRow.RadiologyNotification!="0"){#>
                         <img alt="Select" src="../../Images/RadiologyNotification.png" style="border: 0px solid #FFFFFF;" onclick="ViewRadiologyNotification(this)" />
                    <#}else{#>
                         <img alt="Select" src="../../Images/RadiologyNotification.png" style="border: 0px solid #FFFFFF; display:none" />
                    <#}#>
				</td>
                <td class="GridViewLabItemStyle" id="tdPatientID"><#=objRow.PatientID#></td>
                <td class="GridViewLabItemStyle" id="tdPName" ><#=objRow.PName#></td>
                 <td class="GridViewLabItemStyle" id="tdIdProofNo" >
                     <a target="pagecontent" class='<%# Eval("ClassLabsBlink") %>'  id='A9'  name="c" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/PatientFinalMsg.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>&amp;IsView=1', 1050, 1050, '73%', '90%');" style="color:yellow;" >Reg Info</a>
                     </br>
                     <#=objRow.PatientIDProofNumber#>

                 </td>

                <td class="GridViewLabItemStyle" id="tdIPDNo" ><#=objRow.IPDNO#></td>
                <td  class="GridViewLabItemStyle" style="width:200px;" >                                 
              <%--  <a target="pagecontent" class='<%# Eval("ClassDoctorNoteBlink") %>' id='<#=objRow.PatientID#>' name="a"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/DoctorProgressNote.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Doctor</a>--%>
              <%--  <a target="pagecontent" class='<%# Eval("ClassNursingNoteBlink") %>'  id='A1'  name="b"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/NursingProgress.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Nursing</a>--%>
                 <#if(objRow.LabsCount!="0"){#>
                  <blink class="blink_text">
                    <a target="pagecontent" class='<%# Eval("ClassLabsBlink") %>'  id='A2'  name="c" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../Lab/ViewLabReportsWard.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>&amp;IsView=1', 1050, 1050, '73%', '90%');" style="color:yellow;" >Labs(<#=objRow.LabsCount#>)</a>
              </blink> 
                      <#}else{#>
                          
                     <a target="pagecontent" class='<%# Eval("ClassLabsBlink") %>'  id='A8'  name="c" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../Lab/ViewLabReportsWard.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>&amp;IsView=0', 1050, 1050, '73%', '90%');" style="color:yellow;" >Labs</a>
            
                     <#}#>  


                   <#if(objRow.MedsCount!="0"){#>
                  <blink class="blink_text">
                      <a target="pagecontent" class='<%# Eval("ClassMedBlink") %>'  id='A4' name="e"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/Orders.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>&amp;IsView=1', 1050, 1050, '73%', '90%');" style="color:yellow;" >Meds(<#=objRow.MedsCount#>)</a>
                  </blink> 
                      <#}else{#>
                          
                     <a target="pagecontent" class='<%# Eval("ClassMedBlink") %>'  id='A1' name="e"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/Orders.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>&amp;IsView=0', 1050, 1050, '73%', '90%');" style="color:yellow;" >Meds</a>
                 
                     <#}#>  
                    <#if(objRow.NotesCount!="0"){#>
                  <blink class="blink_text">
                      <a target="pagecontent" class='<%# Eval("ClassMedBlink") %>'  id='A3' name="e"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.TransactionID#>','../IPD/Notefinder.aspx?PID=<#=objRow.PatientID#>&amp;TID=<#=objRow.TransactionID#>&amp;IsView=1', 1050, 1050, '73%', '90%');" style="color:yellow;" >Note(<#=objRow.NotesCount#>)</a>
                  </blink> 
                      <#}else{#>
                          
                     <a target="pagecontent" class='<%# Eval("ClassMedBlink") %>'  id='A5' name="e"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.TransactionID#>','../IPD/Notefinder.aspx?PID=<#=objRow.PatientID#>&amp;TID=<#=objRow.TransactionID#>&amp;IsView=0', 1050, 1050, '73%', '90%');" style="color:yellow;" >Note</a>
                 
                     <#}#>
                     
                <a target="pagecontent" class='<%# Eval("ClassIOBlink") %>'  id='A6'  name="g" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/InTakeOutTakeChart.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>', 1050, 1050, '73%', '90%');" style="color:yellow;" >I/O</a>
                 <a target="pagecontent" class='<%# Eval("ClassFlowSheetsBlink") %>'  id='A7'  name="h"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/FlowSheetView.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>&amp;PType=IPD', 1050, 1050, '73%', '90%');" style="color:yellow;" >FlowSheets</a><br />
                    <a target="pagecontent" class='<%# Eval("ClassFlowSheetsBlink") %>'  id='A1'  name="h"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../IPD/TreatmentDoctor.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>', 1050, 1050, '73%', '90%');" style="color:yellow;" >First Call</a><br />
                 </td>
                <td class="GridViewLabItemStyle" id="tdVital"  ><#=objRow.Vital#></td>   
                <td class="GridViewLabItemStyle" id="tdSex" ><#=objRow.AgeSex#></td>
                <td class="GridViewLabItemStyle" id="tdDoctor" ><#=objRow.TeamName#></td>
                <td class="GridViewLabItemStyle" id="td2" ><#=objRow.FirstCall#></td>
                <td class="GridViewLabItemStyle" id="td3" ><#=objRow.PrimaeryNurse#></td>
				<td class="GridViewLabItemStyle" id="tdAdmitDateTime"  ><#=objRow.AdmitDate#></td>
                <td class="GridViewLabItemStyle" id="tdDischargeDate"  ><#=objRow.DischargeDate#></td>
				<td class="GridViewLabItemStyle" id="tdPanel" ><#=objRow.Company_Name#></td>
				<td class="GridViewLabItemStyle" id="tdRoom" ><#=objRow.RoomName#></td>
                <td class="GridViewLabItemStyle" id="tdMobile" ><#=objRow.Mobile#></td>
                <td class="GridViewLabItemStyle" id="td1" style="display:none"><#=objRow.Relation#></td>
				<td class="GridViewLabItemStyle" id="tdAge" style="width:60px;display:none"><#=objRow.Age#></td> 
				<td class="GridViewLabItemStyle" id="tdGender" style="width:60px;display:none"><#=objRow.Gender#></td>                     
				<td class="GridViewLabItemStyle" id="tdTransactionID" style="width:60px;display:none"><#=objRow.TransactionID#></td>                     
				<td class="GridViewLabItemStyle" id="tdLoginType" style="width:60px;display:none"><#=objRow.LoginType#></td>
				<td class="GridViewLabItemStyle" id="tdBillNo"  style="width:60px;display:none" ><#=objRow.BillNo#></td>    
				<td class="GridViewLabItemStyle" id="tdstatus"  style="width:60px;display:none" ><#=objRow.Status#></td>    
				<td class="GridViewLabItemStyle" id="tdAdmittedBy"><#=objRow.AdmittedBy#></td>   
                <td class="GridViewLabItemStyle" id="tdIsReceivedBy"><#=objRow.IsReceivedBy#></td>   
                <td class="GridViewLabItemStyle" id="tdTeamName"  style="width:60px;display:none"><#=objRow.TeamName#></td>     
				<td class="GridViewLabItemStyle" id="tdPatientCode" style="display:none"><#=objRow.PatientCode#></td>  
                  <td class="GridViewLabItemStyle" id="tdIPDCaseTypeID" style="width:30px;display:none"><#=objRow.IPDCaseTypeID#></td>                                                                                   
                <td class="GridViewLabItemStyle" id="tdSchedulechargeID" style="width:30px;display:none"><#=objRow.ScheduleChargeID#></td>    
                <td class="GridViewLabItemStyle" id="tdDoctorID" style="width:30px;display:none"><#=objRow.DoctorID#></td>    
                <td class="GridViewLabItemStyle" id="tdPanelID" style="width:30px;display:none"><#=objRow.PanelID#></td>                                                                     
			</tr>     
			</tbody>      
			<#}#>       
        </table>    
	</script>
	<div id="divRadiologyNotification"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:1024px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divRadiologyNotification" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Radiology Notification Detail</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-5">
							   <label class="pull-left">IPD No.   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-7" >
							   <label id="lblIPNO"></label>
						  </div>
						 <div class="col-md-5"></div>
						 <div class="col-md-7"></div>
					</div>
                    <div class="row">
                         <div id="RadioNotifiOutput" style="max-height: 250px; overflow-x: auto;"></div>
                    </div>
				</div>
			    <div class="modal-footer">
						 <button type="button"  data-dismiss="divRadiologyNotification" >Close</button>
				</div>
            </div>
			</div>
		</div>

     <div id="divRecievePatient"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:500px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divRecievePatient" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Recieve and Allocate Bed</h4>
                    <span id="spnredirectURL" style="display:none"></span>
                    <span id="spnscheduleChargeID" style="display:none"></span>
                    <span id="spnipdCaseTypeID" style="display:none"></span>
                    <span id="spndoctorID" style="display:none"></span>
                    <span id="spnpanelID" style="display:none"></span>
                    <span id="spnPatientID" style="display:none"></span>
                        <span id="spnTID" style="display:none"></span>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-8">
							   <label class="pull-left">IPD No.   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-7" >
							   <label id="spnIpdNo"></label>
						  </div>
						 
					</div>
                    <div class="row">
                        <div class="col-md-8">  <label class="pull-left">Current Bed  </label>
							   <b class="pull-right">:</b></div>
						 <div class="col-md-16">
                             <label id="spnRoomBed"></label>
						 </div>
                    </div>
                    <div class="row">
                        <div class="col-md-8">
							   <label class="pull-left">Room/Bed</label>
							   <b class="pull-right">:</b>
						  </div>
                        <div class="col-md-16">
                             <select id="ddlRoomShift" class="requiredField"></select>
                        </div>
                    </div>
				</div>
			    <div class="modal-footer">
                     <button type="button"  onclick="recievePatientinRoom()">Recieve</button>
                     <button type="button"  data-dismiss="divRecievePatient" >Close</button>
				</div>
            </div>
			</div>
		</div>
    <script id="tb_RadioNotifiSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_RadioNotifidata" style="width:100%;border-collapse:collapse;">
		<tr id="trNotifiHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Investigation</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Date to Send</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Time to Send</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Remarks</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Entry By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Reply</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Reply By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Reply DateTime</th>
            <th class="GridViewHeaderStyle" scope="col" ></th>
		</tr>
        <#       
        var dataLength=StockData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = StockData[j];
        #>
                <tr id="tr1">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle tdData hidden"  ><#= JSON.stringify(objRow) #></td> 
                    <td class="GridViewLabItemStyle" style="width:200px;" ><#=objRow.Investigation#></td> 
                    <td class="GridViewLabItemStyle" style="width:100px;" ><#=objRow.NotificationDate#></td> 
                    <td class="GridViewLabItemStyle" style="width:80px;" ><#=objRow.NotificationTime#></td> 
                    <td class="GridViewLabItemStyle tdRemarks" style="width:100px;"><#=objRow.Remarks#></td>
                    <td class="GridViewLabItemStyle" style="width:100px;" ><#=objRow.EntryBy#></td>
                    <td class="GridViewLabItemStyle" style="width:100px;" ><#=objRow.Reply#></td>
                    <td class="GridViewLabItemStyle" style="width:100px;" ><#=objRow.replyBy#></td>
                    <td class="GridViewLabItemStyle" style="width:100px;" ><#=objRow.ReplyDateTime#></td>
                    <td class="GridViewLabItemStyle" style="" >
                     
                        <#if(objRow.Reply ==''){  #>
                            <img style="cursor:pointer" src="../../Images/reply.png" alt="" onclick="replyOnNotification(this);" />
                        <#}#>
                    </td>
                </tr>           
        <#}#>                     
     </table>    
    </script>


    <div id="divReplyOnNotification"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:400px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divReplyOnNotification" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Radiology Notification Reply</h4>
				</div>
				<div class="modal-body">
					<div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">
								Remark
							</label>
							<b class="pull-right">:</b>

                        </div>
                        <div class="col-md-19 lblRemarks patientInfo">

                        </div>
					</div>
                    <div class="row">
                        <textarea rows="" cols="" style="height:107px"></textarea>
                    </div>
				</div>
			    <div class="modal-footer">
                         <button type="button"     class="save"  onclick="saveReplyOnNotification(this)"  >Save</button>
						 <button type="button"  data-dismiss="divReplyOnNotification"  class="save" >Close</button>
				</div>
            </div>
			</div>
		</div>


</asp:Content>

