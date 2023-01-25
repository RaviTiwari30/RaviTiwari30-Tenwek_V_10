<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PatientDiagnosis.ascx.cs" Inherits="Design_Controls_PatientDiagnosis" %>
	
<asp:Panel ID="pnlDiagnosis" runat="server" ClientIDMode="Static" Style="display:none" CssClass="pnlItemsFilter" Width="660px" >
				<div class="Purchaseheader">
					<b>Provisional Diagnosis</b> 
				</div>
				<div style="text-align: center;">
					<table style="width: 580px; border-collapse: collapse">                        
						<tr>
							<td >
								 <div id="DiagnosisSearchOutput" style="max-height: 640px; overflow-x: auto;">
						</div>
							</td>
						</tr>
						</table>
					</div>
	<div class="Purchaseheader">
					<b>Final Diagnosis</b> 
				</div>
	  <div style="text-align: center;">
					<table style="width: 580px; border-collapse: collapse">
						
						<tr>
							<td >
								 <div id="FinalDiagnosisOutput" style="max-height: 640px; overflow-x: auto;">
						</div>
							</td>
						</tr>
						</table>

					</div>
	<div class="Purchaseheader">
					<b>Allergies</b> 
				</div>
	 <div style="text-align: center;">
					<table style="width: 580px; border-collapse: collapse">
						
						<tr>
							<td >
								 <div id="AllergiesSearchOutput" style="max-height: 640px; overflow-x: auto;">
						</div>
							</td>
						</tr>
						</table>

					</div>
		</asp:Panel>

<script type="text/javascript">
	function allDiagnosisData(PatientID) {      
		$.ajax({
			url: "../CPOE/Services/Cpoe_CommonServices.asmx/diagnosisData",
			data: '{PatientID:"' + PatientID + '"}',
			type: "POST",
			contentType: "application/json; charset=utf-8",
			timeout: "120000",
			dataType: "json",
			async: false,
			success: function (result) {
				
				if (result.d != "") {
					
					Diagnosis = jQuery.parseJSON(result.d);
					if (Diagnosis != null) {

						var output = $('#tb_grdDiagnosis').parseTemplate(Diagnosis);
						$('#DiagnosisSearchOutput').html(output);
						$('#DiagnosisSearchOutput,#pnlDiagnosis').show();
						$('#spnErrorMsg').text('');
					   
					}
				}
				else {
					$('#spnErrorMsg').text('Diagnosis Not Found');
				  
					$('#DiagnosisSearchOutput').html('');
					$('#pnlDiagnosis').hide();
					
				}
			},
			error: function (xhr, status) {
				window.status = status + "\r\n" + xhr.responseText;
				return false;
			}
		});
	}
	function FinalDiagnosis(PatientID) {
		jQuery.ajax({
			url: "../CPOE/Services/Cpoe_CommonServices.asmx/FinalDiagnosisData",
			data: '{PatientID:"' + PatientID + '"}',
			type: "POST",
			contentType: "application/json; charset=utf-8",
			timeout: "120000",
			dataType: "json",
			async: false,
			success: function (result) {
				if (result.d != "") {
					Diagnosis = jQuery.parseJSON(result.d);
					if (Diagnosis != null) {
						var output = jQuery('#tb_grdfinalDiagnosis').parseTemplate(Diagnosis);
						jQuery('#FinalDiagnosisOutput').html(output);
						jQuery('#FinalDiagnosisOutput,#pnlDiagnosis').show();
					}
				}
				else {
					jQuery('#FinalDiagnosisOutput').html('');
					jQuery('#FinalDiagnosisOutput').hide();
				}
			},
			error: function (xhr, status) {
				window.status = status + "\r\n" + xhr.responseText;
				return false;
			}
		});
	}
	function showAllergies(PatientID) {
		jQuery.ajax({
			url: "../CPOE/Services/Cpoe_CommonServices.asmx/AllergiesData",
			data: '{PatientID:"' + PatientID + '"}',
			type: "POST",
			contentType: "application/json; charset=utf-8",
			timeout: "120000",
			dataType: "json",
			async: false,
			success: function (result) {
				if (result.d != "") {
					Allergies = jQuery.parseJSON(result.d);
					if (Allergies != null) {
						var output = jQuery('#tb_grdAllergies').parseTemplate(Allergies);
						jQuery('#AllergiesSearchOutput').html(output);
						jQuery('#AllergiesSearchOutput,#pnlDiagnosis').show();
					}
				}
				else {
					jQuery('#AllergiesSearchOutput').html('');
					jQuery('#AllergiesSearchOutput').hide();
				}
			},
			error: function (xhr, status) {
				window.status = status + "\r\n" + xhr.responseText;
				return false;
			}
		});
	}
</script>
		<script id="tb_grdDiagnosis" type="text/html">
	<table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_DiagnosisSearch"
	style="width:540px;border-collapse:collapse;text-align:center">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:260px;">Diagnosis Name</th>
			
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Diagnosis&nbsp;Date</th>
</tr>
	   <#
			  var dataLength=Diagnosis.length;
			  window.status="Total Records Found :"+ dataLength;
			  var objRow;
		for(var j=0;j<dataLength;j++)
		{

		objRow = Diagnosis[j];
			#>
					<tr id="Tr1">
						<td class="GridViewLabItemStyle"><#=j+1#></td>
 <td  class="GridViewLabItemStyle"><#=objRow.DiagnosisName#></td>                       

<td class="GridViewLabItemStyle"><#=objRow.DiagnosisDate#></td>
</tr>

			<#}#>
	 </table>
   
	</script>
 <script id="tb_grdfinalDiagnosis" type="text/html">
	<table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_FinalSearch"
	style="width:640px;border-collapse:collapse;text-align:center">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Diagnosis Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:260px;">Diagnosis Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:260px;">Who Full Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Diagnosis&nbsp;Date</th>
</tr>
	   <#
			  var dataLength=Diagnosis.length;
			  window.status="Total Records Found :"+ dataLength;
			  var objRow;
		for(var j=0;j<dataLength;j++)
		{

		objRow = Diagnosis[j];
			#>
					<tr id="Tr2">
						<td class="GridViewLabItemStyle"><#=j+1#></td>
						<td  class="GridViewLabItemStyle"><#=objRow.ICD10_3_Code#></td>                       
 <td  class="GridViewLabItemStyle"><#=objRow.ICD10_3_Code_Desc#></td>                       
						<td  class="GridViewLabItemStyle"><#=objRow.WHO_Full_Desc#></td>                       
<td class="GridViewLabItemStyle"><#=objRow.DATE#></td>
</tr>

			<#}#>
	 </table>
   
	</script>
  <script id="tb_grdAllergies" type="text/html">
	<table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_AllergiesSearch"
	style="width:640px;border-collapse:collapse;text-align:center">
		<tr>
			
			<th class="GridViewHeaderStyle" scope="col" style="width:260px;">Allergies</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:260px;">Entry Date</th>
</tr>
	   <#
			  var dataLength=Allergies.length;
			  window.status="Total Records Found :"+ dataLength;
			  var objRow;
		for(var j=0;j<dataLength;j++)
		{

		objRow = Allergies[j];
			#>
					<tr id="trAllergies">
					   
 <td  class="GridViewLabItemStyle"><#=objRow.Allergies#></td>                       
<td  class="GridViewLabItemStyle"><#=objRow.EntryDate#></td>
</tr>

			<#}#>
	 </table>
   
	</script>