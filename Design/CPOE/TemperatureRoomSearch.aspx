<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TemperatureRoomSearch.aspx.cs" Inherits="Design_CPOE_TemperatureRoomSearch" Title="TemperatureRoomSearch"
	MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
	 <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    
	<style type="text/css">
		.hover {
			background-color: LightBlue;
			color: white;
			cursor: default;
		}

		.Counthover {
			background-color: LightBlue;
			color: white;
			cursor: pointer;
		}

		.auto-style1 {
			width: 765px;
		}
         .blink {
            color:red;
            font-weight:bold;
	    }
	</style>
	<script type="text/javascript">

		var _oldColor;
		function SetNewColor(source) {
			_oldColor = source.style.backgroundColor;
			source.style.backgroundColor = '#afeeee';
		}

		function SetOldColor(source) {
			source.style.backgroundColor = _oldColor;
		}
		function ShowPatient(tnxNo) {
			window.open('PatientReport.aspx?TID=' + tnxNo);
		}
	</script>
	<script type="text/javascript">
		$(document).ready(function () {
			$('#fromDate').change(function () {
				ChkDate();

			});

			$('#ToDate').change(function () {
				ChkDate();

			});

			$('#ddlOPDType').chosen();
		});
		function ChkDate() {
			$.ajax({
				url: "../common/CommonService.asmx/CompareDate",
				data: '{DateFrom:"' + $('#fromDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
				type: "POST",
				async: true,
				dataType: "json",
				contentType: "application/json; charset=utf-8",
				success: function (mydata) {
					var data = mydata.d;
					if (data == false) {
						$('#lblMsg').text('To date can not be less than from date!');
						$('#btnSearch').attr('disabled', 'disabled');

						$('#CpoeOutput').html('');
						$('#CpoeOutput').hide();
						return;
					}
					else {
						$('#lblMsg').text('');
						$('#btnSearch').removeAttr('disabled');

					}
				}
			});

		}

	</script>
	<script type="text/javascript">
		function ReseizeIframe() {
			document.getElementById("iframePatient").style.width = "100%";
			document.getElementById("iframePatient").style.height = "100%";
			document.getElementById("iframePatient").style.display = "";

		}
	</script>
	 <script type="text/javascript">
		 function reseizeIframe(elem) {
			 $modelBlockUI();
			 var iframe = document.getElementById("iframePatient");
			 var row = $(elem).closest('tr');
			 iframe.onload = function () {
				 iframe.style.width = '100%';
				 iframe.style.height = '100%';
				 iframe.style.display = '';
				 try {
					 debugger;
					 var contentDocument = document.getElementById("iframePatient").contentDocument;
					 contentDocument.getElementById('lblPatientName').innerHTML = row.find('.patientName').text();
					 contentDocument.getElementById('lblDoctorName').innerHTML = row.find('.patientDoctorName').text();
					 contentDocument.getElementById('lblPatientID').innerHTML = row.find('.patientID').text();
					 contentDocument.getElementById('lblPanel').innerHTML = row.find('.patientPanelName').text();
					 contentDocument.getElementById('lblGender').innerHTML = row.find('.patientSex').text();
					 contentDocument.getElementById('lblAge').innerHTML = row.find('.patientAge').text();
					 contentDocument.getElementById('lblAppointmentDate').innerHTML = row.find('.patientAppointmentDate').text();
					 contentDocument.getElementById('lblAppointmentID').innerHTML = row.find('.patientAppointmentID').text();
					 contentDocument.getElementById('lblPurposeOfVisit').innerHTML = row.find('.PurposeOfVisit').text();
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
	<script type="text/javascript">
		$(function () {
			var txtBarcode = $('#txtBarcode').focus();
			txtBarcode.keypress(function (e) {
				var key = (e.keyCode ? e.keyCode : e.charCode);
				if (key == 13) {
					e.preventDefault();
					if (!String.isNullOrEmpty($(txtBarcode).val())) {
						getSearchCreteria(function (data) {
							data.MRNo = $(txtBarcode).val();
							searchCpoe(data);
						});
					}
				}
			});

			$('#ddlDoctor,#ddlPanel').chosen();
		});


		function searchCpoe(data) {
			serverCall('TemperatureRoomSearch.aspx/TemperatureRoomSearch', data, function (response) {
				cpoe = JSON.parse(response);
				var output = $('#tb_SearchCpoe').parseTemplate(cpoe);
				$('#CpoeOutput').html(output);
				$('#CpoeOutput,#myTable').show();
			});
		}



		var getSearchCreteria = function (callback) {
			callback({
				MRNo: $.trim($('#txtRegNo').val()),
				PName: $.trim($('#txtPName').val()),
				AppNo: $.trim($('#txtAppNo').val()),
				DoctorID: $.trim($('#ddlDoctor').val()),
				status: $.trim($('#ddlStatus').val()),
				fromDate: $.trim($('#fromDate').val()),
				toDate: $.trim($('#ToDate').val()),
				DrGroup: $.trim($('#ddlDoctorGroup').val()),
				panelID: $.trim($('#ddlPanel').val()),
				appointmentType: $.trim($('#ddlOPDType').val()),
			});
		}



		var searchAppointments = function () {
		    if ($('#ddlOPDType').val() != '0') {
		        getSearchCreteria(function (data) {
		            searchCpoe(data);
		        });
		    }
		    else { modelAlert('Please Select Clinic');}
		}

	</script>
	
	<div id="Pbody_box_inventory">
		<Ajax:ScriptManager ID="sm" runat="server" />
		<div class="POuter_Box_Inventory" style="text-align: center;">

			<b>Search Patient </b>
			<br />
			<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
		</div>
		<div class="POuter_Box_Inventory">
			
			   <div class="row">
				   <div class="col-md-1"></div>
				<div class="col-md-22">
					 <div class="row">
						<div class="col-md-3">
							<label class="pull-left">
							  <strong>Barcode Search</strong>
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <input type="text" id="txtBarcode" maxlength="20"  tabindex="1"   />
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								UHID
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtRegNo" ClientIDMode="Static" runat="server"  TabIndex="1" ToolTip="Enter UHID" />
						</div>
							<div class="col-md-3">
							<label class="pull-left">
								App. No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtAppNo" ClientIDMode="Static" runat="server"  TabIndex="3" ToolTip="Enter  App. No." />
						<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtAppNo"
							ValidChars="0987654321">
						</cc1:FilteredTextBoxExtender>
						</div>
					</div>
					 <div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Patient Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:TextBox ID="txtPName"  ClientIDMode="Static" runat="server" TabIndex="2" ToolTip="Enter Patient Name" />
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Doctor Group
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:DropDownList ID="ddlDoctorGroup" ClientIDMode="Static" runat="server" ></asp:DropDownList>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Status
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:DropDownList ID="ddlStatus" runat="server"  ClientIDMode="Static" TabIndex="7" ToolTip="Select Status">
							<asp:ListItem Selected="True" Value="0">Pending</asp:ListItem>
							<asp:ListItem Value="1">Closed</asp:ListItem>
							<asp:ListItem Value="2">All</asp:ListItem>
						</asp:DropDownList> 
						 </div>
					</div>

					 <div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Clinic
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownList ID="ddlOPDType" ClientIDMode="Static"  runat="server"  TabIndex="4" ToolTip="Select OPD Type" />
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
								Doctor
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							 <asp:DropDownList ID="ddlDoctor" ClientIDMode="Static" runat="server"  TabIndex="4" ToolTip="Select OPD Type" />
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								Panel
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownList ID="ddlPanel" ClientIDMode="Static" runat="server"  TabIndex="5" ToolTip="Select Panel" />
						</div>
					   
					</div>

					 <div class="row">
						 <div class="col-md-3">
							<label class="pull-left">
								From  Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="fromDate"  runat="server" ToolTip="Select From Date" TabIndex="8"
							ClientIDMode="Static"></asp:TextBox>
						<cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="fromDate" Format="dd-MMM-yyyy"
							ClearTime="true">
						</cc1:CalendarExtender>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
								To  Date 
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="ToDate" runat="server" ToolTip="Select To Date" ClientIDMode="Static"
						   TabIndex="9"></asp:TextBox>
						<cc1:CalendarExtender ID="txtAppointmentDate0_CalendarExtender" runat="server" TargetControlID="ToDate"
							Format="dd-MMM-yyyy" ClearTime="true">
						</cc1:CalendarExtender>
						</div>
						 
					</div>
					 
				</div>
					<div class="col-md-1"></div>
			</div>
			 </div>
		 <div class="POuter_Box_Inventory" style="text-align:center">
			 <div class="row">
				<div class="col-md-24">
					<div class="row">
						<div class="col-md-10">
							<button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color: coral"  class="circle"></button>
								 <b style="margin-top:5px;margin-left:5px;float:left">Emergency</b> 
								<button type="button" style="width:25px;height:25px;margin-left:5px;float:left" class="circle badge-grey"></button>
								 <b style="margin-top:5px;margin-left:5px;float:left">Payment Pending</b> 
                            	<button type="button" style=" background-color: yellow;width:25px;height:25px;margin-left:5px;float:left" class="circle" ></button>
								 <b style="margin-top:5px;margin-left:5px;float:left">Admitted In Casulty</b> 
						</div>
						 <div class="col-md-8">
								<input type="button" value="Search" id="btnSearch" onclick="searchAppointments()" class="ItDoseButton" />
							</div>
						  <div class="col-md-6">
						           <b style="margin-top:5px;margin-left:5px;float:right">Doctor IN</b> 
						    <button type="button" style="width:25px;height:25px;margin-left:5px;float:right" class="circle badge-warning"></button>
								 <b style="margin-top:5px;margin-left:5px;float:right">Doctor OUT</b> 
                               <button type="button" style="width:25px;height:25px;margin-left:5px;float:right" class="circle badge-avilable"></button>
						</div>
					</div>
				</div>
			</div>
			 </div>
		 <div class="POuter_Box_Inventory">
		<table  style="width: 100%;border-collapse:collapse;display:none" id="myTable">
				<tr >
					<td colspan="4">
						 <div id="CpoeOutput" style="max-height: 400px; overflow-x: auto;">
						</div>
						<br />                       
					</td>
				</tr>
			</table>
	</div>
	</div>
	<iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>

	<script id="tb_SearchCpoe" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOPD"
	style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">#</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:66px;display:none;">App. No.</th>
            <th class="GridViewHeaderStyle" scope="col">Shortcuts</th>
			 <th class="GridViewHeaderStyle" scope="col">Triaging Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">UHID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Contact</th>
			<th class="GridViewHeaderStyle" scope="col" >Sex</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:133px;">Appointment On</th>
			<th class="GridViewHeaderStyle" scope="col" >Doctor</th>
			<th class="GridViewHeaderStyle" scope="col" >Panel</th>
			<th class="GridViewHeaderStyle" scope="col" >Visit Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">AppID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">LedgertransactionNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">TransactionID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">IsDone</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;"></th>
				   
		</tr>
		<#       
		var dataLength=cpoe.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{       
		objRow = cpoe[j];
		#>
					<tr id="<#=j+1#>"  
			 <#if(objRow.IsEmergency=="1"){#>
						style="background-color:coral"
						<#}#>
			 
			  <#if(objRow.IsPaid==0){#>
						style="background-color:gray"
			  <#}#>

             <#if(objRow.Status=='Out'){#>
						style="background-color:#82af6f"
			  <#}#>

              <#if(objRow.Status=='IN'){#>
						style="background-color:#f89406"
			  <#}#>
                        <#if(objRow.IsPatientAdmitted=='1'){#>
						style="background-color:#FFFF00"
			  <#}#>


						>   
						 
					<td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
					<td class="GridViewLabItemStyle patientAppointmentNo" id="tdAppNo"  style="text-align:center; display:none" ><#=objRow.AppNo#></td>
                           <td class="GridViewLabItemStyle " id="tdshortcut"  > 
                          <a target="pagecontent"   id='AShortcut'  name="h"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<#=objRow.PatientID#>','../OPD/FlowSheetViewOpd.aspx?PatientId=<#=objRow.PatientID#>&amp;TransactionId=<#=objRow.TransactionID#>&amp;PType=OPD', 1050, 1050, '73%', '90%');" style="color:yellow;" >FlowSheets</a><br />
                
                    </td>
                
                           <td class="GridViewLabItemStyle"  scope="col"
                    style='text-align:center; color: <#=objRow.ColorCode=="black" ? 'white': ""#> ;background-color:<#= objRow.ColorCode #>'
                    >
                    <#=objRow.CodeType#>

                </td>  
					<td class="GridViewLabItemStyle patientID" id="tdPatientID" <#if(objRow.PatientType=="VIP"){#>style="background-color:orange"<#}
                         else if(objRow.PatientType=="Warning Alert"){#>style="background-color:orange"<#}#>
                        
                        ><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle patientName
                             <#if(objRow.Status=='Call'){#>
                              blink
                        <#} #>
                        
                        
                        " id="tdPatientName" ><#=objRow.Pname#>

                         <#if(objRow.Status=='Call'){#>
						<%--<img alt="Select" src="../../Images/bell.gif" style="border: 0px solid #FFFFFF;transform: scale(1.2);height: 15px;" />--%>
						<#}#>
					</td>
					<td class="GridViewLabItemStyle" id="tdAge" ><#=objRow.ContactNo#></td>
					<td class="GridViewLabItemStyle patientSex" id="tdSex" ><#=objRow.Sex#></td>
					<td class="GridViewLabItemStyle patientAppointmentDate" id="tdAppointmentDate" style="text-align:center"><#=objRow.AppointmentDate#>

                         <#if(objRow.labResultCount>0){#>
                        <span style="float:right" class="icon icon-color icon-pdf"></span>
                        <#}#>
					</td>

					<td class="GridViewLabItemStyle patientDoctorName" id="td7" ><#=objRow.DName#></td>
					<td class="GridViewLabItemStyle patientDoctorName" id="td1" ><#=objRow.Company_Name#></td>
					<td class="GridViewLabItemStyle" id="tdVisitType" style="text-align:center;"><#=objRow.SubName#></td>
					<td class="GridViewLabItemStyle patientAge" id="td13" style="display:none"><#=objRow.Age#></td>  
					<td class="GridViewLabItemStyle patientPanelName" id="td15" style="display:none"><#=objRow.PanelName#></td>  
					
					<td class="GridViewLabItemStyle patientAppointmentID" id="tdAppID" style="display:none"><#=objRow.App_ID#></td>                     
					<td class="GridViewLabItemStyle" id="tdLedgerTnxNo" style="display:none"><#=objRow.LedgerTnxNo#></td>
					<td class="GridViewLabItemStyle" id="tdTransactionID"  style="display:none" ><#=objRow.TransactionID#></td>                                                           
					<td class="GridViewLabItemStyle" id="tdIsDone"  style="display:none" ><#=objRow.IsDone#></td>  
                        <td class="GridViewLabItemStyle PurposeOfVisit" id="tdPurposeOfVisit"  style="display:none" ><#=objRow.PurposeOfVisit#></td>   
					<td class="GridViewLabItemStyle" style="text-align:center"  >
                         <#if((objRow.SelectFlag ==1 || objRow.SelectFlag ==2) && objRow.IsPaymentApproval==1 ){#>
                         
					               <a target="iframePatient" onclick="reseizeIframe(this);" href="CPOEFolder.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;Sex=<#=objRow.Sex#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=<#=objRow.PanelID#>&amp;DeptID=<#=objRow.DocDepartmentID#>">
						  

                        <#if(objRow.IsPaid ==0){#>
					 <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>    
				   <#}
						else
						{#>                  
					 <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>    
						<#}#> 
                        <#}#> 
                                        
					</td>     
								
					</tr>           
		<#}       
		#>       
	 </table>    
	</script>
	<script type="text/javascript">
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

		function showFrame(TID, LnxNo, Sex, IsDone, PatientID, App_ID) {
			ReseizeIframe();
			location.href = 'CPOE.aspx?TID=' + TID + '&LnxNo=' + LnxNo + '&Sex=' + Sex + '&IsDone=' + IsDone + '&PatientID=' + PatientID + '&App_ID=' + App_ID + '';
		}
	</script>
</asp:Content>
