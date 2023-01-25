<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UCDoctorAmounAllocation.ascx.cs" Inherits="Design_Controls_UCDoctorAmounAllocation" %>

<style type="text/css">
    .selected {
        background-color: aqua !important;
    }
</style>


<script type="text/javascript">

    //**********Global Variables**********
    writeOffReasonMasterArray = [];
    doctorAmountAllocationReceipt = '';
    //**********Global Variables**********



    var initDoctorAmountAllocationControl = function (callback) {
        getWriteOffReason(function () {
            callback();
        });
    }


    var getWriteOffReason = function (callback) {
        serverCall('../common/CommonService.asmx/GetDiscReason', { Type: 'WriteOff' }, function (response) {
            writeOffReasonMasterArray = JSON.parse(response);
            callback(writeOffReasonMasterArray);
        });
    }



    var bindDepartmentWiseDetails = function (data, callback) {
        var transactionID = data.transactionID;
        var pendingAmount = data.pendingAmount;
        var writeOffAmount = data.writeOffAmount;
        var receiptNo = data.receiptNo;
        var paymentModeId = Number(data.paymentModeID);
        doctorAmountAllocationReceipt = receiptNo;
        disableDoctorAllocationBankCut = data.enableBankCut;
        var data = {
            transactionID: transactionID,
            pendingForAllocation: pendingAmount,
            receiptNo: receiptNo,
            paymentModeID: paymentModeId
        };


        var _divDepartmentWiseDetails = $('#divDepartmentWiseDetails');
        var _divAllocationSummary = $('#divAllocationSummary');
        _divDepartmentWiseDetails.html('');
        getDepartmentwiseDetails(data, function (d) {
            templateData = d;

            var parseHTML = $('#templateDepartmentWiseDetails').parseTemplate(templateData);
            _divDepartmentWiseDetails.html(parseHTML).closest('.POuter_Box_Inventory').removeClass('hidden');
            _divAllocationSummary.find('.tdAmountToAllocate').text(data.pendingForAllocation);
            _divAllocationSummary.find('.tdWriteOffToAllocate').text(writeOffAmount);
            
            calculateSummary(function () { });
        });
        
        

    }


    var releaseDoctorAllocationControl = function (callback) {
        $('.crearDiv').html('');
        callback();

    }


    var getDepartmentwiseDetails = function (data, callback) {
        serverCall('Services/DoctorAmountAllocation.asmx/GetDepartmentWiseDetails', data, function (response) {
            var responseData = JSON.parse(response);
            callback(responseData);
        });
    }


    var getItemWiseDetails = function (el) {

        var parentElem = $(el).closest('tr').next().find('#tdItemDetail');


        toggleDetailsView($(el).closest('tr'), parentElem, function () {


            var data = JSON.parse($(el).closest('tr').find('.tdData').text());
            var pendingCollectionForAllocation = $.trim($(el).closest('tr').find('.txtICollection').val());
            var pendingWriteOffForAllocation = $.trim($(el).closest('tr').find('.txtIWriteOff').val());
            var pendingHCollectionForAllocation = $.trim($(el).closest('tr').find('.txtHospICollection').val());
            var pendingHWriteOffForAllocation = $.trim($(el).closest('tr').find('.txtHospIWriteOff').val());
            var pendingHCollectionForAllocationPer = 0;
            var pendingHWriteOffForAllocationPer = 0;
            var pendingCollectionForAllocationPer = 0;
            var pendingWriteOffForAllocationPer = 0;

            if (data.HospShareAmount > 0) {
                pendingHCollectionForAllocationPer = Number(pendingHCollectionForAllocation) * 100 / Number(data.HospShareAmount);
                pendingHWriteOffForAllocationPer = Number(pendingHWriteOffForAllocation) * 100 / Number(data.HospShareAmount)
            }
            if (data.MaxAllocation) {
                pendingCollectionForAllocationPer = Number(pendingCollectionForAllocation) * 100 / Number(data.MaxAllocation);
                pendingwriteOffForAllocationPer = Number(pendingWriteOffForAllocation) * 100 / Number(data.MaxAllocation);
            }

            var data = {
                transactionID: data.TransactionID,
                categoryId: data.CategoryID,
                configId: Number(data.ConfigID),
                serviceTypeId: Number(data.ServiceTypeId),
                pendingCollectionForAllocationPer: pendingCollectionForAllocationPer,
                pendingWriteOffForAllocationPer: pendingWriteOffForAllocationPer,
                pendingHWriteOffForAllocationPer: pendingHWriteOffForAllocationPer,
                pendingHCollectionForAllocationPer: pendingHCollectionForAllocationPer,
                receiptNo: doctorAmountAllocationReceipt,
                paymentModeID: data.PaymentModeID
            }

            if (isNaN(data.pendingCollectionForAllocationPer))
                data.pendingCollectionForAllocationPer = 0;

            if (isNaN(data.pendingwriteOffForAllocationPer))
                data.pendingwriteOffForAllocationPer = 0;

            var isAlreadyExits = parentElem.find('table').length;
            if (isAlreadyExits == 0) {
                serverCall('Services/DoctorAmountAllocation.asmx/GetDepartmentWiseItemDetails', data, function (response) {
                    templateData = JSON.parse(response);
                    console.info(templateData);
                    var parseHTML = $('#templateItemWiseDetails').parseTemplate(templateData);
                    $(el).closest('tr').next().find('#tdItemDetail').html(parseHTML);
                });
            }
        });
    }


    var toggleDetailsView = function (departmentElem, parentElem, callback) {
        var isDisplayNone = parentElem.hasClass('hidden');
        if (isDisplayNone) {
            parentElem.removeClass('hidden');
            departmentElem.addClass('selected');
        }
        else {
            parentElem.addClass('hidden');
            departmentElem.removeClass('selected');
        }

        callback();
    }



    var calculateTotal = function (e) {
        var el = e.target;
        var row = $(el).closest('tr');
        var data = JSON.parse(row.find('.tdData').text());


        //validate total Allocation
        if (['txtICollection', 'txtIWriteOff'].indexOf(e.target.classList[0]) > -1) {
            var total = Number(data.TotalDoctorAllocated);
            total += Number(row.find('.txtICollection').val());
            total += Number(row.find('.txtIWriteOff').val());
         
            if (total > Number(data.ShareAmount)) {
                modelAlert('Invalid Allocation.')
                total = total - Number(e.target.value);
                e.target.value = 0;
            }
            row.find('.tdDoctorPending').text(precise_round(data.ShareAmount - total, 4));
        }
        else if (['txtHospICollection', 'txtHospIWriteOff'].indexOf(e.target.classList[0]) > -1) {
            var total = Number(data.TotalHospitalAllocated);
            total += Number(row.find('.txtHospICollection').val());
            total += Number(row.find('.txtHospIWriteOff').val());
            if (total > Number(data.HospShareAmount)) {
                modelAlert('Invalid Allocation.')
                total = total - Number(e.target.value);
                e.target.value = 0;
              //  return false;
            }
            row.find('.tdHospitalPending').text(precise_round(data.HospShareAmount - total, 4));
        }
        //validate total Allocation



        var table = $(el).closest('table');
        var txtICollections = table.find('tbody').find('.' + el.classList[0]);
        var totalAmount = 0;
        for (var i = 0; i < txtICollections.length; i++) {
            totalAmount += Number(txtICollections[i].value);
        }
        var totalTxt = table.find('#' + el.classList[0]);
        var maxValue = Number(totalTxt.attr('max-value'));

        //if (totalAmount > maxValue) {
        //    var amount = Number(el.value);
        //    el.value = 0;
        //    totalAmount = totalAmount - amount;
        //}

       totalTxt.val(precise_round(totalAmount, 4));
    }

    var calculateProportionally = function (e, isBankCut) {
        var el = e.target;
        var row = $(el).closest('tr');
        var data = JSON.parse(row.find('.tdData').text());


        //validate total Allocation
        if (['txtICollection', 'txtIWriteOff'].indexOf(e.target.classList[0]) > -1) {
            var total = Number(data.TotalDoctorAllocated);
            total += Number(row.find('.txtICollection').val());
            total += Number(row.find('.txtIWriteOff').val());
            if (total > Number(data.ShareAmount)) {
                modelAlert('Invalid Allocation.')
                total = total - Number(e.target.value);
                e.target.value = 0;
               // return false;
            }

            row.find('.tdDoctorPending').text(precise_round(data.ShareAmount - total, 4));
        }
        else if (['txtHospICollection', 'txtHospIWriteOff'].indexOf(e.target.classList[0]) > -1) {
            var total = Number(data.TotalHospitalAllocated);
            total += Number(row.find('.txtHospICollection').val());
            total += Number(row.find('.txtHospIWriteOff').val());
            if (total > Number(data.HospShareAmount)) {
                modelAlert('Invalid Allocation.')
                total = total - Number(e.target.value);
                e.target.value = 0;
               // return false;
            }

            row.find('.tdHospitalPending').text(precise_round(data.HospShareAmount - total, 4));
        }
        //validate total Allocation





        var tableRows = row.next().find('table').find('tbody tr');
        var totalAmount = 0;
        for (var i = 0; i < tableRows.length - 1; i++) {
            var tdData = JSON.parse($(tableRows[i]).find('.tdData').text());
            var amount = 0;
            var percent = 0;

            if (['txtICollection', 'txtIWriteOff'].indexOf(e.target.classList[0]) > -1) {
                percent = (Number(el.value) * 100 / data.MaxAllocatedAmount);
                amount = precise_round(Number(tdData.MaxAllocatedAmount * percent / 100), 4);
            }
            else if (['txtHospICollection', 'txtHospIWriteOff'].indexOf(e.target.classList[0]) > -1) {
                percent = (Number(el.value) * 100 / data.MaxHAllocatedAmount);
                amount = precise_round(Number(tdData.MaxHAllocatedAmount * percent / 100), 4);
            }

            amount = isNaN(amount) ? 0 : amount;
            if (isBankCut == 1)
                amount = Number(el.value);

            totalAmount += amount;
            $(tableRows[i]).find('.' + el.classList[0]).val(amount).attr('max-value', Number(e.target.value));
        }
        totalAmount = precise_round(totalAmount, 4);
        $(tableRows[tableRows.length - 1]).find('#' + el.classList[0]).attr('max-value', Number(totalAmount)).val(Number(totalAmount));

        calculateSummary(function () { });
    }

    var getAllocationAmountDetails = function (callback) {
        var _divAllocationSummary = $('#divAllocationSummary');
        var pendingAmountAllocation = (Number(_divAllocationSummary.find('.tdPendingAmount').text()));
       
        if (pendingAmountAllocation < 0) {
            modelAlert('Invalid Allocation Amount.');
            return false;
        }


       // if (pendingAmountAllocation != 0) {
          //  modelAlert('Please Allocate Pending Amount.');
          //  return false;
       // }


      


        var categoryWiseAllocationDetails = [];
        $('#tableDepartmentWiseDetails tbody').find('.trDItems').each(function (i, e) {
            var data = JSON.parse($(e).find('.tdData').text());
            data.NewAllocation = Number($(e).find('.txtICollection').val());
            data.NewWriteOff = Number($(e).find('.txtIWriteOff').val());
            data.BankCut = Number($(e).find('.txtIBankCut').val());
            data.NewHospCollectionAllocation = Number($(e).find('.txtHospICollection').val());
            data.NewHospWriteOffAllocation = Number($(e).find('.txtHospIWriteOff').val());
            data.HospBankCut = Number($(e).find('.txtHospIBankCut').val());
            data.WriteOffReason = $.trim($(e).find('.ddlIWriteOffReason option:selected').val());
            data.HospWriteOffReason = $.trim($(e).find('.ddlHospIWriteOffReason option:selected').val());
            var itemWiseAllocationDetails = [];
            var tableRows = $(e).next().find('table').find('tbody tr');
            for (var j = 0; j < tableRows.length - 1; j++) {
                var itemWiseAllocationDetail = JSON.parse(($(tableRows[j]).find('.tdData').text()));
                itemWiseAllocationDetail.NewCollectionAllocation = Number($(tableRows[j]).find('.txtICollection').val());
                itemWiseAllocationDetail.NewWriteOffAllocation = Number($(tableRows[j]).find('.txtIWriteOff').val());
                itemWiseAllocationDetail.BankCut = Number($(tableRows[j]).find('.txtIBankCut').val());
                itemWiseAllocationDetail.NewHospCollectionAllocation = Number($(tableRows[j]).find('.txtHospICollection').val());
                itemWiseAllocationDetail.NewHospWriteOffAllocation = Number($(tableRows[j]).find('.txtHospIWriteOff').val());
                itemWiseAllocationDetail.HospBankCut = Number($(tableRows[j]).find('.txtHospIBankCut').val());
                itemWiseAllocationDetail.WriteOffReason = $.trim($(tableRows[j]).find('.ddlIWriteOffReason option:selected').val());
                itemWiseAllocationDetail.HospWriteOffReason = $.trim($(tableRows[j]).find('.ddlHospIWriteOffReason option:selected').val());

                itemWiseAllocationDetails.push(itemWiseAllocationDetail);
            }
            data.ItemWiseAllocationDetails = itemWiseAllocationDetails;
            categoryWiseAllocationDetails.push(data);
        });
        callback(categoryWiseAllocationDetails);
    }



    var calculateSummary = function (callback) {
        var totalAllocationAmount = 0;
        var totalWriteOffAmount = 0;
        var totalBankCut = 0;
        var totalHospAllocationAmount = 0;
        var totalHospWriteOffAmount = 0;
        var totalHospBankCut = 0;
        var _divAllocationSummary = $('#divAllocationSummary');
        var _tableDepartmentWiseDetails = $('#tableDepartmentWiseDetails');
        $('#tableDepartmentWiseDetails tbody .trDItems').each(function () {
            totalAllocationAmount += Number($(this).find('.txtICollection').val());
            totalWriteOffAmount += Number($(this).find('.txtIWriteOff').val());
            totalBankCut += Number($(this).find('.txtIBankCut').val());
            totalHospAllocationAmount += Number($(this).find('.txtHospICollection').val());
            totalHospWriteOffAmount += Number($(this).find('.txtHospIWriteOff').val());
            totalHospBankCut += Number($(this).find('.txtHospIBankCut').val());

        });

        _divAllocationSummary.find('.tdAllocatedAmount').text(precise_round((totalAllocationAmount + totalHospAllocationAmount), 2));
        _divAllocationSummary.find('.tdAllocatedWriteOff').text(precise_round((totalWriteOffAmount + totalHospWriteOffAmount), 2));

        //New Add For Write Off
        _divAllocationSummary.find('.tdWriteOffToAllocate').text(precise_round((totalWriteOffAmount + totalHospWriteOffAmount), 2));

        var amountToAllocate = Number(_divAllocationSummary.find('.tdAmountToAllocate').text());
        var writeOffToAllocate = Number(_divAllocationSummary.find('.tdWriteOffToAllocate').text());
        _divAllocationSummary.find('.tdPendingAmount').text(precise_round(((amountToAllocate + writeOffToAllocate) - (totalAllocationAmount + totalHospAllocationAmount + totalWriteOffAmount + totalHospWriteOffAmount)), 2));

      //  _divAllocationSummary.find('.tdPendingAmount').text(precise_round(((amountToAllocate) - (totalAllocationAmount + totalHospAllocationAmount)), 4));

        var summaryRow = _tableDepartmentWiseDetails.find('tbody tr:last');

        summaryRow.find('.txtICollection').val(precise_round(totalAllocationAmount,4));
        summaryRow.find('.txtIWriteOff').val(precise_round(totalWriteOffAmount,4));
        summaryRow.find('.txtIBankCut').val(precise_round(totalBankCut,4));
        summaryRow.find('.txtHospICollection').val(precise_round(totalHospAllocationAmount,4));
        summaryRow.find('.txtHospIWriteOff').val(precise_round(totalHospWriteOffAmount,4));
        summaryRow.find('.txtHospIBankCut').val(precise_round(totalHospBankCut, 4));

        callback();
    }


