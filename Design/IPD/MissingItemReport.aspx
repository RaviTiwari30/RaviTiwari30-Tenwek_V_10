<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="MissingItemReport.aspx.cs" Inherits="Design_IPD_MissingItemReport" %>


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
	        getMedicineItem();
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

	    function getMedicineItem() {
	        var ddlItem = jQuery("#ddlItem");
	        jQuery("#ddlItem option").remove();
	        var MedicineItem = {
	            type: "POST",
	            url: "../Common/CommonService.asmx/bindMedicineItem",
	            data: '{ }',
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            async: false,
	            success: function (result) {
	                MedicineItem = jQuery.parseJSON(result.d);
	                if (MedicineItem != null) {
	                    ddlItem.chosen('destroy');
	                    ddlItem.append(jQuery("<option></option>").val("ALL").html("ALL"));
	                    if (MedicineItem.length == 0) {
	                        ddlItem.append(jQuery("<option></option>").val("ALL").html("---No Data Found---"));
	                    }
	                    else {
	                        for (i = 0; i < MedicineItem.length; i++) {
	                            ddlItem.append(jQuery("<option></option>").val(MedicineItem[i].ID).html(MedicineItem[i].Name));
	                        }
	                    }
	                }
	                ddlItem.chosen();
	            },
	            error: function (xhr, ajaxOptions, thrownError) {
	                jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
	            }
	        };
	        jQuery.ajax(MedicineItem);
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
		                $("#ddlDoctor").val('<%=ViewState["DoctorID"].ToString()%>').attr('disabled', 'disabled');
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
                            $("#ddlParentPanel").chosen('destroy');
                            $("#ddlParentPanel").append($("<option></option>").val("0").html("ALL"));
                            $("#ddlPanel").append($("<option></option>").val("0").html("ALL"));
                            for (i = 0; i < Data.length; i++) {
                                $("#ddlParentPanel").append($("<option></option>").val(Data[i].PanelID).html(Data[i].Company_Name));
                                $("#ddlPanel").append($("<option></option>").val(Data[i].PanelID).html(Data[i].Company_Name));
                            }
                        }
                    }
                    else {
                        $("#ddlParentPanel").append($("<option></option>").val("0").html("--No Panel Found--"));
                    }
                    $("#ddlParentPanel").chosen();
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
			<b>Missing Item Report</b><br />
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
					  <div class="row" style="display:none;">
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
					  <div class="row" style="display:none;">
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
							 <asp:TextBox ID="txtAgeTo" runat="server" AutoCompleteType="Disabled" TabIndex="6" ClientIDMode="Static" onkeyup="if(event.keyCode==13){Search(0);};" ToolTip="Enter Age To" Width="71px" MaxLength="3" Height="22px"></asp:TextBox>
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
						 <asp:TextBox ID="ucToDate" runat="server" ToolTip="Click To Select To Date" ReadOnly="true"  ClientIDMode="Static" TabIndex="14" onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>
						<cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
						 
					</div>
                    <div class="row">

