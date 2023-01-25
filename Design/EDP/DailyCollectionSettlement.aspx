<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DailyCollectionSettlement.aspx.cs"
    Inherits="Design_EDP_DailyCollectionSettlement" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
        $searchOPDBills = function (callback) {
            var data = {
                BatchNumber: $('[id$=txtbatchnumber]').val(),
                UserId: $('[id$=ddluser] option:selected').val(),
                fromDate: $('#ucFromDate').val(),
                toDate: $('#ucToDate').val(),
                FromTime: $('[id$=txtFromTime]').val(),
                Totime: $('[id$=txtToTime]').val(),
                Status: $('[id$=ddlstatus] option:selected').val()
            }
            serverCall('DailyCollectionSettlement.aspx/SearchDailyCollection', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    billsDetails = JSON.parse(response);
                    var output = $('#templateBillsSearchDetails').parseTemplate(billsDetails);
                    $realeasePaymentControl(function () {
                        $('#divBillDetailsDetails').html(output).customFixedHeader();
                        if (billsDetails[0].IsCanSettleBatch == '1') {
                            var ReceivedAmt = 0;
                            var OutStandingAmt = 0;
                            var TotalAmount = 0;
                            if (billsDetails.length > 0) {



                                for (var i = 0; i < billsDetails.length; i++) {
                                    ReceivedAmt += billsDetails[i].ReceivedAmount;
                                    OutStandingAmt += billsDetails[i].CashAmount_1 + billsDetails[i].CashAmount_2 + billsDetails[i].CashAmount_3 + billsDetails[i].CashAmount_4 + billsDetails[i].CashAmount_6 - billsDetails[i].ReceivedAmount;
                                     
                                }

                                $("#divBillDetailsDetails tr").each(function () {
                                    var id = $(this).closest("tr").attr("id");
                                    $row = $(this).closest('tr');
                                    if (id != 'Header') {
                                        TotalAmount = parseFloat(TotalAmount) + parseFloat($row.find('#tdNetAmount').text());                                       
                                    }
                                });
                                $('[id$=lblTotalAmount]').text('Total Amount: ' + TotalAmount + '');
                                $('[id$=lblReceivedAmount]').text('Total Received Amount: ' + ReceivedAmt + '');
                                $('[id$=lblTotalOutstandingamt]').text('Total Outstanding Amount : '+OutStandingAmt+'');
                            }
                            $('[id$=btnSaveSettlement]').css('display', 'block');
                            $('[id$=lblReceivedAmount]').css('display', 'block');
                            $('[id$=lblTotalAmount]').css('display', 'block');
                            $('[id$=lblTotalOutstandingamt]').css('display', 'block');
                        }
                        else {
                            $('[id$=btnSaveSettlement]').css('display', 'none');
                            $('[id$=lblReceivedAmount]').css('display', 'none');
                            $('[id$=lblTotalAmount]').css('display', 'none');                            
                            $('[id$=lblTotalOutstandingamt]').css('display', 'none');
                        }
                    });
                }
                else {
                    $realeasePaymentControl(function () {
                        $('#divBillDetailsDetails').html('');
                        $('[id$=txtbatchnumber]').val('');
                        $('[id$=btnSaveSettlement]').css('display', 'none');
                        $('[id$=lblReceivedAmount]').css('display', 'none');
                        $('[id$=lblTotalOutstandingamt]').css('display', 'none');
                    });
                }
            });
        }
        $SaveDailyCollection = function (callback) {
            var data = [];
            var batchNumber = '';
            var Remarks = '';
            var Amount = '';
            var ReceivedAmount = '0';
            var OutstandingAmount = '0';
            var CashAmount='0';
            $('#grdOPDBillsSettlement tr').each(function () {
                if (($(this).find('[id$=chkIcu]').prop('checked')) == true) {
                    batchNumber = $(this).find('[id$=tdbatchnumber]').text();
                    Remarks = $(this).find('[id$=txtRemarks]').val();
                    Amount = $(this).find('[id$=txtPaidAmount]').val();
                    CashAmount= $(this).find('[id$=tdCashAmount]').text();
                    OutstandingAmount = $(this).find('[id$=td5]').text();
                    ReceivedAmount = $(this).find('[id$=tdReceivedAmount]').text();
                    data.push({
                        BatchNumber: batchNumber,
                        Remarks: Remarks,
                        Amount: Amount,
                        OutstandingAmount: OutstandingAmount,
                        ReceivedAmount: ReceivedAmount,
                        CashAmount: CashAmount
                    })
                }
            });
            serverCall('DailyCollectionSettlement.aspx/SaveCollectionDetails', { data: data }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    billsDetails = JSON.parse(response);
                    if (billsDetails == true && billsDetails != "") {
                        $('[id$=txtbatchnumber]').val('');
                        $('[id$=btnSaveSettlement]').css('display', 'none');
                        $('#divBillDetailsDetails').html('');
                    }
                    else {
                        
                    }
                }
                else {
                    $('[id$=btnSaveSettlement]').css('display', 'block');
                }
            });
        }
        $realeasePaymentControl = function (callback) {
            $('#divPaymentDetails').html('');
            $('.payment').hide();
            $('.billDetailsDiv').show();
            callback(true);
        }

        function SelectAllIcu() {
            if ($('[id$=chkIcuAll]').is(':checked')) {
                $('#grdOPDBillsSettlement tr').each(function () {
                    if ($(this).find('[id$=chkIcu]').is(':enabled')) {
                        $(this).find('[id$=chkIcu]').prop('checked', true)
                        $(this).find('[id$=txtRemarks]').prop('disabled', false)
                        $(this).find('input[type=radio]').prop('disabled', false)
                        $(this).find('[id$=txtPaidAmount]').prop('disabled', false)
                    }
                });
            }
            else {
                $('#grdOPDBillsSettlement tr').each(function () {
                    if ($(this).find('[id$=chkIcu]').prop('checked', false)) {
                        $(this).find('[id$=txtRemarks]').prop('disabled', true)
                        $(this).find('[id$=txtPaidAmount]').prop('disabled', true)
                        $(this).find('input[type=radio]').prop('disabled', true)
                        $(this).find('input[type=radio]').prop('checked', false)
                        $(this).find('[id$=txtRemarks]').val('');
                        $(this).find('[id$=txtPaidAmount]').val('');
                    }
                });
            }
        }
        function ShowRadiobutton() {
            var flag = 0;
            $('#grdOPDBillsSettlement tr').each(function () {
                if (($(this).find('[id$=chkIcu]').prop('checked')) == false) {
                    $(this).find('[id$=txtRemarks]').prop('disabled', true)
                    $(this).find('input[type=radio]').prop('disabled', true)
                    $(this).find('[id$=txtPaidAmount]').prop('disabled', true)
                    flag = 1;
                }
                else {
                    $(this).find('[id$=txtRemarks]').prop('disabled', false)
                    $(this).find('input[type=radio]').prop('disabled', false)
                    $(this).find('[id$=txtPaidAmount]').prop('disabled', false)
                }
                if (flag == 1) {
                    $('[id$=chkIcuAll]').prop('checked', false);
                }
                else {
                    $('[id$=chkIcuAll]').prop('checked', true);
                }
            });
        }
        function ShowReport(ctr) {
            var BatchNumber = ctr.id.split('_')[1];
            var ReportType = $('[id$=rbtReportType] input:checked').val();
            var fromDate = $('#ucFromDate').val();
            var toDate = $('#ucToDate').val();
            var FromTime = $('[id$=txtFromTime]').val();
            var Totime = $('[id$=txtToTime]').val();
            $.ajax({
                url: "DailyCollectionSettlement.aspx/ShowReport",
                data: '{BatchNumber:"' + BatchNumber + '",ReportType:"' + ReportType + '",fromDate:"' + fromDate + '",toDate:"' + toDate + '",FromTime:"' + FromTime + '",Totime:"' + Totime + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == "1") {
                        window.open('../../Design/common/Commonreport.aspx');
                    }
                    else {
                    }
                }
            });
        }
        function myFunction() {
            var Amount = "";
            var CashAmount = "";
            var ReceivedAmount = "";
            $('#grdOPDBillsSettlement tr').each(function () {
                if (($(this).find('[id$=chkIcu]').prop('checked')) == true) {
                    Amount = $(this).find('[id$=txtPaidAmount]').val();
                    CashAmount = $(this).find('[id$=tdCashAmount]').text()
                    ReceivedAmount = $(this).find('[id$=tdReceivedAmount]').text()
                    if (Amount > (CashAmount - ReceivedAmount)) {
                        $(this).find('[id$=txtPaidAmount]').val('0');
                        modelAlert("You can't Add more than Outstanding Amount!", function () {
                            $(this).find('[id$=txtPaidAmount]').val('').focus();
                        });
                        //modelConfirmation('Alert!!', "You can't Add more than Outstanding Amount!", 'Ok', '', function (response) {
                        //    if (response) {
                        //        return false;
                        //    }
                        //    else {
                        //        return false;
                        //    }
                        //});
                    }
                }
            });
        }
        var labelSearch = function (appointmentStatus, callback) {
            getSearchCriteria(function (data) {
                data.Status = appointmentStatus;
                searchAppointments(data, function () { });
            });
        }
        var getSearchCriteria = function (callback) {
            var data = {
                BatchNumber: $('[id$=txtbatchnumber]').val(),
                UserId: $('[id$=ddluser] option:selected').val(),
                fromDate: $('#ucFromDate').val(),
                toDate: $('#ucToDate').val(),
                FromTime: $('[id$=txtFromTime]').val(),
                Totime: $('[id$=txtToTime]').val(),
                //Status: $('[id$=ddlstatus] option:selected').val()
            }
            callback(data);
        }
        var searchAppointments = function (data, callback) {
            serverCall('DailyCollectionSettlement.aspx/SearchDailyCollection', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    billsDetails = JSON.parse(response);
                    var output = $('#templateBillsSearchDetails').parseTemplate(billsDetails);
                    $realeasePaymentControl(function () {
                        $('#divBillDetailsDetails').html(output).customFixedHeader();
                        if (billsDetails[0].IsCanSettleBatch == '1') {
                            $('[id$=btnSaveSettlement]').css('display', 'block');
                        }
                        else
                            $('[id$=btnSaveSettlement]').css('display', 'none');
                    });
                }
                else {
                    $realeasePaymentControl(function () {
                        $('#divBillDetailsDetails').html('');
                        $('[id$=txtbatchnumber]').val('');
                        $('[id$=btnSaveSettlement]').css('display', 'none');
                    });
                }
            });
        }
       
      function  ShowBatchDetails(ctr){
            var BatchNumber = ctr.id.split('_')[1];
            var data = {
                BatchNumber:BatchNumber
            }
            serverCall('DailyCollectionSettlement.aspx/BindBatchCollection', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    BatchDetails = JSON.parse(response);
                    debugger
                    if (BatchDetails != null && BatchDetails.length>0) {
                        var output = $('#TemplateBatchDetail').parseTemplate(BatchDetails);
                        $realeasePaymentControl(function () {
                            $('#divBatchDetails').html(output).customFixedHeader();
                            $('#oldPatientModel').showModel();
                        });
                    }
                }
                else {
                    $realeasePaymentControl(function () {
                        $('#divBatchDetails').html('');
                        $('#oldPatientModel').hideModel();
                    });
                }
            });
        }

        $closeOldPatientSearchModel = function () {
            $('#oldPatientModel').hideModel();
        }

    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>User Collection Settlement</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From&nbsp;Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="ucFromDate" runat="server" Width="135px" ClientIDMode="Static"
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="80px" ToolTip="Enter Time"
                                TabIndex="2" />
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtFromTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To&nbsp;Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="ucToDate" runat="server" Width="135px" ClientIDMode="Static" ToolTip="Select To Date"
                                TabIndex="2"></asp:TextBox>
                            <cc1:CalendarExtender ID="Todatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="80px" ToolTip="Enter Time"
                                TabIndex="4" />
                            <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtToTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtReportType" runat="server" RepeatDirection="Horizontal"
                                ToolTip="Select Report Type" RepeatColumns="7"> 
                                <asp:ListItem  Value="0">Summarised</asp:ListItem>
                                 <asp:ListItem Selected="True" Value="1">Detailed</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Batch Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtbatchnumber" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                User Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddluser" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlstatus" runat="server" ToolTip="Select Status">
                                <asp:ListItem Selected="True" Value="All">All</asp:ListItem>
                                <asp:ListItem  Value="0">Open</asp:ListItem>
                                <asp:ListItem  Value="1">Closed</asp:ListItem>
                                <asp:ListItem  Value="2">Partially Settled</asp:ListItem>
                                <asp:ListItem  Value="3">Setteled</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12"></div>
                        <div class="col-md-2">
                            <input type="button" onclick="$searchOPDBills(function () { });" value="Search" />
                        </div>
                        <div class="col-md-10"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory billDetailsDiv">
            <div class="row">
                          <div style="text-align:center" class="col-md-6">
                         </div>
						 <div style="text-align:center" class="col-md-6">
							<button type="button" style="width:25px;height:25px;margin-left:5px;float:left" onclick="labelSearch('3',function(){})"  class="circle badge-avilable"></button>
						    <b style="margin-top:5px;margin-left:5px;float:left">Settle</b> 
						</div>
						 <div style="text-align:center" class="col-md-6">
							 <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" onclick="labelSearch('2',function(){})"  class="circle badge-warning"></button>
							 <b style="margin-top:5px;margin-left:5px;float:left">Partial Settle</b> 
						</div>
						 <div style="text-align:center" class="col-md-6">
							 <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background:#fcd588;"  onclick="labelSearch('0',function(){})"  class="circle badge-default"></button>
							 <b style="margin-top:5px;margin-left:5px;float:left">Not Settle</b> 
						</div>
			 </div>
			<div class="row">
				<div  style="overflow:auto;max-height:410px" id="divBillDetailsDetails" class="col-md-24">
				</div>
			</div>
            <div class="row">
                 <div class="row">
                       <div class="col-md-6">
                             <label id="lblTotalAmount" style="display:none;font-weight: bold;" title="Total Amount" >
                             </label>
                        </div>
                        <div class="col-md-4"></div>
                        <div class="col-md-2">
                            <input type="button" id="btnSaveSettlement" style="display:none;" onclick="$SaveDailyCollection(function () { });" value="Settle" />
                        </div>
                        <div class="col-md-6">
                            <label id="lblReceivedAmount" style="display:none;font-weight: bold;" title="Total Received Cash Amount" > 
                            </label>
                        </div>
                        <div class="col-md-6">
                             <label id="lblTotalOutstandingamt" style="display:none;font-weight: bold;" title="Total Outstanding Cash Amount" >
                             </label>
                        </div>
                 </div>
            </div>
		</div>
    </div>
    <script id="templateBillsSearchDetails" type="text/html">
	 <table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdOPDBillsSettlement" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Batch Number</th>
			<th class="GridViewHeaderStyle" scope="col" >User Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Batch StartDate</th>
			<th class="GridViewHeaderStyle" scope="col" >Batch CloseDate</th>
            <th class="GridViewHeaderStyle" scope="col" >Total Amount</th>
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
            <th class="GridViewHeaderStyle" scope="col" >Cash Amount</th>
            <th class="GridViewHeaderStyle" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' scope="col" >Received Cash Amount</th>
            <th class="GridViewHeaderStyle" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' scope="col" >
             <input id="chkIcuAll"   onclick="return SelectAllIcu();" type="checkbox" />
            </th>
            <th class="GridViewHeaderStyle" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' scope="col" >Add Cash Amount</th>
            <th class="GridViewHeaderStyle" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' scope="col" >Outstanding Cash Amount</th>
            <th class="GridViewHeaderStyle" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' scope="col">Remarks</th>
            <th class="GridViewHeaderStyle" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' scope="col">View</th>
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
					<tr  data='<#= JSON.stringify(billsDetails[j]) #>' id="<#=objRow.BatchNumber#>"
                     	 <#
	                    if((billsDetails[j].CashAmount =="0") && (billsDetails[j].ReceivedAmount =="0"))
						  {#>   style="background-color:''" <#} 
							else 
						   {
							    if(billsDetails[j].Settled =="2")
								 {#>  style="background-color:#3CB371" <#} 
							    if(billsDetails[j].Settled =="1")
								 {#> style="background-color:#f89406"  <#} 
							    if(billsDetails[j].Settled=="0")
								 {#> style="background-color:#fcd588" <#} 
						      } 
							 #>
							> 
					<td class="GridViewLabItemStyle" id="tdSNo"><#=j+1#></td>
					<td class="GridViewLabItemStyle" id="tdbatchnumber"  style="text-align:center" ><#=objRow.BatchNumber#></td>
					<td class="GridViewLabItemStyle" id="tdUsername" style="text-align:center" ><#=objRow.Name#></td>
					<td class="GridViewLabItemStyle"  id="tdstartdate" style="text-align:center" ><#=objRow.StartDate#></td>
					<td class="GridViewLabItemStyle" id="tdenddate" style="text-align:center" ><#=objRow.EndDate#></td>
                     <td class="GridViewLabItemStyle" id="tdNetAmount" style="text-align:center" ><#=objRow.NetAmount_1+objRow.NetAmount_2+objRow.NetAmount_3+objRow.NetAmount_4+objRow.NetAmount_5+objRow.NetAmount_6#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center" id="tdSelect" >
					  <img  src="../../Images/Post.gif" alt="" id="imgSelect_<#=objRow.BatchNumber#>" class="paymentSelect" style="cursor:pointer;" onclick="return ShowReport(this);" title="Click To Preview" />
					</td>
                    <td class="GridViewLabItemStyle" id="tdCashAmount" style="text-align:center" ><#=objRow.CashAmount_6+objRow.CashAmount_4+objRow.CashAmount_3+objRow.CashAmount_2+objRow.CashAmount_1#></td>
                    <td class="GridViewLabItemStyle" id="tdReceivedAmount" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' ><#=objRow.ReceivedAmount#></td>
                    <td class="GridViewLabItemStyle"  id="tdcheck" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>'>
                            <input type="checkbox" id="chkIcu" <#if(((objRow.CashAmount)-(objRow.ReceivedAmount))=='0'){#> disabled="disabled"<#} if(objRow.Status=='0'){#> disabled="disabled"<#}#>    onclick="return ShowRadiobutton();" />
                     </td>
                    <td class="GridViewLabItemStyle" id="td4"  style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' >
                        <input type="text" id="txtPaidAmount" onkeyup="myFunction()" value="0" disabled="disabled" />
                    </td>
                    <td class="GridViewLabItemStyle" id="td5"  style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>' ><#=objRow.CashAmount_6+objRow.CashAmount_4+objRow.CashAmount_3+objRow.CashAmount_2+objRow.CashAmount_1-objRow.ReceivedAmount#></td>
                    <td class="GridViewLabItemStyle"  id="tdremarks" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>'>
                        <input type="text" id="txtRemarks"  disabled="disabled"/>
                    </td>
                        <td class="GridViewLabItemStyle" style='<#=billsDetails[0].IsCanSettleBatch=="0"?'display:none':''#>'>
                             <img  src="../../Images/view.GIF" alt="" id="imgShowBatch_<#=objRow.BatchNumber#>"  class="paymentSelect" style="cursor:pointer;" onclick="return ShowBatchDetails(this)"  title="Click To Show Batch" />
                        </td>
					</tr>
		<#}
		#>     
     </table>
	</script>

    <div id="oldPatientModel" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px">
            <div class="modal-header">
                <button type="button" class="close"  onclick="$closeOldPatientSearchModel()"   aria-hidden="true">&times;</button>
                <h4 class="modal-title">Batch Wise Collection Details</h4>
            </div>
            <div class="modal-body">
                <div style="height:200px"  class="row">
                    <div id="divBatchDetails" style="overflow:auto;max-height:200px;" class="col-md-24">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button"  onclick="$closeOldPatientSearchModel()">Close</button>
            </div>
        </div>
    </div>
</div>

    <script id="TemplateBatchDetail" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdBatchDetails" style="width:100%;border-collapse:collapse;">
            <thead>
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Batch Number</th>
			<th class="GridViewHeaderStyle" scope="col" >Collected Amount</th>
			<th class="GridViewHeaderStyle" scope="col" >CollectedDateTime</th>
			<th class="GridViewHeaderStyle" scope="col" >Collected By</th>
            <th class="GridViewHeaderStyle" scope="col" >Remarks</th>
		</tr>
			</thead>
            <#
		var dataLength=BatchDetails.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
		for(var j=0;j<dataLength;j++)
		{
		objRow = BatchDetails[j];
		#>

            	<tr  data='<#= JSON.stringify(BatchDetails[j]) #>' id="<#=objRow.BatchNumber#>" >
                     
					<td class="GridViewLabItemStyle" id="td1"><#=j+1#></td>
					<td class="GridViewLabItemStyle" id="td2"  style="text-align:center" ><#=objRow.BatchNumber#></td>
					<td class="GridViewLabItemStyle" id="td3" style="text-align:center" ><#=objRow.PaidAmount#></td>
					<td class="GridViewLabItemStyle"  id="td6" style="text-align:center" ><#=objRow.PaidAmountDateTime#></td>
					<td class="GridViewLabItemStyle" id="td7" style="text-align:center" ><#=objRow.Name#></td>
                    <td class="GridViewLabItemStyle" id="td8" style="text-align:center" ><#=objRow.Remarks#></td>
					</tr>
            <#}
		#> 
        </table>
    </script>
</asp:Content>