</script>

<div class="row">

    <%--<span id="spnMaxAllocationAmt hidden">0</span>--%>
    <div class="col-md-24 clearDiv" id="divDepartmentWiseDetails"  style="overflow:auto" ></div>
</div>
<div class="row" id="divAllocationSummary">
    <div class="col-md-24 clearDiv">

         <table  cellspacing="0" rules="all" border="1" id="table1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="tr1">
            <th class="GridViewHeaderStyle" scope="col"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px"> Amount to Allocate</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:160px">WriteOff to Allocate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px">Allocated Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px">Allocated WriteOff</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px">Pending</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px"></th>
        </tr>

         </thead>
        <tbody>
            <tr>
                <td class="GridViewLabItemStyle"></td>
                <td class="GridViewLabItemStyle textCenter bold patientInfo tdAmountToAllocate clearDiv">0</td>
                <td class="GridViewLabItemStyle textCenter bold patientInfo tdWriteOffToAllocate clearDiv">0</td>
                <td class="GridViewLabItemStyle textCenter bold patientInfo tdAllocatedAmount clearDiv">0</td>
                <td class="GridViewLabItemStyle textCenter bold patientInfo tdAllocatedWriteOff clearDiv">0</td>
                <td class="GridViewLabItemStyle textCenter bold patientInfo tdPendingAmount clearDiv">0</td>
                <td class="GridViewLabItemStyle textCenter bold patientInfo clearDiv"></td>
            </tr>
            </tbody>
         </table>


    </div>
