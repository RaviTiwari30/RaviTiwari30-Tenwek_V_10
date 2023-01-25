<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="InvoiceSettlement.aspx.cs" Inherits="Design_Dispatch_InvoiceSettlement" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            $('#txtInvoice').bind("keyup", function (e) {
                $("#txtIPDNo").val('');
            });
            $('#txtIPDNo').bind("keyup", function (e) {
                $("#txtInvoice").val('');
            });

            showPatientSearchPopUpModel = function () {
                $('#divPatientSearchPopUpModel').showModel();
            }
            closePatientSearchPopUpModel = function () {
                $('#divPatientSearchPopUpModel').hideModel();
            }
        });

        var $getConversionFactor = function (ctrlId, callback) {
            //CountryID = $(ctrlId).val();
            //serverCall('../Common/CommonService.asmx/GetConversionFactor', { countryID: CountryID }, function (response) {
            //    $(ctrlId).closest('tr').find('#tdCurFactor').text(response);
            //    checkReceiveAmt(ctrlId);
            //});
        }

        var $bindCurrencyDetails = function (ctrlId, callback) {
            CountryID = $(ctrlId).val();
            $(".chkInvoice").attr('checked', 'checked');

            serverCall('../Common/CommonService.asmx/GetConversionFactor', { countryID: CountryID }, function (response) {
                //devendra
                $('#lblCurrencyFactor').text(response);
                $('#lblBalanceSpecific').text(precise_round(parseFloat(Number($('#lblBalance').text()) / Number($('#lblCurrencyFactor').text())), 4));
                $('.ddlCurrency').val(CountryID);
                $('.tdCurFactor').text(response);
                
               // $('.ddlCurrency').change();
                callback(true);
            });
        }
	</script>
	<div id="Pbody_box_inventory">
		<Ajax:ScriptManager ID="ScriptManager1" runat="server">
		</Ajax:ScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center;">

			<b>Panel Invoice Bulk Settlement </b>
			<br />
			<span id="spnErrorMsg" class="ItDoseLblError"></span>
		</div>

		<div class="POuter_Box_Inventory" style="text-align: center;">
			<div class="row">
				<%--<div class="col-md-1"></div>--%>
				<div class="col-md-24">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Invoice No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtInvoice" runat="server"  CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
							
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								IPD/Bill No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtIPDNo" runat="server"  ClientIDMode="Static" MaxLength="30"></asp:TextBox>
							
							<asp:Label ID="lblIPDNo" runat="server" ClientIDMode="Static" Style="display: none"></asp:Label>
						</div>
						<div class="col-md-2">
							  <input id="btnSearch" type="button" onclick="panelInvoiceSearch()" value="Search" class="ItDoseButton" style="width: 60px;" />
						</div>
						<div class="col-md-3">
							 <input type="button" id="btnOldPatient" class="ItDoseButton" value="Old Patient" />
						</div>
						 <div class="col-md-3">
                            <asp:Button ID="btnReport" style="display:none;" Text="Un-Allocated Report" runat="server" OnClick="btnReport_Click" /></div>
					</div>
				</div>
				<%--<div class="col-md-1"></div>--%>
			</div>

		</div>
		<div class="POuter_Box_Inventory" id="hideSearch" style="display: none">

			<div class="Purchaseheader">
				Search Result
			</div>
			<div id="InvoiceDate" style="max-height: 350px; overflow: auto;">
			</div>
		</div>
	 <div class="POuter_Box_Inventory" id="divInvoiceSearch" style="display: none">
        <div class="row">
           <%-- <div class="col-md-1"></div>--%>
            <div class="col-md-24">
                <div class="row">

                    <div class="col-md-3">
                        <label class="pull-left">
                            Invoice No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblInvoiceNo" ClientIDMode="Static" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Invoice Amt.(Base)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblInvoiceAmt" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                    </div>
                     <div class="col-md-3">
                        <label class="pull-left">
                            Pre.Rec.Amt.(Base)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblPreviousReceivedAmt" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                    </div>
                </div>
             
                <div class="row">
                   
                    <div class="col-md-3">
                        <label class="pull-left">
                            Pre.TDS Amt.(Base)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblPreviousTDSAmt" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Pre.Write-Off(Base)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblPreviousWriteOffAmt" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                    </div>
                     <div class="col-md-3">
                        <label class="pull-left">
                            Pre.Deduct.(Base)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblPreviousDeductionAmt" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                         <asp:RadioButtonList ID="rdoType" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" Style="display: none;">
                            <asp:ListItem Selected="True" Value="0">Final Settlement</asp:ListItem>
                            <asp:ListItem Value="1">On Account</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>

                <div class="row">
                     <div class="col-md-3">
                        <label class="pull-left">
                            Currency
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlInvCurrency" CssClass="ddlInvCurrency" onchange="$bindCurrencyDetails(this,function(){ reDistributionsOfAmount(function () { }); });" ClientIDMode="Static" runat="server" > </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Currency Factor
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblCurrencyFactor" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static">1.0000</asp:Label>
                    </div>

                    <div class="col-md-3">
                        <label class="pull-left">
                            Rec.Amt.(Specific)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtReceivedAmt" ClientIDMode="Static" onlynumber="12"  decimalplace="4" runat="server" Text="0" CssClass="ItDoseTextinputNum requiredField" onkeyup="distributeAmount(this,1,function(){});" AutoCompleteType="Disabled" />
                     <%--   <cc1:filteredtextboxextender id="ftbRecAmt" runat="server" targetcontrolid="txtReceivedAmt" FilterMode="ValidChars"
                            ValidChars=".0987654321">
						    </cc1:filteredtextboxextender>--%>
                    </div>
                </div>
                <div class="row">
                     <div class="col-md-3">
                        <label class="pull-left">
                            TDS Amt.(Specific)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtTDSAmt" ClientIDMode="Static" runat="server" Text="0"  onlynumber="12"  decimalplace="4" onkeyup="distributeAmount(this,2,function(){});" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled" />
                       <%-- <cc1:filteredtextboxextender id="ftbTDSAmt" runat="server" targetcontrolid="txtTDSAmt" validchars=".0987654321"> </cc1:filteredtextboxextender>--%>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Write-Off(Specific)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtWriteOff" ClientIDMode="Static" runat="server" Text="0"  onlynumber="12"  decimalplace="4" onkeyup="distributeAmount(this,3,function(){});" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled" />
                       <%-- <cc1:filteredtextboxextender id="ftbtxtWriteOff" runat="server" targetcontrolid="txtWriteOff" validchars=".0987654321"> </cc1:filteredtextboxextender>--%>
                    </div>
                   <div class="col-md-3">
                        <label class="pull-left">
                            Deduction(Specific)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtDeduction" ClientIDMode="Static" runat="server" Text="0" onlynumber="12"  decimalplace="4" onkeyup="distributeAmount(this,4,function(){});" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled" ></asp:TextBox>
                      <%--  <cc1:filteredtextboxextender id="ftbDeduction" runat="server" targetcontrolid="txtDeduction" validchars=".0123456789"></cc1:filteredtextboxextender>--%>
                    </div>
                    
                </div>


                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Payment Mode
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlPaymentMode" CssClass="ddlSettPaymentMode" ClientIDMode="Static" onchange="onPaymentModeChange(this)" runat="server" > </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Bank
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlBank" runat="server" ClientIDMode="Static" onchange="onBankChange(this);" CssClass="requiredField">
                        </asp:DropDownList>
                    </div>
                   
                    
                    <div class="col-md-3">
                        <label class="pull-left">
                           Ref. No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtRefNo" ClientIDMode="Static" runat="server" CssClass="classSettleChequeNo" onkeyup="onRefNoChange(this);"  AutoCompleteType="Disabled" ></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtRefDate" ClientIDMode="Static" runat="server" CssClass="requiredField" onchange="onRefDateChange(this);" ></asp:TextBox>
                        <cc1:calendarextender runat="server" id="dtEntryDate" targetcontrolid="txtRefDate" format="dd-MMM-yyyy" />
                    </div>
                   
                     <div class="col-md-3">
                        <label class="pull-left">
                            Machine
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" >
                        <asp:DropDownList runat="server" ID="ddlSwapeMachine" CssClass="ddlMachineBank"  onchange="onSwapeMachineChange(this);" ClientIDMode="Static" > </asp:DropDownList>
                    </div>
                    <div class="col-md-8"></div>
                </div>

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Balance (Specific)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblBalanceSpecific" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Balance (Base)
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblBalance" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                    </div>
                    <div class="col-md-8"></div>
                </div>
                <div class="row"  style="display:none;">
                    <div class="col-md-3">
                        <input type="button" id="btnCalculate" onclick="reDistributionsOfAmount(function () { });" value="Calculate" class="ItDoseButton" />
                    </div>
                    <div class="col-md-5">
                    </div>
                     <div class="col-md-3">
                        <label class="pull-left">
                            Settlement Type
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" >
                        <asp:DropDownList runat="server" ID="ddlSettlementType" Width="120px" ClientIDMode="Static" onchange="onSettelmentTypeChange(this)">
                            <asp:ListItem Text="" Value="1"></asp:ListItem>
                            <asp:ListItem Text="On Account" Value="2"></asp:ListItem>
                        </asp:DropDownList>

                        <asp:DropDownList runat="server" ClientIDMode="Static" ID="ddlAccountVoucher" onchange="onAccountVoucherChange(this)" Enabled="false" Width="250px"></asp:DropDownList>

                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                        </label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-5">
                        <span id="spnInvoiceDate" style="display: none;"></span>
                        <span id="spnPanelID" style="display: none;"></span>
                        <span id="spnPatientType" style="display: none;"></span>
                    </div>
                </div>
                <div class="row" id="trOnAccountDetail" style="display: none;">
                    <div class="col-md-24">
                        <span id="spnOnAccountDetail" class="patientInfo" style="font-weight: bold;"></span>
                    </div>
                </div>
                <div class="row" id="tabTotal" style="background-color: #f5ee15bd;border: 1px solid black; font-weight:bold">
                    <div class="col-md-4" style="color:red">
                        <label class="pull-left" >
                            Mis-Match Bills Vs Total
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                      <div class="col-md-4">
                        Rec.Amt. : <span id="spnReceivedAmt" class="patientInfo" style="font-weight: bold;">0</span>
                    </div>
                     <div class="col-md-4">
                       TDS : <span id="spnTDSAmt" class="patientInfo" style="font-weight: bold;">0</span>
                    </div>
                      <div class="col-md-4">
                       Write-Off : <span id="spnWriteOffAmt" class="patientInfo" style="font-weight: bold;">0</span>
                    </div>
                    <div class="col-md-4">
                        Deduction : <span id="spnDeductionAmt" class="patientInfo" style="font-weight: bold;">0</span>
                    </div>
                    <div class="col-md-4">
                       Total : <span id="spnBalanceAmt" class="patientInfo" style="font-weight: bold;">0</span>
                    </div>
                </div>
            </div>
        </div>

    </div>
		<div class="POuter_Box_Inventory" id="divDetailOutPut" style="display: none">
            <div class="row" style="font-weight:bold;">
               <div class="col-md-2"></div>
               <div class="col-md-1" style="border: 2px solid black; background-color:#FDE76D; height:20px;"></div>
                <div class="col-md-4">Partially Settlement</div>
               <div class="col-md-1" style="border: 2px solid black; background-color:#FFB6C1;height:20px;"></div>
                <div class="col-md-4">Fully Settlement</div>
               <div class="col-md-1" style="border: 2px solid black; background-color:#fa0d0d;height:20px;"></div>
                <div class="col-md-4">Wrong Settlement</div>
               <div class="col-md-1" style="border: 2px solid black; background-color:transparent;height:20px;"></div>
                <div class="col-md-4">No Settlement</div>
                <div class="col-md-2"></div>
            </div>
			<div id="invoiceDetailOutput" style=" max-height:300px; overflow-x: auto;">
			</div>
		</div>
		<div class="POuter_Box_Inventory" id="divSave" style="display: none; text-align: center">
			<input id="btnSave" type="button" value="Save" onclick="saveInvoice()" class="save margin-top-on-btn" style="display: none" />
		</div>
	</div>
	<script type="text/javascript">
	    $(function () {
	        $("#txtInvoice").focus();
	        $bindPanel(function () { });
	    });
	    function hideInvoiceDetail() {

	        $("#lblInvoiceNo,#lblInvoiceAmt,#spnInvoiceDate,#spnPanelID").text('');
	        $("#txtReceivedAmt,#txtTDSAmt,#txtWriteOff,#txtDeduction,#txtRefNo,#txtRefDate").val('');
	        $("#divDetailOutPut,#divSave,#btnSave,#divInvoiceSearch").hide();
	        $("#ddlBank,#ddlPaymentMode").prop('selectedIndex', 0);
	        $("#lblBalance,#lblPreviousReceivedAmt,#lblPreviousTDSAmt,#lblPreviousWriteOffAmt,#lblPreviousDeductionAmt").text('0');
	        $('#lblBalanceSpecific').text(precise_round(parseFloat(Number($('#lblBalance').text()) / Number($('#lblCurrencyFactor').text())), 4));

	        $('#invoiceDetailOutput,#divSearchResult,#divDetailOutPut,#tabTotal').hide();
	        $("#btnSave").attr('disabled', 'disabled');
	        $("#lblIPDNo").text('');
	        paymentMode();
	    }
	    function panelInvoiceSearch() {
	        if (($.trim($("#txtInvoice").val()) == "") && ($.trim($("#txtIPDNo").val()) == "")) {
	            $("#spnErrorMsg").text('Please Enter Invoice No. OR IPD No.');
	            $("#txtInvoice").focus();
	            $('#InvoiceDate,#hideSearch,#divInvoiceSearch').hide();
	            hideInvoiceDetail();
	            return;
	        }
	        // $.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
	        $.ajax({
	            url: "Services/Panel_Invoice.asmx/panelInvoiceSearch",
	            data: '{InvoiceNo: "' + $("#txtInvoice").val() + '",IPDNo: "' + $("#txtIPDNo").val() + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            dataType: "json",
	            success: function (result) {
	                invoiceData = jQuery.parseJSON(result.d);
	                if (invoiceData == null) {
	                    $("#spnErrorMsg").text('');
	                    $('#InvoiceDate,#hideSearch,#divInvoiceSearch,#invoiceDetailOutput,#divSave,#divDetailOutPut').hide();
	                    // $.unblockUI();

	                    $("#spnErrorMsg").text('Record Not Found');
	                    $("#lblIPDNo").text('');
	                    return;
	                }
	                else {
	                    var output = $('#tb_InvoiceDate').parseTemplate(invoiceData);
	                    $('#InvoiceDate').html(output);
	                    $('#InvoiceDate,#hideSearch').show();
	                    $("#spnErrorMsg").text('');
	                    // $.unblockUI();
	                }
	                hideInvoiceDetail();
	                if ($.trim($("#txtIPDNo").val()) != "")
	                    $("#lblIPDNo").text($.trim($("#txtIPDNo").val()));
	                else
	                    $("#lblIPDNo").text('');

	            },
	            error: function (xhr, status) {

	                $("#spnErrorMsg").text('Error occurred, Please contact administrator');
	                // $.unblockUI();
	            }
	        });
	    }
	    function hideAllData() {


	    }
	</script>
	<script id="tb_InvoiceDate" type="text/html">

   <table class="GridViewStyle" cellspacing="0" rules="all" border="1"  
	style="border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Invoice No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:220px;">Panel Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Invoice Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:187px;">Created By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Panel Payble</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:100px; display:none;">Invoice Amt.</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Patient Payble</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Panel Paid</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Patient Paid</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Balance Amt.</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none"> </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Type </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> </th>
