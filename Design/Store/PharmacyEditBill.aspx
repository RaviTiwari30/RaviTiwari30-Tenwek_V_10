<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PharmacyEditBill.aspx.cs" Inherits="Design_Store_PharmacyEditBill" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/wuc_PaymentDetailsJSON.ascx" TagName="wuc_PaymentControl"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

      <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>


   <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function chkType() {
            if (jQuery('input[name=type]:checked').val() == "1") {
                jQuery("#trCancel,#divCancel").hide();
                jQuery("#pnlEdit").show();
                jQuery("#txtCancelReason").val('');

            }
            else {
                if (jQuery("#spnMRNo").text() != "") {
                    jQuery("#trCancel,#divCancel").show();
                }               
            }
            jQuery("#txtCancelReason").val('').focus();
            jQuery("#pnlEdit").hide();
        }
    </script>
     <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ToolkitScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Pharmacy Credit Bill Return </b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <asp:TextBox ID="txtHash" ClientIDMode="Static" runat="server" CssClass="txtHash" Style="display: none"
                Width="85px"> </asp:TextBox>
            <asp:Label ID="lblOPDPharmacyEditBill" runat="server" Style="display: none"></asp:Label>
            <span style="display:none">
            <input type ="radio" id="rdoHospitalPatient" value="1" name="group1" checked="checked"  > Hospital Patient
          <input type ="radio" id="rdoGeneral" value="2" name="group1" > General
            <input type ="radio" id="rdoEdit" value="1" onclick="chkType()" name="type" checked="checked"  > Edit
          <input type ="radio" id="rdoCancel" value="2" name="type" onclick="chkType()" > Cancel  </span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <table style="width: 100%">
                <tr>
                    <td style="text-align: right; width: 15%;">Bill No. :&nbsp;
                    </td>
                    <td style="text-align: left; width: 25%;">
                        <input type="text" id="txtBillNo" class="required" />
                    </td>
                    <td style="text-align: left; width: 10%;"></td>
                    <td style="text-align: right; width: 15%;">
                       
                    </td>
                    <td style="text-align: left; width: 25%;">
                     
                    </td>
                    <td style="text-align: left; width: 10%;"></td>
                    <td style="text-align: left; width: 10%;"></td>
                </tr>
            </table>
            </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" value="Search" id="btnSearch" class="ItDoseButton" onclick="searchPharmacy()" />
        </div>
            <asp:Panel ID="pnlAllInfo" runat="server" ClientIDMode="Static" Style="display:none">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <table style="width: 100%">

                <tr>
                    <td style="width: 20%; text-align: right">UHID :&nbsp;
                    </td>
                    <td style="width: 20%; text-align: left">
                        <span id="spnMRNo" class="ItDoseLabelSp"></span>

                    </td>
                    <td style="width: 20%; text-align: right">Patient Name :&nbsp;
                    </td>
                    <td colspan="2" style="width: 20%; text-align: left">

                        <span id="spnPatientName" class="ItDoseLabelSp"></span>
                        <span id="spnLedgerNo" class="ItDoseLabelSp" style="display:none"></span>
                        <span id="spnTransactionID" class="ItDoseLabelSp" style="display:none"></span> 

                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">Contact No. :&nbsp;
                    </td>
                    <td style="width: 20%; text-align: left">
                        <span id="spnContactNo" class="ItDoseLabelSp"></span>

                    </td>
                    <td style="width: 20%; text-align: right">Net Amt. :&nbsp;
                    </td>
                    <td style="width: 20%; text-align: left">
                        <span id="spnNetAmt" class="ItDoseLabelSp"></span>

                    </td>
                    <td style="width: 20%">
                        <span id="spnCustomerID" class="ItDoseLabelSp" style="display:none"></span>
                         <span id="spnDeptLedgerNo" class="ItDoseLabelSp" style="display:none"></span>
                        <span id="spnRefundAgainstBillNo" class="ItDoseLabelSp"  style="display:none"></span>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">Age :&nbsp;
                    </td>
                    <td style="text-align: left; width: 20%">
                        <span id="spnAge" class="ItDoseLabelSp"></span>

                    </td>
                    <td style="text-align: right; width: 20%">Amount Paid :&nbsp;
                    </td>
                    <td style="width: 20%; text-align: left">
                        <span id="spnAmtPaid" class="ItDoseLabelSp"></span>
                        <span id="spnReceiptNo" class="ItDoseLabelSp"  style="display:none"></span>

                    </td>
                    <td style="width: 20%">
                        <span id="spnDoctorID" class="ItDoseLabelSp"  style="display:none"></span>
                        <span id="spnPanelID" class="ItDoseLabelSp"  style="display:none"></span>
                        <span id="spnapplyCreditLimit" class="ItDoseLabelSp"  style="display:none"></span>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">Address :&nbsp;
                    </td>
                    <td style="text-align: left; width: 20%">
                        <span id="spnAdress" class="ItDoseLabelSp"></span>
                    </td>
                    <td style="text-align: right; width: 20%">Balance  :&nbsp;
                    </td>
                    <td style="width: 20%; text-align: left">
                        <span id="spnBalance" class="ItDoseLabelSp"></span>

                    </td>
                    <td style="width: 20%">
                        <span id="spnAppBy" class="ItDoseLabelSp"  style="display:none"></span>
                        <span id="spnDiscReason" class="ItDoseLabelSp"  style="display:none"></span>
                        <span id="spnGovTaxAmt" class="ItDoseLabelSp"  style="display:none"></span>
                        <span id="spnGovTaxPer" class="ItDoseLabelSp"  style="display:none"></span>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">Payment Status :&nbsp;
                    </td>
                    <td style="text-align: left; width: 20%">
                        <span id="spnPaymentStatus" class="ItDoseLabelSp"></span>
                    </td>
                    <td style="text-align: right; width: 20%">&nbsp;</td>
                    <td style="width: 20%; text-align: left"> 
                        &nbsp;
                         </td>
                    <td style="width: 20%"></td>
                </tr>
                <tr id="trCancel" style="display:none">
                    <td style="text-align: right; width: 20%">
                        Cancel Reason :&nbsp;
                    </td>
                   <td style="text-align: left; width: 20%" colspan="2">
                        <input type="text" id="txtCancelReason" maxlength="50"  style="width:240px"/>
                         <span style="color: red; font-size: 10px;"  class="shat">*</span>
                    </td>
                </tr>
            </table>

        </div>
                </asp:Panel>
                <asp:Panel ID="pnlEdit" runat="server" ClientIDMode="Static" style="display:none">
         <div class="POuter_Box_Inventory">
				<div class="Purchaseheader" >
					Batch Type Item Selection
				</div>
			   <div id="ItemOutput" style="max-height: 600px; overflow-x: auto;">
						</div>
				<div style="width: 100%; text-align: center;">
				   
					 <input type="button" style="display:none" value="Add Item" class="ItDoseButton"  id="btnAddItem" onclick="addItem()"/>
					 <input type="button" style="display:none" value="Cancel" class="ItDoseButton"  id="btnRCancel"/>
				   </div>
						 

			</div>
         <asp:Panel ID="pnlReturn" runat="server" ClientIDMode="Static" Style="display:none">
        <div class="POuter_Box_Inventory" id="div_Issue">
				<div class="Purchaseheader" >
					Return Medicines
				</div>
				<div style="text-align: center;">
					<table style="width: 100%; border-collapse: collapse">
				<tr style="text-align: center">
					<td colspan="4">
						<table class="GridViewStyle" border="1" id="tb_grdIssueItem"
							style="width: 100%; border-collapse: collapse; display: none;">
							<tr id="ReturnItemHeader">
								
								<th class="GridViewHeaderStyle" scope="col" style="width: 360px;">Item Name
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 160px;">Batch No.
								</th>							
								<th class="GridViewHeaderStyle" scope="col" style="width: 90px; ">Unit
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Qty.
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 120px;">Unit&nbsp;Cost
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 160px;">Total&nbsp;Cost
								</th>
								 <th class="GridViewHeaderStyle" scope="col" style="width: 160px;display:none">ItemID
								</th>
								 <th class="GridViewHeaderStyle" scope="col" style="width: 160px;display:none">StockID
								</th>
								 
								 <th class="GridViewHeaderStyle" scope="col" style="width: 160px;display:none">ToBeBilled
								</th>
								 <th class="GridViewHeaderStyle" scope="col" style="width: 160px;display:none">Type_ID
								</th>
								 <th class="GridViewHeaderStyle" scope="col" style="width: 160px;display:none">IsUsable
								</th>
								
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">PerUnitBuyPrice
								 </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">DiscAmt
								 </th>		
                                		<th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">LTDID
								 </th>	
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">ActualQty
								 </th>		
                                 <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">SDID
								 </th>					
								<th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Remove
								</th>
							</tr>
						</table>
					</td>
				</tr>
			</table>
				</div>
			</div>
        <div class="POuter_Box_Inventory" style="display:none">			
				<table style="width:100%">
					<tr>
						<td style="width:25%">
							&nbsp;
						</td>
						<td style="text-align:right;width:25%; font:bold">
						 <asp:Label ID="lblTotalBillAmount" Text="Total Bill Amount :" ClientIDMode="Static" runat="server" style="display:none"   Font-Bold="true"></asp:Label> 
						</td>
						<td style="text-align:left;width:25%">
							 <asp:Label ID="lblBillAmount" runat="server" Font-Bold="true" ClientIDMode="Static" style="display:none"></asp:Label>
                            <asp:Label ID="lblNetAmount" runat="server" Font-Bold="true" ClientIDMode="Static" style="display:none"></asp:Label>
                        </td>
						<td style="width:25%">
							&nbsp;
						</td>
					</tr>
				</table>
		   
			</div>
         <div class="POuter_Box_Inventory" style="text-align: center;">

            <uc2:wuc_PaymentControl ID="PaymentControl" runat="server" />

        </div>
			<div class="POuter_Box_Inventory" style="text-align: center">
				<input type="button" value="Save" class="ItDoseButton" onclick="editPharmacyBill()"  id="btnSave" style="display:none"/>
			</div>
                </asp:Panel>
                    </asp:Panel>
             <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="divCancel">
				<input type="button" value="Cancel" class="ItDoseButton" onclick="cancelPharmacyBill()"  id="btnCancel"/>
			</div>
         </div>
     <script type="text/javascript">
         jQuery(function () {
             jQuery("#txtBillNo").focus();
             jQuery(".ItDoseTextinputNum").attr('disabled', 'disabled');
         });
         function searchPharmacy() {
             if ((jQuery.trim(jQuery("#txtBillNo").val()) != "")) {
                 jQuery("#spnErrorMsg").text('');
                 jQuery.ajax({
                     url: "PharmacyEditBill.aspx/pharmacyReturnSearch",
                     data: '{BillNo:"' + jQuery("#txtBillNo").val() + '"}',
                     type: "Post",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         Newitem = jQuery.parseJSON(result.d);
                         if (Newitem.status) {
                             modelAlert(Newitem.message);
                         }
                         else {
                             if ((Newitem != "") && (Newitem != null)) {
                                 if (Newitem == "2") {
                                     modelAlert('You Cannot Edit Bill after 2 Hours');
                                     clearControl();
                                     return;
                                 }
                                 var output = jQuery('#tb_Item').parseTemplate(Newitem);
                                 jQuery('#ItemOutput').html(output);
                                 jQuery('#ItemOutput').show();
                                 if (jQuery('#rdoHospitalPatient').is(':checked'))
                                     jQuery('#spnMRNo').text(Newitem[0]["PatientID"]);
                                 else
                                     jQuery('#spnMRNo').text(Newitem[0]["CustomerID"]);

                                 jQuery('#spnCustomerID').text(Newitem[0]["CustomerID"]);
                                 jQuery('#spnDeptLedgerNo').text(Newitem[0]["DeptLedgerNo"]);
                                 jQuery('#spnPatientName').text(Newitem[0]["PName"]);
                                 jQuery('#spnAdress').text(Newitem[0]["Address"]);
                                 jQuery('#spnLedgerNo').text(Newitem[0]["LedgerTransactionNo"]);
                                 jQuery('#spnTransactionID').text(Newitem[0]["TransactionID"]);

                                 jQuery('#spnAmtPaid').text(Newitem[0]["Adjustment"]);
                                 jQuery('#spnContactNo').text(Newitem[0]["ContactNo"]);
                                 jQuery('#spnDoctorID').text(Newitem[0]["DoctorID"]);
                                 jQuery('#spnPanelID').text(Newitem[0]["PanelID"]);

                                 jQuery('#spnAge').text(Newitem[0]["Age"]);
                                 jQuery('#spnNetAmt').text(Newitem[0]["NetAmount"]);
                                 if (jQuery('#spnMRNo').text().trim() == "CASH002") {
                                     jQuery('#spnBalance').text('0');
                                     jQuery('#spnapplyCreditLimit').text('0');
                                 }

                                 else {
                                     jQuery('#spnBalance').text(Newitem[0]["Balance"]);
                                     jQuery('#spnapplyCreditLimit').text(Newitem[0]["applyCreditLimit"]);
                                 }
                                 jQuery('#spnNetAmt').text(Newitem[0]["NetAmount"]);
                                 jQuery('#spnPaymentStatus').text(Newitem[0]["PaymentMode"]);
                                 jQuery('#btnAddItem').show();
                                 if (jQuery('#spnPaymentStatus').text() == "Credit")
                                     jQuery('#<%=PaymentControl.FindControl("ddlPaymentMode").ClientID %>').append($("<option></option>").val('4').html('Credit'));
                                 else
                                     jQuery('#<%=PaymentControl.FindControl("ddlPaymentMode").ClientID %>').append($("<option></option>").val('1').html('Cash'));
                                 jQuery('#spnRefundAgainstBillNo').text(Newitem[0]["BillNo"]);
                                 jQuery('#spnGovTaxPer').text(Newitem[0]["GovTaxPer"]);
                                 jQuery('#spnDiscReason').text(Newitem[0]["DiscountReason"]);
                                 jQuery('#spnAppBy').text(Newitem[0]["DiscountApproveBy"]);
                                 if ((jQuery('#spnPaymentStatus').text()) != "Credit") {
                                     if ((precise_round((parseFloat(jQuery('#spnNetAmt').text()) - parseFloat(jQuery('#spnAmtPaid').text())), 2) > 0) && ((Newitem[0]["IsPaid"]) != "0")) {
                                         jQuery("#spnErrorMsg").text("Please Settle Previous Amount");
                                         jQuery('#pnlAllInfo,#pnlReturn').hide();
                                         return;
                                     }
                                 }

                                 else if (jQuery('#spnapplyCreditLimit').text() == "0") {
                                     jQuery('#rdoAmt,#rdoPer').attr('disabled', 'disabled');
                                     jQuery('#spnAmt,#spnType').text('');
                                 }
                                 else {
                                     jQuery('#spnAmt').text('0');
                                     jQuery('#rdoAmt,#rdoPer').removeAttr('disabled', 'disabled');
                                 }

                                 jQuery('#pnlReturn').hide();
                                 if (jQuery('#spnMRNo').text().trim() == "CASH002") {
                                     jQuery('#rdoAmt,#rdoPer').attr('disabled', 'disabled');
                                 }
                                 chkType();
                                 jQuery('#pnlAllInfo,#pnlEdit').show();
                             }
                             else {
                                 DisplayMsg('MM04', 'spnErrorMsg');
                                 jQuery("#tb_grdIssueItem tr:not(:first)").remove();
                                 jQuery("#trCancel,#divCancel,#pnlAllInfo").hide();
                             }
                         }
                     },
                     error: function (xhr, status) {
                         DisplayMsg('MM05', 'spnErrorMsg');
                         jQuery('#pnlAllInfo,#pnlReturn,#trCancel,#divCancel').hide();
                     }

                 });
             }
             else {
                 jQuery("#spnErrorMsg").text('Please Enter Bill No.');
                 jQuery("#txtBillNo").focus();
                 jQuery("#pnlAllInfo,#pnlReturn,#pnlEdit").hide();
                 jQuery("#tb_grdIssueItem tr:not(:first)").remove();
                 jQuery("#trCancel,#divCancel").hide();
             }
         }
    </script>
         <script id="tb_Item" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdItem"
	style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:440px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">Batch No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">IsExpirable</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Expiry</th>		          	
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Unit Cost</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Available&nbsp;Qty.</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:180px;">Unit</th>	               
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Return Qty.</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">ItemID</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">stockID</th>	
			
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">ToBeBilled</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">Type_ID</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">IsUsable</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none; ">ServiceItemID</th>          
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none ">LedgerTransactionNo</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">GrossAmount</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; "> DiscountOnTotal</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">PerUnitBuyPrice</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">LTDID</th>  
             <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none; ">SDID</th>   
		</tr>
		<#       
		var dataLength=Newitem.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		for(var j=0;j<dataLength;j++)
		{       
		objRow = Newitem[j];
		#>
					<tr id="<#=j+1#>">                            
					<td class="GridViewLabItemStyle" id="tdItemChk" style="width:10px;"><input type="checkbox" onclick="showReturnText(this);" checked="checked" id="chkItem"<#=j+1#></td>
					<td class="GridViewLabItemStyle" id="tdItemName"  style="width:440px;text-align:left" ><#=objRow.ItemName#></td>
					<td class="GridViewLabItemStyle" id="tdBatchNumber"  style="width:240px;text-align:center" ><#=objRow.BatchNumber#></td>
                    <td class="GridViewLabItemStyle" id="tdIsExpirable" style="width:60px;text-align:center; "><#=objRow.IsExpirable#></td>    
					<td class="GridViewLabItemStyle" id="tdMedExpiryDate" style="width:160px;text-align:center; "><#=objRow.MedExpiryDate#></td>
					<td class="GridViewLabItemStyle" id="tdMRP" style="width:120px;text-align:right;"><#=objRow.MRP#></td>
					<td class="GridViewLabItemStyle" id="tdAvlQty" style="width:100px;text-align:right"><#=objRow.AvlQty#></td>
					<td class="GridViewLabItemStyle" id="tdUnitType" style="width:180px;text-align:center"><#=objRow.UnitType#></td>
					<td class="GridViewLabItemStyle" id="tdReturnQty" style="width:120px;text-align:center"><input type="text" style="width:60px" value="<#=objRow.AvlQty#>" id="txtReturnQty" maxlength="6" onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum"  onkeyup="CheckQty(this);"><span style="color: Red; font-size: 10px;" class="shat">*</span></td>
					<td class="GridViewLabItemStyle" id="tdItemID" style="width:180px;text-align:center;display:none"><#=objRow.ItemID#></td>
					<td class="GridViewLabItemStyle" id="tdstockID" style="width:180px;text-align:center;display:none"><#=objRow.StockID#></td>
					<td class="GridViewLabItemStyle" id="tdToBeBilled" style="width:180px;text-align:center;display:none"><#=objRow.ToBeBilled#></td>
					<td class="GridViewLabItemStyle" id="tdType_ID" style="width:180px;text-align:center;display:none"><#=objRow.Type_ID#></td>
					<td class="GridViewLabItemStyle" id="tdIsUsable" style="width:180px;text-align:center;display:none"><#=objRow.IsUsable#></td>
					<td class="GridViewLabItemStyle" id="tdServiceItemID" style="width:80px;text-align:center;display:none"><#=objRow.ServiceItemID#></td>
					<td class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style="width:40px;text-align:center;display:none"><#=objRow.LedgerTransactionNo#></td>
                    <td class="GridViewLabItemStyle" id="tdGrossAmount" style="width:40px;text-align:center;display:none"><#=objRow.GrossAmount#></td>
                    <td class="GridViewLabItemStyle" id="tdDiscountOnTotal" style="width:40px;text-align:center;display:none"><#=objRow.DiscountOnTotal#></td>   
                    <td class="GridViewLabItemStyle" id="tdPerUnitBuyPrice" style="width:40px;text-align:center;display:none"><#=objRow.PerUnitBuyPrice#></td>       
                     <td class="GridViewLabItemStyle" id="tdLTDID" style="width:40px;text-align:center;display:none"><#=objRow.ID#></td>       
                                          <td class="GridViewLabItemStyle" id="tdsdID" style="width:40px;text-align:center;display:none"><#=objRow.sdID#></td>       
   
                         </tr>            
		<#}        
		#>      
	 </table>    
	</script>
<script type="text/javascript">
    function showReturnText(rowid) {

        jQuery(rowid).closest('tr').find("#txtReturnQty").removeAttr('disabled');
    }

    function addItem() {
        var con = 0; var chk = 1;
        jQuery("#tb_grdItem tr").each(function () {
            var id = jQuery(this).closest("tr").attr("id");
            var $rowid = jQuery(this).closest("tr");
            if (id != "Header") {
                if (jQuery(this).find("#chkItem").is(":checked")) {
                    if (jQuery.trim(jQuery(this).find("#txtReturnQty").val()) <= "0") {
                        modelAlert('Please Enter Return Qty.');
                        jQuery(this).find("#txtReturnQty").focus();

                        return false;
                    }
                    chk += chk;
                    if (parseFloat(jQuery.trim(jQuery(this).find("#txtReturnQty").val())) > parseFloat((jQuery.trim($rowid.find("#tdAvlQty").html())))) {
                        modelAlert('Return Qty. Can Not Greater Then Available Qty.');
                        con = 1;
                        return false; 
                    }
                    var stockID = $rowid.find("#tdstockID").html();
                    jQuery("#tb_grdIssueItem tr").each(function () {
                        var IssueItemid = jQuery(this).closest("tr").attr("id");
                        var $IssueItemrowid = jQuery(this).closest("tr");
                        if (IssueItemid != "ReturnItemHeader") {
                            var IssuestockID = $IssueItemrowid.find("#tdStockID").html();
                            if (stockID == IssuestockID) {
                                modelAlert('Item Already Selected');
                                con = 1;
                                return false;
                            }
                        }
                    });

                }
            }
        });
        if (chk == "1") {
            modelAlert('Please Enter Return Qty.');
            return false;
        }
        var totalAmount = 0; var totalGST = 0; var DiscAmt = 0; var TaxAmt = 0; var netAmount = 0;
        if ((con == "0") && (chk > 1)) {
            jQuery("#spnErrorMsg").text('');
            jQuery("#tb_grdItem tr").each(function () {
                if (!isNaN(parseFloat(jQuery(this).find('#txtReturnQty').val()))) {

                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if ((id != "Header") && ($rowid.find("#chkItem").is(':checked'))) {
                        RowCount = jQuery("#tb_grdIssueItem tr").length;
                        RowCount = RowCount + 1;
                        var discPer = 0; var DiscAmt = 0;
                        var amount = parseFloat(parseFloat(jQuery(this).find('#txtReturnQty').val()) * parseFloat(jQuery.trim($rowid.find('#tdMRP').html())));

                        var grossAmount = jQuery.trim($rowid.find("#tdGrossAmount").text());
                        var discountOnTotal = jQuery.trim($rowid.find("#tdDiscountOnTotal").text());
                        if (tdDiscountOnTotal != "0.00") {
                            discPer = parseFloat((discountOnTotal * 100) / grossAmount);
                            DiscAmt = parseFloat((amount * discPer) / 100);
                        }

                        var newRow = jQuery('<tr />').attr('id', 'tr_' + RowCount);
                        newRow.html(
                             '</td><td class="GridViewLabItemStyle" id="tdItemName">' + $rowid.find("#tdItemName").html() +
                             '</td><td class="GridViewLabItemStyle" id="tdBatchNumber">' + $rowid.find('#tdBatchNumber').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;" id="tdUnitType">' + $rowid.find('#tdUnitType').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdReturnQty">' + jQuery(this).find('#txtReturnQty').val() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdMRP">' + $rowid.find('#tdMRP').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right;" id="tdAmount">' + precise_round(parseFloat((parseFloat(jQuery(this).find('#txtReturnQty').val()) * parseFloat(($rowid.find('#tdMRP').html())))), 2) +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdStockID">' + $rowid.find('#tdstockID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdItemID">' + $rowid.find('#tdItemID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdToBeBilled">' + $rowid.find('#tdToBeBilled').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdIsUsable">' + $rowid.find('#tdIsUsable').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdType_ID">' + $rowid.find('#tdType_ID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdPerUnitBuyPrice">' + $rowid.find('#tdPerUnitBuyPrice').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdDiscAmt">' + DiscAmt +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdLTDID">' + $rowid.find('#tdLTDID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdActualQty">' + $rowid.find('#tdAvlQty').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdSDID">' + $rowid.find('#tdsdID').html() +

                            '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgRemove"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);" onmouseover="chngcur()"   style="cursor:pointer;" title="Click To Remove"/></td>'
                            );
                        jQuery("#tb_grdIssueItem").append(newRow);
                        jQuery("#tb_grdIssueItem").show();


                    }


                }
            });
            jQuery("#tb_grdIssueItem tr:not(:first)").each(function () {

                totalAmount += parseFloat(jQuery(this).closest("tr").find("#tdAmount").html());
                DiscAmt += parseFloat(jQuery(this).closest("tr").find("#tdDiscAmt").html());

            });
            netAmount = parseFloat(totalAmount - DiscAmt);
           
            jQuery("#lblBillAmount").text(totalAmount);
            jQuery("#lblNetAmount").text(netAmount);
            jQuery('#lblTotalBillAmount,#btnSave,#lblBillAmount,#pnlReturn').show();
            updateTotalAmount(jQuery('#lblBillAmount').text(), netAmount, DiscAmt, "0", "0", "0");
            chkItemCount();
        }
    }
    function chkItemCount() {

        if (jQuery("#tb_grdIssueItem tr:not(:first)").length > 0)
            jQuery("#btnSearch,#rdoEdit,#rdoCancel").attr('disabled', 'disabled');
        else
            jQuery("#btnSearch,#rdoEdit,#rdoCancel").removeAttr('disabled');
    }
    function DeleteRow(rowid) {
        var totalAmount = 0; var totalGST = 0; var DiscAmt = 0; var netAmount = 0;
        var row = rowid;
        jQuery(row).closest('tr').remove();
        jQuery("#tb_grdIssueItem tr").each(function () {
            var id = jQuery(this).closest("tr").attr("id");
            if (id != "ReturnItemHeader") {
                totalAmount += eval(jQuery(this).closest("tr").find("#tdAmount").html());
                DiscAmt += eval(jQuery(this).closest("tr").find("#tdDiscAmt").html());
            }
        });
        jQuery("#lblBillAmount").text(totalAmount);
        netAmount = parseFloat(totalAmount - DiscAmt);
        jQuery("#lblNetAmount").text(netAmount);
        if (jQuery("#tb_grdIssueItem tr").length == "1") {
            jQuery('#tb_grdIssueItem,#lblBill,#btnSave,#lblBillAmount,#pnlReturn').hide();
        }
        else {
            jQuery('#lblTotalBillAmount,#btnSave,#lblBillAmount,#pnlReturn').show();
        }
        updateTotalAmount(jQuery('#lblBillAmount').text(), netAmount, DiscAmt, "0", "0", "0");
        chkItemCount();
    }
</script>
    <script type="text/javascript">
        function CheckQty(Qty) {
            var Amt = jQuery(Qty).val();
            if (Amt.match(/[^0-9]/g)) {
                Amt = Amt.replace(/[^0-9]/g, '');
                jQuery(Qty).val(Number(Amt));
                return;
            }
            if (Amt.charAt(0) == "0") {
                jQuery(Qty).val(Number(Amt));
            }
            if (Amt.indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = Amt.indexOf(".");
                if (valIndex > "0") {
                    if (Amt.length - (Amt.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        jQuery(Qty).val(jQuery(Qty).val().substring(0, (jQuery(Qty).val().length - 1)));
                        return false;
                    }
                }
            }
            if (Amt == "") {
                jQuery(Qty).val('1');
            }
        }
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
        function chngcur() {
            document.body.style.cursor = 'pointer';
        }
    </script>
    <script type="text/javascript">


        function checkForSecondDecimalCredit(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            if ((strVal == "0") && (charCode == 48)) {
                strVal = Number(strVal);
                sender.value = sender.value.substring(0, (sender.value.length - 1));

            }
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
        function cancelPharmacyBill() {
            if (jQuery.trim(jQuery('#txtCancelReason').val()) != "") {
                jQuery("#btnCancel").attr('disabled', 'disabled').val("Submitting...");
                jQuery.ajax({
                    url: "PharmacyEditBill.aspx/cancelPharmacyBill",
                    data: JSON.stringify({ LedgertransactionNo: jQuery.trim(jQuery('#spnLedgerNo').text()), TransactionID: jQuery('#spnTransactionID').text(), PatientID: jQuery('#spnMRNo').text(), BillAmt: jQuery("#lblBillAmount").text(), type: jQuery('input[name=type]:checked').val(), cancelReason: jQuery('#txtCancelReason').val() }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            modelAlert('Record Saved Successfully');
                        }
                        else if (result.d == "2") {
                            modelAlert('Stock already return please reopen the page');
                            clearControl();
                            jQuery("#txtBillNo").val('');
                            return;
                        }
                        else {
                            modelAlert('Error occurred, Please contact administrator');
                        }
                        clearControl();
                        jQuery("#txtBillNo").val('');
                    }

                });
            }

            else {
                modelAlert('Please Enter Cancel Reason');
                jQuery('#txtCancelReason').focus();
            }
        }
    </script>
    <script type="text/javascript">
        function editPharmacyBill() {
            jQuery("#btnSave").val("Submitting...").attr('disabled', 'disabled');
            var ltd = LedgerTransactionDetail();
            jQuery.ajax({
                url: "PharmacyEditBill.aspx/editPharmacyBillBill",
                data: JSON.stringify({ detail: ltd, LedgertransactionNo: jQuery.trim(jQuery('#spnLedgerNo').text()), TransactionID: jQuery('#spnTransactionID').text(), PatientID: jQuery('#spnMRNo').text(), BillAmt: jQuery("#lblBillAmount").text(), type: jQuery('input[name=type]:checked').val(), cancelReason: jQuery('#txtCancelReason').val() }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        modelAlert('Record Saved Successfully');
                        //window.open('../common/PharmacyReceipt.aspx?LedTnxNo=' + jQuery.trim(jQuery('#spnLedgerNo').text()) + '&OutID=' + jQuery('#spnCustomerID').text() + '&DeptLedgerNo=' + jQuery('#spnDeptLedgerNo').text() + '&IsBill=1&Duplicate=0');

                    }
                    else if (result.d == "2") {
                        modelAlert('Stock already return please reopen the page');
                    }

                    else if (result.d == "3") {
                        var PID = jQuery('#spnMRNo').text();
                        var TID = jQuery('#spnTransactionID').text();
                        modelAlert('Record Saved Successfully, Please Enter Debit Notes Of Rs. ' + jQuery("#lblBillAmount").text(), function () {
                            ReseizeIframe(TID, PID, "");
                        });
                       
                        
                    }
                    else {
                        modelAlert('Error occurred, Please contact administrator');
                    }
                    clearControl();
                    jQuery("#txtBillNo").val('');
                }

            });
        }

        function LedgerTransactionDetail() {
            var dataLTDt = new Array();
            var ObjLdgTnxDt = new Object();
            jQuery("#tb_grdIssueItem tr:not(:first)").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "IssueItemHeader") {
                    ObjLdgTnxDt.ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                    ObjLdgTnxDt.StockID = jQuery.trim($rowid.find("#tdStockID").text());
                    ObjLdgTnxDt.Rate = jQuery.trim($rowid.find("#tdMRP").text());
                    ObjLdgTnxDt.Quantity = jQuery.trim($rowid.find("#tdReturnQty").text());
                    ObjLdgTnxDt.ItemName = $rowid.find("#tdItemName").text();
                    ObjLdgTnxDt.Amount = parseFloat($rowid.find("#tdAmount").text());
                    ObjLdgTnxDt.LTDID = jQuery.trim($rowid.find("#tdLTDID").text());
                    ObjLdgTnxDt.ActualQty = jQuery.trim($rowid.find("#tdActualQty").text());
                    ObjLdgTnxDt.SDID = jQuery.trim($rowid.find("#tdSDID").text());
                    dataLTDt.push(ObjLdgTnxDt);
                    ObjLdgTnxDt = new Object();
                }
            });
            return dataLTDt;
        }
    </script>
    <script type="text/javascript">
        function clearControl() {
            jQuery("#tb_grdIssueItem tr:not(:first)").remove();
            jQuery("#btnSave").attr('disabled', false).val("Save");
            jQuery("#btnSearch").attr('disabled', false);
            jQuery("#pnlAllInfo,#trCancel,#divCancel,#ItemOutput,#pnlEdit,#btnAddItem").hide();
            jQuery("#spnTransactionID,#spnCustomerID,#spnMRNo,#spnDeptLedgerNo").text('');
            jQuery("#txtCancelReason").val('');
            jQuery("#btnCancel").attr('disabled', false).val("Cancel");
            jQuery('#ItemOutput').html('');
            jQuery("#btnSearch,#rdoEdit,#rdoCancel").removeAttr('disabled');
        }
    </script>



     <script type="text/javascript">
         function ReseizeIframe(TID, PID, Gender) {
              
             var href = "../IPD/PanelAmountAllocation.aspx?TID=" + TID + "&TransactionID=" + TID + "&App_ID=&PID=" + PID + "&PatientId=" + PID + "&Sex=" + Gender + "&IsIPDData=0&AdmissionType=OPD_Al"
              
             showuploadbox(href, 1400, 1360, '100%', '100%');
         }
         function showuploadbox(href, maxh, maxw, w, h) {
             $.fancybox({
                 maxWidth: maxw,
                 maxHeight: maxh,
                 fitToView: false,
                 width: w,
                 href: href,
                 height: h,
                 autoSize: false,
                 closeClick: false,
                 openEffect: 'none',
                 closeEffect: 'none',
                 'type': 'iframe'
             });
         }
    </script>
</asp:Content>