<div class="col-md-3">
							<label class="pull-left">
								Medicine Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <select id="ddlItem"  title="Select Medicine" tabindex="2" onkeyup="if(event.keyCode==13){Search(0);};"></select>
						</div>

                          <div class="col-md-3">
							<label class="pull-left">
								Status
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						 <asp:RadioButtonList ID="rdblAdDis" runat="server" CssClass="ItDoseLblSpBl" RepeatDirection="Horizontal" ClientIDMode="Static" TabIndex="15" RepeatLayout="Flow">
							<asp:ListItem Selected="True" Value="M">Missing</asp:ListItem>
							<asp:ListItem Value="C">Complete</asp:ListItem>
							<asp:ListItem Value="B">Both</asp:ListItem>
                          
						</asp:RadioButtonList></div>
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
				<div id="IPDOutput" style="height:300px;width:100%;overflow-y:auto"> 
                <div class="row">
						<div id="divItems" style="height: 300px; max-height: 300px; overflow: auto" class="col-md-24">
						</div>
					</div>
                    </div>
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

	        if (IsReceived == 0) {
	            if (userauthorization == 1) {
	                modelConfirmation('Alert!!!', 'Do You Want To Receive Patient?', 'YES', 'NO', function (response) {
	                    if (response) {
	                        serverCall('../common/CommonService.asmx/IsReceivedPatient', { TID: TID, IsReceived: 1 }, function (response) {
	                            var $responseData = JSON.parse(response);
	                            modelAlert($responseData.response, function () {
	                                closestTr.remove();
	                                $("#iframePatient").attr("src", URL);
	                                if (PatientType == "VIP" || PatientType == "HANDLED WITH CARE") {
	                                    modelAlert('Patient admitted under the Patient Type : <span class="patientInfo">' + PatientType + "</span>", function () {

	                                        reseizeIframe(closestTr);
	                                    });
	                                }
	                                else {
	                                    reseizeIframe(closestTr);
	                                }
	                            });
	                        });
	                    }
	                });
	            }
	            else {
	                modelAlert('You Have No Authority To Receive This Patient.');
	            }
	        }
	        else {
	            $("#iframePatient").attr("src", URL);
	            if (PatientType == "VIP" || PatientType == "HANDLED WITH CARE") {
	                modelAlert('Patient admitted under the Patient Type : <span class="patientInfo">' + PatientType + "</span>", function () {
	                    reseizeIframe(closestTr);
	                });
	            }
	            else {
	                reseizeIframe(closestTr);
	            }

	        }
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
			$("#lblMsg").text('');
			$.ajax({
			    type: "POST",
			    url: "MissingItemReport.aspx/PatientSearch",
			    data: '{MRNo:"' + $.trim($("#txtPatientID").val()) + '",PName:"' + $.trim($("#txtName").val()) + '",Department:"' + $.trim($("#ddlDepartment").val()) + '",ItemID:"' + $.trim($("#ddlItem").val()) + '",Floor:"' + FloorID + '",AgeFrom:"' + $.trim($("#<%=txtAgeFrom.ClientID%>").val()) + '",ddlAgeFrom:"' + $.trim($("#<%=ddlAgeFrom.ClientID%>").val()) + '",AgeTo:"' + $.trim($("#<%=txtAgeTo.ClientID%>").val()) + '",ddlAgeTo:"' + $.trim($("#<%=ddlAgeTo.ClientID%>").val()) + '",RoomType:"' + RoomID + '",IPDNo:"' + $('#txtTransactionNo').val() + '",DoctorID:"' + $('#ddlDoctor').val() + '",Panel:"' + $('#ddlPanel').val() + '",ParentPanel:"' + 0 + '",FromDate:"' + $('#ucFromDate').val() + '",ToDate:"' + $('#ucToDate').val() + '",AdmitDischarge:"' + radios + '",Type:"' + Credit + '",id:"' + id + '",IsPatientReceived:' + IsPatientReceived + '}',
				dataType: "json",
				contentType: "application/json;charset=UTF-8",
				async: true,
				success: function (response) {
				      var items = jQuery.parseJSON(response.d);
				     if (items != "" && items != null) {
				       // window.open('../../Design/common/ExportToExcel.aspx');
				        var outputPatient = $('#templateItems').parseTemplate(items);
				        $('#divItems').html(outputPatient).customFixedHeader();

				    }
				    else {
				    
				         $("#lblMsg").text('No Record Found');
				         $('#divItems').html('');
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
                try {
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
	


    <script id="templateItems" type="text/html">  
	  <table  id="tableItems" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
		<thead>
           <#  var dataLength=items.length;    #>

				<#if(dataLength>0){#>
			<tr id="Header">
			
			<th class="GridViewHeaderStyle" scope="col" style="width:50px" >UHID</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px" >IPNo</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px" >PatientName</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px" >Age</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px" >Gender</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px" >Panelname</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:50px" >ItemName</th>    
			<th class="GridViewHeaderStyle" scope="col" style="width:50px" >ReceiveQty</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:50px" >Timing</th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:50px" >StartDate</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:50px" >EndDate</th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:50px" >Duration</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:50px" >PerDayConsumption</th>    
				 <#}#>

	  <#
					for(var  key in items[0])
						{
               
						   if(key.indexOf('__TOTAL')>-1)
						#>          
						   <th class="GridViewHeaderStyle" scope="col"   style="width:115px" >
								<table  id="TOTALMED" cellspacing="0" rules="all"  style="width:100%;border-collapse :collapse; border: transparent;">
									 <thead>
										  <tr>
											<th colspan="2" style="max-width:110px;text-align:center !important" class="GridViewHeaderStyle trimText" title="<#=key.split("__")[0]#>" scope="col" ><#=key.split("__")[0]#></th>
										 </tr>
										 <tr>
											<th class="GridViewHeaderStyle" scope="col" >Consumption</th>
											<th class="GridViewHeaderStyle" scope="col" >Remaining</th>
										 </tr>
									 </thead>
									</table>
						   </th>    
					<#}#>   
						
		</tr>
			</thead>
		<tbody>
				   
			<#
			
				var objRow;
				for(var j=0;j<dataLength;j++)
				{
					objRow = items[j];
				#>          
				<tr id="tr_<#=(j+1)#>"   >
					
					<td style="display:none" id="tdItemID"><#=objRow.ItemID#></td> 
					<td class="trimText" style="max-width:137px" title="<#=objRow.UHID#>" id="tdUHID"><#=objRow.UHID#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.IPNo#>" id="tdIPNo"><#=objRow.IPNo#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.PatientName#>" id="tdPatientName"><#=objRow.PatientName#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.Age#>" id="tdAge"><#=objRow.Age#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.Gender#>" id="tdGender"><#=objRow.Gender#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.Panelname#>" id="tdPanelname"><#=objRow.Panelname#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.ItemName#>" id="tdItemName"><#=objRow.ItemName#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.ReceiveQty#>" id="tdReceiveQty"><#=objRow.ReceiveQty#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.Timing#>" id="tdTiming"><#=objRow.Timing#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.StartDate#>" id="tdStartDate"><#=objRow.StartDate#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.EndDate#>" id="tdEndDate"><#=objRow.EndDate#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.Duration#>" id="tdDuration"><#=objRow.Duration#> </td>
                    <td class="trimText" style="max-width:137px" title="<#=objRow.PerDayConsumeQty#>" id="tdPerDayConsumeQty"><#=objRow.PerDayConsumeQty#> </td>
					
					
					<#
					for(var  key in objRow)
						{
						   if(key.indexOf('__TOTAL')>-1)
						#>          
						   <td id="td1">
								 <table  id='<#=key.split("__")[2]#>' class="__TOTAL" cellspacing="0" rules="all"  style="width:100%;border-collapse :collapse; border: transparent;">
									 <tbody>
										 <tr>
											<td id="td2"  scope="col" >

                                             <%--<#if( objRow[key].split("#")[0] >0 && objRow[key].split("#")[1]==0  ){ #>
							                  checked="checked"
							                 <#}#>   
                                             <#if(  objRow[key].split("#")[1]>0  ){ #>
							                  checked="checked"
							                 <#}#>   --%>

                                              
											<input  style='<#=(objRow[key].split("#")[0]>0 && objRow[key].split("#")[1]==0)?"background-color:hsl(101, 55%, 56%)":"" #>'
													id='Text0'    class="ConsumeQty"   value='<#=objRow[key].split("#")[0] #>' type="text" onpaste="return false" readonly  />
											</td>
											<td id="td3"  scope="col" >
                                                <input  style='<#=(objRow[key].split("#")[1]>0)?"background-color:#ef8989":"" #>'
													id='Text1'    class="ConsumeQty"   value='<#=objRow[key].split("#")[1] #>' type="text" onpaste="return false" readonly />
											
											   <%--<input  
												   
													id='Text1'     class="RemainingQty" style="padding:2px"   value='' type="text"  onpaste="return false"   />--%>
											</td>
										 </tr>
									 </tbody>
								 </table>
						   </td>
					<#}#>   

				</tr>
			<#}#>   
			 </tbody>         
		 </table>       
	</script>

</asp:Content>