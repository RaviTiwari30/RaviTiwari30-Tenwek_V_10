<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cpoe_PreviousVisit.aspx.cs" Inherits="Design_CPOE_Cpoe_PreviousVisit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<head runat="server">
	<title></title>
	 <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
	<script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
	  <script type="text/javascript">
		  var TID; var App_ID;
		  $(document).ready(function () {
			  TID = '<%=Util.GetString(TID)%>';
			  PID = '<%=PatientID%>';
			  App_ID = '';
			  bindPreviousVisit();
			  bindReferralConsultation();
			  VitalSign();
		  });
		  function bindPreviousVisit() {
			  $.ajax({
				  url: "Cpoe_PreviousVisit.aspx/bindPreviousVisit",
				  data: '{TID:"' + TID + '",PID:"' + PID + '"}',
				  type: "POST",
				  async: false,
				  dataType: "json",
				  contentType: "application/json; charset=utf-8",
				  success: function (mydata) {
					  Visit = jQuery.parseJSON(mydata.d);
					  if (Visit != null) {
						  var output = $('#tb_PreviousVisit').parseTemplate(Visit);
						  $('#VisitOutPut').html(output);
						  $('#VisitOutPut,#PreviousVisit').show();
					  }
					  else {
						  $('#VisitOutPut,#PreviousVisit').hide();
						 
					  }
				  }
			  });
		  }
		  function bindReferralConsultation() {
			  $.ajax({
				  url: "Cpoe_PreviousVisit.aspx/bindReferralConsultation",
				  data: '{TID:"' + TID + '",PID:"' + PID + '",App_ID:"' + App_ID + '"}',
				  type: "POST",
				  async: false,
				  dataType: "json",
				  contentType: "application/json; charset=utf-8",
				  success: function (mydata) {
					  ReferralConsultation = jQuery.parseJSON(mydata.d);
					  if (ReferralConsultation != null) {
						  $("#spnDate").html(ReferralConsultation[0]["Date"]);
						  $("#spnTime").html(ReferralConsultation[0]["Time"]);
						  $("#spnReferralType").html(ReferralConsultation[0]["ReferralType"]);
						  $("#spnFrom").html(ReferralConsultation[0]["UserName"]);
						  $("#spnRegarding").html(ReferralConsultation[0]["Regarding"]);
						  $("#spnConsultationReport").html(ReferralConsultation[0]["ConsultationType"]);
						  $("#spnImpressionDiagnosis").html(ReferralConsultation[0]["Impression"]);
						  $("#spnTreatmentRecommendations").html(ReferralConsultation[0]["Treatment"]);

					  }
					  else {
						  $("#Referral").hide();
					  }
				  }
			  });
		  }

		  function VitalSign() {
			  $.ajax({
				  url: "Cpoe_PreviousVisit.aspx/bindVitalSign",
				  data: '{TID:"' + TID + '"}',
				  type: "POST",
				  async: false,
				  dataType: "json",
				  contentType: "application/json; charset=utf-8",
				  success: function (mydata) {
					  Vital = jQuery.parseJSON(mydata.d);
					  if (Vital != null) {
						  var output = $('#tb_VitalSign').parseTemplate(Vital);
						  $('#VitalSignOutPut').html(output);
						  $('#VitalSignOutPut').show();
					  }
					  else {
						  $('#VitalSignOutPut').hide();
						  $('#VitalSign1').hide();
					  }

				  }
			  });
		  }

		 
		  

var TableBackgroundNormalColor = "#ffffff";
var TableBackgroundMouseoverColor = "#afeeee";

function ChangeBackgroundColor(row) { row.style.backgroundColor = TableBackgroundMouseoverColor; }
function RestoreBackgroundColor(row) { row.style.backgroundColor = TableBackgroundNormalColor; }


					</script>
	<script type="text/javascript">
		function Print(rowid) {
			var TID =$.trim($(rowid).closest('tr').find("#tdTransactionID").text());
			var LnxNo = $.trim($(rowid).closest('tr').find("#tdLedgerTransactionNo").text());
			location.href = 'PrintOut.aspx?TID=' + TID + '&LnxNo=' + LnxNo + ' ';
		}
	</script>
</head>
<body>
	<form id="form1" runat="server">
   
								  <div class="Purchaseheader" style="text-align: left;">
				   Previous Visit
				</div>
								<div id="VisitOutPut"  style="vertical-align:top;height:200px; overflow:auto">
								</div>
						   

		<br />

          <div class="Purchaseheader" style="text-align: left;">
				  Vital Sign
				</div>
							<div id="VitalSignOutPut">
								</div>


		<br />
		<table  style="border-collapse:collapse;width:100%;border: thin solid #000000;" id="Referral" class="GridViewStyle" >
					   
						<tr>
							 <td colspan="2" >
								 

										
								  <div class="Purchaseheader" style="text-align: left;">
					Referral For Consultation
				</div>
						   
							</td>
						</tr>
						 <tr>
							 <td class="GridViewLabItemStyle" style="text-align:right; width:20%">
								
Date Time :&nbsp;
							 </td>
							<td class="GridViewLabItemStyle" style="text-align:left; width:80%">
<span id="spnDate"></span>&nbsp;<span id="spnTime"></span>
							</td>
						 </tr>
						<tr>
							<td class="GridViewLabItemStyle" style="text-align:right">
