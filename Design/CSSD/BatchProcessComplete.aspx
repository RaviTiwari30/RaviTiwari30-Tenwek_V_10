<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
	CodeFile="BatchProcessComplete.aspx.cs" Inherits="Design_CSSD_BatchProcessComplete"
	EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
		<script type="text/javascript" src="../../Scripts/Message.js"></script>
	<script type="text/javascript" >

	    function doClick(buttonName, e) {
	        //the purpose of this function is to allow the enter key to 
	        //point to the correct button to click.
	        var key;

	        if (window.event)
	            key = window.event.keyCode;     //IE
	        else
	            key = e.which;     //firefox

	        if (key == 13) {
	            //Get the button the user wants to have clicked
	            var btn = document.getElementById(buttonName);
	            if (btn != null) { //If we find the button click it
	                btn.click();
	                event.keyCode = 0
	            }
	        }
	    }
	</script>
	<script type="text/javascript">
	    var PatientData = "";
	    $(document).ready(function () {
	        loadData();
	        Search(1);

	        $('#btnAddItem').click(AddItem);
	        //$('#btnSave').click(SaveData);
	        $("#<%=ddlBatch.ClientID %>").change(AddItem);
	    });

        function SaveData() {
            var start_time1 = $('#<%=txtFromTime.ClientID %>').val();
            var end_time1 = $('#<%=txtToTime.ClientID %>').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            var start11 = $("#<%=FrmDate.ClientID %>").val();
            var end11 = $("#<%=ToDate.ClientID %>").val();

            var splitdate11 = start11.split("-");
            var dt111 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];
            var splitdate111 = end11.split("-");
            var dt211 = splitdate111[1] + " " + splitdate111[0] + ", " + splitdate111[2];

            var newStartDate11 = Date.parse(dt111);
            var newEndDate112 = Date.parse(dt211);

            var start_time1 = $('#<%=txtFromTime.ClientID %>').val();
            var end_time1 = $('#<%=txtToTime.ClientID %>').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            if ((newStartDate11 + stt1) > (newEndDate112 + endt1)) {

                alert('Approx End Date Time always greater then Start Date Time');
                return;
            }
            $('#btnSave').attr('disabled', true);
            var Itemdata = "";
            var ItemData = $("#<%=ddlBatch.ClientID %> option:selected").val();
            if ($("#<%=ddlBatch.ClientID %> option:selected").text().toUpperCase() == "Select" || ItemData == "0") {
                DisplayMsg('MM245', 'ctl00_ContentPlaceHolder1_lblmsg');
                //$("#<%=lblmsg.ClientID %>").text('Please Select Batch Name');
		        return;
		    }
            Itemdata = $("#<%=ddlBatch.ClientID %> option:selected").val() + '|' + $('#<%= FrmDate.ClientID %>').val() + ' ' + $("#<%=txtFromTime.ClientID %>").val() + '|' + $('#<%= ToDate.ClientID %>').val() + ' ' + $("#<%=txtFromTime.ClientID %>").val() + '|' + $.trim($("#<%=txtRemark.ClientID %>").val()) + '|';
            if (Itemdata == "") {
                DisplayMsg('MM018', 'ctl00_ContentPlaceHolder1_lblmsg');
                //$("#<%=lblmsg.ClientID %>").text('Please Select Item');
                $("#btnSave").attr('disabled', false);
                return;
            }
            $.ajax({

                url: "Services/BatchProcess.asmx/UpdateBatchProcessing",
                data: '{ItemData: "' + Itemdata + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        //$('ddlSetItem').find('selected', 'selected')
                        $("#tb_grdLabSearch tr:not(:first)").remove();
                        $("#tb_grdLabSearch").hide();
                        $("#<%=lblmsg.ClientID %>").text('Record Saved Successfully');
                        loadData();
                        $("#<%=txtRemark.ClientID %>").val('');
                        $("#<%=ddlBatch.ClientID%>").get(0).selectedIndex = 0;
                        $('#BoilerDetail').attr('style', 'display:none');
                    }
                    else {
                        DisplayMsg('MM07', 'ctl00_ContentPlaceHolder1_lblmsg');
                        //$("#<%=lblmsg.ClientID %>").text('Record Not Saved');
                    }

                    $("#btnSave").attr('disabled', false);
                },
                error: function (xhr, status) {

                    var err = eval("(" + xhr.responseText + ")");
                    alert(err.Message);
                    $("#btnSave").attr('disabled', false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }



        var saveBatchFinalize = function () {

            var start_time1 = $('#<%=txtFromTime.ClientID %>').val();
            var end_time1 = $('#<%=txtToTime.ClientID %>').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            var start11 = $("#<%=FrmDate.ClientID %>").val();
            var end11 = $("#<%=ToDate.ClientID %>").val();

            var splitdate11 = start11.split("-");
            var dt111 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];
            var splitdate111 = end11.split("-");
            var dt211 = splitdate111[1] + " " + splitdate111[0] + ", " + splitdate111[2];

            var newStartDate11 = Date.parse(dt111);
            var newEndDate112 = Date.parse(dt211);

            var start_time1 = $('#<%=txtFromTime.ClientID %>').val();
            var end_time1 = $('#<%=txtToTime.ClientID %>').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            if ((newStartDate11 + stt1) > (newEndDate112 + endt1)) {

                modelAlert('Actual End Date Time always greater then Start Date Time');
                return;
            }

            var data = {
                batchNo: $('#ddlBatch').val(),
                aStartDate: $('#FrmDate').val() + ' ' + $('#txtFromTime').val(),
                aEndTime: $('#ToDate').val() + ' ' + $('#txtToTime').val(),
                remarks: $.trim($('#txtRemark').val())
            };


            serverCall('BatchProcessComplete.aspx/saveBatchFinalize', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        location.reload();
                });

            });






        }






        function AddItem() {
            var IsReturn = 0;
            $("#<%=lblmsg.ClientID %>").text('');
            var ItemData = $("#<%=ddlBatch.ClientID %> option:selected").val();
            if ($("#<%=ddlBatch.ClientID %> option:selected").text().toUpperCase() == "SELECT" || ItemData == "0") {
                DisplayMsg('MM245', 'ctl00_ContentPlaceHolder1_lblmsg');

                $('#BoilerDetail').attr('style', 'display:none');
                $('#PatientLabSearchOutput').hide();
                $("#<%=ddlBatch.ClientID %>").focus();
	            IsReturn = 1;
	            return;
            }
            if (IsReturn == 0) {

                $.ajax({
                    url: "Services/BatchProcess.asmx/LoadBatchDetail",
                    data: '{BatchNo:"' + ItemData + '"}',
                    type: "POST",
                    contentType: "application/json;charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                        var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                        $('#PatientLabSearchOutput').html(output);
                        $('#PatientLabSearchOutput').show();
                        $('#BoilerDetail').attr('style', 'display:""');

                    },
                    error: function (xhr, status) {

                        DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                        //$("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
                $.ajax({
                    url: "Services/BatchProcess.asmx/BtchProcessDateTime",
                    data: '{BatchNo:"' + ItemData + '"}',
                    type: "POST",
                    contentType: "application/json;charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                        for (i = 0; i < PatientData.length; i++) {
                            PatientData = jQuery.parseJSON(result.d);
                            for (i = 0; i < PatientData.length; i++) {
                                $("#<%=FrmDate.ClientID %>").val(PatientData[i]["ApproxStartDate"]);
                                $("#<%=txtFromTime.ClientID %>").val(PatientData[i]["ApproxStartTime"]);
                                $("#<%=ToDate.ClientID %>").val(PatientData[i]["ApproxEndDate"]);
                                $("#<%=txtToTime.ClientID %>").val(PatientData[i]["ApproxEndTime"]);
                                // $find("calFromDate").set_selectedDate(null);
                                $("#<%=FrDate.ClientID %>").val(PatientData[i]["ApproxStartDate"]);
                                // $(".ajax__calendar_invalid").removeClass("ajax__calendar_active");
                                var dtcalendar = $("#<%=calFrmDate.ClientID%>");
                                var dtcalendar1 = $("#<%=calToDate.ClientID%>");
                                dtcalendar.set_selectedDate = $("#<%=FrmDate.ClientID %>").val(PatientData[i]["ApproxStartDate"]);
                                dtcalendar1.set_selectedDate = $("#<%=ToDate.ClientID %>").val(PatientData[i]["ApproxEndDate"]);
                            }

                        }
                        $('#BoilerDetail').attr('style', 'display:""');

                    },
                    error: function (xhr, status) {

                        DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                        //$("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
                $.ajax({
                    url: "BatchProcessComplete.aspx/getdate",
                    data: '{BatchNo:"' + ItemData + '",FrmDate:"' + $("#<%=FrmDate.ClientID %>").val() + '",ToDate:"' + $("#<%=ToDate.ClientID %>").val() + '"}',
                    type: "POST",
                    contentType: "application/json;charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                    },
                    error: function (xhr, status) {

                        DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }

        function loadData() {
            $("#<%=ddlBatch.ClientID %> option").remove();
            var ddlBatch = $("#<%=ddlBatch.ClientID %>");
            ddlBatch.attr("disabled", true);

            $.ajax({
                url: "Services/BatchProcess.asmx/LoadBatch",
                data: '{}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    PatientData = jQuery.parseJSON(result.d);

                    if (PatientData.length == 0) {
                        ddlBatch.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        ddlBatch.append($("<option></option>").val("Select").html("Select"))
                        for (i = 0; i < PatientData.length; i++) {
                            ddlBatch.append($("<option></option>").val(PatientData[i]["BatchNo"]).html(PatientData[i]["BatchName"]));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'ctl00_ContentPlaceHolder1_lblmsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
            ddlBatch.attr("disabled", false);
        }

        function checkAll(checked) {
            $("#tb_grdLabSearch tr").each(function () {
                // alert(checked.checked);
                $(this).find("#chk").attr("checked", checked.checked);
            });
        }
        function TimeCompare() {
            var a = 0;
            var start_time = $('#<%=txtFromTime.ClientID %>').val();
            var end_time = $('#<%=txtToTime.ClientID %>').val();
            var stt = new Date("November 13, 2013 " + start_time);
            stt = stt.getTime();
            var endt = new Date("November 13, 2013 " + end_time);
            endt = endt.getTime();
            if (stt > endt) {
                alert('Approx End-time always greater then Start-time');
                return;
            }

        }
        function ValidateDate() {
            var start1 = $("#<%=FrmDate.ClientID %>").val();
		     var end1 = $("#<%=ToDate.ClientID %>").val();

		     var splitdate1 = start1.split("-");
		     var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
		     var splitdate11 = end1.split("-");
		     var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

		     var newStartDate1 = Date.parse(dt11);
		     var newEndDate1 = Date.parse(dt21);

		     if (newStartDate1 > newEndDate1) {
		         alert("Approx Of End Date should be greater than Start Date");
		         $("#<%=ToDate.ClientID %>").focus();
		        return;
            }
        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
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
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "43") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function checkDate(sender, args) {
            alert(sender._selectedDate); alert($("#<%=FrDate.ClientID %>").val());
            if (sender._selectedDate < $("#<%=FrDate.ClientID %>").val()) {
                alert(sender._selectedDate);
                alert("You cannot select a day earlier than today!");
                sender._selectedDate = new Date();
                // set the date back to the current date
                sender._textbox.set_Value(sender._selectedDate.format(sender._format))
            }
        }
        function ValidateDate1() {
            var start1 = $("#<%=FrDate.ClientID %>").val();
            var end1 = $("#<%=FrmDate.ClientID %>").val();

            var splitdate1 = start1.split("-");
            var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
            var splitdate11 = end1.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);

            if (newStartDate1 > newEndDate1) {
                alert("Approx Of Start Date should be greater than Process Date " + start1);
                $("#<%=FrmDate.ClientID %>").focus();
		        $("#<%=FrmDate.ClientID %>").val(start1);
		        return;
		    }
        }
	</script>
	<script type="text/javascript">
	    function GenerateCloseButton(sender, e) {
	        if ($('#ajax__calendar_close_button').length == 0) {
	            $(sender._header).before("<div id='ajax__calendar_close_button'>x</div>");
	            $('#ajax__calendar_close_button').bind("click", sender, function (e) {
	                $find("calFromDate").hide();
	                $("#<%=calFrmDate.ClientID%>").hide();
	            });
            }
        }
</script>
	<Ajax:ScriptManager ID="ScriptManager2" runat="server"
		 EnableScriptGlobalization="true" EnableScriptLocalization="true" />
	<div id="Pbody_box_inventory">
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Batch Process Completed</b><br />
			<asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError">
			</asp:Label>
		</div>
		<div class="POuter_Box_Inventory">
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Batch Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownList ID="ddlBatch" ToolTip="Select Batch Name" runat="server" ClientIDMode="Static">
							</asp:DropDownList>
							<input type="button" value="Add Item" id="btnAddItem" class="ItDoseButton" style="display: none" />
						</div>
						<div class="col-md-3">
							<label class="pull-left">
							</label>
							<b class="pull-right"></b>
						</div>
						<div class="col-md-5">
						</div>
						<div class="col-md-3">
							<label class="pull-left">
							</label>
							<b class="pull-right"></b>
						</div>
						<div class="col-md-5">
						</div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>
			<table style="width: 100%">
				<tr>
					<td colspan="5">
						<div id="PatientLabSearchOutput" style="max-height: 400px; overflow-y: auto; overflow-x: auto;">
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="POuter_Box_Inventory" id="BoilerDetail" style="display:none;">
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Actual Start Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-3">
							<asp:TextBox ID="FrmDate" runat="server" onchange="ValidateDate1();"  ClientIDMode="Static"></asp:TextBox>
							<asp:TextBox ID="FrDate" Style="display: none" runat="server"></asp:TextBox>
							<cc1:CalendarExtender ID="calFrmDate" runat="server" BehaviorID="calFromDate" Animated="true" TargetControlID="FrmDate" Format="dd-MMM-yyyy">
							</cc1:CalendarExtender>
						</div>
						<div class="col-md-2">
							<asp:TextBox ID="txtFromTime" runat="server"  ClientIDMode="Static"></asp:TextBox>&nbsp;&nbsp;&nbsp;
							<cc1:MaskedEditExtender ID="mee_txtFromTime" runat="server" MaskType="Time" AcceptNegative="None"
								AcceptAMPM="true" TargetControlID="txtFromTime" Mask="99:99" >
							</cc1:MaskedEditExtender>
							<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
								ControlExtender="mee_txtFromTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
								InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Actual End Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-3">
							<asp:TextBox ID="ToDate" runat="server" onchange="javascript:ValidateDate();" ClientIDMode="Static"></asp:TextBox>
							<cc1:CalendarExtender ID="calToDate" runat="server" BehaviorID="calEndDate" TargetControlID="ToDate" Format="dd-MMM-yyyy">
							</cc1:CalendarExtender>
						</div>
						<div class="col-md-2">
							<asp:TextBox ID="txtToTime" runat="server"  ClientIDMode="Static"></asp:TextBox>
							<cc1:MaskedEditExtender ID="mee_txtToTime" runat="server" MaskType="Time" AcceptNegative="None"
								AcceptAMPM="true" TargetControlID="txtToTime" Mask="99:99">
							</cc1:MaskedEditExtender>
							<cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtToTime"
								ControlExtender="mee_txtToTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
								InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Remark
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtRemark" runat="server" MaxLength="50" ToolTip="Enter Remark" onkeypress="return check(event)" ClientIDMode="Static"></asp:TextBox>
							<cc1:FilteredTextBoxExtender ID="cfdremark" runat="server" TargetControlID="txtRemark" FilterType="LowercaseLetters,UppercaseLetters,Numbers,Custom"
								ValidChars="?,. ">
							</cc1:FilteredTextBoxExtender>
						</div>
					</div>
					<div class="row">
						<div class="col-md-11">
						</div>
						<div class="col-md-2">
							<input type="button" value="Save" class="ItDoseButton" id="btnSave" onclick="saveBatchFinalize()" />
						</div>
						<div class="col-md-11">
						</div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>



        
        <div class="POuter_Box_Inventory" style="text-align: center;font-weight:bolder">
               Print Label Data
           </div>
        
<div class="POuter_Box_Inventory"> 
    <div class="row">
        <div class="col-md-3">
							<label class="pull-left">
								From Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-3">
							<asp:TextBox ID="txtPLFromDate" runat="server" onchange="javascript:ValidateDate();" ClientIDMode="Static"></asp:TextBox>
							<cc1:CalendarExtender ID="CalendarExtender1" runat="server"  TargetControlID="txtPLFromDate" Format="dd-MMM-yyyy">
							</cc1:CalendarExtender>
						</div>

         <div class="col-md-3">
							<label class="pull-left">
								To Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-3">
							<asp:TextBox ID="txtPLToDate" runat="server" onchange="javascript:ValidateDate();" ClientIDMode="Static"></asp:TextBox>
							<cc1:CalendarExtender ID="CalendarExtender2" runat="server"  TargetControlID="txtPLToDate" Format="dd-MMM-yyyy">
							</cc1:CalendarExtender>
						</div>

        <div class="col-md-3">
            <input type="button" value="Search" onclick="Search(0)" />
        </div>

        <div class="col-md-5">
            <button id="btn" style="background-color: #ffdffe;border-radius: 100%;height:27px;width:27px"></button>
            Already Printed.
            </div>

     </div>
    </div>

<div class="POuter_Box_Inventory"> 
                <div id="divSList" style="max-height: 400px;">
                    <table class="FixedHeader" id="tblBatchDataToPrint" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th> 
                                <th class="GridViewHeaderStyle">Set Name</th>
                                <th class="GridViewHeaderStyle">Batch No</th>
                                <th class="GridViewHeaderStyle">Date&Time Sterilized</th>
                                <th class="GridViewHeaderStyle">Expiry Date</th> 
                                <th class="GridViewHeaderStyle">Action</th>

                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
        </div>
    
	</div>
	<script id="tb_PatientLabSearch" type="text/html">
	<table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
	style="width:100%;border-collapse:collapse;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px; display:none">Stockid</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none">Batch No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Batch Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Boiler Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Approx Start Date Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Approx End Date Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none;">Set ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:5px;">Set Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:5px;display:none">Item ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:5px;display:none">SetStock ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;display:none;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:5px;">Total Items</th>
		</tr>
		<#
		var dataLength=PatientData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{
		objRow = PatientData[j];
		#>
					<tr id="<#=objRow.stockid#>">
					<td class="GridViewLabItemStyle" style="display:none"><#=objRow.Stockid#></td>
					<td class="GridViewLabItemStyle"><#=j+1#></td>
					<td class="GridViewLabItemStyle" style="display:none"><#=objRow.BatchNo#></td>
					<td class="GridViewLabItemStyle" ><#=objRow.BatchName#></td>
					<td class="GridViewLabItemStyle" ><#=objRow.BoilerName#></td>
					<td class="GridViewLabItemStyle" ><#=objRow.ApproxStartDate#></td>
					<td class="GridViewLabItemStyle" ><#=objRow.ApproxEndDate#></td>
					<td id="SetID" class="GridViewLabItemStyle" style="display:none;" ><#=objRow.SetID#></td>
					<td class="GridViewLabItemStyle" ><#=objRow.SetName#></td>
					<td class="GridViewLabItemStyle" style="display:none"><#=objRow.ItemID#></td>
					<td id="SetStockID" class="GridViewLabItemStyle" style="display:none"><#=objRow.SetStockID#></td>
					<td class="GridViewLabItemStyle" style="text-align: left;display:none;" ><#=objRow.ItemName#></td>
					<td class="GridViewLabItemStyle" ><#=objRow.Qty#></td>
					</tr>
		<#}#>
	 </table>    
	</script>

       <script type="text/javascript">



           function Search(isCurrent) {

               serverCall('BatchProcessComplete.aspx/BindBatchDataToPrint', { FromDate: $("#txtPLFromDate").val(), ToDate: $("#txtPLToDate").val(), IsCurrent: isCurrent }, function (response) {
                   var responseData = JSON.parse(response);
                   if (responseData.status) {
                       BindBatchDataToPrint(responseData.data);
                   }
                   else {
                       $('#tblBatchDataToPrint tbody').empty();
                       modelAlert(responseData.data);
                   }
               });



           }


           function BindBatchDataToPrint(data) {
               $('#tblBatchDataToPrint tbody').empty();

               for (var i = 0; i < data.length > 0; i++) {
                   var j = i + 1;

                   RowColor = "";
                   if (data[i].IsPrint==1) {
                       RowColor = "style='background-color: #ffdffe;'";
                   }

                   var row = '<tr '+RowColor+'>';
                   row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';


                   row += '<td id="tdSetName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SetName + '</td>';
                   row += '<td id="tdBatchNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BatchNo + '</td>';
                   row += '<td id="tdSerealizedDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SerealizedDate + '</td>';
                   row += '<td id="tdExpiryDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ExpiryDate + '</td>';

                   row += '<td class="GridViewLabItemStyle"><input type="button" id="tdSave" style="background-color: green;" onclick="Printlabel(this)" value="Print"/> </td>';

                   row += '</tr>';

                   $('#tblBatchDataToPrint tbody').append(row);
               }
           }



           function Printlabel(rowID) {
               var row = $(rowID).closest('tr');
               var SetName = row.find('#tdSetName').text();
               var BatchNo = row.find('#tdBatchNo').text();
               var SerealizedDate = row.find('#tdSerealizedDate').text();
               var ExpiryDate = row.find('#tdExpiryDate').text();

               serverCall('BatchProcessComplete.aspx/PrintLabel', { SetName: SetName, BatchNo: BatchNo, SerealizedDate: SerealizedDate, ExpiryDate: ExpiryDate }, function (response) {
                   var responseData = JSON.parse(response);
                   if (responseData.status) {
                       window.open('../common/Commonreport.aspx');
                       Search(0);
                   }
                   else {

                       modelAlert(responseData.data);
                   }
               });

           }



    </script>

</asp:Content>
