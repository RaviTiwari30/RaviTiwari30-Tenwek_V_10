<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OpeningBalanceEdit.aspx.cs" Inherits="Design_Finance_OpeningBalanceEdit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .selectedRow {
            background-color: aqua;
        }

        .newItem {
            background-color: bisque;
        }

        .ui-state-focus {
            /*background: none !important;*/
            background-color: #c6dff9 !important;
            border: none !important;
        }

        .ui-menu-item {
            width: 370px;
            max-width: 370px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .ui-widget-content {
            border-radius: 5px;
        }
    </style>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
         <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Opening Balance Bill Edit</b>
            </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"> 
                                <select id="ddlType">
                                    <option value="1">Bill No.</option>
                                    <option value="2">IPD No.</option>
                                    <option value="3">UHID</option>
                                </select>
                           </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearchValue" autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">From Bill Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">To Bill Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter">
            <input type="button" value="Search" class="save margin-top-on-btn" onclick="onBillSearch()" />
        </div>
        <div class="POuter_Box_Inventory textCenter" id="tblBills" style="max-height: 450px; overflow: auto">
        </div>
        <div class="POuter_Box_Inventory textCenter divBillDetails divEditBill hidden">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Service Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-7">
                    <select id="ddlService">
                        <option value="LSHHI20630">Doctor Charges</option>
                        <option value="LSHHI20631">Hospital Charges</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <input type="button" value="Add" class="save margin-top-on-btn" onclick="onAddItem()" />
                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-5">
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter divBillDetails divEditBill hidden">
            <table cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;" id="tblBillDetails">
                <thead>
                    <tr>
                        <td class="GridViewHeaderStyle">#</td>
                        <td class="GridViewHeaderStyle" style="width: 532px;">Item Name</td>
                        <td class="GridViewHeaderStyle" style="width: 99px;">Rate</td>
                        <td class="GridViewHeaderStyle" style="width: 99px;">Qty</td>
                        <td class="GridViewHeaderStyle">Discount(%)</td>
                        <td class="GridViewHeaderStyle" style="width: 250px;">Doctor</td>
                        <td class="GridViewHeaderStyle" style="width: 125px;">Gross Amount</td>
                        <td class="GridViewHeaderStyle" style="width: 115px;">Net Amount</td>
                        <td class="GridViewHeaderStyle" style="width: 80px">Is Active</td>
                    </tr>
                </thead>
                <tbody>
                </tbody>
                <tfoot></tfoot>
            </table>
        </div>

        <div class="POuter_Box_Inventory divDiscountReasonDetails  hidden">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Dis. Resason  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDiscountReason" class="required"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Approved By </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlApprovedBy" class="required"></select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <div class="POuter_Box_Inventory textCenter divEditBill hidden">
            <input type="button" value="Save" onclick="onSaveIPDOpeningBalanceBillDetails(this)" class="save margin-top-on-btn" />
        </div>
    </div>
    
    
    <script id="template_Bills" type="text/html">
        <table  id="tableBills" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >Sr No.</th>
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>
            <th class="GridViewHeaderStyle" scope="col" >IP No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Bill No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Bill Amount</th>
            <th class="GridViewHeaderStyle" scope="col" >Bill Date</th>
               <th class="GridViewHeaderStyle" scope="col" >Total Received Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" >Panel Name</th>
            <th class="GridViewHeaderStyle" scope="col">Select</th>  
                                 
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=responseData.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = responseData[j];
                #>          
                    <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" id="<#=j+1#>" style='cursor:pointer;'>                            
                        <td  class="GridViewLabItemStyle" id="td1" >  <#=j+1#>  </td>  
                        <td  class="GridViewLabItemStyle" id="td2" ><#=objRow.PatientID#></td> 
                        <td  class="GridViewLabItemStyle" id="td3" ><#=objRow.IPNo#></td>                                   
                        <td  class="GridViewLabItemStyle" id="td4"><#=objRow.BillNo#></td>
                        <td class="GridViewLabItemStyle" id="td5" ><#=objRow.TotalBilledAmt#></td>
                        <td class="GridViewLabItemStyle" id="td6" ><#=objRow.BillDate#></td>
                        <td class="GridViewLabItemStyle" id="td8" ><#=objRow.ReceivedAmt#></td>
                        <td class="GridViewLabItemStyle" id="td7" style="text-align:left;" ><#=objRow.PanelName#></td>   
                        <td class="GridViewLabItemStyle tdData"  style="display:none"><#=JSON.stringify(objRow)#></td>  
                        <td class="GridViewLabItemStyle">  
                              <a href="JavaScript:void(0)"  onclick="onBillEdit(this)" >Edit Bill</a>
                        </td>                       
                    </tr>            
            <#}#>            
            </tbody>
         </table>    
    </script>
    <script type="text/javascript">

        var doctorList = [];
        $(document).ready(function () {
            $bindDoctor('All', function () {
                bindDiscReason(function () {
                    bindApprovedMaster(function () {
                        //  onBillSearch(function () { });
                    });
                });
            });
        });

        var bindApprovedMaster = function (callback) {
            serverCall('../EDP/Services/EDP.asmx/bindDisAppoval', { ApprovalType: '', Type: '1' }, function (response) {
                if (String.isNullOrEmpty(response))
                    response = '[]';

                var discountApprovalMaster = JSON.parse(response);
                var ddlApprovedBy = $('#ddlApprovedBy');
                ddlApprovedBy.bindDropDown({ data: discountApprovalMaster, valueField: 'ApprovalType', textField: 'ApprovalType', defaultValue: '', selectedValue: '' });
                callback(ddlApprovedBy.val());
            });
        }

        var bindDiscReason = function (callback) {
            serverCall('../Common/CommonService.asmx/GetDiscReason', { Type: 'IPD' }, function (response) {
                var ddlDiscountReason = $('#ddlDiscountReason');
                ddlDiscountReason.bindDropDown({
                    defaultValue: '', selectedValue: '', data: JSON.parse(response), valueField: 'DiscountReason', textField: 'DiscountReason', isSearchAble: false
                });
                callback(ddlDiscountReason.find('option:selected').text());
            });
        }
        var onBillSearch = function () {

            var data = {
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                searchValue: $('#txtSearchValue').val(),
                searchType: Number($("#ddlType").val())
            };
            serverCall('OpeningBalanceEdit.aspx/SearchOpeningPatientBills', data, function (response) {
                responseData = JSON.parse(response);
                var parseHTML = $('#template_Bills').parseTemplate(responseData);
                $('#tblBills').html(parseHTML).customFixedHeader();
                $('.divEditBill').addClass('hidden');
            });
        }
        var onBillEdit = function (el) {

            var row = $(el).closest('tr');
            var tdData = JSON.parse(row.find('.tdData').text());

            $(row).closest('tbody').find('tr').removeClass('selectedRow');
            $(row).addClass('selectedRow');
            $('.divEditBill').addClass('hidden');

            if (Number(tdData.ReceivedAmt) >= Number(tdData.TotalBilledAmt)) {
                modelAlert("Bill Already Settled.After Fully Settlement,Modification are not Allow.");
                return;
            }

            if (Number(tdData.IsDoctorAllocationDone) > 0) {
                modelAlert("Doctor Allocation Done.After Doctor Allocation, Modification are not Allow.");
                return;
            }

            $('.divEditBill').removeClass('hidden');

            serverCall('OpeningBalanceEdit.aspx/GetBillDetails', { TID: tdData.TransactionID }, function (resposne) {
                var responseData = JSON.parse(resposne);
                console.log(responseData);
                if (responseData.status == false) {
                    modelAlert(responseData.message);
                }
                else {
                    bindBillDetails(responseData.message);
                }
            });
        }

        var bindBillDetails = function (data) {
            $('#tblBillDetails tbody tr').remove();
            for (var i = 0; i < data.length; i++) {
                addNewBillItem(false, function (lastRow) {
                    bindRowDetails(lastRow, data[i], function () { });
                });
            }

            calculateSummary();
        }

        var addNewBillItem = function (isSummaryRow, callback) {
            var rowCount = $('#tblBillDetails tbody tr').length + 1;
            var _tr = '<tr><td class="GridViewLabItemStyle">' + rowCount + '</td>'
            _tr += '<td class="GridViewLabItemStyle tdItem" style="text-align: left;"></td>'
            _tr += '<td class="GridViewLabItemStyle tdRate"><input type="text" class="ItDoseTextinputNum" onkeyup="onRowDataChange(this)" onlynumber="14" decimalplace="4" max-value="10000000" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>'
            _tr += '<td class="GridViewLabItemStyle tdQty"><input type="text" class="ItDoseTextinputNum" onkeyup="onRowDataChange(this)" onlynumber="4" decimalplace="2" max-value="1" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>'
            _tr += '<td class="GridViewLabItemStyle tdDiscountPercent"><input type="text" class="ItDoseTextinputNum" onkeyup="onRowDataChange(this)"  onlynumber="5" decimalplace="2" max-value="100" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>'
            _tr += '<td class="GridViewLabItemStyle tdDoctor" style="width: 250px;"><div class="divDoctor"><select></select></div></td>'
            _tr += '<td class="GridViewLabItemStyle tdGrossAmount"><input type="text" class="ItDoseTextinputNum" disabled="disabled"/></td>'
            _tr += '<td class="GridViewLabItemStyle tdNetAmount"><input type="text" class="ItDoseTextinputNum" disabled="disabled"/></td>'
            _tr += '<td class="GridViewLabItemStyle tdData hidden"></td>'
            _tr += '<td class="GridViewLabItemStyle tdIsActive" style="cursor:pointer"><input type="checkbox"></td>'

            _tr += '</tr>';

            var lastRow;
            if (isSummaryRow) {
                $('#tblBillDetails tfoot tr').remove();
                $('#tblBillDetails tfoot').append(_tr);
                lastRow = $('#tblBillDetails tfoot tr:last');
            }
            else {
                $('#tblBillDetails tbody').append(_tr);
                lastRow = $('#tblBillDetails tbody tr:last');
            }

            lastRow.find('select').bindDropDown({ defaultValue: 'Select', data: doctorList, valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
            callback(lastRow);

        }
        var bindRowDetails = function (row, data, callback) {

            var tdBillData = JSON.parse($('.selectedRow').find('.tdData').text());

            row.find('.tdItem').html(data.ItemName);
            row.find('.tdRate input[type=text]').val(data.Rate);
            row.find('.tdQty input[type=text]').val(data.Quantity).attr('disabled', true);
            row.find('.tdDiscountPercent input[type=text]').val(data.DiscountPercentage).attr('disabled', false);
            row.find('.tdDoctor select').val(data.DoctorID).trigger("chosen:updated");
            if (data.ItemID == "LSHHI20631")
                row.find('.divDoctor').addClass("hidden");
            else
                row.find('.divDoctor').removeClass("hidden");


            row.find('.tdGrossAmount input[type=text]').val(data.GrossAmount);
            row.find('.tdNetAmount input[type=text]').val(data.NetItemAmt);
            if (data.IsVerified == 2)
                row.find('.tdIsActive input[type=checkbox]').prop('checked', false);
            else
                row.find('.tdIsActive input[type=checkbox]').prop('checked', true);
            row.find('.tdData').text(JSON.stringify(data));

            callback();
        }
        var $bindDoctor = function (department, callback) {
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                doctorList = JSON.parse(response);
                callback();
            });
        }

        var onRowDataChange = function (el) {

            var changedRow = $(el).closest('tr');
            var quantity = Number(changedRow.find('.tdQty input[type=text]').val());
            var rate = Number(changedRow.find('.tdRate input[type=text]').val())
            var discount = Number(changedRow.find('.tdDiscountPercent input[type=text]').val());


            var grossAmount = precise_round((rate * quantity), 4);
            var discountAmount = (grossAmount * discount / 100);
            var netItemAmount = (grossAmount - discountAmount);



            var row = $(el).closest('tr');


            var tdData = JSON.parse(row.find('.tdData').text());

            if (tdData.IsPackage)
                netItemAmount = 0;

            changedRow.find('.tdGrossAmount input[type=text]').val(precise_round(grossAmount, 4));
            changedRow.find('.tdNetAmount input[type=text]').val(precise_round(netItemAmount, 4));
            calculateSummary();
        }
        var calculateSummary = function () {
            var totalGrossAmount = 0;
            var totalNetAmount = 0;
            var totalDiscountPercent = 0;


            $('#tblBillDetails tbody tr').each(function () {

                var netAmount = Number($(this).find('.tdNetAmount input[type=text]').val());
                totalNetAmount += netAmount;

                var grossAmount = Number($(this).find('.tdNetAmount input[type=text]').val());
                totalGrossAmount += Number($(this).find('.tdGrossAmount input[type=text]').val());
                totalDiscountPercent += Number($(this).find('.tdDiscountPercent input[type=text]').val());

            });
            var divDiscountReasonDetails = $('.divDiscountReasonDetails');
            if (totalDiscountPercent > 0) {
                divDiscountReasonDetails.removeClass('hidden');
            }
            else {
                divDiscountReasonDetails.addClass('hidden');
                divDiscountReasonDetails.find('select').val();
            }
            addNewBillItem(true, function (summaryRow) {
                $(summaryRow).find('td:first').text('');
                $(summaryRow).find('.tdDoctor').css({ 'text-align': 'right' }).html('<b class="patientInfo">Total:&nbsp;</b>')
                $(summaryRow).find('input[type=text],input[type=checkbox],select,div').hide();
                $(summaryRow).find('.tdNetAmount input[type=text]').val(totalNetAmount).show();
                $(summaryRow).find('.tdGrossAmount input[type=text]')
                $(summaryRow).find('.tdGrossAmount input[type=text]').val(totalGrossAmount).show();
            });

        }

        var onAddItem = function () {
            data = {
                itemName: $("#ddlService option:selected").text(),
                itemId: $("#ddlService").val()
            }
            addNewItemToBill(data);
        }
        var addNewItemToBill = function (data) {
            var tdData = JSON.parse($('.selectedRow').find('.tdData').text());
            // debugger;
            var panelID = tdData.PanelID;
            var itemDetails = data;
            if (itemDetails.itemId == "LSHHI20631" && Number(tdData.IsHospitalChargesApplied) > 0) {
                modelAlert("Hospital Charges can be add only once in the patient's bill.", function () {
                    $('#ddlService').focus();
                });
                return;
            }
            console.log(itemDetails);
            itemDetails.Rate = 0;
            itemDetails.ItemDisplayName = itemDetails.itemName;
            itemDetails.TransactionID = tdData.TransactionID;
            itemDetails.ItemName = itemDetails.itemName;
            itemDetails.ItemID = itemDetails.itemId;
            itemDetails.Quantity = 1;
            itemDetails.GrossAmount = 0;
            itemDetails.DiscountPercentage = 0;
            itemDetails.NetItemAmt = 0;
            itemDetails.IsVerified = 1;
            itemDetails.PanelID = panelID;
            itemDetails.PanelCurrencyCountryID = 0;
            itemDetails.PanelCurrencyFactor = 0;
            itemDetails.NetItemAmt = 0;
            itemDetails.SubCategoryID = "LSHHI139",

            addNewBillItem(false, function (lastRow) {
                $(lastRow).addClass('newItem');
                bindRowDetails(lastRow, itemDetails, function () {
                    calculateSummary();
                });
            });
        }



        var onSaveIPDOpeningBalanceBillDetails = function (btnSave) {
            modelConfirmation('Please Verify All The Patient Billing Detail`s.', 'Are You Sure To Update The Billing Details ?', 'Yes', 'No', function (res) {
                if (res) {
                    getBillChangeDetails(function (data) {
                        $(btnSave).attr('disabled', true).val('Submitting...');
                        serverCall('OpeningBalanceEdit.aspx/ChangeBillDetails', data, function (response) {
                            var responseData = JSON.parse(response);
                            modelAlert(responseData.response, function () {
                                if (responseData.status)
                                    window.location.reload();
                                else {
                                    modelAlert(responseData.message);
                                    $(btnSave).removeAttr('disabled').val('Save');
                                }

                            });
                        });
                    });
                }
            });
        }

        var getBillChangeDetails = function (callback) {
            // var duplicateDoctors = [];
            var LTD = [];

            var discountReason = $('#ddlDiscountReason option:selected').text();
            var approvedBy = $('#ddlApprovedBy option:selected').text();


            $('#tblBillDetails tbody tr').each(function () {
                // debugger;
                var tdData = JSON.parse($(this).find('.tdData').text());

                var rate = Number($(this).find('.tdRate').find('input[type=text]').val());
                var quantity = Number($(this).find('.tdQty').find('input[type=text]').val());
                var discountPercent = Number($(this).find('.tdDiscountPercent').find('input[type=text]').val());
                var doctorID = $(this).find('.tdDoctor').find('select').val();
                var grossAmount = Number($(this).find('.tdGrossAmount').find('input[type=text]').val());
                var netAmount = Number($(this).find('.tdNetAmount').find('input[type=text]').val());
                var isVerified = $(this).find('.tdIsActive').find('input[type=checkbox]').is(':checked') ? 1 : 2;



                var data = {
                    LedgerTransactionNo: tdData.LedgerTransactionNo,
                    LedgerTnxID: tdData.LedgerTnxID,
                    IsAdvance: 0,
                    ItemID: tdData.ItemID,
                    Rate: rate,
                    Quantity: quantity,
                    DiscountPercentage: discountPercent,
                    SubCategoryID: tdData.SubCategoryID,
                    ItemName: tdData.ItemName,
                    DiscountReason: tdData.discountReason,
                    DoctorID: doctorID,
                    CoPayPercent: 0,
                    IsPayable: 0,
                    isPanelWiseDisc: 0,
                    isMobileBooking: 0,
                    CategoryID: tdData.CategoryID,
                    salesID: 0,
                    remark: '',
                    TransactionID: tdData.TransactionID,
                    IsVerified: isVerified,
                    IsPackage: 0,
                    PackageID: '',
                    panelCurrencyCountryID: tdData.PanelCurrencyCountryID,
                    IPDCaseType_ID: tdData.IPDCaseType_ID,
                    Room_ID: tdData.Room_ID,
                    PanelCurrencyFactor: tdData.PanelCurrencyFactor
                };
                LTD.push(data);
            });



            var zeroRateItems = LTD.filter(function (i) {
                return i.Rate <= 0
            });


            if (zeroRateItems.length > 0) {
                modelAlert('Some Item have 0 Rate.');
                return false;
            }


            var zeroQuantityItems = LTD.filter(function (i) {
                return i.Quantity <= 0
            });



            if (zeroQuantityItems.length > 0) {
                modelAlert('Some Item have 0 Quantity.');
                return false;
            }

            // debugger;
            var unSelectedDoctorItems = LTD.filter(function (i) {
                return i.DoctorID == '0' && i.ItemID != 'LSHHI20631'
            });




            if (unSelectedDoctorItems.length > 0) {
                modelAlert('Some Item have Invalid Doctor.');
                return false;
            }



            var discountItems = LTD.filter(function (i) {
                return i.DiscountPercentage > 0 && i.IsVerified == 1
            });


            if (discountItems.length > 0) {

                if (String.isNullOrEmpty(discountReason)) {
                    modelAlert('Please Select Discount Reason.');
                    return false;
                }


                if (String.isNullOrEmpty(approvedBy)) {
                    modelAlert('Please Select Approved By.');
                    return false;
                }
            }

            var duplicateDoctorName = "";
            $('#tblBillDetails tbody tr').each(function () {
                var docId = $(this).find('.tdDoctor').find('select').val();
                var isDuplicate = LTD.filter(function (i) { return i.DoctorID == docId && i.ItemID != 'LSHHI20631' });
                if (isDuplicate.length > 1) {
                    duplicateDoctorName = $(this).find('.tdDoctor').find('select option:selected').text();
                }
            });

            if (!String.isNullOrEmpty(duplicateDoctorName)) {
                modelAlert("Doctor : <span class='patientInfo'>'" + duplicateDoctorName + "'</span> could not be add more than one times in the patient's bill.");
                return false;
            }
            callback({ LTD: LTD, DiscountReason: discountReason, ApprovedBy: approvedBy });

        }

    </script>
</asp:Content>

