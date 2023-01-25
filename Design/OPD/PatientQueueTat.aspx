<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientQueueTat.aspx.cs" Inherits="Design_OPD_PatientQueueTat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
  
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">

        $(document).ready(function () {
            $("#<%=ddlDept.ClientID %>").chosen();
         });

        function createTable() {
            var data = { clinic: $('#<%=ddlDept.ClientID %>').val() }
            serverCall('PatientQueueTat.aspx/FillTable', data, function (response) {
                cpoe = JSON.parse(response);
                var output = $('#tb_SearchCpoe').parseTemplate(cpoe);
                $('#CpoeOutput').html(output);
                $('#CpoeOutput,#myTable').show();
            });
        }   

    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="toolScriptManageer1" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Manage Patient Queue</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="content">
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Clinic
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlDept" runat="server"  onchange="createTable();" ClientIDMode="Static"></asp:DropDownList>
                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24">
                    <div id="CpoeOutput" style="max-height: 400px; overflow-x: auto;">
                    </div>
                    <div id="divPatients" runat="server">
                    </div>
                </div>
            </div>
        </div>
    </div>
        
   <script id="tb_SearchCpoe" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOPD"
	style="width:100%;border-collapse:collapse;">
		<tr>
                     <th class="GridViewHeaderStyle" >S.No</th>
                     <th class="GridViewHeaderStyle" >Encounter No</th>
                     <th class="GridViewHeaderStyle" >Patient Name</th>
                     <th class="GridViewHeaderStyle" >Payment Type</th>
                     <th class="GridViewHeaderStyle" >Waiting Location</th>
                     <th class="GridViewHeaderStyle" >Lab Status</th>
                     <th class="GridViewHeaderStyle" >Waiting Time</th>
                     <th class="GridViewHeaderStyle" >Status</th>
                     <th class="GridViewHeaderStyle" >Triage</th>
                     <th class="GridViewHeaderStyle" >Doc/Recon</th>
                     <th class="GridViewHeaderStyle" >Lab</th>
                     <th class="GridViewHeaderStyle" >Pharm</th>
                     <th class="GridViewHeaderStyle" >Una</th>
                 </tr>

		<#       
		var dataLength=cpoe.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{       
		objRow = cpoe[j];
		#>
					<tr id="<#=j+1#>"  >   
						 
					<td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
					<td class="GridViewLabItemStyle" ><#=objRow.EncounterNo#></td>
					<td class="GridViewLabItemStyle " style="text-align:left;"><#=objRow.Pname#></td>
					<td class="GridViewLabItemStyle " style="width:200px;"><#=objRow.PanelName#></td>
					<td class="GridViewLabItemStyle "><#=objRow.WaitingLocation#></td>
					<td class="GridViewLabItemStyle "><#=objRow.LabStatus#></td>
					<td class="GridViewLabItemStyle "><#=objRow.WaitingTime#></td>
					<td class="GridViewLabItemStyle "><#=objRow.Status#></td>
					<td class="GridViewLabItemStyle "> 
                        <#if(objRow.Triage =="0" ){#>
                        <input type="radio" name='status<#=objRow.EncounterNo#>' checked  />
                        <#}
						else
						{#>    
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'   />
                        <#}#>
					</td>
					<td class="GridViewLabItemStyle ">
                         <#if(objRow.Doc_Recon =="1" ){#>
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'  checked  />
                        <#}
						else
						{#>    
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'   />
                        <#}#>
					</td>

					<td class="GridViewLabItemStyle ">
                        <#if(objRow.Lab =="1" ){#>
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'  checked   />
                        <#}
						else
						{#>    
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'   />
                        <#}#>

					</td>
					<td class="GridViewLabItemStyle "> 
                        <#if(objRow.Pharm =="1"   ){#>
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'  checked  />
                        <#}
						else
						{#>    
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'   />
                        <#}#>

					</td>
					<td class="GridViewLabItemStyle "> 
                         <#if(objRow.Una =="1"   ){#>
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'  checked  />
                        <#}
						else
						{#>    
                        <input type="radio"  name='status<#=objRow.EncounterNo#>'   />
                        <#}#>

					</td>
					</tr>           
		<#}       
		#>       
	 </table>    
	</script>
</asp:Content>