</tr>
	   <#
			  var dataLength=invoiceData.length;
			  var objRow; 
			  for(var j=0;j<dataLength;j++)
			   {                 
				  objRow = invoiceData[j];   
		#>
					<tr id="<#=objRow.InvoiceNo#>">
<td class="GridViewLabItemStyle"><#=j+1#></td>

<td id="tdInvoiceNo"  class="GridViewLabItemStyle" style="width:150px"><#=objRow.PanelInvoiceNo#></td>
<td id="tdPanelName"  class="GridViewLabItemStyle" style="width:200px"><#=objRow.PanelName#></td>
<td id="tdInvoiceDate"  class="GridViewLabItemStyle" style="text-align:center"><#=objRow.DATE#></td>
<td id="tdInvoiceCreatedBy"  class="GridViewLabItemStyle" style="width:150px"><#=objRow.InvoiceCreatedBy#></td>
<td id="tdInvoicePanelPaybleAmt"  class="GridViewLabItemStyle" style="width:100px;text-align:right"><#=objRow.PanelPaybleAmt#></td>
 <td id="tdInvoiceAmt"  class="GridViewLabItemStyle" style="width:100px;text-align:right; display:none;"><#=objRow.InvoiceAmt#></td>
<td id="tdInvoicePatientPaybleAmt"  class="GridViewLabItemStyle" style="width:100px;text-align:right"><#=objRow.PatientPaybleAmt#></td>
<td id="tdInvoicePanelPaidAmt"  class="GridViewLabItemStyle" style="width:100px;text-align:right"><#=objRow.PanelPaidAmt#></td>
<td id="tdInvoicePatientPaidAmt"  class="GridViewLabItemStyle" style="width:100px;text-align:right"><#=objRow.PatientPaidAmt#></td>
<td id="tdInvoiceBalanceAmt"  class="GridViewLabItemStyle" style="width:100px;text-align:right"><#=objRow.BalanceAmt#></td>
<td id="tdPanelID"  class="GridViewLabItemStyle" style="width:100px;text-align:right;display:none"><#=objRow.PanelID#></td>
<td id="tdPatientType"  class="GridViewLabItemStyle" style="width:60px;text-align:center;"><#=objRow.Type#></td>
					   
<td class="GridViewLabItemStyle"><img id="view" style="cursor:pointer" src="../../Images/view.GIF" onclick="bindInvoice(this);"/></td>
</tr>
			<#}#>
	 </table>    
	</script>  
	<script type="text/javascript">
	    function checkForSecondDecimal(sender, e) {
	        formatBox = document.getElementById(sender.id);
	        strLen = sender.value.length;
	        strVal = sender.value;
	        hasDec = false;
	        e = (e) ? e : (window.event) ? event : null;
	        if (e) {
	            var charCode = (e.charCode) ? e.charCode :
								((e.keyCode) ? e.keyCode :
								((e.which) ? e.which : 0));
	            if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
	                for (var i = 0; i < strLen; i++) {
	                    hasDec = (strVal.charAt(i) == '.');
	                    if (hasDec)
	                        return false;
	                }
	            }
	        }
	        return true;
	    }
	    function precise_round(num, decimals) {
	        return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
	    }
	</script>
	<script type="text/javascript">
	    function bindInvoice(rowID) {
	        $("#txtReceivedAmt,#txtTDSAmt,#txtWriteOff,#txtDeduction").val(0);
	        $("#divInvoiceSearch").show();
	        $("#lblInvoiceNo").text($(rowID).closest('tr').find("#tdInvoiceNo").text());
	        $("#lblInvoiceAmt").text($(rowID).closest('tr').find("#tdInvoiceAmt").text());
	        $("#spnInvoiceDate").text($(rowID).closest('tr').find("#tdInvoiceDate").text());
	        $("#spnPanelID").text($(rowID).closest('tr').find("#tdPanelID").text());
	        $("#spnPatientType").text($(rowID).closest('tr').find("#tdPatientType").text());
	        // paymentMode(); 

	        // bindSettelmentType();//
	        bindInvoiceData();
	        bindSettleBank();
	        $getCurrencyDetails(function () { });
	        $bindPaymentModePanelWise(function () {
	            $('#ddlPaymentMode').change();
	        });


	        $("#divDetailOutPut,#divSave,#btnSave").show();

	        //var today = $("#spnInvoiceDate").text();

	        //$("#txtRefDate").datepicker({
	        //    changeYear: true,
	        //    dateFormat: 'dd-M-yy',
	        //    changeMonth: true,
	        //    buttonImageOnly: true,
	        // //   minDate: today,

	        //    onSelect: function (dateText, inst) {
	        //        $("#txtRefDate").val(dateText);
	        //    }
	        //});
	        $("#txtReceivedAmt").focus();
	    }
	</script>
	<script type="text/javascript">

	    var distributeAmount = function (ctrlID, type, callback) {
	        debugger;

	        //  $(".chkInvoice").attr('checked', 'checked');

	        var TRec = Number($(ctrlID).val());
	        var BalanceActual = 0;
	        var CurrencyFactor = Number($('#lblCurrencyFactor').text());
	        var isBillSelected = 0;
	        $("#tb_grdSearch tr").each(function () {
	            var id = $(this).closest("tr").attr("id");
	            if (id != "invoiceHeader") {
	                if ($(this).closest('tr').find("#chk").is(':checked')) {
	                    BalanceActual = BalanceActual + Number($(this).closest('tr').find("#spnBalanceAmount").text());
	                    isBillSelected = 1;
	                }
	            }
	        });

	        //if (isBillSelected == 0)
	        //{
	        //    modelAlert('Please Check Atleast One Bill To Settle');
	        //    $(ctrlID).val('0');
	        //    return false;
	        //}
	        var distributionPer = (TRec * 100) / (BalanceActual / CurrencyFactor);

	        $("#tb_grdSearch tr").each(function () {
	            var id = $(this).closest("tr").attr("id");
	            if (id != "invoiceHeader") {
	                if ($(this).closest('tr').find("#chk").is(':checked')) {
	                    var OutStanding = Number($(this).closest('tr').find("#spnBalanceAmount").text());
	                    var recAmt = precise_round(parseFloat((distributionPer * (OutStanding / CurrencyFactor)) / 100), 4);
	                    if (type == 1) {
	                        $(this).closest('tr').find("#txtReceiveAmtSpecific").val(recAmt);
	                        checkReceiveAmtSpecific($(this).closest('tr').find("#txtReceiveAmtSpecific"));
	                    }
	                    else if (type == 2) {
	                        $(this).closest('tr').find("#txtTDSSpecific").val(recAmt);
	                        checkTDSAmtSpecific($(this).closest('tr').find("#txtTDSSpecific"));
	                    }
	                    else if (type == 3) {
	                        $(this).closest('tr').find("#txtWriteOffAmtSpecific").val(recAmt);
	                        checkWriteOffAmtSpecific($(this).closest('tr').find("#txtWriteOffAmtSpecific"));
	                    }
	                    else if (type == 4) {
	                        $(this).closest('tr').find("#txtAcceptableDeductionSpecific").val(recAmt);
	                        checkAcceptableDeductionAmtSpecific($(this).closest('tr').find("#txtAcceptableDeductionSpecific"));
	                    }
	                }
	                else {
	                    $(this).closest('tr').find('#txtReceiveAmt,#txtReceiveAmtSpecific').val(0);
	                    $(this).closest('tr').find('#txtTDS,#txtTDSSpecific').val(0);
	                    $(this).closest('tr').find('#txtWriteOffAmt,#txtWriteOffAmtSpecific').val(0);
	                    $(this).closest('tr').find('#txtAcceptableDeduction,#txtAcceptableDeductionSpecific').val(0);
	                    checkReceiveAmtSpecific($(this).closest('tr').find("#txtReceiveAmtSpecific"));
	                }
	            }
	        });

	        getBalanceAmount(function () { });
	        callback(true);
	    }
	</script>
	<script type="text/javascript">
	    $(document).ready(function () {
	        $("#rdoType input[type=radio]").attr('disabled', 'disabled');
	        //  panelInvoiceSearch();

	    });
	    $(function () {
	        $("#<%=ddlPaymentMode.ClientID %>").change(function () {
	            paymentMode();
	        });
	    });
	    function paymentMode() {
	    }
	</script>
	<script type="text/javascript">
	    function bindInvoiceData() {
	        var invoiceNo = $("#lblInvoiceNo").text();
	        var IPDNo = "";
	        if ($.trim($("#lblIPDNo").text()) != "") {
	            invoiceNo = "";
	            IPDNo =$.trim($("#lblIPDNo").text());
	        }
	        else {
	            IPDNo = "";
	        }
	        $.ajax({
	            url: "Services/Panel_Invoice.asmx/bindInvoiceData",
	            data: '{invoiceNo:"' + invoiceNo + '",IPDNo:"' + IPDNo + '"}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                invoiceDetail = jQuery.parseJSON(result.d);

	                if (invoiceDetail != null) {
	                    var output = $('#tb_invoiceDetail').parseTemplate(invoiceDetail);
	                    $('#invoiceDetailOutput').html(output);
	                    $('#invoiceDetailOutput,#divSearchResult,#divDetailOutPut,#tabTotal').show();
	                    $('#lblPreviousReceivedAmt').text(invoiceDetail[0].ReceivedAmount);
	                    $('#lblPreviousTDSAmt').text(invoiceDetail[0].PreTDSAmount);
	                    $('#lblPreviousWriteOffAmt').text(invoiceDetail[0].PreWriteOffAmount);
	                    $('#lblPreviousDeductionAmt').text(invoiceDetail[0].PrededucationAmt);
	                    var dec = parseFloat($('#lblPreviousReceivedAmt').text()) + parseFloat($('#lblPreviousTDSAmt').text()) + parseFloat($('#lblPreviousWriteOffAmt').text()) + parseFloat($('#lblPreviousDeductionAmt').text());
	                    var BalanceAmt = precise_round(parseFloat($("#<%=lblInvoiceAmt.ClientID%>").text()) - parseFloat(dec), 4);
	                    if (parseFloat(BalanceAmt) > 0) {
	                        $('#lblBalance,#lblBalanceSpecific').text(BalanceAmt);
	                    }
	                    else {
	                        $('#lblBalance,#lblBalanceSpecific').text('0');
	                    }

	                    $("#btnSave").removeAttr('disabled');
	                }
	                else {
	                    $('#invoiceDetailOutput').html('');
	                    $('#invoiceDetailOutput,#divSearchResult,#divDetailOutPut,#tabTotal').hide();
	                    $("#btnSave").attr('disabled', 'disabled');
	                    modelAlert("No Record Found.");
	                }
	            },
	            error: function (xhr, status) {
	                $("#spnErrorMsg").text('Error occurred, Please contact administrator');
	            }
	        });
        }
	</script>
	<script type="text/javascript">
	    function validateCheque() {
	        if ($.trim($("#txtReceivedAmt").val()) == "") {
	            modelAlert('Please Enter Received Amount');
	            $("#txtReceivedAmt").focus();
	            return;
	        }
	        if ($("#ddlPaymentMode").val() == "2" || $("#ddlPaymentMode").val() == "4") {
	            if ($.trim($("#txtRefNo").val()) == "") {
	                modelAlert('Please Enter Cheque No.');
	                $("#txtRefNo").focus();
	                return;
	            }
	            if ($.trim($("#txtRefDate").val()) == "") {
	                modelAlert('Please Enter Date');
	                $("#txtRefDate").focus();
	                return;

	            }
	        }
	        else if ($("#ddlPaymentMode").val() == "3") {
	            if ($.trim($("#txtRefNo").val()) == "") {
	                modelAlert('Please Enter Credit Card No.');
	                $("#txtRefNo").focus();
	                return;
	            }
	        }
	    }
		</script>
	<script type="text/javascript">
	    var onSettleBankChange = function (el) {

	        var paymentModeID = Number(el.value);
	        //   var machineDetails = ['POS 1-BB', 'POS 2-SBM', 'POS 3-MCB'];
	        if (paymentModeID == 3)
	            $(el).closest('tr').find('.ddlMachineBank').addClass('requiredField');
	        else
	            $(el).closest('tr').find('.ddlMachineBank').removeClass('requiredField');

	    }


	    var onPaymentModeChange = function (el) {
	        var paymentModeID = Number(el.value);

	        $('.ddlSettPaymentMode').val(paymentModeID);

	        var machineDetails = ['POS 1-BB', 'POS 2-SBM', 'POS 3-MCB'];
	        if (paymentModeID == 3) {
	            $('.ddlMachineBank').bindDropDown({ data: machineDetails });
	            $('.ddlMachineBank').addClass('requiredField');
	            $('.ddlMachineBank').removeAttr('disabled');
	        }
	        else {
	            $('.ddlMachineBank').bindDropDown({ data: [''] });
	            $('.ddlMachineBank').removeClass('requiredField');
	            $('.ddlMachineBank').attr('disabled', 'disabled');
	        }

	        if (paymentModeID == 1) {
	            $('.classSettleChequeNo,.ddlSettledBank,#ddlBank').attr('disabled', 'disabled');
	            $('.classSettleChequeNo,.ddlSettledBank,#ddlBank').removeClass('requiredField');
	        }
	        else {
	            $('.classSettleChequeNo,.ddlSettledBank,#ddlBank').removeAttr('disabled');
	            $('.classSettleChequeNo,.ddlSettledBank,#ddlBank').addClass('requiredField');
	        }
	        $('.ddlSettledBank,#ddlBank,.classSettleChequeNo').val('');

	    }

	    var onRefNoChange = function (ctrlID) {
	        $('.classSettleChequeNo').val($(ctrlID).val());
	    }
	    var onRefDateChange = function (ctrlID) {
	        $('.classSettleChequeDate').val($(ctrlID).val());
	    }

	    var onBankChange = function (ctrlID) {
	        $('.ddlSettledBank').val($(ctrlID).val());
	    }

	    var onSwapeMachineChange = function (ctrlID) {
	        $('.ddlMachineBank').val($(ctrlID).val());
	    }

	</script>
	<script id="tb_invoiceDetail" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch" style="border-collapse:collapse;">
		  <#
		 var dataLength=invoiceDetail.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;    
		var decTotal=0;    
		for(var j=0;j<dataLength;j++)
		{
		objRow = invoiceDetail[j];
		#>      
			<# if(j==0)
			{#>
		<tr id="invoiceHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">#</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;" ><input type="checkbox" id="chkAll" onclick="checkAll(this, function () { reDistributionsOfAmount(function () { }); });" /></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px; display:none;">Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:130px;">UHID</th>  
			<# if(invoiceDetail[0].Type=="IPD"){#>
				 <th class="GridViewHeaderStyle" scope="col" style="width:40px;">IPD No.</th> 
			<#} #>               
			 <# if(invoiceDetail[0].Type=="IPD"){#>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">Approval Received Amt.</th>
			<#} #>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Bill Amt.</th>    
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Panel Payble</th> 
             <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Panel Paid</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Other Payble</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Other Paid</th>         
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">O/S Amt.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">Pre. Received Amt.</th>
             <th class="GridViewHeaderStyle" scope="col" style=" width:80px; display:none;">Currency</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:100px; display:none;">Curr.Fac.</th>
			 <th class="GridViewHeaderStyle" scope="col" style=" width:100px; display:none;">Payment Mode</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px; display:none;">Bank</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px; display:none;">Machine</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">Ref. No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;"> Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rec.Amt. (Specific)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rec.Amt. (Base)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">TDS Amt. (Specific)</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">TDS Amt. (Base)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">WriteOff (Specific)</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">WriteOff (Base)</th>           
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Deduction (Specific)</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Deduction (Base)</th>            
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Bal.Amt. (Specific)</th>   
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Bal.Amt. (Base)</th>   
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;"></th>      
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">IsSettled</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">TransactionID</th>                     
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">LedgerTransactionNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">SetDeduction</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">IsAllowSettlement</th>
            

			
			<%--<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none"></th>  --%>        
		</tr>
	   <#}  #>     
					<tr id="<#=j+1#>" >                                                                                                        
					<td id="tdSno" class="GridViewLabItemStyle" style="text-align:center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle"><input type="checkbox" id="chk"  class="chkInvoice" onclick="checkAllChequeNo(this)" 
		                   <#  if(invoiceDetail[j].IsSettled=="1"){#>disabled="disabled"  <#}#>/>
					</td>
					<td class="GridViewLabItemStyle" id="tdType" style="width:40px; display:none;"><#=objRow.Type#></td>
				    <td class="GridViewLabItemStyle" id="tdPatientID" style="width:130px;"><#=objRow.PatientID#></td>   
								 <# if(invoiceDetail[0].Type=="IPD"){#>
					<td class="GridViewLabItemStyle" id="tdIPDNo" style="width:30px;text-align:right"><#=objRow.IPDNo#></td>

						<#} #>                    
									                
					<# if(invoiceDetail[0].Type=="IPD"){#>
					<td class="GridViewLabItemStyle" id="tdPanelApprovedAmt" style="width:30px;text-align:right; display:none;"><#=objRow.PanelApprovedAmt#></td>

						<#} #>
					<td class="GridViewLabItemStyle" id="tdBillAmount" style="width:30px;text-align:right"><#=parseFloat(objRow.BillAmount)#></td>    
					<td class="GridViewLabItemStyle" id="tdPanelAmount" style="width:150px;text-align:right"><#=objRow.PanelAmount#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelPaidAmt" style="width:150px;text-align:right"><#=objRow.PanelPaidAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientPaybleAmt" style="width:150px;text-align:right"><#=objRow.PatientPaybleAmt#></td>

                    <td class="GridViewLabItemStyle" id="tdPatientPaidAmt" style="width:150px;text-align:right"><#=objRow.PatientPaidAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdOutStanding" style="width:30px;text-align:right;display:none"><#=objRow.OutStanding#></td>
					<td class="GridViewLabItemStyle" id="tdPreReceiveAmt" style="width:30px;text-align:right; display:none;"><#=objRow.ReceiveAmt#></td>
                     <td class="GridViewLabItemStyle" id="tdCurrency" style="text-align:right; width:80px; display:none;">
                          <select id="ddlCurrency" class="ddlCurrency" onchange="$getConversionFactor(this)" style="width:80px;" ></select>
					 </td>  
                    <td class="GridViewLabItemStyle tdCurFactor" id="tdCurFactor" style="width:100px;text-align:right; display:none;">1.0000</td> 
				    <td class="GridViewLabItemStyle" id="tdPaymentMode" style="text-align:right; width:100px; display:none;">
						 <select id="ddlSettPaymentMode" class="ddlSettPaymentMode" style="width:100px;"  onchange="onSettleBankChange(this)">
                        </select>
					 </td>    
						<td class="GridViewLabItemStyle" id="tdBank" style="width:150px;text-align:right; display:none;">
							 <select id="ddlSettBank" class="ddlSettledBank" style="width:145px;"  ></select>
                            <span id="spnBankName" style="display:none;width:145px;"></span>
						 </td>    

                        <td class="GridViewLabItemStyle" id="td2" style="width:150px;text-align:right; display:none;">
							 <select id="ddlMachine" class="ddlMachineBank" style="width:145px;" >
                                 <option value=""></option>
							 </select>
                            
						 </td>    


						<td class="GridViewLabItemStyle" id="tdChequeNo" style="width:30px;text-align:right; display:none;">
						<input type="text"   id="txtChequeNo" class="classSettleChequeNo" onpaste="return false"  style="width:80px"/>                          

						 </td>     
						 <td class="GridViewLabItemStyle" id="tdChequeDate" style="width:100px;text-align:right; display:none;">
						 <input onclick="chkDate(this)"  onmousedown="chkDate(this)"  type="text" style="width:100px;" id="txtSettleChequeDate<#=j+1#>"   readonly="readonly" class="classSettleChequeDate" onpaste="return false"/>                          

						 </td>     
                        <td class="GridViewLabItemStyle" id="tdReceiveAmtSpecific" style="width:30px;">
						 <input type="text"  onpaste="return false" id="txtReceiveAmtSpecific" autocomplete="off" style="width:80px" class="ItDoseTextinputNum receiveAmt" onkeypress="return checkNumeric(event,this);" onkeyup="checkReceiveAmtSpecific(this)"
							  <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#>
							  />
						 </td> 

						<td class="GridViewLabItemStyle" id="tdReceiveAmt" style="width:30px;">
						 <input type="text" disabled="disabled" onpaste="return false" id="txtReceiveAmt" autocomplete="off" style="width:80px" class="ItDoseTextinputNum receiveAmt" onkeypress="return checkNumeric(event,this);" onkeyup="checkReceiveAmt(this)"
							<%--  <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#>
							  />--%>
								<span id="spnReceive" style="display:none"></span>
								<span id="spnTypeReceive"  style="display:none" />
						 </td>  
                        <td class="GridViewLabItemStyle" id="tdTDSSpecific" style="width:30px;">
						 <input type="text"   id="txtTDSSpecific" onpaste="return false" style="width:80px" autocomplete="off" class="ItDoseTextinputNum tdsAmt" onkeypress="return checkNumeric(event,this);" onkeyup="checkTDSAmtSpecific(this)"
							  <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#>
							  />
						 </td>                                                                                               
						<td class="GridViewLabItemStyle" id="tdTDSAmt" style="width:30px;">
						 <input type="text"   id="txtTDS" onpaste="return false" disabled="disabled" style="width:80px" autocomplete="off" class="ItDoseTextinputNum tdsAmt" onkeypress="return checkNumeric(event,this);" onkeyup="checkTDSAmt(this)"
							 <%--  <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#>
							  />--%>
							 <span id="spnTDS" style="display:none"></span> <span id="spnChangeTDS"  style="display:none"></span>
							<span id="spnTypeTDS"  style="display:none" />
						 </td>

                         <td class="GridViewLabItemStyle" id="tdWriteOffAmtSpecific" style="width:30px;">
						 <input type="text"  id="txtWriteOffAmtSpecific" onpaste="return false" autocomplete="off" style="width:80px" class="ItDoseTextinputNum WriteOffAmt" onkeypress="return checkNumeric(event,this);" onkeyup="checkWriteOffAmtSpecific(this)"
							  <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#>
							  />
						 </td>

						 <td class="GridViewLabItemStyle" id="tdWriteOffAmt" style="width:30px;">
						 <input type="text"  id="txtWriteOffAmt" disabled="disabled" onpaste="return false" autocomplete="off" style="width:80px" class="ItDoseTextinputNum WriteOffAmt" onkeypress="return checkNumeric(event,this);" onkeyup="checkWriteOffAmt(this)"
							 <%--  <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#>
							  />--%>
							  <span id="spnWriteOff" style="display:none"></span>
							  <span id="spnTypeWriteOff"  style="display:none" />
						 </td>
						 
                         <td class="GridViewLabItemStyle" id="tdAcceptableDeductionSpecific" style="width:30px;">

						 <input type="text"  id="txtAcceptableDeductionSpecific" autocomplete="off" onpaste="return false" style="width:80px" class="ItDoseTextinputNum AcceptableDeductionAmt"  onkeypress="return checkNumeric(event,this);" onkeyup="checkAcceptableDeductionAmtSpecific(this)"
							   <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#> />
						 </td>

						 <td class="GridViewLabItemStyle" id="tdAcceptableDeduction" style="width:30px;">

						 <input type="text"  id="txtAcceptableDeduction" disabled="disabled" autocomplete="off" onpaste="return false" style="width:80px" class="ItDoseTextinputNum AcceptableDeductionAmt"  onkeypress="return checkNumeric(event,this);" onkeyup="checkAcceptableDeductionAmt(this)"
							   <%--  <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#>
							  />--%>
							  <span id="spnAcceptableDeduction" style="display:none"></span>
							 <span id="spnTypeAcceptableDeduction"  style="display:none" />
						 </td>
                        <td class="GridViewLabItemStyle" id="tdBalanceSpecific" style="width:150px;"><#=objRow.OutStanding#></td>
                        <td class="GridViewLabItemStyle" id="tdBalanceAmt" style="width:30px;">
						 <input type="text" id="txtBalanceAmt" onpaste="return false" readonly="readonly" disabled="disabled" class="ItDoseTextinputNum classBalanceAmt" value="<#=objRow.OutStanding#>" style="width:80px" <# if(invoiceDetail[j].IsSettled=="1")
							 {#>  disabled="disabled"<#}#>
							  />
							<span id="spnBalance" style="display:none"></span>
							<span id="spnBalanceAmount"  style="display:none"><#=objRow.OutStanding#></span>
						 </td>
                        				  
						<td class="GridViewLabItemStyle" id="tdIsSettled" style="width:30px;display:none"><#=objRow.IsSettled#> </td>                                                                           
						<td class="GridViewLabItemStyle" id="tdTransactionID" style="width:30px;display:none"><#=objRow.TransactionID#></td>                      
						<td class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style="width:30px;display:none"><#=objRow.LedgertransactionNo#></td>                         
						<td class="GridViewLabItemStyle" id="tdSetDeduction" style="width:30px;display:none"><#=objRow.SetDeduction#></td>   
                        <td class="GridViewLabItemStyle" id="tdIsAllowSettlement" style="width:30px;display:none"><#=objRow.IsAllowSettlement#></td>   
                        
					</tr>

		<#}

		  #>
	 </table>
	</script>
	<script type="text/javascript">
	    function checkNumeric(e, sender) {
	        var charCode = (e.which) ? e.which : e.keyCode;
	        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
	            return false;
	        }
	        if (sender.value == "0") {
	            sender.value = sender.value.substring(0, sender.value.length - 1);
	        }
	        strLen = sender.value.length;
	        strVal = sender.value;
	        hasDec = false;
	        e = (e) ? e : (window.event) ? event : null;
	        if (e) {
	            var charCode = (e.charCode) ? e.charCode :
								((e.keyCode) ? e.keyCode :
								((e.which) ? e.which : 0));
	            if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
	                for (var i = 0; i < strLen; i++) {
	                    hasDec = (strVal.charAt(i) == '.');
	                    if (hasDec)
	                        return false;
	                }
	            }
	        }
	        return true;
	    }
		</script>
	<script type="text/javascript">

	    //dev
	    function checkReceiveAmtSpecific(rowID) {
	        //if (!$(rowID).closest('tr').find('#chk').is(':checked')) {
	        //    $(rowID).val('0');
	        //    modelAlert('Please Check First To Settle Invoice');
	        //    return;

	        //}
	        var specificReceivedAmt = Number($(rowID).val());
	        var ConversionFactor = Number($(rowID).closest('tr').find("#tdCurFactor").text());
	        var baseReceivedAmt = specificReceivedAmt * ConversionFactor;

	        $(rowID).closest('tr').find("#txtReceiveAmt").val(precise_round(parseFloat(baseReceivedAmt), 4));
	        // modelAlert($(rowID).closest('tr').find("#txtReceiveAmt").val());
	        checkReceiveAmt(rowID);
	    }
	    function checkTDSAmtSpecific(rowID) {
	        //if (!$(rowID).closest('tr').find('#chk').is(':checked')) {
	        //    $(rowID).val('0');
	        //    modelAlert('Please Check First To Settle Invoice');
	        //    return;

	        //}
	        var specificTDSAmt = Number($(rowID).val());
	        var ConversionFactor = Number($(rowID).closest('tr').find("#tdCurFactor").text());
	        var baseTDSAmt = specificTDSAmt * ConversionFactor;

	        $(rowID).closest('tr').find("#txtTDS").val(precise_round(parseFloat(baseTDSAmt), 4));
	        checkTDSAmt(rowID);
	    }

	    function checkWriteOffAmtSpecific(rowID) {
	        //if (!$(rowID).closest('tr').find('#chk').is(':checked')) {
	        //    $(rowID).val('0');
	        //    modelAlert('Please Check First To Settle Invoice');
	        //    return;

	        //}
	        var specificWriteOffAmt = Number($(rowID).val());
	        var ConversionFactor = Number($(rowID).closest('tr').find("#tdCurFactor").text());
	        var baseWriteOffAmt = specificWriteOffAmt * ConversionFactor;

	        $(rowID).closest('tr').find("#txtWriteOffAmt").val(precise_round(parseFloat(baseWriteOffAmt), 4));
	        checkWriteOffAmt(rowID);
	    }
	    function checkAcceptableDeductionAmtSpecific(rowID) {
	        //if (!$(rowID).closest('tr').find('#chk').is(':checked')) {
	        //    $(rowID).val('0');
	        //    modelAlert('Please Check First To Settle Invoice');
	        //    return;

	        //}
	        var specificAcceptableDeductionAmt = Number($(rowID).val());
	        var ConversionFactor = Number($(rowID).closest('tr').find("#tdCurFactor").text());
	        var baseAcceptableDeductionAmt = specificAcceptableDeductionAmt * ConversionFactor;

	        $(rowID).closest('tr').find("#txtAcceptableDeduction").val(precise_round(parseFloat(baseAcceptableDeductionAmt), 4));
	        checkAcceptableDeductionAmt(rowID);
	    }
	    function checkReceiveAmt(rowID) {
	        //if (!$(rowID).closest('tr').find('#chk').is(':checked')) {
	        //    $(rowID).closest('tr').find("#txtReceiveAmt").val('0');
	        //    modelAlert('Please Check First To Settle Invoice');
	        //    return;

	        //}
	        if (Number($(rowID).closest('tr').find('#tdIsAllowSettlement').text()) == 0) {
	            $(rowID).closest('tr').find("#txtReceiveAmt").val('0');
	            modelAlert('Total Panel Allocation/Approval Amount should be less than or Equal to Bill Amount. Kindly Check it.');
	            return;

	        }

	        var receiveAmt = 0, tdsAmt = 0, writeOffAmt = 0, deducationAmt = 0, balanceAmt = 0, totalAmt = 0;
	        var totalReceiveAmt = 0;
	        var spnReceiveAmt = precise_round(parseFloat($(rowID).closest('tr').find("#txtBalanceAmt").val()), 4);
	        receiveAmt = parseFloat($(rowID).closest('tr').find("#txtReceiveAmt").val());
	        if (isNaN(receiveAmt)) receiveAmt = 0;
	        tdsAmt = parseFloat($(rowID).closest('tr').find("#txtTDS").val());
	        if (isNaN(tdsAmt)) tdsAmt = 0;
	        writeOffAmt = parseFloat($(rowID).closest('tr').find("#txtWriteOffAmt").val());
	        if (isNaN(writeOffAmt)) writeOffAmt = 0;
	        deducationAmt = parseFloat($(rowID).closest('tr').find("#txtAcceptableDeduction").val());
	        if (isNaN(deducationAmt)) deducationAmt = 0;
	        balanceAmt = parseFloat($(rowID).closest('tr').find("#txtBalanceAmt").val());
	        if (isNaN(balanceAmt)) balanceAmt = 0;

	        totalAmt = parseFloat(receiveAmt + tdsAmt + writeOffAmt + deducationAmt);
	        if (isNaN(totalAmt)) totalAmt = 0;
	        receiveAmt = parseFloat($(rowID).closest('tr').find("#txtReceiveAmt").val());
	        if (isNaN(receiveAmt)) receiveAmt = 0;
	        totalAmt = parseFloat(receiveAmt + tdsAmt + writeOffAmt + deducationAmt);
	        $(rowID).closest('tr').find("#txtBalanceAmt").val(precise_round(parseFloat($(rowID).closest('tr').find("#spnBalanceAmount").text()) - totalAmt, 4));
	        $(rowID).closest('tr').find("#tdBalanceSpecific").text(precise_round(parseFloat(Number($(rowID).closest('tr').find("#txtBalanceAmt").val()) / Number($(rowID).closest('tr').find("#tdCurFactor").text())), 4))
	        $(rowID).closest('tr').find('#spnTypeTDS').html('1');
	        var CurrentBalance = precise_round(parseFloat($(rowID).closest('tr').find("#tdBalanceSpecific").text()), 4);
	        var ActualBalance = precise_round(parseFloat(parseFloat($(rowID).closest('tr').find("#spnBalanceAmount").text()) / parseFloat($(rowID).closest('tr').find("#tdCurFactor").text())), 4);

	        if (CurrentBalance == 0) {
	            $(rowID).closest('tr').css("background-color", "#FFB6C1");
	        }
	        else if (CurrentBalance < 0) {
	            $(rowID).closest('tr').css("background-color", "#fa0d0d");
	        }
	        else if (CurrentBalance != ActualBalance) {
	            $(rowID).closest('tr').css("background-color", "#FDE76D");
	        }
	        else {
	            $(rowID).closest('tr').css("background-color", "transparent");
	            $(rowID).closest('tr').find('#spnTypeTDS').html('0');
	        }

	        CalculateRemaining(function () { });
	    }
	    function checkTDSAmt(rowID) {
	        var receiveAmt = 0, tdsAmt = 0, writeOffAmt = 0, deducationAmt = 0, balanceAmt = 0, totalAmt = 0, totalTDSAmt = 0;
	        var spnTDSAmt = precise_round(parseFloat($(rowID).closest('tr').find("#spnTDS").text()), 4);

	        receiveAmt = parseFloat($(rowID).closest('tr').find("#txtReceiveAmt").val());
	        if (isNaN(receiveAmt)) receiveAmt = 0;
	        tdsAmt = parseFloat($(rowID).closest('tr').find("#txtTDS").val());
	        if (isNaN(tdsAmt)) tdsAmt = 0;
	        writeOffAmt = parseFloat($(rowID).closest('tr').find("#txtWriteOffAmt").val());
	        if (isNaN(writeOffAmt)) writeOffAmt = 0;
	        deducationAmt = parseFloat($(rowID).closest('tr').find("#txtAcceptableDeduction").val());
	        if (isNaN(deducationAmt)) deducationAmt = 0;
	        balanceAmt = parseFloat($(rowID).closest('tr').find("#txtBalanceAmt").val());
	        if (isNaN(balanceAmt)) balanceAmt = 0;
	        totalAmt = parseFloat(receiveAmt + tdsAmt + writeOffAmt + deducationAmt);
	        tdsAmt = parseFloat($(rowID).closest('tr').find("#txtTDS").val());
	        if (isNaN(tdsAmt)) tdsAmt = 0;
	        totalAmt = parseFloat(receiveAmt + tdsAmt + writeOffAmt + deducationAmt);
	        $(rowID).closest('tr').find("#txtBalanceAmt").val(precise_round(parseFloat($(rowID).closest('tr').find("#spnBalanceAmount").text()) - totalAmt, 4));
	        $(rowID).closest('tr').find("#tdBalanceSpecific").text(precise_round(parseFloat(Number($(rowID).closest('tr').find("#txtBalanceAmt").val()) / Number($(rowID).closest('tr').find("#tdCurFactor").text())), 4))

	        //  totalBalanceAmt();


	        $(rowID).closest('tr').find('#spnTypeTDS').html('1');
	        var CurrentBalance = precise_round(parseFloat($(rowID).closest('tr').find("#tdBalanceSpecific").text()), 4);
	        var ActualBalance = precise_round(parseFloat(parseFloat($(rowID).closest('tr').find("#spnBalanceAmount").text()) / parseFloat($(rowID).closest('tr').find("#tdCurFactor").text())), 4);

	        if (CurrentBalance == 0) {
	            $(rowID).closest('tr').css("background-color", "#FFB6C1");
	        }
	        else if (CurrentBalance < 0) {
	            $(rowID).closest('tr').css("background-color", "#fa0d0d");
	        }
	        else if (CurrentBalance != ActualBalance) {
	            $(rowID).closest('tr').css("background-color", "#FDE76D");
	        }
	        else {
	            $(rowID).closest('tr').css("background-color", "transparent");
	            $(rowID).closest('tr').find('#spnTypeTDS').html('0');
	        }

	        CalculateRemaining(function () { });
	    }
	    function checkWriteOffAmt(rowID) {
	        var receiveAmt = 0, tdsAmt = 0, writeOffAmt = 0, deducationAmt = 0, balanceAmt = 0, totalAmt = 0, totalWriteOffAmt = 0;

	        var spnWriteOffAmt = precise_round(parseFloat($(rowID).closest('tr').find("#spnWriteOff").text()), 4);

	        receiveAmt = parseFloat($(rowID).closest('tr').find("#txtReceiveAmt").val());
	        if (isNaN(receiveAmt)) receiveAmt = 0;
	        tdsAmt = parseFloat($(rowID).closest('tr').find("#txtTDS").val());
	        if (isNaN(tdsAmt)) tdsAmt = 0;
	        writeOffAmt = parseFloat($(rowID).closest('tr').find("#txtWriteOffAmt").val());
	        if (isNaN(writeOffAmt)) writeOffAmt = 0;
	        deducationAmt = parseFloat($(rowID).closest('tr').find("#txtAcceptableDeduction").val());
	        if (isNaN(deducationAmt)) deducationAmt = 0;
	        balanceAmt = parseFloat($(rowID).closest('tr').find("#txtBalanceAmt").val());
	        if (isNaN(balanceAmt)) balanceAmt = 0;

	        totalAmt = parseFloat(receiveAmt + tdsAmt + writeOffAmt + deducationAmt);
            writeOffAmt = parseFloat($(rowID).closest('tr').find("#txtWriteOffAmt").val());
	        if (isNaN(writeOffAmt)) writeOffAmt = 0;
	        totalAmt = parseFloat(receiveAmt + tdsAmt + writeOffAmt + deducationAmt);
	        $(rowID).closest('tr').find("#txtBalanceAmt").val(precise_round(parseFloat($(rowID).closest('tr').find("#spnBalanceAmount").text()) - totalAmt, 4));
	        $(rowID).closest('tr').find("#tdBalanceSpecific").text(precise_round(parseFloat(Number($(rowID).closest('tr').find("#txtBalanceAmt").val()) / Number($(rowID).closest('tr').find("#tdCurFactor").text())), 4))

	        $(rowID).closest('tr').find('#spnTypeTDS').html('1');
	        var CurrentBalance = precise_round(parseFloat($(rowID).closest('tr').find("#tdBalanceSpecific").text()), 4);
	        var ActualBalance = precise_round(parseFloat(parseFloat($(rowID).closest('tr').find("#spnBalanceAmount").text()) / parseFloat($(rowID).closest('tr').find("#tdCurFactor").text())), 4);


	        if (CurrentBalance == 0) {
	            $(rowID).closest('tr').css("background-color", "#FFB6C1");
	        }
	        else if (CurrentBalance < 0) {
	            $(rowID).closest('tr').css("background-color", "#fa0d0d");
	        }
	        else if (CurrentBalance != ActualBalance) {
	            $(rowID).closest('tr').css("background-color", "#FDE76D");
	        }
	        else {
	            $(rowID).closest('tr').css("background-color", "transparent");
	            $(rowID).closest('tr').find('#spnTypeTDS').html('0');
	        }

	        CalculateRemaining(function () { });
	    }

	    function checkAcceptableDeductionAmt(rowID) {
	        
	        var receiveAmt = 0, tdsAmt = 0, writeOffAmt = 0, deducationAmt = 0, balanceAmt = 0, totalAmt = 0, totalDeductionAmt = 0;

	        var spnAcceptableDeductionAmt = precise_round(parseFloat($(rowID).closest('tr').find("#spnAcceptableDeduction").text()), 4);

	        receiveAmt = parseFloat($(rowID).closest('tr').find("#txtReceiveAmt").val());
	        if (isNaN(receiveAmt)) receiveAmt = 0;
	        tdsAmt = parseFloat($(rowID).closest('tr').find("#txtTDS").val());
	        if (isNaN(tdsAmt)) tdsAmt = 0;
	        writeOffAmt = parseFloat($(rowID).closest('tr').find("#txtWriteOffAmt").val());
	        if (isNaN(writeOffAmt)) writeOffAmt = 0;
	        deducationAmt = parseFloat($(rowID).closest('tr').find("#txtAcceptableDeduction").val());
	        if (isNaN(deducationAmt)) deducationAmt = 0;
	        balanceAmt = parseFloat($(rowID).closest('tr').find("#txtBalanceAmt").val());
	        if (isNaN(balanceAmt)) balanceAmt = 0;


	        totalAmt = parseFloat(receiveAmt + tdsAmt + writeOffAmt + deducationAmt);
	        
	        deducationAmt = parseFloat($(rowID).closest('tr').find("#txtAcceptableDeduction").val());
	        if (isNaN(deducationAmt)) deducationAmt = 0;
	        totalAmt = parseFloat(receiveAmt + tdsAmt + writeOffAmt + deducationAmt);
	        $(rowID).closest('tr').find("#txtBalanceAmt").val(precise_round(parseFloat($(rowID).closest('tr').find("#spnBalanceAmount").text()) - totalAmt, 4));
	        $(rowID).closest('tr').find("#tdBalanceSpecific").text(precise_round(parseFloat(Number($(rowID).closest('tr').find("#txtBalanceAmt").val()) / Number($(rowID).closest('tr').find("#tdCurFactor").text())), 4))

	        $(rowID).closest('tr').find('#spnTypeTDS').html('1');
	        var CurrentBalance = precise_round(parseFloat($(rowID).closest('tr').find("#tdBalanceSpecific").text()), 4);
	        var ActualBalance = precise_round(parseFloat(parseFloat($(rowID).closest('tr').find("#spnBalanceAmount").text()) / parseFloat($(rowID).closest('tr').find("#tdCurFactor").text())), 4);


	        if (CurrentBalance == 0) {
	            $(rowID).closest('tr').css("background-color", "#FFB6C1");
	        }
	        else if (CurrentBalance < 0) {
	            $(rowID).closest('tr').css("background-color", "#fa0d0d");
	        }
	        else if (CurrentBalance != ActualBalance) {
	            $(rowID).closest('tr').css("background-color", "#FDE76D");
	        }
	        else {
	            $(rowID).closest('tr').css("background-color", "transparent");
	            $(rowID).closest('tr').find('#spnTypeTDS').html('0');
	        }

	        CalculateRemaining(function () { });
	    }
		</script>
	<script type="text/javascript">
	    function validateInvoice() {
	        if (($.trim($("#txtReceivedAmt").val()) == "") || ($.trim($("#txtReceivedAmt").val()) == "0")) {
	            $("#spnErrorMsg").text('Please Enter Received Amount');
	            $("#txtReceivedAmt").focus();
	            return false;
	        }


	        if ($("#ddlPaymentMode").val() == "2" || $("#ddlPaymentMode").val() == "4") {
	            if ($("#ddlBank").val() == "") {
	                $("#spnErrorMsg").text('Please Select Bank');
	                $("#ddlBank").focus();
	                return false;
	            }
	            if ($.trim($("#txtRefNo").val()) == "") {
	                $("#spnErrorMsg").text('Please Enter Cheque No.');
	                $("#txtRefNo").focus();
	                return false;
	            }
	            if ($.trim($("#txtRefDate").val()) == "") {
	                $("#spnErrorMsg").text('Please Enter Date');
	                $("#txtRefDate").focus();
	                return;

	            }
	        }
	        else if ($("#ddlPaymentMode").val() == "3") {
	            if ($("#ddlBank").val() == "") {
	                $("#spnErrorMsg").text('Please Select Bank');
	                $("#ddlBank").focus();
	                return false;
	            }
	            if ($.trim($("#txtRefNo").val()) == "") {
	                $("#spnErrorMsg").text('Please Enter CreditCard No.');
	                $("#txtRefNo").focus();
	                return;
	            }
	        }
	        return true;
	    }

	    function invoiceDetailData() {
	        var dataInvoice = new Array();
	        var ObjInvoice = new Object();
	        $("#tb_grdSearch tr").each(function () {
	            var id = $(this).closest("tr").attr("id");
	            if (id != "invoiceHeader") {

	                if ($(this).closest('tr').find("#chk").is(':checked')) {
	                    var Sno = $(this).closest("tr").find("#tdSno").text();
	                    ObjInvoice.LedgertransactionNo = $(this).closest("tr").find("#tdLedgerTransactionNo").text();
	                    ObjInvoice.PatientID = $(this).closest("tr").find("#tdPatientID").text();
	                    ObjInvoice.TransactionID = $(this).closest("tr").find("#tdTransactionID").text();

	                    if (isNaN($(this).closest("tr").find("#txtReceiveAmt").val())) $(this).closest("tr").find("#txtReceiveAmt").val() = 0;
	                    ObjInvoice.Amount = $(this).closest("tr").find("#txtReceiveAmt").val();

	                    var tdsAmt = $(this).closest("tr").find("#txtTDS").val();
	                    if (isNaN(tdsAmt) || tdsAmt == "") tdsAmt = 0;
	                    ObjInvoice.TDSAmount = tdsAmt;

	                    var WriteOffAmt = $(this).closest("tr").find("#txtWriteOffAmt").val();
	                    if (isNaN(WriteOffAmt) || WriteOffAmt == "") WriteOffAmt = 0;
	                    ObjInvoice.writeOff = WriteOffAmt;

	                    var AcceptableDeduction = $(this).closest("tr").find("#txtAcceptableDeduction").val();
	                    if (isNaN(AcceptableDeduction) || AcceptableDeduction == "") AcceptableDeduction = 0;
	                    ObjInvoice.DeducationAmt = AcceptableDeduction;

	                    var ServiceTax = $(this).closest("tr").find("#txtServiceTaxAmt").val();
	                    if (isNaN(ServiceTax) || ServiceTax == "") ServiceTax = 0;
	                    ObjInvoice.ServiceTax = ServiceTax;

	                    ObjInvoice.panelAmount = $(this).closest("tr").find("#tdPanelAmount").text();
	                    ObjInvoice.billAmount = $(this).closest("tr").find("#tdBillAmount").text();

	                    ObjInvoice.PaymentModeID = $(this).closest("tr").find("#ddlSettPaymentMode").val();
	                    ObjInvoice.PaymentMode = $(this).closest("tr").find("#ddlSettPaymentMode option:selected").text();

	                    if (Number($('#ddlSettlementType').val()) == 1) {
	                        ObjInvoice.bankName = $(this).closest("tr").find("#ddlSettBank option:selected").text();
	                    }
	                    else {
	                        ObjInvoice.bankName = $(this).closest("tr").find("#spnBankName").text();
	                    }
	                    ObjInvoice.machineName = $(this).closest("tr").find('.ddlMachineBank').val();
	                    ObjInvoice.chequeDate = $(this).closest("tr").find('#txtSettleChequeDate' + Sno).val();
	                    ObjInvoice.chequeNo = $(this).closest("tr").find("#txtChequeNo").val();
	                    ObjInvoice.currency = $(this).closest("tr").find("#ddlCurrency").val();
	                    ObjInvoice.currencyFactor = Number($.trim($(this).closest("tr").find("#tdCurFactor").text()));
	                    dataInvoice.push(ObjInvoice);
	                    ObjInvoice = new Object();
	                }
	            }
	        });
	        return dataInvoice;
	    }
	    function saveInvoice() {

            //devendra

	        if (Number($("#spnReceivedAmt").text()) != 0)
	        {
	            modelAlert('Bill-Wise Received Amount is not matching Total Received Amount.');
	            return;
	        }
	        if (Number($("#spnTDSAmt").text()) != 0) {
	            modelAlert('Bill-Wise TDS Amount is not matching Total TDS Amount.');
	            return;
	        }
	        if (Number($("#spnWriteOffAmt").text()) != 0) {
	            modelAlert('Bill-Wise Write-Off Amount is not matching Total Write-Off Amount.');
	            return;
	        }
	        if (Number($("#spnDeductionAmt").text()) != 0) {
	            modelAlert('Bill-Wise Deduction Amount is not matching Total Deduction Amount.');
	            return;
	        }

	        var ddlSettlementType = Number($('#ddlSettlementType').val());

	        var onAccountVoucharID = Number($('#ddlAccountVoucher').val());

	        if (ddlSettlementType == 2) {
	            if (onAccountVoucharID == 0) {
	                modelAlert('Please Select Voucher.');
	                return false;
	            }
	        }


	        $("#spnErrorMsg").text('');
	        if (($.trim($("#txtReceivedAmt").val()) == "") || ($.trim($("#txtReceivedAmt").val()) == "0")) {
	            $("#spnErrorMsg").text('Please Enter Received Amount');
	            $("#txtReceivedAmt").focus();
	            return false;
	        }
	        $("#btnSave").attr('disabled', 'disabled');

	        var con = 0;

	        $("#tb_grdSearch tr").each(function (index, value) {
	            var id = $(this).closest("tr").attr("id");
	            if (id != "invoiceHeader") {
	                if ($(this).closest('tr').find("#chk").is(':checked')) {
	                    if (con == "1") {
	                        $("#btnSave").removeAttr('disabled');
	                        return;
	                    }
	                    if ((($(this).closest("tr").find("#txtReceiveAmt").val()) == "") || (parseFloat($(this).closest("tr").find("#txtReceiveAmt").val()) == "0")) {
	                        con = 1;
	                        modelAlert('Please Enter Receive Amount');
	                        $("#spnErrorMsg").text('Please Enter Receive Amount');
	                        $(this).closest("tr").find("#txtReceiveAmt").focus();
	                        $("#btnSave").removeAttr('disabled');
	                        return;
	                    }
	                    var PaymentMode = $(this).closest("tr").find("#ddlSettPaymentMode option:selected").text();

	                    var paymentModeID = Number($(this).closest("tr").find('#ddlSettPaymentMode').val());

	                    var cashPaymentModeID = 1;

	                    if (Number($('#ddlSettlementType').val()) == 1) {

	                        if (paymentModeID > cashPaymentModeID) {
	                            if ((($(this).closest("tr").find("#ddlSettBank").val()) == "0" || $("#ddlBank").val() == "")) {
	                                con = 1;
	                                modelAlert('Please Select Bank Name');
	                                $("#spnErrorMsg").text('Please Select Bank Name');
	                                $(this).closest("tr").find("#ddlSettBank").focus();
	                                $("#ddlBank").focus();
	                                $("#btnSave").removeAttr('disabled');
	                                return;
	                            }
	                        }
	                    }
	                    else {
	                        if (paymentModeID > cashPaymentModeID) {
	                            if ((($(this).closest("tr").find("#spnBankName").text()) == "")) {
	                                con = 1;
	                                modelAlert('Please Select Bank Name');
	                                $("#spnErrorMsg").text('Please Select Bank Name');
	                                $(this).closest("tr").find("#spnBankName").focus();
	                                $("#btnSave").removeAttr('disabled');
	                                return;
	                            }
	                        }
	                    }

	                    if (paymentModeID > cashPaymentModeID) {

	                        if ($(this).closest("tr").find("#txtChequeNo").val() == "" || $("#txtRefNo").val() == "") {
	                            con = 1;

	                            modelAlert('Please Enter Ref. No.');
	                            $("#spnErrorMsg").text('Please Enter Ref. No.');
	                            $(this).closest("tr").find("#txtChequeNo").focus();
	                            $("#txtRefNo").focus();
	                            $("#btnSave").removeAttr('disabled');
	                            return;
	                        }
	                    }

	                    if ($(this).closest("tr").find("#txtSettleChequeDate").val() == "" || $("#txtRefDate").val() == "") {
	                        con = 1;
	                        modelAlert('Please Select Date');
	                        $("#spnErrorMsg").text('Please Select Date');
	                        $(this).closest("tr").find("#txtSettleChequeDate").focus();
	                        $("#txtRefDate").focus();
	                        $("#btnSave").removeAttr('disabled');
	                        $("#btnSave").removeAttr('disabled');
	                        return;
	                    }

	                    if (parseFloat($(this).closest("tr").find("#txtBalanceAmt").val()) < 0) {
	                        $(this).closest("tr").find("#txtBalanceAmt").focus();
	                        modelAlert('Balance Amount Cannot Be Negative');
	                        $("#spnErrorMsg").text('Balance Amount Cannot Be Negative');
	                        con = 1;
	                        $("#btnSave").removeAttr('disabled');
	                        return;
	                    }
	                }

	            }

	        });
	        if (con == "1") {

	            $("#btnSave").removeAttr('disabled');
	            return false;

	        }

	        var resultInvoice = invoiceDetailData();
	        var Type = $("#rdoType input[type:radio]:checked").val();
	        if (Type == "0")
	            Type = "Final Settlement";
	        else
	            Type = "On Account";
	        var ReceivedAmount = 0; var TDSAmount = 0; var WriteOff = 0; var DeducationAmt = 0;
	        if ($.trim($("#txtReceivedAmt").val()) != "")
	            ReceivedAmount = $.trim($("#txtReceivedAmt").val());
	        if ($.trim($("#txtTDSAmt").val()) != "")
	            TDSAmount = $.trim($("#txtTDSAmt").val());
	        if ($.trim($("#txtWriteOff").val()) != "")
	            WriteOff = $.trim($("#txtWriteOff").val());
	        if ($.trim($("#txtDeduction").val()) != "")
	            DeducationAmt = $.trim($("#txtDeduction").val());

	        if (isNaN(ReceivedAmount)) ReceivedAmount = 0;
	        if (isNaN(TDSAmount)) TDSAmount = 0;
	        if (isNaN(WriteOff)) WriteOff = 0;
	        if (isNaN(DeducationAmt)) DeducationAmt = 0;

	        var CurrencyFactor = Number($('#lblCurrencyFactor').text());
	        ReceivedAmount = precise_round(parseFloat(ReceivedAmount * CurrencyFactor), 4);
	        TDSAmount = precise_round(parseFloat(TDSAmount * CurrencyFactor), 4);
	        WriteOff = precise_round(parseFloat(WriteOff * CurrencyFactor), 4);
	        DeducationAmt = precise_round(parseFloat(DeducationAmt * CurrencyFactor), 4);

	        $.ajax({
	            url: "Services/Panel_Invoice.asmx/saveSettlement",
	            data: JSON.stringify({ Invoice: resultInvoice, ReceivedAmount: ReceivedAmount, TDSAmount: TDSAmount, WriteOff: WriteOff, DeducationAmt: DeducationAmt, Type: Type, InvoiceNo: $("#lblInvoiceNo").text(), InvoiceDate: $("#spnInvoiceDate").text(), PanelID: $("#spnPanelID").text(), PatientType: $("#spnPatientType").text(), balanceAmount: $("#lblBalance").text(), InvoiceAmount: $("#lblInvoiceAmt").text(), onAccountVoucharID: onAccountVoucharID }),
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            dataType: "json",
	            success: function (result) {
	                if (result.d == "1") {
	                    modelAlert('Record Saved Successfully', function () {
	                        window.location.reload();
	                    });

	                }
	                else if (result.d == "2") {
	                    modelAlert('Voucher Amount and Received Amount Not Matched.', function () {
	                        $("#btnSave").removeAttr('disabled');
	                    });
	                }
	                else {
	                    modelAlert("Record Not Saved");
	                    $("#spnErrorMsg").text('Record Not Saved');
	                }

	            },
	            error: function (xhr, status) {
	                modelAlert("Error occurred, Please contact administrator");
	                $("#spnErrorMsg").text('Error occurred, Please contact administrator');
	             
	            }
	        });
	    }


	    function bindSettleBank() {
	        $.ajax({
	            url: "InvoiceSettlement.aspx/bindBank",
	            data: '{}',
	            type: "POST",
	            contentType: "application/json; charset=utf-8",
	            timeout: 120000,
	            async: false,
	            dataType: "json",
	            success: function (result) {
	                bindBank = jQuery.parseJSON(result.d);
	                $(".ddlSettledBank").empty().append('<option selected="selected" value="0"> </option>');
	                for (i = 0; i < bindBank.length; i++) {
	                    $(".ddlSettledBank").append($("<option></option>").val(bindBank[i].Bank_ID).html(bindBank[i].BankName));
	                }
	            }

	        });

	    }
	    var $getCurrencyDetails = function (callback) {
	        var ddlCurrency = $('.ddlCurrency');
	        var ddlInvCurrency = $('.ddlInvCurrency');
	        serverCall('../Common/CommonService.asmx/LoadCurrencyDetail', {}, function (response) {
	            var responseData = JSON.parse(response);
	            $(ddlCurrency).bindDropDown({
	                // defaultValue: '',
	                data: responseData.currancyDetails,
	                valueField: 'CountryID',
	                textField: 'Currency',
	                selectedValue: responseData.baseCountryID
	            });
	            $(ddlInvCurrency).bindDropDown({
	                // defaultValue: '',
	                data: responseData.currancyDetails,
	                valueField: 'CountryID',
	                textField: 'Currency',
	                selectedValue: responseData.baseCountryID
	            });

	            callback(ddlCurrency.val());
	        });
	    }

	    var $bindPaymentModePanelWise = function (callback) {
	        var panelId = $.trim($('#spnPanelID').text());
	        var ddlSettPaymentMode = $('.ddlSettPaymentMode');
	         serverCall('../Common/CommonService.asmx/BindPaymentModePanelWise', { PanelID: panelId }, function (response) {
	      //  serverCall('InvoiceSettlement.aspx/GetPaymentMode', {}, function (response) {
	            paymentModes = $.extend(true, [], JSON.parse(response));
	            paymentModes = paymentModes.filter(function (i) { if (i.PaymentModeID != 4) { return i; } });
	            $(ddlSettPaymentMode).bindDropDown({
	                // defaultValue: '',
	                data: paymentModes,
	                valueField: 'PaymentModeID',
	                textField: 'PaymentMode'
	            });
	            callback(ddlSettPaymentMode.val());
	        });
	    }

	    var checkAll = function (rowID, callback) {
	        if ($(rowID).is(':checked')) {
	            $(".chkInvoice").attr('checked', true);
	            callback(true);
	        }
	        else {
	            $(".chkInvoice").attr('checked', false);
	            callback(true);

	        }
	    }

	    var CalculateRemaining = function () {

	        var TotalBillwiseReceived = 0;
	        var TotalBillwiseTDS = 0;
	        var TotalBillwiseWriteOff = 0;
	        var TotalBillwiseDeduction = 0;
	        var TotalBillWiseCollection = 0;

	        var TotalReceived = Number($('#txtReceivedAmt').val());
	        var TotalTDS = Number($('#txtTDSAmt').val());
	        var TotalWriteOff = Number($('#txtWriteOff').val());
	        var TotalDeduction = Number($('#txtDeduction').val());
	        var TotalCollection = TotalReceived + TotalTDS + TotalWriteOff + TotalDeduction;

	        $("#tb_grdSearch tr").each(function () {
	            var id = $(this).closest("tr").attr("id");
	            if (id != "invoiceHeader") {
	                if ($(this).closest('tr').find("#chk").is(':checked')) {
	                    TotalBillwiseReceived = TotalBillwiseReceived + Number($(this).closest('tr').find("#txtReceiveAmtSpecific").val());
	                    TotalBillwiseTDS=TotalBillwiseTDS+ Number($(this).closest('tr').find("#txtTDSSpecific").val());
	                    TotalBillwiseWriteOff = TotalBillwiseWriteOff+Number($(this).closest('tr').find("#txtWriteOffAmtSpecific").val());
	                    TotalBillwiseDeduction = TotalBillwiseDeduction+Number($(this).closest('tr').find("#txtAcceptableDeductionSpecific").val());
	                }
	            }
	        });

	        TotalBillWiseCollection = TotalBillwiseReceived + TotalBillwiseTDS + TotalBillwiseWriteOff + TotalBillwiseDeduction;

	        $("#spnReceivedAmt").text(precise_round((TotalReceived - TotalBillwiseReceived), 4));
	        $("#spnTDSAmt").text(precise_round((TotalTDS - TotalBillwiseTDS), 4));
	        $("#spnWriteOffAmt").text(precise_round((TotalWriteOff - TotalBillwiseWriteOff), 4));
	        $("#spnDeductionAmt").text(precise_round((TotalDeduction - TotalBillwiseDeduction), 4));
	        $("#spnBalanceAmt").text(precise_round((TotalCollection - TotalBillWiseCollection), 4));
	    }

	    var reDistributionsOfAmount = function () {
	        distributeAmount('#txtReceivedAmt', 1, function () {
	            distributeAmount('#txtTDSAmt', 2, function () {
	                distributeAmount('#txtWriteOff', 3, function () {
	                    distributeAmount('#txtDeduction', 4, function () {
	                    });
	                });
	            });
	        });

	    }

	    var getBalanceAmount = function () {

	        var InvoiceAmt = Number($('#lblInvoiceAmt').text());
	        var PreReceivedAmt = Number($('#lblPreviousReceivedAmt').text());
	        var PreviousTDSAmt = Number($('#lblPreviousTDSAmt').text());
	        var PreviousWriteOffAmt = Number($('#lblPreviousWriteOffAmt').text());
	        var PreviousDeductionAmt = Number($('#lblPreviousDeductionAmt').text());

	        var TotalPreviousPaid = PreReceivedAmt + PreviousTDSAmt + PreviousWriteOffAmt + PreviousDeductionAmt;

	        var CurrentReceivedAmt = Number($('#txtReceivedAmt').val());
	        var CurrentTDSAmt = Number($('#txtTDSAmt').val());
	        var CurrentWriteOffAmt = Number($('#txtWriteOff').val());
	        var CurrentDeductionAmt = Number($('#txtDeduction').val());
	        var CurrencyFactor = Number($('#lblCurrencyFactor').text());
	        var TotalCurrrentPaid = (CurrentReceivedAmt + CurrentTDSAmt + CurrentWriteOffAmt + CurrentDeductionAmt) * CurrencyFactor;

	        var BalanceAmt = precise_round(parseFloat((InvoiceAmt - TotalPreviousPaid - TotalCurrrentPaid)), 4);
	        $("#lblBalance").text(precise_round(parseFloat(BalanceAmt), 4));
	        $('#lblBalanceSpecific').text(precise_round(parseFloat(Number($('#lblBalance').text()) / CurrencyFactor), 4));

	    }
	    function checkAllChequeNo(rowID) {
	        if (!$(rowID).closest('tr').is(':checked')) {
	            $(rowID).closest('tr').find('#txtReceiveAmt,#txtReceiveAmtSpecific').val(0);
	            $(rowID).closest('tr').find('#txtTDS,#txtTDSSpecific').val(0);
	            $(rowID).closest('tr').find('#txtWriteOffAmt,#txtWriteOffAmtSpecific').val(0);
	            $(rowID).closest('tr').find('#txtAcceptableDeduction,#txtAcceptableDeductionSpecific').val(0);

	        }

	        reDistributionsOfAmount(function () { });
	    }
	    function totalBalanceAmt() {
	        var balanceAmt = 0;
	        $("#tb_grdSearch tr").each(function () {
	            var id = $(this).closest("tr").attr("id");
	            if (id != "invoiceHeader") {
	                balanceAmt += parseFloat($(this).closest('tr').find("#txtBalanceAmt").val());

	            }

	        });

	        $("#lblBalance").text(precise_round(parseFloat(balanceAmt), 4));

	        $('#lblBalanceSpecific').text(precise_round(parseFloat(Number($('#lblBalance').text()) / Number($('#lblCurrencyFactor').text())), 4));


	    }
	    function chkDate(rowid) {
	        //modelAlert($("#spnInvoiceDate").text());
	        var Sno = $(rowid).closest('tr').find("#tdSno").text();
	        $(rowid).closest('tr').find('#txtSettleChequeDate' + Sno).show();
	        $(rowid).closest('tr').find('#txtSettleChequeDate' + Sno).datepicker({
	            changeYear: true,
	            dateFormat: 'dd-M-yy',
	            changeMonth: true,
	            buttonImageOnly: true,
	            minDate: '01-Apr-2019',
	            onSelect: function (dateText, inst) {
	                $(rowid).closest('tr').find('#txtSettleChequeDate' + Sno).val(dateText);
	            }

	        });
	    }
		</script>
		<script type="text/javascript">
		    $('#btnOldPatient').click(function (e) {
		        showPatientSearchPopUpModel();
		        $('#PatientDetails').css({ "background-color": "#ccc" });
		        $('#txtSearchPatientID').focus();
		        getDate();
		    });
		    function getDate() {
		        $.ajax({
		            url: "../Common/CommonService.asmx/getDate",
		            data: '{}',
		            type: "POST",
		            dataType: "json",
		            contentType: "application/json; charset=utf-8",
		            success: function (mydata) {
		                var data = mydata.d;
		                $('#txtTDSearch,#txtFDSearch').val(data);
		            }
		        });
		    }
		    var _PageSize = 4;
		    var _PageNo = 0;
		    var OldPatient = "";
		    function oldPatientSearch() {
		        $('#btnView').attr('disabled', 'disabled');
		        $('#spnOldPatient').text('');
		        $.ajax({
		            type: "POST",
		            url: "Services/Panel_Invoice.asmx/oldPatientSearch",
		            data: '{PatientID:"' + $.trim($("#txtSearchPatientID").val()) + '",PName:"' + $.trim($("#txtPatientFName").val()) + '",LName:"' + $.trim($("#txtPatientLname").val()) + '",ContactNo:"' + $.trim($("#txtPhone").val()) + '",Address:"' + $.trim($("#txtSearchAddress").val()) + '",FromDate:"' + $.trim($("#txtFDSearch").val()) + '",ToDate:"' + $.trim($("#txtTDSearch").val()) + '",invoiceSetellment:"' + 1 + '",PanelID:"' + $('#ddlPanel').val() + '"}',
		            dataType: "json",
		            contentType: "application/json;charset=UTF-8",
		            success: function (response) {
		                OldPatient = jQuery.parseJSON(response.d);
		                if (OldPatient != null) {
		                    _PageCount = OldPatient.length / _PageSize;
		                    showPage('0');
		                }
		                else {

		                    $("#spnOldPatient").text('Record Not Found');
		                    $('#PatientOutput').hide();
		                    $('#btnView').removeAttr('disabled');
		                }
		            },
		            error: function (xhr, status) {
		                $('#btnView').removeAttr('disabled');
		            }
		        });
		    }
		    function showPage(_strPage) {
		        _StartIndex = (_strPage * _PageSize);
		        _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
		        var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
		        $('#PatientOutput').html(outputPatient);
		        $('#PatientOutput').show();
		        $('#btnView').attr('disabled', false);
		        $('#tablePatient tr').bind('mouseenter mouseleave', function () {
		            $(this).toggleClass('hover');

		        });
		        $('#tablePatientCount td').bind('mouseenter mouseleave', function () {
		            $(this).toggleClass('Counthover');
		        });
		    }
		    function pageLoad(sender, args) {
		        if (!args.get_isPartialLoad()) {
		            // $addHandler(document, "keydown", onKeyDown);
		        }
		    };
		    function bindPatientDetail(rowid) {
		        var PanelInvoiceNo = $(rowid).closest('tr').find('#tdPanelInvoiceNo').text();
		        $('#txtInvoice').val(PanelInvoiceNo);
		        closePatientSearchPopUpModel();
		        panelInvoiceSearch();
		        clearPatientDetail();
		    }
		    function ChkDate() {
		        $.ajax({
		            url: "../Common/CommonService.asmx/CompareDate",
		            data: '{DateFrom:"' + $('#txtFDSearch').val() + '",DateTo:"' + $('#txtTDSearch').val() + '"}',
		            type: "POST",
		            dataType: "json",
		            contentType: "application/json; charset=utf-8",
		            success: function (mydata) {
		                var data = mydata.d;
		                if (data == false) {
		                    $('#spnOldPatient').text('To date can not be less than from date!');
		                    $('#btnView').attr('disabled', 'disabled');
		                }
		                else {
		                    $('#spnOldPatient').text('');
		                    $('#btnView').removeAttr('disabled');
		                }
		            }
		        });
		    }
		    function clearPatientDetail() {
		        $('#txtSearchPatientID,#txtPatientFName,#txtPatientLname,#txtPhone,#txtSearchAddress,#txtIPDNo,#txtActIPDNo').val('');
		        $('#PatientOutput').hide();
		        $('#tablePatient,#spnOldPatient').html('');
		        $("#PatientDetails").css("background-color", "");
		    }
		</script>
		<script id="tb_OldPatient" type="text/html">
	    <table  id="tablePatient" cellspacing="0" rules="all" border="1" style="border-collapse:collapse; ">
		<thead>
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Select</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel Invoice No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">First Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Last Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Age</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Sex</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:116px;">Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Address</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Contact&nbsp;No.</th>
		   
		</tr>
			</thead>
		<tbody>
		<#     
			 
			  var dataLength=OldPatient.length;
		if(_EndIndex>dataLength)
			{           
			   _EndIndex=dataLength;
			}
		for(var j=_StartIndex;j<_EndIndex;j++)
			{           
	   var objRow = OldPatient[j];
		#>
						<tr id="Tr2" onclick="bindPatientDetail(this);">                            
						<td class="GridViewLabItemStyle"  style="width:60px; font:bold; font-size:16px">
					       <input type="button"  onclick="bindPatientDetail(this);" style="cursor:pointer;" value="Select" />  
						</td>                                                    
						<td  class="GridViewLabItemStyle" id="tdPanelInvoiceNo"  style="width:200px;"><#=objRow.PanelInvoiceNo#></td>
						<td class="GridViewLabItemStyle" id="tdPFirstName" style="width:140px;"><#=objRow.PFirstName#></td>
						<td class="GridViewLabItemStyle" id="tdPLastName" style="width:140px;"><#=objRow.PLastName#></td>
						<td class="GridViewLabItemStyle" id="td1"  style="width:100px;"><#=objRow.MRNo#></td>
						<td class="GridViewLabItemStyle" id="tdAge" style="width:70px;"><#=objRow.Age#></td>
						<td class="GridViewLabItemStyle" id="tdGender" style="width:80px;"><#=objRow.Gender#></td>
						<td class="GridViewLabItemStyle" id="tdDate" style="width:116px;"><#=objRow.Date#></td>
						<td class="GridViewLabItemStyle" id="tdHouseNo"  style="width:200px;"><#=objRow.SubHouseNo#></td>
						<td class="GridViewLabItemStyle" id="tdContactNo" style="width:80px;"><#=objRow.ContactNo#></td>
						
							  </tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
	 <table id="tablePatientCount" style="border-collapse:collapse;">
	   <tr>
   <# if(_PageCount>4) {
	 for(var j=0;j<_PageCount;j++){ #>
	 <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
	 <#}         
   }
#>

	 </tr>
	 
	 </table>  
	</script>
     <div id="divPatientSearchPopUpModel" class="modal fade">
          <div class="modal-dialog">
               <div class="modal-content" style="width: 1100px">
                     <div class="modal-header">
                                <button type="button" class="close" onclick="closePatientSearchPopUpModel()" aria-hidden="true">&times;</button>
                                	<h4 class="modal-title">Old Patient Search</h4>
                            </div>
                     <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                        <div class="row">
					                         <div  class="col-md-4">
						                          <label class="pull-left">  UHID </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                 <input type="text" id="txtSearchPatientID"  title="Enter UHID" maxlength="20" />
					                         </div>
                                             <div  class="col-md-4">
						                          <label class="pull-left">  First Name </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                 <input type="text" id="txtPatientFName" title="Enter First Name" maxlength="20"/>
					                         </div>
                                        </div>
                                         <div class="row">
					                         <div  class="col-md-4">
						                          <label class="pull-left">  Last Name </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                <input type="text" id="txtPatientLname"  title="Enter Last Name" maxlength="20"/>
					                         </div>
                                             <div  class="col-md-4">
						                          <label class="pull-left">  Contact No. </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                 <input type="text" id="txtPhone" title="Enter Contact No." maxlength="15""/>
					                         </div>
                                        </div>
                                        <div class="row">
					                         <div  class="col-md-4">
						                          <label class="pull-left">  Address </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                <input type="text" id="txtSearchAddress"  title="Enter Address" maxlength="50"/>
					                         </div>
                                             <div  class="col-md-4">
						                          <label class="pull-left">Panel</label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                <select id="ddlPanel"></select>
					                         </div>
                                        </div>
                                        <div class="row">
					                         <div  class="col-md-4">
						                          <label class="pull-left">  From Date </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                <asp:TextBox ID="txtFDSearch" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static"></asp:TextBox>
							                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="txtFDSearch" Format="dd-MMM-yyyy">
							                    </cc1:CalendarExtender>
					                         </div>
                                             <div  class="col-md-4">
						                          <label class="pull-left">To Date </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">    
							                    <asp:TextBox ID="txtTDSearch" runat="server"   ClientIDMode="Static" ToolTip="Click To Select To Date " ></asp:TextBox>
							                    <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="txtTDSearch" Format="dd-MMM-yyyy">
							                    </cc1:CalendarExtender>
					                         </div>
                                        </div>
                                        <div style="text-align:center" class="row">
					                       <input type="button" id="btnView" value="Search" class="ItDoseButton" title="Click to Search"   onclick ="oldPatientSearch()"/>   
				                        </div>
				                        <div style="height:150px; overflow:auto"  class="row">
					                        <div id="PatientOutput" class="col-md-24">
					                        </div>
				                        </div>               
	                                    </div>

                                </div>
                            </div>
                     <div class="modal-footer">
                                <div class="row">
                                    <button type="button"  onclick="closePatientSearchPopUpModel()">Close</button>
                                </div>
                     </div>
                </div>
           </div>
     </div>

    <script type="text/javascript">



        var onSettelmentTypeChange = function (el) {
            if (Number(el.value) == 1)
                $(ddlAccountVoucher).val('0').removeClass('required').attr('disabled', true);
            else
                $(ddlAccountVoucher).val('0').addClass('required').attr('disabled', false);

            disableControls();
        }

        var disableControls = function () {
            $("#tb_grdSearch tr").each(function (index, value) {
                var id = $(this).closest("tr").attr("id");
                if (id != "invoiceHeader") {
                    if ($('#ddlSettlementType').val() == "1") {

                        $(this).closest('tr').find("#ddlCurrency").val('<%=Resources.Resource.BaseCurrencyID%>').attr('disabled', false);
                        $(this).closest('tr').find("#ddlSettPaymentMode").val('0').attr('disabled', false);
                        $(this).closest('tr').find("#ddlSettBank").val('0').show();
                        $(this).closest('tr').find("#spnBankName").text('').hide();
                        $(this).closest('tr').find("#txtChequeNo").val('').attr('disabled', false);
                        $(this).closest('tr').find("#tdCurFactor").text('1.0000');
                    }
                    else {
                        $(this).closest('tr').find("#ddlCurrency").val('<%=Resources.Resource.BaseCurrencyID%>').attr('disabled', true);
                        $(this).closest('tr').find("#ddlSettPaymentMode").val('0').attr('disabled', true);
                        $(this).closest('tr').find("#ddlSettBank").val('0').hide();
                        $(this).closest('tr').find("#spnBankName").text('').show();
                        $(this).closest('tr').find("#txtChequeNo").val('').attr('disabled', true);
                        $(this).closest('tr').find("#tdCurFactor").text('1.0000');
                    }
                }
            });
        }
        var onAccountVoucherChange = function (el) {
            voucherID = $(el).val();
            serverCall('InvoiceSettlement.aspx/GetAccountVoucherDetails', { VoucherID: voucherID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    $('#spnOnAccountDetail').text(responseData[0].VoucherDetail);
                    $('#trOnAccountDetail').show();

                    $("#tb_grdSearch tr").each(function (index, value) {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "invoiceHeader") {
                            $(this).closest('tr').find("#ddlCurrency").find("option:contains(" + responseData[0].Currency + ")").attr('selected', 'selected');
                            $(this).closest('tr').find("#ddlSettPaymentMode").val(responseData[0].PaymentMode);
                            $(this).closest('tr').find("#spnBankName").text(responseData[0].BankName);
                            $(this).closest('tr').find("#txtChequeNo").val(responseData[0].VoucherNo);
                            $(this).closest('tr').find("#tdCurFactor").text(responseData[0].CurrencyConversion);

                            var SpecificBal = precise_round(parseFloat(Number($(this).closest('tr').find("#txtBalanceAmt").val()) / Number(responseData[0].CurrencyConversion)), 4);
                            $(this).closest('tr').find("#tdBalanceSpecific").text(SpecificBal);

                        }
                    });

                }
                else {
                    $('#trOnAccountDetail').hide();
                    $('#spnOnAccountDetail').text('');
                }
            });
        }


        var bindSettelmentType = function () {
            var panelID = Number($("#spnPanelID").text());
            serverCall('InvoiceSettlement.aspx/GetPanelAccountVoucher', { panelID: panelID }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlAccountVoucher').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Text' });
            });
        }

        var $bindPanel = function (callback) {
            serverCall('../Common/CommonService.asmx/bindPanelRoleWisePanelGroupWise', { Type: 2 }, function (response) {
                var $ddlParentPanel = $('#ddlPanel');
                $ddlParentPanel.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
                // $("#ddlPanel option[value='1']").chosen('destroy').remove().chosen();
            });
        }


    </script>
</asp:Content>

