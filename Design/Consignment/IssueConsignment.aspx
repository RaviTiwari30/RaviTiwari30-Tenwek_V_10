<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IssueConsignment.aspx.cs" Inherits="Design_Consignment_IssueConsignment" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css">
      <div id="Pbody_box_inventory">
          <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <span style="display:none" id="spnHashCode"></span>
            <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Label  ID="lblDeptLedgerNo" runat="server" style="display:none" ClientIDMode="Static" ></asp:Label>  
                 <b>Consignment Issue</b><br />
        </div>
          <div style="display:none;">
              <img src="https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=http%3A%2F%2Fwww.google.com%2FPatientName: Arjun<br/>Gender:Male&choe=UTF-8" title="Link to Google.com" />
          </div>
             <div id="divSearchCreteria" class="POuter_Box_Inventory" style="text-align: center;">
                 
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left"><b>Barcode</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <input id="txtPatientId" type="text" class="requiredField" maxlength="20" title="Enter UHID" onkeyup="searchPatientByID(event)" autocomplete="off"  />
                            <input id="txtBarCodeSearch" type="text" style="display:none"  maxlength="10" title="Enter BarCode No." autocomplete="off" />
                        </div>
                        <div class="col-md-2">
                            <label id="lblPatientIdType" class="pull-left">IPD No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <input id="txtIPDNO" type="text" class="requiredField" maxlength="20" title="Enter IPD No." onkeyup="searchPatientByID(event)" autocomplete="off" />
                        </div>
                        <div class="col-md-1">
                            <input type="button" id="btnSearch" onclick="searchPatientByID(event)" class="pull-left" value="Search" />
                        </div>
                        <div class="col-md-3">
                            <input id="btnOldPatient" type="button" onclick="$showOldPatientSearchModel()" value="Old Patient Search" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3"></div>
                    </div>
                </div>
            </div>
        </div>
             <div id="divHospitalPatientEntry" style="display:none"  class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <label id="lblPatientName" class="patientInfo"></label>
                        </div>
                        <div class="col-md-3">
                            <label id="lblPatientId" class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <label id="lblMrNo" class="patientInfo"></label>
                            <label id="lblTransactionID"  class="patientInfo" style="display:none" ></label>
                            <label id="lblpanelid"  class="patientInfo" style="display:none" ></label>
                            <label id="lblPatientLedgerNo"  class="patientInfo" style="display:none" ></label>
                            <label id="lblRoom_ID"  class="patientInfo" style="display:none" ></label>
                            <label id="lblIPDCaseType_ID"  class="patientInfo" style="display:none" ></label>
                            <label id="lblPatient_Type"  class="patientInfo" style="display:none" ></label>
                            <label id="lblIsMedCleared"  class="patientInfo" style="display:none" ></label>
                            <label id="lblDoctor_ID"  class="patientInfo" style="display:none" ></label>
                            <asp:Label ID="lblVendorLedgerNo" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Age / Sex</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <label id="lblAgeSex" class="patientInfo"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13 pull-left">
                            <label id="lblAddresss" class="patientInfo"></label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Contact No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <label id="lblContact" class="patientInfo"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Doctor </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select class="requiredField" id="ddlOldPatientDoctor"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">IPD No</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5"><label id="lblPDNo"  class="patientInfo"></label></div>
                       <%-- <div class="col-md-3"></div>
                        <div class="col-md-5"></div>--%>
                        <div class="col-md-5 pull-left">
                               <button id="btnAllergiesAndDiagnosis" type="button" onclick="$popupAllergiesAndDiagnosis()" style="height: 21px; width: 175px; background-color:yellow; display: none;"><strong class="panel-title" style="font-weight: bold; font-family: Verdana, Arial, sans-serif;" title="Allergies & Diagnosis">Allergies & Diagnosis</strong></button>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
            <div id="divMedicineSelect" style="display: none" class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">Search By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <input type="radio" id="rdoTypeItem" class="radioBtnClass pull-left" name="rdoSearchBy" onclick="onSearchTypeChange(this)" checked="checked" value="1" /><span class="pull-left">Item</span>
                            <input type="radio" id="rdoTypeGeneric" class="radioBtnClass pull-left" name="rdoSearchBy" onclick="onSearchTypeChange(this)" value="2" /><span class="pull-left"> Generic</span>
                            <input type="radio" id="rdoTypeGroup" style="display: none" class="radioBtnClass pull-left" onclick="onSearchTypeChange(this)" name="rdoSearchBy" value="3" /><%--Group--%>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left withGeneric">With Generic</label>
                            <b class="pull-right withGeneric">:</b>
                        </div>
                         <div class="col-md-5 pull-left">
                             <input type="radio" class="withGeneric pull-left" value="1" onclick="onIsWithAlternateChange()" name="rdoWithAlt" /><span class="pull-left withGeneric">Yes</span> 
                             <input type="radio" class="withGeneric pull-left" value="0" onclick="onIsWithAlternateChange()" checked="checked"   name="rdoWithAlt" /> <span class="pull-left withGeneric">No</span> 
                         </div>
                        <div class="col-md-5">
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">By First Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13 pull-left">
                            <input type="text" id="txtMedicineSearch" tabindex="1" class="easyui-combogrid" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Quantity</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtQuantity" autocomplete="off" onlynumber="10" " max-value="1000" decimalplace="4" tabindex="2"  onkeyup="addItem(event)"  />
                        </div>
                        <div class="col-md-1">
                            <input type="button" value="Add" onclick="addItem(event)" class="pull-left" tabindex="3" />
                        </div>

                        <div class="col-md-2">
                          <button style="width: 100%; padding: 0px;" class="label label-important" type="button" tabindex="1000">
                              <span id="lblTotalSelectedItemsCount" style="font-size: 14px; font-weight: bold;">Items : 0</span>
                          </button>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

          <%--add medicine--%>
            <div style="display: none" id="divSelectedMedicine" class="POuter_Box_Inventory">
            <table id="tblSelectedMedicine" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr id="IssueItemHeader">
                        <th class="GridViewHeaderStyle" scope="col">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col">Supplier Name</th>
                        <th class="GridViewHeaderStyle" scope="col">Item Name</th>
                        <th class="GridViewHeaderStyle" scope="col">Batch No.</th>
                        <th class="GridViewHeaderStyle" scope="col">Expiry</th>
                        <th class="GridViewHeaderStyle" scope="col">Unit</th>
                        <th class="GridViewHeaderStyle" scope="col">Purchase Price</th>
                        <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                        <th class="GridViewHeaderStyle" scope="col">VAT</th>
                        <th class="GridViewHeaderStyle" scope="col">Tax Amt.</th>
                        <% }else{%>
                        <th class="GridViewHeaderStyle" scope="col">IGST</th>
                        <th class="GridViewHeaderStyle" scope="col">SGST/UTGST</th>
                        <th class="GridViewHeaderStyle" scope="col">CGST</th>
                        <%} %>
                        <th class="GridViewHeaderStyle" scope="col">Selling Price</th>
                        <th class="GridViewHeaderStyle" scope="col">Stock Qty.</th>
                        <th class="GridViewHeaderStyle" scope="col">Qty.</th>
                        <th class="GridViewHeaderStyle" scope="col">Total Cost</th>
                        <th class="GridViewHeaderStyle" scope="col">Remove</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
           <div id="divtotalamount" style="display: none" class="POuter_Box_Inventory">
          <div class="row" >
              <div class="col-md-3">
              <label class="pull-left">Total Amount</label>
                  <b class="pull-right">:</b>
              </div>
              <div class="col-md-3">
                  <input type="text" id="txttotalamount" style="color:red;font-size:large" disabled onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="ItDoseTextinputNum" autocomplete="off"   />
              </div>
              <div class="col-md-5"></div>
              <div class="col-md-3">
                  <input type="button" id="btnSave" value="Save" onclick="SaveConsignment(this)" />
              </div>
          </div></div>
      </div>
      <div id="oldPatientModel" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px">
            <div class="modal-header">
                <button type="button" class="close"  onclick="$closeOldPatientSearchModel()"   aria-hidden="true">&times;</button>
                <h4 class="modal-title">Old Patient Search</h4>
            </div>
            <div class="modal-body">
                 <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  UHID    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">

                          <input type="text" id="txtSearchModelMrNO" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left">   </label>
                           <b class="pull-right"></b>
                     </div>
                     <div  class="col-md-8"></div>
                 </div>
                  <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  First Name    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <input type="text" id="txtSearchModelFirstName" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> Last Name   </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <input type="text" id="txtSearchModelLastName" />
                     </div>
                 </div>

                  <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  Contact No.   </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                         <input type="text" id="txtSerachModelContactNo" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> Address    </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                         <input type="text" id="txtSearchModelAddress" />
                     </div>
                 </div>
                 <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  From Date    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                           <cc1:calendarextender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> To Date    </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                          <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                          <cc1:calendarextender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                 </div>


                <div style="text-align:center" class="row">
                       <button type="button"  onclick="$searchOldPatientDetail()">Search</button>
                </div>
                <div style="height:200px"  class="row">
                    <div id="divSearchModelPatientSearchResults" class="col-md-24">


                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button"  onclick="$closeOldPatientSearchModel()">Close</button>
            </div>
        </div>
    </div>
