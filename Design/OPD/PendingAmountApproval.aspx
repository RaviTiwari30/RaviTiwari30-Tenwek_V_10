<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PendingAmountApproval.aspx.cs" Inherits="Design_OPD_PendingAmountApproval" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Lab/Popup.ascx" TagName="PopUp" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .selectedRow {
            background-color: aqua !important;
        }
    </style>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Payment Approval</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            <select id="ddlsearch">
                                <option value="PName">Patient Name</option>
                                <%--<option value="pmh.BillNo">Bill No</option>--%>
                                <option value="lt.BillNo">Bill No</option>
                                <option value="pm.PatientID" selected >UHID</option>
                                <option value="lt.EncounterNo">Encounter No</option>
                            </select>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtsearch" maxlength="100" /> 
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Filter Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlFilterType">
                                <option value="0" selected >Not-Approved</option>
                                <option value="1">Approved</option>
                                 <option value="2">Both</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Service Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <input id="rdoPanelService" type="radio" name="ServiceType" value="0" checked="checked" class="pull-left"  />
				        <span class="pull-left">Panel Service</span>
				        <input id="rdoPaidService" type="radio" name="ServiceType" value="1"  class="pull-left" />
				        <span class="pull-left">Paid Service</span>
                        </div>



                        </div>
                    <div class="row">
                        <div class="col-md-24" style="text-align: center">
                              <input type="button" id="btnsearch" value="Search" onclick="SearchPatientDetails()" />
                            &nbsp; <input type="button" id="btnExportToExcel" value="Export To Excel" onclick="exportToExcelOPDBills()" />
                            
                        </div>

                    </div>
                </div></div>

           
		</div>
         <div class="POuter_Box_Inventory billDetailsDiv">
			<div class="row">
				<div  style="overflow:auto;max-height:410px" id="divBillDetailsDetails" class="col-md-24">

				</div>
			</div>
        </div>

        <div class="POuter_Box_Inventory">
              <div class="modal fade" id="myModal">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 950px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeRestartModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Item To Approve(<span id="spnSelectedBillNo" class="patientInfo"></span>)</h4>
                        <label id="lblTransactionNoToApproved" style="display:none"></label>
                    </div>
                    <div class="modal-body">
                        <div class="row" style="margin-bottom:10px">
                            <div class="col-md-4" style="font-weight:bolder">
                                Bill Amount :
                            </div>
                            <div class="col-md-4">
                                <label id="lblBillAmounttoApproved"  style="color:red;font-weight:bolder"></label>
                            </div>
                            <div class="col-md-4"  style="font-weight:bolder">
                                Panel Payable :
                            </div>
                            <div class="col-md-4">
                                 <label id="lblPanelAmounttoApproved"  style="color:red;font-weight:bolder"></label>
                            </div>
