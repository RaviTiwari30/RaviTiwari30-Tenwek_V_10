<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ReceiptEdit.aspx.cs" Inherits="Design_Finance_ReceiptEdit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style type="text/css">

        .selectedRow {
            background-color:aqua;
        }


    </style>




    <script type="text/javascript">


        var onReceiptSearch = function () {

            var data = {
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                receiptNo: $('#txtReceipt').val()
            };
            serverCall('ReceiptEdit.asmx/SearchReceipts', data, function (response) {
                responseData = JSON.parse(response);
                var parseHTML = $('#template_Receipts').parseTemplate(responseData);
                $('#tblReceipts').html(parseHTML);
                $('.divEditReceiptDetails').addClass('hidden');
            });
        }




        var getReceiptDetails = function (el) {

            if ($('#lblCanChangePaymentDetails').text() == '0') {
                modelAlert('You Are Not Authorised To Edit Receipt...');
                return false;
            }
            var row = $(el).closest('tr');

          

            $(row).closest('tbody').find('tr').removeClass('selectedRow');
            $(row).addClass('selectedRow');
            var tdData = JSON.parse(row.find('.tdData').text());

            $('.divEditReceiptDetails').removeClass('hidden');

            var data = {
                receipt: tdData.ReceiptNo
            }



            serverCall('ReceiptEdit.asmx/GetPaymentDetails', data, function (response) {
                responseData = JSON.parse(response);
                
                if (responseData.status) {
                    modelAlert(responseData.message);
                    $('#divPaymentControlParent').hide();
                }
                else {
                    $('#divPaymentControlParent').show();
                    bindReceiptDetails(1, tdData.AmountPaid, responseData);
                }
            });
        }





        var bindReceiptDetails = function (panelID,billAmount,data) {


            $paymentControlInit(function () {


                var paymentDetails = data;

                $addBillAmount({
                    panelId: panelID,
                    billAmount: billAmount,
                    disCountAmount: 0,
                    isReceipt: true,
                    patientAdvanceAmount: 0,
                    minimumPayableAmount: billAmount,
                    disableDiscount: true,
                    panelAdvanceAmount: 0,
                    refund: { status: false }
                }, function () {

                    for (var i = 0; i < paymentDetails.length; i++) {
                        debugger;
                        var data = {
                            billAmount: billAmount,
                            $paymentDetails: {
                                Amount: paymentDetails[i].S_Amount,
                                BaceCurrency: 'MUR',
                                BankName: paymentDetails[i].BankName,
                                C_Factor: paymentDetails[i].C_factor,
                                PaymentMode: paymentDetails[i].PaymentMode,
                                PaymentModeID: paymentDetails[i].PaymentModeID,
                                PaymentRemarks: '',
                                RefNo: paymentDetails[i].RefNo,
                                S_Amount: paymentDetails[i].S_Amount,
                                baseCurrencyAmount: paymentDetails[i].Amount,
                                S_CountryID: paymentDetails[i].S_CountryID,
                                S_Currency: paymentDetails[i].S_Currency,
                                S_Notation: paymentDetails[i].S_Notation
                            }, patientAdvanceAmount: 0, panelAdvanceAmount: 0
                        };

                        $bindPaymentModeDetails(data, function (d) {
                            $bindBankMaster(d.bankControl, function () {
                                $calculateTotalPaymentAmount(function () {
                                });
                            }, data.$paymentDetails.BankName);
                        });
                    }

                   // $onChangeCurrency(this, function () { });
                });

            });
        }




        var getEditDetails = function (callback) {

            $getPaymentDetails(function (paymentDetails) {


                var tdData = JSON.parse($('.selectedRow').find('.tdData').text());

                if (tdData.AmountPaid != paymentDetails.adjustment) {
                    modelAlert('Payment Amount Not Match.');
                    return false;
                }




                $PaymentDetail = [];
                $(paymentDetails.paymentDetails).each(function () {
                    $PaymentDetail.push({
                        PaymentMode: this.PaymentMode,
                        PaymentModeID: this.PaymentModeID,
                        S_Amount: this.S_Amount,
                        S_Currency: this.S_Currency,
                        S_CountryID: this.S_CountryID,
                        BankName: this.BankName,
                        RefNo: this.RefNo,
                        BaceCurrency: this.BaceCurrency,
                        C_Factor: this.C_Factor,
                        Amount: this.Amount,
                        S_Notation: this.S_Notation,
                        PaymentRemarks: paymentDetails.paymentRemarks,
                        swipeMachine: this.swipeMachine,
                        currencyRoundOff: paymentDetails.currencyRoundOff / paymentDetails.paymentDetails.length
                    });
                });

                callback($PaymentDetail);
            });
        }



        var onUpdateReceiptDetails = function () {

            var row=$('.selectedRow');
            var tdData = JSON.parse(row.find('.tdData').text());
            var receiptNo=tdData.ReceiptNo;
            getEditDetails(function (data) {
                serverCall('ReceiptEdit.asmx/UpdateReceiptDetails', { paymentDetail: data, receiptNo: receiptNo }, function (response) {

                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            window.location.reload();
                        }
                    });
                });
            });
        }


    </script>









    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
             <asp:Label id="lblCanChangePaymentDetails" ClientIDMode="Static" runat="server" style="display:none"></asp:Label>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Receipt No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtReceipt" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter">
            <input type="button" value="Search" class="save margin-top-on-btn" onclick="onReceiptSearch(this)" />
        </div>


        <div class="POuter_Box_Inventory textCenter ">
            <div class="row">
                <div class="col-md-24" id="tblReceipts" style="max-height: 250px;overflow: auto;"  >
                </div>
            </div>
        </div>


          <div class="divEditReceiptDetails hidden">
               <UC2:PaymentControl ID="paymentControl" runat="server" />
          </div>

         <div class="POuter_Box_Inventory textCenter divEditReceiptDetails hidden">

             <input type="button" value="Save"  onclick="onUpdateReceiptDetails(this)" class="save margin-top-on-btn" />

         </div>


    </div>








    <script id="template_Receipts" type="text/html">
        <table  id="tableReceipts" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >Sr No.</th>
            <th class="GridViewHeaderStyle" scope="col" >ReceiptNo</th>
            <th class="GridViewHeaderStyle" scope="col" >AmountPaid</th>
            <th class="GridViewHeaderStyle" scope="col" >Create By</th>
            <th class="GridViewHeaderStyle" scope="col">BillNo </th>                         
            <th class="GridViewHeaderStyle" scope="col">PaymentModes</th>  
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
                

                    <tr onmouseover="this.style.color='#00F'"       onMouseOut="this.style.color=''" id="<#=j+1#>" ondblclick="onMobileAppointmentSelect(this);" style='cursor:pointer;'>                            
       
                        <td  class="GridViewLabItemStyle" id="td6">  <#=j+1#>  </td>                                   
                        <td  class="GridViewLabItemStyle" id="td1"><#=objRow.ReceiptNo#></td>
                        <td class="GridViewLabItemStyle" id="td2" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.AmountPaid#></td>
                        <td class="GridViewLabItemStyle" id="td3" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.EmployeeName#></td>
                        <td class="GridViewLabItemStyle" id="td4" style=""><#=objRow.BillNo#></td> 
                        <td class="GridViewLabItemStyle" id="td5" style=""><#=objRow.PaymentModes#></td>   
                        
                         <td class="GridViewLabItemStyle tdData"  style="display:none"><#=JSON.stringify(objRow)#></td>  
                        <td class="GridViewLabItemStyle">  <img src="../../Images/Post.gif" alt="" id="imgSelect" class="paymentSelect"   onclick="getReceiptDetails(this,function(){})" title="Click To Select"/></td>                       
                        </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>



</asp:Content>

