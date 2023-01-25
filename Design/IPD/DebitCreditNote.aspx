<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DebitCreditNote.aspx.cs" Inherits="Design_IPD_DebitCreditNote" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>

    <script type="text/javascript">

        var onPatientSearch = function () {
            var data = {
                patientID: $.trim($('#txtPatientID').val()),
                transactionID:  $.trim($('#txtIPDNo').val()),
                patientName: $.trim($('#txtPatientName').val()),
                billNo: $.trim($('#txtBillNumber').val())
            }



            if (String.isNullOrEmpty(data.patientID)
                && String.isNullOrEmpty(data.transactionID)
                 && String.isNullOrEmpty(data.patientName)
                && String.isNullOrEmpty(data.billNo)) {
                modelAlert('Invalid Search Criteria.')

                return false;
            }




            data.transactionID = data.transactionID;//'ISHHI' +
            serverCall('Services/DebitCreditNote.asmx/SearchPatient', data, function (response) {
                templateData = JSON.parse(response);
                $('#tableDebitCreditNoteDetails tbody tr').html('').remove();
                var html = $('#templatePatientDetails').parseTemplate(templateData);
                $('#divPatientDetails').html(html).show();
                $('.clearDiv').html('').closest('.POuter_Box_Inventory').addClass('hidden');
                $('.hideDiv').closest('.POuter_Box_Inventory').addClass('hidden');
            });
        }
        var getDepartmentWiseDetails = function (el) {
            var data = JSON.parse($(el).closest('tr').find('#tdData').text());
            var trid = $(el).closest('tr').attr('id');
            $('#lblSelectedPatientDetails').text(JSON.stringify(data));
            serverCall('Services/DebitCreditNote.asmx/getDepartmentWiseDetails', { transactionID: data.TransactionID, Type: data.Type, LedgertransactionNo: data.LedgertransactionNo }, function (response) {
              var responseData = JSON.parse(response);
              if (responseData.status) {
                  templateData = responseData.data;
                    $("#tablePatientDetails").find("tr:gt(" + trid + ")").remove();
                    $('#tableDepartmentWiseDetails tr').slice(1).remove();
                    var html = $('#templateDepartmentWiseDetails').parseTemplate(templateData);
                    $('#divDepartmentWiseDetails').html(html).closest('.POuter_Box_Inventory').removeClass('hidden');
                }
                else
                    modelAlert(responseData.message);
            });
        }
        var getDepartmentItemDetails = function (el) {
            var selectedPatientDetails = JSON.parse($('#lblSelectedPatientDetails').text());
            var selectedDepartmentDetails = JSON.parse(($(el).closest('tr').find('#tdData').text()));
            var data = {
                transactionID: selectedPatientDetails.TransactionID,
                configID: selectedDepartmentDetails.Category.split('#')[1],
                categoryID: selectedDepartmentDetails.Category.split('#')[0],
                displayName: selectedDepartmentDetails.DisplayName,
                Type: selectedDepartmentDetails.Type,
                LedgerTransactionNo: selectedDepartmentDetails.LedgerTransactionNo
            }

            serverCall('Services/DebitCreditNote.asmx/GetDepartmentItemDetails', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    templateData = responseData.data;
                    $(templateData).each(function () {
                        this.categoryID = data.categoryID;
                        this.displayName = data.displayName;
                    });
                    var html = $('#templateDepartmentItemDetails').parseTemplate(templateData);
                    $('#divDepartmentItemDetails').html(html).closest('.POuter_Box_Inventory').removeClass('hidden');
                    $('.hideDiv').addClass('hidden');
                    $('#txtcreditDebitAmount').val('').attr('max-value', 0);
                }
                else
                    modelAlert(responseData.message);
            });
        }
        var toggleSelect = function (isAll, rowid) {
            var creditDebitNoteType = { value: Number($('#ddlType').val()), text: $('#ddlType option:selected').text() };
            var allCheckBoxes = $('#divDepartmentItemDetails table tr td input[type=checkbox]');

            var isAllChecked = allCheckBoxes.not(':checked').length > 0 ? false : true;

            //var selectAll = $('#chkAll')[0];
            allCheckBoxes.prop('checked', false);
            $(rowid).closest('tr').find(':checkbox').prop('checked', true);
            // else
            // $(selectAll).prop('checked', isAllChecked);


            var totalCreditAmount = 0;
            allCheckBoxes.each(function (i, e) {
                if (e.checked) {
                    var data = JSON.parse($(e).closest('tr').find('#tdData').text());
                    totalCreditAmount += Number(data.NetAmount);
                    serverCall('Services/DebitCreditNote.asmx/GetPanelList', { Type: data.Type, LedgerTransactionNo: data.LedgerTransactionNo, TransactionID: data.TransactionID }, function (response) {
                        var $ddlPanelCompany = $('#ddlPanel');
                        $ddlPanelCompany.bindDropDown({ data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
                    });
                    if (Number(data.NetAmount) > 0) {
                        $('.hideDiv').removeClass('hidden');
                        if (data.Type == "OPD") {
                            $('.drdocCollection').removeClass('hidden');
                            $('.spnCashCollectedDoctor').text(data.CashCollectedDoctor);
                        }
                        else
                            $('.drdocCollection').addClass('hidden');
                    }
                    else
                        $('.hideDiv').addClass('hidden');
                }
            });
            $('#lblTotalAmount').text(totalCreditAmount);
            if (creditDebitNoteType.value == 2)
                totalCreditAmount = 1000000000000;
            $('#txtcreditDebitAmount').attr('max-value', totalCreditAmount);
            //var isChecked = allCheckBoxes.is(':checked');

        }


        var validateDoctorCollection = function (ctrlID)
        {
            if($(ctrlID).val()=="1")
                $("#txtCollectedAmount").addClass("requiredField").attr("disabled",false);
            else
                $("#txtCollectedAmount").val('').removeClass("requiredField").attr("disabled", true);
        }
        var getDebitCreditDetails = function (callback) {
            var allCheckedItems = $('#divDepartmentItemDetails table tr td input[type=checkbox]:checked');
            var _txtcreditDebitAmount = $('#txtcreditDebitAmount');
            var totalEligableCreditAmount = Number($('#lblTotalAmount').text());
            var totalCreditAmount = Number(_txtcreditDebitAmount.val());

            var creditDebitNoteType = { value: Number($('#ddlType').val()), text: $('#ddlType option:selected').text() };

            var noteType = '';
            if (creditDebitNoteType.value == 1 || creditDebitNoteType.value == 2) {
                noteType = 'CR';
            }
            else if (creditDebitNoteType.value == 3 || creditDebitNoteType.value == 4)
                noteType = 'DR';


            if (String.isNullOrEmpty(noteType)) {
                modelAlert('Please Select Note Type.', function () { });
                return false;
            }


            if (allCheckedItems.length == 0) {
                modelAlert('Please Select Items.', function () { });
                return false;
            }




            if (totalCreditAmount <= 0) {
                var message = 'Please Enter ' + creditDebitNoteType.text + ' Amount';
                modelAlert(message, function () {
                    _txtcreditDebitAmount.focus();
                    return;
                });
            }
            if ($('#txtcreditDebitAmount').val() == "" && $('#txtcreditDebitAmount').val() == "0") {
                modelAlert('Please Enter The Amount.', function () {
                    $('#txtcreditDebitAmount').focus();
                    return;
                });
            }
            if ($('#txtReason').val() == "") {
                modelAlert('Please Enter The Reason.', function () {
                    $('#txtReason').focus();
                    return;
                });
            }

            var creditPercent = Number((totalCreditAmount * 100 / totalEligableCreditAmount));
            var selectedPatientDetails = JSON.parse($('#lblSelectedPatientDetails').text());
            var TransactionID = selectedPatientDetails.TransactionID;
            var PayType = "PTNT";
            if ($('#ddlPanel').val() != 1)
                PayType = "PAN";
            var msg = "";

            var isDocCollect= Number($("#ddlIsDocCollection").val());
            var docCollectAmt = isDocCollect == 1 ? Number($("#txtCollectedAmount").val()) : 0;
            var collectedDoctor = $('.spnCashCollectedDoctor').text();
            var creditDebitDetails = [];
            $(allCheckedItems).each(function (i, e) {
                if (e.checked) {
                    var data = JSON.parse($(e).closest('tr').find('#tdData').text());
                    var amount = precise_round((data.NetAmount * creditPercent / 100), 4);
                    if ($('#ddlType').val() == "4" && data.DiscAmt <= 0) {
                        msg = 1;
                    }
                    if ($('#ddlType').val() == "4" && amount > data.DiscAmt) {
                        msg = 2;
                    }

                    var detail = {};
                    detail.CRDR = noteType;
                    detail.TransactionID = selectedPatientDetails.TransactionID,
                    detail.Amount = amount;
                    detail.PtTYPE = PayType;
                    detail.BillNo = data.BillNo;
                    detail.ItemName = data.ItemName;
                    detail.Narration = $('#txtReason').val();
                    detail.ItemID = data.ItemID;
                    detail.data = data;
                    detail.categoryID = data.categoryID;
                    detail.LedgerTnxID = data.ID;
                    detail.LedgerTransactionNo = data.LedgerTransactionNo;
                    detail.PanelID = $('#ddlPanel').val();
                    detail.Rate = data.NetAmount;
                    detail.CRDRNoteType = creditDebitNoteType.value;
                    detail.Type = data.Type,
                    detail.isDocCollect = isDocCollect==1? "Yes":"No",
                    detail.docCollectAmt = docCollectAmt,
                    detail.collectedDoctor = collectedDoctor

                    creditDebitDetails.push(detail);
                }
            });
            if (msg == 1) {
                modelAlert('In this bill no discount is applicable ,So that you can not give the debit note on discount.', function () {
                    $('#ddlType').focus();
                });
                return false;
            }
            if (msg == 2) {
                modelAlert('You can not give the debit note on discount more than existing discount amount.', function () {
                    $('#ddlType').focus();
                });
                return false;
            }
            if (creditDebitDetails.length < 1) {
                var message = 'Please Select Items For ' + creditDebitNoteType.text + ' Note.';
                modelAlert(message, function () { });
                return false;
            }
            callback({ creditDebitDetails: creditDebitDetails, patientID: selectedPatientDetails.PatientID });

        }


        var onCreditDebitNoteAdd = function (el) {
            if ($('#txtcreditDebitAmount').val() == "") {
                modelAlert('Please Enter The Amount.', function () {
                    $('#txtcreditDebitAmount').focus();
                });
                return false;
            }
            if ($('#txtReason').val() == "") {
                modelAlert('Please Enter The Reason.', function () {
                    $('#txtReason').focus();
                });
                return false;
            }

            if ($('#ddlIsDocCollection').val() == "1" && Number($('#txtCollectedAmount').val())<=0) {
                modelAlert('Please Enter Collected Amount.', function () {
                    $('#txtCollectedAmount').focus();
                });
                return false;
            }

            getDebitCreditDetails(function (data) {
                templateData = data.creditDebitDetails;

                var tableToAppend = $('#selectedDebitCreditNoteDetails table tbody');
                var selectedCategoryID = templateData[0].LedgerTnxID;
                tableToAppend.find('.' + selectedCategoryID).remove();

                var totalRows = tableToAppend.find('tr').length;
                for (var i = 0; i < templateData.length; i++) {
                    templateData[i].index = totalRows + 1;
                    totalRows = totalRows + 1;
                }
                var html = $('#templateSelectedItemTemplate').parseTemplate(templateData);
                tableToAppend.append(html);
                onAfterDebitCreditAdd(tableToAppend);
                $('#txtcreditDebitAmount,#txtReason,#txtCollectedAmount').val('');
                $('#ddlIsDocCollection').val('0');
            });
        }



        var onAfterDebitCreditAdd = function (tbody) {
            var totalRow = tbody.find('tr').length;
            $('#ddlType').attr('disabled', totalRow > 0)
            $('#btnSave').attr('disabled', !(totalRow > 0));
            tbody.find('tr').each(function (i, e) {
                $(this).find('td:eq(0)').text(i + 1);
            });

        }

        var onSelectedDebitCreditnoteRemove = function (el) {
            var tableToAppend = $('#selectedDebitCreditNoteDetails table tbody');
            $(el).closest('tr').remove();
            onAfterDebitCreditAdd(tableToAppend);
        }



        var onNoteTypeChange = function () {
            var creditDebitNoteType = { value: Number($('#ddlType').val()), text: $('#ddlType option:selected').text() };
            var totalCreditAmount = Number($('#lblTotalAmount').text());
            if (creditDebitNoteType.value > 2) {
                totalCreditAmount = 1000000000000;
                $('#lblDebitCreditText').text('Debit Amount');
            }
            else
                $('#lblDebitCreditText').text('Credit Amount');


            $('#txtcreditDebitAmount').val('').attr('max-value', totalCreditAmount);

        }



        var getSelectedDebitCreditDetails = function (callback) {
            var selectedPatientDetails = JSON.parse($('#lblSelectedPatientDetails').text());
            var creditDebitDetails = [];
            $('#selectedDebitCreditNoteDetails table tbody tr').each(function () {
                var data = JSON.parse($(this).find('.tdData').text());
                data.isDocCollect = data.isDocCollect == "Yes" ? 1 : 0;
                creditDebitDetails.push(data);
            });

            callback({ creditDebitDetails: creditDebitDetails, patientID: selectedPatientDetails.PatientID });
        }



        var onSaveCreditDebitDetails = function (btnSave) {
            getSelectedDebitCreditDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/DebitCreditNote.asmx/SaveCreditDebitDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.IsMultiPanel) {
                        modelAlert("Record Save Successfully,Please Enter Debit Notes Of Amount " + responseData.Amount, function () {
                            ReseizeIframe(responseData.TransactionId, responseData.PatientId, "");
                        }); 

                    } else {
                        modelAlert(responseData.response, function () {
                            if (responseData.status)
                                window.location.reload();
                            else
                                $(btnSave).removeAttr('disabled').val('Save');
                        });
                    } 

                });
            });
        }
        $(function () {
            $(':input[type=text]').keyup(function () {
                if (event.keyCode == 13) { onPatientSearch(); }
            })
            var currentUserID = '<%=Util.GetString(ViewState["UserID"])%>';

            var allowedUserID = ['EMP001'];

            if (allowedUserID.indexOf(currentUserID) < 0) {
                $('select[id=ddlType]').find('option[value=3],option[value=4]').attr('disabled', true)
            }
        });

    </script>



    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b><span id="lblHeader bold">Manage Debit/Credit Note</span></b>
            <span class="hidden" id="spnHashCode"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
                <label id="lblSelectedPatientDetails" class="hidden"></label>

            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="border-collapse:collapse">
                            <input type="text" id="txtPatientID" data-title="Enter UHID No."  autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD NO.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtIPDNo" maxlength="10" autocomplete="off" data-title="Enter IPD No."/>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientName" autocomplete="off" data-title="Enter Patient Name" />
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBillNumber" autocomplete="off" data-title="Enter Bill No." />
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


        </div>
        <div class="POuter_Box_Inventory textCenter">
            <input type="button" id="txtSearch" value="Search" class="save margin-top-on-btn" onclick="onPatientSearch()" />
        </div>
        <div class="POuter_Box_Inventory ">

            <div class="Purchaseheader">
                Patient Details
            </div>

            <div class="row">
                <div class="col-md-24" id="divPatientDetails"></div>
            </div>
        </div>


        <div class="POuter_Box_Inventory hidden">
            <div class="Purchaseheader">
                DepartmentWise Bill Details
            </div>

            <div class="row">
                <div class="col-md-24 clearDiv" id="divDepartmentWiseDetails"  ></div>
            </div>
        </div>


        <div class="POuter_Box_Inventory hidden">
            <div class="Purchaseheader">
                Item Details
            </div>

            <div class="row">
                <div class="col-md-24 clearDiv" id="divDepartmentItemDetails"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory hideDiv hidden">
            <div class="row">

                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type            
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlType" onchange="onNoteTypeChange()">
                                <option value="1">Credit Note On Rate</option>
                                <option value="2">Credit Note On Discount</option>
                                <%--<option value="3" >Debit Note On Rate</option>
                                <option value="4">Debit Note On Discount</option>--%>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Total Amount            
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <label id="lblTotalAmount" class="patientInfo bold">0</label>
                        </div>

                        <div class="col-md-3">
                            <label id="lblDebitCreditText" class="pull-left">
                                Credit Amount          
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtcreditDebitAmount"  onlynumber="15" decimalplace="4" max-value="0"  class="ItDoseTextinputNum required" autocomplete="off"  />
                        </div>
                    </div>
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel            
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPanel" >
                            </select>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">   
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Narration
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtReason" maxlength="80" class="required" autocomplete="off" />
                        </div>
                      </div>

                     <div class="row hidden drdocCollection" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Collection            
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlIsDocCollection" onchange="validateDoctorCollection(this);" >
                                <option value="0">No</option>
                                <option value="1">Yes</option>
                            </select>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">   
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Collected Amount
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtCollectedAmount"  onlynumber="14" decimalplace="4" max-value="100000000" disabled="disabled" autocomplete="off" />
                        </div>
                      </div>
                      <div class="row hidden drdocCollection" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Cash Collected By            
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <span class="spnCashCollectedDoctor patientInfo" style="font-weight:bold"></span>
                        </div>
                      </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>



          <div class="POuter_Box_Inventory textCenter hideDiv hidden">
               <input type="button"  value="Add" onclick="onCreditDebitNoteAdd()"  class="save margin-top-on-btn"  />
           </div>

         <div class="POuter_Box_Inventory">
            <div class="row">
                 <div class="col-md-24" id="selectedDebitCreditNoteDetails">

                     <table  cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;" id="tableDebitCreditNoteDetails">
        <thead>
        <tr >
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Item</th>
            <th class="GridViewHeaderStyle" scope="col" >Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" >Display Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Discount</th>
            <th class="GridViewHeaderStyle" scope="col" >Amount</th>
            <th class="GridViewHeaderStyle" scope="col" >Credit Note</th>
            <th class="GridViewHeaderStyle" scope="col" >Debit Note</th>
            <th class="GridViewHeaderStyle" scope="col" >Net Amount</th>
            <th class="GridViewHeaderStyle" scope="col" >Amount</th>
            <th class="GridViewHeaderStyle" scope="col" >Type</th>
            <th class="GridViewHeaderStyle" scope="col" >Narration</th>
            <th class="GridViewHeaderStyle" style="width:130px; display:none">Is Doc.Collect</th>
            <th class="GridViewHeaderStyle" style="width:150px; display:none">Collected Amt.</th>
            <th class="GridViewHeaderStyle" style="display:none" >Collected By</th>
            <th class="GridViewHeaderStyle" scope="col"></th>
        </tr>
         </thead><tbody>

                 </tbody>
             </table>



                 </div>
            </div>
         </div>


           <div class="POuter_Box_Inventory textCenter btnSaveClass">
               <input type="button" id="btnSave"  disabled="disabled" value="Save" onclick="onSaveCreditDebitDetails(this)"  class="save margin-top-on-btn" />
           </div>

    </div>





    <script id="templatePatientDetails" type="text/html">
    <table  cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;" id="tablePatientDetails">
        <thead>
        <tr id="Tr5">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Bill Date</th>
            <th class="GridViewHeaderStyle" scope="col" >BillNo</th>
            <th class="GridViewHeaderStyle" scope="col" >IPD No</th>
            <th class="GridViewHeaderStyle" scope="col" >Panel</th>
            <th class="GridViewHeaderStyle" scope="col" >Address</th>
            <th class="GridViewHeaderStyle" scope="col" ></th>
        </tr>
         </thead><tbody>
        <#       
        var dataLength=templateData.length;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = templateData[j];
        #>
                    <tr  id="<#=j+1#>">
                       
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle hidden" id="tdData" > <#= JSON.stringify(objRow) #></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.pname#></td>
                        <td class="GridViewLabItemStyle textCenter"><#=objRow.BillDate#></td>
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.BillNo#></td>
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.IPDNo#></td>
                    <td class="GridViewLabItemStyle textCenter" style="display:none"><#=objRow.TransactionID#></td>
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.company_name#></td>
                    <td class="GridViewLabItemStyle" id="td15" ><#=objRow.Address#></td>       
                    <td style="text-align:center" class="GridViewLabItemStyle">
                     <img alt="" src="../../Images/Post.gif" class="imgPlus"  style="cursor:pointer" onclick="getDepartmentWiseDetails(this)"  />
                    </td>
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>

    <script id="templateDepartmentWiseDetails" type="text/html">
    <table  cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;" id="tableDepartmentWiseDetails">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Department</th>
            <th class="GridViewHeaderStyle" scope="col" >Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" >Amount</th>
            <th class="GridViewHeaderStyle" scope="col" ></th>
        </tr>
         </thead><tbody>
        <#       
        var dataLength=templateData.length;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = templateData[j];
        #>
                    <tr  id="Tr2">
                       
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle hidden" id="tdData" > <#= JSON.stringify(objRow) #></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.DisplayName#></td>
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.Qty#></td>
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.NetAmt#></td>       
                    <td style="text-align:center" class="GridViewLabItemStyle">
                     <img alt="" src="../../Images/Post.gif" class="imgPlus"  style="cursor:pointer" onclick="getDepartmentItemDetails(this)"  />
                    </td>
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>


    <script id="templateDepartmentItemDetails" type="text/html">
    <table  cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr3">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Item</th>
            <th class="GridViewHeaderStyle" scope="col" >Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" >Discount Percent</th>
            <th class="GridViewHeaderStyle" scope="col" >Discount</th>
            <th class="GridViewHeaderStyle" scope="col" >Gross Amount</th>
            <th class="GridViewHeaderStyle" scope="col" >Credit Note</th>
            <th class="GridViewHeaderStyle" scope="col" >Debit Note</th>
            <th class="GridViewHeaderStyle" scope="col" >Net Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="padding-left: 3px;" >
               <%-- <input type="checkbox" onchange="toggleSelect(true)" id="chkAll"  />--%>
            </th>
        </tr>
         </thead><tbody>
        <#       
        var dataLength=templateData.length;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = templateData[j];
        #>
                    <tr  id="Tr4">
                       
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle hidden" id="tdData" > <#= JSON.stringify(objRow) #></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.ItemName#></td>  
<td class="GridViewLabItemStyle textCenter"><#=objRow.EntryDate#></td>   
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.Quantity#></td>   
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.DiscPer#></td>       
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.DiscAmt#></td>  
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.Amount#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.CreditAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.DebitAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.NetAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter">

                        <#if(objRow.NetAmount>0){#>
                        <input type="checkbox" onchange="toggleSelect(false,this)" />
                        <#}#>
                    </td> 
                   
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>




    <script id="templateSelectedItemTemplate" type="text/html">
    
        <#       
        var dataLength=templateData.length;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = templateData[j].data;
        var objData=templateData[j];
        #>
                    <tr  class='<#=objRow.ID#>'>
                       
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=objData.index #></td> 
                    <td class="GridViewLabItemStyle hidden tdData"  > <#= JSON.stringify(objData) #></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.ItemName#></td>   
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.Quantity#></td>   
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.displayName#></td>       
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.DiscAmt#></td>  
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.Amount#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.CreditAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.DebitAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=objRow.NetAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter" id="tdAmount" ><#=templateData[j].Amount#></td>
                    <td class="GridViewLabItemStyle textCenter" id="td1" ><#=templateData[j].CRDR#></td>
                    <td class="GridViewLabItemStyle textCenter" id="tdNarration" ><#=templateData[j].Narration#></td>
                    <td class="GridViewLabItemStyle textCenter" id="tdisDocCollect" style="display:none" ><#=objData.isDocCollect#></td>
                    <td class="GridViewLabItemStyle textCenter" id="tddocCollectAmt" style="display:none" ><#=objData.docCollectAmt#></td>
                    <td class="GridViewLabItemStyle textCenter" id="tdcollectedDoctor" style="display:none" ><#=objData.collectedDoctor#></td>
                    <td class="GridViewLabItemStyle textCenter">
                         <img alt="" src="../../Images/Delete.gif" class="imgPlus"  style="cursor:pointer" onclick="onSelectedDebitCreditnoteRemove(this)"  />
                    </td>  
               </tr>     
             
        <#}        
        #>   
    
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
                 'type': 'iframe',
                 'onClosed': function () {
                     parent.location.reload(true);
                     
                 }
             });
         }
    </script>


</asp:Content>

