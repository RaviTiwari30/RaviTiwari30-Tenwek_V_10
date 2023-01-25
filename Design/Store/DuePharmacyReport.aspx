<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DuePharmacyReport.aspx.cs" Inherits="Design_Store_DuePharmacyReport" MasterPageFile="~/DefaultHome.master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
 
  <script type="text/javascript">
      $(document).ready(function () {
          getData();
      });
      function getData() {
          var data = {
              MRNo: '',
              panelID: '',
              fromDate: $('#txtSearchFromDate').val(),
              toDate: $('#txtSearchToDate').val(),
              centreId: '1',
              billNo:''
          }
          if ($('#txtSearchFromDate').val() != "" && $('#txtSearchToDate').val() != "") {
              serverCall('DuePharmacyReport.aspx/SearchOPDBills', data, function (response) {
                  if (!String.isNullOrEmpty(response)) {
                      billsDetails = JSON.parse(response);
                      var output = $('#templateBillsSearchDetails').parseTemplate(billsDetails);
                      $('#divBillDetailsDetails').html(output).customFixedHeader();
                  }
                  
              });
          }
      }
  </script>

    
  

    
        
	<cc1:ToolkitScriptManager runat="server" ID="scriptManager"></cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Due Pharmacy Bill Report</b><br />
            </div>
              <div class="content">
                            



                        </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">
                        Department
                        </div>
                    <div class="col-md-6"> 
                            <asp:DropDownList ID="ddlDept" runat="server" TabIndex="2" AutoPostBack="true" OnSelectedIndexChanged="ddlDept_SelectedIndexChanged" disabled="disabled"
                                ToolTip="Select Department">
                            </asp:DropDownList>
                        </div>
                	<div class="col-md-3">
							<label class="pull-left">From Date  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-4">
								<asp:TextBox ID="txtSearchFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select From Date" ></asp:TextBox>
							<cc1:CalendarExtender ID="calExdTxtSearchFromDate" TargetControlID="txtSearchFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">To Date </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-4">
							  <asp:TextBox ID="txtSearchToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select From Date" ></asp:TextBox>
							  <cc1:CalendarExtender ID="calExdSearchToDate" TargetControlID="txtSearchToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
                    </div>
                </div>
                
                          <div class="POuter_Box_Inventory" style="text-align: center;">
                      <div class="row">
                    <div class="col-md-6">
                       
                        </div>
                    <div style="text-align:center" class="col-md-6">
							 <input type="button" onclick="getData();" value="Search" />                        
						</div>
                             <div class="col-md-6"> 
            &nbsp; &nbsp;<asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="5"
                Text="Report" OnClick="btnSearch_Click" />
        </div>
                              <div class="col-md-6"> 
                    </div>
					
						
                </div>
                              </div>
                <script id="templateBillsSearchDetails" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdOPDBillsSettlement" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Centre Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill No.</th>
            <th class="GridViewHeaderStyle" scope="col" >PanelName</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" >UHID</th>
			<th class="GridViewHeaderStyle" scope="col" >Bill Amount</th>
			<th class="GridViewHeaderStyle" scope="col" >Balance Amount</th>  
		</tr>
			</thead>
		<#
		var dataLength=billsDetails.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
	
		for(var j=0;j<dataLength;j++)
		{
		objRow = billsDetails[j];
		#>
					<tr  data='<#= JSON.stringify(objRow) #>' <#if(objRow.TypeOfTnx=="Emergency"){#> style="cursor:pointer;background-color:#a179ef;"<#} else{#>style="cursor:pointer;"<#}#>  id='<#=objRow.LedgerTransactionNo#>'>
					<td class="GridViewLabItemStyle" id="tdSNo"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdCentreName"  style="text-align:left" ><#=objRow.centreName#></td>
					<td class="GridViewLabItemStyle" id="tdBillDate"  style="text-align:center" ><#=objRow.BillDate#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdBillNo" ><#=objRow.BillNo#>
						<%--<img src="../../Images/view.GIF" alt="" id="img1" style="cursor:pointer" onclick="$viewBillDetails(this)" title="Click To Select" />--%>
					</td>
                        <td class="GridViewLabItemStyle" id="td1" ><#=objRow.Company_Name#></td>
					<td class="GridViewLabItemStyle" id="tdPatientName" ><#=objRow.PName#></td>
					<td class="GridViewLabItemStyle  textCeneter" id="tdPatientID" ><#=objRow.PatientID#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdNetAmount" ><#=objRow.NetAmount#></td>
			
					<td class="GridViewLabItemStyle textCeneter" id="tdPendingAmt" ><#=objRow.BalanceAmt#></td>  
                    </tr>
		<#}
		#>     
	 </table>
	</script>
            
            	<div class="POuter_Box_Inventory ">
			<div class="row">
				<div  style="overflow:auto;max-height:410px" id="divBillDetailsDetails" class="col-md-24">

				</div>
			</div>
		</div>
            

</asp:Content>