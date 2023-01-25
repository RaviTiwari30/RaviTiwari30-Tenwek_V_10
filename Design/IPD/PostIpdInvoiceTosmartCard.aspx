<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PostIpdInvoiceTosmartCard.aspx.cs" Inherits="Design_IPD_PostIpdInvoiceTosmartCard" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
	<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
   <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
   <script type="text/javascript" src="../../Scripts/json2.js"></script>
	  <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
	 <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>

	<script type="text/javascript" >
	    $(function () {
	        //  $("#ddlPanelCompany option[value='1$0']").remove();
	        $("#ddlPanelCompany").chosen();
	        $('#ucFromDate').change(function () {
	            ChkDate();
	        });
	        $('#ucToDate').change(function () {
	            ChkDate();
	        });
	    });
	    function ChkDate() {
	        $.ajax({
	            url: "../Common/CommonService.asmx/CompareDate",
	            data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
	            type: "POST",
	            async: true,
	            dataType: "json",
	            contentType: "application/json; charset=utf-8",
	            success: function (mydata) {
	                var data = mydata.d;
	                if (data == false) {
	                    $('#spnErrorMsg').text('To date can not be less than from date!');
	                    $('#btnSearch').attr('disabled', 'disabled');
	                    $("#tb_grdSearch table").remove();
	                    $("#divSearchResult").hide();

	                }
	                else {
	                    $('#spnErrorMsg').text('');
	                    $('#btnSearch').removeAttr('disabled');
	                }
	            }
	        });

	    }

	</script>
   <script type="text/javascript">


       $(function () {
           chkDisptachDate();
       });

       function chkDisptachDate() {
           if ($("#chkDisDate").is(':checked')) {
               $("#txtDisptachDate").removeAttr('disabled');
               $('#rdbStatus input[value="0"]').attr('checked', 'checked');
           }
           else {
               $("#txtDisptachDate").val('').attr('disabled', 'disabled');
           }
       }
       function checkStatus() {
           if ($("#rdbStatus input[type:radio]:checked").val() == "1") {
               $('#chkDisDate').attr('checked', false);
               $('#txtDisptachDate').val('').attr('disabled', 'disabled');
               HideShowButton(0)
           } else {
               HideShowButton(1)
           }

           $("#divSearchResult").hide();
       }

       function HideShowButton(Type) {
           if (Type == 1) {
               $("#btnReSave").show();
               $("#btnSave").hide();
               $('#btnPostedInvoice').show();
           } else {
               $("#btnSave").show();
               $("#btnReSave").hide();
               $('#btnPostedInvoice').hide();
           }
       }

	</script>
	<script type="text/javascript">
		 </script>
	<div id="Pbody_box_inventory">
		 <Ajax:ScriptManager ID="ScriptManager1" runat="server">
	</Ajax:ScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">
			
				<b>Claim Submission IPD<asp:Label ID="lblMaxDispatchNO" runat="server"></asp:Label></b><br />
			<span id="spnErrorMsg" class="ItDoseLblError"></span>
		</div>
		<div class="POuter_Box_Inventory" >
			<div class="row">
				<div class="col-md-1"></div>
				 <div class="col-md-22">
					 <div class="row">
						<div class="col-md-3">
							<label class="pull-left">
							  Bill Date From
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <asp:TextBox ID="ucFromDate" TabIndex="1" runat="server" ClientIDMode="Static"></asp:TextBox>
						<cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
							 Bill Date To
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <asp:TextBox ID="ucToDate" TabIndex="2" runat="server" ClientIDMode="Static"></asp:TextBox>
					   <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
							  UHID
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						  <asp:TextBox ID="txtMRNo" TabIndex="3" runat="server"  ClientIDMode="Static"></asp:TextBox>
						</div>
					 </div>
					 <div class="row">
						<div class="col-md-3">
							<label class="pull-left">
                              Ipd No
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                              <asp:TextBox ID="txtEncounterNo" runat="server" TabIndex="5"  MaxLength="10" ClientIDMode="Static" Visible="false"></asp:TextBox>
						   <asp:TextBox ID="txtIPDNo" runat="server" TabIndex="5"  MaxLength="10" ClientIDMode="Static" ></asp:TextBox>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
							 Docket No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						  <asp:TextBox ID="txtDocketNo" runat="server" TabIndex="6" ClientIDMode="Static"></asp:TextBox>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
							 Panel
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <asp:DropDownList ID="ddlPanelCompany" runat="server"  ClientIDMode="Static" 
							TabIndex="9" ToolTip="Select Panel" >   
						</asp:DropDownList>
						</div>
					 </div>
					 <div class="row">
						<div class="col-md-3">
							<label class="pull-left">
							  Dispatch No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						   <asp:TextBox ID="txtDisptchNo" runat="server" TabIndex="8" ClientIDMode="Static"></asp:TextBox>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
							   Policy No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						  <asp:TextBox ID="txtPolicyNo" TabIndex="11" runat="server" ClientIDMode="Static"></asp:TextBox>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
							  <asp:CheckBox ID="chkDisDate" runat="server" onclick="chkDisptachDate()" TabIndex="12" ClientIDMode="Static" Text="Dispatch Date"  />
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						  <asp:TextBox ID="txtDisptachDate"   TabIndex="13" runat="server" ClientIDMode="Static"></asp:TextBox>
						<cc1:CalendarExtender ID="calDisDate" runat="server" TargetControlID="txtDisptachDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
					 </div>
					 <div class="row">
						<div class="col-md-3" style="display:none">
							<label class="pull-left">
							 Type
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5"  style="display:none">
						  <asp:RadioButtonList ID="rdoOPDIPDList" onclick="chkOPDIPDList()" TabIndex="14" ClientIDMode="Static" runat="server"  RepeatDirection="Horizontal" >
						    <asp:ListItem Selected="True" Text="IPD"  Value="IPD"></asp:ListItem>
                             
						</asp:RadioButtonList>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">
							 Status
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-8">
						<asp:RadioButtonList ID="rdbStatus" onclick="checkStatus()" TabIndex="15" ClientIDMode="Static" runat="server"  RepeatDirection="Horizontal" >
						<asp:ListItem  Text="Dispatched" Value="0"></asp:ListItem>
						<asp:ListItem Selected="True" Text="NotDispatched" Value="1"></asp:ListItem>
						<asp:ListItem Text="ALL" Value="ALL" style="display:none"></asp:ListItem>
						</asp:RadioButtonList>
						</div>
						 <%--<div class="col-md-3">
							<label class="pull-left">
							 
							</label>
							
						</div>--%>
						<div class="col-md-5">
						  
						</div>
					 </div>
					 <div class="row" style="display:none;">
						 <div class="col-md-3">
							<label class="pull-left">
							  Claim No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						 <asp:TextBox ID="txtClaimNo" Style="display:none" TabIndex="4" runat="server"  ClientIDMode="Static"></asp:TextBox>
						</div>
						  <div class="col-md-3">
							<label class="pull-left">
							  CASH/CREDIT
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						  <asp:RadioButtonList ID="rbtCashCredit" TabIndex="10" Style="display:none" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal"  >
						<asp:ListItem Text="CASH" Value="0"></asp:ListItem>
						<asp:ListItem Text="CREDIT" Value="1"  Selected="True"></asp:ListItem>
						<asp:ListItem  Text="BOTH" Value="ALL"></asp:ListItem>
					</asp:RadioButtonList>
						</div>

					 </div>
				 </div>
				 <div class="col-md-1"></div>
			</div>
		  
		</div>
		<div class="POuter_Box_Inventory" style="text-align:center" >     
			<div class="row">

						<div class="col-md-24">
							 <button type="button" style="width:30px;height:30px;float:left;margin-left:5px;background-color:lightgreen" class="circle"></button><b style="float:left;margin-top:5px;margin-left:5px">Dispatched</b> 
							 <button type="button" style="width:30px;height:30px;float:left;margin-left:5px;background-color:#FFB6C1" class="circle"></button><b style="float:left;margin-top:5px;margin-left:5px">Not-Dispatched</b> 
							 <input  style="margin-left: -232px;" type="button" id="btnSearch" tabindex="16" class="ItDoseButton" onclick="bindData()" value="Search" />

                            <asp:Button ID="btnPostedInvoice" runat="server" CssClass="ItDoseButton" ClientIDMode="Static" Text="Posted Report" OnClick="btnPostedInvoice_Click" style="display:none" />
						</div>
						<%--<div class="col-md-10"></div>
						 <div class="col-md-2">
							
						 </div>
						 <div class="col-md-8">
							  <div style="text-align:center" class="col-md-12">
								<button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background:#FFB6C1;"  class="circle"></button>
								<b style="margin-top:10px;margin-left:5px;float:left">Dispatched</b> 
							 </div>
						 <div style="text-align:center" class="col-md-12">
							 <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background:#FF99CC;" class="circle"></button>
							  <b style="margin-top:10px;margin-left:5px;float:left">NotDispatched</b> 
						</div>
						 </div>
						 <div class="col-md-4"></div>--%>
			</div>      
		</div>
		<div style="text-align: center;display:none" id="divSearchResult">
		<div class="POuter_Box_Inventory" >
			<div class="Purchaseheader">
				Search Result                           
				<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" Style="display:none"/></div>           
		
			<div style="text-align:center">
				<table style="border-collapse:collapse">
					<tr>
						<td style="text-align:right;width:15%;display:none">
							Panel&nbsp;Name&nbsp;:&nbsp;
						</td>
						<td style="text-align:left;width:65%">
							<span id="spnPanel" class="ItDoseLabelSp" style="display:none"></span>
						</td>
						<td style="text-align:right;width:10%">
							Type :&nbsp;
						</td>
						<td style="text-align:left;width:10%">
							<span id="spnType" class="ItDoseLabelSp"></span>
						  <span id="spnMaxBillDate" class="ItDoseLabelSp" style="display:none" ></span>  
							<span id="spnIPDNo" class="ItDoseLabelSp" style="display:none" ></span>  
                              <span id="spnInvoiceNo" class="ItDoseLabelSp" style="display:none"></span>
						</td>
					</tr>
				</table>
			</div>
			</div>
		<div class="POuter_Box_Inventory">
		<div id="DispatchOutput" style="max-height: 300px; overflow-x: auto;">
						</div>
			</div>
		<div class="POuter_Box_Inventory" style="text-align: center;" >
			<table  style="width: 100%">
			<tr>
				<td style="width: 50%">
					Dispatch&nbsp;Date&nbsp;:
				
					<asp:TextBox ID="ucDispatchDate" Width="120px" runat="server" ClientIDMode="Static"></asp:TextBox>
				   <%--<cc1:CalendarExtender ID="calDispatchDate" TargetControlID="ucDispatchDate" runat="server" Format="dd-MMM-yyyy"></cc1:CalendarExtender>--%>
				</td>
				<td style="width: 50%;text-align:left">                   
					<input type="button" value="Submit Claim" id="btnSave" class="ItDoseButton" onclick="saveDispatch()" />
                    <input type="button" value="Re-Submit Claim" id="btnReSave" class="ItDoseButton" onclick="ReSubmitClaim()" style="display:none" />

				</td>
			</tr>
		</table>
		</div>
		 </div>
	</div>
	  
	
			
	<script type="text/javascript">
	    $(document).ready(function () {
	        checkStatus();
	    });
	    function pageLoad(sender, args) {
	        if (!args.get_isPartialLoad()) {
	            $addHandler(document, "keydown", onKeyDown);
	        }
	    }
	    function onKeyDown(e) {
	        if (e && e.keyCode == Sys.UI.Key.esc) {
	            if ($find('mpDispatchIPD')) {
	                $find('mpDispatchIPD').hide();
	                $('#rdoReportType [type=radio][value=1]').prop('checked', true);
	            }

	        }
	    }
	    function bindData() {
	        //alert($("#ddlPanelCompany").val());
	        if ($("#txtIPDNo").val() == "" || $("#txtIPDNo").val() == null || $("#txtIPDNo").val() == undefined) {
	            modelAlert("Please Enter IPD No", function () {
	            });
	            return;
	        }
	        if ($("#ddlPanelCompany").val() == "0") {
	            modelAlert("Please Select Panel", function () {
	            });
	            return;
	        }

	        $("#spnIPDNo").text("");

	        $("#btnSearch").val("Searching...").attr('disabled', 'disabled');
	        // $.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
	        $.ajax({
	            type: "POST",
	            url: "PostIpdInvoiceTosmartCard.aspx/GetMessages",
	            data: '{BillFromDate:"' + $("#ucFromDate").val() + '",BillToDate:"' + $("#ucToDate").val() + '", PatientID:"' + $("#txtMRNo").val() + '", ClaimNo:"' + $("#txtClaimNo").val() + '", PolicyNo:"' + $("#txtPolicyNo").val() + '", IPDNo:"' + $("#txtIPDNo").val() + '", DocketNo:"' + $("#txtDocketNo").val() + '", DispatchNo:"' + $("#txtDisptchNo").val() + '", DispatchDate:"' + $("#txtDisptachDate").val() + '", PanelID:"' + $("#ddlPanelCompany").val().split('$')[0] + '",Type:"' + $("#rdoOPDIPDList input[type=radio]:checked").val() + '", Status:"' + $("#rdbStatus input[type=radio]:checked").val() + '", CashCredit:"' + $("#rbtCashCredit input[type=radio]:checked").val() + '", chkDispatchDate:"' + $("#chkDisDate").is(':checked') + '",IsCoverNote:"' + $("#ddlPanelCompany").val().split('$')[1] + '",EncounterNo:0}',
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            success: function (result) {
	                DispatchData = jQuery.parseJSON(result.d);
	                if (DispatchData != null) {
	                    var output = $('#tb_DispatchSearch').parseTemplate(DispatchData);
	                    $('#DispatchOutput').html(output);
	                    $('#DispatchOutput,#divSearchResult').show();
	                    $("#spnErrorMsg").text('');
	                    $("#spnPanel").text(DispatchData[0].Company_Name);
	                    $("#spnInvoiceNo").text(DispatchData[0].panelinvoiceno);

	                    $("#spnType").text($("#rdoOPDIPDList input[type:radio]:checked").val());
	                    $("#spnMaxBillDate").text(DispatchData[0].maxBillDate);
	                    //  $("#ucDispatchDate").val($("#spnMaxBillDate").text());
	                    var today = $("#spnMaxBillDate").text();
	                    $("#ucDispatchDate").datepicker({
	                        changeYear: true,
	                        dateFormat: 'd-M-yy',
	                        changeMonth: true,
	                        buttonImageOnly: true,
	                        minDate: today,

	                        onSelect: function (dateText, inst) {
	                            $("#ucDispatchDate").val(dateText);
	                        }
	                    });
	                    // $.unblockUI();
	                }
	                else {
	                    $('#DispatchOutput').html();
	                    $('#DispatchOutput,#divSearchResult').hide();
	                    $("#spnPanel,#spnType").text('');
	                    $("#spnErrorMsg").text('Record Not Found');
	                    $("#btnSearch").val('Search').removeAttr('disabled');
	                    // $.unblockUI();
	                }
	                $("#btnSearch").val("Search").removeAttr('disabled');
	            },
	            error: function (xhr, status) {
	                $("#spnErrorMsg").text('Error occurred, Please contact administrator');
	                $("#btnSearch").val('Search').removeAttr('disabled');
	                $('#DispatchOutput,#divSearchResult').hide();
	                // $.unblockUI();
	            }
	        });
	    }
	</script>
	<script id="tb_DispatchSearch" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
	style="width:200%; border-collapse:collapse;">		
		<#
		var dataLength=DispatchData.length;
		window.status="Total Records Found :"+ dataLength;     
		for(var j=0;j<dataLength;j++)
		{
		objRow = DispatchData[j];
		#>            
			<# if(j==0)
			{#>
		   <tr id="Header">            
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">
                
                 <# if($("#rdbStatus input[type=radio]:checked").val()==1){#>
                <input type="checkbox" class="chkAll"  onclick="chkAll(this)" />S.No.
                <#}  #>
			</th>
			 <# if($("#ddlPanelCompany").val().split('$')[1]==1){#>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Cover Note No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Cover Note Date</th>
			 <#}  #>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Dispatch Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none">Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">UHID</th>                        
			   <# if($("#rdoOPDIPDList input[type=radio]:checked").val()=="IPD"){#>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">IPD No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">DateOfAdmit</th>          
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">DateOfDischarge</th>
			 <#}  #>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Bill No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Bill Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">OPD Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">IPD Amount</th>

			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Net Bill Amt.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel Payble Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Panel Paid Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px; display:none;">Patient Payble Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px; display:none;">Patient Paid Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px; display:none;">Total Balance Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel Balance Amt.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">Ref_1<input type="checkbox" class="chkRefNo1"  onclick="chkAllRefNo1(this)"/></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">Ref_2<input type="checkbox" class="chkRefNo2" onclick="chkAllRefNo2(this)"/></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Docket No.<input type="checkbox" class="chkDocketNo" onclick="chkAllDocketNo(this)"/></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Dispatch No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Courier<input type="checkbox" class="chkCourier" onclick="chkAllCourier(this)"/></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Remarks<input type="checkbox" class="chkRemarks" onclick="chkAllRemarks(this)"/></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">DispatchID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">TID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">DispatchDayID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ValidityDay</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">PanelID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">AdmitDateTime</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">DischargeDateTime</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">LedgerTransactionNO</th>
				<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">MaxBillDate</th>
               <th class="GridViewHeaderStyle" scope="col" style="width:40px">Invoice No</th>
		</tr>
		<tr id="dispatchHeader" >
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"></th>
			  <# if($("#ddlPanelCompany").val().split('$')[1]==1){#>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"></th>
			 <th class="GridViewHeaderStyle" scope="col" style="width:10px;"></th>
			 <#}  #>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			 <# if($("#rdoOPDIPDList input[type=radio]:checked").val()=="IPD"){#>
			 <th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			  <#}  #>                       
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px; display:none;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px; display:none;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px; display:none;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">
				<input type="text"   style="display:none;width:100px" class="dispatchHeaderRef1" onkeyup="fillAllRef1Data(this.value)"/>
			</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">
				<input type="text"   style="display:none;width:100px" class="dispatchHeaderRef2" onkeyup="fillAllRef2Data(this.value)"/>
			</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">
				 <input type="text"   style="display:none;width:80px" class="dispatchHeaderDocketNo" onkeyup="fillAllDocketNoData(this.value)"/>
			</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">
				<input type="text"   style="display:none;width:100px" class="dispatchHeaderCourier" onkeyup="fillAllCourierData(this.value)"/>
			</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">
				<input type="text"   style="display:none;width:100px" class="dispatchHeaderRemarks" onkeyup="fillAllRemarksData(this.value)"/>
			</th>
		   
		</tr>
	   <#}  #>
					<tr id="<#=j+1#>"  
						<# if(DispatchData[j].Dispatch_No !="")
						{#>                      
						style="background-color:lightgreen" <#} 
						else {#>
						style="background-color:#FFB6C1" <#}
						 #>>                         
					<td class="GridViewLabItemStyle" id="tdSNo">

						<input type="checkbox" id="chkSelectSNo"  onclick="chkSelect(this)" class="chkSelect" <# if($.trim(DispatchData[j].IsClaimPosted) !="0")
						{#>disabled="disabled" style="display:none" <#}else{#> <#} #> />
						<#=j+1#></td>

						 <# if($("#ddlPanelCompany").val().split('$')[1]==1 ){#>
						  <td class="GridViewLabItemStyle" id="tdCoverNoteNo" style="width:140px;" ><#=objRow.CoverNoteNo#></td>
						  <td class="GridViewLabItemStyle" id="tdCoverNoteDate" style="width:140px;"><#=objRow.CoverNoteDate#></td>
						 <#}  #>
					<td class="GridViewLabItemStyle" id="tdDispatchDate"  style="width:40px;text-align:left" ><#=objRow.DispatchDate#></td>
					<td class="GridViewLabItemStyle" id="tdType" style="width:120px;display:none"><#=objRow.TYPE#></td>
					<td class="GridViewLabItemStyle" id="tdPatientID" style="width:140px;"><#=objRow.PatientID#></td>
						 <# if($("#rdoOPDIPDList input[type=radio]:checked").val()=="IPD"){#>
					<td class="GridViewLabItemStyle" id="tdTransNo" style="width:40px;"><#=objRow.TransNo#></td>
					<td class="GridViewLabItemStyle" id="tdDateOfAdmit" style="width:80px;"><#=objRow.DateOfAdmit#></td>
					<td class="GridViewLabItemStyle" id="tdDateOfDischarge" style="width:80px;"><#=objRow.DateOfDischarge#></td>  
						  <#}  #>              
					<td class="GridViewLabItemStyle" id="tdPatientName" style="width:80px;"><#=objRow.PatientName#></td>  
					<td class="GridViewLabItemStyle" id="tdCompany_Name" style="width:80px;"><#=objRow.Company_Name#></td>  
					<td class="GridViewLabItemStyle" id="tdBillNo" style="width:80px;"><#=objRow.BillNo#></td>  
					<td class="GridViewLabItemStyle" id="tdBillDate" style="width:80px;"><#=objRow.BillDate#></td>  
                        <td class="GridViewLabItemStyle" id="tdOPDNetAmount" style="width:80px;"><#=objRow.OPDBillAmount#></td>  
                        <td class="GridViewLabItemStyle" id="tdIPDNetAmount" style="width:80px;"><#=objRow.IPDBillAmount#></td>  
					<td class="GridViewLabItemStyle" id="tdBillAmt" style="width:80px;text-align:right"><#=objRow.NetBillAmt#></td> 
					<td class="GridViewLabItemStyle" id="tdPanelAmt" style="width:80px;text-align:right"><#=objRow.PanelAmt#></td> 
                    <td class="GridViewLabItemStyle" id="tdPanelPaidAmt" style="width:80px;text-align:right"><#=objRow.PanelPaidAmt#></td> 
                    <td class="GridViewLabItemStyle" id="tdPatientPaybleAmt" style="width:80px;text-align:right ;display:none;"><#=objRow.PatientPaybleAmt#></td> 
                    <td class="GridViewLabItemStyle" id="tdPatientPaidAmt" style="width:80px;text-align:right;display:none;"><#=objRow.PatientPaidAmt#></td> 
                    <td class="GridViewLabItemStyle" id="td1" style="width:80px;text-align:right;display:none;"><#=objRow.TotalOutstanding#></td> 
                    <td class="GridViewLabItemStyle" id="tdOutStanding" style="width:80px;text-align:right"><#=objRow.OutStanding#></td> 
					<td class="GridViewLabItemStyle" id="tdRefNo1" style="width:80px;display:none">
						<input type="text" id="txtRefNo1" class="refNo1" style="width:100px"  maxlength="100" value="<#=objRow.Ref1#>"/>
					</td> 
					<td class="GridViewLabItemStyle" id="tdRefNo2" style="width:80px;display:none">
							<input type="text" id="txtRefNo2" maxlength="100" style="width:100px" class="refNo2" value="<#=objRow.Ref2#>"/>
					</td> 
					<td class="GridViewLabItemStyle" id="tdDocket" style="width:140px;">
                          <input type="text" id="txtDocket"  class="docket" style="width:80px" value="<#=objRow.TransNo#>"/>
                    <span style="color: red; font-size: 10px;" class="shat">*</span>
					<span id="getDocketNo" style="display:none"   <# if($.trim(DispatchData[j].DocketNo) !="")
						{#> class="getDocket" <#}else{#> class="notGetDocket" <#} #> ></span> </td>                                                           
						<td class="GridViewLabItemStyle" id="tdDispatch_No"  style="width:80px;text-align:center">
							<span class="spnDispatch_No" >
							<#=objRow.Dispatch_No#></span></td>  
						<td class="GridViewLabItemStyle" id="tdCourier" style="width:80px;">
							<input type="text" id="txtCourier" class="courier" style="width:100px" value="<#=objRow.CourierComp#>"/>
						</td> 
						<td class="GridViewLabItemStyle" id="tdRemarks" style="width:80px;">
							<input type="text" id="txtRemarks" style="width:100px" class="remarks" value="<#=objRow.Remarks#>"/>
						</td> 
						<td class="GridViewLabItemStyle" id="tdDispatchID" style="width:80px;display:none"><#=objRow.DispatchID#></td> 
						<td class="GridViewLabItemStyle" id="tdTransactionID" style="width:80px;display:none"><#=objRow.TransactionID#></td> 
						<td class="GridViewLabItemStyle" id="tdDispatchDayID" style="width:80px;display:none"><#=objRow.DispatchDayID#></td> 
						<td class="GridViewLabItemStyle" id="tdValidityDay" style="width:80px;display:none"><#=objRow.ValidityDay#></td> 
						<td class="GridViewLabItemStyle" id="tdPanelID" style="width:80px;display:none"><#=objRow.PanelID#></td> 
						<td class="GridViewLabItemStyle" id="tdAdmitDateTime" style="width:80px;display:none"><#=objRow.AdmitDateTime#></td> 
						<td class="GridViewLabItemStyle" id="tdDischargeDateTime" style="width:80px;display:none"><#=objRow.DischargeDateTime#></td>                                                
						<td class="GridViewLabItemStyle" id="tdLedgerTransactionNO" style="width:80px;display:none"><#=objRow.LedgerTransactionNO#></td>                                                
						<td class="GridViewLabItemStyle MaxBillDate" id="tdMaxBillDate"  style="width:80px;display:none"><#=objRow.maxBillDate#></td>                                                
						<td class="GridViewLabItemStyle" id="tdGrossAmount"  style="width:80px;display:none"><#=objRow.GrossAmount#></td>                                                
						<td class="GridViewLabItemStyle" id="tdDiscAmt"  style="width:80px;display:none"><#=objRow.discAmt#></td>                                                
						<td class="GridViewLabItemStyle" id="tdPolicyNo"  style="width:80px;display:none"><#=objRow.PolicyNo#></td>                                                
						<td class="GridViewLabItemStyle" id="tdCardNo"  style="width:80px;display:none"><#=objRow.CardNo#></td> 
						<td class="GridViewLabItemStyle" id="tdPanelInvoiceNo"  style="width:80px"><#=objRow.panelinvoiceno#></td> 
					</tr>
		<#}
		#>       
	 </table>
	</script>
	<script type="text/javascript">
	    function docketNo(rowID) {
	        if ($.trim($(rowID).closest('tr').find('#txtDocket').val()) != "")
	            $(rowID).closest('tr').find('#getDocketNo').html('1');
	        else
	            $(rowID).closest('tr').find('#getDocketNo').html('0');
	    }
	    function fillAllRef1Data(rowID) {
	        if ($(".spnDispatch_No").text() == "")
	            $(".refNo1").val(rowID);
	        else
	            $(".refNo1").val();
	    }
	    function fillAllRef2Data(rowID) {
	        if ($(".spnDispatch_No").text() == "")
	            $(".refNo2").val(rowID);
	        else
	            $(".refNo2").val();
	    }
	    function fillAllDocketNoData(rowID) {
	        if ($.trim($(".spnDispatch_No").text()) == "")
	            $(".docket").val(rowID);
	        else
	            $(".docket").val();
	    }
	    function fillAllCourierData(rowID) {
	        if ($.trim($(".spnDispatch_No").text()) == "")
	            $(".courier").val(rowID);
	        else
	            $(".courier").val();
	    }
	    function fillAllRemarksData(rowID) {
	        if ($.trim($(".spnDispatch_No").text()) == "")
	            $(".remarks").val(rowID);
	        else
	            $(".remarks").val();
	    }
	    function chkAllRefNo1(rowID) {
	        if (($(".chkRefNo1").is(':checked'))) {
	            $(".dispatchHeaderRef1").show();
	        }
	        else {
	            $(".dispatchHeaderRef1").val('').hide();
	            $(".refNo1").val('');
	        }
	    }
	    function chkAllRefNo2(rowID) {
	        if ($(".chkRefNo2").is(':checked'))
	            $(".dispatchHeaderRef2").show();
	        else {
	            $(".dispatchHeaderRef2").val('').hide();
	            $(".refNo2").val('');
	        }
	    }
	    function chkAllDocketNo(rowID) {
	        if ($(".chkDocketNo").is(':checked'))
	            $(".dispatchHeaderDocketNo").show();
	        else {
	            $(".dispatchHeaderDocketNo").val('').hide();
	            if ($(".spnDispatch_No").text() == "")
	                $(".docket").val('');
	        }
	    }
	    function chkAllCourier(rowID) {
	        if ($(".chkCourier").is(':checked'))
	            $(".dispatchHeaderCourier").show();
	        else {
	            $(".dispatchHeaderCourier").val('').hide();
	            $(".courier").val('');
	        }

	    }
	    function chkAllRemarks(rowID) {
	        if ($(".chkRemarks").is(':checked'))
	            $(".dispatchHeaderRemarks").show();
	        else {
	            $(".dispatchHeaderRemarks").val('').hide();
	            $(".remarks").val('');
	        }
	    }
	    function chkAll(rowID) {
	        if ($(".chkAll").is(':checked'))
	            $(".chkSelect").prop('checked', 'checked');
	        else
	            $(".chkSelect").prop('checked', false);
	    }
	    function chkSelect(rowID) {
	        //  if ($(".chkSelect").length == $(".chkSelect:checked").length)
	        //      $(".chkAll").attr("checked", "checked");
	        //  else
	        //      $(".chkAll").removeAttr("checked");

	        if (($("#rdoOPDIPDList input[type=radio]:checked").val() == "OPD")) {
	            var CoverNoteNo = $(rowID).closest("tr").find("#tdCoverNoteNo").text();
	            $("#tb_grdSearch tr").each(function () {
	                var rowCoverNoteNo = $(this).closest("tr").closest('tr').find("#tdCoverNoteNo").text();
	                if (rowCoverNoteNo == CoverNoteNo) {
	                    //     if($(rowID).closest("tr").find("#chkSelectSNo").is(":checked"))
	                    //          $(this).closest("tr").closest('tr').find("#chkSelectSNo").prop('checked', 'checked');
	                    //     else
	                    //        $(this).closest("tr").closest('tr').find("#chkSelectSNo").prop('checked', false);
	                }
	            });
	        }

	    }
		 </script>
	<script type="text/javascript">
	    function IPDInvoice(InvoiceNo) {
	        $.ajax({
	            url: "PostIpdInvoiceTosmartCard.aspx/IPDInvoice",
	            data: '{InvoiceNo:"' + InvoiceNo + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                Data = (result.d);
	                if (Data == "1") {
	                    window.open('../common/CommonCrystalReportViewer.aspx');
	                }
	            },
	            error: function (xhr, status) {

	            }
	        });
	    }
	    function saveDispatch() {
	        $("#spnErrorMsg").text('');
	        var DocketCon = 0;
	        if ($(".chkSelect:checked").length >= 1) {
	            $("#tb_grdSearch tr").each(function () {
	                var id = $(this).attr("id");
	                var $rowid = $(this).closest("tr");
	                if ((id != "Header") && (id != "dispatchHeader")) {
	                    if ((jQuery(this).find("#chkSelectSNo").is(":checked")) && ($.trim($rowid.find("#txtDocket").val()) == "")) {
	                        DocketCon = $.trim($rowid.find("#tdSNo").text());
	                        $rowid.find("#txtDocket").focus();
	                        return false;
	                    }
	                }
	            });
	            if ((dispatchData().length > 0) && (DocketCon == "0")) {
	                // $.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
	                $("#btnSave").val("Submitting...").attr('disabled', 'disabled');
	                var resultDispatch = dispatchData();
	                $.ajax({
	                    url: "../Dispatch/Services/Panel_Invoice.asmx/saveDispatch",
	                    data: JSON.stringify({ Dispatch: resultDispatch }),
	                    type: "POST",
	                    contentType: "application/json; charset=utf-8",
	                    timeout: 120000,
	                    async: false,
	                    dataType: "json",
	                    success: function (result) {
	                        if (result.d != "0") {

	                            if (result.d != "") {

	                                serverCall('../OPD/Services/CardIntigration.asmx/SubmitClaimIpd', { PanelId: $("#ddlPanelCompany").val().split('$')[0], InvoiceNo: result.d, IpdNo: $("#txtIPDNo").val() }, function (response) {
	                                    var $responseData = JSON.parse(response);

	                                    if ($responseData.status) {

	                                        modelAlert($responseData.Msg.content.message, function () {
	                                            $("#btnSave").val('Submit Claim').removeAttr('disabled');
	                                            bindData();
	                                        })

	                                    } else {
	                                        $("#btnSave").val('Submit Claim').removeAttr('disabled');
	                                        bindData();
	                                        if ($responseData.Msg.message == null || $responseData.Msg.message == "" || $responseData.Msg.message == undefined) {
	                                            modelAlert($responseData.Msg.error, function () {
	                                                $("#btnSave").val('Submit Claim').removeAttr('disabled');
	                                                bindData();
	                                            })
	                                        } else {
	                                            modelAlert($responseData.Msg.message, function () {
	                                                $("#btnSave").val('Submit Claim').removeAttr('disabled');
	                                                bindData();
	                                            })
	                                        }

	                                    }

	                                });

	                            }
	                            else {

	                                $("#btnSave").val('Submit Claim').removeAttr('disabled');

	                            }

	                        }
	                        else {
	                            $("#spnErrorMsg").text('Error occurred, Please contact administrator');
	                            $("#btnSave").val('Submit Claim').removeAttr('disabled');
	                        }


	                    },
	                    error: function (xhr, status) {
	                        $("#spnErrorMsg").text('Error occurred, Please contact administrator');
	                        $("#btnSave").val('Submit Claim').removeAttr('disabled');
	                        // $.unblockUI();
	                    }
	                });
	            }
	            else
	                $("#spnErrorMsg").text('Please Enter Docket No. at S.No.' + DocketCon);
	        }
	        else
	            $("#spnErrorMsg").text('Please Check Atleast One');
	    }
		 </script>
	<script type="text/javascript">
	    function dispatchData() {
	        var con = 0;
	        var dataDispatch = new Array();
	        var ObjDispatch = new Object();
	        $("#tb_grdSearch tr").each(function () {
	            var id = $(this).attr("id");

	            var $rowid = $(this).closest("tr").closest('tr');
	            if ((id != "Header") && (id != "dispatchHeader")) {

	                if (($(this).find("#chkSelectSNo").is(":checked")) && ($.trim($(this).find("#txtDocket").val()) == "")) {

	                    con = $.trim($(this).find("#tdSNo").text());
	                    // $("#spnErrorMsg").text('Please Enter Docket No. at S.No.'+$.trim($rowid.find("#tdSNo").text()));
	                    $(this).find("#txtDocket").focus();
	                    return con;

	                }

	                else if ($(this).find("#chkSelectSNo").is(":checked")) {
	                    ObjDispatch.Type = $.trim($(this).find("#tdType").text());
	                    ObjDispatch.TransactionID = $.trim($(this).find("#tdTransactionID").text());
	                    ObjDispatch.DateOfAdmission = $.trim($(this).find("#tdAdmitDateTime").text());
	                    ObjDispatch.DateOfDischarge = $.trim($(this).find("#tdDischargeDateTime").text());
	                    ObjDispatch.PName = $.trim($(this).find("#tdPatientName").text());
	                    ObjDispatch.PanelID = $.trim($(this).find("#tdPanelID").text());
	                    ObjDispatch.PanelName = $.trim($(this).find("#tdCompany_Name").text());
	                    ObjDispatch.BillAmount = $.trim($(this).find("#tdBillAmt").text());
	                    ObjDispatch.DispatchDate = $.trim($("#ucDispatchDate").val());
	                    ObjDispatch.DocketNo = $.trim($(this).find("#txtDocket").val());
	                    ObjDispatch.Remarks = $.trim($(this).find("#txtRemarks").val());
	                    ObjDispatch.DispatchDayValidity = Number($(this).find("#tdValidityDay").text());
	                    ObjDispatch.DispatchDayID = Number($(this).find("#tdDispatchDayID").text());
	                    ObjDispatch.CourierComp = $.trim($(this).find("#txtCourier").val());
	                    ObjDispatch.Ref1 = $.trim($(this).find("#txtRefNo1").val());
	                    ObjDispatch.Ref2 = $.trim($(this).find("#txtRefNo2").val());
	                    ObjDispatch.PatientID = $.trim($(this).find("#tdPatientID").text());
	                    ObjDispatch.DispatchID = $.trim($(this).find("#tdDispatchID").text());
	                    ObjDispatch.DispatchNo = $.trim($(this).find("#tdDispatch_No").text());
	                    ObjDispatch.PanelAmt = $.trim($(this).find("#tdPanelAmt").text());
	                    ObjDispatch.LedgerTransactionNO = $.trim($(this).find("#tdLedgerTransactionNO").text());
	                    ObjDispatch.BillDate = $.trim($(this).find("#tdBillDate").text());
	                    ObjDispatch.BillNo = $.trim($(this).find("#tdBillNo").text());
	                    ObjDispatch.GrossAmount = $.trim($(this).find("#tdGrossAmount").text());
	                    ObjDispatch.DiscAmt = $.trim($(this).find("#tdDiscAmt").text());
	                    ObjDispatch.policyNo = $.trim($(this).find("#tdPolicyNo").text());
	                    ObjDispatch.cardNo = $.trim($(this).find("#tdCardNo").text());
	                    ObjDispatch.panelInvoiceNo = $.trim($(this).find("#tdPanelInvoiceNo").text());
	                    ObjDispatch.CoverNoteNo = $.trim($(this).find("#tdCoverNoteNo").text());
	                    ObjDispatch.CoverNoteDate = $.trim($(this).find("#tdCoverNoteDate").text());
	                    ObjDispatch.PanelPaidAmt = $.trim($(this).find("#tdPanelPaidAmt").text());
	                    ObjDispatch.PatientPaybleAmt = $.trim($(this).find("#tdPatientPaybleAmt").text());
	                    ObjDispatch.PatientPaidAmt = $.trim($(this).find("#tdPatientPaidAmt").text());
	                    ObjDispatch.OutStanding = $.trim($(this).find("#tdOutStanding").text());
	                    ObjDispatch.OPDNetAmount = $.trim($(this).find("#tdOPDNetAmount").text());
	                    ObjDispatch.IPDNetAmount = $.trim($(this).find("#tdIPDNetAmount").text());
	                    dataDispatch.push(ObjDispatch);
	                    ObjDispatch = new Object();
	                }

	            }
	        });
	        if (con == "0")
	            return dataDispatch;
	        else
	            return con;
	    }
	</script>
	<script type="text/javascript">
	    $(function () {
	        chkOPDIPDList();
	    });
	    function chkOPDIPDList() {
	        $("#spnErrorMsg").text('');
	        $("#divSearchResult").hide();
	        if ($("#rdoOPDIPDList input[type=radio]:checked").val() == "OPD") {
	            $("#txtIPDNo").val('').attr('disabled', 'disabled');
	            //  $('#ucFromDate').attr('disabled', 'disabled');
	            // $('#ucToDate').attr('disabled', 'disabled');
	            //$("#txtMRNo").val('').removeAttr('disabled');
	            //$("#ddlPanelCompany").prop('selectedIndex', 0).removeAttr('disabled');
	        }
	        else if ($("#rdoOPDIPDList input[type=radio]:checked").val() == "EMG") {
	            $("#txtIPDNo").removeAttr('disabled');
	            //  $('#ucFromDate').attr('disabled', 'disabled');
	            // $('#ucToDate').attr('disabled', 'disabled');
	            //$("#txtMRNo").val('').removeAttr('disabled');
	            //$("#ddlPanelCompany").prop('selectedIndex', 0).removeAttr('disabled');
	        }
	        else {
	            $("#txtIPDNo").removeAttr('disabled');
	            $('#ucFromDate').removeAttr('disabled');
	            $('#ucToDate').removeAttr('disabled');
	            //$("#txtMRNo").val('').attr('disabled', 'disabled');
	            //$("#ddlPanelCompany").chosen('destroy').prop('selectedIndex', 0)
	            //$("#ddlPanelCompany").chosen();
	        }
	    }
	</script>
	<script type="text/javascript">
	    function dispatchReportOPD(InvoiceNo) {
	        $.ajax({
	            url: "Services/Panel_Invoice.asmx/dispatchReport",
	            data: '{InvoiceNo:"' + InvoiceNo + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                var Data = (result.d);
	                if (Data == "1")
	                    window.open('../common/CommonCrystalReportViewer.aspx');
	            },
	            error: function (xhr, status) {

	            }

	        });
	    }
	</script>
	<script type="text/javascript">
	    function detailedBillIPD(TransactionID) {
	        $.ajax({
	            url: "Services/Panel_Invoice.asmx/IPDDetailedBill",
	            data: '{TransactionID:"' + TransactionID + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                Data = (result.d);
	                window.open('../common/CommonCrystalReportViewer.aspx');
	            },
	            error: function (xhr, status) {

	            }

	        });
	    }
	</script>
	<script type="text/javascript">
	    function summaryBillIPD(TransactionID) {
	        $.ajax({
	            url: "Services/Panel_Invoice.asmx/IPDSummaryBill",
	            data: '{TransactionID:"' + TransactionID + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                Data = (result.d);
	                window.open('../common/CommonCrystalReportViewer.aspx');
	            },
	            error: function (xhr, status) {

	            }

	        });
	    }
	</script>
	<script type="text/javascript">
	    function dispatchReportIPD() {
	        if ($('#rdoReportType input[type:radio]:checked').val() == "1") {
	            detailedBillIPD($("#spnIPDNo").text());
	        }
	        else if ($('#rdoReportType input[type:radio]:checked').val() == "2") {
	            summaryBillIPD($("#spnIPDNo").text());
	        }

	        else {
	            detailedBillIPD($("#spnIPDNo").text());
	            summaryBillIPD($("#spnIPDNo").text());
	        }
	        $find('mpDispatchIPD').hide();
	    }
	</script>
	 <cc1:modalpopupextender ID="mpDispatchIPD" runat="server" CancelControlID="btnDispatchIPDCancel"
			DropShadow="true" TargetControlID="btnHide" BackgroundCssClass="filterPupupBackground" BehaviorID="mpDispatchIPD"
			PopupControlID="PnlDispatchIPD" PopupDragHandleControlID="Div2" OnCancelScript="closeIPDDispatch()">
		</cc1:modalpopupextender>
	<asp:Button ID="btnHide" runat="server" style="display:none" />
	<asp:Panel ID="PnlDispatchIPD" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
			Width="440px">
			<div class="Purchaseheader"  >
				<b>Report Type</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 <em ><span style="font-size: 7.5pt">Press esc or click
							<img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeIPDDispatch()"/>
							   
								to close</span></em>
			</div>

			  <table style="width:100%">
				<tr>
					<td style="width:40%;text-align:right">Report Type :&nbsp;
					</td>
					<td style="width:60%;text-align:left">

					  <asp:RadioButtonList ID="rdoReportType" ClientIDMode="Static"  runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
						  <asp:ListItem Selected="True" Text="Detailed" Value="1"></asp:ListItem>
						   <asp:ListItem  Text="Summary" Value="2"></asp:ListItem>
						   <asp:ListItem  Text="Both" Value="3"></asp:ListItem>
					  </asp:RadioButtonList>

					</td>
				</tr>
				<tr>
				   
				   <td colspan="2"  style="text-align:center"  >
						<input id="btnDispatchIPD" class="ItDoseButton" type="button" value="Report" onclick="dispatchReportIPD()" />
						<asp:Button ID="btnDispatchIPDCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
							CausesValidation="false" />
					</td>
				</tr>
			</table>

		</asp:Panel>
	<script type="text/javascript">
	    function closeIPDDispatch() {

	        $('#rdoReportType [type=radio][value=1]').prop('checked', true);
	        $find('mpDispatchIPD').hide();

	    }
	</script>
	<script type="text/javascript">
	    //Both for OPD & IPD
	    function dispatchReport(InvoiceNo) {
	        $.ajax({
	            url: "Services/Panel_Invoice.asmx/dispatchReportAll",
	            data: '{InvoiceNo:"' + InvoiceNo + '",Type:"' + $("#rdoOPDIPDList input[type=radio]:checked").val() + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                var Data = (result.d);
	                if (Data == "1")
	                    window.open('../Dispatch/CommonReport.aspx');
	            },
	            error: function (xhr, status) {

	            }

	        });
	    }

	    function ReSubmitClaim() {
	        var InvoiceNo = $("#spnInvoiceNo").text();
	        if (InvoiceNo == "" || InvoiceNo == '' || InvoiceNo == null || InvoiceNo == undefined) {
	            modelAlert("Please Refresh the page and try Again.");
	            return false;
	        }

	        serverCall('../OPD/Services/CardIntigration.asmx/SubmitClaimIpd', { PanelId: $("#ddlPanelCompany").val().split('$')[0], InvoiceNo: InvoiceNo, IpdNo: $("#txtIPDNo").val() }, function (response) {
	            var $responseData = JSON.parse(response);

	            if ($responseData.status) {

	                modelAlert($responseData.Msg.content.message, function () {
	                    $("#btnReSave").val('Re-Submit Claim').removeAttr('disabled');
	                    bindData();
	                })

	            } else {
	                $("#btnReSave").val('Re-Submit Claim').removeAttr('disabled');
	                bindData();
	                if ($responseData.Msg.message == null || $responseData.Msg.message == "" || $responseData.Msg.message == undefined) {
	                    modelAlert($responseData.Msg.error, function () {
	                        $("#btnReSave").val('Re-Submit Claim').removeAttr('disabled');
	                        bindData();
	                    })
	                } else {
	                    modelAlert($responseData.Msg.message, function () {
	                        $("#btnReSave").val('Re-Submit Claim').removeAttr('disabled');
	                        bindData();
	                    })
	                }
 
	            }

	        });
	    }

		 </script>
</asp:Content>
