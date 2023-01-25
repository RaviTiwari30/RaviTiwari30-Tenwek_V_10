
<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" 
MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" 
CodeFile="~/Design/Recovery/DashBoardNew.aspx.cs" Inherits="Design_Recovery_DashBoardNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
         
    <script type="text/javascript">
     $(document).ready(function () {  
        $('#txtFromDate').change(function () {
            ChkDate();
        });
        $('#txtToDate').change(function () {
            ChkDate();
        });                                          
     });
           
      function ChkDate() {
            $.ajax({
                url: "../Recovery/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",DateTo:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value  + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#spnErrorMsg").text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                         $("#spnErrorMsg").text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
        
        $(function () {           
        $("#btnsearch").bind("click", function () {
                $("#spnErrorMsg").text('');
                getBillsPendingforDispatchInvoice();
                getInvoiceAckNotReceived();
                getInvoiceAckReceived();
                getTPAQuery();
            });
        });

    function getbtnreport1(rowID) {
                window.open('data:application/vnd.ms-excel,' + encodeURIComponent( $('div[id$=div_BillsPendingforDispatchInvoiceDetail]').html()));                
         }

    function getbtnreport2(rowID) {
                window.open('data:application/vnd.ms-excel,' + encodeURIComponent( $('div[id$=div_InvoiceAckNotReceiveBillDetail]').html()));               
         }
    function getbtnreport3(rowID) {
                window.open('data:application/vnd.ms-excel,' + encodeURIComponent( $('div[id$=div_PanelWiseProcessBillDetail]').html()));               
         }

//        ----------------------------START BillsPendingforInvoice---------------------------

        function getBillsPendingforDispatchInvoice()
        {
         $('#div_BillsPendingforDispatchInvoiceSummary').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getBillsPendingforDispatchInvoiceSummary",
                data: '{FromDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                BillsPendingforDispatchInvoiceSummary = $.parseJSON(result.d);
                    if (BillsPendingforDispatchInvoiceSummary != "0") {
                        var BillsPendingforDispatchInvoiceSummaryOutPut = $('#tb_BillsPendingforDispatchInvoiceSummary').parseTemplate(BillsPendingforDispatchInvoiceSummary);
                        $('#div_BillsPendingforDispatchInvoiceSummary').html(BillsPendingforDispatchInvoiceSummaryOutPut);
                        $('#div_BillsPendingforDispatchInvoiceSummary').show();                        
                    }               
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        
        function getBillsPendingforDispatchInvoiceDetail(PanelID)
        {
         $('#div_BillsPendingforDispatchInvoiceDetail').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/BillsPendingforDispatchInvoiceDetail",
                data: '{FromDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '",PanelID:"' + PanelID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                BillsPendingforDispatchInvoiceDetail = $.parseJSON(result.d);
                    if (BillsPendingforDispatchInvoiceDetail != "0") {
                        var BillsPendingforDispatchInvoiceDetailOutPut = $('#tb_BillsPendingforDispatchInvoiceDetail').parseTemplate(BillsPendingforDispatchInvoiceDetail);
                        $('#div_BillsPendingforDispatchInvoiceDetail').html(BillsPendingforDispatchInvoiceDetailOutPut);
                        $('#div_BillsPendingforDispatchInvoiceDetail').show();                        
                    }               
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }
       
         function ShowPopUpBillsPendingforDispatchInvoice(rowID) {
          var PanelID=$(rowID).closest('tr').find('#tdPanelID').text();
            $("#spnErrorMsg").text('');                                      
                getBillsPendingforDispatchInvoiceDetail(PanelID);
                $find('mpChangeBillsPendingforDispatchInvoice').show();           
         }
         function ClosePopUpBillsPendingforDispatchInvoice() {
            $find('mpChangeBillsPendingforDispatchInvoice').hide();
         } 
       
//        ----------------------------END BillsPendingforDispatchInvoice---------------------------
               
     
  
//        ----------------------------START InvoiceAckNotReceived---------------------------

        function getInvoiceAckNotReceived()
        {
         $('#div_InvoiceAckNotReceivedSummary').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getInvoiceAckNotReceivedSummary",
                data: '{FromDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                InvoiceAckNotReceivedSummary = $.parseJSON(result.d);
                    if (InvoiceAckNotReceivedSummary != "0") {
                        var InvoiceAckNotReceivedSummaryOutPut = $('#tb_InvoiceAckNotReceivedSummary').parseTemplate(InvoiceAckNotReceivedSummary);
                        $('#div_InvoiceAckNotReceivedSummary').html(InvoiceAckNotReceivedSummaryOutPut);
                        $('#div_InvoiceAckNotReceivedSummary').show();                        
                    }               
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        
        function getInvoiceAckNotReceiveDetail(PanelID)
        {
         $('#div_InvoiceAckNotReceiveDetail').hide();
         $('#div_InvoiceAckNotReceiveBillDetail').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getInvoiceAckNotReceivedDetail",
                data: '{FromDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '",PanelID:"' + PanelID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                InvoiceAckNotReceiveDetail = $.parseJSON(result.d);
                    if (InvoiceAckNotReceiveDetail != "0") {
                        var InvoiceAckNotReceiveDetailOutPut = $('#tb_InvoiceAckNotReceiveDetail').parseTemplate(InvoiceAckNotReceiveDetail);
                        $('#div_InvoiceAckNotReceiveDetail').html(InvoiceAckNotReceiveDetailOutPut);
                        $('#div_InvoiceAckNotReceiveDetail').show();                        
                    }               
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }
         
         function ShowPopUpInvoiceAckNotReceived(rowID) {
          var PanelID=$(rowID).closest('tr').find('#tdPanelID').text();
            $("#spnErrorMsg").text('');                                      
                getInvoiceAckNotReceiveDetail(PanelID);
                $find('mpChangeInvoiceAckNotReceived').show();           
         }
         function ClosePopUpInvoiceAckNotReceived() {
            $find('mpChangeInvoiceAckNotReceived').hide();
         } 
         
         function getInvoiceAckNotReceiveBillDetail(TPAInvNo)
         {
         $('#div_InvoiceAckNotReceiveBillDetail').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getInvoiceAckNotReceivedBillDetail",
                data: '{FromDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtFromDate').value + '",ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '",TPAInvNo:"' + TPAInvNo + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                InvoiceAckNotReceiveBillDetail = $.parseJSON(result.d);
                    if (InvoiceAckNotReceiveBillDetail != "0") {
//                      $("#spnErrorMsg").text(InvoiceAckNotReceiveDetail.length + ' Record Found');
                        var InvoiceAckNotReceiveBillDetailOutPut = $('#tb_InvoiceAckNotReceiveBillDetail').parseTemplate(InvoiceAckNotReceiveBillDetail);
                        $('#div_InvoiceAckNotReceiveBillDetail').html(InvoiceAckNotReceiveBillDetailOutPut);
                        $('#div_InvoiceAckNotReceiveBillDetail').show();                        
                    }               
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }
       
         function ShowPopUpInvoiceAckNotReceivedBill(rowID) {
          var TPAInvNo=$(rowID).closest('tr').find('#tdTPAInvNo').text();
            $("#spnErrorMsg").text('');                                      
                getInvoiceAckNotReceiveBillDetail(TPAInvNo);
                $find('mpChangeInvoiceAckNotReceivedBill').show();           
         }
         function ClosePopUpInvoiceAckNotReceivedBill() {
            $find('mpChangeInvoiceAckNotReceivedBill').hide();
         } 
       
//        ----------------------------END InvoiceAckNotReceived---------------------------
               
  
//        ----------------------------START InvoiceAckReceived---------------------------

        function getInvoiceAckReceived()
        {
         $('#div_InvoiceAckReceivedSummary').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getInvoiceAckReceivedSummary",
                data: '{ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                InvoiceAckReceivedSummary = $.parseJSON(result.d);
                    if (InvoiceAckReceivedSummary != "0") {
                        var InvoiceAckReceivedSummaryOutPut = $('#tb_InvoiceAckReceivedSummary').parseTemplate(InvoiceAckReceivedSummary);
                        $('#div_InvoiceAckReceivedSummary').html(InvoiceAckReceivedSummaryOutPut);
                        $('#div_InvoiceAckReceivedSummary').show();                        
                    }               
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }                            
         
        function ShowPopUpPanelWiseProcessList(rowID) {
            var PanelID=$(rowID).closest('tr').find('#tdPanelID').text();
            var Panel=$(rowID).closest('tr').find('#tdPanel').text();
            $("#spnErrorMsg").text('');  
            $("#spnAlert").text('');
            $("#spnPanel").text(Panel);                                    
                getPanelWiseProcessList(PanelID);
                $find('mpChangePanelWiseProcessList').show();           
         }
         function ClosePopUpPanelWiseProcessList() {
            $find('mpChangePanelWiseProcessList').hide();
         } 
         
         
         
        function getPanelWiseProcessList(PanelID)
        {
         $('#div_PanelWiseProcessList').hide();
         $('#div_PanelWiseProcessBillDetail').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getPanelWiseProcessList",
                data: '{PanelID:"' + PanelID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                PanelWiseProcessList = $.parseJSON(result.d);
                    if (PanelWiseProcessList != "0") {
                        var PanelWiseProcessListOutPut = $('#tb_PanelWiseProcessList').parseTemplate(PanelWiseProcessList);
                        $('#div_PanelWiseProcessList').html(PanelWiseProcessListOutPut);
                        $('#div_PanelWiseProcessList').show();                        
                    }               
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }
                
       function getPanelWiseProcessBillDetail(PanelID,ProcessID)
         {
         $('#div_PanelWiseProcessBillDetail').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getPanelWiseProcessBillDetail",
                data: '{PanelID:"' + PanelID + '",ProcessID:"' + ProcessID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                PanelWiseProcessBillDetail = $.parseJSON(result.d);
                    if (PanelWiseProcessBillDetail != "0") {                    
                        var PanelWiseProcessBillDetailOutPut = $('#tb_PanelWiseProcessBillDetail').parseTemplate(PanelWiseProcessBillDetail);
                        $('#div_PanelWiseProcessBillDetail').html(PanelWiseProcessBillDetailOutPut);
                        $('#div_PanelWiseProcessBillDetail').show();        
                        $("#spnAlert").text('');                
                    }     
                    else if (PanelWiseProcessBillDetail == "0") {
                      $("#spnAlert").text('No Record Found');
                       
                    }            
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }
       
         function ShowPopUpPanelWiseProcessBillDetail(rowID) {
          var PanelID=$(rowID).closest('tr').find('#tdPanelID').text();
          var ProcessID=$(rowID).closest('tr').find('#tdProcessID').text();                                 
                getPanelWiseProcessBillDetail(PanelID,ProcessID);
                $find('mpChangePanelWiseProcessBillDetail').show();           
         }
         function ClosePopUpPanelWiseProcessBillDetail() {
            $find('mpChangePanelWiseProcessBillDetail').hide();
         } 
//        ----------------------------END InvoiceAckNotReceived---------------------------
               
  
  
//        ----------------------------START TPAQuery---------------------------

        function getTPAQuery()
        {
         $('#div_TPAQuery').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getTPAQuery",
                data: '{ToDate:"' + document.getElementById('ctl00_ContentPlaceHolder1_txtToDate').value + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                TPAQuery = $.parseJSON(result.d);
                    if (TPAQuery != "0") {
                        var TPAQueryOutPut = $('#tb_TPAQuery').parseTemplate(TPAQuery);
                        $('#div_TPAQuery').html(TPAQueryOutPut);
                        $('#div_TPAQuery').show();                        
                    }          
                    else if (TPAQuery == "0") {       
                    var TPAQueryOutPut = $('#tb_TPAQuery').parseTemplate(TPAQuery);            
                    $('#div_TPAQuery').html(TPAQueryOutPut);                    
                    $("#spnTPAQuery").text('No Record Found');  
                    $('#div_TPAQuery').show();                        
                    }          
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }                            
         
        function ShowPopUpTPAQuery(rowID) {
            var QueryID=$(rowID).closest('tr').find('#tdQueryID').text();
            var Query=$(rowID).closest('tr').find('#tdQuery').text();
            $("#spnErrorMsg").text('');  
            $("#spnQuery").text(Query);                                    
                getTPAQueryDetail(QueryID);
                $find('mpChangeTPAQuery').show();           
         }
        function ClosePopUpTPAQuery() {
            $find('mpChangeTPAQuery').hide();
         } 
          
        function getTPAQueryDetail(QueryID)
        {
         $('#div_TPAQueryDetail').hide();
            $.ajax({                                                                         
                url: "Services/CommonService.asmx/getTPAQueryDetail",
                data: '{QueryID:"' + QueryID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                TPAQueryDetail = $.parseJSON(result.d);
                    if (TPAQueryDetail != "0") {
                        var TPAQueryDetailOutPut = $('#tb_TPAQueryDetail').parseTemplate(TPAQueryDetail);
                        $('#div_TPAQueryDetail').html(TPAQueryDetailOutPut);
                        $('#div_TPAQueryDetail').show();                        
                    }               
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }                
     
     
     
//        ----------------------------END TPAQuery---------------------------
  
  
        </script>
    
        
    <script id="tb_BillsPendingforDispatchInvoiceSummary" type="text/html">
                <table  id="tbheader1" border="1" style="width:460px;border-collapse:collapse;text-align:center;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:460px;">Bills Pending for Invoicing</th>                  			       
		        </tr>    
		        </table>
    
        <table id="tableBillsPendingforDispatchInvoiceSummary" border="1" style="width:460px;border-collapse:collapse;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">PanelID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:320px;Text-align:left;">Panel</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Total</th>                            
                    <th class="GridViewHeaderStyle" scope="col" style="width:30px;"></th> 
			       
		        </tr>            		                          
            <#
                 var dataLength=BillsPendingforDispatchInvoiceSummary.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = BillsPendingforDispatchInvoiceSummary[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>
                    <td class="GridViewStyleMIS"  style="width:50px;Text-align:left;display:none;" id="tdPanelID"><#=objRow.PanelID#></td>  
                    <td class="GridViewStyleMIS"  style="width:320px;Text-align:left;" id="tdPanel"><#=objRow.Panel#></td>     
                    <td class="GridViewStyleMIS"  style="width:40px;Text-align:left;" id="tdTotalBills"><#=objRow.TotalBills#></td>                  
                    <td class="GridViewStyleMIS"  style="width:30px;"> 
                        <img src="../../Images/view.GIF" style="cursor:pointer" onclick="ShowPopUpBillsPendingforDispatchInvoice(this)"  />                  
                    </td>             
		        </tr>
            <#}#>            
         </table>                            
          
    </script>
        
    <script id="tb_BillsPendingforDispatchInvoiceDetail" type="text/html">
        <table  id="tableBillsPendingforDispatchInvoiceDetail" border="1" style="width:920px;border-collapse:collapse;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">UHID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">IP No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;Text-align:left;">Patient Name</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;Text-align:left;display:none;">Panel</th>        
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Admission Date</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Discharge Date</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Bill Date</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Bill No</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Claim No</th>  
                    <th class="GridViewHeaderStyle" scope="col" style="width:90px;Text-align:left;">Bill Amount</th>     
                                                
		        </tr>            		                          
            <#
                 var dataLength=BillsPendingforDispatchInvoiceDetail.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = BillsPendingforDispatchInvoiceDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>
                    <td class="GridViewStyleMIS"  style="width:60px;" id="tdMRNo"><#=objRow.MRNo#></td>
                    <td class="GridViewStyleMIS"  style="width:60px;" id="tdIPNo"><#=objRow.IPNo#></td>
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;" id="tdPName"><#=objRow.PName#></td>    
                    <td class="GridViewStyleMIS"  style="width:200px;Text-align:left;display:none;" id="tdPanel"><#=objRow.Panel#></td>     
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdDateOfAdmit"><#=objRow.DateOfAdmit#></td>    
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdDateOfDischarge"><#=objRow.DateOfDischarge#></td>  
                    <td class="GridViewStyleMIS"  style="width:100px;Text-align:left;" id="tdBillDate"><#=objRow.BillDate#></td>   
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;" id="tdBillNo"><#=objRow.BillNo#></td> 
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;" id="tdClaimNo"><#=objRow.ClaimNo#></td>    
                    <td class="GridViewStyleMIS"  style="width:90px;Text-align:left;" id="tdBillAmt"><#=objRow.BillAmt#></td>   
                                                      
		        </tr>
            <#}#>   
             <tr>
            <td class="GridViewStyleMIS"  style="width:920px;Text-align:center;" colspan="11">
             <input type="button" id="btnreport1" value="Report" class="ItDoseButton" onclick="getbtnreport1(this)" />
            </td>
            </tr>          
         </table>                            
          
          
            
    </script>
        
    <script id="tb_InvoiceAckNotReceivedSummary" type="text/html">
                <table  id="tbheader2" border="1" style="width:460px;border-collapse:collapse;text-align:center;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:460px;">Invoice Not Acknowledged/Received</th>                  			       
		        </tr>    
		        </table>
      
        <table  id="tableInvoiceAckNotReceivedSummary" border="1" style="width:460px;border-collapse:collapse;">   
                <tr >
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">PanelID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:320px;Text-align:left;">Panel</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Total</th>                            
                    <th class="GridViewHeaderStyle" scope="col" style="width:30px;"></th> 
			       
		        </tr>            		                          
            <#
                 var dataLength=InvoiceAckNotReceivedSummary.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = InvoiceAckNotReceivedSummary[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>
                    <td class="GridViewStyleMIS"  style="width:50px;Text-align:left;display:none;" id="tdPanelID"><#=objRow.PanelID#></td>  
                    <td class="GridViewStyleMIS"  style="width:320px;Text-align:left;" id="tdPanel"><#=objRow.Panel#></td>     
                    <td class="GridViewStyleMIS"  style="width:40px;Text-align:left;" id="tdTotalBills"><#=objRow.TotalBills#></td>                  
                    <td class="GridViewStyleMIS"  style="width:30px;"> 
                        <img src="../../Images/view.GIF" style="cursor:pointer" onclick="ShowPopUpInvoiceAckNotReceived(this)"  />                  
                    </td>             
		        </tr>
            <#}#>            
         </table>                            
          
    </script>    
        
    <script id="tb_InvoiceAckNotReceiveDetail" type="text/html">
        <table  id="tableInvoiceAckNotReceiveDetail" border="1" style="width:920px;border-collapse:collapse;">   
                <tr >
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;Text-align:left;">Panel</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;Text-align:left;">Invoice Date</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;Text-align:left;">Invoice No</th>                              
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">View</th>                                                                       
		        </tr>            		                          
            <#
                 var dataLength=InvoiceAckNotReceiveDetail.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = InvoiceAckNotReceiveDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>  
                    <td class="GridViewStyleMIS"  style="width:200px;Text-align:left;" id="tdPanel"><#=objRow.Panel#></td>     
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;" id="tdTPAInvDate"><#=objRow.TPAInvDate#></td>    
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;" id="tdTPAInvNo"><#=objRow.TPAInvNo#></td>  
                   <td class="GridViewStyleMIS"  style="width:40px;"> 
                        <img src="../../Images/view.GIF" style="cursor:pointer" onclick="ShowPopUpInvoiceAckNotReceivedBill(this)"  />                  
                    </td>                                                   
		        </tr>
            <#}#>            
         </table>                            
          
    </script>
   
    <script id="tb_InvoiceAckNotReceiveBillDetail" type="text/html">
        <table  id="tableInvoiceAckNotReceiveBillDetail" border="1" style="width:920px;border-collapse:collapse;">   
                <tr >
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">UHID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;">IP No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;Text-align:left;">Patient Name</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:220px;Text-align:left;display:none;">Panel</th>        
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Admission Date</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Discharge Date</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Bill Date</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Bill No</th>   
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;display:none;">Claim No</th>  
                    <th class="GridViewHeaderStyle" scope="col" style="width:90px;Text-align:left;">Bill Amount</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;Text-align:left;display:none;">Invoice Date</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;Text-align:left;display:none;">Invoice No</th>   
                                                
		        </tr>            		                          
            <#
                 var dataLength=InvoiceAckNotReceiveBillDetail.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = InvoiceAckNotReceiveBillDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>
                    <td class="GridViewStyleMIS"  style="width:60px;" id="tdMRNo"><#=objRow.MRNo#></td>
                    <td class="GridViewStyleMIS"  style="width:60px;" id="tdIPNo"><#=objRow.IPNo#></td>
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;" id="tdPName"><#=objRow.PName#></td>    
                    <td class="GridViewStyleMIS"  style="width:220px;Text-align:left;display:none;" id="tdPanel"><#=objRow.Panel#></td>     
                    <td class="GridViewStyleMIS"  style="width:100px;Text-align:left;" id="tdDateOfAdmit"><#=objRow.DateOfAdmit#></td>    
                    <td class="GridViewStyleMIS"  style="width:100px;Text-align:left;" id="tdDateOfDischarge"><#=objRow.DateOfDischarge#></td>  
                    <td class="GridViewStyleMIS"  style="width:90px;Text-align:left;" id="tdBillDate"><#=objRow.BillDate#></td>   
                    <td class="GridViewStyleMIS"  style="width:140px;Text-align:left;" id="tdBillNo"><#=objRow.BillNo#></td> 
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;display:none;" id="tdClaimNo"><#=objRow.ClaimNo#></td>    
                    <td class="GridViewStyleMIS"  style="width:90px;Text-align:left;" id="tdBillAmt"><#=objRow.BillAmt#></td>   
                    <td class="GridViewStyleMIS"  style="width:90px;Text-align:left;display:none;" id="tdTPAInvoiceDate"><#=objRow.TPAInvoiceDate#></td> 
                    <td class="GridViewStyleMIS"  style="width:90px;Text-align:left;display:none;" id="tdTPAInvNo"><#=objRow.TPAInvNo#></td>                                      
		        </tr>
            <#}#>     
             <tr>
            <td class="GridViewStyleMIS"  style="width:920px;Text-align:center;" colspan="11">
             <input type="button" id="btnreport2" value="Report" class="ItDoseButton" onclick="getbtnreport2(this)" />
            </td>
            </tr>           
         </table>                            
          
    </script>
   
    <script id="tb_InvoiceAckReceivedSummary" type="text/html">
                <table  id="tbheader3" border="1" style="width:460px;border-collapse:collapse;text-align:center;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:460px;">Panel Wise Process Status(As on Date)</th>                  			       
		        </tr>    
		        </table>
      
        <table  id="tableInvoiceAckReceivedSummary" border="1" style="width:460px;border-collapse:collapse;">   
                <tr >
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">PanelID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:320px;Text-align:left;">Panel</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Total</th>                            
                    <th class="GridViewHeaderStyle" scope="col" style="width:30px;"></th> 
			       
		        </tr>            		                          
            <#
                 var dataLength=InvoiceAckReceivedSummary.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = InvoiceAckReceivedSummary[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>
                    <td class="GridViewStyleMIS"  style="width:50px;Text-align:left;display:none;" id="tdPanelID"><#=objRow.PanelID#></td>  
                    <td class="GridViewStyleMIS"  style="width:320px;Text-align:left;" id="tdPanel"><#=objRow.Panel#></td>     
                    <td class="GridViewStyleMIS"  style="width:40px;Text-align:left;" id="tdTotalBills"><#=objRow.TotalBills#></td>                  
                    <td class="GridViewStyleMIS"  style="width:30px;"> 
                        <img src="../../Images/view.GIF" style="cursor:pointer" onclick="ShowPopUpPanelWiseProcessList(this)"  />                  
                    </td>             
		        </tr>
            <#}#>            
         </table>                            
          
    </script>    
    
    <script id="tb_PanelWiseProcessList" type="text/html">
        <table  id="tablePanelWiseProcessList" border="1" style="width:920px;border-collapse:collapse;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;Text-align:left;display:none;">Panel ID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;Text-align:left;display:none;">Process ID</th>                      
                    <th class="GridViewHeaderStyle" scope="col" style="width:500px;Text-align:left;">Process</th>       
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;Text-align:left;">Active</th>                         
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">View</th>                                                                       
		        </tr>            		                          
            <#
                 var dataLength=PanelWiseProcessList.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = PanelWiseProcessList[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>  
			        <td class="GridViewStyleMIS"  style="width:50px;Text-align:left;display:none;" id="tdPanelID"><#=objRow.PanelID#></td>   
                    <td class="GridViewStyleMIS"  style="width:50px;Text-align:left;display:none;" id="tdProcessID"><#=objRow.ProcessID#></td>     
                    <td class="GridViewStyleMIS"  style="width:500px;Text-align:left;" id="tdProcess"><#=objRow.Name#></td>  
                    <td class="GridViewStyleMIS"  style="width:70px;Text-align:left;" id="tdActive"><#=objRow.Active#></td>    
                    <td class="GridViewStyleMIS"  style="width:40px;"> 
                        <img src="../../Images/view.GIF" style="cursor:pointer" onclick="ShowPopUpPanelWiseProcessBillDetail(this)"  />                  
                    </td>                                                   
		        </tr>		        
            <#}#>                         
         </table>                            
          
    </script>
    
    <script id="tb_PanelWiseProcessBillDetail" type="text/html">
        <table  id="tablePanelWiseProcessBillDetail" border="1" style="width:1150px;border-collapse:collapse;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:250px;Text-align:left;display:none;">Panel</th>                       
                    <th class="GridViewHeaderStyle" scope="col" style="width:300px;Text-align:left;display:none;">Process</th>       
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;Text-align:left;">IP No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Bill No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;Text-align:left;">Patient name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:110px;Text-align:left;">Expected Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Target Date</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:250px;Text-align:left;">User Remark</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Created By</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Created Date</th>                                                                                                        
		        </tr>            		                          
            <#
                 var dataLength=PanelWiseProcessBillDetail.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = PanelWiseProcessBillDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>  
                    <td class="GridViewStyleMIS"  style="width:250px;Text-align:left;display:none;" id="tdPanel"><#=objRow.Panel#></td>      
                    <td class="GridViewStyleMIS"  style="width:300px;Text-align:left;display:none;" id="tdProcess"><#=objRow.Name#></td>  
                    <td class="GridViewStyleMIS"  style="width:60px;Text-align:left;" id="tdIPNo"><#=objRow.IPNo#></td> 
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdBillNo"><#=objRow.BillNo#></td> 
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;" id="tdPName"><#=objRow.PName#></td>
                    <td class="GridViewStyleMIS"  style="width:110px;Text-align:left;" id="tdExpectedDate"><#=objRow.ExpectedDate#></td> 
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdTargetDate"><#=objRow.TargetDate#></td> 
                    <td class="GridViewStyleMIS"  style="width:250px;Text-align:left;" id="tdUserRemark"><#=objRow.UserRemark#></td> 
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdCreatedBy"><#=objRow.CreatedBy#></td>  
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdCreatedDate"><#=objRow.CreatedDate#></td>                              
		        </tr>
            <#}#>         
            <tr>
            <td class="GridViewStyleMIS"  style="width:920px;Text-align:center;" colspan="11">
             <input type="button" id="btnreport3" value="Report" class="ItDoseButton" onclick="getbtnreport3(this)" />
            </td>
            </tr>    
         </table>                            
          
    </script>                    
    
      <script id="tb_TPAQuery" type="text/html">
                <table  id="tbheader4" border="1" style="width:460px;border-collapse:collapse;text-align:center;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:460px;">Panel Query Status(As on Date)</th>                  			       
		        </tr>    
		        </table>
      
        <table  id="tableTPAQuery" border="1" style="width:460px;border-collapse:collapse;">   
                <tr >
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">QueryID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:320px;Text-align:left;">Query</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Total</th>                            
                    <th class="GridViewHeaderStyle" scope="col" style="width:30px;"></th> 
			       
		        </tr>            		                          
            <#
                 var dataLength=TPAQuery.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = TPAQuery[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>
                    <td class="GridViewStyleMIS"  style="width:50px;Text-align:left;display:none;" id="tdQueryID"><#=objRow.QueryID#></td>  
                    <td class="GridViewStyleMIS"  style="width:320px;Text-align:left;" id="tdQuery"><#=objRow.Name#></td>     
                    <td class="GridViewStyleMIS"  style="width:40px;Text-align:left;" id="tdTotalBills"><#=objRow.TotalBills#></td>                  
                    <td class="GridViewStyleMIS"  style="width:30px;"> 
                        <img src="../../Images/view.GIF" style="cursor:pointer" onclick="ShowPopUpTPAQuery(this)"  />                  
                    </td>             
		        </tr>
            <#}#>            
         </table>                            
          
    </script>    
    
      <script id="tb_TPAQueryDetail" type="text/html">
        <table  id="tableTPAQueryDetail" border="1" style="width:1050px;border-collapse:collapse;">   
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:250px;Text-align:left;display:none;">Panel</th>                       
                    <th class="GridViewHeaderStyle" scope="col" style="width:200px;Text-align:left;display:none;">Query</th>  
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;Text-align:left;display:none;">UHID</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:60px;Text-align:left;">IP No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Bill No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;Text-align:left;">Patient name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Expected Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Target Date</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:250px;Text-align:left;">User Remark</th>     
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Created By</th> 
                    <th class="GridViewHeaderStyle" scope="col" style="width:130px;Text-align:left;">Created Date</th>                                                                                                 
		        </tr>            		                          
            <#
                 var dataLength=TPAQueryDetail.length;        
                 var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = TPAQueryDetail[j];
                #>          
		        <tr id="tr_<#=(j+1)#>">
			        <td class="GridViewStyleMIS"  style="width:40px;" id="tdSNo"><#=(j+1)#></td>  
                    <td class="GridViewStyleMIS"  style="width:250px;Text-align:left;display:none;" id="tdPanel"><#=objRow.Panel#></td>      
                    <td class="GridViewStyleMIS"  style="width:200px;Text-align:left;display:none;" id="tdQuery"><#=objRow.Name#></td>  
                    <td class="GridViewStyleMIS"  style="width:70px;Text-align:left;display:none;" id="tdMRNo"><#=objRow.MRNo#></td> 
                    <td class="GridViewStyleMIS"  style="width:60px;Text-align:left;" id="tdIPNo"><#=objRow.IPNo#></td> 
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdBillNo"><#=objRow.BillNo#></td> 
                    <td class="GridViewStyleMIS"  style="width:150px;Text-align:left;" id="tdPName"><#=objRow.PName#></td>
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdExpectedDate"><#=objRow.ExpectedDate#></td> 
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdTargetDate"><#=objRow.TargetDate#></td> 
                    <td class="GridViewStyleMIS"  style="width:250px;Text-align:left;" id="tdUserRemark"><#=objRow.UserRemark#></td> 
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdCreatedBy"><#=objRow.CreatedBy#></td>  
                    <td class="GridViewStyleMIS"  style="width:130px;Text-align:left;" id="tdCreatedDate"><#=objRow.CreatedDate#></td>                                                                     
		        </tr>		        
            <#}#>                         
         </table>                            
          
    </script>
    
    
    
    
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
               <b>RECOVERY DASHBOARD</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                <table cellpadding="0" cellspacing="0" style="width: 100%">                                                          
                    <tr>                  
                        <td align="left" style="width: 20%">
                              &nbsp;From Date :
                              </td>
                        <td align="left" style="width: 30%">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select Date" CssClass="ItDoseTextinputText" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </td>
                        <td align="left" style="width: 20%">
                            To Date</td>
                        <td align="left" style="width: 30%">
                           <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </td>
                    </tr>

                </table>
            </div>
        </div>
        
        
     
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnsearch" value="Search" class="ItDoseButton" />           
        </div> 
        
         
        
        <div class="POuter_Box_Inventory">
            <div  style="text-align: center;display:none; overflow:scroll; height:250px;float:left; width:480px;" class="GridViewStyleMIS" id="div_BillsPendingforDispatchInvoiceSummary">            
            </div>  
            <div  style="text-align: center;display:none; overflow:scroll; height:250px;float:right; width:480px;" class="GridViewStyleMIS" id="div_InvoiceAckNotReceivedSummary">            
            </div> 
        </div>
                
        <div class="POuter_Box_Inventory">
            <div  style="text-align: center;display:none; overflow:scroll; height:250px;float:left; width:480px;" class="GridViewStyleMIS" id="div_InvoiceAckReceivedSummary">            
            </div> 
            <div  style="text-align: center;display:none; overflow:scroll; height:250px;float:right; width:480px;" class="GridViewStyleMIS" id="div_TPAQuery">            
            </div> 
        </div>                 
        
        
        
        <%--  Start BillsPendingforDispatchInvoice--%>
     <asp:Button ID="btnhidemp1" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpChangeBillsPendingforDispatchInvoice" BehaviorID="mpChangeBillsPendingforDispatchInvoice" runat="server" DropShadow="true" TargetControlID="btnhidemp1" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlBillsPendingforDispatchInvoice" X="40" Y="40">
     </cc1:ModalPopupExtender>     
     
      <asp:Panel ID="pnlBillsPendingforDispatchInvoice" style="display:none;" runat="server">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:950px;">
            <div class="Purchaseheader">
                <table width="950">
                    <tr>
                        <td style="text-align:left;">
                            <b>Bills Pending for Dispatch Invoice</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img alt="" src="../../Images/Delete.gif" style="cursor:pointer" width="10px" onclick="ClosePopUpBillsPendingforDispatchInvoice()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:950px;text-align:center;">
                <div style="text-align: center;display:none; overflow:scroll; height:500px;float:left; width:945px;" class="GridViewStyleMIS" id="div_BillsPendingforDispatchInvoiceDetail">            
                </div>  
            </div>
            
            </div>
            
      </asp:Panel>
         <%--  End BillsPendingforDispatchInvoice--%>
      
       <%--  Start InvoiceAckNotReceived--%>
     <asp:Button ID="btnhidemp2" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpChangeInvoiceAckNotReceived" BehaviorID="mpChangeInvoiceAckNotReceived" runat="server" DropShadow="true" TargetControlID="btnhidemp2" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlChangeInvoiceAckNotReceived" X="40" Y="40">
     </cc1:ModalPopupExtender>     
     
      <asp:Panel ID="pnlChangeInvoiceAckNotReceived" style="display:none;" runat="server">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:950px; height:550px;">
            <div class="Purchaseheader">
                <table width="950">
                    <tr>
                        <td style="text-align:left;">
                            <b>Invoice Acknowledgement Not Received</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img alt="" src="../../Images/Delete.gif" style="cursor:pointer" width="10px" onclick="ClosePopUpInvoiceAckNotReceived()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:950px;text-align:center;">
                <div style="text-align: center;display:none; overflow:scroll; height:120px;float:left; width:945px;" class="GridViewStyleMIS" id="div_InvoiceAckNotReceiveDetail">            
                </div>  
            </div>
            
             <div class="POuter_Box_Inventory" style="text-align: center;width:950px;">            
                <div class="Purchaseheader">
                   Bill Details
                </div>           
             </div>     
         <div class="POuter_Box_Inventory" style="width:950px;text-align:center;">
         <div style="text-align: center;display:none; overflow:scroll; height:380px;float:left; width:945px;" class="GridViewStyleMIS" id="div_InvoiceAckNotReceiveBillDetail">            
                </div> 
         </div>
        
            
            </div>
            
      </asp:Panel>
      <%--  End InvoiceAckNotReceived--%>
      
      
      
      
      
    <%--  Start InvoiceAckReceived--%>
       <asp:Button ID="btnhidemp3" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpChangePanelWiseProcessList" BehaviorID="mpChangePanelWiseProcessList" runat="server" DropShadow="true" TargetControlID="btnhidemp3" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlChangePanelWiseProcessList" X="40" Y="40">
     </cc1:ModalPopupExtender>     
     
      <asp:Panel ID="pnlChangePanelWiseProcessList" style="display:none;" runat="server">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:950px; height:550px;">
            <div class="Purchaseheader">
                <table width="950">
                    <tr>
                        <td style="text-align:left;">
                            <b><span id="spnPanel" class="ItDoseLblError"></span></b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img alt="" src="../../Images/Delete.gif" style="cursor:pointer" width="10px" onclick="ClosePopUpPanelWiseProcessList()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:950px;text-align:center;">
                <div style="text-align: center;display:none; overflow:scroll; height:120px;float:left; width:945px;" class="GridViewStyleMIS" id="div_PanelWiseProcessList">            
                </div>  
            </div>
            
         <div class="POuter_Box_Inventory" style="text-align: center;width:950px;">
                <b><span id="spnAlert" class="ItDoseLblError"></span></b>   
                <div class="Purchaseheader">
                   Bill Details
                </div>           
             </div>     
         <div class="POuter_Box_Inventory" style="width:950px;text-align:center;">
                <div style="text-align: center;display:none; overflow:scroll; height:380px;float:left; width:945px;" class="GridViewStyleMIS" id="div_PanelWiseProcessBillDetail">            
                </div> 
         </div>
                    
            </div>
            
      </asp:Panel>
         <%--  End InvoiceAckReceived--%>
     
     
      
    <%--  Start TPAQuery--%>
       <asp:Button ID="btnhidemp4" runat="server" style="display:none;"></asp:Button>
     <cc1:ModalPopupExtender ID="mpChangeTPAQuery" BehaviorID="mpChangeTPAQuery" runat="server" DropShadow="true" TargetControlID="btnhidemp4" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlChangeTPAQuery" X="40" Y="40">
     </cc1:ModalPopupExtender>     
     
      <asp:Panel ID="pnlChangeTPAQuery" style="display:none;" runat="server">         
            <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:950px; height:550px;">
                <div class="Purchaseheader">
                <table width="950">
                    <tr>
                        <td style="text-align:left;">
                            <b><span id="spnQuery" class="ItDoseLblError"></span></b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img alt="" src="../../Images/Delete.gif" style="cursor:pointer" width="10px" onclick="ClosePopUpTPAQuery()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
                </div>  
                               
                <div class="POuter_Box_Inventory" style="width:950px;text-align:center;">
                    <b><span id="spnTPAQuery" class="ItDoseLblError"></span></b>
                    <div style="text-align: center;display:none; overflow:scroll; height:250px;float:left; width:945px;" class="GridViewStyleMIS" id="div_TPAQueryDetail">            
                    </div>  
                </div>
                                               
        </div>
            
      </asp:Panel>
         <%--  End TPAQuery--%>
     
     
   </div>      
        
   
            
</asp:Content>
