<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PatientOutstandingNotify.aspx.cs" Inherits="Design_IPD_PatientOutstandingNotify" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	
	
	<script type="text/javascript">
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
	                    ddlDepartment.append(jQuery("<option></option>").val("ALL").html("ALL"));
	                    if (department.length == 0) {
	                        ddlDepartment.append(jQuery("<option></option>").val("ALL").html("---No Data Found---"));
	                    }
	                    else {
	                        for (i = 0; i < department.length; i++) {
	                            ddlDepartment.append(jQuery("<option></option>").val(department[i].ID).html(department[i].Name)).chosen('destroy').chosen();
	                        }
	                    }
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
	            url: "PatientOutstandingNotify.aspx/BindFloor",
	            data: '{ }',
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            async: false,
	            success: function (result) {
	                Floor = jQuery.parseJSON(result.d);
	                if (Floor != null) {
	                    ddlFloor.append(jQuery("<option></option>").val("0").html("ALL"));
	                    if (Floor.length == 0) {
	                        ddlFloor.append(jQuery("<option></option>").val("0").html("---No Data Found---"));
	                    }
	                    else {

	                        for (i = 0; i < Floor.length; i++) {
	                            ddlFloor.append(jQuery("<option></option>").val(Floor[i].ID).html(Floor[i].NAME)).chosen('destroy').chosen();
	                            dataFloor.push(Floor[i].ID);
	                            if (Floor.length == 1)
	                                ddlFloor.val(Floor[i].ID).attr('disabled', 'disabled');
	                        }
	                    }
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
	            url: "PatientOutstandingNotify.aspx/BindRoomType",
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
	                    $("#cmbRoom").append($("<option></option>").val(RoomData[i].IPDCaseType_ID).html(RoomData[i].Name)).chosen('destroy').chosen();
	                    dataRoom.push(RoomData[i].IPDCaseType_ID);
	                    if (RoomData.length == 1)
	                        $("#cmbRoom").val(RoomData[i].IPDCaseType_ID).attr('disabled', 'disabled');
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
	                $("#ddlDoctor").append($("<option></option>").val("0").html("ALL"));
	                for (i = 0; i < Data.length; i++) {
	                    $("#ddlDoctor").append($("<option></option>").val(Data[i].DoctorID).html(Data[i].Name)).chosen('destroy').chosen();
	                }
	            },
	            error: function (xhr, status) {
	            }
	        });
	    }

	    function bindPanel() {
	        jQuery("#ddlParentPanel option").remove();
	        jQuery("#ddlPanel option").remove();
	        jQuery.ajax({
	            url: "Services/IPDAdmission.asmx/bindPanel",
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
	                        $("#ddlParentPanel").append($("<option></option>").val("0").html("ALL"));
	                        $("#ddlPanel").append($("<option></option>").val("0").html("ALL"));
	                        for (i = 0; i < Data.length; i++) {
	                            $("#ddlParentPanel").append($("<option></option>").val(Data[i].PanelID).html(Data[i].Company_Name)).chosen('destroy').chosen();
	                            $("#ddlPanel").append($("<option></option>").val(Data[i].PanelID).html(Data[i].Company_Name));
	                        }
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


	    function Search(id) {
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
	        var radios = $("#rdblAdDis input[type=radio]:checked").val();
	        var Credit = 0;
	        if ($('#chkCreditCase').is(":checked"))
	            Credit = 1;
	        $("#lblMsg").text('');
	        $.ajax({
	            type: "POST",
	            url: "PatientOutstandingNotify.aspx/PatientSearch",
	            data: '{MRNo:"' + $.trim($("#txtPatientID").val()) + '",PName:"' + $.trim($("#txtName").val()) + '",Department:"' + $.trim($("#ddlDepartment").val()) + '",Floor:"' + FloorID + '",AgeFrom:"' + $.trim($("#txtAgeFrom").val()) + '",ddlAgeFrom:"' + $.trim($("#ddlAgeFrom").val()) + '",AgeTo:"' + $.trim($("#txtAgeTo").val()) + '",ddlAgeTo:"' + $.trim($("#ctl00_ContentPlaceHolder1_ddlAgeTo").val()) + '",RoomType:"' + RoomID + '",IPDNo:"' + $('#txtTransactionNo').val() + '",DoctorID:"' + $('#ddlDoctor').val() + '",Panel:"' + $('#ddlPanel').val() + '",ParentPanel:"' + 0 + '",FromDate:"' + $('#ucFromDate').val() + '",ToDate:"' + $('#ucToDate').val() + '",AdmitDischarge:"' + radios + '",Type:"' + Credit + '",id:"' + id + '",IsPatientReceived:' + IsPatientReceived + '}',
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



	    var getSendEmailDetails = function (callback) {
	        var sendEmailDetails = [];
	        $('#IPDOutput table tbody tr td  input[type=checkbox]:checked').each(function () {

	            var row = $(this).closest('tr');
	            var data=JSON.parse(($(row).find('.tdData').text()));
	            var transactionID = data.TransactionID;
	            var outStandingAmount = data.IPDOutstanding;
	            var mobile = data.Mobile;
	            if ($('#chkkinsms').is(':checked'))
	                mobile = data.kinPhone;
	            
	            var email = data.email;

	            sendEmailDetails.push({
	                TransactionID: data.TransactionID,
	                PatientID:data.PatientID,
	                OutStandingAmount: data.IPDOutstanding,
	                PanelName:data.Company_Name,
	                PName: data.PName,
	                Email: data.email,
	                Phone: mobile
	            });
	        });

	        if (sendEmailDetails.length < 1) {
	            modelAlert('Please Select Patient.')
	            return false;
	        }

	        callback(sendEmailDetails);

            
	    }


	    var sendEmail = function (btnSave) {
	        getSendEmailDetails(function (data) {
	            serverCall('PatientOutstandingNotify.aspx/SendEmail', { selectedPatients: data }, function (response) {
	                var $responseData = JSON.parse(response);
	                modelAlert($responseData.response, function () {
	                    if ($responseData.status)
	                        window.location.reload();
	                    else
	                        $(btnSave).removeAttr('disabled').val('Save');
	                });
	            });
	        });
	    }



	    var sendPhoneSms = function (btnSave) {
	        getSendEmailDetails(function (data) {
	            serverCall('PatientOutstandingNotify.aspx/SendSMS', { selectedPatients: data }, function (response) {
	              
	                var $responseData = JSON.parse(response);
	                modelAlert($responseData.response, function () {
	                    if ($responseData.status)
	                        window.location.reload();
	                    else
	                        $(btnSave).removeAttr('disabled').val('Save');
	                });
	            });
	        });
	    }


	</script>
	<div id="Pbody_box_inventory">
	   <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Patient Outstanding Search</b><br />
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
							<input type="text" id="txtPatientID" onkeyup="if(event.keyCode==13){Search(0);};" tabindex="1" autocomplete="off" data-title="Enter UHID" />
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Patient Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text" id="txtName" onkeyup="if(event.keyCode==13){Search(0);};" tabindex="1" autocomplete="off" data-title="Enter Patient Name"/>
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								IPD No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtTransactionNo" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" data-title="Enter IPD No." TabIndex="9"  onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>

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
								Room Type 
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							  <select id="cmbRoom" title="Select Room Type"   tabindex="10" onkeyup="if(event.keyCode==13){Search(0);};"></select>
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
							<asp:ListItem Value="DI" Selected="True">Discharged</asp:ListItem>
							<asp:ListItem Value="BNF">Bill Not Finalised</asp:ListItem>
							<asp:ListItem Value="BF">Bill Finalised</asp:ListItem>
						</asp:RadioButtonList>
					</div>
						 </div>
				<%--	<div class="row"></div>
					  <div class="row">
						 <div class="col-md-11">
						 </div>
						  <div class="col-md-2">
								
						 </div>
						  <div class="col-md-11">
						 </div>
					  </div>
					<div class="row"></div>--%>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>
	   
        <div class="POuter_Box_Inventory textCenter">
             
            <input type="button" class="save margin-top-on-btn"  title="Click to Search Patient" tabindex="16" value="Search" id="btnSearch" onclick="Search(0)" />
            
        </div>



		<div class="POuter_Box_Inventory">
				<div id="IPDOutput" style="height:280px;width:100%;overflow-y:auto"> </div>
		</div>

        <div class="POuter_Box_Inventory textCenter">
            <input type="button" value="Send Email" class="save margin-top-on-btn" onclick="sendEmail(this)" />
            <input type="button" value="Send SMS" class="save margin-top-on-btn" onclick="sendPhoneSms(this)" />
            <input type="checkbox" id="chkkinsms" value="" />Send SMS On Kin Phone No.
         </div>
	</div>

	<script id="tb_Search" type="text/html">
		<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdIPD" style="width:100%;border-collapse:collapse;">
			<thead>
			<tr id="Header">
				<%--<th class="GridViewHeaderStyle" scope="col">Select</th>
				<th class="GridViewHeaderStyle" scope="col">Sticker</th>--%>
				<%--<th class="GridViewHeaderStyle" scope="col">Summary</th>--%>
                <th class="GridViewHeaderStyle" scope="col">#</th>
				<%--<th class="GridViewHeaderStyle" scope="col">Admit Date</th>--%>
				<th class="GridViewHeaderStyle" scope="col">UHID</th>
				<th class="GridViewHeaderStyle" style="width: 70px;" scope="col">IPD No.</th>
				<th class="GridViewHeaderStyle" scope="col">Patient Name</th>
				<th class="GridViewHeaderStyle" scope="col">Age/Sex</th>
                <th class="GridViewHeaderStyle" scope="col">Kin Phone</th>
				<th class="GridViewHeaderStyle" scope="col">Doctor</th>
				<th class="GridViewHeaderStyle" scope="col">Panel</th>
				<th class="GridViewHeaderStyle" scope="col">Room Name</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">TransactionID</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">LoginType</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">BillNo</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none">Status</th> 
                <th class="GridViewHeaderStyle" scope="col" style="">OutStanding</th>                    
				<th class="GridViewHeaderStyle" style="width: 100px;" scope="col">Last Email</th>
                <th class="GridViewHeaderStyle" style="width: 100px;" scope="col">Last SMS</th>
                <th class="GridViewHeaderStyle" >
                    <input type="checkbox" style="margin-left:-6px;" />
                </th>
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
				<td class="GridViewLabItemStyle hidden" style="text-align:center" >
                    <a  href="javascript:void(0)" class="btnselect" onclick="checkIsReceived(this)"  >
                        <input type="hidden" value="<#=objRow.IsPatientReceived#>" class="hdnselect" />
                        <input type="hidden" value="<#=objRow.TransactionID#>" class="hdnTID" />
                         <input type="hidden" value="<#=objRow.userauthorization#>" class="hdnuserauthorization" />
                        <input type="hidden" value="IPFolder.aspx?TID=<#=objRow.TransactionID#>&amp;BillNo=<#=objRow.BillNo#>&amp;PID=<#=objRow.PatientID#>&amp;LoginType=<#=objRow.LoginType#>&amp;BillNo=<#=objRow.BillNo#>&amp;sex=<#=objRow.Gender#>" class="hdnredirect" />
					   <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" id="imgframe"/>
					 </a>
					 <%--<a target="iframePatient" onclick="reseizeIframe(this);"  href="" >
					   <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" id="imgframe"/>
					 </a>--%>                                                                                        
				</td>  
				<td class="GridViewLabItemStyle hidden" style="text-align:center" >
					<img alt="Select" src="../../Images/print.GIF" style="cursor:pointer"  onclick="printSticker(this)" />
				</td>
				<td class="GridViewLabItemStyle hidden" style="text-align:center" >
					<#if(objRow.DischargeSummary !="0"){#> 
						<img alt="Select" src="../../Images/view.GIF" style="border: 0px solid #FFFFFF;" onclick="ViewDischargeSummary(this)" />
					<#}else{#>
						<img alt="Select" src="../../Images/view.GIF" style="border: 0px solid #FFFFFF;display:none" /> 
					<#}#>
				</td>   
                <td class="GridViewLabItemStyle" id="td1"  ><#=j+1#></td>
			
				<td class="GridViewLabItemStyle" id="tdPatientID"   ><#=objRow.PatientID#></td>
				<td class="GridViewLabItemStyle" id="tdIPDNo" ><#=objRow.IPDNO#></td>
				<td class="GridViewLabItemStyle" id="tdPName" ><#=objRow.PName#></td>
				<td class="GridViewLabItemStyle" id="tdSex" ><#=objRow.AgeSex#></td>
                <td class="GridViewLabItemStyle" id="tdkinphone" ><#=objRow.kinPhone#></td>
				<td class="GridViewLabItemStyle" id="tdDoctor" ><#=objRow.DName#></td>
				<td class="GridViewLabItemStyle" id="tdPanel" ><#=objRow.Company_Name#></td>
				<td class="GridViewLabItemStyle" id="tdRoom" ><#=objRow.RoomName#></td>
				<td class="GridViewLabItemStyle" id="tdAge" style="width:60px;display:none"><#=objRow.Age#></td> 
				<td class="GridViewLabItemStyle" id="tdGender" style="width:60px;display:none"><#=objRow.Gender#></td>                     
				<td class="GridViewLabItemStyle" id="tdTransactionID" style="width:60px;display:none"><#=objRow.TransactionID#></td>                     
				<td class="GridViewLabItemStyle" id="tdLoginType" style="width:60px;display:none"><#=objRow.LoginType#></td>
				<td class="GridViewLabItemStyle" id="tdBillNo"  style="width:60px;display:none" ><#=objRow.BillNo#></td>    
				<td class="GridViewLabItemStyle" id="tdstatus"  style="width:60px;display:none" ><#=objRow.Status#></td>    

                <td class="GridViewLabItemStyle hidden tdData" id="td2"   ><#= JSON.stringify(objRow)  #></td>    


                <td class="GridViewLabItemStyle" id="td4"><#=objRow.IPDOutstanding#></td>  
				<td class="GridViewLabItemStyle" id="tdAdmittedBy"><#=objRow.LastEmail#></td>  
                <td class="GridViewLabItemStyle" id="td3"><#=objRow.LastSMS#></td>  
                <td class="GridViewLabItemStyle">
                    <input type="checkbox" />
                </td>
                                                                                 
			</tr>     
			</tbody>      
			<#}#>       
		</table>    
	</script>
	
</asp:Content>

