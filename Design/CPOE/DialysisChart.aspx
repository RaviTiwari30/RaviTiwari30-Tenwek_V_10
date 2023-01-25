<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DialysisChart.aspx.cs" Inherits="Design_CPOE_DialysisChart" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
  
<html xmlns="http://www.w3.org/1999/xhtml">
<head  id="Head1"  runat="server">
	<title></title>
	 <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
	 <link rel="Stylesheet" href="../../Styles/framestyle.css" />
	 <link href="../../Styles/grid24.css" rel="stylesheet" />
	 <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
	<script type="text/javascript" src="../../Scripts/Message.js"></script>
	<script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
	<script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
	<style type="text/css">
		auto-style7 {
			font-size: 10px;
		}

		.auto-style2 {
			width: 119px;
		}

		.auto-style3 {
			width: 365px;
		}

		.auto-style4 {
			width: 125px;
		}

		.auto-style5 {
			width: 311px;
		}
	</style>
	 <script type="text/javascript" >
		 $(document).ready(function () {
		     $('#ddlDoctor').chosen({ width: '100%' });
			 bindDialysis15min();
			 getTime();
			 bindDetailDialysis();
		 });

		 function CloseValidate() {
			 var Close = confirm('Do you Want to Close This Dialysis');
			 if (Close) {
				 if ($.trim($("#txtDurationofHD").val()) == "") {
					 $("#lblMsg").text('Please Enter Duration Of HD');
					 $("#txtDurationofHD").focus();
					 return false;
				 }
				 if ($.trim($("#txtUF").val()) == "") {
					 $("#lblMsg").text('Please Enter UF');
					 $("#txtUF").focus();
					 return false;
				 }
				 if ($.trim($("#txtQB").val()) == "") {
					 $("#lblMsg").text('Please Enter QB');
					 $("#txtQB").focus();
					 return false;
				 }
				 if ($.trim($("#txtQD").val()) == "") {
					 $("#lblMsg").text('Please Enter QD');
					 $("#txtQD").focus();
					 return false;
				 }
				 if ($.trim($("#txtNoofHD").val()) == "") {
					 $("#lblMsg").text('Please Enter No of HD');
					 $("#txtNoofHD").focus();
					 return false;
				 }
				 if ($.trim($("#txtHeparin").val()) == "") {
					 $("#lblMsg").text('Please Enter Heparin');
					 $("#txtHeparin").focus();
					 return false;
				 }
				 if ($.trim($("#txtPreBp").val()) == "") {
					 alert($("#txtPreBP").val());
					 $("#lblMsg").text('Please Enter Pre HD B/P');
					 $("#txtPreBp").focus();
					 return false;
				 }
				 if ($.trim($("#txtPostBP").val()) == "") {
					 $("#lblMsg").text('Please Enter Post HD B/P');
					 $("#txtPostBp").focus();
					 return false;
				 }
				 if ($('#txtPostBP').val() != "") {
					 var bp = $('#txtPostBP').val();
					 var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
					 if (!bpexp.test(bp)) {
						 alert('Please enter valid Post HD B/P ');
						 $('#txtPostBP').focus();
						 return false;
					 }
				 }
				 if ($.trim($("#txtPreHdWeight").val()) == "") {
					 $("#lblMsg").text('Please Enter Pre HD Weight');
					 $("#txtPreHdWeight").focus();
					 return false;
				 }
				 if ($.trim($("#txtPostHdWeight").val()) == "") {
					 $("#lblMsg").text('Please Enter Post HD Weight');
					 $("#txtPostHdWeight").focus();
					 return false;
				 }
				 if ($.trim($("#ddlSalineType").text()) == "Select") {
					 $("#lblMsg").text('Please Select Saline Type');
					 $("#ddlSalineType").focus();
					 return false;
				 }
				 if ($.trim($("#ddlDialReuser").text()) == "Select") {
					 $("#lblMsg").text('Please Select Dialyser Ruser');
					 $("#ddlDialReuser").focus();
					 return false;
				 }
				 if ($.trim($("#txtAccess").val()) == "") {
					 $("#lblMsg").text('Please Enter Access Type');
					 $("#txtPreHdWeight").focus();
					 return false;
				 }
				 return true;
			 }
		 }
		 function minValdate() {
			 if ($.trim($("#txt15minBp").val()) == "") {
				 $("#lblMsg").text('Please Enter B/P');
				 $("#txt15minBp").focus();
				 return false;
			 }
			 if ($('#txt15minBp').val() != '') {
				 var bp = $('#txt15minBp').val();
				 var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
				 if (!bpexp.test(bp)) {
					 alert('Please enter valid B/P ');
					 $('#txt15minBp').focus();
					 return false;
				 }
			 }
			 if ($.trim($("#txt15minVp").val()) == "") {
				 $("#lblMsg").text('Please Enter VP');
				 $("#txt15minVp").focus();
				 return false;
			 }
			 if ($.trim($("#txt15minTemp").val()) == "") {
				 $("#lblMsg").text('Please Enter Temp.');
				 $("#txt15minTemp").focus();
				 return false;
			 }
			 if ($.trim($("#txt15minHeparin").val()) == "") {
				 $("#lblMsg").text('Please Enter Heparin');
				 $("#txt15minHeparin").focus();
				 return false;
			 }
			 return true;
		 }
		 function Validate() {

			 if ($.trim($("#txtUF").val()) == "") {
				 $("#lblMsg").text('Please Enter UF');
				 $("#txtUF").focus();
				 return false;
			 }
			 if ($.trim($("#txtQB").val()) == "") {
				 $("#lblMsg").text('Please Enter QB');
				 $("#txtQB").focus();
				 return false;
			 }
			 if ($.trim($("#txtQD").val()) == "") {
				 $("#lblMsg").text('Please Enter QD');
				 $("#txtQD").focus();
				 return false;
			 }
			 if ($.trim($("#txtNoofHD").val()) == "") {
				 $("#lblMsg").text('Please Enter No of HD');
				 $("#txtNoofHD").focus();
				 return false;
			 }
			 if ($.trim($("#txtHeparin").val()) == "") {
				 $("#lblMsg").text('Please Enter Heparin');
				 $("#txtHeparin").focus();
				 return false;
			 }
			 if ($.trim($("#txtPreBp").val()) == "") {
				 $("#lblMsg").text('Please Enter Pre HD B/P');
				 $("#txtPreBp").focus();
				 return false;
			 }
			 if ($('#txtPreBp').val() != '') {
				 var bp = $('#txtPreBp').val();
				 var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
				 if (!bpexp.test(bp)) {
					 alert('Please enter valid Post HD B/P ');
					 $('#txtPreBp').focus();
					 return false;
				 }
			 }
			 if ($.trim($("#txtPreHdWeight").val()) == "") {
				 $("#lblMsg").text('Please Enter Pre HD Weight');
				 $("#txtPreHdWeight").focus();
				 return false;
			 }
			 if ($('#btn'))
				 if ($.trim($("#txtPostHdWeight").val()) == "") {
					 $("#lblMsg").text('Please Enter Pre HD Weight');
					 $("#txtPostHdWeight").focus();
					 return false;
				 }
			 if ($('#txtPostBp').val() != '') {
				 var bp = $('#txtPreBp').val();
				 var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
				 if (!bpexp.test(bp)) {
					 alert('Please enter valid Post HD B/P ');
					 $('#txtPostBp').focus();
					 return false;
				 }
			 }
			 if ($.trim($("#ddlSalineType").text()) == "Select") {
				 $("#lblMsg").text('Please Select Saline Type');
				 $("#ddlSalineType").focus();
				 return false;
			 }
			 if ($.trim($("#ddlDialReuser").text()) == "Select") {
				 $("#lblMsg").text('Please Select Dialyser Ruser');
				 $("#ddlDialReuser").focus();
				 return false;
			 }
			 if ($.trim($("#txtAccess").val()) == "") {
				 $("#lblMsg").text('Please Enter Access Type');
				 $("#txtPreHdWeight").focus();
				 return false;
			 }
		 }
		 function bp() {
			 if ($('#txtPreBp').val() != "") {
				 var bp = $('#txtPreBp').val();
				 var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
				 if (!bpexp.test(bp)) {
					 alert('Please enter valid Pre HD B/P ');
					 $('#txtPreBp').focus();
					 return false;
				 }
			 }


		 }


		 function onlyNumeric(element, evt) {
			 var charCode = (evt.which) ? evt.which : event.keyCode
			 if (
				 (charCode < 48 || charCode > 57) && (charCode != 8)) {
				 $("#lblMsg").text('Enter Numeric Value Only');
				 return false;
			 }
			 else {
				 $("#lblMsg").text(' ');
				 return true;
			 }
		 }
		 function NomericAndDot(element, evt) {
			 var charCode = (evt.which) ? evt.which : event.keyCode
			 if (
				 //  (charCode != 45 || $(element).val().indexOf('-') != -1) &&      // “-” CHECK MINUS, AND ONLY ONE.
				 (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
				 (charCode < 48 || charCode > 57) &&
				 (charCode != 8)) {
				 $("#lblMsg").text('Enter Numeric Value Only Or One Dot Apply');
				 return false;
			 }
			 else {
				 var DigitsAfterDecimal = 1;
				 var val = $(element).val();
				 var valIndex = val.indexOf(".");
				 if (valIndex > "0") {
					 if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
						 alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
						 $(element).val($(element).val().substring(0, ($(element).val().length - 1)))
						 return false;
					 }
					 else {
						 $("#lblMsg").text(' ');
						 return true;
					 }
				 }
			 }
		 }
		 function Savemin() {
			 if (minValdate() == true) {
				 $("#btnSavemin").attr('disabled', 'disabled');
				 $.ajax({
					 url: "DialysisChart.aspx/Insert",
					 data: '{Time:"' + $.trim($('#txt15MinTime').val()) + '", BP:"' + $.trim($('#txt15minBp').val()) + '",VP:"' + $.trim($('#txt15minVp').val()) + '",Temp:"' + $.trim($('#txt15minTemp').val()) + '",Heparin:"' + $.trim($('#txt15minHeparin').val()) + '",DialysisNo:"' + $.trim($('#lblDialysesNo').text()) + '",PID:"' + $.trim($('#lblPatientID').text()) + '",TID:"' + $.trim($('#lblTransactionID').text()) + '"}',
					 type: "POST",
					 contentType: "application/json; charset=utf-8",
					 timeout: 120000,
					 async: false,
					 dataType: "json",
					 success: function (result) {
						 if (result.d == "1") {
							 DisplayMsg('MM01', 'spnMsg');
							 $("#btnSavemin").removeProp('disabled');
							 clearmin();
						 }
						 else if (result.d == "2") {
							 DisplayMsg('MM05', 'spnMsg');
							 $("#btnSavemin").removeProp('disabled');
						 }
						 bindDialysis15min();
					 },
					 error: function (xhr, status) {
						 DisplayMsg('MM05', 'spnMsg');
						 window.status = status + "\r\n" + xhr.responseText;
					 }
				 });
			 }
		 }
		 function clearmin() {
			 $('#txt15MinTime,#txt15minBp,#txt15minVp,#txt15minTemp,#txt15minHeparin').val('');
		 }
		 function bindDialysis15min() {
			 $.ajax({
				 url: "DialysisChart.aspx/Bind15min",
				 data: '{DialysisNo:"' + $.trim($('#lblDialysesNo').text()) + '",PID:"' + $.trim($('#lblPatientID').text()) + '"}',
				 type: "POST",
				 async: false,
				 dataType: "json",
				 contentType: "application/json; charset=utf-8",
				 success: function (response) {
					 Dial = jQuery.parseJSON(response.d);
					 if (Dial != null) {
						 var output = $('#sc_Dialysis15minMonitor').parseTemplate(Dial);
						 $('#MinOutput').html(output);
						 $('#MinOutput').show();
					 }
					 else {
						 $('#MinOutput').hide();
					 }
					 getTime();
				 }
			 });
		 }

		 </script>
	
