<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AcceptIssueCSSDRequisition.aspx.cs" Inherits="Design_CSSD_AcceptIssueCSSDRequisition" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script>

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
    </script>


    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Accept/Issue CSSD Requisition</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Request Id
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtRequestId" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlFromDept" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus" onchange="StatusChange()">
                                <option value="0" selected="selected">Pending</option>
                                <option value="1">Accepted</option>
                                <option value="2">Issued</option>
                                <option value="3">Rejected</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" onchange="ChkDate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFrom" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" onchange="ChkDate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="calTo" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlRequestType" onchange="Serach()">
                                <option value="Requested" selected="selected">Requested</option>
                                <option value="Returned">Returned</option>
                            </select>
                            </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Search" id="btnSearch" style="width: 100px; margin-top: 7px;" onclick="Serach()" />
        </div>
         <div class="POuter_Box_Inventory" style="text-align:center;display:none;" id="searchResult">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row" id="searchOutPut" style="max-height:350px;overflow-y:scroll;"></div>
             
        <div class="row" style="text-align:center;">
            <input type="button" id="btnAccept" value="Accept" style="margin-top:7px;width:100px;" onclick="updateStatus('1');" />
            <input type="button" id="btnReject" value="Reject" style="margin-top:7px;width:100px;" onclick="updateStatus('3');" />
            
        </div>
             </div>
    </div>
     <div id="divRequestDetails" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1000px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divRequestDetails" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Requisition Details</h4>
                </div>
                <div class="modal-body">
                    <div class="row" id="divRequestItems" style="max-height:300px;overflow-y:scroll;">
                       
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnIssueRequest" onclick="IssueRequest()" >Issue</button>
                    <button type="button" id="btnConsume" onclick="ConsumeStock()" >Consume</button>
                    <button type="button" data-dismiss="divRequestDetails">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var Serach = function () {
            var data = {
                requestId: $.trim($('#txtRequestId').val()),
                fromDept: $('#ddlFromDept').val(),
                status: $('#ddlStatus').val(),
                fromDate: $.trim($('#txtFromDate').val()),
                toDate: $.trim($('#txtToDate').val()),
                requestType: $('#ddlRequestType').val()
            };
            serverCall('AcceptIssueCSSDRequisition.aspx/searchReqisition', data, function (response) {
                if (response != '') {
                    DataSearch = JSON.parse(response);
                    var output = $('#tb_SearchData').parseTemplate(DataSearch);
                    $('#searchOutPut').html(output).customFixedHeader();
                    $('#searchResult').show();
                    $('#lblMsg').text(DataSearch.length + ' Records Found');
                }
                else {
                    $('#searchResult').hide();
                    $('#searchOutPut').empty();
                    $('#lblMsg').text('No Record Found');
                }
            });

        }

        var checkAll = function (sender) {
            if ($(sender).prop('checked'))
                $('[id$=cbSelect]').prop('checked', true);
            else
                $('[id$=cbSelect]').prop('checked', false);
        }
        var StatusChange = function () {
            if ($('#ddlStatus').val() == '0')
                $('#btnAccept,#btnReject').removeAttr('disabled');
            else
                $('#btnAccept,#btnReject').attr('disabled', 'disabled');
            $('#searchResult').hide();
            $('#searchOutPut').empty();
        }
        var updateStatus = function ($status) {
            var dataList = [];

            $('#tb_SearchDataList tbody tr:not(#Header)').each(function () {
                if ($(this).find('#cbSelect').prop('checked')) {
                    dataList.push({
                        requestId: $(this).find('#tdRequestId').text(),
                        status: $status,
                        requestType: $(this).find('#tdRequestType').text()
                    });
                }
            });
            if ($(dataList).length == 0) {
                modelAlert('Please Select At Least One Record to Update.');
                return false;
            }
            serverCall('AcceptIssueCSSDRequisition.aspx/updateStatus', { data: dataList }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        Serach();
                });

            });

        }
        var getRequestDetails = function (requestId) {

            serverCall('AcceptIssueCSSDRequisition.aspx/getRequestDetails', { requestId: requestId }, function (response) {
                if (response != '') {
                    DataRequestDetails = JSON.parse(response);
                    var output = $('#tb_RequestItem').parseTemplate(DataRequestDetails);
                    $('#divRequestItems').html(output).customFixedHeader();
                    $('#divRequestDetails').showModel();
                    // if (DataRequestDetails[0].status == 1 && DataRequestDetails[0].requestType == "Requested")
                    if (DataRequestDetails[0].status == 1)
                        $('#btnIssueRequest,#btnConsume').removeAttr('disabled');
                    else
                        $('#btnIssueRequest,#btnConsume').attr('disabled', 'disabled');


                    if (DataRequestDetails[0].requestType == "Requested") {
                        $('.requestedType,#btnIssueRequest').show();
                        $('.returnedType,#btnConsume').hide();
                    }
                    else {
                        $('.requestedType,#btnIssueRequest').hide();
                        $('.returnedType,#btnConsume').show();
                        if (DataRequestDetails[0].IsProcessed == 1)
                            $('#btnConsume').attr('disabled', 'disabled');


                    }

                }

            });


        }
        var IssueRequest = function () {
            if (validateStock()) {
                var dataList = [];
                $('#tbRequestItemList tr:not(#trheader)').each(function () {
                    dataList.push({
                        requestId: $(this).find('#spanRequestId').text(),
                        setId: $(this).find('#tdSetId').text(),
                        itemId: $(this).find('#tdItemId').text(),
                        issueQty: Number($(this).find('#txtIssueQty').val()),
                        itemName: $(this).find('#tdItemName').text(),
                        toDeptLedgerNo: $(this).find('#tdFromDeptLedgerNo').text(),
                        id: Number($(this).find('#tdRowId').text()),
                        CssdComment: $(this).find('#txtCssdComment').val(),
                    });
                });

                var zeroQtyItem = dataList.filter(function (i) { if (i.issueQty == 0) { return i; } })

                //if (zeroQtyItem.length == dataList.length) {
                //    modelAlert('Please Issue At Least One Item');
                //    return false;
                //}
                if (zeroQtyItem.length > 0) {
                    modelAlert('Stock Not Available for ' + zeroQtyItem[0].itemName);
                    return false;
                }

                modelConfirmation('Alert!!!', 'Are you sure want to Issue?', 'Yes, Issue', 'Close', function (response) {
                    if (response) {
                        serverCall('AcceptIssueCSSDRequisition.aspx/issueRequisition', { data: dataList }, function (resp) {
                            var responseData = JSON.parse(resp);
                            modelAlert(responseData.response, function () {
                                if (responseData.status) {
                                    $('#divRequestDetails').closeModel();
                                    Serach();
                                }
                            });

                        });
                    }
                });
            }
        }

        var validateStock = function () {
            var isValid = true;
            $('#tbRequestItemList tr:not(#trheader)').each(function () {
                var itemId = $(this).find('#tdItemId').text();
                var availStock = Number($(this).find('#tdStockQty').text());
                var requiredQty = 0;
                $('#tbRequestItemList tr:not(#trheader)').each(function () {
                    if ($(this).find('#tdItemId').text() == itemId)
                        requiredQty += Number($(this).find('#txtIssueQty').val());

                });

                if (availStock < requiredQty) {
                    isValid = false;
                    modelAlert('Total Issued QTY is Greater than Available QTY of Item : <span class="patientInfo">' + $(this).find('#tdItemName').text() + '</span>.Please Check.');
                    return false;
                }

            });

            return isValid;



        }
        var ConsumeStock = function () {
            var dataList = [];
            $('#tbRequestItemList tr:not(#trheader)').each(function () {
                var consumedQty = Number($(this).find('#txtConsumeQty').val());
                if (consumedQty > 0) {
                    dataList.push({
                        requestId: $(this).find('#spanRequestId').text(),
                        setId: $(this).find('#tdSetId').text(),
                        itemId: $(this).find('#tdItemId').text(),
                        issueQty: consumedQty,
                        itemName: $(this).find('#tdItemName').text(),
                        toDeptLedgerNo: $(this).find('#tdFromDeptLedgerNo').text(),
                        id: Number($(this).find('#tdRowId').text()),
                        setStockId: $(this).find('#tdToSetStockId').text(),
                        CssdComment: $(this).find('#txtCssdComment').val()
                    });
                }
            });

            if (dataList.length == 0) {
                modelAlert('Please Consume At Least One Item');
                return;
            }

            modelConfirmation('Alert!!!', 'Are you sure want to Consume?', 'Yes, Consume', 'Close', function (response) {
                if (response) {
                    serverCall('AcceptIssueCSSDRequisition.aspx/consumeStock', { data: dataList }, function (resp) {
                        var responseData = JSON.parse(resp);
                        modelAlert(responseData.response, function () {
                            if (responseData.status) {
                                $('#divRequestDetails').closeModel();
                                // Serach();
                            }
                        });

                    });
                }
            });


        }
    </script>
