<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DepartmentReceiving.aspx.cs" Inherits="Design_Lab_DepartmentReceiving" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Department Sample Receiving</b><br />
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
                                Barcode No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBarcodeNo" data-title="Enter Barcode No." onkeyup="if(event.keyCode==13){searchsamples();};" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtUHID" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlLabDepartment" data-title="Select Department"></select>
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
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSampleStatus">
                                <option value="S" selected="selected">Pending</option>
                                <option value="Y">Received</option>
                                <option value="R">Rejected</option>
                            </select>
                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <div class="col-md-8">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightyellow;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                       
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightgreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Recieved</b>
                      
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Reject</b>
                        </div>
                        <div class="col-md-8" style="text-align:center">
                            <input type="button" onclick="searchsamples();" value="Search" id="btnsearch" />
                        </div>
						<div class="col-md-8"></div>
                    </div>                   
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div style="overflow: auto; max-height: 375px" id="divSampleDDetails" class="col-md-24">
                </div>
            </div>
            <div class="row">
                <div class="col-md-8"></div>
                <div style="text-align: right" class="col-md-4">
                    <input type="button" id="btnlogisticreceive" style="display: none" onclick="transfersamples();" value="Transfered Sample" />
                </div>
                <div class="col-md-12" >
                    <input type="button" id="btnreceive" value="Receive" onclick="SampleReceive()" style="display: none" />
                </div>

            </div>
        </div>
    </div>
      <div id="RejectSample" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 500px;max-width:80%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeRejectSample()"   aria-hidden="true">&times;</button>
				<h4 class="modal-title">Reject Sample</h4>
                <span id="spnTestID" style="display:none"></span>
			</div>
			<div class="modal-body">
				 <div class="row">
					 <div  class="col-md-8">
						  <label class="pull-left"> Reject Reason    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-15">
						  <input type="text" id="txtRejectReason"  />
					 </div>
					 				 </div>

				<div style="text-align:center" class="row">
					   <button type="button"  onclick="$rejectsample($('#txtRejectReason').val(),$('#spnTestID').text())">Save</button>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
    <script type="text/javascript">
        function showRejectSample(TestID) {
            $('#spnTestID').text(TestID);
            $('#RejectSample').showModel();
        }
        $closeRejectSample = function () {
            $('#txtRejectReason').val('');
            $('#spnTestID').text('');
            $('#RejectSample').hideModel();
        }
        function $rejectsample(RejectReason, TestID) {
            if (TestID == "") {
                modelAlert("Kindly Refresh The Page");
                return;
            }
            if (RejectReason == "") {
                modelAlert("Please Enter The Reject Reason");
                return;
            }
            serverCall('../Lab/SampleCollectionLab.aspx/SampleRejection', { RejectReason: RejectReason, TestID: TestID }, function (response) {
                if (response == "1") {
                    modelAlert('Sample Reject Successfully', function (response) {
                        $closeRejectSample();
                        searchsamples();
                    });
                    
                    return;
                }
                else {
                    $closeRejectSample();
                    modelAlert(response);
                    return;
                }
            });
        }
        $(function () {
            $bindDepartment(function () { });
        });
        $bindDepartment = function (callback) {
            serverCall('DepartmentReceiving.aspx/BindDepartment', {}, function (response) {
                var $ddlLabDepartment = $('#ddlLabDepartment');
                $ddlLabDepartment.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'ObservationType_ID', textField: 'Name', isSearchAble: true });
                callback($ddlLabDepartment.val());
            });
        }
        function getsearchdata() {
            var dataPLO = new Array();
            dataPLO[0] = $('#ddlLabDepartment').val();
            dataPLO[1] = $('#txtBarcodeNo').val();
            dataPLO[2] = $('#txtUHID').val();
            dataPLO[3] = $('#FrmDate').val();
            dataPLO[4] = $('#ToDate').val();
            dataPLO[5] = $('#ddlSampleStatus').val();
            return dataPLO;
        }
        function searchsamples() {
            var data = getsearchdata();
            serverCall('DepartmentReceiving.aspx/SaveDeptReceive', { data: data }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    TransferDetails = JSON.parse(response);
                    var output = $('#templateDeptRecDetails').parseTemplate(TransferDetails);
                    $('#divSampleDDetails').html(output).customFixedHeader();
                    // $('#btnlogisticreceive').show();
                    $('#btnreceive').show();
                }
                else {
                    $('#divSampleDDetails').html('');
                    $('#btnlogisticreceive').hide();
                    $('#btnreceive').hide();
                    modelAlert("No Record Found");
                }
            });
        }
    </script>
    <script id="templateDeptRecDetails" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdDeptRecDetails" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col">Booking Center</th>
            <th class="GridViewHeaderStyle" scope="col" >Type</th>
            <th class="GridViewHeaderStyle" scope="col" >Barcode No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
			<th class="GridViewHeaderStyle" scope="col" >Age/Gender</th>
			<th class="GridViewHeaderStyle" scope="col" >Department Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px" >Req Date/ Withdraw Date/ Devation</th>
			<th class="GridViewHeaderStyle" scope="col" >Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Reject</th>
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
					<tr style='background-color:<#=objRow.rowcolor#>'>
					<td class="GridViewLabItemStyle textCeneter" id="tdSNo" style="text-align:center"><#=j+1#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="td3"  style="text-align:center" ><#=objRow.BookingCenter#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="td2"  style="text-align:center" ><#=objRow.PatientType#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdBarcodeNo"  style="text-align:center" ><#=objRow.BarcodeNo#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="tdToCenter"  style="text-align:center" ><#=objRow.PatientName#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdPatientID" style="text-align:center"><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdPatientName" style="text-align:center"><#=objRow.Age#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdDeptName" style="text-align:center"><#=objRow.DeptName#></td>
                        <td class="GridViewLabItemStyle textCeneter" id="tdDeptName" style="text-align:center; width:140px"><#=objRow.Samplerequestdate#> / <#=objRow.Acutalwithdrawdate#> / <#=objRow.DevationTime#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdTestName" style="text-align:center"><#=objRow.TestName#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="td1" style="text-align:center">
                          <#if(objRow.IsSampleCollected != 'R' && objRow.Result_Flag == '0'){#>
                        <span title="Click To Reject Sample" style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="showRejectSample('<#=objRow.Test_ID#>')" >R</span>
                        <#} #>
                        </td>
					<td class="GridViewLabItemStyle textCeneter" style="text-align:center">
                        <#if(objRow.IsSampleCollected != 'R' && objRow.Result_Flag == '0'){#>
                        <input type="checkbox" id="chksampletransfered" />
                        <#} #>
					</td>    
                    <td class="GridViewLabItemStyle textCeneter" id="tdTestID" style="display:none;" ><#=objRow.Test_ID#></td>
                        <td class="GridViewLabItemStyle textCeneter" id="tdstatus" style="display:none;" ><#=objRow.IsSampleCollected#></td>
                         <td class="GridViewLabItemStyle textCeneter" id="tdreporttype" style="display:none;" ><#=objRow.Reporttype#></td>
                        <td class="GridViewLabItemStyle textCeneter" id="tdreportnumber" style="display:none;" ><#=objRow.reportnumber#></td>
                        <td class="GridViewLabItemStyle textCeneter" id="tdDescription" style="display:none;" ><#=objRow.Description#></td>
					</tr>
		<#}
		#>     
	 </table>
	</script>
    <script type="text/javascript">
        function call() {
            if ($('#hd').prop('checked') == true) {
                $('#grdDeptRecDetails tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        $(this).closest("tr").find('#chksampletransfered:not(:disabled)').prop('checked', true);
                    }
                });
            }
            else {
                $('#grdDeptRecDetails tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "Header") {
                        $(this).closest("tr").find('#chksampletransfered:not(:disabled)').prop('checked', false);
                    }
                });
            }
        }
        function GetData(param) {
            var dataPLO = new Array();
            $('#grdDeptRecDetails tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "Header") {
                    if ($(this).closest("tr").find('#chksampletransfered').prop('checked') == true) {
                        if (param == "R") {
                            if ($(this).closest("tr").find('#tdstatus').text() == "S") {
                                dataPLO.push($(this).closest("tr").find("#tdTestID").text() + "#" + $(this).closest("tr").find("#tdBarcodeNo").text() + "#" + $(this).closest("tr").find("#tdreporttype").text() + "#" + $(this).closest("tr").find("#tdDescription").text());
                            }
                        }
                        if (param == "T")
                        {
                            dataPLO.push($(this).closest("tr").find("#tdTestID").text() + "#" + $(this).closest("tr").find("#tdreportnumber").text() + "#" + $(this).closest("tr").find("#tdDescription").text());
                        }
                    }
                }
            });
            return dataPLO;
        }
        function SampleReceive() {
            var data = GetData('R');
            if (data.length == 0) {
                modelAlert("Kindly select at least one sample or may be selected sample already received");
                return;
            }
            else {
                serverCall('DepartmentReceiving.aspx/SaveSampleReceive', { data: data }, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        if (response == "1") {
                            modelAlert("Record Saved Successfully", function () {
                                $('#grdDeptRecDetails tr').slice(1).remove();
                                $('#divSampleDDetails').html('');
                                searchsamples();
                            });
                        }
                    }
                    else {
                        modelAlert("Error..");
                        return;
                    }
                });
            }
        }
        function transfersamples() {
            var data = GetData('T');
            if (data.length == 0) {
                modelAlert("Kindly select at least one sample");
                return;
            }
            else {
                serverCall('DepartmentReceiving.aspx/savetranferdata', { data: data }, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        if (response == "1") {
                            modelAlert("Sample Transfered Successfully", function () {
                                $('#grdDeptRecDetails tr').slice(1).remove();
                                $('#divSampleDDetails').html('');
                                searchsamples();
                            });
                        }
                    }
                    else {
                        modelAlert("Error..");
                        return;
                    }
                });
            }
        }
    </script>
</asp:Content>

