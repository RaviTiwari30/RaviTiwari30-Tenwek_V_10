<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientEditBillDetail.aspx.cs" Inherits="Design_EDP_PatientEditBillDetail" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Release">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">          
                <b>Edit Patient Bill</b>
                <br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>            
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width:100%">
                <tr>
                    <td style="width:20%;text-align:right">
                        IPD No. :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtIPDNo" AutoCompleteType="Disabled" runat="server" MaxLength="10" ClientIDMode="Static"></asp:TextBox>
                          <span style="color: red; font-size: 10px;"  class="shat">*</span>
                       
                    </td>
                    <td>

                    </td>
                    <td>

                    </td>
                </tr>
            </table>
            </div> 
        
      <div class="POuter_Box_Inventory" style="text-align:center">
               <input type="button" class="ItDoseButton" id="btnSearch" value="Search"   onclick="searchDetail()" />
                        
                    </div>
        <asp:Panel ID="pnlHideDetail" runat="server" ClientIDMode="Static" Style="display:none">
      <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Details
            </div>
            <table  style="width: 100%; border-collapse:collapse" >
                <tr >
                    <td colspan="4">
                        <div id="PatientSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                       
                    </td>
                </tr>
            </table>
        </div>
      <div id="divPatientDetail" style="display:none">
         <div class="POuter_Box_Inventory">
                <table  style=" width:100%">
                    <tr>
                        <td style="text-align:right;width:20%">
                            UHID :&nbsp;
                        </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnPatientID" class="ItDoseLabelSp"></span>
                             
                        </td>
                        <td style="text-align:right;width:20%">
                            IPD No. :&nbsp;
                            </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnIPDNo" class="ItDoseLabelSp"></span>
                            
                        </td>
                    </tr>
                    <tr>
                         <td style="text-align:right;width:20%">
                            Name :&nbsp;
                        </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnPatientName" class="ItDoseLabelSp"></span>
                            
                        </td>
                         <td style="text-align:right;width:20%">
                            Panel :&nbsp;
                            </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnPanel" class="ItDoseLabelSp"></span>
                            
                        </td>
                    </tr>
                     <tr >
                         <td style="text-align:right;width:20%">
                            Room No. :&nbsp;
                        </td>
                        <td style="text-align:left;width:30%">
                             <span id="spnRoomNo" class="ItDoseLabelSp"></span>
                        </td>
                         <td style="text-align:right;width:20%">
                            Doctor Name :&nbsp;
                            </td>
                       <td style="text-align:left;width:30%">
                            <span id="spnDoctorName" class="ItDoseLabelSp"></span>
                           <span id="spnDoctorID" class="ItDoseLabelSp" style="display:none"></span>
                            <span id="spnBillNo" style="display:none"></span>
                            <span id="spnBillDate" style="display:none"></span>
                            <span id="spnBillTime" style="display:none"></span>
                             <span id="spnLedgerTransactionNo" style="display:none"></span>
                            <span id="spnTransactionID" style="display:none"></span>               
                        </td>
                    </tr>
                     <tr >
                         <td style="text-align:right;width:20%">
                            Date Of Admission :&nbsp;
                        </td>
                        <td style="text-align:left;width:30%">
                            <span id="spnAdmissionDate1" class="ItDoseLabelSp" ></span>
                              <span id="spnAdmissionDate" class="ItDoseLabelSp"  style="display:none"></span>
                        </td>
                         <td style="text-align:right;width:20%">
                            Time Of Admission :&nbsp;
                            </td>
                       <td style="text-align:left;width:30%">
                            <span id="spnTimeOfAdmission" class="ItDoseLabelSp" ></span>
                           </td>
                    </tr>
        </table>
        </div>
            </div>
      <div id="hideItem" style="display:none">
        <div class="POuter_Box_Inventory">
             
        <table  style="width: 100%; border-collapse:collapse;display:none" id="trItemHide">
            
            <tr >
                <td style="text-align:right">Item :&nbsp;</td>
                <td style="text-align:left"><select id="ddlItem" style="width:320px" ></select></td>
                <td>&nbsp;&nbsp;FromDate :&nbsp;</td>
                <td>
                    <asp:TextBox type="text" ID="txtFromDate" runat="server" ClientIDMode="Static" style="width:100px" ReadOnly="true"></asp:TextBox>
                </td>
                <td>&nbsp;&nbsp;ToDate :&nbsp;</td>
                <td>
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" style="width:100px" ReadOnly="true"></asp:TextBox>
                </td>
                <td>&nbsp;&nbsp;Qty</td>
                <td>
                    <asp:TextBox ID="txtQty" runat="server" CssClass="ItDoseTextinputNum" style="width:50px" ClientIDMode="Static" onkeyup="CheckQty(this);" onkeypress="return checkForSecondDecimal(this,event)" MaxLength="4" onpaste="return false"></asp:TextBox>
                </td>
                <td style="text-align:left">&nbsp;&nbsp;&nbsp;<input type="button" class="ItDoseButton" id="btnGetItem" value="Get Item" onclick="addNewItem()" /></td>
                <td style="width:46%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            </tr>
             </table>                      
                        <div id="PatientItemSearchOutput" style="display:none" >
                        </div>                                           
         </div>
         </div>          
      <div class="POuter_Box_Inventory" style="text-align:center;display:none" id="divAddItem" >
            <input type="button" id="btnAddItem" value="Add Item" onclick="addItem()" class="ItDoseButton" />
            </div>
      <div id="itemDetail" style="display:none">
				<div class="POuter_Box_Inventory" style="text-align:center">					
						<table class="GridViewStyle" border="1" id="tb_grdIssueItem"
							style="width: 940px; border-collapse: collapse; display: none;">
							<tr id="IssueItemHeader">								
								<th class="GridViewHeaderStyle" scope="col" style="width: 360px;">Item Name
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 160px;">Batch No.
								</th>							
								<th class="GridViewHeaderStyle" scope="col" style="width: 90px; ">Rate
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Issue Qty.
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 140px;display:none">Bill&nbsp;No.
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 120px;display:none">Amount
								</th>								 
								 <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">StockID
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">ItemID
								</th>
                                 <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">SubCategoryID
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">IsNewItem
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">isAlreadyExist
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">MedExpiryDate
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">UnitPrice
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">Actual Qty
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">Type_ID
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">IsUsable
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">ServiceItemID
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">LTDID
								</th>
                                 <th class="GridViewHeaderStyle" scope="col" style="width: 60px;display:none">NonSelectedLTDID
								</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">EntryDate
								</th>
								<th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Remove
								</th>
							</tr>
						</table>
					</div>
				</div>          
	  <div class="POuter_Box_Inventory" style="text-align:center;display:none" id="hideBillDetail">             
        <asp:Label Text="New Bill Date :" runat="server" ID="lblBillDate"></asp:Label>        
        <asp:TextBox ID="txtBillDate" runat="server" ClientIDMode="Static" Style="width:100px" ></asp:TextBox>
                <span style="color: red; font-size: 10px;"  class="shat">*</span>
        <asp:TextBox ID="txtBillTime" runat="server" ClientIDMode="Static" Style="width:80px"></asp:TextBox>
                    <span style="color: red; font-size: 10px;"  class="shat">*</span>   
                Net Amount :&nbsp;<span id="spnBillAmount" class="ItDoseLabelSp"></span>   
           
          
        </div>                           
      <div class="POuter_Box_Inventory" style="text-align:center;display:none" id="hideSave">
            <input type="button" id="btnSave" value="Save" onclick="save()" class="ItDoseButton"  />       
            </div>      
        </asp:Panel>
        <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtBillTime"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtBillTime"
    ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Bill Time"
    InvalidValueMessage="Invalid Bill Time"   Display="None"   ></cc1:MaskedEditValidator>
    </div>
    <asp:Button ID="btnHidden" runat="server" Style="display:none" />
     <asp:Panel ID="pnlRejection" runat="server" CssClass="pnlItemsFilter" Style="display: none; width:280px;height:90px">
                    <div class="Purchaseheader" id="Div1" runat="server">
                        Rejection Reason</div>
         <table style="width:100%">
             <tr>
                 <td colspan="2" style="text-align:center">
                     <span id="spnErrorReason" class="ItDoseLblError"></span>
             </td>
                 </tr>
             <tr>
                 <td style="text-align:right">
                     Reason :&nbsp;
                 </td>
                 <td style="text-align:left">
                     <input type="text" maxlength="100" id="txtCancelReason" />
                      <span style="color: red; font-size: 10px;"  class="shat">*</span>
                 </td>
             </tr>
             
             <tr>
                 <td colspan="2" style="text-align:center">
                      <input type="button" class="ItDoseButton" value="Save" onclick="saveCancelReason()" />                        
                        &nbsp; &nbsp;&nbsp;
                        <asp:Button ID="btnCancelRejection" runat="server" Text="Cancel" CausesValidation="false"
                            CssClass="ItDoseButton" />
                 </td>
             </tr>
         </table>                                     
                </asp:Panel>
     <cc1:ModalPopupExtender ID="mpeRejection" BehaviorID="mpeRejection" runat="server" CancelControlID="btnCancelRejection"
                    DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
                    PopupControlID="pnlRejection" PopupDragHandleControlID="dragHandle"  />     
    <script type="text/javascript">
        function searchDetail() {
            if (jQuery.trim($("#txtIPDNo").val()) != "") {
                $.ajax({
                    url: "PatientEditBillDetail.aspx/bindPatientData",
                    data: '{IPDNo:"' + $.trim($("#txtIPDNo").val()) + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        IsBilledClosed = (result.d);
                        if (IsBilledClosed == "3") {
                            jQuery("#spnErrorMsg").text('Please First Generate Patient Bill');
                            jQuery("#pnlHideDetail").hide();
                        }
                        else if (IsBilledClosed == "2") {
                            jQuery("#spnErrorMsg").text('Patient Final Bill has been Closed');
                            jQuery("#pnlHideDetail").hide();
                        }
                        else {
                            jQuery("#spnErrorMsg").text('');
                            bindPatientDetail();
                        }
                        jQuery("#tb_grdIssueItem tr:not(:first)").remove();
                        jQuery("#divPatientDetail,#hideBillDetail,#hideSave,#hideItem,#itemDetail,#divAddItem").hide();
                    },
                    error: function (xhr, status) {
                        $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
            else {
                jQuery("#spnErrorMsg").text('Please Enter IPD No.');
                jQuery("#txtIPDNo").focus();
            }
        }
        function bindPatientDetail() {
            $.ajax({
                url: "PatientEditBillDetail.aspx/bindPatientDetail",
                data: '{IPDNo:"' + $.trim($("#txtIPDNo").val()) + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    patientData = jQuery.parseJSON(result.d);
                    if (patientData != null) {
                        var output = $('#tb_PatientSearch').parseTemplate(patientData);
                        jQuery('#PatientSearchOutput').html(output);
                        jQuery('#PatientSearchOutput').show();
                        jQuery('#spnPatientID').text(patientData[0]["PatientID"]);
                        jQuery('#spnIPDNo').text(patientData[0]["IPDNo"]);
                        jQuery('#spnPatientName').text(patientData[0]["PName"]);
                        jQuery('#spnPanel').text(patientData[0]["Company_Name"]);
                        jQuery('#spnRoomNo').text(patientData[0]["RoomNo"]);
                        jQuery('#spnTransactionID').text(patientData[0]["TransactionID"]);
                        jQuery('#pnlHideDetail').show();
                        jQuery("#tb_grdIssueItem tr:not(:first)").remove();
                    }
                    else {
                        jQuery('#PatientSearchOutput').html();
                        jQuery('#PatientSearchOutput,#pnlHideDetail').hide();
                        $("#spnErrorMsg").text('No Record Found');

                    }
                }
            });
        }
        </script>
    <script id="tb_PatientSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:940px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IPD No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Panel</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Bill Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Bill No.</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Bill Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Select</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Replace</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">LedgerTransactionNo</th>            
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">TID</th> 
		</tr>
        <#
        var dataLength=patientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = patientData[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdIPDNo"  style="width:80px;text-align:center" ><#=objRow.IPDNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:240px;text-align:center"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdCompany_Name" style="width:120px;text-align:center"><#=objRow.Company_Name#></td>
                    <td class="GridViewLabItemStyle" id="tdAmount" style="width:140px;text-align:right"><#=objRow.Amount#></td>
                    <td class="GridViewLabItemStyle" id="tdBillNo" style="width:160px;text-align:center"><#=objRow.BillNo#>                           
                        </td>
                    <td class="GridViewLabItemStyle" id="tdBillDate" style="width:120px;text-align:center"><#=objRow.Date#></td>
                    <td class="GridViewLabItemStyle" id="td1" style="width:80px;">
                        <img src="../../Images/view.GIF" style="cursor:pointer" onclick="bindItemDetail(this)" />
                    </td>
                    <td class="GridViewLabItemStyle" id="td2" style="width:120px;text-align:center;display:none"><input type="button" value="Replace" class="ItDoseButton" id="btnreplace" onclick="btnreplace_click(this)" /></td>
                        <td class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style="width:80px;display:none"><#=objRow.LedgerTransactionNo#>                           
                        </td>                      
                        <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:80px;display:none"><#=objRow.TransactionID#>                          
                        </td>
                    </tr>
        <#}
        #>       
     </table>
    </script>
    <script type="text/javascript">
        $(function () {
            bindNewItem();
        });
        function bindNewItem() {
            $.ajax({
                url: "PatientEditBillDetail.aspx/bindItem",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    for (var i = 0; i < data.length; i++) {
                        $('#ddlItem').append($("<option></option>").val(data[i].itemID).html(data[i].itemName));
                    }
                }
            });
        }
        function IPDInformation() {
            $.ajax({
                url: "PatientEditBillDetail.aspx/PatientIPDInformation",
                data: '{IPDNo:"' + $.trim($("#txtIPDNo").val()) + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var IPDdata = jQuery.parseJSON(mydata.d);
                    if (IPDdata != null) {
                        jQuery('#spnDoctorName').text(IPDdata[0]["DoctorName"]);
                        jQuery('#spnAdmissionDate').text(IPDdata[0]["DateOfAdmit"]);
                        jQuery('#spnAdmissionDate1').text(IPDdata[0]["DateOfAdmit1"]);
                        jQuery('#spnTimeOfAdmission').text(IPDdata[0]["TimeOfAdmit"]);
                        jQuery('#spnDoctorID').text(IPDdata[0]["DoctorID"]);
                        var today = jQuery('#spnAdmissionDate').text();

                        $("#txtBillDate").datepicker({
                            buttonImageOnly: true,
                            dateFormat: 'dd-M-yy',
                            minDate: new Date(today),
                            defaultDate: today
                        });
                        // $("#txtBillDate").datepicker("setDate", today);
                        // $('#txtBillDate').val($.datepicker.formatDate('dd-MM-yy', new Date($('#spnBillDate').text())));
                    }
                    else {
                        $('#spnDoctorName,#spnAdmissionDate,#spnDoctorID').text('');
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function bindItemDetail(rowID) {
            var TID = $(rowID).closest('tr').find('#tdTransactionID').text();
            $("#spnBillNo").text($(rowID).closest('tr').find('#tdBillNo').text());
            $("#spnBillDate").text($(rowID).closest('tr').find('#tdBillDate').text());
            $('#spnLedgerTransactionNo').text($(rowID).closest('tr').find('#tdLedgerTransactionNo').text());


            $.ajax({
                url: "PatientEditBillDetail.aspx/bindItemDetail",
                data: '{IPDNo:"' + TID + '",LedgerTransactionNo:"' + $('#spnLedgerTransactionNo').text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    itemData = jQuery.parseJSON(result.d);
                    if (itemData != null) {
                        $("#spnBillTime").text(itemData[0]["TIME"]);
                        var output = $('#tb_PatientItemSearch').parseTemplate(itemData);
                        $('#PatientItemSearchOutput').html(output);
                        $('#PatientItemSearchOutput,#hideItem,#btnAddItem,#divPatientDetail,#divAddItem').show();
                        $('#trItemHide,#hideBillDetail,#hideSave,#itemDetail').hide();
                        jQuery("#tb_grdIssueItem tr:not(:first)").remove();
                        IPDInformation();

                    }
                    else {
                        $('#PatientItemSearchOutput').html('');
                        $('#PatientItemSearchOutput,#hideItem,#btnAddItem,#divPatientDetail,#trItemHide').hide();
                    }

                    //Bind Dates           
                    bindDates($(rowID).closest('tr').find('#tdBillDate').text());
                }
            });
        }
    </script>
    <script type="text/javascript">
        function chkAllCon(rowID) {
            //  $(rowID).closest('tr').find(".chk input[type=checkbox]").prop('checked', true);        
            jQuery("#tb_grdItem tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "trItem") {
                    jQuery(this).closest("tr").find("#chkItem").attr("checked", "checked");
                }
            });
        }
        function chkItemCon(rowID) {
            if ($(rowID).closest('tr').find('#chkItem').is(':checked'))
                $(rowID).closest('tr').find('#spnQty').show();
            else
                $(rowID).closest('tr').find('#spnQty').hide();
            if ($(".chk").length == $(".chk:checked").length) {
                $(".chkAll").attr("checked", "checked");
            } else {
                $(".chkAll").removeAttr("checked");
            }
        }
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                return false;
            }

            return true;
        }
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


        }
    </script>
    <script id="tb_PatientItemSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdItem"
    style="width:940px;border-collapse:collapse;">
		<tr id="trItem">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.<input type="checkbox"  style="display:none" onclick="chkAllCon(this);" class="chkAll" id="chkAll" checked="checked" /></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:320px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Entry Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px; ">Batch No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Qty.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none">Bill No.</th>         
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none">Actual Qty.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none">Stock ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none ">ItemID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none">SubCategoryID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none "></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none ">MedExpiryDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none ">UnitPrice</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none ">Type_ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none ">IsUsable</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none ">ServiceItemID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none ">LTDID</th>
		</tr>
        <#      
        var dataLength=itemData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = itemData[j];        
          #>
                    <tr id="<#=objRow.stockid#>" >
                        <td class="GridViewLabItemStyle"><input type="checkbox" onclick="chkItemCon(this)"  class="chk" checked="checked" id="chkItem"<#=j+1#></td>
                        <td id="tdItemName" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.ItemName#></td>
                        <td id="tdDate" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRow.Date#></td>
                        <td id="tdEntryDate" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.dtEntry#></td>

                        <td id="tdBatchNumber" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.BatchNumber#></td>
                        <td  id="tdRate" class="GridViewLabItemStyle" style="text-align:right"><#=objRow.LRate#></td>                          
                        <td  class="GridViewLabItemStyle"  style="text-align:right; ">
                         <input id="txtIssueQty" type="text" onpaste="return false"  class="ItDoseTextinputNum" title="Enter New Qty." maxlength="4"  size="5" value="<#=objRow.availQty#>"  onkeyup="CheckQty(this);" onkeypress="return checkForSecondDecimal(this,event)" />
                             <span style="color: red; font-size: 10px;" id="spnQty"  class="shat">*</span>
                         </td>
                        <td  id="tdLtBillNo" class="GridViewLabItemStyle" style="display:none" ><#=objRow.BillNo#></td>                      
                        <td  id="tdActualQty" class="GridViewLabItemStyle" style="display:none"><#=objRow.availQty#></td>                   
                        <td  id="tdStockID" class="GridViewLabItemStyle" style="display:none"><#=objRow.StockID#></td>
                        <td  id="tdItemID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ItemID#></td>
                        <td  id="tdSubCategoryID" class="GridViewLabItemStyle" style="display:none"><#=objRow.SubCategoryID#></td>  
                        <td  id="tdIsNewItem" class="GridViewLabItemStyle" style="display:none"><#=objRow.IsNewItem#></td>
                        <td  id="tdisAlreadyExist" class="GridViewLabItemStyle" style="display:none"><#=objRow.isAlreadyExist#></td>
                        <td  id="tdMedExpiryDate" class="GridViewLabItemStyle" style="display:none"><#=objRow.MedExpiryDate#></td>
                        <td  id="tdUnitPrice" class="GridViewLabItemStyle" style="display:none"><#=objRow.UnitPrice#></td>
                        <td  id="tdType_ID" class="GridViewLabItemStyle" style="display:none"><#=objRow.Type_ID#></td>
                        <td  id="tdIsUsable" class="GridViewLabItemStyle" style="display:none"><#=objRow.IsUsable#></td>
                        <td  id="tdServiceItemID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ServiceItemID#></td>
                        <td  id="tdLTDID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ID#></td>

                           </tr>
            <#}#>
     </table>    
    </script>
    <script type="text/javascript">
        function precise_roundoff(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function addItem() {
            var con = 0; var chk = 1; var conChk = 0; var conVal = 0; var nonSelectedLTDID = "";
            jQuery("#tb_grdItem tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "trItem") {
                    if (jQuery(this).find("#chkItem").is(":checked")) {
                        if (jQuery.trim(jQuery(this).find("#txtIssueQty").val()) <= "0") {
                            if (jQuery.trim(jQuery(this).find("#txtIssueQty").val()) < "0") {
                                jQuery("#spnErrorMsg").text('Please Enter Issue Qty.');
                                con = 1;
                            }
                            else {
                                jQuery("#spnErrorMsg").text('Please Enter Valid Issue Qty.');
                                conVal = 1;
                            }
                            jQuery(this).find("#txtIssueQty").focus();

                            return;
                        }
                        chk += chk;
                        //if (parseFloat(jQuery.trim(jQuery(this).find("#txtIssueQty").val())) > parseFloat((jQuery.trim($rowid.find("#tdAvlQty").html())))) {
                        //    jQuery("#spnErrorMsg").text('Issue Qty. Can Not Greater Then Available Qty.');
                        //    con = 1;
                        //    return false;
                        //}

                        var stockID = $rowid.find("#tdStockID").html();
                        jQuery("#tb_grdIssueItem tr").each(function () {
                            var IssueItemid = jQuery(this).closest("tr").attr("id");
                            var $IssueItemrowid = jQuery(this).closest("tr");
                            if (IssueItemid != "IssueItemHeader") {
                                var IssuestockID = $IssueItemrowid.find("#tdStockID").html();
                                if (stockID == IssuestockID) {
                                    jQuery("#spnErrorMsg").text('Item Already Selected');
                                    conChk = 1;
                                    return false;
                                }
                            }
                        });
                    }
                    else {
                        if (nonSelectedLTDID != "") {

                            nonSelectedLTDID += ",'" + jQuery.trim(jQuery(this).find("#tdLTDID").text()) + "'";
                        }
                        else {

                            nonSelectedLTDID = "'" + jQuery.trim(jQuery(this).find("#tdLTDID").text()) + "'";
                        }
                    }
                }
            });
            if (con == "1") {
                jQuery("#spnErrorMsg").text('Please Enter Issue Qty.');
                return false;
            }
            if (conVal == "1") {
                jQuery("#spnErrorMsg").text('Please Enter Valid Issue Qty.');
                return false;
            }

            if (chk == "1") {
                jQuery("#spnErrorMsg").text('Please Check Atleast One Item');
                return false;
            }

            if (conChk == "1") {
                jQuery("#spnErrorMsg").text('Item Already Selected');
                return false;
            }

            var amt = 0; var nonSelectedStockID = "";
            if ((con == "0") && (chk > 1)) {
                jQuery("#spnErrorMsg").text('');
                jQuery("#tb_grdItem tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if ((id != "Header") && ($rowid.find("#chkItem").is(':checked'))) {
                        RowCount = jQuery("#tb_grdItem tr").length;
                        RowCount = RowCount + 1;
                        var newRow = jQuery('<tr />').attr('id', 'tr_' + RowCount);
                        newRow.html(
                             '</td><td class="GridViewLabItemStyle" id="tdItemName">' + $rowid.find("#tdItemName").html() +
                             '</td><td class="GridViewLabItemStyle" id="tdBatchNumber">' + $rowid.find('#tdBatchNumber').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdRate">' + $rowid.find('#tdRate').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right" id="tdIssueQty">' + jQuery(this).find('#txtIssueQty').val() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none" id="tdBillNo">' + $rowid.find('#tdLtBillNo').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:right;display:none" id="tdAmount">' + precise_roundoff(parseFloat((parseFloat(jQuery(this).find('#txtIssueQty').val()) * parseFloat(($rowid.find('#tdRate').html())))), 2) +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdStockID">' + $rowid.find('#tdStockID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdItemID">' + $rowid.find('#tdItemID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdSubCategoryID">' + $rowid.find('#tdSubCategoryID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdIsNewItem">' + $rowid.find('#tdIsNewItem').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdisAlreadyExist">' + $rowid.find('#tdisAlreadyExist').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdMedExpiryDate">' + $rowid.find('#tdMedExpiryDate').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdUnitPrice">' + $rowid.find('#tdUnitPrice').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdActualQty">' + $rowid.find('#tdActualQty').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdType_ID">' + $rowid.find('#tdType_ID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdIsUsable">' + $rowid.find('#tdIsUsable').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdServiceItemID">' + $rowid.find('#tdServiceItemID').html() +
                             '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdLTDID">' + $rowid.find('#tdLTDID').html() +
                            '</td><td class="GridViewLabItemStyle" style="text-align:centre;display:none" id="tdnonSelectedLTDID">' + nonSelectedLTDID +
                            //////////////////////
                            '</td><td class="GridViewLabItemStyle" style="text-align:centre;" id="tdEntryDate">' + $rowid.find('#tdEntryDate').html() +
                            //////////////////////
                            '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgRemove"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"    style="cursor:pointer;" title="Click To Remove"/></td>'
                            );
                        jQuery("#tb_grdIssueItem").append(newRow);
                        jQuery("#tb_grdIssueItem").show();

                    }
                    //else if (id != "Header") {
                    //    if (nonSelectedStockID != "") {
                    //        nonSelectedStockID += ",'" + $rowid.find('#tdStockID').html() + "'";
                    //    }
                    //    else {

                    //        nonSelectedStockID = "'" + $rowid.find('#tdStockID').html() + "'";
                    //    }

                    //}
                });
                jQuery("#tb_grdIssueItem tr:not(:first)").each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "IssueItemHeader") {
                        amt += parseFloat(parseFloat(jQuery(this).closest("tr").find("#tdRate").html()) * parseFloat(jQuery(this).closest("tr").find("#tdIssueQty").html()));
                    }
                });
                jQuery('#PatientItemSearchOutput').html('');
                jQuery('#PatientItemSearchOutput,#btnAddItem,#itemDetail').hide();
                jQuery("#spnBillAmount").text(precise_roundoff(amt, 2));
                jQuery('#btnSave,#trItemHide,#hideBillDetail,#itemDetail').show();
                jQuery('#txtBillDate').val($('#spnBillDate').text());
                jQuery('#txtBillTime').val($('#spnBillTime').text());
                if ($("#tb_grdIssueItem tr").length == "1")
                    $("#hideSave").hide();
                else
                    $("#hideSave").show();
            }
        }
        function DeleteRow(rowid) {
            var amt = 0;
            var row = rowid;
            var deletedStockID = "";
            if (jQuery(row).closest('tr').find("#tdIsNewItem").text() == "0") {
                //    $find('mpeRejection').show();
                if (deletedStockID != "") {
                    deletedStockID += ",'" + jQuery(row).closest('tr').find('#tdStockID').html() + "'";
                }
                else {

                    deletedStockID = "'" + jQuery(row).closest('tr').find('#tdStockID').html() + "'";
                }
            }
            jQuery(row).closest('tr').remove();
            jQuery("#tb_grdIssueItem tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "IssueItemHeader") {
                    amt += eval(jQuery(this).closest("tr").find("#tdAmount").html());
                }
            });
            jQuery("#spnBillAmount").text(amt);

            if (jQuery("#tb_grdIssueItem tr").length == "1") {
                jQuery('#tb_grdIssueItem,#lblBill,#btnSave,#lblBillAmount,#divPatientDetail,#hideBillDetail,#itemDetail').hide();
                $('#PatientItemSearchOutput').html(''); $('#PatientItemSearchOutput,#hideItem,#divAddItem,#divAddItem').hide();
                jQuery("#tb_grdIssueItem tr:not(:first)").remove();
            }
            else {
                jQuery('#lblBill,#btnSave,#lblBillAmount').show();
            }

        }
    </script>
    <script type="text/javascript">
        function addNewItem() {

            var FromDate = $.datepicker.parseDate('dd-M-yy', $("#txtFromDate").val());
            var ToDate = $.datepicker.parseDate('dd-M-yy', $("#txtToDate").val());


            if ($.trim($('#txtFromDate').val()).length == 0) {
                $('#spnErrorMsg').text("Please Select From Date.");
                $('#txtFromDate').focus();
                return;
            }
            else if ($.trim($('#txtToDate').val()).length == 0) {
                $('#spnErrorMsg').text("Please Select To Date.");
                $('#txtToDate').focus();
                return;
            }
            else if (FromDate > ToDate) {
                $('#spnErrorMsg').text("To date cannot be less than from date!.");
                $('#txtToDate').focus();
                return;
            }
            else if ($.trim($('#txtQty').val()).length == 0) {
                $('#spnErrorMsg').text("Please Enter Quantity.");
                $('#txtQty').focus();
                return;
            }

            jQuery("#spnErrorMsg").text('');
            $.ajax({
                url: "PatientEditBillDetail.aspx/addNewItem",
                data: '{ItemID:"' + $("#ddlItem").val() + '",BillNo:"' + $("#spnBillNo").text() + '",BillDate:"' + $("#spnBillDate").text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    itemData = jQuery.parseJSON(result.d);
                    //////////////////////
                    itemData = GenerateRows(itemData);
                    //////////////////////
                    if (itemData != null) {
                        var output = $('#tb_PatientItemSearch').parseTemplate(itemData);
                        $('#PatientItemSearchOutput').html(output);
                        $('#PatientItemSearchOutput,#btnAddItem').show();
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function chkValidation() {
            var begT = new Date($('#spnAdmissionDate').text() + " " + $('#spnTimeOfAdmission').text());
            var dateTypeVar = $('#txtBillDate').datepicker('getDate');
            var end = $.datepicker.formatDate('mm-dd-yy', dateTypeVar);
            var endT = new Date(end + " " + $('#txtBillTime').val());

            if ((endT) < (begT)) {
                alert('Bill Date-Time always greater then Admission Date-Time');
                return false;
            }
            else
                return true;
        }
        function save() {
            if (chkValidation() == true) {
                $("#btnSave").attr('disabled', 'disabled').val("Submitting...");
                var ltd = LedgerTransactionDetail();
                $.ajax({
                    url: "PatientEditBillDetail.aspx/editBill",
                    data: JSON.stringify({ detail: ltd, LedgertransactionNo: $.trim($('#spnLedgerTransactionNo').text()), TransactionID: $('#spnTransactionID').text(), BillDate: $('#txtBillDate').val(), BillTime: $('#txtBillTime').val(), DoctorID: $('#spnDoctorID').text() }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            jQuery("#spnErrorMsg").text('Record Saved Successfully');

                        }

                        else {
                            jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        }
                        jQuery("#pnlHideDetail,#trItemHide,#hideSave,#itemDetail,#hideItem,#tb_grdIssueItem,#hideBillDetail").hide();
                        jQuery('#PatientItemSearchOutput').html('');
                        jQuery("#tb_grdIssueItem tr:not(:first)").remove();
                        jQuery('#spnDoctorName,#spnAdmissionDate,#spnDoctorID').text('');
                        jQuery("#btnSave").attr('disabled', false).val("Save");
                        jQuery("#txtIPDNo").val('').focus();

                    }

                });
            }
        }
        function LedgerTransactionDetail() {
            var dataLTDt = new Array();
            var ObjLdgTnxDt = new Object();
            jQuery("#tb_grdIssueItem tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "IssueItemHeader") {
                    ObjLdgTnxDt.ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                    ObjLdgTnxDt.StockID = jQuery.trim($rowid.find("#tdStockID").text());
                    ObjLdgTnxDt.SubCategoryID = jQuery.trim($rowid.find("#tdSubCategoryID").text());
                    ObjLdgTnxDt.Rate = jQuery.trim($rowid.find("#tdRate").text());
                    ObjLdgTnxDt.Quantity = jQuery.trim($rowid.find("#tdIssueQty").text());
                    ObjLdgTnxDt.ItemName = $rowid.find("#tdItemName").text();
                    ObjLdgTnxDt.Amount = parseFloat($rowid.find("#tdAmount").text());
                    ObjLdgTnxDt.IsNewItem = $rowid.find("#tdIsNewItem").text();
                    ObjLdgTnxDt.IsAlreadyExist = $rowid.find("#tdisAlreadyExist").text();
                    ObjLdgTnxDt.BatchNo = jQuery.trim($rowid.find("#tdBatchNumber").text());
                    ObjLdgTnxDt.LTDID = jQuery.trim($rowid.find("#tdLTDID").text());
                    ObjLdgTnxDt.nonSelectedLTDID = jQuery.trim($rowid.find("#tdnonSelectedLTDID").text());
                    //////////////////////
                    ObjLdgTnxDt.EntryDate = jQuery.trim($rowid.find("#tdEntryDate").text());
                    //////////////////////
                    dataLTDt.push(ObjLdgTnxDt);
                    ObjLdgTnxDt = new Object();
                }
            });
            return dataLTDt;
        }

    </script>
    <script type="text/javascript">
        function saveCancelReason() {
        }
    </script>
    <script type="text/javascript">
        //////////////////////
        function bindDates(ToMaxDate) {

            var AdmitDate = $('#spnAdmissionDate').text();
            $('#txtFromDate').val($('#spnBillDate').text());
            $('#txtToDate').val($('#spnBillDate').text());

            $('#txtFromDate').datepicker('destroy');
            $('#txtFromDate').datepicker({
                changeYear: true,
                dateFormat: 'dd-M-yy',
                changeMonth: true,
                buttonImageOnly: true,
                minDate: new Date(AdmitDate),
                maxDate: ToMaxDate


            });

            $('#txtToDate').datepicker('destroy');
            $('#txtToDate').datepicker({
                changeYear: true,
                dateFormat: 'dd-M-yy',
                changeMonth: true,
                buttonImageOnly: true,
                minDate: new Date(AdmitDate),
                maxDate: ToMaxDate
            });
        }

        function GenerateRows(Rows) {
            var month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            var ToDate = $.datepicker.parseDate('dd-M-yy', $("#txtToDate").val());
            var NewGrid = [];

            var objRow = itemData[0];
            var FromDate = $.datepicker.parseDate('dd-M-yy', $("#txtFromDate").val());

            while (ToDate >= FromDate) {
                var row = {};
                row.StockID = objRow.StockID;
                row.ItemID = objRow.ItemID;
                row.ItemName = objRow.ItemName;
                row.BatchNumber = objRow.BatchNumber;
                row.SubCategoryID = objRow.SubCategoryID;
                row.UnitPrice = objRow.UnitPrice;
                row.LRate = objRow.LRate;
                row.MedExpiryDate = objRow.MedExpiryDate;
                row.IsNewItem = objRow.IsNewItem;
                row.isAlreadyExist = objRow.isAlreadyExist;
                row.BillNo = objRow.BillNo;
                row.dtEntry = FromDate.getDate() + "-" + month[FromDate.getMonth()] + "-" + FromDate.getFullYear();
                row.Type_ID = objRow.Type_ID;
                row.IsUsable = objRow.IsUsable;
                row.ServiceItemID = objRow.ServiceItemID;
                row.availQty = $('#txtQty').val();
                row.tax = objRow.tax;

                NewGrid.push(row);

                FromDate.setDate((FromDate.getDate() + 1));

            }


            return NewGrid;

        }
        //////////////////////
    </script>
    
     
    <asp:Button ID="btnhide" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpReplace" BehaviorID="mpReplace" runat="server" CancelControlID="btnComplaintCancel"
            DropShadow="true" TargetControlID="btnhide" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlReplace">
     </cc1:ModalPopupExtender>     

    <asp:Panel ID="pnlReplace" runat="server">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:800px;">
            <div class="Purchaseheader">
                <table width="790">
                    <tr>
                        <td style="text-align:left;">
                            <b>Replace Medicine</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor:pointer" onclick="closeTypeOfApp()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:797px;text-align:center;">
                <b><span id="lblMsg" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;" id="Table1">
                    <tr >
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">
                            &nbsp;</td>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">
                            &nbsp;</td>
                        </tr >                       
                    <tr>
                        <td style="text-align:right;width:200px;">IPD No :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblipdno"></span></td>
                        <td style="text-align:right;width:200px;">Name :&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="lblname"></span></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;width:200px;"><span id="lblledgertnxno" style="display:none;"></span></td>
                        <td style="text-align:left;width:200px;"><span id="lbltid" style="display:none;"></span></td>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align:right;width:200px;">Bill Date :&nbsp;</td>
                        <td style="text-align:left;width:200px;">
                            <span id="lblbilldate"></span>
                        </td>
                        
                        <td style="text-align:right;width:200px;">Bill No :&nbsp;</td>                        
                        <td style="text-align:left;width:200px;">
                            <span id="lblbillno"></span>
                        </td>                        
                    </tr>                    
                    <tr>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                    </tr>
                </table>   
            </div>
            <div class="POuter_Box_Inventory" style="width:797px;">                 
                <table  style="border-collapse:collapse;" id="ReplaceTable">
                    <tr >
                        <td style="text-align:right;">&nbsp;</td>
                        <td style="text-align:left;">
                            &nbsp;</td>
                        <td style="text-align:right;">&nbsp;</td>
                        <td style="text-align:left">
                            &nbsp;</td>
                        </tr >                       
                    <tr>
                        <td style="text-align:right;">From Date :&nbsp;</td>
                        <td style="text-align:left;">
                            <asp:TextBox ID="txtFromDateBill" runat="server" ClientIDMode="Static" ReadOnly="true" style="width:100px" type="text"></asp:TextBox>
                            <span style="color: red; font-size: 10px;"  class="shat">*</span>
                        </td>
                        <td style="text-align:right;">ToDate :&nbsp;</td>
                        <td style="text-align:left">
                            <asp:TextBox ID="txtToDateBill" runat="server" ClientIDMode="Static" ReadOnly="true" style="width:100px"></asp:TextBox>
                            <span style="color: red; font-size: 10px;"  class="shat">*</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">&nbsp;</td>
                        <td style="text-align:left;">&nbsp;</td>
                        <td style="text-align:right;">&nbsp;</td>
                        <td style="text-align:left">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align:right">Bill Medicine :</td>
                        <td style="text-align:left"><select id="ddlBillMedicine" style="width:250px" ></select>
                            <span style="color: red; font-size: 10px;"  class="shat">*</span>
                        </td>                        
                        <td style="text-align:right">&nbsp;Replace With :</td>                        
                        <td style="text-align:left"><select id="ddlMedicine" style="width:250px" ></select>
                            <span style="color: red; font-size: 10px;"  class="shat">*</span>
                        </td>                        
                    </tr>                    
                    <tr>
                        <td style="text-align:right">&nbsp;</td>
                        <td style="text-align:left">&nbsp;</td>
                        <td style="text-align:right">&nbsp;</td>
                        <td style="text-align:left">&nbsp;</td>
                    </tr>
                </table> 
                </div>  
            <div class="POuter_Box_Inventory" style="text-align:center;width:797px;">
                <input type="button" id="Button1" value="Replace" onclick="UpdateMedicine();" class="ItDoseButton"/>
                 </div>         
        </div>        
    </asp:Panel> 
    <script type="text/javascript">

        function btnreplace_click(rowID) {

            bindAllItem();
            bindBillItems(rowID);
            $find("mpReplace").show();

        }

        function closeTypeOfApp() {
            $find('mpReplace').hide();
        }

        function bindAllItem() {
            $.ajax({
                url: "PatientEditBillDetail.aspx/bindItem",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    $('#ddlMedicine').empty();
                    for (var i = 0; i < data.length; i++) {
                        $('#ddlMedicine').append($("<option></option>").val(data[i].itemID).html(data[i].itemName));
                    }
                }
            });
        }

        function bindBillItems(rowID) {
            var TID = $(rowID).closest('tr').find('#tdTransactionID').text();
            var LedgerTnxNo = $(rowID).closest('tr').find('#tdLedgerTransactionNo').text();

            $.ajax({
                url: "PatientEditBillDetail.aspx/bindItemDetail",
                data: '{IPDNo:"' + TID + '",LedgerTransactionNo:"' + LedgerTnxNo + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    itemData = jQuery.parseJSON(result.d);
                    if (itemData != null) {
                        $('#ddlBillMedicine').empty();
                        for (var i = 0; i < itemData.length; i++) {
                            $('#ddlBillMedicine').append($("<option></option>").val(itemData[i].ItemID).html(itemData[i].ItemName));
                        }
                    }
                }
            });

            $('#lblipdno').text($(rowID).closest('tr').find('#tdIPDNo').text());
            $('#lblname').text($(rowID).closest('tr').find('#tdPName').text());
            $('#lblbilldate').text($(rowID).closest('tr').find('#tdBillDate').text());
            $('#lblbillno').text($(rowID).closest('tr').find('#tdBillNo').text());
            $('#lblledgertnxno').text($(rowID).closest('tr').find('#tdLedgerTransactionNo').text());
            $('#lbltid').text($(rowID).closest('tr').find('#tdTransactionID').text());

            bindReplaceDates();
        }

        function bindReplaceDates() {
            
            var AdmitDate;
            $.ajax({
                url: "PatientEditBillDetail.aspx/PatientIPDInformation",
                data: '{IPDNo:"' + $.trim($("#txtIPDNo").val()) + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var IPDdata = jQuery.parseJSON(mydata.d);
                    if (IPDdata != null) {                        
                        AdmitDate = IPDdata[0]["DateOfAdmit"];                   
                    }
                }
            });
            

            $('#txtFromDateBill').val($('#lblbilldate').text());
            $('#txtToDateBill').val($('#lblbilldate').text());

            $('#txtFromDateBill').datepicker('destroy');
            $('#txtFromDateBill').datepicker({
                changeYear: true,
                dateFormat: 'dd-M-yy',
                changeMonth: true,
                buttonImageOnly: true,
                minDate: new Date(AdmitDate),
                maxDate: $('#lblbilldate').text()


            });

            $('#txtToDateBill').datepicker('destroy');
            $('#txtToDateBill').datepicker({
                changeYear: true,
                dateFormat: 'dd-M-yy',
                changeMonth: true,
                buttonImageOnly: true,
                minDate: new Date(AdmitDate),
                maxDate: $('#lblbilldate').text()
            });
        }


        function UpdateMedicine() {
            var FromDate = $.datepicker.parseDate('dd-M-yy', $("#txtFromDateBill").val());
            var ToDate = $.datepicker.parseDate('dd-M-yy', $("#txtToDateBill").val());


            if ($.trim($('#txtFromDateBill').val()).length == 0) {
                $('#lblMsg').text("Please Select From Date");
                $('#txtFromDateBill').focus();
                return;
            }
            else if ($.trim($('#txtToDateBill').val()).length == 0) {
                $('#lblMsg').text("Please Select To Date");
                $('#txtToDateBill').focus();
                return;
            }
            else if (FromDate > ToDate) {
                $('#lblMsg').text("To date cannot be less than from date");
                $('#txtToDateBill').focus();
                return;
            }

            jQuery("#lblMsg").text('');
            $.ajax({
                url: "PatientEditBillDetail.aspx/replaceMedicine",
                data: '{LedgertransactionNo:"' + $('#lblledgertnxno').text() + '",TransactionID:"' + $('#lbltid').text() + '",BillNo:"' + $("#lblbillno").text() + '",BillDate:"' + $("#lblbilldate").text() + '",From:"' + $('#txtFromDateBill').val() + '",To:"' + $('#txtToDateBill').val() + '",BillItem:"' + $('#ddlBillMedicine').val() + '",ReplaceItem:"' + $('#ddlMedicine').val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        alert('Record Updated Successfully');
                        $find("mpReplace").hide();
                        jQuery("#pnlHideDetail,#trItemHide,#hideSave,#itemDetail,#hideItem,#tb_grdIssueItem,#hideBillDetail").hide();
                        jQuery('#PatientItemSearchOutput').html('');
                        jQuery("#tb_grdIssueItem tr:not(:first)").remove();
                        jQuery('#spnDoctorName,#spnAdmissionDate,#spnDoctorID').text('');
                        jQuery("#btnSave").attr('disabled', false).val("Save");
                        jQuery("#txtIPDNo").val('').focus();
                    }

                    else {
                        jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                }
            });
        }
    </script>  

    </asp:Content>

