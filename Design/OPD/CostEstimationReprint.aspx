<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CostEstimationReprint.aspx.cs" Inherits="Design_OPD_CostEstimationReprint" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory textCenter">
            <b>CostEstimation Re-Print</b>

        </div>

        <div class="POuter_Box_Inventory textCenter">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="col-md-3">
                        <label class="pull-left">
                            UHID 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtUHID" />
                    </div>

                    <div class="col-md-3">
                        <label class="pull-left">
                            From Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox runat="server" ID="txtFromDate" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>


                    <div class="col-md-3">
                        <label class="pull-left">
                            To Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox runat="server" ID="txtToDate" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Estimation ID 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtCostEstimationID" />
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter">
            <input type="button" value="Search" onclick="searchCostEstimation(this)" class="save margin-top-on-btn" />
        </div>
        <div class="POuter_Box_Inventory textCenter">
            <div class="row">
                <div id="divCostEstimationSearchDetails" class="col-md-24">
                </div>
            </div>

        </div>


    </div>


    <script type="text/javascript">
        $(function () {
            $('input').keyup(function () {
                if (event.keyCode == 13)
                    if ($(this).val() != "")
                        searchCostEstimation(this);
            })
        })
        var searchCostEstimation = function () {

            var data = {
                patientID: $.trim($('#txtUHID').val()),
                fromDate: $.trim($('#txtFromDate').val()),
                toDate: $.trim($('#txtToDate').val()),
                costEstimationID: $.trim($('#txtCostEstimationID').val()),
            }


            serverCall('CostEstimationReprint.aspx/SearchCostEstimation', data, function (response) {
                responseData = JSON.parse(response);
                var parseHTML = $('#template_costEstimation').parseTemplate(responseData);
                $('#divCostEstimationSearchDetails').html(parseHTML);
            });


        }


        var onCostEstimationSelect = function (el) {
            var data = JSON.parse($(el).closest('tr').find('#tdData').text());
            var url = '../common/CostEstimationBill.aspx?CostEstimateNo=' + data.id;
            window.open(url);
        }



    </script>


   

    <script id="template_costEstimation" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblCostEstimation" style="width:100%;border-collapse:collapse;">
		<#if(responseData.length>0){#>

		<thead>
						   <tr  id='Header'>

								<th class='GridViewHeaderStyle'>#</th>
								<th class='GridViewHeaderStyle'>UHID</th>
								<th class='GridViewHeaderStyle'>Patient Name</th>
								<th class='GridViewHeaderStyle'>Estimated Amount</th>
								<th class='GridViewHeaderStyle'>Contact No.</th>
                                <th class='GridViewHeaderStyle'>Address</th>
						   </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=responseData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{

		objRow = responseData[j];
		
		  #>
						<tr style="cursor:pointer" onclick="onCostEstimationSelect(this)">
						<td  class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
						<td  id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=JSON.stringify(objRow)#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center"><#=objRow.PatientID#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center"><#=objRow.PatientName#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center"><#=objRow.TotalEstimate#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center"><#=objRow.ContactNo#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Address#></td>             
						</tr>   

			<#}#>
</tbody>
	 </table>    
	</script>



</asp:Content>

