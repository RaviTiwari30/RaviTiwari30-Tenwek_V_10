<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="StatusBloodTransferToCentre.aspx.cs" Inherits="Design_BloodBank_StatusBloodTransferToCentre" %>

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
            <b>Centre Stock Transfer Status
            </b><br />
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
                            <select id="ddlCentre" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Centre"></select>
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
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:TextBox ID="fromDate" runat="server" ToolTip="Select From Date"  ClientIDMode="Static"   TabIndex="4" ></asp:TextBox>
                        <cc1:CalendarExtender ID="clcFromDate" runat="server" TargetControlID="fromDate" Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="ToDate" runat="server" ToolTip="Select To Date" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcToDate" runat="server" TargetControlID="ToDate" Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-8">
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
             <input type="button" id="btnSearch" value="Search" tabindex="4" class="ItDoseButton" onclick="SearchSentRequest(); SearchIssueRequest();" />
             </div>
     
       
       
        <div class="POuter_Box_Inventory" style="text-align: center; display:none;" id="divRequstStatus">
             <div class="Purchaseheader">
               Sent Request Status
            </div>
<%--            <div>
            <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #28b779" class="circle"></button>
            <b style="float: left; margin-top: 5px; margin-left: 5px">Issued</b>
            <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #ff6a00" class="circle"></button>
            <b style="float: left; margin-top: 5px; margin-left: 5px">Reject</b>
            <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #0063ff" class="circle"></button>
            <b style="float: left; margin-top: 5px; margin-left: 5px">Pending</b>
                </div>--%>
                  <div id="StockOutput" style="max-height: 200px; overflow-x: auto;">
                      
                  </div>
         </div>
        <div class="POuter_Box_Inventory" style="text-align: center; display:none;" id="divIssueRequest">
             <div class="Purchaseheader">
               Issued Request Status
            </div>
                  <div id="IssueRequestOutput" style="max-height: 200px; overflow-x: auto;">
                  </div>
         </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadCentre();
            LoadComponent();
            LoadBloodGroup();
        });
        function LoadCentre() {
            serverCall('StatusBloodTransferToCentre.aspx/LoadCentre', {}, function (response) {
                ddlCentre = $('#ddlCentre');
                ddlCentre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false });
            });
        }
        function LoadComponent() {
            serverCall('StatusBloodTransferToCentre.aspx/LoadComponent', {}, function (response) {
                ddlComponent = $('#ddlComponent');
                ddlComponent.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'ComponentName', isSearchAble: false });
            });
        }
        function LoadBloodGroup() {
            serverCall('StatusBloodTransferToCentre.aspx/LoadBloodGroup', {}, function (response) {
                ddlBloodGroup = $('#ddlBloodGroup');
                ddlBloodGroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });
            });
        }

    </script>
    <script type="text/javascript">
        function SearchSentRequest() {
            var CentreID = $('#ddlCentre option:selected').val();
            var Component = $('#ddlComponent option:selected').val();
            var BloodGroup = $('#ddlBloodGroup option:selected').html();
            var fromDate = $.trim($('#fromDate').val());
            var toDate = $.trim($('#ToDate').val());

            if (CentreID == "0") {
                modelAlert('Please Select Centre !!');
                return false;
            }
            $.ajax({
                url: "StatusBloodTransferToCentre.aspx/SearchSentRequest",
                data: '{CentreID:"' + CentreID + '",Component:"' + Component + '",BloodGroup:"' + BloodGroup + '",fromDate:"' + fromDate + '",toDate:"' + toDate + '"}',
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
                            $('#divRequstStatus').show();

                        }
                    }
                    else {
                        $('#StockOutput').html();
                        $('#StockOutput').hide();
                        $('#divRequstStatus').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#StockOutput').html();
                    $('#StockOutput').hide();
                    $('#divRequstStatus').hide();
                    modelAlert('Error');
                }
            });
        }
        function SearchIssueRequest() {
            var CentreID = $('#ddlCentre option:selected').val();
            var Component = $('#ddlComponent option:selected').val();
            var BloodGroup = $('#ddlBloodGroup option:selected').html();
            var fromDate = $.trim($('#fromDate').val());
            var toDate = $.trim($('#ToDate').val());

            if (CentreID == "0") {
                modelAlert('Please Select Centre !!');
                return false;
            }
            $.ajax({
                url: "StatusBloodTransferToCentre.aspx/SearchIssueRequest",
                data: '{CentreID:"' + CentreID + '",Component:"' + Component + '",BloodGroup:"' + BloodGroup + '",fromDate:"' + fromDate + '",toDate:"' + toDate + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        StockData = jQuery.parseJSON(result.d);
                        if (StockData != null) {
                            var output = $('#tb_IssueSearch').parseTemplate(StockData);
                            $('#IssueRequestOutput').html(output);
                            $('#IssueRequestOutput').show();
                            $('#divIssueRequest').show();

                        }
                    }
                    else {
                        $('#IssueRequestOutput').html();
                        $('#IssueRequestOutput').hide();
                        $('#divIssueRequest').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#IssueRequestOutput').html();
                    $('#IssueRequestOutput').hide();
                    $('#divIssueRequest').hide();
                    modelAlert('Error');
                }
            });
        }
        function SearchIssuedetail(rowID){
            var RequestID= $(rowID).closest('tr').find("#tdI_RequestID").text();
            var ToCentre = $(rowID).closest('tr').find("#tdI_ToCentre").text();
            var CompName = $(rowID).closest('tr').find("#tdI_ComponentName").text();

            $.ajax({
                url: "StatusBloodTransferToCentre.aspx/SearchIssuedetail",
                data: '{RequestID:"' + RequestID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        StockData = jQuery.parseJSON(result.d);
                        if (StockData != null) {
                            var output = $('#tb_IssueDetailSearch').parseTemplate(StockData);
                            $('#divIssueDetail #IssueDetailOutput').html(output);
                            $('#divIssueDetail #IssueDetailOutput').show();

                            $('#divIssueDetail #spnReqID').text(RequestID);
                            $('#divIssueDetail #spnToCentreName').text(ToCentre);
                            $('#divIssueDetail #spnCompName').text(CompName);
                            $('#divIssueDetail').showModel();

                        }
                    }
                    else {
                        $('#divIssueDetail #IssueDetailOutput').html();
                        $('#divIssueDetail #IssueDetailOutput').hide();
                        $('#divIssueDetail').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#divIssueDetail #IssueDetailOutput').html();
                    $('#divIssueDetail #IssueDetailOutput').hide();
                    $('#divIssueDetail').hide();
                    modelAlert('Error');
                }
            });

           
        }
        function SearchSentRequestdetail(rowID) {
            var RequestID = $(rowID).closest('tr').find("#tdRequestID").text();
            var FromCentre = $(rowID).closest('tr').find("#tdToCentre").text();
            var CompName = $(rowID).closest('tr').find("#tdComponentName").text();

            $.ajax({
                url: "StatusBloodTransferToCentre.aspx/SearchSentRequestdetail",
                data: '{RequestID:"' + RequestID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        StockData = jQuery.parseJSON(result.d);
                        if (StockData != null) {
                            var output = $('#tb_SentDetailSearch').parseTemplate(StockData);
                            $('#divSentRequestDetail #SentDetailOutput').html(output);
                            $('#divSentRequestDetail #SentDetailOutput').show();

                            $('#divSentRequestDetail #spnRRequestID').text(RequestID);
                            $('#divSentRequestDetail #spnFromCentre').text(FromCentre);
                            $('#divSentRequestDetail #spnr_CompName').text(CompName);
                            $('#divSentRequestDetail').showModel();

                        }
                    }
                    else {
                        $('#divSentRequestDetail #SentDetailOutput').html();
                        $('#divSentRequestDetail #SentDetailOutput').hide();
                        $('#divSentRequestDetail').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#divSentRequestDetail #SentDetailOutput').html();
                    $('#divSentRequestDetail #SentDetailOutput').hide();
                    $('#divSentRequestDetail').hide();
                    modelAlert('Error');
                }
            });


        }
    </script>
    <script id="tb_StockSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_Stockdata" style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">From Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">To Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Component</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Blood Group</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Request Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Request Reason</th>        
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Req. Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Issue Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Reject Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Pending Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Detail</th>
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
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td class="GridViewLabItemStyle" id="tdRequestID"  style="width:40px; display:none" ><#=objRow.RequestID#></td>   
                        <td class="GridViewLabItemStyle" id="tdFromCentre"  style="width:80px;" ><#=objRow.FromCentre#></td>   
                        <td class="GridViewLabItemStyle" id="tdToCentre"  style="width:80px;" ><#=objRow.ToCentre#></td>   
                        <td class="GridViewLabItemStyle" id="tdComponentName"  style="width:80px;" ><#=objRow.ComponentName#></td>
                        <td class="GridViewLabItemStyle" id="tdBloodGroup"  style="width:40px;" ><#=objRow.BloodGroup#></td>
                        <td class="GridViewLabItemStyle" id="tdRequestDate"  style="width:40px;" ><#=objRow.RequestDate#></td>
                        <td class="GridViewLabItemStyle" id="tdReason"  style="width:100px;"><#=objRow.EntryReason#></td> 
                        <td class="GridViewLabItemStyle" id="td4"  style="width:40px;"><#=objRow.Quantity#></td>  
                        <td class="GridViewLabItemStyle" id="td2"  style="width:40px;"><#=objRow.IssueQuantity#></td>  
                        <td class="GridViewLabItemStyle" id="td1"  style="width:40px;"><#=objRow.RejectQty#></td>  
                        <td class="GridViewLabItemStyle" id="tdStatus"  style="width:40px;"><#=objRow.PendingQty#></td>   
                        <td class="GridViewLabItemStyle" id="td3"  style="width:40px;"><#=objRow.STATUS#></td>
                        <td class="GridViewLabItemStyle" id="td5"  style="width:20px;"><img id="imgProcess" src="../../Images/view.gif" onclick="SearchSentRequestdetail(this);" title="Click To View Detail" /></td>                     
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <script id="tb_IssueSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_IssueData" style="width:100%;border-collapse:collapse;">
		<tr id="IHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">From Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">To Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Component</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Blood Group</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Request Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Request Reason</th>        
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Req. Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Issue Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Reject Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Pending Qty</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Detail</th>
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
                    <tr id="Tr2">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td class="GridViewLabItemStyle" id="tdI_RequestID"  style="width:40px; display:none" ><#=objRow.RequestID#></td>   
                        <td class="GridViewLabItemStyle" id="tdI_FromCentre"  style="width:80px;" ><#=objRow.FromCentre#></td>   
                        <td class="GridViewLabItemStyle" id="tdI_ToCentre"  style="width:80px;" ><#=objRow.ToCentre#></td>   
                        <td class="GridViewLabItemStyle" id="tdI_ComponentName"  style="width:80px;" ><#=objRow.ComponentName#></td>
                        <td class="GridViewLabItemStyle" id="tdI_BloodGroup"  style="width:40px;" ><#=objRow.BloodGroup#></td>
                        <td class="GridViewLabItemStyle" id="tdI_RequestDate"  style="width:40px;" ><#=objRow.RequestDate#></td>
                        <td class="GridViewLabItemStyle" id="tdI_EntryReason"  style="width:100px;"><#=objRow.EntryReason#></td> 
                        <td class="GridViewLabItemStyle" id="tdI_Quantity"  style="width:40px;"><#=objRow.Quantity#></td>  
                        <td class="GridViewLabItemStyle" id="tdI_IssueQuantity"  style="width:40px;"><#=objRow.IssueQuantity#></td>  
                        <td class="GridViewLabItemStyle" id="tdI_RejectQty"  style="width:40px;"><#=objRow.RejectQty#></td>  
                        <td class="GridViewLabItemStyle" id="tdI_PendingQty"  style="width:40px;"><#=objRow.PendingQty#></td>   
                        <td class="GridViewLabItemStyle" id="tdI_STATUS"  style="width:40px;"><#=objRow.STATUS#></td>
                        <td class="GridViewLabItemStyle" id="tdI_View"  style="width:20px;"><img id="imgViewIDetail" src="../../Images/view.gif" onclick="SearchIssuedetail(this);" title="Click To View Detail" /></td>                     
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <script id="tb_IssueDetailSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_IssueDetaildata" style="width:100%;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Req. Blood Group</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Issue Blood Group</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">StockID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Bag Number</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">ExpiryDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IssueDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IssueBy</th>
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
                    <tr id="Tr3">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td class="GridViewLabItemStyle" id="td6"  style="width:40px; display:none" ><#=objRow.RequestID#></td>   
                        <td class="GridViewLabItemStyle" id="td7"  style="width:80px;" ><#=objRow.RequestBG#></td> 
                          <td class="GridViewLabItemStyle" id="td8"  style="width:80px;" ><#=objRow.IssueBG#></td> 
                          <td class="GridViewLabItemStyle" id="td9"  style="width:80px; display:none;" ><#=objRow.Stock_Id#></td> 
                          <td class="GridViewLabItemStyle" id="td10"  style="width:80px;" ><#=objRow.BBTubeNo#></td> 
                          <td class="GridViewLabItemStyle" id="td11"  style="width:80px;" ><#=objRow.ExpiryDate#></td>   
                        <td class="GridViewLabItemStyle" id="td12"  style="width:80px;" ><#=objRow.IssueDate#></td>   
                        <td class="GridViewLabItemStyle" id="td13"  style="width:80px;" ><#=objRow.IssueBy#></td>   
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <script id="tb_SentDetailSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_entData" style="width:100%;border-collapse:collapse;">
		<tr id="Tr4">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Req. Blood Group</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Issue Blood Group</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">StockID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Bag Number</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">ExpiryDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IssueDate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IssueBy</th>
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
                    <tr id="Tr5">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td class="GridViewLabItemStyle" id="td14"  style="width:40px; display:none" ><#=objRow.RequestID#></td>   
                        <td class="GridViewLabItemStyle" id="td15"  style="width:80px;" ><#=objRow.RequestBG#></td> 
                          <td class="GridViewLabItemStyle" id="td16"  style="width:80px;" ><#=objRow.IssueBG#></td> 
                          <td class="GridViewLabItemStyle" id="td17"  style="width:80px; display:none;" ><#=objRow.Stock_Id#></td> 
                          <td class="GridViewLabItemStyle" id="td18"  style="width:80px;" ><#=objRow.BBTubeNo#></td> 
                          <td class="GridViewLabItemStyle" id="td19"  style="width:80px;" ><#=objRow.ExpiryDate#></td>   
                        <td class="GridViewLabItemStyle" id="td20"  style="width:80px;" ><#=objRow.IssueDate#></td>   
                        <td class="GridViewLabItemStyle" id="td21"  style="width:80px;" ><#=objRow.IssueBy#></td>   
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <div id="divIssueDetail"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:700px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divIssueDetail" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Issued Request Detail</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-5">
							   <label class="pull-left">To Centre   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-7" >
							  <span id="spnToCentreName"></span>
                             <span id="spnReqID" style="display:none"></span>  
						  </div>
						 <div class="col-md-5">
							   <label class="pull-left"> Component   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div class="col-md-7">
                              <span id="spnCompName"></span>
						  </div>
					</div>
                    <div class="row">
                         <div id="IssueDetailOutput" style="max-height: 200px; overflow-x: auto;">
                  </div>
                        </div>
				</div>
			    <div class="modal-footer">
						 <button type="button"  data-dismiss="divIssueDetail" >Close</button>
				</div>
            </div>
			</div>
		</div>
    <div id="divSentRequestDetail"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:700px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divSentRequestDetail" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Sent Request Detail</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-5">
							   <label class="pull-left">From Centre   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-7" >
							  <span id="spnFromCentre"></span>
                             <span id="spnRRequestID" style="display:none"></span>  
						  </div>
						 <div class="col-md-5">
							   <label class="pull-left"> Component   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div class="col-md-7">
                              <span id="spnr_CompName"></span>
						  </div>
					</div>
                    <div class="row">
                         <div id="SentDetailOutput" style="max-height: 200px; overflow-x: auto;">
                  </div>
                        </div>
				</div>
			    <div class="modal-footer">
						 <button type="button"  data-dismiss="divSentRequestDetail" >Close</button>
				</div>
            </div>
			</div>
		</div>
</asp:Content>