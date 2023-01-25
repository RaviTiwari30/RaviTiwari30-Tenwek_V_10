<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientHistoryDetails.aspx.cs" Inherits="Design_OPD_PatientHistoryDetails" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Visit History</b><br />
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
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientID" onkeyup="if(event.keyCode==13){$Search();};" tabindex="1" maxlength="20" class="requiredField" autocomplete="off" data-title="Enter UHID" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <input type="checkbox" id="cbIgnoreDate" tabindex="2" onclick="checkdate()" />
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" TabIndex="3"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFrom" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                        </div>
                    </div>
                    
                </div>
            </div>
        </div>
             <div class="POuter_Box_Inventory">
        <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" class="ItDoseButton" title="Click to Search Patient" tabindex="5" value="Search" id="btnSearch" onclick="$Search()" />
                        </div>
                        <div class="col-md-11">
                            <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #90ee90;cursor: default;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">IPD</b> 
                            <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:yellowgreen;cursor: default;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">EMG</b>
                            <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:greenyellow;cursor: default;" class="circle"></button>
							  <b style="margin-top:5px;margin-left:5px;float:left">OPD</b> 
                        </div>
                    </div>
                 </div>
         <div class="POuter_Box_Inventory" id="searchResults" style="display:none;">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnPID"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnPName"></span>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                               Age/Gender
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnAgeGender"></span>
                        </div>
                        </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnContactNo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                              Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnAddress"></span>
                        </div>
                         
                        </div>
                    </div>
                </div>
             <div class="row" id="divPatientHistory">
             </div>
             </div>
        </div>
        <script type="text/javascript">
            var checkdate = function () {
                if ($('#cbIgnoreDate').is(':checked'))
                {
                    $('#txtFromDate').removeAttr('disabled');
                }
                else
                    $('#txtFromDate').attr('disabled','disabled');
            }
            $(document).ready(function () {
                $('#txtPatientID').focus();
                checkdate();
            });
                $Search = function () {
                    if ($('#txtPatientID').val() == "") {
                        modelAlert('Please Enter UHID.');
                        $('#txtPatientID').focus();
                        return false;
                    }
                    $PID = $.trim($('#txtPatientID').val());
                    $fromDate = '';
                    $toDate = '';
                    if ($('#cbIgnoreDate').prop('checked')) {
                        $fromDate = $('#txtFromDate').val();
                        $toDate = $('#txtToDate').val();
                    }
                    $('#divPatientHistory').empty();
                    $('#searchResults').hide();
                    $.ajax({
                        url: 'PatientHistoryDetails.aspx/GetPatientHistory',
                        data: '{PID:"' + $PID + '",fromDate:"' + $fromDate + '",toDate:"' + $toDate + '"}',
                        type: 'Post',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (result) {
                            if (result.d != '' && result.d != null) {
                                Data = jQuery.parseJSON(result.d);
                                $bindPatientDetails();
                                var output = $('#tb_Search').parseTemplate(Data);
                                $('#divPatientHistory').html(output).customFixedHeader();
                                $('#searchResults').show();
                            }
                            else {
                                $('#divPatientHistory').empty();
                                $('#searchResults').hide();
                                modelAlert('No Patient History Found');
                            }
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                        }

                    });

                }
                $bindPatientDetails = function () {
                    $('#spnPID').text(Data[0].MRNo);
                    $('#spnPName').text(Data[0].PatientName);
                    $('#spnAgeGender').text(Data[0].AgeGender);
                    $('#spnContactNo').text(Data[0].ContactNo);
                    $('#spnAddress').text(Data[0].Adderss);

                }
                $ViewVisitDetails = function (sender) {
                    $TnxId = $.trim($(sender).closest('tr').find('#tdTnxId').text());
                    $TnxType = $.trim($(sender).closest('tr').find('#tdTnxType').text());
                    $Type = $.trim($(sender).closest('tr').find('#tdType').text());
                    $LTnxNo = $.trim($(sender).closest('tr').find('#tdLTnxNo').text());
                    $Status = 'OUT';
                    if ($.trim($(sender).closest('tr').find('#tdOutDate').text()) == 'Still Admitted')
                        $Status = 'IN';
                    if ($TnxType == 'OPD-APPOINTMENT') {
                        wopen('../CPOE/PrintOut.aspx?TID=' + $TnxId + '&LnxNo=' + $LTnxNo, 'popup1', 940, 550)
                        return;
                    }
                    else if ($TnxType == 'OPD-LAB' || $TnxType=='IPD ADMISSION') {
                        $.ajax({
                            url: 'PatientHistoryDetails.aspx/GetPatientVisitDetails',
                            data: '{TnxId:"' + $TnxId + '",TnxType:"' + $TnxType + '",LTnxNo:"' + $LTnxNo + '"}',
                            type: 'Post',
                            contentType: 'application/json; charset=utf-8',
                            dataType: 'json',
                            success: function (result) {
                                if ($TnxType == 'OPD-LAB') {
                                    if (result.d != '' && result.d != null) {
                                        wopen('../Lab/printLabReport_pdf.aspx?TestID=' + result.d + '&LabType=OPD', 'popup1', 940, 550);
                                    }
                                    else {
                                        modelAlert('Patient Report Not Prepared Yet');
                                    }

                                }
                                else if ($TnxType == "IPD ADMISSION") {
                                    if (result.d != '' && result.d != null) {
                                        wopen('../EMR/printDischargeReport_pdf.aspx?TID=' + $TnxId + '&Status=' + $Status + '&ReportType=PDF', 'popup1', 940, 550);
                                    }
                                    else {
                                        modelAlert('Patient Discharge Summary Not Prepared Yet');
                                    }

                                }

                                else {
                                    modelAlert('No Details Found');
                                }
                            },
                            error: function (xhr, status) {
                                window.status = status + "\r\n" + xhr.responseText;
                            }

                        });
                
                    }
                    //else if ($TnxType == 'OPD-Package') {
                    //    wopen('../common/OPDPackageReceipt.aspx?LedgerTransactionNo='+$LTnxNo+'&IsBill=1&Duplicate=1', 'popup1', 940, 550);
                    //}
                    if ($Type != 'IPD') {
                        if ($TnxType == 'Pharmacy-Issue') {
                            //wopen('../Common/GSTPharmacyReceipt.aspx?LedTnxNo=' + $LTnxNo + '&ReceiptNo=""&DeptLedgerNo=""&Duplicate=1&OutID=&IsBill=1', 'popup1', 940, 550);
                            wopen('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $LTnxNo + '&IsBill=1&Duplicate=1&Type=PHY', 'popup1', 1040, 1000);
                        }
                        else if ($TnxType == 'Pharmacy-Return') {
                            //wopen('../Common/GSTPharmacyReturnReceipt.aspx?LedTnxNo=' + $LTnxNo + '&ReceiptNo=""&DeptLedgerNo=""&Duplicate=1&OutID=&IsBill=1', 'popup1', 940, 550);
                            wopen('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $LTnxNo + '&IsBill=1&Duplicate=1&Type=PHY', 'popup1', 1040, 1000);
                        }
                        else {
                            wopen('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $LTnxNo + '&IsBill=1&Duplicate=1&Type=OPD', 'popup1', 1040, 1000);
                        }
                    }


                }
                function wopen(url, name, w, h) {

                    w += 32;
                    h += 96;
                    var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
                    win.resizeTo(w, h);
                    win.moveTo(10, 100);
                    win.focus();
                }
        </script>
        <script id="tb_Search" type="text/html">
		<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_PtHistory" style="width:100%;border-collapse:collapse;">
			<thead>
			<tr id="Header">
				<th class="GridViewHeaderStyle" scope="col">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col">In Date</th>
                <th class="GridViewHeaderStyle" scope="col">Out Date</th>
                <th class="GridViewHeaderStyle" scope="col">Type</th>
                <th class="GridViewHeaderStyle" scope="col">IPD No</th>
                <th class="GridViewHeaderStyle" scope="col">Visit Details</th>
                <th class="GridViewHeaderStyle" scope="col">Bill No</th>                
                <th class="GridViewHeaderStyle" scope="col">Doctor</th>
				<th class="GridViewHeaderStyle" scope="col">View Details</th>
			</tr>

			</thead>
			<#       
				var dataLength=Data.length;
				window.status="Total Records Found :"+ dataLength;
				var objRow; 
				for(var j=0;j<dataLength;j++)
				{       
					objRow = Data[j];
			#>
			<tbody>
			<tr
				<#if(objRow.Type=="IPD"){#>
					style="background-color:#90ee90"
				<#}
                if(objRow.Type=="EMG"){#>
					style="background-color:yellowgreen"
				<#}
                if(objRow.Type=="OPD"){#>
					style="background-color:greenyellow"
				<#}
                #>
			 > 
				<td class="GridViewLabItemStyle"  ><#=j+1#></td>
                <td class="GridViewLabItemStyle"  ><#=objRow.InDate#></td>
                <td class="GridViewLabItemStyle" id="tdOutDate"  ><#=objRow.OutDate#></td>
                <td class="GridViewLabItemStyle" id="tdType"  ><#=objRow.Type#></td>
                <td class="GridViewLabItemStyle"  ><#=objRow.IPDNo#></td>
                <td class="GridViewLabItemStyle" id="tdTnxType"><#=objRow.TnxType#></td>
                <td class="GridViewLabItemStyle"  ><#=objRow.BillNo#></td>
                <td class="GridViewLabItemStyle"  ><#=objRow.Doctor#></td>
				<td class="GridViewLabItemStyle" style="text-align:center" >
				<img alt="Select" src="../../Images/view.GIF" style="border: 0px solid #FFFFFF;cursor:pointer" onclick="$ViewVisitDetails(this)" />
                 </td>   
				<td class="GridViewLabItemStyle" id="tdTnxId" style="display:none;"><#=objRow.TransactionID#></td>
                <td class="GridViewLabItemStyle" id="tdLTnxNo" style="display:none;"><#=objRow.LTnxNo#></td>                                                              
			</tr>  
                <#}#>         
			</tbody>      
			 
		</table>    
	</script>
</asp:Content>

