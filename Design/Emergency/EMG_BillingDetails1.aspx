<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EMG_BillingDetails1.aspx.cs" Inherits="Design_Emergency_EMG_BillingDetails1" %>



<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/MarcTooltips.js"></script>
    <link href="../../Styles/MarcTooltips.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    
</head>
<body>
    <script type="text/javascript">
        shortcut.add('Alt+S', function () {
            var btnSave = $('#btnUpdateBilling');
            if (btnSave.length > 0) {
                if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                    $UpdateBillDetails(btnSave[0]);
                }
            }
        }, addShortCutOptions);
    </script>
    <form id="form1" runat="server">
      <Ajax:ScriptManager ID="sc" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true"></Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Change Doctor</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row" style="display:none;">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    <b>Bill No.</b>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="padding:0;">
                                <span id="spnBillNo" style="color: #d01515; font-weight: bold;"></span>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    <b>Bill Date</b>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <span id="spnBillDate" style="color: #d01515; font-weight: bold;"></span>
                            </div>
                            <div class="col-md-4 BillInfo">
                                <label class="pull-left">
                                    <b>Gross Amount</b>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 BillInfo">
                                <span id="spnGrossAmt" style="color: #d01515; font-weight: bold;">0</span>
                            </div>
                        </div>
                        <div class="row BillInfo">

                            <div class="col-md-4">
                                <label class="pull-left">
                                    <b>Disc. Amount</b>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <span id="spnDiscAmt" style="color: #d01515; font-weight: bold;">0</span>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                   <b>Round Off</b>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <span id="spnRoundOff" style="color: #d01515; font-weight: bold;">0</span>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    <b>Net Bill Amount</b>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <span id="spnNetAmt" style="color: #d01515; font-weight: bold;">0</span>
                            </div>
                        </div>
                        <div class="row">
                              <div class="col-md-4">
                              <input type="button" id="btnUpdateTraging" value="Update Triaging" style="width:100px;margin-top:7px;"  onclick="$UpdateTriaging(this)" />
                              </div>
                            <div class="col-md-4" style="display:none;">
                                <input type="button" id="btnCloseBill" value="Close Patient Without Bill" style="width:150px;margin-top:7px;" onclick="$closePatient(this, 1)" />
                            </div>
                             <div class="col-md-4">
                                <input type="button" id="btnPrimaryDoctorChange" value="Primary Doctor Changes" style="width:150px;margin-top:7px;" onclick="$ParimaryDoctorChange(this)" />
                            </div>
                            <div class="col-md-4">
                                <input type="button" id="btnMedicresidence" value="Medic/Resident Doctor" style="width:150px;margin-top:7px;" onclick="$MedicresidenceDoctor(this)" />
                            </div>
                        </div>
                    </div>

                </div>
            </div>
          
            <div class="POuter_Box_Inventory" id="showItemDetails" style="display:none;">
                <div class="row">
                    <div class="col-md-24" id="divBillItemDetails" style="max-height:400px; overflow:auto;">
                        </div>
                    </div>
                  <div class="POuter_Box_Inventory divDiscountReason" style="display:none">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Discount Reason</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <select id="ddlDiscountReason" class="required" ></select>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Approve By</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <select id="ddlDiscountApproveBy"  class="required"></select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                <div class="row" style="text-align:center;">
                  
                    <input type="button" id="btnUpdateBilling" value="Update Billing" style="display:none; width:100px;margin-top:7px;"  onclick="$UpdateBillDetails(this)" />&nbsp;
                    <input type="button" id="btnRelease" value="Release from Emergency" style="display:none; width:150px;margin-top:7px;" onclick="$ReleasePatient(this, 0)" />&nbsp;
                    <input type="button" id="btnCloseBilling" value="Close Billing" style="display:none; width:100px;margin-top:7px;" onclick="$CloseBilling(this)" />
                    <input type="button" id="btnPrintBill" value="Print Bill" style="width:100px;margin-top:7px;" onclick="$PrintBill(this)" />
                    </div>
            </div>
        </div>
        
 <div id="divRejectItem"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:450px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divRejectItem" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Reject Item</h4>
                    <span id="spnRejectLTID" style="display:none;"></span>
                    <span id="spnTypeofTnx" style="display:none;"></span>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">Reject Reason</label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="50" id="txtRejectReason" class="requiredField" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$RejectSave()">Reject</button>
						 <button type="button"  data-dismiss="divRejectItem" >Close</button>
				</div>
			</div>
		</div>
	</div>

         <div id="divRelease"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:750px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divRelease" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Release Patient</h4>
                    <span id="spnTransactionID" style="display:none;"></span>
                    

				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-5">
							   <label class="pull-left">Release Type</label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-7">
							<asp:DropDownList ID="ddlReleaseType" runat="server" ClientIDMode="Static" CssClass="requiredField" onchange="Discharge();"></asp:DropDownList>
                             <span id="spnisclose" style="display:none">0</span>
						 </div>
                          <div class="col-md-5">
                              <label class="pull-left">Reason</label>
							   <b class="pull-right">:</b>
                          </div>
                          <div class="col-md-7">
                              <input type="text" id="txtreasonwithoutbill" />
                          </div>
					  </div>
                    <div id="divDeath" style="display:none;">
                    <div class="row">
                        <div class="col-md-5">
                             <label class="pull-left">Date of Death</label>
							   <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-7">
                        <asp:TextBox ID="txtDeathofDate" runat="server" ToolTip="Select Date of Death"  ClientIDMode="Static" ></asp:TextBox>
                           
                        <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDeathofDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                         </div>
                         <div class="col-md-5">
                              <label class="pull-left">Time of Death</label>
							   <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-7">
                               <asp:TextBox ID="txtTime" runat="server" ClientIDMode="Static" ToolTip="Enter Time"></asp:TextBox>
                           
                         <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime" Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                         </div>
                        </div>
                       <div class="row">
                        <div class="col-md-5">
                             <label class="pull-left">Cause of Death</label>
							   <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-7">
                             <input type="text" id="txtCause" class="requiredField" />
                         </div>
                         <div class="col-md-5">
                              <label class="pull-left">Remarks</label>
							   <b class="pull-right">:</b>
                         </div>
                        
                         <div class="col-md-7">
                              <input type="text" id="txtRemarks" />
                         </div>
                        </div>
                    <div class="row">
                        <div class="col-md-5">
                             <label class="pull-left">Type of Death</label>
							   <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-7">
                               <asp:DropDownList ID="ddltypeOfDeath" runat="server" ToolTip="Select Type Of Death" ClientIDMode="Static" CssClass="requiredField"></asp:DropDownList>
                         </div>
                         <div class="col-md-5"></div>
                         <div class="col-md-7">
                             <input type="checkbox" id="chkDeathover48hrs" /> Death Over 48hrs
                         </div>
                        </div>