</div>



    <script id="templateDepartmentWiseDetails" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tableDepartmentWiseDetails"  style="width:2035px;border-collapse:collapse;">
        <thead>
        <tr id="trDHeader">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 180px;" >Service Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 280px;" >Display Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="">Total_Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Doctor_Share</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Hospital_Share</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Doctor_PreAllocated</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Hospital_PreAllocated</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Doctor_Pending</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Hospital_Pending</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px" >Collection</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >Write_Off</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >WriteOff_Reason</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >Bank_Cut</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >Hosp_Collection</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >Hosp_WriteOff</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >WriteOff_Reason</th>
            <th class="GridViewHeaderStyle hidden" scope="col" style="width:90px;" >Hosp_BankCut</th>
            <th class="GridViewHeaderStyle hidden" scope="col">IsItemShow</th>
            
        </tr>
         </thead>
        <tbody>
        <#       
        var dataLength=templateData.length;
        var objRow;
            var a=0;
            var b=0;
            var c=0;
            var _TotalDoctorAllocated=0;
            var _TotalHospitalAllocated=0;
            var _PendingDoctorAmount=0;   
            var _PendingHospitalAmount=0;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = templateData[j];
            a+=Number(objRow.Amount);
            b+=Number(objRow.ShareAmount);
            c+=Number(objRow.HospShareAmount);
            _TotalDoctorAllocated+=Number(objRow.TotalDoctorAllocated);
            _TotalHospitalAllocated+=Number(objRow.TotalHospitalAllocated);
            _PendingDoctorAmount+=Number(objRow.PendingDoctorAmount);
            _PendingHospitalAmount+=Number(objRow.PendingHospitalAmount);
        #>
                    <tr class="trDItems" style="cursor:pointer" >
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemWiseDetails(this);"><#=j+1#></td> 
                    <td class="GridViewLabItemStyle hidden tdData"> <#=JSON.stringify(objRow) #></td> 
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemWiseDetails(this);"><#=objRow.ServiceType#></td>
                    <td class="GridViewLabItemStyle" ondblclick="getItemWiseDetails(this);"><#=objRow.DisplayName#></td>
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemWiseDetails(this);"><#=objRow.Amount#></td> 
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemWiseDetails(this);"><#=objRow.ShareAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemWiseDetails(this);"><#=objRow.HospShareAmount#></td> 

                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemWiseDetails(this);"><#=objRow.TotalDoctorAllocated #> </td> 
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemWiseDetails(this);"><#=objRow.TotalHospitalAllocated #></td> 
                    <td class="GridViewLabItemStyle textCenter tdDoctorPending" ondblclick="getItemWiseDetails(this);"><#=objRow.PendingDoctorAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter tdHospitalPending" ondblclick="getItemWiseDetails(this);"><#=objRow.PendingHospitalAmount#></td> 
                        
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtICollection ItDoseTextinputNum" 
                        <#if(objRow.isHideCollection=="1"){#> disabled="disabled"  <#}#>  
                        
                        onkeyup="calculateProportionally(event,0)"  onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)"   onkeydown="$commonJsPreventDotRemove(event)"  max-value='<#=objRow.MaxAllocatedAmount#>' value='<#=objRow.PreAllocatedAmt#>' /></td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtIWriteOff ItDoseTextinputNum"   onkeyup="calculateProportionally(event,0)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" max-value='<#=objRow.MaxAllocatedAmount#>' value='<#=objRow.WriteOffAmt#>' /></td>
                    <td class="GridViewLabItemStyle textCenter"> <select class="ddlIWriteOffReason">
                        <option value="0"></option>
                         <#       
        var option;   
        for(var n=0;n<writeOffReasonMasterArray.length;n++)
        {       
        option = writeOffReasonMasterArray[n];
            
        #>
             <option value='<#=option.ID#>'
                 
                 <#if(objRow.WriteOff_Reason==option.ID){#>
                       selected
                 <#}#>

                 ><#=option.DiscountReason#></option>
            <#}#>

                                                                 </select> </td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtIBankCut ItDoseTextinputNum" <#if(objRow.isHideCollection=="1"){#> disabled="disabled"  <#}#>  onkeyup="calculateProportionally(event,1)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" max-value="100" value='<#=objRow.BankCutPercent#>'   <#=disableDoctorAllocationBankCut?'':'disabled' #>      /></td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtHospICollection ItDoseTextinputNum"   <#if(objRow.isHideCollection=="1"){#> disabled="disabled"  <#}#>  onkeyup="calculateProportionally(event,0)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" max-value='<#=objRow.MaxHAllocatedAmount#>' value='<#=objRow.HPreAllocatedAmt#>' /></td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtHospIWriteOff ItDoseTextinputNum"   onkeyup="calculateProportionally(event,0)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" max-value='<#=objRow.MaxHAllocatedAmount#>' value='<#=objRow.Hosp_WriteOffAmt#>' /></td>
                    <td class="GridViewLabItemStyle textCenter"> <select class="ddlHospIWriteOffReason">
                             <option value="0"></option>
                         <#       
        var option;   
        for(var n=0;n<writeOffReasonMasterArray.length;n++)
        {       
        option = writeOffReasonMasterArray[n];
            
        #>
             <option value='<#=option.ID#>'
                 
                 <#if(objRow.Hosp_WriteOff_Reason==option.ID){#>
                       selected
                 <#}#>
                 
                 ><#=option.DiscountReason#></option>
            <#}#>


                                                                 </select> </td>
                    <td class="GridViewLabItemStyle textCenter hidden"><input type="text" class="txtHospIBankCut ItDoseTextinputNum"  <#if(objRow.isHideCollection=="1"){#> disabled="disabled"  <#}#>  onkeyup="calculateProportionally(event,1)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  max-value="100" value='<#=objRow.Hosp_BankCutPercent#>' <#=disableDoctorAllocationBankCut?'':'disabled' #> /></td>
                    <td class="GridViewLabItemStyle hidden" id="tdIsItemShow">0</td>
               </tr>     
              <tr id="trItemDetail" >
                     <td colspan="20" id="tdItemDetail"  class="GridViewLabItemStyle hidden">
              </td>
        </tr> 
        <#}#>   

             <tr  style="cursor:pointer" >
                    <td class="GridViewLabItemStyle textCenter bold" colspan="3" >Total:- </td> 
                   
                    <td class="GridViewLabItemStyle textCenter"><#=a#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=b#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=c#></td> 

                    <td class="GridViewLabItemStyle textCenter"><#=precise_round(_TotalDoctorAllocated,4)#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=precise_round(_TotalHospitalAllocated,4)#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=precise_round(_PendingDoctorAmount,4)#></td> 
                    <td class="GridViewLabItemStyle textCenter"><#=precise_round(_PendingHospitalAmount,4)#></td> 
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtICollection ItDoseTextinputNum" disabled="disabled"  /></td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtIWriteOff ItDoseTextinputNum" disabled="disabled" /></td>
                    <td class="GridViewLabItemStyle textCenter"> <select disabled="disabled"></select> </td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtIBankCut ItDoseTextinputNum" disabled="disabled"/></td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtHospICollection ItDoseTextinputNum" disabled="disabled"/></td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtHospIWriteOff ItDoseTextinputNum" disabled="disabled"/></td>
                    <td class="GridViewLabItemStyle textCenter"> <select disabled="disabled"></select> </td>
                    <td class="GridViewLabItemStyle textCenter hidden"><input type="text" class="txtHospIBankCut ItDoseTextinputNum" disabled="disabled"/></td>
                    <td class="GridViewLabItemStyle hidden" id="td1">0</td>
               </tr>     



       </tbody>   
     </table>    
</script>

    <script id="templateItemWiseDetails" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tableItemWiseDetails"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="trIHeader">
            <th class="GridViewHeaderStyle" scope="col">#</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:467px;" >Service Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Total_Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Doctor_Share</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Hospital_Share</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Doctor_PreAllocated</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Hospital_PreAllocated</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Doctor_Pending</th>
            <th class="GridViewHeaderStyle" scope="col" style="" >Hospital_Pending</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px">Collection</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >Write_Off</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >WriteOff_Reason</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px">Bank_Cut</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px">Hosp_Collection</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px">Hosp_WriteOff</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px" >WriteOff_Reason</th>
            <th class="GridViewHeaderStyle hidden" scope="col" style="width:90px;">Hosp_BankCut</th>
        </tr>

         </thead>
        <tbody>
        <#       
        var dataLength=templateData.length;
        var objRow;   
        var totalCollection=0;
        var totalWriteOff=0;
            var totalHCollection=0;
            var totalHWriteOff=0;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = templateData[j];
            totalCollection+=Number(objRow.PreAllocatedAmt);
            totalWriteOff+=Number(objRow.WriteOffAmt);
            totalHCollection+=Number(objRow.HPreAllocatedAmt);
            totalHWriteOff+=Number(objRow.Hosp_WriteOffAmt);
        #>

                    <tr  id="trIItem">
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemDetails(this)"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle hidden tdData"> <#= JSON.stringify(objRow) #></td> 
                    <td class="GridViewLabItemStyle" ondblclick="getItemDetails(this)"><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemDetails(this)"><#=objRow.Amount#></td> 
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemDetails(this)"><#=objRow.ShareAmount#></td> 

                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemDetails(this);"><#=objRow.Amount-objRow.ShareAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemDetails(this)"><#=objRow.TotalDoctorAllocated#></td> 
                    <td class="GridViewLabItemStyle textCenter" ondblclick="getItemDetails(this)"><#=objRow.TotalHospitalAllocated#></td> 
                    <td class="GridViewLabItemStyle textCenter tdDoctorPending" ondblclick="getItemDetails(this);"><#=objRow.PendingDoctorAmount#></td> 
                    <td class="GridViewLabItemStyle textCenter tdHospitalPending" ondblclick="getItemDetails(this);"><#=objRow.PendingHospitalAmount#></td> 
                        
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtICollection ItDoseTextinputNum"  <#if(objRow.isHideDCollection=="1"){#> disabled="disabled"  <#}#>  onkeyup="calculateTotal(event)"  onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"   max-value='<#=objRow.MaxAllocatedAmount#>' value='<#=objRow.PreAllocatedAmt#>' /> </td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtIWriteOff ItDoseTextinputNum"    onkeyup="calculateTotal(event)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"     max-value='<#=objRow.MaxAllocatedAmount#>' value='<#=objRow.WriteOffAmt#>' /></td>
                    <td class="GridViewLabItemStyle textCenter"> <select class="ddlIWriteOffReason">
                    <option value="0"></option>
                                       <#       
        var option;   
        for(var n=0;n<writeOffReasonMasterArray.length;n++)
        {       
        option = writeOffReasonMasterArray[n];
            
        #>
             <option value='<#=option.ID#>'
                 
                  <#if(objRow.WriteOff_Reason==option.ID){#>
                       selected
                 <#}#>
                 
                 ><#=option.DiscountReason#></option>
            <#}#>
                                 </select> </td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtIBankCut ItDoseTextinputNum"   <#if(objRow.isHideDCollection=="1"){#> disabled="disabled"  <#}#>   onkeyup="calculateTotal(event)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"      max-value='100' value='<#=objRow.BankCutPercent#>' <#=disableDoctorAllocationBankCut?'':'disabled' #> /></td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtHospICollection ItDoseTextinputNum"   <#if(objRow.isHideHCollection=="1"){#> disabled="disabled"  <#}#>   onkeyup="calculateTotal(event)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"    max-value='<#=objRow.MaxHAllocatedAmount#>' value='<#=objRow.HPreAllocatedAmt#>' /></td>
                    <td class="GridViewLabItemStyle textCenter"><input type="text" class="txtHospIWriteOff ItDoseTextinputNum"    onkeyup="calculateTotal(event)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"       max-value='<#=objRow.MaxHAllocatedAmount#>' value='<#=objRow.Hosp_WriteOffAmt#>' /></td>
                    <td class="GridViewLabItemStyle textCenter"> <select class="ddlHospIWriteOffReason">
                        <option value="0"></option>

                                         <#       
        var option;   
        for(var n=0;n<writeOffReasonMasterArray.length;n++)
        {       
        option = writeOffReasonMasterArray[n];
            
        #>
             <option value='<#=option.ID#>'
                 
                 
                   <#if(objRow.Hosp_WriteOff_Reason==option.ID){#>
                       selected
                 <#}#>
                 
                 
                 
                 ><#=option.DiscountReason#></option>
            <#}#>


                                                                 </select> </td>
                    <td class="GridViewLabItemStyle textCenter hidden"><input type="text" class="txtHospIBankCut ItDoseTextinputNum"    onkeyup="calculateTotal(event)" onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"     max-value='100' value='<#=objRow.Hosp_BankCutPercent#>'  <#=disableDoctorAllocationBankCut?'':'disabled' #>  /></td>
               </tr> 
        <#}#>   

            <tr> 
                <td class="GridViewLabItemStyle textRight" colspan="9"><b>Total :-</b></td>
                <td class="GridViewLabItemStyle textCenter"><input type="text" class="ItDoseTextinputNum" id="txtICollection"  disabled="disabled"  onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" value='<#= precise_round(totalCollection,4)#>'  max-value='<#=precise_round(totalCollection,4)#>'/> </td>
                <td class="GridViewLabItemStyle textCenter"><input type="text" class="ItDoseTextinputNum" id="txtIWriteOff" disabled="disabled"    onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" value='<#=precise_round(totalWriteOff,4)#>'    max-value='<#=precise_round(totalWriteOff,4)#>'/></td>
                <td class="GridViewLabItemStyle textCenter"><select disabled="disabled"></select> </td>
                <td class="GridViewLabItemStyle textCenter"><input type="text" class="ItDoseTextinputNum" id="txtIBankCut" disabled="disabled"    onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" /></td>
                <td class="GridViewLabItemStyle textCenter"><input type="text" class="ItDoseTextinputNum" id="txtHospICollection" disabled="disabled"    onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" value='<#=precise_round(totalHCollection,4)#>'    max-value='<#=precise_round(totalHCollection,4)#>'/></td>
                <td class="GridViewLabItemStyle textCenter"><input type="text" class="ItDoseTextinputNum" id="txtHospIWriteOff" disabled="disabled"    onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" value='<#=precise_round(totalHWriteOff,4)#>'    max-value='<#=precise_round(totalHWriteOff,4)#>'/></td>
                <td class="GridViewLabItemStyle textCenter"> <select disabled="disabled"></select> </td>
                <td class="GridViewLabItemStyle textCenter hidden"><input type="text" class="ItDoseTextinputNum" id="txtHospIBankCut" disabled="disabled"    onlynumber="14" decimalplace="4" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"     max-value='100000'/></td>
            </tr>
       </tbody>   
     </table>   
 
</script>