</head>
<body>
	<form id="form1" runat="server">
		 <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
			EnableScriptLocalization="true">
		</cc1:ToolkitScriptManager>
		   <div id="Pbody_box_inventory">
			<div class="POuter_Box_Inventory" style="text-align: center">
				<b>Dialysis Monitoring Chart
				</b>
				<br />
				<span id="spnMsg" class="ItDoseLblError"></span>
				<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
				<asp:Label ID="lblPatientID" runat="server" ClientIDMode="Static" style="display:none"></asp:Label>
				<asp:Label ID="lblTransactionID" runat="server" ClientIDMode="Static" style="display:none"></asp:Label>
			</div>
				<div class="POuter_Box_Inventory">
					<div class="Purchaseheader" style="text-align: left;">
					   Dialysis Chart
					</div>
					<div class="easyui-accordion" style="width: 100%; max-height: 700px;">
						<div title="Dialysis Monitoring Chart" style="overflow: auto; padding: 10px; background-color: #EAF3FD;">
						<div>
							<div class="row">
								<div class="col-md-24">
									<div class="row">
										<div class="col-md-3">
										 <label class="pull-left">
											 Start Date
										 </label>
										 <b class="pull-right">:</b>
									   </div>
										<div class="col-md-5">
										 <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
										 <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
										   Format="dd-MMM-yyyy">
										  </cc1:CalendarExtender>
									 </div>
										<div class="col-md-3">
										<label class="pull-left">
											Start Time
										</label>
										 <b class="pull-right">:</b>
										  </div>
										<div class="col-md-5">
											  <asp:TextBox ID="txtTime" runat="server" ClientIDMode="Static"></asp:TextBox>
											  <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
											   Mask="99:99" MaskType="Time" AcceptAMPM="true" />
											  <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
											  ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
											  InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
											<em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
										 </div>
										<div class="col-md-3">
										 <label class="pull-left">
											 Duration Of HD
										 </label>
									   <b class="pull-right">:</b>
									   </div>
										<div class="col-md-5">
										  <asp:TextBox ID="txtDurationofHD" runat="server" ClientIDMode="Static" onkeypress="return onlyNumeric(this,event)"></asp:TextBox>
										 </div>
									</div>
									<div class="row">
										 <div class="col-md-3">
								   <label class="pull-left">
										   UF
										</label>
								<b class="pull-right">:</b>
									 </div>
								   <div class="col-md-5">
									<asp:TextBox ID="txtUF" runat="server" CssClass="requiredField" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox>
								   <span class="auto-style7">Litre</span>
								   </div>
						  <div class="col-md-3">
							<label class="pull-left">
								QB
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtQB" runat="server" CssClass="requiredField" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox>
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								QD
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtQD" runat="server" CssClass="requiredField" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox>
						</div>
						</div>
									<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								No Of HD
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtNoofHD" CssClass="requiredField" runat="server" ClientIDMode="Static" onkeypress="return onlyNumeric(this,event)">
						  </asp:TextBox>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Heparin
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtHeparin" runat="server" ClientIDMode="Static"></asp:TextBox>
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								Pre HD B/P
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtPreBp" CssClass="requiredField" runat="server" ClientIDMode="Static" ></asp:TextBox>
							 <span class="auto-style7">mm/Hg</span>
						</div>
					</div>
									<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Post HD B/P
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtPostBP" runat="server" ClientIDMode="Static"></asp:TextBox>
							 <span class="auto-style7">mm/Hg</span>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Pre HD Weight
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtPreHdWeight" runat="server" CssClass="requiredField" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox>
							 <span class="auto-style7">Kg</span>
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								Post HD Weight
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtPostHdWeight" runat="server" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox>
							 <span class="auto-style7">Kg</span>
						</div>
					</div>
									<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Access
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:DropDownList ID="ddlSalineType" CssClass="requiredField" runat="server" Width="180px" ClientIDMode="Static">
								 <asp:ListItem>Select</asp:ListItem> <asp:ListItem>Normal Saline</asp:ListItem>
								 <asp:ListItem>25% Dextrose</asp:ListItem><asp:ListItem>Packed Cell</asp:ListItem></asp:DropDownList>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Dialyser Reuser
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:DropDownList ID="ddlDialReuser" CssClass="requiredField" runat="server" ClientIDMode="Static" Width="100px">
								<asp:ListItem>Select</asp:ListItem> <asp:ListItem>Yes</asp:ListItem><asp:ListItem>No</asp:ListItem></asp:DropDownList>
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								Access
							</label>
							<b class="pull-right">:</b>
						   </div>
						   <div class="col-md-5">
							   <asp:TextBox ID="txtAccess" CssClass="requiredField" runat="server" ClientIDMode="Static"></asp:TextBox>
						   </div>
						</div>
									<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Doctor
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownList ID="ddlDoctor" runat="server" Width="180px" ClientIDMode="Static"></asp:DropDownList>
						</div>
										</div>
									<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								 Remarks
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-21">
							<asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Height="64px" Width="662px" MaxLength="400" ClientIDMode="Static"></asp:TextBox>
						</div>
						  </div>
								</div>
								</div>
					  <div style="text-align:center">
			   <asp:Label ID="lblDiID" runat="server" Visible="false"></asp:Label>
			   <asp:Label ID="lblDialysesNo" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
			   <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" ClientIDMode="Static" Text="Save" OnClick="btnSave_Click" OnClientClick="return Validate(),bp();"/>
			   &nbsp;&nbsp;&nbsp;<asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton" Text="Close Dialysis" OnClick="btnClose_Click" OnClientClick="return CloseValidate()" />
				   </div></div>

						</div>
						  <div title="During Dialysis Every 15 Minutes Monitoring Chart" style="overflow: auto;padding:10px; background-color: #EAF3FD;">
							<div>
								<table>
								  <tr >
									  <td style="border-right: 1px; border-right:solid black;width:7px;text-align:center"></td>
					<td style="border: 1px; border-bottom:solid black;border-top:solid black; border-right:solid black;width:180px;text-align:center">Time</td>
					<td style="border: 1px; border-bottom:solid black;border-top:solid black; border-right:solid black;width:180px;text-align:center">BP <span style="color:red">(mm/Hg)</span></td>
					<td style="border: 1px; border-bottom:solid black;border-top:solid black; border-right:solid black;width:180px;text-align:center">VP</td>
					<td style="border: 1px; border-bottom:solid black;border-top:solid black; border-right:solid black;width:180px;text-align:center">Temp <span style="color:red">(<sup><span class="auto-style7" style="color:red">0</span></sup>F)</span></td>                 
					<td style="border: 1px; border-bottom:solid black;border-top:solid black; border-right:solid black;width:180px;text-align:center">Heparin</td>
				</tr>
									<tr>
										 <td style="border-right: 1px; border-right:solid black;width:7px;text-align:center;"></td>
										<td style="border: 1px; border-bottom:solid black; border-right:solid black;width:180px;text-align:center;"><asp:TextBox ID="txt15MinTime" runat="server" ClientIDMode="Static"></asp:TextBox><asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
										  <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txt15MinTime"
							Mask="99:99" MaskType="Time" AcceptAMPM="true" />

						<cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txt15MinTime"
								ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
								InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
							
										</td>
					<td style="border: 1px; border-bottom:solid black; border-right:solid black;width:180px;text-align:center"><asp:TextBox ID="txt15minBp" runat="server" ClientIDMode="Static"></asp:TextBox><asp:Label ID="Label15" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label></td>
					<td style="border: 1px; border-bottom:solid black; border-right:solid black;width:180px;text-align:center"><asp:TextBox ID="txt15minVp" runat="server" ClientIDMode="Static"></asp:TextBox><asp:Label ID="Label16" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label></td>
					<td style="border: 1px; border-bottom:solid black; border-right:solid black;width:180px;text-align:center"><asp:TextBox ID="txt15minTemp" runat="server" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox><asp:Label ID="Label17" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label></td>                 
					<td style="border: 1px; border-bottom:solid black;border-right:solid black;width:180px;text-align:center"><asp:TextBox ID="txt15minHeparin" runat="server" ClientIDMode="Static"></asp:TextBox><asp:Label ID="Label18" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label></td>
									</tr>
									<tr>
										 <td >&nbsp;</td>
										<td ><em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em></td>
					<td >&nbsp;</td>
					<td >&nbsp;</td>
					<td >&nbsp;</td>                 
					<td >&nbsp;</td>
									</tr>
								</table>
								<div style="text-align:center">
									<asp:Label ID="lblisClose" runat="server" ClientIDMode="Static" style="display:none"></asp:Label>
									<asp:Label ID="lblID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
									  <input id="btnSavemin" type="button" value="Save" class="ItDoseButton" onclick="Savemin()"/>                         
							<input id="btnUpdate" type="button" value="Update" class="ItDoseButton" style="display:none" onclick="Updatemin()"/>
						   <input id="btnCancel" type="button" value="Cancel" class="ItDoseButton" style="display:none" onclick="CancelUpdation()"/>
								</div>
								<div class="POuter_Box_Inventory" style="text-align:center">
			 <div class="Purchaseheader">Result
			</div>
									 <table>
		 <tr style="width:100%">
					<td colspan="5" style="text-align:center">
						<div id="MinOutput" style="max-height: 300px; overflow-x: auto; text-align:center;width:100%">
						</div></td></tr>
		 </table>
			  
							</div></div>

					</div>
