<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PanelAdvanceAmountPayment.aspx.cs" Inherits="Design_PanelLedger_PanelAdvanceAmountPayment"
    Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            bindPanel();
            $paymentControlInit(function () { });
        });

        function panelChange() {
            $("#txtAdvAmt").val('');
            getPanelAdvanceAmt();
            GetPaymentDetail('5');
            $clearPaymentControl(function () { });
        }

        function getPanelAdvanceAmt() {
            var data = {
                PanelID: $("#<%=ddlPanelCompany.ClientID%>").val()
             }
            serverCall('Services/PanelAdvance.asmx/GetPanelAdvanceAmt', data, function (response) {
                var $responseData = JSON.parse(response);
                    if ($responseData.status)
                        $("#spnAvailableBalance").text('Panel Available Advance Amt. : ' + $responseData.response);
                    else
                        $("#spnAvailableBalance").text('');
            });
        }
        var save = function (btnSave) {
            getPanelAdvancePaymentDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/PanelAdvance.asmx/SaveAdvance', data, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            window.location.reload();
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }
        var getPanelAdvancePayment = function (callback) {
            var data = {
                RecievedDate: $('#txtReceiveDate').val().trim(),
                PanelID: $("#<%=ddlPanelCompany.ClientID%>").val()
            }
            callback(data);
        }
        var getPanelAdvancePaymentDetails = function (callback) {
            getPanelAdvancePayment(function (PaneladvanceDetails) {
                $getPaymentDetails(function (payment) {
                    PaneladvanceDetails.totalPaidAmount = payment.adjustment;
                    PaneladvanceDetails.paymentRemarks = payment.paymentRemarks;
                    PaneladvanceDetails.paymentDetail = [];
                    $(payment.paymentDetails).each(function () {
                        PaneladvanceDetails.paymentDetail.push({
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
                            PaymentRemarks: this.paymentRemarks,
                            swipeMachine: this.swipeMachine,
                            currencyRoundOff: payment.currencyRoundOff / payment.paymentDetails.length
                        });
                    });
                    if (PaneladvanceDetails.paymentDetail.length < 1) {
                        modelAlert('Please Select Atleast One Payment Mode');
                        return false;
                    }
                    callback(PaneladvanceDetails);
                });
            });
        }

        function bindPanel() {
            $.ajax({
                url: "../Common/CommonService.asmx/bindPanel",
                data: '{}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var dtdata = jQuery.parseJSON(mydata.d);
                    if (dtdata.length > 0) {
                        jQuery("#<%=ddlPanelCompany.ClientID%> option").remove();
                        for (i = 0; i < dtdata.length; i++) {
                            if (dtdata[i].PanelID != "1")
                                jQuery("#<%=ddlPanelCompany.ClientID%>").append($("<option></option>").val(dtdata[i].PanelID).html(dtdata[i].Company_Name));
                        }
                        getPanelAdvanceAmt();
                        GetPaymentDetail('5');
                    }

                }
            });
        }

        var onAmountChange = function (value) {
            var amount = String.isNullOrEmpty(value) ? 0 : value;
            var panelID = jQuery("#<%=ddlPanelCompany.ClientID%>").val();
            $addBillAmount({
                panelId: 1,
                billAmount: amount,
                disCountAmount: 0,
                isReceipt: true,
                disableDiscount: true,
                patientAdvanceAmount: 0,
                disableCredit: true,
                refund: { status: false }
            }, function () { });
        }
        function UpdateLedgerReceipt(rowid, UpdateType) {
            var data = {
                LedgerReceiptNo: $(rowid).closest('tr').find('#tdLedgerReceiptNo').text(),
                TypeForUpdate: UpdateType
         }
            serverCall('Services/PanelAdvance.asmx/UpdateLedgerReceipt', data, function (response) {
                var $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    getPanelAdvanceAmt();
                    GetPaymentDetail('5');
                });
         });
        }
       
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Advance Payment for Credit Panel</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Panel Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPanelCompany" runat="server" onchange="panelChange()" TabIndex="1" ToolTip="Select Panel"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Advance Amount
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtAdvAmt" runat="server" ClientIDMode="Static" Width="150px" AutoComplete="off" onlynumber="10" onkeyup="onAmountChange(this.value)" CssClass="requiredField" />

                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Receive Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtReceiveDate" runat="server" ClientIDMode="Static" ReadOnly="true" Width="150px" CssClass="requiredField"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExteDOB" TargetControlID="txtReceiveDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                </div>
            </div>
        </div>
        <div id="paymentControlDiv">
            <UC2:PaymentControl ID="paymentControl" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSave" onclick="save(this)" tabindex="10" value="Save" tooltip="Click To Save" />
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-16">
                   <input type="button" id="btnGetPaymentDetail" onclick="GetPaymentDetail('1')" tabindex="10" value="All" tooltip="Click To Check All Payment Details" />&nbsp; &nbsp;
                    <input type="button" id="btnPendingforAdjustment" onclick="GetPaymentDetail('5')" tabindex="11" value="Pending for Billing" tooltip="Click To Pending for Billing" />&nbsp; &nbsp;
                     <input type="button" id="btnGetPendingChequeForClearance" onclick="GetPaymentDetail('2')" tabindex="12" value="Check Pending Cheque For Clearance" tooltip="Click To Check Pending Cheques For Clearance" />&nbsp; &nbsp;
                    <input type="button" id="btnBouncedchequeDetail" onclick="GetPaymentDetail('3')" tabindex="13" value="Check Bounced cheque Detail" tooltip="Click To Check Bounced cheque Detail" />&nbsp; &nbsp;
                   <input type="button" id="btnCancelPanelAdvance" onclick="GetPaymentDetail('4')" tabindex="14" value="Check Cancel Panel Advance Receipt" tooltip="Click To Check Cancel Panel Advance Receipt" />
              </div>
              <div class="col-md-8">
                  <span id="spnAvailableBalance" class="ItDoseLblError" ></span>
                </div>
            </div>
        </div>
         <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                 <div id="PanelDetails" style="max-height: 250px; overflow:auto;"></div>
                </div>
            </div>
        </div>

    </div>
       <script type="text/javascript">
           var _PageSize = 5;
           var _PageNo = 0;
           var _PageCount = 0;
           function GetPaymentDetail(Type) {
               $('#PanelDetails').html();
               $('#PanelDetails').hide();
            $.ajax({
                url: "Services/PanelAdvance.asmx/GetPaymentDetail",
                data: '{PanelID:"' + $("#<%=ddlPanelCompany.ClientID%>").val() + '",SearchType:"'+ Type +'"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    PanelAdvanceData = jQuery.parseJSON(result.d);
                    if (PanelAdvanceData != null) {
                        _PageCount = PanelAdvanceData.length / _PageSize;
                        showPage('0');
                    }
                    else {
                        $('#PanelDetails').html();
                        $('#PanelDetails').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#PanelDetails').html();
                    $('#PanelDetails').hide();
                }
            });
           }
           function showPage(_strPage) {
               _StartIndex = (_strPage * _PageSize);
               _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
               var output = $('#tb_PanelDetails').parseTemplate(PanelAdvanceData);
               $('#PanelDetails').html(output);
               $('#PanelDetails').show();
               $('#FixedTables tr').bind('mouseenter mouseleave', function () {
                   $(this).toggleClass('hover');

               });
               $('#tablePanelLedgerCount td').bind('mouseenter mouseleave', function () {
                   $(this).toggleClass('Counthover');
               });
           }
    </script>
      <script id="tb_PanelDetails" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch" style="border-collapse:collapse;">
            <tr id="Header">
			    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:250px;">Panel Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;text-align:left;">Ledger Receipt No.</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Received Amt.</th> 
                 <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Available Amt</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Recieved Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Entry Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Payment Mode</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Bank Details</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">User Name </th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Cheque Clearance</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Cheque Bounced</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Receipt Cancel</th>
            </tr>
            <#
              var dataLength=PanelAdvanceData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;
              if(_EndIndex>dataLength)
               {           
                  _EndIndex=dataLength;
               }

              for(var j=_StartIndex;j<_EndIndex;j++)
              {
                 objRow = PanelAdvanceData[j];
            #>
            <tr id="<#=j+1#>"
                 <# if(PanelAdvanceData[j].IsChequeBounce =="Yes")
                    {#>                      
                        style="background-color:#d1404f" <#} 
                  else if(PanelAdvanceData[j].IsClear =="No")
                     {#>                      
                   style="background-color:#aa42f4" <#}
                     #> >
                <td class="GridViewLabItemStyle"><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdCompany_Name"  style="width:250px;text-align:left" ><#=objRow.Company_Name#></td>  
                <td class="GridViewLabItemStyle" id="tdLedgerReceiptNo"  style="width:150px;text-align:left" ><#=objRow.LedgerReceiptNo#></td> 
                <td class="GridViewLabItemStyle" id="tdLedgerReceivedAmt"  style="width:60px;text-align:right" ><#=objRow.LedgerReceivedAmt#></td>
                <td class="GridViewLabItemStyle" id="tdAdvanceAmt"  style="width:60px;text-align:right" ><#=objRow.AdvanceAmt#></td>
                <td class="GridViewLabItemStyle" id="tdAdvanceAmtRecievedDate" style="width:70px;text-align:left"><#=objRow.AdvanceAmtRecievedDate#></td>  
                 <td class="GridViewLabItemStyle" id="tdEntryDate" style="width:80px;text-align:left"><#=objRow.EntryDate#></td>              
                <td class="GridViewLabItemStyle" id="tdPaymentMode"   style="width:100px;text-align:left" ><#=objRow.PaymentMode#></td>
                <td class="GridViewLabItemStyle" id="tdBankDetails" style="width:100px;text-align:left"><#=objRow.BankDetails#></td>
                <td class="GridViewLabItemStyle" id="tdEntryUserName" style="width:150px;text-align:left"><#=objRow.EntryUserName#></td>
                <td class="GridViewLabItemStyle" style="width:60px;text-align:center">
                 <# if(PanelAdvanceData[j].IsClear =="No" && PanelAdvanceData[j].IsChequeBounce =="No" )
                    {#> 
                      <input type="button" id="btnClearCheque" onclick="UpdateLedgerReceipt(this, 'Clear')" value="Clear" class="ItDoseButton" />
                    <#} 
                    #>
                </td>
                <td class="GridViewLabItemStyle" style="width:60px;text-align:center">
                    <# if(PanelAdvanceData[j].IsClear =="No" && PanelAdvanceData[j].IsChequeBounce =="No" )
                    {#>         
                      <input type="button" id="btnBounceCheque" onclick="UpdateLedgerReceipt(this, 'ChequeBounce')" value="Bounce" class="ItDoseButton" />             
                        <#} 
                    #>
                    </td>
                <td class="GridViewLabItemStyle" style="width:60px;text-align:center">
                 <# if(PanelAdvanceData[j].IsCancel =="0" && PanelAdvanceData[j].AdjustmentAmount=="0")
                    {#>  
                      <input type="button" id="Button1" onclick="UpdateLedgerReceipt(this, 'CancelReceipt')" value="Cancel" class="ItDoseButton" />                     
                        <#} 
                    #>
                </td>
            </tr>
            <#}#>
        </table>
        <table id="tablePanelLedgerCount" style="border-collapse:collapse;">
               <tr>
                   <# if(_PageCount>0) {
                     for(var k=0;k<_PageCount;k++){ #>
                     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=k#>');" ><#=k+1#></a></td>
                     <#}         
                   }
                #>
             </tr>
     
       </table>  
    </script>
</asp:Content>
