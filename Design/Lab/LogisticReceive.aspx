<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="LogisticReceive.aspx.cs" Inherits="Design_Lab_LogisticReceive" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div id="Pbody_box_inventory" style="width:1304px;">
              <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
              <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Logistic Sample Receive</b><br />
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
                              Transferred From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlTransferedCenter" data-title="Select Source Center"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Barcode No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBarcodeNo" data-title="Enter Barcode No."  autocomplete="off" onkeyup="if(event.keyCode==13){searchsamples();};" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                          
                                Dispatch Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtDispatchCode" data-title="Enter Dispatch Code." autocomplete="off" onkeyup="if(event.keyCode==13){searchsamples();};"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
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
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" data-title="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-8"></div>
                        <div class="col-md-8" style="text-align:center;">
                        <input type="button" onclick="searchsamples();" value="Search Logistic Samples" id="btnsearchlogistic" />
                        </div><div class="col-md-8"></div>
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
						<div class="col-md-8"></div>
						<div style="text-align:right;padding-right:10px" class="col-md-8"><input type="button" id="btnlogisticreceive" style="display:none" onclick="logisticreceivesamples();" value="Logistic Sample Receive" /></div>
					</div>
		</div></div>
     <script id="templateTransferDetails" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdTransferDetails" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >From Center</th>
			<th class="GridViewHeaderStyle" scope="col" >To Center</th>
			<th class="GridViewHeaderStyle" scope="col" >Barcode No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
			<th class="GridViewHeaderStyle" scope="col" >Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Dispatch Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Dispatch No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Courier Boy Name</th>
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
					<td class="GridViewLabItemStyle textCeneter" id="tdfromCenter"  style="text-align:center" ><#=objRow.FromCenter#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="tdToCenter"  style="text-align:center" ><#=objRow.ToCenter#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdBarcodeNo" ><#=objRow.BarcodeNo#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdPatientName" ><#=objRow.PatientName#></td>
					<td class="GridViewLabItemStyle  textCeneter" id="tdPatientID" ><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdTestName" ><#=objRow.TestName#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="tdDispatchDate"  style="text-align:center" ><#=objRow.DispatchDate#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="tdDispatchCode"  style="text-align:center" ><#=objRow.DipatchCode#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="td1" ><#=objRow.CourierBoy#></td>
					<td class="GridViewLabItemStyle textCeneter"><input type="checkbox" id="chksampletransfered" /></td>    
                    <td class="GridViewLabItemStyle textCeneter" id="tdslID" style="display:none" ><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="tdTestID" style="display:none" ><#=objRow.Test_ID#></td>
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
        $bindCenter = function (callback) {
            serverCall('SampleTransfer.aspx/bindCenter', {}, function (response) {
                var $ddlTransferedCenter = $('#ddlTransferedCenter');
                $ddlTransferedCenter.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                callback($ddlTransferedCenter.val());
            });
        }
        function getsearchdata() {
            var dataPLO = new Array();
            dataPLO[0] = $('#ddlTransferedCenter').val();
            dataPLO[1] = $('#txtBarcodeNo').val();
            dataPLO[2] = $('#txtDispatchCode').val();
            dataPLO[3] = $('#FrmDate').val();
            dataPLO[4] = $('#ToDate').val();
            return dataPLO;
        }
        function searchsamples() {
            var data = getsearchdata();
            serverCall('LogisticReceive.aspx/SearchInvestigation', { data: data }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    TransferDetails = JSON.parse(response);
                    var output = $('#templateTransferDetails').parseTemplate(TransferDetails);
                    $('#divSampleDDetails').html(output).customFixedHeader();
                    $('#btnlogisticreceive').show();
                }
                else {
                    $('#divSampleDDetails').html('');
                    $('#btnlogisticreceive').hide();
                    modelAlert("No Record Found");
                }
            });
        }
        function GetData() {
            var dataPLO = new Array();
            $('#grdTransferDetails tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "Header") {
                    if ($(this).closest("tr").find('#chksampletransfered').prop('checked') == true) {
                        dataPLO.push($(this).closest("tr").find("#tdslID").text() + "#" + $(this).closest("tr").find("#tdTestID").text());
                    }
                }
            });
            return dataPLO;
        }
        function logisticreceivesamples()
        {
            var data = GetData();
            if (data == "")
            {
                modelAlert("Kindly Select At Least One Sample");
            }
            serverCall('LogisticReceive.aspx/SaveLogistic', { data: data }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    if (response == "1") {
                        modelAlert("Record Saved Successfully");
                        $('#grdTransferDetails tr').slice(1).remove();
                        $('#divSampleDDetails').html('');
                        $('#btnlogisticreceive').hide();
                    }
                }
                else {
                    modelAlert("Error..");
                    return;
                }
            });
        }
    </script>
</asp:Content>

