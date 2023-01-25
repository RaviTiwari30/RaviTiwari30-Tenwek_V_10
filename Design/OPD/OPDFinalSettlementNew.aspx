<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDFinalSettlementNew.aspx.cs" Inherits="Design_OPD_OPDFinalSettlementNew" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	<script type="text/javascript">
	    $searchOPDBills = function (callback) {
	        var x = document.getElementById("ddlCentre");
	        var optionVal = "";
	        for (i = 0; i < x.length; i++) {
	            if (optionVal == "")
	                optionVal = "'" + x.options[i].value + "'";
	            else
	                optionVal += ",'" + x.options[i].value + "'";
	        }
	        if (optionVal == "") {
	            modelAlert('Please select Centre');
	            return false;
	        }
	        $("#checkedPatientId").text("");
	        $("#lblPendingTotalAmt").text("");
	        var data = {
	            MRNo: $('#txtBarcode').val(),
	            panelID: $('#ddlPanel').val() == '0' ? '' : $('#ddlPanel').val(),
	            fromDate: $('#txtSearchFromDate').val(),
	            toDate: $('#txtSearchToDate').val(),
	            centreId: $('#ddlCentre').val(),
	            billNo: $("#txtBillNo").val(),
	            encounterno: $("#txtEncounterNo").val()
	        }
	        serverCall('OPDFinalSettlementNew.aspx/SearchOPDBills', data, function (response) {
	            if (!String.isNullOrEmpty(response)) {
	                billsDetails = JSON.parse(response);
	                var output = $('#templateBillsSearchDetails').parseTemplate(billsDetails);
	                $realeasePaymentControl(function () {
	                    $('#divBillDetailsDetails').html(output).customFixedHeader();
	                });
	            }
	            else {
	                $realeasePaymentControl(function () {
	                    $('#divBillDetailsDetails').html('');
	                    modelAlert('No Record Found', function () { });
	                });
	            }
	        });
	    }
	    $bindPanel = function (callBack) {
	        serverCall('OPDFinalSettlementNew.aspx/GetPanels', {}, function (response) {
	            var $ddlPanel = $('#ddlPanel');
	            $ddlPanel.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
	            callBack(true);
	        });
	    }
	    var centerid = '<%=Session["CentreID"].ToString()%>';
	    var $bindCentre = function () {
	        serverCall('OPDFinalSettlementNew.aspx/BindCentre', {}, function (response) {
	            Centre = $('#ddlCentre');
	            Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: centerid });
	        });
	    }

	    $loadPaymentControl = function (elem, callback) {
	        serverCall('../Controls/LoadUserControl.asmx/LoadControl', { userControlNames: ['UCPayment.ascx'], isControlHaveScriptManager: false }, function (response) {
	            $getHashCode(function (hashCode) {
	                var temp = '<span id="selectedRowObject" style="display:none"> </span><span style="display:none" id="spnHashCode"></span>';
	                billDetails = JSON.parse($(elem).closest('tr').attr('data'));
	                var output = $('#templatePatientDetails').parseTemplate(billDetails);
	                $('#divPaymentControl').html(output + response + temp).removeAttr('style');
	                $paymentControlInit(function () {
	                    $commonJsInit(function () {
	                        $('.payment').show();
	                        $('.billDetailsDiv').hide();
	                        $('#selectedRowObject').text(JSON.stringify(billDetails));
	                        $('#spnHashCode').text(hashCode);
	                        hideShowdivpendingamt(0);
	                        $addBillAmount({ panelId: billDetails.PanelID, billAmount: Math.abs(billDetails.PendingAmt), minimumPayableAmount: Math.abs(billDetails.PendingAmt), disableCredit: true, disableDiscount: true, disCountAmount: 0, isReceipt: true, patientAdvanceAmount: billDetails.AdvanceAmount, refund: { status: (billDetails.PendingAmt < 0 ? true : false) } }, function () { });
	                    });
	                });
	            });
	        });
	    }
	    $realeasePaymentControl = function (callback) {
	        $('#divPaymentDetails').html('');
	        $('.payment').hide();
	        $('.billDetailsDiv').show();
	        callback(true);
	    }
	    $getBillPaymentDetails = function (callback) {
	        var billDetails = JSON.parse($('#selectedRowObject').text());
	        var hashCode = $('#spnHashCode').text();
	        var invalidrefno = '0';
	        $getPaymentDetails(function (paymentDetails) {
	            
	            $PaymentDetail = [];
	            $(paymentDetails.paymentDetails).each(function () {
	                //alert(this.RefNo.length);
	                if ((this.PaymentMode == 'M-Pesa') && (this.RefNo.replace(/\s/g, '').length != 10 ))
	                {
	                    invalidrefno = '1';
	                }
	                $PaymentDetail.push({
	                    PaymentMode: this.PaymentMode,
	                    PaymentModeID: this.PaymentModeID,
	                    S_Amount: this.S_Amount,
	                    S_Currency: this.S_Currency,
	                    S_CountryID: this.S_CountryID,
	                    BankName: this.BankName,
	                    RefNo: this.RefNo,
	                    BaceCurrency: this.BaceCurrency,
	                    C_Factor: this.C_Factor,
	                    Amount: this.Amount,
	                    S_Notation: this.S_Notation,
	                    PaymentRemarks: paymentDetails.paymentRemarks,
	                    swipeMachine: this.swipeMachine,
	                    currencyRoundOff: paymentDetails.currencyRoundOff / paymentDetails.paymentDetails.length
	                });
	            });
	            $OPDDiscount = {
	                netAmount: paymentDetails.newAmount,
	                DiscountReason: paymentDetails.discountReason,
	                DiscountApproveBy: paymentDetails.approvedBY,
	                DiscountOnTotal: paymentDetails.discountAmount,
	                RoundOff: paymentDetails.roundOff,
	                Adjustment: paymentDetails.adjustment,
	                DiscAmt: paymentDetails.discountAmount,
	                DiscountPercentage: paymentDetails.discountPercent
	            }
	            $hashCode = hashCode;
	            $AmountPaid = paymentDetails.adjustment;
	            $PatientID = billDetails.PatientID;
	            $TransactionID = billDetails.TransactionID;
	            $LedgerTranNo = billDetails.LedgerTransactionNo;
	            $Naration = paymentDetails.paymentRemarks;
	            $PanelID = billDetails.PanelID;
	            $IsRefund = parseFloat(billDetails.PendingAmt) < 0 ? 1 : 0;
	            $netAmount = billDetails.NetAmount;
	            $advanceAmt = billDetails.AdvanceAmount;
	            $TypeOfTnx = billDetails.TypeOfTnx;
	            $feePaid = billDetails.FeesPaid;
	            $IsNewPatient = billDetails.IsNewPatient;
	            $centreId = Number(billDetails.CentreID);
	            
	            if (PartialPayment != 1 && billDetails.PendingAmt != paymentDetails.adjustment)
	            {
	                modelAlert(" You Are Not Allowed To Take Partial Payment"); return;
	            }
	            if (invalidrefno == '1') {
	                modelAlert("M-Pesa RefNo length should be equal to 10 or remove the sapce. ");
	                return;
	            }
	            callback({ PaymentDetail: $PaymentDetail, OPDDiscount: [$OPDDiscount], hashCode: $hashCode, AmountPaid: $AmountPaid, PatientID: $PatientID, TransactionID: $TransactionID, LedgerTranNo: $LedgerTranNo, Naration: $Naration, PanelID: $PanelID, IsRefund: $IsRefund, netAmount: $netAmount, advanceAmt: $advanceAmt, TypeOfTnx: $TypeOfTnx, feePaid: $feePaid, IsNewPatient: $IsNewPatient, centreId: $centreId }, billDetails);

	        });
	    }

	    $savePaymentDetails = function (btnSave) {

	        $getBillPaymentDetails(function (data, selectedBillDetails) {
	            $(btnSave).attr('disabled', true).val('Submitting...');
	            serverCall('OPDFinalSettlementNew.aspx/saveOPDSettlement', data, function (response) {
	                var $responseData = JSON.parse(response);
	                modelAlert($responseData.response, function () {
	                    if ($responseData.status) {
	                        $realeasePaymentControl(function () {
	                            $('#' + data.LedgerTranNo).remove();
	                            $(btnSave).removeAttr('disabled').val('Save');
	                            if (data.TypeOfTnx == 'OPD-Package') {
	                                if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
	                                    window.open('../common/OPDPackageReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0');
	                                else
	                                   // window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0&Type=OPD');
	                                    window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0&Type=OPD');
	                            }
	                            else if (data.TypeOfTnx == 'Pharmacy-Issue')
	                               // window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&Duplicate=0&Type=PHY');
	                                window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&Duplicate=0&Type=PHY');
	                            else if (data.TypeOfTnx == 'Pharmacy-Return')
	                                // window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&Duplicate=0&Type=PHY');
	                                window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&Duplicate=0&Type=PHY');
	                            else {
	                                if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
	                                    //window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&ReceiptNo=' + $responseData.Receipt_No + '&Duplicate=0');
	                                    window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0&Type=OPD');
	                                else
	                                    window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0&Type=OPD');
	                                    
	                                    //window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&ReceiptNo=' + $responseData.Receipt_No + '&Duplicate=0&Type=OPD');
	                            }
	                        });
	                    }
	                    else
	                        $(btnSave).removeAttr('disabled').val('Save');
	                });
	            });
	        });
	    }




	    var $getHashCode = function (callback) {
	        serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
	            callback(response);
	        });
	    }



	    $viewBillDetails = function (rowid) {
	        var LardgerTransactionNo = $(rowid).closest('tr').find('#tdLedgerTransactionNo').text();
	        var Customerid = $(rowid).closest('tr').find('#tdCustomerID').text();
	        var DeptLedgerNo = $(rowid).closest('tr').find('#tdDeptLedgerNo').text();
	        if ($(rowid).closest('tr').find('#tdTypeOfTnx').text() == "OPD-Package") {
	            if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
	                window.open('../common/OPDPackageReceipt.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&Duplicate=1');
	            else
	                //window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&Duplicate=1&Type=OPD');
	            window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&Duplicate=1&Type=OPD');
	        }
	        else if ($(rowid).closest('tr').find('#tdTypeOfTnx').text() == "Pharmacy-Issue")
	            //window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=0&Duplicate=0&Type=PHY');
	            window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=0&Duplicate=0&Type=PHY');
	        else if ($(rowid).closest('tr').find('#tdTypeOfTnx').text() == "Pharmacy-Return")
	            //window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=0&Duplicate=0&Type=PHY');
	            window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=0&Duplicate=0&Type=PHY');
	        else {
	            if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
	              //  window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=1');
	                window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=1');
	            else
	                window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=1&Type=OPD');
	               // window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=1&Type=OPD');
	        }
	    }

	    $(function () {
	        shortcut.add('Alt+S', function () {
	            var btnSave = $('#btnSavePayment');
	            if (btnSave.length > 0) {
	                if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
	                    $savePaymentDetails(btnSave[0]);
	                }
	            }
	        }, addShortCutOptions);
	    });




	    var PartialPayment = "";
	    $(document).ready(function () {
	        $('input[type=text]').keyup(function () {
	            if (event.keyCode == 13)
	                $searchOPDBills(function () { });
	        });
	        $bindPanel(function () {
	            $bindCentre();
	        });

	        bindIsallowpartilpayment();
	    });


	    var bindIsallowpartilpayment = function () {
	        serverCall('OPDFinalSettlementNew.aspx/bindIsallowpartilpayment', {}, function (response) {
	            var isPartialpayment = (response);
	            PartialPayment = isPartialpayment;
	        });
	    }

	</script>

	<cc1:ToolkitScriptManager runat="server" ID="scriptManager"></cc1:ToolkitScriptManager>
	<div id="Pbody_box_inventory">
		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>OPD Final Settlement</b>

            <label id="checkedPatientId" style="display:none"></label>
		   
		</div>
		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">Search Criteria</div>
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left"><b>Barcode/UHID </b></label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text"  autocomplete="off"  id="txtBarcode"/>
						   
						</div>
						 <div class="col-md-3">
							<label class="pull-left">Bill No. </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text"  autocomplete="off" id="txtMrNO" style="display:none;" />
						  <input type="text"  autocomplete="off" id="txtBillNo" />
						</div>
						 <div class="col-md-3">
							<label class="pull-left"> Panel  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <select id="ddlPanel" title="Select Panel" > </select>          
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">From Date  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
								<asp:TextBox ID="txtSearchFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select From Date" ></asp:TextBox>
							<cc1:CalendarExtender ID="calExdTxtSearchFromDate" TargetControlID="txtSearchFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">To Date </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							  <asp:TextBox ID="txtSearchToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select From Date" ></asp:TextBox>
							  <cc1:CalendarExtender ID="calExdSearchToDate" TargetControlID="txtSearchToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">Centre   </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
	                        <select id="ddlCentre" title="Select Centre" > </select>       
						</div>
					</div>
                    <div class="row">
						<div class="col-md-3">
							<label class="pull-left">Encounter No </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<input type="text"  autocomplete="off"  id="txtEncounterNo"/>
						   
						</div>
                        </div>
					<div class="row">
						<div class="col-md-8">
						 
						</div>
						<div style="text-align:center" class="col-md-8">
							 <input type="button" onclick="$searchOPDBills(function () { });" value="Search" />                        
						</div>
						<div class="col-md-4"><button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color: #a179ef;" class="circle"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Emergency Bills</b>
						</div>
                        <div class="col-md-4">
						 <input type="button" value="Settle Mult Bill" onclick="openMultiSettleModel()" />
						</div>
					</div>
                    <div class="row" id="divpendingamt" style="display:none">
                        <div class="col-md-5" >
						<b style="font-weight:bolder" >Pending Of Selected Bill :</b> 
                            </div>
                            <div class="col-md-2">
						  <label id="lblPendingTotalAmt" style="color:red;font-weight:bolder"></label>
						</div>
						
                    </div>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>
		<div class="POuter_Box_Inventory billDetailsDiv">
			<div class="row">
				<div  style="overflow:auto;max-height:410px" id="divBillDetailsDetails" class="col-md-24">

				</div>
			</div>
		</div>
		<div id="divPaymentControl"  class="payment">

		   
		</div>
		 <div style="display:none"  class="POuter_Box_Inventory payment">
				<div style="text-align:center" class="col-md-24">
				   <input type="button" id="btnSavePayment" class="ItDoseButton" style="width:100px;margin-top:7px"  value="Save" onclick="$savePaymentDetails(this, function () { });"  tabindex="35" />
				   <input type="button" id="btnCancelPayment" class="ItDoseButton" style="width:100px;margin-top:7px" onclick="$realeasePaymentControl(function () { })"  value="Back"  tabindex="35" />
				</div>
		 </div>
	</div>





	<script id="templateBillsSearchDetails" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdOPDBillsSettlement" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col"><%--<input type="checkbox" id="chkSelectAll" onclick="SelectAllCheckboxes(this)" />--%>Select</th>
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Panel Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Centre Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
            		<th class="GridViewHeaderStyle" scope="col" >Encounter No</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill Amount</th>
			<th class="GridViewHeaderStyle" scope="col" >Paid Amount</th>
			<th class="GridViewHeaderStyle" scope="col" >Pending Amount</th>  
            <th class="GridViewHeaderStyle" scope="col" >Type</th>          
			<th class="GridViewHeaderStyle" scope="col" style="max-width:140px;">Panel</th>
			<th class="GridViewHeaderStyle" scope="col" >Select</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">PanelID</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">NetAmtBeforeTax</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">LedgerTransactionNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">TransactionID</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">TypeOfTnx</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">CustomerID</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">DeptLesgerNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">Roundoff</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none">CentreID</th>
		</tr>
			</thead>
		<#
		var dataLength=billsDetails.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
	
		for(var j=0;j<dataLength;j++)
		{
		objRow = billsDetails[j];
		#>
					<tr  data='<#= JSON.stringify(objRow) #>' <#if(objRow.TypeOfTnx=="Emergency"){#> style="cursor:pointer;background-color:#a179ef;"<#} else{#>style="cursor:pointer;"<#}#>  id='<#=objRow.LedgerTransactionNo#>'>
					<#if(<#=objRow.SettlementType#>!="Refund")
                        {#>
                         <td class="GridViewLabItemStyle" id="tdCheckbox"><input type="checkbox" id="chkSelect" class="chkRow" value="<#=objRow.PatientID#>" onclick="onChekboxChecked(this)"/></td>
                        
                        <#} else {#>
                         <td class="GridViewLabItemStyle" id="td3"></td>
                       
                        
                        <#} #>
                       
                         <td class="GridViewLabItemStyle" id="tdSNo"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdCentreName"  style="text-align:left" ><#=objRow.CentreName#></td>
                        <td class="GridViewLabItemStyle" id="td2"  style="text-align:left" ><#=objRow.Company_Name#></td>
					<td class="GridViewLabItemStyle" id="tdBillDate"  style="text-align:center" ><#=objRow.BillDate#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdBillNo" ><#=objRow.BillNo#>
						<img src="../../Images/view.GIF" alt="" id="img1" style="cursor:pointer" onclick="$viewBillDetails(this)" title="Click To Select" />
					</td>
					<td class="GridViewLabItemStyle" id="tdPatientName" ><#=objRow.PatientName#></td>
					<td class="GridViewLabItemStyle  textCeneter" id="tdPatientID" ><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle  textCeneter" id="td1" ><#=objRow.EncounterNo#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdNetAmount" ><#=objRow.NetAmount#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdPaidAmt" ><#=objRow.PaidAmt#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdPendingAmt" ><#=objRow.PendingAmt#></td>  
                    <td class="GridViewLabItemStyle textCeneter" id="tdSettlementType" ><#=objRow.SettlementType#></td>      
					<td class="GridViewLabItemStyle" id="tdCompanyName"><#=objRow.CompanyName#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdSelect"  >
					  <img src="../../Images/Post.gif" alt="" id="imgSelect" class="paymentSelect" style="cursor:pointer" onclick="$loadPaymentControl(this,function(){})" title="Click To Select" />
					</td>   				   
					<td class="GridViewLabItemStyle" id="tdPanelID" style="display:none"><#=objRow.PanelID#></td>    
					<td class="GridViewLabItemStyle" id="tdNetAmtBeforeTax" style="display:none"><#=objRow.NetAmtBeforeTax#></td>    
					<td class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style="display:none"><#=objRow.LedgerTransactionNo#></td>    
					<td class="GridViewLabItemStyle" id="tdTransactionID" style="display:none"><#=objRow.TransactionID#></td>        
					<td class="GridViewLabItemStyle" id="tdTypeOfTnx" style="display:none"><#=objRow.TypeOfTnx#></td>        
					<td class="GridViewLabItemStyle" id="tdCustomerID" style="display:none"><#=objRow.CustomerID#></td>
					<td class="GridViewLabItemStyle" id="tdDeptLedgerNo" style="display:none"><#=objRow.DeptLedgerNo#></td>       
					<td class="GridViewLabItemStyle" id="tdRoundoff" style="display:none"><#=objRow.Roundoff#></td> 
					<td class="GridViewLabItemStyle" id="tdFeesPaid" style="display:none"><#=objRow.FeesPaid#></td> 
					<td class="GridViewLabItemStyle" id="tdIsNewPatient" style="display:none"><#=objRow.FeesPaid#></td> 
                        <td class="GridViewLabItemStyle" id="tdCentreID" style="display:none"><#=objRow.CentreID#></td> 
					</tr>
		<#}
		#>     
	 </table>
	</script>

	<script id="templatePatientDetails" type="text/html">
		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">
			Patient Details 
		</div>
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label id="lblPatientId" class="pull-left">UHID</label>
							<b class="pull-right">:</b>
							
						</div>
						<div class="col-md-5 pull-left">
							<label id="lblMrNo" class="patientInfo"><#=billDetails.PatientID#></label>
						</div>
						<div class="col-md-3">
							<label class="pull-left">Patient Name</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 pull-left">
							<label id="lblPatientName" class="patientInfo"><#=billDetails.PatientName#></label>							
						</div>
						<div class="col-md-3">
							<label class="pull-left">Panel</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 pull-left">
							<label id="lblAgeSex" class="patientInfo"><#=billDetails.CompanyName#></label>
						</div>
					</div>
				<div class="col-md-1"></div>
			</div>  
           </div>
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label id="Label1" class="pull-left">Bill No.</label>
							<b class="pull-right">:</b>
							
						</div>
						<div class="col-md-5 pull-left">
							<label id="Label2" class="patientInfo"><#=billDetails.BillNo#></label>
						</div>
						<div class="col-md-3">
							<label class="pull-left">Bill Amount</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 pull-left">
							<label id="Label3" class="patientInfo"><#=billDetails.NetAmount#></label>							
						</div>
						<div class="col-md-3">
							<label class="pull-left">Paid Amount</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 pull-left">
							<label id="Label4" class="patientInfo"><#=billDetails.PaidAmt#></label>
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
							<label class="pull-left">Centre</label>
							<b class="pull-right">:</b>
							
						</div>
						<div class="col-md-5 pull-left">
							<label id="lblCentreName" class="patientInfo"><#=billDetails.CentreName#></label>
						</div>
						<div class="col-md-16">
                            <label id="lblCentreId" style="display:none;" class="patientInfo"><#=billDetails.CentreID#></label>
						</div>
					</div>
				</div>
				<div class="col-md-1"></div>
			</div>
		</div>
	</script>
	
    
    
 <div id="divModelMultisettle"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="width:100%;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divModelMultisettle" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Multi Bill Settle</h4>
                    <span id="spnMultiBaseCurrency" style="display:none"></span>
	<span id="spnMultiBaseCountryID" style="display:none"></span>
	<span id="spnMultiBaseNotation" style="display:none"></span>
	<span id="spnMultiCFactor" style="display:none"></span>
				</div>
				<div class="modal-body" style="height:400px">
					  <div class="row">
                          <div style="padding-right: 0px;" class="col-md-4">
								<label class="pull-left">Currency</label>
								<b class="pull-right">:</b>
				</div>
				<div style="padding-left: 15px;" class="col-md-3">
					<select onchange="$onMultiChangeCurrency(this,function(){});" id="ddlMultiCurrency">
					</select>
				</div>
                          <div id="spnMultiBlanceAmount" style="color:red;font-weight:bold;text-align: left;padding-top: 3px;" class="col-md-4">
				  
				</div>
                          <div style="padding-top: 3px;" class="col-md-2">
								<label class="pull-left">Factor</label>
								<b class="pull-right">:</b>
				</div>
				<div id="spnMultiConvertionRate" style="color:red;font-weight:bold;text-align: left;padding-top: 3px;" class="col-md-9">
				  
				</div>
					  </div>


                    <div class="row">
                        <div   class="col-md-4">
					 <label class="pull-left">PaymentMode</label>
					 <b class="pull-right">:</b>
				</div>
                        <div style="padding-left: 15px;" id="divpaymentMode" class="col-md-19">
<div class="ellipsis" style="float:left">
<input type="checkbox" name="mpaymentMode" value="1" onclick="AddPaymentRow(this)" />
<b> Cash </b>
</div>
<div class="ellipsis" style="float:left">
<input type="checkbox" name="mpaymentMode" value="2" onclick="AddPaymentRow(this)"/>
<b> Cheque </b>
</div>
<div class="ellipsis" style="float:left">
<input type="checkbox" name="mpaymentMode" value="9" onclick="AddPaymentRow(this)"/>
<b> M-Pesa </b>
</div>
                            <div class="ellipsis" style="float:left;display:none">
<input type="checkbox" name="mpaymentMode" value="7" onclick="AddPaymentRow(this)"/>
<b>OPD-Advance </b>
</div>
</div>
                    </div>
          <div  class="row">
				<div id="divMultiPaymentDetails" class="col-md-24">
				<table  class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblPaymentDetails" style="width:100%;border-collapse:collapse;">
				 <thead>
				 <tr id="headTr">
				 <th class="GridViewHeaderStyle" style="width: 125px;" scope="col" >Payment Mode</th>				 
				 <th class="GridViewHeaderStyle" style="width: 75px;" scope="col" >Currency</th>
				 <th class="GridViewHeaderStyle" style="width: 150px;"  scope="col" >Bank Name</th>
				 <th class="GridViewHeaderStyle" style="width: 80px;"  scope="col" >Ref No.</th>
				 <th class="GridViewHeaderStyle" style="width: 150px;" scope="col" >Machine</th> 
				 </tr>
				 </thead>
				 <tbody></tbody>
				</table>
			</div>
              
			</div>

 <div  class="row" id="divMesaButton" style="display:none"> 
      <input type="button" id="bntMultiMpesaRequest" value="Make Payment"  onclick="showMultiMpesaSettlePage()" /> 
     </div>
                <div  class="row">
                     <div style="padding-right: 0px;" class="col-md-4">
								<label class="pull-left">Remarks/Mobile No</label>
								<b class="pull-right">:</b>
				</div>

                    <div class="col-md-5">
                        <input type="text" id="txtMultiMobileNo" />
                    </div>
</div>

				</div>
				  <div class="modal-footer">
                      <input type="button" onclick="$saveMultiPaymentDetails(this, function () { });" value="Save" id="btnMultiSave" /> 
						 <button type="button"  data-dismiss="divModelMultisettle" >Close</button>
				</div>
			</div>
		</div>
</div>
    
    
    <div  id="modalMpesaMultiSettlement" class="modal fade">    
    <div class="modal-dialog"  tabindex="-1" >
            <div class="modal-content" style="width:700px;height:410px;">
                <div class="modal-header">
                  
                    <b class="modal-title">M-PESA PAYMENT</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <iframe  style="width:100%;height:300px;" id="iframe2" ></iframe>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer"> 
                       <button type="button" onclick="CloseMultiMpesaSettleModel()">Close</button>
                </div>
            </div>
        </div>
        </div>



    
    
    
    
    
    
    <style type="text/css">
        .textCeneter {
            text-align: center;
        }
    </style>

    <script type="text/javascript">

        function SelectAllCheckboxes(chkall) {
            $('#grdOPDBillsSettlement').find("input:checkbox").each(function () {

                if (this != chkall) {
                    var RefundType = $(this).closest('tr').find('#tdSettlementType').text();
                    if (RefundType != "Refund") {
                        if ($("#checkedPatientId").text() == "") {

                            $("#checkedPatientId").text($(this).val());
                            this.checked = chkall.checked;

                        } else {
                            if ($("#checkedPatientId").text() != $(this).val()) {

                                modelAlert(" Check bill of only one patient.");
                            } else {

                                this.checked = chkall.checked;

                            }
                        }

                    } else {
                        this.checked = false;

                    }
                }

            });

        }

        function onChekboxChecked(rowId) {

            var IsChecked = $(rowId).closest('tr').find('#chkSelect').is(":checked");
            var val = $(rowId).closest('tr').find('#chkSelect').val();
            var RefundType = $(rowId).closest('tr').find('#tdSettlementType').text();


            if (IsChecked) {
                if (RefundType == "Refund") {
                    modelAlert("Don't select Refund ");
                    $(rowId).closest('tr').find('#chkSelect').prop("checked", false);
                } else {
                    if ($("#checkedPatientId").text() == "") {
                        $("#checkedPatientId").text(val);
                    } else {
                        if ($("#checkedPatientId").text() != val) {
                            modelAlert(" Check bill of only one patient.");
                            $(rowId).closest('tr').find('#chkSelect').prop("checked", false);

                        } else {
                            $(rowId).closest('tr').find('#chkSelect').prop("checked", true);
                        }
                    }
                }

                calculatependingAmt();
            } else {

                var isAnySelection = 0;

                $('#grdOPDBillsSettlement').find("input:checkbox").each(function () {
                    var IsSelect = $(this).is(":checked");
                    if (IsSelect) {
                        isAnySelection = 1;
                    }

                });

                if (isAnySelection == 0) {
                    $("#checkedPatientId").text("");
                }
                calculatependingAmt();
            }


        }


        function calculatependingAmt() {

            var TotalPending = 0;

            $('#grdOPDBillsSettlement').find("input:checkbox").each(function () {
                var IsSelect = $(this).is(":checked");
                if (IsSelect) {

                    TotalPending = parseFloat(TotalPending) + parseFloat($(this).closest('tr').find('#tdPendingAmt').text());
                }

            });
            hideShowdivpendingamt(TotalPending);
            $("#lblPendingTotalAmt").text(TotalPending);
        }


        function hideShowdivpendingamt(Amt) {

            if (parseFloat(Amt) > 0) {
                $("#divpendingamt").show();
            } else {
                $("#lblPendingTotalAmt").text("");
                $("#divpendingamt").hide();
            }
        }

        var openMultiSettleModel = function () {
            var isAnySelection = 0;
            $('#divMultiPaymentDetails table tbody').empty();
            $("input[name='mpaymentMode']").each(function () {
                var IsSelect = $(this).is(":checked");
                if (IsSelect) {
                    $(this).prop("checked", false);
                }
            });

            $("#txtMultiMobileNo").val("");

            $('#grdOPDBillsSettlement').find("input:checkbox").each(function () {
                var IsSelect = $(this).is(":checked");
                if (IsSelect) {
                    isAnySelection = parseInt(isAnySelection) + 1;
                }

            });
            if (parseInt(isAnySelection) > 1) {
                BindCurrencyDetails(function (baseCountryID) {
                    $getMultiConversionFactor(baseCountryID, function (conversionFactor) {
                        $('#spnMultiCFactor').text(conversionFactor);
                        $('#spnMultiConvertionRate').text('1 ' + $('#ddlMultiCurrency option:selected').text() + ' = ' + precise_round(conversionFactor, 2) + ' ' + $('#spnMultiBaseNotation').text());
                        $('#spnMultiBlanceAmount').text($("#lblPendingTotalAmt").text() + " " + $('#spnMultiBaseCurrency').text());

                    });
                });
                $('#divModelMultisettle').showModel();
            }
            else {
                modelAlert("Select Multiple Bill To Settle");
            }

        }

        function closeMultiSettleModel() {
            $('#divModelMultisettle').closeModel();
        }


        var BindCurrencyDetails = function (callback) {

            var ddlCurrency = $('#ddlMultiCurrency');
            serverCall('../Common/CommonService.asmx/LoadCurrencyDetail', {}, function (response) {
                var responseData = JSON.parse(response);

                $('#spnMultiBaseCurrency').text(responseData.baseCurrency);
                $('#spnMultiBaseCountryID').text(responseData.baseCountryID);
                $('#spnMultiBaseNotation').text(responseData.baseNotation);
                $(ddlCurrency).bindDropDown({
                    data: responseData.currancyDetails,
                    valueField: 'CountryID',
                    textField: 'Currency',
                    selectedValue: responseData.baseCountryID
                });
                callback(ddlCurrency.val());
            });

        }
        var $getMultiConversionFactor = function (countryID, callback) {
            serverCall('../Common/CommonService.asmx/GetConversionFactor', { countryID: countryID }, function (response) {
                callback(response);
            });
        }


        var $onMultiChangeCurrency = function (elem, callback) {
            $getMultiConversionFactor(elem.value, function (conversionFactor) {
                var blanceAmount = $("#lblPendingTotalAmt").text();
                var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
                $MulticonvertCurrency(elem.value, $blanceAmount, function (convertedCurrency) {

                    $('#spnMultiCFactor').text(conversionFactor);
                    $('#spnMultiConvertionRate').text('1 ' + $('#ddlMultiCurrency option:selected').text() + ' = ' + precise_round(conversionFactor, 2) + ' ' + $('#spnMultiBaseNotation').text());
                    $('#spnMultiBlanceAmount').text(convertedCurrency + " " + $("#ddlMultiCurrency option:selected").text());

                });
            });
        }


        var $MulticonvertCurrency = function (countryID, amount, callback) {
            serverCall('../Common/CommonService.asmx/getConvertCurrecncy', { countryID: countryID, Amount: amount }, function (response) {
                callback(response);
            });
        }

        function AddPaymentRow(rowId) {

            var isAnySelection = 0;
            var PaymentModeId = 0;
            var paymentMode = "";
            $("input[name='mpaymentMode']").each(function () {
                var IsSelect = $(this).is(":checked");
                if (IsSelect) {
                    isAnySelection = parseInt(isAnySelection) + 1;
                    PaymentModeId = $(this).val();
                    paymentMode = $.trim($(this).next('b').text());
                }

            });
            if (PaymentModeId == 9) {
                $("#divMesaButton").show();
            } else {
                $("#divMesaButton").hide();
                $("#txtMultiMobileNo").removeAttr("disabled", "disabled");
            }

            if (isAnySelection == 1) {
                 

                $('#divMultiPaymentDetails table tbody').empty();

                var row = "";

                row += '<tr>';
                row += '<td id="tdMPaymentMode" class="GridViewLabItemStyle">' + paymentMode + '</td>';
                row += '<td id="tdMS_Currency" class="GridViewLabItemStyle">' + $("#spnMultiBaseCurrency").text() + '</td>';
                if (PaymentModeId != 1) {
                    row += '<td id="tdMBankName" class="GridViewLabItemStyle"> <select class="mbnk" id="ddlmultibank" style="padding: 0px;"></select> </td>';
                    if (paymentMode == 'M-Pesa') {
                        row += '<td id="tdMRefNo" class="GridViewLabItemStyle"> <input type="text" autocomplete="off" class="required"  id="txtRefNo" value="" maxlength="10" /> </td> ';

                    }
                    else {
                        row += '<td id="tdMRefNo" class="GridViewLabItemStyle"> <input type="text" autocomplete="off" class="required"  id="txtRefNo" value=""  /> </td> ';

                    }
                    if (PaymentModeId != 10) {

                        row += '<td id="tdMSwipeMachineID" class="GridViewLabItemStyle"></td>';

                    } else {

                        row += '<td id="tdMSwipeMachineID" class="GridViewLabItemStyle"><select class="swipeMachine" style="padding: 0px;"><option value="POS 1-BB">POS 1-BB</option><option value="POS 2-SBM">POS 2-SBM</option><option value="POS 3-MCB">POS 3-MCB</option> </select> </td>';

                    }

                } else {
                    row += '<td id="tdMBankName" class="GridViewLabItemStyle"> </td>';
                    row += '<td id="tdMRefNo" class="GridViewLabItemStyle"><input type="text" autocomplete="off" class="required"  id="txtRefNo" value="" style="display:none"/> </td>';
                    row += '<td id="tdMSwipeMachineID" class="GridViewLabItemStyle"> </td>';

                }
                row += '<td id="tdMBaceCurrency" style="display:none">' + $("#spnMultiBaseCurrency").text() + '</td>';
                row += '<td id="tdMS_CountryID" style="display:none" >' + $("#spnMultiBaseCountryID").text() + ' </td>';
                row += '<td id="tdMS_Notation" style="display:none">' + $("#spnMultiBaseNotation").text() + ' </td>';
                row += '<td id="tdMC_Factor" style="display:none" class="GridViewLabItemStyle">' + $("#spnMultiCFactor").text() + '</td>';
                row += '<td id="tdMPaymentModeID" style="display:none" class="GridViewLabItemStyle">' + PaymentModeId + '</td>';

                row += '</tr>';

                $('#divMultiPaymentDetails table tbody').append(row);

                if (PaymentModeId != 1) {
                    $bindMBankMaster(function () { });
                }

            } else if (isAnySelection == 0) {
                $("#divMesaButton").hide();
                $("#txtMultiMobileNo").removeAttr("disabled", "disabled");
                $('#divMultiPaymentDetails table tbody').empty();
                $(rowId).prop("checked", false);
            } else {
                $(rowId).prop("checked", false);
                modelAlert("Select Only one Payment Mode.");
            }


        }

        var $bindMBankMaster = function (callback) {
            $getBankMaster(function (response) {
                $(".mbnk").bindDropDown({
                    data: response,
                    valueField: 'BankName',
                    textField: 'BankName',
                    defaultValue: '',
                    selectedValue: ''
                });
                callback(true);
            });
        }
        var $bankMaster = [];
        var $getBankMaster = function (callback) {
            if ($bankMaster.length < 1) {
                serverCall('../Common/CommonService.asmx/GetBankMaster', {}, function (response) {
                    $bankMaster = JSON.parse(response);
                    callback($bankMaster);
                });
            }
            else
                callback($bankMaster);
        }




        $getMultiBillPaymentDetails = function (data, callback) {

            var billDetails = JSON.parse(data);

            console.log(billDetails);
            $getHashCode(function (hashCode) {
                var hashCode = hashCode;

                $PaymentDetail = [];
                var isinvalid = '0';
                $('#divMultiPaymentDetails table tbody tr').each(function (index, elem) {
                    var $row = $(elem);
                    if ($($row).find('#tdMRefNo input').val().length != 10) {
                        isinvalid = '1';

                    }
                    $PaymentDetail.push({
                        PaymentMode: $($row).find('#tdMPaymentMode').text(),
                        PaymentModeID: $($row).find('#tdMPaymentModeID').text(),
                        S_Amount: billDetails.PendingAmt,
                        S_Currency: $($row).find('#tdMBaceCurrency').text(),
                        S_CountryID: Number($($row).find('#tdMS_CountryID').text()),
                        BankName: String.isNullOrEmpty($($row).find('#tdMBankName select').val()) ? '' : $($row).find('#tdMBankName select').val(),
                        RefNo: String.isNullOrEmpty($($row).find('#tdMRefNo input').val()) ? '' : $($row).find('#tdMRefNo input').val(),
                        BaceCurrency: $($row).find('#tdMBaceCurrency').text(),
                        C_Factor: $($row).find('#tdMC_Factor').text(),
                        Amount: billDetails.PendingAmt,
                        S_Notation: $($row).find('#tdMS_Notation').text(),
                        PaymentRemarks: $("#txtMultiMobileNo").val(),
                        swipeMachine: String.isNullOrEmpty($($row).find('#tdMSwipeMachineID select').val()) ? '' : $($row).find('#tdMSwipeMachineID select').val(),

                        currencyRoundOff: 0,

                    });

                });


                $OPDDiscount = {
                    netAmount: billDetails.NetAmount,
                    DiscountReason: "",
                    DiscountApproveBy: "",
                    DiscountOnTotal: 0,
                    RoundOff: 0,
                    Adjustment: billDetails.PendingAmt,
                    DiscAmt: 0,
                    DiscountPercentage: 0
                }
                $hashCode = hashCode;
                $AmountPaid = billDetails.PendingAmt;
                $PatientID = billDetails.PatientID;
                $TransactionID = billDetails.TransactionID;
                $LedgerTranNo = billDetails.LedgerTransactionNo;
                $Naration = $("#txtMultiMobileNo").val();
                $PanelID = billDetails.PanelID;
                $IsRefund = parseFloat(billDetails.PendingAmt) < 0 ? 1 : 0;
                $netAmount = billDetails.NetAmount;
                $advanceAmt = billDetails.AdvanceAmount;
                $TypeOfTnx = billDetails.TypeOfTnx;
                $feePaid = billDetails.FeesPaid;
                $IsNewPatient = billDetails.IsNewPatient;
                $centreId = Number(billDetails.CentreID);
                if (PartialPayment != 1 && billDetails.PendingAmt != paymentDetails.adjustment) {
                    modelAlert(" You Are Not Allowed To Take Partial Payment"); return;
                }
                if (isinvalid=='1') {
                  
                    modelAlert("You Are Not Allowed to take refNo less than 10", function () {

                        $('#divModelMultisettle').showModel();

                    });
                    isinvalid = '0';
                    return;
                }
                callback({ PaymentDetail: $PaymentDetail, OPDDiscount: [$OPDDiscount], hashCode: $hashCode, AmountPaid: $AmountPaid, PatientID: $PatientID, TransactionID: $TransactionID, LedgerTranNo: $LedgerTranNo, Naration: $Naration, PanelID: $PanelID, IsRefund: $IsRefund, netAmount: $netAmount, advanceAmt: $advanceAmt, TypeOfTnx: $TypeOfTnx, feePaid: $feePaid, IsNewPatient: $IsNewPatient, centreId: $centreId }, billDetails);


            });

        }


        $saveMultiPaymentDetails = function (btnSave) {

            $('#grdOPDBillsSettlement').find("input:checkbox:checked").each(function () {
                var IsSelect = $(this).is(":checked");
                if (IsSelect) {

                    var rowObj = $(this).closest('tr').attr('data');

                    $getMultiBillPaymentDetails(rowObj, function (data, selectedBillDetails) {
                        $(btnSave).attr('disabled', true).val('Submitting...');
                        serverCall('OPDFinalSettlementNew.aspx/saveOPDSettlement', data, function (response) {
                            var $responseData = JSON.parse(response);
                            modelAlert($responseData.response, function () { });
                            if ($responseData.status) {

                                $('#' + data.LedgerTranNo).remove();
                                $(btnSave).removeAttr('disabled').val('Save');
                                if (data.TypeOfTnx == 'OPD-Package') {
                                    if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
                                        window.open('../common/OPDPackageReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0');
                                    else
                                        // window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0&Type=OPD');
                                        window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0&Type=OPD');
                                }
                                else if (data.TypeOfTnx == 'Pharmacy-Issue')
                                    // window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&Duplicate=0&Type=PHY');
                                    window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&Duplicate=0&Type=PHY');
                                else if (data.TypeOfTnx == 'Pharmacy-Return')
                                    // window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&Duplicate=0&Type=PHY');
                                    window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&Duplicate=0&Type=PHY');
                                else {
                                    if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
                                        //window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&ReceiptNo=' + $responseData.Receipt_No + '&Duplicate=0');
                                        window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0&Type=OPD');
                                    else
                                        window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&Duplicate=0&ReceiptNo=' + $responseData.Receipt_No + '&IsBill=0&Type=OPD');

                                    //window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.LedgerTranNo + '&IsBill=0&ReceiptNo=' + $responseData.Receipt_No + '&Duplicate=0&Type=OPD');
                                }

                    }
                    else
                        $(btnSave).removeAttr('disabled').val('Save');

                        });
                    });


        }

            });

            closeMultiSettleModel();
        }


        </script>



    <script type="text/javascript">
        var OpenMultiMpesaSettleModel = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#modalMpesaMultiSettlement');
            divSearchbyDate.showModel();
        }
        function CloseMultiMpesaSettleModel() {
            debugger
            var MobileNo = $("#iframe2").contents().find("#lblPhoneNumber").text();
            var MpesaReceipt = $("#iframe2").contents().find("#lblMpesaReceiptNumber").text();
            var CanGenrateBill = $("#iframe2").contents().find("#lblCanGenrateBill").text();
            $("#txtMultiMobileNo").val(MobileNo);
            $("#tblPaymentDetails tbody tr:first #txtRefNo").val(MpesaReceipt).attr("disabled", "disabled");
            if (CanGenrateBill == "1") {
                $("#txtMultiMobileNo").attr("disabled", "disabled");
                jQuery('#btnMultiSave').trigger('click');
            } else if (CanGenrateBill == "2") {
                $("#txtMultiMobileNo").removeAttr("disabled", "disabled");
                modelAlert("Can not generate Receipt,You Close Before Processing .");
            }
            else {
                $("#txtMultiMobileNo").removeAttr("disabled", "disabled");
                modelAlert("Can not generate Receipt,Mpesa payment Failed");
            }

            $('#modalMpesaMultiSettlement').closeModel();

        }
        function showMultiMpesaSettlePage() {

            var BillNo = "";
            $('#grdOPDBillsSettlement').find("input:checkbox:checked").each(function () {
                var IsSelect = $(this).is(":checked");
                if (IsSelect) {
                    var rowObj = $(this).closest('tr').attr('data');
                    var billDetails = JSON.parse(rowObj);
                    if (BillNo=="") {
                        BillNo = billDetails.BillNo;
                    } else {
                        BillNo =BillNo+","+ billDetails.BillNo;
                    }


                }
            });
           
            PatientID = $("#checkedPatientId").text(); 
            Amount = $("#lblPendingTotalAmt").text();

            $('#iframe2').attr('src', "../OPD/MPesaRequestPage.aspx?PatientID=" + PatientID + "&BillNo=" + BillNo + "&Amount=" + Amount + "");
            $("#modalMpesaMultiSettlement").show();
        }

    </script>

</asp:Content>