</div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$SaveReleasePatient()">Release</button>
						 <button type="button"  data-dismiss="divRelease" >Close</button>
				</div>
			</div>
		</div>
	</div>
         <div id="divtriagingCodes"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:450px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divtriagingCodes" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Triaging Code</h4>
                    <span id="Span1" style="display:none;"></span>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">Triaging Codes</label>
                        <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							<select id="ddlTriaging" title="Select Triaging Codes."></select>
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$TriagingSave()">Save</button>
						 <button type="button"  data-dismiss="divtriagingCodes" >Close</button>
				</div>
			</div>
		</div>
	</div>
        <div id="divPrimaryDoctorChange"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:450px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divPrimaryDoctorChange" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Doctor Name</h4>
                    <span id="Span2" style="display:none;"></span>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">Primary Doctor Change</label>
                        <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							<select id="ddlDoctor" title="Select Doctor "></select>
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$PrimaryDoctorchange()">Save</button>
						 <button type="button"  data-dismiss="divPrimaryDoctorChange" >Close</button>
				</div>
			</div>
		</div>
	</div>
    <div id="divMedicResidenceDoctor"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:450px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divMedicResidenceDoctor" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Doctor Name</h4>
                    <span id="Span3" style="display:none;"></span>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-11">
							   <label class="pull-left">Medic/Residence Doctor</label>
                            <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-13">
							<select id="ddlMedicResidenceDoctor" title="Select Doctor "></select>
						 </div>
					  </div>
				</div>
				<div class="modal-footer">
						 <button type="button"  onclick="$MedicResidenceDoctorChange()">Save</button>
						 <button type="button"  data-dismiss="divMedicResidenceDoctor" >Close</button>
				</div>
			</div>
		</div>
	</div>

    </form>
