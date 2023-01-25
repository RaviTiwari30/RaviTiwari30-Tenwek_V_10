<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleTransfer.aspx.cs" Inherits="Design_Lab_SampleTransfer" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div id="Pbody_box_inventory" style="width:1304px;">
              <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
              <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Sample Transfer / Dispatch</b><br />
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
                              Transferred To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlTransferedCenter" data-title="Select Transfer Center" class="required"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Barcode No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBarcodeNo" data-title="Enter Barcode No." autocomplete="off" onkeyup="if(event.keyCode==13){searchsamples();};" class="required" />
                        </div>
                        <div class="col-md-8" style="text-align:center">
                              <input type="button" onclick="searchsamples();" value="Search Samples" data-title="Search Sample" />
                        </div>
                    </div>
                </div></div>

           </div>
          	<div class="POuter_Box_Inventory">
			<div class="row">
				<div  style="overflow:auto;max-height:410px" id="divSampleDDetails" class="col-md-24">

				</div>
			</div>
              <div class="row">
						<div class="col-md-8"></div>
						<div style="text-align:center" class="col-md-8"><input type="button" id="btnsampletransfer" style="display:none" onclick="$Transferedsamples();" value="Transfered Sample" /></div>
						<div class="col-md-8"></div>
					</div>
		</div>
         <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">Dispatch Samples</div>
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                          <div class="col-md-3">
                            <label class="pull-left">
                              Dispatch Center To
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddldispatchcenter" onchange="Binddispatchsample()" data-title]="Select Dispatch Center" class="required"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            From Date    
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" data-title="Select From Date"></asp:TextBox>
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
                              <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" data-title="Enter To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                        </div>
                    </div></div>
         </div>
     </div>
         <div class="POuter_Box_Inventory">
			<div class="row">
				<div  style="overflow:auto;max-height:410px" id="divdispatchsamples" class="col-md-24">

				</div>
			</div>
             <div class="row co" style="display:none">
                 <div class="col-md-3">
                     <label class="pull-left">Courier Boy Name</label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-5">
                     <input type="text" maxlength="100" id="txtcourierboy" class="requiredField" autocomplete="off" data-title="Enter Courier Boy Name" />
                 </div>
                 <div class="col-md-8"></div>
                 <div class="col-md-8"></div>
             </div>
              <div class="row">
						<div class="col-md-8"></div>
						<div style="text-align:center" class="col-md-8"><input type="button" id="btnsaveDispatchSample" style="display:none" onclick="SaveDispatchsamples();" value="Transfered Sample" /></div>
						<div class="col-md-8"></div>
					</div>
		</div>
     </div>
    <script id="templateTransferDetails" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdTransferDetails" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Sample Collection Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Barcode No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
			<th class="GridViewHeaderStyle" scope="col" >Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" ><input type="checkbox" onclick="call()" id="hd" /></th>
		</tr>
			</thead>
		<#
		var dataLength=TransferDetails.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
	
		for(var j=0;j<dataLength;j++)
		{
		objRow = TransferDetails[j];
		#>
					<tr>
					<td class="GridViewLabItemStyle textCeneter" id="tdSNo"><#=j+1#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdCollDate"  style="text-align:center" ><#=objRow.CollDate#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdBarcodeNo" ><#=objRow.BarcodeNo#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdPatientName" ><#=objRow.PatientName#></td>
					<td class="GridViewLabItemStyle  textCeneter" id="tdPatientID" ><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdTestName" ><#=objRow.TestName#></td>
					<td class="GridViewLabItemStyle textCeneter"><input type="checkbox" id="chksampletransfered" /></td>    
                        <td class="GridViewLabItemStyle textCeneter" style="display:none" id="tdTestID" ><#=objRow.Test_ID#></td>
					</tr>
		<#}
		#>     
	 </table>
	</script>
    <script id="templateDispatchDetails" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdDispatchDetails" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" >From Centre</th>
			<th class="GridViewHeaderStyle" scope="col" >To Center</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
            	<th class="GridViewHeaderStyle" scope="col" >Barcode No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Transfer Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Transfer By</th>
            <th class="GridViewHeaderStyle" scope="col" ><input type="checkbox" onclick="call1()" id="chkd" /></th>
		</tr>
			</thead>
		<#
		var dataLength=DispatchDetails.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
	
		for(var j=0;j<dataLength;j++)
		{
		objRow = DispatchDetails[j];
		#>
					<tr>
					<td class="GridViewLabItemStyle textCeneter" id="td1"><#=j+1#></td>
					<td class="GridViewLabItemStyle textCeneter" id="td2"  style="text-align:center" ><#=objRow.FromCentre#></td>
					<td class="GridViewLabItemStyle textCeneter" id="td3" ><#=objRow.ToCenter#></td>
					<td class="GridViewLabItemStyle textCeneter" id="td4" ><#=objRow.PName#></td>
					<td class="GridViewLabItemStyle  textCeneter" id="td5" ><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle textCeneter" id="td6" ><#=objRow.BarcodeNo#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="td8" ><#=objRow.TestName#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="td9" ><#=objRow.TransferDate#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="td10" ><#=objRow.TransferedBy#></td>
					<td class="GridViewLabItemStyle textCeneter"><input type="checkbox" id="chksampledispatch" /></td>    
                    <td class="GridViewLabItemStyle textCeneter" id="tdID" style="display:none" ><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="tdDTestID" style="display:none" ><#=objRow.Test_ID#></td>
					</tr>
		<#}
		#>     
	 </table>
	</script>
    <script type="text/javascript">
        $(function () {
            $bindCenter(function () { });
        });
        function call() {
            if ($('#hd').prop('checked') == true) {
                $('#grdTransferDetails tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        $(this).closest("tr").find('#chksampletransfered:not(:disabled)').prop('checked', true);
                    }
                });
            }
            else {
                $('#grdTransferDetails tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        $(this).closest("tr").find('#chksampletransfered:not(:disabled)').prop('checked', false);
                    }
                });
            }
        }
        function call1() {
            if ($('#chkd').prop('checked') == true) {
                $('#grdDispatchDetails tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        $(this).closest("tr").find('#chksampledispatch:not(:disabled)').prop('checked', true);
                    }
                });
            }
            else {
                $('#grdDispatchDetails tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        $(this).closest("tr").find('#chksampledispatch:not(:disabled)').prop('checked', false);
                    }
                });
            }
        }
        $bindCenter = function (callback) {
            serverCall('SampleTransfer.aspx/bindCenter', {}, function (response) {
                var $ddlTransferedCenter = $('#ddlTransferedCenter');
                var $ddldispatchcenter = $('#ddldispatchcenter');
                $ddlTransferedCenter.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                $ddldispatchcenter.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                callback({TransferedCenter: $ddlTransferedCenter.val(), DispatchCenter: $ddldispatchcenter.val()});
            });
        }
        //$searchsamples = function (callback) {
            //var data = {
            //    MRNo: String.isNullOrEmpty($('#txtBarcode').val()) ? $('#txtMrNO').val() : $('#txtBarcode').val(),
            //    panelID: $('#ddlPanel').val() == '0' ? '' : $('#ddlPanel').val(),
            //    fromDate: $('#txtSearchFromDate').val(),
            //    toDate: $('#txtSearchToDate').val(),
            //}
        function searchsamples() {
            if ($('#txtBarcodeNo').val() == "") {
                modelAlert("Please Enter The Barcode No.");
                $('#txtBarcodeNo').focus();
                return;
            }
            var BarcodeNo = $('#txtBarcodeNo').val();
            serverCall('SampleTransfer.aspx/SearchInvestigation', { BarcodeNo: BarcodeNo }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    //alert(response);
                    TransferDetails = JSON.parse(response);
                    var output = $('#templateTransferDetails').parseTemplate(TransferDetails);
                    $('#divSampleDDetails').html(output).customFixedHeader();
                    $('#btnsampletransfer').show();
                    $('#txtBarcodeNo').val('');
                }
                else {
                    $('#divSampleDDetails').html('');
                    $('#btnsampletransfer').hide();
                    modelAlert("No Record Found");
                }
            });
        }
        function GetData() {
            if ($('#ddlTransferedCenter').val() == "0")
                return "3";
            var dataPLO = new Array();
            $('#grdTransferDetails tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "Header") {
                    if ($(this).closest("tr").find('#chksampletransfered').prop('checked') == true) {
                        dataPLO.push($(this).closest("tr").find("#tdTestID").text() + "#" + $('#ddlTransferedCenter').val() + "#" + $(this).closest("tr").find("#tdBarcodeNo").text());
                    }
                }
            });
            return dataPLO;
        }
        function $Transferedsamples()
        {
            var data = GetData();
            if (data == "3")
            {
                modelAlert("Please Select the Transfer To Center");
                $('#ddlTransferedCenter').focus();
                return;
            }
            if (data.length == 0) {
                modelAlert("Please Select At Least One Sample");
                return;
            }
            serverCall('SampleTransfer.aspx/SaveSampleTransfer', { data: data }, function (response) {
                debugger;
                if (response == "1") {
                    $('#grdTransferDetails tr').slice(1).remove();
                    $('#btnsampletransfer').hide();
                    modelAlert("Record Saved Successfully");
                }
            });
        }
        function Binddispatchsample()
        {
            var dispatchcenter = $('#ddldispatchcenter').val();
            var fromdate = $('#FrmDate').val();
            var todate = $('#ToDate').val();
            serverCall('SampleTransfer.aspx/SampleDispatchSearch', { dispatchcenter: dispatchcenter, fromdate: fromdate, todate: todate }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                        DispatchDetails = JSON.parse(response);
                        var output = $('#templateDispatchDetails').parseTemplate(DispatchDetails);
                        $('#divdispatchsamples').html(output).customFixedHeader();
                        $('#btnsaveDispatchSample').show();
                        $('.co').show();
                }
                else {
                    $('#divdispatchsamples').html('');
                    $('#btnsaveDispatchSample').hide();
                    $('.co').hide();
                    modelAlert("No Sample Is Pending For Dispatch");
                }
            });
        }
        function GetDispatchData() {
            if ($('#txtcourierboy').val() == "")
                return "3";
            var dataPLO = new Array();
            $('#grdDispatchDetails tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "Header") {
                    if ($(this).closest("tr").find('#chksampledispatch').prop('checked') == true) {
                        dataPLO.push($(this).closest("tr").find("#tdID").text() + "#" + $('#txtcourierboy').val() + "#" + $(this).closest("tr").find("#tdDTestID").text());
                    }
                }
            });
            return dataPLO;
        }
        function SaveDispatchsamples()
        {
            var data = GetDispatchData();
            if (data == "3")
            {
                modelAlert("Please Enter The Name of Courier Boy");
                $('#txtcourierboy').val();
                return;
            }
            if (data == "")
            {
                modelAlert("Kindly Select At Least One Sample");
                return;
            }
            serverCall('SampleTransfer.aspx/SaveSampleDispatch', { data: data }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    if (response == "1") {
                        modelAlert("Sample Transfered Successfully");
                        $('#grdDispatchDetails tr').slice(1).remove();
                        $('#divdispatchsamples').html('');
                        $('#txtcourierboy').val('');
                        $('.co').hide();
                        $('#btnsaveDispatchSample').hide();
                        return;
                    }
                }
                else
                {
                    modelAlert("Error");
                    return;
                }
            });
        }
    </script>
</asp:Content>