Referral Type :&nbsp;
							</td>
							<td  class="GridViewLabItemStyle">
<span id="spnReferralType"></span>
							</td>
						</tr>
			<tr>
				 <td class="GridViewLabItemStyle" style="text-align:right">
From :&nbsp;
					 </td>
							<td  class="GridViewLabItemStyle">
<span id="spnFrom"></span>
							</td>
						</tr>
			<tr>
				 <td class="GridViewLabItemStyle" style="text-align:right">
					 Regarding :&nbsp;
					 </td>
							<td  class="GridViewLabItemStyle">
<span id="spnRegarding"></span>
							</td>
						</tr>
			<tr>
				<td class="GridViewLabItemStyle" style="text-align:right">
Consultation Report :&nbsp;
					</td>
							<td  class="GridViewLabItemStyle">
<span id="spnConsultationReport"></span>
							</td>
						</tr>
			<tr>
				 <td class="GridViewLabItemStyle" style="text-align:right">
Impression/Diagnosis  :&nbsp;
					 </td>
							<td  class="GridViewLabItemStyle">
<span id="spnImpressionDiagnosis"></span>
							</td>
						</tr>
			<tr>
				<td class="GridViewLabItemStyle" style="text-align:right">
Treatment/Recommendations   :&nbsp;
					</td>
							<td  class="GridViewLabItemStyle">
<span id="spnTreatmentRecommendations"></span>
							</td>
						</tr>
					</table>
	</form>
</body>
</html>
 <script id="tb_PreviousVisit" type="text/html">
					 <table  cellspacing="0" rules="all" border="1" 
	style="border-collapse:collapse;width:100%"  class="GridViewStyle">
		<tr id="Header">
			
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Visit Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">DoctorID</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">TID</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">LedgerTransactionNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Print</th>
		</tr>
		<#       
		var dataLength=Visit.length;
		var objRow;   
		for(var j=0;j<dataLength;j++)
		{       
		objRow = Visit[j];
		#>
		   

					 <tr id="<#=j+1#>"  style="cursor:pointer;"  onmouseover="ChangeBackgroundColor(this)" onmouseout="RestoreBackgroundColor(this)">                                                                                                       
																														  
				   
					<td   class="GridViewLabItemStyle"  id="tdVisitDate" style="width:100px;text-align:center" ><#=objRow.DateVisit#></td>
					<td   class="GridViewLabItemStyle" id="tdDName" style="width:240px; text-align:center;">
					   <#=objRow.DName#>
						</td>
					<td   class="GridViewLabItemStyle" id="tdDoctorID" style=" text-align:center; display:none">
					   <#=objRow.DoctorID#>
						</td>
<td   class="GridViewLabItemStyle" id="tdTransactionID" style=" text-align:center; display:none">
					   <#=objRow.TransactionID#>
						</td>
						 <td   class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style=" text-align:center; display:none">
					   <#=objRow.LedgerTransactionNo#>
						</td>
						<td class="GridViewLabItemStyle" style="width:40px;text-align:center">
							<input type="button" class="ItDoseButton" value="Print"  onclick="Print(this)"/>
						</td>
					</tr>           
		<#}       
		#>       
	 </table>   </script> 

<script id="tb_VitalSign" type="text/html">
	<table  cellspacing="0" rules="all" border="1" 
	style="border-collapse:collapse;width:100%"  class="GridViewStyle">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">BP</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Pulse</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Resp.</th>			
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Temp.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Height(cm)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Weight(kg)</th>
			 <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Arm Span</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">SHeight</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">BMI</th>
		 <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IBW(kg)</th>
		</tr>
		<#     
 
		var dataLength=Vital.length;
		var objRow;   
		for(var j=0;j<dataLength;j++)
		{       
		objRow = Vital[j];
		#>
				   <tr id="Tr2">                                                                                                       
					<td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
					<td class="GridViewLabItemStyle"   style="width:90px;text-align:left" ><#=objRow.Date#></td>
					<td class="GridViewLabItemStyle"   style="width:40px; text-align:center;">
					   <#=objRow.BP#>
						</td>
				   <td class="GridViewLabItemStyle"  style="width:40px; text-align:center;">
						<#=objRow.P#>
					</td>
						<td class="GridViewLabItemStyle"  style="width:40px; text-align:center;">
						<#=objRow.R#>
					</td>
						<td class="GridViewLabItemStyle"  style="width:70px; text-align:center;">
						<#=objRow.T#>
					</td>
						<td class="GridViewLabItemStyle"  style="width:80px; text-align:center;">
						<#=objRow.HT#>
					</td>
						
					   <td class="GridViewLabItemStyle"  style="width:80px; text-align:center;">
						<#=objRow.WT#>
					</td>
						<td class="GridViewLabItemStyle"  style="width:80px; text-align:center;">
						<#=objRow.ArmSpan#>
					</td>
					   <td class="GridViewLabItemStyle"  style="width:80px; text-align:center;">
						<#=objRow.SHight#>
					</td>
					   
					   <td class="GridViewLabItemStyle"  style="width:80px; text-align:center;">
						<#=objRow.BMI#>
					</td>
						<td class="GridViewLabItemStyle"  style="width:80px; text-align:center;">
						<#=objRow.IBWKg#>
					</td>
					   
					</tr>           
		<#}       
		#>       
	 </table>    
	</script>


