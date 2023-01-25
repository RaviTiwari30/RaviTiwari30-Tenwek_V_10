<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="VehicleRequest.aspx.cs" Inherits="Design_Transport_VehicleRequest" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script type="text/javascript">
	    $(document).ready(function () {
	        bindDepartment();
	        binPurpose();
	        AvailabilityStatus();

	        $("#ddlVehicleType").change(function () {
	            AvailabilityStatus();
	        });

	        $("#ctl00_ContentPlaceHolder1_txtTime_txtTime").blur(function () {
	            AvailabilityStatus();
	        });


	        $("#txtPurpose").keypress(function (e) {
	            var keynum
	            var keychar
	            // For Internet Explorer  
	            if (window.event) {
	                keynum = e.keyCode
	            }
	                // For Netscape/Firefox/Opera  
	            else if (e.which) {
	                keynum = e.which
	            }
	            keychar = String.fromCharCode(keynum)
	            //List of special characters you want to restrict

	            if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "/" || keychar == "`") {
	                return false;
	            }
	            else {
	                return true;
	            }
	        });



	    });

	    function changedate() {
	        AvailabilityStatus();
	    }

	    function bindDepartment() {
	        $("#ddlDepFrom,#ddlDepTo").empty();
	        $.ajax({
	            url: "../common/CommonService.asmx/bindRoleDepartment",
	            data: '{}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            dataType: "json",
	            success: function (result) {
	                if (result.d != null && result.d != "") {
	                    var Dept = $.parseJSON(result.d);
	                    for (var i = 0; i < Dept.length; i++) {
	                        $("#ddlDepFrom,#ddlDepTo").append($("<option></option>").val(Dept[i].DeptLedgerNo).html(Dept[i].DeptName));
	                    }
	                    //$("#ddlDepFrom option:contains('TRANSPORT')").remove();
	                    $("#ddlDepFrom").val($("#lblLoginType").text());
	                    $("#ddlDepTo option:contains('TRANSPORT')").attr("selected", true);
	                    $("#ddlDepTo").attr("disabled", true);
	                }
	                else {
	                    $("#ddlDepFrom,#ddlDepTo").append($("<option></option>").val("0").html("--No Data--"));
	                }
	            },
	            error: function (xhr, status) {
	            }
	        });
	    }

	    function binPurpose() {
	        $('#lblErrormsg').text('');
	        $("#ddlPurpose").empty();
	        $.ajax({
	            type: "POST",
	            url: "Services/Transport.asmx/bindPurpose",
	            data: '{}',
	            dataType: "json",
	            contentType: "application/json;charset=UTF-8",
	            success: function (response) {
	                purpose = jQuery.parseJSON(response.d);
	                if (purpose != null) {
	                    $("#ddlPurpose").append($("<option></option>").val("0").html("Select"));
	                    for (i = 0; i < purpose.length; i++) {
	                        $("#ddlPurpose").append($("<option></option>").val(purpose[i].Id).html(purpose[i].Purpose));
	                    }
	                }
	                else {
	                    $("#ddlPurpose").append($("<option></option>").val("0").html("Select"));
	                }
	            },
	            error: function (xhr, status) {
	                modelAlert('Error Occured');
	                window.status = status + "\r\n" + xhr.responseText;
	            }
	        });
	    }

	    function saveNewPurpose() {

	        $("#spnPurpose").text("");
	        if ($.trim($("#txtPurpose").val()) == "") {
	            $("#spnPurpose").text("Please Enter New Purpose");
	            return;
	        }

	        $.ajax({

	            url: "Services/Transport.asmx/savePurpose",
	            data: '{Purpose:"' + $.trim($("#txtPurpose").val()) + '"}',
	            type: "POST",
	            async: true,
	            dataType: "json",
	            contentType: "application/json; charset=utf-8",
	            success: function (mydata) {
	                var data = mydata.d;
	                if (data == "1") {
	                    binPurpose();
	                    $("#lblErrorMsg").text("Purpose Saved Successfully");
	                    closePurpose();
	                }
	                else if (data == "2") {
	                    $('#lblErrorMsg').text("Purpose Already Exist");
	                    closePurpose();
	                }
	                else if (data == "0") {
	                    $('#lblErrorMsg').text("Error occurred, Please contact administrator");
	                    closePurpose();
	                }
	            }
	        });


	    }

	    function AvailabilityStatus() {

	        $("#vehicle_div").empty();
	        var Requests = Array();
	        var Status = Array();

	        $.ajax({

	            url: "Services/Transport.asmx/currentVehicleStatus",
	            data: '{}',
	            type: "POST",
	            async: false,
	            dataType: "json",
	            contentType: "application/json; charset=utf-8",
	            success: function (mydata) {
	                if (mydata.d != null && mydata.d != "0") {
	                    VehicleStatus = $.parseJSON(mydata.d);
	                    if (VehicleStatus.length > 0) {
	                        var HtmlOutput = $("#statusScript").parseTemplate(VehicleStatus);
	                        $("#vehicle_div").html(HtmlOutput);
	                        $("#vehicle_div,#vehicle_div1").show();
	                        Status = VehicleStatus;
	                    }
	                    else {
	                        $("#vehicle_div,#vehicle_div1").hide();
	                    }
	                }
	                else {
	                    $("#vehicle_div").empty();
	                    $("#vehicle_div,#vehicle_div1").hide();
	                }
	            },
	            error: function (xhr, status) {
	                $("#vehicle_div").empty();
	                $("#vehicle_div,#vehicle_div1").hide();
	            }
	        });


	        $.ajax({

	            url: "Services/Transport.asmx/currentRequestStatus",
	            data: '{Date:"' + $("#txtDate").val() + '",Time:"' + $("#ctl00_ContentPlaceHolder1_txtTime_txtTime").val() + '",VehicleType:"' + $("#ddlVehicleType").val() + '"}',
	            type: "POST",
	            async: false,
	            dataType: "json",
	            contentType: "application/json; charset=utf-8",
	            success: function (mydata) {
	                if (mydata.d != null && mydata.d != "0") {
	                    AllRequest = $.parseJSON(mydata.d)
	                    if (AllRequest.length > 0) {
	                        var HtmlOutput = $("#SearchResult").parseTemplate(AllRequest);
	                        $("#request_div").html(HtmlOutput);
	                        $("#request_div,#request_div1").show();
	                        Requests = AllRequest;
	                    }
	                    else {
	                        $("#request_div").empty();
	                        $("#request_div,#request_div1").hide();
	                    }
	                }
	                else {
	                    $("#request_div").empty();
	                    $("#request_div,#request_div1").hide();
	                }
	            },
	            error: function (xhr, status) {
	                $("#request_div").empty();
	                $("#request_div,#request_div1").hide();
	            }
	        });

	        var RequestCount = 0;
	        var VehicleCount = 0;

	        if (Requests.length > 0) {

	            if (Requests[0]["IsNewDay"] == "1") {
	                if ($("#ddlVehicleType").val() != "Normal") {
	                    for (var i = 0; i < Requests.length; i++) {
	                        if (Requests[i]["VehicleType"] == "Normal")
	                            RequestCount++;
	                    }
	                    VehicleCount = Number(Status[1]["Total"]);
	                }
	                else if ($("#ddlVehicleType").val() != "Ambulance") {
	                    for (var i = 0; i < Requests.length; i++) {
	                        if (Requests[i]["VehicleType"] == "Ambulance")
	                            RequestCount++;
	                    }
	                    VehicleCount = Number(Status[0]["Total"]);
	                }
	                else {
	                    for (var i = 0; i < Requests.length; i++) {
	                        RequestCount++;
	                    }

	                    VehicleCount = Number(Status[0]["Total"]) + Number(Status[1]["Total"]);
	                }

	            }
	            else {
	                if ($("#ddlVehicleType").val().toUpperCase() == "NORMAL") {
	                    for (var i = 0; i < Requests.length; i++) {
	                        if (Requests[i]["VehicleType"].toUpperCase() == "NORMAL")
	                            RequestCount++;
	                    }
	                    VehicleCount = Number(Status[1]["iIN"]);
	                }
	                else if ($("#ddlVehicleType").val().toUpperCase() == "AMBULANCE") {
	                    for (var i = 0; i < Requests.length; i++) {
	                        if (Requests[i]["VehicleType"].toUpperCase() == "AMBULANCE")
	                            RequestCount++;
	                    }
	                    VehicleCount = Number(Status[0]["iIN"]);
	                }
	                else {
	                    for (var i = 0; i < Requests.length; i++) {
	                        RequestCount++;
	                    }

	                    VehicleCount = Number(Status[0]["iIN"]) + Number(Status[1]["iIN"]);
	                }
	            }
	        }
	        else {
	            if ($("#ddlVehicleType").val().toUpperCase() == "NORMAL") {
	                VehicleCount = Number(Status[1]["Total"]);
	            }
	            else if ($("#ddlVehicleType").val().toUpperCase() == "AMBULANCE") {
	                VehicleCount = Number(Status[0]["Total"]);
	            }
	            else {
	                VehicleCount = Number(Status[1]["Total"]) + Number(Status[0]["Total"]);
	            }
	        }

	        if (VehicleCount > RequestCount) {
	            $("#spnStatus").text("Possible Available " + ($("#ddlVehicleType").val() != "Select" ? $("#ddlVehicleType").val() : "") + " Vehicle : " + (VehicleCount - RequestCount)).css("color", "green");
	        }
	        else {
	            //$("#spnStatus").text("Possible Available " + ($("#ddlVehicleType").val() != "Select" ? $("#ddlVehicleType").val() : "") + " Vehicle : 0").css("color", "red");;
	        }

	    }

	    function closePurpose() {
	        $find('mpPurpose').hide();
	        $("#txtPurpose").val('');
	        $("#spnPurpose").text('');
	    }
	    function cancelPurpose() {
	        $("#txtPurpose").val('');
	        $("#spnPurpose").text('');
	    }

	    function clear() {
	        $("#ddlDepFrom option:contains('" + $("#lblLoginType").text() + "')").attr("selected", true);
	        $("#ddlVehicleType option:contains('Select')").attr("selected", true);
	        $('#txtComment').val('');
	        $("#ddlPurpose").val("0");
	    }

	</script>
	
	<div class="body_box_inventory">
			<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

		  <div style="height:40px;"></div>
		<div  class="POuter_Box_Inventory" style="text-align: center;">
			<b><span id="lblHeader" style="font-weight: bold;">Department Request for Vehicle</span></b><br />
			<span id="lblErrorMsg" class="ItDoseLblError"></span>
		</div>
	  
	
		<div class="POuter_Box_Inventory"  style="text-align: center;">
			<div class="Purchaseheader">
			  Search Criteria
			</div>
	  </div>

			<div class="POuter_Box_Inventory"  style="text-align: center;">
				<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">                     
						<div class="col-md-3">                         
							Department From
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5"  style="text-align:left">
							 <select id="ddlDepFrom" style="width: 156px;" title="Select From Department"></select>
						</div>                        
						<div class="col-md-3">                          
							Department To
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5"  style="text-align:left"> 
							  <select id="ddlDepTo" style="width: 156px;" title="Select To Department"></select> 
							<asp:Label ID="lblLoginType" runat="server" ClientIDMode="Static" Style="display: none;" />        
						</div>

						 <div class="col-md-3">                          
						   Type of Vehicle
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5"  style="text-align:left"> 
							   <select id="ddlVehicleType" style="width: 156px;" title="Select Vehicle Type"   class="requiredField">
								<option selected="selected">Select</option>
								<option>Normal</option>
								<option>Ambulance</option>
							</select>
						</div>

					</div>
				</div>
				<div class="col-md-1"></div>
			</div>


		<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">                     
						<div class="col-md-3">                         
							<span id="Span2" class="pull-left">Traveling Date</span>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5"  style="text-align:left">
							   <asp:TextBox ID="txtDate" runat="server" ToolTip="Select Traveling Date" Width="151px" ClientIDMode="Static" onchange="changedate();"/>
							<cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>                        
						<div class="col-md-3">                          
						   Traveling Time
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5"  style="text-align:left"> 
							  <uc1:Time ID="txtTime" runat="server" /> 
						</div>
						<div class="col-md-3">                           
						   Purpose                   
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5"  style="text-align:left">                            
							  <select id="ddlPurpose" style="width: 155px" title="Select Purpose"   class="requiredField"></select>
							<asp:Button ID="btnPurpose" runat="server" CssClass="ItDoseButton" Text="New" />
						</div>
					</div>

                    <div class="row">  
                        <div class="col-md-16">
                            </div>

                        <div class="col-md-3">                           
						          Comment            
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5"  style="text-align:left">                            
							 <textarea  id="txtComment" cols="2" rows="2"></textarea>
						</div>

                        </div>


				</div>
				<div class="col-md-1"></div>
			</div>


		<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">                     
						<div class="col-md-24" style="text-align:center;">                         
							<input type="button" id="btnSave" class="ItDoseButton" title="Click To Save" value="Save"  onclick="saveRequest()"/>
						</div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>


			</div>
	 
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<span id="spnStatus" style="font-size: 15pt;"></span>
		</div>
		<div class="POuter_Box_Inventory" style="text-align: center; display: none;" id="vehicle_div1">
			<div class="Purchaseheader">
				Current Vehicle Status 
			</div>
			<div id="vehicle_div" style="margin: 0 auto;">
			</div>
		</div>
		<div class="POuter_Box_Inventory" style="text-align: center; display: none;" id="request_div1">
			<div class="Purchaseheader">
				Pending Vehicle Request
			</div>
			<div id="request_div">
			</div>
		</div>
 
	<cc1:ModalPopupExtender ID="mpPurpose" runat="server" BackgroundCssClass="filterPupupBackground"
		CancelControlID="btnPurposeCancel" DropShadow="true" PopupControlID="pnlPurpopse"
		TargetControlID="btnPurpose" OnCancelScript="cancelPurpose()" BehaviorID="mpPurpose">
	</cc1:ModalPopupExtender>
	<asp:Panel ID="pnlPurpopse" runat="server" CssClass="pnlItemsFilter" Style="display: none" Width="450px">
		<div id="Div3" class="Purchaseheader" runat="server">
			Create New Purpose&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <em><span style="font-size: 7.5pt">Press esc or click
							<img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closePurpose()" />
				  to close</span></em>
		</div>
		<table style="width: 100%">
			<tr>
				<td style="text-align: center" colspan="2">
					<span id="spnPurpose" class="ItDoseLblError"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: right">&nbsp;Purpose :&nbsp;
				</td>
				<td>
					<input type="text" id="txtPurpose" maxlength="500" title="Enter Purpose" style="width: 300px;" />
					<span style="color: red; font-size: 10px;">*</span>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: center">
					<input type="button" onclick="saveNewPurpose();" value="Save" class="ItDoseButton" id="btnPurposeSave" title="Click To Save" />&nbsp;
					<asp:Button ID="btnPurposeCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
				</td>
			</tr>
		</table>
	</asp:Panel>
	   </div>
	  
		<script type="text/html" id="SearchResult">
		<table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;">
			<tr>            
				<th class="GridViewHeaderStyle" scope="col" style="width:50px;">S.No.</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Request Type</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Travel Date</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Travel Time</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle Type</th>			    	                				                                        	
			</tr>
			<#       
			var dataLength=AllRequest.length;
			window.status="Total Records Found :"+ dataLength;
			var objRow;               
			for(var j=0;j<dataLength;j++)
			{
				objRow=AllRequest[j];
								
			#>
					<tr>                                          
						<td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=(j+1)#></td>
						<td class="GridViewLabItemStyle" style="width:100px;text-align:center;" ><#=objRow.RequestType#></td>
						<td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.TravelDate#></td>    
						<td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.TravelTime#></td> 
						<td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.VehicleType#></td>                        
					</tr>            
				
			<#}        
			#>                   
		</table>    
	</script>

	<script type="text/html" id="statusScript">
		<table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;">
			<tr>            
				<th class="GridViewHeaderStyle" scope="col" style="width:50px;">S.No.</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle Type</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:100px;">TOTAL</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:100px;">OUT</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:100px;">IN</th>			    	                				                                        	
			</tr>
			<#       
			var dataLength=VehicleStatus.length;
			window.status="Total Records Found :"+ dataLength;
			var objRow;               
			for(var j=0;j<dataLength;j++)
			{
				objRow=VehicleStatus[j];
								
			#>
					<tr>                                          
						<td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=(j+1)#></td>
						<td class="GridViewLabItemStyle" style="width:100px;text-align:center;" ><#=objRow.VehicleType#></td>
						<td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.Total#></td>    
						<td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.iOut#></td> 
						<td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.iIN#></td>                        
					</tr>            
				
			<#}        
			#>                   
		</table>    
	</script>
	<script type="text/javascript">
	    function saveRequest() {


	        $("#lblErrorMsg").text("");

	        if ($.trim($("#ctl00_ContentPlaceHolder1_txtTime_txtTime").val()) == "") {
	            $("#ctl00_ContentPlaceHolder1_txtTime_txtTime").focus();
	            $("#lblErrorMsg").text("Please Enter Traveling Time");
	            return;
	        }
	        if ($.trim($("#ddlVehicleType").val()) == "Select") {
	            $("#ddlVehicleType").focus();
	            $("#lblErrorMsg").text("Please Select Vehicle Type");
	            return;
	        }
	        if ($("#ddlPurpose").val() == "0") {
	            $("#ddlPurpose").focus();
	            $("#lblErrorMsg").text("Please Select Purpose");
	            return;
	        }


	        $("#btnSave").val("Submitting...");
	        $("#btnSave").attr("disabled", true);
	        $.ajax({
	            url: "VehicleRequest.aspx/SaveRequest",
	            data: '{FromDept:"' + $("#ddlDepFrom").val() + '",ToDept:"' + $("#ddlDepTo").val() + '",Type:"' + $("#ddlVehicleType").val() + '",Date:"' + $("#txtDate").val() + '",Time:"' + $("#ctl00_ContentPlaceHolder1_txtTime_txtTime").val() + '",Purpose:"' + $("#ddlPurpose").val() + '",PurposeName:"' + $('#ddlPurpose option:selected').text() + '",Comment:"' + $('#txtComment').val() + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            dataType: "json",
	            success: function (result) {
	                if (result.d != null && result.d == "1") {
	                    modelAlert('Requet Sent to Transport');
	                    $("#btnSave").val("Save");
	                    $("#btnSave").attr("disabled", false);
	                    clear();
	                }
	                else {
	                    $("#btnSave").val("Save");
	                    $("#btnSave").attr("disabled", false);
	                    DisplayMsg("MM05", "lblErrorMsg");
	                }
	            },
	            error: function (xhr, status) {
	                alert(status);
	                DisplayMsg("MM05", "lblErrorMsg");
	            }

	        });



	    }
	</script>
</asp:Content>

