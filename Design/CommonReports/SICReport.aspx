<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SICReport.aspx.cs"
    Inherits="Design_CommonReports_SICReport" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript">

          $(document).ready(function () {
              $bindCentre();
          });
          var $bindCentre = function () {
              serverCall('SICReport.aspx/BindCentre', {}, function (response) {
                  Centre = $('#ddlCentre');
                  var DefaultCentre = '<%=Session["CentreID"].ToString() %>';
                  Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false, selectedValue: DefaultCentre });
              });
          }
        var $bindSICReport = function () {
            $("#lblMsg").text('');
            $('#dvHISvsFinanceData').html('');
            if ($("#ddlCentre").val() == "0")
            {
                $("#lblMsg").text('Please Select Centre');
                return false;
            }
              data = {
                  centreID: Number($("#ddlCentre").val()),
                  fromDate: $("#txtFromDate").val(),
                  toDate: $("#txtToDate").val(),
                  type: Number($("#ddlType").val())
              }
              serverCall('SICReport.aspx/generateSICReport', data, function (response) {
                  if (!String.isNullOrEmpty(response)) {
                      hisDetails = JSON.parse(response);
                      if (hisDetails.length > 0) {
                          var output = $('#templateHISDetails').parseTemplate(hisDetails);
                          $('#dvHISvsFinanceData').html(output).customFixedHeader();
                      }
                  }
                  else {
                      modelAlert('No Record Found', function () { });
                  }
              });
          }


  var getExcelReports = function () {
              data = {
                  centreID: Number($('#ddlCentre').val()),
                  fromDate: $('#txtFromDate').val(),
                  toDate: $('#txtToDate').val(),
                  type: Number($('#ddlType').val())
              }
              serverCall('SICReport.aspx/GetExcelReports', data, function (response) {

                  var responseData = JSON.parse(response);

                  if (responseData.status)
                      window.open(responseData.URL, "_blank");
                  else
                      modelAlert(responseData.message);

              });
          }

      </script>
    <cc1:ToolkitScriptManager ID="scManager" runat="server"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>SIC Report
            </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                         <div class="col-md-2">
                            <label class="pull-left">Centre </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ddlCentre" title="Select Centre"></select>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtFromDate" ClientIDMode="Static" runat="server" Width="150px"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-2">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtToDate" ClientIDMode="Static" runat="server" Width="150px"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                       
                        <div class="col-md-2">
                            <label class="pull-left">Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ddlType" title="Select Type">
                                 <option value="1">Revenue</option>
                                 <option value="2">Collection</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <input type="button" class="ItDoseButton" id="btnPreview" value="Search" onclick="$bindSICReport()" />