<script id="tb_SearchData" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_SearchDataList" style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.
                <br />
                <input type="checkbox" onclick="checkAll(this)" />
			</th>
            <th class="GridViewHeaderStyle" scope="col">From Department</th>
            <th class="GridViewHeaderStyle" scope="col">From Department</th>
            <th class="GridViewHeaderStyle" scope="col">Request Id</th>
            <th class="GridViewHeaderStyle" scope="col">Request Date/Time</th>
            <th class="GridViewHeaderStyle" scope="col">Status</th>
            <th class="GridViewHeaderStyle" scope="col">Requested By</th>
            <th class="GridViewHeaderStyle" scope="col">Total Sets</th>
            <th class="GridViewHeaderStyle" scope="col">View/Issue</th>
            
		</tr>
        <#       
        var dataLength=DataSearch.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = DataSearch[j];
        #>
                    <tr>                            
                    <td class="GridViewLabItemStyle"><#=j+1#><input type="checkbox" id="cbSelect" />  </td>
                        <td  id="tdRequestType" class="GridViewLabItemStyle"><#=objRow.requestType#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.FromDept#></td>
                    <td class="GridViewLabItemStyle" id="tdRequestId"><#=objRow.requestId#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.DateTime#></td>
                    <td class="GridViewLabItemStyle">
                      <# if(objRow.status==0){ #>
                       <span style="color:red;font-weight:bold;">Pending</span> 
                      <#} else if(objRow.status==1){ #>
                            <# if(objRow.IsProcessed==1){ #>
                                <span style="color:black;font-weight:bold;">Processed</span>
                        <# } else{ #>
                        <span style="color:green;font-weight:bold;">Accepted</span>
                        <#}#>
                      <#} else if(objRow.status==2){ #>
                         <span style="color:blue;font-weight:bold;">Issued</span>
                      <#} else if(objRow.status==3){ #>
                         <span style="color:red;font-weight:bold;">Rejected</span>
                      <#}#>

                    </td>
                    <td class="GridViewLabItemStyle"><#=objRow.CreatedBy#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.TotalSets#></td>
                    <td class="GridViewLabItemStyle">
                        <img alt="Select" src="../../Images/view.GIF" style="border: 0px solid #FFFFFF;cursor:pointer;" onclick="getRequestDetails(<#=objRow.requestId#>)">
                </td>
 </tr>           
        <#}#>                     
     </table>    
    </script>
