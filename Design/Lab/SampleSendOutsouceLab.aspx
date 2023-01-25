<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleSendOutsouceLab.aspx.cs" Inherits="Design_Lab_SampleSendOutsouceLab" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <div id="Pbody_box_inventory">
              <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
              <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Sample Send To OutSource Lab</b><br />
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
                            <input type="text" id="txtUHID"  />
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
                    </div>
                     <div class="row">
                        <div class="col-md-8">
                          
                        </div>
                        <div class="col-md-8" style="text-align:center">
                        <input type="button" onclick="searchsamples();" value="Search" id="btnsearch" />
                        </div><div class="col-md-8">  
                               <label class="pull-right">
                            <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:lightyellow;" class="circle"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Pending</b>
                            <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;background-color:Aqua;" class="circle"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Outsourced</b>
                                   </label>
                                   </div>
                    </div>
                </div></div></div>
           	<div class="POuter_Box_Inventory">
			<div class="row">
				<div  style="overflow:auto;max-height:390px" id="divSampleDDetails" ><%-- class="col-md-24"--%>

				</div>
			</div>
              <div class="row"> 

						<div class="col-md-24" style="text-align:center">
                            <input type="button" id="btnoutsource"  value="Send To Outsource Lab" onclick="SaveOutSourceSample()" style="display:none" /> 
						</div>
					</div>
		</div>
       </div>
    <script type="text/javascript">
        function GetData() {
            var dataPLO = new Array();
            $('#grdDeptRecDetails tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "Header") {
                    if ($(this).closest("tr").find('#chksampletransfered').prop('checked') == true) {
                      //  alert($(this).closest("tr").find("#ddloutsourcelab :selected").text());
                        dataPLO.push($(this).closest("tr").find("#tdTestID").text() + "#" + $(this).closest("tr").find("#ddloutsourcelab").val() + "#" + $(this).closest("tr").find("#ddloutsourcelab :selected").text());
                        }
                    }
            });
            return dataPLO;
        }
        function SaveOutSourceSample() {
            var data = GetData();
            if (data.length == 0) {
                modelAlert("Kindly select at least one sample or may be selected sample already received");
                return;
            }
            else {
                serverCall('SampleSendOutsouceLab.aspx/SaveOutsourceSample', { data: data }, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        if (response == "1") {
                            modelAlert('Record Saved Successfully', function (response) {
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
        $(function () {
            $bindDepartment(function () { });
        });
        $bindDepartment = function (callback) {
            serverCall('SampleSendOutsouceLab.aspx/BindDepartment', {}, function (response) {
                var $ddlLabDepartment = $('#ddlLabDepartment');
                if (response !="") { 
                    $ddlLabDepartment.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'ObservationType_ID', textField: 'Name', isSearchAble: true });
                    callback($ddlLabDepartment.val());
                }
            });
        }
        function getsearchdata() {
            var dataPLO = new Array();
            dataPLO[0] = $('#ddlLabDepartment').val();
            dataPLO[1] = $('#txtBarcodeNo').val();
            dataPLO[2] = $('#txtUHID').val();
            dataPLO[3] = $('#FrmDate').val();
            dataPLO[4] = $('#ToDate').val();
            return dataPLO;
        }
        function searchsamples() {
            var data = getsearchdata();
            serverCall('SampleSendOutsouceLab.aspx/SaveDeptReceive', { data: data }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    TransferDetails = JSON.parse(response);
                    var output = $('#templateDeptRecDetails').parseTemplate(TransferDetails);
                    $('#divSampleDDetails').html(output).customFixedHeader();
                    $('#btnoutsource').show();
                    CheckCondition();
                }
                else {
                    $('#divSampleDDetails').html('');
                    $('#btnoutsource').hide();
                    modelAlert("No Record Found");
                }
            });
        }
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
    </script>
      <script id="templateDeptRecDetails" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdDeptRecDetails" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Barcode No</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
			<th class="GridViewHeaderStyle" scope="col" >Age / Gender</th>
			<th class="GridViewHeaderStyle" scope="col" >Department Name</th>

			<th class="GridViewHeaderStyle" scope="col" >Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Outsource Lab<br /><select id="ddlOutSourceHeader" runat="server" clientidmode="Static" onchange="ChangeOutSourceLabType(this)"></select></th>
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
					<td class="GridViewLabItemStyle textCeneter" id="tdfromCenter"  style="text-align:center" ><#=objRow.BarcodeNo#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="tdToCenter"  style="text-align:center" ><#=objRow.PatientName#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdBarcodeNo" style="text-align:center"><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdPatientName" style="text-align:center"><#=objRow.Age#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdPatientID" style="text-align:center"><#=objRow.DeptName#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdTestName" style="text-align:center"><#=objRow.TestName#></td>
                    <td class="GridViewLabItemStyle textCeneter" id="td1" style="text-align:center">
                         <select id="ddloutsourcelab" runat="server" clientidmode="Static"></select>
                        </td>
					<td class="GridViewLabItemStyle textCeneter" style="text-align:center">
                        <#if(objRow.IsSampleCollected != 'R' && objRow.Result_Flag == '0'){#>
                        <input type="checkbox" id="chksampletransfered" />
                        <#} #>
					</td>    
                    <td class="GridViewLabItemStyle textCeneter" id="tdTestID" style="display:none;" ><#=objRow.Test_ID#></td>
                        <td class="GridViewLabItemStyle textCeneter" id="tdstatus" style="display:none;" ><#=objRow.IsSampleCollected#></td>
                        <td class="GridViewLabItemStyle textCeneter" id="tdoutsourcelabid" style="display:none;" ><#=objRow.OutSourceID#></td>
					</tr>
		<#}
		#>     
	 </table>
	</script>
    <script type="text/javascript">
        function ChangeOutSourceLabType(rowid) {
            var OutSourcelab = $(rowid).val();
            jQuery("#grdDeptRecDetails tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    debugger;
                    if ($rowid.find("#chksampletransfered").is(":checked"))
                        jQuery.trim($rowid.find("#ddloutsourcelab").val(OutSourcelab));
                }
            });
        }
        function CheckCondition() {
            jQuery("#grdDeptRecDetails tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    if (jQuery.trim($rowid.find("#tdoutsourcelabid").text()) != '0') {
                        $rowid.find("#ddloutsourcelab").val(jQuery.trim($rowid.find("#tdoutsourcelabid").text()));
                        $rowid.find("#ddloutsourcelab,#chksampletransfered").attr('disabled', 'disabled');
                    }
                    else
                        $rowid.find("#ddloutsourcelab,#chksampletransfered").attr('disabled', false);
                }
            });
        }
    </script>
</asp:Content>