<div title="Patient Dialysis Monitoring Form" style="overflow: auto; background-color: #EAF3FD;">
	<div class="POuter_Box_Inventory" style="text-align:center">
			 <div class="Purchaseheader">Dialysis List (For Detail Click On the Row)
			</div>
									 <table>
		 <tr style="width:100%">
					<td colspan="5" style="text-align:center">
						<div id="SummaryOutput" style="max-height: 100px;width:1000px; overflow-x: auto; text-align:center">
						</div></td></tr>
		 </table>
			  
							</div>
	</div>
					</div></div></div>
		<asp:Panel ID="PnlDialysisDetail" runat="server" CssClass="pnlItemsFilter" style=" display:none;
		width: 700px; height: 350px;" ScrollBars="Auto">
		<div>
						<div class="Purchaseheader" style="text-align: left;">
				   15 Minute Monitoring Chart&nbsp;&nbsp;&nbsp;&nbsp;
			 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<em ><span style="font-size: 7.5pt"> Press esc or click
							<img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closePatientDetail()"/>                               
								to close</span></em>
				</div>
								<div id="DialysisDetailReport"  style="vertical-align:top;height:200px;">
								</div>
		
		
	<div>
		 <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none" CssClass="ItDoseButton"/>
		  <table><tr><td colspan="1"  style="width: 100%; text-align:left">
			  <asp:Button ID="btnCancelDetail" runat="server" Text="Cancel"  CssClass="ItDoseButton" style="display:none" />
			  </td>
				 </tr></table>
	  </div>
		  </div>
	</asp:Panel>
		<cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" 
		PopupDragHandleControlID="dragHandle" CancelControlID="btnCancelDetail" PopupControlID="PnlDialysisDetail"
		TargetControlID="btnHidden" BehaviorID="mpe2">
	</cc1:ModalPopupExtender>
	</form>
	<script id="sc_Dialysis15minMonitor" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_Dialysis15minMonitor"
	style="width:700px;border-collapse:collapse; text-align:center">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Dialysis No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">BP(mm/Hg)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">VP</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Temp</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Heparin</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Enrty By</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none"></th>
		</tr>
		<#
		var objRow;
		for(var j=0;j<Dial.length;j++)
		{
		objRow = Dial[j];
		#>
					<tr id="<#=j+1#>">
					<td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
					<td class="GridViewLabItemStyle"  id="tdDialysisNo" style="width:10px;"><#=objRow.DialysisNo#></td>
					<td class="GridViewLabItemStyle" id="tdTime"  style="width:100px;text-align:center" ><#=objRow.Time#></td>
					<td class="GridViewLabItemStyle" id="tdBP"  style="width:60px;text-align:center" ><#=objRow.BP#></td>
					<td class="GridViewLabItemStyle" id="tdVP"  style="width:50px;text-align:center;" ><#=objRow.VP#></td>
					<td class="GridViewLabItemStyle" id="tdTemp"  style="width:100px;text-align:center" ><#=objRow.Temp#></td>
					<td class="GridViewLabItemStyle" id="tdHeparin"  style="width:100px;text-align:center" ><#=objRow.Heparin#></td>
					<td class="GridViewLabItemStyle" id="tdName"  style="width:100px;text-align:center" ><#=objRow.NAME#></td>
					<td class="GridViewLabItemStyle" style="width:30px; text-align:center"><input type="button" value="Edit"  id="btnEdit"  class="ItDoseButton" onclick="edit(this);" /></td>
					<td class="GridViewLabItemStyle" id="tdID" style="width:10px;text-align:center;display:none" ><#=objRow.ID#></td>
					</tr>
		<#}
		#>
	 </table>
	</script>
	 <script id="sc_DialysisSummary" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_DialysisSummary"
	style="width:960px;border-collapse:collapse; text-align:center">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none">View</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Dialysis No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Access</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">No. of Hd</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Pre HD BP</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Pre HD WT.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Post HD BP</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Post HD WT.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Weight Gain</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Dialyser Reuser</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Heparin</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Entry By</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">Nephrologist</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none"></th>
		</tr>
		<#
		var objRow;
		for(var j=0;j<Dial.length;j++)
		{
		objRow = Dial[j];
		#>
					<tr id="Tr2" onclick="bindDialysisDetail(this)">
					<td class="GridViewLabItemStyle" style="width:10px;display:none;"><img src="../../Images/view.GIF"  style="cursor:pointer" onclick="bindDialysisDetail(this)"/></td>
					<td class="GridViewLabItemStyle"  id="td_Dialysis" style="width:10px;"><#=objRow.DialysisNo#></td>
					<td class="GridViewLabItemStyle" id="td2"  style="width:100px;text-align:center" ><#=objRow.StartDate#></td>
					<td class="GridViewLabItemStyle" id="td3"  style="width:60px;text-align:center" ><#=objRow.Access#></td>
					<td class="GridViewLabItemStyle" id="td4"  style="width:50px;text-align:center;" ><#=objRow.No_HD#></td>
					<td class="GridViewLabItemStyle" id="td5"  style="width:100px;text-align:center" ><#=objRow.Pre_HDBP#></td>
					<td class="GridViewLabItemStyle" id="td6"  style="width:100px;text-align:center" ><#=objRow.Pre_HDWeight#></td>
					<td class="GridViewLabItemStyle" id="td7"  style="width:100px;text-align:center" ><#=objRow.Post_HDBP#></td>
					<td class="GridViewLabItemStyle" id="td9"  style="width:100px;text-align:center" ><#=objRow.Post_HDWeight#></td>
					<td class="GridViewLabItemStyle" id="td10"  style="width:100px;text-align:center" ><#=objRow.WeightGain#></td>
					<td class="GridViewLabItemStyle" id="td11"  style="width:100px;text-align:center" ><#=objRow.DialyzerReuser#></td>
					<td class="GridViewLabItemStyle" id="td12"  style="width:100px;text-align:center" ><#=objRow.Heparine#></td>
					<td class="GridViewLabItemStyle" id="td13"  style="width:100px;text-align:center" ><#=objRow.Saline_Tyle#></td>
					<td class="GridViewLabItemStyle" id="td14"  style="width:300px;text-align:center" ><#=objRow.EntryBy#></td>
					<td class="GridViewLabItemStyle" id="td15"  style="width:100px;text-align:center;display:none" ><#=objRow.Doctor#></td>
					<td class="GridViewLabItemStyle" id="td_transactionID"  style="width:100px;text-align:center;display:none" ><#=objRow.TransactionID#></td>
					</tr>
		<#}
		#>
	 </table>
	</script>
	<script id="sc_DetailDialysis" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="Table1"
	style="width:700px;border-collapse:collapse; text-align:center">
		<tr id="Tr3">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Dialysis No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">BP(mm/Hg)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">VP</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Temp</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Heparin</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Enrty By</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none"></th>
		</tr>
		<#
		var objRow;
		for(var j=0;j<DetailDialysisNo.length;j++)
		{
		objRow = DetailDialysisNo[j];
		#>
					<tr id="Tr4">
					<td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
					<td class="GridViewLabItemStyle"  id="td1" style="width:10px;"><#=objRow.DialysisNo#></td>
					<td class="GridViewLabItemStyle" id="td8"  style="width:100px;text-align:center" ><#=objRow.Time#></td>
					<td class="GridViewLabItemStyle" id="td16"  style="width:60px;text-align:center" ><#=objRow.BP#></td>
					<td class="GridViewLabItemStyle" id="td17"  style="width:50px;text-align:center;" ><#=objRow.VP#></td>
					<td class="GridViewLabItemStyle" id="td18"  style="width:100px;text-align:center" ><#=objRow.Temp#></td>
					<td class="GridViewLabItemStyle" id="td19"  style="width:100px;text-align:center" ><#=objRow.Heparin#></td>
					<td class="GridViewLabItemStyle" id="td20"  style="width:100px;text-align:center" ><#=objRow.NAME#></td>
					<td class="GridViewLabItemStyle" id="td21" style="width:10px;text-align:center;display:none" ><#=objRow.ID#></td>
					</tr>
		<#}
		#>
	 </table>
	</script>
	<script type="text/javascript">
		function closePatientDetail() {
			$find("mpe2").hide();
		}
		function pageLoad(sender, args) {
			if (!args.get_isPartialLoad()) {
				$addHandler(document, "keydown", onKeyDown);
			}
		}
		function onKeyDown(e) {
			if (e && e.keyCode == Sys.UI.Key.esc) {
				if ($find('mpe2')) {
					$find('mpe2').hide();
				}
			}
		}
		function bindDialysisDetail(rowid) {
			var TID = $.trim($(rowid).closest('tr').find("#td_transactionID").text());
			var DialNo = $.trim($(rowid).closest('tr').find("#td_Dialysis").text());
			$.ajax({
				url: "DialysisChart.aspx/bindDialysisDetail",
				data: '{DialNo:"' + DialNo + '",TID:"' + TID + '"}',
				type: "POST",
				async: false,
				dataType: "json",
				contentType: "application/json; charset=utf-8",
				success: function (mydata) {
					DetailDialysisNo = jQuery.parseJSON(mydata.d);
					if (DetailDialysisNo != null) {
						var output = $('#sc_DetailDialysis').parseTemplate(DetailDialysisNo);
						$('#spnMsg').text('');
						$find("mpe2").show();
						$('#DialysisDetailReport').html(output);
						$('#DialysisDetailReport,#sc_DetailDialysis').show();
					}
					else {
						DisplayMsg('MM04', 'spnMsg');
						$('#DialysisDetailReport,#sc_DetailDialysis').hide();
						$find("mpe2").hide();
					}
				}
			});
		}
		function getTime() {
			$.ajax({
				url: "DialysisChart.aspx/getTime",
				data: '{}',
				type: "POST",
				async: true,
				dataType: "json",
				contentType: "application/json; charset=utf-8",
				success: function (mydata) {
					var data = mydata.d;
					$('#txt15MinTime').val(data);
					return;
				}
			});
		}
		function edit(rowid) {
			$("#lblID").text($(rowid).closest('tr').find('#tdID').text());
			$('#btnUpdate').show();
			$('#btnSavemin').hide();
			$('#btnCancel').show();
			$('#txt15minHeparin').val($(rowid).closest('tr').find('#tdHeparin').text());
			$('#txt15minTemp').val($(rowid).closest('tr').find('#tdTemp').text());
			$('#txt15minVp').val($(rowid).closest('tr').find('#tdVP').text());
			$('#txt15minBp').val($(rowid).closest('tr').find('#tdBP').text());
			$('#txt15MinTime').val($(rowid).closest('tr').find('#tdTime').text());
		}
		function CancelUpdation() {
			$('#txt15MinTime').val('');
			$("#lblID").text(' ');
			$('#btnUpdate').hide();
			$('#btnSavemin').show();
			$('#btnCancel').hide();
			$('#txt15minHeparin').val('');
			$('#txt15minTemp').val('');
			$('#txt15minVp').val('');
			$('#txt15minBp').val('');
			getTime();
		}
		function Updatemin() {
			if (minValdate() == true) {
				$('#btnUpdate').attr('disabled', 'disabled');
				$.ajax({
					url: "DialysisChart.aspx/Update",
					data: '{Time:"' + $.trim($('#txt15MinTime').val()) + '", BP:"' + $.trim($('#txt15minBp').val()) + '",VP:"' + $.trim($('#txt15minVp').val()) + '",Temp:"' + $.trim($('#txt15minTemp').val()) + '",Heparin:"' + $.trim($('#txt15minHeparin').val()) + '",ID:"' + $.trim($('#lblID').text()) + '"}',
					type: "POST",
					contentType: "application/json; charset=utf-8",
					timeout: 120000,
					async: false,
					dataType: "json",
					success: function (result) {
						if (result.d == "1") {
							DisplayMsg('MM01', 'spnMsg');
							$('#lblMsg').text('');
							$('#btnUpdate').attr('disabled', false);
							clearmin();
						}
						else if (result.d == "2") {
							DisplayMsg('MM05', 'spnMsg');
							$('#btnUpdate').removeProp('disabled');
						}
						bindDialysis15min();
					},
					error: function (xhr, status) {
						DisplayMsg('MM05', 'spnMsg');
						window.status = status + "\r\n" + xhr.responseText;
					}
				});
			}
			else {
				$('#btnUpdate').removeProp('disabled');
			}
		}
		function bindDetailDialysis() {
			$.ajax({
				url: "DialysisChart.aspx/BindDetailDialysis",
				data: '{PID:"' + $.trim($('#lblPatientID').text()) + '"}',
				type: "POST",
				async: false,
				dataType: "json",
				contentType: "application/json; charset=utf-8",
				success: function (response) {
					Dial = jQuery.parseJSON(response.d);
					if (Dial != null) {
						var output = $('#sc_DialysisSummary').parseTemplate(Dial);
						$('#SummaryOutput').html(output);
						$('#SummaryOutput').show();
						$('#tb_DialysisSummary tr').bind('mouseenter mouseleave', function () {
							$(this).toggleClass('hover');

						});
					}
					else {
						$('#SummaryOutput').hide();
					}
				}
			});
		}
	</script>
   <style>
	   .hover {
		   border-top: 3px solid #f00;
		   border-bottom: 3px solid #f00;
		   cursor: pointer;
	   }
   </style>
</body>
</html>
