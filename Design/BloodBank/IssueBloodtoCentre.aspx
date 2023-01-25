<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="IssueBloodtoCentre.aspx.cs" Inherits="Design_BloodBank_IssueBloodtoCentre" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <script type="text/javascript" src="../../Scripts/Search.js"> </script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script  src="../../Scripts/json2.js" type="text/javascript"></script>
      
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Issue Stock to Centre </b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" runat="server">
                Search Criteria
            </div>
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                       <div class="col-md-3">
                            <label class="pull-left">
                                Centre Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCentre" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Centre" ></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Component
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <select id="ddlComponent" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Component" ></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlBloodGroup" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Blood Group"></select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
                     <input type="button" id="btnSearch" value="Search Stock" tabindex="4" class="ItDoseButton" onclick="SearchRequest();" />
         </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Request Status
            </div>
                  <div id="RequestOutPut" style="max-height: 500px; overflow-x: auto;"></div>
         </div>
        <div class="POuter_Box_Inventory" style="text-align:left; display:none" id="divDetail">
        <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                       <div class="col-md-3">
                            <label class="pull-left">
                               From Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <label id="lblCentreName"></label>
                           <label id="lblCentreID" style="display:none"></label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               Component Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <label id="lblComponentName"></label>
                           <label id="lblComponentID" style="display:none"></label>
                            <label id="lblRequestID" style="display:none"></label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               Pending Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <label id="lblPenQty"></label>
                          <label id="lblSelectedQty" style="display:none;"></label>
                        </div>
                        </div>
                    </div>
             <div class="col-md-1"></div>
            </div>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
             <div class="Purchaseheader">
                Stock Detail
            </div>
                  <div id="StockOutput" style="max-height: 500px; overflow-x: auto;"></div>
         </div>
        <div class="POuter_Box_Inventory" style="text-align: center; display:none;" id="divSave">
                     <input type="button" id="btnSave" value="Save" tabindex="5" class="ItDoseButton" onclick="SaveRequest();" />
         </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadCentre();
            LoadComponent();
            LoadBloodGroup();
        });
        function LoadCentre() {
            serverCall('IssueBloodtoCentre.aspx/LoadCentre', {}, function (response) {
                ddlCentre = $('#ddlCentre');
                ddlCentre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false });
            });
        }
        function LoadComponent() {
            var CentreID = $('#ddlCentre option:selected').val();
            serverCall('IssueBloodtoCentre.aspx/LoadComponent', { CentreID: CentreID }, function (response) {
                ddlComponent = $('#ddlComponent');
                ddlComponent.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'ComponentName', isSearchAble: false });
            });
        }
        function LoadBloodGroup() {
            serverCall('IssueBloodtoCentre.aspx/LoadBloodGroup', {}, function (response) {
                ddlBloodGroup = $('#ddlBloodGroup');
                ddlBloodGroup.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });
            });
        }
        function ChangeColor(rowID) {
            var Count = Number($('#lblSelectedQty').text());
            var PendingQty = Number($('#lblPenQty').text());
            if ($(rowID).closest('tr').find("#chkYes").is(':checked')) {
                if (Count > PendingQty) {
                    modelAlert('Can not Select more than pending Qty');
                    $(rowID).closest('tr').find("#chkYes").prop('checked', false);
                }
                else {
                    Count = Count + 1;
                    $('#lblSelectedQty').text(Count);
                    $(rowID).closest('tr').css("background-color", "#FDE76D");
                }
            }
            else {
                $(rowID).closest('tr').css("background-color", "transparent");
                Count = Count - 1;
                $('#lblSelectedQty').text(Count);
            }
        }
    </script>
    <script type="text/javascript">

        function SearchRequest() {
            var CentreID = $('#ddlCentre option:selected').val();
            var Component = $('#ddlComponent option:selected').val();
            var BloodGroup = $('#ddlBloodGroup option:selected').html();
            if (CentreID == "0") {
                modelAlert('Please Select Centre !!');
                return false;
            }

            $.ajax({
                url: "IssueBloodtoCentre.aspx/SearchRequest",
                data: '{CentreID:"' + CentreID + '",Component:"' + Component + '",BloodGroup:"' + BloodGroup + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        RequestData = jQuery.parseJSON(result.d);
                        if (RequestData != null) {
                            var output = $('#tb_RequestSearch').parseTemplate(RequestData);
                            $('#RequestOutPut').html(output);
                            $('#RequestOutPut').show();
                        }
                    }
                    else {
                        $('#RequestOutPut').html();
                        $('#RequestOutPut').hide();
                        modelAlert('No Request Found');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#RequestOutPut').html();
                    $('#RequestOutPut').hide();
                    modelAlert('Error');
                }
            });
        }

        function SearchStock(rowID) {
            var row = rowID;
            var CentreID = $(row).closest('tr').find("#tdr_CentreID").text();
            var Component = $(row).closest('tr').find("#tdr_ComponentID").text();
            var BloodGroup = $(row).closest('tr').find("#tdr_BloodGroup").text();
            $('#lblSelectedQty').text('1');
            $('#lblCentreID').text(CentreID);
            $('#lblCentreName').text($(row).closest('tr').find("#tdr_CentreName").text());
            $('#lblComponentID').text(Component);
            $('#lblComponentName').text($(row).closest('tr').find("#tdr_ComponentName").text());
            $('#lblRequestID').text($(row).closest('tr').find("#td_RequestID").text());
            $('#lblPenQty').text($(row).closest('tr').find("#tdr_PendingQty").text());

            if (CentreID == "0") {
                modelAlert('Please Select Centre !!');
                return false;
            }

            $.ajax({
                url: "IssueBloodtoCentre.aspx/SearchStock",
                data: '{CentreID:"' + CentreID + '",Component:"' + Component + '",BloodGroup:"' + BloodGroup + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        StockData = jQuery.parseJSON(result.d);
                        if (StockData != null) {
                            var output = $('#tb_StockSearch').parseTemplate(StockData);
                            $('#StockOutput').html(output);
                            $('#StockOutput').show();
                            $('#divSave').show();
                            $('#divDetail').show();
                        }
                    }
                    else {
                        $('#StockOutput').html();
                        $('#StockOutput').hide();
                        $('#divSave').hide();
                        $('#divDetail').hide();
                        modelAlert('No Stock Found');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#StockOutput').html();
                    $('#StockOutput').hide();
                    modelAlert('Error');
                }
            });
        }

        function SaveRequest() {
            var dataStk = new Array();
            var ObjDtStk = new Object();
            $('#tb_Stockdata tr input:checked').each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") {
                    ObjDtStk.CentreID = $('#lblCentreID').text();
                    ObjDtStk.ComponentID = $('#lblComponentID').text();
                    ObjDtStk.RequestID = $('#lblRequestID').text();
                    ObjDtStk.StockID = $.trim($rowid.find("#tdStockID").text());

                    dataStk.push(ObjDtStk);
                    ObjDtStk = new Object();
                }
            });
            if (dataStk.length > 0) {
                $.ajax({
                    url: "IssueBloodtoCentre.aspx/SaveRequest",
                    data: JSON.stringify({ Data: dataStk }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        Data = result.d;
                        if (Data == "1") {
                            modelAlert('Record Save Successfully', function () {
                                SearchRequest();
                            });
                            $('#StockOutput').hide();
                            $('#divSave').hide();
                            $('#divDetail').hide();
                        }
                        else {
                            modelAlert('Record Not Saved');
                        }
                    },
                    error: function (xhr, status) {

                    }
                });
            }
        }
        function RejectRequest(rowID) {
            var ComponentName = $(rowID).closest('tr').find("#tdr_ComponentName").text();
            var RequestQty = $(rowID).closest('tr').find("#td_RequestID").text();
            var PenQty = $(rowID).closest('tr').find("#tdr_PendingQty").text();
            $('#divReject #txtRejectQty').val(PenQty);
            $('#divReject #spnPenQty').text(PenQty);
            $('#divReject #spnComName').text(ComponentName);
            $('#divReject #spnReqID').text(RequestQty);
            $('#divReject').showModel();
        }
        function $RejectRequest(RejectDetail)
        {
            if (Number(RejectDetail.RejectQty) <=0) {
                modelAlert('Enter Reject Quantity');
                return false;
            }
            if (RejectDetail.RejectResaon <= '') {
                modelAlert('Enter Reject Reason');
                return false;
            }

            serverCall('IssueBloodtoCentre.aspx/RejectRequest', { RequestID: RejectDetail.RequestID, RejectQty: RejectDetail.RejectQty, RejectReason: RejectDetail.RejectResaon }, function (response) {
                $responseData = parseInt(response);
                 if ($responseData == '1') {
                     $('#divReject').closeModel();
                     modelAlert('Request Reject Successfully', function (response) {
                         SearchRequest();
                         $('#StockOutput').hide();
                         $('#divSave').hide();
                         $('#divDetail').hide();
                    });
                }
                else
                    modelAlert('Error occurred, Please contact administrator');
            });

        }
        function CheckNumeric(Qty) {
            var Amt = $(Qty).val();
            if (Amt.charAt(0) == "0") {
                $(Qty).val(Number(Amt));
            }

            if (Amt.match(/[^0-9\.]/g)) {
                Amt = Amt.replace(/[^0-9\.]/g, '');
                $(Qty).val(Number(Amt));
                return;
            }
            if (Amt.indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = Amt.indexOf(".");
                if (valIndex > "0") {
                    if (Amt.length - (Amt.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(Qty).val($(Qty).val().substring(0, ($(Qty).val().length - 1)));

                    }
                }
            }
        }
    </script>
     <script id="tb_RequestSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_RequestData" style="width:100%;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">From Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Component</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Blood Group</th>        
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Req. Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Issue Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rejected Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Pending Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Request Reason</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Request Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Request By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Process</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Reject</th>
		</tr>
        <#       
        var dataLength=RequestData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = RequestData[j];
        #>
                    <tr id="trHeader">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td class="GridViewLabItemStyle" id="td_RequestID"  style="width:40px;display:none;" ><#=objRow.RequestID#></td> 
                        <td class="GridViewLabItemStyle" id="tdr_CentreID"  style="width:40px;display:none;" ><#=objRow.CentreID#></td> 
                        <td class="GridViewLabItemStyle" id="tdr_CentreName"  style="width:40px;" ><#=objRow.CentreName#></td>   
                        <td class="GridViewLabItemStyle" id="tdr_ComponentID"  style="width:40px; display:none" ><#=objRow.ComponentID#></td>
                        <td class="GridViewLabItemStyle" id="tdr_ComponentName"  style="width:40px;" ><#=objRow.ComponentName#></td>
                        <td class="GridViewLabItemStyle" id="tdr_BloodGroup"  style="width:40px;" ><#=objRow.BloodGroup#></td>
                        <td class="GridViewLabItemStyle" id="tdr_Quantity"  style="width:40px;" ><#=objRow.Quantity#></td>
                        <td class="GridViewLabItemStyle" id="tdr_IssueQty"  style="width:40px;" ><#=objRow.IssueQuantity#></td>
                        <td class="GridViewLabItemStyle" id="tdr_RejQty"  style="width:40px;" ><#=objRow.RejectQty#></td>
                        <td class="GridViewLabItemStyle" id="tdr_PendingQty"  style="width:40px;" ><#=objRow.PendingQuantity#></td>
                        <td class="GridViewLabItemStyle" id="tdr_Reason"  style="width:40px;" ><#=objRow.EntryReason#></td>   
                        <td class="GridViewLabItemStyle" id="tdr_EntryDate"  style="width:40px;" ><#=objRow.EntryDate#></td>   
                        <td class="GridViewLabItemStyle" id="tdr_EntryBy"  style="width:40px;" ><#=objRow.EntryBy#></td>  
                        <td class="GridViewLabItemStyle" id="td1"  style="width:30px;" ><img id="imgProcess" src="../../Images/view.gif" onclick="SearchStock(this);" title="Click To Process" /></td>            
                        <td class="GridViewLabItemStyle" id="td2"  style="width:30px;" ><img id="img1" src="../../Images/Delete.gif" onclick="RejectRequest(this);" title="Click To Reject" /></td>            
                    </tr>           
        <#}#>                     
     </table>    
    </script>

    <script id="tb_StockSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_Stockdata" style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Component</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Blood Group</th>        
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Bag Number</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Expiry Date</th>
		</tr>
        <#       
        var dataLength=StockData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = StockData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#><input type="checkbox" id="chkYes" onclick="ChangeColor(this);" /></td>
                        <td class="GridViewLabItemStyle" id="tdComponentID"  style="width:40px; display:none" ><#=objRow.ComponentId#></td>
                        <td class="GridViewLabItemStyle" id="tdComponentName"  style="width:40px;" ><#=objRow.Componentname#></td>
                        <td class="GridViewLabItemStyle" id="tdBloodGroup"  style="width:40px;" ><#=objRow.BloodGroup#></td>
                        <td class="GridViewLabItemStyle" id="tdBatchNo"  style="width:40px;" ><#=objRow.BatchNo#></td>
                        <td class="GridViewLabItemStyle" id="tdQuantity"  style="width:40px;" ><#=objRow.Quantity#></td>   
                        <td class="GridViewLabItemStyle" id="tdExpiryDate"  style="width:40px;" ><#=objRow.ExpiryDate#></td>   
                        <td class="GridViewLabItemStyle" id="tdStockID"  style="width:40px; display:none;" ><#=objRow.Stock_Id#></td>              
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <div id="divReject"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:550px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divReject" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Reject Request</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-5">
							   <label class="pull-left">Comp. Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div class="col-md-7">
                              <span id="spnComName"></span>
                              <span id="spnReqID" style="display:none;"></span>
						  </div>
						  <div class="col-md-5">
							   <label class="pull-left">Pending Qty   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-7" >
							   <span id="spnPenQty"></span>
						  </div>
                        
					</div>
                    <div class="row">
                        <div class="col-md-5">
							   <label class="pull-left">Reject Qty   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-7" >
							   <input type="text" id="txtRejectQty" style="border-bottom-color: red; border-bottom-width: 2px" onkeyup="CheckNumeric(this); " />
						  </div>
						 <div class="col-md-5">
							   <label class="pull-left"> Reason   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div class="col-md-7">
                              <input type="text" id="txtRejectReason" style="border-bottom-color: red; border-bottom-width: 2px" />
						  </div>
                        </div>
				</div>
			    <div class="modal-footer">
						 <button type="button"  onclick="$RejectRequest({RequestID:$('#spnReqID').text(),RejectQty:$('#txtRejectQty').val(),RejectResaon:$('#txtRejectReason').val()})">Reject</button>
						 <button type="button"  data-dismiss="divReject" >Close</button>
				</div>
            </div>
			</div>
		</div>
</asp:Content>