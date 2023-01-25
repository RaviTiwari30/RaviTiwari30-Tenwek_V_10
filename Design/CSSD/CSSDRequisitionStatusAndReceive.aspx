<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CSSDRequisitionStatusAndReceive.aspx.cs" Inherits="Design_CSSD_CSSDRequisitionStatusAndReceive" %>

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
            <b>CSSD Requisition Status & Update Used</b><br />
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
                                Req. Department
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
                                <option value="" selected="selected">All</option>
                                <option value="0">Pending</option>
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
        <div class="POuter_Box_Inventory" style="text-align: center; display: none;" id="searchResult">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row" id="searchOutPut" style="max-height: 350px; overflow-y: scroll;"></div>

         
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
                    <button type="button" style="width:25px;height:20px;float:left;margin-left:5px;background-color:yellow" class="circle"></button>
                    <b style="float:left;margin-top:5px;margin-left:5px">Partial Issue</b>
                    <button type="button" id="btnUpdateUsed" onclick="updateUsed()" >Update Used</button>
                    <button type="button" data-dismiss="divRequestDetails">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script>

        var Serach = function () {
            var data = {
                requestId: $.trim($('#txtRequestId').val()),
                toDept: $('#ddlFromDept').val(),
                status: $('#ddlStatus').val(),
                fromDate: $.trim($('#txtFromDate').val()),
                toDate: $.trim($('#txtToDate').val()),
                requestType: $('#ddlRequestType').val()
            };
            serverCall('CSSDRequisitionStatusAndReceive.aspx/searchReqisition', data, function (response) {
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
        var getRequestDetails = function (requestId) {

            serverCall('CSSDRequisitionStatusAndReceive.aspx/getRequestDetails', { requestId: requestId }, function (response) {
                if (response != '') {
                    DataRequestDetails = JSON.parse(response);
                    var output = $('#tb_RequestItem').parseTemplate(DataRequestDetails);
                    $('#divRequestItems').html(output).customFixedHeader();
                    $('#divRequestDetails').showModel();
                    if (DataRequestDetails[0].Status == 2)
                        $('#btnUpdateUsed').removeAttr('disabled');
                    else
                        $('#btnUpdateUsed').attr('disabled', 'disabled');
                }

            });


        }
        var checkAllItem = function (sender) {
            if ($(sender).prop('checked'))
                $('[id$=cbSelectUsed]:visible').prop('checked', true);
            else
                $('[id$=cbSelectUsed]:visible').prop('checked', false);
        }
        var fillAllUHID = function (sender) {
            $('[id$=txtUsedUHID]').val($.trim($(sender).val()));


        }
        var updateUsed = function () {
            var dataList = [];
            $('#tbRequestItemList tr:not(#trheader)').each(function () {
                if ($(this).find('#cbSelectUsed').prop('checked')) {
                    dataList.push({
                        id: $(this).find('#tdId').text(),
                        usedUHID: $.trim($(this).find('#txtUsedUHID').val())
                    });


                }
            });

            if (dataList.length == 0) {
                modelAlert('Please Select At Least One Item To Update');
                return false;

            }

            serverCall('CSSDRequisitionStatusAndReceive.aspx/updateUsed', { data: dataList }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        $('#divRequestDetails').closeModel();
                        Serach();
                    }
                });
            });


        }
    </script>
    <script id="tb_SearchData" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_SearchDataList" style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.
                <br />
                <input type="checkbox" onclick="checkAll(this)" style="display:none;" checked="checked" />
			</th>
            <th class="GridViewHeaderStyle" scope="col">Type</th>
            <th class="GridViewHeaderStyle" scope="col">Requested Department</th>
            <th class="GridViewHeaderStyle" scope="col">Request Id</th>
            <th class="GridViewHeaderStyle" scope="col">Request Date/Time</th>
            <th class="GridViewHeaderStyle" scope="col">Status</th>
            <th class="GridViewHeaderStyle" scope="col">Requested By</th>
            <th class="GridViewHeaderStyle" scope="col">Total Sets</th>
            <th class="GridViewHeaderStyle" scope="col">View/Use</th>
            
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
                    <td class="GridViewLabItemStyle"><#=j+1#><input type="checkbox" id="cbSelect"  style="display:none;" />  </td>
                    <td class="GridViewLabItemStyle"><#=objRow.requestType#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.ToDept#></td>
                    <td class="GridViewLabItemStyle" id="tdRequestId"><#=objRow.requestId#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.DateTime#></td>
                    <td class="GridViewLabItemStyle">
                      <# if(objRow.status==0){ #>
                       <span style="color:red;font-weight:bold;">Pending</span> 
                      <#} else if(objRow.status==1){ #>
                         <span style="color:green;font-weight:bold;">Accepted</span>
                      <#} else if(objRow.status==2){ #>
                         <span style="color:blue;font-weight:bold;">Issued</span>
                      <#} else if(objRow.status==3){ #>
                         <span style="color:red;font-weight:bold;">Rejected</span>
                        <#} else {#>
                       <span style="color:black;font-weight:bold;"><#=objRow.status#></span>
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
                <input type="checkbox" onclick="checkAllItem(this)" style="display:none;" />
			</th>
            <th class="GridViewHeaderStyle" scope="col">Request Id</th>
            <th class="GridViewHeaderStyle" scope="col">Set Name</th>
            <th class="GridViewHeaderStyle" scope="col">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col">Status</th>
            <th class="GridViewHeaderStyle" scope="col">Requested QTY</th>
            <th class="GridViewHeaderStyle" scope="col">Issue QTY</th>
             <th class="GridViewHeaderStyle" scope="col">Comment</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Used UHID
                <input type="text" maxlength="20" onkeyup="fillAllUHID(this)" style="width:110px;" />
            </th>
            
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
                    <tr  <# if(objRow.reqQty!=objRow.IssuedQty){#> style="background-color: yellow;"<# }#>>                            
                    <td class="GridViewLabItemStyle"><#=j+1#><input type="checkbox"  id="cbSelectUsed"  style="display:none;" checked="checked" />  </td>
                    <td class="GridViewLabItemStyle" id="tdDetailsRequestId"><span id="spanRequestId" <#if(lastRequestId==objRow.requestId){ #> style='display:none;'<#}#> ><#=objRow.requestId#></span></td>
                    <td class="GridViewLabItemStyle">
                        <span id="spnSetName" <#if(lastSetName==objRow.SetName){ #> style='display:none;'<#}#> >
                        <#=objRow.SetName#></span></td>
                    <td class="GridViewLabItemStyle" id="tdItemName"><#=objRow.ItemName#></td>
                   <td class="GridViewLabItemStyle">
                      <# if(objRow.Status==0){ #>
                       <span style="color:red;font-weight:bold;">Pending</span> 
                      <#} else if(objRow.Status==1){ #>
                         <span style="color:green;font-weight:bold;">Accepted</span>
                      <#} else if(objRow.Status==2){ #>
                         <span style="color:blue;font-weight:bold;">Issued</span>
                      <#} else if(objRow.Status==3){ #>
                         <span style="color:red;font-weight:bold;">Rejected</span>
                      <#} else {#>
                       <span style="color:black;font-weight:bold;"><#=objRow.Status#></span>
                       <#}#>
                    </td>
                    <td class="GridViewLabItemStyle"  style="text-align:center;"><#=objRow.reqQty#></td>
                    <td class="GridViewLabItemStyle"  style="text-align:center;"><#=objRow.IssuedQty#></td>
 					<td class="GridViewLabItemStyle" ><#=objRow.CssdComment#></td>

                    <td class="GridViewLabItemStyle">
                      <#if(objRow.Status==2){ #>
                      <input type="text" id="txtUsedUHID" maxlength="20" autocomplete="off"  />
                      <#}#>
                 </td>
                  <td class="GridViewLabItemStyle" id="tdSetId"  style="display:none;"><#=objRow.setId#></td>
                  <td class="GridViewLabItemStyle" id="tdItemId"  style="display:none;"><#=objRow.itemId#></td>
                  <td class="GridViewLabItemStyle" id="tdId"  style="display:none;"><#=objRow.id#></td>
 </tr>   
            <#lastRequestId=objRow.requestId;lastSetName=objRow.SetName; #>        
        <#}#>                     
     </table>    
    </script>
</asp:Content>