</div>
       <div id="dvAllergiesAndDiagnosis" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 40%;">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="closeAllergiesAndDiagnosisModel()" aria-hidden="true">×</button>
                        <h4 class="modal-title">Patient Allergies & Diagnosis</h4>
                    </div>
                    <div style="max-height: 200px; overflow:auto;" class="modal-body">
                        <div id="dvAllergiesAndDiagnosisData"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" onclick="closeAllergiesAndDiagnosisModel()">Close</button>
                    </div>
                </div>
            </div>
        </div>
    <script type="text/javascript">
        var SaveConsignment = function () {
            getconsignmentIssueDetails(function (medicine, patientissue) {
                $('#btnSave').attr('disabled', true).val('Submitting...');
                serverCall('IssueConsignment.aspx/IssueConsignmentdetail', { medicine: medicine, patientissue: patientissue }, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        $('#btnSave').removeAttr('disabled').val('Save');
                        if ($responseData.status) {
                            window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.message + '&IsBill=1&Duplicate=0&Type=PHY');
                            $.each($responseData.grnlist, function () {
							
                                window.open('../Store/DirectGRNReport.aspx?Hos_GRN=' + this.grnno);
                            });
                            window.location.reload();
                        }
                    });
                });
            });
        }

        var getconsignmentIssueDetails = function (callback) {
            var patientissue = []
            patientissue.push({
                patientid: $('#lblMrNo').text(),
                transactionid: $('#lblTransactionID').text(),
                panelid: $('#lblpanelid').text(),
                patienttype: $('#lblPatient_Typ').text(),
                totalamount: $('#txttotalamount').val(),
                deptledgerno: $('#lblDeptLedgerNo').text(),
                IPDCaseTypeID: $('#lblIPDCaseType_ID').text(),
                RoomID: $('#lblRoom_ID').text(),
                patientledgerno: $('#lblPatientLedgerNo').text(),
                doctorid: $('#lblDoctor_ID').text()
            });
            var medicine = [];
            $('#tblSelectedMedicine tbody tr').each(function () {
                medicine.push({
                    consignmentdetails: $(this).find('#spnconsignmentdetails').text(),
                    quantity: $(this).find('#txtIssueQty').val(),
                    supplierID: $(this).find('#spnconsignmentdetails').text().split('#')[2],
                    transactionid: $('#lblPDNo').text(),
                    deptledgerno: $('#lblDeptLedgerNo').text()
                });
            });

            callback(medicine, patientissue);
        }
        var addItem = function (e) {
            var txtMedicineSearch = $('#txtMedicineSearch');
            var txtQuantity = $('#txtQuantity');
            var quantity = isNaN(parseFloat(txtQuantity.val())) ? 0 : parseFloat(txtQuantity.val());
            var grid = txtMedicineSearch.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');
            var code = (e.keyCode ? e.keyCode : e.which);
            if (String.isNullOrEmpty(selectedRow)) {
                modelAlert('Please Select Item First', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
                return;
            }

            var stockID = $.trim(selectedRow.ItemID.split('#')[1]);




            var alreadySelectBool = $('#tr_' + stockID).length > 0 ? true : false;
            if (alreadySelectBool) {
                modelAlert('Item Already Added', function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
                return;
            }
            if (quantity == 0)
                return;
            var itemID = selectedRow.ItemID.split('#')[0];
            var avilableQuantity = selectedRow.AvlQty;
            var deptLedgerNo = $('#lblDeptLedgerNo').text().trim();
            if (quantity > parseFloat(selectedRow.AvlQty)) {
                modelAlert('Stock Not Avilable', function () {
                    txtQuantity.val('').focus();
                });
                return;
            }
            var itemdetails = {
                itemID: itemID,
                quantity: quantity,
                stockid: stockID,
                avilableQuantity: avilableQuantity,
                deptLedgerNo: deptLedgerNo,
                ItemName: selectedRow.ItemName,
                MRP: selectedRow.MRP,
                BatchNumber: selectedRow.BatchNumber,
                PurTaxPer: selectedRow.ItemID.split('#')[3],
                PurTaxAmt: selectedRow.ItemID.split('#')[4],
                SaleTaxPer: selectedRow.ItemID.split('#')[5],
                SaleTaxAmt: selectedRow.ItemID.split('#')[6],
                Unit: selectedRow.ItemID.split('#')[7],
                MedExpiryDate: selectedRow.Expiry,
                PurchaePrice: selectedRow.ItemID.split('#')[8],
                LedgerName: selectedRow.LedgerName,
                stockdetails: selectedRow.ItemID,
                IGSTPercent: selectedRow.IGSTPercent,
                CGSTPercent: selectedRow.CGSTPercent,
                SGSTPercent: selectedRow.SGSTPercent
            };
            if (code == 13 && e.target.type == 'text') {
                quantity = e.target.value;
                bindItem(itemdetails, function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
            }
            else if (e.target.type == 'button') {
                bindItem(itemdetails, function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
            }

            if (code == 9 && e.target.type == 'text') {
                $(this).parent().find('input[type=button]').focus();
            }
        }
        var bindItem = function (itemdetails, callback) {
            addNewRow(itemdetails, function (response) {
                if (response) {
                    if ($('#tblSelectedMedicine tbody').find('tr').length > 0)
                        $('#divSelectedMedicine').show();
                    calculateTotal(function (total) {
                        callback();
                    });
                }
            });
        }
        var calculateTotal = function (callback) {
            var totalAmount = 0;
            var totalDiscountAmount = 0;
            $('#tblSelectedMedicine tbody tr').each(function () {
                totalAmount += Number($(this).find('#tdGrossAmount').text());
            });
            $('#txttotalamount').val(precise_round(totalAmount, 2));
            if (totalAmount > 0)
                $("#divtotalamount").show();
            else
                $("#divtotalamount").hide();
            callback(totalAmount);
        }
        var removeMedicine = function (elem) {
            $(elem).parent().parent().remove();
            calculateTotal(function (total) { });
        }
        var onQuantityChange = function (elem, callback) {
            var row = $(elem).closest('tr');
            var quantity = isNaN(parseFloat(elem.value)) ? 0 : elem.value;
            var mrp = parseFloat(row.find('#tdsellingprice').text());
            var grossAmount = precise_round((parseFloat(quantity) * parseFloat(mrp)), 4);
            row.find('#tdGrossAmount').text(grossAmount);
            calculateTotal(function (total) {
                callback();
            });
        }
        var addNewRow = function (itemDetails,callback) {
            var grossAmount = precise_round(parseFloat((parseFloat(itemDetails.quantity) * parseFloat(itemDetails.MRP))), 4);
            var netAmmount = grossAmount;
            var table = $('#tblSelectedMedicine tbody');
            var newRow = $('<tr />').attr('id', 'tr_' + itemDetails.stockid);
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                newRow.html(
                                  '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center">' + (table.find('tr').length + 1) +
                                  '</td><td class="GridViewLabItemStyle" id="tditembame">' + itemDetails.LedgerName +
                                  '</td><td class="GridViewLabItemStyle" id="tditembame">' + itemDetails.ItemName +
                                  '</td><td class="GridViewLabItemStyle" id="tdbatchbumber" style="text-align:center">' + itemDetails.BatchNumber +
                                  '</td><td class="GridViewLabItemStyle" id="tdmedexpirydate">' + itemDetails.MedExpiryDate +
                                  '</td><td class="GridViewLabItemStyle" id="tdunit">' + itemDetails.Unit +
                                  '</td><td class="GridViewLabItemStyle" id="tdpurchaseprice">' + precise_round(itemDetails.PurchaePrice, 2) +
                                  '</td><td class="GridViewLabItemStyle" id="tdvatper">' + precise_round(itemDetails.PurTaxPer, 2) +
                                  '</td><td class="GridViewLabItemStyle" id="tdvatamt">' + precise_round(itemDetails.PurTaxAmt, 2) +
                                  '</td><td class="GridViewLabItemStyle" id="tdsellingprice">' + precise_round(itemDetails.MRP, 2) +
                                  '</td><td class="GridViewLabItemStyle" id="tdavilablequantity">' + itemDetails.avilableQuantity +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;width:50px" id="tdissueqty"><span id="spnconsignmentdetails" style="display:none">' + itemDetails.stockdetails + '</span><input type="text" max-value="' + itemDetails.AvlQty + '" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off"  id="txtIssueQty" maxlength="4"  onkeyup="onQuantityChange(this,function(){});"   style="" value=' + itemDetails.quantity + ' />' +
                                  '</td><td class="GridViewLabItemStyle" id="tdGrossAmount">' + netAmmount +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgPhRemove"><img id="imgRmv" class="btn" src="../../Images/Delete.gif" onclick="removeMedicine(this);"  class="pharmacyRemove"  style="cursor:pointer;" title="Click To Remove"/></td>'
                                  );
            }
            else {
                newRow.html(
                    '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center">' + (table.find('tr').length + 1) +
                    '</td><td class="GridViewLabItemStyle" id="tditembame">' + itemDetails.LedgerName +
                    '</td><td class="GridViewLabItemStyle" id="tditembame">' + itemDetails.ItemName +
                    '</td><td class="GridViewLabItemStyle" id="tdbatchbumber" style="text-align:center">' + itemDetails.BatchNumber +
                    '</td><td class="GridViewLabItemStyle" id="tdmedexpirydate">' + itemDetails.MedExpiryDate +
                    '</td><td class="GridViewLabItemStyle" id="tdunit">' + itemDetails.Unit +
                    '</td><td class="GridViewLabItemStyle" id="tdpurchaseprice">' + precise_round(itemDetails.PurchaePrice, 2) +
                    '</td><td class="GridViewLabItemStyle" id="tdIGSTPercent">' + precise_round(itemDetails.IGSTPercent,2) +
                    '</td><td class="GridViewLabItemStyle" id="tdSGSTPercent">' + precise_round(itemDetails.SGSTPercent,2) +
                    '</td><td class="GridViewLabItemStyle" id="tdCGSTPercent">' + precise_round(itemDetails.CGSTPercent,2) +
                    '</td><td class="GridViewLabItemStyle" id="tdsellingprice">' + precise_round(itemDetails.MRP, 2) +
                    '</td><td class="GridViewLabItemStyle" id="tdavilablequantity">' + itemDetails.avilableQuantity +
                    '</td><td class="GridViewLabItemStyle" style="text-align:center;width:50px" id="tdissueqty"><span id="spnconsignmentdetails" style="display:none">' + itemDetails.stockdetails + '</span><input type="text" max-value="' + itemDetails.AvlQty + '" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off"  id="txtIssueQty" maxlength="4"  onkeyup="onQuantityChange(this,function(){});"   style="" value=' + itemDetails.quantity + ' />' +
                    '</td><td class="GridViewLabItemStyle" id="tdGrossAmount">' + netAmmount +
                    '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgPhRemove"><img id="imgRmv" class="btn" src="../../Images/Delete.gif" onclick="removeMedicine(this);"  class="pharmacyRemove"  style="cursor:pointer;" title="Click To Remove"/></td>'
                    );
            }
            table.append(newRow);
            callback(true);
        }











        var initMedicineSearch = function (callback) {
            try {
                getComboGridOption(function (response) {
                    $('#divMedicineSelect').removeAttr('style');
                    $('#txtMedicineSearch').combogrid(response);
                    $('#divMedicineSelect').hide();
                    callback(true);
                });
            } catch (e) {

            }
        }

        var getComboGridOption = function (callback) {
            var setting = {
                panelWidth: 850,
                idField: 'ItemID',
                textField: 'ItemName',
                mode: 'remote',
                url: 'IssueConsignment.aspx?cmd=item',
                loadMsg: 'Searching... ',
                method: 'get',
                pagination: true,
                pageSize: 50,
                rownumbers: true,
                fit: true,
                border: false,
                cache: false,
                nowrap: true,
                emptyrecords: 'No records to display.',
                queryParams: {
                    type: $('input[type=radio][name:rdoSearchBy]:checked').val(),
                    deptLedgerNo: $('#lblDeptLedgerNo').text().trim(),
                    sort: 'ItemName',
                    order: 'asc',
                    isWithAlternate: false,
                    isBarCodeScan: false
                },
                onHidePanel: function () { $('#txtQuantity').focus(); },
                columns: [[
                    { field: 'ItemName', title: 'ItemName', align: 'left', sortable: true },
                    { field: 'BatchNumber', title: 'Batch No.', align: 'center', sortable: true },
                    { field: 'AvlQty', title: 'Avl. Qty.', align: 'right', sortable: true },
                    { field: 'Expiry', title: 'Expiry', align: 'center', sortable: true },
                    { field: 'MRP', title: 'MRP', align: 'right', sortable: true },
                    { field: 'LedgerName', title: 'Supplier Name', align: 'right', sortable: true }
                ]],
                fitColumns: true,
                rowStyler: function (index, row) {
                    if (row.alterNate > 0) {
                        return 'background-color:antiquewhite;';
                    }
                }
            }
            callback(setting);
        }


        var _PageSize = 9;
        var _PageNo = 0;
        var $searchOldPatientDetail = function () {
            var data = {
                PatientID: $('#txtSearchModelMrNO').val(),
                PName: $('#txtSearchModelFirstName').val(),
                LName: $('#txtSearchModelLastName').val(),
                ContactNo: $('#txtSerachModelContactNo').val(),
                Address: $('#txtSearchModelAddress').val(),
                FromDate: $('#txtSearchModelFromDate').val(),
                ToDate: $('#txtSerachModelToDate').val(),
                PatientRegStatus: 1,
                isCheck: '0',
                AadharCardNo: '',
                MembershipCardNo: '',
                DOB: '',
                IsDOBChecked: '0',
                Relation: '0',
                RelationName: '',
                IPDNO: '',
                panelID: '',
                cardNo: '',
                IDProof: '',
                visitID: '',
                emailID: ''
            }
            serverCall('../Common/CommonService.asmx/oldPatientSearch', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    OldPatient = JSON.parse(response);
                    if (OldPatient != null) {
                        _PageCount = OldPatient.length / _PageSize;
                        showPage(0);
                    }
                    else {
                        $('#divSearchModelPatientSearchResults').html('');
                    }
                }
                else
                    $('#divSearchModelPatientSearchResults').html('');

            });
        }
        var $showOldPatientSearchModel = function () {
            $('#oldPatientModel').showModel();
        }

        var $closeOldPatientSearchModel = function () {
            $('#oldPatientModel').hideModel();
        }
        var bindDoctor = function (department, callback) {
            var $ddlOldPatientDoctor = $('#ddlOldPatientDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                $ddlOldPatientDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Doctor_ID', textField: 'Name', isSearchAble: true });
                callback($ddlOldPatientDoctor.val());
            });
        }
        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
            $('#divSearchModelPatientSearchResults').html(outputPatient);
        }

        var $IsShowAllergiesAndDiagnosisButton = function (patientID) {
            $("#btnAllergiesAndDiagnosis").hide();
            serverCall('../Store/OPDPharmacyIssue.aspx/GetAllergiesAndDiagnosis', { patientID: patientID }, function (response) {
                AllergiesAndDiagnosis = JSON.parse(response);
                if (AllergiesAndDiagnosis.length > 0) {
                    $("#btnAllergiesAndDiagnosis").show();
                }
            });
        }
        var $popupAllergiesAndDiagnosis = function () {
            serverCall('../Store/OPDPharmacyIssue.aspx/GetAllergiesAndDiagnosis', { patientID: $('#lblMrNo').text() }, function (response) {
                AllergiesAndDiagnosis = JSON.parse(response);
                if (AllergiesAndDiagnosis.length > 0) {
                    var message = $('#tb_AllergiesAndDiagnosispopup').parseTemplate(AllergiesAndDiagnosis);
                    $('#dvAllergiesAndDiagnosisData').html(message);
                    $('#dvAllergiesAndDiagnosis').showModel();
                }

            });
        }
        var closeAllergiesAndDiagnosisModel = function () {
            $('#dvAllergiesAndDiagnosis').closeModel();
        }
        var searchPatientByID = function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13 && e.target.type == 'text') {
                $getPatientDetails(null, function (response) {
                    $bindPatientDetails(response, function () {
                     
                    });
                });
            }
            else if (e.target.type == 'button') {
                $getPatientDetails(null, function (response) {
                    $bindPatientDetails(response, function () {
                        
                    });
                });
            }
        }

        var $getPatientDetails = function (selectPatientID, callback) {
            // var patientType = $('input[type=radio][name=rdoPatientType]:checked').val();
            var data = {
                patientID: $.trim($('#txtPatientId').val()),
                IPDNo: $.trim($('#txtIPDNO').val()),
            }

            if (!String.isNullOrEmpty(selectPatientID))
                data.patientID = selectPatientID

            serverCall('IssueConsignment.aspx/bindData', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    if (responseData.data.length > 0)
                        callback(responseData.data[0]);
                    else
                        modelAlert(responseData.message);
                }
                else {
                    modelAlert(responseData.message, function () {
                        clearHospitalPatientDetails(function () { $('#divMedicineSelect,#divHospitalPatientEntry').hide(); });
                    });
                    return;
                }
            });
        }
        var $bindPatientDetails = function (data, callback) {
            if (data.IsMedCleared == 0) {
                $('#lblPatientName').text(data.PName);
                $('#lblMrNo').text(data.PatientID);
                $('#lblAgeSex').text(data.Age + '/' + data.Gender);
                $('#lblAddresss').text(data.Address);
                $('#lblContact').text(data.Mobile);
                $('#lblPDNo').text(data.TransNo);//.replace("ISHHI", "")
                $('#ddlOldPatientDoctor').val(data.DoctorID).chosen('destroy').chosen({ width: '100%' });
                $('#lblTransactionID').text(data.TransactionID)
                $('#lblpanelid').text(data.PanelID)
                $('#lblPatientLedgerNo').text(data.PatientLedgerNo)
                $('#lblRoom_ID').text(data.RoomID)
                $('#lblIPDCaseType_ID').text(data.IPDCaseTypeID)
                $('#lblPatient_Typ').text(data.PatientType)
                $('#lblIsMedCleared').text(data.IsMedCleared)
                $('#lblDoctor_ID').text(data.DoctorID)
                $('#divMedicineSelect,#divHospitalPatientEntry').show();
                $('#tblSelectedMedicine tbody').html('');
                if ($('#tblSelectedMedicine tbody').length <= 1) {
                    $('#divSelectedMedicine').hide();
                }
                $('#txttotalamount').val(0);
                $("#divtotalamount").hide();
                $closeOldPatientSearchModel();
                $IsShowAllergiesAndDiagnosisButton(data.PatientID);
                $popupAllergiesAndDiagnosis();
                callback(true);
            }
            else {
                modelAlert("PATIENT MEDICAL CLEARANCE HAS BEEN DONE, YOU CAN'T ISSUE ANY ITEMS.", function () {
                    $('#divHospitalPatientEntry .patientInfo').text('');
                    $('#divMedicineSelect,#divHospitalPatientEntry,#divSelectedMedicine').hide();
                    $('#tblSelectedMedicine tbody').html('');
                    $('#txttotalamount').val(0);
                    $("#divtotalamount").hide();
                });
                callback(false);
            }
        }
        var clearHospitalPatientDetails = function (callback) {
            $('#divHospitalPatientEntry .patientInfo').text('');
            $('#ddlOldPatientDoctor').val('0').chosen('destroy').chosen({ width: '100%' });
            $('#ddlOldPatientDoctor').val('<%=Resources.Resource.DefaultPanelID %>').chosen('destroy').chosen({ width: '100%' });
        callback(true);
        }
        var $searchPatient = function (data, IPDDetails, callback) {
            var IPDAdmissionDetails = IPDDetails.split('#');
            var IPDTransactionID = IPDAdmissionDetails[0];
            var IPDAdmissionRoomType = IPDAdmissionDetails[1];
            if (!String.isNullOrEmpty(IPDTransactionID)) {
                modelConfirmation('<span style="color: red;">Patient is Already Admited !</span>', '<span style="color: black;"> With IPD NO. :<span> &nbsp;<span style="color: blue;"> ' + IPDTransactionID.replace('ISHHI', '') + '</span></br><span style="color: black;">IN Room Type :</span>&nbsp; <span style="color: blue;">' + IPDAdmissionRoomType + '</span>', '', 'Close', function (response) {
                    $getPatientDetails(data.PatientID, function (response) {
                        callback(response);
                    });
                });
            }
            else {
                $getPatientDetails(data.PatientID, function (response) {
                    callback(response);
                });
            }
        }
        $(function () {
            initMedicineSearch(function () {
                $('.textbox-text').attr('tabindex', 1);
            });
            bindDoctor('All', function () { });
            shortcut.add("Alt+S", function () {
                var btnSave = $('#btnSave');
                if (!String.isNullOrEmpty(btnSave)) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        SaveConsignment(btnSave);
                    }
                }
            }, addShortCutOptions);
        });
    </script>

    <script id="tb_OldPatient" type="text/html">
    <table  id="tablePatient" cellspacing="0" rules="all" border="1" 
    style="width:876px;border-collapse :collapse;">
        <thead>
        <tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
            <th class="GridViewHeaderStyle" scope="col" >Title</th>
            <th class="GridViewHeaderStyle" scope="col" >First Name</th>
            <th class="GridViewHeaderStyle" scope="col" >L.Name</th>
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>
            <th class="GridViewHeaderStyle" scope="col" >Age</th>
            <th class="GridViewHeaderStyle" scope="col" >Sex</th>
            <th class="GridViewHeaderStyle" scope="col" >Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Address</th>
            <th class="GridViewHeaderStyle" scope="col" >Contact&nbsp;No.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Card No.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Valid To</th>                          
    
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
                        <tr id="<#=j+1#>"  
                             <#if(objRow.PatientRegStatus =="2"){#>
                        style="background-color:coral;cursor:pointer;"
                         
                        <#}
                         else {#>
                        style="cursor:pointer;"
                        <#}
                        #>
                            >                            
                        <td class="GridViewLabItemStyle">
                       <a  class="btn" onclick="$searchPatient({PatientID:$.trim($(this).closest('tr').find('#tdPatientID').text()),PatientRegStatus:1},$(this).find('#spnIPDDetails').text(),function(response){$bindPatientDetails(response,function(){})});" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
                          Select
                           <span style="display:none" id="spnIPDDetails"><#=objRow.IPDDetails#></span>
                       </a>    </td>                                                    
                        <td  class="GridViewLabItemStyle" id="tdTitle"  ><#=objRow.Title#></td>
                        <td class="GridViewLabItemStyle" id="tdPFirstName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PFirstName#></td>
                        <td class="GridViewLabItemStyle" id="tdPLastName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PLastName#></td>
                        <td class="GridViewLabItemStyle" id="tdPatientID"  ><#=objRow.MRNo#></td>
                        <td class="GridViewLabItemStyle" id="tdAge" ><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle" id="tdGender" ><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle" id="tdDate" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.Date#></td>
                        <td class="GridViewLabItemStyle" id="tdHouseNo" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"  ><#=objRow.SubHouseNo#></td>
                        <td class="GridViewLabItemStyle" id="tdContactNo" ><#=objRow.ContactNo#></td>  
                        <td class="GridViewLabItemStyle" id="tdCardNo" ><#=objRow.MemberShipCardNo#></td>   
                        <td class="GridViewLabItemStyle" id="tdValidTo" ><#=objRow.MemberShipValidTo#></td>                      
                        
                        <td class="GridViewLabItemStyle" id="tdPatientRegStatus" style="width:80px;display:none"><#=objRow.PatientRegStatus#></td>                         
                        </tr>            
        <#}        
        #>
            </tbody>      
     </table>  
     <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
       <tr>
   <# if(_PageCount>1) {
     for(var j=0;j<_PageCount;j++){ #>
     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}         
   }
#>
     </tr>     
     </table>  
    </script>
  

      <script id="tb_AllergiesAndDiagnosispopup" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdAllergiesAndDiagnosis" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="TrHead">
                <th class="GridViewHeaderStyle" scope="col" >S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Type</th>
                <th class="GridViewHeaderStyle" scope="col" >Value</th>
            </tr>
                </thead><tbody>
        <#       
        var dataLength=AllergiesAndDiagnosis.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = AllergiesAndDiagnosis[j];
        #>
               <tr id="TrBody" >        
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.EntryDate #></td>
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.DataType #></td>
                    <td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.DataValues #></td>
               </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>

</asp:Content>