<script id="tb_RequestItem" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tbRequestItemList" style="width:100%;border-collapse:collapse;">
		<tr id="trheader">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.
                <br />
                <input type="checkbox" style="display:none;" />
			</th>
            <th class="GridViewHeaderStyle" scope="col">Request Id</th>
            <th class="GridViewHeaderStyle" scope="col">Set Name</th>
            <th class="GridViewHeaderStyle" scope="col">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col">Status</th>
            <th class="GridViewHeaderStyle" scope="col">Master QTY</th>
            <th class="GridViewHeaderStyle requestedType" scope="col" >Stock Available</th>
            <th class="GridViewHeaderStyle" scope="col">Requested QTY</th>
            <th class="GridViewHeaderStyle requestedType" scope="col">Issue QTY</th>
            <th class="GridViewHeaderStyle returnedType" scope="col">Consumed QTY</th>
            <th class="GridViewHeaderStyle returnedType" scope="col">Consume QTY</th>
             <th class="GridViewHeaderStyle" scope="col">Dept. Comment</th>
              <th class="GridViewHeaderStyle" scope="col">AddComment</th>
		</tr>
        <#       
        var dataLength=DataRequestDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;    
        var lastRequestId='';
        var lastSetName='';  
        for(var j=0;j<dataLength;j++)
        {       
        objRow = DataRequestDetails[j];
        #>
                    <tr>                            
                    <td class="GridViewLabItemStyle"><#=j+1#><input type="checkbox" id="Checkbox1"  style="display:none;" />  </td>
                    <td class="GridViewLabItemStyle" id="tdDetailsRequestId"><span id="spanRequestId" <#if(lastRequestId==objRow.requestId){ #> style='display:none;'<#}#> ><#=objRow.requestId#></span></td>
                    <td class="GridViewLabItemStyle">
                        <span id="spnSetName" <#if(lastSetName==objRow.SetName){ #> style='display:none;'<#}#> >
                        <#=objRow.SetName#></span></td>
                    <td class="GridViewLabItemStyle" id="tdItemName"><#=objRow.ItemName#></td>
                   <td class="GridViewLabItemStyle">
                      <# if(objRow.status==0){ #>
                       <span style="color:red;font-weight:bold;">Pending</span> 
                      <#} else if(objRow.status==1){ #>
                         <span style="color:green;font-weight:bold;">Accepted</span>
                      <#} else if(objRow.status==2){ #>
                         <span style="color:blue;font-weight:bold;">Issued</span>
                      <#} else if(objRow.status==3){ #>
                         <span style="color:red;font-weight:bold;">Rejected</span>
                      <#}#>

                    </td>
                    <td class="GridViewLabItemStyle"  style="text-align:center;" ><#=objRow.masterQty#></td>
                    <td class="GridViewLabItemStyle requestedType"  style="text-align:center;" id="tdStockQty"><#=objRow.StockQty#></td>
                    <td class="GridViewLabItemStyle"  style="text-align:center;"><#=objRow.reqQty#></td>
                    
                      <td class="GridViewLabItemStyle requestedType">
                        <# var maxQty=Number(objRow.reqQty); if(Number(objRow.reqQty)>Number(objRow.StockQty)) { maxQty=0 } #>
                     <input type="text" id="txtIssueQty" class="ItDoseTextinputNum requiredField" onlynumber="5" autocomplete="off" value="<#=maxQty#>" max-value="<#=maxQty#>"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" disabled />
                 </td>
                        <td class="GridViewLabItemStyle returnedType" style="text-align:center;"><#=objRow.consumedQty#></td>
                 <td class="GridViewLabItemStyle returnedType">
                        <# var maxQty=Number(objRow.reqQty)-Number(objRow.consumedQty); #>
                     <input type="text" id="txtConsumeQty" class="ItDoseTextinputNum requiredField" onlynumber="5" autocomplete="off" value="0" max-value="<#=maxQty#>"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" <#if(objRow.IsProcessed==1){ #> disabled <#}#> />
                 </td>
<td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Comment#></td>

<td class="GridViewLabItemStyle" style="text-align:center;"> <textarea id="txtCssdComment" cols="1" rows="1" style="width:200px" ></textarea> </td>

                        
                   <td class="GridViewLabItemStyle" id="tdSetId"  style="display:none;"><#=objRow.setId#></td>
                  <td class="GridViewLabItemStyle" id="tdItemId"  style="display:none;"><#=objRow.itemId#></td>
                   <td class="GridViewLabItemStyle" id="tdRowId"  style="display:none;"><#=objRow.id#></td>
                  <td class="GridViewLabItemStyle" id="tdFromDeptLedgerNo"  style="display:none;"><#=objRow.FromDeptLedgerNo#></td>
                 <td class="GridViewLabItemStyle" id="tdToSetStockId"  style="display:none;"><#=objRow.toSetStockId#></td>
 </tr>   
            <#lastRequestId=objRow.requestId;lastSetName=objRow.SetName; #>        
        <#}#>                     
     </table>    
    </script>
</asp:Content>

