<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientVehicleRequest.aspx.cs" Inherits="Design_Transport_PatientVehicleRequest" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    
    <script type="text/javascript" src="../../Scripts/moment.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            //Bind controls            
            binPurpose();
            bindRequest();
            AvailabilityStatus();

            $("#txtTime_txtTime").attr("tabindex", "2");

            $("#txtTime_txtTime")

            $("#ddlVehicleType").change(function () {
                AvailabilityStatus();
            });

            //$("#txtDate").blur(function () {
            //    AvailabilityStatus();
            //});

            $("#txtTime_txtTime").blur(function () {
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

            $("#btnSave").click(function () {
                $("#lblErrorMsg").text("");
                if ($.trim($("#txtDate").val()) == "") {
                    $("#txtDate").focus();
                    $("#lblErrorMsg").text("Please Enter Traveling Date");
                    return;
                }

                if ($.trim($("#txtTime_txtTime").val()) == "") {
                    $("#txtTime_txtTime").focus();
                    $("#lblErrorMsg").text("Please Enter Traveling Time");
                    return;
                }

                getDateTime();
                var EnterDateTime = moment($("#txtDate").val() + " " + $("#txtTime_txtTime").val(), 'DD-MMM-yyyy HH:mm A');
                var CurrentDateTime = moment($('#spnDateTime').text(), 'MM/DD/yyyy HH:mm A');
                var EnterDateTime = new Date(EnterDateTime.format('MMMM DD,YYYY HH:mm:ss'));
                var CurrentDateTime = new Date(CurrentDateTime.format('MMMM DD,YYYY HH:mm:ss'));

                if (EnterDateTime.getTime() < CurrentDateTime.getTime()) {
                    $("#lblErrorMsg").text('Travel Time can not be less than Current Time!');
                    $("#txtArrivalTime").focus();
                    return false;
                }


                if ($.trim($("#ddlVehicleType option:selected").text()) == "Select") {
                    $("#ddlVehicleType").focus();
                    $("#lblErrorMsg").text("Please Select Vehicle Type");
                    return;
                }

                if ($.trim($("#ddlPurpose").val()) == "0") {
                    $("#ddlPurpose").focus();
                    $("#lblErrorMsg").text("Please Select Purpose");
                    return;
                }

                $("#btnSave").val("Submitting...");
                $("#btnSave").attr("disabled", true);

                $.ajax({
                    url: "PatientVehicleRequest.aspx/SaveRequest",
                    data: '{MRNo:"' + $("#lblMRNo").text().trim() + '",IPDNo:"' + $("#lblIPDNo").text().trim() + '",Type:"' + $("#ddlVehicleType option:selected").text().trim() + '",Date:"' + $("#txtDate").val().trim() + '",Time:"' + $("#txtTime_txtTime").val().trim() + '",Purpose:"' + $("#ddlPurpose").val().trim() + '",userID:"' + $("#lblUserID").text().trim() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d != null && result.d == "1") {
                            $("#lblErrorMsg").text("Record Saved Successfully");
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            clear();
                            window.open("PatientVehicleRequest.aspx?TransactionID=" + $("#lblIPDNo").text() + "&PatientID=" + $("#lblMRNo").text() + "&Sex=&AdmissionType=", "_self");
                            //bindRequest();
                        }
                        else {
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            $("#lblErrorMsg").text("Error occurred, Please contact administrator");
                        }
                    },
                    error: function (xhr, status) {
                        $("#btnSave").val("Save");
                        $("#btnSave").attr("disabled", false);
                        $("#lblErrorMsg").text("Error occurred, Please contact administrator");
                    }
                });
            });
        });

        function changedate() {
            AvailabilityStatus();
        }

        function getDateTime() {
            $.ajax({
                url: "../Common/CommonService.asmx/getFormatedDate",
                data: '{}',
                type: "POST",
                dataType: "json",
                async: false,
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    $('#spnDateTime').text(mydata.d);
                }
            });
        }

        function binPurpose() {
            $('#lblErrorMsg').text('');
            $("#ddlPurpose").empty();
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/bindPurpose",
                data: '{}',
                dataType: "json",
                async: false,
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
                    $("#lblErrorMsg").text("Error occurred, Please contact administrator");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindRequest() {
            $.ajax({
                url: "PatientVehicleRequest.aspx/bindRequests",
                data: '{MRNo:"' + $.trim($("#lblMRNo").text()) + '",IPDNo:"' + $.trim($("#lblIPDNo").text()) + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d != null && result.d != "0") {
                        PatientRequest = $.parseJSON(result.d);
                        var HtmlOutput = $("#PatientRequestScript").parseTemplate(PatientRequest);
                        $("#PatientRequest_DIV").html(HtmlOutput);
                        $("#PatientRequest_DIV,#PatientRequest_DIV1").show();
                    }
                    else {
                        $("#PatientRequest_DIV").empty();
                        $("#PatientRequest_DIV,#PatientRequest_DIV1").hide();
                    }
                },
                error: function (xhr, status) {
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
                data: '{Date:"' + $("#txtDate").val() + '",Time:"' + $("#txtTime_txtTime").val() + '",VehicleType:"' + $("#ddlVehicleType").val() + '"}',
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
                        $("#request_div").hide();
                    }
                },
                error: function (xhr, status) {
                    $("#request_div").empty();
                    $("#request_div").hide();
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
                $("#spnStatus").text("");
            }
        }

        function saveNewPurpose() {
            $("#spnPurpose").text("");

            if ($.trim($("#txtPurpose").val()) == "") {
                modelAlert("Please Enter New Purpose");
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
                        $('#divPurpose').closeModel();
                        $("#txtPurpose").val('');
                    }
                    else if (data == "2") {
                        $('#lblErrorMsg').text("Purpose Already Exist");
                        $('#divPurpose').closeModel();
                    }
                    else if (data == "0") {
                        $('#lblErrorMsg').text("Error occurred, Please contact administrator");
                        $('#divPurpose').closeModel();
                    }
                }
            });
        }             

        function clear() {
            $("#ddlVehicleType option:contains('Select')").attr("selected", true);
            $("#ddlPurpose").val("0");
        }

        var openDivPurpose = function (e) {
            e.preventDefault();
            var divPurpose = $('#divPurpose');
            divPurpose.showModel();
        }

        var validateGroupName = function (e) {

            if ($.trim($('#txtGroupName').val()) == '') {
                modelAlert('Enter Group Name');
                $('#txtGroupName').focus();
                return false;
            }

            __doPostBack('btnNewGroupPopUp', '');
        }

    </script>
    <script type="text/ecmascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }

        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                closePurpose();
            }
        }
    </script>

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b><span id="lblHeader" style="font-weight: bold;">Patient Request for Vehicle</span></b><br />
                <span id="lblErrorMsg" class="ItDoseLblError"></span>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Request Detail
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Travel Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtDate" runat="server" ToolTip="Select Traveling Date" ClientIDMode="Static" TabIndex="1" onchange="changedate();" CssClass="requiredField" />
                                <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-2">
                                <uc1:Time ID="txtTime" runat="server" class="requiredField" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                   Vehicle Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlVehicleType" title="Select Vehicle Type" class="requiredField" tabindex="3">
                                    <option selected="selected">Select</option>
                                    <option>Normal</option>
                                    <option>Ambulance</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Purpose
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlPurpose" class="requiredField" title="Select Purpose" tabindex="4"></select>
                            </div>
                            <div class="col-md-1">
                                <asp:Button ID="btnPurpose" runat="server" CssClass="ItDoseButton" Text="New" OnClientClick="openDivPurpose(event);"  />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-11">
                            </div>
                            <div class="col-md-2">
                                <input type="button" id="btnSave" class="ItDoseButton" title="Click To Save" value="Save" />
                            </div>
                            <div class="col-md-11">
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
            <div id="PatientRequest_DIV1" class="POuter_Box_Inventory" style="text-align: center; display: none; overflow: auto;">
                <div class="Purchaseheader" style="width: 100%;">
                    Patient Requests
                </div>
                <div id="PatientRequest_DIV" style="width: 100%;">
                </div>
            </div>
        </div>

        <div id="divPurpose" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width: 200px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divPurpose" area-hidden="true">&times;</button>
                        <b class="modal-title">Create New Purpose</b>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="pull-left">Purpose</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-18">
                                        <input type="text" id="txtPurpose" maxlength="500" title="Enter Purpose" style="width: 300px;" class="requiredField" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" onclick="saveNewPurpose();" value="Save" class="ItDoseButton" id="btnPurposeSave" title="Click To Save" />
                        <button type="button" data-dismiss="divPurpose">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <asp:Label ID="lblUserID" runat="server" ClientIDMode="Static" Style="display: none;" />
    <asp:Label ID="lblMRNo" runat="server" ClientIDMode="Static" Style="display: none;" />
    <asp:Label ID="lblIPDNo" runat="server" ClientIDMode="Static" Style="display: none;" />        
    <span id="spnDateTime" style="display: none;" />

    <!-------------------------Status Script--------------------------------->
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
		    <#}#>                   
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
		    <#}#>                   
	    </table>    
    </script>   
    <!-------------------------Status Script--------------------------------->
    
    <!-------------------------Bind Patient Requests------------------------->
    <script type="text/html" id="PatientRequestScript">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">IPDNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">MRNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Request Date</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Travel Date Time</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle Type</th>   
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Purpose</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Cancel By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Cancel Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Reason</th>               	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle No</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Driver Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Departure Date Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Arrival Date Time</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Place Visited</th>             				                                        	
		    </tr>
		    <#       
		    var dataLength=PatientRequest.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {        
                var strStyle="";
		        objRow = PatientRequest[j];  
                
                if(objRow.IsCancel=="1"){
                    strStyle="background-color: #ffffff;"; 
                }
                else
                {
                    if(objRow.IsComplete=="0"){
                        strStyle="background-color: #99bbff;";          
                    }
                    else{
                        if(objRow.Status=="1"){
                            strStyle="background-color: #F48FB1;";                       
                        }
                        else{                        
                            strStyle="background-color: #4DB6AC;";
                        }
                    }
                }              
		    #>
            <tr style="<#=strStyle#>">                                          
                <td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=(j+1)#></td>
                <td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=objRow.IPDNo#></td>
                <td class="GridViewLabItemStyle" style="width:150px;text-align:center; "><#=objRow.Patient_ID#></td>    
                <td class="GridViewLabItemStyle" style="width:150px;text-align:left; "><#=objRow.PName#></td>
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.RequestDate#></td>
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.TravelDate#><br/><#=objRow.TravelTime#></td>
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center"><#=objRow.VehicleType#></td>
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center"><#=objRow.Purpose#></td>
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.CancelBy#></td>
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.CancelDate#></td>
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.CancelReason#></td> 
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.VehicleNo#></td>
                <td class="GridViewLabItemStyle" style="width:100px;text-align:left;"><#=objRow.DriverName#></td>
                <td class="GridViewLabItemStyle" style="width:120px;text-align:center;"><#=objRow.DepartureDate#><br /><#=objRow.DepartureTime#></td>                                                                  
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.ArrivalDate#><br /><#=objRow.ArrivalTime#></td>  
                <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.PlaceVisited#></td>                      
            </tr>             
		    <#}#>                   
	    </table>    
    </script>
    <!-------------------------Bind Patient Requests------------------------->
</body>
</html>