</body>
    <script id="tb_ItemDetails" type="text/html">
	<table  id="tableitemdetails" cellspacing="0" class="GridViewStyle" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr class="tblTitle" id="Header">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none;" >
                <input type="checkbox" id="cbAll" onclick="$checkAll();" class="EditElement" />
			</th>
            <th class="GridViewHeaderStyle" scope="col" >Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Category</th>
			<th class="GridViewHeaderStyle" scope="col" >Sub Category</th>           
			<th class="GridViewHeaderStyle" scope="col" >Item</th>    
            <th class="GridViewHeaderStyle" scope="col" >Doctor Name</th>      
			<th class="GridViewHeaderStyle" scope="col"  style="display:none;"  >Rate<br />
                <input type="text" id="txtRateAll"  onlynumber="10" decimalplace="2" style="width:80px;height:18px;display:none;" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$updateRateAll(this)" class="BillInfo" />
			</th>         
			<th class="GridViewHeaderStyle" scope="col"  style="display:none;"  >QTY</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none;"  >Disc(%)<br />
                <input type="text" id="txtDiscPerAll"  onlynumber="10" max-value="100" decimalplace="2" style="width:80px;height:18px;display:none;" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$updateDiscAll(this)" class="BillInfo"  />
			</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;"  >Disc Amt</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none;"  >Amount</th> 
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >Reject</th>
		</tr>
			</thead>
		<tbody>
		<#     
			  var dataLength=Data.length;
				var objRow;
	   for(var j=0;j<dataLength;j++)
		{
		objRow = Data[j];
		#>
		<tr id="<#=objRow.ID#>">
						<td class="GridViewLabItemStyle" id="tdSNo"  style="text-align:center"><#=j+1#>
                           
						</td> 
            <td class="GridViewLabItemStyle"  style="display:none;" >
                 <input type="checkbox" id="cbCheckItem" onclick="$openRowElemenst(this)" class="EditElement" /> 
            </td>
                        <td class="GridViewLabItemStyle"><#=objRow.EntryDate#></td>
						<td class="GridViewLabItemStyle"><#=objRow.Category#></td>
						<td class="GridViewLabItemStyle"><#=objRow.Subcategory#></td>                       
						<td class="GridViewLabItemStyle"><#=objRow.Item#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.DoctorName#></td>                      
						<td class="GridViewLabItemStyle" style="display:none;" ><input type="text" id="txtRate" class="BillInfo" value="<#=objRow.Rate#>" onlynumber="10" decimalplace="2" style="width:80px;" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$updateRowAmount(this,0)" disabled /></td>    
                        <td class="GridViewLabItemStyle" style="display:none;" ><input type="text" id="txtQTY"  value="<#=objRow.Quantity#>" max-value="<#=objRow.MaxValue#>"  onlynumber="10" style="width:80px;" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$updateRowAmount(this,0)" disabled  /></td>    
                        <td class="GridViewLabItemStyle" style="display:none;" ><input type="text"  id="txtDiscPer" class="BillInfo" value="<#=objRow.DiscPer#>" max-value="100" onlynumber="10" decimalplace="2" style="width:80px;" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$updateRowAmount(this,0)" disabled  /></td>    
                        <td class="GridViewLabItemStyle" style="display:none;" ><input type="text"  id="txtDiscAmt" class="BillInfo" value="<#=objRow.DiscAmt#>"  onlynumber="10" decimalplace="2" style="width:80px;" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onkeyup="$updateRowAmount(this,1)" disabled  /></td>
                        <td class="GridViewLabItemStyle" style="display:none;" ><input type="text"  id="txtAmount" class="BillInfo" value="<#=objRow.Amount#>"  onlynumber="10" decimalplace="2" style="width:80px;" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" disabled /></td>                         
						<td class="GridViewLabItemStyle" id="tdLTDID" style="display:none;text-align:center;"><#=objRow.ID#></td>
                        <td class="GridViewLabItemStyle" id="tdtypeoftnx" style="display:none;text-align:center;"><#=objRow.TypeOfTnx#></td>
                        <td class="GridViewLabItemStyle tdData"  style="display:none;text-align:center;"><#= JSON.stringify(objRow) #></td>
                          <td class="GridViewLabItemStyle" id="tdConfigID" style="display:none;text-align:center;"><#=objRow.ConfigID#></td>
                        <td class="GridViewLabItemStyle" id="tddelete" style="display:none; text-align:center;">
                            <#if(objRow.ConfigID !=11){ #>
                                    <img class="btn RejectElement" alt="" src="../../Images/Delete.gif" onclick="$removeLabItems(this)"/>
                            <#}#>
						</td>                       
			           </tr>            
		<#}        
		#>
			</tbody>      
	 </table> 
   </script>
    <script type="text/javascript">
        function bindTriagingCodes() {
            var ddlTriaging = $('#ddlTriaging');
            serverCall('Services/EmergencyAdmission.asmx/GetTriagingCodes', {}, function (response) {
                var responseData = JSON.parse(response);
                ddlTriaging.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'ID', isSearchAble: true });
            });
        }
        function bindDoctor() {
            var centreID = '<%=Util.GetString(Session["CentreID"])%>';
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorCentrewise', { CentreID: centreID }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
            });
        }

        function bindMedicResidanceDoctor() {
            var centreID = '<%=Util.GetString(Session["CentreID"])%>';
            var $ddlMedicResidenceDoctor = $('#ddlMedicResidenceDoctor');
            // serverCall('../common/CommonService.asmx/bindMedicResidanceCentrewise', { CentreID: centreID }, function (response) {
            serverCall('Services/EmergencyAdmission.asmx/bindMedicResidanceCentrewise', { CentreID: centreID }, function (response) {
                $ddlMedicResidenceDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
            });
        }

        function $TriagingSave() {
            var ddlTriaging = $('#ddlTriaging');
            if ($(ddlTriaging).val() == 0) {
                modelAlert('Please Select the Triaging Code', function () {
                    $(ddlTriaging).focus();
                });
                return;
            }
            else {
                serverCall('Services/EmergencyAdmission.asmx/SaveTriaging', { Triaging: $(ddlTriaging).val(), TID: EmergencyPatientDetails.TID }, function (response) {
                    var responseData = JSON.parse(response);
                    $('#divtriagingCodes').hideModel();
                    modelAlert(responseData.response, function () { });
                });
            }
        }

        function $PrimaryDoctorchange() {
            var ddlDoctor = $('#ddlDoctor');
            if ($(ddlDoctor).val() == 0) {
                modelAlert('Please Select the DoctorName', function () {
                    $(ddlDoctor).focus();
                });
                return;
            }
            else {
                serverCall('Services/EmergencyAdmission.asmx/SavePrimaryDoctor', { DoctorID: $(ddlDoctor).val(), TID: EmergencyPatientDetails.TID }, function (response) {
                    var responseData = JSON.parse(response);
                    $('#divPrimaryDoctorChange').hideModel();
                    modelAlert(responseData.response, function () { });
                });
            }
        }

        function $MedicResidenceDoctorChange() {
            var $ddlMedicResidenceDoctor = $('#ddlMedicResidenceDoctor');
            if ($(ddlMedicResidenceDoctor).val() == 0) {
                modelAlert('Please Select the DoctorName', function () {
                    $(ddlMedicResidenceDoctor).focus();
                });
                return;
            }
            else {
                serverCall('Services/EmergencyAdmission.asmx/SaveMedicResidenceDoctor', { DoctorID: $(ddlMedicResidenceDoctor).val(), TID: EmergencyPatientDetails.TID }, function (response) {
                    var responseData = JSON.parse(response);
                    $('#divMedicResidenceDoctor').hideModel();
                    modelAlert(responseData.response, function () { });
                });
            }
        }

        $UpdateTriaging = function (sender) {
            $('#divtriagingCodes').hideModel();
            bindTriagingCodes();
            $('#ddlTriaging').val(0);
            $('#divtriagingCodes').showModel();
        }
        $ParimaryDoctorChange = function (sender) {
            $('#divPrimaryDoctorChange').hideModel();
            bindDoctor();
            $('#ddlTriaging').val(0);
            $('#divPrimaryDoctorChange').showModel();
        }

        $MedicresidenceDoctor = function (sender) {
            $('#divMedicResidenceDoctor').hideModel();
            bindMedicResidanceDoctor();
            $('#ddlTriaging').val(0);
            $('#divMedicResidenceDoctor').showModel();
        }


        var EmergencyPatientDetails = [];
        var UserRights = [];
        $(document).ready(function () {
            $bindUserRights(function () {
                $loadPatientDetails(function () {
                    $bindStatus(function () {
                        $bindPatientBillItems(function () {
                            $bindPatientFinalBillAmounts(function () {
                                $bindbillclosingcon(function () {
                                    if (UserRights.CanEditCloseEMGBilling == "0") {
                                        if (UserRights.CanViewRatesEMGBilling == 0)
                                            $('.BillInfo').hide();
                                        if (UserRights.CanEditEMGBilling == 0)
                                            $('.EditElement,#btnUpdateBilling').attr('disabled', 'disabled');
                                        if (UserRights.CanRejectEMGBilling == 0)
                                            $('.RejectElement').hide();
                                        if (UserRights.CanReleaseEMGPatient == 0)
                                            $('#btnRelease').attr('disabled', 'disabled');
                                        if (UserRights.CanCloseEMGBilling == 0)
                                            $('#btnCloseBilling').attr('disabled', 'disabled');
                                    }
                                    else {
                                        $('.BillInfo,.RejectElement').show();
                                        $('.EditElement,#btnUpdateBilling').removeAttr('disabled');
                                    }
                                });
                            });
                        });
                    });
                });
            });
        });
        $loadPatientDetails = function (callback) {
            $EMGNo = '<%=Request.QueryString["EMGNo"].ToString()%>';
            serverCall('../Emergency/Services/EmergencyBilling.asmx/getEmergencyPatientDetails', { EmergencyNo: $EMGNo }, function (response) {
                if (jQuery.parseJSON(response) == null)
                    location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Shifted To IPD.'
                else {
                    EmergencyPatientDetails = jQuery.parseJSON(response)[0];
                    if (EmergencyPatientDetails.Status == "RFI")
                        location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released for IPD.';
                    else
                        callback(true);
                }
            });
        }

        $bindUserRights = function (callback) {
            serverCall('Services/EmergencyBilling.asmx/getEmergencyUserRights', {}, function (response) {
                UserRights = jQuery.parseJSON(response)[0];
                callback(true);
            });
        }
        $bindbillclosingcon = function (callback) {
            serverCall('Services/EmergencyBilling.asmx/getBillCloseRights', { TID: EmergencyPatientDetails.TID }, function (response) {
                //if(response == 0)
                // $('#btnCloseBilling').attr('disabled', 'disabled');
                callback(true);
            });
        }
        $bindPatientFinalBillAmounts = function (callback) {
            $('#spnBillNo').text(EmergencyPatientDetails.BillNo);
            $('#spnBillDate').text(EmergencyPatientDetails.BillDate);
            $('#spnGrossAmt').text(Number(EmergencyPatientDetails.GrossAmount).toFixed(2));
            $('#spnDiscAmt').text(Number(EmergencyPatientDetails.DiscountOnTotal).toFixed(2));
            $('#spnRoundOff').text(Number(EmergencyPatientDetails.RoundOff).toFixed(2));
            $('#spnNetAmt').text(Number(EmergencyPatientDetails.NetAmount).toFixed(2));
            if (Number(EmergencyPatientDetails.GrossAmount).toFixed(2) > 0)
                $('#btnCloseBill').attr("disabled", "disabled");
            else
                $('#btnCloseBill').removeAttr("disabled");
            callback(true);

        }
        $bindPatientBillItems = function (callback) {
            serverCall('Services/EmergencyBilling.asmx/getEmergencyBillItemDetails', { LTnxNo: EmergencyPatientDetails.LTnxNo }, function (response) {

                if (response != '') {
                    Data = JSON.parse(response);
                    var output = $('#tb_ItemDetails').parseTemplate(Data);
                    $('#divBillItemDetails').html(output);
                    $('#showItemDetails').show();
                }
                else {
                    $('#divBillItemDetails').html('');
                    $('#showItemDetails').hide();

                }
                callback(true);
            });
        }
        $bindStatus = function (callback) {
            if (EmergencyPatientDetails.BillNo != "") {
                $('#btnCloseBilling,#btnUpdateBilling').attr('disabled', 'disabled');
                if (EmergencyPatientDetails.Status == "OUT")
                    $('#btnRelease').attr('disabled', 'disabled');
            }
            else {
                $('#btnRelease').attr('disabled', 'disabled');

            }
            callback(true);
        }
    </script>
    <script type="text/javascript">

        $checkAll = function () {
            if ($('#cbAll').prop('checked'))
                $('[id$=cbCheckItem]').prop('checked', true);
            else
                $('[id$=cbCheckItem]').prop('checked', false);
            $('#tableitemdetails tbody tr').each(function () {
                $openRowElemenst($(this).find('#cbCheckItem'));
            });
        }
        $updateDiscAll = function (sender) {
            if ($(sender).val() == '')
                return false;
            $('#tableitemdetails tbody tr').each(function () {
                if ($(this).find('#cbCheckItem').prop('checked')) {

                    var data = JSON.parse($(this).find('.tdData').text());
                    if (Number((data.ConfigID) != 11)) {
                        $(this).find('#txtDiscPer').val($(sender).val());
                        $updateRowAmount($(this).find('#txtDiscPer'), 0);
                    }
                }
            });
        }
        $updateRateAll = function (sender) {
            if ($(sender).val() == '')
                return false;
            $('#tableitemdetails tbody tr').each(function () {
                if ($(this).find('#cbCheckItem').prop('checked')) {

                    var data = JSON.parse($(this).find('.tdData').text());
                    if (Number((data.ConfigID) != 11)) {
                        $(this).find('#txtRate').val($(sender).val());
                        $updateRowAmount($(this).find('#txtRate'), 0);
                    }
                }
            });

        }
        $updateRowAmount = function (sender, $IsDiscInAmt) {
            if ($(sender).closest('tr').find('#txtQTY').val() == '')
                $(sender).closest('tr').find('#txtQTY').val('1');

            if (Number($(sender).closest('tr').find('#txtQTY').val()) == 0)
                $(sender).closest('tr').find('#txtQTY').val('1');

            $('#lblMsg').text('');
            if ($(sender).val() == '')
                $(sender).val('0');
            $Rate = Number($(sender).closest('tr').find('#txtRate').val()).toFixed(2);
            $QTY = Number($(sender).closest('tr').find('#txtQTY').val()).toFixed(0);
            $DiscPer = 0;
            $DiscAmt = 0;
            $NetAmount = 0;
            $GrossAmt = $Rate * $QTY;
            if ($IsDiscInAmt == 0) {
                $DiscPer = Number($(sender).closest('tr').find('#txtDiscPer').val()).toFixed(2);
                $DiscAmt = Number(($Rate * $QTY * $DiscPer) / 100).toFixed(2);
                $(sender).closest('tr').find('#txtDiscAmt').val($DiscAmt)
            }
            else {
                $DiscAmt = Number($(sender).closest('tr').find('#txtDiscAmt').val()).toFixed(2);
                if ($GrossAmt < $DiscAmt) {
                    $DiscAmt = 0;
                    $('#lblMsg').text('Discount Amount Cannot be Greater than Gross Amount');
                }
                $DiscPer = Number(($DiscAmt / $GrossAmt) * 100).toFixed(4);
                $(sender).closest('tr').find('#txtDiscPer').val($DiscPer);
            }
            if ($DiscPer > 0 || $DiscAmt > 0) {
                $('.divDiscountReason').find('select').val('0');
                $('.divDiscountReason').show()
            }
            else {
                $('.divDiscountReason').find('select').val('0');
                $('.divDiscountReason').hide();
            }
            $NetAmount = $GrossAmt - $DiscAmt;
            $(sender).closest('tr').find('#txtAmount').val($NetAmount);

        }
        $openRowElemenst = function (sender) {
            if ($(sender).prop('checked')) {
                var data = JSON.parse($(sender).closest('tr').find('.tdData').text());
                if (Number(data.ConfigID) != 11) {
                    $(sender).closest('tr').find('#txtRate,#txtQTY,#txtDiscPer,#txtDiscAmt').removeAttr('disabled');
                }
            }
            else
                $(sender).closest('tr').find('#txtRate,#txtQTY,#txtDiscPer,#txtDiscAmt').attr('disabled', 'disabled');


        }
        $removeLabItems = function (sender) {
            $LTDID = $(sender).closest('tr').find('#tdLTDID').text();
            $TypeofTnx = $(sender).closest('tr').find('#tdtypeoftnx').text();
            configID = $(sender).closest('tr').find('#tdConfigID').text();
            $('#spnTypeofTnx').text('');
            $('#spnRejectLTID').text('');
            $('#spnTypeofTnx').text($TypeofTnx);
            $('#spnRejectLTID').text($LTDID);
            $('#txtRejectReason').val('');
            if (configID == '3') {
                serverCall('Services/EmergencyBilling.asmx/checkSampleCollected', { ltdID: $LTDID, configID: configID }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.response) {
                        modelAlert(responseData.response);
                    } else
                        $('#divRejectItem').showModel();

                });
            } else {
                $('#divRejectItem').showModel();
            }

        }
        $RejectSave = function () {
            if ($('#txtRejectReason').val() == '') {
                modelAlert('Please Enter Reject Reason', function () {
                    $('#txtRejectReason').focus();
                });
                return false;
            }
            serverCall('Services/EmergencyBilling.asmx/rejectEmergencyItem', { LtdId: $('#spnRejectLTID').text(), LedgerTnxNo: EmergencyPatientDetails.LTnxNo, Reason: $.trim($('#txtRejectReason').val()), TypeofTnx: $('#spnTypeofTnx').text() }, function (response) {
                var $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    if ($responseData.status) {
                        $loadPatientDetails(function () {
                            $('#tableitemdetails tbody').find('#' + $('#spnRejectLTID').text()).remove();
                            $('#divRejectItem').hide();
                            $bindPatientFinalBillAmounts(function () { });
                            if ($('#tableitemdetails tbody tr').length == 0) {
                                $('#divBillItemDetails').html('');
                                $('#showItemDetails').hide();
                            }
                        });
                    }

                });

            });

        }
        $UpdateBillDetails = function (btn) {
            $LTD = [];
            DiscountReason = 0;
            DIscountApproved = 0;
            $('#tableitemdetails tbody tr').each(function () {
                if ($(this).find('#cbCheckItem').prop('checked')) {

                    if (Number($(this).find('#txtDiscPer').val().trim()) > 0) {
                        if ($('#ddlDiscountReason').val() == "0") {
                            DiscountReason += 1;
                        }
                        if ($('#ddlDiscountApproveBy').val() == "0") {
                            DIscountApproved += 1
                        }
                    }
                    $LTD.push({
                        LedgerTransactionNo: EmergencyPatientDetails.LTnxNo,
                        ID: $(this).find('#tdLTDID').text(),
                        Rate: Number($(this).find('#txtRate').val().trim()),
                        Quantity: Number($(this).find('#txtQTY').val().trim()),
                        DiscountPercentage: Number($(this).find('#txtDiscPer').val().trim()),
                        DiscAmt: Number($(this).find('#txtDiscAmt').val().trim()),
                        Amount: Number($(this).find('#txtAmount').val().trim()),
                        DiscountApproveBy: $.trim($('#ddlDiscountApproveBy option:selected').text()),
                        DiscountReason: $.trim($('#ddlDiscountReason option:selected').text())
                    });
                }

            });
            if (DiscountReason > 0) {
                modelAlert('Please Select Discount Reason.', function () {
                    $('#ddlDiscountReason').focus();
                });
                return false;
            }
            if (DIscountApproved > 0) {
                modelAlert('Please Select Approve By.', function () {
                    $('#ddlDiscountApproveBy').focus();
                });
                return false;
            }
            if ($LTD.length == 0) {
                modelAlert('Please Select Any Item to Update');
                return false;
            }
            $(btn).attr('disabled', 'disabled');
            serverCall('Services/EmergencyBilling.asmx/updateBillItems', { LTD: $LTD }, function (response) {
                var $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    if ($responseData.status)
                        location.reload();
                    else
                        $(btn).removeAttr('disabled');
                });
            });


        }

        $ReleasePatient = function (sender) {
            $('#spnisclose').text('0');
            $('#divRelease #divDeath').hide();
            $('#divRelease #ddlReleaseType').val('SELECT');
            //$('#txtreasonwithoutbill').val('').removeClass('required').attr('disabled', 'disabled');
            $('#divRelease').showModel();
        }
        $closePatient = function (sender) {
            $('#divRelease #divDeath').hide();
            $('#txtreasonwithoutbill').val('').removeAttr('disabled').addClass('required').focus();
            $('#divRelease #ddlReleaseType').val('Patient Discharge Without Bill').attr('disabled', 'disabled');
            $('#spnisclose').text('1').hide();
            $('#divRelease').showModel();
        }

        $SaveReleasePatient = function () {
            var DathOver48hr = 0, IsDeath = 0;
            if ($('#ddlReleaseType option:selected').val().toUpperCase() == "SELECT") {
                modelAlert('Please Select Release Type');
                return false;
            }

            if ($('#ddlReleaseType option:selected').val().toUpperCase() == "DEATH")
                IsDeath = 1;

            if ($('#ddltypeOfDeath option:selected').val() == "0" && IsDeath == "1") {
                modelAlert('Please Select Death Type');
                return false;
            }

            if ($('#txtCause').val().trim() == "" && IsDeath == "1") {
                modelAlert('Please Enter Cause Of Death');
                return false;
            }

            if ($('#chkDeathover48hrs').is(":checked"))
                DathOver48hr = 1;
            var msg = "Do You Want To Release Patient from Emergency ?";
            var IsWithoutBill = 0;
            if ($('#spnisclose').text() == "1") {
                IsWithoutBill = 1;
                msg = "Do You Want To Release Patient from Emergency Without Bill ?";
                if ($('#txtreasonwithoutbill').val().length <= 5) {
                    modelAlert("Please Enter Reason More Than 5 Characters.");
                    return;
                }
            }
            modelConfirmation('Alert!!!', msg, 'Release', 'Close', function (response) {
                if (response) {
                    serverCall('Services/EmergencyBilling.asmx/RelaseEmergencyPatient', { TID: EmergencyPatientDetails.TID, IsDeath: IsDeath, ReleaseType: $('#ddlReleaseType option:selected').val(), DeathDate: $('#txtDeathofDate').val(), DeathTime: $('#txtTime').val(), DeathCause: $('#txtCause').val(), Remarks: $('#txtRemarks').val(), DeathType: $('#ddltypeOfDeath option:selected').val(), DathOver48hr: DathOver48hr, ReleasedReason: $('#txtreasonwithoutbill').val(), IsWithoutBill: IsWithoutBill }, function (response) {
                        var $responseData = JSON.parse(response);
                        modelAlert($responseData.response, function () {
                            if ($responseData.status)
                                location.reload();
                        });
                    });
                }
            });
        }
        $CloseBilling = function (btn) {
            $isValid = 1;

            serverCall('Services/EmergencyBilling.asmx/checkZeroRateItems', { LTnxNo: EmergencyPatientDetails.LTnxNo }, function (response) {
                if (response > 0) {
                    modelAlert('Zero Rate Items are not allowed');
                    return false;
                }
                else {
                    modelConfirmation('Alert!!!', 'Do You Want To Generate Bill ?', 'Generate', 'Close', function (response) {
                        if (response) {
                            serverCall('Services/EmergencyBilling.asmx/GenerateEmergencyBill', { LTnxNo: EmergencyPatientDetails.LTnxNo, PID: EmergencyPatientDetails.PatientID, TID: EmergencyPatientDetails.TID, RoomId: EmergencyPatientDetails.RoomId, PanelID: EmergencyPatientDetails.PanelID }, function (response) {
                                var $responseData = JSON.parse(response);
                                modelAlert($responseData.response, function () {
                                    if ($responseData.status) {
                                        modelConfirmation('Alert!!!', 'Do You Want To go for Settelment ?', 'Yes', 'No', function (response) {
                                            if (response)
                                                window.open('../OPD/OPDFinalSettlementNew.aspx');
                                            location.reload();
                                        });
                                    }
                                });
                            });
                        }
                    });



                }


            });



        }
        $PrintBill = function (btn) {
            window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + EmergencyPatientDetails.LTnxNo + '&IsBill=0&Duplicate=1&Type=OPD');
        }
        function Discharge() {
            if ($('#ddlReleaseType option:selected').val().toUpperCase() == "DEATH") {
                $('#divDeath').show();
            }
            else {
                $('#divDeath').hide();
            }
        }
        var bindApprovedMaster = function (callback) {


            var divDiscountReason = $('.divDiscountReason');

            serverCall('../EDP/Services/EDP.asmx/bindDisAppoval', { ApprovalType: '', Type: '1' }, function (response) {
                if (String.isNullOrEmpty(response))
                    response = '[]';

                var discountApprovalMaster = JSON.parse(response);
                var ddlDiscountApproveBy = divDiscountReason.find('#ddlDiscountApproveBy');
                ddlDiscountApproveBy.bindDropDown({
                    data: discountApprovalMaster,
                    valueField: 'ApprovalType',
                    textField: 'ApprovalType',
                    defaultValue: '',
                    selectedValue: ''
                });
                callback(ddlDiscountApproveBy.val());

            });
        }


        var bindDiscReason = function (callback) {


            var divDiscountReason = $('.divDiscountReason');
            serverCall('../Common/CommonService.asmx/GetDiscReason', { Type: 'OPD' }, function (response) {
                var $ddlControlDiscountReason = divDiscountReason.find('#ddlDiscountReason');
                $ddlControlDiscountReason.bindDropDown({
                    defaultValue: '', selectedValue: '', data: JSON.parse(response), valueField: 'DiscountReason', textField: 'DiscountReason', isSearchAble: false
                });
                callback($ddlControlDiscountReason.find('option:selected').text());
            });
        }


        $(document).ready(function () {
            bindApprovedMaster(function () {
                bindDiscReason(function () { });
            });
        });
    </script>
</html>