<div class="col-md-4"  style="font-weight:bolder">
                                Patient Payable :
                            </div>
                            <div class="col-md-4">
                                 <label id="lblPatientAmounttoApproved" style="color:red;font-weight:bolder"></label>
                            </div>
                        </div>
                        <div class="row" style="margin-bottom:10px;display:none" id="divAmountPaidByPatient">
                            
                            <div class="col-md-4"  style="font-weight:bolder" >
                                Paid By Patient :
                            </div>
                            <div class="col-md-4">
                                 <label id="lblPaidByPatinet"  style="color:red;font-weight:bolder"></label>
                            </div>
                            <div class="col-md-4"  style="font-weight:bolder" >
                              Patient  Pending :
                            </div>
                            <div class="col-md-4">
                                 <label id="lblPendingByPatinet"  style="color:red;font-weight:bolder"></label>
                            </div>
                        </div>
                        <div id="DivOrderDetails" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">

                            <table id="tblItemApproved" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                                <thead>
                                    <tr>
                                        <td class="GridViewHeaderStyle">SNo.</td>
                                        <td class="GridViewHeaderStyle">Service Type</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">Amount</td>
                                         <td class="GridViewHeaderStyle">Status</td>
                                        <td class="GridViewHeaderStyle">Approved By</td>
                                        <td class="GridViewHeaderStyle">Approved DT</td>
                                         <td class="GridViewHeaderStyle">Remark</td>
                                        <td class="GridViewHeaderStyle">Select </td>
                                        
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>

                            
                        </div>
                        <div class="row" id="divRemark">
                            <div class="col-md-2">
                                 Remark :
                            </div>

                            <div class="col-md-22">
                                <textarea id="txtRemark" cols="10" rows="1" class="required" ></textarea>
                                   
                            </div> 
                        </div>

                    </div>
                    <div class="modal-footer">
                        <input id="btnApprovedPayment" type="button" style="display:none" value="Approved Payment" onclick="ApprovedPaymentItemWise()" />
                    </div>
                </div>

            </div>
        </div>

        </div>


        
        <script type="text/javascript">
            function SearchPatientDetails() {
                var data = {
                    searchtype: $('#ddlsearch').val(),
                    searchvalue: $('#txtsearch').val(),
                    fromDate: $('#FrmDate').val(),
                    toDate: $('#ToDate').val(),
                    filterType: Number($('#ddlFilterType').val()),
                    serviceType: Number($('input[type=radio][name=ServiceType]:checked').val())
                }
                serverCall('PendingAmountApproval.aspx/SearchOPDBills', data, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        billsDetails = JSON.parse(response);
                        var output = $('#templateBillsSearchDetails').parseTemplate(billsDetails);
                        $('#divBillDetailsDetails').html(output).customFixedHeader();
                    }
                    else {
                        modelAlert('No Record Found', function () { $('#divBillDetailsDetails').html(''); });
                    }
                });
            }

            function exportToExcelOPDBills() {
                var data = {
                    searchtype: $('#ddlsearch').val(),
                    searchvalue: $('#txtsearch').val(),
                    fromDate: $('#FrmDate').val(),
                    toDate: $('#ToDate').val(),
                    filterType: Number($('#ddlFilterType').val()),
                    serviceType: Number($('input[type=radio][name=ServiceType]:checked').val())
                }
                serverCall('PendingAmountApproval.aspx/exportToExcelOPDBills', data, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        window.open('../../Design/commonReports/Commonreport.aspx?ReportName=' + ($('#ddlFilterType option:selected').text() == "Both" ? "Both(Approved And Not Approved)" : $('#ddlFilterType option:selected').text()) + ' Payment Approval Report&Type=E');

                    }
                    else {
                        modelAlert('No Record Found');
                    }
                });
            }


            var $UpdatePaymentApproval = function (rowid) {
                modelConfirmation('Confirmation', 'Do you want to Approved the Pending Amount?', 'Yes', 'Cancel', function (response) {
                    if (response) {
                        var LardgerTransactionNo = $(rowid).closest('tr').find('#tdLedgerTransactionNo').text();
                        var BillType = $(rowid).closest('tr').find('#tdBilltype').text();
                        serverCall('PendingAmountApproval.aspx/UpdatePaymentApproval', { LedgerTransactionNo: LardgerTransactionNo }, function (response) {
                            var j = JSON.parse(response)
                            if (!String.isNullOrEmpty(response)) {
                                modelAlert(j.message, function () {
                                    if (BillType == "OPD")
                                        window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=0&Type=OPD');
                                    else
                                        window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=0&Type=PHY');

                                    SearchPatientDetails();
                                });
                            }
                            else {
                                modelAlert('No Record Found', function () { $('#divBillDetailsDetails').html(''); });
                            }
                        });
                    }
                    else { return; }
                })

            }
        </script>


        <script id="templateBillsSearchDetails" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdOPDBillsSettlement" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Panel Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">Panel</th>
            <th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
            <th class="GridViewHeaderStyle" scope="col" >Encounter No</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill Amount</th>
			<th class="GridViewHeaderStyle" scope="col" >Paid Amount</th>
			<th class="GridViewHeaderStyle" scope="col" >Pending Amount</th>  
			<th class="GridViewHeaderStyle" scope="col" >Select</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">LedgerTransactionNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">TransactionID</th>
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
					<tr  data='<#= JSON.stringify(objRow) #>'>
					<td class="GridViewLabItemStyle textCenter" id="tdSNo"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdCompanyName"  style="text-align:left" ><#=objRow.Company_Name#></td>
					<td class="GridViewLabItemStyle" id="tdBillDate"  style="text-align:center" ><#=objRow.BillDate#></td>
					<td class="GridViewLabItemStyle textCenter" id="tdBillNo" ><#=objRow.BillNo#>
                        <br />
                        <img src="../../Images/view.GIF" alt="" id="img1" style="cursor:pointer" onclick="$viewBillDetails(this)" title="Click To Select" />
					
					</td>
					<td class="GridViewLabItemStyle" id="tdPatientName" ><#=objRow.PatientName#></td>
					<td class="GridViewLabItemStyle  textCenter" id="tdPatientID" ><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle  textCenter" id="td1" ><#=objRow.EncounterNo#></td>
					<td class="GridViewLabItemStyle textCenter" id="tdNetAmount" ><#=objRow.NetBillAmount#></td>
					<td class="GridViewLabItemStyle textCenter" id="tdPaidAmt" ><#=objRow.PaidAmount#></td>
					<td class="GridViewLabItemStyle textCenter" id="tdPendingAmt" ><#=objRow.PendingAmt#></td>  
					<%--<td class="GridViewLabItemStyle textCeneter" id="tdSelect"  >
					  <img src="../../Images/Post.gif" alt="" id="imgSelect" class="paymentSelect" style="cursor:pointer" onclick="$UpdatePaymentApproval(this,function(){})" title="Click To Select" />
					</td>--%>   	
                       <td class="GridViewLabItemStyle textCenter" id="tdSelect"  >
                            <input type="button" id="btnGetItem" value="Get Item" onclick="GetItemToApproved(this)" />
                        </td>			   
					<td class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style="display:none"><#=objRow.LedgerTransactionNo#></td>    
						<td class="GridViewLabItemStyle" id="tdBilltype" style="display:none"><#=objRow.BillType#></td>  
                        <td class="GridViewLabItemStyle" id="tdTransactionID" style="display:none"><#=objRow.TransactionID#></td>        
					</tr>
		<#}
		#>     
	 </table>
	</script>


        <script type="text/javascript">
            var openRestartModel = function () {
                $('#tblItemApproved').show();
                $("#myModal").showModel();
            }

            var $closeRestartModel = function () {
                $("#lblTransactionNoToApproved").text("");
                $('#tblItemApproved tbody').empty();
                $("#myModal").hideModel();

            }
            function GetItemToApproved(rowid) {

                $(rowid).closest('table tbody').find('tr').removeClass('selectedRow');
                $(rowid).closest('tr').addClass('selectedRow');

                var LardgerTransactionNo = $(rowid).closest('tr').find('#tdLedgerTransactionNo').text();
                var BillNo = $(rowid).closest('tr').find('#tdBillNo').text();

                $("#lblTransactionNoToApproved").text(LardgerTransactionNo);
                $("#spnSelectedBillNo").text('Bill No : ' + BillNo);

                txtRemarkHideShow();
                SelectItemToApproved(LardgerTransactionNo);
            }

            function SelectItemToApproved(LardgerTransactionNo) {
                btnApprovedHideShow(0);
                var data = {
                    LedgerTransactionNo: LardgerTransactionNo,
                    filterType: Number($('#ddlFilterType').val()),
                    serviceType: Number($('input[type=radio][name=ServiceType]:checked').val())
                }
                serverCall('PendingAmountApproval.aspx/GetItemToApproved', data, function (response) {


                    var GetData = JSON.parse(response);

                    if (GetData.status) {
                        data = GetData.data;
                        $('#tblItemApproved tbody').empty();
                        var Remark = "";

                        $("#lblBillAmounttoApproved").text(data[0].TotalBillAmount);
                        $("#lblPanelAmounttoApproved").text(data[0].PanelPayable);
                        $("#lblPatientAmounttoApproved").text(data[0].PatientPayable);
                        if (parseFloat(data[0].PatientPayable) > 0) {
                            $("#lblPaidByPatinet").text(data[0].AmountPaidByPatient);
                            $("#lblPendingByPatinet").text(data[0].PendingAmt);
                            $("#divAmountPaidByPatient").show();
                        } else {
                            $("#divAmountPaidByPatient").hide();
                        }

                        $.each(data, function (i, item) {

                            var rows = "";
                            rows += '<tr>';
                            rows += '<td class="GridViewLabItemStyle" >' + (++i) + '</td>';

                            rows += '<td class="GridViewLabItemStyle"  id="tbServiceType">' + item.ServiceType + '</td>';
                            rows += '<td class="GridViewLabItemStyle"  id="tbItemName">' + item.ItemName + '</td>';
                            rows += '<td class="GridViewLabItemStyle"  id="tbAmount">' + item.Amount + '</td>';
                            rows += '<td class="GridViewLabItemStyle"  id="tbStaus">' + item.IsPaymentApproval + '</td>';

                            rows += '<td class="GridViewLabItemStyle"  id="tbApprovedBy">' + item.PaymentApprovedBy + '</td>';
                            rows += '<td class="GridViewLabItemStyle"  id="tbApprovedDT">' + item.PaymentApprovedDateTime + '</td>';

                            rows += '<td class="GridViewLabItemStyle"  id="tbPaymentApprovalRemark">' + item.PaymentApprovalRemark + '</td>';

                            rows += '<td class="GridViewLabItemStyle"  id="tbSelect"> '
                            if (item.IsPayable == 1) {
                                if (item.Status == 0) {
                                    if (item.CanApprovePendingAmount == 1) {
                                        rows += ' <input type="checkbox" id="chkSelect" value="' + item.ID + '" />';
                                        btnApprovedHideShow(1)
                                    } else {
                                        rows += '<span style="color:red">You are Not authorised to approved pending amount for cash Patient.</span>';
                                        btnApprovedHideShow(1)
                                    }

                                }

                            } else {
                                if (item.Status == 0) {
                                    rows += ' <input type="checkbox" id="chkSelect" checked="checked" value="' + item.ID + '"  />';
                                    btnApprovedHideShow(1);
                                }
                            }

                            rows += ' </td>';


                            rows += '<td class="GridViewLabItemStyle"  id="tbId" style="display:none">' + item.ID + '</td>';
                            rows += '<td class="GridViewLabItemStyle"  id="tdBillType" style="display:none">' + item.BillType + '</td>';
                            rows += '<td class="GridViewLabItemStyle"  id="tdLedgertransactionNo" style="display:none">' + item.LedgerTransactionNo + '</td>';


                            rows += '</tr>';

                            if (item.PaymentApprovalRemark!="") {
                                Remark = item.PaymentApprovalRemark;
                            }
                            $('#tblItemApproved tbody').append(rows);
                        });

                        $("#txtRemark").val(Remark);

                        openRestartModel();
                    }
                    else {
                        $closeRestartModel();
                        modelAlert("No data Avilable.");

                    }


                });
            }


            function ApprovedPaymentItemWise() {

                var ltdId = "";
                var count = 0;

                var BillType = $('#tblItemApproved tbody tr:first').find('#tdBillType').text();
                var LardgerTransactionNo = $('#tblItemApproved tbody tr:first').find('#tdLedgertransactionNo').text();

                $("#tblItemApproved #chkSelect:checked").each(function () {
                    if (count == 0) {
                        ltdId = this.value;

                    } else {
                        ltdId = ltdId + ',' + this.value;
                    }
                    count = count + 1;

                });

                var Remark="";

                var typ = Number($('input[type=radio][name=ServiceType]:checked').val())
                if (typ == 0) {
                    Remark="";
                } else {
                    Remark=$("#txtRemark").val();

                    if (Remark == "" || Remark == null || Remark==undefined) {
                        modelAlert("Please Enter Remark");
                        return false;
                    }
                }



                serverCall('PendingAmountApproval.aspx/ApprovedPaymentItemWise', { Id: ltdId, Remark: Remark }, function (response) {


                    var GetData = JSON.parse(response);

                    if (GetData.status) {
                        modelAlert(GetData.response, function () {
                            if (BillType == "OPD")
                                window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=0&Type=OPD');
                            else
                                window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=0&Type=PHY');


                            SelectItemToApproved($("#lblTransactionNoToApproved").text());
                        })
                    }
                    else {
                        modelAlert(GetData.response, function () {
                            //  SelectItemToApproved($("#lblTransactionNoToApproved").text());
                        })
                    }


                });

            }

            function btnApprovedHideShow(typ) {
                if (typ == 0) {
                    $("#btnApprovedPayment").hide();
                } else {
                    $("#btnApprovedPayment").show();
                }

            }

            $viewBillDetails = function (rowid) {
                var LardgerTransactionNo = $(rowid).closest('tr').find('#tdLedgerTransactionNo').text();
                var BillType = $(rowid).closest('tr').find('#tdBilltype').text();
                if (BillType == "OPD")
                    window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=0&Type=OPD');
                else
                    window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + LardgerTransactionNo + '&IsBill=1&Duplicate=0&Type=PHY');

            }


            function txtRemarkHideShow() {

                var typ = Number($('input[type=radio][name=ServiceType]:checked').val())
                if (typ == 0) {
                    $("#divRemark").hide();
                } else {
                    $("#divRemark").show();
                }

            }




        </script>

        </div>
</asp:Content>
