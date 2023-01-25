<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PurchaseOrderApproval.aspx.cs" Inherits="Design_Store_PurchaseOrderApproval" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	<style type="text/css">
	    .customRow {
	        cursor: pointer;
	    }

	        .customRow:hover {
	            background-color: #b0f8f8;
	        }
	</style>




	<script type="text/javascript">


	    //*****Global Variables*******



	    //****************************



	    $(function () {
	        getCentre(function () {
	            getDepartMent(function () {
	                getRequestions(true);
	            });
	        });
	    });



	    var getCentre = function (callback) {
	        serverCall('Services/CommonService.asmx/GetAllCentre', {}, function (response) {
	            var responseData = JSON.parse(response);
	            callback($('#ddlCentre').bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', defaultValue: 'All' }));
	        });
	    }

	    var getDepartMent = function (callback) {
	        serverCall('Services/CommonService.asmx/GetDepartMent', {}, function (response) {
	            var responseData = JSON.parse(response);
	            callback($('#ddlDepartment').bindDropDown({ data: JSON.parse(response), valueField: 'DeptLedgerNo', textField: 'RoleName', defaultValue: 'All' }));
	        });
	    }

	    var getRequestions = function (searchType) {
	        var data = {
	            fromDate: $.trim($('#txtFromDate').val()),
	            toDate: $.trim($('#txtToDate').val()),
	            departmentLedgerNo: $.trim($('#ddlDepartment').val()),
	            CentreID: $.trim($('#ddlCentre').val()),
	            RequestionTypeID: $.trim($('#ddlIndentType').val()),
	            searchType: searchType,

	        }
	        serverCall('PurchaseOrderApproval.aspx/GetRequisitions', data, function (reponse) {
	            requestionApproval = JSON.parse(reponse);
	            if (requestionApproval == '1') {
	                $('#divRequestionApproval').html('<label style="color:red;font-size:medium;font-weight:bold; margin-left: 38%;">No Data Found..</label>');
	            }
	            else if (requestionApproval == '0') {
	                $('#divRequestionApproval').html('<label style="color:red;font-size:medium;font-weight:bold; margin-left: 38%;">You have no authority for approval..</label>');
	            }
	            else {
	                $('#divRequestionApproval').html($('#template_Requisitions').parseTemplate(requestionApproval)).customFixedHeader();
	            }
	        });
	    }

	    var getIndentDetails = function (elem, callback) {
	        var selectedRequisitionDetails = JSON.parse($(elem).closest('tr').find('#tdData').text());
	        var data = {
	            requisitionType: selectedRequisitionDetails.RequestionType,
	            requisitionNo: selectedRequisitionDetails.IndentNo,
	            centreID: selectedRequisitionDetails.CentreID,
	            departmentLedgerNo: selectedRequisitionDetails.DeptFrom
	        }
	        serverCall('PurchaseOrderApproval.aspx/GetRequisitionDetails', data, function (response) {
	            var responseData = JSON.parse(response);
	            bindRequisitionDetails(elem, responseData);
	            callback();
	        });
	    }



	    var bindRequisitionDetails = function (elem, data) {
	        var selectedRow = $(elem).closest('tr');
	        var isAlreadySelected = selectedRow.hasClass('selectedRow');
	        $(elem).closest('tbody').find('tr').removeClass('selectedRow').hide();
	        if (!isAlreadySelected) {
	            $('.trIndentDetails').hide().find('td').html('');
	            requisitionDetails = data;
	            selectedRow.addClass('selectedRow').show().next('.trIndentDetails')
					.show().find('td').html($('#template_RequisitionDetails').parseTemplate(requisitionDetails));
	        }
	        else {
	            $(elem).closest('tbody').find('tr').removeClass('selectedRow').show();
	            $('.trIndentDetails').hide().find('td').html('');
	        }
	    }



	    var onRequisitionApproved = function (elem) {
	        var selectedRequisitionDetails = JSON.parse($(elem).closest('tr').find('#tdData').text());
	        $('#spnPurchaseOrder').text(selectedRequisitionDetails.PurchaseOrderNo);
	        $('#divRequisitionApproveModel').showModel();
	        $('#txtApprovedRemarks').val('').focus();
	    }


	    var saveRequisitionApproval = function () {
	        var data = {
	            purchaseOrderNumber: $.trim($('#spnPurchaseOrder').text()),
	            remark: $.trim($('#txtApprovedRemarks').val())
	        }


	        var url = 'PurchaseOrderApproval.aspx/ApprovedPurchaseOrder';

	        serverCall(url, data, function (response) {
	            var responseData = JSON.parse(response);
	            modelAlert(responseData.message, function (res) {
	                    $('#divRequisitionApproveModel').closeModel();
	                    getRequestions(true);
	            });
	        });
	    }



	    var onRequisitionReject = function (elem) {
	        var selectedRequisitionDetails = JSON.parse($(elem).closest('tr').find('#tdData').text());
	        $('#spnRejectPurchaseOrder').text(selectedRequisitionDetails.PurchaseOrderNo);
	        $('#divRequisitionRejectModel').showModel();
	        $('#txtRejectRemark').val('').focus();
	    }


	    var saveRequisitionReject = function () {
	        var data = {
	            purchaseOrderNumber: $.trim($('#spnRejectPurchaseOrder').text()),
	            remark: $.trim($('#txtRejectRemark').val())
	        }

	        var url = 'PurchaseOrderApproval.aspx/RejectPurchaseOrder';

	        serverCall(url, data, function (response) {
	            var responseData = JSON.parse(response);
	            modelAlert(responseData.message, function (res) {
	                    $('#divRequisitionRejectModel').closeModel();
	                    getRequestions(true);
	            });
	        });
	    }


	    var onRequisitionEdit = function (elem) {

	    }









		</script>
<div id="Pbody_box_inventory">
	<cc1:ToolkitScriptManager runat="server" ID="scrManager"></cc1:ToolkitScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Purchase Order Approval</b>
		</div>
		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">
				Search Purchase Order`s
			</div>
			<div class="row">
				<div class="col-md-3">
					<label class="pull-left">Centre </label>
					<b class="pull-right">:</b>
				</div>

				<div class="col-md-5">
					<select id="ddlCentre"></select>
				</div>


                <div class="col-md-3">
					<label class="pull-left">From Date </label>
					<b class="pull-right">:</b>
				</div>

				<div class="col-md-5">
					<asp:TextBox runat="server" ClientIDMode="Static" ID="txtFromDate"></asp:TextBox>
					<cc1:CalendarExtender runat="server" ID="calExtFromDate" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
				</div>
				<div class="col-md-3">
					<label class="pull-left">To Date</label>
					<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					<asp:TextBox runat="server" ClientIDMode="Static" ID="txtToDate"></asp:TextBox>
					<cc1:CalendarExtender runat="server" ID="calExtToDate" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
				</div>


				
			</div>
			<div class="row hidden">
				      <div class="col-md-3 hidden">
					<label class="pull-left">Department </label>
					<b class="pull-right">:</b>
				</div>

				<div class="col-md-5 hidden">
					<select id="ddlDepartment"></select>
				</div>
				<div class="col-md-3 hidden">
					<label class="pull-left">Type</label>
					<b class="pull-right">:</b>
				</div>

				<div class="col-md-5 hidden">
					<select id="ddlIndentType">
						<option value="1">ALL</option>
						<%--<option value="2">Issue</option>
						<option value="3">Return</option>
                        <option value="4">Direct Issue</option>--%>
					</select>
				</div>
				</div>
			</div>

	<div class="POuter_Box_Inventory"  style="text-align:center">
			<input type="button" value="Search" class=" save margin-top-on-btn" onclick="getRequestions(true);" id="btnSearch" />
		</div>
		<div class="POuter_Box_Inventory">
			<div class="row">
				<div class="col-md-24">
					<div style="max-height: 400px; overflow: auto" id="divRequestionApproval">
					</div>
				</div>
			</div>
		</div>
		
	
	</div>
	<script id="template_Requisitions" type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="tblIndents" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle">#</th>
						<th class="GridViewHeaderStyle">Purchase Order No</th>
						<th class="GridViewHeaderStyle">Subject</th>
						<th class="GridViewHeaderStyle">Supplier</th>
						<th class="GridViewHeaderStyle">Net Amount</th>
						<th class="GridViewHeaderStyle">Raised By</th>
						<th class="GridViewHeaderStyle">Raised On</th>
                        <th class="GridViewHeaderStyle">Edit</th>
                        <th class="GridViewHeaderStyle">Approved</th>
						<th class="GridViewHeaderStyle">Reject</th>
						</tr>
				</thead>
				   <tbody>
			<#
			 var dataLength=requestionApproval.length;        
			 var objRow; 
          
				for(var j=0;j<dataLength;j++)
				{
						objRow = requestionApproval[j];
				#>          
				         
				<tr  id="<#= j+1 #>"  class="customRow">
					<td class="GridViewLabItemStyle"><#= j+1 #></td>
					<td class="GridViewLabItemStyle bold" id="tdRequestionNo"  ><#=objRow.PurchaseOrderNo#></td>
					<td class="GridViewLabItemStyle">  <#=objRow.Subject#></td>
					<td class="GridViewLabItemStyle"> <#=objRow.VendorName#></td>
					<td class="GridViewLabItemStyle textCenter"> <#=objRow.GrossTotal#></td>
					<td class="GridViewLabItemStyle textCenter"> <#=objRow.UserName#></td>
                    <td class="GridViewLabItemStyle textCenter"> <#=objRow.RaisedDate#></td>
                    <td class="GridViewLabItemStyle hidden" id="tdData"> <#=JSON.stringify(objRow) #></td>
                    
                      <td class="GridViewLabItemStyle textCenter"> 
                        <img alt="E" onclick="onEditPurchaseOrder(this)"  class="btnOperation" style="cursor:pointer" src="../../Images/Post.gif"/>
                      </td>


                    <td class="GridViewLabItemStyle textCenter"> 
                        <img alt="X" onclick="onRequisitionApproved(this)"  class="btnOperation" style="cursor:pointer" src="../../Images/Post.gif"/>
                    </td>
                    <td class="GridViewLabItemStyle textCenter"> 
                        <img alt="X" onclick="onRequisitionReject(this)"  class="btnOperation" style="cursor:pointer" src="../../Images/Delete.gif"/>
                    </td>
                    </tr>
			   <#}#>     
					</tbody>       
		 </table>    
	</script>


	<script id="template_PurchaseOrderDetails"  type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="Table1" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle" style="width:18px">#</th>
						<th class="GridViewHeaderStyle">Item Name</th>
                        <th class="GridViewHeaderStyle" style="width:95px">Unit Price</th>
                        <th class="GridViewHeaderStyle" style="width:95px">Amount</th>
                        <th class="GridViewHeaderStyle" style="width:45px">MRP</th>
                        <th class="GridViewHeaderStyle" style="width:45px">Quantity</th>
						<th class="GridViewHeaderStyle" style="width:65px" >Reject</th>
						</tr>
				</thead>
				   <tbody>
			<#
			 var dataLength=responseData.length;        
			 var objRow;    
			
				for(var j=0;j<dataLength;j++)
				{
					objRow = responseData[j];
				#>          
				<tr>
					<td  class="GridViewLabItemStyle"><#= j+1 #></td>
					<td class="GridViewLabItemStyle" id="td1"> <#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle textCenter"> <#=objRow.BuyPrice#></td>
                    <td class="GridViewLabItemStyle textCenter"> <#=objRow.Amount#></td>
                    <td class="GridViewLabItemStyle textCenter"> <#=objRow.MRP#></td>
                     <td class="GridViewLabItemStyle hidden tdData"> <#=JSON.stringify(objRow) #></td>
					<td class="GridViewLabItemStyle">
                        <input type="text" value='<#=objRow.ApprovedQty#>'   onlynumber="10" decimalplace="4" max-value="10000000000"  autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$labItemRateQuantityDiscountChange(event)"  id="txtApprovedQty" class="ItDoseTextinputNum" />
					</td>
                    <td class="GridViewLabItemStyle textCenter">
                        <img alt="X" onclick="cancelPurchaseOrderItem(this)"  class="btnOperation" style="cursor:pointer" src="../../Images/Delete.gif"/>
                    </td>
				</tr>
			  

			   <#}#>     
					</tbody>       
		 </table>
	</script>






	<div id="divRequisitionApproveModel" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divRequisitionApproveModel" aria-hidden="true">×</button>
					<h4 class="modal-title">Approved Remark</h4>
					<span id="spnPurchaseOrder" style="display:none"></span>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div style="display:none" class="col-md-5">
							   <label class="pull-left">   Remark   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-24">
							 <textarea cols="" rows="" style="height: 75px;width: 276px;max-height:75px;max-width:276px;min-height:75px;min-width:276px" id="txtApprovedRemarks"></textarea>
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button" class="save" onclick="saveRequisitionApproval()" >Save</button>
						 <button type="button" class="save" data-dismiss="divRequisitionApproveModel">Close</button>
				</div>
			</div>
		</div>
	</div>




	<div id="divRequisitionRejectModel" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divRequisitionRejectModel" aria-hidden="true">×</button>
					<h4 class="modal-title">Reject Remark</h4>
					<span id="spnRejectPurchaseOrder" style="display:none"></span>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div style="display:none" class="col-md-5">
							   <label class="pull-left">   Remark   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-24">
							 <textarea cols="" rows="" style="height: 75px;width: 276px;max-height:75px;max-width:276px;min-height:75px;min-width:276px" id="txtRejectRemark"></textarea>
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button" class="save" onclick="saveRequisitionReject()" >Save</button>
						 <button type="button" class="save" data-dismiss="divRequisitionRejectModel">Close</button>
				</div>
			</div>
		</div>
	</div>




    <div id="divPurchaseOrderEdit" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divPurchaseOrderEdit" aria-hidden="true">×</button>
					<h4 class="modal-title">Purchase Order Edit</h4>
					<span class="spnPurchaseOrderEdit" style="display:none"></span>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div  class="col-md-24" style="width: 750px;max-height: 400px;overflow: auto;">
							 
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button" class="save"  onclick="updatePurchaseOrder(this);" >Save</button>
						 <button type="button" class="save" data-dismiss="divPurchaseOrderEdit">Close</button>
				</div>
			</div>
		</div>
	</div>
    


    <script type="text/javascript">

        var onEditPurchaseOrder = function (el) {
            var selectedRequisitionDetails = JSON.parse($(el).closest('tr').find('#tdData').text());
            var divPurchaseOrderEdit = $('#divPurchaseOrderEdit');
            divPurchaseOrderEdit.find('#spnPurchaseOrderEdit').text(selectedRequisitionDetails.PurchaseOrderNo);
            bindPurchaseOrderItemDetails(selectedRequisitionDetails.PurchaseOrderNo);
        }
        

        var bindPurchaseOrderItemDetails = function (purchaseOrderNumber) {
            var divPurchaseOrderEdit = $('#divPurchaseOrderEdit');
            serverCall('PurchaseOrderApproval.aspx/GetPurchaseOrderDetails', { purchaseOrderNumber: purchaseOrderNumber }, function (response) {
                responseData = JSON.parse(response);
                    var parseHTML = $('#template_PurchaseOrderDetails').parseTemplate(responseData);
                    divPurchaseOrderEdit.find('.modal-body .row .col-md-24').html(parseHTML);
                    divPurchaseOrderEdit.showModel();
            });
        }



        var getPurchaseOrderEditDetails = function (callback) {
            var purchaseOrderDetails = [];
            var divPurchaseOrderEdit = $('#divPurchaseOrderEdit');
            divPurchaseOrderEdit.find('table tbody tr').each(function (i, e) {
                var data = JSON.parse($(this).find('.tdData').text());
                var quantity = Number($(this).find('#txtApprovedQty').val());

                purchaseOrderDetails.push({
                    purchaseOrderDetailsID: data.PurchaseOrderDetailID,
                    quantity: quantity,
                    purchaseOrderNo: data.PurchaseOrderNo
                });
            });

            callback(purchaseOrderDetails);

        }


        var updatePurchaseOrder = function () {
            getPurchaseOrderEditDetails(function (data) {
                serverCall('PurchaseOrderApproval.aspx/UpdatePurchaseOrder', { purchaseOrderDetails: data }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.message, function () {
                        var divPurchaseOrderEdit = $('#divPurchaseOrderEdit');
                        divPurchaseOrderEdit.hide();
                    });
                });
            });
        }



        var cancelPurchaseOrderItem = function (el) {

            var data = JSON.parse($(el).closest('tr').find('.tdData').text());
            $('#spnPONo').text(data.PurchaseOrderNo);
            $('#spnItemid').text(data.ItemID);
            $('#spnPODetailID').text(data.PurchaseOrderDetailID);

            $('#divPOItemwiseRemarks').showModel();
           

            
           

        }


        function $Savepoitemesrejectremarks()
        {
            if ($('#txtDefaultremarks').val() == '') {
                modelAlert('Enter Remarks');
                return;
            }
            data = {
                purchaseOrderDetailID: $('#spnPODetailID').text(),
                PONo: $('#spnPONo').text(),
                itemID: $('#spnItemid').text(),
                Remarks: $('#txtDefaultremarks').val()
            }
            serverCall('PurchaseOrderApproval.aspx/CancelPurchaseOrderItem', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.message, function () {
                    $('#divPOItemwiseRemarks').hideModel();
                    bindPurchaseOrderItemDetails($('#spnPONo').text());
                });
            });

        }




    </script>
    <div id="divPOItemwiseRemarks" class="modal fade" >
        <div class="modal-dialog">
            <div class="modal-content" style="width:350px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divPOItemwiseRemarks" aria-hidden="true">×</button>
                    <h4 class="modal-title">Remarks</h4>
                    <span id="spnItemid" style="display:none"></span>
                    <span id="spnPONo" style="display:none"></span>
                    <span id="spnPODetailID" style="display:none"></span>
                </div>
                <div class="modal-body">
                     <div class="row">
                        <div class="col-md-10">
                                    <label class="pull-left">Remarks </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-14">
                                    <input type="text" autocomplete="off" onlytext="30" id="txtDefaultremarks" class="form-control ItDoseTextinputText requiredField"  />
                                </div>
                      </div>
                </div>
                  <div class="modal-footer">
                            <button type="button" onclick="$Savepoitemesrejectremarks()" id="btnSavedefaultremarks" value="Save">Save</button>
                            <button type="button" data-dismiss="divPOItemwiseRemarks">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