<input type="button" class="ItDoseButton" id="btnGetExcel" value="Get Excel" onclick="getExcelReports(this)" />
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24"   >
                    <div id="dvHISvsFinanceData" style=" max-width:195%;max-height:450px;overflow:auto">
                    </div>
                </div>
            </div>
        </div>

    </div>


    <%-- DocumentDate,BillNo,PatientID,IPID,TYPE,ServiceName, DocCurrency, BaseCurrency,DocumentAmt,BaseAmt,UserName--%>
   
	<script id="templateHISDetails" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tableHISDetail" style="border-collapse:collapse;">
	 <thead>
        <tr>
	       <th class="GridViewHeaderStyle" scope="col" colspan="12" style="text-align:center;">HIS MODUULE</th>
           <th class="GridViewHeaderStyle" scope="col" style="width:1px;background-color:black;" ></th>
           <th class="GridViewHeaderStyle" scope="col" colspan="12"  style="text-align:center; background-color:green;">FINANCE MODULE</th>
        </tr>
	    <tr>
           
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Document Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill No.</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
			<th class="GridViewHeaderStyle" scope="col" >IPID</th> 
            <th class="GridViewHeaderStyle" scope="col" >Type</th>          
			<th class="GridViewHeaderStyle" scope="col" >Service Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Doc Currency</th>
			<th class="GridViewHeaderStyle" scope="col" >Base Currency</th>
			<th class="GridViewHeaderStyle" scope="col" >Document Amt</th>
			<th class="GridViewHeaderStyle" scope="col" >Base Amt</th>
			<th class="GridViewHeaderStyle" scope="col" >User Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:1px;background-color:black;" ></th>
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green" >Document Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green" >Finance Doc. Reference</th>
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green;width:200px" >Narration</th>
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green" >DR/CR</th> 
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green" >Doc Currency</th>
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green" >Base Currency</th>
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green" >Document Amt</th>
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green" >Base Amt</th>
            <th class="GridViewHeaderStyle" scope="col" style="background-color:green" >COA</th> 
			<th class="GridViewHeaderStyle" scope="col" style="background-color:green" >Cost Centre</th>


		</tr>
			</thead>
             <tbody>
		<#
		var dataLength=hisDetails.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
	
		for(var j=0;j<dataLength;j++)
		{
		objRow = hisDetails[j];
		#>
					<tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" <#if(objRow.HBaseAmt==objRow.FBaseAmt){#>style="cursor:pointer;"<#} else{#>style="cursor:pointer;background-color:#FFB6C1;"<#}#> >
					<td class="GridViewLabItemStyle" id="tdHSNo" style="text-align:center"><#=j+1#></td>
					<td class="GridViewLabItemStyle" id="tdHDocumentDate"  style="text-align:center; width:150px;" ><#=objRow.HDocumentDate#></td>
                    <td class="GridViewLabItemStyle" id="tdHBillNo"  style="text-align:center; width:200px;" ><#=objRow.HBillNo#></td>
					<td class="GridViewLabItemStyle" id="tdHPatientID"  style="text-align:center; width:100px;" ><#=objRow.HPatientID#></td>
					<td class="GridViewLabItemStyle" id="tdHIPID" style="text-align:center;" ><#=objRow.HIPID#></td> 
                    <td class="GridViewLabItemStyle" id="tdHTYPE" style="text-align:center;"><#=objRow.HTYPE#></td>      
					<td class="GridViewLabItemStyle" id="tdHServiceName"><#=objRow.HServiceName#></td>
                    <td class="GridViewLabItemStyle" id="tdHDocCurrency"  style="text-align:center;" ><#=objRow.HDocCurrency#></td>
					<td class="GridViewLabItemStyle" id="tdHBaseCurrency" style="text-align:center;" ><#=objRow.HBaseCurrency#></td> 
                    <td class="GridViewLabItemStyle" id="tdHDocumentAmt" ><#=objRow.HDocumentAmt#></td>      
					<td class="GridViewLabItemStyle" id="tdHBaseAmt"><#=objRow.HBaseAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdHUserName"><#=objRow.HUserName#></td>
                    <td class="GridViewLabItemStyle" id="tdspace" style="width:1px;background-color:black;">  </td>
					<td class="GridViewLabItemStyle" id="tdFDocumentDate" style="text-align:center; width:150px;" ><#=objRow.FDocumentDate#></td>
                    <td class="GridViewLabItemStyle" id="tdFFinance_document_reference" style="text-align:center; width:200px;" ><#=objRow.Finance_document_reference#></td>
					<td class="GridViewLabItemStyle" id="tdFNARRATION" style="text-align:center;" ><#=objRow.NARRATION#></td>
					<td class="GridViewLabItemStyle" id="tdFDR_CR" style="text-align:center;" ><#=objRow.DR_CR#></td> 
                    <td class="GridViewLabItemStyle" id="tdFDocCurrency" style="text-align:center;" ><#=objRow.FDocCurrency#></td>
					<td class="GridViewLabItemStyle" id="tdFBaseCurrency" style="text-align:center;" ><#=objRow.FBaseCurrency#></td> 
                    <td class="GridViewLabItemStyle" id="tdFDocumentAmt" ><#=objRow.FDocumentAmt#></td>      
					<td class="GridViewLabItemStyle" id="tdFBaseAmt"><#=objRow.FBaseAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdFCOA"><#=objRow.FServiceName#></td>
                    <td class="GridViewLabItemStyle" id="tdFCOST_CENTER"><#=objRow.COST_CENTER#></td>
					</tr>
		<#}
		#>    
      </tbody> 
	 </table>
	</script>
</asp:Content>
