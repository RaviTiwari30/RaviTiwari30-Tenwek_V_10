<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PaymentAtDesk.aspx.cs" Inherits="Design_OPD_PaymentAtDesk" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script type="text/javascript">
		$(document).ready(function () {
			getEmployeeType(function () {
				getDoctorEmployees(function () {
					getDepartment(function () {
						getExpenceHeads(function () {
							getApprovalBy(function () {
								searchExpenceList();
							});
						});
					});
				});
			});
		});


		var getApprovalBy = function (callback) {
			var ddlApprovedBy = $('#ddlApprovedBy');
			serverCall('PaymentAtDesk.aspx/GetApprovalBy', {}, function (response) {
				callback($(ddlApprovedBy).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ApprovalType', textField: 'ApprovalType', isSearchable: true }));
			});
		}

		onExpenceTypeChange = function (value,callback) {
			getExpenceSubHead(value, function () { callback(); });
		}

		var getExpenceSubHead = function (expenceHeadID, callback) {
			var ddlExpenceHead = $('#ddlExpenceHead');
			serverCall('PaymentAtDesk.aspx/GetExpenceSubHead', { expenceHeadID: expenceHeadID }, function (response) {
				callback($(ddlExpenceHead).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'subhead_ID', textField: 'subhead_name', isSearchable: true }));
			});
		}




		var getExpenceHeads = function (callback) {
			var ddlExpenceType = $('#ddlExpenceType');
			serverCall('PaymentAtDesk.aspx/GetExpenceHead', {}, function (response) {
				callback($(ddlExpenceType).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'id', textField: 'ExpenceHead', isSearchable: true }));
			});
		}


		var getDepartment = function (callback) {
			var ddlDepartment = $('#ddlDepartment');
			serverCall('../common/CommonService.asmx/GetRoles', {}, function (response) {
				callback($(ddlDepartment).bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ID', textField: 'RoleName', selectedValue: '0', isSearchable: true }));
			});
		}



		//var getEmpByEmployeeType = function (empType, callback) {
		//	var ddlEmployeeName = $('#ddlEmployeeName');
		//	serverCall('../common/CommonService.asmx/GetEmpByEmployeeType', { employeeType: empType }, function (response) {
		//		var responseData = JSON.parse(response);
		//		$(ddlEmployeeName).bindDropDown({ data: responseData, defaultValue: ' ', valueField: 'Employee_ID', textField: 'Name', isSearchable: true });
		//		callback(ddlEmployeeName.val())
		//	});
		//}


		var getEmployeeType = function (callback) {
			var ddlEmployeeType = $('#ddlEmployeeType');
		//	serverCall('../common/CommonService.asmx/GetEmployeeType', {}, function (response) {
			var responseData = [{ type: 'Employees', typeID: 1 }, { type: 'Doctors', typeID: 2 }, { type: 'Other', typeID: 3 }]
				//responseData.push({ Name: 'Other', User_Type_ID: '1' });
			$(ddlEmployeeType).bindDropDown({ data: responseData, valueField: 'typeID', textField: 'type', isSearchable: true });
				callback(ddlEmployeeType.val())
		//	});
		}

		
		var onEmployeeTypeChange = function (val,callback) {
			var empType = Number(val);
			if (empType == 3)
			{
				$('#ddlEmployeeName_chosen').hide();
				$('#txtEmployeeName').show();
				callback();
			}
			else
			{
				getDoctorEmployees(function () {
					$('#txtEmployeeName').hide();
					$('#ddlEmployeeName_chosen').show();
					callback();
				});
			}
		}


		var getDoctorEmployees=function (callback) {
			var employeeType=Number($('#ddlEmployeeType').val());
			var ddlEmployeeName = $('#ddlEmployeeName');
			serverCall('PaymentAtDesk.aspx/GetEmployeeDoctors', { employeeType: employeeType }, function (response) {
				var responseData=JSON.parse(response);
				$(ddlEmployeeName).bindDropDown({ data: responseData, defaultValue: 'Select', valueField: 'Employee_ID', textField: 'Name', isSearchable: true });
				callback();
			})
		}


		var getExpenceDetails = function (callback) {
			var expenceType = Number($('input[type=radio][name=paymentType]:checked').val());
			var employeeTypeID = Number($('#ddlEmployeeType').val());
			var expenceDetails = {
				EmployeeID: employeeTypeID == 3 ? '' : $.trim($('#ddlEmployeeName').val()),
				EmployeeName: employeeTypeID == 3 ? $.trim($('#txtEmployeeName').val()) : $('#ddlEmployeeName option:selected').text(),
				RoleID: Number($('#ddlDepartment').val()),
				ExpenceTypeId: Number($('#ddlExpenceType').val()),
				ExpenceType: $('#ddlExpenceType option:selected').text(),
				ExpenceToId: $.trim($('#ddlExpenceHead').val()),
				ExpenceTo: $('#ddlExpenceHead option:selected').text(),
				AmountPaid: Number($('#txtAmount').val()),
				ApprovedBy: $.trim($('#ddlApprovedBy').val()),
				Naration: $.trim($('#txtRemarks').val()),
				ReceivedAgainstReceiptNo: $.trim($('#txtAgainstReceipt').val()),
				EmployeeType: employeeTypeID
			}
			expenceDetails.AmtCash = expenceDetails.AmountPaid;

			if (expenceDetails.EmployeeID == '0') {
				modelAlert('Please Select Employee', function () {
					$('#ddlEmployeeName').focus();
				});
				return false;
			}
			if (expenceDetails.EmployeeName == '') {
				modelAlert('Please Enter Employee', function () {
					$('#ddlEmployeeName').focus();
				});
				return false;
			}


			if (expenceDetails.RoleID == 0) {
				modelAlert('Please Select Department', function () {
					$('#ddlDepartment').focus();
				});
				return false;
			}


			if (expenceDetails.ExpenceTypeId == '0') {
				modelAlert('Please Select Expence Type', function () {
					$('#ddlExpenceType').focus();
				});
				return false;
			}

			if (expenceDetails.ExpenceToId == '0') {
				modelAlert('Please Select Expence To', function () {
					$('#ddlExpenceHead').focus();
				});
				return false;
			}

			if (expenceDetails.AmountPaid == 0) {
				modelAlert('Please Enter Amount', function () {
					$('#txtAmount').focus();
				});
				return false;
			}

			if (expenceDetails.ApprovedBy == '0') {
				modelAlert('Please Select Approved By', function () {
					$('#ddlApprovedBy').focus();
				});
				return false;
			}

			if (expenceType == 2)
				expenceDetails.AmountPaid = -1 * expenceDetails.AmountPaid;


			callback(expenceDetails, expenceType);

		}

		var save = function (btnSave) {
			getExpenceDetails(function (expenceDetails, expenceType) {
				$(btnSave).attr('disabled', true).val('Submitting...');
				serverCall('PaymentAtDesk.aspx/SaveExpence', { expenceReceipt: expenceDetails}, function (response) {
					var $responseData = JSON.parse(response);
					modelAlert($responseData.response, function () {
						if ($responseData.status) {
							window.open('../../Design/Common/PrintExpense.aspx?id=' + $responseData.receiptNo + '&type=' + (expenceType == 1 ? 'PAID' : 'RECEIVED'));
							window.location.reload();
						}
						else
							$(btnSave).removeAttr('disabled').val('Save');
					});
				});
			});
		}



		var getExpenceList = function (data,callback) {
			serverCall('PaymentAtDesk.aspx/GetExpenceList', data, function (response) {
				var responseData = JSON.parse(response);
				expenceLists = responseData;
				var responseHtml = $('#template_Expence_Lists').parseTemplate(expenceLists);
				$('#divExpenceLists').html(responseHtml).customFixedHeader();
			});
		}

		var searchExpenceList = function (callback) {
			var data = {
				fromDate: $.trim($('#txtFromDate').val()),
				toDate: $.trim($('#txtToDate').val()),
				receiptNo: $.trim($('#txtBillNo').val()),
			}
			getExpenceList(data, function () {});
		}


		var openAddNewExpenceToModel = function () {
			var expenceType =$.trim($('#ddlExpenceType').val());
			if (expenceType != '0') {
				$('#txtExpenceTo').val('');
				$('#divAddExpenceTo').showModel();
			}
			else
				modelAlert('Please Select Expence Type First');
		}

		var saveNewExpenceTo = function () {
			var data={
				expenceType:$.trim($('#ddlExpenceType option:selected').text()),
				subHeadName: $.trim($('#txtExpenceTo').val())
			};
			serverCall('PaymentAtDesk.aspx/NewExpenceTo', data, function (response) {
				var $responseData = JSON.parse(response);
				modelAlert($responseData.response, function () {
					if ($responseData.status) {
						$('#divAddExpenceTo').closeModel();
						onExpenceTypeChange($.trim($('#ddlExpenceType').val()));
					}
					
				});

			});
		}

		var bindReceivedAgainstReceipt = function (elem) {
			$('.againstReceipt').show();
			var selectedTr = $(elem).closest('tr');
			var trData = JSON.parse($(selectedTr).attr('data-app'));
			if (trData.AdjustmentAmount >= trData.AmountPaid) {
			    modelAlert("Received Amount Can't Be Greater Then Issue Amount");
			    return false;
			}

			$('input[type=radio][name=paymentType][value=2]').prop('checked', true);
			$('#txtAgainstReceipt').val(trData.ReceiptNo);
			$('#ddlExpenceType').val(trData.ExpenceTypeId).attr('disabled',true).change().chosen('destroy').chosen();
			$('#ddlDepartment').val(trData.RoleID).chosen('destroy').chosen();
			onExpenceTypeChange(trData.ExpenceTypeId, function () {
				$('#ddlExpenceHead').val(trData.ExpenceToId).attr('disabled', true).chosen('destroy').chosen();
			});
			$('#ddlEmployeeType').val(trData.EmployeeType).chosen('destroy').chosen();
			onEmployeeTypeChange(trData.EmployeeType, function () {
			   
				if (trData.EmployeeType == 3)
					$('#txtEmployeeName').val(trData.NAME);
				else
					$('#ddlEmployeeName').val(trData.EmployeeID).chosen('destroy').chosen();
			});

			$('#ddlApprovedBy').val(trData.ApprovedBy).chosen('destroy').chosen();
			$('#txtAmount').attr('max-value', trData.RemainAmount);
			
		}

		var onPaymentTypeChanged = function () {
			$('#txtAmount').attr('max-value', '10000000');
			$('.againstReceipt').hide();
			$('#txtAgainstReceipt').val('');
			$('#formDetails').find('select').val('0').attr('disabled', false).chosen('destroy').chosen();
			$('#formDetails').find('input[type=text],textarea').val('');
			$('#ddlEmployeeType').val('1').change().chosen('destroy').chosen();
			
		}

		var receiptView = function (elem) {
			var selectedTr = $(elem).closest('tr');
			var trData = JSON.parse($(selectedTr).attr('data-app'));
			var trExpenceType = $.trim(trData.ExpenceType.toLowerCase());
			var expenceType = '';
			if (trExpenceType == 'issue')
				expenceType = 'PAID';
			else if (trExpenceType == 'received')
				expenceType = 'RECEIVED';

			window.open('../../Design/Common/PrintExpense.aspx?id=' + trData.ReceiptNo + '&type=' + expenceType);
		}


	</script>



	<cc1:ToolkitScriptManager ID="scr1" runat="server"></cc1:ToolkitScriptManager>
	<div id="Pbody_box_inventory">
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Payment At Desk</b>
		</div>
		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">Add New Expence Details</div>
			<div class="row">
				<div class="col-md-1"></div>
				<div id="formDetails" class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Payment Type
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<label>
								<input type="radio" value="1" name="paymentType" onclick="onPaymentTypeChanged()" checked="checked" />Issue 
							</label>
							<label>
								<input type="radio" name="paymentType" value="2" />Received 
							</label>
						</div>
						<div class="col-md-3">
							<label style="display:none;font-weight:bold" class="pull-left againstReceipt patientInfo">
								Against Receipt
							</label>
							<b style="display:none" class="pull-right againstReceipt">:</b>
						</div>
						<div class="col-md-5">
							<input type="text" class="required againstReceipt patientInfo" style="display:none" disabled="disabled" id="txtAgainstReceipt"/> 
						</div>
						<div class="col-md-3">
							<label class="pull-left">
							</label>
							<b class="pull-right"></b>

						</div>
						<div class="col-md-5">
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Employee Type
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select class="required" onchange="onEmployeeTypeChange(this.value,function(){})" id="ddlEmployeeType"></select>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select class="required" id="ddlEmployeeName"></select>
							<input class="required" style="display: none" type="text" onlytext="150"  id="txtEmployeeName" />
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Department 
							</label>
							<b class="pull-right">:</b>

						</div>
						<div class="col-md-5">
							<select class="required" id="ddlDepartment"></select>
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Expence Type
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select class="required" onchange="onExpenceTypeChange(this.value,function(){})" id="ddlExpenceType"></select>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Expence To
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-4">
							<select class="required" id="ddlExpenceHead"></select>
						</div>
						<div class="col-md-1">
							<input type="button" id="btnAddNewExpenceTo" onclick="openAddNewExpenceToModel()"  value="New" />
						</div>
						<div class="col-md-3">
							<label class="pull-left">
							</label>
							<b class="pull-right"></b>
						</div>
						<div class="col-md-5">
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Amount
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input class="required" onlynumber="5" decimalplace="2" max-value="10000000"  class="ItDoseTextinputNum" type="text" id="txtAmount" />
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Approved By
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select class="required" id="ddlApprovedBy"></select>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Remarks
							</label>
							<b class="pull-right">:</b>

						</div>
						<div class="col-md-5">
							<textarea id="txtRemarks" style="min-height: 30px" cols="2" rows=""></textarea>
						</div>
					</div>
					<div class="row">
						<div style="text-align: center" class="col-md-24">
							<input type="button" onclick="save(this)" value="Save" class="save" />
						</div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>


		</div>

		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">Search Expence  Details</div>
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								From Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ClientIDMode="Static" runat="server" ID="txtFromDate"></asp:TextBox>
							<cc1:CalendarExtender ID="calendarExtenderFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								To Date 
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ClientIDMode="Static" runat="server" ID="txtToDate"></asp:TextBox>
							<cc1:CalendarExtender ID="calendarExtenderToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Receipt No.
							</label>
							<b class="pull-right">:</b>

						</div>
						<div class="col-md-5">
							<input type="text" id="txtBillNo" />
						</div>
					</div>
					<div class="row">
						<div class="col-md-4">
										 <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" onclick="labelSearch('Confirmed',function(){})" class="circle badge-grey"></button>
										 <b style="margin-top:5px;margin-left:5px;float:left">Received</b> 
						</div>
						<div style="text-align: center" class="col-md-16">
							<input type="button" value="Search" onclick="searchExpenceList()" class="save" />
						</div>
						<div class="col-md-4"></div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>

				<div class="row">
				<div id="divExpenceLists" style="max-height:275px;overflow:auto " class="col-md-24">
				</div>
			</div>
		</div>
	</div>


	<div id="divAddExpenceTo"     class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:420px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddExpenceTo" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Create New Expence To</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">    Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="100" id="txtExpenceTo" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="saveNewExpenceTo(this)" >Save</button>
						 <button type="button"  data-dismiss="divAddExpenceTo" >Close</button>
				</div>
			</div>
		</div>
	</div>



	


	<script id="template_Expence_Lists" type="text/html">
		<table  id="tableMobileApplicationAppointment" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
		<thead>
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" >Sr No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Receipt No</th>
			<th class="GridViewHeaderStyle" scope="col" >Received Against Receipt</th>
			<th class="GridViewHeaderStyle" scope="col" >Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Amount Paid</th>
			<th class="GridViewHeaderStyle" scope="col" >Adjustment</th>
			<th class="GridViewHeaderStyle" scope="col" >Expence Type</th>
			<th class="GridViewHeaderStyle" scope="col" >NAME</th>
			<th class="GridViewHeaderStyle" scope="col">Remarks</th> 
			<th class="GridViewHeaderStyle" scope="col">Receive</th>                                                     
		</tr>
			</thead>   
			<tbody>

				<#
					 var dataLength=expenceLists.length;        
					 var objRow;    
			
				for(var j=0;j<dataLength;j++)
				{
					objRow = expenceLists[j];
				#>          
				
					<tr onmouseover="this.style.color='#00F'"    data-app='<#= JSON.stringify(objRow)  #>'  ondblclick="receiptView(this)"  onMouseOut="this.style.color=''"  
					
						<# if(objRow.AmountPaid>0){#>
							 style="cursor:pointer;background-color:''"
					<#}else{ #>
							 style="cursor:pointer;background-color:#a0a0a0"
						<#}#>
						>                            
						<td class="GridViewLabItemStyle">
								<#=j+1 #>
						</td>                                                    
						<td  class="GridViewLabItemStyle" id="td1"><#=objRow.ReceiptNo#></td>
						<td  class="GridViewLabItemStyle" id="td6"><#=objRow.ReceivedAgainstReceiptNo#></td>
						<td class="GridViewLabItemStyle"><#= objRow.Date#>  </td>
						<td class="GridViewLabItemStyle" style="text-align: center;" id="td4" style=""><#=objRow.AmountPaid#></td> 
						<td class="GridViewLabItemStyle" style="text-align: center;" id="td7" style=""><#=objRow.AdjustmentAmount#></td> 
						<td class="GridViewLabItemStyle" id="td3" style=""><#=objRow.ExpenceType#></td> 
						<td class="GridViewLabItemStyle" id="td5" style=""><#=objRow.NAME#></td> 
						<td class="GridViewLabItemStyle" id="td12" style=""><#=objRow.Naration#></td>     
						<td style="text-align: center;"  class="GridViewLabItemStyle" id="td2" >
							<#if(objRow.AmountPaid>0){ #>
									<img src="../../Images/Post.gif" alt="" onclick="bindReceivedAgainstReceipt(this)" />
							<#}#>
						</td>                         
				   </tr>            
			<#}#>            

			</tbody>
		 </table>    
	</script>
</asp:Content>



